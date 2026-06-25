import { notFound } from 'next/navigation';

import { Header } from '@/app/_components/Header';
import { SousFichePeriodes } from '@/app/_components/SousFichePeriodes';
import { nomComplet } from '@/lib/format';
import { supabaseAdmin } from '@/lib/supabase';
import { FormEnfant } from '../FormEnfant';
import {
  ajouterBesoin,
  ajouterIncompatibilite,
  ajouterPreference,
  ajouterSolution,
  supprimerBesoin,
  supprimerIncompatibilite,
  supprimerPreference,
  supprimerSolution,
} from './actions';
import {
  IncompatibilitesEnfant,
  PreferencesEnfant,
  SolutionsEnfant,
} from './SousFiches';

export const dynamic = 'force-dynamic';

export default async function ModifierEnfant({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const idNum = Number(id);
  const db = supabaseAdmin();
  const [enf, acc, fra, bes, tousEnf, inc, pref, sol] = await Promise.all([
    db.from('escale_enfants').select('*').eq('id', idNum).maybeSingle(),
    db.from('escale_accueillants').select('id, nom, prenom').order('nom'),
    db.from('escale_fratries').select('id, nom').order('nom'),
    db.from('escale_besoins_relais').select('*').eq('enfant_id', idNum).order('debut'),
    db.from('escale_enfants').select('id, nom, prenom').order('nom'),
    db
      .from('escale_incompatibilites')
      .select('*')
      .or(`enfant_a_id.eq.${idNum},enfant_b_id.eq.${idNum}`),
    db.from('escale_preferences_accueil').select('*').eq('enfant_id', idNum),
    db.from('escale_solutions_alternatives').select('*').eq('enfant_id', idNum).order('debut'),
  ]);
  if (enf.error) throw new Error(enf.error.message);
  if (!enf.data) notFound();

  const accueillants = (acc.data ?? []).map((a) => ({ id: a.id, nom: nomComplet(a) }));
  const accById = new Map(accueillants.map((a) => [a.id, a.nom]));
  const enfById = new Map(
    (tousEnf.data ?? []).map((e) => [e.id, nomComplet(e)]),
  );

  const liens = (inc.data ?? []).map((r) => {
    const autreId = r.enfant_a_id === idNum ? r.enfant_b_id : r.enfant_a_id;
    return { id: r.id, autreNom: enfById.get(autreId) ?? `#${autreId}` };
  });
  const dejaIncompat = new Set(
    (inc.data ?? []).map((r) => (r.enfant_a_id === idNum ? r.enfant_b_id : r.enfant_a_id)),
  );
  const autresEnfants = (tousEnf.data ?? [])
    .filter((e) => e.id !== idNum && !dejaIncompat.has(e.id))
    .map((e) => ({ id: e.id, nom: nomComplet(e) }));

  const prefs = (pref.data ?? []).map((p) => ({
    id: p.id,
    accueillantNom: accById.get(p.accueillant_id) ?? `#${p.accueillant_id}`,
    type: p.type,
  }));

  return (
    <>
      <Header actif="/enfants" />
      <div className="contenu">
        <h1>Modifier l&apos;enfant</h1>
        <FormEnfant e={enf.data} accueillants={acc.data ?? []} fratries={fra.data ?? []} />

        <SousFichePeriodes
          titre="Besoins de relais"
          description="Périodes pendant lesquelles l'enfant doit être accueilli."
          items={bes.data ?? []}
          ajouter={ajouterBesoin}
          supprimer={supprimerBesoin}
          parentName="enfantId"
          parentId={idNum}
          avecMotif
          motifLabel="Motif"
        />

        <IncompatibilitesEnfant
          enfantId={idNum}
          liens={liens}
          autresEnfants={autresEnfants}
          ajouter={ajouterIncompatibilite}
          supprimer={supprimerIncompatibilite}
        />

        <PreferencesEnfant
          enfantId={idNum}
          prefs={prefs}
          accueillants={accueillants}
          ajouter={ajouterPreference}
          supprimer={supprimerPreference}
        />

        <SolutionsEnfant
          enfantId={idNum}
          items={sol.data ?? []}
          ajouter={ajouterSolution}
          supprimer={supprimerSolution}
        />
      </div>
    </>
  );
}

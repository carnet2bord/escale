import { notFound } from 'next/navigation';

import { Header } from '@/app/_components/Header';
import { SousFichePeriodes } from '@/app/_components/SousFichePeriodes';
import { supabaseAdmin } from '@/lib/supabase';
import { FormEnfant } from '../FormEnfant';
import { ajouterBesoin, supprimerBesoin } from './actions';

export const dynamic = 'force-dynamic';

export default async function ModifierEnfant({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const idNum = Number(id);
  const db = supabaseAdmin();
  const [enf, acc, fra, bes] = await Promise.all([
    db.from('enfants').select('*').eq('id', idNum).maybeSingle(),
    db.from('accueillants').select('id, nom, prenom').order('nom'),
    db.from('fratries').select('id, nom').order('nom'),
    db.from('besoins_relais').select('*').eq('enfant_id', idNum).order('debut'),
  ]);
  if (enf.error) throw new Error(enf.error.message);
  if (!enf.data) notFound();

  return (
    <>
      <Header actif="/enfants" />
      <div className="contenu">
        <h1>Modifier l&apos;enfant</h1>
        <FormEnfant e={enf.data} accueillants={acc.data ?? []} fratries={fra.data ?? []} />

        <SousFichePeriodes
          titre="Besoins de relais"
          description="Périodes pendant lesquelles cet enfant a besoin d'un accueil relais."
          items={bes.data ?? []}
          ajouter={ajouterBesoin}
          supprimer={supprimerBesoin}
          parentName="enfantId"
          parentId={idNum}
          avecMotif
          motifLabel="Motif"
        />
      </div>
    </>
  );
}

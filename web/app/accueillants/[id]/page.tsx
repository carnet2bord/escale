import { notFound } from 'next/navigation';

import { Header } from '@/app/_components/Header';
import { SousFichePeriodes } from '@/app/_components/SousFichePeriodes';
import { supabaseAdmin } from '@/lib/supabase';
import { FormAccueillant } from '../FormAccueillant';
import {
  ajouterDispo,
  ajouterIndispo,
  supprimerDispo,
  supprimerIndispo,
} from './actions';

export const dynamic = 'force-dynamic';

export default async function ModifierAccueillant({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const idNum = Number(id);
  const db = supabaseAdmin();
  const [acc, dis, ind] = await Promise.all([
    db.from('escale_accueillants').select('*').eq('id', idNum).maybeSingle(),
    db.from('escale_disponibilites_accueil').select('*').eq('accueillant_id', idNum).order('debut'),
    db.from('escale_indisponibilites').select('*').eq('accueillant_id', idNum).order('debut'),
  ]);
  if (acc.error) throw new Error(acc.error.message);
  if (!acc.data) notFound();

  return (
    <>
      <Header actif="/accueillants" />
      <div className="contenu">
        <h1>Modifier l&apos;accueillant</h1>
        <FormAccueillant a={acc.data} />

        <SousFichePeriodes
          titre="Périodes où il/elle peut accueillir"
          description="Si vide, l'accueillant est considéré disponible sauf pendant ses vacances."
          items={dis.data ?? []}
          ajouter={ajouterDispo}
          supprimer={supprimerDispo}
          parentName="accueillantId"
          parentId={idNum}
        />

        <SousFichePeriodes
          titre="Vacances / indisponibilités"
          description="L'accueillant ne peut recevoir personne sur ces périodes."
          items={ind.data ?? []}
          ajouter={ajouterIndispo}
          supprimer={supprimerIndispo}
          parentName="accueillantId"
          parentId={idNum}
          avecMotif
          motifLabel="Motif"
        />
      </div>
    </>
  );
}

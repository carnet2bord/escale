import { notFound } from 'next/navigation';

import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';
import { FormEnfant } from '../FormEnfant';

export const dynamic = 'force-dynamic';

export default async function ModifierEnfant({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const db = supabaseAdmin();
  const [enf, acc, fra] = await Promise.all([
    db.from('enfants').select('*').eq('id', Number(id)).maybeSingle(),
    db.from('accueillants').select('id, nom, prenom').order('nom'),
    db.from('fratries').select('id, nom').order('nom'),
  ]);
  if (enf.error) throw new Error(enf.error.message);
  if (!enf.data) notFound();

  return (
    <>
      <Header actif="/enfants" />
      <div className="contenu">
        <h1>Modifier l&apos;enfant</h1>
        <FormEnfant e={enf.data} accueillants={acc.data ?? []} fratries={fra.data ?? []} />
      </div>
    </>
  );
}

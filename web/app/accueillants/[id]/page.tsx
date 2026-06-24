import { notFound } from 'next/navigation';

import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';
import { FormAccueillant } from '../FormAccueillant';

export const dynamic = 'force-dynamic';

export default async function ModifierAccueillant({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const { data, error } = await supabaseAdmin()
    .from('accueillants')
    .select('*')
    .eq('id', Number(id))
    .maybeSingle();
  if (error) throw new Error(error.message);
  if (!data) notFound();

  return (
    <>
      <Header actif="/accueillants" />
      <div className="contenu">
        <h1>Modifier l&apos;accueillant</h1>
        <FormAccueillant a={data} />
      </div>
    </>
  );
}

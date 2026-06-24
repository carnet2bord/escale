import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';
import { FormEnfant } from '../FormEnfant';

export const dynamic = 'force-dynamic';

export default async function NouvelEnfant() {
  const db = supabaseAdmin();
  const [acc, fra] = await Promise.all([
    db.from('accueillants').select('id, nom, prenom').order('nom'),
    db.from('fratries').select('id, nom').order('nom'),
  ]);
  return (
    <>
      <Header actif="/enfants" />
      <div className="contenu">
        <h1>Nouvel enfant</h1>
        <FormEnfant accueillants={acc.data ?? []} fratries={fra.data ?? []} />
      </div>
    </>
  );
}

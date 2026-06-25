import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';
import { ListeEnfants } from './ListeEnfants';

export const dynamic = 'force-dynamic';

export default async function EnfantsPage() {
  const { data, error } = await supabaseAdmin()
    .from('escale_enfants')
    .select('id, nom, prenom, sexe, date_naissance')
    .order('nom');

  return (
    <>
      <Header actif="/enfants" />
      <div className="contenu">
        <div className="aligne-droite">
          <h1>Enfants</h1>
          <Link className="bouton" href="/enfants/nouveau">
            Nouvel enfant
          </Link>
        </div>
        {error ? (
          <div className="banniere" style={{ background: '#fbeaea', color: '#b3261e' }}>
            {error.message}
          </div>
        ) : (
          <ListeEnfants enfants={data ?? []} />
        )}
      </div>
    </>
  );
}

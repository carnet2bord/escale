import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';
import { ListeAccueillants } from './ListeAccueillants';

export const dynamic = 'force-dynamic';

export default async function AccueillantsPage() {
  const { data, error } = await supabaseAdmin()
    .from('escale_accueillants')
    .select('id, nom, prenom, nb_places, restriction_sexe')
    .order('nom');

  return (
    <>
      <Header actif="/accueillants" />
      <div className="contenu">
        <div className="aligne-droite">
          <h1>Accueillants</h1>
          <Link className="bouton" href="/accueillants/nouveau">
            Nouvel accueillant
          </Link>
        </div>
        {error ? (
          <div className="banniere" style={{ background: '#fbeaea', color: '#b3261e' }}>
            {error.message}
          </div>
        ) : (
          <ListeAccueillants accueillants={data ?? []} />
        )}
      </div>
    </>
  );
}

import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';

export const dynamic = 'force-dynamic';

const restrictionLabel: Record<string, string> = {
  aucune: 'Mixte',
  garcon: 'Garçons',
  fille: 'Filles',
};

export default async function AccueillantsPage() {
  const { data, error } = await supabaseAdmin()
    .from('accueillants')
    .select('*')
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
        ) : (data ?? []).length === 0 ? (
          <div className="banniere">Aucun accueillant pour l&apos;instant.</div>
        ) : (
          <table className="liste">
            <thead>
              <tr>
                <th>Nom</th>
                <th>Places</th>
                <th>Accueil</th>
                <th>Secteur</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {(data ?? []).map((a) => (
                <tr key={a.id}>
                  <td>{[a.prenom, a.nom].filter(Boolean).join(' ')}</td>
                  <td>{a.nb_places}</td>
                  <td>{restrictionLabel[a.restriction_sexe] ?? 'Mixte'}</td>
                  <td>{a.secteur ?? '—'}</td>
                  <td style={{ textAlign: 'right' }}>
                    <a href={`/api/pdf/accueillant/${a.id}`} target="_blank" rel="noreferrer">
                      Planning PDF
                    </a>
                    {' '}
                    <a
                      href={`/api/pdf/accueillant/${a.id}?anon=1`}
                      target="_blank"
                      rel="noreferrer"
                      style={{ fontSize: 12 }}
                    >
                      (anon.)
                    </a>
                    {'  ·  '}
                    <Link href={`/accueillants/${a.id}`}>Modifier</Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}

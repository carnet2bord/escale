import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';
import { ageAnnees } from '@/lib/domain/dates';

export const dynamic = 'force-dynamic';

export default async function EnfantsPage() {
  const { data, error } = await supabaseAdmin()
    .from('enfants')
    .select('*')
    .order('nom');

  return (
    <>
      <Header actif="/enfants" />
      <div className="contenu">
        <div className="aligne-droite">
          <h1>Enfants</h1>
          <Link className="bouton" href="/enfants/nouveau">Nouvel enfant</Link>
        </div>
        {error ? (
          <div className="banniere" style={{ background: '#fbeaea', color: '#b3261e' }}>
            {error.message}
          </div>
        ) : (data ?? []).length === 0 ? (
          <div className="banniere">Aucun enfant pour l&apos;instant.</div>
        ) : (
          <table className="liste">
            <thead>
              <tr>
                <th>Nom</th>
                <th>Sexe</th>
                <th>Âge</th>
                <th>Secteur</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {(data ?? []).map((e) => {
                const age = ageAnnees(e.date_naissance ? new Date(`${e.date_naissance}T00:00:00`) : null);
                return (
                  <tr key={e.id}>
                    <td>{[e.prenom, e.nom].filter(Boolean).join(' ')}</td>
                    <td>{e.sexe === 'fille' ? 'Fille' : 'Garçon'}</td>
                    <td>{age != null ? `${age} ans` : '—'}</td>
                    <td>{e.secteur ?? '—'}</td>
                    <td style={{ textAlign: 'right' }}>
                      <a href={`/api/pdf/enfant/${e.id}`} target="_blank" rel="noreferrer">
                        Parcours PDF
                      </a>
                      {'  ·  '}
                      <Link href={`/enfants/${e.id}`}>Modifier</Link>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}

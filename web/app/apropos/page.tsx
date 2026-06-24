import { Header } from '@/app/_components/Header';
import {
  AUTEUR_ESCALE,
  CHANGELOG,
  EMAIL_ESCALE,
  VERSION_ESCALE,
} from '@/lib/changelog';

export const dynamic = 'force-dynamic';

export default function Apropos() {
  return (
    <>
      <Header actif="/apropos" />
      <div className="contenu">
        <h1>À propos d&apos;Escale</h1>
        <p style={{ color: 'var(--gris)', margin: '4px 0' }}>
          Version {VERSION_ESCALE}
        </p>
        <p style={{ fontWeight: 600, margin: '4px 0' }}>
          Créé par {AUTEUR_ESCALE} —{' '}
          <a href={`mailto:${EMAIL_ESCALE}`}>{EMAIL_ESCALE}</a>
        </p>

        <h2 style={{ marginTop: 32 }}>Historique des versions</h2>
        {CHANGELOG.map((v) => (
          <div key={v.numero} className="form-bloc" style={{ marginBottom: 14 }}>
            <div style={{ display: 'flex', gap: 10, alignItems: 'baseline' }}>
              <strong style={{ color: 'var(--teal)' }}>v{v.numero}</strong>
              <span style={{ fontWeight: 600 }}>{v.titre}</span>
            </div>
            <ul style={{ margin: '8px 0 0', paddingLeft: 20 }}>
              {v.points.map((p, i) => (
                <li key={i}>{p}</li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    </>
  );
}

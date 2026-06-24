import { Header } from '@/app/_components/Header';
import { supabaseAdmin } from '@/lib/supabase';

export const dynamic = 'force-dynamic';

const OP: Record<string, string> = {
  INSERT: 'Création',
  UPDATE: 'Modification',
  DELETE: 'Suppression',
};

const TABLE: Record<string, string> = {
  accueillants: 'accueillant',
  enfants: 'enfant',
  fratries: 'fratrie',
  affectations: 'relais',
  besoins_relais: 'besoin',
  disponibilites_accueil: 'disponibilité',
  indisponibilites: 'indisponibilité',
  incompatibilites: 'incompatibilité',
  preferences_accueil: 'préférence',
  solutions_alternatives: 'solution alternative',
};

function decrire(action: string): string {
  const [op, table] = action.split(' ');
  return `${OP[op] ?? op} — ${TABLE[table] ?? table ?? ''}`;
}

export default async function JournalPage() {
  const { data, error } = await supabaseAdmin()
    .from('journal_audit')
    .select('*')
    .order('horodatage', { ascending: false })
    .limit(300);

  return (
    <>
      <Header actif="/journal" />
      <div className="contenu">
        <h1>Journal d&apos;audit</h1>
        <p style={{ color: 'var(--gris)' }}>
          Trace des écritures sur les données (300 dernières). Alimenté par des
          triggers PostgreSQL ; n&apos;enregistre que l&apos;opération et
          l&apos;identifiant de la ligne, jamais le contenu.
        </p>

        {error ? (
          <div className="banniere" style={{ background: '#fbeaea', color: '#b3261e' }}>
            {error.message}. Avez-vous exécuté le schéma (triggers d&apos;audit) ?
          </div>
        ) : (data ?? []).length === 0 ? (
          <div className="banniere">Aucune écriture enregistrée pour l&apos;instant.</div>
        ) : (
          <table className="liste">
            <thead>
              <tr>
                <th>Horodatage</th>
                <th>Opération</th>
                <th>Référence</th>
              </tr>
            </thead>
            <tbody>
              {(data ?? []).map((e) => (
                <tr key={e.id}>
                  <td>{new Date(e.horodatage).toLocaleString('fr-FR')}</td>
                  <td>{decrire(e.action)}</td>
                  <td style={{ color: 'var(--gris)' }}>{e.details}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </>
  );
}

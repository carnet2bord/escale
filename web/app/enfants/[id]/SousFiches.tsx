import { frDate } from '@/lib/format';

type Action = (fd: FormData) => void | Promise<void>;

// Icônes outline (Material : block / star) — pas d'émoji.
const IcoBlock = (
  <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" style={{ verticalAlign: '-3px' }}>
    <circle cx="12" cy="12" r="9" />
    <path d="M5.6 5.6l12.8 12.8" />
  </svg>
);
const IcoStar = (
  <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor" style={{ verticalAlign: '-3px' }}>
    <path d="M12 3l2.7 5.5 6 .9-4.3 4.2 1 6-5.4-2.8L6.3 19.6l1-6L3 9.4l6-.9z" />
  </svg>
);

interface OptionNom {
  id: number;
  nom: string;
}

// --- Incompatibilités enfant ↔ enfant ---

export function IncompatibilitesEnfant({
  enfantId,
  liens,
  autresEnfants,
  ajouter,
  supprimer,
}: {
  enfantId: number;
  liens: { id: number; autreNom: string }[];
  autresEnfants: OptionNom[];
  ajouter: Action;
  supprimer: Action;
}) {
  return (
    <div className="form-bloc" style={{ marginTop: 16, maxWidth: 760 }}>
      <h2 style={{ marginTop: 0 }}>Incompatibilités</h2>
      <p style={{ color: 'var(--gris)', marginTop: -4 }}>
        Enfants à ne jamais accueillir en même temps chez le même accueillant.
      </p>
      {liens.length === 0 ? (
        <p style={{ color: 'var(--gris)' }}>Aucune incompatibilité.</p>
      ) : (
        <ul style={{ listStyle: 'none', padding: 0, margin: '0 0 8px' }}>
          {liens.map((l) => (
            <li
              key={l.id}
              style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '4px 0' }}
            >
              <span style={{ color: '#c62828' }}>{IcoBlock} {l.autreNom}</span>
              <form action={supprimer}>
                <input type="hidden" name="id" value={l.id} />
                <input type="hidden" name="enfantId" value={enfantId} />
                <button className="lien-deco" type="submit" title="Retirer">
                  ✕
                </button>
              </form>
            </li>
          ))}
        </ul>
      )}
      {autresEnfants.length === 0 ? null : (
        <form action={ajouter} className="ligne" style={{ alignItems: 'end' }}>
          <input type="hidden" name="enfantId" value={enfantId} />
          <div style={{ flex: 1 }}>
            <label>Ajouter un enfant incompatible</label>
            <select name="autreId" defaultValue="" required>
              <option value="" disabled>
                — Choisir —
              </option>
              {autresEnfants.map((e) => (
                <option key={e.id} value={e.id}>
                  {e.nom}
                </option>
              ))}
            </select>
          </div>
          <button className="bouton" type="submit">
            Ajouter
          </button>
        </form>
      )}
    </div>
  );
}

// --- Préférences d'accueil (favori / à éviter) ---

export function PreferencesEnfant({
  enfantId,
  prefs,
  accueillants,
  ajouter,
  supprimer,
}: {
  enfantId: number;
  prefs: { id: number; accueillantNom: string; type: string }[];
  accueillants: OptionNom[];
  ajouter: Action;
  supprimer: Action;
}) {
  return (
    <div className="form-bloc" style={{ marginTop: 16, maxWidth: 760 }}>
      <h2 style={{ marginTop: 0 }}>Accueillants favoris / à éviter</h2>
      <p style={{ color: 'var(--gris)', marginTop: -4 }}>
        « À éviter » bloque l&apos;affectation ; « favori » est privilégié par la
        proposition automatique.
      </p>
      {prefs.length === 0 ? (
        <p style={{ color: 'var(--gris)' }}>Aucune préférence.</p>
      ) : (
        <ul style={{ listStyle: 'none', padding: 0, margin: '0 0 8px' }}>
          {prefs.map((p) => (
            <li
              key={p.id}
              style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '4px 0' }}
            >
              <span>
                <span style={{ color: p.type === 'favori' ? '#b8860b' : '#c62828' }}>
                  {p.type === 'favori' ? IcoStar : IcoBlock}
                </span>{' '}
                {p.accueillantNom}{' '}
                <span style={{ color: 'var(--gris)' }}>
                  ({p.type === 'favori' ? 'favori' : 'à éviter'})
                </span>
              </span>
              <form action={supprimer}>
                <input type="hidden" name="id" value={p.id} />
                <input type="hidden" name="enfantId" value={enfantId} />
                <button className="lien-deco" type="submit" title="Retirer">
                  ✕
                </button>
              </form>
            </li>
          ))}
        </ul>
      )}
      {accueillants.length === 0 ? null : (
        <form action={ajouter} className="ligne" style={{ alignItems: 'end' }}>
          <input type="hidden" name="enfantId" value={enfantId} />
          <div style={{ flex: 1 }}>
            <label>Accueillant</label>
            <select name="accueillantId" defaultValue="" required>
              <option value="" disabled>
                — Choisir —
              </option>
              {accueillants.map((a) => (
                <option key={a.id} value={a.id}>
                  {a.nom}
                </option>
              ))}
            </select>
          </div>
          <div>
            <label>Type</label>
            <select name="type" defaultValue="favori">
              <option value="favori">Favori</option>
              <option value="exclu">À éviter</option>
            </select>
          </div>
          <button className="bouton" type="submit">
            Ajouter
          </button>
        </form>
      )}
    </div>
  );
}

// --- Solutions alternatives (colonie / tiers / autre) ---

const LIBELLE_SOLUTION: Record<string, string> = {
  colonie: 'Colonie de vacances',
  tiers: 'Accueil par un tiers',
  autre: 'Autre',
};

export function SolutionsEnfant({
  enfantId,
  items,
  ajouter,
  supprimer,
}: {
  enfantId: number;
  items: { id: number; debut: string; fin: string; type: string; details: string | null }[];
  ajouter: Action;
  supprimer: Action;
}) {
  return (
    <div className="form-bloc" style={{ marginTop: 16, maxWidth: 760 }}>
      <h2 style={{ marginTop: 0 }}>Solutions alternatives (hors relais)</h2>
      <p style={{ color: 'var(--gris)', marginTop: -4 }}>
        Couvrir un besoin sans relais : colonie, accueil par un tiers, etc. Comptée
        dans la couverture de l&apos;enfant.
      </p>
      {items.length === 0 ? (
        <p style={{ color: 'var(--gris)' }}>Aucune solution alternative.</p>
      ) : (
        <table className="liste">
          <thead>
            <tr>
              <th>Période</th>
              <th>Type</th>
              <th>Détails</th>
              <th style={{ width: 1 }}></th>
            </tr>
          </thead>
          <tbody>
            {items.map((s) => (
              <tr key={s.id}>
                <td>
                  {frDate(s.debut)} → {frDate(s.fin)}
                </td>
                <td>{LIBELLE_SOLUTION[s.type] ?? s.type}</td>
                <td>{s.details ?? ''}</td>
                <td>
                  <form action={supprimer}>
                    <input type="hidden" name="id" value={s.id} />
                    <input type="hidden" name="enfantId" value={enfantId} />
                    <button className="lien-deco" type="submit" title="Supprimer">
                      ✕
                    </button>
                  </form>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <form action={ajouter} className="ligne" style={{ marginTop: 14, alignItems: 'end' }}>
        <input type="hidden" name="enfantId" value={enfantId} />
        <div>
          <label>Début</label>
          <input type="date" name="debut" required />
        </div>
        <div>
          <label>Fin</label>
          <input type="date" name="fin" required />
        </div>
        <div>
          <label>Type</label>
          <select name="type" defaultValue="colonie">
            <option value="colonie">Colonie de vacances</option>
            <option value="tiers">Accueil par un tiers</option>
            <option value="autre">Autre</option>
          </select>
        </div>
        <div style={{ flex: 1 }}>
          <label>Détails</label>
          <input name="details" placeholder="Optionnel" />
        </div>
        <button className="bouton" type="submit">
          Ajouter
        </button>
      </form>
    </div>
  );
}

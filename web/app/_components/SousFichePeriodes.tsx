import { frDate } from '@/lib/format';

interface ItemPeriode {
  id: number;
  debut: string;
  fin: string;
  motif?: string | null;
}

export function SousFichePeriodes({
  titre,
  description,
  items,
  ajouter,
  supprimer,
  parentName,
  parentId,
  avecMotif = false,
  motifLabel = 'Motif',
}: {
  titre: string;
  description?: string;
  items: ItemPeriode[];
  ajouter: (fd: FormData) => void | Promise<void>;
  supprimer: (fd: FormData) => void | Promise<void>;
  parentName: 'accueillantId' | 'enfantId';
  parentId: number;
  avecMotif?: boolean;
  motifLabel?: string;
}) {
  return (
    <div className="form-bloc" style={{ marginTop: 16, maxWidth: 760 }}>
      <h2 style={{ marginTop: 0 }}>{titre}</h2>
      {description ? (
        <p style={{ color: 'var(--gris)', marginTop: -4 }}>{description}</p>
      ) : null}

      {items.length === 0 ? (
        <p style={{ color: 'var(--gris)' }}>Aucune période enregistrée.</p>
      ) : (
        <table className="liste">
          <thead>
            <tr>
              <th>Début</th>
              <th>Fin</th>
              {avecMotif ? <th>{motifLabel}</th> : null}
              <th style={{ width: 1 }}></th>
            </tr>
          </thead>
          <tbody>
            {items.map((it) => (
              <tr key={it.id}>
                <td>{frDate(it.debut)}</td>
                <td>{frDate(it.fin)}</td>
                {avecMotif ? <td>{it.motif ?? ''}</td> : null}
                <td>
                  <form action={supprimer}>
                    <input type="hidden" name="id" value={it.id} />
                    <input type="hidden" name={parentName} value={parentId} />
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

      <form
        action={ajouter}
        className="ligne"
        style={{ marginTop: 14, alignItems: 'end' }}
      >
        <input type="hidden" name={parentName} value={parentId} />
        <div>
          <label>Début</label>
          <input type="date" name="debut" required />
        </div>
        <div>
          <label>Fin</label>
          <input type="date" name="fin" required />
        </div>
        {avecMotif ? (
          <div>
            <label>{motifLabel}</label>
            <input name="motif" />
          </div>
        ) : null}
        <button className="bouton" type="submit">
          Ajouter
        </button>
      </form>
    </div>
  );
}

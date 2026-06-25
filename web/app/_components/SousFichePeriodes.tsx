import Link from 'next/link';

import { frDate } from '@/lib/format';
import { IcoDelete } from './icons';

interface ItemPeriode {
  id: number;
  debut: string;
  fin: string;
  motif?: string | null;
}

function nbJours(debut: string, fin: string): number {
  const a = new Date(`${debut}T00:00:00`).getTime();
  const b = new Date(`${fin}T00:00:00`).getTime();
  return Math.max(1, Math.round((b - a) / 86400000) + 1);
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
  planifierBase,
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
  planifierBase?: string;
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
              <th>Durée</th>
              {avecMotif ? <th>{motifLabel}</th> : null}
              <th style={{ width: 1 }}></th>
            </tr>
          </thead>
          <tbody>
            {items.map((it) => (
              <tr key={it.id}>
                <td>{frDate(it.debut)}</td>
                <td>{frDate(it.fin)}</td>
                <td>{nbJours(it.debut, it.fin)} jour(s)</td>
                {avecMotif ? <td>{it.motif ?? ''}</td> : null}
                <td style={{ whiteSpace: 'nowrap' }}>
                  {planifierBase ? (
                    <Link
                      href={`${planifierBase}?enfant=${parentId}&debut=${it.debut}&fin=${it.fin}`}
                      title="Planifier un relais sur cette période"
                      style={{ marginRight: 8 }}
                    >
                      Planifier
                    </Link>
                  ) : null}
                  <form action={supprimer} style={{ display: 'inline' }}>
                    <input type="hidden" name="id" value={it.id} />
                    <input type="hidden" name={parentName} value={parentId} />
                    <button className="lien-deco" type="submit" title="Supprimer" style={{ verticalAlign: 'middle' }}>
                      <IcoDelete size={16} />
                    </button>
                  </form>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <form action={ajouter} className="ligne" style={{ marginTop: 14, alignItems: 'end' }}>
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

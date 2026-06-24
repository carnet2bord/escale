import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { dateFr } from '@/lib/domain/dates';
import { proposerAffectations } from '@/lib/domain/proposition';
import { chargerSnapshot } from '@/lib/data';
import { isoDate, nomComplet } from '@/lib/format';
import { creerRelais, creerToutes } from './actions';

export const dynamic = 'force-dynamic';

export default async function PropositionPage() {
  const snap = await chargerSnapshot();
  const enfById = new Map(snap.enfants.map((e) => [e.id, e]));
  const accById = new Map(snap.accueillants.map((a) => [a.id, a]));

  const res = proposerAffectations({
    enfants: snap.enfants,
    accueillants: snap.accueillants,
    affectationsExistantes: snap.affectations,
    besoins: snap.besoins,
    dispos: snap.disponibilites,
    indispos: snap.indisponibilites,
    incompatibilites: snap.incompatibilites,
    fratries: snap.fratries,
    preferences: snap.preferences,
    solutions: snap.solutions,
  });

  const payload = JSON.stringify(
    res.propositions.map((p) => ({
      enfant_id: p.enfant.id,
      accueillant_id: p.accueillant.id,
      debut: isoDate(p.debut),
      fin: isoDate(p.fin),
      besoin_id: p.besoinId,
    })),
  );

  return (
    <>
      <Header actif="/proposition" />
      <div className="contenu">
        <h1>Proposition automatique</h1>
        <p style={{ color: 'var(--gris)' }}>
          Le moteur place les besoins de relais non couverts chez les accueillants
          disponibles, sans créer de conflit bloquant.
        </p>

        {res.limiteAtteinte ? (
          <p style={{ color: '#b26a00' }}>
            ⚠ Espace de recherche très grand : la proposition a été tronquée. Affinez
            les disponibilités/besoins pour un résultat complet.
          </p>
        ) : null}

        <div style={{ display: 'flex', gap: 12, alignItems: 'center', margin: '12px 0' }}>
          <h2 style={{ margin: 0 }}>
            {res.propositions.length} relais proposé(s)
          </h2>
          {res.propositions.length > 0 ? (
            <form action={creerToutes}>
              <input type="hidden" name="payload" value={payload} />
              <button className="bouton" type="submit">
                Tout créer (proposé)
              </button>
            </form>
          ) : null}
          <Link className="bouton-secondaire" href="/planning">
            Voir le planning
          </Link>
        </div>

        {res.propositions.length === 0 ? (
          <p>Aucune proposition : tous les besoins sont couverts, ou aucun accueillant n&apos;est disponible.</p>
        ) : (
          <table className="liste">
            <thead>
              <tr>
                <th>Période</th>
                <th>Enfant</th>
                <th>Accueillant proposé</th>
                <th style={{ width: 1 }}></th>
              </tr>
            </thead>
            <tbody>
              {res.propositions.map((p, i) => (
                <tr key={i}>
                  <td>
                    {dateFr(p.debut)} → {dateFr(p.fin)}
                  </td>
                  <td>{nomComplet(p.enfant)}</td>
                  <td>{nomComplet(p.accueillant)}</td>
                  <td>
                    <form action={creerRelais}>
                      <input type="hidden" name="enfantId" value={p.enfant.id} />
                      <input type="hidden" name="accueillantId" value={p.accueillant.id} />
                      <input type="hidden" name="debut" value={isoDate(p.debut)} />
                      <input type="hidden" name="fin" value={isoDate(p.fin)} />
                      <input type="hidden" name="besoinId" value={p.besoinId} />
                      <button className="bouton-secondaire" type="submit" style={{ padding: '4px 12px' }}>
                        Créer
                      </button>
                    </form>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}

        {res.nonPlaces.length > 0 ? (
          <>
            <h2 style={{ marginTop: 28 }}>
              {res.nonPlaces.length} besoin(s) non plaçable(s)
            </h2>
            <p style={{ color: 'var(--gris)' }}>
              Aucun accueillant compatible et disponible sur la période. Pensez aux
              solutions alternatives (colonie, tiers digne de confiance…).
            </p>
            <table className="liste">
              <thead>
                <tr>
                  <th>Période</th>
                  <th>Enfant</th>
                </tr>
              </thead>
              <tbody>
                {res.nonPlaces.map((c, i) => (
                  <tr key={i}>
                    <td>
                      {dateFr(c.debut)} → {dateFr(c.fin)}
                    </td>
                    <td>{nomComplet(c.enfant)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        ) : null}
      </div>
    </>
  );
}

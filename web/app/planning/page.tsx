import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { EmptyState, Pastille } from '@/app/_components/ui';
import {
  IcoAdd,
  IcoAlert,
  IcoCalWeek,
  IcoCalendar,
  IcoCar,
  IcoList,
  IcoOk,
  IcoPdf,
  IcoSparkles,
  IcoWarning,
} from '@/app/_components/icons';
import { analyserAffectation } from '@/lib/domain/conflits';
import { distanceKm } from '@/lib/domain/distance';
import { periodeFr } from '@/lib/domain/dates';
import { relaisActif, statutAnnule } from '@/lib/domain/types';
import { chargerSnapshot } from '@/lib/data';
import { nomComplet } from '@/lib/format';
import { lireSeuilDistanceKm } from '@/lib/reglages';
import { CalendrierPlanning } from './CalendrierPlanning';
import { RelaisActions } from './RelaisActions';

export const dynamic = 'force-dynamic';

const LIBELLE_STATUT: Record<string, string> = {
  propose: 'Proposé',
  confirme: 'Confirmé',
  realise: 'Réalisé',
  annule: 'Annulé',
};
const COULEUR_STATUT: Record<string, string> = {
  propose: '#c2710c',
  confirme: '#156f6c',
  realise: '#4b5563',
  annule: '#9ca3af',
};
const LIBELLE_SOLUTION: Record<string, string> = {
  colonie: 'Colonie de vacances',
  tiers: 'Accueil par un tiers',
  autre: 'Autre',
};

export default async function Planning({
  searchParams,
}: {
  searchParams: Promise<{ vue?: string }>;
}) {
  const { vue } = await searchParams;
  const calendrier = vue === 'calendrier';
  const snap = await chargerSnapshot();
  const seuilDistanceKm = await lireSeuilDistanceKm();
  const accById = new Map(snap.accueillants.map((a) => [a.id, a]));
  const enfById = new Map(snap.enfants.map((e) => [e.id, e]));

  const affs = [...snap.affectations].sort((a, b) => a.debut.getTime() - b.debut.getTime());

  const lignes = affs.map((a) => {
    const enfant = enfById.get(a.enfantId);
    const accueillant = accById.get(a.accueillantId);
    const conflits =
      enfant && accueillant && relaisActif(a.statut)
        ? analyserAffectation({
            enfant,
            accueillant,
            debut: a.debut,
            fin: a.fin,
            affectations: snap.affectations,
            disponibilites: snap.disponibilites,
            indisponibilites: snap.indisponibilites,
            incompatibilites: snap.incompatibilites,
            enfants: snap.enfants,
            fratries: snap.fratries,
            preferences: snap.preferences,
            solutions: snap.solutions,
            affectationExclueId: a.id,
            seuilDistanceKm,
          })
        : [];
    const dist = enfant && accueillant ? distanceKm(enfant, accueillant) : null;
    return { a, enfant, accueillant, conflits, dist };
  });

  const solutions = [...snap.solutions].sort((a, b) => a.debut.getTime() - b.debut.getTime());

  return (
    <>
      <Header actif="/planning" />
      <div className="contenu">
        <div className="aligne-droite">
          <h1>Planning des relais</h1>
          <span style={{ display: 'flex', gap: 10 }}>
            <Link className="bouton-secondaire" href="/proposition" style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
              <IcoSparkles /> Proposer
            </Link>
            <Link className="bouton" href="/planning/nouveau" style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
              <IcoAdd /> Nouveau relais
            </Link>
          </span>
        </div>

        <div className="segmented">
          <Link href="/planning" className={calendrier ? '' : 'actif'}>
            <IcoList /> Liste
          </Link>
          <Link href="/planning?vue=calendrier" className={calendrier ? 'actif' : ''}>
            <IcoCalWeek /> Calendrier
          </Link>
        </div>

        {calendrier ? (
          <CalendrierPlanning
            accueillants={snap.accueillants.map((a) => ({ id: a.id, nom: nomComplet(a) }))}
            enfants={snap.enfants.map((e) => ({ id: e.id, nom: nomComplet(e) }))}
            affectations={snap.affectations}
            solutions={snap.solutions}
          />
        ) : lignes.length === 0 && solutions.length === 0 ? (
          <EmptyState
            icone={<IcoCalendar />}
            titre="Aucun relais planifié"
            sousTitre="Créez un relais manuellement, ou laissez « Proposer » placer automatiquement les enfants."
            action={
              <Link className="bouton" href="/planning/nouveau">
                Nouveau relais
              </Link>
            }
          />
        ) : (
          <>
            {lignes.map(({ a, enfant, accueillant, conflits, dist }) => {
              const annule = a.statut === statutAnnule;
              const bloquants = conflits.filter((c) => c.severite === 'bloquant').length;
              const avert = conflits.length - bloquants;
              const gravite =
                bloquants > 0 ? (
                  <span style={{ color: '#c62828' }}><IcoAlert /></span>
                ) : avert > 0 ? (
                  <span style={{ color: '#b26a00' }}><IcoWarning /></span>
                ) : (
                  <span style={{ color: '#2e7d32' }}><IcoOk /></span>
                );
              return (
                <div className="carte-liste" key={a.id} style={annule ? { opacity: 0.6 } : undefined}>
                  <span style={{ flexShrink: 0 }}>{gravite}</span>
                  <div className="cl-corps">
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <span style={{ fontWeight: 600, textDecoration: annule ? 'line-through' : undefined }}>
                        {enfant ? nomComplet(enfant) : '?'} → {accueillant ? nomComplet(accueillant) : '?'}
                      </span>
                      <Pastille texte={LIBELLE_STATUT[a.statut] ?? a.statut} couleur={COULEUR_STATUT[a.statut] ?? '#156f6c'} />
                    </div>
                    <div style={{ color: 'var(--gris)', fontSize: 13, marginTop: 2 }}>
                      {periodeFr(a.debut, a.fin)}
                      {dist != null ? ` · ${Math.round(dist)} km` : ''}
                    </div>
                    {a.transport && a.transport.trim() ? (
                      <div style={{ display: 'flex', alignItems: 'center', gap: 4, color: 'var(--gris)', fontSize: 12, marginTop: 4 }}>
                        <IcoCar /> {a.transport.trim()}
                      </div>
                    ) : null}
                    {conflits.length > 0 ? (
                      <ul style={{ margin: '6px 0 0', paddingLeft: 16 }}>
                        {conflits.map((c, i) => (
                          <li key={i} style={{ color: c.severite === 'bloquant' ? '#c62828' : '#b26a00', fontSize: 12 }}>
                            {c.message}
                          </li>
                        ))}
                      </ul>
                    ) : null}
                  </div>
                  <div style={{ flexShrink: 0 }}>
                    <RelaisActions id={a.id} statut={a.statut} transport={a.transport} />
                  </div>
                </div>
              );
            })}

            {solutions.length > 0 ? (
              <>
                <h2 style={{ marginTop: 24 }}>Solutions alternatives</h2>
                <p style={{ color: 'var(--gris)', marginTop: -6 }}>
                  Couvertures hors relais (colonie, accueil par un tiers…).
                </p>
                {solutions.map((s) => {
                  const enf = enfById.get(s.enfantId);
                  return (
                    <div className="carte-liste" key={`s${s.id}`}>
                      <div className="cl-corps">
                        <div style={{ fontWeight: 600 }}>
                          {enf ? nomComplet(enf) : '?'} · {LIBELLE_SOLUTION[s.type] ?? s.type}
                        </div>
                        <div style={{ color: 'var(--gris)', fontSize: 13, marginTop: 2 }}>
                          {periodeFr(s.debut, s.fin)}
                          {s.details ? ` — ${s.details}` : ''}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </>
            ) : null}
          </>
        )}
      </div>
    </>
  );
}

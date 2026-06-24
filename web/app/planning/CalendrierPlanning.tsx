import { jour } from '@/lib/domain/dates';
import type { Affectation, SolutionAlternative } from '@/lib/domain/types';
import { relaisActif } from '@/lib/domain/types';

const JOUR_MS = 86400000;
const LARGEUR_JOUR = 30; // px par jour
const LARGEUR_LIBELLE = 180; // colonne accueillant
const HAUTEUR_LANE = 26;
const MAX_JOURS = 400;

const MOIS = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];
const JOURS_LETTRE = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];

const COULEUR_TYPE: Record<string, string> = {
  relais: '#156f6c',
  colonie: '#c2710c',
  tiers: '#7c3aed',
  autre: '#5a6168',
};

interface Barre {
  debut: Date;
  fin: Date;
  label: string;
  couleur: string;
  lane: number;
}

interface Ligne {
  titre: string;
  barres: Barre[];
  nbLanes: number;
}

function assignerLanes(items: Omit<Barre, 'lane'>[]): Barre[] {
  const tries = [...items].sort((a, b) => a.debut.getTime() - b.debut.getTime());
  const finDeLane: number[] = [];
  const res: Barre[] = [];
  for (const it of tries) {
    const d = jour(it.debut).getTime();
    let lane = finDeLane.findIndex((f) => f < d);
    if (lane === -1) {
      lane = finDeLane.length;
      finDeLane.push(0);
    }
    finDeLane[lane] = jour(it.fin).getTime();
    res.push({ ...it, lane });
  }
  return res;
}

export function CalendrierPlanning({
  accueillants,
  enfants,
  affectations,
  solutions,
}: {
  accueillants: { id: number; nom: string }[];
  enfants: { id: number; nom: string }[];
  affectations: Affectation[];
  solutions: SolutionAlternative[];
}) {
  const enfNom = new Map(enfants.map((e) => [e.id, e.nom]));
  const affsActives = affectations.filter((a) => relaisActif(a.statut));

  // Plage de dates.
  const toutes: Date[] = [];
  for (const a of affsActives) {
    toutes.push(jour(a.debut), jour(a.fin));
  }
  for (const s of solutions) {
    toutes.push(jour(s.debut), jour(s.fin));
  }
  if (toutes.length === 0) {
    return <p>Aucun relais à afficher dans le calendrier.</p>;
  }
  let debutPlage = new Date(Math.min(...toutes.map((d) => d.getTime())));
  let finPlage = new Date(Math.max(...toutes.map((d) => d.getTime())));
  let tronque = false;
  const nbJoursTotal = Math.round((finPlage.getTime() - debutPlage.getTime()) / JOUR_MS) + 1;
  if (nbJoursTotal > MAX_JOURS) {
    finPlage = new Date(debutPlage.getTime() + (MAX_JOURS - 1) * JOUR_MS);
    tronque = true;
  }

  const jours: Date[] = [];
  for (let t = debutPlage.getTime(); t <= finPlage.getTime(); t += JOUR_MS) {
    jours.push(new Date(t));
  }
  const indexParJour = new Map(jours.map((d, i) => [jour(d).getTime(), i]));
  const idx = (d: Date): number => {
    const t = jour(d).getTime();
    if (t < debutPlage.getTime()) return 0;
    if (t > finPlage.getTime()) return jours.length - 1;
    return indexParJour.get(t) ?? 0;
  };
  const largeurTotale = jours.length * LARGEUR_JOUR;

  // Bandeau des mois.
  const segmentsMois: { label: string; jours: number }[] = [];
  for (const d of jours) {
    const label = `${MOIS[d.getMonth()]} ${d.getFullYear()}`;
    const dernier = segmentsMois[segmentsMois.length - 1];
    if (dernier && dernier.label === label) dernier.jours++;
    else segmentsMois.push({ label, jours: 1 });
  }

  // Lignes accueillants.
  const lignes: Ligne[] = accueillants
    .slice()
    .sort((a, b) => a.nom.localeCompare(b.nom))
    .map((acc) => {
      const items = affsActives
        .filter((a) => a.accueillantId === acc.id)
        .map((a) => ({
          debut: a.debut,
          fin: a.fin,
          label: enfNom.get(a.enfantId) ?? '—',
          couleur: COULEUR_TYPE.relais,
        }));
      const barres = assignerLanes(items);
      return {
        titre: acc.nom,
        barres,
        nbLanes: Math.max(1, ...barres.map((b) => b.lane + 1)),
      };
    });

  // Ligne « Hors relais » (solutions alternatives).
  if (solutions.length > 0) {
    const items = solutions.map((s) => ({
      debut: s.debut,
      fin: s.fin,
      label: enfNom.get(s.enfantId) ?? '—',
      couleur: COULEUR_TYPE[s.type] ?? COULEUR_TYPE.autre,
    }));
    const barres = assignerLanes(items);
    lignes.push({
      titre: 'Hors relais',
      barres,
      nbLanes: Math.max(1, ...barres.map((b) => b.lane + 1)),
    });
  }

  return (
    <div>
      {tronque ? (
        <p style={{ color: '#b26a00' }}>
          Affichage limité à {MAX_JOURS} jours à partir du premier relais.
        </p>
      ) : null}

      <div style={{ display: 'flex', gap: 16, margin: '8px 0 12px', fontSize: 13 }}>
        <Legende couleur={COULEUR_TYPE.relais} texte="Relais" />
        <Legende couleur={COULEUR_TYPE.colonie} texte="Colonie de vacances" />
        <Legende couleur={COULEUR_TYPE.tiers} texte="Accueil par un tiers" />
      </div>

      <div
        style={{
          overflowX: 'auto',
          border: '1px solid var(--filet)',
          borderRadius: 12,
          background: '#fff',
        }}
      >
        <div style={{ minWidth: LARGEUR_LIBELLE + largeurTotale }}>
          {/* Bandeau mois */}
          <div style={{ display: 'flex', borderBottom: '1px solid var(--filet)' }}>
            <div style={{ width: LARGEUR_LIBELLE, flexShrink: 0 }} />
            <div style={{ display: 'flex' }}>
              {segmentsMois.map((m, i) => (
                <div
                  key={i}
                  style={{
                    width: m.jours * LARGEUR_JOUR,
                    flexShrink: 0,
                    padding: '4px 6px',
                    fontWeight: 600,
                    fontSize: 12,
                    borderLeft: '1px solid var(--filet)',
                    textTransform: 'capitalize',
                  }}
                >
                  {m.label}
                </div>
              ))}
            </div>
          </div>

          {/* Bandeau jours */}
          <div style={{ display: 'flex', borderBottom: '1px solid var(--filet)' }}>
            <div style={{ width: LARGEUR_LIBELLE, flexShrink: 0 }} />
            <div style={{ display: 'flex' }}>
              {jours.map((d, i) => {
                const we = d.getDay() === 0 || d.getDay() === 6;
                return (
                  <div
                    key={i}
                    style={{
                      width: LARGEUR_JOUR,
                      flexShrink: 0,
                      textAlign: 'center',
                      fontSize: 10,
                      color: we ? '#aab0b5' : 'var(--gris)',
                      background: we ? '#f6f8f8' : '#fff',
                      borderLeft: '1px solid #eef1f2',
                      padding: '2px 0',
                    }}
                  >
                    <div>{JOURS_LETTRE[d.getDay()]}</div>
                    <div>{d.getDate()}</div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Lignes */}
          {lignes.map((ligne, li) => (
            <div
              key={li}
              style={{
                display: 'flex',
                borderBottom: '1px solid var(--filet)',
                background: ligne.titre === 'Hors relais' ? '#fafbfb' : '#fff',
              }}
            >
              <div
                style={{
                  width: LARGEUR_LIBELLE,
                  flexShrink: 0,
                  padding: '8px 10px',
                  fontSize: 13,
                  fontWeight: ligne.titre === 'Hors relais' ? 400 : 600,
                  fontStyle: ligne.titre === 'Hors relais' ? 'italic' : 'normal',
                  borderRight: '1px solid var(--filet)',
                  display: 'flex',
                  alignItems: 'center',
                }}
              >
                {ligne.titre}
              </div>
              <div
                style={{
                  position: 'relative',
                  width: largeurTotale,
                  flexShrink: 0,
                  height: ligne.nbLanes * HAUTEUR_LANE + 8,
                }}
              >
                {/* Colonnes week-end */}
                {jours.map((d, i) =>
                  d.getDay() === 0 || d.getDay() === 6 ? (
                    <div
                      key={i}
                      style={{
                        position: 'absolute',
                        left: i * LARGEUR_JOUR,
                        top: 0,
                        bottom: 0,
                        width: LARGEUR_JOUR,
                        background: '#f6f8f8',
                      }}
                    />
                  ) : null,
                )}
                {ligne.barres.map((b, bi) => {
                  const gauche = idx(b.debut) * LARGEUR_JOUR;
                  const largeur =
                    (idx(b.fin) - idx(b.debut) + 1) * LARGEUR_JOUR - 4;
                  return (
                    <div
                      key={bi}
                      title={b.label}
                      style={{
                        position: 'absolute',
                        left: gauche + 2,
                        top: b.lane * HAUTEUR_LANE + 4,
                        width: Math.max(largeur, LARGEUR_JOUR - 4),
                        height: HAUTEUR_LANE - 4,
                        background: b.couleur,
                        color: '#fff',
                        borderRadius: 6,
                        fontSize: 11,
                        lineHeight: `${HAUTEUR_LANE - 4}px`,
                        padding: '0 6px',
                        overflow: 'hidden',
                        whiteSpace: 'nowrap',
                        textOverflow: 'ellipsis',
                      }}
                    >
                      {b.label}
                    </div>
                  );
                })}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function Legende({ couleur, texte }: { couleur: string; texte: string }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
      <span
        style={{ width: 14, height: 14, borderRadius: 4, background: couleur, display: 'inline-block' }}
      />
      {texte}
    </span>
  );
}

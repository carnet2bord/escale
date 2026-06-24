import { Header } from './_components/Header';
import { chargerSnapshot } from '@/lib/data';
import { couverturesEnfant } from '@/lib/domain/proposition';
import { jour } from '@/lib/domain/dates';
import { relaisActif } from '@/lib/domain/types';

export const dynamic = 'force-dynamic';

function couverture(s: Awaited<ReturnType<typeof chargerSnapshot>>) {
  let total = 0;
  let couverts = 0;
  for (const b of s.besoins) {
    if (jour(b.fin).getTime() < jour(b.debut).getTime()) continue;
    const cov = couverturesEnfant(b.enfantId, s.affectations, s.solutions);
    let d = jour(b.debut);
    const f = jour(b.fin);
    while (d.getTime() <= f.getTime()) {
      total++;
      if (cov.some((c) => d.getTime() >= jour(c[0]).getTime() && d.getTime() <= jour(c[1]).getTime())) {
        couverts++;
      }
      d = new Date(d.getTime() + 86400000);
    }
  }
  return { total, couverts, pct: total === 0 ? 100 : Math.round((couverts * 100) / total) };
}

export default async function DashboardPage() {
  let s: Awaited<ReturnType<typeof chargerSnapshot>> | null = null;
  let erreur: string | null = null;
  try {
    s = await chargerSnapshot();
  } catch (e) {
    erreur = e instanceof Error ? e.message : String(e);
  }

  return (
    <>
      <Header actif="/" />
      <div className="contenu">
        <h1>Tableau de bord</h1>
        {erreur ? (
          <div className="banniere" style={{ background: '#fbeaea', color: '#b3261e' }}>
            Connexion à la base impossible : {erreur}. Vérifiez SUPABASE_URL /
            SUPABASE_SERVICE_ROLE_KEY et que le schéma a été exécuté.
          </div>
        ) : s ? (
          <>
            <div className="cartes">
              <div className="carte">
                <div className="valeur">{s.accueillants.length}</div>
                <div className="libelle">Accueillants</div>
              </div>
              <div className="carte">
                <div className="valeur">{s.enfants.length}</div>
                <div className="libelle">Enfants</div>
              </div>
              <div className="carte">
                <div className="valeur">
                  {s.affectations.filter((a) => relaisActif(a.statut)).length}
                </div>
                <div className="libelle">Relais planifiés</div>
              </div>
              <div className="carte">
                <div className="valeur">{s.besoins.length}</div>
                <div className="libelle">Besoins</div>
              </div>
            </div>
            {(() => {
              const c = couverture(s!);
              return (
                <div className="kpi">
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <strong>Couverture des besoins</strong>
                    <span style={{ fontSize: 24, fontWeight: 700, color: 'var(--teal)' }}>{c.pct} %</span>
                  </div>
                  <div className="jauge"><div style={{ width: `${c.pct}%` }} /></div>
                  <div style={{ color: 'var(--gris)', fontSize: 13 }}>
                    {c.couverts} / {c.total} journées de besoin assurées
                  </div>
                </div>
              );
            })()}
          </>
        ) : null}
        <div className="banniere">
          Version web (fondation) — moteur de conflits et de proposition porté et
          vérifié. Les écrans complets (accueillants, enfants, planning, documents)
          arrivent dans les prochaines itérations.
        </div>
      </div>
    </>
  );
}

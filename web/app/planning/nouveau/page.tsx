import Link from 'next/link';

import { Header } from '@/app/_components/Header';
import { creerRelais } from '@/app/proposition/actions';
import { nomComplet } from '@/lib/format';
import { supabaseAdmin } from '@/lib/supabase';

export const dynamic = 'force-dynamic';

export default async function NouveauRelais({
  searchParams,
}: {
  searchParams: Promise<{ enfant?: string; debut?: string; fin?: string }>;
}) {
  const sp = await searchParams;
  const enfantPre = sp.enfant ?? '';
  const db = supabaseAdmin();
  const [enf, acc] = await Promise.all([
    db.from('escale_enfants').select('id, nom, prenom').order('nom'),
    db.from('escale_accueillants').select('id, nom, prenom').order('nom'),
  ]);

  return (
    <>
      <Header actif="/planning" />
      <div className="contenu">
        <h1>Nouveau relais</h1>
        <p style={{ color: 'var(--gris)' }}>
          Le relais n&apos;est créé que s&apos;il ne génère aucun conflit bloquant.
        </p>
        <div className="form-bloc">
          <form action={creerRelais}>
            <input type="hidden" name="apres" value="/planning" />
            <div className="ligne">
              <div>
                <label>Enfant *</label>
                <select name="enfantId" defaultValue={enfantPre} required>
                  <option value="" disabled>
                    — Choisir —
                  </option>
                  {(enf.data ?? []).map((e) => (
                    <option key={e.id} value={e.id}>
                      {nomComplet(e)}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label>Accueillant *</label>
                <select name="accueillantId" defaultValue="" required>
                  <option value="" disabled>
                    — Choisir —
                  </option>
                  {(acc.data ?? []).map((a) => (
                    <option key={a.id} value={a.id}>
                      {nomComplet(a)}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <div className="ligne">
              <div>
                <label>Début *</label>
                <input type="date" name="debut" defaultValue={sp.debut ?? ''} required />
              </div>
              <div>
                <label>Fin *</label>
                <input type="date" name="fin" defaultValue={sp.fin ?? ''} required />
              </div>
            </div>
            <div className="actions-form">
              <button className="bouton" type="submit">
                Créer le relais
              </button>
              <Link className="bouton-secondaire" href="/planning">
                Annuler
              </Link>
            </div>
          </form>
        </div>
      </div>
    </>
  );
}

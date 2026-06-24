import { Header } from '@/app/_components/Header';
import { nomComplet } from '@/lib/format';
import { supabaseAdmin } from '@/lib/supabase';
import { enregistrerFratrie, supprimerFratrie } from './actions';

export const dynamic = 'force-dynamic';

function SelectRegroupement({ valeur }: { valeur: string }) {
  return (
    <select name="regroupement" defaultValue={valeur}>
      <option value="ensemble">Garder ensemble</option>
      <option value="separes">À séparer</option>
      <option value="indifferent">Indifférent</option>
    </select>
  );
}

export default async function FratriesPage({
  searchParams,
}: {
  searchParams: Promise<{ erreur?: string }>;
}) {
  const { erreur } = await searchParams;
  const db = supabaseAdmin();
  const [fra, enf] = await Promise.all([
    db.from('fratries').select('*').order('nom'),
    db.from('enfants').select('id, nom, prenom, fratrie_id').order('nom'),
  ]);
  if (fra.error) throw new Error(fra.error.message);

  const membres = new Map<number, string[]>();
  for (const e of enf.data ?? []) {
    if (e.fratrie_id == null) continue;
    const liste = membres.get(e.fratrie_id) ?? [];
    liste.push(nomComplet(e));
    membres.set(e.fratrie_id, liste);
  }

  return (
    <>
      <Header actif="/fratries" />
      <div className="contenu">
        <h1>Fratries</h1>
        <p style={{ color: 'var(--gris)' }}>
          Une fratrie regroupe des enfants liés. La politique « À séparer » bloque
          leur accueil simultané chez le même accueillant ; « Garder ensemble »
          est privilégié par la proposition automatique. Le lien enfant→fratrie se
          choisit sur la fiche de chaque enfant.
        </p>

        {erreur === 'nom' ? <p className="erreur">Le nom est obligatoire.</p> : null}
        {erreur === 'doublon' ? (
          <p className="erreur">Une fratrie porte déjà ce nom.</p>
        ) : null}

        <div className="form-bloc" style={{ marginBottom: 16 }}>
          <h2 style={{ marginTop: 0 }}>Nouvelle fratrie</h2>
          <form action={enregistrerFratrie} className="ligne" style={{ alignItems: 'end' }}>
            <div style={{ flex: 1 }}>
              <label>Nom</label>
              <input name="nom" placeholder="Ex. Fratrie Martin" required />
            </div>
            <div>
              <label>Politique</label>
              <SelectRegroupement valeur="ensemble" />
            </div>
            <button className="bouton" type="submit">
              Créer
            </button>
          </form>
        </div>

        {(fra.data ?? []).length === 0 ? (
          <div className="banniere">Aucune fratrie pour l&apos;instant.</div>
        ) : (
          <table className="liste">
            <thead>
              <tr>
                <th>Nom</th>
                <th>Politique</th>
                <th>Membres</th>
                <th style={{ width: 1 }}></th>
              </tr>
            </thead>
            <tbody>
              {(fra.data ?? []).map((f) => (
                <tr key={f.id}>
                  <td colSpan={2} style={{ padding: 0 }}>
                    <form
                      action={enregistrerFratrie}
                      style={{ display: 'flex', gap: 8, alignItems: 'center', padding: '8px 14px' }}
                    >
                      <input type="hidden" name="id" value={f.id} />
                      <input name="nom" defaultValue={f.nom} style={{ flex: 1 }} />
                      <SelectRegroupement valeur={f.regroupement ?? 'ensemble'} />
                      <button className="bouton-secondaire" type="submit" style={{ padding: '6px 12px' }}>
                        Enregistrer
                      </button>
                    </form>
                  </td>
                  <td style={{ color: 'var(--gris)', fontSize: 13 }}>
                    {(membres.get(f.id) ?? []).join(', ') || '—'}
                  </td>
                  <td>
                    <form action={supprimerFratrie}>
                      <input type="hidden" name="id" value={f.id} />
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
      </div>
    </>
  );
}

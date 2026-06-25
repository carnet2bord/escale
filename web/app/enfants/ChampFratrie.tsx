'use client';

import { useState } from 'react';

import { creerFratrieRapide, majRegroupement } from '@/app/fratries/actions';

interface Fra {
  id: number;
  nom: string;
  regroupement?: string;
}

export function ChampFratrie({
  fratries,
  defaultId,
}: {
  fratries: Fra[];
  defaultId?: number | null;
}) {
  const [liste, setListe] = useState<Fra[]>(fratries);
  const [sel, setSel] = useState(defaultId != null ? String(defaultId) : '');

  async function creer() {
    const nom = window.prompt('Nom de la nouvelle fratrie');
    if (!nom || !nom.trim()) return;
    const f = await creerFratrieRapide(nom.trim());
    if (f) {
      setListe([...liste, f].sort((a, b) => a.nom.localeCompare(b.nom)));
      setSel(String(f.id));
    }
  }

  const courante = liste.find((f) => String(f.id) === sel);

  return (
    <div>
      <label>Fratrie</label>
      <div style={{ display: 'flex', gap: 8 }}>
        <select
          name="fratrieId"
          value={sel}
          onChange={(e) => setSel(e.target.value)}
          style={{ flex: 1 }}
        >
          <option value="">— Aucune —</option>
          {liste.map((f) => (
            <option key={f.id} value={f.id}>
              {f.nom}
            </option>
          ))}
        </select>
        <button type="button" className="bouton-secondaire" onClick={creer} style={{ whiteSpace: 'nowrap' }}>
          + Créer
        </button>
      </div>
      {courante ? (
        <div style={{ marginTop: 8 }}>
          <label>En relais, les frères / sœurs…</label>
          <select
            defaultValue={courante.regroupement ?? 'ensemble'}
            onChange={(e) => majRegroupement(courante.id, e.target.value)}
          >
            <option value="ensemble">À garder ensemble</option>
            <option value="separes">À séparer</option>
            <option value="indifferent">Indifférent</option>
          </select>
        </div>
      ) : null}
    </div>
  );
}

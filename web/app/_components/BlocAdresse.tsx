'use client';

import { useState } from 'react';

import { geocoderAdresse } from './geo-action';
import { IcoGeo } from './icons';

interface AvecAdresse {
  adresse?: string | null;
  latitude?: number | null;
  longitude?: number | null;
}

export function BlocAdresse({ entite }: { entite?: AvecAdresse }) {
  const [adresse, setAdresse] = useState(entite?.adresse ?? '');
  const [lat, setLat] = useState(entite?.latitude != null ? String(entite.latitude) : '');
  const [lon, setLon] = useState(entite?.longitude != null ? String(entite.longitude) : '');
  const [busy, setBusy] = useState(false);
  const [msg, setMsg] = useState('');

  async function geocoder() {
    if (adresse.trim().length < 3) return;
    setBusy(true);
    setMsg('');
    const c = await geocoderAdresse(adresse);
    setBusy(false);
    if (c) {
      setLat(c.latitude.toFixed(6));
      setLon(c.longitude.toFixed(6));
      setMsg('Coordonnées trouvées via la BAN.');
    } else {
      setMsg('Adresse introuvable (BAN).');
    }
  }

  return (
    <div style={{ marginTop: 16, borderTop: '1px solid var(--filet)', paddingTop: 12 }}>
      <h2 style={{ margin: '0 0 4px', fontSize: 15 }}>Adresse &amp; localisation</h2>
      <label>Adresse</label>
      <input
        name="adresse"
        value={adresse}
        onChange={(e) => setAdresse(e.target.value)}
        placeholder="N°, rue, code postal, ville"
      />
      <div className="ligne" style={{ alignItems: 'end', marginTop: 10 }}>
        <div>
          <label>Latitude</label>
          <input name="latitude" value={lat} onChange={(e) => setLat(e.target.value)} placeholder="ex. 48.8566" />
        </div>
        <div>
          <label>Longitude</label>
          <input name="longitude" value={lon} onChange={(e) => setLon(e.target.value)} placeholder="ex. 2.3522" />
        </div>
        <div style={{ flex: '0 0 auto' }}>
          <button
            type="button"
            className="bouton-secondaire"
            onClick={geocoder}
            disabled={busy}
            style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}
          >
            <IcoGeo /> {busy ? 'Recherche…' : 'Géocoder'}
          </button>
        </div>
      </div>
      {msg ? <p style={{ color: 'var(--gris)', fontSize: 12, marginTop: 6 }}>{msg}</p> : null}
      <p style={{ color: 'var(--gris)', fontSize: 12, marginTop: 4 }}>
        Le géocodage envoie l&apos;adresse à la BAN (data.gouv.fr) — données
        fictives tant que le DPO n&apos;a pas validé. Le calcul des distances reste local.
      </p>
    </div>
  );
}

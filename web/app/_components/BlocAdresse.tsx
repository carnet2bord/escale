// Bloc adresse + coordonnées, partagé par les fiches accueillant et enfant.
// Le géocodage (BAN) est optionnel ; les coordonnées peuvent être saisies à la
// main. Le calcul de distance se fait ensuite localement.

interface AvecAdresse {
  adresse?: string | null;
  latitude?: number | null;
  longitude?: number | null;
}

export function BlocAdresse({ entite }: { entite?: AvecAdresse }) {
  const aCoords = entite?.latitude != null && entite?.longitude != null;
  return (
    <div style={{ marginTop: 16, borderTop: '1px solid var(--filet)', paddingTop: 12 }}>
      <h2 style={{ margin: '0 0 4px', fontSize: 15 }}>Adresse &amp; localisation</h2>
      <label>Adresse</label>
      <input
        name="adresse"
        defaultValue={entite?.adresse ?? ''}
        placeholder="N°, rue, code postal, ville"
      />
      <label style={{ display: 'flex', gap: 8, alignItems: 'center', marginTop: 10 }}>
        <input
          type="checkbox"
          name="geocoder"
          defaultChecked={!aCoords}
          style={{ width: 'auto' }}
        />
        Géocoder l&apos;adresse automatiquement (BAN) à l&apos;enregistrement
      </label>
      <div className="ligne">
        <div>
          <label>Latitude</label>
          <input
            name="latitude"
            type="number"
            step="any"
            defaultValue={entite?.latitude ?? ''}
            placeholder="ex. 48.8566"
          />
        </div>
        <div>
          <label>Longitude</label>
          <input
            name="longitude"
            type="number"
            step="any"
            defaultValue={entite?.longitude ?? ''}
            placeholder="ex. 2.3522"
          />
        </div>
      </div>
      <p style={{ color: 'var(--gris)', fontSize: 12, marginTop: 4 }}>
        Le géocodage envoie l&apos;adresse à la BAN (data.gouv.fr) — données
        fictives tant que le DPO n&apos;a pas validé. Vous pouvez aussi saisir les
        coordonnées à la main. Le calcul des distances reste local.
      </p>
    </div>
  );
}

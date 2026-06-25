// Avatar, Pastille, EmptyState — réplique des widgets desktop (lib/ui/widgets.dart).

export function Avatar({ initiale, couleur = 'var(--teal)' }: { initiale: string; couleur?: string }) {
  return (
    <div
      style={{
        width: 42,
        height: 42,
        flexShrink: 0,
        borderRadius: '50%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontWeight: 700,
        color: couleur,
        background: `color-mix(in srgb, ${couleur} 14%, transparent)`,
      }}
    >
      {initiale}
    </div>
  );
}

export function Pastille({
  texte,
  couleur,
  icone,
}: {
  texte: string;
  couleur: string;
  icone?: React.ReactNode;
}) {
  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 5,
        padding: '5px 10px',
        borderRadius: 8,
        fontSize: 12,
        fontWeight: 600,
        color: couleur,
        background: `color-mix(in srgb, ${couleur} 12%, transparent)`,
        border: `1px solid color-mix(in srgb, ${couleur} 28%, transparent)`,
      }}
    >
      {icone}
      {texte}
    </span>
  );
}

export function EmptyState({
  icone,
  titre,
  sousTitre,
  action,
}: {
  icone: React.ReactNode;
  titre: string;
  sousTitre?: string;
  action?: React.ReactNode;
}) {
  return (
    <div style={{ maxWidth: 420, margin: '40px auto', textAlign: 'center', padding: 32 }}>
      <div
        style={{
          width: 72,
          height: 72,
          margin: '0 auto',
          borderRadius: '50%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          color: 'var(--teal)',
          background: 'color-mix(in srgb, var(--teal) 14%, transparent)',
        }}
      >
        {icone}
      </div>
      <div style={{ marginTop: 20, fontSize: 17, fontWeight: 600 }}>{titre}</div>
      {sousTitre ? (
        <div style={{ marginTop: 6, color: 'var(--gris)', fontSize: 13.5 }}>{sousTitre}</div>
      ) : null}
      {action ? <div style={{ marginTop: 20 }}>{action}</div> : null}
    </div>
  );
}

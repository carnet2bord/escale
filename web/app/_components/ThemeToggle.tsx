'use client';

import { useState } from 'react';

const LUNE = (
  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2">
    <path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z" strokeLinejoin="round" />
  </svg>
);
const SOLEIL = (
  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
    <circle cx="12" cy="12" r="4" />
    <path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" />
  </svg>
);

export function ThemeToggle({
  initialSombre,
  compact,
}: {
  initialSombre: boolean;
  compact?: boolean;
}) {
  const [sombre, setSombre] = useState(initialSombre);
  function bascule() {
    const next = sombre ? 'clair' : 'sombre';
    document.documentElement.dataset.theme = next;
    document.cookie = `escale_theme=${next}; path=/; max-age=31536000; samesite=lax`;
    setSombre(!sombre);
  }
  if (compact) {
    return (
      <button
        type="button"
        className="outils-bouton"
        onClick={bascule}
        title={sombre ? 'Thème clair' : 'Thème sombre'}
        aria-label={sombre ? 'Thème clair' : 'Thème sombre'}
      >
        {sombre ? SOLEIL : LUNE}
      </button>
    );
  }
  return (
    <button
      type="button"
      className="lien-deco"
      onClick={bascule}
      style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 12px', width: '100%' }}
    >
      {sombre ? SOLEIL : LUNE}
      {sombre ? 'Mode clair' : 'Mode nuit'}
    </button>
  );
}

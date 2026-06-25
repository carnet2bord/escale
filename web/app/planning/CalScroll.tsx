'use client';

import { useEffect, useRef } from 'react';

// Conteneur défilant du calendrier : positionne la frise sur aujourd'hui au
// premier rendu (comme le jumpTo desktop).
export function CalScroll({ scrollTo, children }: { scrollTo: number; children: React.ReactNode }) {
  const ref = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (ref.current) ref.current.scrollLeft = Math.max(0, scrollTo - 240);
  }, [scrollTo]);
  return (
    <div
      ref={ref}
      style={{
        overflowX: 'auto',
        border: '1px solid var(--filet)',
        borderRadius: 12,
        background: 'var(--surface)',
      }}
    >
      {children}
    </div>
  );
}

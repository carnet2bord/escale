// Icônes outline reprenant les icônes Material utilisées par l'app desktop.
// (Aucun émoji — on s'en tient aux icônes existantes du desktop.)

type P = { size?: number };
const svg = (size: number, children: React.ReactNode, filled = false) => (
  <svg
    viewBox="0 0 24 24"
    width={size}
    height={size}
    fill={filled ? 'currentColor' : 'none'}
    stroke={filled ? 'none' : 'currentColor'}
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    {children}
  </svg>
);

export const IcoSearch = ({ size = 18 }: P) => svg(size, <><circle cx="11" cy="11" r="7" /><path d="M21 21l-4.3-4.3" /></>);
export const IcoAdd = ({ size = 18 }: P) => svg(size, <path d="M12 5v14M5 12h14" />);
export const IcoEdit = ({ size = 18 }: P) => svg(size, <><path d="M4 20h4L18.5 9.5a2.1 2.1 0 0 0-3-3L5 17v3z" /><path d="M13.5 6.5l3 3" /></>);
export const IcoDelete = ({ size = 18 }: P) => svg(size, <><path d="M4 7h16M9 7V5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2" /><path d="M6 7l1 13h10l1-13" /></>);
export const IcoPdf = ({ size = 18 }: P) => svg(size, <><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z" /><path d="M14 3v5h5" /></>);
export const IcoSeat = ({ size = 14 }: P) => svg(size, <><path d="M6 9V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v4" /><path d="M5 9h12a2 2 0 0 1 2 2v4H5z" /><path d="M5 19v-4M17 19v-4" /></>);
export const IcoWc = ({ size = 14 }: P) => svg(size, <><circle cx="8" cy="4" r="1.6" /><path d="M6 21v-6H4l2-5h4l2 5h-2v6z" /><circle cx="17" cy="4" r="1.6" /><path d="M15 21v-5M19 21v-5M15.5 16h3l1-6h-5z" /></>);
export const IcoMale = ({ size = 14 }: P) => svg(size, <><circle cx="10" cy="14" r="5" /><path d="M14 10l6-6M15 4h5v5" /></>);
export const IcoFemale = ({ size = 14 }: P) => svg(size, <><circle cx="12" cy="8" r="5" /><path d="M12 13v8M9 18h6" /></>);
export const IcoCake = ({ size = 14 }: P) => svg(size, <><path d="M4 20h16v-7a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2z" /><path d="M4 15c2 1.5 4-1.5 8 0s4 1.5 8 0M12 8V5M9 8V6.5M15 8V6.5" /></>);
export const IcoHome = ({ size = 34 }: P) => svg(size, <><path d="M4 11l8-6 8 6" /><path d="M6 10v9h12v-9" /></>);
export const IcoChild = ({ size = 34 }: P) => svg(size, <><circle cx="12" cy="6" r="3" /><path d="M6 21v-3a6 6 0 0 1 12 0v3" /></>);
export const IcoCalendar = ({ size = 34 }: P) => svg(size, <><rect x="3" y="4.5" width="18" height="16" rx="2" /><path d="M3 9h18M8 2.5v4M16 2.5v4" /></>);
export const IcoCar = ({ size = 14 }: P) => svg(size, <><path d="M5 11l1.5-4.5A2 2 0 0 1 8.4 5h7.2a2 2 0 0 1 1.9 1.5L19 11" /><path d="M3 11h18v5H3z" /><circle cx="7.5" cy="16.5" r="1.5" /><circle cx="16.5" cy="16.5" r="1.5" /></>);
export const IcoMore = ({ size = 20 }: P) => svg(size, <><circle cx="12" cy="5" r="1.6" /><circle cx="12" cy="12" r="1.6" /><circle cx="12" cy="19" r="1.6" /></>, true);
export const IcoCheck = ({ size = 18 }: P) => svg(size, <><circle cx="12" cy="12" r="9" /><path d="M8.5 12l2.5 2.5 4.5-4.5" /></>);
export const IcoTask = ({ size = 18 }: P) => svg(size, <><path d="M9 11l3 3 8-8" /><path d="M20 12v6a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h9" /></>);
export const IcoBlock = ({ size = 18 }: P) => svg(size, <><circle cx="12" cy="12" r="9" /><path d="M5.6 5.6l12.8 12.8" /></>);
export const IcoRestore = ({ size = 18 }: P) => svg(size, <><path d="M3 12a9 9 0 1 0 3-6.7L3 8" /><path d="M3 4v4h4" /><path d="M12 8v4l3 2" /></>);
export const IcoCopy = ({ size = 18 }: P) => svg(size, <><rect x="9" y="9" width="11" height="11" rx="2" /><path d="M5 15V5a2 2 0 0 1 2-2h8" /></>);
export const IcoDescription = ({ size = 18 }: P) => svg(size, <><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z" /><path d="M14 3v5h5M8 13h8M8 17h6" /></>);
export const IcoAlert = ({ size = 22 }: P) => svg(size, <><circle cx="12" cy="12" r="9" /><path d="M12 8v5M12 16h.01" /></>);
export const IcoWarning = ({ size = 22 }: P) => svg(size, <><path d="M12 4l9 16H3z" /><path d="M12 10v4M12 17h.01" /></>);
export const IcoOk = ({ size = 22 }: P) => svg(size, <><circle cx="12" cy="12" r="9" /><path d="M8.5 12l2.5 2.5 4.5-4.5" /></>);
export const IcoSparkles = ({ size = 18 }: P) => svg(size, <><path d="M12 3l1.8 4.2L18 9l-4.2 1.8L12 15l-1.8-4.2L6 9l4.2-1.8z" /><path d="M18 14l.9 2.1L21 17l-2.1.9L18 20l-.9-2.1L15 17l2.1-.9z" /></>);
export const IcoList = ({ size = 18 }: P) => svg(size, <><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01" /></>);
export const IcoCalWeek = ({ size = 18 }: P) => svg(size, <><rect x="3" y="4.5" width="18" height="16" rx="2" /><path d="M3 9h18M8 13h2M14 13h2M8 17h2" /></>);
export const IcoGeo = ({ size = 18 }: P) => svg(size, <><circle cx="11" cy="11" r="7" /><path d="M11 7v8M7 11h8M21 21l-4.3-4.3" /></>);

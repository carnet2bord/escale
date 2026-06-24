import { chargerSnapshot } from '@/lib/data';
import { ficheData } from '@/lib/pdf/data';
import { pdfFicheLiaison } from '@/lib/pdf/documents';
import { lireInfosStructure } from '@/lib/reglages';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function GET(
  _req: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  const [snap, struct] = await Promise.all([chargerSnapshot(), lireInfosStructure()]);
  const d = ficheData(snap, struct, Number(id));
  if (!d) return new Response('Relais introuvable', { status: 404 });
  const buf = await pdfFicheLiaison(d);
  return new Response(new Uint8Array(buf), {
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': `inline; filename="fiche-liaison-${id}.pdf"`,
    },
  });
}

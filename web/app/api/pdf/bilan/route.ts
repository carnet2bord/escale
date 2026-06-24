import { chargerSnapshot } from '@/lib/data';
import { bilanData } from '@/lib/pdf/data';
import { pdfBilan } from '@/lib/pdf/documents';
import { lireInfosStructure } from '@/lib/reglages';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function GET() {
  const [snap, struct] = await Promise.all([chargerSnapshot(), lireInfosStructure()]);
  const buf = await pdfBilan(bilanData(snap, struct));
  return new Response(new Uint8Array(buf), {
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'inline; filename="bilan-escale.pdf"',
    },
  });
}

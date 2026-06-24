import { chargerSnapshot } from '@/lib/data';
import { bilanData } from '@/lib/pdf/data';
import { pdfBilan } from '@/lib/pdf/documents';
import { lireInfosStructure } from '@/lib/reglages';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function GET(req: Request) {
  const anon = new URL(req.url).searchParams.get('anon') === '1';
  const [snap, struct] = await Promise.all([chargerSnapshot(), lireInfosStructure()]);
  const buf = await pdfBilan(bilanData(snap, struct, anon));
  return new Response(new Uint8Array(buf), {
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'inline; filename="bilan-escale.pdf"',
    },
  });
}

import { pdfRegistre } from '@/lib/pdf/documents';
import { lireInfosStructure } from '@/lib/reglages';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function GET() {
  const structure = await lireInfosStructure();
  const buf = await pdfRegistre({ structure });
  return new Response(new Uint8Array(buf), {
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'inline; filename="registre-traitements.pdf"',
    },
  });
}

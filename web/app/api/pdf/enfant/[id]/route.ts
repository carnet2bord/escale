import { chargerSnapshot } from '@/lib/data';
import { planningEnfantData } from '@/lib/pdf/data';
import { pdfPlanning } from '@/lib/pdf/documents';
import { lireInfosStructure } from '@/lib/reglages';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function GET(
  req: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  const anon = new URL(req.url).searchParams.get('anon') === '1';
  const [snap, struct] = await Promise.all([chargerSnapshot(), lireInfosStructure()]);
  const d = planningEnfantData(snap, struct, Number(id), anon);
  if (!d) return new Response('Enfant introuvable', { status: 404 });
  const buf = await pdfPlanning(d);
  return new Response(new Uint8Array(buf), {
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': `inline; filename="parcours-enfant-${id}.pdf"`,
    },
  });
}

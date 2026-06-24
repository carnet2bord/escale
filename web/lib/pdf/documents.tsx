// Modèles de documents PDF (rendu serveur via @react-pdf/renderer).
// Les route handlers préparent les données ; ici on ne fait que la mise en page.

import fs from 'node:fs';
import path from 'node:path';

import {
  Document,
  Font,
  Page,
  StyleSheet,
  Text,
  View,
  renderToBuffer,
} from '@react-pdf/renderer';
import React, { type ReactElement } from 'react';

const TEAL = '#156f6c';
const GRIS = '#5a6168';
const FILET = '#dde1e4';

// Police Unicode Inter (couvre latin étendu, vietnamien, cyrillique…). Repli
// sur Helvetica (Latin-1) si les fichiers manquent dans le déploiement.
const FONT_DIR = path.join(process.cwd(), 'public', 'fonts');
const FONT_REGULAR = path.join(FONT_DIR, 'Inter-Regular.ttf');
const FONT_BOLD = path.join(FONT_DIR, 'Inter-Bold.ttf');
const policeOk = (() => {
  try {
    if (!fs.existsSync(FONT_REGULAR) || !fs.existsSync(FONT_BOLD)) return false;
    Font.register({
      family: 'Inter',
      fonts: [
        { src: FONT_REGULAR },
        { src: FONT_BOLD, fontWeight: 'bold' },
      ],
    });
    return true;
  } catch {
    return false;
  }
})();
const FAMILLE = policeOk ? 'Inter' : 'Helvetica';

// La police par défaut (Helvetica/WinAnsi) ne gère que le Latin-1. On remplace
// la ponctuation typographique, puis on translittère les caractères hors
// Latin-1 (ł, ş, vietnamien, cyrillique…) pour éviter les « tofu ».
// Évolution possible : embarquer une police Unicode (Noto Sans) via Font.register.
function safe(v: string | null | undefined): string {
  if (!v) return '';
  const base = v
    .replace(/[—–]/g, '-')
    .replace(/→/g, '->')
    .replace(/…/g, '...')
    .replace(/[‘’]/g, "'")
    .replace(/[“”]/g, '"')
    .replace(/ /g, ' ');
  if (policeOk) return base; // Inter gère l'Unicode, pas de translittération
  return Array.from(base)
    .map((ch) => {
      if (ch.charCodeAt(0) <= 0xff) return ch;
      const decomp = ch.normalize('NFKD').replace(/[̀-ͯ]/g, '');
      const garde = Array.from(decomp).filter((c) => c.charCodeAt(0) <= 0xff).join('');
      return garde || '?';
    })
    .join('');
}

const styles = StyleSheet.create({
  page: { padding: 40, fontSize: 10, color: '#1a1c1e', fontFamily: FAMILLE },
  enTete: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    borderBottomWidth: 1,
    borderBottomColor: FILET,
    paddingBottom: 8,
    marginBottom: 16,
  },
  structureNom: { fontSize: 13, fontWeight: 'bold', color: TEAL },
  structureAdresse: { fontSize: 9, color: GRIS, marginTop: 2 },
  marque: { fontSize: 11, fontWeight: 'bold', color: TEAL },
  titre: { fontSize: 16, fontWeight: 'bold', marginBottom: 12 },
  sousTitre: { fontSize: 9, color: GRIS, marginBottom: 14 },
  section: { marginBottom: 12 },
  sectionTitre: {
    fontSize: 11,
    fontWeight: 'bold',
    color: TEAL,
    marginBottom: 4,
  },
  ligneChamp: { flexDirection: 'row', marginBottom: 2 },
  label: { width: 130, color: GRIS },
  valeur: { flex: 1 },
  encadre: {
    borderWidth: 1,
    borderColor: FILET,
    backgroundColor: '#f6f8f8',
    borderRadius: 4,
    padding: 8,
  },
  tableEntete: {
    flexDirection: 'row',
    backgroundColor: '#eaf3f1',
    paddingVertical: 4,
    paddingHorizontal: 4,
  },
  tableLigne: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: FILET,
    paddingVertical: 4,
    paddingHorizontal: 4,
  },
  th: { fontWeight: 'bold', color: TEAL, fontSize: 9 },
  signatures: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 30 },
  blocSignature: { width: '45%' },
  ligneSignature: {
    borderTopWidth: 1,
    borderTopColor: '#9aa0a6',
    marginTop: 36,
    paddingTop: 3,
    fontSize: 9,
    color: GRIS,
  },
  pied: {
    position: 'absolute',
    bottom: 24,
    left: 40,
    right: 40,
    borderTopWidth: 1,
    borderTopColor: FILET,
    paddingTop: 6,
    fontSize: 8,
    color: GRIS,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
});

export interface Struct {
  nom: string;
  adresse: string;
  signataire: string;
  mention: string;
}

function EnTete({ structure }: { structure: Struct }) {
  return (
    <View style={styles.enTete}>
      <View>
        {structure.nom ? (
          <Text style={styles.structureNom}>{safe(structure.nom)}</Text>
        ) : (
          <Text style={styles.marque}>Escale</Text>
        )}
        {structure.adresse ? (
          <Text style={styles.structureAdresse}>{safe(structure.adresse)}</Text>
        ) : null}
      </View>
      <Text style={styles.marque}>Escale</Text>
    </View>
  );
}

function Pied({ mention }: { mention: string }) {
  return (
    <View style={styles.pied} fixed>
      <Text>{safe(mention) || 'Document confidentiel'}</Text>
      <Text
        render={({ pageNumber, totalPages }) => `${pageNumber} / ${totalPages}`}
      />
    </View>
  );
}

function Champ({ label, valeur }: { label: string; valeur: string }) {
  return (
    <View style={styles.ligneChamp}>
      <Text style={styles.label}>{label}</Text>
      <Text style={styles.valeur}>{safe(valeur)}</Text>
    </View>
  );
}

// --- Fiche de liaison (par relais) ---

export interface FicheData {
  structure: Struct;
  enfant: {
    nom: string;
    sexe: string;
    age: string;
    secteur: string;
    afHabituel: string;
    sante: string;
    contactUrgence: string;
  };
  accueillant: { nom: string; places: string; secteur: string };
  periode: string;
  transport: string;
}

export function FicheLiaison({ d }: { d: FicheData }) {
  return (
    <Document>
      <Page size="A4" style={styles.page}>
        <EnTete structure={d.structure} />
        <Text style={styles.titre}>Fiche de liaison — accueil relais</Text>

        <View style={styles.section}>
          <Text style={styles.sectionTitre}>Enfant accueilli</Text>
          <Champ label="Nom" valeur={d.enfant.nom} />
          <Champ label="Sexe" valeur={d.enfant.sexe} />
          <Champ label="Age" valeur={d.enfant.age} />
          {d.enfant.secteur ? <Champ label="Secteur" valeur={d.enfant.secteur} /> : null}
          {d.enfant.afHabituel ? (
            <Champ label="Assistant familial" valeur={d.enfant.afHabituel} />
          ) : null}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitre}>Accueillant désigné</Text>
          <Champ label="Nom" valeur={d.accueillant.nom} />
          {d.accueillant.secteur ? (
            <Champ label="Secteur" valeur={d.accueillant.secteur} />
          ) : null}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitre}>Période du relais</Text>
          <Champ label="Période" valeur={d.periode} />
          {d.transport ? <Champ label="Transport" valeur={d.transport} /> : null}
        </View>

        {d.enfant.sante || d.enfant.contactUrgence ? (
          <View style={styles.section}>
            <Text style={styles.sectionTitre}>Informations importantes</Text>
            <View style={styles.encadre}>
              {d.enfant.contactUrgence ? (
                <Champ label="Contact d'urgence" valeur={d.enfant.contactUrgence} />
              ) : null}
              {d.enfant.sante ? <Champ label="Santé" valeur={d.enfant.sante} /> : null}
            </View>
          </View>
        ) : null}

        <View style={styles.signatures}>
          <View style={styles.blocSignature}>
            <Text>{safe(d.structure.signataire) || 'Pour la structure'}</Text>
            <Text style={styles.ligneSignature}>Signature</Text>
          </View>
          <View style={styles.blocSignature}>
            <Text>L'accueillant : {safe(d.accueillant.nom)}</Text>
            <Text style={styles.ligneSignature}>Signature</Text>
          </View>
        </View>

        <Pied mention={d.structure.mention} />
      </Page>
    </Document>
  );
}

// --- Bilan d'activité ---

export interface BilanData {
  structure: Struct;
  nbEnfants: number;
  nbAccueillants: number;
  nbRelais: number;
  couverturePct: number | null;
  couvertureTexte: string;
  charges: { nom: string; nbRelais: number; nbJours: number }[];
}

export function Bilan({ d }: { d: BilanData }) {
  return (
    <Document>
      <Page size="A4" style={styles.page}>
        <EnTete structure={d.structure} />
        <Text style={styles.titre}>Bilan d'activité</Text>

        <View style={styles.section}>
          <Champ label="Enfants" valeur={String(d.nbEnfants)} />
          <Champ label="Accueillants" valeur={String(d.nbAccueillants)} />
          <Champ label="Relais planifiés" valeur={String(d.nbRelais)} />
          <Champ
            label="Couverture des besoins"
            valeur={
              d.couverturePct == null
                ? 'Aucun besoin recensé'
                : `${d.couverturePct} % (${d.couvertureTexte})`
            }
          />
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitre}>Charge par accueillant</Text>
          <View style={styles.tableEntete}>
            <Text style={[styles.th, { flex: 3 }]}>Accueillant</Text>
            <Text style={[styles.th, { flex: 1 }]}>Relais</Text>
            <Text style={[styles.th, { flex: 1 }]}>Jours</Text>
          </View>
          {d.charges.length === 0 ? (
            <Text style={{ color: GRIS, marginTop: 6 }}>Aucun relais.</Text>
          ) : (
            d.charges.map((c, i) => (
              <View style={styles.tableLigne} key={i}>
                <Text style={{ flex: 3 }}>{safe(c.nom)}</Text>
                <Text style={{ flex: 1 }}>{c.nbRelais}</Text>
                <Text style={{ flex: 1 }}>{c.nbJours}</Text>
              </View>
            ))
          )}
        </View>

        <Pied mention={d.structure.mention} />
      </Page>
    </Document>
  );
}

// --- Planning / parcours (par accueillant ou par enfant) ---

export interface PlanningData {
  structure: Struct;
  titre: string;
  colonneLieu: string; // "Enfant" ou "Lieu / accueillant"
  lignes: { periode: string; lieu: string; info: string }[];
}

export function Planning({ d }: { d: PlanningData }) {
  return (
    <Document>
      <Page size="A4" style={styles.page}>
        <EnTete structure={d.structure} />
        <Text style={styles.titre}>{safe(d.titre)}</Text>

        <View style={styles.tableEntete}>
          <Text style={[styles.th, { flex: 2 }]}>Période</Text>
          <Text style={[styles.th, { flex: 2 }]}>{safe(d.colonneLieu)}</Text>
          <Text style={[styles.th, { flex: 2 }]}>Détail</Text>
        </View>
        {d.lignes.length === 0 ? (
          <Text style={{ color: GRIS, marginTop: 6 }}>Aucun relais.</Text>
        ) : (
          d.lignes.map((l, i) => (
            <View style={styles.tableLigne} key={i}>
              <Text style={{ flex: 2 }}>{safe(l.periode)}</Text>
              <Text style={{ flex: 2 }}>{safe(l.lieu)}</Text>
              <Text style={{ flex: 2 }}>{safe(l.info)}</Text>
            </View>
          ))
        )}

        <Pied mention={d.structure.mention} />
      </Page>
    </Document>
  );
}

// --- Registre des traitements (RGPD) ---

export interface RegistreData {
  structure: Struct;
}

function BlocRegistre({ titre, texte }: { titre: string; texte: string }) {
  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitre}>{titre}</Text>
      <Text>{safe(texte)}</Text>
    </View>
  );
}

export function Registre({ d }: { d: RegistreData }) {
  const responsable = d.structure.nom || 'La structure';
  return (
    <Document>
      <Page size="A4" style={styles.page}>
        <EnTete structure={d.structure} />
        <Text style={styles.titre}>Registre des traitements de données</Text>
        <Text style={styles.sousTitre}>
          Traitement « Organisation des relais d'accueil familial »
        </Text>

        <BlocRegistre
          titre="Responsable du traitement"
          texte={`${responsable}${d.structure.signataire ? ` — ${d.structure.signataire}` : ''}`}
        />
        <BlocRegistre
          titre="Finalité"
          texte="Organiser les accueils relais (placements temporaires d'enfants chez des assistants familiaux accueillants pendant l'indisponibilité de leur assistant familial habituel)."
        />
        <BlocRegistre
          titre="Base légale"
          texte="Mission d'intérêt public relevant de la protection de l'enfance."
        />
        <BlocRegistre
          titre="Catégories de personnes concernées"
          texte="Enfants accueillis et assistants familiaux (habituels et accueillants)."
        />
        <BlocRegistre
          titre="Catégories de données"
          texte="Identité, sexe, date de naissance, secteur géographique, périodes d'accueil et de besoin, données de santé (allergies, traitements), contacts d'urgence, liens de fratrie et incompatibilités."
        />
        <BlocRegistre
          titre="Destinataires"
          texte="Personnel habilité du service, dans la limite de ses attributions."
        />
        <BlocRegistre
          titre="Durée de conservation"
          texte={
            d.structure.mention ||
            "À définir par la structure selon ses obligations légales ; purge/anonymisation des dossiers clos."
          }
        />
        <BlocRegistre
          titre="Mesures de sécurité"
          texte="Accès par mot de passe partagé, transport chiffré (HTTPS), hébergement de données de santé (HDS), chiffrement au repos de la base, journal d'audit des écritures."
        />
        <BlocRegistre
          titre="Droits des personnes"
          texte="Information des représentants légaux ; droits d'accès, de rectification et d'effacement exercés auprès du responsable du traitement."
        />

        <Pied mention={d.structure.mention} />
      </Page>
    </Document>
  );
}

async function rendre(doc: ReactElement): Promise<Buffer> {
  return await renderToBuffer(doc as Parameters<typeof renderToBuffer>[0]);
}

// Helpers de rendu (les route handlers restent en .ts, sans JSX).
export const pdfFicheLiaison = (d: FicheData): Promise<Buffer> =>
  rendre(<FicheLiaison d={d} />);
export const pdfBilan = (d: BilanData): Promise<Buffer> => rendre(<Bilan d={d} />);
export const pdfPlanning = (d: PlanningData): Promise<Buffer> =>
  rendre(<Planning d={d} />);
export const pdfRegistre = (d: RegistreData): Promise<Buffer> =>
  rendre(<Registre d={d} />);

import Link from 'next/link';

export const dynamic = 'force-static';

export const metadata = { title: 'Guide des testeurs — Escale' };

function Etape({ n, titre, children }: { n: number; titre: string; children: React.ReactNode }) {
  return (
    <div style={{ display: 'flex', gap: 14, marginBottom: 18 }}>
      <div
        style={{
          flexShrink: 0,
          width: 30,
          height: 30,
          borderRadius: 15,
          background: 'var(--teal)',
          color: '#fff',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontWeight: 700,
        }}
      >
        {n}
      </div>
      <div>
        <strong>{titre}</strong>
        <div style={{ color: 'var(--gris)', marginTop: 2 }}>{children}</div>
      </div>
    </div>
  );
}

export default function Guide() {
  return (
    <div style={{ maxWidth: 760, margin: '0 auto', padding: '32px 20px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <span className="marque">Escale</span>
        <Link className="bouton" href="/login">
          Se connecter
        </Link>
      </div>

      <h1>Guide des testeurs</h1>
      <p style={{ color: 'var(--gris)' }}>
        Escale aide à organiser les <strong>relais d&apos;accueil familial</strong> :
        placer temporairement un enfant chez un assistant familial « accueillant »
        quand son assistant familial habituel est indisponible.
      </p>

      <div
        className="banniere"
        style={{ background: '#fff4e5', color: '#8a5300', border: '1px solid #f0c98a' }}
      >
        ⚠ <strong>Données fictives uniquement.</strong> Tant que le délégué à la
        protection des données (DPO) n&apos;a pas validé la mise en ligne, n&apos;entrez
        aucune donnée réelle concernant un enfant ou une famille.
      </div>

      <h2>Se connecter</h2>
      <p>
        Ouvrez l&apos;adresse fournie et saisissez le <strong>mot de passe partagé</strong>{' '}
        communiqué par votre administrateur. La session reste ouverte 12 heures.
      </p>

      <h2>Le parcours en 4 étapes</h2>
      <Etape n={1} titre="Renseigner les accueillants">
        Menu <em>Accueillants</em> → <em>Nouvel accueillant</em>. Indiquez le nombre
        de places, l&apos;éventuelle restriction (n&apos;accueille que des garçons / des
        filles), le secteur. Sur sa fiche, ajoutez ses{' '}
        <strong>disponibilités d&apos;accueil</strong> et ses indisponibilités (congés).
      </Etape>
      <Etape n={2} titre="Renseigner les enfants">
        Menu <em>Enfants</em> → <em>Nouvel enfant</em>. Sur sa fiche, ajoutez ses{' '}
        <strong>besoins de relais</strong> (les périodes à couvrir), et au besoin la
        fratrie, les incompatibilités, les accueillants favoris/à éviter et les
        solutions alternatives (colonie, tiers).
      </Etape>
      <Etape n={3} titre="Proposer les relais">
        Menu <em>Proposition</em>. Le moteur place automatiquement les besoins non
        couverts chez des accueillants disponibles, <strong>sans créer de conflit
        bloquant</strong>. Validez un relais (« Créer ») ou tous d&apos;un coup.
      </Etape>
      <Etape n={4} titre="Consulter le planning">
        Menu <em>Planning</em> (vue Liste ou Calendrier). Vous pouvez changer le
        statut d&apos;un relais (proposé → confirmé → réalisé), voir les éventuelles
        alertes, et éditer les relais.
      </Etape>

      <h2>Importer des données de test rapidement</h2>
      <p>
        Menu <em>Import</em> : chargez un fichier <strong>.csv</strong> (depuis Excel :
        « Enregistrer sous » → CSV). Colonnes reconnues —
      </p>
      <ul style={{ color: 'var(--gris)' }}>
        <li>
          <strong>Accueillants</strong> : nom, prenom, places, restriction
          (garçons/filles), secteur, notes.
        </li>
        <li>
          <strong>Enfants</strong> : nom, prenom, sexe, date de naissance
          (JJ/MM/AAAA ou AAAA-MM-JJ), secteur, notes.
        </li>
      </ul>

      <h2>Documents</h2>
      <p style={{ color: 'var(--gris)' }}>
        Fiche de liaison (depuis le planning), planning par accueillant, parcours par
        enfant, bilan d&apos;activité (tableau de bord). Chaque document a une variante{' '}
        <strong>anonymisée</strong> (initiales) pour un partage sans identités.
      </p>

      <h2>Comprendre les alertes</h2>
      <p style={{ color: 'var(--gris)' }}>
        Un conflit <strong style={{ color: '#c62828' }}>bloquant</strong> (rouge)
        empêche le relais : sexe non accueilli, AF habituel, accueillant « à éviter »,
        indisponibilité, capacité dépassée, incompatibilité, fratrie à séparer… Un{' '}
        <strong style={{ color: '#b26a00' }}>avertissement</strong> (orange) n&apos;empêche
        pas mais signale un point d&apos;attention : tranche d&apos;âge, agrément expirant,
        secteur différent, plafond de jours.
      </p>

      <h2>Confidentialité</h2>
      <p style={{ color: 'var(--gris)' }}>
        Les paramètres regroupent les outils RGPD : <em>journal d&apos;audit</em> (trace
        des modifications), <em>registre des traitements</em> (PDF), et{' '}
        <em>purge des dossiers clos</em> (anonymisation irréversible des enfants dont
        tous les relais sont passés).
      </p>

      <h2>Vos retours</h2>
      <p style={{ color: 'var(--gris)' }}>
        Notez ce qui vous bloque, ce qui manque ou ce qui prête à confusion, et
        transmettez-le à votre référent. Merci !
      </p>

      <p style={{ marginTop: 28 }}>
        <Link className="bouton" href="/login">
          Commencer
        </Link>
      </p>
    </div>
  );
}

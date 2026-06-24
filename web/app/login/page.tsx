import { connexion } from '../actions';

export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ erreur?: string }>;
}) {
  const { erreur } = await searchParams;
  return (
    <div className="connexion">
      <div className="boite">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src="/logo-escale.png" alt="Escale" />
        <p style={{ color: 'var(--gris)', fontSize: 14, marginTop: 0 }}>
          Coordonner les relais d&apos;accueil familial
        </p>
        <form action={connexion}>
          <input
            className="champ"
            type="password"
            name="motDePasse"
            placeholder="Mot de passe"
            autoFocus
            required
          />
          {erreur === 'bloque' ? (
            <div className="erreur">
              Trop de tentatives. Réessayez dans quelques minutes.
            </div>
          ) : erreur ? (
            <div className="erreur">Mot de passe incorrect.</div>
          ) : null}
          <button className="bouton" type="submit" style={{ width: '100%', marginTop: 8 }}>
            Se connecter
          </button>
        </form>
        <p style={{ marginTop: 16, fontSize: 13 }}>
          <a href="/guide">Guide des testeurs</a>
        </p>
      </div>
    </div>
  );
}

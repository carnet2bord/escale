# Escale web — déploiement (Next.js + Supabase auto-hébergé)

Version en ligne d'Escale, à héberger sur **votre serveur dédié / HDS** avec
**Supabase auto-hébergé** (PostgreSQL + API). Accès par **mot de passe unique
partagé**.

> ⚠️ Données sensibles (enfants protégés). N'utilisez que des **données
> fictives** pour les tests tant que votre **DPO** n'a pas validé la mise en
> ligne de vraies données.

## 1. Base de données (Supabase auto-hébergé)

1. Installer Supabase en self-hosting sur le serveur dédié (Docker) :
   voir https://supabase.com/docs/guides/self-hosting/docker
2. Dans le SQL editor de Supabase, exécuter le contenu de
   [`supabase/schema.sql`](supabase/schema.sql) pour créer les tables.
3. Noter l'URL de l'API (`SUPABASE_URL`) et la clé **service_role**.

## 2. Configuration de l'application

```bash
cp .env.example .env
```
Renseigner dans `.env` :
- `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` (étape 1) ;
- `APP_PASSWORD` : le mot de passe partagé des testeurs ;
- `SESSION_SECRET` : une longue chaîne aléatoire (ex. `openssl rand -hex 32`).

## 3. Lancer

```bash
npm install
npm run build
npm run start      # sert sur http://localhost:3000
```
En production, placer l'app derrière un **reverse proxy HTTPS** (Nginx/Caddy)
— le cookie de session est `secure` (HTTPS requis). Idéalement sur le même
réseau interne que Supabase.

## 4. Utilisation

Ouvrir l'URL → saisir le mot de passe partagé → tableau de bord.

## Sécurité / RGPD

- **HTTPS obligatoire.**
- Chiffrement au repos assuré par **PostgreSQL + l'hébergement HDS** (et le
  chiffrement disque du serveur), pas besoin de SQLCipher côté application.
- Accès tracé : table `journal_audit` (à brancher dans les prochaines
  itérations via triggers PostgreSQL).
- Durée de conservation / purge : à mettre en place côté SQL (chantier web).

## Vérifier la logique métier

```bash
npm run test:domaine     # rejoue les cas de conflits / proposition
```

## État

**Fondation livrée** : projet Next.js, schéma, accès par mot de passe, logique
métier (conflits + proposition) portée **et testée**, tableau de bord (compteurs
+ couverture). **À venir** (parité complète) : écrans accueillants / enfants /
planning / proposition / documents PDF / import, et journal d'audit + purge
côté PostgreSQL.

-- Schéma PostgreSQL d'Escale (version web), miroir du modèle desktop (drift v8).
-- À exécuter sur la base Supabase auto-hébergée (SQL editor ou migration).

create table if not exists accueillants (
  id                serial primary key,
  nom               text not null,
  prenom            text not null default '',
  nb_places         int  not null default 1,
  restriction_sexe  text not null default 'aucune', -- aucune | garcon | fille
  age_min           int,
  age_max           int,
  agrement_echeance date,
  plafond_jours_an  int,
  secteur           text,
  adresse           text,
  latitude          double precision,
  longitude         double precision,
  notes             text
);

create table if not exists fratries (
  id            serial primary key,
  nom           text not null,
  regroupement  text not null default 'ensemble'   -- ensemble | separes | indifferent
);

create table if not exists enfants (
  id               serial primary key,
  nom              text not null,
  prenom           text not null default '',
  sexe             text not null default 'garcon',  -- garcon | fille
  date_naissance   date,
  af_habituel_id   int references accueillants(id) on delete set null,
  fratrie_id       int references fratries(id) on delete set null,
  sante            text,
  contact_urgence  text,
  secteur          text,
  adresse          text,
  latitude         double precision,
  longitude        double precision,
  notes            text
);

-- Colonnes adresse/géo ajoutées après coup : idempotent pour bases existantes.
alter table accueillants add column if not exists adresse text;
alter table accueillants add column if not exists latitude double precision;
alter table accueillants add column if not exists longitude double precision;
alter table enfants add column if not exists adresse text;
alter table enfants add column if not exists latitude double precision;
alter table enfants add column if not exists longitude double precision;

create table if not exists disponibilites_accueil (
  id             serial primary key,
  accueillant_id int not null references accueillants(id) on delete cascade,
  debut          date not null,
  fin            date not null
);

create table if not exists indisponibilites (
  id             serial primary key,
  accueillant_id int not null references accueillants(id) on delete cascade,
  debut          date not null,
  fin            date not null,
  motif          text
);

create table if not exists besoins_relais (
  id        serial primary key,
  enfant_id int not null references enfants(id) on delete cascade,
  debut     date not null,
  fin       date not null,
  motif     text
);

create table if not exists affectations (
  id             serial primary key,
  enfant_id      int not null references enfants(id) on delete cascade,
  accueillant_id int not null references accueillants(id) on delete cascade,
  debut          date not null,
  fin            date not null,
  besoin_id      int references besoins_relais(id) on delete set null,
  statut         text not null default 'confirme', -- propose | confirme | realise | annule
  transport      text
);

create table if not exists incompatibilites (
  id          serial primary key,
  enfant_a_id int not null references enfants(id) on delete cascade,
  enfant_b_id int not null references enfants(id) on delete cascade
);

create table if not exists preferences_accueil (
  id             serial primary key,
  enfant_id      int not null references enfants(id) on delete cascade,
  accueillant_id int not null references accueillants(id) on delete cascade,
  type           text not null,  -- favori | exclu
  unique (enfant_id, accueillant_id)  -- un seul choix par couple
);

create table if not exists solutions_alternatives (
  id        serial primary key,
  enfant_id int not null references enfants(id) on delete cascade,
  debut     date not null,
  fin       date not null,
  type      text not null,       -- colonie | tiers | autre
  details   text
);

create table if not exists reglages (
  cle    text primary key,
  valeur text not null default ''
);

-- Journal d'audit : trace des écritures sur les données sensibles.
-- NB : l'auth étant un mot de passe partagé (clé service-role unique), le
-- journal trace l'opération mais pas l'acteur ; les consultations (lectures)
-- ne sont pas tracées. Limite à documenter avec le DPO.
create table if not exists journal_audit (
  id        bigserial primary key,
  horodatage timestamptz not null default now(),
  action    text not null,
  details   text
);
create index if not exists idx_journal_audit_id on journal_audit (id desc);

-- Fonction de journalisation générique (déclenchée APRÈS chaque écriture).
-- Trace l'opération + la table + l'id de la ligne (pas le contenu, pour ne pas
-- recopier de données sensibles en clair dans le journal).
create or replace function journaliser() returns trigger as $$
begin
  insert into journal_audit(action, details)
  values (
    TG_OP || ' ' || TG_TABLE_NAME,
    case when TG_OP = 'DELETE' then 'id=' || old.id else 'id=' || new.id end
  );
  return null;
end;
$$ language plpgsql;

-- Triggers idempotents sur les tables sensibles.
do $$
declare t text;
begin
  foreach t in array array[
    'accueillants', 'enfants', 'fratries', 'affectations', 'besoins_relais',
    'disponibilites_accueil', 'indisponibilites', 'incompatibilites',
    'preferences_accueil', 'solutions_alternatives'
  ]
  loop
    execute format('drop trigger if exists audit_%1$s on %1$s;', t);
    execute format(
      'create trigger audit_%1$s after insert or update or delete on %1$s '
      'for each row execute function journaliser();', t);
  end loop;
end $$;

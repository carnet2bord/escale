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
  notes            text
);

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

-- Journal d'audit (chantier web) : trace des écritures sensibles.
create table if not exists journal_audit (
  id        bigserial primary key,
  horodatage timestamptz not null default now(),
  action    text not null,
  details   text
);

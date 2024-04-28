create sequence coaches_id_seq
    as integer;

alter sequence coaches_id_seq owner to postgres;

create sequence organizers_id_seq
    as integer;

alter sequence organizers_id_seq owner to postgres;

create table country
(
    id   serial
        constraint country_pk
            primary key,
    name varchar(100) not null
);

alter table country
    owner to postgres;

create table organization
(
    id           integer default nextval('"lab3#19".organizers_id_seq'::regclass) not null
        constraint organizers_pk
            primary key,
    name         varchar(100)                                                     not null,
    address      varchar(100),
    phone_number varchar(20),
    email        varchar(50)                                                      not null,
    inn          integer                                                          not null,
    kpp          integer                                                          not null
);

alter table organization
    owner to postgres;

alter sequence organizers_id_seq owned by organization.id;

create table competition
(
    id           serial
        constraint competition_pk
            primary key,
    name         varchar(100) not null,
    stard_date   date         not null,
    end_date     serial,
    address      varchar(100) not null,
    organization integer      not null
        constraint competition_organization_id_fk
            references organization
);

alter table competition
    owner to postgres;

create table perfomance_category
(
    id   serial
        constraint perfomance_category_pk
            primary key,
    name varchar(50) not null
);

alter table perfomance_category
    owner to postgres;

create table coach_specialization
(
    id           serial
        constraint coach_specialization_pk
            primary key,
    name         varchar(50) not null,
    requirements text
);

alter table coach_specialization
    owner to postgres;

create table coach
(
    id             integer default nextval('"lab3#19".coaches_id_seq'::regclass) not null
        constraint coache_pk
            primary key,
    full_name      varchar(100)                                                  not null,
    phone_number   varchar(20),
    specialization integer
        constraint coach_coach_specialization_id_fk
            references coach_specialization
            on update restrict on delete restrict,
    email          varchar(50)                                                   not null,
    age            smallint
);

alter table coach
    owner to postgres;

alter sequence coaches_id_seq owned by coach.id;

create table athelete
(
    id            serial
        constraint athelete_pk
            primary key,
    full_name     varchar(100) not null,
    date_of_birth date         not null,
    category      varchar(50),
    country       integer
        constraint athelete_country_id_fk
            references country,
    weight        integer,
    height        integer,
    coach_id      integer      not null
        constraint athelete_coach_id_fk
            references coach
            on update restrict on delete restrict,
    gender        pg_enum,
    phone_number  varchar(20)
);

alter table athelete
    owner to postgres;

create table perfomance
(
    id          serial
        constraint perfomance_pk
            primary key,
    athlete     integer     not null
        constraint perfomance_athlete_id_fk
            references athelete
            on update restrict on delete restrict,
    competition integer     not null
        constraint perfomance_competition_id_fk
            references competition
            on update restrict on delete restrict,
    date        date        not null,
    result      varchar(50) not null,
    unit        varchar(10),
    category    integer
        constraint perfomance_perfomance_category_id_fk
            references perfomance_category
            on update restrict on delete restrict
);

alter table perfomance
    owner to postgres;

create table result
(
    perfomance_id integer not null
        constraint result_perfomance_id_fk
            references perfomance
            on update restrict on delete restrict,
    place         integer not null
);

alter table result
    owner to postgres;



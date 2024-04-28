create table category
(
    id          serial
        constraint category_pk
            primary key,
    name        varchar(50) not null,
    description text
);

alter table category
    owner to postgres;

create table seller
(
    id           serial
        constraint seller_pk
            primary key,
    name         varchar(50) not null,
    email        varchar(50) not null,
    phone_number varchar(20) not null,
    address      varchar(50) not null,
    inn          integer     not null,
    kpp          integer
);

alter table seller
    owner to postgres;

create table customer
(
    id           serial
        constraint customer_pk
            primary key,
    name         varchar(50) not null,
    phone_number varchar(20) not null,
    email        varchar(50) not null,
    address      varchar(100)
);

alter table customer
    owner to postgres;

create table manufacturer
(
    id           serial
        constraint manufacturer_pk
            primary key,
    name         varchar(50),
    phone_number varchar(20) not null,
    email        varchar(50),
    address      varchar(100),
    inn          integer     not null,
    kpp          integer     not null
);

alter table manufacturer
    owner to postgres;

create table product
(
    id           serial
        constraint product_pk
            primary key,
    name         varchar(50) not null,
    description  text,
    category     integer     not null
        constraint product_category_id_fk
            references category
            on update restrict on delete restrict,
    manufacturer integer     not null
        constraint product_manufacturer_id_fk
            references manufacturer
            on update restrict on delete restrict
);

alter table product
    owner to postgres;

create table sale
(
    id              integer not null
        constraint sale_pk
            primary key,
    customer        integer not null
        constraint sale_customer_id_fk
            references customer
            on update restrict on delete restrict,
    product         integer not null
        constraint sale_product_id_fk
            references product
            on update restrict on delete restrict,
    seller          integer not null
        constraint sale_seller_id_fk
            references seller
            on update restrict on delete restrict,
    price           integer not null,
    date            date    not null,
    type_of_payment pg_enum not null,
    status          pg_enum not null
);

alter table sale
    owner to postgres;



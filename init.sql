create table if not exists host
(
    ID          integer not null
        constraint host_pk
            primary key autoincrement,
    HOST        text,
    PORT        integer,
    USER        text,
    PASSWD      text,
    DESC        text,
    CREATE_TIME text,
    UPDATE_TIME text,
    LOGIN_TIMES integer default 0
);


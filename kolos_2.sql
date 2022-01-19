
-- Przukładowe zadanie z sql , które będzie na kolokwium łatwiejsze
223. 230. 232. 234. 236. 228.


-- Zadanie od Muryjasa 

-- Utworzyć tabelę bazy danych o nazwie Indeks. Tabela powinna zawierać informacje o
--studencie (identyfikator, Nazwisko, imię), przedmiotach (nazwa przedmiotu), z których
--student zdał już swoje egzaminy oraz datę zdanego egzaminu. Lista przedmiotów wraz z
--datami dla danego studenta powinna być kolumną typu tabela zagnieżdżona. Dane w tabeli
--Indeks należy wygenerować na podstawie zawartości tabeli Egzaminy, Studenci oraz
--Przedmioty.

225.
set serveroutput on;
CREATE OR REPLACE TYPE przedmiot_data_typ AS OBJECT(nazwa varchar2(50),
                                                    data_zalicz date
                                                    );

CREATE OR REPLACE TYPE przedmiot_typ IS TABLE OF przedmiot_data_typ;
CREATE TABLE Indeks (id_student varchar2(7) primary key,
                    nazwisko    varchar2(50) not null,
                    imie        varchar2(25) not null,
                    przedmioty  przedmiot_typ
                    )
                    NESTED TABLE przedmioty STORE AS przedmioty_tab;

declare 
coll_stud_courses przedmiot_typ := przedmiot_typ();
CURSOR c1 IS
SELECT
    id_student,
    nazwisko,
    imie
FROM
    studenci; 
    FUNCTION f_create_collection (ids studenci.id_student%TYPE) RETURN przedmiot_typ IS

            CURSOR c2 (
                pids studenci.id_student%TYPE
            ) IS
            SELECT
                nazwa_przedmiot,
                data_egzamin
            FROM
                przedmioty   p
                INNER JOIN egzaminy     e ON p.id_przedmiot = e.id_przedmiot
            WHERE
                upper(zdal) = 'T'
                AND id_student = pids;

            courses_collection przedmiot_typ := przedmiot_typ();
        BEGIN

                for vc2 in c2(ids) loop
                    courses_collection.extend;
                    courses_collection(c2%rowcount) := przedmiot_data_typ(vc2.nazwa_przedmiot, vc2.data_egzamin);
                end loop;
                return courses_collection;
    end f_create_collection;
    BEGIN
        FOR vc1 IN c1 LOOP
            coll_stud_courses := f_create_collection(vc1.id_student);
            insert into indeks values (vc1.id_student, vc1.nazwisko, vc1.imie, coll_stud_courses);
        END LOOP;
    END;




    select id_student, nazwisko, imie, p.nazwa, p.data_zalicz from indeks ind, table(przedmioty) p;

--Utworzyć tabelę bazy danych o nazwie Analityka. Tabela powinna zawierać informacje o
--liczbie egzaminów poszczególnych egzaminatorów w poszczególnych ośrodkach. W tabeli
--utworzyć kolumny opisujące ośrodek (identyfikator oraz nazwa), egzaminatora
--(identyfikator, imię i Nazwisko) oraz liczbę egzaminów egzaminatora w danym ośrodku.
--Dane dotyczące egzaminatora i liczby jego egzaminów należy umieścić w kolumnie,
--będącej tabelą zagnieżdżoną. Wprowadzić dane do tabeli Analityka na podstawie danych
--zgromadzonych w tabelach Egzaminy, Osrodki i Egzaminatorzy. 

228.
    CREATE OR REPLACE TYPE egzaminator_ilosc AS OBJECT( id_egzaminator varchar2(7),
                                                    nazwisko varchar2(50),
                                                    liczba_egzaminow int(7)
                                                    );
    CREATE OR REPLACE TYPE egzaminator_osrodki IS TABLE OF egzaminator_ilosc;
    CREATE TABLE Analityka (
                    id_osrodek varchar2(7) primary key,
                    nazwa   varchar2(50) not null,
                    liczba_odz_egzaminow  egzaminator_osrodki
                    )
                    NESTED TABLE liczba_odz_egzaminow STORE AS egzaminator_osrodki_tab;


    declare
    egza_osrodki_ilosc egzaminator_osrodki := egzaminator_osrodki();
    cursor c1 is select id_osrodek, nazwa_osrodek from osrodki;
    
    Function f_create_count_osrodek( id_osr osrodki.id_osrodek%TYPE) return egzaminator_osrodki is
        count_egzaminator egzaminator_osrodki := egzaminator_osrodki();
        cursor c2 is select g.id_egzaminator, g.nazwisko,
            (select count(*) from egzaminy e where e.id_egzaminator = g.id_egzaminator and e.id_osrodek =  id_osr) LiczbaEgza
        from 
            egzaminatorzy g;
     begin
        for vc2 in c2 loop
            count_egzaminator.extend;
            count_egzaminator(c2%rowcount) := egzaminator_ilosc(vc2.id_egzaminator, vc2.nazwisko, vc2.LiczbaEgza);
            end loop;
        return count_egzaminator;
    end f_create_count_osrodek;
begin
    for vc1 in c1 loop
       egza_osrodki_ilosc :=  f_create_count_osrodek(vc1.id_osrodek);
       insert into analityka values (vc1.id_osrodek,vc1.nazwa_osrodek,egza_osrodki_ilosc);
    end loop;
end;


select a.id_osrodek, a.nazwa, eg.id_egzaminator, eg.nazwisko, eg.liczba_egzaminow from analityka a,table(a.liczba_odz_egzaminow) eg;

--Utworzyć tabelę bazy danych o nazwie Analityka_Studenci. Tabela powinna zawierać
--informacje o liczbie egzaminów każdego studenta w każdym z ośrodków. W tabeli
--utworzyć kolumny opisujące studenta (identyfikator, Nazwisko i imię), ośrodek
--(identyfikator i nazwa) oraz liczbę egzaminów studenta w danym ośrodku. Dane dotyczące
--ośrodka i liczby egzaminów należy umieścić w kolumnie, będącej tabelą zagnieżdżoną.
--Wprowadzić dane do tabeli Analityka_Studenci na podstawie danych zgromadzonych w
--tabelach Egzaminy, Osrodki i Studenci. 

230.

create or replace type studenci_osrodek as object(
                    id_osrodek varchar2(7),
                    nazwa varchar2(50),
                    liczba_egzaminow int(7)
                    );
create or replace type studenci_osrodek_type is table of studenci_osrodek;
                    
create table Analityka_studenci (
                    id_student varchar2(7) primary key,
                    imie varchar2(50) not null,
                    liczba_egzaminow_type studenci_osrodek_type
                    )
                    nested table liczba_egzaminow_type store as liczba_egzaminow_type_;

 declare
    egza_student studenci_osrodek_type := studenci_osrodek_type();
    cursor c1 is select id_student, imie from studenci;
    Function f_create_count_osrodek( id_std studenci.id_student%TYPE) return studenci_osrodek_type is
        count_student studenci_osrodek_type := studenci_osrodek_type();
        cursor c2 is select o.id_osrodek, o.nazwa_osrodek,
            (select count(*) from egzaminy e where e.id_student = id_std and e.id_osrodek = o.id_osrodek) LiczbaEgza
        from 
            osrodki o;
     begin
         for vc2 in c2 loop
            count_student.extend;
            count_student(c2%rowcount) := studenci_osrodek(vc2.id_osrodek, vc2.nazwa_osrodek, vc2.LiczbaEgza);
            end loop;
        return count_student;
    end f_create_count_osrodek;
begin
    for vc1 in c1 loop
       egza_student :=  f_create_count_osrodek(vc1.id_student);
       insert into analityka_studenci values (vc1.id_student,vc1.imie,egza_student);
    end loop;
end;


select a.id_student, a.imie, o.id_osrodek, o.nazwa, o.liczba_egzaminow from analityka_studenci a, table(a.liczba_egzaminow_type) o;


--Utworzyć tabelę o zmiennym rozmiarze i nazwać ją VT_Studenci. Tabela powinna zawierać
--elementy opisujące liczbę egzaminów każdego studenta. Zainicjować wartości elementów
--na podstawie danych z tabel Studenci i Egzaminy. Zapewnić, by studenci umieszczeni w
--kolejnych elementach uporządkowani byli wg liczby zdawanych egzaminów, od
--największej do najmniejszej. Po zainicjowaniu tabeli, wyświetlić wartości znajdujące się w
--poszczególnych jej elementach.
232.

declare
    type r_student is record (id_student studenci.id_student%type,
                                imie studenci.imie%type,
                                nazwisko studenci.nazwisko%type,
                                l_egz number);
    type v_student is varray(999) of r_student;
    collection v_student:=v_student();
    cursor c1 is select id_student, imie, nazwisko, (select count(*) from egzaminy e where e.id_student = s.id_student) l_egz
            from 
                studenci s
            order by 4 desc;
begin
    for vc1 in c1 loop
        collection.extend();
        collection(c1%rowcount):=r_student(vc1.id_student, vc1.imie, vc1.nazwisko, vc1.l_egz);
    end loop;
    for vc2 in collection.first..collection.last loop
        DBMS_OUtPUT.Put_line(collection(vc2).id_student || ' ' || collection(vc2).l_egz);
    end loop;
end;
             
--Utworzyć tabelę w bazie danych o nazwie Przedmioty_Terminy. Tabela powinna zawierać
--dwie kolumny: nazwę przedmiotu oraz tabelę o zmiennej długości, zawierającą daty
--egzaminów z każdego przedmiotu. Następnie wstawić do tabeli Przedmioty_Terminy
--rekordy na podstawie danych z tabeli Egzaminy i Przedmioty. Przed wstawieniem danych
--do tabeli, należy je wyświetlić, porządkując wg nazwy przedmiotu.
234.
declare
    cursor c1 is select id_przedmiot, nazwa_przedmiot from przedmioty order by 1 desc;
    collection t_przedmiot := t_przedmiot();
    function f_coll(id_przed przedmioty.id_przedmiot%type) return t_przedmiot is
        cursor c2 is select distinct data_egzamin from egzaminy where id_przedmiot = id_przed;
        lo_coll t_przedmiot:= t_przedmiot();
    begin
        for vc2 in c2 loop
            lo_coll.extend();
            lo_coll(c2%rowcount):=o_przedmiot(vc2.data_egzamin);
        end loop;
        return lo_coll;
    end f_coll;
begin
    for vc1 in c1 loop
        collection:=f_coll(vc1.id_przedmiot);
        DBMS_OUTput.put_line(vc1.nazwa_przedmiot||' ');
        for x in collection.first..collection.last loop
            DBMS_OUTput.put_line(collection(x).data_egzamin);
        end loop;
        insert into Przedmioty_Terminy values(vc1.nazwa_przedmiot, collection);
    end loop;
end;




-- Zadanie Z wykładu
-- Utworzyć w bazie danych tabelę o nazwie PrzedmiotyAnaliza.
-- Tabela powinna zawierać informacje o liczbie egzaminów zdawanych przez poszczególnych studentów z
-- poszczególnych przedmiotów oraz całkowitej liczbie punktów uzyskanych z danego przedmiotuprzez studenta.
-- W tabeli należy utworzyć 2 kolumny.
-- Pierwsza z nich opisuje przedmiot przy pomocy jego nazwy.
-- Druga kolumna tabeli jest kolekcją typu tablica zagnieżdżona i opisuje studenta
-- (identyfikator, nazwisko, imię), liczbę egzaminów studenta z danego przedmiotu oraz liczbę zdobytych punktów
-- ze wszystkich egzaminów tego studenta z danego przedmiotu. 
-- Wprowadzić dane do tabeli PrzedmiotyAnaliza na podstawie danych zgromadzonych tabelach Studenci,
-- Przedmioty i Egzaminy.
-- Zapewnić, by przedmioty wprowadzane do tabeli były uporządkowane w kolejności alfabetycznej wg ich nazwy.
-- Natomiast elementy kolekcji należy wprowadzić tak, aby były uporządkowane wg nazwiska studenta.
-- Następnie wyświetlić dane znajdujące się w tabeli PrzedmiotyAnaliza

CREATE TYPE t_rec_student AS object (NrAlbum                    VARCHAR2(7),
                                                        StudentNazwa            VARCHAR2(100),
                                                        LiczbaEgzaminow     NUMBER,
                                                        Punkty                      NUMBER(6,2)
                                                        ) ;
                                                        
CREATE TYPE t_kol_egzaminow IS TABLE OF t_rec_student ;
 
CREATE TABLE sesja (Przedmiot               VARCHAR2(100),
                            EgzaminyStudenta    t_kol_egzaminow
                            )
                            NESTED TABLE EgzaminyStudenta STORE AS tab_egzaminy ;
 
DECLARE
    global_kol_egzaminow   t_kol_egzaminow := t_kol_egzaminow() ;
    CURSOR c1 IS SELECT id_przedmiot, nazwa_przedmiot FROM przedmioty ORDER BY 1 ;
    FUNCTION f_tworz_kol_egzaminow (idp przedmioty.id_przedmiot%TYPE) RETURN t_kol_egzaminow IS
        kol_egzaminow   t_kol_egzaminow := t_kol_egzaminow() ;
        CURSOR c2 IS SELECT id_student NrAlbum, CONCAT(imie, CONCAT(' ' , nazwisko)) NazwaStudent, 
                                    (SELECT COUNT(*) FROM egzaminy e WHERE e.id_student = s.id_student AND id_przedmiot = idp) LiczbaEgz,
                                    (SELECT NVL(SUM(punkty),0) FROM egzaminy e WHERE e.id_student = s.id_student AND id_przedmiot = idp) LiczbaPkt
                    FROM studenci s;
        BEGIN
            FOR vc2 IN c2 LOOP
                kol_egzaminow.extend ;
                kol_egzaminow(c2%rowcount) :=  t_rec_student (vc2.NrAlbum, vc2.NazwaStudent, vc2.LiczbaEgz, vc2.LiczbaPkt);
            END LOOP ;
            RETURN  kol_egzaminow ;
    END f_tworz_kol_egzaminow ;
BEGIN
    FOR vc1 IN c1 LOOP
        -- budowanie kolekcji
        global_kol_egzaminow := f_tworz_kol_egzaminow(vc1.id_przedmiot) ;
        -- wstawienie rekordu z przedmiotem i egzaminami studentow jako kolekcji do tabeli sesja
        INSERT INTO SESJA VALUES (vc1.nazwa_przedmiot, global_kol_egzaminow) ;
        NULL;
    END LOOP ;
END ;
 
SELECT przedmiot, nt.nralbum, nt.StudentNazwa, nt.LiczbaEgzaminow, nt.punkty
FROM sesja s, TABLE(s.EgzaminyStudenta) ntcountEgza



236.





--Utworzyć kolekcję typu tablica zagnieżdżona i nazwać ją NT_Studenci.
--W kolekcji należy umieścić elementy, z których każdy opisuje studenta, rok, liczbę zdanych
--przedmiotów w danym roku oraz całkowitą liczbę punktów zdobytych przez niego ze zdanych
--egzaminów w danym roku.
--Do opisu studenta należy użyć jego identyfikatora, nazwiska i imienia. Do opisu roku użyć 4 cyfr.
--Zastosować odpowiednie aliasy do opisu poszczególnych liczb.
--Zainicjować wartości elementów kolekcji na podstawie danych z tabel Studenci i Egzaminy.
--Zapewnić, by dane umieszczane były w kolejności alfabetycznej wg nazwiska studenta i roku
--egzaminu.
--Po zainicjowaniu kolekcji, wyświetlić wartości znajdujące się w poszczególnych jej elementach.

1.

create or REPLACE type nt_studenci_o as object(
            id_student varchar2(7),
            nazwisko varchar2(50),
            rok varchar2(7),
            liczba_zdanych number,
            punkty number);

create or replace type nt_studenci is table of nt_studenci_o;

declare
    collection nt_studenci := nt_studenci();
    cursor c1 is select id_student, nazwisko from studenci order by 2;
    cursor c2( id_stud studenci.id_student%type) is select 
        extract(year from data_egzamin)  rok 
    from egzaminy where id_student = id_stud
    order by 1;
    cursor c3(id_stud studenci.id_student%type, rok varchar) is select
        count(*)  as LiczbaZdanych,
        sum(punkty) as SumaPkt
    from egzaminy where id_student = id_stud and extract(year from data_egzamin) = rok and upper(zdal) = 'T';
    i number := 1;
begin
    for vc1 in c1 loop
        for vc2 in c2(vc1.id_student) loop
            for vc3 in c3(vc1.id_student, vc2.rok) loop
                collection.extend();
                collection(i) := nt_studenci_o(vc1.id_student, vc1.nazwisko, vc2.rok, vc3.LiczbaZdanych, vc3.SumaPkt);
                i := i+1;
            end loop;
        end loop;
    end loop;
    for vc2 in collection.first..collection.last loop
        DBMS_OUtPUT.Put_line(collection(vc2).id_student|| ' ' ||collection(vc2).nazwisko|| ' ' ||collection(vc2).rok|| ' ' ||collection(vc2).liczba_zdanych|| ' ' ||collection(vc2).punkty);
    e


declare
    collection nt_studenci := nt_studenci();
    cursor c1 is select id_student, nazwisko from studenci order by 2;
    cursor c2( id_stud studenci.id_student%type) is select 
        extract(year from data_egzamin)  rok 
    from egzaminy where id_student = id_stud
    order by rok;
    cursor c3(id_stud studenci.id_student%type, rok varchar) is select
        count(*)  as LiczbaZdanych,
        sum(punkty) as SumaPkt
    from egzaminy where id_student = id_stud and extract(year from data_egzamin) = rok and upper(zdal) = 'T';
    i number := 1;
begin
    for vc1 in c1 loop
        for vc2 in c2(vc1.id_student) loop
            for vc3 in c3(vc1.id_student, vc2.rok) loop
                collection.extend();
                collection(i) := nt_studenci_o(vc1.id_student, vc1.nazwisko, vc2.rok, vc3.LiczbaZdanych, vc3.SumaPkt);
                DBMS_OUtPUT.Put_line(collection(i).id_student|| ' ' ||collection(i).nazwisko|| ' ' ||collection(i).rok|| ' ' ||collection(i).liczba_zdanych|| ' ' ||collection(i).punkty);
                i := i+1;
            end loop;
        end loop;
    end loop;
    for vc2 in collection.first..collection.last loop
        DBMS_OUtPUT.Put_line(collection(vc2).id_student|| ' ' ||collection(vc2).nazwisko|| ' ' ||collection(vc2).rok|| ' ' ||collection(vc2).liczba_zdanych|| ' ' ||collection(vc2).punkty);
    end loop;
end;
            



declare
type r_student is record(id_student varchar2(50),imie varchar2(50),nazwisko varchar2(50),rok varchar2(4),l_zdane_przedmioty number, punkty number );
type t_student is table of r_student;
cursor c1 is select * from studenci order by 2;
cursor c2(ids varchar2) is select distinct extract(year from data_egzamin) as rok from egzaminy where id_student=ids order by 1;
cursor c3(ids varchar2,rok varchar2) is select count(*) as l_egz , sum(punkty) as punkty from egzaminy where  extract(year from data_egzamin)=rok and  id_student=ids and upper(zdal)='T';
global_coll t_student:=t_student();
i number:=1;
begin
for vc1 in c1 loop
    for vc2 in c2(vc1.id_student)loop
        for vc3 in c3(vc1.id_student,vc2.rok)loop
        global_coll.extend();
        global_coll(i):=r_student(vc1.id_student,vc1.imie,vc1.nazwisko,vc2.rok,vc3.l_egz,vc3.punkty);
        DBMS_OUTPUT.PUT_LINE(vc1.id_student||' '  ||vc1.imie||' '  ||vc1.nazwisko||' '  ||vc2.rok||' '  ||vc3.l_egz||' '  ||vc3.punkty);
        i:=i+1;
        end loop;
    end loop;
    end loop;
end;            




declare
type r_student is record(id_student varchar2(50),imie varchar2(50),nazwisko varchar2(50),rok varchar2(4),l_zdane_przedmioty number, punkty number );
type t_student is table of r_student;
cursor c1 is select * from studenci order by 2;
cursor c2(ids varchar2) is select distinct extract(year from data_egzamin) as rok from egzaminy where id_student=ids order by 1;
cursor c3(ids varchar2,rok varchar2) is select count(*) as l_egz , sum(punkty) as punkty from egzaminy where  extract(year from data_egzamin)=rok and  id_student=ids and upper(zdal)='T';
global_coll t_student:=t_student();
i number:=1;
begin
for vc1 in c1 loop
    for vc2 in c2(vc1.id_student)loop
        for vc3 in c3(vc1.id_student,vc2.rok)loop
        global_coll.extend();
        global_coll(i):=r_student(vc1.id_student,vc1.imie,vc1.nazwisko,vc2.rok,vc3.l_egz,vc3.punkty);
        DBMS_OUTPUT.PUT_LINE(vc1.id_student||' '  ||vc1.imie||' '  ||vc1.nazwisko||' '  ||vc2.rok||' '  ||vc3.l_egz||' '  ||vc3.punkty);
        i:=i+1;
        end loop;
    end loop;
    end loop;
end;






declare
    
    collection nt_studenci := nt_studenci();
    cursor c1 is select * from studenci order by 2;
    cursor c2( id_stud studenci.id_student%type) is select distinct
        extract(year from data_egzamin)  rok 
    from egzaminy where id_student = id_stud
    order by 1;
    cursor c3(id_stud studenci.id_student%type, rok varchar) is select
        count(*)  as LiczbaZdanych,
        sum(punkty) as SumaPkt
    from egzaminy where id_student = id_stud and extract(year from data_egzamin) = rok and upper(zdal) = 'T';
    i number := 1;
begin
    for vc1 in c1 loop
        for vc2 in c2(vc1.id_student) loop
            for vc3 in c3(vc1.id_student, vc2.rok) loop
                collection.extend();
                collection(i) := nt_studenci_o(vc1.id_student, vc1.nazwisko, vc2.rok, vc3.LiczbaZdanych, vc3.SumaPkt);
                DBMS_OUtPUT.Put_line(collection(i).id_student|| ' ' ||collection(i).nazwisko|| ' ' ||collection(i).rok|| ' ' ||collection(i).liczba_zdanych|| ' ' ||collection(i).punkty);
                i := i+1;
            end loop;
        end loop;
    end loop;
    for vc2 in collection.first..collection.last loop
        DBMS_OUtPUT.Put_line(collection(vc2).id_student|| ' ' ||collection(vc2).nazwisko|| ' ' ||collection(vc2).rok|| ' ' ||collection(vc2).liczba_zdanych|| ' ' ||collection(vc2).punkty);
    end loop;
end;
           


2.

create or replace type  n_przedmiotyO as object (
                    id_student varchar2(7),
                    nazwisko varchar2(50),
                    imie varchar2(50),
                    liczbaEgza number,
                    punkty number)
                    
create or replace type n_przedmioty is table of n_przedmiotyO;
    
create table PrzedmiotAnaliza(
    nazwa varchar2(50),
    list_stud n_przedmioty)
    nested TABLE list_stud store as list_stud_tab ;


DECLARE
    global_kol_egzaminow   n_przedmioty := n_przedmioty() ;
    CURSOR c1 IS SELECT id_przedmiot, nazwa_przedmiot FROM przedmioty ORDER BY nazwa_przedmiot;
    FUNCTION f_tworz_kol_egzaminow (idp przedmioty.id_przedmiot%TYPE) RETURN n_przedmioty IS
        kol_egzaminow   n_przedmioty := n_przedmioty() ;
        CURSOR c2 IS SELECT id_student , imie, nazwisko, 
                                    (SELECT COUNT(*) FROM egzaminy e WHERE e.id_student = s.id_student AND id_przedmiot = idp) LiczbaEgz,
                                    (SELECT NVL(SUM(punkty),0) FROM egzaminy e WHERE e.id_student = s.id_student AND id_przedmiot = idp) LiczbaPkt
                    FROM studenci s order by s.nazwisko;
        BEGIN
            FOR vc2 IN c2 LOOP
                kol_egzaminow.extend ;
                kol_egzaminow(c2%rowcount) :=  n_przedmiotyO (vc2.id_student, vc2.nazwisko,vc2.imie, vc2.LiczbaEgz, vc2.LiczbaPkt);
            END LOOP ;
            RETURN  kol_egzaminow ;
    END f_tworz_kol_egzaminow ;
BEGIN
    FOR vc1 IN c1 LOOP
        -- budowanie kolekcji
        global_kol_egzaminow := f_tworz_kol_egzaminow(vc1.id_przedmiot) ;
        -- wstawienie rekordu z przedmiotem i egzaminami studentow jako kolekcji do tabeli sesja
        INSERT INTO PrzedmiotAnaliza VALUES (vc1.nazwa_przedmiot, global_kol_egzaminow) ;
        NULL;
    END LOOP ;
END ;


SELECT nazwa, nt.id_student, nt.nazwisko, nt.liczbaEgza, nt.punkty
FROM PrzedmiotAnaliza s, TABLE(s.list_stud ) nt






declare
type nt_egzamin_czas_r is record(rok varchar2(4), miesiac varchar2(20), liczba_egz number, liczba_std number);
type nt_egzamin_czas is table of nt_egzamin_czas_r;
cursor c1 is select distinct  extract(year from data_egzamin) as rok, extract(month from data_egzamin) as miesiac from egzaminy order by rok, miesiac;
global_coll nt_egzamin_czas:=nt_egzamin_czas();
i number :=1;
egz number := 0;
stud number := 0;
begin
    for vc1 in c1 loop
            select count(*) into egz from egzaminy where extract(year from data_egzamin) = vc1.rok and extract(month from data_egzamin) = vc1.miesiac;
            select  distinct count(id_student) into stud from egzaminy where extract(year from data_egzamin) = vc1.rok and extract(month from data_egzamin) = vc1.miesiac order by id_student;
            global_coll.extend();
            global_coll(i):=nt_egzamin_czas_r(vc1.rok, vc1.miesiac, egz, stud);
            DBMS_OUTPUT.PUT_LINE(global_coll(i).rok||' '  ||global_coll(i).miesiac||' '  ||global_coll(i).liczba_egz||' '  ||global_coll(i).liczba_std);
            i:=i+1;
            egz := 0;
            stud := 0;
    end loop;
end;




declare
type nt_egzamin_czas_r is record(rok varchar2(4), miesiac varchar2(20), liczba_egz number, liczba_std number);
type nt_egzamin_czas is table of nt_egzamin_czas_r;
cursor c1 is select distinct  extract(year from data_egzamin) as rok, extract(month from data_egzamin) as miesiac from egzaminy order by rok, miesiac;
global_coll nt_egzamin_czas:=nt_egzamin_czas();
i number :=1;
egz number := 0;
stud number := 0;
begin
    for vc1 in c1 loop
            select count(id_egzamin) into egz from egzaminy where extract(year from data_egzamin) = vc1.rok and extract(month from data_egzamin) = vc1.miesiac;
            select distinct sum(id_student) into stud from egzaminy where extract(year from data_egzamin) = vc1.rok and extract(month from data_egzamin) = vc1.miesiac ;
            global_coll.extend();
            global_coll(i):=nt_egzamin_czas_r(vc1.rok, vc1.miesiac, egz, stud);
            DBMS_OUTPUT.PUT_LINE(global_coll(i).rok||' '  ||global_coll(i).miesiac||' '  ||global_coll(i).liczba_egz||' '  ||global_coll(i).liczba_std);
            i:=i+1;
            egz := 0;
            stud := 0;
    end loop;
end;



declare
type nt_egzamin_czas_r is record(rok varchar2(4), miesiac varchar2(20), liczba_egz number, liczba_std number);
type nt_egzamin_czas is table of nt_egzamin_czas_r;
cursor c1 is select distinct  extract(year from data_egzamin) as rok, extract(month from data_egzamin) as miesiac from egzaminy order by rok, miesiac;
global_coll nt_egzamin_czas:=nt_egzamin_czas();
i number :=1;
egz number := 0;
stud number := 0;
begin
    for vc1 in c1 loop
            select count(*) into egz from egzaminy where extract(year from data_egzamin) = vc1.rok and extract(month from data_egzamin) = vc1.miesiac;
            select count(distinct id_student) into stud from egzaminy where extract(year from data_egzamin) = '2010' and extract(month from data_egzamin) = '1' ;
                        global_coll.extend();
            global_coll(i):=nt_egzamin_czas_r(vc1.rok, vc1.miesiac, egz, stud);
            DBMS_OUTPUT.PUT_LINE(global_coll(i).rok' '  global_coll(i).miesiac' '  global_coll(i).liczba_egz' '  global_coll(i).liczba_std);
            i:=i+1;
            egz := 0;
            stud := 0;
    end loop;
end;


select TO_CHAR(TO_DATE(data_egzamin), 'YYYY-MM-DD') from egzaminy






-- Utworzyć kolekcję typu tablica zagnieżdżona i nazwać ją NT_Osrodki. Kolekcja powinna zawierać
--- elementy, z których każdy opisuje ośrodek, datę ostatniego egzaminu w tym ośrodku oraz studenta,
-- który zdawał ten egzamin. Do opisu ośrodka należy użyć jego identyfikatora oraz nazwy; datę
-- należy przedstawić w formacie YYYY-MM-DDD. Studenta proszę opisać przy pomocy jego
--identyfikatora, nazwiska i imienia. Zastosować czytelny alias do opisu daty egzaminu. Zainicjować
--wartości elementów kolekcji na podstawie danych z tabel Osrodki, Studenci i Egzaminy. Zapewnić,
--by elementy kolekcji uporządkowane były alfabetycznie wg nazwy ośrodka. Po zainicjowaniu
--kolekcji, wyświetlić wartości znajdujące się w poszczególnych jej elementach. 
---

declare
type r_osrodek is record(id_osrodek varchar2(7), nazwa_osrodek varchar2(50), data_ostatni_egz varchar2(10), id_student varchar2(7), nazwisko varchar2(50));
type nt_osrodek is table of r_osrodek;
nt_orodki nt_osrodek:=nt_osrodek();
cursor c1 is select id_osrodek, nazwa_osrodek from osrodki;
cursor c2 (id_os osrodki.id_osrodek%type) is select distinct e.data_egzamin, e.id_student, s.nazwisko from
    egzaminy e inner join studenci s on e.id_student = s.id_student
    where data_egzamin= (select max(data_egzamin) from egzaminy where id_osrodek = id_os);

i number := 1;
begin
 for vc1 in c1 loop
    for vc2 in c2(vc1.id_osrodek) loop
       nt_orodki.extend();
       nt_orodki(i):=r_osrodek(vc1.id_osrodek, vc1.nazwa_osrodek,TO_CHAR(TO_DATE(vc2.data_egzamin), 'YYYY-MM-DD'), vc2.id_student, vc2.nazwisko );
       DBMS_OUTPUT.PUT_LINE(nt_orodki(i).id_osrodek || ' '||  nt_orodki(i).nazwa_osrodek ||' ' || nt_orodki(i).data_ostatni_egz ||' ' || nt_orodki(i).id_student ||' ' || nt_orodki(i).nazwisko );
       i:=i+1;
    end loop;
 end loop;
 end;








declare
type r_table is record(rok  varchar2(4), id_osrodek osrodki.id_osrodek%type,nazwa_osrodek osrodki.nazwa_osrodek%type,l_egz number);
type t_table is table of r_table;
nt_osrodki t_table:=t_table();
cursor c1 is select extract(year from data_egzamin) rok,id_osrodek,
(select nazwa_osrodek from osrodki o where o.id_osrodek=e.id_osrodek) as nazwa_osrodek,count(*) as l_egz  from egzaminy e group by extract(year from data_egzamin),id_osrodek order by 1,3;
begin
 for vc1 in c1 loop
 nt_osrodki.extend();
 nt_osrodki(c1%rowcount):=r_table(vc1.rok,vc1.id_osrodek,vc1.nazwa_osrodek,vc1.l_egz);
 end loop;
    
    
    for x in nt_osrodki.first..nt_osrodki.last loop
     DBMS_OUTPUT.PUT_LINE(nt_osrodki(x).rok|| ' '||nt_osrodki(x).id_osrodek|| ' '||nt_osrodki(x).nazwa_osrodek|| ' '||nt_osrodki(x).l_egz);
    end loop;
end;
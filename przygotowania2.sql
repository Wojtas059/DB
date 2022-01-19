--Dokładnie ustalaj typ zmiennych używaj prostych nazw bo się wypierdolisz na głupi pysk

--Funkcje nazywaj create_collection(param t_type) return t_type is
-- kolekcja lokalna
-- cursor cx is zapytanie dla kolekcji
-- begin
-- pentla
-- kolekcja.extend();
-- kolekcja(c2%rowcount):=o_type;
-- return kol lok
--  end create_coll;

--Ważne po nazwie typu force wymusza usunięcie go!!!
--więc create or replace type force bla bla

--wyświetlanie komentarzy             DBMS_OUTPUT.PUT_LINE('Has no members');
--włączenie komentarzy set SERVEROUTPUT ON; zawsze na początku

--type x record is (pola lokalne tabel)
--type x varray (rozmiar) of record

--wyświetlenie daty w innym formacie niż główny TO_CHAR(data_egzamin,'yyyy-dd-mm'-kolejność pól)
--wyświetlanie daty z extracta np miesiąc TO_CHAR(TO_DATE(zmienna, 'MM'), 'month')

extract zwraca liczbę kurwaAAAAAA
aby do pozycji w tablicy przypisać rekod należy mieć pełną zgodność typów, czyli rok jako liczba i itp

--Do wyświetlania tablicy zagnieżdzonej czy też recordów
procedure print_table(my_table  t_egzaminator) is
begin
IF my_table IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Result: null set');
        ELSIF my_table.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Result: empty set');
        ELSE
            FOR i IN my_table.FIRST..my_table.LAST LOOP
            
            null;
             END LOOP;
            DBMS_OUTPUT.put_line(' ----------------- ');
        END IF;
end print_table;



Wzór do tabeli w bazie

create or replace type o_tabela as object(pola);
create or replace type t_tabela as table of o_tabela;
create table tabela(pola,tabela_z t_tabela)nested table tabela_z store as tabelka;

declare

cursor c1 is select pola from tabela główna;
global_coll  t_tabela:=t_tabela();

function create_coll(parametr typ) return t_tabela is
cursor c2 is select pola from tabela;
local_coll t_tabela:=t_tabela();

begin
for vc2 in c2 loop
local_coll.extend();
local_coll(c2%rowcount):=o_tabela(pola z vc2);
end loop;
return local_coll;
end create_coll;
begin
for vc1 in c1 loop
    global_coll:=create_coll(vc1.parametr);
    insert into tabela values (pola z vc1,global_coll);
end loop;
end ;


select * from tabela t ,table(t.tabela_z) tz; -- lepiej używać wszystkich pól niż *, lepiej wyświetla


Wzór record łatwiejszy wariant

declare
type r_table is record(pola);
type t_table is table of r_table;

global_coll t_table:=t_table();
cursor c1 is select pola from tabela główna;
begin
for vc1 in c1 loop
 global_coll.extend();
 global_coll(c1%rowcount):=vc1;
end loop;

for x in global_coll.first..global_coll.last loop
     DBMS_OUTPUT.PUT_LINE('');
    end loop;
end;

Sprytny select z podzapytaniami dla pól wez joina
nieużywać tak z datami 
w przypadku dat radzę na spokojnie je wyciągąć
       select  distinct p.id_przedmiot, p.nazwa_przedmiot,
                        (select  count(e2.id_egzamin) from egzaminy e2 where e2.id_egzaminator =  ide and e2.id_przedmiot = p.id_przedmiot) as liczba_egz,
                        (select count(e3.id_student) from egzaminy e3 where e3.id_egzaminator = ide and e3.id_przedmiot = p.id_przedmiot) as liczba_osob
                        from przedmioty p  ;


228
create or replace type o_egzaminator  as object (id_egzaminator varchar2(10),imie varchar2(20),nazwisko varchar2(20), liczba_egz number);

create or replace type t_egzaminator as table of o_egzaminator;

create table analityka(id_osrodek varchar2(30),nazwa_osrodek varchar2(30), egzaminator t_egzaminator )nested table egzaminator store as egzekutor


declare

global_coll t_egzaminator:=t_egzaminator();

cursor c1 is select id_osrodek,nazwa_osrodek from osrodki;

function create_collection(ido osrodki.id_osrodek%type) return t_egzaminator is
local_coll t_egzaminator:=t_egzaminator();
cursor c2 is select id_egzaminator,imie,nazwisko,(select count(*) from egzaminy e where e.id_egzaminator=eg.id_egzaminator and e.id_osrodek=ido) as liczba_egzaminow from egzaminatorzy eg;
begin
for vc2 in c2 loop
    local_coll.extend();  local_coll(c2%rowcount):=o_egzaminator(vc2.id_egzaminator,vc2.imie,vc2.nazwisko,vc2.liczba_egzaminow);
end loop;
return local_coll;
end create_collection;begin
    for vc1 in c1 loop
        global_coll:=create_collection(vc1.id_osrodek);
        insert into analityka values (vc1.id_osrodek,vc1.nazwa_osrodek,global_coll);
    end loop;
end;

--select id_osrodek,nazwa_osrodek,id_egzaminator,nazwisko,imie,liczba_egz from analityka a,table(a.egzaminator) eg;

230

create or replace type o_student force as object(id_osrodek varchar2(30),nazwa_osrodek varchar2(30),l_egzaminow number(5));
create or replace type t_student as table of o_student;
create table Analityka_Studenci(id_student varchar2(50),imie varchar2(50),nazwisko varchar2(50),student t_student)nested table student store as studenciak



declare
 cursor c1 is select id_student,imie,nazwisko from studenci;
 global_coll t_student:=t_student();
 function create_coll(ids studenci.id_student%type)return t_student is
 local_coll t_student:=t_student();
 cursor c2 is select o.id_osrodek,nazwa_osrodek,(select count(*) from egzaminy e where e.id_student=ids and e.id_osrodek= o.id_osrodek) l_egzaminow from osrodki o;
begin
    for vc2 in c2 loop
    local_coll.extend();
    local_coll(c2%rowcount):=o_student(vc2.id_osrodek,vc2.nazwa_osrodek,vc2.l_egzaminow);
    end loop;
    return local_coll;
    
    end create_coll;
begin
    for vc1 in c1 loop
    global_coll:=create_coll(vc1.id_student);
    insert into Analityka_Studenci values(vc1.id_student,vc1.imie,vc1.nazwisko,global_coll);
    end loop;
end;

select id_student,imie,nazwisko,id_osrodek,nazwa_osrodek,l_egzaminow from Analityka_Studenci a,table(a.student)s;

232

--Tutaj jest jeszcze opcja wpieprzenia to tablicy, logiczniejsze 
-- po zainicjowaniu oznacza po wprowadzeniu wartości

declare
type r_student is record(id_student studenci.id_student%type,imie studenci.imie%type,nazwisko studenci.nazwisko%type,l_egz number);
type v_student is varray(999) of r_student;
collection v_student:=v_student();
CURSOR c1 is select id_student,imie,nazwisko,(select count(*) from egzaminy e  where e.id_student=s.id_student) as l_egz from studenci s order by 4 desc;
begin
    for vc1 in c1 loop
    collection.extend();
    collection(c1%rowcount):=r_student(vc1.id_student,vc1.imie,vc1.nazwisko,vc1.l_egz);
    end loop;
    
    for vc2 in collection.first..collection.last loop
    DBMS_OUTPUT.PUT_LINE(collection(vc2).id_student || ' '||collection(vc2).l_egz);
    end loop;
end;


234

create or replace type o_przedmiot as object(data_egzamin date);
create or replace type t_przedmiot as table of o_przedmiot;
create table Przedmioty_Terminy(nazwa_przedmiot varchar2(45),termin t_przedmiot)nested table termin store as terminek;



declare
cursor c1 is select id_przedmiot,nazwa_przedmiot from przedmioty order by 1 desc;
global_coll t_przedmiot:=t_przedmiot();

function create_coll(ids przedmioty.id_przedmiot%type)return t_przedmiot
is 
cursor c2 is select distinct data_egzamin from egzaminy where id_przedmiot=ids;
local_coll t_przedmiot:=t_przedmiot();
begin
    for vc2 in c2 loop
     local_coll.extend();
     local_coll(c2%rowcount):=o_przedmiot(vc2.data_egzamin); end loop;
    return local_coll;
end create_coll;

begin
    for vc1 in c1 loop
        global_coll:=create_coll(vc1.id_przedmiot);
        DBMS_OUTPUT.PUT_LINE(vc1.nazwa_przedmiot|| ' ');
        for x in global_coll.first..global_coll.last loop
        DBMS_OUTPUT.PUT_LINE(global_coll(x).data_egzamin);
        end loop;
        insert into Przedmioty_Terminy values(vc1.nazwa_przedmiot,global_coll);
    end loop;
end;

select * from Przedmioty_Terminy pt,table(pt.termin) t


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



declare
type r_student is record(id_student varchar2(50),imie varchar2(50),nazwisko varchar2(50),rok varchar2(4),l_zdane_przedmioty number, punkty number );
type t_student is table of r_student;
cursor c1 is select * from studenci;
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



-- Utworzyć w bazie danych tabelę o nazwie PrzedmiotyAnaliza.
-- Tabela powinna zawierać informacje o liczbie egzaminów zdawanych przez poszczególnych
--studentów z
-- poszczególnych przedmiotów oraz całkowitej liczbie punktów uzyskanych z danego przedmiotu
--przez studenta.
-- W tabeli należy utworzyć 2 kolumny.
-- Pierwsza z nich opisuje przedmiot przy pomocy jego nazwy.
-- Druga kolumna tabeli jest kolekcją typu tablica zagnieżdżona i opisuje studenta
-- (identyfikator, nazwisko, imię), liczbę egzaminów studenta z danego przedmiotu oraz liczbę
--zdobytych punktów
-- ze wszystkich egzaminów tego studenta z danego przedmiotu. 
-- Wprowadzić dane do tabeli PrzedmiotyAnaliza na podstawie danych zgromadzonych tabelach
--Studenci,
-- Przedmioty i Egzaminy.
-- Zapewnić, by przedmioty wprowadzane do tabeli były uporządkowane w kolejności
--alfabetycznej wg ich nazwy.
-- Natomiast elementy kolekcji należy wprowadzić tak, aby były uporządkowane wg nazwiska
--studenta.
-- Następnie wyświetlić dane znajdujące się w tabeli PrzedmiotyAnaliza.

create or replace type  o_analiza force as object (id_student varchar2(50),imie varchar2(50),nazwisko varchar2(50),l_egz number, punkty number);
create or replace type t_analiza  as table of o_analiza;
create table PrzedmiotyAnaliza(nazwa_przemdmiot varchar2(50), student t_analiza)nested table student store as analiza;

declare
cursor c1 is select id_przedmiot,nazwa_przedmiot from przedmioty order by 1;
g_coll t_analiza:=t_analiza();
function create_coll(idp przedmioty.id_przedmiot%TYPE) return t_analiza 
is
l_coll t_analiza:=t_analiza();
cursor c2 is select s.id_student,imie,nazwisko,(select count(*) from egzaminy e where e.id_student=s.id_student and id_przedmiot= idp) as l_egz,(select sum(e.punkty) from egzaminy e where e.id_student=s.id_student and id_przedmiot= idp) as punkty from studenci s order by 3 ;
begin
for vc2 in c2 loop
l_coll.extend();
l_coll(c2%rowcount):=o_analiza(vc2.id_student,vc2.imie,vc2.nazwisko,vc2.l_egz,vc2.punkty);
end loop;
return l_coll;
end create_coll; 
begin
for vc1 in c1 loop
    g_coll:=create_coll(vc1.id_przedmiot);
    insert into PrzedmiotyAnaliza values(vc1.nazwa_przedmiot,g_coll);
end loop;
end;

select * from PrzedmiotyAnaliza pa,table(pa.student) a ;


Utworzyć kolekcję typu tablica zagnieżdżona i nazwać ją NT_Studenci. W kolekcji należy umieścić
elementy, z których każdy opisuje studenta, rok, liczbę zdanych przedmiotów w danym roku oraz
całkowitą liczbę punktów zdobytych przez niego ze zdanych egzaminów w danym roku. Do opisu
studenta należy użyć jego identyfikatora, nazwiska i imienia. Do opisu roku użyć 4 cyfr.
Zastosować odpowiednie aliasy do opisu poszczególnych liczb.
Zainicjować wartości elementów kolekcji na podstawie danych z tabel Studenci i Egzaminy.
Zapewnić, by dane umieszczane były w kolejności alfabetycznej wg nazwiska studenta i roku
egzaminu.
Po zainicjowaniu kolekcji, wyświetlić wartości znajdujące się w poszczególnych jej elementach.

declare
type r_table is record(id_student varchar2(50),imie varchar2(50),nazwisko varchar2(50), rok  varchar2(4),zdane_p number, punkty_p number);
type t_table is table of r_table;

nt_studenci t_table:=t_table();
j number :=1;
cursor c1 is select * from studenci order by 2;
cursor c2(ids studenci.id_student%TYPE) is select distinct extract(year from data_egzamin) rok from egzaminy where id_student=ids order by 1;
cursor c3(ids studenci.id_student%TYPE, rok varchar2) is select count(*) l_egz,sum(punkty) punkty from egzaminy where id_student=ids and extract(year from data_egzamin)=rok and upper(zdal)='T';
begin

for vc1 in c1 loop
 
 for vc2 in c2(vc1.id_student) loop
 for vc3 in c3(vc1.id_student,vc2.rok) loop
 nt_studenci.extend();
 nt_studenci(j):=r_table(vc1.id_student,vc1.imie,vc1.nazwisko,vc2.rok,vc3.l_egz,vc3.punkty);
 j:=j+1;
 end loop;
 end loop;

end loop;
for x in nt_studenci.first..nt_studenci.last loop
DBMS_OUTPUT.PUT_LINE(nt_studenci(x).id_student|| ' '||nt_studenci(x).imie|| ' '||nt_studenci(x).nazwisko|| ' '||nt_studenci(x).rok|| ' '||nt_studenci(x).zdane_p|| ' '||nt_studenci(x).punkty_p);
end loop;

end;

Utworzyć w bazie danych tabelę o nazwie EgzaminatorAnaliza. Tabela powinna zawierać
informacje o liczbie egzaminów z poszczególnych przedmiotów i liczbie egzaminowanych osób dla
poszczególnych egzaminatorów.
W tabeli utworzyć 3 kolumny. Pierwsza z nich opisuje identyfikator egzaminatora. Druga kolumna
tabeli opisuje nazwisko i imię egzaminatora. Trzecia kolumna tabeli jest kolekcją typu tablica
zagnieżdżona i opisuje przedmiot (nazwa przedmiotu), liczbę egzaminów z danego przedmiotu
przeprowadzonych przez danego egzaminatora oraz liczbę osób egzaminowanych z tegoż
przedmiotu przez danego egzaminatora. 

create or replace type o_egzaminator as object(nazwa_przedmiot varchar2(50), l_egz number, l_osob number);
create or replace type t_egzaminator as table of o_egzaminator;
CREATE TABLE EGZAMINATORANALIZA 
(
  ID_EGZAMINATOR VARCHAR2(50 BYTE) 
, IMIE_NAZWISKO VARCHAR2(50 BYTE) 
, EGZAMINATOR IRA.T_EGZAMINATOR 
) NESTED TABLE EGZAMINATOR STORE AS EGZAMINATOREK

--sprytniejsze rozwiązanie od Łukasz też poprawne w kursor wepchać  id i nazwę ośrodka z zapytaniami zagnieżdżonymi z ośrodków

--jeszcze sprytniej select 
                      select  distinct p.id_przedmiot, p.nazwa_przedmiot,
                        (select  count(e2.id_egzamin) from egzaminy e2 where e2.id_egzaminator =  ide and e2.id_przedmiot = p.id_przedmiot) as liczba_egz,
                        (select count(e3.id_student) from egzaminy e3 where e3.id_egzaminator = ide and e3.id_przedmiot = p.id_przedmiot) as liczba_osob
                        from przedmioty p  ;

declare

cursor c1 is select id_egzaminator,concat(imie,concat(' ',nazwisko)) as imie_nazwisko from egzaminatorzy;
global_coll  t_egzaminator:=t_egzaminator();

function create_coll(ide egzaminatorzy.id_egzaminator%type) return t_egzaminator is
cursor c2 is select id_przedmiot,nazwa_przedmiot from przedmioty;
cursor c3(idp przedmioty.id_przedmiot%type) is select count(*) as l_egz,count(distinct id_student) as l_s from egzaminy where id_egzaminator=ide and id_przedmiot=idp;
local_coll t_egzaminator:=t_egzaminator();
i number:=1;
begin
for vc2 in c2 loop
for vc3 in c3(vc2.id_przedmiot) loop
local_coll.extend();
local_coll(i):=o_egzaminator(vc2.nazwa_przedmiot,vc3.l_egz,vc3.l_s);
i:=i+1;
end loop;
end loop;
return local_coll;
end create_coll;
begin
for vc1 in c1 loop
    global_coll:=create_coll(vc1.id_egzaminator);
    insert into EgzaminatorAnaliza values (vc1.id_egzaminator,vc1.imie_nazwisko,global_coll);
end loop;
end ;

select * from EgzaminatorAnaliza t ,table(t.EGZAMINATOR) tz;

studExamdates

create or replace type typ_obj as object (nazwa_przedmiot varchar(50),
                                            data_zdania date);
                                        
create or replace type typ_table is table of typ_obj;

create table StudExamDates (id_student varchar(20),
                            imie varchar(40),
                            nazwisko varchar(40),
                            przedmioty typ_table)
                            NESTED TABLE przedmioty STORE AS przemiot_table;

declare 
    cursor c1 is select id_student, imie, nazwisko from studenci;
    
    global_collection typ_table := typ_table();
    
    procedure print_table(nt_table IN OUT typ_table)
    is
        i number := 1;
    begin
        IF nt_table IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Result: null set');
        ELSIF nt_table.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Result: empty set');
        ELSE
            FOR i IN nt_table.FIRST..nt_table.LAST LOOP
                DBMS_OUTPUT.put_line(' ' ||TO_CHAR(nt_table(i).nazwa_przedmiot) || ' ' || nt_table(i).data_zdania); 
            END LOOP;
            DBMS_OUTPUT.put_line(' ----------------- ');
        END IF;
    end print_table;
    
    function f_createCollection(idStudent number) return typ_table
    is
        cursor c2 is select nazwa_przedmiot, data_egzamin from egzaminy 
                        inner join przedmioty on przedmioty.id_przedmiot = egzaminy.id_przedmiot
                        where id_student = idStudent and egzaminy.zdal='T';
        local_collection typ_table := typ_table();
    begin
        for vc2 in c2 loop
            local_collection.extend();
            local_collection(c2%ROWCOUNT) := typ_obj(vc2.nazwa_przedmiot, vc2.data_egzamin);
        end loop;
        return local_collection;
        print_table(local_collection);
    end f_createCollection;
begin
    for vc1 in c1 loop
        dbms_output.put_line(vc1.id_student || ' ' || vc1.imie || ' ' || vc1.nazwisko);
        global_collection := f_createCollection(vc1.id_student);
        insert into StudExamDates VALUES (vc1.id_student,vc1.imie, vc1.nazwisko, global_collection);
    end loop;
end;

select id_student, imie, nazwisko, nazwa_przedmiot, data_zdania from StudExamDates s, table(s.przedmioty) nt

nt_egzaminy_czas

declare
type r_table is record(rok  varchar2(50), miesiac varchar2(50),l_egz number, l_stud number);
type t_table is table of r_table;


nt_egzaminy_czas t_table:=t_table();
cursor c1 is select extract(year from data_egzamin) rok,extract (month from data_egzamin) miesiac, count(*) as l_egz,count(distinct id_student) as l_stud  from egzaminy group by extract(year from data_egzamin),extract (month from data_egzamin) order by 1,2;
begin
 for vc1 in c1 loop
 nt_egzaminy_czas.extend();
 nt_egzaminy_czas(c1%ROWCOUNT):=r_table(vc1.rok,TO_CHAR(TO_DATE(vc1.miesiac, 'MM'), 'month')
,vc1.l_egz,vc1.l_stud);
 end loop;
    
    
    for x in nt_egzaminy_czas.first..nt_egzaminy_czas.last loop
     DBMS_OUTPUT.PUT_LINE(nt_egzaminy_czas(x).rok|| ' '||nt_egzaminy_czas(x).miesiac|| ' '||nt_egzaminy_czas(x).l_egz|| ' '||nt_egzaminy_czas(x).l_stud);
    end loop;
end;

Utworzyć kolekcję typu tablica zagnieżdżona i nazwać ją NT_Osrodki. Kolekcja powinna zawierać
elementy, z których każdy opisuje rok, ośrodek i liczbę egzaminów przeprowadzonych w danym
ośrodku. Do opisu roku proszę użyć 4 cyfr; opisu ośrodka - jego identyfikatora i nazwy. Zastosować
także czytelny alias do opisu liczby egzaminów.
Zainicjować wartości elementów kolekcji na podstawie danych z tabel Osrodki i Egzaminy.
Zapewnić, by dane umieszczone w kolejnych elementach kolekcji były uporządkowane wg roku i
nazwy ośrodka.
Po zainicjowaniu kolekcji, wyświetlić wartości znajdujące się w poszczególnych jej elementach.


NT_Osrodki
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

NT_Przedmioty

declare
type r_table is record(rok  varchar2(4),nazwa_przedmiot przedmioty.nazwa_przedmiot%type,l_egz number);
type t_table is table of r_table;
nt_osrodki t_table:=t_table();
cursor c1 is select extract(year from data_egzamin) rok,nazwa_przedmiot,count(distinct id_student) as l_egz from egzaminy e inner join przedmioty p on e.id_przedmiot=p.id_przedmiot 
group by nazwa_przedmiot,extract(year from data_egzamin)
order by 1,2; 
begin

 for vc1 in c1 loop
 nt_osrodki.extend();
 nt_osrodki(c1%rowcount):=r_table(vc1.rok,vc1.nazwa_przedmiot,vc1.l_egz);
 end loop;
    
    
    for x in nt_osrodki.first..nt_osrodki.last loop
     DBMS_OUTPUT.PUT_LINE(nt_osrodki(x).rok|| ' '||nt_osrodki(x).nazwa_przedmiot|| ' '||nt_osrodki(x).l_egz);
    end loop;
end;

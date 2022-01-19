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

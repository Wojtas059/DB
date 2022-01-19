91
select o.id_osrodek,o.nazwa_osrodek,o.miasto from osrodki o
minus
select o1.id_osrodek,o1.nazwa_osrodek,o1.miasto from osrodki o1
inner join egzaminy e on o1.id_osrodek = e.id_osrodek
where e.id_student='0000050'

92.
SELECT
    s.id_student,
    s.imie,
    s.nazwisko
FROM
    studenci s
where s.id_student NOT IN ( SELECT
    e1.id_student from egzaminy e1
    inner join przedmioty p on e1.id_przedmiot = p.id_przedmiot
    where nazwa_przedmiot='Bazy danych'
)

93

select o.id_osrodek,o.nazwa_osrodek,o.miasto from osrodki o
where o.id_osrodek not in(select e.id_osrodek from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
where nazwa_przedmiot='Bazy danych');

94.
select s.id_student,s.imie,s.nazwisko from studenci  s 
where s.id_student in (
select e.id_student from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
inner join osrodki o on o.id_osrodek = e.id_osrodek
where o.nazwa_osrodek='CKMP' and p.nazwa_przedmiot='Bazy danych'
)
intersect
select s.id_student,s.imie,s.nazwisko from studenci  s 
where s.id_student in (
select e.id_student from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
inner join osrodki o on o.id_osrodek = e.id_osrodek
where o.nazwa_osrodek='LBS' and p.nazwa_przedmiot='Bazy danych'
)

95.
SELECT o.id_osrodek, o.nazwa_osrodek FROM osrodki o
WHERE NOT EXISTS (
SELECT 1 FROM egzaminy e
INNER JOIN osrodki o2 ON e.id_osrodek = o2.id_osrodek
INNER JOIN studenci s ON s.id_student = e.id_student
WHERE UPPER(s.nazwisko) = 'biegaj' ANd
o.id_osrodek = e.id_osrodek
)
96.
select  p.nazwa_przedmiot, count(*) as liczba_egz from egzaminy e 
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by p.nazwa_przedmiot
having count(*)=(select max(count(e1.id_przedmiot))  from egzaminy e1
group by e1.id_przedmiot )

97.select o.id_osrodek, o.nazwa_osrodek, count(*) from egzaminy e 
inner join osrodki o on o.id_osrodek = e.id_osrodek
group by o.id_osrodek, o.nazwa_osrodek
having count(*)=(select min(count(e1.id_osrodek))from egzaminy e1
group by  e1.id_osrodek)

98.
select s.id_student,s.imie,s.nazwisko, o.id_osrodek, count(*)  from egzaminy e 
inner join studenci s on s.id_student = e.id_student
inner join osrodki o on o.id_osrodek = e.id_osrodek
group by s.id_student,s.imie,s.nazwisko, o.id_osrodek
having count(*)=(select min(count(e1.id_egzamin)) from egzaminy e1
inner join osrodki o1 on o1.id_osrodek = e1.id_osrodek
where o1.nazwa_osrodek='CKMP' and o1.id_osrodek=o.id_osrodek
group by e1.id_student, o1.id_osrodek)

99.

SELECT
    eg.id_egzaminator,
    eg.imie,
    eg.nazwisko,
    COUNT(DISTINCT e.id_student)
FROM
    egzaminy        e
    INNER JOIN egzaminatorzy   eg ON eg.id_egzaminator = e.id_egzaminator
GROUP BY
    eg.id_egzaminator,
    eg.imie,
    eg.nazwisko
HAVING
    COUNT(distinct e.id_student) = (
        SELECT
            max(COUNT(DISTINCT e1.id_student))
        FROM
            egzaminy e1
        WHERE
            eg.id_egzaminator = e1.id_egzaminator
        GROUP BY
            e1.id_egzaminator
    )

    100. tu musi być where z dwoma kolumnami, inaczej daty się powtarzają
    select o.id_osrodek,o.nazwa_osrodek,p.id_przedmiot,p.nazwa_przedmiot,e.data_egzamin from egzaminy e 
inner join osrodki o on o.id_osrodek = e.id_osrodek
inner join przedmioty p on  p.id_przedmiot = e.id_przedmiot
where (e.data_egzamin,e.id_przedmiot) in(select max(e1.data_egzamin), e1.id_przedmiot from egzaminy e1

group by e1.id_przedmiot)

101. Kurwa pamiętaj not exists w wherze nie ma nic przed nim, ani ponim tylko where not exists!!!!


select o.id_osrodek, o.nazwa_osrodek from osrodki o
left join egzaminy e1 on o.id_osrodek = e1.id_osrodek
where  not exists (select e.id_osrodek from egzaminy e 
inner join egzaminatorzy eg on  eg.id_egzaminator = e.id_egzaminator
where eg.nazwisko='Muryjas'
)

102.
select p.id_przedmiot, p.nazwa_przedmiot, o.id_osrodek,o.nazwa_osrodek, count(e.id_egzamin) from egzaminy e 
inner join przedmioty p on  p.id_przedmiot = e.id_przedmiot
inner join osrodki o on o.id_osrodek = e.id_osrodek
group by p.id_przedmiot, p.nazwa_przedmiot, o.id_osrodek,o.nazwa_osrodek
having count(e.id_egzamin) in (select max(count(e1.id_egzamin)) from egzaminy e1
where    o.id_osrodek=e1.id_osrodek
group by e1.id_przedmiot
)
order by 3

103.Zapytanie jest skierowane do przedmiotów, więc to będzie w inner wherze
select s.id_student,s.imie,s.nazwisko, p.nazwa_przedmiot, e.data_egzamin from egzaminy e 
inner join studenci s on s.id_student = e.id_student
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot


where e.data_egzamin  = (select min(e1.data_egzamin) from egzaminy e1
where e.id_przedmiot=e1.id_przedmiot
)
group by s.id_student,s.imie,s.nazwisko, p.nazwa_przedmiot, e.data_egzamin
order by 4

104
select s.id_student,s.imie,s.nazwisko,e.id_egzaminator, e.data_egzamin from egzaminy e 
inner join studenci s on s.id_student = e.id_student
inner join egzaminatorzy eg on eg.id_egzaminator = e.id_egzaminator
where e.data_egzamin in (select min(e1.data_egzamin) from egzaminy e1
where e.id_egzaminator=e1.id_egzaminator 
group by e1.id_egzaminator
)
and  eg.nazwisko='Muryjas'
group by  s.id_student,s.imie,s.nazwisko,e.id_egzaminator, e.data_egzamin

105.
select e.id_osrodek,e.id_przedmiot,p.nazwa_przedmiot, count(*) from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by e.id_osrodek, e.id_przedmiot,p.nazwa_przedmiot
having count(*) in (select max(count(e1.id_osrodek)) from egzaminy e1
inner join osrodki o on o.id_osrodek = e1.id_osrodek
where o.nazwa_osrodek='CKMP' and e1.id_osrodek=e.id_osrodek
group by e1.id_przedmiot,e1.id_osrodek
)

106.Pamiętaj zapytanie o przedmioty, więc warunek też co do przedmiotów, grupowanie po studentach, dlatego że tą metodą zbieramy ich wyniki i wyciągamy konkretny dla danej osoby, a max zwaraa tylko największe względem przedmiotu będącego w warunku
select e.id_student,e.id_przedmiot,p.nazwa_przedmiot, count(*) from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by e.id_student, e.id_przedmiot,p.nazwa_przedmiot
having count(*) = (
    select max(count(*)) from egzaminy e1
where e.id_przedmiot=e1.id_przedmiot
group by e1.id_student
)
order by 3


select max(count(*)) from egzaminy e1 
where e.id_przedmiot = e1.id_przedmiot
group by e1.id_przedmiot

107.
select e.id_egzaminator, e.id_osrodek,o.nazwa_osrodek, count(distinct e.id_student) from egzaminy e 
inner join osrodki o on o.id_osrodek = e.id_osrodek
group by e.id_egzaminator, e.id_osrodek,o.nazwa_osrodek
having count(distinct e.id_student) in (select count(distinct e1.id_student) from egzaminy e1
inner join egzaminatorzy eg on eg.id_egzaminator = e1.id_egzaminator
where eg.nazwisko='Muryjas' and e.id_egzaminator=e1.id_egzaminator
group by e1.id_osrodek
)
and count(distinct e.id_student) >2
order by 2 

108.
select e.id_student, min(e.data_egzamin),max(e.data_egzamin),e.id_osrodek from egzaminy e
group by e.id_student,e.id_osrodek
having (min(e.data_egzamin),max(e.data_egzamin)) in (select min(e1.data_egzamin),max(e1.data_egzamin) from egzaminy e1
where e.id_osrodek=e1.id_osrodek
group by e.id_osrodek
)

109.

select e.id_egzaminator,e.id_osrodek,e.id_przedmiot,p.nazwa_przedmiot, count(*) from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by e.id_egzaminator,e.id_osrodek,e.id_przedmiot,p.nazwa_przedmiot
having count(*) in (select max(count(e1.id_przedmiot)) from egzaminy e1
inner join egzaminatorzy eg on eg.id_egzaminator = e1.id_egzaminator
inner join osrodki o on o.id_osrodek = e1.id_osrodek
where e.id_osrodek=e1.id_osrodek and eg.nazwisko='Muryjas' and e1.id_egzaminator = e.id_egzaminator  and o.nazwa_osrodek='CKMP'
group by e1.id_przedmiot
)
order by 1,5

110. Pamiętaj grupowanie count zbiera wszystko, dosłownie, dlatego trzeba ostożnie dobierać warunki where, bo one determinują co będzie realnie brane pod uwagę
tak jak tutaj w głównym wherze chcemy konkretną osobę, z danym nazwiskiem oraz statusem T, wówczas to wyliczy bardzo dokładnie
to samo należy zrobić w podzapytaniu. 
To zadanie i poprzednie mają podobnych schemat
select s.id_student,s.nazwisko,s.imie, id_osrodek,count(*) from studenci s
inner join egzaminy e on s.id_student = e.id_student
where s.nazwisko='Nowak' and e.zdal='T'
group by s.id_student,s.nazwisko,s.imie, id_osrodek
having count(*) in (select min(count(e.id_student)) from egzaminy e1
INNER JOIN studenci s1 ON s1.id_student = e1.id_student
WHERE UPPER(s1.nazwisko) = 'NOWAK' and e1.zdal = 'T'
group by e1.id_osrodek
)

111.
select s.id_student,s.imie,s.nazwisko,e.id_osrodek, count(*) from studenci s
inner join egzaminy e on s.id_student = e.id_student
where e.zdal='N'
group by s.id_student,s.imie,s.nazwisko,e.id_osrodek
having count(*) in (select max(count(e1.id_student)) from egzaminy e1
where e1.zdal='N' and e.id_osrodek=e1.id_osrodek
group by e1.id_osrodek,e1.id_student
)
order by 4
112.

select e.id_egzaminator,e.id_osrodek,min(e.data_egzamin),max(e.data_egzamin) from egzaminy e
group by e.id_egzaminator,e.id_osrodek
having (min(e.data_egzamin),max(e.data_egzamin)) in (select min(e1.data_egzamin),max(e1.data_egzamin) from egzaminy e1
where e1.zdal='T'
group by e1.id_osrodek,e1.id_egzaminator
)

113.
select extract(month from e.data_egzamin),EXTRACT(year from e.data_egzamin),e.id_osrodek, count(*) from egzaminy e
inner join osrodki o1 on o1.id_osrodek = e.id_osrodek

group by extract(month from e.data_egzamin),EXTRACT(year from e.data_egzamin), e.id_osrodek
having count(*) = (select max(count(*)) from egzaminy e1
inner join osrodki o on o.id_osrodek = e1.id_osrodek
where o.nazwa_osrodek='CKMP' and e.id_osrodek=e1.id_osrodek
group by extract(month from e1.data_egzamin),EXTRACT(year from e1.data_egzamin),e1.id_osrodek
)
114.
select extract(month from e.data_egzamin),EXTRACT(year from e.data_egzamin),count(*) from egzaminy e

group by extract(month from e.data_egzamin),EXTRACT(year from e.data_egzamin)
having count(*) = (select max(count(*)) from egzaminy e1

where EXTRACT(year from e.data_egzamin)=EXTRACT(year from e1.data_egzamin)
group by extract(month from e1.data_egzamin),EXTRACT(year from e1.data_egzamin)
)
115.

select extract(month from e.data_egzamin),EXTRACT(year from e.data_egzamin),e.id_osrodek,count(*) from egzaminy e

group by extract(month from e.data_egzamin),EXTRACT(year from e.data_egzamin), e.id_osrodek
having count(*) = (select max(count(*)) from egzaminy e1
inner join osrodki o on o.id_osrodek = e1.id_osrodek
where EXTRACT(year from e.data_egzamin)=EXTRACT(year from e1.data_egzamin) and o.nazwa_osrodek='CKMP' and e.id_osrodek=e1.id_osrodek
group by extract(month from e1.data_egzamin)
)
order by 3,2
116.To date zmienia tylko do fomatu daty, nastomiast to char wyciąga opisowo dany miesiąc itp
select to_char( TO_DATE( extract(month from e.data_egzamin),'MM'),'Month'),EXTRACT(year from e.data_egzamin),count(*) from egzaminy e

group by extract(month from e.data_egzamin),EXTRACT(year from e.data_egzamin)
having count(*) = (select max(count(*)) from egzaminy e1

where EXTRACT(year from e.data_egzamin)=EXTRACT(year from e1.data_egzamin)
group by extract(month from e1.data_egzamin),EXTRACT(year from e1.data_egzamin)
)
188.
DECLARE
    CURSOR c1 IS
    SELECT
        eg.id_egzaminator,
        eg.imie,
        eg.nazwisko
    FROM
        egzaminatorzy eg;

    i NUMBER DEFAULT 1;
BEGIN
    FOR x IN c1 LOOP
        dbms_output.put_line(i
                             || ' '
                             || x.id_egzaminator
                             || ' '
                             || x.imie
                             || ' '
                             || x.nazwisko);

        i := i + 1;
    END LOOP;
END;

189.
declare
cursor c1 is select id_osrodek, count(*) as liczba from egzaminy group by id_osrodek having count(*)<5;
cursor c2 is select id_osrodek, count(*) as liczba from egzaminy group by id_osrodek having count(*)>4 and count(*)<11;
cursor c3 is select id_osrodek, count(*) as liczba from egzaminy group by id_osrodek having count(*)>10;
begin
for x in c1 loop
    DBMS_OUTPUT.PUT_LINE(x.id_osrodek||' '||x.liczba);
end loop;
DBMS_OUTPUT.PUT_LINE('----------------------');

for x in c2 loop
    DBMS_OUTPUT.PUT_LINE(x.id_osrodek||' '||x.liczba);
end loop;
DBMS_OUTPUT.PUT_LINE('----------------------');

for x in c3 loop
    DBMS_OUTPUT.PUT_LINE(x.id_osrodek||' '||x.liczba);
end loop;

end;

190.
declare
cursor c1 is select id_przedmiot, count(*) as liczba from egzaminy group by id_przedmiot order by 2 desc;
mvar c1%rowtype;
begin
open c1;
if c1%isopen then
fetch c1 into mvar;
while c1%found loop
    exit when c1%rowcount>3;
    DBMS_OUTPUT.PUT_LINE(mvar.id_przedmiot||' '||mvar.liczba);
    fetch c1 into mvar;
end loop;
end if;

end;

191. Zapamiętaj domyślnie data nie jest distinct, trzeba ją przeformatować do z todate albo to char, pamiętaj o jebanym zamykaniu cursorów !!!
DECLARE
    CURSOR c1 IS
    SELECT DISTINCT
        TO_DATE(data_egzamin, 'dd-mm-yyyy') AS mydate
    FROM
        egzaminy e
    ORDER BY
        1 DESC;

    CURSOR c2 (
        mdate egzaminy.data_egzamin%TYPE
    ) IS
    SELECT
        id_student,
        data_egzamin
    FROM
        egzaminy
    WHERE
        TO_DATE(data_egzamin, 'dd-mm-yyyy') = mdate;

    mydate   egzaminy.data_egzamin%TYPE;
    mvalue   c2%rowtype;
BEGIN
    OPEN c1;
    IF c1%isopen THEN
        FETCH c1 INTO mydate;
        WHILE c1%found LOOP
            EXIT WHEN c1%rowcount > 3;
            OPEN c2(mydate);
            IF c2%isopen THEN
                FETCH c2 INTO mvalue;
                WHILE c2%found LOOP
                    dbms_output.put_line(mvalue.id_student
                                         || ' '
                                         || mvalue.data_egzamin);
                    FETCH c2 INTO mvalue;
                END LOOP;

            END IF;

            CLOSE c2;
            FETCH c1 INTO mydate;
        END LOOP;

        CLOSE c1;
    END IF;

END;

192.


begin 
for x  in c1 loop
    open c2(x.id_osrodek);
    if c2%isopen then
    fetch c2 into mvar;
    while c2%found loop
        exit when c2%rowcount>2;
        DBMS_OUTPUT.PUT_LINE(mvar.id_student||' '||mvar.liczba||' '||x.id_osrodek);
        fetch c2 into mvar;
    end loop;
    end if;
    close c2;
end loop;
end;

193. rozwiązanie z wyjątkiem

 declare
 
begin
insert into Przedmioty values (10,'Hurtownie danych',null);
exception 
when DUP_VAL_ON_INDEX THEN
       DBMS_OUTPUT.put_line('Podany przedmiot już istnieje');
end;

z kursorem

declare
mvar varchar2(20);
cursor c1 is SELECT id_przedmiot into mvar from przedmioty where id_przedmiot ='10'; 
mvar2 varchar2(20);
begin
open c1;
if c1%isopen then
fetch c1 into mvar2;
if c1%notfound then
    insert into Przedmioty values (10,'Hurtownie danych',null);
end if;
end if;

end;

194.
declare
cursor c1 is select id_egzamin, zdal from egzaminy for update of punkty;
rvalue number;
begin
for x in c1 loop
    if x.zdal='T' then
    rvalue:= ROUND(DBMS_RANDOM.value(3,5),2);
    else
    rvalue:= ROUND(DBMS_RANDOM.value(2,3),2);
    end if;
    update egzaminy set punkty=rvalue where current of c1;
end loop;
end;

195.
declare
cursor c1 is select id_przedmiot, nazwa_przedmiot from przedmioty;
cursor c2(mprzedmiot egzaminy.id_przedmiot%type) is select id_student, count (*) as liczba from egzaminy where id_przedmiot=mprzedmiot group by id_student order by 1;
begin
for x in c1 loop
    for y in c2(x.id_przedmiot) loop
        DBMS_OUTPUT.PUT_LINE(y.id_student||' '||x.id_przedmiot|| ' '||x.nazwa_przedmiot||' ' ||y.liczba);
    end loop;
end loop;
end;

198. Wewnętrzny select wyciaga czyste dane, zewnętrzny ma pola w odpowiedniej kolejności(zgodność) i tutaj dokonujemy grupowania i tak dalej
po in nawias i w czym ma być przeszukiwane.
 
declare
begin
for x in (select rok,miesiac,id_osrodek,nazwa_osrodek,count(*) as liczba from (
    select extract(year from e.data_egzamin) as rok,extract(month from e.data_egzamin) as miesiac,e.id_osrodek,o.nazwa_osrodek from egzaminy e 
    inner join osrodki o on o.id_osrodek = e.id_osrodek
    
) group by rok,miesiac,id_osrodek,nazwa_osrodek) loop
    insert into tlmosrodki values(x.rok,x.miesiac,x.id_osrodek,x.nazwa_osrodek,x.liczba);
end loop;
end;

206.
declare
cursor c1 is select id_przedmiot,count(*) as liczba from egzaminy group by id_przedmiot;

begin
for x in c1 loop
begin
    if x.liczba=0 then raise no_data_found;
    end if;
    exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Brak egzaminu z przedmiotu'||x.id_przedmiot);
    end;
end loop;
end;
207.
declare
cursor c1 is select id_egzaminator,data_egzamin,count(*) as liczba from egzaminy group by id_egzaminator,data_egzamin;
over5 exception;
begin
for x in c1 loop
begin
    if x.liczba>3 then raise over5;
    end if;
    exception
    when over5 then
    
        DBMS_OUTPUT.PUT_LINE(x.id_egzaminator||' przeprowadził '||x.liczba|| ' egzaminów w dniu '||x.data_egzamin);
end;
end loop;
end;
208.
DECLARE
    egzaminator_nie_istnieje EXCEPTION;
    CURSOR c1 IS SELECT id_egzaminator, imie, nazwisko FROM egzaminatorzy
    WHERE UPPER(nazwisko) = 'MURYJAS';
    CURSOR c2(idEgzaminatora NUMBER) IS SELECT COUNT(*) as liczba FROm egzaminy
    WHERE id_egzaminator = idEgzaminatora
    GROUP BY id_egzaminator;
    data c1%rowtype;
BEGIN 
    OPEN c1;
    FETCH c1 INTO data;
    BEGIN
        IF c1%NOTFOUND THEN RAISE egzaminator_nie_istnieje;
        ELSE
            WHILE c1%FOUND LOOP
                FOR vC2 in C2(data.id_egzaminator) LOOP
                    DBMS_OUTPUT.put_line(data.id_egzaminator || ' ' || data.imie || ' ' || data.nazwisko || ' ' || vC2.liczba);
                END LOOP;
            FETCH c1 INTO data;
            END LOOP;
        END IF;
    EXCEPTION 
 WHEN egzaminator_nie_istnieje THEN
            DBMS_OUTPUT.put_line('Egzaminator o podanym nazwisku nie istnieje');
    END;
    CLOSE c1;
END;

209. Ok szymon robił to na zadzie czy istnieje ośrodek, select into jeśli nie ma wywali wyjątek, a jeśli tak to leciał po prostu po zawartości bazy, drugie podejście wziąć z bazy wszystko w sensie konkretne ośrodki i sprawdzać przy pomocy notfound i podnosić ręcznie wyjątek, pierwsze jest optymalniejsze, na pewno w tym przypadku
dlaczego szymon nie robi joina, odpowiedź: jest efektywniejsze, nie musi tworzyć niejawnych
czemu szymon nie dał otwarcia kursora tylko sprawdza select into, bo też da błąd no data found oraz zwiększa optymalność zaptytania
pamiętaj o distinct dla sprawdzenia istnienia ośrodków, bo inaczej jeśli jest wiele to zwróci błąd, a distinct sprawia , że pojawi się unikatowe wystąpienie, czyli tylko sprawdzenie istnienia.
declare
cursor c1 is select id_osrodek,nazwa_osrodek from osrodki where nazwa_osrodek='CKMP';
osrodekistnieje number;
counter number;
begin
select distinct 1 into osrodekistnieje from osrodki where nazwa_osrodek='CKMP';
for x in c1 loop
    select count(*) into counter from osrodki where id_osrodek=x.id_osrodek;
    if counter <>0 then
    DBMS_OUTPUT.PUT_LINE('Osrodek o numerze i nazwie '||x.id_osrodek|| '  '||x.nazwa_osrodek||' przeprowadził '||counter||' egzaminów');
    else
        DBMS_OUTPUT.PUT_LINE('Osrodek o numerze i nazwie '||x.id_osrodek|| ' '||x.nazwa_osrodek||'nie przeprowadził egzaminów');
    end if;
end loop;
exception
    when no_data_found then
    DBMS_OUTPUT.PUT_LINE('Nie ma takiego osrodka jak LBS');
end;

255.
declare

procedure pmosrodek(ido osrodki.id_osrodek%type) is
cursor c1 is select id_osrodek,nazwa_osrodek,miasto from osrodki where id_osrodek = ido for update of nazwa_osrodek,miasto;
idistnieje number;
begin
select 1 into idistnieje from osrodki where id_osrodek=ido;
for x in c1 loop
    update osrodki set miasto='Kraków' where current of c1;
end loop;
EXCEPTION
when no_data_found then
    DBMS_OUTPUT.PUT_LINE('Nie ma takiego id '||ido);
end pmosrodek;

begin
    pmosrodek(20);
    end;

256.
declare
procedure inOsroWasEgz(ido osrodki.id_osrodek%type) is
cursor c1 is select id_osrodek,nazwa_osrodek from osrodki where id_osrodek=ido;
begin
for x in c1 loop
dbms_output.put_line(x.id_osrodek||' ' ||x.nazwa_osrodek);
end loop;
end inOsroWasEgz;
begin 
    for y in (select distinct id_osrodek from egzaminy order by 1) loop
        inOsroWasEgz(y.id_osrodek);
    end loop;
end;

257.
declare
points number;
function countPoints(idstud number)return number is
vpoints number default 0;
bstudintable number;
begin 
select distinct 1 into bstudintable from egzaminy where id_student=idstud;
select sum(punkty) into vpoints from egzaminy where id_student=idstud;
return vpoints;
exception 
when no_data_found then return vpoints;
end countPoints;
begin
for x in (select id_student from studenci) loop
    points:= countPoints(x.id_student);
    if  points> 0 then
    dbms_output.put_line ('Student otrzymal'|| points||'  ' ||x.id_student);
    else
    dbms_output.put_line ('Student nie zdawal egzaminu '||x.id_student);
    end if;
end loop;
end;
261.
declare 

procedure absolut(idstud studenci.id_student%type) is

cursor c1 is select nr_ecdl,data_ecdl from studenci where id_student=idstud for update of nr_ecdl,data_ecdl;
    mdate date;
    function maxDate(idstud studenci.id_student%type) return date is
    lastEx date;
    begin
    select max(data_egzamin) into lastEx from egzaminy where id_student=idstud;
    return lastEx;
    exception
    when no_data_found then
    
    
    end maxDate;
    
    function allPassed(idstud studenci.id_student%type) return boolean is
    bwynik boolean;
    vegz number;
    vegzstud number;
    begin
    select count(*) into vegz from przedmioty;
    select count(*) into vegzstud from egzaminy where id_student=idstud and zdal='T';
    if vegz=vegzstud then return true;
    else return false;
    end if;
    exception
    when no_data_found then
    dbms_output.put_line('Ten student nie pisal zadnego egzaminu');
    return false;
    end allPassed;
begin
    for x in c1 loop
        if allPassed(idstud) then
        mdate:=maxDate(idstud);
        update studenci set nr_ecdl=idstud,data_ecdl=mdate where current of c1;
         dbms_output.put_line(idstud);
        else
        dbms_output.put_line('Ten student nie orzymal absolutu');
        end if;
    end loop;
end absolut;
begin
    for y in (select id_student from studenci) loop
        absolut(y.id_student);
    end loop;
end;

kolos:

1.
 Dla każdego roku, w którym odbyły się egzaminy, proszę wskazać tego studenta, który zdał najwięcej egzaminów w danym roku. Dodatkowo, należy podać sumaryczną liczbę punktów
 uzyskanych ze wszystkich zdanych egzaminów przez tego studenta w danym roku. 
 W odpowiedzi umieścić informację o roku (w formacie YYYY) oraz pełne informacje o studencie (identyfikator, nazwisko, imię). Zadanie należy rozwiązać z użyciem kursora.

2.
Który egzaminator przeprowadził więcej niż 50 egzaminów w tym samym ośrodku w jednym roku? Zadanie należy rozwiązać przy użyciu techniki wyjątków (jeśli to konieczne, można dodatkowo zastosować kursory). W odpowiedzi proszę umieścić pełne dane o ośrodku (identyfikator, nazwa), informację o roku (w formacie YYYY), pełne dane egzaminatora (identyfikator, nazwisko, imię) oraz liczbę egzaminów.

 Zadanie należy wykonać wykorzystując technikę wyjątków.

3.
 Dla każdego ośrodka wskazać tych studentów, którzy zdawali egzamin w tym ośrodku w kolejnych latach.
  W rozwiązaniu zadania wykorzystać podprogram (funkcję lub procedurę) PL/SQL, który umożliwia kontrolę uczestnictwa studenta w egzaminie 
  przeprowadzonym w danym ośrodku i w danym roku. Wynik zadania powinien zawierać informację o identyfikatorze ośrodka, jego nazwie, numerze roku,
   identyfikatorze studenta oraz jego nazwisku i imieniu. Uporządkować dane wynikowe wg nazwy ośrodka, roku i nazwiska studenta.

   4.  Utworzyć funkcję składowaną o nazwie CheckPoints, która umożliwi kontrolę poprawności przyznania punktów za egzamin. Funkcja powinna zwrócić wartość TRUE jeśli: 

 za egzamin zdany przyznano poprawną liczbę punktów z przedziału od 3 do 5 (obustronnie domkniętego),
 za egzaminy niezdany przyznano liczbę punktów z przedziału od 2 do 2,99 (również obustronnie domkniętego). 
 Jeśli powyższe warunki nie są spełnione, funkcja powinna zwrócić wartość FALSE. 
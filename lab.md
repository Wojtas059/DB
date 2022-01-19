190. Wskazać trzy przedmioty, z których przeprowadzono najwięcej egzaminów. W
odpowiedzi umieścić nazwę przedmiotu oraz liczbę egzaminów.

```sql
declare 
    vcount number;
    cursor c1 is select distinct count(*) from egzaminy group by id_przedmiot order by 1 desc;
begin
    open c1;
    if c1%isopen then
        fetch c1 into vcount; 
        while c1%found loop
            exit when c1%rowcount >3;
            dbms_output.put_line(vcount);
            fetch c1 into vcount;
        end loop;
    end if;
end;
```
```sql
DECLARE
    CURSOR c1 IS SELECT DISTINCT COUNT(*)
        FROM egzaminy
        GROUP BY id_przedmiot
        ORDER BY 1 DESC;
    CURSOR c2 IS
        SELECT DISTINCT e.id_przedmiot, p.nazwa_przedmiot AS Nazwa, COUNT(*) AS liczba
        FROM egzaminy e
        join przedmioty p ON p.id_przedmiot = e.id_przedmiot
        GROUP BY e.id_przedmiot, p.nazwa_przedmiot
        ORDER BY 3 DESC;
    vcount NUMBER;
    vprzedmiot c2%ROWTYPE;
BEGIN
    OPEN c1;
    IF c1%isopen THEN
        FETCH c1 INTO vcount;
        WHILE c1%found LOOP
            EXIT WHEN c1%rowcount > 3;
            OPEN c2;
            IF c2%isopen THEN
                FETCH c2 INTO vprzedmiot;
                WHILE c2%found LOOP
                    IF vprzedmiot.liczba = vcount THEN
                        DBMS_OUTPUT.put_line(vprzedmiot.Nazwa || ' ' || vcount);
                    END IF;
                    FETCH c2 INTO vprzedmiot;
                END LOOP;
            END IF;
            CLOSE c2;
            FETCH c1 INTO vcount;
        END LOOP;
        CLOSE c1;
    END IF;
END;
```


```sql
DECLARE
    vcount NUMBER;
    CURSOR c1 IS SELECT DISTINCT COUNT(*)
        FROM egzaminy
        GROUP BY id_przedmiot
        ORDER BY 1 DESC;
    CURSOR c2  IS
        SELECT DISTINCT e.id_przedmiot, p.nazwa_przedmiot AS Nazwa, COUNT(*) AS liczba
        FROM egzaminy e
        join przedmioty p ON p.id_przedmiot = e.id_przedmiot
        GROUP BY e.id_przedmiot, p.nazwa_przedmiot
        having count(*)=vcount
        ORDER BY 3 DESC;
    
    vprzedmiot c2%ROWTYPE;
BEGIN
    OPEN c1;
    IF c1%isopen THEN
        FETCH c1 INTO vcount;
        WHILE c1%found LOOP
            EXIT WHEN c1%rowcount > 3;
            FOR vc2 in c2 loop
                DBMS_OUTPUT.put_line(vprzedmiot.Nazwa || ' ' || vcount);
            END loop;
            FETCH c1 INTO vcount;
        END LOOP;
        CLOSE c1;
    END IF;
END;
```


```sql
DECLARE
    vcount NUMBER;
    CURSOR c1 IS SELECT DISTINCT COUNT(*)
        FROM egzaminy
        GROUP BY id_przedmiot
        ORDER BY 1 DESC;
    CURSOR c2 IS
        SELECT DISTINCT e.id_przedmiot, p.nazwa_przedmiot AS Nazwa, COUNT(*) AS liczba
        FROM egzaminy e
        join przedmioty p ON p.id_przedmiot = e.id_przedmiot
        GROUP BY e.id_przedmiot, p.nazwa_przedmiot
        HAVING COUNT(*) = vcount
        ORDER BY 3 DESC;
    vprzedmiot c2%ROWTYPE;
BEGIN
    OPEN c1;
    IF c1%isopen THEN
        FETCH c1 INTO vcount;
        WHILE c1%found LOOP
            EXIT WHEN c1%rowcount > 3;
            FOR vc2 IN c2 LOOP
                DBMS_OUTPUT.put_line(vc2.Nazwa || ' ' || vcount);
            END LOOP;
            FETCH c1 INTO vcount;
        END LOOP;
        CLOSE c1;
    END IF;
END;
```




192
```sql
SET SERVEROUTPUT ON
DECLARE CURSOR c1 IS
SELECT id_osrodek
FROM osrodki
WHERE nazwa_osrodek = 'CKMP';
vbase NUMBER;
CURSOR c2 IS
SELECT COUNT(*) AS liczba,
    e.id_student,
    imie,
    nazwisko,
    o.nazwa_osrodek,
    e.id_osrodek
FROM egzaminy e
inner join osrodki o ON o.id_osrodek = e.id_osrodek
inner join studenci ON studenci.id_student = e.id_student
WHERE e.id_osrodek = vbase
GROUP BY e.id_student,
    imie,
    nazwisko,
    o.nazwa_osrodek,
    e.id_osrodek
ORDER BY 1 DESC;
vresult c2%ROWTYPE;
BEGIN OPEN c1;
IF c1 %isopen THEN FETCH c1 INTO vbase;
WHILE c1 %found LOOP DBMS_OUTPUT.put_line('numer osrodka ' || vbase);
OPEN c2;
IF c2%isopen THEN
FETCH c2 INTO vresult;
WHILE c2%found LOOP
EXIT WHEN c2%rowcount > 2;
DBMS_OUTPUT.put_line('Student i osrodek ' || vresult.id_student || ' ' || vresult.imie || ' ' || vresult.nazwisko || ' ' || vresult.id_osrodek || ' ' || vresult.nazwa_osrodek  );
FETCH c2 INTO vresult;
END LOOP;
CLOSE c2;
END IF;
FETCH c1 INTO vbase;
END LOOP;
CLOSE c1;
END IF;
END;
```


194 
```sql
DECLARE
    CURSOR c1 IS
        SELECT id_egzamin, zdal
        FROM egzaminy;
    vegzamin c1%ROWTYPE;
BEGIN
    OPEN c1;
    IF c1%isopen THEN
        FETCH c1 INTO vegzamin;
        WHILE c1%found LOOP
            IF vegzamin.zdal = 'T' THEN
                UPDATE egzaminy
                SET punkty = ROUND(DBMS_RANDOM.VALUE(3,5),2)
                WHERE id_egzamin = vegzamin.id_egzamin;
            ELSE
                UPDATE egzaminy
                SET punkty = ROUND(DBMS_RANDOM.VALUE(2,2.99),2)
                WHERE id_egzamin = vegzamin.id_egzamin;
            END IF;
            FETCH c1 INTO vegzamin;
        END LOOP;
    END IF;
END;


DECLARE
    CURSOR c1 IS
        SELECT  zdal
        FROM egzaminy for update; -- blokuje tabele na czas operacji
    vegzamin c1%ROWTYPE;
BEGIN
    OPEN c1;
    IF c1%isopen THEN
        FETCH c1 INTO vegzamin;
        WHILE c1%found LOOP
            IF vegzamin.zdal = 'T' THEN
                UPDATE egzaminy
                SET punkty = ROUND(DBMS_RANDOM.VALUE(3,5),2)
                WHERE current c1;
            ELSE
                UPDATE egzaminy
                SET punkty = ROUND(DBMS_RANDOM.VALUE(2,2.99),2)
                WHERE current c1;
            END IF;
            FETCH c1 INTO vegzamin;
        END LOOP;
    END IF;
END;


DECLARE
    CURSOR c1 IS
        SELECT  zdal
        FROM egzaminy for update; -- blokuje tabele na czas operacji
    vegzamin c1%ROWTYPE;
    vpoints number; 
BEGIN
    OPEN c1;
    IF c1%isopen THEN
        FETCH c1 INTO vegzamin;
        WHILE c1%found LOOP
            IF vegzamin.zdal = 'T' THEN
                
                vpoints := ROUND(DBMS_RANDOM.VALUE(3,5),2);
                
            ELSE
                vpoints := ROUND(DBMS_RANDOM.VALUE(2,2.99),2);
            END IF;
            UPDATE egzaminy
                SET punkty=vpoints
                WHERE current of c1;
            FETCH c1 INTO vegzamin;
        END LOOP;
        CLOSE c1;
    END IF;
END;
```



198 

```sql

CREATE TABLE TLMOsrodki 
(
    ROK NUMBER(4),
    MIESIAC NUMBER(2),
    ID_OSRODEK NUMBER,
    NAZWA_OSRODEK VARCHAR2(50),
    LICZBA NUMBER
);
 
 
BEGIN 
    FOR i IN (
        SELECT rok, miesiac, id_osrodek, nazwa_osrodek, COUNT(*) liczba FROM 
            (
                SELECT EXTRACT(YEAR FROM data_egzamin) rok, EXTRACT(MONTH FROM data_egzamin) miesiac, o.id_osrodek, o.nazwa_osrodek, id_egzamin FROM osrodki o join egzaminy e ON o.id_osrodek = e.id_osrodek
            ) GROUP BY rok, miesiac, id_osrodek, nazwa_osrodek
    ) LOOP
        INSERT INTO TLMOsrodki VALUES (i.rok, i.miesiac, i.id_osrodek, i.nazwa_osrodek, i.liczba);
    END LOOP;
END ; 
)

```





ID_EGZAMINATOR	NAZWISKO	IMIE	MIASTO

ID_EGZAMIN	ID_STUDENT	ID_PRZEDMIOT	ID_EGZAMINATOR	DATA_EGZAMIN	ID_OSRODEK	ZDAL	PUNKTY


select DISTINCT r.ID_EGZAMINATOR, NAZWISKO, IMIE, DATA_EGZAMIN as Liczba from egzaminatorzy r left join egzaminy e on r.ID_EGZAMINATOR=e.ID_EGZAMINATOR GROUP BY r.ID_EGZAMINATOR, NAZWISKO, IMIE, DATA_EGZAMIN ORDER BY r.ID_EGZAMINATOR ASC;


```
DECLARE
    CoNajmn5 EXCEPTION;
    CURSOR c1 IS SELECT e.nazwisko, e.imie, 
    ey.data_egzamin, COUNT(ey.id_student) AS Liczba FROM egzaminatorzy e
    inner join egzaminy ey ON e.id_egzaminator = ey.id_egzaminator
    GROUP BY e.nazwisko, e.imie, ey.data_egzamin;
BEGIN
    FOR iterator IN c1 LOOP
        BEGIN
            IF iterator.Liczba>5 THEN RAISE CoNajmn5;
            END IF;
        EXCEPTION
            WHEN CoNajmn5 THEN
                DBMS_OUTPUT.Put_line(iterator.nazwisko || ' ' || iterator.imie || ' ' || 
               iterator.data_egzamin || ' ' || iterator.Liczba);
        END;
    END LOOP;
END;



DECLARE
    Uwaga EXCEPTION ;
    CURSOR CStudent IS SELECT s.ID_Student, Nazwisko, Imie,
    COUNT(ID_Egzamin) AS Liczba FROM Studenci s LEFT JOIN Egzaminy e
    ON s.ID_Student = e.ID_Student GROUP BY s.ID_Student, Nazwisko, Imie ;
BEGIN
    FOR vCur IN CStudent LOOP
    BEGIN
        IF vCur.Liczba = 0 THEN RAISE Uwaga ;
        END IF ;
        EXCEPTION
            WHEN Uwaga THEN
                Dbms_output.Put_line(vCur.ID_Student || ' ' ||
                vCur.Nazwisko || ' ' || vCur.Imie) ;
            END ;
    END LOOP ;
END ; 





DECLARE
    CURSOR c_osrodki IS
    SELECT
        id_osrodek,
        nazwa_osrodek
    FROM
        osrodki
    WHERE
        UPPER(nazwa_osrodek) = 'LBS';
 
    examscount      INTEGER;
    no_exams_found_exception EXCEPTION;
    osrodekexists   INTEGER;
BEGIN
    SELECT
        1
    INTO osrodekexists
    FROM
        osrodki
    WHERE
        UPPER(nazwa_osrodek) = 'LBS';
 
    BEGIN
        FOR cur IN c_osrodki LOOP
            BEGIN
                SELECT DISTINCT
                    COUNT(id_egzamin)
                INTO examscount
                FROM
                    egzaminy
                WHERE
                    id_osrodek = cur.id_osrodek;
 
                IF examscount = 0 THEN
                    RAISE no_exams_found_exception;
                ELSE
                    DBMS_OUTPUT.put_line('Id osrodka: '
                                         || cur.id_osrodek
                                         || ' liczba egzaminow:'
                                         || examscount);
                END IF;
 
            EXCEPTION
                WHEN no_exams_found_exception THEN
                    DBMS_OUTPUT.put_line('Osrodek o id ' || cur.id_osrodek
                                         || ' nie uczestniczyl w egzaminach');
            END;
        END LOOP;
 
    END;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('Osrodek o podanej nazwie nie istnieje');
END;





DECLARE
    zdawali EXCEPTION;
    point_ NUMBER;
    CURSOR c1 IS SELECT s.id_student, s.nazwisko , s.imie,
    COUNT(ey.punkty) AS Suma FROM studenci s
    inner join egzaminy ey ON s.id_student = ey.id_student
    GROUP BY s.id_student, s.nazwisko , s.imie;
    
    FUNCTION punkty ( id_ NUMBER)
    RETURN NUMBER IS poi NUMBER DEFAULT 0;
    BEGIN 
        select SUM(punkty) into point_
        from egzaminy where id_student = id_;
        RETURN point_;
    END punkty;
    
    
BEGIN
    FOR iterator IN c1 LOOP
        BEGIN
            IF punkty(iterator.id_student)>0 THEN RAISE zdawali;
            ELSE
                DBMS_OUTPUT.Put_line(iterator.nazwisko || ' ' || iterator.imie || ' Nie zdawal jeszcze egzaminu');
            END IF;    
        EXCEPTION
            WHEN zdawali THEN
                DBMS_OUTPUT.Put_line(iterator.nazwisko || ' ' || iterator.imie || ' '
                || punkty(iterator.id_student));
        END;
    END LOOP;
END;

```


90
```sql

```

91
```sql
select o.id_osrodek, o.nazwa_osrodek, o.miasto from osrodki o inner join egzaminy e on e.id_osrodek = o.id_osrodek where e.zdal ='N' and e.id_student = 0000050
```

92
```sql
select DISTINCT s.id_student, s.nazwisko, s.imie from studenci s inner join egzaminy e on e.id_student = s.id_student where e.id_student not in (select id_student from przedmioty p inner join egzaminy e on p.id_przedmiot = e.id_przedmiot  where nazwa_przedmiot = 'Bazy danych') order by s.id_student


SELECT DISTINCT s.id_student, s.imie, s.nazwisko FROM STUDENCI s
LEFT JOIN EGZAMINY e ON e.id_student = s.id_student
WHERE s.ID_STUDENT NOT IN (SELECT DISTINCT id_student from EGZAMINY e2
INNER JOIN Przedmioty p ON e2.id_przedmiot = p.id_przedmiot
WHERE UPPER(p.nazwa_przedmiot) = 'BAZY DANYCH')
ORDER BY s.id_student
```

93
```sql
select DISTINCT s.id_osrodek, s.nazwa_osrodek, s.miasto from osrodki s 
inner join egzaminy e on e.id_osrodek = s.id_osrodek
where e.id_osrodek not in 
(select id_osrodek from przedmioty p 
inner join egzaminy e on p.id_przedmiot = e.id_przedmiot 
where nazwa_przedmiot = 'Bazy danych') 
order by s.id_osrodek
```

94
```sql
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

```


95
```sql
select o.id_osrodek, o.nazwa_osrodek from osrodki o 
left join egzaminy e
on o.id_osrodek = e.id_osrodek
where e.id_osrodek  not in   (select e.ID_OSRODEK from egzaminy e 
inner join studenci s on e.ID_STUDENT = s.ID_STUDENT where s.nazwisko = 'Nowak')
order by o.id_osrodek
```


96
```sql

select p.nazwa_przedmiot, count(e.id_przedmiot) 
from egzaminy e 
inner join przedmioty p on e.id_przedmiot = p.id_przedmiot  
group by p.id_przedmiot, p.nazwa_przedmiot
having count(e.id_przedmiot)  = (select  max(count(id_egzamin)) from egzaminy group by id_przedmiot)


select p.nazwa_przedmiot , count(e.id_egzamin) from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by p.nazwa_przedmiot
having count(e.id_egzamin) = (select max(count(id_egzamin)) from egzaminy group by id_przedmiot)

```

97
```sql
SELECT o.id_osrodek, o.nazwa_osrodek , COUNT(id_egzamin) 
FROM   osrodki o
INNER JOIN egzaminy e ON e.id_osrodek = o.id_osrodek  
GROUP BY  o.id_osrodek, o.nazwa_osrodek
HAVING COUNT(id_egzamin)  = (SELECT MIN(COUNT(id_egzamin)) FROM egzaminy 
GROUP BY id_osrodek)

select p.id_osrodek, p.nazwa_osrodek, count(e.id_egzamin) 
from  osrodki p
inner join egzaminy e on e.id_osrodek = p.id_osrodek  
group by p.id_osrodek , p.nazwa_osrodek
having count(e.id_egzamin)  = (select  min(count(id_egzamin)) from egzaminy 
group by id_osrodek)
```

98





```sql
select s.id_student, s.imie, s.nazwisko, count(e.id_egzamin) as Liczba from studenci s
inner join egzaminy e on  e.id_student =  s.id_student
inner join osrodki o on  e.id_osrodek =  o.id_osrodek 
where  e.zdal = 'T' and UPPER(o.nazwa_osrodek) = 'CKMP'
group by  s.id_student, s.imie, s.nazwisko
having count(e.id_egzamin) = (select min(count(id_egzamin)) from egzaminy e inner join osrodki o 
on o.id_osrodek = e.id_osrodek
where o.nazwa_osrodek = 'CKMP' 
group by e.id_student, e.id_osrodek)
```

99
```sql

    
    select 
    g.id_egzaminator,
    g.nazwisko, 
    g.imie, count(DISTINCT e.id_student)
from egzaminatorzy g
inner join egzaminy e on e.id_egzaminator = g.id_egzaminator

group by g.id_egzaminator, g.nazwisko, g.imie
having count(DISTINCT e.id_student) = (
select max(count(DISTINCT e.id_student)) from egzaminy e 
group by e.id_egzaminator)

```

100
```sql
select  o.id_osrodek, o.nazwa_osrodek, e.data_egzamin from osrodki o 
inner join egzaminy e on e.id_osrodek = o.id_osrodek
where (e.data_egzamin, e.id_przedmiot) in 
(select max(e1.data_egzamin), e1.id_przedmiot 
from egzaminy e1 
group by e1.id_przedmiot)
```


101
```sql
select o.id_osrodek, o.nazwa_osrodek from osrodki o
left join egzaminy e1 on o.id_osrodek = e1.id_osrodek
where  not exists (select e.id_osrodek from egzaminy e 
inner join egzaminatorzy eg on  eg.id_egzaminator = e.id_egzaminator
where eg.nazwisko='Muryjas'
)


select o.id_osrodek, o.nazwa_osrodek from osrodki o
left join egzaminy e on e.id_osrodek = o.id_osrodek 
where e.id_osrodek not in (
select e1.id_osrodek from egzaminy e1 
inner join egzaminatorzy g on g.id_egzaminator = e1.id_egzaminator 
where g.nazwisko = 'Muryjas')
```


102
```sql
select o.id_osrodek, p.nazwa_przedmiot, count(e.id_egzamin) from egzaminy e
inner join  osrodki o on e.id_osrodek = o.id_osrodek
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by o.id_osrodek,  p.nazwa_przedmiot
having count(e.id_egzamin) in (select max(count(e1.id_egzamin)) from egzaminy e1 
where o.id_osrodek = e1.id_osrodek
group by  e1.id_przedmiot)
order by 3
```

103
```sql
select p.id_przedmiot, p.nazwa_przedmiot, s.id_student, s.nazwisko, s.imie from egzaminy e
inner join przedmioty p on e.id_przedmiot = p.id_przedmiot
inner join studenci s on e.id_student = s.id_student
where e.data_egzamin = (select min(e1.data_egzamin) from egzaminy e1
where e1.id_przedmiot = p.id_przedmiot)
group by p.id_przedmiot, p.nazwa_przedmiot, s.id_student, s.nazwisko, s.imie
order by 4

```

104
```sql
select g.id_egzaminator, g.nazwisko, s.id_student, s.nazwisko, s.imie, e.data_egzamin from egzaminy e
inner join studenci s on e.id_student = s.id_student
inner join egzaminatorzy g on e.id_egzaminator = g.id_egzaminator
where e.data_egzamin = (select min(e1.data_egzamin) from egzaminy e1
where g.id_egzaminator = e1.id_egzaminator 
group by e1.id_egzaminator)
and g.nazwisko = 'Muryjas'
group by g.id_egzaminator, g.nazwisko, s.id_student, s.nazwisko, s.imie, e.data_egzamin 
```


105
```sql
select e.id_osrodek, p.id_przedmiot, p.nazwa_przedmiot, count(*) from  egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by e.id_osrodek, p.id_przedmiot, p.nazwa_przedmiot
having count(*) = (select max(count(e1.id_osrodek)) from egzaminy e1 
right join osrodki o on e.id_osrodek = o.id_osrodek
where o.nazwa_osrodek = 'CKMP' and e1.id_osrodek = e.id_osrodek
group by e1.id_przedmiot, e1.id_osrodek)
order by e.id_osrodek
```

106
```sql
select e.id_przedmiot, s.id_student, s.nazwisko, s.imie , count(*) from egzaminy e
inner join studenci s on s.id_student = e.id_student
group by e.id_przedmiot, s.id_student, s.nazwisko, s.imie
having count(*) = (
select max(count(e1.id_przedmiot)) from egzaminy e1 
where e.id_przedmiot = e1.id_przedmiot
group by  e1.id_przedmiot)
order by e.id_przedmiot
```


107
```sql
select e.id_student, p.id_przedmiot, p.nazwa_przedmiot, count(*) from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot
group by e.id_student, p.id_przedmiot, p.nazwa_przedmiot
having count(*) = (
select max(count(*)) from egzaminy e1
where p.id_przedmiot=e1.id_przedmiot
group by e1.id_student
)
order by 3
```

108
```sql

select e.id_osrodek, e.id_student,  min(e.data_egzamin), max(e.data_egzamin) from 
egzaminy e 
group by e.id_osrodek,  e.id_student
having (min(e.data_egzamin), max(e.data_egzamin)) in ( select min(e1.data_egzamin), max(e1.data_egzamin) from egzaminy e1
where e.id_osrodek=e1.id_osrodek
group by e.id_osrodek)


```

109

```sql
select e.id_przedmiot, e.id_egzaminator, e.id_osrodek, p.nazwa_przedmiot,  count(*) from egzaminy e
inner join przedmioty p on p.id_przedmiot = e.id_przedmiot 
group by e.id_przedmiot, p.nazwa_przedmiot, e.id_egzaminator, e.id_osrodek, p.nazwa_przedmiot
having count(*) in 
(select max(count(*)) from egzaminy e1
inner join osrodki o on o.id_osrodek = e.id_osrodek
inner join egzaminatorzy g on g.id_egzaminator = e.id_egzaminator 
where g.nazwisko = 'Muryjas' and o.nazwa_osrodek = 'CKMP' and e1.id_osrodek = e.id_osrodek and e1.id_egzaminator = e.id_egzaminator
group by e1.id_przedmiot)


```


110
```sql
select e.id_osrodek, s.id_student, o.nazwa_osrodek, count(*) from studenci s
inner join egzaminy e on e.id_student = s.id_student
inner join osrodki o  on e.id_osrodek = o.id_osrodek
where s.nazwisko = 'Nowak' and e.zdal = 'T'
group by  e.id_osrodek, s.id_student, o.nazwa_osrodek
having count(*) in ( 
select min(count(e1.id_student)) from egzaminy e1
inner join studenci s1 on e1.id_student = s1.id_student
where s1.nazwisko = 'Nowak' and e1.zdal = 'T'
group by e1.id_osrodek)



```

111
```sql
select s.id_student,s.imie,s.nazwisko,e.id_osrodek, count(*) from studenci s
inner join egzaminy e  on s.id_student = e.id_student
where e.zdal = 'N'
group by s.id_student,s.imie,s.nazwisko,e.id_osrodek
having count(*) in  (select max(count(e1.id_student)) from egzaminy e1
where e1.zdal='N' and e.id_osrodek = e1.id_osrodek 
group by e1.id_osrodek, e1.id_student
)
order by e.id_osrodek

```
112
```sql
select g.id_egzaminator, g.nazwisko, g.imie, e.id_osrodek, min(e.data_egzamin), max(e.data_egzamin) from egzaminy e
inner join egzaminatorzy g on g.id_egzaminator = e.id_egzaminator 
group by  g.id_egzaminator, g.nazwisko, g.imie, e.id_osrodek
having (min(e.data_egzamin), max(e.data_egzamin)) in 
(select min(e1.data_egzamin), max(e1.data_egzamin) from 
egzaminy e1 
where e1.zdal='T'
group by 
e1.id_egzaminator, e1.id_osrodek)
```
113
```sql
select extract(month from e.data_egzamin), extract(year from e.data_egzamin), e.id_osrodek , count(*) from egzaminy e
inner join osrodki o on o.id_osrodek = e.id_osrodek
group by extract(month from e.data_egzamin), extract(year from e.data_egzamin), e.id_osrodek
having count(*) in
( select max(count(*)) from egzaminy e1
inner join osrodki o on o.id_osrodek = e1.id_osrodek 
where o.nazwa_osrodek='CKMP' and e.id_osrodek=e1.id_osrodek
group by  extract(month from e1.data_egzamin),EXTRACT(year from e1.data_egzamin),e1.id_osrodek)
```

114
```sql
select extract(month from e.data_egzamin), extract(year from e.data_egzamin), count(*) from egzaminy e
group by extract(month from e.data_egzamin), extract(year from e.data_egzamin)
having count(*) in
( select max(count(*)) from egzaminy e1
inner join osrodki o on o.id_osrodek = e1.id_osrodek 
where  EXTRACT(year from e1.data_egzamin) = EXTRACT(year from e.data_egzamin)
group by  extract(month from e1.data_egzamin),EXTRACT(year from e1.data_egzamin))

```

115
```sql
select extract(month from e.data_egzamin), extract(year from e.data_egzamin),e.id_osrodek, count(*) from egzaminy e
group by extract(month from e.data_egzamin), extract(year from e.data_egzamin), e.id_osrodek
having count(*) in
( select max(count(*)) from egzaminy e1
inner join osrodki o on o.id_osrodek = e1.id_osrodek 
where  EXTRACT(year from e1.data_egzamin) = EXTRACT(year from e.data_egzamin) and  o.nazwa_osrodek = 'CKMP' and e.id_osrodek=e1.id_osrodek
group by  extract(month from e1.data_egzamin),EXTRACT(year from e1.data_egzamin))
```

116
```sql

```

188
```sql
DECLARE
    CURSOR c1 IS
    SELECT
        e.id_egzaminator,
        e.imie,
        e.nazwisko
    FROM
        egzaminatorzy e;

    i NUMBER DEFAULT 1;
BEGIN FOR x IN c1 loop 
    dbms_output.put_line(i
                                           || ' '
                                           || x.id_egzaminator
                                           || ' '
                                           || x.imie
                                           || ' '
                                           || x.nazwisko);

     i:= i + 1;
     end loop;
end;
```

189
```sql
DECLARE
    cursor c1 is select id_osrodek, count(*) as liczba from egzaminy group by id_osrodek having count(*)<5;
    cursor c2 is select id_osrodek, count(*) as liczba from egzaminy group by id_osrodek having count(*) > 4 and count(*) < 11;
    cursor c3 is select id_osrodek, count(*) as liczba from egzaminy group by id_osrodek having count(*) > 10;
BEGIN 
    FOR x IN c1 loop 
        dbms_output.put_line(x.id_osrodek || ' '||x.liczba);
     end loop;
     dbms_output.put_line('----------------------------');
     FOR x IN c2 loop 
        dbms_output.put_line(x.id_osrodek || ' '||x.liczba);
     end loop;
     dbms_output.put_line('----------------------------');
     FOR x IN c3 loop 
        dbms_output.put_line(x.id_osrodek || ' '||x.liczba);
     end loop;
end;
```

190
```sql
DECLARE
    cursor c1 is select id_przedmiot, count(*) as liczba from egzaminy group by id_przedmiot order by 2 desc;
    mvar c1%rowtype;
BEGIN 
    open c1;
    if c1%isopen then
    fetch c1 into mvar;
    while c1%found loop
        exit when c1%rowcount > 3;
        DBMS_OUTPUT.PUT_LINE(mvar.id_przedmiot||' '||mvar.liczba);
        fetch c1 into mvar;
    end loop;
    end if;
    
end;
```

191
```sql
declare
    cursor c1 is
    select DISTINCT TO_DATE(data_egzamin, 'dd-mm-yyyy') as mydate
    from egzaminy e
    order by 1 desc;
    
    cursor c2( mdate egzaminy.data_egzamin%TYPE)
    is
    select 
        id_student,
        data_egzamin
    from 
        egzaminy
    Where
        TO_DATE(data_egzamin, 'dd-mm-yyyy') = mdate;
    mydate  egzaminy.data_egzamin%TYPE;
    mvalue c2%rowtype;
BEGIN
    open c1;
    if c1%isopen then
        FETCH c1 into mydate;
        While c1%found loop
            exit when c1%rowcount > 3;
            open c2(mydate);
            if c2%isopen then
                FETCH c2 into mvalue;
                while c2%found loop
                    dbms_output.put_line(mvalue.id_student||' '|| mvalue.data_egzamin);
                    FETCH c2 into mvalue;
                end loop;
            end if;
            close c2;
            FETCH c1 into mydate;
        end loop;
    end if;
end;
            
    
```


192
```sql
DECLARE
    CURSOR c1 IS
    SELECT
        id_osrodek
    FROM
        osrodki
    WHERE
        upper(nazwa_osrodek) = upper('CKMP');

cursor c2(osr number) is select id_student, count(*) as liczba from egzaminy where id_osrodek=osr group by id_student order by 2; 
mvar c2%rowtype;
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

```


193
```sql 
declare
begin
    insert into Przedmioty values(10, 'Hurtowania danych', null);
    exception
    when DUP_VAL_ON_INDEX then
        dbms_output.put_line('Podany przedmiot juz istniej');
end;
        
declare
    mvar varchar2(20);
    cursor c1 is select id_przedmiot into mvar from przedmioty where id_przedmiot= '10';
    mvar2 varchar2(20);
begin
    open c1;
    if c1%isopen then
    fetch c1 into mvar2;
    if c1%notfound then
        insert into Przedmioty values (10, 'Hurtowania danych', null);
    end if;
    end if;
end;
        
DECLARE
    mvar varchar2(20);
    cursor c1 is select id_przedmiot into mvar from przedmioty where id_przedmiot= '10';
    mvar2 varchar2(20);
begin
    open c1;
    if c1%isopen then
    fetch c1 into mvar2;
    if c1%notfound then
        insert into Przedmioty values (10, 'Hurtowania danych', null);
         dbms_output.put_line('Udalo sie dodac nowy przedmiot');
    else 
         dbms_output.put_line('Podany przedmiot juz istniej');
    end if;
    end if;
end;

``` 

194
```sql
DECLARE
    cursor c1 is 
        select id_egzamin, zdal from egzaminy for update of punkty;
        rval number;
begin
    for x in c1 loop
        if x.zdal='T' then
            rval := ROUND(dbms_random.value(3,5),2);
        else
            rval := ROUND(dbms_random.value(2,3),2);
        end if;
        UPDATE egzaminy set punkty=rval where CURRENT of c1;
    end loop;
end;
        
    
```
```sql
195.

DECLARE

    cursor c1 is 
        select id_student, nazwisko, imie from studenci;
    cursor c2 is
        select id_przedmiot, nazwa_przedmiot from przedmioty;
    cursor c3 (przed egzaminy.id_przedmiot%type, stud egzaminy.id_student%type) is 
        select count(*) as liczba from egzaminy where id_przedmiot = przed and id_student = stud order by 1;

begin
    for x in c1 loop
    dbms_output.put_line(x.id_student||' '||x.nazwisko||' '||x.imie);
    dbms_output.put_line('--------------------------------------------');
        for y in c2 loop
            for z in c3(y.id_przedmiot, x.id_student) loop
                dbms_output.put_line('    '||y.id_przedmiot||' '||y.nazwa_przedmiot||': '||z.liczba);
            end loop;
        end loop;
    end loop;
end;
       





198.
declare
begin 
for x in (select rok,miesiac,id_osrodek,nazwa_osrodek,count(*) as liczba from
            (select extract(year from e.data_egzamin) as rok, EXTRACT(month from e.data_egzamin) as miesiac,  
            e.id_osrodek,o.nazwa_osrodek from egzaminy e
            inner join osrodki o on o.id_osrodek = e.id_osrodek
            )
            group by rok, miesiac, id_osrodek, nazwa_osrodek) loop
            insert into tlmosrodki values(x.rok,x.miesiac,x.id_osrodek,x.nazwa_osrodek,x.liczba);
end loop;
end;
    


206.
declare 
    cursor c1 is select id_przedmiot, count(*) as liczba from egzaminy group by id_przedmiot;
begin
    for x in c1 loop
    BEGIN
        if x.liczba = 0  then raise no_data_found;
        end if;
        EXCEPTION
        when no_data_found then
            DBMS_OUTPUT.put_line('Brak egzaminow z przedmiotu, o indeksie: '||x.id_przedmiot);
        end;
    end loop;
end;




207.

declare 
    cursor c1 is select id_egzaminator, nazwisko, imie from egzaminatorzy;
    cursor c2 (mvar egzaminy.id_egzaminator%type) is select data_egzamin, count(*) as liczba from egzaminy where id_egzaminator = mvar group by data_egzamin;
    over5 exception;
begin 
    for x in c1 loop
        for y in c2(x.id_egzaminator) loop
        begin
            if y.liczba > 3 then RAISE over5;
            end if;
            exception
            when over5 then
                DBMS_OUTPUT.PUT_LINE(x.id_egzaminator||' '||x.imie||' ' ||x.nazwisko||' przeprowadził '||y.liczba|| ' egzaminów w dniu '||y.data_egzamin);
            end;
        end loop;
    end loop;
end;

208.
DECLARE
    egzaminator_nie exception;
    cursor c1 is select id_egzaminator, imie  from egzaminatorzy where upper(nazwisko) ='MURYJAS' group by id_egzaminator, imie;
    cursor c2 (mvar egzaminy.id_egzaminator%type) is select count(*) as liczba from egzaminy where mvar=id_egzaminator
    group by id_egzaminator;
    data c1%rowtype;
begin
    open c1;
    fetch c1 into data;
    begin
        IF c1%NOTFOUND then RAISE egzaminator_nie;
        else
            while c1%found loop
                for x in c2(data.id_egzaminator) loop
                    dbms_output.put_line(data.id_egzaminator || ' ' || data.imie||' '||x.liczba);
                end loop;
                fetch c1 into data;
            end loop;
        end if;
        exception
        when egzaminator_nie then
            DBMS_OUTPUT.put_line('Egzaminator o podanym nazwisku nie istnieje');
        end;
    close c1;
end;

209.
declare
    nie_ma EXCEPTION;
    cursor c1 is select id_osrodek from osrodki where upper(nazwa_osrodek) = 'LBS' group by id_osrodek;
    cursor c2 (id_os egzaminy.id_osrodek%type) is select count(*) liczba from egzaminy where id_osrodek = id_os group by id_osrodek;
    mvar c1%rowtype;
begin 
    open c1;
    fetch c1 into mvar;
    begin
        if c1%notfound then raise nie_ma;
        else
            while c1%found loop
                for x in c2(mvar.id_osrodek) loop
                    dbms_output.put_line(mvar.id_osrodek || ' ' || x.liczba);
                end LOOP;
                fetch c1 into mvar;
            end loop;
        end if;
        exception
        when nie_ma then
            dbms_output.put_line('Nie ma osrodkow o podanej nazwie');
        end;
    close c1;
end;

declare
cursor c1 is select id_osrodek,nazwa_osrodek from osrodki where nazwa_osrodek='LBS';
osrodekistnieje number;
counter number;
begin
select distinct 1 into osrodekistnieje from osrodki where nazwa_osrodek='LBS';
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
    procedure osrodek( id_os osrodki.id_osrodek%type) is
        cursor c1 is select id_osrodek, nazwa_osrodek from osrodki where id_osrodek = id_os;
        exist number;
        begin
            select 1 into exist from osrodki where id_osrodek = id_os;
            for x in c1 loop
                DBMS_OUTPUT.PUT_LINE(x.id_osrodek||' ' ||x.nazwa_osrodek);
            end loop;
            exception
            when no_data_found then
                DBMS_OUTPUT.PUT_LINE('Nie ma takiego id '||id_os);
    end osrodek;
begin 
    for y in (select distinct id_osrodek from egzaminy order by 1) loop
        osrodek(y.id_osrodek);
    end loop;
end;    



257.

declare
    point number;
    function count_point(id_st number)return number is
        vpoints number default 0;
        b_table number;
        begin
            select DISTINCT 1 into b_table from egzaminy where id_student = id_st;
            select sum(punkty) into vpoints from egzaminy where id_student=id_st;
            return vpoints;
            exception
            when no_data_found then return vpoints;
        end count_point;
begin
    for x in (select id_student from studenci) loop
        if count_point(x.id_student) > 0 then
            dbms_output.put_line ('Student otrzymal '|| count_point(x.id_student)||'  ' ||x.id_student);
        else
            dbms_output.put_line ('Student nie zdawal jeszcze egzaminu');
        end if;
    end loop;
end;



261.

declare
    
    function all_zdal(id_st egzaminy.id_student%type) return BOOLEAN is
        bool boolean default False;
        all_e number;
        s_e number;
        begin
            select count(*) into all_e from przedmioty;
            select count(*) into s_e from egzaminy where id_student=id_st and zdal='T';
            if all_e=s_e then
                bool :=True;
            end if;
                return bool;
        end all_zdal;
    procedure get_data(id_st studenci.id_student%type) is
        last_data date;
        cursor c1 is select max(data_egzamin) into last_data from egzaminy where id_student=id_st;
        begin
            update studenci set NR_ECDL=id_st, DATA_ECDL=last_data where id_student = id_st;
    end get_data;
begin
    for x in (select id_student from studenci) loop
        if all_zdal(x.id_student) then
            get_data(x.id_student);
        else
            update studenci set NR_ECDL=null, Data_ECDL=null where id_student = x.id_student;
        end if;
    end loop;
end;
         





declare
    
        
    function all_zdal(id_st egzaminy.id_student%type) return BOOLEAN is
        bool boolean default False;
        all_e number;
        s_e number;
        begin
        select count(*) into all_e from przedmioty;
            select count(*) into s_e from egzaminy where id_student=id_st and zdal='T';
            if all_e=s_e then
                bool :=True;
            end if;
                return bool;
        end all_zdal;
        
    procedure get_data(id_st studenci.id_student%type) is
        cursor c1 is select nr_ecdl, data_ecdl from studenci where id_student=id_st for update of nr_ecdl, data_ecdl;
        mdate date;
        FUNCTION get_d(id_st egzaminy.id_student%type) return date is
            last_date date DEFAULT null;
            begin
                select max(data_egzamin) into last_date from egzaminy where id_student=id_st;
                return last_date;
                exception
                when no_data_found then
                    dbms_output.put_line('blad');
        end get_d;
        begin
            for x in c1 loop
                mdate := get_d(id_st);
                update studenci set nr_ecdl=id_st, data_ecdl=mdate where current of c1;
            end loop;
    end get_data;
    begin
    for x in (select id_student from studenci) loop
        if all_zdal(x.id_student) then
            get_data(x.id_student);
        else
            update studenci set NR_ECDL=null, Data_ECDL=null where id_student = x.id_student;
        end if;
    end loop;
end;



kolos 


declare
    cursor c1 is 
        select DISTINCT extract(year from data_egzamin) as rok from egzaminy order by rok;
    cursor c2 (year_ varchar2) is
        select 
            e.id_student,
            s.nazwisko,
            s.imie,
            count(e.id_egzamin) as liczba
        from egzaminy e
        inner join studenci s on
        e.id_student = s.id_student
        where extract(year from data_egzamin) = year_ and e.zdal='T'
        group by e.id_student, s.nazwisko, s.imie
        having 
            count(e.id_egzamin) = (
            select max(count(e1.id_egzamin)) from
                egzaminy e1 
                where extract(year from e1.data_egzamin) = year_ and e1.zdal='T'
                group by e1.id_student)
        order by liczba desc;
        
    point_ number;
    cursor c3 (rok varchar2, id_stud egzaminy.id_student%type) is select
        sum(e.punkty) as points from egzaminy e 
        where extract(year from e.data_egzamin) = rok and e.id_student = id_stud;
    
begin
    for x in c1 loop
        for y in c2(x.rok) loop
            open c3(x.rok, y.id_student);
            if c3%isopen then
                FETCH c3 into point_;
                    DBMS_OUTPUT.PUT_LINE('W '||x.rok||' najwiecej punktow, zdobyl '||y.id_student||' '||y.nazwisko||' '||y.imie||' sume: '||point_);
                
            else
                DBMS_OUTPUT.PUT_LINE('Error ');
            end if;
            close c3;
        end loop;
    end loop;
end;
      


DECLARE
    exTooManyExams EXCEPTION;
    
    CURSOR cYears IS
        SELECT DISTINCT EXTRACT(YEAR FROM data_egzamin) as rok FROM egzaminy
        ORDER BY rok ASC;
    
    CURSOR cExams(vYear VARCHAR2, vInst osrodki.id_osrodek%TYPE) IS
        SELECT egz.id_egzaminator, egz.imie, egz.nazwisko, COUNT(eg.id_egzamin) as exam_count FROM egzaminy eg
        JOIN egzaminatorzy egz ON egz.id_egzaminator = eg.id_egzaminator
        WHERE eg.id_osrodek = vInst
        AND EXTRACT(YEAR FROM eg.data_egzamin) = vYear
        GROUP BY egz.id_egzaminator, egz.imie, egz.nazwisko;
BEGIN
    FOR vYear IN cYears LOOP
        FOR vInst IN (SELECT * FROM osrodki ORDER BY id_osrodek) LOOP
            FOR vExam IN cExams(vYear.rok, vInst.id_osrodek) LOOP
                BEGIN
                    IF vExam.exam_count > 50 THEN
                        RAISE exTooManyExams;
                    END IF;
                EXCEPTION
                    WHEN exTooManyExams THEN
                        DBMS_OUTPUT.PUT_LINE('W roku ' || vYear.rok || ' egzaminator #' || vExam.id_egzaminator || ' o nazwisku ' || vExam.imie || ' ' || vExam.nazwisko || ' przeprowadzil w osrodku #' || vInst.id_osrodek || ' (' || vInst.nazwa_osrodek || ') ' || vExam.exam_count || ' egzaminow');
                END;
            END LOOP;
        END LOOP;
    END LOOP;
END;




CREATE OR REPLACE FUNCTION CheckPoints(exam_id egzaminy.id_egzamin%TYPE) RETURN BOOLEAN IS
    vIsValid BOOLEAN;
    vPoints egzaminy.punkty%TYPE;
    vPassed egzaminy.zdal%TYPE;
BEGIN
    SELECT punkty INTO vPoints FROM egzaminy WHERE id_egzamin = exam_id;
    SELECT zdal INTO vPassed FROM egzaminy WHERE id_egzamin = exam_id;
    IF vPassed = 'T' AND (vPoints BETWEEN 3 AND 5) THEN
        RETURN TRUE;
    END IF;
    IF vPassed = 'N' AND (vPoints BETWEEN 2 AND 2.99) THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;

-- 2. sprawdzenie działania

DECLARE
    vExamCount NUMBER;
    vExamsValid NUMBER DEFAULT 0;
BEGIN
    SELECT COUNT(id_egzamin) INTO vExamCount FROM egzaminy;
    -- dbms_output.put_line('Ilosc egzaminow: ' || vExamCount);
    FOR exam IN (SELECT * FROM egzaminy ORDER BY id_egzamin) LOOP
        IF CheckPoints(exam.id_egzamin) THEN
            vExamsValid := vExamsValid + 1;
        ELSE
            dbms_output.put_line('Egzamin ' || exam.id_egzamin || ' oceniono niepoprawnie (zdal = ' || exam.zdal || ', punkty = ' || exam.punkty || ')');
        END IF;
    END LOOP;
    
    -- dbms_output.put_line('Ilosc sprawdzonych egzaminow: ' || vExamsValid);
    IF vExamsValid = vExamCount THEN
        dbms_output.put_line('Wszystkie egzaminy oceniono poprawnie');
    END IF;
END;



declare
    mdata date;
    cursor c2 (id_egz egzaminy.id_egzaminator%type, m_date egzaminy.data_egzamin%type, id_stud egzaminy.id_student%type) select is
        e.id_egzaminator
        e.id_student,
        s.imie,
        s.nazwisko
    from egzaminy e 
    inner join studenci s on e.id_student = s.id_student
    where e.id_egzaminator = id_egz 
        and e.data_egzamin = m_data
        and e.id_student = id_stud
    group by e.id_egzaminator
        e.id_student,
        s.imie,
        s.nazwisko;
    mdate_ date;
    
    function exist_egzam(nazwisko_u varchar2) return boolean is
        bool boolean DEFAULT false;
        MVAR NUMBER;
        begin
            SELECT 1 into mvar from egzaminatorzy where upper(nazwisko) = nazwisko_u group by id_egzaminator;
            return True;
            exception
            when no_data_found then
                return false;
    end;
    function max_data(id_eg egzaminy.id_egzaminator%type) return date is
        get_date date;
        begin
            select max(data_egzamin) into get_data from egzaminy where id_egzaminator = id_eg;
            return get_date;
            exception
            when no_data_found then 
                return null;
    end;

    
begin
    if(exist_egzam('Muryjas')) then
        for x in (select id_egzaminator from egzaminatorzy where upper(nazwisko) = 'Muryjas' group by id_egzaminator) loop
            if null<>  max_data(x.id_egzaminator) then
                mdate_ := max_data(x.id_egzaminator);
                for y in(select * from studenci) loop
                    for z in c2(x.id_egzaminator,mdate_, y.id_student) loop
                        dbms_output.put_line(z.id_student);
            else
                dbms_output.put_line('dany egzamiantor nie prowadzi egzaminow');
    else
         dbms_output.put_line('Nie ma takiego egzaminatora o podanym nazwisku');
            
    
    declare 
    cursor c1 is select id_egzaminator from egzaminatorzy where upper(nazwisko) = 'Muryjas' ;
    cursor c2 (id_egz egzaminy.id_egzaminator%type) is select 
        max(data_egzamin) 
        from egzaminy
        where id_egzaminator = id_egz
    group by id_egzaminator;
    mdata date;
    exist_eg number;
begin 
    select 1 into exist_eg from egzaminatorzy where upper(nazwisko)='Muryjas' group by nazwisko;
    for x in c1 loop
        DBMS_OUTPUT.PUT_LINE('dupa');
    end loop;
    exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nie ma tegiego egzaminatora o podanym nazwisku');
end;

begin
        select 1 into exist_eg from egzaminy where id_egzaminator=x.id_egzaminator group by id_egzaminator;
        for y in c2 loop
            for z in (select * from studenci) loop
                begin
                    select 1 into exist_eg from egzaminy where id_egzaminator =x.id_egzamiantor and data_egzamin = y.data_egzamin and id_student = z.id_student group by id_student, id_egzaminator;
                    DBMS_OUTPUT.PUT_LINE(z.id_student||' '||z.imie);
                    exception
                    when on_data_found then
                    DBMS_OUTPUT.PUT_LINE('Dany student nie zdawal danego dnia u tego egzaminatora');
            end loop;
        end loop;        
        exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Dany egzaminator nie prowadzil egzaminow');



declare 
    cursor c1 is select id_egzaminator from egzaminatorzy where upper(nazwisko) = 'MURYJAS' ;
    cursor c2 (id_egz egzaminy.id_egzaminator%type) is select 
        max(data_egzamin) as data_
        from egzaminy
        where id_egzaminator = id_egz
    group by id_egzaminator;
    mdata date;
    exist_eg number;
    exist_d number;
    exist_s number;
begin 
    select 1 into exist_eg from egzaminatorzy where upper(nazwisko)='MURYJAS' group by nazwisko;
    for x in c1 loop
        begin
            select DISTINCT 1 into exist_d from egzaminy where id_egzaminator=x.id_egzaminator ;
            for y in c2(x.id_egzaminator) loop
                 for z in (select * from studenci) loop
                    begin
                        
                        select 1 into exist_s from egzaminy where id_egzaminator =x.id_egzaminator and data_egzamin = y.data_ and id_student = z.id_student 
                        group by id_student, id_egzaminator;
                        DBMS_OUTPUT.PUT_LINE(z.id_student||' '||z.imie);
                        exception
                        when no_data_found then
                            DBMS_OUTPUT.PUT_LINE('Dany student nie zdawal danego dnia u tego egzaminatora');
                    
                    end;
                end loop;
            end loop;
            exception
            when no_data_found then
                DBMS_OUTPUT.PUT_LINE('Dany egzaminator nie prowadzil egzaminow');
        end;
    end loop;
    exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nie ma tegiego egzaminatora o podanym nazwisku');
end;





declare 
    cursor c1 is select id_egzaminator from egzaminatorzy where upper(nazwisko) = 'MURYJAS' ;
    cursor c2 (id_egz egzaminy.id_egzaminator%type) is select 
        max(data_egzamin) as data_
        from egzaminy
        where id_egzaminator = id_egz
    group by id_egzaminator;
    cursor c3 (id_egz egzaminy.id_egzaminator%type, mdata_ egzaminy.data_egzamin%type)
    is select 
        e.id_student,
        s.imie,
        s.nazwisko
        from
        egzaminy e
        inner join studenci s on 
        e.id_student = s.id_student
        where 
        e.data_egzamin = mdata_
        and
        e.id_egzaminator = id_egz
    group by
        e.id_student,
        s.imie,
        s.nazwisko;
    mdata date;
    exist_eg number;
    exist_d number;
    exist_s number;
begin 
    select 1 into exist_eg from egzaminatorzy where upper(nazwisko)='MURYJAS' group by nazwisko;
    for x in c1 loop
        begin
            select DISTINCT 1 into exist_d from egzaminy where id_egzaminator=x.id_egzaminator ;
            for y in c2(x.id_egzaminator) loop
                 for z in c3(x.id_egzaminator, y.data_) loop
                        DBMS_OUTPUT.PUT_LINE(z.id_student||' '||z.imie||z.id_student||' '||x.id_egzaminator);
                 end loop;
            end loop;
            exception
            when no_data_found then
                DBMS_OUTPUT.PUT_LINE('Dany egzaminator nie prowadzil egzaminow');
        end;
    end loop;
    exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nie ma tegiego egzaminatora o podanym nazwisku');
end;

CREATE OR REPLACE FUNCTION CheckPoints(exam_id egzaminy.id_egzamin%TYPE) RETURN BOOLEAN IS
    vIsValid BOOLEAN;
    vPoints egzaminy.punkty%TYPE;
    vPassed egzaminy.zdal%TYPE;
BEGIN
    SELECT punkty INTO vPoints FROM egzaminy WHERE id_egzamin = exam_id;
    SELECT zdal INTO vPassed FROM egzaminy WHERE id_egzamin = exam_id;
    IF vPassed = 'T' AND (vPoints BETWEEN 3 AND 5) THEN
        RETURN TRUE;
    END IF;
    IF vPassed = 'N' AND (vPoints BETWEEN 2 AND 2.99) THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;

-- 2. sprawdzenie działania

DECLARE
    vExamCount NUMBER;
    vExamsValid NUMBER DEFAULT 0;
BEGIN
    SELECT COUNT(id_egzamin) INTO vExamCount FROM egzaminy;
    -- dbms_output.put_line('Ilosc egzaminow: ' || vExamCount);
    FOR exam IN (SELECT * FROM egzaminy ORDER BY id_egzamin) LOOP
        IF CheckPoints(exam.id_egzamin) THEN
            vExamsValid := vExamsValid + 1;
        ELSE
            dbms_output.put_line('Egzamin ' || exam.id_egzamin || ' oceniono niepoprawnie (zdal = ' || exam.zdal || ', punkty = ' || exam.punkty || ')');
        END IF;
    END LOOP;
    
    -- dbms_output.put_line('Ilosc sprawdzonych egzaminow: ' || vExamsValid);
    IF vExamsValid = vExamCount THEN
        dbms_output.put_line('Wszystkie egzaminy oceniono poprawnie');
    END IF;
END;
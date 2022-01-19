

### Którzy studenci zdawali egzaminy w ciągu ostatnich 3 dni?


##### example 1

```sql
DECLARE
    vLast3Days DATE ;
    CURSOR c1 IS SELECT DISTINCT data_egzamin FROM egzaminy ORDER BY 1 DESC ;
    CURSOR c2 IS SELECT DISTINCT s.id_student, nazwisko, imie FROM studenci s
                    inner join egzaminy e ON s.id_student = e.id_student WHERE data_egzamin = vLast3Days ;
    vStudent c2%ROWTYPE ;
BEGIN
    OPEN c1 ;
    IF c1%ISOPEN THEN
       FETCH c1 INTO vLast3Days ;
       WHILE c1%FOUND LOOP
            DBMS_OUTPUT.put_line(TO_CHAR(vLast3Days, 'yyyy-mm-dd')) ;
            OPEN c2 ;
            IF c2%isopen THEN
                FETCH c2 INTO vStudent ;
                DBMS_OUTPUT.put_line(vStudent.id_student || ' ' || vStudent.Nazwisko || ' ' || vStudent.imie) ;
                CLOSE c2 ;
            END IF ;
            FETCH c1 INTO vLast3Days ;
            IF c1%rowcount > 3 THEN EXIT ; END IF ;
       END LOOP;
    END IF ;
END ;
```

##### example 2

```sql
DECLARE
    vLast3Days DATE ;
    CURSOR c1 IS SELECT DISTINCT data_egzamin FROM egzaminy ORDER BY 1 DESC ;
    CURSOR c2 IS SELECT DISTINCT s.id_student, nazwisko, imie FROM studenci s
                    inner join egzaminy e ON s.id_student = e.id_student WHERE data_egzamin = vLast3Days ;
    vStudent c2%ROWTYPE ;
BEGIN
    OPEN c1 ;
    IF c1%ISOPEN THEN
       FETCH c1 INTO vLast3Days ;
       WHILE c1%FOUND LOOP
            DBMS_OUTPUT.put_line(TO_CHAR(vLast3Days, 'yyyy-mm-dd')) ;
            OPEN c2 ;
            IF c2%isopen THEN
                FETCH c2 INTO vStudent ;
                DBMS_OUTPUT.put_line(vStudent.id_student || ' ' || vStudent.Nazwisko || ' ' || vStudent.imie) ;
                CLOSE c2 ;
            END IF ;
            FETCH c1 INTO vLast3Days ;
            IF c1%rowcount > 3 THEN EXIT ; END IF ;
       END LOOP;
       CLOSE c1 ;
    END IF ;
END ;
```
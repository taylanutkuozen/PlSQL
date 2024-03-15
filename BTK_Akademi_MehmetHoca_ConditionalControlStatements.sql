/*
    Conditional Control Statements (Kosullu Akis Kontrolleri)
Ýki tane akis kontrolu vardir :
1)IF
-IF THEN
-IF THEN ELSE
-IF THEN ELSIF
2)CASE
-SIMPLE CASE
-SEARCHED CASE
=IF=
1)IF THEN
*Syntax:
IF condition_1 THEN
    statement_1;
END IF;
2)IF THEN ELSE
*Syntax:
IF condition_1 THEN
    statement_1;
ELSE
    statement_2;
END IF;
3)IF THEN ELSIF
*Syntax:
IF condition_1 THEN
 statements_1;
ELSIF condition_2 THEN
    statements_2;
ELSIF condition_3 THEN
    statements_3;
...
ELSIF condition_n THEN
    statements_n;
ELSE
    statements_4;
END IF;
=CASE=
1)SIMPLE CASE
*Syntax :
CASE selector_value
    WHEN selector_value_1 THEN statements_1
    WHEN selector_value_2 THEN statements_2
    ...
    WHEN selector_value_n THEN statements_n
    [ELSE else_staements]--> Zorunlu bir alan degil
END CASE;
2)SEARCHED CASE
*Syntax:
CASE
    WHEN condition_1 THEN statements_1
    WHEN condition_2 THEN statements_2
    ...
    WHEN condition_n THEN statements_n
    [ELSE else_statements]--> Zorunlu bir alan degil
END CASE;
=IF 1.Kullanim=
DECLARE
    dogumTarihi date:=to_date('21/05/2010','dd/mm/yyyy');
    yasi    number(3);
BEGIN
    yasi:= (sysdate - dogumtarihi) / 365;
    IF yasi < 15 THEN
        dbms_output.put_line('Ben bir cocugum! Yasim : '||yasi);
    END IF;
END;
=IF 2.Kullanim=
DECLARE
    dogumTarihi date:=to_date('21/05/2000','dd/mm/yyyy'); --'21/05/2010' bu sekilde date veri type'ina deger atamayýz.
    yasi    number(3);
BEGIN
    --yasi:= sysdate - dogumtarihi; bu sonuc bize gun sayisini verecektir.
    yasi:= (sysdate - dogumtarihi) / 365;
    IF yasi < 15 THEN
        dbms_output.put_line('Ben bir cocugum! Yasim : '||yasi);
    ELSE
        dbms_output.put_line('Ben bir cocuk degilim! Yasim : '||yasi);
    END IF;
END;
=IF 3.Kullanim=
DECLARE
    dogumTarihi date:=to_date('21/05/2005','dd/mm/yyyy');
    yasi    number(3);
BEGIN
    yasi:= (sysdate - dogumtarihi) / 365;
    IF yasi < 15 THEN
        dbms_output.put_line('Ben bir cocugum! Yasim : '||yasi);
        dbms_output.put_line('Ben küçüðüm.');
    ELSIF yasi < 22 THEN
        dbms_output.put_line('Ben bir gencim. Yasim: '||yasi);
        IF yasi>17 THEN --NESTED IF
            dbms_output.put_line('Ben liseyi bitirdim');
        END IF;
    ELSIF yasi < 45 THEN
        dbms_output.put_line('Ben bir yetiskinim. Yasim: '||yasi);
    ELSIF yasi < 65 THEN
        dbms_output.put_line('Ben olgun bir insaným. Yasim: '||yasi);
    ELSE
        dbms_output.put_line('Ben yasli bir insanim. Yasim : '||yasi);
    END IF;
END;
=SEARCHED CASE=
DECLARE
    dogumTarihi date:=to_date('26/07/2004','dd/mm/yyyy');
    yasi    number(3);
    cikti varchar2(2000);
BEGIN
    yasi:= (sysdate - dogumtarihi) / 365;
    CASE
        WHEN yasi < 15 THEN cikti:='Ben bir çocuðum! Yaþým: '||yasi;
        WHEN yasi < 24 THEN cikti:='Ben bir gencim. Yaþým: '||yasi;
            CASE -- NESTED CASE
                WHEN yasi>17 THEN cikti:='Ben liseyi bitirdim';
            END CASE;
        WHEN yasi < 45 THEN cikti:='Ben bir yetiþkinim. Yaþým: '||yasi;
        WHEN yasi < 65 THEN cikti:='Ben olgun bir insaným. Yaþým: '||yasi;
        ELSE cikti:='Ben yaþlý bir insaným. Yaþým: '||yasi;  
    END CASE;
    dbms_output.put_lýne(cikti);
END;
=SIMPLE CASE=
DECLARE
    sayi number:=&sayi;--& sembolu ile input degeri kullanici tarafindan verilir.
    cikti varchar2(2000);
BEGIN
    CASE mod(sayi,2)
        WHEN 1 THEN cikti:='Tek sayi '||sayi;
            CASE
                NESTED CASE ornek verebilmek icin
            END CASE;
        ELSE cikti:='Çift sayi '||sayi;
    END CASE;
    dbms_output.put_line(cikti);
END;
*/
/*SEARCHED CASE*/
DECLARE
    sayi number:=&sayi;
    cikti varchar2(2000);
BEGIN
    CASE
        WHEN mod(sayi,2)=1 THEN cikti:='Tek sayidir. '||sayi;
        ELSE cikti:='Çift sayidir. '||sayi;
    END CASE;
    dbms_output.put_line(cikti);
END;
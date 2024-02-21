---=Exceptions-Error Handling=---
--PL/SQL Runtime Errors(program �al��ma esnas�nda olu�an hatalard�r.)
--Exceptions Neden Olu�ur?
--*Tasar�m hatalar�ndan,(Tablolarda yanl�� yap�land�rma. PK,FK, Index, Column)
--*Kodlama hatalar�ndan,(Yanl�� program ak��lar�)
--*Donan�m yetersizli�inden,(Disk, RAM, CPU yetersizli�i)
--*Ba��ml� yaz�l�m eksikli�inden,(Versiyon uyumsuzlu�u, lisans bitmesi, vb.)
--*Donan�m ar�zalar�ndan(Disk Bozulmalar� vs.)
--*ve di�er pek �ok sebepten olu�abilir.
--Program i�inde Exception neden yaz�lmal�d�r?
--*Program �al��mas� esnas�nda ortaya ��kabilecek t�m hatalar �nceden bilinemez.
--*Program�n kontrols�z bir bi�imde sonlanmamas� i�in, herhangi bir exception olu�tu�unda program�n kontroll� bir
--�ekilde devam etmesi ya da sonland�r�lmas� i�in exceptions yaz�lmal�d�r.
--Exception Gruplar�
--*Internally Defined Exceptions (Dahili Tan�ml� �stisnalar)
--=Internally Defined Exceptions=Error kodu olan fakat ismi olmayan istisnalard�r.
--*Predefined Exceptions (Tan�ml� �stisnalar)
--Predefined Exceptions=Error kodu ve ismi olan istisnalard�r.
--*User - Defined Exceptions
--User-Defined Exceptions=Programc� taraf�ndan yaz�lan istisnalard�r.
---------------------
--Internally Defined Exceptions (Dahili Tan�ml� �stisnalar)
--=Error kodu olan fakat ismi olmayan istisnalard�r.
--Bu istisnalar iki farkl� tan�mlama ile yakalan�p y�netilebilir.
--*PRAGMA_EXCEPTION_INIT veya EXCEPTION WHEN OTHERS
--Syntax:
--DECLARE
--my_exception(verilen_isim) exception(data_type);
--pragma exception_init(my_exception,-errCode);
--BEGIN
--...
--EXCEPTION when my_exception then
--    ...
--END;
---veya
--DECLARE
--my_exception(verilen_isim) exception(data_type);
--BEGIN
--...
--EXCEPTION when others then
--    ...
--END;
--Example-1:Pragma Exception Init
--DECLARE
--    my_exception EXCEPTION;
--    pragma exception_init(my_exception,-2292);--error kodunu kodu ilk �al��t�rd�k gelen hatadan ald�k.
--    my_exception2 EXCEPTION;
--    pragma exception_init(my_exception2,-00001);--Example 2: Pragma Exception_Init, Exception Scope
--BEGIN
--    insert into REGIONS values(70,'Avustralya');
--    BEGIN
--        delete from departments where department_id=90;
--        EXCEPTION  when my_exception then
--            dbms_output.put_line('Hata');
--    END;--Exception scope'u yapt�k. Hangi Exception hangisine ait oldu�unu ay�rt edebilmek i�in scope ihtiyac�m�z vard�r.
--    EXCEPTION  when my_exception2 then
--        dbms_output.put_line('Hata2');
--END;
--Example 3: Exception when others then
--DECLARE
--BEGIN
--    insert into REGIONS values(72,'Avustralya');
--    BEGIN
--        delete from departments where department_id=90;
--        EXCEPTION  when others then--hata kodlar�n� vermemi�tir.
--            dbms_output.put_line('Hata ' || sqlcode || ' ' || sqlerrm);--hata kodunu ve hata mesaj�n� almak i�in concat i�lemi yap�ld�.
--    END;--Exception scope'u yapt�k. Hangi Exception hangisine ait oldu�unu ay�rt edebilmek i�in scope ihtiyac�m�z vard�r.
--    EXCEPTION  when others then
--        dbms_output.put_line('Hata2 ' || sqlcode || ' ' || sqlerrm);
--END;
-----------------
--Predefined Exceptions(Tan�ml� �stisnalar)
--=Error kodu ve ismi olan istisnalard�r.
--*Bu istisnalar ismine �zel Exception yaz�larak yakalan�p y�netilebilir.
--ExceptionName=ACCESS_INTO_NULL ErrorCode=-6530 Description=Null tan�ml� bir nesneye bir de�er atand���nda olu�ur.(Developer-Defined Data Type - normal varchar,number gibi �nceden tan�ml� de�i�kenlerde olmaz.)
--ExceptionName=CASE_NOT_FOUND ErrorCode=-6592 Description=CASE kullan�ld���nda, se�eneklerden hi�biri sa�lanm�yor ve ELSE ifadesi yoksa olu�ur.
--ExceptionName=DUP_VAL_ON_INDEX ErrorCode=-0001 Description=UNIQUE INDEX tan�ml� bir kolona, kolonda var olan bir de�eri atamaya �al���ld���nda olu�ur.
--ExceptionName=INVALID_CURSOR ErrorCode=-01001 Description=A��k olmayan bir Cursor'dan de�er okunmaya �al���ld���nda olu�ur.
--ExceptionName=INVALID_NUMBER ErrorCode=-01722 Description=Say�sal tan�ml� bir kolona ya da de�i�kene String bir de�er atanmaya �al���ld���nda olu�ur.
--ExceptionName=NO_DATA_FOUND ErrorCode=-01403 Description=Select sonucu herhangi bir kay�t d�nm�yorsa, olu�ur.
--ExceptionName=TOO_MANY_ROWS ErrorCode=-01422 Description=Select sonucu birden fazla kay�t d�n�yorsa, olu�ur.
--ExceptionName=VALUE_ERROR ErrorCode=-06502 Description=Bir kolona ya da de�i�kene, tan�ml� oldu�u uzunluktan fazla de�er atanmaya �al���ld���nda, olu�ur.
--Syntax:
--DECLARE
--  ...
--BEGIN
--  ...
--  EXCEPTION when <exception_name> then
--      ...
--      when <exception_name> then //birden fazla exception i�in bu ifade ile s�n�rs�z bir �ekilde yaz�labilir.
--          ...
--END;
--Example 1:Predefined Exceptions(NoDataFound,TooManyRows,ValueError,ZeroDivide)
--DECLARE
--rec_emp employees%rowtype;
--val1 number(5);
--BEGIN
--    val1:=5000/0;
--    --val1:=0123456; Value Error
--    --select * INTO rec_emp from employees;--TOO_MANY_ROWS hatas� geldi. 
--    --where employee_id=1;*bu komutlarla durumda NO_DATA_FOUND
--    dbms_output.put_line(rec_emp.employee_id || ' ' || rec_emp.first_name);
--    EXCEPTION WHEN NO_DATA_FOUND THEN
--        dbms_output.put_line('1 nolu kay�t yok ' ||sqlcode||' '||sqlerrm);
--        when TOO_MANY_ROWS THEN
--             dbms_output.put_line('1 den fazla kay�t geliyor. ' ||sqlcode||' '||sqlerrm);
--        when VALUE_ERROR THEN
--             dbms_output.put_line('Yanl�� De�er. ' ||sqlcode||' '||sqlerrm);
--        when ZERO_DIVIDE THEN
--             dbms_output.put_line('S�f�rla b�lme yap�lamaz. ' ||sqlcode||' '||sqlerrm);
--END;
-----------------
---=USER DEFINED EXCEPTIONS=---
--Developer taraf�ndan olu�turulan istisnalar
--=Tan�ml� istisnalar d���nda, i�leme g�re yeni istisnalar olu�turulabilir.
--Syntax:
--DECLARE
    --<exception_name> EXCEPTION;
--BEGIN
--***�nceki exceptionlar� y�nlendirecek herhangi bir kod yazmad�k. Ancak bu exception'da �al��ma esnas�nda exception'a y�nlendirme i�lemini yap�yoruz.
--�rne�in:
--IF<condition> then
    --RAISE<exception_name>; raise anahtar kelimesi y�nlendirme yapmak i�in kullan�lmaktad�r.
--END IF;
--...
    --EXCEPTION when<exception_name> then
        --...
--END;
--Example : B�l�me g�re �al��an personel say�s�n� bulan PL/SQL program yazal�m. (B�l�m No runtime esnas�nda girilecektir)
DECLARE
    v_dept_id employees.department_id%type;
    v_toplam number;
    e_invalid_id exception;
BEGIN
    v_dept_id:=&dept_id;--& i�areti �nemlidir. yan�na isim olarak herhangi bir �ey yaz�labilir.
    IF(v_dept_id>0) then
        select count(*) into v_toplam from employees where department_id=v_dept_id;
        dbms_output.put_line('Toplam := '||v_toplam);
    ELSE
                RAISE e_invalid_id;
    END IF;
    EXCEPTION WHEN e_invalid_id THEN
        dbms_output.put_line('Bol�m numaras� negatif olamaz');
END;
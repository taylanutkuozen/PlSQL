---=Exceptions-Error Handling=---
--PL/SQL Runtime Errors(program çalýþma esnasýnda oluþan hatalardýr.)
--Exceptions Neden Oluþur?
--*Tasarým hatalarýndan,(Tablolarda yanlýþ yapýlandýrma. PK,FK, Index, Column)
--*Kodlama hatalarýndan,(Yanlýþ program akýþlarý)
--*Donaným yetersizliðinden,(Disk, RAM, CPU yetersizliði)
--*Baðýmlý yazýlým eksikliðinden,(Versiyon uyumsuzluðu, lisans bitmesi, vb.)
--*Donaným arýzalarýndan(Disk Bozulmalarý vs.)
--*ve diðer pek çok sebepten oluþabilir.
--Program içinde Exception neden yazýlmalýdýr?
--*Program çalýþmasý esnasýnda ortaya çýkabilecek tüm hatalar önceden bilinemez.
--*Programýn kontrolsüz bir biçimde sonlanmamasý için, herhangi bir exception oluþtuðunda programýn kontrollü bir
--þekilde devam etmesi ya da sonlandýrýlmasý için exceptions yazýlmalýdýr.
--Exception Gruplarý
--*Internally Defined Exceptions (Dahili Tanýmlý Ýstisnalar)
--=Internally Defined Exceptions=Error kodu olan fakat ismi olmayan istisnalardýr.
--*Predefined Exceptions (Tanýmlý Ýstisnalar)
--Predefined Exceptions=Error kodu ve ismi olan istisnalardýr.
--*User - Defined Exceptions
--User-Defined Exceptions=Programcý tarafýndan yazýlan istisnalardýr.
---------------------
--Internally Defined Exceptions (Dahili Tanýmlý Ýstisnalar)
--=Error kodu olan fakat ismi olmayan istisnalardýr.
--Bu istisnalar iki farklý tanýmlama ile yakalanýp yönetilebilir.
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
--    pragma exception_init(my_exception,-2292);--error kodunu kodu ilk çalýþtýrdýk gelen hatadan aldýk.
--    my_exception2 EXCEPTION;
--    pragma exception_init(my_exception2,-00001);--Example 2: Pragma Exception_Init, Exception Scope
--BEGIN
--    insert into REGIONS values(70,'Avustralya');
--    BEGIN
--        delete from departments where department_id=90;
--        EXCEPTION  when my_exception then
--            dbms_output.put_line('Hata');
--    END;--Exception scope'u yaptýk. Hangi Exception hangisine ait olduðunu ayýrt edebilmek için scope ihtiyacýmýz vardýr.
--    EXCEPTION  when my_exception2 then
--        dbms_output.put_line('Hata2');
--END;
--Example 3: Exception when others then
--DECLARE
--BEGIN
--    insert into REGIONS values(72,'Avustralya');
--    BEGIN
--        delete from departments where department_id=90;
--        EXCEPTION  when others then--hata kodlarýný vermemiþtir.
--            dbms_output.put_line('Hata ' || sqlcode || ' ' || sqlerrm);--hata kodunu ve hata mesajýný almak için concat iþlemi yapýldý.
--    END;--Exception scope'u yaptýk. Hangi Exception hangisine ait olduðunu ayýrt edebilmek için scope ihtiyacýmýz vardýr.
--    EXCEPTION  when others then
--        dbms_output.put_line('Hata2 ' || sqlcode || ' ' || sqlerrm);
--END;
-----------------
--Predefined Exceptions(Tanýmlý Ýstisnalar)
--=Error kodu ve ismi olan istisnalardýr.
--*Bu istisnalar ismine özel Exception yazýlarak yakalanýp yönetilebilir.
--ExceptionName=ACCESS_INTO_NULL ErrorCode=-6530 Description=Null tanýmlý bir nesneye bir deðer atandýðýnda oluþur.(Developer-Defined Data Type - normal varchar,number gibi önceden tanýmlý deðiþkenlerde olmaz.)
--ExceptionName=CASE_NOT_FOUND ErrorCode=-6592 Description=CASE kullanýldýðýnda, seçeneklerden hiçbiri saðlanmýyor ve ELSE ifadesi yoksa oluþur.
--ExceptionName=DUP_VAL_ON_INDEX ErrorCode=-0001 Description=UNIQUE INDEX tanýmlý bir kolona, kolonda var olan bir deðeri atamaya çalýþýldýðýnda oluþur.
--ExceptionName=INVALID_CURSOR ErrorCode=-01001 Description=Açýk olmayan bir Cursor'dan deðer okunmaya çalýþýldýðýnda oluþur.
--ExceptionName=INVALID_NUMBER ErrorCode=-01722 Description=Sayýsal tanýmlý bir kolona ya da deðiþkene String bir deðer atanmaya çalýþýldýðýnda oluþur.
--ExceptionName=NO_DATA_FOUND ErrorCode=-01403 Description=Select sonucu herhangi bir kayýt dönmüyorsa, oluþur.
--ExceptionName=TOO_MANY_ROWS ErrorCode=-01422 Description=Select sonucu birden fazla kayýt dönüyorsa, oluþur.
--ExceptionName=VALUE_ERROR ErrorCode=-06502 Description=Bir kolona ya da deðiþkene, tanýmlý olduðu uzunluktan fazla deðer atanmaya çalýþýldýðýnda, oluþur.
--Syntax:
--DECLARE
--  ...
--BEGIN
--  ...
--  EXCEPTION when <exception_name> then
--      ...
--      when <exception_name> then //birden fazla exception için bu ifade ile sýnýrsýz bir þekilde yazýlabilir.
--          ...
--END;
--Example 1:Predefined Exceptions(NoDataFound,TooManyRows,ValueError,ZeroDivide)
--DECLARE
--rec_emp employees%rowtype;
--val1 number(5);
--BEGIN
--    val1:=5000/0;
--    --val1:=0123456; Value Error
--    --select * INTO rec_emp from employees;--TOO_MANY_ROWS hatasý geldi. 
--    --where employee_id=1;*bu komutlarla durumda NO_DATA_FOUND
--    dbms_output.put_line(rec_emp.employee_id || ' ' || rec_emp.first_name);
--    EXCEPTION WHEN NO_DATA_FOUND THEN
--        dbms_output.put_line('1 nolu kayýt yok ' ||sqlcode||' '||sqlerrm);
--        when TOO_MANY_ROWS THEN
--             dbms_output.put_line('1 den fazla kayýt geliyor. ' ||sqlcode||' '||sqlerrm);
--        when VALUE_ERROR THEN
--             dbms_output.put_line('Yanlýþ Deðer. ' ||sqlcode||' '||sqlerrm);
--        when ZERO_DIVIDE THEN
--             dbms_output.put_line('Sýfýrla bölme yapýlamaz. ' ||sqlcode||' '||sqlerrm);
--END;
-----------------
---=USER DEFINED EXCEPTIONS=---
--Developer tarafýndan oluþturulan istisnalar
--=Tanýmlý istisnalar dýþýnda, iþleme göre yeni istisnalar oluþturulabilir.
--Syntax:
--DECLARE
    --<exception_name> EXCEPTION;
--BEGIN
--***Önceki exceptionlarý yönlendirecek herhangi bir kod yazmadýk. Ancak bu exception'da çalýþma esnasýnda exception'a yönlendirme iþlemini yapýyoruz.
--Örneðin:
--IF<condition> then
    --RAISE<exception_name>; raise anahtar kelimesi yönlendirme yapmak için kullanýlmaktadýr.
--END IF;
--...
    --EXCEPTION when<exception_name> then
        --...
--END;
--Example : Bölüme göre çalýþan personel sayýsýný bulan PL/SQL program yazalým. (Bölüm No runtime esnasýnda girilecektir)
DECLARE
    v_dept_id employees.department_id%type;
    v_toplam number;
    e_invalid_id exception;
BEGIN
    v_dept_id:=&dept_id;--& iþareti önemlidir. yanýna isim olarak herhangi bir þey yazýlabilir.
    IF(v_dept_id>0) then
        select count(*) into v_toplam from employees where department_id=v_dept_id;
        dbms_output.put_line('Toplam := '||v_toplam);
    ELSE
                RAISE e_invalid_id;
    END IF;
    EXCEPTION WHEN e_invalid_id THEN
        dbms_output.put_line('Bolüm numarasý negatif olamaz');
END;
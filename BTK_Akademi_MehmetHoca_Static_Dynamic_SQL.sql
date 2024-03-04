----------=PL/SQL Static-Dynamic=--------------
---DDL(Data Definiion Language{Create,Alter,Drop}) and DCL(Data Control Language{Grant,Revoke}) of commands play role as DYNAMIC SQL(Execute Immediate). They don't use directly.
---DML(Data Manipulation Language{Select,Insert,Delete,Update}) and TCL(Transaction Control Language{Commit,Rollback}) of commands play role as STATIC SQL.They use directly.
------------------------------------------------------------------------------------
-----=Using SQL Commands in PLSQL(Static SQL - DML - TCL)=-----
--desc employees;---Employees tablosunun description'�n� verir.
--create table employees2 as select * from employees;---bir tablonun ayn�s�n� ayn� verilerle olu�turma komutudur.
--select * from employees2;
--desc employees2
--DECLARE
--    emp_id employees2.employee_id%type;
--    emp_first_name employees2.first_name%type:='Utku';
--    emp_last_name  employees2.last_name%type:='OZEN';
--    emp_job_id employees2.job_id%type:='PL/SQL'; --ilk de�er atamalar�n� yapm�� olduk.
--BEGIN
--    select nvl(max(EMPLOYEE_ID), 0) + 1 into emp_id from employees2; --nvl komutu null veri olup olmad���n� kontrol eder.
--    insert into employees2(employee_id,first_name,last_name,job_id,email,hire_date) values(emp_id,emp_first_name,emp_last_name,emp_job_id,'abc@xyz.com',sysdate);
--    update employees2 SET job_id='DBA' where employee_id=emp_id;
--    delete employees2 where employee_id=emp_id
--    RETURNING EMPLOYEE_ID,FIRST_NAME, LAST_NAME, JOB_ID INTO emp_id,emp_first_name,emp_last_name,emp_job_id;---returning hangi kay�t delete edildiyse o kayda ait de�erleri elde eder.
--    rollback;
--    dbms_output.put_line(emp_id||' '||emp_first_name || ' ' || emp_last_name || ' ' || emp_job_id);
--END;
--select * from employees2 where employee_id=207 rollback i�lemi oldu�u i�in bo� tablo d�necektir.
------------------
--DECLARE
--    emp_id employees2.employee_id%type;
--    emp_first_name employees2.first_name%type:='Utku';
--    emp_last_name  employees2.last_name%type:='OZEN';
--    emp_job_id employees2.job_id%type:='PL/SQL'; --ilk de�er atamalar�n� yapm�� olduk.
--BEGIN
--    select nvl(max(EMPLOYEE_ID), 0) + 1 into emp_id from employees2; --nvl komutu null veri olup olmad���n� kontrol eder.
--    insert into employees2(employee_id,first_name,last_name,job_id,email,hire_date) values(emp_id,emp_first_name,emp_last_name,emp_job_id,'abc@xyz.com',sysdate);
--    update employees2 SET job_id='DBA' where employee_id=emp_id;
--    /*delete employees2 where employee_id=emp_id
--    RETURNING EMPLOYEE_ID,FIRST_NAME, LAST_NAME, JOB_ID INTO emp_id,emp_first_name,emp_last_name,emp_job_id;---returning hangi kay�t delete edildiyse o kayda ait de�erleri elde eder.*/
--    commit;
--    dbms_output.put_line(emp_id||' '||emp_first_name || ' ' || emp_last_name || ' ' || emp_job_id);
--END;
--select * from employees2 where employee_id=207 commit i�leminde de�er g�rece�iz.
---=Savepoint=---
/*desc regions;
create table regions2 as select * from regions where 1=2;--i�i bo� tablo oldu�u g�r�lecektir.
select * from regions2;
delete from regions2;
commit;
DECLARE
BEGIN
    INSERT INTO REGIONS2(region_id, region_name) VALUES(1,'AVRUPA');
    SAVEPOINT A;--savepoint PL/SQL bloklar� i�erisinde �e�itli i�lem basamaklar�ndan �nce veya sonra izler b�rak�l�r. Bu izlere gore rollback veya commit islemleri yap�labilir. 
    --Syntax olarak : SAVEPOINT verecegimiz_isim;
    
    INSERT INTO REGIONS2(region_id, region_name) VALUES(2,'ASYA');
    SAVEPOINT B;
    
    UPDATE REGIONS2 SET region_name='Asia' where region_id=2;
    SAVEPOINT C;
    
    DELETE FROM REGIONS2 WHERE region_id=2;
    --ROLLBACK TO A;--A noktas�ndan sonraki tum DML islemleri rollback yapacak. Sadece AVRUPA kaydi gelmistir.
    --ROLLBACK TO B;--B noktadan onceki DML islemleri gerceklesecek B noktasindan sonraki islemler ROLLBACK yapilacaktir. AVRUPA ve ASYA tabloda gorulecektir.
    --ROLLBACK TO C;--C noktasindan onceki DML islemleri gerceklesecek C noktasindan sonraki islemler gerceklesmeyecektir. AVRUPA ve Asia tabloda gorulecektir.
    ROLLBACK;
       --COMMIT;
END;*/
---------------------------------
----------PL/SQL ��inde SQL komutlar�n�n kullan�m�(Dynamic SQL-DDL-DCL)
/*DECLARE
ddl_komut varchar2(200);
BEGIN
 --ddl_komut:= 'create table TEMP_TABLE (urun_id number(10),urun_adi varchar2(30))';
 --ddl_komut:='alter table temp_table add urun_fiyati number(15,2)'; --number(15,2)=13 tam sayi virgulden sonra 2 digit
 --ddl_komut:='grant select on temp_table to Utku';--Utku kullan�c�s�na select yetkisi vermis olacagiz. 
--ddl_komut:='revoke select on temp_table from Utku';--Utku kullan�c�s�ndan select yetkisini almis olduk.
  ddl_komut := 'drop table temp_table';
  execute IMMEDIATE ddl_komut;
--zaman zaman doldur bo�alt tablolara ihtiya� duyulmaktad�r. ihtiya� bittikten sonra tablo silinebilir.
--dbms_output.put_line('Tablo olu�turuldu');--dbms=database management system
  dbms_output.put_l�ne('Tablo alter edildi');
END;
/
/=yukar�daki ve a�a��daki komutlar� birbirinden ay�rarak se�im yapmadan RUN etmemizi sa�lar.
desc temp_table;*/
/*
Yeni bir kullan�c� olu�turmak i�in DBA yetkili bir kullan�c� ile veritaban�na ba�lanmak gerekiyor. Bu nedenle system database'ine gidiyoruz.
create user Utku IDENTIFIED BY OZEN;--Utku ad�nda bir kullan�c� olu�turuldu.
grant connect, resource, unlimited tablespace to Utku;--db ba�lanma, kaynak kullanma gibi yetkiler verildi.
Utku kullan�c�s� i�in bir ba�lant� tan�m� yapma ad�mlar�:
1.Connections men�s�nden new connection diyoruz.
2.A��lan pencerede name, username,password ve veritaban�n�n SID veya Service name k�s�mlar�n� giriyoruz.
3.Test diyoruz.
4.Success gelirse connect diyoruz.
*/
----------------------
-----=Sequence in PL/SQL=-----
--Tabloda olmayan bir kolonu tablonun kolonuymu� gibi davrand�rmak(Pseudocolumns{Currval,Nextval})
--sequences=s�radan sayi �rete�leridir.
DECLARE
    seq_num number;
BEGIN
    seq_num:=test_seq.nextval;
    insert into regions(region_id, region_name) values(seq_num,'Avustralya');--sequenceleri bu sekilde bir degiskene atadiktan sonra kullanmak daha performanslidir.
    seq_num:=test_seq.currval;
    update regions set region_name='Antartika' where region_id=seq_num;
    /*insert into regions(region_id, region_name)
     values(test_seq.nextval,'Avustralya');*/--sequence'lari bu sekilde kullanmak performansli degil.
    /*updates regions set region_name='Antartika' where region_id=test_seq.currval;
    currval=sequence in kaldigi son numarayi belirtmektedir. Yukaridaki ifade gibi sequence kullanimi performanssizdir.*/
    commit;
END;
/*create sequence test_seq start with 73 increment by 1;--73 ten baslasin ve birer birer artis gostersin. Sequence syntax
select test_seq.currval from dual=sequence en son kac numarada kaldi.*/
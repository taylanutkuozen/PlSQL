----------=PL/SQL Static-Dynamic=--------------
---DDL(Data Definiion Language{Create,Alter,Drop}) and DCL(Data Control Language{Grant,Revoke}) of commands play role as DYNAMIC SQL(Execute Immediate). They don't use directly.
---DML(Data Manipulation Language{Select,Insert,Delete,Update}) and TCL(Transaction Control Language{Commit,Rollback}) of commands play role as STATIC SQL.They use directly.
------------------------------------------------------------------------------------
-----=Using SQL Commands in PLSQL(Static SQL - DML - TCL)=-----
--desc employees;---Employees tablosunun description'ýný verir.
--create table employees2 as select * from employees;---bir tablonun aynýsýný ayný verilerle oluþturma komutudur.
--select * from employees2;
--desc employees2
--DECLARE
--    emp_id employees2.employee_id%type;
--    emp_first_name employees2.first_name%type:='Utku';
--    emp_last_name  employees2.last_name%type:='OZEN';
--    emp_job_id employees2.job_id%type:='PL/SQL'; --ilk deðer atamalarýný yapmýþ olduk.
--BEGIN
--    select nvl(max(EMPLOYEE_ID), 0) + 1 into emp_id from employees2; --nvl komutu null veri olup olmadýðýný kontrol eder.
--    insert into employees2(employee_id,first_name,last_name,job_id,email,hire_date) values(emp_id,emp_first_name,emp_last_name,emp_job_id,'abc@xyz.com',sysdate);
--    update employees2 SET job_id='DBA' where employee_id=emp_id;
--    delete employees2 where employee_id=emp_id
--    RETURNING EMPLOYEE_ID,FIRST_NAME, LAST_NAME, JOB_ID INTO emp_id,emp_first_name,emp_last_name,emp_job_id;---returning hangi kayýt delete edildiyse o kayda ait deðerleri elde eder.
--    rollback;
--    dbms_output.put_line(emp_id||' '||emp_first_name || ' ' || emp_last_name || ' ' || emp_job_id);
--END;
--select * from employees2 where employee_id=207 rollback iþlemi olduðu için boþ tablo dönecektir.
------------------
--DECLARE
--    emp_id employees2.employee_id%type;
--    emp_first_name employees2.first_name%type:='Utku';
--    emp_last_name  employees2.last_name%type:='OZEN';
--    emp_job_id employees2.job_id%type:='PL/SQL'; --ilk deðer atamalarýný yapmýþ olduk.
--BEGIN
--    select nvl(max(EMPLOYEE_ID), 0) + 1 into emp_id from employees2; --nvl komutu null veri olup olmadýðýný kontrol eder.
--    insert into employees2(employee_id,first_name,last_name,job_id,email,hire_date) values(emp_id,emp_first_name,emp_last_name,emp_job_id,'abc@xyz.com',sysdate);
--    update employees2 SET job_id='DBA' where employee_id=emp_id;
--    /*delete employees2 where employee_id=emp_id
--    RETURNING EMPLOYEE_ID,FIRST_NAME, LAST_NAME, JOB_ID INTO emp_id,emp_first_name,emp_last_name,emp_job_id;---returning hangi kayýt delete edildiyse o kayda ait deðerleri elde eder.*/
--    commit;
--    dbms_output.put_line(emp_id||' '||emp_first_name || ' ' || emp_last_name || ' ' || emp_job_id);
--END;
--select * from employees2 where employee_id=207 commit iþleminde deðer göreceðiz.
---=Savepoint=---
/*desc regions;
create table regions2 as select * from regions where 1=2;--içi boþ tablo olduðu görülecektir.
select * from regions2;
delete from regions2;
commit;
DECLARE
BEGIN
    INSERT INTO REGIONS2(region_id, region_name) VALUES(1,'AVRUPA');
    SAVEPOINT A;--savepoint PL/SQL bloklarý içerisinde çeþitli iþlem basamaklarýndan önce veya sonra izler býrakýlýr. Bu izlere gore rollback veya commit islemleri yapýlabilir. 
    --Syntax olarak : SAVEPOINT verecegimiz_isim;
    
    INSERT INTO REGIONS2(region_id, region_name) VALUES(2,'ASYA');
    SAVEPOINT B;
    
    UPDATE REGIONS2 SET region_name='Asia' where region_id=2;
    SAVEPOINT C;
    
    DELETE FROM REGIONS2 WHERE region_id=2;
    --ROLLBACK TO A;--A noktasýndan sonraki tum DML islemleri rollback yapacak. Sadece AVRUPA kaydi gelmistir.
    --ROLLBACK TO B;--B noktadan onceki DML islemleri gerceklesecek B noktasindan sonraki islemler ROLLBACK yapilacaktir. AVRUPA ve ASYA tabloda gorulecektir.
    --ROLLBACK TO C;--C noktasindan onceki DML islemleri gerceklesecek C noktasindan sonraki islemler gerceklesmeyecektir. AVRUPA ve Asia tabloda gorulecektir.
    ROLLBACK;
       --COMMIT;
END;*/
---------------------------------
----------PL/SQL Ýçinde SQL komutlarýnýn kullanýmý(Dynamic SQL-DDL-DCL)
/*DECLARE
ddl_komut varchar2(200);
BEGIN
 --ddl_komut:= 'create table TEMP_TABLE (urun_id number(10),urun_adi varchar2(30))';
 --ddl_komut:='alter table temp_table add urun_fiyati number(15,2)'; --number(15,2)=13 tam sayi virgulden sonra 2 digit
 --ddl_komut:='grant select on temp_table to Utku';--Utku kullanýcýsýna select yetkisi vermis olacagiz. 
--ddl_komut:='revoke select on temp_table from Utku';--Utku kullanýcýsýndan select yetkisini almis olduk.
  ddl_komut := 'drop table temp_table';
  execute IMMEDIATE ddl_komut;
--zaman zaman doldur boþalt tablolara ihtiyaç duyulmaktadýr. ihtiyaç bittikten sonra tablo silinebilir.
--dbms_output.put_line('Tablo oluþturuldu');--dbms=database management system
  dbms_output.put_lýne('Tablo alter edildi');
END;
/
/=yukarýdaki ve aþaðýdaki komutlarý birbirinden ayýrarak seçim yapmadan RUN etmemizi saðlar.
desc temp_table;*/
/*
Yeni bir kullanýcý oluþturmak için DBA yetkili bir kullanýcý ile veritabanýna baðlanmak gerekiyor. Bu nedenle system database'ine gidiyoruz.
create user Utku IDENTIFIED BY OZEN;--Utku adýnda bir kullanýcý oluþturuldu.
grant connect, resource, unlimited tablespace to Utku;--db baðlanma, kaynak kullanma gibi yetkiler verildi.
Utku kullanýcýsý için bir baðlantý tanýmý yapma adýmlarý:
1.Connections menüsünden new connection diyoruz.
2.Açýlan pencerede name, username,password ve veritabanýnýn SID veya Service name kýsýmlarýný giriyoruz.
3.Test diyoruz.
4.Success gelirse connect diyoruz.
*/
----------------------
-----=Sequence in PL/SQL=-----
--Tabloda olmayan bir kolonu tablonun kolonuymuþ gibi davrandýrmak(Pseudocolumns{Currval,Nextval})
--sequences=sýradan sayi üreteçleridir.
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
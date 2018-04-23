set serveroutput on size unlimited
 
declare
 
 
  v_sql VARCHAR(2000);
  v_count NUMBER(3);
  v_nombre_tabla VARCHAR(30) := 'TMP_APROV_DACIONES';
  v_esquema_tabla VARCHAR(30) := 'HAYA01'; --'#ESQUEMA#'
       
  type t_esquema is table of varchar2(30) index by binary_integer;
  v_esquema_grant t_esquema;
    
begin
    
  v_esquema_grant(1) := '#ESQUEMA_MASTER#'; --'BANKMASTER';
  v_esquema_grant(2) := '#ESQUEMA_MINIREC#'; --'MINIREC';
  v_esquema_grant(3) := '#ESQUEMA_DWH#'; --'RECOVERY_BANKIA_DWH'
     
IF v_esquema_grant.count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No existen esquemas para Grants.');
   ELSE
    FOR i IN v_esquema_grant.FIRST .. v_esquema_grant.LAST
     LOOP
      v_count := 0;
      v_sql := 'select count(1) from all_users
                 where username=''' || v_esquema_grant(i) || '''';
      execute immediate v_sql into v_count;
           
      if v_count > 0 then
        v_sql := 'grant ALL
                     on ' || v_esquema_tabla || '.' || v_nombre_tabla || '
                     to ' || v_esquema_grant(i);
        DBMS_OUTPUT.PUT_LINE('[INFO]: ' || v_sql);
        execute immediate v_sql;
      else
        DBMS_OUTPUT.PUT_LINE('[INFO]: Esquema ' || v_esquema_grant(i) || ' NO EXISTE');
      end if;
           
     END LOOP;
END IF;
 
EXCEPTION
       WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCION: '||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            ROLLBACK;
            RAISE;
END;
 
/
EXIT

--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180423
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-505
--## PRODUCTO=SI
--## Finalidad: Grants en la tabla TMP_APROV_DACIONES
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET DEFINE OFF;
 
declare
 
 
  v_sql VARCHAR(2000);
  v_count NUMBER(3);
  v_nombre_tabla VARCHAR(30) := 'UVEM_HAYA_OLD';
  v_esquema_tabla VARCHAR(30) := 'REM01'; --'#ESQUEMA#'
       
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


v_nombre_tabla := 'TMP_SCR_GIANTS';

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


v_nombre_tabla := 'HAYA_OLD_HAYA_NEW';

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

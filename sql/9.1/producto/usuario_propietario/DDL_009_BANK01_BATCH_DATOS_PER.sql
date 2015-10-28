--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20151001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-58
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    TYPE T_ESQUEMA IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
    V_ESQUEMA_GRANT T_ESQUEMA;

BEGIN
    
    v_esquema_grant(1) := '#ESQUEMA_MASTER#';  --'BANKMASTER';
    v_esquema_grant(2) := '#ESQUEMA_MINIREC#'; --'MINIREC';
    v_esquema_grant(3) := '#ESQUEMA_DWH#';     --'RECOVERY_BANKIA_DWH';
    v_esquema_grant(4) := '#ESQUEMA_STG#';     --'RECOVERY_BANKIA_DATASTAGE';

    -----------------------
    --  BATCH_DATOS_PER  --
    ----------------------- 
    
    --** Comprobamos si existe la tabla   

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BATCH_DATOS_PER'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.BATCH_DATOS_PER CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_PER... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_PER... Comprobaciones previas FIN');


    --** Creamos la tabla

    V_MSQL := 'CREATE GLOBAL TEMPORARY TABLE ' ||v_esquema||'.BATCH_DATOS_PER
               (
		PER_ID    NUMBER (16)
		,PER_NOMBRE    VARCHAR2 (100 Char)
		,PER_APELLIDO1    VARCHAR2 (100 Char)
		,PER_APELLIDO2    VARCHAR2 (100 Char)
		,PER_DEUDA_IRREGULAR    NUMBER
		,PER_RIESGO_DIRECTO    NUMBER
		,PER_RIESGO_INDIRECTO    NUMBER
               )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_PER... Tabla creada');


    --** Creamos Indices
 
    V_MSQL := 'CREATE INDEX IDX_BATCH_DATOS_PER_1 ON '||v_esquema||'.BATCH_DATOS_PER(PER_DEUDA_IRREGULAR)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_DATOS_PER_1... Indice creado');
    V_MSQL := 'CREATE INDEX IDX_BATCH_DATOS_PER_2 ON '||v_esquema||'.BATCH_DATOS_PER(PER_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_DATOS_PER_2... Indice creado');
   

    --** Damos permisos a otros esquemas
    IF v_esquema_grant.count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No existen esquemas para Grants.');
      ELSE
        FOR i IN v_esquema_grant.FIRST .. v_esquema_grant.LAST
         LOOP
          v_num_tablas := 0;
          v_sql := 'select count(1) from all_users
                     where username='''||v_esquema_grant(i)||'''';
          execute immediate v_sql into v_num_tablas;
                 
          if v_num_tablas > 0 then
            v_sql := 'grant select, update, delete, insert
                         on '||v_esquema||'.BATCH_DATOS_PER
                         to '||v_esquema_grant(i);
            DBMS_OUTPUT.PUT_LINE('[INFO]: ' || v_sql);
            execute immediate v_sql;
          else
            DBMS_OUTPUT.PUT_LINE('[INFO]: Esquema '||v_esquema_grant(i)||' NO EXISTE');
          end if;
                 
         END LOOP;
    END IF;

    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
    

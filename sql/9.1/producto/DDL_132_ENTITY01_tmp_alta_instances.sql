--/*
--##########################################
--## AUTOR=Óscar
--## FECHA_CREACION=20151210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.19-bk
--## INCIDENCIA_LINK=BKREC-1202
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

    
    DBMS_OUTPUT.PUT_LINE('******** TMP_ALTA_BPM_INSTANCES ********'); 
    
     V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_ALTA_BPM_INSTANCES'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_ALTA_BPM_INSTANCES existe'); 
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_ALTA_BPM_INSTANCES';
        EXECUTE IMMEDIATE V_MSQL;  
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_ALTA_BPM_INSTANCES borrada'); 
        
     END IF;
     
        V_MSQL := 'CREATE GLOBAL TEMPORARY TABLE '||V_ESQUEMA||'.TMP_ALTA_BPM_INSTANCES 
       (  
       PRC_ID NUMBER(16,0) NOT NULL ENABLE, 
       DEF_ID NUMBER(16,0) NOT NULL ENABLE, 
       NODE_ID NUMBER(16,0) NOT NULL ENABLE, 
       TAP_CODIGO VARCHAR2(100 CHAR) NOT NULL ENABLE, 
       TEX_ID NUMBER(16,0) NOT NULL ENABLE, 
       FORK_NODE NUMBER(16,0), 
       INST_ID NUMBER(16,0) NOT NULL ENABLE, 
       TOKEN_PADRE_ID NUMBER(16,0), 
       MODULE_PADRE_ID NUMBER(16,0), 
       VMAP_PADRE_ID NUMBER(16,0),
       TOKEN_ID NUMBER(16,0), 
       MODULE_ID NUMBER(16,0), 
       VMAP_ID NUMBER(16,0)
       ) ON COMMIT DELETE ROWS ';        
                EXECUTE IMMEDIATE V_MSQL;  
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_ALTA_BPM_INSTANCES creada');    
   
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

    COMMIT;
    
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
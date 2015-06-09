--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20150520
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.10.13
--## INCIDENCIA_LINK=BCFI-589
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
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN

    -- ******** TMP_CNT_PER_EXCEPTUADOS *******
    DBMS_OUTPUT.PUT_LINE('******** TMP_CNT_PER_EXCEPTUADOS ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNT_PER_EXCEPTUADOS... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNT_PER_EXCEPTUADOS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_CNT_PER_EXCEPTUADOS CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNT_PER_EXCEPTUADOS... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNT_PER_EXCEPTUADOS... Comprobaciones previas FIN'); 
    
    --Creamos la tabla
    V_MSQL := 'CREATE GLOBAL TEMPORARY TABLE '||V_ESQUEMA||'.TMP_CNT_PER_EXCEPTUADOS
               ( EXC_ID  NUMBER(16)
               , PER_ID  NUMBER(16)
               , CNT_ID  NUMBER(16)
               ) ON COMMIT PRESERVE ROWS
            ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNT_PER_EXCEPTUADOS... Tabla creada');
    
    -- Damos permisos de lectura
    EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.TMP_CNT_PER_EXCEPTUADOS 
                          TO '||V_ESQUEMA_M||'
                           , '||V_ESQUEMA_MIN||'
                           , '||V_ESQUEMA_DWH||'
                           , '||V_ESQUEMA_STG||'
                      ';
    
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

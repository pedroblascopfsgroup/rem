--/*
--##########################################
--## AUTOR=VICENTE LOZANO
--## FECHA_CREACION=31-08-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-76
--## PRODUCTO=SI
--## Finalidad: DDL Modificacion de las tablas DD_PCO_BFT_TIPO y PCO_BUR_ENVIO
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN
	    
	
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_PCO_BFT_TIPO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla procedemos a modificarla
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_PCO_BFT_TIPO MODIFY DD_PCO_BFT_PLANTILLA varchar(2000)';
            EXECUTE IMMEDIATE V_MSQL;
            
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PCO_BFT_TIPO columna DD_PCO_BFT_PLANTILLA modificada');
            
    ELSE	
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PCO_BFT_TIPO... La tabla NO existe.');
    END IF;
    
     -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_BUR_ENVIO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla procedemos a modificarla
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_BUR_ENVIO MODIFY PCO_BUR_ENVIO_CONTENIDO varchar(2000)';
            EXECUTE IMMEDIATE V_MSQL;
            
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PCO_BFT_TIPO columna PCO_BUR_ENVIO_CONTENIDO modificada');
    ELSE
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO... La tabla NO existe.');
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
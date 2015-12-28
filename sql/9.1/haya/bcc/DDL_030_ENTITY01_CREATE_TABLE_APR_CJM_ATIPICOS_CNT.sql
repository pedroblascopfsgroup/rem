--/*
--##########################################
--## AUTOR=AGUSTIN MOMPO
--## FECHA_CREACION=20150807
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-161
--## PRODUCTO=SI
--## Finalidad: DDL Creación de las tablas de aprovisionamieto para CAJAMAR ATIPICOS
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
	    
	 -- Creacion Tabla APR_CJM_ATC_ATIPICOS_CNT
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''APR_CJM_ATC_ATIPICOS_CNT'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_CJM_ATC_ATIPICOS_CNT... La tabla YA EXISTE');
    ELSE
    		  --Creamos la tabla
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.APR_CJM_ATC_ATIPICOS_CNT
               (
				ATC_FECHA_EXTRACCION VARCHAR2(8 CHAR), 
				ATC_FECHA_DATO VARCHAR2(8 CHAR), 
				ATC_TIPO_PRODUCTO VARCHAR2(5 CHAR), 
				ATC_NUMERO_CONTRATO VARCHAR2(18 CHAR), 
				ATC_NUMERO_SPEC VARCHAR2(16 CHAR), 
				ATC_CODIGO_ATIPICO VARCHAR2(21 CHAR), 
				ATC_IMPORTE_ATIPICO VARCHAR2(16 CHAR), 
				ATC_TIPO_ATIPICO VARCHAR2(4 CHAR), 
				ATC_MOTIVO_ATIPICO VARCHAR2(9 CHAR), 
				ATC_FECHA_VALOR VARCHAR2(8 CHAR), 
				ATC_FECHA_MOVIMIENTO VARCHAR2(8 CHAR), 
				ATC_CHAR_EXTRA1 VARCHAR2(50 CHAR), 
				ATC_CHAR_EXTRA2 VARCHAR2(50 CHAR), 
				ATC_FLAG_EXTRA1 VARCHAR2(1 CHAR), 
				ATC_FLAG_EXTRA2 VARCHAR2(1 CHAR), 
				ATC_DATE_EXTRA1 VARCHAR2(8 CHAR), 
				ATC_DATE_EXTRA2 VARCHAR2(8 CHAR), 
				ATC_NUM_EXTRA1 VARCHAR2(16 CHAR), 
				ATC_NUM_EXTRA2 VARCHAR2(16 CHAR)               
			)';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_CJM_ATC_ATIPICOS_CNT... Tabla creada');
    END IF;
    
	-- Creacion Tabla APR_CJM_ATC_ATIPI_CNT_REJECTS
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''APR_CJM_ATC_ATIPI_CNT_REJECTS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_CJM_ATC_ATIPI_CNT_REJECTS... La tabla YA EXISTE');
    ELSE
    		  --Creamos la tabla
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.APR_CJM_ATC_ATIPI_CNT_REJECTS
               (
				ROWREJECTED VARCHAR2(1024 CHAR), 
				ERRORCODE VARCHAR2(255 CHAR), 
				ERRORMESSAGE VARCHAR2(255 CHAR)
			)';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_CJM_ATC_ATIPI_CNT_REJECTS... Tabla creada');
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

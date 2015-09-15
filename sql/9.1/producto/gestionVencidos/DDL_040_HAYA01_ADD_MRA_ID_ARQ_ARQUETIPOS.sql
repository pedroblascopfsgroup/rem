/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-49
--## PRODUCTO=SI
--## Finalidad: DDL Para agregar la columna MRA_ID en la tabla ARQ_ARQUETIPOS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
*/

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

    -- Comprobamos si existe la tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME = ''ARQ_ARQUETIPOS''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    IF V_NUM_TABLAS > 0 THEN
    	-- Comprobamos si la tabla ya tiene creada la columna
    	V_SQL :='SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''ARQ_ARQUETIPOS'' AND COLUMN_NAME=''MRA_ID''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ARQ_ARQUETIPOS ADD (MRA_ID NUMBER(16, 0) )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.ARQ_ARQUETIPOS.MRA_ID creada OK');
    	ELSE
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.ARQ_ARQUETIPOS.MRA_ID ya existia.');
    	END IF;
    	
    	-- Comprobamos si la tabla ya tiene creada la columna DTYPE
    	V_SQL :='SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''ARQ_ARQUETIPOS'' AND COLUMN_NAME=''DTYPE''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ARQ_ARQUETIPOS ADD (DTYPE VARCHAR2(200 CHAR) DEFAULT ''ARQArquetipo'' NOT NULL)';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.ARQ_ARQUETIPOS.DTYPE creada OK');
    	ELSE
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.ARQ_ARQUETIPOS.DTYPE ya existia.');
    	END IF;
    	
    	-- Comprobamos si ya existe la FK
    	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''ARQ_ARQUETIPOS'' AND CONSTRAINT_TYPE=''R'' AND CONSTRAINT_NAME=''FK_ARQ_ARQU_FK_MRA_REL_MODELO''';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    	
    	IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ARQ_ARQUETIPOS ADD CONSTRAINT FK_ARQ_ARQU_FK_MRA_REL_MODELO FOREIGN KEY ( MRA_ID ) REFERENCES '||V_ESQUEMA||'.MRA_REL_MODELO_ARQ ( MRA_ID ) ENABLE';
    		EXECUTE IMMEDIATE V_MSQL;
          	DBMS_OUTPUT.PUT_LINE('[INFO] Foreign key '||V_ESQUEMA||'.ARQ_ARQUETIPOS.FK_ARQ_ARQU_FK_MRA_REL_MODELO creada OK');
        ELSE
        	DBMS_OUTPUT.PUT_LINE('[INFO] Foreign key '||V_ESQUEMA||'.ARQ_ARQUETIPOS.FK_ARQ_ARQU_FK_MRA_REL_MODELO ya existia');
        END IF;
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[ERROR] No existe la tabla '||V_ESQUEMA||'.ARQ_ARQUETIPOS ');
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

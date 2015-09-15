/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-49
--## PRODUCTO=SI
--## Finalidad: DML para actualizar en la medida de lo posible el nuevo campo MRA_ID en ARQ_ARQUETIPOS
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
    
    falta_columna EXCEPTION;
    
BEGIN

    -- Comprobamos si existe la tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME = ''ARQ_ARQUETIPOS''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    IF V_NUM_TABLAS > 0 THEN
    	-- Comprobamos si la tabla ya tiene creada la columna
    	V_SQL :='SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''ARQ_ARQUETIPOS'' AND COLUMN_NAME=''MRA_ID''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS > 0 THEN
    		V_MSQL := '
				MERGE INTO '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ
				USING (
				SELECT * FROM (
				  SELECT  DISTINCT LIA.LIA_NOMBRE, MRA.ITI_ID, MRA.MRA_NIVEL, LIA.LIA_GESTION, NVL(LIA.LIA_PLAZO_DISPARO,0) LIA_PLAZO_DISPARO, LIA.DD_TSN_ID, MRA.MRA_ID, MRA.FECHACREAR,  
				    ROW_NUMBER() OVER (PARTITION BY LIA.LIA_NOMBRE, MRA.ITI_ID, LIA.LIA_GESTION, LIA.LIA_PLAZO_DISPARO, LIA.DD_TSN_ID, MOA.DD_ESM_ID ORDER BY MRA.FECHACREAR DESC) REG
				  FROM '||V_ESQUEMA||'.MRA_REL_MODELO_ARQ MRA
				  INNER JOIN '||V_ESQUEMA||'.MOA_MODELOS_ARQ MOA ON MRA.MOA_ID = MRA.MOA_ID AND MOA.DD_ESM_ID > 2 
				  INNER JOIN '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS LIA ON MRA.LIA_ID = LIA.LIA_ID) WHERE REG = 1
				) MODELO
				ON (
				  UPPER(TRIM(ARQ.ARQ_NOMBRE)) = UPPER(TRIM(MODELO.LIA_NOMBRE))
				  AND (MODELO.ITI_ID = ARQ.ITI_ID OR (MODELO.ITI_ID IS NULL AND ARQ.ITI_ID IS NULL))
				  AND MODELO.MRA_NIVEL = ARQ.ARQ_NIVEL
				  AND MODELO.LIA_GESTION = ARQ.ARQ_GESTION
				  AND MODELO.LIA_PLAZO_DISPARO =  ARQ.ARQ_PLAZO_DISPARO
				  AND (MODELO.DD_TSN_ID = ARQ.DD_TSN_ID OR (MODELO.DD_TSN_ID IS NULL AND ARQ.DD_TSN_ID IS NULL))
				)
				WHEN MATCHED THEN UPDATE SET MRA_ID = MODELO.MRA_ID
				WHERE ARQ.BORRADO = 0 AND ARQ.MRA_ID IS NULL
				';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.ARQ_ARQUETIPOS.MRA_ID actualizada OK');
    	ELSE
    		DBMS_OUTPUT.PUT_LINE('[ERROR] Columna '||V_ESQUEMA||'.ARQ_ARQUETIPOS.MRA_ID no existe debe ejecutarse antes el DDL_040_HAYA01_ADD_MRA_ID_ARQ_ARQUETIPOS.');
    		RAISE falta_columna;
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

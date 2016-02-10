

--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=BKREC-1420
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
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
    
    -----------------
    --   BIE_CNT   --
    -----------------   
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BIE_CNT'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe comprobamos si existe la columna
    IF V_NUM_TABLAS = 1 THEN 
    
			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME =''BIE_CNT'' and owner = '''||v_esquema||''' AND COLUMN_NAME =''BIE_SEC_GARANTIA_CNT''';
			EXECUTE IMMEDIATE v_sql INTO v_num_column;	
			
			IF V_NUM_COLUMN = 1	THEN			  
			--** Modificamos la tabla
			V_MSQL := 'MERGE INTO '||v_esquema||'.BIE_CNT BIECNT  USING (
							SELECT CNT.CNT_ID,BIE.BIE_ID,APR.NUM_EXTRA1 
								FROM '||v_esquema||'.APR_AUX_ABC_BIECNT_CONSOL APR 
								JOIN '||v_esquema||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO=APR.NUMERO_CONTRATO 
								JOIN '||v_esquema||'.BIE_BIEN BIE ON APR.CODIGO_BIEN=BIE.BIE_CODIGO_INTERNO
							) AUX
							  ON (BIECNT.CNT_ID = AUX.CNT_ID AND BIECNT.BIE_ID = AUX.BIE_ID)
							  WHEN MATCHED THEN
								UPDATE SET 
								BIECNT.BIE_SEC_GARANTIA_CNT=AUX.NUM_EXTRA1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BIE_CNT... MERGE REALIZADO CON EXITO');
		    END IF;			
   END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BIE_CNT... MERGE FIN');  
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



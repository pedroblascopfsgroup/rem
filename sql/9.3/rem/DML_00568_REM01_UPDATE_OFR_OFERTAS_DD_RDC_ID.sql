--/*
--######################################### 
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13525
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionamos el campo DD_RDC_ID de la tabla OFR_OFERTAS
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TABLA VARCHAR2(100 CHAR) := 'OFR_OFERTAS'; -- Tabla Destino

	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-13525';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	
BEGIN
	
  	--Comprobacion de la tabla
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);  
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN   
        
        	-- Verificar si el campo ya existe
            	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = ''DD_RDC_ID''';
            	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
		IF V_NUM_TABLAS > 0 THEN
                   
        		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
        			SET 
        				DD_RDC_ID = (SELECT DD_RDC_ID FROM '||V_ESQUEMA||'.DD_RDC_RESPONSABLE_DOCUMENTACION_CLIENTE WHERE DD_RDC_CODIGO = ''03'')
				WHERE OFR_DOC_RESP_PRESCRIPTOR = 0
			';
			EXECUTE IMMEDIATE V_SQL;
			
			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
        			SET 
        				DD_RDC_ID = (SELECT DD_RDC_ID FROM '||V_ESQUEMA||'.DD_RDC_RESPONSABLE_DOCUMENTACION_CLIENTE WHERE DD_RDC_CODIGO = ''02'')
				WHERE OFR_DOC_RESP_PRESCRIPTOR = 1 AND PVE_ID_PRESCRIPTOR = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 2321)
			';
			EXECUTE IMMEDIATE V_SQL;
			
			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
        			SET 
        				DD_RDC_ID = (SELECT DD_RDC_ID FROM '||V_ESQUEMA||'.DD_RDC_RESPONSABLE_DOCUMENTACION_CLIENTE WHERE DD_RDC_CODIGO = ''01'')
				WHERE OFR_DOC_RESP_PRESCRIPTOR = 1 AND PVE_ID_PRESCRIPTOR IN (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM <> 2321)
			';
			EXECUTE IMMEDIATE V_SQL;	
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
			
			COMMIT;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios confirmados.');
		ELSE
        	    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'... No existe el campo DD_RDC_ID en tabla '||V_TABLA||'.');  
	        END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'... No existe la tabla '||V_TABLA||'.');  
        END IF;
  	
EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

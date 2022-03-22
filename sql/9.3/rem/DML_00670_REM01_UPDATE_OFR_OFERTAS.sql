--/*
--######################################### 
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210909
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14860
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionamos el campo OFR_ORIGEN de la tabla OFR_OFERTAS
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

	V_TABLA VARCHAR2(2400 CHAR) := 'OFR_OFERTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    	V_TABLA_AUX VARCHAR2(2400 CHAR) := 'AUX_OFR_ENTIDAD_ORIGEN'; -- Vble. auxiliar para almacenar el nombre de la tabla auxiliar.
    	V_TABLA_DD VARCHAR2(2400 CHAR) := 'DD_SOR_SISTEMA_ORIGEN'; -- Vble. auxiliar para almacenar el nombre de la tabla diccionario.

	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14860';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	
	V_OFR_ID NUMBER(16); -- Vble. que almacena el id de la oferta.
    	V_OFR_ENTIDAD VARCHAR(10 CHAR); -- Vble. que almacena el nombre de la entidad origen.
	
BEGIN
	
  	--Comprobacion de la tabla
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);  
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
        
		-- Verificar si el campo ya existe
            	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = ''OFR_ORIGEN''';
            	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
            
		IF V_NUM_TABLAS > 0 THEN
		
			-- Insertamos los valores de la tabla auxiliar en la OFR_OFERTAS
			DBMS_OUTPUT.PUT_LINE('[INFO] Se va a actualizar '||V_TABLA||' > OFR_ORIGEN desde '||V_TABLA_AUX||'.');

			EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' OFR USING (
			    SELECT ORG.OFR_ID, ORG.OFR_ENTIDAD_ORIGEN
			    FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' ORG
			) AUX
			ON (OFR.OFR_ID = AUX.OFR_ID)
			WHEN MATCHED THEN UPDATE SET
			OFR.OFR_ORIGEN = (SELECT DD_SOR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD||' WHERE DD_SOR_DESCRIPCION = AUX.OFR_ENTIDAD_ORIGEN)';

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en '||V_TABLA||'.');  

			COMMIT;
		    
		    	DBMS_OUTPUT.PUT_LINE('[FIN]');
		ELSE
        	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... No existe el campo OFR_ORIGEN en tabla '||V_TABLA||'.');  
	        END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... No existe la tabla '||V_TABLA||'.');  
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

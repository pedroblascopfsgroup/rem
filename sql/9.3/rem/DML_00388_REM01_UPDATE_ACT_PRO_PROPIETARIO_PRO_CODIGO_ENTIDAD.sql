--/*
--######################################### 
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20210113
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12060
--## PRODUCTO=NO
--## 
--## Finalidad:
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

	V_TABLA VARCHAR2(100 CHAR) := 'ACT_PRO_PROPIETARIO'; -- Tabla Destino

	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-12060';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	
BEGIN
	
  	--Comprobacion de la tabla
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);  
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN              
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
        			SET 
        				PRO_CODIGO_ENTIDAD = ''0997'', 
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE 
				WHERE PRO_CODIGO_ENTIDAD = ''997''
			';
		EXECUTE IMMEDIATE V_SQL;	
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] Cambios confirmados.');


		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
        			SET 
        				PRO_CODIGO_ENTIDAD = ''0998'', 
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE 
				WHERE PRO_CODIGO_ENTIDAD = ''998''
			';
		EXECUTE IMMEDIATE V_SQL;	
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] Cambios confirmados.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'... No existe la tabla.');  
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

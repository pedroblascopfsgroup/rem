--/*
--#########################################
--## AUTOR=Joaquin Arnal Diaz
--## FECHA_CREACION=20201011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11460
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar descripcion de localidades en REM.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'dd_loc_localidad'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-11460';
	

BEGIN

	--Adapto los campos insertados en la temporal para luego volcarlos al tarifario
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));	
	DBMS_OUTPUT.PUT_LINE('[INFO] PREPARANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||'.');

	V_SQL := 'MERGE INTO '||V_ESQUEMA_M||'.'||V_TABLA_TMP||' dest
			USING (
				select 
					aux.municipio_bbva, loc.dd_loc_id, loc.dd_loc_descripcion_larga
				from '||V_ESQUEMA||'.AUX_HREOS_11460 aux
					join '||V_ESQUEMA_M||'.dd_loc_localidad loc on loc.dd_loc_id = to_number(aux.dd_loc_id)
					where aux.municipio_bbva != loc.dd_loc_descripcion
			) src
			ON (dest.dd_loc_id = src.dd_loc_id) 
			WHEN MATCHED THEN UPDATE SET 
				dest.dd_loc_descripcion = src.municipio_bbva,
				dest.usuariomodificar = '''||V_USUARIO||''',
				dest.fechamodificar = sysdate';
				
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_TMP);
	COMMIT;
	
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

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

--/*
--#########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9387
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion gestores en las tablas GEE_GESTOR_ENTIDAD y GEH_GESTOR_ENTIDAD_HIST.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_ASIGNACION_GESTOR_ACTIVO'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9387';
	CURSOR V_CURSOR IS 
	SELECT ID_HAYA, GESTOR, USUARIO
	FROM REM01.TMP_ASIGNACION_GESTOR_ACTIVO
	WHERE ID_HAYA NOT IN (SELECT ACT_NUM_ACTIVO FROM REM01.ACT_ACTIVO WHERE BORRADO=0)
	OR USUARIO NOT IN (SELECT USU_USERNAME FROM REMMASTER.USU_USUARIOS WHERE BORRADO=0);
	ID_HAYA NUMBER(16,0);
	GESTOR VARCHAR2(20 CHAR);
	USUARIO VARCHAR2(100 CHAR);
	

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));

	--Abro cursor para mostrar los activos y usuarios que no van a ser insertados en la temporal
	OPEN V_CURSOR;
	LOOP

		FETCH V_CURSOR INTO ID_HAYA, GESTOR, USUARIO;
		EXIT WHEN V_CURSOR%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se elimina el activo '||ID_HAYA||' correspondiente al gestor '||GESTOR||' y al usuario '||USUARIO);

	END LOOP;
	CLOSE V_CURSOR;

	--Borro de la tabla temporal los activos que no existen
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE ID_HAYA NOT IN (SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE BORRADO=0)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_TMP);

	--Borro de la tabla los usuarios que no existen

	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE USUARIO NOT IN (SELECT USU_USERNAME FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO=0)';

	
	--Adapto los campos insertados en la temporal para luego volcarlos en las tablas de gestor - entidad
	DBMS_OUTPUT.PUT_LINE('[INFO] PREPARANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||'.');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
				USING (
					SELECT
					ROWNUM CONTADOR,
					TMP.ID_HAYA,
					TMP.GESTOR,
					TMP.USUARIO						
					FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
					INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO=TMP.ID_HAYA 									
				) AUX
				ON (TMP.ID_HAYA = AUX.ID_HAYA AND TMP.GESTOR=AUX.GESTOR AND TMP.USUARIO=AUX.USUARIO) 
				WHEN MATCHED THEN UPDATE SET				 
				 TMP.CONTADOR=AUX.CONTADOR';
					
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

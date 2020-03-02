--/*
--#########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9387
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar gestores al activo en las tablas GAC_GESTOR_ADD_ACTIVO y GAH_GESTOR_ACTIVO_HISTORICO .
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
	V_TABLA_GAC VARCHAR2(40 CHAR):='GAC_GESTOR_ADD_ACTIVO';--Variable para la tabla de volcado
	V_TABLA_GAH VARCHAR2(40 CHAR):='GAH_GESTOR_ACTIVO_HISTORICO';--Variable para la tabla de volcado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9387';
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	--Insertamos en la tabla GAC_GESTOR_ADD_ACTIVO	
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_GAC||'.');
	
	V_SQL:= ('INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GAC||' (GEE_ID, ACT_ID)        
		SELECT 
		TMP.GEE_ID		
		,ACT.ACT_ID		
		FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO=TMP.ID_HAYA'   	
        );

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_GAC);	
	
	--Insertamos en la tabla GAH_GESTOR_ACTIVO_HISTORICO
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_GAH||'.');
	
	V_SQL:= ('INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GAH||' (GEH_ID, ACT_ID)        
		SELECT 
		TMP.GEH_ID		
		,ACT.ACT_ID		
		FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO=TMP.ID_HAYA'   	
        );

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_GAH);	
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

--/*
--#########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9387
--## PRODUCTO=NO
--## 
--## Finalidad: eliminar gestores en las tablas GEE_GESTOR_ENTIDAD y GEH_GESTOR_ENTIDAD_HIST.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
		
	V_TABLA_GAC VARCHAR2(30 CHAR) := 'GAC_GESTOR_ADD_ACTIVO'; -- Variable para tabla
	V_TABLA_GEE VARCHAR2(30 CHAR) := 'GEE_GESTOR_ENTIDAD'; -- Variable para tabla
	V_TABLA_GAH VARCHAR2(30 CHAR) := 'GAH_GESTOR_ACTIVO_HISTORICO'; -- Variable para tabla
	V_TABLA_GEH VARCHAR2(30 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST'; -- Variable para tabla
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar
	V_NUM NUMBER(16); --Variable para comprobar si existen registros	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9387';
	

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	
	--Hacemos el borrado lógico en la tabla GEE_GESTOR_ENTIDAD correspondiente a los gestores de la subcartera Divarian
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO LÓGICO GESTORES DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_GEE||'.');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_GEE||' GEE
				USING (					
					SELECT
					GEE.GEE_ID
					FROM '||V_ESQUEMA||'.'||V_TABLA_GAC||' GAC
					INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID AND ACT.BORRADO = 0
    				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_GEE||' GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
					LEFT JOIN  '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
					WHERE SCR.DD_SCR_CODIGO IN (''151'', ''152'')
				) AUX
				ON (GEE.GEE_ID = AUX.GEE_ID) 
				WHEN MATCHED THEN UPDATE SET
				 GEE.USUARIOBORRAR = '''||V_USUARIO||''',
				 GEE.FECHABORRAR = SYSDATE,				 
				 GEE.BORRADO = 1				 
			 ';
					
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_GEE);


	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAMOS REGISTROS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_GAC||'.');

	--Eliminamos los registros de la tabla GAC_GESTOR_ADD_ACTIVO correspondientes a los activos y gestores de la cartera Divarian
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_GAC||' 
			  WHERE ACT_ID IN (SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							   LEFT JOIN  '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
					           WHERE SCR.DD_SCR_CODIGO IN (''151'', ''152'')
							   AND ACT.BORRADO = 0)
			  ';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_GAC);


	--Añadimos fecha_hasta en la tabla GEH_GESTOR_ENTIDAD_HIST correspondiente a los gestores de la subcartera Divarian
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO LÓGICO GESTORES DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_GEH||'.');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_GEH||' GEH
				USING (
					SELECT
					GEH.GEH_ID
					FROM '||V_ESQUEMA||'.'||V_TABLA_GAH||' GAH
					INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAH.ACT_ID AND ACT.BORRADO = 0
    				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_GEH||' GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.BORRADO = 0
					LEFT JOIN  '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
					WHERE SCR.DD_SCR_CODIGO IN (''151'', ''152'')														
				) AUX
				ON (GEH.GEH_ID = AUX.GEH_ID) 
				WHEN MATCHED THEN UPDATE SET
				GEH.GEH_FECHA_HASTA = SYSDATE,				 
				GEH.USUARIOMODIFICAR = '''||V_USUARIO||''',
				GEH.FECHAMODIFICAR = SYSDATE				
				';
					
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_GEH);
	
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

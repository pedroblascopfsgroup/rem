--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20181008
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4591
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion gestor de activo en agrupaciones.
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

	V_TABLA VARCHAR2(30 CHAR) := 'AUX_CARGA_CARGAS_REMVIP_1564_2'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-4591';

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	
	UPDATE REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX1
	SET EXISTE_ACTIVO = 0
	WHERE EXISTS (
	SELECT 1 
	FROM REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX
	LEFT JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
	WHERE ACT.ACT_ID IS NULL
	AND AUX.ACT_NUM_ACTIVO = AUX1.ACT_NUM_ACTIVO);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGRUP_PROYECTO_HREOS_4591 actualizada. '||SQL%ROWCOUNT||' activos NO existen.');

	UPDATE REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX1
	SET EXISTE_ACTIVO = 1
	WHERE EXISTS (
	SELECT 1 
	FROM REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX
	INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
	WHERE AUX.ACT_NUM_ACTIVO = AUX1.ACT_NUM_ACTIVO);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGRUP_PROYECTO_HREOS_4591 actualizada. '||SQL%ROWCOUNT||' activos SI existen.');
	
	UPDATE REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX1
	SET CARGAR_AGRUPACION = 1
	WHERE CARGAR_AGRUPACION IS NULL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGRUP_PROYECTO_HREOS_4591 actualizada. '||SQL%ROWCOUNT||'regstros. Marcadas por defecto como que si se crearan.');
	
	UPDATE REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX1
	SET CARGAR_AGRUPACION = 0
	WHERE EXISTS (
	SELECT DISTINCT 1 FROM (
	SELECT DISTINCT ID_PROYECTO, DD_CRA_ID, DD_PRV_ID
	FROM (
		SELECT AUX1.ID_PROYECTO, AUX1.ACT_NUM_ACTIVO, CRA.DD_CRA_ID, BIELOC.DD_PRV_ID,
		ROW_NUMBER()
						OVER (PARTITION BY AUX1.ID_PROYECTO, CRA.DD_CRA_ID, BIELOC.DD_PRV_ID ORDER BY AUX1.ID_PROYECTO ASC) AS RN2
		FROM (		
			select ID_PROYECTO,ACT_NUM_ACTIVO,
			ROW_NUMBER()
						OVER (PARTITION BY ACT_NUM_ACTIVO ORDER BY ID_PROYECTO ASC) AS RN
			FROM REM01.AUX_AGRUP_PROYECTO_HREOS_4591
			WHERE EXISTE_ACTIVO = 1
			) AUX			
		INNER JOIN REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX1 ON AUX1.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		INNER JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		INNER JOIN REM01.BIE_LOCALIZACION BIELOC ON BIELOC.BIE_ID = ACT.BIE_ID
		WHERE RN > 1
		)
	)T1
	WHERE T1.ID_PROYECTO = AUX1.ID_PROYECTO);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGRUP_PROYECTO_HREOS_4591 actualizada. '||SQL%ROWCOUNT||' registros no volcaran por duplicidades de activos en distintas agrupaciones.');
	
	UPDATE REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX1
	SET CARGAR_AGRUPACION = 0
	WHERE EXISTS (
	SELECT 1
	FROM (
		SELECT DISTINCT ID_PROYECTO, DD_CRA_ID, DD_PRV_ID
		FROM (
		SELECT AUX1.ID_PROYECTO, AUX1.ACT_NUM_ACTIVO, CRA.DD_CRA_ID, BIELOC.DD_PRV_ID,
			ROW_NUMBER()
							OVER (PARTITION BY AUX1.ID_PROYECTO, CRA.DD_CRA_ID, BIELOC.DD_PRV_ID ORDER BY AUX1.ID_PROYECTO ASC) AS RN2
			FROM (
			
				SELECT ID_PROYECTO, ACT_NUM_ACTIVO,
				ROW_NUMBER()
							OVER (PARTITION BY ACT_NUM_ACTIVO ORDER BY ID_PROYECTO ASC) AS RN
				FROM REM01.AUX_AGRUP_PROYECTO_HREOS_4591
				WHERE EXISTE_ACTIVO = 1
				AND CARGAR_AGRUPACION = 1
				) AUX        
			INNER JOIN REM01.AUX_AGRUP_PROYECTO_HREOS_4591 AUX1 ON AUX1.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
			INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
			INNER JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
			INNER JOIN REM01.BIE_LOCALIZACION BIELOC ON BIELOC.BIE_ID = ACT.BIE_ID
			WHERE RN = 1
			)
		) T1
	WHERE T1.ID_PROYECTO = AUX1.ID_PROYECTO
	GROUP BY ID_PROYECTO
	HAVING COUNT(1)>1);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGRUP_PROYECTO_HREOS_4591 actualizada. '||SQL%ROWCOUNT||' registros no volcaran por actvios con distinta cartera/provincia.');
	
	
	INSERT INTO REM01.ACT_AGR_AGRUPACION AGR(
	AGR_ID,
	DD_TAG_ID,
	AGR_NOMBRE,
	AGR_DESCRIPCION,
	AGR_NUM_AGRUP_REM,
	AGR_NUM_AGRUP_UVEM,
	AGR_FECHA_ALTA,
	AGR_ELIMINADO,
	AGR_FECHA_BAJA,
	AGR_URL,
	AGR_PUBLICADO,
	AGR_SEG_VISITAS,
	AGR_TEXTO_WEB,
	AGR_ACT_PRINCIPAL,
	AGR_GESTOR_ID,
	AGR_MEDIADOR_ID,
	AGR_INI_VIGENCIA,
	AGR_FIN_VIGENCIA,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH AGRUP AS (
		SELECT ID_PROYECTO, AGR_NOMBRE FROM (
			SELECT ID_PROYECTO, AGR_NOMBRE,
			ROW_NUMBER()
			OVER (PARTITION BY ID_PROYECTO, AGR_NOMBRE ORDER BY ID_PROYECTO ASC) AS RN
			FROM REM01.AUX_AGRUP_PROYECTO_HREOS_4591
			WHERE EXISTE_ACTIVO = 1
			AND CARGAR_AGRUPACION = 1
			)
		WHERE RN = 1
	)
	SELECT
	REM01.S_ACT_AGR_AGRUPACION.NEXTVAL			            AGR_ID,
	TAG.DD_TAG_ID	     		                            DD_TAG_ID,
	AUX.AGR_NOMBRE								            AGR_NOMBRE,
	AUX.ID_PROYECTO								            AGR_DESCRIPCION,
	REM01.S_ACT_AGR_AGRUPACION.NEXTVAL			            AGR_NUM_AGRUP_REM,
	NULL										            AGR_NUM_AGRUP_UVEM,
	SYSDATE										            AGR_FECHA_ALTA,
	0										                AGR_ELIMINADO,
	NULL										            AGR_FECHA_BAJA,
	NULL										            AGR_URL,
	0                                                       AGR_PUBLICADO,
	NULL                                                    AGR_SEG_VISITAS,
	NULL                                                    AGR_TEXTO_WEB,
	NULL                                                    AGR_ACT_PRINCIPAL,
	NULL		                                            AGR_GESTOR_ID,
	NULL			                                        AGR_MEDIADOR_ID,
	NULL										            AGR_INI_VIGENCIA,
	NULL							                        AGR_FIN_VIGENCIA,
	'0'                                                 	VERSION,
	'HREOS-4591'                                		    USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	0                                                     	BORRADO
	FROM AGRUP AUX
	INNER JOIN REM01.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_CODIGO = '04';

	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_AGR_AGRUPACION cargada. '||SQL%ROWCOUNT||' Filas.');
	
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

--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AAG_AGRUPACIONES' -> 'ACT_AGR_AGRUPACION', 'ACT_ONV_OBRA_NUEVA', 'ACT_RES_RESTRINGIDA'
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGR_AGRUPACION';
V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_ONV_OBRA_NUEVA';
V_TABLA_3 VARCHAR2(40 CHAR) := 'ACT_RES_RESTRINGIDA';
V_TABLA_4 VARCHAR2(40 CHAR) := 'ACT_LCO_LOTE_COMERCIAL';
V_TABLA_5 VARCHAR2(40 CHAR) := 'ACT_ASI_ASISTIDA';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AAG_AGRUPACIONES';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
--#############################################################
--############ AGRUPACIONES
--#############################################################

/*EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_AGA_AGRUPACION_ACTIVO AGR1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_AAG_AGRUPACIONES MIG INNER JOIN REM01.ACT_AGR_AGRUPACION AGR ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM WHERE VALIDACION IN (0, 1) AND AGR1.AGR_ID = AGR.AGR_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_AAH_AGRUP_ACTIVO_HIST AGR1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_AAG_AGRUPACIONES MIG INNER JOIN REM01.ACT_AGR_AGRUPACION AGR ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM WHERE VALIDACION IN (0, 1) AND AGR1.AGR_ID = AGR.AGR_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_AAH_AGRUP_ACTIVO_HIST borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_SDV_SUBDIVISION_ACTIVO AGR1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_AAG_AGRUPACIONES MIG INNER JOIN REM01.ACT_AGR_AGRUPACION AGR ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM WHERE VALIDACION IN (0, 1) AND AGR1.AGR_ID = AGR.AGR_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_SDV_SUBDIVISION_ACTIVO borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_ONV_OBRA_NUEVA AGR1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_AAG_AGRUPACIONES MIG INNER JOIN REM01.ACT_AGR_AGRUPACION AGR ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM WHERE VALIDACION IN (0, 1) AND AGR1.AGR_ID = AGR.AGR_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_AGO_AGRUPACION_OBS AGR1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_AAG_AGRUPACIONES MIG INNER JOIN REM01.ACT_AGR_AGRUPACION AGR ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM WHERE VALIDACION IN (0, 1) AND AGR1.AGR_ID = AGR.AGR_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_RES_RESTRINGIDA AGR1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_AAG_AGRUPACIONES MIG INNER JOIN REM01.ACT_AGR_AGRUPACION AGR ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM WHERE VALIDACION IN (0, 1) AND AGR1.AGR_ID = AGR.AGR_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_RES_RESTRINGIDA borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_AGR_AGRUPACION AGR1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_AAG_AGRUPACIONES MIG INNER JOIN REM01.ACT_AGR_AGRUPACION AGR ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM WHERE VALIDACION IN (0, 1) AND AGR1.AGR_ID = AGR.AGR_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_AGR_AGRUPACION borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');
  */
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
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
	SELECT
	'||V_ESQUEMA||'.S_ACT_AGR_AGRUPACION.NEXTVAL			AGR_ID,
	(SELECT DD_TAG_ID
	FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION 
	WHERE DD_TAG_CODIGO = MIG.TIPO_AGRUPACION)	     		DD_TAG_ID,
	MIG.AGR_NOMBRE											AGR_NOMBRE,
	MIG.AGR_DESCRIPCION										AGR_DESCRIPCION,
	'||V_ESQUEMA||'.S_ACT_AGR_AGRUPACION.NEXTVAL			AGR_NUM_AGRUP_REM,
	MIG.AGR_UVEM											AGR_NUM_AGRUP_UVEM,
	MIG.AGR_FECHA_ALTA										AGR_FECHA_ALTA,
	MIG.AGR_ELIMINADO										AGR_ELIMINADO,
	MIG.AGR_FECHA_BAJA										AGR_FECHA_BAJA,
	NULL													AGR_URL,
	MIG.AGR_PUBLICADO                                       AGR_PUBLICADO,
	NULL                                                    AGR_SEG_VISITAS,
	MIG.AGR_TEXTO_WEB                                       AGR_TEXTO_WEB,
	(SELECT ACT_ID
	FROM '||V_ESQUEMA||'.ACT_ACTIVO
	WHERE ACT_NUM_ACTIVO = MIG.AGR_ACT_PRINCIPAL)           AGR_ACT_PRINCIPAL,
	NULL		                                            AGR_GESTOR_ID,
	NULL			                                        AGR_MEDIADOR_ID,
	MIG.AGR_FECHA_FIRMA										AGR_INI_VIGENCIA,
	MIG.AGR_FECHA_VENCIMIENTO								AGR_FIN_VIGENCIA,
	''0''                                                 	VERSION,
	'''||V_USUARIO||'''                                	USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	0                                                     	BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	WHERE MIG.VALIDACION = 0 AND MIG.AGR_ELIMINADO IS NOT NULL AND MIG.AGR_PUBLICADO IS NOT NULL
	')
	;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_AGR_AGRUPACION T1
USING (SELECT DISTINCT T1.AGR_ID, CASE WHEN T5.DD_CLA_CODIGO = ''02'' THEN (SELECT DD_SIN_ID FROM REMMASTER.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') 
    ELSE (SELECT DD_SIN_ID FROM REMMASTER.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'') END AGR_IS_FORMALIZACION, T5.DD_CLA_DESCRIPCION 
FROM REM01.ACT_AGR_AGRUPACION T1
JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO T3 ON T3.AGR_ID = T1.AGR_ID
JOIN REM01.ACT_ABA_ACTIVO_BANCARIO T4 ON T4.ACT_ID = T3.ACT_ID
JOIN REM01.DD_CLA_CLASE_ACTIVO T5 ON T5.DD_CLA_ID = T4.DD_CLA_ID
LEFT JOIN REM01.OFR_OFERTAS T2 ON T1.AGR_ID = T2.AGR_ID
UNION
SELECT DISTINCT T1.AGR_ID, CASE WHEN T5.DD_CLA_CODIGO = ''02'' THEN (SELECT DD_SIN_ID FROM REMMASTER.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') 
    ELSE (SELECT DD_SIN_ID FROM REMMASTER.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'') END AGR_IS_FORMALIZACION, T5.DD_CLA_DESCRIPCION  
FROM REM01.ACT_AGR_AGRUPACION T1
JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO T3 ON T3.AGR_ID = T1.AGR_ID
JOIN REM01.ACT_ABA_ACTIVO_BANCARIO T4 ON T4.ACT_ID = T3.ACT_ID
JOIN REM01.DD_CLA_CLASE_ACTIVO T5 ON T5.DD_CLA_ID = T4.DD_CLA_ID
JOIN REM01.OFR_OFERTAS T2 ON T1.AGR_ID = T2.AGR_ID
JOIN DD_EOF_ESTADOS_OFERTA T6 ON T6.DD_EOF_ID = T2.DD_EOF_ID AND T6.DD_EOF_CODIGO IN (''01'',''04'')) T2
ON (T1.AGR_ID = T2.AGR_ID)
WHEN MATCHED THEN UPDATE SET
    T1.AGR_IS_FORMALIZACION = T2.AGR_IS_FORMALIZACION';

  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_3||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_3||' (
	AGR_ID,
	DD_PRV_ID,
	DD_LOC_ID,
	RES_DIRECCION,
	RES_CP,
	RES_ACREEDOR_PDV
	)
	WITH AGR_UVEM AS (
		SELECT AGR_ID , AGR_UVEM
		FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM
		WHERE DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''02'')
		AND MIG.VALIDACION = 0
	)
	SELECT
	(SELECT AGR_ID
	FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
	WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)    			AGR_ID,
	(SELECT DD_PRV_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA
	WHERE DD_PRV_CODIGO = MIG.PRO_AGRUP_LOTE_RESTRINGIDO)   	DD_PRV_ID,
	(SELECT DD_LOC_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD
	WHERE DD_LOC_CODIGO = MIG.LOC_AGRUP_LOTE_RESTRINGIDO)		DD_LOC_ID,
	MIG.RES_DIR_AGRUP_LOTE_RESTRINGIDO							RES_DIRECCION,
	MIG.RES_CP_AGRUP_LOTE_RESTRINGIDO							RES_CP,
	(SELECT pve_id
			FROM REM01.ACT_PVE_PROVEEDOR pve
			WHERE RES_ACR_PDV_AGRUP_LOTE_RESTRIN = pve.PVE_COD_API_PROVEEDOR)	RES_ACREEDOR_PDV 
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN AGR_UVEM AGR
	ON AGR.AGR_UVEM = MIG.AGR_UVEM
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_3||' cargada. '||SQL%ROWCOUNT||' Filas.');


  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
	AGR_ID,
    DD_PRV_ID,
    DD_LOC_ID,
    ONV_DIRECCION,
    ONV_CP,
    ONV_ACREEDOR_PDV
	)
	WITH AGR_UVEM AS (
		SELECT AGR_ID , AGR_UVEM
		FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM
		WHERE DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''01'')
		AND MIG.VALIDACION = 0
	)
	SELECT
	AGR.AGR_ID,
	(SELECT DD_PRV_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA
	WHERE DD_PRV_CODIGO = MIG.PROV_AGRUP_OBRA_NUEVA)   	DD_PRV_ID,
	(SELECT DD_LOC_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD
	WHERE DD_LOC_CODIGO = MIG.LOC_AGRUP_OBRA_NUEVA)		DD_LOC_ID,
	MIG.ONV_DIR_AGRUP_OBRA_NUEVA						ONV_DIRECCION,
	MIG.ONV_CP_AGRUP_OBRA_NUEVA							ONV_CP,
	(SELECT pve_id
			FROM REM01.ACT_PVE_PROVEEDOR pve
			WHERE ONV_ACR_PDV_AGRUP_OBRA_NUEVA = pve.PVE_COD_API_PROVEEDOR)	ONV_ACREEDOR_PDV
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN AGR_UVEM AGR
	ON AGR.AGR_UVEM = MIG.AGR_UVEM
	WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_2||' T2 WHERE T2.AGR_ID = AGR.AGR_ID)
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_4||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO ACT_LCO_LOTE_COMERCIAL T4 (AGR_ID)
WITH AGR_UVEM AS (
		SELECT AGR_ID , AGR_UVEM
		FROM REM01.ACT_AGR_AGRUPACION AGR
		INNER JOIN MIG_AAG_AGRUPACIONES MIG
		ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM
		WHERE NOT EXISTS (
		  SELECT 1 
		  FROM ACT_LCO_LOTE_COMERCIAL AUX WHERE AUX.AGR_ID = AGR.AGR_ID
			)
		AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''14'')
	)
	SELECT
	AGR.AGR_ID
	FROM AGR_UVEM AGR
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_5||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO ACT_ASI_ASISTIDA T4 (AGR_ID)
WITH AGR_UVEM AS (
		SELECT AGR_ID , AGR_UVEM
		FROM REM01.ACT_AGR_AGRUPACION AGR
		INNER JOIN MIG_AAG_AGRUPACIONES MIG
		ON MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM
		WHERE NOT EXISTS (
		  SELECT 1 
		  FROM ACT_ASI_ASISTIDA AUX WHERE AUX.AGR_ID = AGR.AGR_ID
			)
		AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''13'')
	)
	SELECT
	AGR.AGR_ID
	FROM AGR_UVEM AGR
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_5||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  EXECUTE IMMEDIATE ('
			  merge into rem01.act_asi_asistida asi
			using(
			select agr.AGR_ID, 
			(SELECT DD_PRV_ID
			FROM remmaster.DD_PRV_PROVINCIA
			WHERE DD_PRV_CODIGO = MIG.PROV_AGRUP_OBRA_NUEVA) DD_PRV_ID,
			(SELECT DD_LOC_ID
			FROM remmaster.DD_LOC_LOCALIDAD
			WHERE DD_LOC_CODIGO = MIG.LOC_AGRUP_OBRA_NUEVA)	DD_LOC_ID,
			ONV_DIR_AGRUP_OBRA_NUEVA,
			ONV_CP_AGRUP_OBRA_NUEVA,
			(SELECT pve_id
			FROM REM01.ACT_PVE_PROVEEDOR pve
			WHERE ONV_ACR_PDV_AGRUP_OBRA_NUEVA = pve.PVE_COD_API_PROVEEDOR)	pve_id ,
			ONV_ACR_PDV_AGRUP_OBRA_NUEVA
			from REM01.MIG_AAG_AGRUPACIONES mig
			inner join REM01.ACT_AGR_AGRUPACION agr on mig.AGR_UVEM = agr.AGR_NUM_AGRUP_UVEM
			where tipo_agrupacion = ''13'' ) datos
			on (asi.agr_id = datos.agr_id)
			when matched then update
			set 
			asi.DD_PRV_ID = datos.DD_PRV_ID,
			asi.DD_LOC_ID = datos.DD_LOC_ID,
			asi.ASI_DIRECCION = datos.ONV_DIR_AGRUP_OBRA_NUEVA,
			asi.ASI_CP = datos.ONV_CP_AGRUP_OBRA_NUEVA,
			asi.ASI_ACREEDOR_PDV= datos.pve_id
			')
			;
				
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Merge en '||V_ESQUEMA||'.'||V_TABLA_5||' ejecutado. '||SQL%ROWCOUNT||' Filas.');			
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_3||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_3||' ANALIZADA.');

      	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_4||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_4||' ANALIZADA.'); 
  

  
  EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;

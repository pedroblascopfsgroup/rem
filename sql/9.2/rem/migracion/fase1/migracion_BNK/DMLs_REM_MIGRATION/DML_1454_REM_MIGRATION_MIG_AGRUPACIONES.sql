--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
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

TABLE_COUNT NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGR_AGRUPACION';
V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_ONV_OBRA_NUEVA';
V_TABLA_3 VARCHAR2(40 CHAR) := 'ACT_RES_RESTRINGIDA';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AAG_AGRUPACIONES_BNK';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
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
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH AGR_UVEM AS (
		SELECT AGR_UVEM 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		WHERE AGR_UVEM NOT IN (
		  SELECT AGR_NUM_AGRUP_UVEM 
		  FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)
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
	''0''                                                 	VERSION,
	''MIGRAREM01BNK''                                               	USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	0                                                     	BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN AGR_UVEM AGR
	ON AGR.AGR_UVEM = MIG.AGR_UVEM
	')
	;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
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
		WHERE AGR_ID NOT IN (
		  SELECT AGR_ID 
		  FROM '||V_ESQUEMA||'.'||V_TABLA_3||'
			)
		AND DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''02'')
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
	MIG.RES_ACR_PDV_AGRUP_LOTE_RESTRIN							RES_ACREEDOR_PDV
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN AGR_UVEM AGR
	ON AGR.AGR_UVEM = MIG.AGR_UVEM
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_3||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_3||' ANALIZADA.');
  
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
		WHERE AGR_ID NOT IN (
		  SELECT AGR_ID 
		  FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
			)
		AND DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''01'')
	)
	SELECT
	(SELECT AGR_ID
	FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
	WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)    	AGR_ID,
	(SELECT DD_PRV_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA
	WHERE DD_PRV_CODIGO = MIG.PROV_AGRUP_OBRA_NUEVA)   	DD_PRV_ID,
	(SELECT DD_LOC_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD
	WHERE DD_LOC_CODIGO = MIG.LOC_AGRUP_OBRA_NUEVA)		DD_LOC_ID,
	MIG.ONV_DIR_AGRUP_OBRA_NUEVA						ONV_DIRECCION,
	MIG.ONV_CP_AGRUP_OBRA_NUEVA							ONV_CP,
	MIG.ONV_ACR_PDV_AGRUP_OBRA_NUEVA					ONV_ACREEDOR_PDV
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN AGR_UVEM AGR
	ON AGR.AGR_UVEM = MIG.AGR_UVEM
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
  -- INFORMAMOS A LA TABLA INFO
  
  --TABLA_AGRUPACIONES
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(AGR_UVEM) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(AGR_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TAG_TIPO_AGRUPACION'')
	AND FICHERO_ORIGEN = ''AGRUPACIONES.dat''
	AND CAMPO_ORIGEN IN (''TIPO_AGRUPACION'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
   V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' AGRUPACIONES, comprobar integridad de los campos.';
  END IF;
  
  EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
	TABLA_MIG,
	TABLA_REM,
	REGISTROS_TABLA_MIG,
	REGISTROS_INSERTADOS,
	REGISTROS_RECHAZADOS,
	DD_COD_INEXISTENTES,
	FECHA,
	OBSERVACIONES
	)
	SELECT
	'''||V_TABLA_MIG||''',
	'''||V_TABLA||''',
	'||V_REG_MIG||',
	'||V_REG_INSERTADOS||',
	'||V_REJECTS||',
	'||V_COD||',
	SYSDATE,
	'''||V_OBSERVACIONES||'''
	FROM DUAL
  ')
  ;
  
  COMMIT;
  
  -- TABLA_OBRA_NUEVA
  
  -- Registros con DD_TAG_ID = 1, OBRA_NUEVA
  V_SENTENCIA := '
	SELECT COUNT(1)
	FROM '||V_ESQUEMA||'.'||V_TABLA||' AGR
	WHERE AGR.DD_TAG_ID = 1
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(AGR_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
   
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_PRV_PROVINCIA'',''DD_LOC_LOCALIDAD'')
	AND FICHERO_ORIGEN = ''AGRUPACIONES.dat''
	AND CAMPO_ORIGEN IN (''PROV_AGRUP_OBRA_NUEVA'',''LOC_AGRUP_OBRA_NUEVA'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
   V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros, comprobar integridad de los campos.';
  END IF;
  
  EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
	TABLA_MIG,
	TABLA_REM,
	REGISTROS_TABLA_MIG,
	REGISTROS_INSERTADOS,
	REGISTROS_RECHAZADOS,
	DD_COD_INEXISTENTES,
	FECHA,
	OBSERVACIONES
	)
	SELECT
	'''||V_TABLA_MIG||''',
	'''||V_TABLA_2||''',
	'||V_REG_MIG||',
	'||V_REG_INSERTADOS||',
	'||V_REJECTS||',
	'||V_COD||',
	SYSDATE,
	'''||V_OBSERVACIONES||'''
	FROM DUAL
  ')
  ;
  
  -- TABLA_RESTRIGIDA
  
  -- Registros con DD_TAG_ID = 2, RESTRINGIDA
  V_SENTENCIA := '
	SELECT COUNT(1)
	FROM '||V_ESQUEMA||'.'||V_TABLA||' AGR
	WHERE AGR.DD_TAG_ID = 2
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(AGR_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_3||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
   
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  COMMIT;
  
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_PRV_PROVINCIA'',''DD_LOC_LOCALIDAD'')
	AND FICHERO_ORIGEN = ''AGRUPACIONES.dat''
	AND CAMPO_ORIGEN IN (''PRO_AGRUP_LOTE_RESTRINGIDO'',''LOC_AGRUP_LOTE_RESTRINGIDO'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;

  -- Observaciones
  IF V_REJECTS != 0 THEN
   V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros, comprobar integridad de los campos.';
  END IF;
  
  EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
	TABLA_MIG,
	TABLA_REM,
	REGISTROS_TABLA_MIG,
	REGISTROS_INSERTADOS,
	REGISTROS_RECHAZADOS,
	DD_COD_INEXISTENTES,
	FECHA,
	OBSERVACIONES
	)
	SELECT
	'''||V_TABLA_MIG||''',
	'''||V_TABLA_3||''',
	'||V_REG_MIG||',
	'||V_REG_INSERTADOS||',
	'||V_REJECTS||',
	'||V_COD||',
	SYSDATE,
	'''||V_OBSERVACIONES||'''
	FROM DUAL
  ')
  ;
  
  COMMIT;
  
  
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

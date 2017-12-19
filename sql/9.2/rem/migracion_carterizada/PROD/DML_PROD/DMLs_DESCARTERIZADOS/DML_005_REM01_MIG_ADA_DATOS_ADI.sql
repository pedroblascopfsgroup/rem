--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ADA_DATOS_ADI' -> 'ACT_ADM_INF_ADMINISTRATIVA', 'ACT_SPS_SIT_POSESORIA',
--##														'BIE_DATOS_REGISTRALES', 'ACT_REG_INFO_REGISTRAL', 'ACT_LOC_LOCALIZACION',
--##														'BIE_LOCALIZACION (MERGE)', 'ACT_ACTIVO (MERGE)'
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
V_TABLA VARCHAR2(30 CHAR) := 'ACT_ADM_INF_ADMINISTRATIVA';
V_TABLA_2 VARCHAR2(30 CHAR) := 'ACT_SPS_SIT_POSESORIA';
V_TABLA_3 VARCHAR2(30 CHAR) := 'BIE_DATOS_REGISTRALES';
V_TABLA_4 VARCHAR2(30 CHAR) := 'ACT_REG_INFO_REGISTRAL';
V_TABLA_5 VARCHAR2(30 CHAR) := 'BIE_LOCALIZACION';
V_TABLA_6 VARCHAR2(30 CHAR) := 'ACT_LOC_LOCALIZACION';
V_TABLA_7 VARCHAR2(30 CHAR) := 'ACT_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ADA_DATOS_ADI';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  SET
  BIE_DREG_ID = S_BIE_DATOS_REGISTRALES.NEXTVAL,
  REG_ID = S_ACT_REG_INFO_REGISTRAL.NEXTVAL,
  BIE_LOC_ID = S_BIE_LOCALIZACION.NEXTVAL,
  LOC_ID = S_ACT_LOC_LOCALIZACION.NEXTVAL
  WHERE BIE_DREG_ID IS NULL
  OR REG_ID IS NULL
  OR BIE_LOC_ID IS NULL
  OR LOC_ID IS NULL
  AND NOT EXISTS (
	SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO NOTT
	WHERE NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	)
  ')
  ;
  --POR CADA TABLA DEL MODELO, HACEMOS UN FILTRO PARA NO INSERTAR REGISTROS QUE YA EXISTEN, LO HACEMOS A TRAVES DE ACT_NUMERO_ACTIVO
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'. [INFORMACION ADMINISTRATIVA ACTIVO]');

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	ADM_ID,
	ACT_ID,
	DD_TVP_ID,
	ADM_SUELO_VPO,
	ADM_PROMOCION_VPO,
	ADM_NUM_EXPEDIENTE,
	ADM_FECHA_CALIFICACION,
	ADM_OBLIGATORIO_SOL_DEV_AYUDA,
	ADM_OBLIG_AUT_ADM_VENTA,
	ADM_DESCALIFICADO,
	ADM_MAX_PRECIO_VENTA,
	ADM_OBSERVACIONES,
	ADM_SUJETO_A_EXPEDIENTE,
	ADM_ORGANISMO_EXPROPIANTE,
	ADM_FECHA_INI_EXPEDIENTE,
	ADM_REF_EXPDTE_ADMIN,
	ADM_REF_EXPDTE_INTERNO,
	ADM_OBS_EXPROPIACION,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	WITH ACT_NUM_ACTIVO AS (
		SELECT ACT_NUMERO_ACTIVO 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		WHERE ACT_NUMERO_ACTIVO NOT IN (
		  SELECT ACT_NUM_ACTIVO 
		  FROM '||V_ESQUEMA||'.ACT_ACTIVO 
		  WHERE ACT_ID IN (
			SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' 
			)
			)
		AND MIG.VALIDACION IN (0,1)
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_ADM_INF_ADMINISTRATIVA.NEXTVAL      ADM_ID,
	ACT2.ACT_ID,
	(SELECT DD_TVP_ID
	FROM '||V_ESQUEMA||'.DD_TVP_TIPO_VPO
	WHERE DD_TVP_CODIGO = MIG.TIPO_VPO)                       DD_TVP_ID,
	MIG.ADM_SUELO_VPO                                         ADM_SUELO_VPO,
	MIG.ADM_PROMOCION_VPO                                     ADM_PROMOCION_VPO,
	MIG.ADM_NUM_EXPEDIENTE                                    ADM_NUM_EXPEDIENTE,
	MIG.ADM_FECHA_CALIFICACION                                ADM_FECHA_CALIFICACION,
	MIG.ADM_OBLIGATORIO_SOL_DEV_AYUDA                         ADM_OBLIGATORIO_SOL_DEV_AYUDA,
	MIG.ADM_OBLIG_AUT_ADM_VENTA                               ADM_OBLIG_AUT_ADM_VENTA,
	MIG.ADM_DESCALIFICADO                                     ADM_DESCALIFICADO,
	MIG.ADM_MAX_PRECIO_VENTA                                  ADM_MAX_PRECIO_VENTA,
	MIG.ADM_OBSERVACIONES                                     ADM_OBSERVACIONES,
	NULL                                                      ADM_SUJETO_A_EXPEDIENTE,
	NULL                                                      ADM_ORGANISMO_EXPROPIANTE,
	NULL                                                      ADM_FECHA_INI_EXPEDIENTE,
	NULL                                                      ADM_REF_EXPDTE_ADMIN,
	NULL                                                      ADM_REF_EXPDTE_INTERNO,
	NULL                                                      ADM_OBS_EXPROPIACION,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN ACT_NUM_ACTIVO ACT ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO = ACT.ACT_NUMERO_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  -------
  
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'. [SITUACION POSESORIA ACTIVO]');

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
	SPS_ID,
	ACT_ID,
	DD_TPO_ID,
	SPS_FECHA_REVISION_ESTADO,
	SPS_FECHA_TOMA_POSESION,
	SPS_OCUPADO,
	SPS_CON_TITULO,
	SPS_RIESGO_OCUPACION,
	SPS_FECHA_TITULO,
	SPS_FECHA_VENC_TITULO,
	SPS_RENTA_MENSUAL,
	SPS_FECHA_SOL_DESAHUCIO,
	SPS_FECHA_LANZAMIENTO,
	SPS_FECHA_LANZAMIENTO_EFECTIVO,
	SPS_ACC_TAPIADO,
	SPS_FECHA_ACC_TAPIADO,
	SPS_ACC_ANTIOCUPA,
	SPS_FECHA_ACC_ANTIOCUPA,
	SPS_OTRO,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_SPS_SIT_POSESORIA.NEXTVAL           SPS_ID,
	ACT.ACT_ID,
	(SELECT DD_TPO_ID
	FROM '||V_ESQUEMA||'.DD_TPO_TIPO_TITULO_POSESORIO
	WHERE DD_TPO_CODIGO = MIG.TIPO_TITULO_POSESORIO)          DD_TPO_ID,
	MIG.SPS_FECHA_REVISION_ESTADO                             SPS_FECHA_REVISION_ESTADO,
	MIG.SPS_FECHA_TOMA_POSESION                               SPS_FECHA_TOMA_POSESION,
	MIG.SPS_OCUPADO                                           SPS_OCUPADO,
	MIG.SPS_CON_TITULO                                        SPS_CON_TITULO,
	MIG.SPS_RIESGO_OCUPACION                                  SPS_RIESGO_OCUPACION,
	MIG.SPS_FECHA_TITULO                                      SPS_FECHA_TITULO,
	MIG.SPS_FECHA_VENC_TITULO                                 SPS_FECHA_VENC_TITULO,
	MIG.SPS_RENTA_MENSUAL                                     SPS_RENTA_MENSUAL,
	MIG.SPS_FECHA_SOL_DESAHUCIO                               SPS_FECHA_SOL_DESAHUCIO,
	MIG.SPS_FECHA_LANZAMIENTO                                 SPS_FECHA_LANZAMIENTO,
	MIG.SPS_FECHA_LANZAMIENTO_EFECTIVO                        SPS_FECHA_LANZAMIENTO_EFECTIVO,
	MIG.SPS_ACC_TAPIADO                                       SPS_ACC_TAPIADO,
	MIG.SPS_FECHA_ACC_TAPIADO                                 SPS_FECHA_ACC_TAPIADO,
	MIG.SPS_ACC_ANTIOCUPA                                     SPS_ACC_ANTIOCUPA,
	MIG.SPS_FECHA_ACC_ANTIOCUPA                               SPS_FECHA_ACC_ANTIOCUPA,
	MIG.ACT_IND_CONDICIONADO_OTROS							  SPS_OTRO,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO AND ACT.BORRADO = 0
	WHERE MIG.VALIDACION IN (0,1) AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_2||' AUX WHERE AUX.ACT_ID = ACT.ACT_ID AND AUX.BORRADO = 0)
	')
	;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_2||' T1
  	USING (SELECT T1.ACT_ID, MIG.SPS_FECHA_TOMA_POSESION
  		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  		JOIN '||V_ESQUEMA||'.ACT_ACTIVO T1 ON T1.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO AND T1.BORRADO = 0
  		WHERE MIG.VALIDACION IN (0,1)) T2
  	ON (T1.ACT_ID = T2.ACT_ID)
  	WHEN MATCHED THEN UPDATE SET
  		T1.SPS_FECHA_TOMA_POSESION = T2.SPS_FECHA_TOMA_POSESION';

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' actualizada (SPS_FECHA_TOMA_POSESION). '||SQL%ROWCOUNT||' Filas.');

  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
	-------
   
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_3||'. [DATOS REGISTRALES BIENES]');

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_3||' (
	BIE_DREG_ID,
	BIE_ID,
	BIE_DREG_REFERENCIA_CATASTRAL,
	BIE_DREG_SUPERFICIE,
	BIE_DREG_SUPERFICIE_CONSTRUIDA,
	BIE_DREG_TOMO,
	BIE_DREG_LIBRO,
	BIE_DREG_FOLIO,
	BIE_DREG_INSCRIPCION,
	BIE_DREG_FECHA_INSCRIPCION,
	BIE_DREG_NUM_REGISTRO,
	BIE_DREG_MUNICIPIO_LIBRO,
	BIE_DREG_CODIGO_REGISTRO,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO,
	BIE_DREG_NUM_FINCA,
	DD_LOC_ID,
	DD_PRV_ID
	)
	SELECT
	MIG.BIE_DREG_ID									          BIE_DREG_ID,
	ACT.BIE_ID,
	NULL                  									  BIE_DREG_REFERENCIA_CATASTRAL,
	MIG.REG_SUPERFICIE                                        BIE_DREG_SUPERFICIE,
	MIG.REG_SUPERFICIE_CONSTRUIDA                             BIE_DREG_SUPERFICIE_CONSTRUIDA,
	MIG.REG_TOMO                                              BIE_DREG_TOMO,
	MIG.REG_LIBRO                                             BIE_DREG_LIBRO,
	MIG.REG_FOLIO                                             BIE_DREG_FOLIO,
	NULL                            						  BIE_DREG_INSCRIPCION,
	NULL                      								  BIE_DREG_FECHA_INSCRIPCION,
	MIG.REG_NUM_REGISTRO                                      BIE_DREG_NUM_REGISTRO,
	NULL                        							  BIE_DREG_MUNICIPIO_LIBRO,
	NULL                        							  BIE_DREG_CODIGO_REGISTRO,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''			                          	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO,
	MIG.REG_NUM_FINCA                                         BIE_DREG_NUM_FINCA,
	(SELECT DD_LOC_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD
	WHERE DD_LOC_CODIGO = MIG.MUNICIPIO_REGISTRO)                      DD_LOC_ID,
	(SELECT DD_PRV_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA
	WHERE DD_PRV_CODIGO = MIG.PROVINCIA)                      DD_PRV_ID
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.VALIDACION IN (0,1) AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_3||' AUX WHERE AUX.BIE_DREG_ID = MIG.BIE_DREG_ID)
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_3||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_3||' ANALIZADA.');
  
  --------
    
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_4||'. [INFORMACION REGISTRAL ACTIVO]');

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_4||' (
	REG_ID,
	ACT_ID,
	BIE_DREG_ID,
	REG_IDUFIR,
	REG_NUM_DEPARTAMENTO,
	REG_HAN_CAMBIADO,
	DD_LOC_ID_ANTERIOR,
	REG_NUM_ANTERIOR,
	REG_NUM_FINCA_ANTERIOR,
	REG_SUPERFICIE_UTIL,
	REG_SUPERFICIE_ELEM_COMUN,
	REG_SUPERFICIE_PARCELA,
	REG_SUPERFICIE_BAJO_RASANTE,
	REG_SUPERFICIE_SOBRE_RASANTE,
	REG_DIV_HOR_INSCRITO,
	DD_EDH_ID,
	DD_EON_ID,
	REG_FECHA_CFO,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	SELECT 
	MIG.REG_ID          										REG_ID,
	ACT.ACT_ID,
	MIG.BIE_DREG_ID									          BIE_DREG_ID,
	MIG.REG_IDUFIR                                            REG_IDUFIR,
	NULL					                                  REG_NUM_DEPARTAMENTO,
	MIG.REG_HAN_CAMBIADO                                      REG_HAN_CAMBIADO,
	(SELECT DD_LOC_ID
	FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD
	WHERE DD_LOC_CODIGO = MIG.MUNICIPIO_REG_ANTERIOR)         DD_LOC_ID_ANTERIOR,
	MIG.REG_NUM_ANTERIOR                                      REG_NUM_ANTERIOR,
	MIG.REG_NUM_FINCA_ANTERIOR                                REG_NUM_FINCA_ANTERIOR,
	MIG.REG_SUPERFICIE_UTIL                                   REG_SUPERFICIE_UTIL,
	MIG.REG_SUPERFICIE_ELEM_COMUN                             REG_SUPERFICIE_ELEM_COMUN,
	MIG.REG_SUPERFICIE_PARCELA                                REG_SUPERFICIE_PARCELA,
	MIG.REG_SUPERFICIE_BAJO_RASANTE                           REG_SUPERFICIE_BAJO_RASANTE,
	MIG.REG_SUPERFICIE_SOBRE_RASANTE                          REG_SUPERFICIE_SOBRE_RASANTE,
	MIG.REG_DIV_HOR_INSCRITO                                  REG_DIV_HOR_INSCRITO,
	(SELECT DD_EDH_ID
	FROM '||V_ESQUEMA||'.DD_EDH_ESTADO_DIV_HORIZONTAL
	WHERE DD_EDH_CODIGO = MIG.ESTADO_DIVISION_HORIZONTAL)     DD_EDH_ID,
	(SELECT DD_EON_ID
	FROM '||V_ESQUEMA||'.DD_EON_ESTADO_OBRA_NUEVA
	WHERE DD_EON_CODIGO = MIG.ESTADO_OBRA_NUEVA)              DD_EON_ID,
	MIG.REG_FECHA_CFO                                         REG_FECHA_CFO,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE  MIG.VALIDACION IN (0,1) AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_4||' AUX WHERE AUX.ACT_ID = ACT.ACT_ID AND AUX.BORRADO = 0)
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_4||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_4||' ANALIZADA.');
  
  --------
    
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_5||'. [LOCALIZACION BIEN]');
	
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_5||' (
  BIE_LOC_ID,
  BIE_ID,
  BIE_LOC_POBLACION,
  BIE_LOC_DIRECCION,
  BIE_LOC_COD_POST,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO,
  DD_PRV_ID,
  BIE_LOC_NOMBRE_VIA,
  BIE_LOC_NUMERO_DOMICILIO,
  BIE_LOC_ESCALERA,
  BIE_LOC_PISO,
  BIE_LOC_PUERTA,
  BIE_LOC_MUNICIPIO,
  BIE_LOC_PROVINCIA,
  DD_LOC_ID,
  DD_UPO_ID,
  DD_TVI_ID,
  DD_CIC_ID
  )
  SELECT
  MIG.BIE_LOC_ID							                    	                                        BIE_LOC_ID,
  ACT.BIE_ID,
  
  MIG.MUNICIPIO														                                                  BIE_LOC_POBLACION,
  MIG.LOC_NOMBRE_VIA||'',''||MIG.LOC_NUMERO_DOMICILIO				        BIE_LOC_DIRECCION,
  MIG.LOC_COD_POST													                                            BIE_LOC_COD_POST,
  ''0''                                                                                               VERSION,
  '''||V_USUARIO||'''                                                                                           USUARIOCREAR,
  SYSDATE                                                                                      FECHACREAR,
  0                                                                                                BORRADO,
  DD.DD_PRV_ID							              DD_PRV_ID,
  MIG.LOC_NOMBRE_VIA												                                         BIE_LOC_NOMBRE_VIA,
  MIG.LOC_NUMERO_DOMICILIO											                               BIE_LOC_NUMERO_DOMICILIO,
  MIG.LOC_ESCALERA													                                        BIE_LOC_ESCALERA,
  MIG.LOC_PISO														                                               BIE_LOC_PISO,
  MIG.LOC_PUERTA													                                            BIE_LOC_PUERTA,
  MIG.MUNICIPIO														                                            BIE_LOC_MUNICIPIO,
  MIG.PROVINCIA														                                         BIE_LOC_PROVINCIA,
  (SELECT DD_LOC_ID
    FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD
    WHERE DD_LOC_CODIGO = MIG.MUNICIPIO)							                       DD_LOC_ID,
  (SELECT DD_UPO_ID
    FROM '||V_ESQUEMA_MASTER||'.DD_UPO_UNID_POBLACIONAL
    WHERE DD_UPO_CODIGO = MIG.UNIDAD_INFERIOR_MUNICIPIO)			      DD_UPO_ID,
  (SELECT DD_TVI_ID
    FROM '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA
    WHERE DD_TVI_CODIGO = MIG.TIPO_VIA)								                           DD_TVI_ID,
  (SELECT DD_CIC_ID
    FROM '||V_ESQUEMA_MASTER||'.DD_CIC_CODIGO_ISO_CIRBE_BKP
    WHERE DD_CIC_CODIGO = MIG.PAIS)									                             DD_CIC_ID
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA DD
	ON DD.DD_PRV_CODIGO = MIG.PROVINCIA
  WHERE DD.DD_PRV_CODIGO IS NOT NULL
  AND MIG.VALIDACION IN (0,1) AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_5||' AUX WHERE AUX.BIE_ID = ACT.BIE_ID )
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_5||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_5||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_5||' ANALIZADA.');
  
  --------

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_6||'. [LOCALIZACION ACTIVO]');

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_6||' LOC (
	LOC_ID,
	ACT_ID,
	BIE_LOC_ID,
	DD_TUB_ID,
	LOC_LONGITUD,
	LOC_LATITUD,
	LOC_DIST_PLAYA,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	SELECT
	MIG.LOC_ID									              LOC_ID,
	ACT.ACT_ID,
	MIG.BIE_LOC_ID									          BIE_LOC_ID,
	(SELECT DD_TUB_ID
	FROM '||V_ESQUEMA||'.DD_TUB_TIPO_UBICACION
	WHERE DD_TUB_CODIGO = MIG.TIPO_UBICACION)                 DD_TUB_ID,
	MIG.LOC_LONGITUD                                          LOC_LONGITUD,
	MIG.LOC_LATITUD                                           LOC_LATITUD,
	MIG.LOC_DIST_PLAYA                                        LOC_DIST_PLAYA,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    JOIN '||V_ESQUEMA||'.'||V_TABLA_5||' BIE_LOC ON BIE_LOC.BIE_LOC_ID = MIG.BIE_LOC_ID
	WHERE MIG.VALIDACION IN (0,1) AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_6||' AUX WHERE AUX.ACT_ID = ACT.ACT_ID AND AUX.BORRADO = 0)
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_6||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_6||' ANALIZADA.');
  
  --------
    
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_7||'. [CPR_ID]');

	EXECUTE IMMEDIATE ('
	MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_7||' ACT 
	USING (
		SELECT MIG.CPR_COD_COM_PROP_UVEM, CPR.CPR_ID, MIG.ACT_NUMERO_ACTIVO
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		INNER JOIN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS CPR
		ON CPR.CPR_COD_COM_PROP_UVEM = MIG.CPR_COD_COM_PROP_UVEM
		WHERE MIG.VALIDACION IN (0,1)
	) TMP
	ON (ACT.ACT_NUM_ACTIVO = TMP.ACT_NUMERO_ACTIVO)
	WHEN MATCHED THEN UPDATE SET
	ACT.CPR_ID = TMP.CPR_ID
	')  
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_7||' actualizada. '||SQL%ROWCOUNT||' Filas. Merge.');
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_7||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_7||' ANALIZADA.');
  
  --------
    
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_7||'. [LLAVES]');

	EXECUTE IMMEDIATE ('
	MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_7||' ACT 
	USING (
		SELECT * FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		WHERE MIG.VALIDACION IN (0,1)
	) MIG
	ON (MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO)
	WHEN MATCHED THEN UPDATE
	SET
	ACT.ACT_LLAVES_NECESARIAS = MIG.ACT_LLV_NECESARIAS,
	ACT.ACT_LLAVES_HRE = MIG.ACT_LLV_LLAVES_HRE,
	ACT.ACT_LLAVES_NUM_JUEGOS = MIG.ACT_LLV_NUM_JUEGOS,
	ACT.ACT_LLAVES_FECHA_RECEP = MIG.ACT_LLV_FECHA_RECEPCION
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_7||' actualizada. '||SQL%ROWCOUNT||' Filas. Merge.');
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_7||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_7||' ANALIZADA.');
  
  --INSERTAMOS REGISTROS EN BIE_LOCALIZACION Y ACT_LOC_LOCALIZACION PARA QUE SEA 1 A 1 CON ACTIVOS, YA QUE LO REQUIERE LA APLICACION
  
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS REGISTROS EN BIE_LOCALIZACION Y ACT_LOC_LOCALIZACION PARA QUE SEA 1 A 1 CON ACTIVOS, YA QUE LO REQUIERE LA APLICACION.');
  
  EXECUTE IMMEDIATE '
  insert into '||V_ESQUEMA||'.'||V_TABLA_5||' (
	bie_loc_id,
	BIE_ID,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	select
	MIG.BIE_LOC_ID					bie_loc_id,
	ACT.bie_id bie_id,
	0,
	'''||V_USUARIO||''',
	sysdate,
	0
	from '||V_ESQUEMA||'.'||V_TABLA_MIG||' mig
        	INNER join '||V_ESQUEMA||'.act_activo act
	  on act.act_num_activo = mig.act_numero_activo
	where not exists (
	  select 1 from '||V_ESQUEMA||'.'||V_TABLA_5||' loc where loc.bie_id = act.bie_id
	  )
	AND mig.VALIDACION IN (0,1)
	'
  ;
  
	commit;
  
  EXECUTE IMMEDIATE '
  insert into '||V_ESQUEMA||'.'||V_TABLA_6||' (
	LOC_ID,
	ACT_ID,
	BIE_LOC_ID,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	select
	MIG.LOC_ID					LOC_ID,
	ACT.ACT_ID ACT_ID,
	MIG.BIE_LOC_ID  BIE_LOC_ID,
	0,
	'''||V_USUARIO||''',
	sysdate,
	0
	from '||V_ESQUEMA||'.'||V_TABLA_MIG||' mig
    	INNER join '||V_ESQUEMA||'.act_activo act
	  on act.act_num_activo = mig.act_numero_activo
      INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON BIE_LOC.BIE_LOC_ID = MIG.BIE_LOC_ID
	where not exists (
	  select 1 from '||V_ESQUEMA||'.'||V_TABLA_6||' LOC where loc.ACT_ID = act.ACT_ID
      AND LOC.BIE_LOC_ID = BIE_LOC.BIE_LOC_ID
	  )
	AND mig.VALIDACION IN (0,1)
  '
  ;
  
	commit;
  
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

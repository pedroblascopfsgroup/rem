--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190224
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3398
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 
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

-- Variables
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3398';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);
V_SENTENCIA VARCHAR2(2000 CHAR);

--Tablas
V_TABLA VARCHAR2(30 CHAR) := 'ACT_ADM_INF_ADMINISTRATIVA';
V_TABLA_2 VARCHAR2(30 CHAR) := 'ACT_SPS_SIT_POSESORIA';
V_TABLA_3 VARCHAR2(30 CHAR) := 'BIE_DATOS_REGISTRALES';
V_TABLA_4 VARCHAR2(30 CHAR) := 'ACT_REG_INFO_REGISTRAL';
V_TABLA_5 VARCHAR2(30 CHAR) := 'BIE_LOCALIZACION';
V_TABLA_6 VARCHAR2(30 CHAR) := 'ACT_LOC_LOCALIZACION';

V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_SEGREG_SAREB';




BEGIN
  

  --POR CADA TABLA DEL MODELO, HACEMOS UN FILTRO PARA NO INSERTAR REGISTROS QUE YA EXISTEN, LO HACEMOS A TRAVES DE ACT_NUMERO_ACTIVO
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'. [INFORMACION ADMINISTRATIVA ACTIVO]');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_ADM_INF_ADMINISTRATIVA');
        
    ELSE
    
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
	SELECT
	'||V_ESQUEMA||'.S_ACT_ADM_INF_ADMINISTRATIVA.NEXTVAL      ADM_ID,
	ACT2.ACT_ID,
	ADM.DD_TVP_ID						                      DD_TVP_ID,
	ADM.ADM_SUELO_VPO                                         ADM_SUELO_VPO,
	ADM.ADM_PROMOCION_VPO                                     ADM_PROMOCION_VPO,
	ADM.ADM_NUM_EXPEDIENTE                                    ADM_NUM_EXPEDIENTE,
	ADM.ADM_FECHA_CALIFICACION                                ADM_FECHA_CALIFICACION,
	ADM.ADM_OBLIGATORIO_SOL_DEV_AYUDA                         ADM_OBLIGATORIO_SOL_DEV_AYUDA,
	ADM.ADM_OBLIG_AUT_ADM_VENTA                               ADM_OBLIG_AUT_ADM_VENTA,
	ADM.ADM_DESCALIFICADO                                     ADM_DESCALIFICADO,
	ADM.ADM_MAX_PRECIO_VENTA                                  ADM_MAX_PRECIO_VENTA,
	ADM.ADM_OBSERVACIONES                                     ADM_OBSERVACIONES,
	NULL                                                      ADM_SUJETO_A_EXPEDIENTE,
	NULL                                                      ADM_ORGANISMO_EXPROPIANTE,
	NULL                                                      ADM_FECHA_INI_EXPEDIENTE,
	NULL                                                      ADM_REF_EXPDTE_ADMIN,
	NULL                                                      ADM_REF_EXPDTE_INTERNO,
	NULL                                                      ADM_OBS_EXPROPIACION,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                       USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ADM ON ADM.ACT_ID = ACT.ACT_ID
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  -------
  
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'. [SITUACION POSESORIA ACTIVO]');

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_SPS_SIT_POSESORIA');
        
    ELSE

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
	ACT2.ACT_ID,
	SPS.DD_TPO_ID									          DD_TPO_ID,
	trunc(SYSDATE)				                              SPS_FECHA_REVISION_ESTADO,
	null                               						  SPS_FECHA_TOMA_POSESION,
	0                                           			  SPS_OCUPADO,
	0                                        				  SPS_CON_TITULO,
	0						                                  SPS_RIESGO_OCUPACION,
	TRUNC(SYSDATE)                            				  SPS_FECHA_TITULO,
	SPS.SPS_FECHA_VENC_TITULO                                 SPS_FECHA_VENC_TITULO,
	SPS.SPS_RENTA_MENSUAL                                     SPS_RENTA_MENSUAL,
	SPS.SPS_FECHA_SOL_DESAHUCIO                               SPS_FECHA_SOL_DESAHUCIO,
	SPS.SPS_FECHA_LANZAMIENTO                                 SPS_FECHA_LANZAMIENTO,
	SPS.SPS_FECHA_LANZAMIENTO_EFECTIVO                        SPS_FECHA_LANZAMIENTO_EFECTIVO,
	SPS.SPS_ACC_TAPIADO                                       SPS_ACC_TAPIADO,
	SPS.SPS_FECHA_ACC_TAPIADO                                 SPS_FECHA_ACC_TAPIADO,
	SPS.SPS_ACC_ANTIOCUPA                                     SPS_ACC_ANTIOCUPA,
	SPS.SPS_FECHA_ACC_ANTIOCUPA                               SPS_FECHA_ACC_ANTIOCUPA,
	SPS.SPS_OTRO							  				  SPS_OTRO,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                       USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' SPS ON SPS.ACT_ID = ACT.ACT_ID
	')
	;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  

  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
	-------
   
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_3||'. [DATOS REGISTRALES BIENES]');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_3||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA BIE_DATOS_REGISTRALES');

    ELSE

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
	'||V_ESQUEMA||'.S_BIE_DATOS_REGISTRALES.NEXTVAL			  BIE_DREG_ID,
	ACT2.BIE_ID,
	AUX.REF_CATASTRAL      									  BIE_DREG_REFERENCIA_CATASTRAL,
	BIE.BIE_DREG_SUPERFICIE                                   BIE_DREG_SUPERFICIE,
	BIE.BIE_DREG_SUPERFICIE_CONSTRUIDA                        BIE_DREG_SUPERFICIE_CONSTRUIDA,
	''2068''		                                          BIE_DREG_TOMO,
	''944''				                                      BIE_DREG_LIBRO,
	AUX.FOLIO_REG     			                                   BIE_DREG_FOLIO,
	NULL                            						  BIE_DREG_INSCRIPCION,
	NULL                      								  BIE_DREG_FECHA_INSCRIPCION,
	BIE.BIE_DREG_NUM_REGISTRO                                 BIE_DREG_NUM_REGISTRO,
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
	AUX.FINCA                                    				BIE_DREG_NUM_FINCA,
	BIE.DD_LOC_ID						                      DD_LOC_ID,
	BIE.DD_PRV_ID                      						  DD_PRV_ID
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_3||' BIE ON ACT.BIE_ID = BIE.BIE_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_3||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_3||' ANALIZADA.');
  
  --------
    
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_4||'. [INFORMACION REGISTRAL ACTIVO]');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_4||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_REG_INFO_REGISTRAL');
        
    ELSE

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
	'||V_ESQUEMA||'.S_ACT_REG_INFO_REGISTRAL.NEXTVAL          REG_ID,
	ACT2.ACT_ID,
	BIE_REG.BIE_DREG_ID									          BIE_DREG_ID,
	AUX.IDUFIR                                            REG_IDUFIR,
	NULL					                                  REG_NUM_DEPARTAMENTO,
	REG.REG_HAN_CAMBIADO                                      REG_HAN_CAMBIADO,
	REG.DD_LOC_ID_ANTERIOR							          DD_LOC_ID_ANTERIOR,
	REG.REG_NUM_ANTERIOR                                      REG_NUM_ANTERIOR,
	REG.REG_NUM_FINCA_ANTERIOR                                REG_NUM_FINCA_ANTERIOR,
	REG.REG_SUPERFICIE_UTIL                                   REG_SUPERFICIE_UTIL,
	REG.REG_SUPERFICIE_ELEM_COMUN                             REG_SUPERFICIE_ELEM_COMUN,
	REG.REG_SUPERFICIE_PARCELA                                REG_SUPERFICIE_PARCELA,
	REG.REG_SUPERFICIE_BAJO_RASANTE                           REG_SUPERFICIE_BAJO_RASANTE,
	REG.REG_SUPERFICIE_SOBRE_RASANTE                          REG_SUPERFICIE_SOBRE_RASANTE,
	REG.REG_DIV_HOR_INSCRITO                                  REG_DIV_HOR_INSCRITO,
	REG.DD_EDH_ID										      DD_EDH_ID,
	REG.DD_EON_ID								              DD_EON_ID,
	REG.REG_FECHA_CFO                                         REG_FECHA_CFO,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                       USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_4||' REG ON ACT.ACT_ID = REG.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_3||' BIE_REG ON BIE_REG.BIE_ID = ACT2.BIE_ID

  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_4||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_4||' ANALIZADA.');
  
  --------
    
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_5||'. [LOCALIZACION BIEN]');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_5||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA BIE_LOCALIZACION');
        
    ELSE
	
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
  '||V_ESQUEMA||'.S_BIE_LOCALIZACION.NEXTVAL 							BIE_LOC_ID,
  ACT2.BIE_ID, 
  LOC.BIE_LOC_POBLACION												    BIE_LOC_POBLACION,
  LOC.BIE_LOC_DIRECCION				        							BIE_LOC_DIRECCION,
  LOC.BIE_LOC_COD_POST													BIE_LOC_COD_POST,
  ''0''                                                                 VERSION,
  '''||V_USUARIO||'''                                                   USUARIOCREAR,
  SYSDATE                                                               FECHACREAR,
  0                                                                     BORRADO,
  LOC.DD_PRV_ID							              					DD_PRV_ID,
  LOC.BIE_LOC_NOMBRE_VIA	                 							BIE_LOC_NOMBRE_VIA,
  AUX.VIA																BIE_LOC_NUMERO_DOMICILIO,
  LOC.BIE_LOC_ESCALERA													BIE_LOC_ESCALERA,
  AUX.PLANTA															BIE_LOC_PISO,
  AUX.PUERTA															BIE_LOC_PUERTA,
  LOC.BIE_LOC_MUNICIPIO													BIE_LOC_MUNICIPIO,
  LOC.BIE_LOC_PROVINCIA													BIE_LOC_PROVINCIA,
  LOC.DD_LOC_ID							                        		DD_LOC_ID,
  LOC.DD_UPO_ID			      											DD_UPO_ID,
  LOC.DD_TVI_ID							                           		DD_TVI_ID,
  LOC.DD_CIC_ID								                            DD_CIC_ID
  FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_5||' LOC ON ACT.BIE_ID = LOC.BIE_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_5||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_5||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_5||' ANALIZADA.');
  
  --------

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_6||'. [LOCALIZACION ACTIVO]');

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_6||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_LOC_LOCALIZACION');
        
    ELSE

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
	  '||V_ESQUEMA||'.S_ACT_LOC_LOCALIZACION.NEXTVAL   		                LOC_ID,
	ACT2.ACT_ID,
	LOC.BIE_LOC_ID									          BIE_LOC_ID,
	ACT_LOC.DD_TUB_ID                 DD_TUB_ID,
	ACT_LOC.LOC_LONGITUD                                          LOC_LONGITUD,
	ACT_LOC.LOC_LATITUD                                           LOC_LATITUD,
	ACT_LOC.LOC_DIST_PLAYA                                        LOC_DIST_PLAYA,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_6||' ACT_LOC ON ACT.ACT_ID = ACT_LOC.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_5||' LOC ON LOC.BIE_ID = ACT2.BIE_ID

  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_6||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_6||' ANALIZADA.');
  
 
  
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

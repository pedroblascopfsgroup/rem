--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-17293
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

-- Variables
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17293';
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
V_TABLA_7 VARCHAR2(30 CHAR) := 'ACT_VAL_VALORACIONES';
V_TABLA_8 VARCHAR2(30 CHAR) := 'ACT_HVA_HIST_VALORACIONES';
V_TABLA_9 VARCHAR2(30 CHAR) := 'H_ACT_RFV_REQ_FASE_VENTA';

V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';



BEGIN
  

  --POR CADA TABLA DEL MODELO, HACEMOS UN FILTRO PARA NO INSERTAR REGISTROS QUE YA EXISTEN, LO HACEMOS A TRAVES DE ACT_NUMERO_ACTIVO
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'. [INFORMACION ADMINISTRATIVA ACTIVO]');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
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
	BORRADO,

	ADM_VIGENCIA,
	ADM_COMUNICAR_ADQUISICION,
	ADM_NECESARIO_INSCR_VPO,
	ADM_LIBERTAD_CESION,
	ADM_RENUNCIA_TANTEO_RETRAC,
	ADM_VISA_CONTRATO_PRIVADO,
	ADM_VENDER_PER_JURIDICA,
	ADM_MINUSVALIA,
	ADM_INSCR_REGISTRO_DEMANDA,
	ADM_INGRESOS_INF_NIVEL,
	ADM_RESIDENCIA_CM_AUTONOMA,
	ADM_NO_TITULAR_VIVIENDA,
	ADM_FECHA_SOL_CERTIFICADO,
	ADM_FECHA_COM_ADQUISICION,
	ADM_FECHA_COM_REG_DEM,
	ADM_ACTUALIZA_PRECIO_MAX,
	ADM_FECHA_VENCIMIENTO,
	ADM_PRECIO_MAX_VENTA,
	DD_TRA_ID,
	ACT_ADM_FECHA_VENC_TIP_BON,
	ACT_ADM_FECHA_LIQ_COMPLEM,
	ADM_ESTADO_VENTA,
	ADM_FECHA_ENVIO_COM_ORG,
	ADM_FECHA_RECEPCION_RESP_ORG,
	ADM_MAX_PRECIO_MODULO_ALQUILER
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_ADM_INF_ADMINISTRATIVA.NEXTVAL      ADM_ID,
	ACT2.ACT_ID,  
    ADM.DD_TVP_ID     						DD_TVP_ID,  					                           
    ADM.ADM_SUELO_VPO     					ADM_SUELO_VPO,      
    ADM.ADM_PROMOCION_VPO     				ADM_PROMOCION_VPO,        
    ADM.ADM_NUM_EXPEDIENTE     				ADM_NUM_EXPEDIENTE,       
    ADM.ADM_FECHA_CALIFICACION     			ADM_FECHA_CALIFICACION,      
    ADM.ADM_OBLIGATORIO_SOL_DEV_AYUDA     	ADM_OBLIGATORIO_SOL_DEV_AYUDA,   
    ADM.ADM_OBLIG_AUT_ADM_VENTA     		ADM_OBLIG_AUT_ADM_VENTA,  
    ADM.ADM_DESCALIFICADO     				ADM_DESCALIFICADO,
    ADM.ADM_MAX_PRECIO_VENTA     			ADM_MAX_PRECIO_VENTA, 
    ADM.ADM_OBSERVACIONES                 	ADM_OBSERVACIONES,
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
	ADM.BORRADO                                                         BORRADO, 
    ADM.ADM_VIGENCIA     					ADM_VIGENCIA,					  	  
    ADM.ADM_COMUNICAR_ADQUISICION    		ADM_COMUNICAR_ADQUISICION,		    
    ADM.ADM_NECESARIO_INSCR_VPO     		ADM_NECESARIO_INSCR_VPO,			  
    ADM.ADM_LIBERTAD_CESION     			ADM_LIBERTAD_CESION,				    
    ADM.ADM_RENUNCIA_TANTEO_RETRAC     		ADM_RENUNCIA_TANTEO_RETRAC,		 
    ADM.ADM_VISA_CONTRATO_PRIVADO     		ADM_VISA_CONTRATO_PRIVADO,		
    ADM.ADM_VENDER_PER_JURIDICA     		ADM_VENDER_PER_JURIDICA,			  
    ADM.ADM_MINUSVALIA     					ADM_MINUSVALIA,					 
    ADM.ADM_INSCR_REGISTRO_DEMANDA     		ADM_INSCR_REGISTRO_DEMANDA,		 
    ADM.ADM_INGRESOS_INF_NIVEL     			ADM_INGRESOS_INF_NIVEL,			  
    ADM.ADM_RESIDENCIA_CM_AUTONOMA     		ADM_RESIDENCIA_CM_AUTONOMA,		  
    ADM.ADM_NO_TITULAR_VIVIENDA     		ADM_NO_TITULAR_VIVIENDA,		  
    ADM.ADM_FECHA_SOL_CERTIFICADO     		ADM_FECHA_SOL_CERTIFICADO,		  
    ADM.ADM_FECHA_COM_ADQUISICION     		ADM_FECHA_COM_ADQUISICION,		  
    ADM.ADM_FECHA_COM_REG_DEM     			ADM_FECHA_COM_REG_DEM,			   
    ADM.ADM_ACTUALIZA_PRECIO_MAX     		ADM_ACTUALIZA_PRECIO_MAX,		    
    ADM.ADM_FECHA_VENCIMIENTO     			ADM_FECHA_VENCIMIENTO,			  	  
    ADM.ADM_PRECIO_MAX_VENTA     			ADM_PRECIO_MAX_VENTA,			   	  
    ADM.DD_TRA_ID     						DD_TRA_ID,					   	  
    ADM.ACT_ADM_FECHA_VENC_TIP_BON     		ACT_ADM_FECHA_VENC_TIP_BON,		 
    ADM.ACT_ADM_FECHA_LIQ_COMPLEM     		ACT_ADM_FECHA_LIQ_COMPLEM,			  
    ADM.ADM_ESTADO_VENTA    				ADM_ESTADO_VENTA,			
    ADM.ADM_FECHA_ENVIO_COM_ORG     		ADM_FECHA_ENVIO_COM_ORG,		
	ADM.ADM_FECHA_RECEPCION_RESP_ORG     	ADM_FECHA_RECEPCION_RESP_ORG,	
	ADM.ADM_MAX_PRECIO_MODULO_ALQUILER     	ADM_MAX_PRECIO_MODULO_ALQUILER

	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ADM ON ADM.ACT_ID = ACT.ACT_ID
	
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
	
	SPS_FECHA_REVISION_ESTADO,
	SPS_FECHA_TOMA_POSESION,

	SPS_OCUPADO,
	DD_TPA_ID,

	

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
	BORRADO,
	SPS_ALARMA,
	SPS_FECHA_INSTALA_ALARMA,
	SPS_FECHA_DESINSTALA_ALARMA,
	SPS_VIGILANCIA,
	SPS_FECHA_INSTALA_VIGILANCIA,
	SPS_FECHA_DESINSTALA_VIGILANCIA
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_SPS_SIT_POSESORIA.NEXTVAL           SPS_ID,
	ACT2.ACT_ID,
	
	NULL				                              SPS_FECHA_REVISION_ESTADO,
	null                               						  SPS_FECHA_TOMA_POSESION,
	
	SPS.SPS_OCUPADO                                           SPS_OCUPADO,
	SPS.DD_TPA_ID												  DD_TPA_ID,
	
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
	SPS.BORRADO                                                         BORRADO,
	SPS.SPS_ALARMA												SPS_ALARMA,
	SPS.SPS_FECHA_INSTALA_ALARMA								SPS_FECHA_INSTALA_ALARMA,
	SPS.SPS_FECHA_DESINSTALA_ALARMA								SPS_FECHA_DESINSTALA_ALARMA,
	SPS.SPS_VIGILANCIA											SPS_VIGILANCIA,
	SPS.SPS_FECHA_INSTALA_VIGILANCIA							SPS_FECHA_INSTALA_VIGILANCIA,
	SPS.SPS_FECHA_DESINSTALA_VIGILANCIA							SPS_FECHA_DESINSTALA_VIGILANCIA
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' SPS ON SPS.ACT_ID = ACT.ACT_ID
	')
	;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  

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
	'||V_ESQUEMA||'.S_BIE_DATOS_REGISTRALES.NEXTVAL			  BIE_DREG_ID,
	ACT2.BIE_ID,
	BIE.BIE_DREG_REFERENCIA_CATASTRAL      					  BIE_DREG_REFERENCIA_CATASTRAL,
	BIE.BIE_DREG_SUPERFICIE                                   BIE_DREG_SUPERFICIE,
	BIE.BIE_DREG_SUPERFICIE_CONSTRUIDA                        BIE_DREG_SUPERFICIE_CONSTRUIDA,
	BIE.BIE_DREG_TOMO                                         BIE_DREG_TOMO,
	BIE.BIE_DREG_LIBRO                                        BIE_DREG_LIBRO,
	BIE.BIE_DREG_FOLIO                                        BIE_DREG_FOLIO,
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
	BIE.BORRADO                                                        BORRADO,
	BIE.BIE_DREG_NUM_FINCA                                    BIE_DREG_NUM_FINCA,
	BIE.DD_LOC_ID						                      DD_LOC_ID,
	BIE.DD_PRV_ID                      						  DD_PRV_ID
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_3||' BIE ON ACT.BIE_ID = BIE.BIE_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
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
	'||V_ESQUEMA||'.S_ACT_REG_INFO_REGISTRAL.NEXTVAL          REG_ID,
	ACT2.ACT_ID,
	REG.BIE_DREG_ID									          BIE_DREG_ID,
	REG.REG_IDUFIR                                            REG_IDUFIR,
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
	REG.BORRADO                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_4||' REG ON ACT.ACT_ID = REG.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
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
  '||V_ESQUEMA||'.S_BIE_LOCALIZACION.NEXTVAL 							BIE_LOC_ID,
  ACT2.BIE_ID, 
  LOC.BIE_LOC_POBLACION												    BIE_LOC_POBLACION,
  LOC.BIE_LOC_DIRECCION				        							BIE_LOC_DIRECCION,
  LOC.BIE_LOC_COD_POST													BIE_LOC_COD_POST,
  ''0''                                                                 VERSION,
  '''||V_USUARIO||'''                                                   USUARIOCREAR,
  SYSDATE                                                               FECHACREAR,
  LOC.BORRADO                                                                     BORRADO,
  LOC.DD_PRV_ID							              					DD_PRV_ID,
  LOC.BIE_LOC_NOMBRE_VIA												BIE_LOC_NOMBRE_VIA,
  LOC.BIE_LOC_NUMERO_DOMICILIO											BIE_LOC_NUMERO_DOMICILIO,
  LOC.BIE_LOC_ESCALERA													BIE_LOC_ESCALERA,
  LOC.BIE_LOC_PISO														BIE_LOC_PISO,
  LOC.BIE_LOC_PUERTA													BIE_LOC_PUERTA,
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
	  '||V_ESQUEMA||'.S_ACT_LOC_LOCALIZACION.NEXTVAL   		                LOC_ID,
	ACT2.ACT_ID,
	ACT_LOC.BIE_LOC_ID									          BIE_LOC_ID,
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
	ACT_LOC.BORRADO                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_6||' ACT_LOC ON ACT.ACT_ID = ACT_LOC.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
 
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_6||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_6||' ANALIZADA.');
  
 --------


	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_7||'. [VALORACIONES Y PRECIOS]');

	
    
    

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_7||' VAL (
	VAL_ID,
	ACT_ID,
	DD_TPC_ID,
	VAL_IMPORTE,
	VAL_FECHA_INICIO,
	VAL_FECHA_FIN,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO,
	VAL_FECHA_APROBACION,
	VAL_FECHA_CARGA,
	USU_ID,
	VAL_OBSERVACIONES,
	VAL_FECHA_VENTA,
	VAL_LIQUIDEZ
	)
	SELECT
	  '||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL   		                VAL_ID,
	ACT2.ACT_ID,

	ACT_VAL.DD_TPC_ID										DD_TPC_ID,
	ACT_VAL.VAL_IMPORTE										VAL_IMPORTE,
	ACT_VAL.VAL_FECHA_INICIO								VAL_FECHA_INICIO,
	ACT_VAL.VAL_FECHA_FIN									VAL_FECHA_FIN,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	ACT_VAL.BORRADO                                                         BORRADO,
	ACT_VAL.VAL_FECHA_APROBACION							VAL_FECHA_APROBACION,
	ACT_VAL.VAL_FECHA_CARGA									VAL_FECHA_CARGA,
	ACT_VAL.USU_ID											USU_ID,
	ACT_VAL.VAL_OBSERVACIONES								VAL_OBSERVACIONES,
	ACT_VAL.VAL_FECHA_VENTA									VAL_FECHA_VENTA,
	ACT_VAL.VAL_LIQUIDEZ									VAL_LIQUIDEZ

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_7||' ACT_VAL ON ACT.ACT_ID = ACT_VAL.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_7||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_7||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_7||' ANALIZADA.');

---------

DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_8||'. [HISTORICO VALORACIONES ]');

	

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_8||' HVAL (
	HVA_ID,
	ACT_ID,
	DD_TPC_ID,
	HVA_IMPORTE,
	HVA_FECHA_INICIO,
	HVA_FECHA_FIN,
	HVA_FECHA_APROBACION,
	HVA_FECHA_CARGA,
	USU_ID,
	HVA_OBSERVACIONES,
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
	  '||V_ESQUEMA||'.S_ACT_HVA_HIST_VALORACIONES.NEXTVAL   		                HVA_ID,
	ACT2.ACT_ID,
	ACT_HVAL.DD_TPC_ID										DD_TPC_ID,
	ACT_HVAL.HVA_IMPORTE										HVA_IMPORTE,
	ACT_HVAL.HVA_FECHA_INICIO								HVA_FECHA_INICIO,
	ACT_HVAL.HVA_FECHA_FIN									HVA_FECHA_FIN,
	ACT_HVAL.HVA_FECHA_APROBACION							HVA_FECHA_APROBACION,
	ACT_HVAL.HVA_FECHA_CARGA									HVA_FECHA_CARGA,
	ACT_HVAL.USU_ID											USU_ID,
	ACT_HVAL.HVA_OBSERVACIONES								HVA_OBSERVACIONES,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	ACT_HVAL.BORRADO                                                         BORRADO

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_8||' ACT_HVAL ON ACT.ACT_ID = ACT_HVAL.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_8||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_8||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_8||' ANALIZADA.');

---------


DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_9||'. [HISTORICO FASE VENTA ]');

	

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_9||' HRFV (
	RFV_ID,
	ADM_ID,
	RFV_FECHA_SOLICITUD_PRECIO_MAX,
	RFV_FECHA_RESPUESTA_ORGANISMO,
	RFV_PRECIO_MAX_VENTA,
	RFV_FECHA_VENCIMIENTO,
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
	  '||V_ESQUEMA||'.S_H_ACT_RFV_REQ_FASE_VENTA.NEXTVAL   		                RFV_ID,
	ACT_ADM2.ADM_ID											ADM_ID,
	ACT_HRFV.RFV_FECHA_SOLICITUD_PRECIO_MAX					RFV_FECHA_SOLICITUD_PRECIO_MAX,
	ACT_HRFV.RFV_FECHA_RESPUESTA_ORGANISMO					RFV_FECHA_RESPUESTA_ORGANISMO,
	ACT_HRFV.RFV_PRECIO_MAX_VENTA							RFV_PRECIO_MAX_VENTA,
	ACT_HRFV.RFV_FECHA_VENCIMIENTO							RFV_FECHA_VENCIMIENTO,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	ACT_HRFV.BORRADO                                                         BORRADO

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ACT_ADM ON ACT.ACT_ID = ACT_ADM.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_9||' ACT_HRFV ON ACT_ADM.ADM_ID = ACT_HRFV.ADM_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ACT_ADM2 ON ACT2.ACT_ID = ACT_ADM2.ACT_ID
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_9||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_9||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_9||' ANALIZADA.');

---------











  
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

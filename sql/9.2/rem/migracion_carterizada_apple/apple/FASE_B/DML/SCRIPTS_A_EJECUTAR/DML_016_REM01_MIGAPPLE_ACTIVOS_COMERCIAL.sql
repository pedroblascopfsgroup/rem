--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AIA_INFOCOMERCIAL_ACTIVO' -> ACT_ICO_INFO_COMERCIAL - ACT_EDI_EDIFICIO - ACT_VIV_VIVIENDA - ACT_LCO_LOCAL_COMERCIAL - ACT_APR_PLAZA_APARCAMIENTO
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

	V_TABLA VARCHAR2(40 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
	V_TABLA2 VARCHAR2(40 CHAR) := 'ACT_HIC_EST_INF_COMER_HIST';
	V_TABLA3 VARCHAR2(40 CHAR) := 'ACT_EDI_EDIFICIO';
	V_TABLA4 VARCHAR2(40 CHAR) := 'ACT_VIV_VIVIENDA';
	V_TABLA5 VARCHAR2(40 CHAR) := 'ACT_LCO_LOCAL_COMERCIAL';
	V_TABLA6 VARCHAR2(40 CHAR) := 'ACT_APR_PLAZA_APARCAMIENTO';
	V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AIA_INFCOMERCIAL_ACT';
	
	V_SENTENCIA VARCHAR2(1600 CHAR);
	V_SENTENCIA2 VARCHAR2(1600 CHAR);
	V_SENTENCIA3 VARCHAR2(1600 CHAR);
	V_SENTENCIA4 VARCHAR2(1600 CHAR);
	V_REG_MIG NUMBER(10,0) := 0;
	V_REG_INSERTADOS NUMBER(10,0) := 0;
	V_REJECTS NUMBER(10,0) := 0;
	V_COD NUMBER(10,0) := 0;
	V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS COMERCIAL');

  -------------------------------------------------
  --INSERCION EN ACT_ICO_INFO_COMERCIAL--
  -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_ICO_INFO_COMERCIAL');
  

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		ICO_ID,
		ACT_ID,
		DD_UAC_ID,
		DD_ECT_ID,
		DD_ECV_ID,
		DD_TIC_ID,
		DD_DIS_ID,
		ICO_MEDIADOR_ID,
		ICO_DESCRIPCION,
		ICO_ANO_CONSTRUCCION,
		ICO_ANO_REHABILITACION,
		ICO_APTO_PUBLICIDAD,
		ICO_ACTIVOS_VINC,
		ICO_FECHA_EMISION_INFORME,
		ICO_FECHA_ULTIMA_VISITA,
		ICO_FECHA_ACEPTACION,
		ICO_FECHA_RECHAZO,
		ICO_FECHA_RECEP_LLAVES,
		ICO_CONDICIONES_LEGALES,
		ICO_JUSTIFICACION_VENTA,
		ICO_JUSTIFICACION_RENTA,
		DD_TPA_ID,
		DD_SAC_ID,	
		ICO_FECHA_ESTIMACION_VENTA,
		ICO_FECHA_ESTIMACION_RENTA,
		ICO_INFO_DESCRIPCION,
		ICO_INFO_DISTRIBUCION_INTERIOR,
		ICO_POSIBLE_HACER_INF,
		ICO_FECHA_ENVIO_LLAVES_API,
		ICO_RECIBIO_IMPORTE_ADM,
		ICO_IBI_IMPORTE_ADM,
		ICO_DERRAMA_IMPORTE_ADM,
		ICO_DET_DERRAMA_IMPORTE_ADM,
		ICO_DERRAMACP_ORIENTATIVA,	
		ICO_VALOR_MAX_VPO,
		ICO_PRESIDENTE_NOMBRE,
		ICO_PRESIDENTE_TELF,
		ICO_ADMINISTRADOR_NOMBRE,
		ICO_ADMINISTRADOR_TELF,
		ICO_EXIS_COM_PROP, 	
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
  )
  SELECT 
		'||V_ESQUEMA||'.S_ACT_ICO_INFO_COMERCIAL.NEXTVAL                    ICO_ID,
		ACT.ACT_ID                                                          ACT_ID,
		(SELECT DD_UAC_ID
		  FROM '||V_ESQUEMA||'.DD_UAC_UBICACION_ACTIVO UAC
		  WHERE UAC.DD_UAC_CODIGO = MIG.UBICACION_ACTIVO)             		DD_UAC_ID,
		(SELECT DD_ECT_ID
		  FROM '||V_ESQUEMA||'.DD_ECT_ESTADO_CONSTRUCCION ECT
		  WHERE ECT.DD_ECT_CODIGO = MIG.ESTADO_CONSTRUCCION)     			DD_ECT_ID,     
		(SELECT DD_ECV_ID
		  FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION ECV
		  WHERE ECV.DD_ECV_CODIGO = MIG.ESTADO_CONSERVACION)      			DD_ECV_ID,     
		(SELECT DD_TIC_ID
		  FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC
		  WHERE TIC.DD_TIC_CODIGO = MIG.TIPO_INFO_COMERCIAL)          		DD_TIC_ID,
		(SELECT DIS.DD_DIS_ID
		  FROM '||V_ESQUEMA||'.DD_DIS_DISTRITO DIS
		  WHERE DIS.DD_DIS_CODIGO = NVL(MIG.DD_DIS_ID, MIG.ICO_DISTRITO))   DD_DIS_ID, 
		(SELECT PVE.PVE_ID
		  FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		  WHERE PVE.PVE_COD_PRINEX = MIG.PVE_CODIGO 
			AND PVE.PVE_FECHA_BAJA IS NULL AND ROWNUM = 1)                  ICO_MEDIADOR_ID,
		MIG.ICO_DESCRIPCION                                                 ICO_DESCRIPCION,
		MIG.ICO_ANO_CONSTRUCCION                                            ICO_ANO_CONSTRUCCION,
		MIG.ICO_ANO_REHABILITACION                                          ICO_ANO_REHABILITACION,
		MIG.ICO_APTO_PUBLICIDAD                                             ICO_APTO_PUBLICIDAD,
		MIG.ICO_ACTIVOS_VINC                                                ICO_ACTIVOS_VINC,
		MIG.ICO_FECHA_EMISION_INFORME                                       ICO_FECHA_EMISION_INFORME,
		MIG.ICO_FECHA_ULTIMA_VISITA                                         ICO_FECHA_ULTIMA_VISITA,
		MIG.ICO_FECHA_ACEPTACION                                            ICO_FECHA_ACEPTACION,
		MIG.ICO_FECHA_RECHAZO                                               ICO_FECHA_RECHAZO,
		MIG.ICO_FECHA_RECEPCION_LLAVES                          			ICO_FECHA_RECEP_LLAVES,
		MIG.ICO_CONDICIONES_LEGALES                                         ICO_CONDICIONES_LEGALES,
		MIG.ICO_JUSTIF_IMPORTE_VENTA	                          			ICO_JUSTIFICACION_VENTA,
		MIG.ICO_JUSTIF_IMPORTE_ALQUILER		                       			ICO_JUSTIFICACION_RENTA,
		ACT.DD_TPA_ID														DD_TPA_ID,
		ACT.DD_SAC_ID														DD_SAC_ID,
		MIG.ICO_FECHA_ESTIMACION_VENTA										ICO_FECHA_ESTIMACION_VENTA,
		MIG.ICO_FECHA_ESTIMACION_RENTA										ICO_FECHA_ESTIMACION_RENTA,
		MIG.ICO_INFO_DESCRIPCION											ICO_INFO_DESCRIPCION,
		MIG.ICO_INFO_DISTRIBUCION_INTERIOR									ICO_INFO_DISTRIBUCION_INTERIOR,
		MIG.ICO_POSIBLE_HACER_INF											ICO_POSIBLE_HACER_INF,
		MIG.ICO_FECHA_ENVIO_LLAVES_API										ICO_FECHA_ENVIO_LLAVES_API,
		MIG.ICO_RECIBIO_IMPORTE_ADM											ICO_RECIBIO_IMPORTE_ADM,
		MIG.ICO_IBI_IMPORTE_ADM												ICO_IBI_IMPORTE_ADM,
		MIG.ICO_DERRAMA_IMPORTE_ADM											ICO_DERRAMA_IMPORTE_ADM,
		MIG.ICO_DET_DERRAMA_IMPORTE_ADM										ICO_DET_DERRAMA_IMPORTE_ADM,
		MIG.ICO_DERRAMACP_ORIENTATIVA										ICO_DERRAMACP_ORIENTATIVA,
		MIG.ICO_VALOR_MAX_VPO												ICO_VALOR_MAX_VPO,
		MIG.ICO_PRESIDENTE_NOMBRE											ICO_PRESIDENTE_NOMBRE,
		MIG.ICO_PRESIDENTE_TELF												ICO_PRESIDENTE_TELF,
		MIG.ICO_ADMINISTRADOR_NOMBRE										ICO_ADMINISTRADOR_NOMBRE,
		MIG.ICO_ADMINISTRADOR_TELF											ICO_ADMINISTRADOR_TELF,
		MIG.ICO_EXIS_COM_PROP												ICO_EXIS_COM_PROP,
		''0''                                                               VERSION,
		'''||V_USUARIO||'''                                                 USUARIOCREAR,
		SYSDATE                                                             FECHACREAR,
		0                                                                   BORRADO
   FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 	MIG
   JOIN '||V_ESQUEMA||'.ACT_ACTIVO 			ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
   WHERE MIG.VALIDACION = 0 AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' T1 WHERE T1.ACT_ID = ACT.ACT_ID)
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');


  ---------------------------------------------------------------------------------------------
  --ACTUALIZACIÓN DE LA ICO_FECHA_EMISION_INFORME para informes aceptados y rechazados--
  ---------------------------------------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] ACTUALIZACIÓN DE ICO_FECHA_EMISION_INFORME PARA INFORMES ACEPTADOS Y RECHAZADOS');
  
  
  EXECUTE IMMEDIATE (
  'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL SET 
		 ICO_FECHA_EMISION_INFORME = ICO_FECHA_ACEPTACION 
   WHERE ICO_FECHA_EMISION_INFORME IS NULL 
     AND ICO_FECHA_ACEPTACION IS NOT NULL
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL actualizado para informes aceptados. '||SQL%ROWCOUNT||' Filas.'); 


  EXECUTE IMMEDIATE (
  'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL SET 
		 ICO_FECHA_EMISION_INFORME = ICO_FECHA_RECHAZO 
   WHERE ICO_FECHA_EMISION_INFORME IS NULL 
     AND ICO_FECHA_RECHAZO IS NOT NULL
  ');  
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL actualizado para informes rechazados. '||SQL%ROWCOUNT||' Filas.'); 
  

  -------------------------------------------------
  --INSERCION EN ACT_HIC_EST_INF_COMER_HIST--
  -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_HIC_EST_INF_COMER_HIST');


  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA2||' 
  (
       HIC_ID
      ,ACT_ID
      ,DD_AIC_ID
      ,HIC_FECHA
      ,HIC_MOTIVO
      ,VERSION
      ,USUARIOCREAR
      ,FECHACREAR
      ,BORRADO
  )
  SELECT 
      '||V_ESQUEMA||'.S_ACT_HIC_EST_INF_COMER_HIST.NEXTVAL 																	AS HIC_ID
      , ACT.ACT_ID 																											AS ACT_ID
      , CASE
          WHEN ICO.ICO_FECHA_EMISION_INFORME IS NOT NULL AND ICO_FECHA_ACEPTACION IS NULL AND ICO_FECHA_RECHAZO IS NULL
            THEN (SELECT DD_AIC_ID FROM '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL WHERE DD_AIC_CODIGO = ''03'')
          WHEN ICO_FECHA_ACEPTACION IS NOT NULL AND ICO_FECHA_RECHAZO IS NULL
            THEN (SELECT DD_AIC_ID FROM '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL WHERE DD_AIC_CODIGO = ''02'')
          WHEN ICO_FECHA_ACEPTACION IS NULL AND ICO_FECHA_RECHAZO IS NOT NULL
            THEN (SELECT DD_AIC_ID FROM '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL WHERE DD_AIC_CODIGO = ''04'')
        END                  																								AS DD_AIC_ID
      , SYSDATE              																								AS HIC_FECHA
      , NULL                 																								AS HIC_MOTIVO
      , ''0''                																								AS VERSION
      , '''||V_USUARIO||'''  																								AS USUARIOCREAR
      , SYSDATE              																								AS FECHACREAR
      , 0                    																								AS BORRADO
  FROM '||V_ESQUEMA||'.ACT_ACTIVO 					ACT
  JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL 	ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
  JOIN '||V_ESQUEMA||'.MIG_ACA_CABECERA 		ACA ON ACA.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
  WHERE ICO.ICO_FECHA_EMISION_INFORME IS NOT NULL 
    AND ACA.VALIDACION IN (1,0) 
    AND ACT.BORRADO = 0
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA2||' cargada. '||SQL%ROWCOUNT||' Filas.'); 
 
 
  -------------------------------------------------
  --INSERCION EN ACT_EDI_EDIFICIO--
  -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_EDI_EDIFICIO');
 

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA3||' (
	  EDI_ID,
	  ICO_ID,
	  DD_ECV_ID,
	  DD_TPF_ID,
	  EDI_ANO_REHABILITACION,
	  EDI_NUM_PLANTAS,
	  EDI_ASCENSOR,
	  EDI_NUM_ASCENSORES,
	  EDI_REFORMA_FACHADA,
	  EDI_REFORMA_ESCALERA,
	  EDI_REFORMA_PORTAL,
	  EDI_REFORMA_ASCENSOR,
	  EDI_REFORMA_CUBIERTA,
	  EDI_REFORMA_OTRA_ZONA,
	  EDI_REFORMA_OTRO,
	  EDI_REFORMA_OTRO_DESC,
	  EDI_DESCRIPCION,
	  EDI_ENTORNO_INFRAESTRUCTURA,
	  EDI_ENTORNO_COMUNICACION,
	  VERSION,
	  USUARIOCREAR,
	  FECHACREAR,
	  BORRADO,
	  EDI_DIVISIBLE,
	  EDI_DESC_PLANTAS,
	  EDI_OTRAS_CARACTERISTICAS
  )
  SELECT
	    '||V_ESQUEMA||'.S_ACT_EDI_EDIFICIO.NEXTVAL                                                                EDI_ID,
		ICO.ICO_ID                                                                                                ICO_ID,
		(SELECT ECV.DD_ECV_ID
		FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION ECV
		WHERE ECV.DD_ECV_CODIGO = MIG.ESTADO_CONSERVACION_EDIFICIO)            									  DD_ECV_ID,  
		(SELECT TPF.DD_TPF_ID
		FROM '||V_ESQUEMA||'.DD_TPF_TIPO_FACHADA TPF
		WHERE TPF.DD_TPF_CODIGO = MIG.TIPO_FACHADA_EDIFICIO)                            						  DD_TPF_ID,    
		NVL(MIG.ICO_ANO_REHAB_EDIFICIO, MIG.EDI_ANO_REHABILITACION)	                                              EDI_ANO_REHABILITACION,
		MIG.EDI_NUM_PLANTAS                                                                                       EDI_NUM_PLANTAS,
		MIG.EDI_ASCENSOR                                                                                          EDI_ASCENSOR,
		MIG.EDI_NUM_ASCENSORES                                                                              	  EDI_NUM_ASCENSORES,
		MIG.EDI_REFORMA_FACHADA                                                                           		  EDI_REFORMA_FACHADA,
		MIG.EDI_REFORMA_ESCALERA                                                                            	  EDI_REFORMA_ESCALERA,
		MIG.EDI_REFORMA_PORTAL                                                                              	  EDI_REFORMA_PORTAL,
		MIG.EDI_REFORMA_ASCENSOR                                                                          		  EDI_REFORMA_ASCENSOR,
		MIG.EDI_REFORMA_CUBIERTA                                                                          		  EDI_REFORMA_CUBIERTA,
		MIG.EDI_REFORMA_OTRA_ZONA                                                                     			  EDI_REFORMA_OTRA_ZONA,
		MIG.EDI_REFORMA_OTRO                                                                                	  EDI_REFORMA_OTRO,
		MIG.EDI_REFORMA_OTRO_DESC                                                                     			  EDI_REFORMA_OTRO_DESC,
		MIG.EDI_DESCRIPCION                                                                                   	  EDI_DESCRIPCION,
		MIG.EDI_ENTORNO_INFRAESTRUCTURA                                                          				  EDI_ENTORNO_INFRAESTRUCTURA,
		MIG.EDI_ENTORNO_COMUNICACION                                                            				  EDI_ENTORNO_COMUNICACION,
		''0''                                                                                                     VERSION,
		'''||V_USUARIO||'''                                                                                       USUARIOCREAR,
		SYSDATE                                                                                                   FECHACREAR,
		0                                                                                                         BORRADO,
		MIG.EDI_DIVISIBLE																						  EDI_DIVISIBLE,
		MIG.EDI_DESC_PLANTAS																					  EDI_DESC_PLANTAS,
		MIG.EDI_OTRAS_CARACTERISTICAS																			  EDI_OTRAS_CARACTERISTICAS		
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'  MIG
  JOIN '||V_ESQUEMA||'.ACT_ACTIVO 		  ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  JOIN '||V_ESQUEMA||'.'||V_TABLA||' 	  ICO ON ICO.ACT_ID = ACT.ACT_ID
  WHERE MIG.VALIDACION IN (0,1) 
    AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA3||' T1 WHERE T1.ICO_ID = ICO.ICO_ID AND T1.BORRADO = ICO.BORRADO)
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  -------------------------------------------------
  --INSERCION EN ACT_VIV_VIVIENDA--
  -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_VIV_VIVIENDA');
  

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA4||' (
		ICO_ID,
		DD_TPV_ID,
		DD_TPO_ID,
		DD_TPR_ID,
		VIV_ULTIMA_PLANTA,
		VIV_NUM_PLANTAS_INTERIOR,
		VIV_REFORMA_CARP_INT,
		VIV_REFORMA_CARP_EXT,
		VIV_REFORMA_COCINA,
		VIV_REFORMA_BANYO,
		VIV_REFORMA_SUELO,
		VIV_REFORMA_PINTURA,
		VIV_REFORMA_INTEGRAL,
		VIV_REFORMA_OTRO,
		VIV_REFORMA_OTRO_DESC,
		VIV_REFORMA_PRESUPUESTO,
		VIV_DISTRIBUCION_TXT
  )
  SELECT
		ICO.ICO_ID 																						ICO_ID,
		TPV.DD_TPV_ID                                                                                 	DD_TPV_ID,     
		TPO.DD_TPO_ID                                                                               	DD_TPO_ID, 
		TPR.DD_TPR_ID                                                                             		DD_TPR_ID, 
		MIG.VIV_ULTIMA_PLANTA                                                                        	VIV_ULTIMA_PLANTA,
		MIG.VIV_NUM_PLANTAS_INTERIOR                                                          			VIV_NUM_PLANTAS_INTERIOR,
		MIG.VIV_REFORMA_CARP_INT                                                                  		VIV_REFORMA_CARP_INT,
		MIG.VIV_REFORMA_CARP_EXT                                                                		VIV_REFORMA_CARP_EXT,
		MIG.VIV_REFORMA_COCINA                                                                    		VIV_REFORMA_COCINA,
		MIG.VIV_REFORMA_BANYO                                                                      		VIV_REFORMA_BANYO,
		MIG.VIV_REFORMA_SUELO                                                                     		VIV_REFORMA_SUELO,
		MIG.VIV_REFORMA_PINTURA                                                                 		VIV_REFORMA_PINTURA,
		MIG.VIV_REFORMA_INTEGRAL                                                                		VIV_REFORMA_INTEGRAL,
		MIG.VIV_REFORMA_OTRO                                                                      		VIV_REFORMA_OTRO,
		MIG.VIV_REFORMA_OTRO_DESC                                                              			VIV_REFORMA_OTRO_DESC,
		MIG.VIV_REFORMA_PRESUPUESTO                                                           			VIV_REFORMA_PRESUPUESTO,
		MIG.VIV_DISTRIBUCION_TXT                                                                    	VIV_DISTRIBUCION_TXT
   FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 				MIG
   JOIN '||V_ESQUEMA||'.ACT_ACTIVO 						ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
   JOIN '||V_ESQUEMA||'.'||V_TABLA||' 					ICO ON ICO.ACT_ID = ACT.ACT_ID
   JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO 			SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.DD_SAC_CODIGO IN (''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''20'')
   LEFT JOIN '||V_ESQUEMA||'.DD_TPV_TIPO_VIVIENDA 		TPV ON TPV.DD_TPV_CODIGO = MIG.TIPO_VIVIENDA
   LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_ORIENTACION 	TPO ON TPO.DD_TPO_CODIGO = MIG.TIPO_ORIENTACION
   LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_RENTA 		TPR ON TPR.DD_TPR_CODIGO = MIG.TIPO_RENTA
   WHERE MIG.VALIDACION IN (0,1)
     AND NOT EXISTS (
					   SELECT 1
					   FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL INFO
					   JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA 	   VIV ON VIV.ICO_ID = INFO.ICO_ID
					   WHERE VIV.ICO_ID = ICO.ICO_ID
					)
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
    
  --------------------------------------------------------------------------
  --ACTUALIZAMOS EL DD_TIC_ID DE LA ICO EN LOS ACTIVOS QUE SON VIVIENDA--
  --------------------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] ACTIALIZACIÓN DEL DD_TIC_ID EN ACTIVOS QUE SON VIVIENDA');
  
    
  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO SET 
	DD_TIC_ID = (SELECT DD_TIC_ID FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL WHERE DD_TIC_CODIGO = ''01'')
  WHERE EXISTS  
  (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA4||' VIV 
    WHERE ICO.ICO_ID = VIV.ICO_ID
  )');
    
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizado el DD_TIC_ID para los activos que son vivienda. '||SQL%ROWCOUNT||' Filas.');


  -------------------------------------------------
  --INSERCION EN ACT_LCO_LOCAL_COMERCIAL--
  -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_LCO_LOCAL_COMERCIAL');


  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA5||' (
	  ICO_ID,
	  LCO_MTS_FACHADA_PPAL,
	  LCO_MTS_FACHADA_LAT,
	  LCO_MTS_LUZ_LIBRE,
	  LCO_MTS_ALTURA_LIBRE,
	  LCO_MTS_LINEALES_PROF,
	  LCO_DIAFANO,
	  LCO_USO_IDONEO,
	  LCO_USO_ANTERIOR,
	  LCO_OBSERVACIONES,
	  LCO_NUMERO_ESTANCIAS,
	  LCO_NUMERO_BANYOS,
	  LCO_NUMERO_ASEOS,
	  LCO_SALIDA_HUMOS,
	  LCO_SALIDA_EMERGENCIA,
	  LCO_ACCESO_MINUSVALIDOS,
	  LCO_OTROS_OTRAS_CARACT
  )
  SELECT
		ICO.ICO_ID                                                          ICO_ID,
		MIG.LCO_MTS_FACHADA_PPAL                                            LCO_MTS_FACHADA_PPAL,
		MIG.LCO_MTS_FACHADA_LAT                                             LCO_MTS_FACHADA_LAT,
		MIG.LCO_MTS_LUZ_LIBRE                                               LCO_MTS_LUZ_LIBRE,
		MIG.LCO_MTS_ALTURA_LIBRE                                            LCO_MTS_ALTURA_LIBRE, 
		MIG.LCO_MTS_LINEALES_PROF                                           LCO_MTS_LINEALES_PROF,
		MIG.LCO_DIAFANO                                                     LCO_DIAFANO,
		MIG.LCO_USO_IDONEO                                                  LCO_USO_IDONEO,
		MIG.LCO_USO_ANTERIOR                                                LCO_USO_ANTERIOR,
		SUBSTR(MIG.VIV_DISTRIBUCION_TXT,1,512)                              LCO_OBSERVACIONES,		
		MIG.LCO_NUMERO_ESTANCIAS											LCO_NUMERO_ESTANCIAS,
		MIG.LCO_NUMERO_BANYOS												LCO_NUMERO_BANYOS,
		MIG.LCO_NUMERO_ASEOS												LCO_NUMERO_ASEOS,
		MIG.LCO_SALIDA_HUMOS												LCO_SALIDA_HUMOS,
		MIG.LCO_SALIDA_EMERGENCIA											LCO_SALIDA_EMERGENCIA,
		MIG.LCO_ACCESO_MINUSVALIDOS											LCO_ACCESO_MINUSVALIDOS,
		MIG.LCO_OTROS_OTRAS_CARACT											LCO_OTROS_OTRAS_CARACT	
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 				MIG
  JOIN '||V_ESQUEMA||'.ACT_ACTIVO 						ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  JOIN '||V_ESQUEMA||'.'||V_TABLA||' 					ICO ON ICO.ACT_ID = ACT.ACT_ID
  JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO 			SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.DD_SAC_CODIGO IN (''13'',''14'',''15'',''16'')
  WHERE MIG.VALIDACION IN (0,1)
    AND NOT EXISTS (
					  SELECT 1
					  FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL   INFO
					  JOIN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL  LCO ON LCO.ICO_ID = INFO.ICO_ID
					  WHERE LCO.ICO_ID = ICO.ICO_ID
				   ) 
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA5||' cargada. '||SQL%ROWCOUNT||' Filas.');


  -------------------------------------------------------------------------------
  --ACTUALIZAMOS EL DD_TIC_ID DE LA ICO EN LOS ACTIVOS QUE SON LOCAL COMERCIAL--
  -------------------------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] ACTIALIZACIÓN DEL DD_TIC_ID EN ACTIVOS QUE SON LOCAL COMERCIAL');


  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO SET 
	DD_TIC_ID = (SELECT DD_TIC_ID FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL WHERE DD_TIC_CODIGO = ''02'')
  WHERE EXISTS  
  (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA5||' LOC 
    WHERE ICO.ICO_ID = LOC.ICO_ID
  )');
    
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizado el DD_TIC_ID para los activos que son local comercial. '||SQL%ROWCOUNT||' Filas.');


  -------------------------------------------------
  --INSERCION EN ACT_APR_PLAZA_APARCAMIENTO--
  -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_APR_PLAZA_APARCAMIENTO');


  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA6||' (
	  ICO_ID,
	  APR_DESTINO_COCHE,
	  APR_DESTINO_MOTO,
	  APR_DESTINO_DOBLE,
	  DD_TUA_ID,
	  DD_TCA_ID,
	  APR_ANCHURA,
	  APR_PROFUNDIDAD,
	  APR_FORMA_IRREGULAR,
	  DD_TPV_ID,
	  APR_ALTURA,
	  DD_SPG_ID,
	  APR_LICENCIA,
	  APR_SERVIDUMBRE,
	  APR_ASCENSOR_MONTACARGA,
	  APR_COLUMNAS,
	  APR_SEGURIDAD
  )
  SELECT
		ICO.ICO_ID																		ICO_ID,
		MIG.APR_DESTINO_COCHE                                                           APR_DESTINO_COCHE,
		MIG.APR_DESTINO_MOTO                                                            APR_DESTINO_MOTO,
		MIG.APR_DESTINO_DOBLE                                                           APR_DESTINO_DOBLE,
		(SELECT DD_TUA_ID
		FROM '||V_ESQUEMA||'.DD_TUA_TIPO_UBICA_APARCA TUA
		WHERE TUA.DD_TUA_CODIGO = MIG.DD_TUA_ID)  										DD_TUA_ID, 
		(SELECT DD_TCA_ID
		FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CALIDAD TCA
		WHERE TCA.DD_TCA_CODIGO = MIG.DD_TCA_ID)                  						DD_TCA_ID, 
		MIG.APR_ANCHURA                                                                 APR_ANCHURA,
		MIG.APR_PROFUNDIDAD                                                             APR_PROFUNDIDAD,
		MIG.APR_FORMA_IRREGULAR                                                     	APR_FORMA_IRREGULAR,
		(SELECT DD_TPV_ID
		FROM '||V_ESQUEMA||'.DD_TPV_TIPO_VIVIENDA TPV
		WHERE TPV.DD_TPV_CODIGO = MIG.DD_TPV_ID)										DD_TPV_ID,
		MIG.APR_ALTURA																	APR_ALTURA,
		(SELECT DD_SPG_ID
		FROM '||V_ESQUEMA||'.DD_SPG_SUBTIPO_PLAZA_GARAJE SPG
		WHERE SPG.DD_SPG_CODIGO = MIG.DD_SPG_ID)										DD_SPG_ID,
		MIG.APR_LICENCIA																APR_LICENCIA,
		MIG.APR_SERVIDUMBRE																APR_SERVIDUMBRE,
		MIG.APR_ASCENSOR_MONTACARGA														APR_ASCENSOR_MONTACARGA,
		MIG.APR_COLUMNAS																APR_COLUMNAS,
		MIG.APR_SEGURIDAD																APR_SEGURIDAD 	
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 				MIG
  JOIN '||V_ESQUEMA||'.ACT_ACTIVO 						ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  JOIN '||V_ESQUEMA||'.'||V_TABLA||' 					ICO ON ICO.ACT_ID = ACT.ACT_ID
  JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO 			SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.DD_SAC_CODIGO IN (''19'',''24'',''26'')
  WHERE MIG.VALIDACION IN (0,1)
    AND NOT EXISTS (
					  SELECT 1
					  FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL      INFO
					  JOIN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO  APR ON APR.ICO_ID = INFO.ICO_ID
					  WHERE APR.ICO_ID = ICO.ICO_ID
				   ) 
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA6||' cargada. '||SQL%ROWCOUNT||' Filas.');


  ------------------------------------------------------------------------------------
  --ACTUALIZAMOS EL DD_TIC_ID DE LA ICO EN LOS ACTIVOS QUE SON PLAZA DE APARCAMIENTO--
  ------------------------------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('	[INFO] ACTIALIZACIÓN DEL DD_TIC_ID EN ACTIVOS QUE SON PLAZA DE APARCAMIENTO');


  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO SET 
	DD_TIC_ID = (SELECT DD_TIC_ID FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL WHERE DD_TIC_CODIGO = ''03'')
  WHERE EXISTS  
  (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA6||' APR 
    WHERE ICO.ICO_ID = APR.ICO_ID
  )');
    
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizado el DD_TIC_ID para los activos que son plaza de aparcamiento. '||SQL%ROWCOUNT||' Filas.');


  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA ||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA2||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA3||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA4||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA5||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA6||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS COMERCIAL');


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
  

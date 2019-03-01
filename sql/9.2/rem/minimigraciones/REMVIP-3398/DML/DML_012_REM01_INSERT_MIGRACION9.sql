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
TABLE_COUNT NUMBER(10,0) := 0;
TABLE_COUNT2 NUMBER(10,0) := 0;
TABLE_COUNT3 NUMBER(10,0) := 0;
TABLE_COUNT4 NUMBER(10,0) := 0;

V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

V_TABLA VARCHAR2(40 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
V_TABLA3 VARCHAR2(40 CHAR) := 'ACT_EDI_EDIFICIO';
V_TABLA4 VARCHAR2(40 CHAR) := 'ACT_VIV_VIVIENDA';
V_TABLA5 VARCHAR2(40 CHAR) := 'ACT_LCO_LOCAL_COMERCIAL';
V_TABLA6 VARCHAR2(40 CHAR) := 'ACT_APR_PLAZA_APARCAMIENTO';

V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_SEGREG_SAREB';

BEGIN
  
  

--Llenamos la primera tabla ACT_ICO_INFO_COMERCIAL
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN ACT_ICO_INFO_COMERCIAL...');

  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_ICO_INFO_COMERCIAL');
        
    ELSE

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
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  SELECT 
    '||V_ESQUEMA||'.S_ACT_ICO_INFO_COMERCIAL.NEXTVAL                    ICO_ID,
    ACT2.ACT_ID                                                         ACT_ID,
    ICO.DD_UAC_ID										                DD_UAC_ID,
    ICO.DD_ECT_ID												        DD_ECT_ID,     
    ICO.DD_ECV_ID												        DD_ECV_ID,     
    ICO.DD_TIC_ID											            DD_TIC_ID,
    ICO.DD_DIS_ID										                DD_DIS_ID, 
    ICO.ICO_MEDIADOR_ID                      						    ICO_MEDIADOR_ID,
    ICO.ICO_DESCRIPCION                                                 ICO_DESCRIPCION,
    ICO.ICO_ANO_CONSTRUCCION                                            ICO_ANO_CONSTRUCCION,
    ICO.ICO_ANO_REHABILITACION                                          ICO_ANO_REHABILITACION,
    ICO.ICO_APTO_PUBLICIDAD                                             ICO_APTO_PUBLICIDAD,
    ICO.ICO_ACTIVOS_VINC                                                ICO_ACTIVOS_VINC,
    ICO.ICO_FECHA_EMISION_INFORME                                       ICO_FECHA_EMISION_INFORME,
    ICO.ICO_FECHA_ULTIMA_VISITA                                         ICO_FECHA_ULTIMA_VISITA,
    ICO.ICO_FECHA_ACEPTACION                                            ICO_FECHA_ACEPTACION,
    ICO.ICO_FECHA_RECHAZO                                               ICO_FECHA_RECHAZO,
    ICO.ICO_FECHA_RECEP_LLAVES                          				ICO_FECHA_RECEP_LLAVES,
    ICO.ICO_CONDICIONES_LEGALES                                         ICO_CONDICIONES_LEGALES,
    ICO.ICO_JUSTIFICACION_VENTA                          				ICO_JUSTIFICACION_VENTA,
    ICO.ICO_JUSTIFICACION_RENTA                       					ICO_JUSTIFICACION_RENTA,
    ICO.DD_TPA_ID,
    ICO.DD_SAC_ID,
    ''0''                                                               VERSION,
    '''||V_USUARIO||'''                                                 USUARIOCREAR,
    SYSDATE                                                             FECHACREAR,
    0                                                                   BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO ON ICO.ACT_ID = ACT.ACT_ID
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
	
  END IF;
  --


  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN ACT_HIC_EST_INF_COMER_HIST...');

  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_HIC_EST_INF_COMER_HIST');
        
    ELSE

  EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST 
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
      '||V_ESQUEMA||'.S_ACT_HIC_EST_INF_COMER_HIST.NEXTVAL
      , ACT2.ACT_ID
      , HIC.DD_AIC_ID        AS DD_AIC_ID
      , SYSDATE              AS HIC_FECHA
      , NULL                 AS HIC_MOTIVO
      , ''0''                AS VERSION
      , '''||V_USUARIO||'''  AS USUARIOCREAR
      , SYSDATE              AS FECHACREAR
      , 0                    AS BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC ON HIC.ACT_ID = ACT.ACT_ID
  '
  )
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST cargada. '||SQL%ROWCOUNT||' Filas.'); 
 
 END IF;
--Llenamos la tercera tabla ACT_EDI_EDIFICIO
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN ACT_EDI_EDIFICIO...');

  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA3||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_EDI_EDIFICIO');
        
    ELSE

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
	BORRADO
  )
  SELECT
  '||V_ESQUEMA||'.S_ACT_EDI_EDIFICIO.NEXTVAL                                           EDI_ID,
    ICO.ICO_ID                                                                         ICO_ID,
    EDI.DD_ECV_ID            														   DD_ECV_ID,                                                
    EDI.DD_TPF_ID                           										   DD_TPF_ID,                                 
    EDI.EDI_ANO_REHABILITACION                                               	       EDI_ANO_REHABILITACION,
    EDI.EDI_NUM_PLANTAS                                                                EDI_NUM_PLANTAS,
    EDI.EDI_ASCENSOR                                                                   EDI_ASCENSOR,
    EDI.EDI_NUM_ASCENSORES                                                             EDI_NUM_ASCENSORES,
    EDI.EDI_REFORMA_FACHADA                                                            EDI_REFORMA_FACHADA,
    EDI.EDI_REFORMA_ESCALERA                                                           EDI_REFORMA_ESCALERA,
    EDI.EDI_REFORMA_PORTAL                                                             EDI_REFORMA_PORTAL,
    EDI.EDI_REFORMA_ASCENSOR                                                           EDI_REFORMA_ASCENSOR,
    EDI.EDI_REFORMA_CUBIERTA                                                           EDI_REFORMA_CUBIERTA,
    EDI.EDI_REFORMA_OTRA_ZONA                                                          EDI_REFORMA_OTRA_ZONA,
    EDI.EDI_REFORMA_OTRO                                                               EDI_REFORMA_OTRO,
    EDI.EDI_REFORMA_OTRO_DESC                                                          EDI_REFORMA_OTRO_DESC,
    EDI.EDI_DESCRIPCION                                                                EDI_DESCRIPCION,
    EDI.EDI_ENTORNO_INFRAESTRUCTURA                                                    EDI_ENTORNO_INFRAESTRUCTURA,
    EDI.EDI_ENTORNO_COMUNICACION                                                       EDI_ENTORNO_COMUNICACION,
    ''0''                                                                              VERSION,
    '''||V_USUARIO||'''                                                                USUARIOCREAR,
    SYSDATE                                                                            FECHACREAR,
    0                                                                                  BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA3||' EDI ON EDI.ICO_ID = ICO2.ICO_ID
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
--Llenamos la cuarta tabla ACT_VIV_VIVIENDA

---Validamos que el Subtipo Activo es de Vivienda

  
  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO VIVIENDAS EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA4||'.');


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
    ICO.ICO_ID                                                          ICO_ID,  
    VIV.DD_TPV_ID                    									DD_TPV_ID,     
    VIV.DD_TPO_ID                    									DD_TPO_ID, 
    VIV.DD_TPR_ID                    									DD_TPR_ID, 
    VIV.VIV_ULTIMA_PLANTA            									VIV_ULTIMA_PLANTA,
    VIV.VIV_NUM_PLANTAS_INTERIOR                                        VIV_NUM_PLANTAS_INTERIOR,
    VIV.VIV_REFORMA_CARP_INT                                            VIV_REFORMA_CARP_INT,
    VIV.VIV_REFORMA_CARP_EXT                                            VIV_REFORMA_CARP_EXT,
    VIV.VIV_REFORMA_COCINA                                              VIV_REFORMA_COCINA,
    VIV.VIV_REFORMA_BANYO                                               VIV_REFORMA_BANYO,
    VIV.VIV_REFORMA_SUELO                                               VIV_REFORMA_SUELO,
    VIV.VIV_REFORMA_PINTURA                                             VIV_REFORMA_PINTURA,
    VIV.VIV_REFORMA_INTEGRAL                                            VIV_REFORMA_INTEGRAL,
    VIV.VIV_REFORMA_OTRO                                                VIV_REFORMA_OTRO,
    VIV.VIV_REFORMA_OTRO_DESC                                           VIV_REFORMA_OTRO_DESC,
    VIV.VIV_REFORMA_PRESUPUESTO                                         VIV_REFORMA_PRESUPUESTO,
    VIV.VIV_DISTRIBUCION_TXT                                            VIV_DISTRIBUCION_TXT
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA4||' VIV ON VIV.ICO_ID = ICO2.ICO_ID  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  

  --Llenamos la quinta tabla ACT_LCO_LOCAL_COMERCIAL
  
  
  ---Validamos que el Subtipo Activo es de Local Comercial

  
  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO LOCALES COMERCIALES EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA5||'.');



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
  LCO_OBSERVACIONES
  )
  SELECT
	ICO.ICO_ID															ICO_ID,
    VIV.LCO_MTS_FACHADA_PPAL                                            LCO_MTS_FACHADA_PPAL,
    VIV.LCO_MTS_FACHADA_LAT                                             LCO_MTS_FACHADA_LAT,
    VIV.LCO_MTS_LUZ_LIBRE                                               LCO_MTS_LUZ_LIBRE,
    VIV.LCO_MTS_ALTURA_LIBRE                                            LCO_MTS_ALTURA_LIBRE, 
    VIV.LCO_MTS_LINEALES_PROF                                           LCO_MTS_LINEALES_PROF,
    VIV.LCO_DIAFANO                                                     LCO_DIAFANO,
    VIV.LCO_USO_IDONEO                                                  LCO_USO_IDONEO,
    VIV.LCO_USO_ANTERIOR                                                LCO_USO_ANTERIOR,
	VIV.LCO_OBSERVACIONES												LCO_OBSERVACIONES
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA5||' VIV ON VIV.ICO_ID = ICO2.ICO_ID  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA5||' cargada. '||SQL%ROWCOUNT||' Filas.');


--Llenamos la sexta tabla ACT_APR_PLAZA_APARCAMIENTO


  
  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO PLAZAS DE APARCAMIENTO EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA6||'.');


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
  APR_FORMA_IRREGULAR
  )
  SELECT
	ICO.ICO_ID															ICO_ID,
    APR.APR_DESTINO_COCHE                                               APR_DESTINO_COCHE,
    APR.APR_DESTINO_MOTO                                                APR_DESTINO_MOTO,
    APR.APR_DESTINO_DOBLE                                               APR_DESTINO_DOBLE,
    APR.DD_TUA_ID													    DD_TUA_ID, 
    APR.DD_TCA_ID                  										DD_TCA_ID, 
    APR.APR_ANCHURA                                                     APR_ANCHURA,
    APR.APR_PROFUNDIDAD                                                 APR_PROFUNDIDAD,
    APR.APR_FORMA_IRREGULAR                                             APR_FORMA_IRREGULAR
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA6||' APR ON APR.ICO_ID = ICO2.ICO_ID  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  


  END IF;

  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA3||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_HIC_EST_INF_COMER_HIST'',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA6||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA5||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA4||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

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
  

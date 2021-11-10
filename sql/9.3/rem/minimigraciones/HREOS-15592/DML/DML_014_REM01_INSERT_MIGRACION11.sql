--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-15592
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16329';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(2000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;

	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';

	V_TABLA VARCHAR2(40 CHAR) := 'ACT_CRI_CARPINTERIA_INT';
	V_TABLA1 VARCHAR2(40 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
	V_TABLA2 VARCHAR2(40 CHAR) := 'ACT_CRE_CARPINTERIA_EXT';
	V_TABLA3 VARCHAR2(40 CHAR) := 'ACT_PRV_PARAMENTO_VERTICAL';
	V_TABLA4 VARCHAR2(40 CHAR) := 'ACT_SOL_SOLADO';
	V_TABLA5 VARCHAR2(40 CHAR) := 'ACT_INF_INFRAESTRUCTURA';
	V_TABLA6 VARCHAR2(40 CHAR) := 'ACT_ZCO_ZONA_COMUN';
	V_TABLA7 VARCHAR2(40 CHAR) := 'ACT_INS_INSTALACION';
	V_TABLA8 VARCHAR2(40 CHAR) := 'ACT_BNY_BANYO';
	V_TABLA9 VARCHAR2(40 CHAR) := 'ACT_COC_COCINA';
  V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';


BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION DESDE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

--Llenamos la primera tabla ACT_CRI_CARPINTERIA_INT
		
  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE
	
	
  V_SQL := '
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        CRI_ID,
        ICO_ID,
        DD_ACR_ID,
        CRI_PTA_ENT_NORMAL,
        CRI_PTA_ENT_BLINDADA,
        CRI_PTA_ENT_ACORAZADA,
        CRI_PTA_PASO_MACIZAS,
        CRI_PTA_PASO_HUECAS,
        CRI_PTA_PASO_LACADAS,
        CRI_ARMARIOS_EMPOTRADOS,
        CRI_CRP_INT_OTROS,
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
  '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                       CRI_ID,
	ICO.ICO_ID ICO_ID,
	CRI.DD_ACR_ID 													 DD_ACR_ID,  
	CRI.CRI_PTA_ENT_NORMAL,
	CRI.CRI_PTA_ENT_BLINDADA,
	CRI.CRI_PTA_ENT_ACORAZADA,
	CRI.CRI_PTA_PASO_MACIZAS,
	CRI.CRI_PTA_PASO_HUECAS,
	CRI.CRI_PTA_PASO_LACADAS,
	CRI.CRI_ARMARIOS_EMPOTRADOS,
	CRI.CRI_CRP_INT_OTROS,    
	0                                                 VERSION,
	'''||V_USUARIO||'''                                   USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' CRI ON CRI.ICO_ID = ICO2.ICO_ID	
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||'  AUX WHERE AUX.ICO_ID = ICO.ICO_ID )    
  '
  ;

  EXECUTE IMMEDIATE V_SQL;
   
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  		

--Llenamos la segunda tabla ACT_CRE_CARPINTERIA_EXT

  V_SQL:= '
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA2||' (
  CRE_ID,
  ICO_ID,
  CRE_VTNAS_HIERRO,
  CRE_VTNAS_ALU_ANODIZADO,
  CRE_VTNAS_ALU_LACADO,
  CRE_VTNAS_PVC,
  CRE_VTNAS_MADERA,
  CRE_PERS_PLASTICO,
  CRE_PERS_ALU,
  CRE_VTNAS_CORREDERAS,
  CRE_VTNAS_ABATIBLES,
  CRE_VTNAS_OSCILOBAT,
  CRE_DOBLE_CRISTAL,
  CRE_EST_DOBLE_CRISTAL,
  CRE_CRP_EXT_OTROS,
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
		'||V_ESQUEMA||'.S_'||V_TABLA2||'.NEXTVAL                       CRE_ID, 
		ICO.ICO_ID,
		CRE.CRE_VTNAS_HIERRO,
		CRE.CRE_VTNAS_ALU_ANODIZADO,
		CRE.CRE_VTNAS_ALU_LACADO,
		CRE.CRE_VTNAS_PVC,
		CRE.CRE_VTNAS_MADERA,
		CRE.CRE_PERS_PLASTICO,
		CRE.CRE_PERS_ALU,
		CRE.CRE_VTNAS_CORREDERAS,
		CRE.CRE_VTNAS_ABATIBLES,
		CRE.CRE_VTNAS_OSCILOBAT,
		CRE.CRE_DOBLE_CRISTAL,
		CRE.CRE_EST_DOBLE_CRISTAL,
		CRE.CRE_CRP_EXT_OTROS,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                   USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA2||' CRE ON CRE.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA2||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )    
  '  ;

  EXECUTE IMMEDIATE V_SQL;	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
 
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA2||''',''1''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;



--Llenamos la tercera tabla ACT_PRV_PARAMENTO_VERTICAL

  V_SQL := '
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA3||' (
  PRV_ID,
  ICO_ID,
  PRV_HUMEDAD_PARED,
  PRV_HUMEDAD_TECHO,
  PRV_GRIETA_PARED,
  PRV_GRIETA_TECHO,
  PRV_GOTELE,
  PRV_PLASTICA_LISA,
  PRV_PAPEL_PINTADO,
  PRV_PINTURA_LISA_TECHO,
  PRV_PINTURA_LISA_TECHO_EST,
  PRV_MOLDURA_ESCAYOLA,
  PRV_MOLDURA_ESCAYOLA_EST,
  PRV_PARAMENTOS_OTROS,
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
		'||V_ESQUEMA||'.S_'||V_TABLA3||'.NEXTVAL                       PRV_ID,
		ICO.ICO_ID,
		PRV.PRV_HUMEDAD_PARED,
		PRV.PRV_HUMEDAD_TECHO,
		PRV.PRV_GRIETA_PARED,
		PRV.PRV_GRIETA_TECHO,
		PRV.PRV_GOTELE,
		PRV.PRV_PLASTICA_LISA,
		PRV.PRV_PAPEL_PINTADO,
		PRV.PRV_PINTURA_LISA_TECHO,
		PRV.PRV_PINTURA_LISA_TECHO_EST,
		PRV.PRV_MOLDURA_ESCAYOLA,
		PRV.PRV_MOLDURA_ESCAYOLA_EST,
		PRV.PRV_PARAMENTOS_OTROS,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                               USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA3||' PRV ON PRV.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA3||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )    
  ';
  
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
 
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA3||''',''1''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  

  
  --Llenamos la cuarta tabla ACT_SOL_SOLADO

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA4||' (
  SOL_ID,
  ICO_ID,
  SOL_TARIMA_FLOTANTE,
  SOL_PARQUE,
  SOL_MARMOL,
  SOL_PLAQUETA,
  SOL_SOLADO_OTROS,
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
  '||V_ESQUEMA||'.S_'||V_TABLA4||'.NEXTVAL                       PRV_ID,
	ICO.ICO_ID, 
	SOL.SOL_TARIMA_FLOTANTE,
	SOL.SOL_PARQUE,
	SOL.SOL_MARMOL,
	SOL.SOL_PLAQUETA,
	SOL.SOL_SOLADO_OTROS,
	''0''                                                 VERSION,
	'''||V_USUARIO||'''                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA4||' SOL ON SOL.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA4||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )   
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  
  COMMIT;
  
   EXECUTE IMMEDIATE  'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA4||''',''1''); END;';



--Llenamos la quinta tabla ACT_INF_INFRAESTRUCTURA

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA5||' (
  INF_ID,
  ICO_ID,
  INF_OCIO,
  INF_HOTELES,
  INF_HOTELES_DESC,
  INF_TEATROS,
  INF_TEATROS_DESC,
  INF_SALAS_CINE,
  INF_SALAS_CINE_DESC,
  INF_INST_DEPORT,
  INF_INST_DEPORT_DESC,
  INF_CENTROS_COMERC,
  INF_CENTROS_COMERC_DESC,
  INF_OCIO_OTROS,
  INF_CENTROS_EDU,
  INF_ESCUELAS_INF,
  INF_ESCUELAS_INF_DESC,
  INF_COLEGIOS,
  INF_COLEGIOS_DESC,
  INF_INSTITUTOS,
  INF_INSTITUTOS_DESC,
  INF_UNIVERSIDADES,
  INF_UNIVERSIDADES_DESC,
  INF_CENTROS_EDU_OTROS,
  INF_CENTROS_SANIT,
  INF_CENTROS_SALUD,
  INF_CENTROS_SALUD_DESC,
  INF_CLINICAS,
  INF_CLINICAS_DESC,
  INF_HOSPITALES,
  INF_HOSPITALES_DESC,
  INF_CENTROS_SANIT_OTROS,
  INF_PARKING_SUP_SUF,
  INF_COMUNICACIONES,
  INF_FACIL_ACCESO,
  INF_FACIL_ACCESO_DESC,
  INF_LINEAS_BUS,
  INF_LINEAS_BUS_DESC,
  INF_METRO,
  INF_METRO_DESC,
  INF_EST_TREN,
  INF_EST_TREN_DESC,
  INF_COMUNICACIONES_OTRO,
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
  '||V_ESQUEMA||'.S_'||V_TABLA5||'.NEXTVAL                       INF_ID,
  ICO.ICO_ID,
  INF.INF_OCIO,
  INF.INF_HOTELES,
  INF.INF_HOTELES_DESC,
  INF.INF_TEATROS,
  INF.INF_TEATROS_DESC,
  INF.INF_SALAS_CINE,
  INF.INF_SALAS_CINE_DESC,
  INF.INF_INST_DEPORT,
  INF.INF_INST_DEPORT_DESC,
  INF.INF_CENTROS_COMERC,
  INF.INF_CENTROS_COMERC_DESC,
  INF.INF_OCIO_OTROS,
  INF.INF_CENTROS_EDU,
  INF.INF_ESCUELAS_INF,
  INF.INF_ESCUELAS_INF_DESC,
  INF.INF_COLEGIOS,
  INF.INF_COLEGIOS_DESC,
  INF.INF_INSTITUTOS,
  INF.INF_INSTITUTOS_DESC,
  INF.INF_UNIVERSIDADES,
  INF.INF_UNIVERSIDADES_DESC,
  INF.INF_CENTROS_EDU_OTROS,
  INF.INF_CENTROS_SANIT,
  INF.INF_CENTROS_SALUD,
  INF.INF_CENTROS_SALUD_DESC,
  INF.INF_CLINICAS,
  INF.INF_CLINICAS_DESC,
  INF.INF_HOSPITALES,
  INF.INF_HOSPITALES_DESC,
  INF.INF_CENTROS_SANIT_OTROS,
  INF.INF_PARKING_SUP_SUF,
  INF.INF_COMUNICACIONES,
  INF.INF_FACIL_ACCESO,
  INF.INF_FACIL_ACCESO_DESC,
  INF.INF_LINEAS_BUS,
  INF.INF_LINEAS_BUS_DESC,
  INF.INF_METRO,
  INF.INF_METRO_DESC,
  INF.INF_EST_TREN,
  INF.INF_EST_TREN_DESC,
  INF.INF_COMUNICACIONES_OTRO,
  ''0''                                                 VERSION,
  '''||V_USUARIO||'''                                               USUARIOCREAR,
  SYSDATE                                               FECHACREAR,
  NULL                                                  USUARIOMODIFICAR,
  NULL                                                  FECHAMODIFICAR,
  NULL                                                  USUARIOBORRAR,
  NULL                                                  FECHABORRAR,
  0                                                     BORRADO
      FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA5||' INF ON INF.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA5||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )   

  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA5||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  

  
 EXECUTE IMMEDIATE  'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA5||''',''1''); END;';


  --Llenamos la sexta tabla ACT_ZCO_ZONA_COMUN

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA6||' (
  ZCO_ID,
  ICO_ID,
  ZCO_ZONAS_COMUNES,
  ZCO_JARDINES,
  ZCO_PISCINA,
  ZCO_INST_DEP,
  ZCO_PADEL,
  ZCO_TENIS,
  ZCO_PISTA_POLIDEP,
  ZCO_OTROS,
  ZCO_ZONA_INFANTIL,
  ZCO_CONSERJE_VIGILANCIA,
  ZCO_GIMNASIO,
  ZCO_ZONA_COMUN_OTROS,
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
		'||V_ESQUEMA||'.S_'||V_TABLA6||'.NEXTVAL                       ZCO_ID,
		ICO.ICO_ID,
		ZCO.ZCO_ZONAS_COMUNES,
		ZCO.ZCO_JARDINES,
		ZCO.ZCO_PISCINA,
		ZCO.ZCO_INST_DEP,
		ZCO.ZCO_PADEL,
		ZCO.ZCO_TENIS,
		ZCO.ZCO_PISTA_POLIDEP,
		ZCO.ZCO_OTROS,
		ZCO.ZCO_ZONA_INFANTIL,
		ZCO.ZCO_CONSERJE_VIGILANCIA,
		ZCO.ZCO_GIMNASIO,
		ZCO.ZCO_ZONA_COMUN_OTROS,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                               USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO
      FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA6||' ZCO ON ZCO.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA6||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )   
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
 
  
  COMMIT;
  
  EXECUTE IMMEDIATE  'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA6||''',''1''); END;';
  
  
  --Llenamos la séptima tabla ACT_INS_INSTALACION

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA7||' (
  INS_ID,
  ICO_ID,
  INS_ELECTR,
  INS_ELECTR_CON_CONTADOR,
  INS_ELECTR_BUEN_ESTADO,
  INS_ELECTR_DEFECTUOSA_ANTIGUA,
  INS_AGUA,
  INS_AGUA_CON_CONTADOR,
  INS_AGUA_BUEN_ESTADO,
  INS_AGUA_DEFECTUOSA_ANTIGUA,
  INS_AGUA_CALIENTE_CENTRAL,
  INS_AGUA_CALIENTE_GAS_NATURAL,
  INS_GAS,
  INS_GAS_CON_CONTADOR,
  INS_GAS_INST_BUEN_ESTADO,
  INS_GAS_DEFECTUOSA_ANTIGUA,
  INS_CALEF,
  INS_CALEF_CENTRAL,
  INS_CALEF_GAS_NATURAL,
  INS_CALEF_RADIADORES_ALU,
  INS_CALEF_PREINSTALACION,
  INS_AIRE,
  INS_AIRE_PREINSTALACION,
  INS_AIRE_INSTALACION,
  INS_AIRE_FRIO_CALOR,
  INS_INST_OTROS,
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
		'||V_ESQUEMA||'.S_'||V_TABLA7||'.NEXTVAL                       INS_ID,
		ICO.ICO_ID,
		INS.INS_ELECTR,
		INS.INS_ELECTR_CON_CONTADOR,
		INS.INS_ELECTR_BUEN_ESTADO,
		INS.INS_ELECTR_DEFECTUOSA_ANTIGUA,
		INS.INS_AGUA,
		INS.INS_AGUA_CON_CONTADOR,
		INS.INS_AGUA_BUEN_ESTADO,
		INS.INS_AGUA_DEFECTUOSA_ANTIGUA,
		INS.INS_AGUA_CALIENTE_CENTRAL,
		INS.INS_AGUA_CALIENTE_GAS_NATURAL,
		INS.INS_GAS,
		INS.INS_GAS_CON_CONTADOR,
		INS.INS_GAS_INST_BUEN_ESTADO,
		INS.INS_GAS_DEFECTUOSA_ANTIGUA,
		INS.INS_CALEF,
		INS.INS_CALEF_CENTRAL,
		INS.INS_CALEF_GAS_NATURAL,
		INS.INS_CALEF_RADIADORES_ALU,
		INS.INS_CALEF_PREINSTALACION,
		INS.INS_AIRE,
		INS.INS_AIRE_PREINSTALACION,
		INS.INS_AIRE_INSTALACION,
		INS.INS_AIRE_FRIO_CALOR,
		INS.INS_INST_OTROS,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                               USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO
      FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA7||' INS ON INS.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA7||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )   

  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA7||' cargada. '||SQL%ROWCOUNT||' Filas.');
  

  
  COMMIT;
  

    EXECUTE IMMEDIATE  'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA7||''',''1''); END;';
  
  

  --Llenamos la octava tabla ACT_BNY_BANYO

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA8||' (
  BNY_ID,
  ICO_ID,
  BNY_DUCHA_BANYERA,
  BNY_DUCHA,
  BNY_BANYERA,
  BNY_BANYERA_HIDROMASAJE,
  BNY_COLUMNA_HIDROMASAJE,
  BNY_ALICATADO_MARMOL,
  BNY_ALICATADO_GRANITO,
  BNY_ALICATADO_AZULEJO,
  BNY_ENCIMERA,
  BNY_MARMOL,
  BNY_GRANITO,
  BNY_OTRO_MATERIAL,
  BNY_SANITARIOS,
  BNY_SANITARIOS_EST,
  BNY_SUELOS,
  BNY_GRIFO_MONOMANDO,
  BNY_GRIFO_MONOMANDO_EST,
  BNY_BANYO_OTROS,
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
		'||V_ESQUEMA||'.S_'||V_TABLA8||'.NEXTVAL                       BNY_ID,
		ICO.ICO_ID,
		BNY.BNY_DUCHA_BANYERA,
		BNY.BNY_DUCHA,
		BNY.BNY_BANYERA,
		BNY.BNY_BANYERA_HIDROMASAJE,
		BNY.BNY_COLUMNA_HIDROMASAJE,
		BNY.BNY_ALICATADO_MARMOL,
		BNY.BNY_ALICATADO_GRANITO,
		BNY.BNY_ALICATADO_AZULEJO,
		BNY.BNY_ENCIMERA,
		BNY.BNY_MARMOL,
		BNY.BNY_GRANITO,
		BNY.BNY_OTRO_MATERIAL,
		BNY.BNY_SANITARIOS,
		BNY.BNY_SANITARIOS_EST,
		BNY.BNY_SUELOS,
		BNY.BNY_GRIFO_MONOMANDO,
		BNY.BNY_GRIFO_MONOMANDO_EST,
		BNY.BNY_BANYO_OTROS,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                               USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA8||' BNY ON BNY.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA8||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )   
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA8||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  COMMIT;
  
  EXECUTE IMMEDIATE  'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA8||''',''1''); END;';
  --Llenamos la novena tabla ACT_COC_COCINA



    
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA9||' (
  COC_ID,
  ICO_ID,
  COC_AMUEBLADA,
  COC_AMUEBLADA_EST,
  COC_ENCIMERA,
  COC_ENCI_GRANITO,
  COC_ENCI_MARMOL,
  COC_ENCI_OTRO_MATERIAL,
  COC_VITRO,
  COC_LAVADORA,
  COC_FRIGORIFICO,
  COC_LAVAVAJILLAS,
  COC_MICROONDAS,
  COC_HORNO,
  COC_SUELOS,
  COC_AZULEJOS,
  COC_AZULEJOS_EST,
  COC_GRIFOS_MONOMANDO,
  COC_GRIFOS_MONOMANDO_EST,
  COC_COCINA_OTROS,
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
		'||V_ESQUEMA||'.S_'||V_TABLA9||'.NEXTVAL                       COC_ID,
		ICO.ICO_ID,
		COC.COC_AMUEBLADA,
		COC.COC_AMUEBLADA_EST,
		COC.COC_ENCIMERA,
		COC.COC_ENCI_GRANITO,
		COC.COC_ENCI_MARMOL,
		COC.COC_ENCI_OTRO_MATERIAL,
		COC.COC_VITRO,
		COC.COC_LAVADORA,
		COC.COC_FRIGORIFICO,
		COC.COC_LAVAVAJILLAS,
		COC.COC_MICROONDAS,
		COC.COC_HORNO,
		COC.COC_SUELOS,
		COC.COC_AZULEJOS,
		COC.COC_AZULEJOS_EST,
		COC.COC_GRIFOS_MONOMANDO,
		COC.COC_GRIFOS_MONOMANDO_EST,
		COC.COC_COCINA_OTROS,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                               USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA9||' COC ON COC.ICO_ID = ICO2.ICO_ID
	WHERE NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA9||' AUX WHERE AUX.ICO_ID = ICO.ICO_ID )   
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA9||' cargada. '||SQL%ROWCOUNT||' Filas.');
  END IF;
  COMMIT;
  
  EXECUTE IMMEDIATE  'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA9||''',''1''); END;';
 
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

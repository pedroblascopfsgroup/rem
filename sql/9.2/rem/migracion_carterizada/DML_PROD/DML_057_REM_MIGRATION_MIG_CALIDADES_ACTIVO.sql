--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AIA_CALIDADES_ACTIVO' -> 'ACT_CRI_CARPINTERIA_INT' - ACT_CRE_CARPINTERIA_EXT - ACT_PRV_PARAMENTO_VERTICAL - ACT_SOL_SOLADO - ACT_INF_INFRAESTRUCTURA - ACT_ZCO_ZONA_COMUN - ACT_INS_INSTALACION - ACT_BNY_BANYO
--## 									- ACT_COC_COCINA
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_CRI_CARPINTERIA_INT';
V_TABLA2 VARCHAR2(40 CHAR) := 'ACT_CRE_CARPINTERIA_EXT';
V_TABLA3 VARCHAR2(40 CHAR) := 'ACT_PRV_PARAMENTO_VERTICAL';
V_TABLA4 VARCHAR2(40 CHAR) := 'ACT_SOL_SOLADO';
V_TABLA5 VARCHAR2(40 CHAR) := 'ACT_INF_INFRAESTRUCTURA';
V_TABLA6 VARCHAR2(40 CHAR) := 'ACT_ZCO_ZONA_COMUN';
V_TABLA7 VARCHAR2(40 CHAR) := 'ACT_INS_INSTALACION';
V_TABLA8 VARCHAR2(40 CHAR) := 'ACT_BNY_BANYO';
V_TABLA9 VARCHAR2(40 CHAR) := 'ACT_COC_COCINA';

V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ACA_CALIDADES_ACTIVO';
V_SENTENCIA VARCHAR2(1600 CHAR);
V_NUM NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

--Llenamos la primera tabla ACT_CRI_CARPINTERIA_INT

	EXECUTE IMMEDIATE ('
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
	WITH ACT_NUM_ACTIVO AS (
    SELECT ACT_NUMERO_ACTIVO 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
    WHERE ACT_NUMERO_ACTIVO NOT IN (
      SELECT ACT_NUM_ACTIVO 
      FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
      WHERE ICO.ICO_ID IN (
        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' ZCO
        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
	SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                       CRI_ID,
  
  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
  
	
    (SELECT DD_ACR_ID
		FROM '||V_ESQUEMA||'.DD_ACR_ACABADO_CARPINTERIA ACR
		WHERE ACR.DD_ACR_CODIGO = MIG.NIVEL_ACABADO_INTERIOR) DD_ACR_ID, 
    
CRI_PTA_ENT_NORMAL,
CRI_PTA_ENT_BLINDADA,
CRI_PTA_ENT_ACORAZADA,
CRI_PTA_PASO_MACIZAS,
CRI_PTA_PASO_HUECAS,
CRI_PTA_PASO_LACADAS,
CRI_ARMARIOS_EMPOTRADOS,
CRI_CRP_INT_OTROS,    
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  

--Llenamos la segunda tabla ACT_CRE_CARPINTERIA_EXT

	EXECUTE IMMEDIATE ('
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
	WITH ACT_NUM_ACTIVO AS (
    SELECT ACT_NUMERO_ACTIVO 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
    WHERE ACT_NUMERO_ACTIVO NOT IN (
      SELECT ACT_NUM_ACTIVO 
      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT
      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
      WHERE ICO.ICO_ID IN (
        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA2||' ZCO
        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
	SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA2||'.NEXTVAL                       CRE_ID,
  
  
  
  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
    
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
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA2||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA2||' ANALIZADA.');



--Llenamos la tercera tabla ACT_PRV_PARAMENTO_VERTICAL

	EXECUTE IMMEDIATE ('
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
	WITH ACT_NUM_ACTIVO AS (
	    SELECT ACT_NUMERO_ACTIVO 
	    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
	    WHERE ACT_NUMERO_ACTIVO NOT IN (
	      SELECT ACT_NUM_ACTIVO 
	      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT
	      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
	      WHERE ICO.ICO_ID IN (
	        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA3||' ZCO
	    	)
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
	SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA3||'.NEXTVAL                       PRV_ID,

  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
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
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA3||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA3||' ANALIZADA.');
  
  
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
	WITH ACT_NUM_ACTIVO AS (
	    SELECT ACT_NUMERO_ACTIVO 
	    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
	    WHERE ACT_NUMERO_ACTIVO NOT IN (
	      SELECT ACT_NUM_ACTIVO 
	      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT
	      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
	      WHERE ICO.ICO_ID IN (
	        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA4||' ZCO
	        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA4||'.NEXTVAL                       PRV_ID,

  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID, 
  SOL_TARIMA_FLOTANTE,
  SOL_PARQUE,
  SOL_MARMOL,
  SOL_PLAQUETA,
  SOL_SOLADO_OTROS,
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA4||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA4||' ANALIZADA.');


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
	WITH ACT_NUM_ACTIVO AS (
	    SELECT ACT_NUMERO_ACTIVO 
	    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
	    WHERE ACT_NUMERO_ACTIVO NOT IN (
	      SELECT ACT_NUM_ACTIVO 
	      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT
	      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
	      WHERE ICO.ICO_ID IN (
	        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA5||' ZCO
	        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
	SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA5||'.NEXTVAL                       INF_ID,
  
  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
    
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
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA5||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA5||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA5||' ANALIZADA.');
  
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
	WITH ACT_NUM_ACTIVO AS (
	    SELECT ACT_NUMERO_ACTIVO 
	    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
	    WHERE ACT_NUMERO_ACTIVO NOT IN (
	      SELECT ACT_NUM_ACTIVO 
	      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT
	      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
	      WHERE ICO.ICO_ID IN (
	        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA6||' ZCO
	        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA6||'.NEXTVAL                       ZCO_ID,
  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
    
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
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA6||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA6||' ANALIZADA.');
  
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
	WITH ACT_NUM_ACTIVO AS (
	    SELECT ACT_NUMERO_ACTIVO 
	    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
	    WHERE ACT_NUMERO_ACTIVO NOT IN (
	      SELECT ACT_NUM_ACTIVO 
	      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT
	      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
	      WHERE ICO.ICO_ID IN (
	        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA7||' ZCO
	        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA7||'.NEXTVAL                       INS_ID,
  
  
  
  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
    
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
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA7||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA7||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA7||' ANALIZADA.');
  
  
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
	WITH ACT_NUM_ACTIVO AS (
	    SELECT ACT_NUMERO_ACTIVO 
	    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
	    WHERE ACT_NUMERO_ACTIVO NOT IN (
	      SELECT ACT_NUM_ACTIVO 
	      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT
	      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
	      WHERE ICO.ICO_ID IN (
	        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA8||' ZCO
	        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA8||'.NEXTVAL                       BNY_ID,
  
  
  
  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
    
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
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA8||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA8||' ANALIZADA.');
  
  COMMIT;
  
  
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
	WITH ACT_NUM_ACTIVO AS (
	    SELECT ACT_NUMERO_ACTIVO 
	    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
	    WHERE ACT_NUMERO_ACTIVO NOT IN (
	      SELECT ACT_NUM_ACTIVO 
	      FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	      JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
	      WHERE ICO.ICO_ID IN (
	        SELECT ZCO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA9||' ZCO
	        )
		)
		AND VALIDACION = 0
	),
  ACT_ICO AS (
    SELECT ACT.ACT_NUM_ACTIVO
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_ID = ICO.ACT_ID
  )
SELECT
	'||V_ESQUEMA||'.S_'||V_TABLA9||'.NEXTVAL                       COC_ID,
  
  (SELECT AC.ICO_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL AC
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    ) ICO_ID,
    
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
	''0''                                                 VERSION,
	'||V_USUARIO||'                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
        ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN ACT_ICO ICO
  ON ICO.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	MIG.VALIDACION = 0
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA9||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA9||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA9||' ANALIZADA.');
 
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
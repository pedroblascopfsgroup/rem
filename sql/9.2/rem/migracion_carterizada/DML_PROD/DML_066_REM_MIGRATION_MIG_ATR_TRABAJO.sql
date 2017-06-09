--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ATR_TRABAJO' -> 'ACT_TBJ_TRABAJO', 'ACT_TBJ'
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
TABLE_COUNT_2 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_TBJ_TRABAJO';
V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_TBJ';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATR_TRABAJO';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_DUP NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  -- Estamos dando por hecho que el campo ACT_NUM_TRABAJO va a ser unico e identificara cada trabajo, cuando se reciban datos
  -- se comprobara si es asi, si se diera el caso de que no lo fuera, cambiar el filtro del WITH
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	TBJ_ID,
	ACT_ID,
	AGR_ID,
	TBJ_NUM_TRABAJO,
	PVC_ID,
	USU_ID,
	DD_TTR_ID,
	DD_STR_ID,
	DD_EST_ID,
	TBJ_DESCRIPCION,
	TBJ_FECHA_SOLICITUD,
	TBJ_FECHA_APROBACION,
	TBJ_FECHA_INICIO,
	TBJ_FECHA_FIN,
	TBJ_CONTINUO_OBSERVACIONES,
	TBJ_FECHA_FIN_COMPROMISO,
	TBJ_FECHA_TOPE,
	TBJ_FECHA_HORA_CONCRETA,
	TBJ_URGENTE,
	TBJ_CON_RIESGO_TERCEROS,
	TBJ_CUBRE_SEGURO,
	TBJ_CIA_ASEGURADORA,
	DD_TCA_ID,
	TBJ_TERCERO_NOMBRE,
	TBJ_TERCERO_EMAIL,
	TBJ_TERCERO_DIRECCION,
	TBJ_TERCERO_CONTACTO,
	TBJ_TERCERO_TEL1,
	TBJ_TERCERO_TEL2,
	TBJ_IMPORTE_PENAL_DIARIO,
	TBJ_OBSERVACIONES,
	TBJ_IMPORTE_TOTAL,
	TBJ_FECHA_RECHAZO,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
  WITH TRABAJOS AS (
  SELECT * FROM (
   SELECT MIG.*, ROW_NUMBER() OVER (PARTITION BY TBJ_NUM_TRABAJO ORDER BY TBJ_FECHA_APROBACION DESC) ORDEN
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS ACTW
      ON ACTW.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    WHERE ACTW.ACT_NUM_ACTIVO IS NULL
	AND MIG.VALIDACION = 0
  ) WHERE ORDEN = 1
  )
  SELECT
	'||V_ESQUEMA||'.S_ACT_TBJ_TRABAJO.NEXTVAL			                         TBJ_ID,
  NULL																	           ACT_ID,
  (SELECT AGR.AGR_ID
  FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
  WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)                 AGR_ID,
  MIG.TBJ_NUM_TRABAJO                                                                 TBJ_NUM_TRABAJO,
  (SELECT PVC.PVC_ID
  FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
  WHERE PVC.PVC_DOCIDENTIF = MIG.PVC_DOCIDENTIF)                  PVC_ID,
  NULL                                                                                         USU_ID,
  (SELECT TTR.DD_TTR_ID
  FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
  WHERE TTR.DD_TTR_CODIGO = MIG.TIPO_TRABAJO)                    DD_TTR_ID,
  (SELECT STR.DD_STR_ID
  FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR
  WHERE STR.DD_STR_CODIGO = MIG.SUBTIPO_TRABAJO)                 DD_STR_ID,
  (SELECT EST.DD_EST_ID
  FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST
  WHERE EST.DD_EST_CODIGO = MIG.ESTADO_TRABAJO)              DD_EST_ID,
  MIG.TBJ_DESCRIPCION                                                            TBJ_DESCRIPCION,
  MIG.TBJ_FECHA_SOLICITUD                                                        TBJ_FECHA_SOLICITUD,
  MIG.TBJ_FECHA_APROBACION                                                 TBJ_FECHA_APROBACION,
  MIG.TBJ_FECHA_INICIO                                                             TBJ_FECHA_INICIO,
  MIG.TBJ_FECHA_FIN                                                                  TBJ_FECHA_FIN,
  MIG.TBJ_CONTINUO_OBSERVACIONES                                       TBJ_CONTINUO_OBSERVACIONES,
  MIG.TBJ_FECHA_FIN_COMPROMISO                                                      TBJ_FECHA_FIN_COMPROMISO,
  MIG.TBJ_FECHA_TOPE                                                                  TBJ_FECHA_TOPE,
  MIG.TBJ_FECHA_HORA_CONCRETA                                          TBJ_FECHA_HORA_CONCRETA,
  MIG.TBJ_URGENTE                                                                 TBJ_URGENTE,
  MIG.TBJ_CON_RIESGO_TERCEROS                                                 TBJ_CON_RIESGO_TERCEROS,
  MIG.TBJ_CUBRE_SEGURO                                                       TBJ_CUBRE_SEGURO,
  MIG.TBJ_CIA_ASEGURADORA                                                    TBJ_CIA_ASEGURADORA,
  (SELECT TCA.DD_TCA_ID
  FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CALIDAD TCA
  WHERE TCA.DD_TCA_CODIGO = MIG.TIPO_CALIDAD)               DD_TCA_ID,
  MIG.TBJ_TERCERO_NOMBRE                                                     TBJ_TERCERO_NOMBRE,
  MIG.TBJ_TERCERO_EMAIL                                                       TBJ_TERCERO_EMAIL,
  MIG.TBJ_TERCERO_DIRECCION                                               TBJ_TERCERO_DIRECCION,
  MIG.TBJ_TERCERO_CONTACTO                                               TBJ_TERCERO_CONTACTO,
  MIG.TBJ_TERCERO_TEL1                                                       TBJ_TERCERO_TEL1,
  MIG.TBJ_TERCERO_TEL2                                                         TBJ_TERCERO_TEL2,
  MIG.TBJ_IMPORTE_PENAL_DIARIO                                            TBJ_IMPORTE_PENAL_DIARIO,
  MIG.TBJ_OBSERVACIONES                                                         TBJ_OBSERVACIONES,
  MIG.TBJ_IMPORTE_TOTAL                                                        TBJ_IMPORTE_TOTAL,
  MIG.TBJ_FECHA_DENEGACION												TBJ_FECHA_RECHAZO,
  ''0''                                                                                         VERSION,
  '||V_USUARIO||'                                                                                    USUARIOCREAR,
  SYSDATE                                                                            FECHACREAR,
  0                                                                                         BORRADO
	FROM TRABAJOS MIG
	')
	;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'.');
 
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
	ACT_ID,
	TBJ_ID,
	ACT_TBJ_PARTICIPACION,
	VERSION
	)
	WITH EXISTENTES AS (
		SELECT DISTINCT ACT_ID, TBJ_ID
		FROM '||V_ESQUEMA||'.'||V_TABLA_2||' TBJ
	),
  INSERTAR AS (
    SELECT DISTINCT ACT.ACT_ID, TBJ.TBJ_ID
		FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
    INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
      ON TBJ.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
      ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.VALIDACION = 0
  )
	SELECT 
	TBJ.ACT_ID  					ACT_ID,
	TBJ.TBJ_ID						TBJ_ID,
	0								ACT_TBJ_PARTICIPACION,
	0								VERSION
	FROM INSERTAR TBJ
	LEFT JOIN EXISTENTES EXI
		ON EXI.TBJ_ID = TBJ.TBJ_ID
	WHERE EXI.TBJ_ID IS NULL
    AND EXI.ACT_ID IS NULL
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
  --MERGEAMOS PARA AÑADIR ACT_ID EN ACT_TBJ_TRABAJO
  
		EXECUTE IMMEDIATE '
		MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' TBJ USING
		(
			SELECT ACT_ID, TBJ_ID FROM(
			  SELECT  ACT_TBJ.TBJ_ID, ACT_TBJ.ACT_ID, ROW_NUMBER() OVER ( PARTITION BY ACT_TBJ.TBJ_ID ORDER BY ACT_ID DESC) AS ORDEN
			  FROM '||V_ESQUEMA||'.'||V_TABLA_2||' ACT_TBJ)
			  WHERE ORDEN = 1
		) TMP
		ON (TBJ.TBJ_ID = TMP.TBJ_ID)
		WHEN MATCHED THEN UPDATE
		SET
		TBJ.ACT_ID = TMP.ACT_ID
		'
		;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA_2||' mergeada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
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
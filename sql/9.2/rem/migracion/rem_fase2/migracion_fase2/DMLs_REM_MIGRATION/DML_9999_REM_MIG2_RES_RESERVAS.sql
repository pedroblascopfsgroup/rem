--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160929
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_RES_RESERVAS' -> 'RES_RESERVAS'
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
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'RES_RESERVAS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_RES_RESERVAS';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_DUP NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN 
  
  --COMPROBACIONES PREVIAS - OFERTAS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO OFERTAS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR WHERE OFR.OFR_NUM_OFERTA = MIG.RES_COD_OFERTA
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
  
  IF TABLE_COUNT_2 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS OFERTAS EXISTEN EN OFR_OFERTAS');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' OFERTAS INEXISTENTES EN OFR_OFERTAS. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS (
    OFR_NUM_OFERTA,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH OFR_NUM_OFERTA AS (
		SELECT
		MIG.RES_COD_OFERTA 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE MIG.RES_COD_OFERTA = OFR_NUM_OFERTA
		)
    )
    SELECT DISTINCT
    MIG.RES_COD_OFERTA                              						RES_COD_OFERTA,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA
    ON OFR_NUM_OFERTA.RES_COD_OFERTA = MIG.RES_COD_OFERTA
    '
    ;
    
    COMMIT;

  END IF;
  
  
  --Inicio del proceso de volcado sobre RES_RESERVAS
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	RES_ID,
	ECO_ID,
	RES_NUM_RESERVA,
	RES_FECHA_ENVIO,
	RES_FECHA_FIRMA,
	RES_FECHA_VENCIMIENTO,
	RES_FECHA_ANULACION,
	RES_MOTIVO_ANULACION,
	RES_IND_IMP_ANULACION,
	RES_IMPORTE_DEVUELTO,
	DD_TAR_ID,
	DD_ERE_ID,
	RES_FECHA_SOLICITUD,
	RES_FECHA_RESOLUCION,
	VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
	)
	WITH INSERTAR AS (
    SELECT DISTINCT
     MIGW.RES_COD_OFERTA,
     MIGW.RES_COD_NUM_RESERVA,
     --MIGW.RES_FECHA_ENVIO,
     MIGW.RES_FECHA_SOLICITUD,
     MIGW.RES_FECHA_FIRMA,
     MIGW.RES_FECHA_VENCIMIENTO,
     MIGW.RES_FECHA_ANULACION,
     MIGW.RES_MOTIVO_ANULACION,
     MIGW.RES_IND_IMP_ANULACION,
     MIGW.RES_IMPORTE_DEVUELTO,
     MIGW.RES_COD_TIPO_ARRA,
     MIGW.RES_COD_ESTADO_RESERVA,
     MIGW.RES_FECHA_SOLICITUD,
     --MIGW.RES_FECHA_RESOLUCION
     FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
     WHERE NOT EXISTS (
      SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' RESW WHERE MIGW.RES_COD_NUM_RESERVA = RESW.RES_NUM_RESERVA
	))
	SELECT 
	'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL             RES_ID,
	RES.RES_COD_OFERTA									ECO_ID,
	RES.RES_COD_NUM_RESERVA								RES_NUM_RESERVA,
	--RES.RES_FECHA_ENVIO								RES_FECHA_ENVIO,
	RES.RES_FECHA_FIRMA									RES_FECHA_FIRMA,
	RES.RES_FECHA_VENCIMIENTO							RES_FECHA_VENCIMIENTO,
	RES.RES_FECHA_ANULACION								RES_FECHA_ANULACION,
	RES.RES_MOTIVO_ANULACION							RES_MOTIVO_ANULACION,
	RES.RES_IND_IMP_ANULACION							RES_MOTIVO_ANULACION,
	RES.RES_IMPORTE_DEVUELTO							RES_IMPORTE_DEVUELTO,
	(SELECT DD_TAR_ID
	FROM '||V_ESQUEMA||'.DD_TAR_TIPOS_ARRAS 
	WHERE DD_TAR_CODIGO = RES.RES_COD_TIPO_ARRA)		DD_TAR_ID,
	(SELECT DD_ERE_ID
	FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA 
	WHERE DD_ERE_CODIGO = RES.RES_COD_ESTADO_RESERVA)	DD_ERE_ID,
	RES.RES_FECHA_SOLICITUD								RES_FECHA_SOLICITUD,
	--RES.RES_FECHA_RESOLUCION							RES_FECHA_RESOLUCION,
	''0''                                               VERSION,
	''MIG2''                                            USUARIOCREAR,
	SYSDATE                                             FECHACREAR,
	0                                                   BORRADO
	FROM INSERTAR RES									
	LEFT JOIN '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS NOTT
			ON NOTT.RES_COD_OFERTA = MIG.RES_COD_OFERTA
	WHERE NOTT.RES_COD_OFERTA IS NULL
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
   -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;

 EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
 
 -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = ''MIG2''
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
  
    IF TABLE_COUNT != 0 THEN
    
      V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por OFERTAS inexistentes. ';
    
    END IF; 
    
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

--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_FOR_FORMALIZACIONES' -> 'FOR_FORMALIZACION'
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'FOR_FORMALIZACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_FOR_FORMALIZACIONES';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN 
  
 
  --Inicio del proceso de volcado sobre RES_RESERVAS
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE ('
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        FOR_ID,
        ECO_ID,
        FOR_PETICIONARIO,
        FOR_FECHA_PETICION,
        FOR_FECHA_RESOLUCION,
        FOR_FECHA_ESCRITURA,
        FOR_FECHA_CONTABILIZACION,
        FOR_FECHA_PAGO,
        FOR_IMPORTE,
        FOR_FORMA_PAGO,
        FOR_MOTIVO_RESOLUCION,
        VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
        )
        SELECT 
        '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL             FOR_ID,
        ECO.ECO_ID                                                                                      ECO_ID,
        MIG.FOR_PETICIONARIO                                                            FOR_PETICIONARIO,
        MIG.FOR_FECHA_PETICION                                                          FOR_FECHA_PETICION,
        MIG.FOR_FECHA_RESOLUCION                                                        FOR_FECHA_RESOLUCION,
        MIG.FOR_FECHA_ESCRITURA                                                         FOR_FECHA_ESCRITURA,
        MIG.FOR_FECHA_CONTABILIZACION                                           FOR_FECHA_CONTABILIZACION,
        MIG.FOR_FECHA_PAGO                                                                      FOR_FECHA_PAGO,
        MIG.FOR_IMPORTE                                                                         FOR_IMPORTE,
        MIG.FOR_FORMA_PAGO                                                                      FOR_FORMA_PAGO,
        MIG.FOR_MOTIVO_RESOLUCION                                                       FOR_MOTIVO_RESOLUCION,
        ''0''                                               VERSION,
        '''||V_USUARIO||'''                                 USUARIOCREAR,
        SYSDATE                                             FECHACREAR,
        0                                                   BORRADO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG.FOR_COD_OFERTA
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID 
		WHERE MIG.VALIDACION = 0                                                             
        ')
        ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
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

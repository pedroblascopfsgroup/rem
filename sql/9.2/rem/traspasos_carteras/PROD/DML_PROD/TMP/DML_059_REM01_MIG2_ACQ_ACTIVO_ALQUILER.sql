--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_ACQ_ACTIVO_ALQUILER -> ACT_HAL_HIST_ALQUILERES
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
V_USUARIO VARCHAR2(50 CHAR) := 'TRASPASO_TANGO';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_HAL_HIST_ALQUILERES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACQ_ACTIVO_ALQUILER';
V_SENTENCIA VARCHAR2(32000 CHAR);
BEGIN

          --Inicio del proceso de volcado sobre ACT_HAL_HIST_ALQUILERES
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            HAL_ID,
            ACT_ID,
            HAL_NUMERO_CONTRATO_ALQUILER,
            DD_ESC_ID,
            HAL_FECHA_INICIO_CONTRATO,
            HAL_FECHA_FIN_CONTRATO,
            HAL_FECHA_RESOLUCION_CONTRATO,
            HAL_IMPORTE_RENTA_CONTRATO,
            HAL_PLAZO_OPCION_COMPRA,
            HAL_PRIMA_OPCION_COMPRA,
            HAL_PRECIO_OPCION_COMPRA,
            HAL_CONDICIONES_OPCION_COMPRA,
            HAL_IND_CONFLICTO_INTERESES,
            HAL_IND_RIESGO_REPUTACIONAL,
            HAL_GASTOS_IBI,
            DD_TPC_ID_IBI,
            HAL_GASTOS_COMUNIDAD,
            DD_TPC_ID_COM,
            DD_TPC_ID_SUMINISTRO,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO
        )
        SELECT
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                     HAL_ID,
            ACT.ACT_ID                                                  ACT_ID,
            MIG.ACQ_NUMERO_CONTRATO_ALQUILER                            HAL_NUMERO_CONTRATO_ALQUILER,
            ESC.DD_ESC_ID                                               DD_ESC_ID,
            MIG.ACQ_FECHA_INICIO_CONTRATO                               HAL_FECHA_INICIO_CONTRATO,
            MIG.ACQ_FECHA_FIN_CONTRATO                                  HAL_FECHA_FIN_CONTRATO,
            MIG.ACQ_FECHA_RESOLUCION_CONTRATO                           HAL_FECHA_RESOLUCION_CONTRATO,
            MIG.ACQ_IMPORTE_RENTA_CONTRATO                              HAL_IMPORTE_RENTA_CONTRATO,
            MIG.ACQ_PLAZO_OPCION_COMPRA                                 HAL_PLAZO_OPCION_COMPRA,
            MIG.ACQ_PRIMA_OPCION_COMPRA                                 HAL_PRIMA_OPCION_COMPRA,
            MIG.ACQ_PRECIO_OPCION_COMPRA                                HAL_PRECIO_OPCION_COMPRA,
            MIG.ACQ_CONDICIONES_OPCION_COMPRA                           HAL_CONDICIONES_OPCION_COMPRA,
            MIG.ACQ_IND_CONFLICTO_INTERESES                             HAL_IND_CONFLICTO_INTERESES,
            MIG.ACQ_IND_RIESGO_REPUTACIONAL                             HAL_IND_RIESGO_REPUTACIONAL,
            MIG.ACQ_GASTOS_IBI                                          HAL_GASTOS_IBI,
            TPC_IBI.DD_TPC_ID                                           DD_TPC_ID_IBI,
            MIG.ACQ_GASTOS_COMUNIDAD                                    HAL_GASTOS_COMUNIDAD,
            TPC_COM.DD_TPC_ID                                           DD_TPC_ID_COM,
            TPC_SUMINISTRO.DD_TPC_ID                                    DD_TPC_ID_SUMINISTRO,
            0                                                           VERSION,
            '''||V_USUARIO||'''                                     USUARIOCREAR,
            SYSDATE                                                     FECHACREAR,
            0                                                           BORRADO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                     ON ACT.ACT_NUM_ACTIVO = MIG.ACQ_NUMERO_ACTIVO
                LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_IBI
                     ON TPC_IBI.DD_TPC_CODIGO = MIG.ACQ_COD_TIPO_PORCTA_IBI
                LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_COM
                     ON TPC_COM.DD_TPC_CODIGO = MIG.ACQ_COD_TIPO_PORCTA_COMUNIDAD
                LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_SUMINISTRO
                    ON TPC_SUMINISTRO.DD_TPC_CODIGO = MIG.ACQ_COD_TIPO_PORCTA_SUMINIS
                LEFT JOIN '||V_ESQUEMA||'.DD_ESC_ESTADO_CNT_ALQUILER ESC
                    ON ESC.DD_ESC_CODIGO = MIG.ACQ_COD_ESTADO_CNT_ALQUILER
        WHERE MIG.VALIDACION = 0
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
 
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
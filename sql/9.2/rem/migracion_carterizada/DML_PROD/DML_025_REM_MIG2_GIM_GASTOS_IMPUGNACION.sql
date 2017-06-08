--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GIM_GASTOS_IMPUGANCION -> GIM_GASTOS_IMPUGNACION
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
V_TABLA VARCHAR2(40 CHAR) := 'GIM_GASTOS_IMPUGNACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GIM_GASTOS_IMPUGNACION';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                GIM_ID,
                GPV_ID,
                GIM_FECHA_TOPE,
                GIM_FECHA_PRESENTACION,
                GIM_FECHA_RESOLUCION,
                DD_RIM_ID,
                GIM_OBSERVACIONES,
                VERSION,
                USUARIOCREAR,
                FECHACREAR,
                BORRADO
                )
                WITH INSERTAR AS (
                SELECT DISTINCT GPV.GPV_ID, 
                                                MIG.GIM_FECHA_TOPE_IMPUGNACION,
                                                MIG.GIM_FECHA_PRESEN_IMPUG,
                                                MIG.GIM_FECHA_RESOLUCION,
                                                MIG.GIM_COD_RESULTADO_IMPUGNACION,
                                                MIG.GIM_OBSERVACIONES
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                  ON GPV.GPV_NUM_GASTO_HAYA = MIG.GIM_GPV_ID
				WHERE MIG.VALIDACION = 0
          )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                         GIM_ID, 
                GIM.GPV_ID                                                                                                      GPV_ID,
                GIM.GIM_FECHA_TOPE_IMPUGNACION                                                                  GIM_FECHA_TOPE,
                GIM.GIM_FECHA_PRESEN_IMPUG                                                                              GIM_FECHA_PRESENTACION,
                GIM.GIM_FECHA_RESOLUCION                                                                                GIM_FECHA_RESOLUCION,
                (SELECT DD_RIM_ID 
                FROM '||V_ESQUEMA||'.DD_RIM_RESULTADOS_IMPUGNACION
                WHERE DD_RIM_CODIGO = GIM.GIM_COD_RESULTADO_IMPUGNACION)                DD_RIM_ID,
                GIM.GIM_OBSERVACIONES                                                                                   GIM_OBSERVACIONES,
                0                                                                                                                               VERSION,
                ''#USUARIO_MIGRACION#''                                                                USUARIOCREAR,
                SYSDATE                                                                         FECHACREAR,
                0                                                                               BORRADO
                FROM INSERTAR GIM
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
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
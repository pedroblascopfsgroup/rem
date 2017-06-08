--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_PRP_PROPUESTAS_PRECIOS -> PRP_PROPUESTAS_PRECIOS
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

TABLE_COUNT     NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
TABLE_COUNT_3 NUMBER(10,0) := 0;
TABLE_COUNT_4 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'PRP_PROPUESTAS_PRECIOS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PRP_PROPUESTAS_PRECIOS';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

      --Inicio del proceso de volcado sobre PRP_PROPUESTAS_PRECIOS
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
                INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' PRP (
                          PRP_ID,
                          PRP_NUM_PROPUESTA,
                          PRP_NOMBRE_PROPUESTA,
                          DD_EPP_ID,
                          USU_ID,
                          DD_CRA_ID,
                          DD_TPP_ID,
                          PRP_ES_PROP_MANUAL,
                          PRP_FECHA_EMISION,
                          PRP_FECHA_ENVIO,
                          PRP_FECHA_SANCION,
                          PRP_FECHA_CARGA,
                          PRP_OBSERVACIONES,
                          VERSION,
                          USUARIOCREAR,
                          FECHACREAR,
                          BORRADO
                )
                SELECT
                        '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                         PRP_ID,
                        MIG.PRP_NUM_PROPUESTA                                                                           PRP_NUM_PROPUESTA,
                        MIG.PRP_NOMBRE_PROPUESTA                                                                        PRP_NOMBRE_PROPUESTA,
                        EPP.DD_EPP_ID                                                                                           DD_EPP_ID,
                        NVL(USU.USU_ID,
                                (SELECT USU_ID
                                FROM REMMASTER.USU_USUARIOS
                                WHERE USU_USERNAME = ''MIGRACION''
                                AND BORRADO = 0)
                        )                                                                                                                       USU_ID,
                        CRA.DD_CRA_ID                                                                                           DD_CRA_ID,
                        TPP.DD_TPP_ID                                                                                           DD_TPP_ID,
                        MIG.PRP_IND_PROP_MANUAL                                                                         PRP_ES_PROP_MANUAL,
                        MIG.PRP_FECHA_EMISION                                                                           PRP_FECHA_EMISION,
                        MIG.PRP_FECHA_ENVIO                                                                                     PRP_FECHA_ENVIO,
                        MIG.PRP_FECHA_SANCION                                                                           PRP_FECHA_SANCION,
                        MIG.PRP_FECHA_CARGA                                                                                     PRP_FECHA_CARGA,
                        MIG.PRP_OBSERVACIONES                                                                           PRP_OBSERVACIONES,
                        0                                                                                                                       VERSION,
                        ''#USUARIO_MIGRACION#''                                                                                                        USUARIOCREAR,
                        SYSDATE                                                                                                         FECHACREAR,
                        0                                                                                                                       BORRADO
                  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                  INNER JOIN '||V_ESQUEMA||'.DD_EPP_ESTADO_PROP_PRECIO EPP 
                        ON DD_EPP_CODIGO = MIG.PRP_COD_ESTADO_PRP 
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU 
                        ON USU.USU_USERNAME = MIG.PRP_COD_USUARIO
                  INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA 
                        ON CRA.DD_CRA_CODIGO = MIG.PRP_COD_CARTERA
                  INNER JOIN '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO TPP 
                        ON TPP.DD_TPP_CODIGO = MIG.PRP_COD_TIPO_PRP
                  WHERE NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.'||V_TABLA||' NOTE
                        WHERE NOTE.PRP_NUM_PROPUESTA = MIG.PRP_NUM_PROPUESTA
                        AND NOTE.BORRADO = 0
                        )
				 	AND MIG.VALIDACION = 0
      '
      ;
   
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
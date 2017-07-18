--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GPV_ACT_TBJ -> GPV_ACT & GPC_TBJ
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

TABLE_COUNT    NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
TABLE_COUNT_3 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA_1 VARCHAR2(40 CHAR) := 'GPV_ACT';
V_TABLA_2 VARCHAR2(40 CHAR) := 'GPV_TBJ';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GPV_ACT_TBJ';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN

          --Inicio del proceso de volcado sobre GPV_ACT
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_1||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_1||' (
                GPV_ACT_ID,
                GPV_ID,
                ACT_ID,
                VERSION
                )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA_1||'.NEXTVAL                               GPV_ACT_ID, 
                GPV.GPV_ID                                                                                                              GPV_ID,
                ACT.ACT_ID                                                                              ACT_ID,
                0                                                                               VERSION
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                        ON GPV.GPV_NUM_GASTO_HAYA = MIG.GPT_GPV_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                        ON ACT.ACT_NUM_ACTIVO = MIG.GPT_ACT_NUMERO_ACTIVO
				WHERE MIG.VALIDACION = 0
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_1||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
       V_SENTENCIA := '
        MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_1||' GAS
        USING ( 
                                WITH SUMATORIO AS(
                                        SELECT GPT_ACT_NUMERO_ACTIVO, GREATEST(SUM(GPT_BASE_IMPONIBLE),1) AS SUMA
                                        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
										WHERE VALIDACION = 0
                                        GROUP BY GPT_ACT_NUMERO_ACTIVO
                                )
                                SELECT GPV.GPV_ID, ACT.ACT_ID, GPT_BASE_IMPONIBLE, ROUND(100*GPT_BASE_IMPONIBLE/OPERACION.SUMA,4) AS SUMA FROM MIG2_GPV_ACT_TBJ MIG2
                                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                  ON ACT.ACT_NUM_ACTIVO = MIG2.GPT_ACT_NUMERO_ACTIVO
                                INNER JOIN SUMATORIO OPERACION
                                  ON MIG2.GPT_ACT_NUMERO_ACTIVO = OPERACION.GPT_ACT_NUMERO_ACTIVO                                       
                                INNER JOIN  '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_NUM_GASTO_HAYA = MIG2.GPT_GPV_ID
                                JOIN '||V_ESQUEMA||'.GPV_ACT T1 ON T1.GPV_ID = GPV.GPV_ID AND T1.ACT_ID = ACT.ACT_ID
								WHERE MIG2.VALIDACION = 0
                          ) AUX
                ON (GAS.GPV_ID = AUX.GPV_ID AND GAS.ACT_ID = AUX.ACT_ID)
                WHEN MATCHED THEN UPDATE SET
                  GAS.GPV_PARTICIPACION_GASTO = AUX.SUMA
      '
      ;
      --EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_1||' actualizada (GPV_PARTICIPACION_GASTO). '||SQL%ROWCOUNT||' Filas.');
      
      --Inicio del proceso de volcado sobre GPV_TBJ
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
                GPV_TBJ_ID,
                GPV_ID,
                TBJ_ID,
                USUARIOCREAR,
                VERSION
                )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA_2||'.NEXTVAL                               GPV_TBJ_ID, 
                GPV.GPV_ID                                                                                                              GPV_ID,
                TBJ.TBJ_ID                                                                              TBJ_ID,
                '''||V_USUARIO||''' AS USUARIOCREAR,
                0                                                                               VERSION
                
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                        ON GPV.GPV_NUM_GASTO_HAYA = MIG.GPT_GPV_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ 
                        ON TBJ.TBJ_NUM_TRABAJO = MIG.GPT_TBJ_NUM_TRABAJO

			     WHERE gpT_tbj_num_trabajo NOT IN 
                   (select gpT_tbj_num_trabajo from '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
                     where gpT_tbj_num_trabajo is not null
                     GROUP BY gpT_tbj_num_trabajo
                     HAVING COUNT(1) > 1)
					AND MIG.VALIDACION = 0

                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_1||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''10''); END;';
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

--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GPR_PROVISION_GASTOS -> PRG_PROVISION_GASTOS
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
MAX_NUM_PROVISION NUMBER(20,0) := 0;
V_NUM_TABLAS NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'PRG_PROVISION_GASTOS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GPR_PROVISION_GASTOS';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
          --Inicio del proceso de volcado sobre PRG_PROVISION_GASTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                PRG_ID,
                PRG_NUM_PROVISION,
                DD_EPR_ID,
                PRG_FECHA_ALTA,
                PVE_ID_GESTORIA,
                PRG_FECHA_ENVIO,
                PRG_FECHA_RESPUESTA,
                PRG_FECHA_ANULACION,
                VERSION,
                USUARIOCREAR,
                FECHACREAR,
                BORRADO
                )
                WITH INSERTAR AS (
			    SELECT
				  	  MIGW.GPR_NUMERO_PROVISION_FONDOS                                        
					  ,EPR.DD_EPR_ID                                                                             
					  ,MIGW.GPR_FECHA_ALTA                                                                           
					  ,PVE.PVE_ID                                                                                    
					  ,MIGW.GPR_FECHA_ENVIO                                                                                   
					  ,MIGW.GPR_FECHA_RESPUESTA                                                                                 
					  ,MIGW.GPR_FECHA_ANULACION
					  ,ROW_NUMBER() OVER (PARTITION BY MIGW.GPR_NUMERO_PROVISION_FONDOS ORDER BY MIGW.GPR_FECHA_RESPUESTA DESC) ORDEN
			    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
			    INNER JOIN '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO EPR ON EPR.DD_EPR_CODIGO = MIGW.GPR_COD_ESTADO_PROVISION
			    INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_PRINEX =  MIGW.GPR_COD_GESTORIA AND PVE.PVE_FECHA_BAJA IS NULL
					   AND PVE.DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''01'')
				WHERE MIGW.VALIDACION = 0
			 
				)
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                 PRG_ID, 
                MIG.GPR_NUMERO_PROVISION_FONDOS                         PRG_NUM_PROVISION,
                MIG.DD_EPR_ID                                           DD_EPR_ID,
                MIG.GPR_FECHA_ALTA                                      PRG_FECHA_ALTA,
                MIG.PVE_ID                                              PVE_ID_GESTORIA,
                MIG.GPR_FECHA_ENVIO                                     PRG_FECHA_ENVIO,
                MIG.GPR_FECHA_RESPUESTA                                 PRG_FECHA_RESPUESTA,
                MIG.GPR_FECHA_ANULACION                                 PRG_FECHA_ANULACION,
                ''0''                                                   VERSION,                                                                                
                '''||V_USUARIO||'''                                 USUARIOCREAR,
				SYSDATE                                                 FECHACREAR,     
				0                                                       BORRADO
                FROM INSERTAR MIG
                WHERE ORDEN = 1

                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
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

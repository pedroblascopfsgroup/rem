--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_SUB_SUBSANACIONES -> SUB_SUBSANACIONES
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
V_TABLA VARCHAR2(40 CHAR) := 'SUB_SUBSANACIONES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_SUB_SUBSANACIONES';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
      
      --Inicio del proceso de volcado sobre SUB_SUBSANACIONES
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA:= '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' SUB (
                SUB_ID                  ,
                ECO_ID                  ,
                DD_ESU_ID               ,
                SUB_PETICIONARIO        ,
                SUB_MOTIVO              ,
                SUB_FECHA_PETICION      ,
                SUB_GASTOS_SUBSANACION  ,
                SUB_GASTOS_INSCRIPCION  ,
                VERSION                 ,
                USUARIOCREAR            ,
                FECHACREAR       )
           SELECT
                '||V_ESQUEMA||'.S_SUB_SUBSANACIONES.NEXTVAL     ,
                ECO.ECO_ID                                      ,
                ESU.DD_ESU_ID                                   ,
                SUB_PETICIONARIO                                ,
                SUB_MOTIVO                                      ,
                SUB_FECHA_PETICION                              ,
                SUB_GASTOS_SUBSANACION                          ,
                SUB_GASTOS_INSCRIPCION                          ,
                0                                               ,
                '''||V_USUARIO||'''                                        ,
                SYSDATE
           FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_NUM_EXPEDIENTE = MIG.SUB_COD_OFERTA
                LEFT  JOIN '||V_ESQUEMA||'.DD_ESU_ESTADOS_SUBSANACION ESU ON ESU.DD_ESU_CODIGO = MIG.SUB_COD_ESTADO_SUBSANACION
		   WHERE MIG.VALIDACION = 0';
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
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

--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_PAC_PERIMETRO_ACTIVO -> ACT_PAC_PERIMETRO_ACTIVO
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
V_USUARIO VARCHAR2(50 CHAR) := 'TRASPASO_TANGO';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PAC_PERIMETRO_ACTIVO';
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
          PAC_ID
          ,ACT_ID
          ,PAC_INCLUIDO
          ,PAC_CHECK_TRA_ADMISION
          ,PAC_FECHA_TRA_ADMISION
          ,PAC_MOTIVO_TRA_ADMISION
          ,PAC_CHECK_GESTIONAR
          ,PAC_FECHA_GESTIONAR
          ,PAC_MOTIVO_GESTIONAR
          ,PAC_CHECK_ASIGNAR_MEDIADOR
          ,PAC_FECHA_ASIGNAR_MEDIADOR
          ,PAC_MOTIVO_ASIGNAR_MEDIADOR
          ,PAC_CHECK_COMERCIALIZAR
          ,PAC_FECHA_COMERCIALIZAR
          ,DD_MCO_ID
          ,PAC_CHECK_FORMALIZAR
          ,PAC_FECHA_FORMALIZAR
          ,PAC_MOTIVO_FORMALIZAR
          ,VERSION
          ,USUARIOCREAR
          ,FECHACREAR
          ,BORRADO
          ,PAC_MOT_EXCL_COMERCIALIZAR
        )
        SELECT 
          '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                               AS PAC_ID,
          AUX.*
        FROM (      
          SELECT DISTINCT      
          ACT.ACT_ID,      
          MIG2.PAC_IND_INCLUIDO                                                                  AS PAC_INCLUIDO,
                  MIG2.PAC_IND_CHECK_TRA_ADMISION                                                                                                         AS PAC_CHECK_TRA_ADMISION,
                  MIG2.PAC_FECHA_TRA_ADMISION                                                                                                                 AS PAC_FECHA_TRA_ADMISION,
                  MIG2.PAC_MOTIVO_TRA_ADMISION                                                                                                              AS PAC_MOTIVO_TRA_ADMISION,
                  MIG2.PAC_IND_CHECK_GESTIONAR                                                                                                              AS PAC_CHECK_GESTIONAR,
                  MIG2.PAC_FECHA_GESTIONAR                                                                                                                                AS PAC_FECHA_GESTIONAR,
                  MIG2.PAC_MOTIVO_GESTIONAR                                                                                                                             AS PAC_MOTIVO_GESTIONAR,
                  MIG2.PAC_IND_CHECK_ASIG_MEDIA                                                                                                             AS PAC_CHECK_ASIGNAR_MEDIADOR,
                  MIG2.PAC_FECHA_ASIGNAR_MEDIADOR                                                                                                       AS PAC_FECHA_ASIGNAR_MEDIADOR,
                  MIG2.PAC_MOTIVO_ASIGNAR_MEDIADOR                                                                                                    AS PAC_MOTIVO_ASIGNAR_MEDIADOR,
                  MIG2.PAC_IND_CHECK_COMERCIALIZAR                                                                                                      AS PAC_CHECK_COMERCIALIZAR,
                  MIG2.PAC_FECHA_COMERCIALIZAR                                                                                                              AS PAC_FECHA_COMERCIALIZAR,
                  MCO.DD_MCO_ID                                                                                                                                              AS DD_MCO_ID,
                  MIG2.PAC_IND_CHECK_FORMALIZAR                                                                                                                 AS PAC_CHECK_FORMALIZAR,
                  MIG2.PAC_FECHA_FORMALIZAR                                                                                                                                   AS PAC_FECHA_FORMALIZAR,
                  MIG2.PAC_MOTIVO_FORMALIZAR                                                                                                                          AS PAC_MOTIVO_FORMALIZAR,
          0                                                                                                               AS VERSION, 
          '''||V_USUARIO||'''                                                                                        AS USUARIOCREAR,                            
          SYSDATE                                                                                               AS FECHACREAR,                             
          0                                                                                                         AS BORRADO,
          MNC.DD_MNC_DESCRIPCION                                                                                AS PAC_MOT_EXCL_COMERCIALIZAR
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG2.PAC_NUMERO_ACTIVO
          LEFT JOIN '||V_ESQUEMA||'.DD_MCO_MOTIVO_COMERCIALIZACION MCO ON MCO.DD_MCO_CODIGO = MIG2.PAC_COD_MOTIVO_COMERCIAL
          LEFT JOIN '||V_ESQUEMA||'.DD_MNC_MOT_NOCOMERCIALIZACION MNC ON MNC.DD_MNC_CODIGO = MIG2.PAC_COD_MOTIVO_NOCOMERCIAL
          LEFT JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO PAC2 ON PAC2.ACT_ID = ACT.ACT_ID
		      WHERE MIG2.VALIDACION = 0 AND PAC2.PAC_ID IS NULL
        ) AUX
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
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

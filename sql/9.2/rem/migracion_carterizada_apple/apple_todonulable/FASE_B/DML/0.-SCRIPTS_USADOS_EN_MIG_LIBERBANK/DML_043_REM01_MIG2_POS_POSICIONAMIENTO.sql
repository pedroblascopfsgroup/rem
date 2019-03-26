--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_POS_POSICIONAMIENTO -> POS_POSICIONAMIENTO
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
V_TABLA VARCHAR2(40 CHAR) := 'POS_POSICIONAMIENTO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_POS_POSICIONAMIENTO';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
    
      --Inicio del proceso de volcado sobre POS_POSICIONAMIENTO
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' POS (
              POS_ID
              ,ECO_ID
              ,POS_FECHA_AVISO
              ,POS_NOTARIA
              ,POS_FECHA_POSICIONAMIENTO
              ,POS_MOTIVO_APLAZAMIENTO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
              ,PVE_ID_NOTARIO
          )
          SELECT 
              '||V_ESQUEMA||'.S_POS_POSICIONAMIENTO.NEXTVAL             AS POS_ID,
              AUX.*
          FROM (
            SELECT DISTINCT
              ECO.ECO_ID                                                                    AS ECO_ID,
              MIG2.POS_FECHA_AVISO                                                  AS POS_FECHA_AVISO,
              NULL                                                                             AS POS_NOTARIA,                            
              MIG2.POS_FECHA_POSICIONAMIENTO                              AS POS_FECHA_POSICIONAMIENTO,
              MIG2.POS_MOTIVO_APLAZAMIENTO                                 AS POS_MOTIVO_APLAZAMIENTO,
              0                                                                                  AS VERSION,
              '''||V_USUARIO||'''                                                                           AS USUARIOCREAR,
              SYSDATE                                                                     AS FECHACREAR,
              0                                                                                 AS BORRADO,
              PVE.PVE_ID                                                                  AS PVE_ID_NOTARIO
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
            INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG2.POS_COD_OFERTA AND OFR.BORRADO = 0
            INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_PRINEX = MIG2.POS_COD_NOTARIO AND PVE.PVE_FECHA_BAJA IS NULL AND PVE.BORRADO = 0 
            LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID  AND TPR.DD_TPR_CODIGO = ''21'' AND TPR.BORRADO = 0
          	WHERE MIG2.VALIDACION = 0
			) AUX
      '
      ;
      
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

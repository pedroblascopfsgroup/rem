--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_PRD_PROVEEDOR_DIRECCION' -> 'ACT_PRD_PROVEEDOR_DIRECCION'
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
      V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
      V_TABLA VARCHAR2(40 CHAR) := 'ACT_PRD_PROVEEDOR_DIRECCION';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PRD_PROVEEDOR_DIRECCION';
      V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN 
     
      --Inicio del proceso de volcado sobre ACT_PRD_PROVEEDOR_DIRECCION
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE ('
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                  PRD_ID,
                  PVE_ID,
                  DD_TDP_ID,
                  DD_TVI_ID,
                  PRD_NOMBRE,
                  PRD_NUM,
                  PRD_PTA,
                  DD_UPO_ID,
                  DD_PRV_ID,
                  PRD_CP,
                  PRD_TELEFONO,
                  PRD_EMAIL,
                  DD_LOC_ID,
                  VERSION,
                  USUARIOCREAR,
                  FECHACREAR,
                  BORRADO,
                  PVE_COD_DIRECC_UVEM
            )
            SELECT 
                  '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                               PRD_ID,
                  PVE.PVE_ID                                                                                                                    PVE_ID,
                  TDP.DD_TDP_ID                                                                                                         DD_TDP_ID,
                  TVI.DD_TVI_ID                                                                                                         DD_TVI_ID,
                  MIG.PRD_NOMBRE                                                                                                                PRD_NOMBRE,
                  MIG.PRD_NUMERO                                                                                                                PRD_NUM,
                  MIG.PRD_PUERTA                                                                                                                PRD_PTA,
                  UPO.DD_UPO_ID                                                                                                         DD_UPO_ID,
                  PRV.DD_PRV_ID                                                                                                         DD_PRV_ID,
                  MIG.PRD_CODIGO_POSTAL                                                                                         PRD_CP,
                  MIG.PRD_TELEFONO                                                                                                      PRD_TELEFONO,
                  MIG.PRD_EMAIL                                                                                                         PRD_EMAIL,
                  LOC.DD_LOC_ID                                                                                                         DD_LOC_ID,
                  0                                                                   VERSION,
                  '''||V_USUARIO||'''                                                            USUARIOCREAR,
                  SYSDATE                                                             FECHACREAR,
                  0                                                                   BORRADO,
                  MIG.PVD_COD_DIRECCION                             PVE_COD_DIRECC_UVEM
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG          
                INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON (PVE.PVE_COD_PRINEX = MIG.PVE_COD_UVEM OR (MIG.PVE_COD_UVEM IS NULL AND PVE.PVE_COD_REM = MIG.PVE_REM_ID) AND PVE.PVE_FECHA_BAJA IS NULL)
                INNER JOIN '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR TDP ON TDP.DD_TDP_CODIGO = MIG.PRD_COD_TIPO_DIRECCION AND TDP.BORRADO = 0
                INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA TVI ON TVI.DD_TVI_CODIGO = MIG.PRD_COD_TIPO_VIA AND TVI.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_UPO_UNID_POBLACIONAL UPO  ON UPO.DD_UPO_CODIGO = TRIM(LEADING 0 FROM MIG.PRD_COD_UNIDADPOBLACIONAL) AND UPO.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = MIG.PRD_COD_PROVINCIA AND PRV.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG.PRD_COD_LOCALIDAD AND LOC.BORRADO = 0
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

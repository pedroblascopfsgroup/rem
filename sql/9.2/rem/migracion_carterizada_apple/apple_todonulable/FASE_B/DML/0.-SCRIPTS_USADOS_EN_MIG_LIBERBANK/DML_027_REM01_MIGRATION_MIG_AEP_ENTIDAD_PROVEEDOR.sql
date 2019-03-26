--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AEP_ENTIDAD_PROVEEDOR' -> 'ACT_ETP_ENTIDAD_PROVEEDOR'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ETP_ENTIDAD_PROVEEDOR';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AEP_ENTIDAD_PROVEEDOR';
V_SENTENCIA VARCHAR2(1600 CHAR);

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR (
	  ETP_ID,
	  DD_CRA_ID,
	  PVE_ID,
	  DD_TCL_ID,
	  ETP_FECHA_CONTRATO,
	  ETP_FECHA_INICIO,
	  ETP_FECHA_FIN,
	  ETP_ESTADO,
	  VERSION,
	  USUARIOCREAR,
	  FECHACREAR,
	  BORRADO
		)
	SELECT
	  '||V_ESQUEMA||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL	  			ETP_ID,
	  CRA.DD_CRA_ID                           							DD_CRA_ID,
	  PVE.PVE_ID                              							PVE_ID,
	  TCL.DD_TCL_ID                           							DD_TCL_ID,
	  MIG.ETP_FECHA_CONTRATO                                            ETP_FECHA_CONTRATO,
	  MIG.ETP_FECHA_INI                                                 ETP_FECHA_INICIO,
	  MIG.ETP_FECHA_FIN                                                 ETP_FECHA_FIN,
	  MIG.ETP_ESTADO                                                    ETP_ESTADO,
	  ''0''                                                             VERSION,
	  '''||V_USUARIO||'''                                                 USUARIOCREAR,
      SYSDATE                                                           FECHACREAR,
      0                                                                 BORRADO  
	FROM MIG_AEP_ENTIDAD_PROVEEDOR MIG
    INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
      ON PVE.PVE_COD_PRINEX = MIG.PVE_DOCIDENTIF AND PVE.PVE_FECHA_BAJA IS NULL
    INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
      ON CRA.DD_CRA_CODIGO = MIG.ENTIDAD_PROPIETARIA
    LEFT JOIN '||V_ESQUEMA||'.DD_TCL_TIPO_COLABORACION TCL
      ON TCL.DD_TCL_CODIGO = MIG.TIPO_COLABORACION
    WHERE NOT EXISTS (
		  SELECT 1 
		  FROM '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR ETPW
		  WHERE ETPW.PVE_ID = PVE.PVE_ID 
		  AND ETPW.DD_CRA_ID = CRA.DD_CRA_ID
		)
	AND MIG.VALIDACION = 0 
	')
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

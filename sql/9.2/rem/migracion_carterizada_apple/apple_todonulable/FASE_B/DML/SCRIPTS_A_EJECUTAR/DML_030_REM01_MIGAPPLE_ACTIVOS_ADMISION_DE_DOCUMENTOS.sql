--/*
--#########################################
--## AUTOR=PABLO MESEGUER
--## FECHA_CREACION=20170208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ADD_ADMISION_DOC_BNK' -> 'ACT_ADO_ADMISION_DOCUMENTO'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ADO_ADMISION_DOCUMENTO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ADD_ADMISION_DOC';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_SENTENCIA VARCHAR2(1600 CHAR);

BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS ADMISION DE DOCUMENTOS');

    -------------------------------------------------
    --INSERCION EN ACT_ADO_ADMISION_DOCUMENTO--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_ADO_ADMISION_DOCUMENTO');
  
    
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		ADO_ID,
		ACT_ID,
		CFD_ID,
		DD_EDC_ID,
		ADO_APLICA,
		ADO_REF_DOC,
		ADO_NUM_DOC,
		ADO_FECHA_VERIFICADO,
		ADO_FECHA_SOLICITUD,
		ADO_FECHA_EMISION,
		ADO_FECHA_OBTENCION,
		ADO_FECHA_CADUCIDAD,
		ADO_FECHA_ETIQUETA,
		ADO_FECHA_CALIFICACION,
		DD_TCE_ID,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT
		'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL								ADO_ID,
		ACT.ACT_ID															ACT_ID,
		CFD.CFD_ID															CFD_ID,
		EDC.DD_EDC_ID														DD_EDC_ID,
		MIG.ADO_APLICA														ADO_APLICA,
		SUBSTR(MIG.ADO_REF_DOC,0,48)					                    ADO_REF_DOC,
		MIG.ADO_NUM_DOCUMENTO                                               ADO_NUM_DOC,					
		MIG.ADO_FECHA_VERIFICACION											ADO_FECHA_VERIFICADO,
		MIG.ADO_FECHA_SOLICITUD												ADO_FECHA_SOLICITUD,
		MIG.ADO_FECHA_EMISION												ADO_FECHA_EMISION,
		MIG.ADO_FECHA_OBTENCION												ADO_FECHA_OBTENCION,
		MIG.ADO_FECHA_CADUCIDAD												ADO_FECHA_CADUCIDAD,
		MIG.ADO_FECHA_ETIQUETA												ADO_FECHA_ETIQUETA,
		MIG.ADO_FECHA_CALIFICACION											ADO_FECHA_CALIFICACION,
		TCE.DD_TCE_ID														DD_TCE_ID,
		''0''                                                 				VERSION,
		'''||V_USUARIO||'''                                               	USUARIOCREAR,
		SYSDATE                                               				FECHACREAR,
		0                                                     				BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 						MIG
	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO 			TPD
		ON TPD.DD_TPD_CODIGO = MIG.TIPO_DOCUMENTO
	INNER JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO 		CFD
		ON TPD.DD_TPD_ID = CFD.DD_TPD_ID 
	   AND ACT.DD_TPA_ID = CFD.DD_TPA_ID
	LEFT JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO 			EDC 
		ON EDC.DD_EDC_CODIGO = MIG.ESTADO_DOCUMENTO
	LEFT JOIN '||V_ESQUEMA||'.DD_TCE_TIPO_CALIF_ENERGETICA 		TCE
		ON TCE.DD_TCE_CODIGO = MIG.ADO_CALIFICACION
	WHERE MIG.VALIDACION = 0
  ');	
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS ADMISION DE DOCUMENTOS');
  
  
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

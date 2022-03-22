--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-17293
--## PRODUCTO=NO
--## 
--## Finalidad:
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17293';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(2000 CHAR);
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
	V_TABLA VARCHAR2(40 CHAR) := 'ACT_ADO_ADMISION_DOCUMENTO';
	V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';


BEGIN
  
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
   V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE 
      
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		ADO_ID,
		ACT_ID,
		CFD_ID,
		DD_EDC_ID,
		ADO_APLICA,
		ADO_REF_DOC,
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
		ACT2.ACT_ID															ACT_ID,
		ADO.CFD_ID															CFD_ID,
		ADO.DD_EDC_ID														DD_EDC_ID,
		ADO.ADO_APLICA														ADO_APLICA,
		ADO.ADO_REF_DOC														ADO_REF_DOC,
		ADO.ADO_FECHA_VERIFICADO											ADO_FECHA_VERIFICADO,
		ADO.ADO_FECHA_SOLICITUD												ADO_FECHA_SOLICITUD,
		ADO.ADO_FECHA_EMISION												ADO_FECHA_EMISION,
		ADO.ADO_FECHA_OBTENCION												ADO_FECHA_OBTENCION,
		ADO.ADO_FECHA_CADUCIDAD												ADO_FECHA_CADUCIDAD,
		ADO.ADO_FECHA_ETIQUETA												ADO_FECHA_ETIQUETA,
		ADO.ADO_FECHA_CALIFICACION											ADO_FECHA_CALIFICACION,
		ADO.DD_TCE_ID														DD_TCE_ID,
		''0''                                                 				VERSION,
		'''||V_USUARIO||'''                                               	USUARIOCREAR,
		SYSDATE                                               				FECHACREAR,
		ADO.BORRADO                                                     				BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ADO ON ADO.ACT_ID = ACT.ACT_ID
	')
	;	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
  COMMIT;
  
  EXECUTE IMMEDIATE 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
  
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

--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190224
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3398
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 
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

	-- Variables
	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3398';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(2000 CHAR);
	
    V_TABLA VARCHAR2(40 CHAR) := 'BIE_VALORACIONES';
    V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_TAS_TASACION';
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_SEGREG_SAREB';


BEGIN

  
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' se cargará.');
  
  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA BIE_VALORACIONES');
        
    ELSE
  
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	BIE_VAL_ID,
	BIE_ID,
	BIE_IMPORTE_VALOR_TASACION,
	BIE_FECHA_VALOR_TASACION,
	BIE_F_SOL_TASACION,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
  )
  SELECT
	'||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL						BIE_VAL_ID,
	ACT2.BIE_ID                                                	  	BIE_ID,
	VAL.BIE_IMPORTE_VALOR_TASACION									BIE_IMPORTE_VALOR_TASACION,
	VAL.BIE_FECHA_VALOR_TASACION									BIE_FECHA_VALOR_TASACION,
	VAL.BIE_F_SOL_TASACION											BIE_F_SOL_TASACION,
	''0''                                                           VERSION,
	'''||V_USUARIO||'''                                             USUARIOCREAR,
	SYSDATE                                                         FECHACREAR,
	0                                                               BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' VAL ON ACT.BIE_ID = VAL.BIE_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
  
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
	
	END IF;

    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' se cargará.');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_TAS_TASACION');
        
    ELSE
	
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
		TAS_ID,
		ACT_ID,
		BIE_VAL_ID,
		DD_TTS_ID,
		TAS_FECHA_INI_TASACION,
		TAS_FECHA_RECEPCION_TASACION,
		TAS_CODIGO_FIRMA,
		TAS_NOMBRE_TASADOR,
		TAS_IMPORTE_TAS_FIN,
		TAS_COSTE_REPO_NETO_ACTUAL,
		TAS_COSTE_REPO_NETO_FINALIZADO,
		TAS_COEF_MERCADO_ESTADO,
		TAS_COEF_POND_VALOR_ANYADIDO,
		TAS_VALOR_REPER_SUELO_CONST,
		TAS_COSTE_CONST_CONST,
		TAS_INDICE_DEPRE_FISICA,
		TAS_INDICE_DEPRE_FUNCIONAL,
		TAS_INDICE_TOTAL_DEPRE,
		TAS_COSTE_CONST_DEPRE,
		TAS_COSTE_UNI_REPO_NETO,
		TAS_COSTE_REPOSICION,
		TAS_PORCENTAJE_OBRA,
		TAS_IMPORTE_VALOR_TER,
		TAS_ID_TEXTO_ASOCIADO,
		TAS_IMPORTE_VAL_LEGAL_FINCA,
		TAS_IMPORTE_VAL_SOLAR,
		TAS_OBSERVACIONES,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT
		'||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL							TAS_ID,
		ACT2.ACT_ID     													ACT_ID,
		BIE_VAL.BIE_VAL_ID                                      			BIE_VAL_ID,
		VAL.DD_TTS_ID														DD_TTS_ID,
		VAL.TAS_FECHA_INI_TASACION											TAS_FECHA_INI_TASACION,
		VAL.TAS_FECHA_RECEPCION_TASACION									TAS_FECHA_RECEPCION_TASACION,
		VAL.TAS_CODIGO_FIRMA												TAS_CODIGO_FIRMA,
		VAL.TAS_NOMBRE_TASADOR												TAS_NOMBRE_TASADOR,
		VAL.TAS_IMPORTE_TAS_FIN												TAS_IMPORTE_TAS_FIN,
		VAL.TAS_COSTE_REPO_NETO_ACTUAL										TAS_COSTE_REPO_NETO_ACTUAL,
		VAL.TAS_COSTE_REPO_NETO_FINALIZADO									TAS_COSTE_REPO_NETO_FINALIZADO,
		VAL.TAS_COEF_MERCADO_ESTADO											TAS_COEF_MERCADO_ESTADO,
		VAL.TAS_COEF_POND_VALOR_ANYADIDO									TAS_COEF_POND_VALOR_ANYADIDO,
		VAL.TAS_VALOR_REPER_SUELO_CONST                         			TAS_VALOR_REPER_SUELO_CONST,
		VAL.TAS_COSTE_CONST_CONST                               			TAS_COSTE_CONST_CONST,
		VAL.TAS_INDICE_DEPRE_FISICA                             			TAS_INDICE_DEPRE_FISICA,
		VAL.TAS_INDICE_DEPRE_FUNCIONAL                          			TAS_INDICE_DEPRE_FUNCIONAL,
		VAL.TAS_INDICE_TOTAL_DEPRE                              			TAS_INDICE_TOTAL_DEPRE,
		VAL.TAS_COSTE_CONST_DEPRE                               			TAS_COSTE_CONST_DEPRE,
		VAL.TAS_COSTE_UNI_REPO_NETO                             			TAS_COSTE_UNI_REPO_NETO,
		VAL.TAS_COSTE_REPOSICION                                			TAS_COSTE_REPOSICION,
		VAL.TAS_PORCENTAJE_OBRA                                 			TAS_PORCENTAJE_OBRA,
		VAL.TAS_IMPORTE_VALOR_TER                               			TAS_IMPORTE_VALOR_TER,
		VAL.TAS_ID_TEXTO_ASOCIADO                               			TAS_ID_TEXTO_ASOCIADO,
		VAL.TAS_IMPORTE_VAL_LEGAL_FINCA                         			TAS_IMPORTE_VAL_LEGAL_FINCA,
		VAL.TAS_IMPORTE_VAL_SOLAR                               			TAS_IMPORTE_VAL_SOLAR,
		VAL.TAS_OBSERVACIONES                                   			TAS_OBSERVACIONES,
		''0''                                                 				VERSION,
		'''||V_USUARIO||'''                                               	USUARIOCREAR,
		SYSDATE                                               				FECHACREAR,
		0                                                     				BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' VAL ON ACT.ACT_ID = VAL.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' BIE_VAL ON ACT2.BIE_ID = BIE_VAL.BIE_ID
	')
	;
	
  
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  -- ACTUALIZAMOS EL CAMPO TAS_ID_EXTERNO CON LOS DATOS DE FASE 1
	END IF;
  
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' se analizará.');
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' analizada.');
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' se analizará.');
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
	DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' analizada.');

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

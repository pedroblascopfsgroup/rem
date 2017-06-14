--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ATA_TASACIONES_ACTIVO' -> 'ACT_TAS_TASACION', 'BIE_VALORACIONES'
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

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#'; --#ESQUEMA#
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#'; --#ESQUEMA_MASTER#
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'BIE_VALORACIONES';
V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_TAS_TASACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATA_TASACIONES_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
  --REGISTRAMOS TAS_ID Y BIE_VAL_ID
  
  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  SET
  BIE_VAL_ID = S_BIE_VALORACIONES.NEXTVAL,
  TAS_ID = S_ACT_TAS_TASACION.NEXTVAL
  WHERE BIE_VAL_ID IS NULL
  OR TAS_ID IS NULL
  ')
  ; 
  
  --DAMOS REGISTROS EN ALTA BIE_VALORACIONES PARA LOS ACTIVOS QUE TRATAMOS
  
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA||'.');
  
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
  WITH ACTIVOS AS (
	SELECT 
	ACT_ID, BIE_VAL_ID, TAS_ID, BIE_ID, MIG.ACT_NUMERO_ACTIVO, MIG.TAS_IMPORTE_VALOR_TASACION, MIG.TAS_FECHA_FIN_TASACION, MIG.TAS_F_SOL_TASACION
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
	ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.VALIDACION = 0
  )
  SELECT
  ACT.BIE_VAL_ID													BIE_VAL_ID,
  ACT.BIE_ID                                                	  	BIE_ID,
  ACT.TAS_IMPORTE_VALOR_TASACION									BIE_IMPORTE_VALOR_TASACION,
  ACT.TAS_FECHA_FIN_TASACION										BIE_FECHA_VALOR_TASACION,
  ACT.TAS_F_SOL_TASACION											BIE_F_SOL_TASACION,
  ''0''                                                             VERSION,
  '''||V_USUARIO||'''                                                           USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  0                                                                 BORRADO
  FROM ACTIVOS ACT
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' BIE 
    WHERE BIE.BIE_ID = (SELECT BIE_ID
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT2
    WHERE ACT2.ACT_ID = ACT.ACT_ID)
   )
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA_2||'.');
  
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
	BORRADO,
	TAS_ID_EXTERNO
	)
	WITH MIG_TASACIONES AS (
		SELECT DISTINCT 
		ACT.ACT_ID,
		MIG.ACT_NUMERO_ACTIVO,
		MIG.BIE_VAL_ID,
		MIG.TAS_ID,
		MIG.TAS_CODIGO_TASA_UVEM,
		MIG.TAS_TIPO_TASACION,
		MIG.TAS_FECHA_INI_TASACION,				
		MIG.TAS_FECHA_RECEPCION_TASACION,	
		MIG.TAS_CODIGO_FIRMA,				
		MIG.TAS_NOMBRE_TASADOR,				
		MIG.TAS_IMPORTE_TAS_FIN,				
		MIG.TAS_COSTE_REPO_NETO_ACTUAL,		
		MIG.TAS_COSTE_REPO_NETO_FINALIZADO,	
		MIG.TAS_COEF_MERCADO_ESTADO,			
		MIG.TAS_COEF_POND_VALOR_ANYADIDO,	
		MIG.TAS_VALOR_REPER_SUELO_CONST,     
		MIG.TAS_COSTE_CONST_CONST,           
		MIG.TAS_INDICE_DEPRE_FISICA ,        
		MIG.TAS_INDICE_DEPRE_FUNCIONAL,      
		MIG.TAS_INDICE_TOTAL_DEPRE,          
		MIG.TAS_COSTE_CONST_DEPRE,           
		MIG.TAS_COSTE_UNI_REPO_NETO,         
		MIG.TAS_COSTE_REPOSICION,            
		MIG.TAS_PORCENTAJE_OBRA,             
		MIG.TAS_IMPORTE_VALOR_TER,           
		MIG.TAS_ID_TEXTO_ASOCIADO,           
		MIG.TAS_IMPORTE_VAL_LEGAL_FINCA ,    
		MIG.TAS_IMPORTE_VAL_SOLAR,           
		MIG.TAS_OBSERVACIONES
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
		INNER JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE
		ON BIE.BIE_ID = ACT.BIE_ID
		WHERE MIG.VALIDACION = 0
	)
	SELECT
	MIG.TAS_ID															TAS_ID,
	MIG.ACT_ID     														ACT_ID,
	MIG.BIE_VAL_ID                                      				BIE_VAL_ID,
	(SELECT DD_TTS_ID
	FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION
	WHERE DD_TTS_CODIGO = MIG.TAS_TIPO_TASACION)						DD_TTS_ID,
	MIG.TAS_FECHA_INI_TASACION											TAS_FECHA_INI_TASACION,
	MIG.TAS_FECHA_RECEPCION_TASACION									TAS_FECHA_RECEPCION_TASACION,
	MIG.TAS_CODIGO_FIRMA												TAS_CODIGO_FIRMA,
	MIG.TAS_NOMBRE_TASADOR												TAS_NOMBRE_TASADOR,
	MIG.TAS_IMPORTE_TAS_FIN												TAS_IMPORTE_TAS_FIN,
	MIG.TAS_COSTE_REPO_NETO_ACTUAL										TAS_COSTE_REPO_NETO_ACTUAL,
	MIG.TAS_COSTE_REPO_NETO_FINALIZADO									TAS_COSTE_REPO_NETO_FINALIZADO,
	MIG.TAS_COEF_MERCADO_ESTADO											TAS_COEF_MERCADO_ESTADO,
	MIG.TAS_COEF_POND_VALOR_ANYADIDO									TAS_COEF_POND_VALOR_ANYADIDO,
	MIG.TAS_VALOR_REPER_SUELO_CONST                         			TAS_VALOR_REPER_SUELO_CONST,
	MIG.TAS_COSTE_CONST_CONST                               			TAS_COSTE_CONST_CONST,
	MIG.TAS_INDICE_DEPRE_FISICA                             			TAS_INDICE_DEPRE_FISICA,
	MIG.TAS_INDICE_DEPRE_FUNCIONAL                          			TAS_INDICE_DEPRE_FUNCIONAL,
	MIG.TAS_INDICE_TOTAL_DEPRE                              			TAS_INDICE_TOTAL_DEPRE,
	MIG.TAS_COSTE_CONST_DEPRE                               			TAS_COSTE_CONST_DEPRE,
	MIG.TAS_COSTE_UNI_REPO_NETO                             			TAS_COSTE_UNI_REPO_NETO,
	MIG.TAS_COSTE_REPOSICION                                			TAS_COSTE_REPOSICION,
	MIG.TAS_PORCENTAJE_OBRA                                 			TAS_PORCENTAJE_OBRA,
	MIG.TAS_IMPORTE_VALOR_TER                               			TAS_IMPORTE_VALOR_TER,
	MIG.TAS_ID_TEXTO_ASOCIADO                               			TAS_ID_TEXTO_ASOCIADO,
	MIG.TAS_IMPORTE_VAL_LEGAL_FINCA                         			TAS_IMPORTE_VAL_LEGAL_FINCA,
	MIG.TAS_IMPORTE_VAL_SOLAR                               			TAS_IMPORTE_VAL_SOLAR,
	MIG.TAS_OBSERVACIONES                                   			TAS_OBSERVACIONES,
	''0''                                                 				VERSION,
	'''||V_USUARIO||'''                                               	USUARIOCREAR,
	SYSDATE                                               				FECHACREAR,
	0                                                     				BORRADO,
	MIG.TAS_CODIGO_TASA_UVEM											TAS_ID_EXTERNO	
	FROM MIG_TASACIONES MIG
	WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_2||' CRG 
    WHERE CRG.ACT_ID = MIG.ACT_ID
    )
	')
	;
	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  -- ACTUALIZAMOS EL CAMPO TAS_ID_EXTERNO CON LOS DATOS DE FASE 1
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO TAS_ID_EXTERNO EN '||V_ESQUEMA||'.'||V_TABLA_2||' DESDE FASE 1.');
  
	EXECUTE IMMEDIATE ('
	MERGE INTO ACT_TAS_TASACION TAS
	USING
	(
		SELECT TAS.BIE_VAL_ID, ATA.TAS_CODIGO_TASA_UVEM FROM '||V_ESQUEMA||'.MIG_ATA_TASACIONES_ACTIVO ATA
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' TAS
		  ON TAS.BIE_VAL_ID = ATA.BIE_VAL_ID
		WHERE ATA.VALIDACION = 0
	) AUX
	ON (AUX.BIE_VAL_ID = TAS.BIE_VAL_ID)
	WHEN MATCHED THEN UPDATE SET
	  TAS.TAS_ID_EXTERNO = AUX.TAS_CODIGO_TASA_UVEM,
	  TAS.USUARIOMODIFICAR = '''||V_USUARIO||''',
	  TAS.FECHAMODIFICAR = SYSDATE
	')
	;
  
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
	COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
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
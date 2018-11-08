--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ALA_LLAVES_ACTIVO' -> 'ACT_LLV_LLAVE'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_LLV_LLAVE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ALA_LLAVES_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
    EXECUTE IMMEDIATE '
    UPDATE '||V_ESQUEMA||'.'||V_TABLA_MIG||' ALA
    SET LLV_ID = '||V_ESQUEMA||'.S_ACT_LLV_LLAVE.NEXTVAL
    WHERE ALA.VALIDACION = 0
    AND ALA.LLV_ID IS NULL
    '
    ;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas. Update LLV_ID');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	LLV_ID,
	ACT_ID,
	LLV_COD_CENTRO,
	LLV_NOMBRE_CENTRO,
	LLV_ARCHIVO1,
	LLV_ARCHIVO2,
	LLV_ARCHIVO3,
	LLV_COMPLETO,
	LLV_MOTIVO_INCOMPLETO,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO,
	LLV_NUM_LLAVE
	)
	SELECT
	MIG.LLV_ID                              							LLV_ID,
	ACT.ACT_ID,
	MIG.LLV_COD_CENTRO													LLV_COD_CENTRO,
	MIG.LLV_NOMBRE_CENTRO												LLV_NOMBRE_CENTRO,
	MIG.LLV_ARCHIVO1													LLV_ARCHIVO1,
	MIG.LLV_ARCHIVO2													LLV_ARCHIVO2,
	MIG.LLV_ARCHIVO3													LLV_ARCHIVO3,
	MIG.LLV_COMPLETO													LLV_COMPLETO,
	MIG.LLV_MOTIVO_INCOMPLETO											LLV_MOTIVO_INCOMPLETO,
	''0''                                                 				VERSION,
	'''||V_USUARIO||'''                                               	USUARIOCREAR,
	SYSDATE                                               				FECHACREAR,
	0                                                     				BORRADO,
	MIG.LLV_CODIGO_UVEM													LLV_NUM_LLAVE
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.LLV_CODIGO_UVEM != 0
	  AND MIG.LLV_CODIGO_UVEM IS NOT NULL
	  AND MIG.VALIDACION IN (0, 1)
	')
	;
	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  -- UPDATE LLV_NUM_LLAVE DE FASE 1
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION DEL CAMPO LLV_NUM_LLAVE DE LOS ACTIVOS DE FASE 1 SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' LLV
        USING ( SELECT MIG.LLV_ID,MIG.LLV_CODIGO_UVEM 
				FROM MIG_ALA_LLAVES_ACTIVO MIG
				INNER JOIN ACT_LLV_LLAVE LLV
				  ON LLV.LLV_ID = MIG.LLV_ID
					WHERE LLV.USUARIOCREAR = ''MIG'' OR LLV.USUARIOCREAR = ''MIG2'' OR LLV.USUARIOCREAR = '''||V_USUARIO||'''
				AND MIG.VALIDACION IN (0, 1)
              ) AUX
                ON (AUX.LLV_ID = LLV.LLV_ID)
                WHEN MATCHED THEN UPDATE SET
		  LLV.LLV_NUM_LLAVE = AUX.LLV_CODIGO_UVEM
          ,LLV.USUARIOMODIFICAR = '''||V_USUARIO||'''
          ,LLV.FECHAMODIFICAR = SYSDATE
	
	')
	;
	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada. '||SQL%ROWCOUNT||' Filas.');
  
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

--/*
--#########################################
--## AUTOR=Maria Presencia Herrero
--## FECHA_CREACION=20181119
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2806
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
	V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2806';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(2000 CHAR);
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON_2';
	V_TABLA VARCHAR2(40 CHAR) := 'ACT_LLV_LLAVE';

BEGIN
    

    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_LLV_LLAVE');
        
    ELSE  
  
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
	'||V_ESQUEMA||'.S_ACT_LLV_LLAVE.NEXTVAL                          LLV_ID,
	ACT2.ACT_ID,
	LLV.LLV_COD_CENTRO													LLV_COD_CENTRO,
	LLV.LLV_NOMBRE_CENTRO												LLV_NOMBRE_CENTRO,
	LLV.LLV_ARCHIVO1													LLV_ARCHIVO1,
	LLV.LLV_ARCHIVO2													LLV_ARCHIVO2,
	LLV.LLV_ARCHIVO3													LLV_ARCHIVO3,
	LLV.LLV_COMPLETO													LLV_COMPLETO,
	LLV.LLV_MOTIVO_INCOMPLETO											LLV_MOTIVO_INCOMPLETO,
	''0''                                                 				VERSION,
	'''||V_USUARIO||'''                                               	USUARIOCREAR,
	SYSDATE                                               				FECHACREAR,
	0                                                     				BORRADO,
	null																LLV_NUM_LLAVE
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' LLV ON LLV.ACT_ID = ACT.ACT_ID
	')
	;
	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;

  
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

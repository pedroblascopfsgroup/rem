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
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_SEGREG_SAREB';
	V_TABLA VARCHAR2(40 CHAR) := 'ACT_CAT_CATASTRO';


BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

		
  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_CAT_CATASTRO');
        
    ELSE
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	CAT_ID,
	ACT_ID,
	CAT_REF_CATASTRAL,
	CAT_POLIGONO,
	CAT_PARCELA,
	CAT_TITULAR_CATASTRAL,
	CAT_SUPERFICIE_CONSTRUIDA,
	CAT_SUPERFICIE_UTIL,
	CAT_SUPERFICIE_REPER_COMUN,
	CAT_SUPERFICIE_PARCELA,
	CAT_SUPERFICIE_SUELO,
	CAT_VALOR_CATASTRAL_CONST,
	CAT_VALOR_CATASTRAL_SUELO,
	CAT_FECHA_REV_VALOR_CATASTRAL,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO,
	CAT_IND_INTERFAZ_BANKIA
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_CAT_CATASTRO.NEXTVAL							CAT_ID,
	ACT2.ACT_ID,
	AUX.REF_CATASTRAL												CAT_REF_CATASTRAL,
	CAT.CAT_POLIGONO													CAT_POLIGONO,
	CAT.CAT_PARCELA														CAT_PARCELA,
	CAT.CAT_TITULAR_CATASTRAL											CAT_TITULAR_CATASTRAL,
	CAT.CAT_SUPERFICIE_CONSTRUIDA										CAT_SUPERFICIE_CONSTRUIDA,
	CAT.CAT_SUPERFICIE_UTIL												CAT_SUPERFICIE_UTIL,
	CAT.CAT_SUPERFICIE_REPER_COMUN										CAT_SUPERFICIE_REPER_COMUN,
	CAT.CAT_SUPERFICIE_PARCELA											CAT_SUPERFICIE_PARCELA,
	CAT.CAT_SUPERFICIE_SUELO											CAT_SUPERFICIE_SUELO,
	CAT.CAT_VALOR_CATASTRAL_CONST										CAT_VALOR_CATASTRAL_CONST,
	CAT.CAT_VALOR_CATASTRAL_SUELO										CAT_VALOR_CATASTRAL_SUELO,
	CAT.CAT_FECHA_REV_VALOR_CATASTRAL									CAT_FECHA_REV_VALOR_CATASTRAL,
	''0''                                                 				VERSION,
	'''||V_USUARIO||'''                                               	USUARIOCREAR,
	SYSDATE                                               				FECHACREAR,
	0                                                     				BORRADO,
	CAT.CAT_IND_INTERFAZ_BANKIA											CAT_IND_INTERFAZ_BANKIA
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' CAT ON CAT.ACT_ID = ACT.ACT_ID
	');

	
  
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

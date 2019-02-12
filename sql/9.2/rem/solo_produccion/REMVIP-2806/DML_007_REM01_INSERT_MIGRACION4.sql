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
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2806';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);
V_SENTENCIA VARCHAR2(2000 CHAR);

--Tablas
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ADN_ADJNOJUDICIAL';

V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON_2';

BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
	
		
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_ADM_INF_ADMINISTRATIVA');
        
    ELSE
	
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	ADN_ID,
	ACT_ID,
	DD_EEJ_ID,
	ADN_FECHA_TITULO,
	ADN_FECHA_FIRMA_TITULO,
	ADN_VALOR_ADQUISICION,
	ADN_TRAMITADOR_TITULO,
	ADN_NUM_REFERENCIA,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_ADN_ADJNOJUDICIAL.NEXTVAL       ADN_ID,
	ACT.ACT_ID,
	ADN.DD_EEJ_ID								          DD_EEJ_ID,
	ADN.ADN_FECHA_TITULO                                  ADN_FECHA_TITULO,
	ADN.ADN_FECHA_FIRMA_TITULO                            ADN_FECHA_FIRMA_TITULO,
	ADN.ADN_VALOR_ADQUISICION                             ADN_VALOR_ADQUISICION,
	ADN.ADN_TRAMITADOR_TITULO                             ADN_TRAMITADOR_TITULO,
	ADN.ADN_NUM_REFERENCIA                                ADN_NUM_REFERENCIA,
	''0''                                                 VERSION,
	'''||V_USUARIO||'''                                   USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' ADN ON ADN.ACT_ID = ACT.ACT_ID
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

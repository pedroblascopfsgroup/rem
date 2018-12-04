--/*
--#########################################
--## AUTOR=Maria Presencia Herrero
--## FECHA_CREACION=20181030
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4629
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
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-4629';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);
V_SENTENCIA VARCHAR2(2000 CHAR);

--Tablas
V_TABLA VARCHAR2(40 CHAR) := 'ACT_TIT_TITULO';
V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON';


BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_ADM_INF_ADMINISTRATIVA');
        
    ELSE

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		TIT_ID,
		ACT_ID,
		DD_ETI_ID,
		TIT_FECHA_ENTREGA_GESTORIA,
		TIT_FECHA_PRESENT_HACIENDA,
		TIT_FECHA_ENVIO_AUTO,
		TIT_FECHA_PRESENT1_REG,
		TIT_FECHA_PRESENT2_REG,
		TIT_FECHA_INSC_REG,
		TIT_FECHA_RETIRADA_REG,
		TIT_FECHA_NOTA_SIMPLE,
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
		'||V_ESQUEMA||'.S_ACT_TIT_TITULO.NEXTVAL              TIT_ID,
		ACT2.ACT_ID,
		TIT.DD_ETI_ID							              DD_ETI_ID,
		TIT.TIT_FECHA_ENTREGA_GESTORIA                        TIT_FECHA_ENTREGA_GESTORIA,
		TIT.TIT_FECHA_PRESENT_HACIENDA                        TIT_FECHA_PRESENT_HACIENDA,
		TIT.TIT_FECHA_ENVIO_AUTO                              TIT_FECHA_ENVIO_AUTO,
		TIT.TIT_FECHA_PRESENT1_REG                            TIT_FECHA_PRESENT1_REG,
		TIT.TIT_FECHA_PRESENT2_REG                            TIT_FECHA_PRESENT2_REG,
		TIT.TIT_FECHA_INSC_REG                                TIT_FECHA_INSC_REG,
		TIT.TIT_FECHA_RETIRADA_REG                            TIT_FECHA_RETIRADA_REG,
		TIT.TIT_FECHA_NOTA_SIMPLE                             TIT_FECHA_NOTA_SIMPLE,
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
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' TIT ON TIT.ACT_ID = ACT.ACT_ID
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

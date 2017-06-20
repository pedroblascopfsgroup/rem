--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ATI_TITULO' -> 'ACT_TIT_TITULO'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_TIT_TITULO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATI_TITULO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

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
	ACT.ACT_ID,
	(SELECT DD_ETI_ID
	  FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO DD
	  WHERE DD_ETI_CODIGO = MIG.ESTADO_TITULO)            DD_ETI_ID,
	MIG.TIT_FECHA_ENTREGA_GESTORIA                        TIT_FECHA_ENTREGA_GESTORIA,
	MIG.TIT_FECHA_PRESENT_HACIENDA                        TIT_FECHA_PRESENT_HACIENDA,
	MIG.TIT_FECHA_ENVIO_AUTO                              TIT_FECHA_ENVIO_AUTO,
	MIG.TIT_FECHA_PRESENT1_REG                            TIT_FECHA_PRESENT1_REG,
	MIG.TIT_FECHA_PRESENT2_REG                            TIT_FECHA_PRESENT2_REG,
	MIG.TIT_FECHA_INSC_REG                                TIT_FECHA_INSC_REG,
	MIG.TIT_FECHA_RETIRADA_REG                            TIT_FECHA_RETIRADA_REG,
	MIG.TIT_FECHA_NOTA_SIMPLE                             TIT_FECHA_NOTA_SIMPLE,
	''0''                                                 VERSION,
	'''||V_USUARIO||'''                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.VALIDACION = 0
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

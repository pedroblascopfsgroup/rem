--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200604
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7432
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_TABLA VARCHAR2(100 CHAR) := 'DD_OPM_OPERACION_MASIVA'; -- Tabla Destino
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7432';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	
BEGIN
  	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_OPM_VALIDACION_FORMATO = ''n*,s1'', 
			USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE WHERE DD_OPM_CODIGO = ''SUBT''';
			
	EXECUTE IMMEDIATE V_SQL;	
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualzado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
	COMMIT;
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

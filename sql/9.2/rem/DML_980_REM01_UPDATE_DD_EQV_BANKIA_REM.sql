--/*
--#########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20191017
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7691
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registro 'Subsanar' en DD_EQL_BANKIA_REM.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_TABLA VARCHAR2(30 CHAR) := 'DD_EQV_BANKIA_REM'; -- Variable para tabla principal.
	V_TABLA_2 VARCHAR2(30 CHAR) := 'DD_ETI_ESTADO_TITULO'; -- Variable para subconsulta.
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema.
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-7691';
	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	V_SQL := 'UPDATE  '||V_ESQUEMA||'.'||V_TABLA||'
		SET 
			DD_CODIGO_REM = 
				(SELECT DD_ETI_CODIGO 
					FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
					WHERE DD_ETI_CODIGO = ''06''
				),		
			DD_DESCRIPCION_REM = 
				(SELECT DD_ETI_DESCRIPCION
					FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
					WHERE DD_ETI_CODIGO = ''06''
				),
			DD_DESCRIPCION_LARGA_REM = 
				(SELECT DD_ETI_DESCRIPCION_LARGA
					FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
					WHERE DD_ETI_CODIGO = ''06''
				),
			VERSION = VERSION +1,
			USUARIOMODIFICAR = '''||V_USUARIO||''',	
			FECHAMODIFICAR = SYSDATE 
			WHERE DD_DESCRIPCION_BANKIA = ''SUBSANAR'' 
			AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha UPDATEADO  en total '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

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

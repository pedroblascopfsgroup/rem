--/*
--#########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6905
--## PRODUCTO=NO
--## 
--## Finalidad: Se modifica el tipo de trabajo de Acompañamiento y Fotografia a Actuacion Tecnica. Peticion de Haya el dia de la migracion Div.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6905';
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Se cambia el tipo de trabajo de Fotografia y Acompañamiento de Obtencion documento a Actuacion tecnica.');
	
	V_SQL:= 'UPDATE '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO SET 
	DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.dd_ttr_tipo_trabajo WHERE DD_TTR_CODIGO = ''03''),
	USUARIOMODIFICAR = ''REMVIP-6905'',
	FECHAMODIFICAR = SYSDATE
	WHERE DD_STR_CODIGO = ''ACO''';
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' filas actualizadas. Acompañamiento.');

	V_SQL:= 'UPDATE '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO SET DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.dd_ttr_tipo_trabajo WHERE DD_TTR_CODIGO = ''03''),
	USUARIOMODIFICAR = ''REMVIP-6905'',
	FECHAMODIFICAR = SYSDATE
	WHERE DD_STR_CODIGO = ''FOT''';

	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' filas actualizadas. Fotografía.');
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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

--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9777
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica CUENTA Y PARTIDA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA_CCC VARCHAR2(27 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES';
	V_TEXT_TABLA_CPP VARCHAR2(27 CHAR) := 'ACT_CONFIG_PTDAS_PREP';

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA_CCC||' SET BORRADO = 0, USUARIOBORRAR = NULL, FECHABORRAR = NULL
				WHERE BORRADO = 1';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] DESBORRAMOS '|| SQL%ROWCOUNT ||' REGISTROS DE CUENTAS CONTABLES');

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA_CPP||' SET BORRADO = 0, USUARIOBORRAR = NULL, FECHABORRAR = NULL
				WHERE BORRADO = 1';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] DESBORRAMOS '|| SQL%ROWCOUNT ||' REGISTROS DE PARTIDAS PRESUPUESTARIAS');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT
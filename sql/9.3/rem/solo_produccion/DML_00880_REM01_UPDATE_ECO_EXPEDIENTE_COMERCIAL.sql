--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210526
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9779
--## PRODUCTO=NO
--##
--## Finalidad: Modificar comité
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9779'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = 260184';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

	IF V_COUNT = 1 THEN

		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET 
						DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''36''),
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE ECO_NUM_EXPEDIENTE = 260184';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] COMITÉ SANCIONADOR ACTUALIZADO');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL EXPEDIENTE');

	END IF;

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

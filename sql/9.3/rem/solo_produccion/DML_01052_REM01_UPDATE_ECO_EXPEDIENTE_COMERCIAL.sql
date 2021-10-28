--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10545
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica trabajo
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10545'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

			
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET
				ECO_FECHA_ENVIO_ADVISORY_NOTE = TO_DATE(''17/09/2021'',''dd/mm/yyyy''),
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE
				WHERE ECO_NUM_EXPEDIENTE = 275332';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Modificado  '||SQL%ROWCOUNT||' expediente 275332');
	

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
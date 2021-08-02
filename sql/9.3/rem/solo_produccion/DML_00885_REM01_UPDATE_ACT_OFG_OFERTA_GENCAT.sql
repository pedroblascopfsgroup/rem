--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210531
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9833
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9833'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
	V_CMG_ID NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7311720';
	EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;	

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT WHERE ACT_ID = '||V_ACT_ID||'';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

	IF V_COUNT = 1 THEN

		V_MSQL := 'SELECT CMG_ID FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT WHERE ACT_ID = '||V_ACT_ID||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_CMG_ID;	

		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT SET 
						OFR_ID_ANT = NULL,
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE CMG_ID = '||V_CMG_ID||'';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] COMUNICACIÓN GENCAT ACTUALIZADA');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA COMUNICACIÓN GENCAT');

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

--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9416
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_TBJ_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9416'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TBJ_HPE_HISTORIFICADOR_PESTANAS SET BORRADO = 1, USUARIOBORRAR = '''||V_USU||''',
				FECHABORRAR = SYSDATE WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
				WHERE TBJ_NUM_TRABAJO = 924567825254 AND BORRADO = 0) AND VALOR_NUEVO = ''Cancelado''';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADO REGISTRO HISTORIFICADO EN TRABAJO 924567825254');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
					SELECT DISTINCT TBJ_ID,TBJ_FECHA_VALIDACION FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
					WHERE TBJ_NUM_TRABAJO = 924567825254 AND BORRADO = 0
				) T2
				ON (T1.TBJ_ID = T2.TBJ_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.DD_EST_ID = 23,
				T1.TBJ_FECHA_CAMBIO_ESTADO = T2.TBJ_FECHA_VALIDACION,
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO TRABAJO 924567825254');

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
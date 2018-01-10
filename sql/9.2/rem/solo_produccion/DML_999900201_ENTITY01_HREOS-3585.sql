--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.35
--## INCIDENCIA_LINK=HREOS-3585
--## PRODUCTO=SI
--## Finalidad: Corregir el expediente 83845
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

	VN_COUNT NUMBER;
	V_TABLENAME VARCHAR2(35 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL'; 
	V_TABLENAME2 VARCHAR2(35 CHAR):= 'RES_RESERVAS';
	V_TABLENAME3 VARCHAR2(35 CHAR):= 'OFR_OFERTAS';
	V_NUMEXPEDIENTE NUMBER := 83845;
	V_INCIDENCIALINK VARCHAR(35 CHAR):='HREOS-3585';
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas');
	
	V_MSQL := 'SELECT COUNT(1) 
		FROM '||V_ESQUEMA||'.'||V_TABLENAME||' 
		WHERE ECO_NUM_EXPEDIENTE = '||V_NUMEXPEDIENTE||' 
		AND ECO_FECHA_DEV_ENTREGAS IS NULL';

	EXECUTE IMMEDIATE V_MSQL INTO VN_COUNT;

	IF VN_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El expediente ya está corregido');

	ELSE

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLENAME2||' SET USUARIOMODIFICAR = '''||V_INCIDENCIALINK||''', FECHAMODIFICAR = SYSDATE, DD_ERE_ID = 5, DD_EDE_ID = NULL
		WHERE ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.'||V_TABLENAME||' WHERE ECO_NUM_EXPEDIENTE = '||V_NUMEXPEDIENTE||')';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada la tabla: '||V_TABLENAME2);

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLENAME3||' SET USUARIOMODIFICAR = '''||V_INCIDENCIALINK||''', FECHAMODIFICAR = SYSDATE, DD_EOF_ID = 1
		WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.'||V_TABLENAME||' WHERE ECO_NUM_EXPEDIENTE = '||V_NUMEXPEDIENTE||')';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada la tabla: '||V_TABLENAME3);

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLENAME||' SET USUARIOMODIFICAR = '''||V_INCIDENCIALINK||''', FECHAMODIFICAR = SYSDATE, ECO_FECHA_DEV_ENTREGAS = NULL, DD_EEC_ID = 16
		WHERE ECO_NUM_EXPEDIENTE = '||V_NUMEXPEDIENTE;

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada la tabla: '||V_TABLENAME);

END IF;



COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Terminadas las tareas del ticket '||V_INCIDENCIALINK);

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

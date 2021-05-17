--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210514
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9731
--## PRODUCTO=NO
--##
--## Finalidad: Script soluciona duplicados en gestores
--## INSTRUCCIONES: Poner GEH_ID y GEE_ID del gestor duplicado
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9731'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_GEH_ID NUMBER(30) := 17372316;
	V_GEH_TABLA VARCHAR2(50 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST';
	V_GEE_ID NUMBER(30) := 15332457;
	V_GEE_TABLA VARCHAR2(50 CHAR) := 'GEE_GESTOR_ENTIDAD';
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_GEH_TABLA||' SET
						GEH_FECHA_HASTA = TO_DATE(''09/07/2020'',''DD/MM/YYYY''),
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE GEH_ID = '||V_GEH_ID||'';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_GEE_TABLA||' SET
						BORRADO = 1,
						USUARIOBORRAR = '''||V_USU||''',
						FECHABORRAR = SYSDATE
						WHERE GEE_ID = '||V_GEE_ID||'';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO GESTOR DUPLICADO');

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
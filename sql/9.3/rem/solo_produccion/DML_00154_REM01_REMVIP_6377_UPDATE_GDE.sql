--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6377
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en borra los datos de pago de los gastos
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	V_MSQL := ' UPDATE REM01.GDE_GASTOS_DETALLE_ECONOMICO
		    SET GDE_FECHA_PAGO = NULL,
			USUARIOMODIFICAR = ''REMVIP-6377'',
			FECHAMODIFICAR = SYSDATE
		    WHERE 1 = 1
		    AND GPV_ID IN
				(

				SELECT GPV_ID
				FROM REM01.GPV_GASTOS_PROVEEDOR 
				WHERE GPV_NUM_GASTO_HAYA IN 
								(
	
								''10668146'',
								''10668147'',
								''10668148'',
								''10668149'',
								''10668150'',
								''10668151'',
								''10668152'',
								''10668153'',
								''10668154''

								)

				) ';
			
	EXECUTE IMMEDIATE V_MSQL;	

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ha borrado la fecha de pago de '||SQL%ROWCOUNT||' gastos ');


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

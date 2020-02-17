--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6396
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar de estado gastos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE


    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-------------------------------------------------------------------------------------------------------
	-- Se cambia de subtipo las partidas:

	
	DBMS_OUTPUT.PUT_LINE('[INFO]: se cambian de estado los gastos ');

	V_SQL := ' UPDATE REM01.GPV_GASTOS_PROVEEDOR
		    SET DD_EGA_ID = ( SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04'' ),
		    USUARIOMODIFICAR = ''REMVIP-6396'',
		    FECHAMODIFICAR = SYSDATE
		    WHERE 1 = 1
		    AND GPV_NUM_GASTO_HAYA IN
(

''9587093'',
''10097750'',
''10098283'',
''10101921'',
''10101922'',
''10101923'',
''10101924'',
''10101925'',
''10101926'',
''10101928'',
''10101931'',
''10130376'',
''10132180'',
''10247689'',
''10247712'',
''10259188'',
''10259190'',
''10259194'',
''10259195'',
''10259198'',
''10259202'',
''10259203'',
''10259206'',
''10259207'',
''10259209'',
''10259210'',
''10259740'',
''10259741'',
''10259743'',
''10259748'',
''10259755'',
''10259792'',
''10268102'',
''10284667'',
''10284733'',
''10370842'',
''10381173'',
''10425098'',
''10433991'',
''10435656'',
''10471687'',
''10471693'',
''10471695'',
''10471704'',
''10477403'',
''10477411'',
''10497927'',
''10517769'',
''10523088'',
''10527406'',
''10535589'',
''10539626'',
''10539627'',
''10539632'',
''10539633'',
''10539690'',
''10539691'',
''10655617'',
''10655622'',
''10655626'',
''10686650'',
''10731167'',
''10755474''

)
		   AND BORRADO = 0';



	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' gastos ');  



	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado el tarifario de apple y divarian ');


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

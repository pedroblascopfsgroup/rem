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

  

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

		T_TIPO_DATA( '9587093', '05/11/2019' ),
		T_TIPO_DATA( '10097750', '05/12/2019' ),
		T_TIPO_DATA( '10098283', '05/12/2019' ),
		T_TIPO_DATA( '10101921', '05/12/2019' ),
		T_TIPO_DATA( '10101922', '05/12/2019' ),
		T_TIPO_DATA( '10101923', '05/12/2019' ),
		T_TIPO_DATA( '10101924', '05/12/2019' ),
		T_TIPO_DATA( '10101925', '05/12/2019' ),
		T_TIPO_DATA( '10101926', '05/12/2019' ),
		T_TIPO_DATA( '10101928', '05/12/2019' ),
		T_TIPO_DATA( '10101931', '05/12/2019' ),
		T_TIPO_DATA( '10130376', '05/12/2018' ),
		T_TIPO_DATA( '10132180', '05/12/2018' ),
		T_TIPO_DATA( '10247689', '05/07/2019' ),
		T_TIPO_DATA( '10247712', '05/07/2019' ),
		T_TIPO_DATA( '10259188', '05/12/2019' ),
		T_TIPO_DATA( '10259190', '05/12/2019' ),
		T_TIPO_DATA( '10259194', '05/12/2019' ),
		T_TIPO_DATA( '10259195', '05/12/2019' ),
		T_TIPO_DATA( '10259198', '05/12/2019' ),
		T_TIPO_DATA( '10259202', '05/12/2019' ),
		T_TIPO_DATA( '10259203', '05/12/2019' ),
		T_TIPO_DATA( '10259206', '05/12/2019' ),
		T_TIPO_DATA( '10259207', '05/12/2019' ),
		T_TIPO_DATA( '10259209', '05/12/2019' ),
		T_TIPO_DATA( '10259210', '05/12/2019' ),
		T_TIPO_DATA( '10259740', '05/12/2019' ),
		T_TIPO_DATA( '10259741', '05/12/2019' ),
		T_TIPO_DATA( '10259743', '05/07/2019' ),
		T_TIPO_DATA( '10259748', '05/07/2019' ),
		T_TIPO_DATA( '10259755', '05/07/2019' ),
		T_TIPO_DATA( '10259792', '05/07/2019' ),
		T_TIPO_DATA( '10268102', '06/03/2019' ),
		T_TIPO_DATA( '10284667', '05/07/2019' ),
		T_TIPO_DATA( '10284733', '05/07/2019' ),
		T_TIPO_DATA( '10370842', '05/11/2019' ),
		T_TIPO_DATA( '10381173', '05/04/2019' ),
		T_TIPO_DATA( '10425098', '05/12/2019' ),
		T_TIPO_DATA( '10433991', '05/07/2019' ),
		T_TIPO_DATA( '10435656', '05/07/2019' ),
		T_TIPO_DATA( '10471687', '20/05/2019' ),
		T_TIPO_DATA( '10471693', '20/05/2019' ),
		T_TIPO_DATA( '10471695', '20/05/2019' ),
		T_TIPO_DATA( '10471704', '20/05/2019' ),
		T_TIPO_DATA( '10477403', '05/07/2019' ),
		T_TIPO_DATA( '10477411', '05/07/2019' ),
		T_TIPO_DATA( '10497927', '05/07/2019' ),
		T_TIPO_DATA( '10517769', '05/12/2019' ),
		T_TIPO_DATA( '10523088', '05/12/2019' ),
		T_TIPO_DATA( '10527406', '05/07/2019' ),
		T_TIPO_DATA( '10535589', '05/12/2019' ),
		T_TIPO_DATA( '10539626', '05/12/2019' ),
		T_TIPO_DATA( '10539627', '05/12/2019' ),
		T_TIPO_DATA( '10539632', '05/12/2019' ),
		T_TIPO_DATA( '10539633', '05/12/2019' ),
		T_TIPO_DATA( '10539690', '05/12/2019' ),
		T_TIPO_DATA( '10539691', '05/12/2019' ),
		T_TIPO_DATA( '10655617', '22/10/2018' ),
		T_TIPO_DATA( '10655622', '22/10/2018' ),
		T_TIPO_DATA( '10655626', '22/10/2018' ),
		T_TIPO_DATA( '10686650', '21/10/2019' ),
		T_TIPO_DATA( '10731167', '05/12/2019' ),
		T_TIPO_DATA( '10755474', '05/12/2019' )


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-------------------------------------------------------------------------------------------------------
	-- Se actualizan los nuevos valores:
	-- se itera por el array
	DBMS_OUTPUT.PUT_LINE('[INFO]: Se actualizan gastos' );

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_SQL := 
		'UPDATE REM01.GPV_GASTOS_PROVEEDOR
		 SET DD_EGA_ID = ( SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' ),
		    USUARIOMODIFICAR = ''REMVIP-6396'',
		    FECHAMODIFICAR = SYSDATE
		 WHERE 1 = 1
		 AND GPV_NUM_GASTO_HAYA = ' ||TRIM(V_TMP_TIPO_DATA(1)) || '
		 AND BORRADO = 0 ' ;

		 EXECUTE IMMEDIATE V_SQL;

	         DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' gasto #' || TRIM(V_TMP_TIPO_DATA(1))  );  

		-------------------

		V_SQL := 
		'UPDATE REM01.GDE_GASTOS_DETALLE_ECONOMICO
		 SET GDE_FECHA_PAGO = TO_DATE( ''' || TRIM(V_TMP_TIPO_DATA(2)) || ''', ''DD/MM/YYYY'' ) ,
		    USUARIOMODIFICAR = ''REMVIP-6396'',
		    FECHAMODIFICAR = SYSDATE
		 WHERE 1 = 1
		 AND GPV_ID = ( SELECT GPV_ID FROM
				REM01.GPV_GASTOS_PROVEEDOR
				WHERE  GPV_NUM_GASTO_HAYA = ' ||TRIM(V_TMP_TIPO_DATA(1)) || '
				AND BORRADO = 0
			      )	
		 AND BORRADO = 0 ' ;

		 EXECUTE IMMEDIATE V_SQL;

	         DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' detalle económico del gasto #' || TRIM(V_TMP_TIPO_DATA(1))  );  


	END LOOP;

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

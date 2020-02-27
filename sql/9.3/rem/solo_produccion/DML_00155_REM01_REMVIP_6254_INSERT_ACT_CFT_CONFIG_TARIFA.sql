--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6254
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA
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
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM NUMBER(16); -- Vble. auxiliar para almacenar el número de registros
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-6254'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	TIPO_TARIFA_CODIGO | TIPO_TRABAJO_CÓDIGO | TIPO_SUBTRABAJO_CÓDIGO | PRECIO_UNITARIO | UNIDAD_MEDIDA

T_TIPO_DATA( 'AP-VACI-LIMP-CER1', '03', '57', '1038', '€/unidad' ),
T_TIPO_DATA( 'AP-VACI-LIMP-CER2', '03', '57', '336', '€/unidad' ),
T_TIPO_DATA( 'AP-VACI-LIMP-CER3', '03', '57', '222', '€/unidad' ),
T_TIPO_DATA( 'AP-VACI-LIMP-CER4', '03', '57', '60' , '€/unidad' ),

T_TIPO_DATA( 'AP-VACI-LIMP-CER1', '03', '68', '1038', '€/unidad' ),
T_TIPO_DATA( 'AP-VACI-LIMP-CER2', '03', '68', '336', '€/unidad' ),
T_TIPO_DATA( 'AP-VACI-LIMP-CER3', '03', '68', '222', '€/unidad' ),
T_TIPO_DATA( 'AP-VACI-LIMP-CER4', '03', '68', '60' , '€/unidad' )


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	


	-------------------------------------------------------------------------------------------------------
	-- Se actualizan los nuevos valores:
	-- se itera por el array
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		------------------------------------------------------------------
		-- Se trata apple:

		
		V_MSQL := ' SELECT COUNT(1) FROM REM01.ACT_CFT_CONFIG_TARIFA
			    WHERE 1 = 1
			    AND DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
		 	    AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')    			 
			    AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
			    AND DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'' )
			    AND DD_SCR_ID = ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'' ) ';
			
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
		IF ( V_NUM = 0 ) THEN

		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 
		'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		 ( CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, 
		   VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                 SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL AS CFT_ID, 
		 (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
		 (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),    			 
		 (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),

                 DD_CRA_ID,
		 DD_SCR_ID,

                 ' || TRIM(V_TMP_TIPO_DATA(4)) ||', '''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 
		 FROM REM01.DD_SCR_SUBCARTERA
	         WHERE DD_SCR_CODIGO IN ( ''138'' )
		 AND BORRADO = 0 ';

		 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
 		
		ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

		V_MSQL := 
		'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		 SET  	CFT_PRECIO_UNITARIO = ' || TRIM(V_TMP_TIPO_DATA(4))||',
			CFT_UNIDAD_MEDIDA = '''||TRIM(V_TMP_TIPO_DATA(5))||''',
			USUARIOMODIFICAR = ''REMVIP-6254'',
			FECHAMODIFICAR = SYSDATE
		 WHERE 1 = 1
		 AND DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
		 AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')    			 
		 AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')

	 	 AND DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'' )
		 AND DD_SCR_ID = ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'' )';

		 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');
			

		END IF;

	END LOOP;

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

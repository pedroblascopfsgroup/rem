--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20220403
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-17471
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en TFI_TAREAS_FORM_ITEMS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TAP NUMBER(16); -- Vble almacenamiento tap_id
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'TFI_TAREAS_FORM_ITEMS';
    V_CHARS VARCHAR2(3 CHAR):= 'TFI';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-17471';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    -- CODIGO TAREA 			       TIPO CAMPO                  NOMBRE               LABEL
      T_TIPO_DATA('T017_AgendarPosicionamiento',	'combobox',			'cambioRiesgo',     'Cambio de riesgo',     '02',    'DDSiNo',      6),
      T_TIPO_DATA('T017_AgendarPosicionamiento',	'textarea',			'observaciones',     'Observaciones',     '',    '',      7),
      T_TIPO_DATA('T017_ConfirmarFechaEscritura',	'comboboxinicial',		    'cambioRiesgo',     'Cambio de riesgo',     '02',    'DDSiNo',      8),
      T_TIPO_DATA('T017_ConfirmarFechaEscritura',	'textarea',		    'observaciones',     'Observaciones',     '',    '',      9),
      T_TIPO_DATA('T017_FirmaContrato',			    'comboboxinicial',		    'cambioRiesgo',     'Cambio de riesgo',     '02',    'DDSiNo',      9),
      T_TIPO_DATA('T017_FirmaContrato',			    'textarea',		    'observaciones',     'Observaciones',     '',    '',      10)

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      --Recogemos el tap id
      V_SQL := 'SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_TAP;
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE '||V_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND TAP_ID = '||V_TAP||'';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' para la tarea '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            '||V_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
            '||V_CHARS||'_ORDEN = '||TRIM(V_TMP_TIPO_DATA(7))||',
            '||V_CHARS||'_TIPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            '||V_CHARS||'_LABEL = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
            '||V_CHARS||'_VALOR_INICIAL = '''||TRIM(V_TMP_TIPO_DATA(5))||''',
            '||V_CHARS||'_BUSINESS_OPERATION = '''||TRIM(V_TMP_TIPO_DATA(6))||''',
	        USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
			    WHERE '||V_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
			    AND TAP_ID = '||V_TAP||'';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' para la tarea '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
				'||V_CHARS||'_ID, '||V_CHARS||'_NOMBRE, '||V_CHARS||'_ORDEN, '||V_CHARS||'_TIPO, '||V_CHARS||'_LABEL, '||V_CHARS||'_VALOR_INICIAL,
				'||V_CHARS||'_BUSINESS_OPERATION, TAP_ID, VERSION, USUARIOCREAR, FECHACREAR)
          	SELECT 
	            '|| V_ID || ',
	            '''||V_TMP_TIPO_DATA(3)||''',
	            '||V_TMP_TIPO_DATA(7)||',
	            '''||V_TMP_TIPO_DATA(2)||''',
	            '''||V_TMP_TIPO_DATA(4)||''',
	            '''||V_TMP_TIPO_DATA(5)||''',
	            '''||V_TMP_TIPO_DATA(6)||''',
	            '||V_TAP||',
	            0, '''||V_USUARIO||''', SYSDATE FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
      END IF;

    END LOOP;
  COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

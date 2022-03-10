--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20220302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-17091
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en DD_TRL_TIPO_ROLES_MEDIADOR
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
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'DD_SVI_SUBESTADOS_VISITA';
    V_CHARS VARCHAR2(3 CHAR):= 'SVI';
    V_TABLA_TIPO VARCHAR2(50 CHAR):= 'DD_EVI_ESTADOS_VISITA';
    V_CHARS_TIPO VARCHAR2(50 CHAR):= 'EVI';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-17091';
    V_ID_SUP NUMBER(16);
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- CODIGO EVI   CODIGO SVI  	EXT SINGULAR   EXT RETAIL    RESULT REASON CODE
      T_TIPO_DATA('01',        '24',         'Z001',       'ZM01',           ''   ),
      T_TIPO_DATA('02',        '20',         'Z002',       'ZM03',           ''   ),
      T_TIPO_DATA('02',        '21',         'Z002',       'ZM03',           ''   ),
      T_TIPO_DATA('02',        '23',         'Z002',       'ZM03',           ''   ),
      T_TIPO_DATA('04',        '01',         'Z004',       'ZM05',           'Z19'),
      T_TIPO_DATA('04',        '02',         'Z004',       'ZM05',           'Z19'),
      T_TIPO_DATA('04',        '03',         'Z004',       'ZM05',           'Z41'),
      T_TIPO_DATA('04',        '04',         'Z004',       'ZM05',           'Z22'),
      T_TIPO_DATA('04',        '19',         'Z004',       'ZM05',           'Z19'),
      T_TIPO_DATA('05',        '05',         'Z004',       'ZM05',           'Z22'),
      T_TIPO_DATA('05',        '06',         'Z004',       'ZM05',           'Z25'),
      T_TIPO_DATA('05',        '07',         'Z005',       'Z005',           'Z37'),
      T_TIPO_DATA('05',        '08',         'Z004',       'ZM05',           'Z22'),
      T_TIPO_DATA('05',        '09',         'Z004',       'ZM05',           'Z23'),
      T_TIPO_DATA('05',        '10',         'Z004',       'ZM05',           'Z19'),
      T_TIPO_DATA('05',        '11',         'Z004',       'ZM05',           'Z23'),
      T_TIPO_DATA('05',        '12',         'Z004',       'ZM05',           'Z40'),
      T_TIPO_DATA('05',        '13',         'Z004',       'ZM05',           'Z40'),
      T_TIPO_DATA('05',        '14',         'Z004',       'ZM05',           'Z34'),
      T_TIPO_DATA('05',        '15',         'Z004',       'ZM05',           'Z34'),
      T_TIPO_DATA('05',        '16',         'Z004',       'ZM05',           'Z30'),
      T_TIPO_DATA('05',        '17',         'Z004',       'ZM05',           'Z24'),
      T_TIPO_DATA('05',        '18',         'Z004',       'ZM05',           'Z34'),
      T_TIPO_DATA('05',        '22',         'Z004',       'ZM05',           'Z34'),
      T_TIPO_DATA('05',        '25',         'Z004',       'ZM05',           'Z30'),
      T_TIPO_DATA('05',        '26',         'Z004',       'ZM05',           'Z30'),
      T_TIPO_DATA('05',        '27',         'Z004',       'ZM05',           'Z21')



    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	 
      -- LOOP para insertar los valores -----------------------------------------------------------------

      FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
      	
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        V_SQL := 'SELECT SVI.DD_'||V_CHARS||'_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' SVI 
        JOIN '||V_ESQUEMA||'.'||V_TABLA_TIPO||' EVI ON SVI.DD_'||V_CHARS_TIPO||'_ID = EVI.DD_'||V_CHARS_TIPO||'_ID AND EVI.DD_'||V_CHARS_TIPO||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
        WHERE SVI.DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_ID_SUP;
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        DBMS_OUTPUT.PUT_LINE(TRIM(V_TMP_TIPO_DATA(5)));
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| V_ID_SUP ||'''');
          V_MSQL := '
            UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
            SET 
              DD_'||V_CHARS||'_EXTUSC_SIN = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              DD_'||V_CHARS||'_EXTUSC_RET = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              DD_'||V_CHARS||'_RESRCOD = '''||TRIM(V_TMP_TIPO_DATA(5))||''',
  	          USUARIOMODIFICAR = '''||V_USUARIO||''',
              FECHAMODIFICAR = SYSDATE
  			    WHERE DD_'||V_CHARS||'_ID = '''||V_ID_SUP||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
          
        --Si no existe, lo insertamos   
        ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: NO SE MODIFICA NADA');
        
        END IF;

      END LOOP;

  COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line(V_SQL);
          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

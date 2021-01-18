--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20201012
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.2.0
--## INCIDENCIA_LINK=HREOS-11214
--## PRODUCTO=NO
--## Finalidad: Insercion de datos en el diccionario DD_EMI_ERROR_MAP_INMUEBLE
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Se añade nuevo error
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EMI_ERROR_MAP_INMUEBLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-11214';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('listaNoInformada','14',  'Lista de inmuebles no informada.',  'Lista de inmuebles no informada.'),
        T_TIPO_DATA('codigoInmuebleConFormatoIncorrecto','15',  'Formato de código de inmueble incorrecto.',  'Formato de código de inmueble incorrecto.'),
        T_TIPO_DATA('codigoInmuebleNoInformado','16',  'Código de inmueble no informado.',  'Código de inmueble no informado.'),
        T_TIPO_DATA('sinDeterminarTasacion','21',  'No se puede determinar el tipo de tasación.',  'No se puede determinar el tipo de tasación.'),
        T_TIPO_DATA('sinDeterminarEnCarteraSocial','22',  'No se puede determinar si el inmueble es de Cartera Fondo Social.',  'No se puede determinar si el inmueble es de Cartera Fondo Social.'),
        T_TIPO_DATA('sinDeterminarSituacionComercial','23',  'No se puede determinar la Situación Comercial del inmueble.',  'No se puede determinar la Situación Comercial del inmueble.'),
        T_TIPO_DATA('sinDeterminarTipoActivo','24',  'No se puede determinar el tipo de activo.',  'No se puede determinar el tipo de activo.'),
        T_TIPO_DATA('sinDeterminarProindiviso','25',  'No se puede determinar el proindiviso del inmueble.',  'No se puede determinar el proindiviso del inmueble.'),
        T_TIPO_DATA('sinDeterminarIndisponibilidadJuridica','26',  'No se puede determinar la indisponibilidad jurídica del inmueble.',  'No se puede determinar la indisponibilidad jurídica del inmueble.'),
        T_TIPO_DATA('sinDeterminarOkupas','27',  'No se puede determinar si el inmueble tiene okupas.',  'No se puede determinar si el inmueble tiene okupas.'),
        T_TIPO_DATA('sinDeterminarOrigenInmueble','28',  'No se puede determinar el origen del inmueble.',  'No se puede determinar el origen del inmueble.'),
        T_TIPO_DATA('sinDeterminarPosesion','29',  'No se puede determinar la posesión del inmueble.',  'No se puede determinar la posesión del inmueble.'),
        T_TIPO_DATA('noSeEncuentraInmueble','31',  'Formato de código de inmueble incorrecto.',  'Formato de código de inmueble incorrecto.'),
        T_TIPO_DATA('inmuebleEnFondoSocial','31',  'Inmueble de CARTERA FONDO SOCIAL.',  'Inmueble de CARTERA FONDO SOCIAL.'),
        T_TIPO_DATA('inmuebleAlquilado','31',  'Inmueble con situación comercial ALQUILADO.',  'Inmueble con situación comercial ALQUILADO.'),
	T_TIPO_DATA('inmuebleEscriturado','31',  'Inmueble con situación comercial ESCRITURADO.',  'Inmueble con situación comercial ESCRITURADO.'),
        T_TIPO_DATA('inmuebleTipoSuelo','31',  'Inmueble de tipo SUELO.',  'Inmueble de tipo SUELO.'),
        T_TIPO_DATA('inmuebleProindiviso','31',  'Inmueble con PROINDIVISO PARCIAL.',  'Inmueble con PROINDIVISO PARCIAL.'),
        T_TIPO_DATA('inmuebleIndisponibilidadJuridica','31',  'Inmueble con INDISPONIBILIDAD JURIDICA.',  'Inmueble con INDISPONIBILIDAD JURIDICA.'),
        T_TIPO_DATA('tieneOkupas','31',  'Inmueble que TIENE OKUPAS.',  'Inmueble que TIENE OKUPAS.'),
        T_TIPO_DATA('sinPosesion','31',  'Inmueble sin POSESION.',  'Inmueble sin POSESION.')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_EMI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_EMI_ERROR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                    ', DD_EMI_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
					', DD_EMI_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_EMI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
  
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                      DD_EMI_ID, DD_EMI_CODIGO, DD_EMI_ERROR_CODIGO, DD_EMI_DESCRIPCION, DD_EMI_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES
                      (S_'||V_TEXT_TABLA||'.NEXTVAL,  '''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||V_USUARIO||''',SYSDATE)';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

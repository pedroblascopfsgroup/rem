--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_OPM_OPERACION_MASIVA los datos añadidos en T_ARRAY_DATA.
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
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_OPM_OPERACION_MASIVA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'OPM'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('AGAR'	,'Agrupaciones: Agrupar activos (Restringidos)'				,'Agrupaciones: Agrupar activos (Restringidos)'),
        T_TIPO_DATA('AGAN'	,'Agrupaciones: Agrupar activos (Obra nueva)'				,'Agrupaciones: Agrupar activos (Obra nueva)'),
        T_TIPO_DATA('AGAA'	,'Agrupaciones: Agrupar activos (Asistida/PDV)'				,'Agrupaciones: Agrupar activos (Asistida/PDV)'),
        T_TIPO_DATA('LACT'	,'Trabajos: Lista de activos'								,'Trabajos: Lista de activos'),
        T_TIPO_DATA('CPPA'	,'Precios: Carga de propuesta de precios'					,'Precios: Carga de propuesta de precios'),
        T_TIPO_DATA('ADPA'	,'Precios: Actualizar precios de activo'					,'Precios: Actualizar precios de activo'),
        T_TIPO_DATA('BBPA'	,'Precios: Bloquear precios de activo'						,'Precios: Bloquear precios de activo'),
        T_TIPO_DATA('DBPA'	,'Precios: Desbloquear precios de activo'					,'Precios: Desbloquear precios de activo'),
        T_TIPO_DATA('ACPA'	,'Perímetros: Actualizar perímetro de activos'				,'Perímetros: Actualizar perímetro de activos'),
    	T_TIPO_DATA('ACPF'	,'Precios: Actualizar valores FSV de los activos'			,'Precios: Actualizar valores FSV de los activos'),
        T_TIPO_DATA('APBO'	,'Publicación: Publicación ordinaria del activo'			,'Publicación: Publicación ordinaria del activo'),
        T_TIPO_DATA('APUB'	,'Publicación: Publicación forzada del activo'				,'Publicación: Publicación forzada del activo'),
        T_TIPO_DATA('AOAC'	,'Publicación: Ocultar publicación activo'					,'Publicación: Ocultar publicación activo'),
        T_TIPO_DATA('ADAC'	,'Publicación: Desocultar publicación activo'				,'Publicación: Desocultar publicación activo'),
        T_TIPO_DATA('AOPR'	,'Publicación: Ocultar precio publicación'					,'Publicación: Ocultar precio publicación'),
        T_TIPO_DATA('ADPR'	,'Publicación: Desocultar precio publicación'				,'Publicación: Desocultar precio publicación'),
        T_TIPO_DATA('ADPU'	,'Publicación: Despublicar forzada'							,'Publicación: Despublicar forzada')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_'||V_TEXT_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_'||V_TEXT_CHARS||'_ID, DD_'||V_TEXT_CHARS||'_CODIGO, DD_'||V_TEXT_CHARS||'_DESCRIPCION, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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
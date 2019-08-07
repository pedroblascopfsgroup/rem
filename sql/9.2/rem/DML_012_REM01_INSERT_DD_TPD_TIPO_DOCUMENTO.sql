--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190807
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-SG
--## INCIDENCIA_LINK=HREOS-7293
--## PRODUCTO=NO
--##
--## Finalidad: INSERT TIPO DOCUMENTO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	  V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TPD_TIPO_DOCUMENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TPD'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('140'	 ,'Recurso derivación de deuda'	 ,'Recurso derivación de deuda'	 ,'AI-15-FACT-AX'),
      T_TIPO_DATA('141'  ,'Recurso hipoteca legal tácita'   ,'Recurso hipoteca legal tácita'   ,'AI-15-FACT-AY'),
      T_TIPO_DATA('142'  ,'Respuesta recurso derivación de deuda'   ,'Respuesta recurso derivación de deuda'   ,'AI-01-DOCA-60'),
      T_TIPO_DATA('143'  ,'Respuesta recurso hipoteca legal tácita'   ,'Respuesta recurso hipoteca legal tácita'   ,'AI-01-DOCA-61'),
      T_TIPO_DATA('146'  ,'Recurso sanción'   ,'Recurso sanción'   ,'AI-01-DOCJ-29'),
      T_TIPO_DATA('147'  ,'Recurso multa coercitiva'   ,'Recurso multa coercitiva'   ,'AI-01-DOCA-63'),
      T_TIPO_DATA('148'  ,'Solicitud bonificación tributaria'   ,'Solicitud bonificación tributaria'   ,'AI-01-DOCA-64'),
      T_TIPO_DATA('149'  ,'Recurso solicitud bonificación tributaria'   ,'Recurso solicitud bonificación tributaria'   ,'AI-01-DOCA-65'),
      T_TIPO_DATA('150'  ,'Solicitud suspensión de deudas recurridas'   ,'Solicitud suspensión de deudas recurridas'   ,'AI-01-DOCA-66'),
      T_TIPO_DATA('151'  ,'Recurso suspensión de deudas recurridas'   ,'Recurso suspensión de deudas recurridas'   ,'AI-01-DOCA-67')
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
					', DD_'||V_TEXT_CHARS||'_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''HREOS-7022'' , FECHAMODIFICAR = SYSDATE '||
					', DD_'||V_TEXT_CHARS||'_VISIBLE = 1'||
					'WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_'||V_TEXT_CHARS||'_ID, DD_'||V_TEXT_CHARS||'_CODIGO, DD_'||V_TEXT_CHARS||'_DESCRIPCION, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, DD_'||V_TEXT_CHARS||'_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DD_'||V_TEXT_CHARS||'_VISIBLE) ' ||
                      'SELECT '|| V_ID || ',  '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-7022'',SYSDATE,0 '||
					  ', 1  FROM DUAL';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
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

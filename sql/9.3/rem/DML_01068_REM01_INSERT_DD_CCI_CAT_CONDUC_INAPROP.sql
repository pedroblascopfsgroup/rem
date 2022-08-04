--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17599
--## PRODUCTO=NO
--##
--## Finalidad: Insert en tabla .
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_TABLA_TCI VARCHAR2(2400 CHAR) := 'DD_TCI_TIPO_CONDUC_INAPROP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_NCI VARCHAR2(2400 CHAR) := 'DD_NCI_NIVEL_CONDUC_INAPROP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_CCI_CAT_CONDUC_INAPROP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CODIGO_TABLA VARCHAR2(3 CHAR) := 'CCI';
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-17599';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('01',  'Pérdida',  '01', '01'),
    	T_TIPO_DATA('02',  'No devuelve llaves',  '01', '01'),
    	T_TIPO_DATA('03',  'No traspasa llaves',  '01', '01'),
    	T_TIPO_DATA('04',  'Ceden llaves a terceros sin autorización',  '01', '02'),
    	T_TIPO_DATA('05',  'No realiza informe tras varias reclamaciones',  '02', '01'),
    	T_TIPO_DATA('06',  'Publica por importe incorrecto',  '03', '01'),
    	T_TIPO_DATA('07',  'No llama al cliente tras reclamación',  '04', '01'),
    	T_TIPO_DATA('08',  'Cierra oportunidad y da alta otra para cobrar fee',  '04', '02'),
    	T_TIPO_DATA('09',  'No se presenta a la visita',  '04', '01'),
    	T_TIPO_DATA('10',  'Cobro de comisión al cliente',  '04', '03'),
    	T_TIPO_DATA('11',  'Presenta oferta propia sin autorización de Haya',  '05', '03')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_CODIGO_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                    SET DD_'||V_CODIGO_TABLA||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
					, DD_'||V_CODIGO_TABLA||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                    , DD_TCI_ID = (SELECT DD_TCI_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TCI||' WHERE DD_TCI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
                    , DD_NCI_ID = (SELECT DD_NCI_ID FROM '||V_ESQUEMA||'.'||V_TABLA_NCI||' WHERE DD_NCI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')
					, USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE 
					WHERE DD_'||V_CODIGO_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
  
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                      DD_'||V_CODIGO_TABLA||'_ID,DD_TCI_ID, DD_NCI_ID, DD_'||V_CODIGO_TABLA||'_CODIGO, DD_'||V_CODIGO_TABLA||'_DESCRIPCION, DD_'||V_CODIGO_TABLA||'_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES
                      (S_'||V_TEXT_TABLA||'.NEXTVAL, 
                      (SELECT DD_TCI_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TCI||' WHERE DD_TCI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),
                      (SELECT DD_NCI_ID FROM '||V_ESQUEMA||'.'||V_TABLA_NCI||' WHERE DD_NCI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''),
                      '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||V_USUARIO||''',SYSDATE)';
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

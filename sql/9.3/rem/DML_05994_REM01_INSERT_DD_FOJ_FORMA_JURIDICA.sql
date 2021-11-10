--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14267
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_FOJ_FORMA_JURIDICA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CODIGO_TABLA VARCHAR2(3 CHAR) := 'FOJ';
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-14267';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('1',	'Z1',	'S.L.',	'S.L.'),
            T_TIPO_DATA('2',	'50',	'S.A.',	'S.A.'),
            T_TIPO_DATA('3',	'Z0',	'C.Bienes o Herencia Yacente',	'C.Bienes o Herencia Yacente'),
            T_TIPO_DATA('4',	'Z2',	'S. Colectiva',	'S. Colectiva'),
            T_TIPO_DATA('5',	'Z3',	'Asociación o Fundación',	'Asociación o Fundación'),
            T_TIPO_DATA('6',	'Z4',	'S. Comanditaria',	'S. Comanditaria'),
            T_TIPO_DATA('7',	'Z5',	'Cooperativa',	'Cooperativa'),
            T_TIPO_DATA('8',	'Z6',	'Com. Propietarios',	'Com. Propietarios'),
            T_TIPO_DATA('9',	'Z7',	'S. Civil',	'S. Civil'),
            T_TIPO_DATA('10',	'Z8',	'Corp. Local',	'Corp. Local'),
            T_TIPO_DATA('11',	'Z9',	'Organismo Public.',	'Organismo Public.'),
            T_TIPO_DATA('12',	'Y0',	'C. Religiosa',	'C. Religiosa'),
            T_TIPO_DATA('13',	'Y1',	'Organismo estatal/autonómico',	'Organismo estatal/autonómico'),
            T_TIPO_DATA('14',	'Y2',	'UTE',	'UTE'),
            T_TIPO_DATA('15',	'Y3',	'Otro',	'Otro')
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
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_'||V_CODIGO_TABLA||'_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', DD_'||V_CODIGO_TABLA||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', DD_'||V_CODIGO_TABLA||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_'||V_CODIGO_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
  
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                      DD_'||V_CODIGO_TABLA||'_ID, DD_'||V_CODIGO_TABLA||'_CODIGO,DD_'||V_CODIGO_TABLA||'_CODIGO_C4C , DD_'||V_CODIGO_TABLA||'_DESCRIPCION,  DD_'||V_CODIGO_TABLA||'_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES
                      (S_'||V_TEXT_TABLA||'.NEXTVAL,  '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||V_USUARIO||''',SYSDATE)';
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

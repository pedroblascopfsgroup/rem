--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20191115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8274
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
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
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	COD_PROVINCIA NUMBER(25);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('Almería', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Cádiz', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Córdoba', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Granada', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Huelva', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Jaén', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Málaga', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Sevilla', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Huesca', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Teruel', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Zaragoza', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Asturias', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Baleares', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Las Palmas', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Santa C. Tenerife', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Cantabria', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Albacete', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('CiudadReal', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Cuenca', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Guadalajara', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Toledo', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Avila', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Burgos', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('León', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Palencia', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Salamanca', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Segovia', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Soria', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Valladolid', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Zamora', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Barcelona', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Girona', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Lleida', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Tarragona', 'José Maria Della Manzano', 'jdella'),
    	T_TIPO_DATA('Alicante', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Castellón', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Valencia', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Badajoz', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Cáceres', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('A Coruña', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Lugo', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Ourense', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Pontevedra', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Madrid', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Melilla', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Ceuta', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Murcia', 'Paloma Diez Blasco', 'pdiez'),
    	T_TIPO_DATA('Navarra', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Álava', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Vizcaya', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('Guipúzcoa', 'Mario Fuentes Martinez', 'mfuentesm'),
    	T_TIPO_DATA('La Rioja', 'Mario Fuentes Martinez', 'mfuentesm')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION/ACTUALIZACION EN ACT_GES_DIST_GESTORES');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS = 1 THEN
			V_SQL := 'SELECT TO_NUMBER(DD_PRV_CODIGO) FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO COD_PROVINCIA;
		
			--Comprobar el dato a insertar.
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES 
						WHERE TIPO_GESTOR = ''GFORM'' 
						AND COD_CARTERA = 11
						AND COD_SUBCARTERA = 65
						AND COD_PROVINCIA = '||COD_PROVINCIA||'';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS > 0 THEN				
			  -- Si existe se modifica.
			  V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES
						 SET NOMBRE_USUARIO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
						 , USERNAME = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
						 , USUARIOMODIFICAR = ''HREOS-8274''
						 , FECHAMODIFICAR = SYSDATE
						 WHERE TIPO_GESTOR = ''GFORM'' 
						 AND COD_CARTERA = 11
						 AND COD_SUBCARTERA = 65
						 AND COD_PROVINCIA = '||COD_PROVINCIA||'';
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: CONFIGURACIÓN DE GFORM, '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''  MODIFICADO CORRECTAMENTE');
		   ELSE
			-- Si no existe se inserta.
			  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL FROM DUAL';
			  EXECUTE IMMEDIATE V_MSQL INTO V_ID;
			  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES (
						  ID, 
						  TIPO_GESTOR, 
						  COD_CARTERA,
						  COD_SUBCARTERA,
						  COD_PROVINCIA,
						  NOMBRE_USUARIO,
						  USERNAME,
						  VERSION, 
						  USUARIOCREAR, 
						  FECHACREAR, 
						  BORRADO) 
						  SELECT '|| V_ID || ',
						  ''GFORM'',
						  11,
						  65,
						  '||COD_PROVINCIA||',
						  '''||TRIM(V_TMP_TIPO_DATA(2))||''',
						  '''||TRIM(V_TMP_TIPO_DATA(3))||''',
						  0, 
						  ''HREOS-8274'',
						  SYSDATE,
						  0 
						  FROM DUAL';
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: CONFIGURACIÓN DE GFORM, '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''  INSERTADO CORRECTAMENTE');
		  END IF;
	  ELSE
		  DBMS_OUTPUT.PUT_LINE('[INFO]: LA PROVINCIA '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' NO EXISTE');
	  END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_GES_DIST_GESTORES ACTUALIZADO CORRECTAMENTE ');

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

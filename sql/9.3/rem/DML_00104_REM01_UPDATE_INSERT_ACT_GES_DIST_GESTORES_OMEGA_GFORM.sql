--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20200227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9621
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
    	T_TIPO_DATA( 'Irene Sanchez Muñoz ', 'isanchezmu')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION/ACTUALIZACION EN ACT_GES_DIST_GESTORES');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	
    LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
		--Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES 
					WHERE TIPO_GESTOR = ''GFORM'' 
					AND COD_CARTERA = 11
					AND COD_SUBCARTERA = 65
					AND USERNAME LIKE ''%'||TRIM(V_TMP_TIPO_DATA(2))||'%'' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN				
			-- Si no existe se inserta.
			V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES (
				  ID, 
				  TIPO_GESTOR, 
				  COD_CARTERA,
				  COD_SUBCARTERA,
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
				  '''||TRIM(V_TMP_TIPO_DATA(1))||''',
				  '''||TRIM(V_TMP_TIPO_DATA(2))||''',
				  0, 
				  ''HREOS-9621'',
				  SYSDATE,
				  0 
				  FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: CONFIGURACIÓN DE GFORM CON USUARIO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''  INSERTADO CORRECTAMENTE');
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: CONFIGURACIÓN DE GFORM CON USUARIO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''  YA EXISTE.');
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

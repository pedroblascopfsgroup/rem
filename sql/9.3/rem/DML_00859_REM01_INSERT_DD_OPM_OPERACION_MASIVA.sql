--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14969
--## PRODUCTO=NO
--##
--## FINALIDAD: Script que añade en DD_OPM_OPERACION_MASIVA los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial 
--##		0.2 Se cambia el Array de insercion para su update. 
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TABLA VARCHAR2(30 CHAR):= 'DD_OPM_OPERACION_MASIVA';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-14969';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    T_FUNCION('CFGREC', 'Configuración de recomendación RC/DC','TAB_CONFIG_RECOMENDACION','s*,s,s*,s*,d,d,s')    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores en DD_OPM_OPERACION_MASIVA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_OPM_OPERACION_MASIVA] ');
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    LOOP
      V_TMP_FUNCION := V_FUNCION(I);
        
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||'.');
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_OPM_DESCRIPCION = '''||V_TMP_FUNCION(2)||''', 
              DD_OPM_DESCRIPCION_LARGA = '''||V_TMP_FUNCION(2)||''', 
              FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TMP_FUNCION(3)||'''), 
              USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE, 
              DD_OPM_VALIDACION_FORMATO = '''||V_TMP_FUNCION(4)||''' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||''' ';
        EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' actualizados correctamente.');
			ELSE
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
							(DD_OPM_ID, DD_OPM_CODIGO, DD_OPM_DESCRIPCION, DD_OPM_DESCRIPCION_LARGA, FUN_ID, USUARIOCREAR, FECHACREAR, DD_OPM_VALIDACION_FORMATO) 
							SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,	'''||V_TMP_FUNCION(1)||''','''||V_TMP_FUNCION(2)||''','''||V_TMP_FUNCION(2)||''',
							(SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TMP_FUNCION(3)||'''), 
							'''||V_USUARIO||''', SYSDATE, '''||V_TMP_FUNCION(4)||''' FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' insertados correctamente.');
				
		    END IF;	
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
EXIT;
--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8909
--## PRODUCTO=NO
--##
--## Finalidad: Script que ACTUALIZA o INSERTA en DD_OPM_OPERACION_MASIVA los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES: 
--##    T_FUNCION (<código>, <Descripción de FUN_FUNCIONES>, <Descripción Larga de FUN_FUNCIONES>, <tipo col 1>,...<tipo col n>)
--##    Nomenclatura:
--##      n: numérico.
--##      s: string.
--##      f: fecha.
--##      *: campo obligatorio, va detrás de cada tipo de campo.
--##    T_ARRAY_FUNCION Es un array multidimensional, usándose normalmente dos de ellas para componer
--##    un array que a su vez contiene varios arrays.
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Reemplaza a HREOS-7805 cambiando la obligatoriedad del campo DD_SFP_CODIGO, ya no es obligatorio
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia auxiliar a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_FUN_ID NUMBER(16); -- Vble. Para validar si existe el id en FUN_FUNCIONES
    V_TABLA_OPM VARCHAR2(30 CHAR); -- Vble para nombre de la tabla principal del DML
    V_TABLA_FUN_FUNCIONES VARCHAR(30 CHAR); -- Vble para uso en consultas auxiliares
    V_USUARIO VARCHAR2(25 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION( -- La última posición es la descripción de FUN_FUNCIONES
	     T_FUNCION('ACMT','API Automatizado: Carga masiva de trabajos', 'n*,n,s,s,s,s', 'CARGA_MASIVA_TRABAJOS')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  V_TABLA_OPM := 'DD_OPM_OPERACION_MASIVA';
	V_USUARIO := 'HREOS-8909'; -- Contiene el nombre del usuario que crea, modifica o borra, normalmente el Nº de item
  V_TABLA_FUN_FUNCIONES := 'FUN_FUNCIONES';
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '|| V_TABLA_OPM);

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
      V_TMP_FUNCION := V_FUNCION(I);
      
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_OPM||' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      V_FUN_ID := -1;
      V_MSQL_1 := ' SELECT FUN_ID FROM '||V_ESQUEMA_M||'.'||V_TABLA_FUN_FUNCIONES||' WHERE FUN_DESCRIPCION = '''||V_TMP_FUNCION(4)||'''';
			EXECUTE IMMEDIATE V_MSQL_1 INTO V_FUN_ID;

      IF V_NUM_TABLAS > 0 AND V_FUN_ID >= 0 THEN	  
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA_OPM||'...actualizando.');
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_OPM
              ||'  SET DD_OPM_DESCRIPCION ='''||V_TMP_FUNCION(2)
              ||''', DD_OPM_DESCRIPCION_LARGA = '''||V_TMP_FUNCION(2)||'''' 
              ||', VERSION = VERSION + 1, USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE, BORRADO = 0, DD_OPM_VALIDACION_FORMATO = '''
              ||V_TMP_FUNCION(3)||''' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||'''';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA_OPM||' actualizados correctamente.');
      ELSIF V_FUN_ID >= 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] No existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA_OPM||'...insertando.');

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_OPM
              ||' (DD_OPM_ID, DD_OPM_CODIGO, DD_OPM_DESCRIPCION, DD_OPM_DESCRIPCION_LARGA, FUN_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_OPM_VALIDACION_FORMATO)'
              ||' SELECT '||V_ESQUEMA||'.S_'||V_TABLA_OPM||'.NEXTVAL, '''||V_TMP_FUNCION(1)||''','''||V_TMP_FUNCION(2)||''','''||V_TMP_FUNCION(2)||''',('|| V_MSQL_1 ||'), 0,'''
              ||V_USUARIO||''', SYSDATE, 0, '''||V_TMP_FUNCION(3)||''' FROM DUAL';
              
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA_OPM||' insertados correctamente.');
      ELSIF V_FUN_ID<0 THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] No se localiza la función '||V_ESQUEMA_M||'.'||V_TABLA_FUN_FUNCIONES||', no se realizan cambios.');
      END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA_OPM||' ACTUALIZADO CORRECTAMENTE ');
   
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
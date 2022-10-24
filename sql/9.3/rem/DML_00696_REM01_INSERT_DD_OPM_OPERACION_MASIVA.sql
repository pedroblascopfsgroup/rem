--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17111
--## PRODUCTO=NO
--##
--## FINALIDAD: Script que añade en DD_OPM_OPERACION_MASIVA los datos añadidos en T_ARRAY_DATA.
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
    V_TABLA VARCHAR2(30 CHAR);
    V_USUARIOCREAR VARCHAR2(25 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	     T_FUNCION('CMO', 'Carga masiva de organismos', 'Carga masiva de organismos','CARGA_MASIVA_DE_ORGANISMOS','n*,s*,s*,f*,s*')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  V_TABLA := 'DD_OPM_OPERACION_MASIVA';
	V_USUARIOCREAR := 'HREOS-17111'; 
    -- LOOP para insertar los valores en DD_OPM_OPERACION_MASIVA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_OPM_OPERACION_MASIVA] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||'.');
        V_MSQL_1 := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET ' ||
        'DD_OPM_DESCRIPCION = '''||V_TMP_FUNCION(2)||''', ' ||
        'DD_OPM_DESCRIPCION_LARGA = '''||V_TMP_FUNCION(3)||''', ' ||
        'FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TMP_FUNCION(4)||'''), ' ||
        'USUARIOMODIFICAR = '''||V_USUARIOCREAR||''', ' ||
        'FECHAMODIFICAR = SYSDATE, ' ||
        'DD_OPM_VALIDACION_FORMATO = '''||V_TMP_FUNCION(5)||''' ' ||
        'WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||''' ';
        DBMS_OUTPUT.PUT_LINE(V_MSQL_1);

        EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' actualizados correctamente.');
			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||
							' (DD_OPM_ID, DD_OPM_CODIGO, DD_OPM_DESCRIPCION, DD_OPM_DESCRIPCION_LARGA, FUN_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_OPM_VALIDACION_FORMATO)' || 
							' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,' ||
							' '''||V_TMP_FUNCION(1)||''','''||V_TMP_FUNCION(2)||''','''||V_TMP_FUNCION(3)||''','||
							' (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TMP_FUNCION(4)||'''), '||
							' 0, '''||V_USUARIOCREAR||''', SYSDATE, 0, '''||V_TMP_FUNCION(5)||''' FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL_1;
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
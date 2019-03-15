--/*
--##########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5854
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en GRU_GRUPOS_USUARIOS los datos añadidos en T_ARRAY_FUNCION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 HREOS-5854 -> añadimos nuevos usuarios al grupo gruforadmto
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('achillon', 'gruforadmto'),
      T_FUNCION('gruforadmto', 'gruforadmto'),
      T_FUNCION('vmoreno', 'gruforadmto')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
	 
    -- LOOP para insertar los valores en USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN GRU_GRUPOS_USUARIOS] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS 
			WHERE USU_ID_USUARIO = 
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU1
				WHERE USU1.USU_USERNAME = '''||TRIM(V_TMP_FUNCION(1))||''') 
				AND USU_ID_GRUPO = 
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU1
				WHERE USU1.USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||''') ';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS...no se modifica nada.');
				
			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS' ||
							' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,' ||
							' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||'''),' ||							
							' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(1))||'''),' ||
							' 1,''HREOS-5274'',SYSDATE,0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: GRU_GRUPOS_USUARIOS ACTUALIZADO CORRECTAMENTE ');
   

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



   

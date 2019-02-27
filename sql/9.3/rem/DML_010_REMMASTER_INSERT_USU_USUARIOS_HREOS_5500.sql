--/*
--##########################################
--## AUTOR=Sergio Hernández
--## FECHA_CREACION=20190220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-5500
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en GRU_GRUPOS_USUARIOS los datos añadidos en T_ARRAY_DATA.
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
	
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-5500'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(

	T_FUNCION('cenahi01','cenahi01'),
	T_FUNCION('cenahi02','cenahi02'),
	T_FUNCION('cenahi03','cenahi03'),
	T_FUNCION('diagonal01','diagonal01'),
	T_FUNCION('diagonal02','diagonal02'),
	T_FUNCION('diagonal03','diagonal03'),
	T_FUNCION('emais01','emais01'),
	T_FUNCION('emais02','emais02'),
	T_FUNCION('emais03','emais03'),
	T_FUNCION('f&g01','f&g01'),
	T_FUNCION('f&g02','f&g02'),
	T_FUNCION('f&g03','f&g03'),
	T_FUNCION('garsa01','garsa01'),
	T_FUNCION('garsa02','garsa02'),
	T_FUNCION('garsa03','garsa03'),
	T_FUNCION('gestinova01','gestinova01'),
	T_FUNCION('gestinova02','gestinova02'),
	T_FUNCION('gestinova03','gestinova03'),
	T_FUNCION('gl01','gl01'),
	T_FUNCION('gl02','gl02'),
	T_FUNCION('gl03','gl03'),
	T_FUNCION('maretra01','maretra01'),
	T_FUNCION('maretra02','maretra02'),
	T_FUNCION('maretra03','maretra03'),
	T_FUNCION('mediterraneo01','mediterraneo01'),
	T_FUNCION('mediterraneo02','mediterraneo02'),
	T_FUNCION('mediterraneo03','mediterraneo03'),
	T_FUNCION('montalvo01','montalvo01'),
	T_FUNCION('montalvo02','montalvo02'),
	T_FUNCION('montalvo03','montalvo03'),
	T_FUNCION('ogf01','ogf01'),
	T_FUNCION('ogf02','ogf02'),
	T_FUNCION('ogf03','ogf03'),
	T_FUNCION('pinos01','pinos01'),
	T_FUNCION('pinos02','pinos02'),
	T_FUNCION('pinos03','pinos03'),
	T_FUNCION('qipert01','qipert01'),
	T_FUNCION('qipert02','qipert02'),
	T_FUNCION('qipert03','qipert03'),
	T_FUNCION('tecnotra01','tecnotra01'),
	T_FUNCION('tecnotra02','tecnotra02'),
	T_FUNCION('tecnotra03','tecnotra03'),
	T_FUNCION('tinsacer01','tinsacer01'),
	T_FUNCION('tinsacer02','tinsacer02'),
	T_FUNCION('tinsacer03','tinsacer03'),
	T_FUNCION('uniges01','uniges01'),
	T_FUNCION('uniges02','uniges02'),
	T_FUNCION('uniges03','uniges03')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' 
						WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') 
							AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
			
			-- Si existe la FILA
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' ...no se modifica nada.');
				
			ELSE

     		    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(1))||''' ';
    			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

			    IF V_NUM_TABLAS = 1 THEN

					V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||'' ||
								' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
								' SELECT '||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL' ||
								',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''')' ||
								',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')' ||
								',0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL';
			    	
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' insertados correctamente.');
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO] No existe los datos del usuario '||TRIM(V_TMP_FUNCION(1))||' ');
			    END IF;	
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

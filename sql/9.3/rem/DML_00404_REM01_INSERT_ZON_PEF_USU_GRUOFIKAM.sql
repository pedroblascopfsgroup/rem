--/*
--###########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11446
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
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-11446'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'ZON_PEF_USU';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
   	  T_FUNCION('gruofikam'),  
	  T_FUNCION('pcouto'),
	  T_FUNCION('ssanchez')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
						(ZON_ID
						, PEF_ID
						, USU_ID
						, ZPU_ID
						, VERSION
						, USUARIOCREAR
						, FECHACREAR
						, BORRADO)
						SELECT 
						19504 ZON_ID
						, PEF.PEF_ID PEF_ID
						, (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') USU_ID
						, '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL ZPU_ID
						, 0 VERSION
						, '''||V_USUARIO||''' USUARIOCREAR
						, SYSDATE FECHACREAR
						, 0
						FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
						JOIN '||V_ESQUEMA||'.ZON_PEF_USU ZPU ON USU.USU_ID = ZPU.USU_ID AND ZPU.BORRADO = 0
						JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON ZPU.PEF_ID = PEF.PEF_ID AND PEF.BORRADO = 0
						WHERE USU.BORRADO = 0 
						AND USU.USU_USERNAME = ''rchicharro''
						AND NOT EXISTS (SELECT 1 
						FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU_INT
						JOIN '||V_ESQUEMA||'.ZON_PEF_USU ZPU_INT ON USU_INT.USU_ID = ZPU_INT.USU_ID AND ZPU_INT.BORRADO = 0
						JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF_INT ON ZPU_INT.PEF_ID = PEF_INT.PEF_ID AND PEF_INT.BORRADO = 0
						WHERE USU_INT.BORRADO = 0 
						AND USU_INT.USU_USERNAME = '''||V_TMP_FUNCION(1)||'''
						AND PEF_INT.PEF_ID = PEF.PEF_ID)';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' insertados correctamente.');

		ELSE
			DBMS_OUTPUT.PUT_LINE('[ INFO ]: El usuario no existe.');
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

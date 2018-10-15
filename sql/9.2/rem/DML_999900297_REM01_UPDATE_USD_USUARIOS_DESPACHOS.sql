--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180809
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4390
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra en USD_USUARIOS_DESPACHOS los datos añadidos en T_ARRAY_FUNCION.
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
    V_SQL_2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --		USU_USERNAME			DES_DESPACHO
      T_FUNCION('jcordoba',			'gestsue') 
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para borrar los valores en USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN USD_USUARIOS_DESPACHOS] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
			WHERE DES_ID = 
				(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
				WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION(2))||''') 
				AND USU_ID = 
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(1))||''')';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN
				
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' || 
							' SET USUARIOBORRAR=''HREOS-4390'', FECHABORRAR=SYSDATE, BORRADO=1' || 
							' WHERE USU_ID=(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||TRIM(V_TMP_FUNCION(1))||''')' || 
							' AND DES_ID=(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO='''||TRIM(V_TMP_FUNCION(2))||''')';
				
				EXECUTE IMMEDIATE V_MSQL;
					  
				DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de despacho '''||TRIM(V_TMP_FUNCION(2))||''' para el usuario '''||TRIM(V_TMP_FUNCION(1))||''' en '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS... realizado correctamente.');
				
			ELSE

				DBMS_OUTPUT.PUT_LINE('[INFO] El despacho '''||TRIM(V_TMP_FUNCION(2))||''' con usuario '''||TRIM(V_TMP_FUNCION(1))||''' en '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS... no existe.');

			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: USD_USUARIOS_DESPACHOS ACTUALIZADO CORRECTAMENTE ');
   

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
   

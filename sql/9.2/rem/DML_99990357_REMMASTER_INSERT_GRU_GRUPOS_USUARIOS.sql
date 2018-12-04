--/*
--##########################################
--## AUTOR=Isidro Sotoca
--## FECHA_CREACION=20180828
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4446
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
	
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-4446'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    	--		USU_USERNAME_GRUPO		USU_USERNAME_USUARIO
   	  	T_FUNCION('lcmpart', 			'lcmpart')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar grupo en la tabla:'||V_ESQUEMA_M||'.'||V_TABLA||'.');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas.');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        
        V_TMP_FUNCION := V_FUNCION(I);
			  
        V_SQL := '
        	SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' 
				WHERE USU_ID_GRUPO = (
					SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') 
			 		AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')';
			  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			  IF V_NUM_TABLAS > 0 THEN	  
				
          DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el grupo para el USU_USERNAME '||TRIM(V_TMP_FUNCION(1))||' en la tabla.');
				
			  ELSE
				  V_MSQL := '
            INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' (
				GRU_ID, 
				USU_ID_GRUPO, 
				USU_ID_USUARIO, 
				VERSION, 
				USUARIOCREAR, 
				FECHACREAR, 
				BORRADO
			) 
			SELECT 
              	'||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL,
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||'''),
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||'''),
				0,
              	'''||V_USUARIO||''',
              	SYSDATE,
              	0
            FROM DUAL
        ';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Registro de grupo INSERTADO para el USU_USERNAME: '||TRIM(V_TMP_FUNCION(1))||'.');
				
		    END IF;	
      END LOOP;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TABLA||' actualizada correctamente.');
   
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
--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20211122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16479
--## PRODUCTO=NO
--##
--## Finalidad: Modiifcacion tabla MGP_MAPEO_GESTOR_DOC_PRO cliente Jaguar
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'MGP_MAPEO_GESTOR_DOC_PRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16479'; -- Usuario modificar
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_TABLA_PRO VARCHAR2(25 CHAR):='ACT_PRO_PROPIETARIO'; 

    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	    T_FUNCION('Jaguar', 'Promontoria Jaguar')
    );          
    V_TMP_FUNCION T_FUNCION;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||'] ');
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE BORRADO = 0 AND CLIENTE_GD =  '''||V_TMP_FUNCION(1)||''' ';
    
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

        IF V_NUM_TABLAS > 0 THEN
                
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' se actualizan');

                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET CLIENTE_GD = '''||V_TMP_FUNCION(2)||''', CLIENTE_WS = UPPER('''||V_TMP_FUNCION(2)||'''),
					USUARIOMODIFICAR = '''||V_USUARIO||''',FECHAMODIFICAR = SYSDATE
					WHERE CLIENTE_GD = '''||V_TMP_FUNCION(1)||'''
                    AND BORRADO = 0 ';
	            EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' modificado correctamente. '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' ');
            
        ELSE

        	DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' no modificados.');

        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

   

	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   			
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

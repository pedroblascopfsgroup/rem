--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14915
--## PRODUCTO=NO
--##
--## Finalidad: Se realiza un borrado logico con los datos de la tabla MGD_MAPEO_GESTOR_DOC
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Juan Bautista Alfonso - REMVIP-10428 Cambiar subcartera bfa
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
    V_TABLA_MGD VARCHAR2(25 CHAR):='MGD_MAPEO_GESTOR_DOC';
    V_TABLA_CRA VARCHAR2(25 CHAR):='DD_CRA_CARTERA';
    V_TABLA_SCR VARCHAR2(25 CHAR):='DD_SCR_SUBCARTERA';
    V_USUARIO VARCHAR2(25 CHAR):='HREOS-14915';
    
    V_CRA_VIEJA VARCHAR2(25 CHAR):='03';
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	T_FUNCION('17', '07', 'BFA', 'BFA')
    );          
    V_TMP_FUNCION T_FUNCION;
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
    -- LOOP para borrado logico los valores en MGD_MAPEO_GESTOR_DOC --
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION EN '||V_TABLA_MGD||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MGD||' WHERE DD_CRA_ID = 
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE DD_CRA_CODIGO = '''||V_CRA_VIEJA||''') 
							AND DD_SCR_ID = 
								(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SCR||' WHERE DD_SCR_CODIGO = '''||(V_TMP_FUNCION(2))||''')
                                AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA_MGD||'... SE ACTUALIZAN.');
                
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_MGD||' SET 
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE,
					DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||'''),
					CLIENTE_GD = '''||V_TMP_FUNCION(3)||''',
					CLIENTE_WS = '''||V_TMP_FUNCION(4)||'''
					WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE DD_CRA_CODIGO = '''||V_CRA_VIEJA||''') 
                    AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SCR||' WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||''')
                    AND BORRADO = 0 ';
	            EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA_MGD||' modificados correctamente. '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' - '''||V_TMP_FUNCION(3)||''' - '''||V_TMP_FUNCION(4)||''' ');
				
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe el registro en la tabla '||V_TABLA_MGD||' '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' - '''||V_TMP_FUNCION(3)||''' - '''||V_TMP_FUNCION(4)||''' ');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA_MGD||' ACTUALIZADA CORRECTAMENTE ');

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

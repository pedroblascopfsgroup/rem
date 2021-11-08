--/*
--##########################################
--## AUTOR=Remus Ovidiu Viorel
--## FECHA_CREACION=20211108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10707
--## PRODUCTO=NO
--##
--## Finalidad: Se añaden datos a la tabla MGD_MAPEO_GESTOR_DOC
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USUARIO VARCHAR2(150 CHAR):='REMVIP-10707';
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('03', '161', 'Caixabank', 'CAIXABANK'),
      T_FUNCION('03', '160', 'Caixabank', 'CAIXABANK'),
      T_FUNCION('18', '162', 'EDT', 'EDT'),
      T_FUNCION('18', '163', 'TDA', 'TDA')
    );          
    V_TMP_FUNCION T_FUNCION;
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
    -- LOOP para insertar los valores en MGD_MAPEO_GESTOR_DOC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN MGD_MAPEO_GESTOR_DOC] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC WHERE DD_CRA_ID = 
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||(V_TMP_FUNCION(1))||''') 
							AND DD_SCR_ID = 
								(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||(V_TMP_FUNCION(2))||''')
                                AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC...SE ACTUALIZAN.');
                
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC SET 
					CLIENTE_WS = '''||(V_TMP_FUNCION(4)) ||''',
                    			CLIENTE_GD = '''||(V_TMP_FUNCION(3)) ||''',
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE
					WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||''') 
                    AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||''')
                    AND BORRADO = 0 ';
	            EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC modificado correctamente. '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' - '''||V_TMP_FUNCION(3)||''' - '''||V_TMP_FUNCION(4)||''' ');
				
			ELSE

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC (' ||
					'MGD_ID, DD_CRA_ID, DD_SCR_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR, BORRADO, CLIENTE_WS) ' ||
					' SELECT '||V_ESQUEMA||'.S_MGD_MAPEO_GESTOR_DOC.NEXTVAL,' ||
					'(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||'''), '||
					'(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||'''), '''||
					(V_TMP_FUNCION(3)) ||''','''||V_USUARIO||''', SYSDATE, 0, '''||(V_TMP_FUNCION(4)) ||''' FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC insertados correctamente. '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' - '''||V_TMP_FUNCION(3)||''' - '''||V_TMP_FUNCION(4)||''' ');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: MGD_MAPEO_GESTOR_DOC ACTUALIZADO CORRECTAMENTE ');

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

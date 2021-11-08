--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211027
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16070
--## PRODUCTO=NO
--##
--## Finalidad: MOdiifcacion tabla MGD_MAPEO_GESTOR_DOC
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'MGD_MAPEO_GESTOR_DOC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16070'; -- Usuario modificar
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_TABLA_CRA VARCHAR2(25 CHAR):='DD_CRA_CARTERA';
    V_TABLA_SCR VARCHAR2(25 CHAR):='DD_SCR_SUBCARTERA';  

    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	    T_FUNCION('18', '162', 'Titulizada', 'TITULIZADA', 'I'),
        T_FUNCION('18', '163', 'Titulizada', 'TITULIZADA', 'I'),
        T_FUNCION('03', '09', '', '', 'D')
    );          
    V_TMP_FUNCION T_FUNCION;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||'] ');
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);

        IF V_TMP_FUNCION(5) = 'I' THEN
        
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE 
                    DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||''') 
                    AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SCR||' WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||''')
                    AND BORRADO = 0';
        
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

            IF V_NUM_TABLAS > 0 THEN
				  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.');
				
			ELSE

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                    (MGD_ID, DD_CRA_ID, DD_SCR_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR, CLIENTE_WS)
					SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||'''),
					(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SCR||' WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||'''),
                    '''||V_TMP_FUNCION(3)||''','''||V_USUARIO||''', SYSDATE, '''||V_TMP_FUNCION(4)||''' FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' insertados correctamente. 
                    COD CARTERA '''||V_TMP_FUNCION(1)||''' - COD SUBCARTERA '''||V_TMP_FUNCION(2)||''' - '''||V_TMP_FUNCION(3)||''' - '''||V_TMP_FUNCION(4)||''' ');

            END IF;

        ELSIF V_TMP_FUNCION(5) = 'D' THEN

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE 
                    DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||''') 
                    AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SCR||' WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||''')
                    AND BORRADO = 0';
        
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

            IF V_NUM_TABLAS = 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] No existe el registro en la tabla '||V_TEXT_TABLA||' '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||'''');

			ELSE
            
                DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||'. Borramos');

				V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
					        USUARIOBORRAR = '''||V_USUARIO||''',FECHABORRAR = SYSDATE,BORRADO = 1
        					WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||''') 
                            AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SCR||' WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||''')
                            AND BORRADO = 0 ';
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' borrados correctamente. 
                    COD CARTERA '''||V_TMP_FUNCION(1)||''' - COD SUBCARTERA '''||V_TMP_FUNCION(2)||'''');

            END IF;

        END IF;

    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');
   			
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

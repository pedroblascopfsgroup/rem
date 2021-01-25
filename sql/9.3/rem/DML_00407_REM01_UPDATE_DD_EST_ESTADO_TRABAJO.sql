2--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12223
--## PRODUCTO=NO
--##
--## Finalidad: Corregir campos codigo
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_DICCIONARIO VARCHAR2(2400 CHAR) := 'DD_EST_ESTADO_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de el diccionario de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-12223';
    VALIDACION VARCHAR2(2400 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_NUM NUMBER(16); -- Vble. auxiliar
    
BEGIN
	
	
	 -- Verificar si la tabla ya existe
  	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_DICCIONARIO||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  	IF V_NUM_TABLAS = 1 THEN
  	
                DBMS_OUTPUT.PUT_LINE('Actualizar descripción de tareas de '||V_TEXT_DICCIONARIO);
                
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_DICCIONARIO||' 
                        WHERE DD_EST_CODIGO = ''12'' ';

                EXECUTE IMMEDIATE V_MSQL INTO V_NUM;


                IF V_NUM = 1  THEN
                        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_DICCIONARIO||'
                                        SET FLAG_ACTIVO = 0
                                                        , USUARIOMODIFICAR = '''||V_USUARIO||'''
                                                        , FECHAMODIFICAR = SYSDATE
                                        WHERE  DD_EST_CODIGO = ''12'' ';

                        EXECUTE IMMEDIATE V_MSQL;

                        DBMS_OUTPUT.PUT_LINE('Actualizada las referencias de '||V_TEXT_DICCIONARIO);
                        COMMIT;
                END IF;
                
    	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO][FIN] NO EXISTE LA TABLA '||V_TEXT_DICCIONARIO);
	END IF;
	
	
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
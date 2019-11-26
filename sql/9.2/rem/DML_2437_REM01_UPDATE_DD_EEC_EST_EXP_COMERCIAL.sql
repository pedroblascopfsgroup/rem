--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20191125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8545
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la columna DD_EEC_DESCRIPCION de la tabla DD_EEC_EST_EXP_COMERCIAL
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-8545';
    VALIDACION VARCHAR2(2400 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_NUM NUMBER(16); -- Vble. auxiliar
    
    
BEGIN

        DBMS_OUTPUT.PUT_LINE('Actualizar descripción de tareas de '||V_TEXT_TABLA);
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''34'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_EEC_DESCRIPCION = ''Pendiente Resolución Advisory''
					, DD_EEC_DESCRIPCION_LARGA = ''Pendiente Resolución Advisory''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_EEC_CODIGO = ''34''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''37'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_EEC_DESCRIPCION = ''Denegada Oferta Advisory''
					, DD_EEC_DESCRIPCION_LARGA = ''Denegada Oferta Advisory''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_EEC_CODIGO = ''37''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''38'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_EEC_DESCRIPCION = ''Contraofertado Advisory''
					, DD_EEC_DESCRIPCION_LARGA = ''Contraofertado Advisory''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_EEC_CODIGO = ''38''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''39'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_EEC_DESCRIPCION = ''Reservado Pdte Propiedad''
					, DD_EEC_DESCRIPCION_LARGA = ''Reservado Pdte Propiedad''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_EEC_CODIGO = ''39''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''40'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_EEC_DESCRIPCION = ''Aprobado Pdte Propiedad''
					, DD_EEC_DESCRIPCION_LARGA = ''Aprobado Pdte Propiedad''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_EEC_CODIGO = ''40''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''41'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_EEC_DESCRIPCION = ''Denegado Propiedad''
					, DD_EEC_DESCRIPCION_LARGA = ''Denegado Propiedad''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE  DD_EEC_CODIGO = ''41''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);

    	END IF;
    	
    	DBMS_OUTPUT.PUT_LINE('Borrado de tareas de '||V_TEXT_TABLA);
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''30'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET
					 USUARIOBORRAR = '''||V_USUARIO||'''
					, FECHABORRAR = SYSDATE
					, BORRADO = 1
            		WHERE  DD_EEC_CODIGO = ''30''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Borrada tarea en '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''32'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET
					 USUARIOBORRAR = '''||V_USUARIO||'''
					, FECHABORRAR = SYSDATE
					, BORRADO = 1
            		WHERE  DD_EEC_CODIGO = ''32''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Borrada tarea en '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_EEC_CODIGO = ''33'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET
					 USUARIOBORRAR = '''||V_USUARIO||'''
					, FECHABORRAR = SYSDATE
					, BORRADO = 1
            		WHERE  DD_EEC_CODIGO = ''33''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Borrada tarea en '||V_TEXT_TABLA);

    	END IF;
    	
    	
    	COMMIT;
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
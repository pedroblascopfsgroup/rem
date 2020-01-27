--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20191208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8545
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la columna TAP_DESCRIPCION de la tabla TAP_TAREA_PROCEDIMIENTO
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-8545'; 
    VALIDACION VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16); -- Vble. auxiliar
    V_NUM NUMBER(16); -- Vble. auxiliar
    
    
BEGIN

        DBMS_OUTPUT.PUT_LINE('Actualizar descripción de tareas de '||V_TEXT_TABLA);
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO= ''T017'') AND TAP_CODIGO = ''T017_ResolucionCES'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET TAP_DESCRIPCION = ''Resolución Advisory''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO= ''T017'') AND  TAP_CODIGO = ''T017_ResolucionCES''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Actualizado descripción de tarea T017_ResolucionCES de '||V_TEXT_TABLA);

    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO= ''T017'') AND TAP_CODIGO = ''T017_RecomendCES'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET TAP_DESCRIPCION = ''Recomendación Advisory''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO= ''T017'') AND  TAP_CODIGO = ''T017_RecomendCES''';
            EXECUTE IMMEDIATE V_MSQL;
			    DBMS_OUTPUT.PUT_LINE('Actualizado descripción de tarea T017_RecomendCES de '||V_TEXT_TABLA);
    	END IF;
    	
    	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO= ''T017'') AND TAP_CODIGO = ''T017_RecomendCES'' ';

    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	IF V_NUM = 1 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET TAP_DESCRIPCION = ''Autorización Propiedad''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO= ''T017'') AND  TAP_CODIGO = ''T017_ResolucionPROManzana''';
            EXECUTE IMMEDIATE V_MSQL;
			    DBMS_OUTPUT.PUT_LINE('Actualizado descripción de tarea T017_ResolucionPROManzana de '||V_TEXT_TABLA);
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
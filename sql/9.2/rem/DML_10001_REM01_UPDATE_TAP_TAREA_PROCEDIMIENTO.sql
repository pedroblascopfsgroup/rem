--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5468
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la columna DD_TGE_ID de la tabla TAP_TAREA_PROCEDIMIENTO
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
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-5468';
    VALIDACION VARCHAR2(2400 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
BEGIN

        DBMS_OUTPUT.PUT_LINE('Actualizar descripción de trabajo de '||V_TEXT_TABLA);

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GACT'')
                      , DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''39'')
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
            		WHERE TAP_CODIGO = ''T016_ProcesoAdecuacion''';
            EXECUTE IMMEDIATE V_MSQL;

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GFORMADM'')
                      , DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''39'')
          , USUARIOMODIFICAR = '''||V_USUARIO||'''
          , FECHAMODIFICAR = SYSDATE
                WHERE TAP_CODIGO = ''T016_ComunicarGENCAT''';
            EXECUTE IMMEDIATE V_MSQL;
        
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
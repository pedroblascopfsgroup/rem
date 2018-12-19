--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20181219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5100
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar script validacion en tarea Obtención contrato reserva (comercial venta)
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-5100';
    VALIDACION VARCHAR2(2400 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
BEGIN

        DBMS_OUTPUT.PUT_LINE('Actualizar datos de '||V_TEXT_TABLA);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T015_DefinicionOferta'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET TAP_SCRIPT_VALIDACION_JBPM = ''checkEstadoOcupadoTramite() && checkConTituloTramite() == false ? ''''El activo se encuentra ocupado'''' : checkContratoSubido() ? (valores[''''T015_CierreContrato''''][''''docOK''''] != ''''false'''' ? null : ''''Debe marcar la casilla "Documentaci&#243;n OK" para poder avanzar la tarea.'''') : ''''Es necesario adjuntar sobre el Expediente Comercial, el documento Contrato.'''' ''
                    , USUARIOMODIFICAR = '''||V_USUARIO||'''
                    , FECHAMODIFICAR = SYSDATE
                    WHERE TAP_CODIGO = ''T015_CierreContrato''';
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando script_validacion_jbpm.......');
            EXECUTE IMMEDIATE V_MSQL;

        END IF;
        
    --COMMIT;
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
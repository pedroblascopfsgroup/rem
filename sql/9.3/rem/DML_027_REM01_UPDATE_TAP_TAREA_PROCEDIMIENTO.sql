--/*
--##########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6619
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar T017_InstruccionesReserva
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
    
    V_USU_MODIFICAR VARCHAR2(1024 CHAR):= 'HREOS-6619';
    V_TABLA VARCHAR2(2400 CHAR):= 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TAP_CODIGO VARCHAR2(1024 CHAR):= 'T017_InstruccionesReserva';
    V_VALIDACION VARCHAR2(2000 CHAR) := 'checkImporteParticipacion() ? (checkCompradores() ? checkProvinciaCompradores() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Todos los compradores tienen que tener provincia informada'''' : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente''''';
    V_VALIDACION_JBPM VARCHAR2(2000 CHAR) := 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente''''';
    
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO] Comienza el proceso de actualización en '||V_ESQUEMA||'.'||V_TABLA||' ...');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');

    DBMS_OUTPUT.PUT_LINE('[INFO] Se comprueba la existencia de la tabla '||V_TABLA||'... ');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''' AND BORRADO = 0';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

      IF V_NUM_TABLAS > 0 THEN

          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                    TAP_SCRIPT_VALIDACION = '''||V_VALIDACION||''',
                    TAP_SCRIPT_VALIDACION_JBPM = '''||V_VALIDACION_JBPM||''',
                    USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', 
                    FECHAMODIFICAR = SYSDATE 
                    WHERE TAP_CODIGO = '''||V_TAP_CODIGO||'''';
          
          DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tarea '||V_TAP_CODIGO||'...');
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] OK');

      ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] KO. '||V_TAP_CODIGO||' no existe ');
      END IF;

    ELSE
       DBMS_OUTPUT.PUT_LINE('[INFO] KO. '||V_TABLA||' no existe ');
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
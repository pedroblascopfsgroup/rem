--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.4-hy
--## INCIDENCIA_LINK=HR-1030
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar mensajes de validacion
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
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

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');


EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] == null || valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] == '''''''' || valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] == ''''0'''' ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'''': (cuentaCreditosInsinuadosExt()!=valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'''' : null)'' WHERE TAP_CODIGO = ''H009_RegistrarInsinuacionCreditos''';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] == null || valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] == '''''''' || valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] == ''''0'''' ? (cuentaCreditosInsinuadosSup() != ''''0'''' ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'''' : null) : (cuentaCreditosInsinuadosSup()!=valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'''' : null)'' WHERE TAP_CODIGO = ''H009_RevisarInsinuacionCreditos''';

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

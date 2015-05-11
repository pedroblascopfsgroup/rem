--/*
--##########################################
--## Author: JoseVi
--## Finalidad: DML
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

-- FASE-1151
DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAP_TAREA_PROCEDIMIENTO - Incidencia FASE-1151...');
EXECUTE IMMEDIATE ('  update '||V_ESQUEMA||'.tfi_tareas_form_items '||
	' set tfi_label = ''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deber&aacute; de acceder a la pestaña Gestores del asunto correspondiente y asignar el tipo de gestor "Gestor&iacute;a adjudicaci&oacute;n" seg&uacute;n el protocolo que tiene establecido la entidad.</p><p>A trav&eacute;s de esta pantalla se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p>Una vez confirmado con el procurador el env&iacute;o a la gestor&iacute;a, se deber&aacute; consignar dicha fecha en el campo "Fecha env&iacute;o a Gestor&iacute;a".</p><p>Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripci&oacute;n deber&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Obtenido el testimonio, se revisar&aacute; la fecha de expedici&oacute;n para liquidaci&oacute;n de impuestos en plazo, seg&uacute;n normativa de CCAA. La verificaci&oacute;n de la fecha del t&iacute;tulo es necesaria y fundamental para que la gestor&iacute;a pueda realizar la liquidaci&oacute;n en plazo.</li><li style="margin-bottom: 10px; margin-left: 35px;">Adicionalmente se revisar&aacute;n el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripci&oacute;n. Contenido b&aacute;sico para revisar en testimonio decreto de adjudicaci&oacute;n y mandamientos:</li><ul style="list-style-type: circle;"><li style="margin-bottom: 10px; margin-left: 50px;">Datos procesales b&aacute;sicos: (No autos, tipo de procedimiento, cantidad reclamada)</li><li style="margin-bottom: 10px; margin-left: 50px;">Datos de la Entidad demandante (nombre CIF, domicilio) y cesionaria (en caso de cesi&oacute;n de remate a Fondos de titulizaci&oacute;n)</li><li style="margin-bottom: 10px; margin-left: 50px;">Datos de los demandados y titulares registrales.</li><li style="margin-bottom: 10px; margin-left: 50px;">Importe de adjudicaci&oacute;n y cesi&oacute;n de remate (en su caso).</li><li style="margin-bottom: 10px; margin-left: 50px;">Orden de cancelaci&oacute;n de la nota marginal y cancelaci&oacute;n de la carga objeto de ejecuci&oacute;n as&iacute; como cargas posteriores).</li><li style="margin-bottom: 10px; margin-left: 50px;">Descripci&oacute;n y datos registrales completos de la finca adjudicada.</li><li style="margin-bottom: 10px; margin-left: 50px;">Declaraci&oacute;n en el auto de la firmeza de la resoluci&oacute;n</li></ul></ul><p>Una vez analizados los puntos descritos, en el campo Requiere subsanaci&oacute;n deber&aacute; indicar el resultado de dicho an&aacute;lisis.</p><p>Para dar por terminada esta tarea deber&aacute; de adjuntar al asunto correspondiente una copia escaneada del decreto firme de adjudicaci&oacute;n.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzar&aacute;, en caso de requerir subsanaci&oacute;n el tr&aacute;mite de subsanaci&oacute;n de adjudicaci&oacute;n, y en caso contrario se lanzar&aacute; por un lado la tarea "Registrar entrega del t&iacute;tulo" y por otro el tr&aacute;mite de posesi&oacute;n.</p></div>'' ' ||
	' where ' ||
	' tfi_nombre = ''titulo'' ' ||
	' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P413_ConfirmarTestimonio'') ');


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

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


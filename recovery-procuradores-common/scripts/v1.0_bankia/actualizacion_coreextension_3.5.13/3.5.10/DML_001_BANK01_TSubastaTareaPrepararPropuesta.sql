--/*
--##########################################
--## Author: Óscar
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

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


execute immediate 'delete from '||V_ESQUEMA||'.tfi_tareas_form_items where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta'')';

execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta''), 0, ''label'', ''titulo'', 
''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">'||
'Antes de completar esta tarea deberá esperar a que estén disponibles en Recovery todas las tasaciones correspondientes a los bienes afectos a la subasta, esto lo podrá consultar a través de la pestaña Subastas del asunto correspondiente.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los lotes afectos a la subasta e indicar el tipo de subas y los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podrá generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo. En cualquier caso  deberá adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en la que da por finalizada la preparación de instrucciones para la subasta.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través del campo “Suspender subasta” y “Motivo suspensión” podrá indicar si desea suspender la subasta, en cuyo caso no será necesario completar los valores de las instrucciones de subasta  pero sí consignar el motivo por el cual suspende la subasta.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de los datos introducidos la siguiente tarea podrá ser:'||
   '<ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">	En caso de que la subasta sea delegada y no haya propuesto suspensión de la misma, se lanzará la tarea “Lectura y aceptación de instrucciones” a realizar por el letrado.</p>'||
   '</li><li style="margin-bottom: 10px; margin-left: 35px;">	En caso de que la subasta sea delegada y no haya propuesto suspensión de la misma y de que bien la persona demandada sea jurídica o bien alguno de los bienes subastados sea de tipo suelos, promociones o bajo, se lanzará el trámite de tributación a la vez que se lanza la tarea “Lectura y aceptación por parte de letrado”.</p>'||
   '</li><li style="margin-bottom: 10px; margin-left: 35px;">	En caso de que la subasta no sea delegada o haya propuesto suspensión de la misma, se lanzará la tarea “Validar propuesta de instrucciones” a realizar por el supervisor de la entidad.</li></ul></div>'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta''), 1, ''combo'', ''comboTipo'', ''Tipo subasta'', ''dameTipoSubasta()'', ''DDTipoSubasta'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta''), 2, ''date'', ''fechaDecision'', ''Fecha'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', ''valor != null && valor != '''''''' ? true : false'', 0, ''DML'', sysdate, 0)';

execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta''), 3, ''combo'', ''comboSuspension'', ''Suspender subasta'', ''valores[''''P401_PrepararPropuestaSubasta''''][''''comboSuspension'''']'', ''DDSiNo'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta''), 4, ''combo'', ''motivoSuspension'', ''Motivo suspensión'', ''valores[''''P401_PrepararPropuestaSubasta''''][''''motivoSuspension'''']'', ''DDMotivoSuspSubasta'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta''), 6, ''textarea'', ''observaciones'', ''Observaciones'', 0, ''DML'', sysdate, 0)';


execute immediate 'delete from '||V_ESQUEMA||'.tfi_tareas_form_items where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta'')';

execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta''), 0, ''label'', ''titulo'', 
''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">'||
'Antes de completar esta tarea deberá esperar a que estén disponibles en Recovery todas las tasaciones correspondientes a los bienes afectos a la subasta, esto lo podrá consultar a través de la pestaña Subastas del asunto correspondiente.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los lotes afectos a la subasta e indicar el tipo de subas y los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podrá generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo. En cualquier caso  deberá adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en la que da por finalizada la preparación de instrucciones para la subasta.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través del campo “Suspender subasta” y “Motivo suspensión” podrá indicar si desea suspender la subasta, en cuyo caso no será necesario completar los valores de las instrucciones de subasta  pero sí consignar el motivo por el cual suspende la subasta.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>'||
   '<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de los datos introducidos la siguiente tarea podrá ser:<ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">'||
   'En caso de que la subasta sea delegada y no haya propuesto suspensión de la misma, se lanzará la tarea “Lectura y aceptación de instrucciones” a realizar por el letrado.</li><li style="margin-bottom: 10px; margin-left: 35px;">'||
   'En caso de que la subasta sea delegada y no haya propuesto suspensión de la misma y de que bien la persona demandada sea jurídica o bien alguno de los bienes subastados sea de tipo suelos, promociones o bajo, se lanzará el trámite de tributación a la vez que se lanza la tarea “Lectura y aceptación por parte de letrado”.</li><li style="margin-bottom: 10px; margin-left: 35px;">'||
   'En caso de que la subasta no sea delegada o haya propuesto suspensión de la misma, se lanzará la tarea “Validar propuesta de instrucciones” a realizar por el supervisor de la entidad.</li></ul></div>'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta''), 1, ''combo'', ''comboTipo'', ''Tipo subasta'', ''dameTipoSubasta()'', ''DDTipoSubasta'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta''), 2, ''date'', ''fechaDecision'', ''Fecha decisión'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', ''valor != null && valor != '''''''' ? true : false'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta''), 3, ''combo'', ''comboSuspension'', ''Suspender subasta'', ''valores[''''P409_PrepararPropuestaSubasta''''][''''comboSuspension'''']'', ''DDSiNo'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta''), 4, ''combo'', ''motivoSuspension'', ''Motivo suspensión'', ''valores[''''P409_PrepararPropuestaSubasta''''][''''motivoSuspension'''']'', ''DDMotivoSuspSubasta'', 0, ''DML'', sysdate, 0)';
execute immediate 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta''), 6, ''textarea'', ''observaciones'', ''Observaciones'', 0, ''DML'', sysdate, 0)';



execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_decision = ''valores[''''P401_PrepararPropuestaSubasta''''][''''comboSuspension''''] == DDSiNo.SI ? ''''subastaNoDelegada'''' : decidirPrepararPropuestaSubasta()'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_decision = ''valores[''''P409_PrepararPropuestaSubasta''''][''''comboSuspension''''] == DDSiNo.SI ? ''''subastaNoDelegada'''' : decidirPrepararPropuestaSubasta()'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/tramiteSubasta/prepararPropuestaSubasta'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararPropuestaSubasta'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/tramiteSubasta/prepararPropuestaSubasta'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararPropuestaSubasta'')';



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


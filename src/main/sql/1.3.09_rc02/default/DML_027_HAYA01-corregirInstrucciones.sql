/*
--######################################################################
--## Author: Roberto
--## Tarea: http://link.pfsgroup.es/jira/browse/HR-532
--## Finalidad: Modificación del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
BEGIN	
	
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; informar la fecha con la que se nos comunica mediante correo electr&oacute;nico por la Administraci&oacute;n Concursal el proyecto de inventario.</p><p style="margin-bottom: 10px">Igualmente, deberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&oacute;n Concursal. En el caso de que sea favorable, se deber&aacute; esperar a la siguiente tarea sobre el informe presentado por la Administraci&oacute;n Concursal ante el juez.</p><p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&aacute; comprobar si el error ha sido cometido por la Entidad a la hora de elaborar la insinuaci&oacute;n de cr&eacute;ditos. Si la insinuaci&oacute;n ha sido correcta deber&aacute; ponerse en contacto con la Administraci&oacute;n Concursal para su aclaraci&oacute;n. Con independencia de que se aclarada o no la discrepancia con la Administraci&oacute;n Concursal, se deber&aacute; remitir igualmente correo electr&oacute;nico a la Administraci&oacute;n Concursal solicitando su subsanaci&oacute;n para su constancia por escrito, haciendo menci&oacute;n en su caso de la aclaraci&oacute;n efectuada previamente.</p><p style="margin-bottom: 10px">En aquellos casos en los que la discrepancia sea relevante deber&aacute; informar al supervisor mediante comunicado o notificaci&oacute;n para anticipar la posibilidad de que sea necesario interponer un incidente de impugnaci&oacute;n una vez presentado el informe en el Juzgado. En todo caso, tanto si el proyecto es favorable como desfavorable, deberemos modificar el estado de todos los cr&eacute;ditos al estado "3. Pendiente revisi&oacute;n IAC" para completar esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de ser favorable "Registrar informe de la administraci&oacute;n concursal" y en caso contrario "Presentar rectificaci&oacute;n".</p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H009_RegistrarProyectoInventario'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;     
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez interpuesta la demanda y admitida, en esta pantalla ha de indicar si se ha producido oposición a la demanda y si hay vista.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Para el supuesto de que haya más de un demandado y alguno de ellos se oponga y otros se allamen a la misma, se deberá informar dicha circunstancia en el campo observaciones.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">- En el supuesto de que exista oposición de la parte demandada y no haya vista, deberá informar su fecha de notificación correspondiente y, la siguiente tarea será "Admisión de oposición y señalamiento de vista".&nbsp;</span></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">- En el caso de que exista oposición y vista, se deberá informar de la fecha de la vista. La siguiente tarea será "Registrar vista".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">- Si no existe oposición ni vista la siguiente tarea será "Registrar resolución".&nbsp;</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.&nbsp;</span></p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H023_confirmarOposicion'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea se lanzar&aacute; autom&aacute;ticamente si Sareb ha dictaminado en la fase de convenio si se debe registrar convenio propio. Para dar por finalizada esta tarea, deber&aacute; registrar la propuesta de convenio en la herramienta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar convenio propio", y, dependiendo de su dictamen, el responsable de realizar la tarea, ser&aacute; el supervisor o el gestor asociado al procedimiento.</p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H037_determinarConfeccionDeConvenio'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones al informe de la Administraci&oacute;n Concursal, al pulsar Aceptar el sistema comprobar&aacute; que el estado de los cr&eacute;ditos insinuados en la pestaña Fase Com&uacute;n es, en caso de presentar alegaciones "4. Pendiente de demanda incidental" o en caso contrario "6. Reconocido". Para ello debe abrir el asunto correspondiente, ir a la pestaña "Fase Com&uacute;n" y abrir la ficha de cada uno de los cr&eacute;ditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea,<ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;"> En caso de no presentar alegaciones ser&aacute; "Registrar resoluci&oacute;n de finalizaci&oacute;n fase com&uacute;n".</li><li style="margin-bottom: 10px; margin-left: 35px;"> En caso de haberse presentado alegaciones se lanzar&aacute; la tarea "Validar alegaciones" al supervisor del concurso y, el letrado deber&aacute; presentar el informe.</li></ul></p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H009_RevisarResultadoInfAdmon'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones al informe de la Administraci&oacute;n Concursal, al pulsar Aceptar el sistema comprobar&aacute; que el estado de los cr&eacute;ditos insinuados en la pestaña Fase Com&uacute;n es, en caso de presentar alegaciones "4. Pendiente de demanda incidental" o en caso contrario "6. Reconocido". Para ello debe abrir el asunto correspondiente, ir a la pestaña "Fase Com&uacute;n" y abrir la ficha de cada uno de los cr&eacute;ditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea,<ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;"> En caso de no presentar alegaciones ser&aacute; "Registrar resoluci&oacute;n de finalizaci&oacute;n fase com&uacute;n".</li><li style="margin-bottom: 10px; margin-left: 35px;"> En caso de haberse presentado alegaciones se lanzar&aacute; la tarea "Validar alegaciones" al supervisor del concurso y, el letrado deber&aacute; presentar el informe.</li></ul></p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; de informar la fecha de presentaci&oacute;n en Notaria de la escritura devuelta por el Registrador para su subsanaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Entregar nueva escritura p&uacute;blica de propiedad".</p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H065_registrarPresentacionEscrituraSub'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; de informar de la fecha en que recibe la informaci&oacute;n sobre los documentos asignados que se le han enviado.</p><p style="margin-bottom: 10px">Antes de dar por terminada esta tarea deber&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">- Liquidar impuestos  en  plazo  seg&uacute;n CCAA. En caso de personas jur&iacute;dicas existir&aacute; una consulta previa realizada sobre la posible liquidaci&oacute;n de IVA. Esta informaci&oacute;n podr&aacute; consultarla a trav&eacute;s de la ficha de cada uno de los bienes incluidos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Verificar situaci&oacute;n ocupacional de la finca para manifestaci&oacute;n de libertad arrendamientos de cara a inscripci&oacute;n (LAU).</p><p style="margin-bottom: 10px; margin-left: 40px;">- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentaci&oacute;n  en el registro junto con el testimonio y los mandamientos.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Realizar notificaci&oacute;n fehaciente a inquilinos para la inscripci&oacute;n  (en casos de inmueble con arrendamiento reconocido)</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar presentaci&oacute;n en hacienda".</p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H066_registrarEntregaTitulo'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; presentar la liquidaci&oacute;n del testimonio en Hacienda, una vez realizado esto deber&aacute; adjuntar al procedimiento correspondiente copia escaneada del documento de liquidaci&oacute;n de impuestos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar presentaci&oacute;n en el registro".</p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H066_registrarPresentacionHacienda'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En caso de que se haya tenido que presentar subsanación y por tanto estemos a la espera de recibir el nuevo testimonio decreto de adjudicación, en el campo fecha nuevo testimonio debe reflejar la fecha en la que se recibe el nuevo testimonio.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla se lanzará la tarea "Registrar inscripción del título".</span></p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H066_registrarPresentacionRegistro'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p class="MsoNormal"><span style="font-size: 8pt; line-height: 115%; font-family: Arial, sans-serif;">Para dar por finalizada esta tarea deberá de revisar y dictaminar sobre la propuesta de informe de subasta e informar si la propuesta es delegada si o no.<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:0cm;margin-bottom:.0001pt"><span style="font-size: 8pt; line-height: 115%; font-family: Arial, sans-serif;">¿ En caso de seguir con la subasta y la propuesta esté delegada internamente&nbsp; y disponga de atribuciones, se lanzará la tarea de&nbsp; "Lectura y aceptación&nbsp; de Instrucciones" y en el caso que no tenga atribuciones suficientes, se lanzará la tarea de "Elevar Propuesta a Comité" para&nbsp; la aprobación por el Comite.<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:0cm;margin-bottom:.0001pt"><span style="font-size: 8pt; line-height: 115%; font-family: Arial, sans-serif;">¿ En caso que se dictamine la suspensión de la subasta, se lanzará la tarea&nbsp; de "Solicitar suspensión de subasta" a realizar por el letrado.<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:0cm;margin-bottom:.0001pt"><span style="font-size: 8pt; line-height: 115%; font-family: Arial, sans-serif;">¿ ¿Preparar propuesta informe de subasta¿ En caso de haber requerido al supervisor la modificación de las instrucciones para la subasta.<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:0cm;margin-bottom:.0001pt"></p><p class="MsoNormal" style="margin-bottom:0cm;margin-bottom:.0001pt"><span style="font-size: 8pt; line-height: 115%; font-family: Arial, sans-serif;">¿ En caso de que indique que no dispone de atribución para decidir sobre la subasta, se lanzará la tarea "Elevar propuesta a Sareb" para obtener instrucciones desde Sareb.<o:p></o:p></span></p><p style="margin-bottom: 10px"></p><p class="MsoNormal"><span style="font-size: 8pt; line-height: 115%; font-family: Arial, sans-serif;">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</span><o:p></o:p></p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H003_ValidarPropuesta'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Dado que se han de preparar instrucciones para una subasta no delegada, deberá presentar vía workflow la propuesta a Sareb para recibir instrucciones de Subasta.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por completada esta tarea también deberá adjuntar la siguiente documentación dependiendo del tipo de bien a subastar:</span></font></p><p style="margin: 0cm 0cm 0.0001pt; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;"><span style="font-size: 8pt; font-family: Arial, sans-serif;">- Plantilla subasta SAREB: Siempre</span><span style="font-size: 13.5pt;"><o:p></o:p></span></p><p style="margin: 0cm 0cm 0.0001pt; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;"><span style="font-size: 8pt; font-family: Arial, sans-serif;">- Front-sheet SAREB: Cuando el bien es de tipo suelo u obra nueva</span><span style="font-size: 13.5pt;"><o:p></o:p></span></p><p style="margin: 0cm 0cm 0.0001pt; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;"><span style="font-size: 8pt; font-family: Arial, sans-serif;">- Ficha suelo SAREB: Cuando el bien es de tipo suelo.</span><span style="font-size: 13.5pt;"><o:p></o:p></span></p><p style="margin: 0cm 0cm 0.0001pt; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;"><span style="font-size: 8pt; font-family: Arial, sans-serif;">-  Due Diligence en caso de haberla solicitado.</span><span style="font-size: 13.5pt;"><o:p></o:p></span></p><p style="margin: 0cm 0cm 0.0001pt; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;"><span style="font-size: 8pt; font-family: Arial, sans-serif;">- Tasación</span><span style="font-size: 13.5pt;"><o:p></o:p></span></p><p style="margin: 0cm 0cm 0.0001pt; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;"><span style="font-size: 8pt; font-family: Arial, sans-serif;">- Edicto + PLAN DE LIQUIDACIÓN + NOTAS SIMPLES ACTUALIZADAS</span></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En cualquier caso, para dar por terminada esta tarea, deberá adjuntar el informe con la propuesta de instrucciones para la subasta al asunto correspondiente.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo Fecha indicar la fecha de presentación de la solicitud vía workflow, el tipo de porpuesta y el num.propuesta.</span></font></p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H003_ElevarPropuestaASareb'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := '  update tfi_tareas_form_items '
    		|| ' set tfi_label=''<div align="justify" style="margin-bottom: 30px;"><p style="color: rgb(0, 0, 0); font-family: Arial; font-size: 8pt; margin-bottom: 10px;">Para dar por finalizada esta tarea deberá  revisar y dictaminar sobre la propuesta de instrucciones  e informar si la propuesta es delegada o no.</p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">* En caso de seguir con la subasta y la propuesta esté delegada internamente &nbsp;y disponga de atribuciones, se lanzará la tarea de &nbsp;"Lectura y aceptación &nbsp;de Instrucciones" y en el caso que no tenga atribuciones suficientes, se lanzará la tarea de "Elevar Propuesta a Comité" para &nbsp;la aprobación por el Comite.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">- En caso que se dictamine la suspensión de la subasta, se lanzará la tarea &nbsp;de "Solicitar suspensión de subasta" a realizar por el letrado.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">- "Preparar propuesta informe de subasta" en caso de haber requerido al supervisor la modificación de las instrucciones para la subasta.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">- En caso de la subasta sea No Delegada para decidir sobre la subasta, se lanzará la tarea "Elevar propuesta a Sareb" para obtener instrucciones desde Sareb.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</span></p></div>'' '
    		|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H004_ValidarPropuesta'') and tfi_nombre=''titulo'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
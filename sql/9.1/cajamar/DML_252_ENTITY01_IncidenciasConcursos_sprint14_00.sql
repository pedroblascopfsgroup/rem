--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20151021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hy
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Concursos
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-879');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
		  ' SET TAP_SCRIPT_VALIDACION = ''dameSiguienteFechaVencimiento() == null ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">No existen cr&eacute;ditos contingentes pr&oacute;ximos en el tiempo.</p></div>'''' : null'' ' ||
          ' ,TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''CJ003_RevisarCreditosContingentes''''][''''comboSeguimiento''''] == DDSiNo.SI && !existeSiguienteFechaVencimiento() ? ''''No existen cr&eacute;ditos contingentes pr&oacute;ximos en el tiempo.'''' : null'' ' ||
          ' WHERE TAP_CODIGO = ''CJ003_RevisarCreditosContingentes'' ';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''CJ007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI) && ((valores[''''CJ007_Impugnacion''''][''''fechaImpugnacion''''] == ''''''''))) ? ''''tareaExterna.error.CJ007_Impugnacion.fechasOblgatorias'''' : ((valores[''''CJ007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI) && (!comprobarExisteDocumentoEIC())) ? ''''Es necesario adjuntar el escrito de impugnaci&oacute;n (Costas)'''' : null'' ' ||
          ' WHERE TAP_CODIGO = ''CJ007_Impugnacion'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-879');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-898');
	V_TAREA:='CJ004_CelebracionSubasta';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente información:</p><p style="margin-bottom: 10px">-En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deberá indicar a través de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.</p><p style="margin-bottom: 10px">-En la ficha del bien se debe recoger el resultado de la  adjudicación y el valor de la adjudicación.</p><p style="margin-bottom: 10px">-En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo "Celebrada", en el campo “Decisión suspensión” deberá informar quien ha provocado dicha suspensión y en el campo “Motivo suspensión” deberá indicar el motivo por el cual se ha suspendido.</p><p style="margin-bottom: 10px">-En caso de haberse adjudicado alguno de los bienes la Entidad, deberá indicar si ha habido Postores o no en la subasta y en el campo Cesión deberá indicar si se debe cursar la cesión de remate o no, según el procedimiento establecido por la entidad.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá adjuntar el acta de subasta al procedimiento a través de la pestaña "Adjuntos".</p><p style="margin-bottom: 10px">La siguiente tarea será:</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes adjudicados a un tercero, se lanzará la tarea “Solicitar mandamiento de pago”.</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes adjudicados a la entidad con o sin cesión de remate, se lanzará una tarea en la que se indica finaliza la gestión en la herramienta. La adjudicación y la cesión de remate deberán registrarse mediante un sistema externo a Recovery</p><p style="margin-bottom: 10px">-En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisión suspensión” deberá informar quien ha provocado dicha suspensión y en el campo “Motivo suspensión” ' ||
	  'deberá indicar el motivo por el cual se ha suspendido. En este caso, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p><p style="margin-bottom: 10px">-En caso de que se celebre la subasta, además, de lo indicado anteriormente, se lanzará la tarea "Actualizar deuda presentada en el juzgado".</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-898');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-897');
	V_TAREA:='CJ004_CelebracionSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumento(''''ACS'''') ? null  :  ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Acta de subasta</div>'''''', TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''CJ004_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? (valores[''''CJ004_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo Decisi&oacute;n suspensi&oacute;n es obligatorio</div>'''' : null) : (validarBienesDocCelebracionSubasta() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate</div>'''')'' WHERE TAP_CODIGO = '''||V_TAREA ||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-897');
	
	-------Parte alberto
	-------Es para el sprint 15, al ser modificaciones breves, no se crea nuevo script.
	-------Se cambia la fecha de este para que la petertool lo reconozca
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-928');
	V_TAREA:='CJ004_AdjuntarInformeOficina';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''CJ004_AdjuntarInformeOficina''''][''''comboEdificacion''''] == DDSiNo.SI && valores[''''CJ004_AdjuntarInformeOficina''''][''''comboFinalizada''''] == DDSiNo.SI && valores[''''CJ004_AdjuntarInformeOficina''''][''''comboDocumentacion''''] == DDSiNo.SI ? (comprobarExisteDocumentoCERFIO() ? (comprobarExisteDocumentoLICPRIO() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Licencia primera ocupaci&oacute;n.</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Certificado final de obra.</div>'''') : null'' WHERE TAP_CODIGO = '''||V_TAREA ||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-928');
		
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
--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.4
--## INCIDENCIA_LINK=HR-1040
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite Adjudicacion
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H005';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    
    V_TAREA VARCHAR(30 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''comprobarBienAsociadoPrc() ? (comprobarExisteDocumentoESADJ() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el documento "Escrito solicitud adjudicaci&oacute;n"</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_SolicitudDecretoAdjudicacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_SolicitudDecretoAdjudicacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoDFA() ? (comprobarExisteDocumentoMCC() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento "Mandamiento de cancelaci&oacute;n de cargas".</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>'''' ''' ||
			  ' WHERE TAP_CODIGO = ''H005_ConfirmarTestimonio''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_ConfirmarTestimonio actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoDPRCD() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento que acredite la presentaci&oacute;n en registro con la fecha Car&aacute;tula del Decreto con el sello de presentaci&oacute;n.</div>'''' ''' ||
			  ' WHERE TAP_CODIGO = ''H005_RegistrarPresentacionEnRegistro''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_RegistrarPresentacionEnRegistro actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H005_RegistrarInscripcionDelTitulo''''][''''comboSituacionTitulo''''] == ''''INS'''') ? ((valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaInscripcion''''] == null || valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaInscripcion''''] == '''''''') ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo se ha inscrito, es necesario indicar la fecha de inscripci&oacute;n</div>'''' : (comprobarExisteDocumentoTITINSC() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento "T&iacute;tulo inscrito"</div>'''')) : ((valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaEnvioDecretoAdicion''''] == null || valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaEnvioDecretoAdicion''''] == '''''''') ?  ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo est&aacute; pde. subsanacion, es necesario indicar la fecha env&iacute;o decreto adici&oacute;n</div>'''' : null ) ''' ||
			  ' WHERE TAP_CODIGO = ''H005_RegistrarInscripcionDelTitulo''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_RegistrarInscripcionDelTitulo actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES PLAZOS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''valoresBPMPadre[''''H002_SenyalamientoSubasta'''']!= null ? damePlazo(valoresBPMPadre[''''H002_SenyalamientoSubasta''''][''''fechaSenyalamiento'''']) + 20*24*60*60*1000L : (valoresBPMPadre[''''H003_SenyalamientoSubasta'''']!= null ? damePlazo(valoresBPMPadre[''''H003_SenyalamientoSubasta''''][''''fechaSenyalamiento'''']) + 20*24*60*60*1000L : (valoresBPMPadre[''''H004_SenyalamientoSubasta'''']!= null?  damePlazo(valoresBPMPadre[''''H004_SenyalamientoSubasta''''][''''fechaSenyalamiento'''']) + 20*24*60*60*1000L : 1*24*60*60*1000L))'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_SolicitudDecretoAdjudicacion'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_SolicitudDecretoAdjudicacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H005_SolicitudDecretoAdjudicacion''''][''''fechaSolicitud'''']) + 30*24*60*60*1000L '' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_notificacionDecretoAdjudicacionAEntidad actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tanto si en la subasta no han concurrido postores, como si SAREB ha resultado mejor postor, el letrado deber&aacute; solicitar  la adjudicaci&oacute;n a favor de SAREB con reserva de la facultad de ceder el remate, por lo que a trav&eacute;s de esta tarea deber&aacute; de informar la fecha de presentaci&oacute;n en el Juzgado del escrito de solicitud del Decreto de Adjudicaci&oacute;n.</p><p style="margin-bottom: 10px">Se deber&aacute; adjuntar el Escrito de Solicitud de Adjudicaci&oacute;n presentado en el Juzgado, es decir, la copia sellada.</p><p style="margin-bottom: 10px">En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligar&aacute; a asociarlo a trav&eacute;s de la pesta&ntilde;a bienes del procedimiento el bien que corresponda.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Notificaci&oacute;n decreto de adjudicaci&oacute;n a la entidad”.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_SolicitudDecretoAdjudicacion'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_SolicitudDecretoAdjudicacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Fecha notificación'' ' ||
			  ' WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_notificacionDecretoAdjudicacionAEntidad actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 3 ' ||
			  ' WHERE TFI_NOMBRE = ''comboSubsanacion'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_notificacionDecretoAdjudicacionAEntidad actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 4 ' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_notificacionDecretoAdjudicacionAEntidad actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deber&aacute; de acceder a la pesta&ntilde;a Gestores del asunto correspondiente y asignar el tipo de gestor "Gestor&iacute;a adjudicaci&oacute;n" seg&uacute;n el protocolo que tiene establecido la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez confirmado con el procurador el env&iacute;o a la gestor&iacute;a, se deber&aacute; informar dicha fecha en el campo "Fecha env&iacute;o a Gestor&iacute;a" y del nombre de la gestor&iacute;a.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripci&oacute;n deber&aacute;:' ||
			  '<br>Obtenido el testimonio, se revisar&aacute; la  fecha de expedici&oacute;n  para liquidaci&oacute;n de impuestos en plazo, seg&uacute;n normativa de CCAA. La verificaci&oacute;n de la fecha del t&iacute;tulo es necesaria y fundamental para que la gestor&iacute;a pueda realizar la liquidaci&oacute;n en plazo.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Adicionalmente se  revisar&aacute;n el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Contenido b&aacute;sico para revisar en testimonio decreto de adjudicaci&oacute;n  y mandamientos:<br>- Datos procesales b&aacute;sicos: (Nº autos, tipo de procedimiento, cantidad reclamada)<br>- Datos de la Entidad demandante (nombre CIF, domicilio) y en su caso de los adjudicados.<br>- Datos  de los demandados y titulares registrales.<br>- Importe de adjudicaci&oacute;n y cesi&oacute;n de remate (en su caso).<br>- Orden de cancelaci&oacute;n de la nota marginal y cancelaci&oacute;n de la carga objeto de ejecuci&oacute;n as&iacute; como cargas posteriores)<br>- Descripci&oacute;n  y datos registrales completos de la finca adjudicada.'||
			  '<br>- Declaraci&oacute;n en el auto de la firmeza de la resoluci&oacute;n</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez analizados los puntos descritos, en el campo Requiere subsanaci&oacute;n deber&aacute; indicar el resultado de dicho an&aacute;lisis.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; de adjuntar al procedimiento correspondiente una copia escaneada del decreto firme de adjudicaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzar&aacute;, en caso de requerir subsanaci&oacute;n el tr&aacute;mite de subsanaci&oacute;n de adjudicaci&oacute;n, y en caso contrario se lanzar&aacute; por un lado la tarea  "Registrar entrega del t&iacute;tulo" y por otro el tr&aacute;mite de posesi&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_ConfirmarTestimonio'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_ConfirmarTestimonio actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; informar de la fecha de presentaci&oacute;n en el registro, ya sea del testimonio decreto de adjudicaci&oacute;n original o del testimonio decreto de adjudicaci&oacute;n una vez subsanados los errores encontrados con anterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Registrar inscripci&oacute;n del t&iacute;tulo”.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H005_RegistrarPresentacionEnRegistro'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_RegistrarPresentacionEnRegistro actualizada.');
    
    
    
    /* ------------------- --------------------------------- */
	/* --------------  BORRADO CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    
	 /* ------------------- --------------------------------- */
	/* --------------  BORRADO TAREAS--------------- */
	/* ------------------- --------------------------------- */
	
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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
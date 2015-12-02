--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150928
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.6-hy
--## INCIDENCIA_LINK=HR-1198
--## PRODUCTO=NO
--##
--## Finalidad: Modificación documentos trámite Adjudicacion
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
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUG(''''RECGES'''', ''''ASU'''') || comprobarExisteDocumentoRECGES() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Recib&iacute; de Gestor&iacute;a.</div>'''' '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_RegistrarEntregaTitulo''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_RegistrarEntregaTitulo actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H005_RegistrarInscripcionDelTitulo''''][''''comboSituacionTitulo''''] == ''''INS'''') ? ((valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaInscripcion''''] == null || valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaInscripcion''''] == '''''''') ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo se ha inscrito, es necesario indicar la fecha de inscripci&oacute;n</div>'''' : (existeAdjuntoUG(''''TITINSC'''', ''''ASU'''') || comprobarExisteDocumentoTITINSC() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento "T&iacute;tulo inscrito"</div>'''')) : ((valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaEnvioDecretoAdicion''''] == null || valores[''''H005_RegistrarInscripcionDelTitulo''''][''''fechaEnvioDecretoAdicion''''] == '''''''') ?  ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Si el t&iacute;tulo est&aacute; pde. subsanacion, es necesario indicar la fecha env&iacute;o decreto adici&oacute;n</div>'''' : null )  '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_RegistrarInscripcionDelTitulo''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_RegistrarInscripcionDelTitulo actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''existeAdjuntoUG(''''CALHAC'''', ''''ASU'''') || comprobarExisteDocumentoCALHAC() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la copia de la autoliquidación presentada en Hacienda.</div>'''' '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_RegistrarPresentacionEnHacienda''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_RegistrarPresentacionEnHacienda actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''existeAdjuntoUG(''''DPRCD'''', ''''ASU'''') || comprobarExisteDocumentoDPRCD() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento que acredite la presentaci&oacute;n en registro con la fecha Car&aacute;tula del Decreto con el sello de presentaci&oacute;n.</div>''''  '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_RegistrarPresentacionEnRegistro''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_RegistrarPresentacionEnRegistro actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''comprobarBienAsociadoPrc() ? (existeAdjuntoUG(''''ESADJ'''', ''''ASU'''') || comprobarExisteDocumentoESADJ() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el documento "Escrito solicitud adjudicaci&oacute;n"</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>''''  '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_SolicitudDecretoAdjudicacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_SolicitudDecretoAdjudicacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''existeAdjuntoUG(''''DFA'''', ''''ASU'''') || comprobarExisteDocumentoDFA() ? (existeAdjuntoUG(''''MCC'''', ''''ASU'''') || comprobarExisteDocumentoMCC() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento "Mandamiento de cancelaci&oacute;n de cargas".</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>''''  '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_ConfirmarTestimonio''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_ConfirmarTestimonio actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''existeAdjuntoUG(''''DECRADJ'''', ''''ASU'''') || comprobarExisteDocumentoDECRADJ() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Decreto de Adjudicaci&oacute;n.</div>''''  '' ' ||
			  ' WHERE TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H005_notificacionDecretoAdjudicacionAEntidad actualizada.');
    
    

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
--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150811
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.4
--## INCIDENCIA_LINK=HR-1040
--## PRODUCTO=NO
--##
--## Finalidad: Modificación script validación jbpm
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    V_TAREA VARCHAR(30 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H048_TrasladoDocuDeteccionOcupantes''''][''''comboDocumentacion''''] == DDSiNo.SI && (valores[''''H048_TrasladoDocuDeteccionOcupantes''''][''''fechaDocumentos''''] == null || valores[''''H048_TrasladoDocuDeteccionOcupantes''''][''''fechaDocumentos''''] == '''''''') ?  ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe informar el campo "Fecha Documentaci&oacute;n"</div>'''' : null '' ' ||
			  ' WHERE TAP_CODIGO = ''H048_TrasladoDocuDeteccionOcupantes''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H048_TrasladoDocuDeteccionOcupantes actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI) && ((valores[''''H007_Impugnacion''''][''''fechaImpugnacion''''] == ''''''''))) ? ''''tareaExterna.error.H007_Impugnacion.fechasOblgatorias'''' : ((valores[''''H007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI) && (!comprobarExisteDocumentoEIC())) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el escrito de impugnaci&oacute;n (Costas)</div>'''' : null  '' ' ||
			  ' WHERE TAP_CODIGO = ''H007_Impugnacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H007_Impugnacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboRegistro''''] == DDPositivoNegativo.POSITIVO) && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboAgTribut''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboSegSocial''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboCatastro''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboAyto''''] == '''''''') && (valores[''''H044_RegistrarResultadoInvestigacion''''][''''comboOtros''''] == '''''''') ) ? ''''tareaExterna.error.H044_RegistrarImpugnacion.algunComboObligatorio'''' : null '' ' ||
			  ' WHERE TAP_CODIGO = ''H044_RegistrarResultadoInvestigacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H044_RegistrarResultadoInvestigacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H037_registrarAdmision''''][''''comboAdmision''''] == DDSiNo.SI) && (valores[''''H037_registrarAdmision''''][''''comboSubsanable''''] == '''''''')) ?  ''''tareaExterna.error.faltaSubsanable'''' : (convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? (creditosDefinidosEnConvenioPropioAdmitidoNoAdmitido() ? null : ''''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioEstadoCorrecto'''' ) : ''''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'''') : ''''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido'''') '' ' ||
			  ' WHERE TAP_CODIGO = ''H037_registrarAdmision''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H037_registrarAdmision actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H035_registrarOposicion''''][''''comboOposicion''''] == DDSiNo.SI) && ((valores[''''H035_registrarOposicion''''][''''fecha''''] == ''''''''))) ? ''''tareaExterna.error.H035_registrarOposicion.fechasOblgatorias'''' : null '' ' ||
			  ' WHERE TAP_CODIGO = ''H035_registrarOposicion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H035_registrarOposicion actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H039_registrarOposicion''''][''''comboOposicion''''] == DDSiNo.SI && (valores[''''H039_registrarOposicion''''][''''fechaOposicion''''] == null || valores[''''H039_registrarOposicion''''][''''fechaOposicion''''] == '''''''')) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe informar de la fecha de oposici&oacute;n</div>'''' : ((valores[''''H039_registrarOposicion''''][''''comboOposicion''''] == DDSiNo.SI && valores[''''H039_registrarOposicion''''][''''comboParte''''] == null) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe informar la parte opositora</div>'''' : null) '' ' ||
			  ' WHERE TAP_CODIGO = ''H039_registrarOposicion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H039_registrarOposicion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H066_validarMinuta''''][''''comboValidacion''''] == DDSiNo.SI && (valores[''''H066_validarMinuta''''][''''fecha''''] == null || valores[''''H066_validarMinuta''''][''''fecha''''] == '''''''')) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo "Fecha validaci&oacute;n minuta" es obligatorio</div>'''' : null'' ' ||
			  ' WHERE TAP_CODIGO = ''H066_validarMinuta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H066_validarMinuta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboRequerido''''] == DDSiNo.SI) && ((valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == '''''''')||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == null)||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''importeNom''''] == '''''''')||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''importeRet''''] == '''''''')) )?''''tareaExterna.error.H038_ConfirmarRequerimientoResultado.importesYresultado'''':null'' ' ||
			  ' WHERE TAP_CODIGO = ''H038_ConfirmarRequerimientoResultado''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H038_ConfirmarRequerimientoResultado actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H025_resolucionFirme''''][''''combo1''''] == DDSiNo.SI && (valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado1''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado1''''] == '''''''' || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador1''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador1''''] == '''''''') ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Los importes de 1ª instancia son obligatorios</div>'''' : (valores[''''H025_resolucionFirme''''][''''combo2''''] == DDSiNo.SI && (valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado2''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeLetrado2''''] == '''''''' || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador2''''] == null || valores[''''H025_registrarImporteCuotasAbonar''''][''''importeProcurador2''''] == '''''''') ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Los importes de 2ª instancia son obligatorios</div>'''' : null) '' ' ||
			  ' WHERE TAP_CODIGO = ''H025_registrarImporteCuotasAbonar''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H025_registrarImporteCuotasAbonar actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H066_registrarInscripcionTitulo''''][''''situacionTitulo''''] == ''''INS'''' ? (valores[''''H066_registrarInscripcionTitulo''''][''''fechaInscripcion''''] == null || valores[''''H066_registrarInscripcionTitulo''''][''''fechaInscripcion''''] == '''''''' ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo "Fecha inscripci&oacute;n es obligatorio"</div>'''' : null) : (valores[''''H066_registrarInscripcionTitulo''''][''''fechaEnvio''''] == null || valores[''''H066_registrarInscripcionTitulo''''][''''fechaEnvio''''] == '''''''' ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo "Fecha env&iacute;o escrito subsanaci&oacute;n" es obligatorio</div>'''' : null)'' ' ||
			  ' WHERE TAP_CODIGO = ''H066_registrarInscripcionTitulo''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H066_registrarInscripcionTitulo actualizada.');
      
    

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
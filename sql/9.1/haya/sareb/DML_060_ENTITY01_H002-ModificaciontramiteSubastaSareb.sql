--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hy-rc03
--## INCIDENCIA_LINK=HR-989
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite subasta sareb
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H002';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
	 V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarBienesSolitudSubasta() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Se deben cumplimentar los datos de cargas, vivienda habitual y situaci&oacute,n posesoria de todos los bienes incluidos en la subasta</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>'''' '' ' ||
			  ' WHERE TAP_CODIGO = ''H002_SolicitudSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitudSubasta actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''comprobarBienesTasacion() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe informar los campos "Fecha valor tasaci&oacute;n" y "valor tasaci&oacute;n" en la pesta&ntilde;a del bien, por cada bien de la subasta</div>'''' '' ' ||
	          ' WHERE TAP_CODIGO = ''H002_ActualizarTasacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ActualizarTasacion actualizada.');
    
     
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES CAMPOS--------------- */
	/* ------------------- --------------------------------- */
	 V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe informar las fechas de anuncio y celebraci&oacute;n de la misma as&iacute; como las costas del letrado y procurador.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se lanzar&aacute;n las siguientes tareas:</p><p style="margin-bottom: 10px; margin-left: 40px;">• "Celebraci&oacute;n subasta" a realizar por el letrado.</p><p style="margin-bottom: 10px; margin-left: 40px;">• "Preparar la propuesta de subasta" a realizar por el gestor de litigios.</p><p style="margin-bottom: 10px; margin-left: 40px;">• “Adjuntar informe de subasta” a realizar por el letrado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Necesario actualizar Nota Simple'' ' ||
			  ' WHERE TFI_NOMBRE = ''comboNotaSimple'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ValidarInformeDeSubastaYPrepararCuadroDePujas'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ValidarInformeDeSubastaYPrepararCuadroDePujas actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALIDACION = null ' ||
			  ' ,TFI_ERROR_VALIDACION = null ' ||
			  ' WHERE TFI_NOMBRE = ''comboDelegada'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CumplimentarParteEconomica'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CumplimentarParteEconomica actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALIDACION = null ' ||
			  ' ,TFI_ERROR_VALIDACION = null ' ||
			  ' WHERE TFI_NOMBRE = ''numPropuestaSareb'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CumplimentarParteEconomica'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CumplimentarParteEconomica actualizada.');
    
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES PLAZOS--------------- */
	/* ------------------- --------------------------------- */
	
	
	  
	/* ------------------- --------------------------------- */
	/* --------------  BORRADO TAREAS--------------- */
	/* ------------------- --------------------------------- */
	
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

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
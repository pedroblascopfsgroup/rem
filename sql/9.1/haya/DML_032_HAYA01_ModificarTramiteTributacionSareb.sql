--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150806
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.4
--## INCIDENCIA_LINK=HR-1042
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite Tributacion bienes Sareb
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H054';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI('H054_EmisionInformeFiscal','1','combo','comboInformeFiscal','Informe Fiscal Válido','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H054_EmisionInformeFiscal','3','combo','comboPresentar','Presentar Escrito Juzgado',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('H054_PresentarEscritoJuzgado','1','combo','comboModelo','Modelo de escrito a presentar',null,null,'valores[''H054_EmisionInformeFiscal''][''comboModelo'']','DDModeloEscrito','0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(30 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFIS'')' ||
			  ' ,TAP_SCRIPT_DECISION = null' ||
			  ' WHERE TAP_CODIGO = ''H054_ValidaBienesTributacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_ValidaBienesTributacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_DECISION = ''valores[''''H054_ValidaBienesTributacion''''][''''comboInformeFiscal''''] == DDSiNo.SI ? ''''SI'''' : ''''NO'''' ''' ||
			  ' WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_EmisionInformeFiscal actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFIS'')' ||
	          ' WHERE TAP_CODIGO = ''H054_PresentarEscritoJuzgado''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_PresentarEscritoJuzgado actualizada.');
    
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; validar la informaci&oacute;n sobre tributaci&oacute;n para los bienes afectos a la subasta. Estos bienes los podr&aacute; identificar a trav&eacute;s de la pesta&ntilde;a Subastas del asunto correspondiente. Deber&aacute; validar en la ficha del bien, si para aquellos bienes que pertenezcan a persona jur&iacute;dica o si el transmitente es una persona fisica y los bienes a subastar son locales comerciales, naves industriales, promociones en curso, terrenos urbanos y plazas de garages (siempre que vayan vinculadas a locales o naves)se dispone en la "ficha del bien" de la siguiente informaci&oacute;n /documentaci&oacute;n junto con el informe fiscal:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Viviendas y sus anexos: indicar si el transmitente de los inmuebles fue el promotor de los mismos y si se dispone de la Licencia de Primera Ocupaci&oacute;n o han sido arrendados sin opci&oacute;n de compra o han sido usados por su promotor por un periodo superior a los dos a&ntilde;os.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Locales, naves u oficinas y plazas de garaje aisladas: indicar si el transmitente de los inmuebles fue promotor de los mismos o han sido arrendados sin opci&oacute;n de compra o han sido usados por su promotor.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Terrenos en curso de urbanizaci&oacute;n: confirmaci&oacute;n de que han dado materialmente comienzo la obras de urbanizaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Fecha indicar&aacute; la fecha en la que completa la informaci&oacute;n requerida.</p><p style="margin-bottom: 10px">En el campo Transmitente, indicar si el transmitente es una persona fisica o juridica.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_ValidaBienesTributacion'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_ValidaBienesTributacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Fecha'' ' ||
			  ' WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_ValidaBienesTributacion'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_ValidaBienesTributacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Transmitente'' ' ||
			  ',TFI_NOMBRE = ''comboTransmitente'' ' ||
			  ',TFI_BUSINESS_OPERATION = ''DDTipoPersona'' ' ||
			  ' WHERE TFI_NOMBRE = ''comboInformeFiscal'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_ValidaBienesTributacion'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_ValidaBienesTributacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada la tarea deber&aacute;, en primer lugar, indicar si ya existe informe fiscal anterior y si es v&aacute;lido.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si existe informe fiscal y contin&uacute;a siendo v&aacute;lido, el tramite finaliza.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si no existe informe fiscal, debe adjuntar el informe fiscal de aplicaci&oacute;n a los bienes incluidos en la subasta seg&uacute;n lo solicitado y actualizar la ficha del bien todos aquellos campos referidos a la tributaci&oacute;n de todos los bienes incluidos en la subasta, que han sido analizados para determinar el tipo de tributaci&oacute;n de la operaci&oacute;n. Concretamente, los datos que se deben ser actualizados en la ficha del bien, en el apartado de "Datos Economicos" son la tributaci&oacute;n, el tipo impositivo y si existe renuncia a la exenci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Fecha, indicar la fecha en la que adjunta el informe fiscal.</p><p style="margin-bottom: 10px">En el caso que el tipo de tributacion de algunos de los bienes, est&eacute; sujeta a IVA, deber&aacute; indicar si se debe presentar escrito al juzgado y en caso afirmativo, deber&aacute; adjuntar el modelo de escrito a presentar por el letrado, indicando en el campo "Modelo de escrito a presentar" el modelo que debe ser presentado por el letrado.</p><p style="margin-bottom: 10px">Una vez completada la tarea, se lanzar&aacute; la  siguiente tarea " Presentar Escrito al Juzgado" por parte del letrado en caso que se haya indicado afirmativamente en el campo correspondiente y en caso contrario, no se llevar&aacute; a cabo ninguna acci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_EmisionInformeFiscal actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 2 ' ||
			  ' WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_EmisionInformeFiscal actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 4 ' ||
			  ',TFI_NOMBRE = ''comboModelo'' ' ||
			  ',TFI_LABEL = ''Modelo de escrito a presentar'' ' ||
			  ',TFI_BUSINESS_OPERATION = ''DDModeloEscrito'' ' ||
			  ' WHERE TFI_NOMBRE = ''comboResultadoInformeFiscal'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_EmisionInformeFiscal actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 5 ' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_EmisionInformeFiscal actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada la tarea deber&aacute;, en primer lugar, indicar si ya existe informe fiscal anterior y si es v&aacute;lido.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si existe informe fiscal y contin&uacute;a siendo v&aacute;lido, el tramite finaliza.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si no existe informe fiscal, debe adjuntar el informe fiscal de aplicaci&oacute;n a los bienes incluidos en la subasta seg&uacute;n lo solicitado y actualizar la ficha del bien todos aquellos campos referidos a la tributaci&oacute;n de todos los bienes incluidos en la subasta, que han sido analizados para determinar el tipo de tributaci&oacute;n de la operaci&oacute;n. Concretamente, los datos que se deben ser actualizados en la ficha del bien, en el apartado de "Datos Economicos" son la tributaci&oacute;n, el tipo impositivo y si existe renuncia a la exenci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Fecha, indicar la fecha en la que adjunta el informe fiscal.</p><p style="margin-bottom: 10px">En el caso que el tipo de tributacion de algunos de los bienes, est&eacute; sujeta a IVA, deber&aacute; indicar si se debe presentar escrito al juzgado y en caso afirmativo, deber&aacute; adjuntar el modelo de escrito a presentar por el letrado, indicando en el campo "Modelo de escrito a presentar" el modelo que debe ser presentado por el letrado.</p><p style="margin-bottom: 10px">Una vez completada la tarea, se lanzar&aacute; la  siguiente tarea " Presentar Escrito al Juzgado" por parte del letrado en caso que se haya indicado afirmativamente en el campo correspondiente y en caso contrario, no se llevar&aacute; a cabo ninguna acci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_PresentarEscritoJuzgado'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_PresentarEscritoJuzgado actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 2 ' ||
			  ' ,TFI_LABEL = ''Fecha escrito juzgado'' ' ||
			  ' WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_PresentarEscritoJuzgado'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_PresentarEscritoJuzgado actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 3 ' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_PresentarEscritoJuzgado'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_PresentarEscritoJuzgado actualizada.');
    
    
    /* ------------------- --------------------------------- */
	/* --------------  BORRADO CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    
	 /* ------------------- --------------------------------- */
	/* --------------  BORRADO TAREAS--------------- */
	/* ------------------- --------------------------------- */
	V_TAREA:='H054_ConfirmarComEmpresario';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=SYSDATE,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
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
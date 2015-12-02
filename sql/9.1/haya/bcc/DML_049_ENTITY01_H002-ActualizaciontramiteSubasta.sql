--/*
--##########################################
--## AUTOR=Nacho arcos
--## FECHA_CREACION=20150815
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-481-484
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite subasta
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

BEGIN	
	
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	/*  CMREC-481 */	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Diligencia de señalamiento Edicto de subasta'', DD_TFA_DESCRIPCION_LARGA = ''Diligencia de señalamiento Edicto de subasta'' WHERE DD_TFA_CODIGO = ''ESRAS''';
	
	/*  CMREC-482 */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/cajamar/tramiteSubasta/validarInformeSubasta'' WHERE TAP_CODIGO = ''H002_ValidarInformeDeSubasta''';
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALIDACION = null , ' ||
			  ' TFI_ERROR_VALIDACION = null ' ||
			  ' WHERE TFI_NOMBRE = ''comboAutorizacion'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ValidarInformeDeSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ValidarInformeDeSubasta actualizada.');
    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/cajamar/tramiteSubasta/validarInformeSubasta'' WHERE TAP_CODIGO = ''H004_ValidarInformeDeSubasta''';
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALIDACION = null , ' ||
			  ' TFI_ERROR_VALIDACION = null ' ||
			  ' WHERE TFI_NOMBRE = ''comboAutorizacion'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H004_ValidarInformeDeSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H004_ValidarInformeDeSubasta actualizada.');
    
    /* CMREC-483 */    
   V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALOR_INICIAL = ''valores[''''H002_ObtenerValidacionComite''''] != null ? (valores[''''H002_ObtenerValidacionComite''''][''''comboResultado''''] == ''''SUS'''' ? DDSiNo.SI : DDSiNo.NO) : null'' ' ||
			  ' WHERE TFI_NOMBRE = ''comboSuspender'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_DictarInstruccionesSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_DictarInstruccionesSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALOR_INICIAL = ''valores[''''H004_ObtenerValidacionComite''''] != null ? (valores[''''H004_ObtenerValidacionComite''''][''''comboResultado''''] == ''''SUS'''' ? DDSiNo.SI : DDSiNo.NO) : null'' ' ||
			  ' WHERE TFI_NOMBRE = ''comboSuspender'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H004_DictarInstruccionesSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H004_DictarInstruccionesSubasta actualizada.');
    
    /*CMREC-484 */
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_DECISION = ''valores[''''H002_DictarInstruccionesSubasta''''][''''comboSuspender''''] == DDSiNo.SI ? ''''Suspender'''' : ''''NoSuspender'''' '' ' ||
			  ' WHERE TAP_CODIGO = ''H002_DictarInstruccionesSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_DictarInstruccionesSubasta actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_DECISION = ''valores[''''H004_DictarInstruccionesSubasta''''][''''comboSuspender''''] == DDSiNo.SI ? ''''Suspender'''' : ''''NoSuspender'''' '' ' ||
			  ' WHERE TAP_CODIGO = ''H004_DictarInstruccionesSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H004_DictarInstruccionesSubasta actualizada.');
    
    /* EXTRAS*/
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGCONGE'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''TSUCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H002_AdjuntarInformeFiscal''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Decisión H002_AdjuntarInformeFiscal actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGCONGE'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''TSUCONGE'')' ||
			  ' WHERE TAP_CODIGO = ''H004_AdjuntarInformeFiscal''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Decisión H004_AdjuntarInformeFiscal actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-TGESEXT'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''CJ-SUEXT'')' ||
			  ' WHERE TAP_CODIGO = ''H002_ObtenerValidacionComite''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Decisión H002_ObtenerValidacionComite actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-TGESEXT'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''CJ-SUEXT'')' ||
			  ' WHERE TAP_CODIGO = ''H004_ObtenerValidacionComite''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Decisión H004_ObtenerValidacionComite actualizada.');
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H004_SuspenderDecision'' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS < 1 THEN 
		 V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''H004''),' ||
                    ' ''H004_SuspenderDecision'',null,' ||
                    ' null,null,null,' || 
                    'null,' ||
                    '''0'',''Tarea toma de decisión'',''0'',''DD'',' ||
                    'sysdate,''0'',null,null,' ||
                    'null,''0'',''EXTTareaProcedimiento'',''3'',' ||
                    'null,' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''CJ-819''),' || 
                    'null,' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''GCONGE'')' || 
					',null FROM DUAL';
          
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ');
            EXECUTE IMMEDIATE V_MSQL;
            
       ELSE
				DBMS_OUTPUT.PUT_LINE('La tarea H004_SuspenderDecision ya existe, NO se creará de nuevo otra vez.');
			
       END IF;
    
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
--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Litigios
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

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-746');
	V_TAREA:='HC105_SolicitudPosesionInterina';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_BUSINESS_OPERATION=''DDTipoBienCajamar''' ||
	  ' WHERE TFI_NOMBRE=''comboBien'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-746');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-747');
	V_TAREA:='H065_registrarPresentacionEscrituraSub';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A través de esta tarea deberá de informar la fecha de presentación en Notaría de la escritura devuelta por el Registrador para su subsanación.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Entregar nueva escritura publica de propiedad".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-747');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-615');
	V_TAREA:='H011_LecturaInstruccionesMoratoria';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=NULL ' ||
	  ' ,TFI_VALIDACION=NULL ' ||
	  ' WHERE TFI_NOMBRE=''instruccionesMoratoria'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-615');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-744');
	V_TAREA:='H048_ResolucionFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''vieneDeTramitePosesion() ? (valores[''''H048_RegistrarResolucion''''][''''comboResultado''''] == DDPositivoNegativo.NEGATIVO ? ''''desfavorable'''' : ''''favorable'''') : ''''desfavorableNTP'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-744');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-741');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Diligencia de se&ntilde;alamiento Edicto de subasta".</div>'''''' ' ||
			' WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-741');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-661');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H022_ConfirmarAdmisionDemanda''''][''''comboResultado''''] == DDSiNo.SI ? comprobarExisteDocumentoADEM() ? null : ''''Es necesario adjuntar el documento Auto Despachando Ejecuci&oacute;n del P. Monitorio.'''' : null'' ' ||
			' WHERE TAP_CODIGO = ''H022_ConfirmarAdmisionDemanda'' ';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H022_ConfirmarOposicionCuantia''''][''''comboResultado''''] == DDSiNo.SI ? comprobarExisteDocumentoEOM() ? null : ''''Es necesario adjuntar el documento Escrito de Oposici&oacute;n del P. Monitorio.'''' : null'' ' ||
			' WHERE TAP_CODIGO = ''H022_ConfirmarOposicionCuantia'' ';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-661');
	
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
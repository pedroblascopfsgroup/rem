--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-373
--## PRODUCTO=NO
--##
--## Finalidad: Adaptar BPM's Haya-Cajamar
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    
BEGIN
	
	/* 
	 * UPDATES
	 * -------
	 */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO tpo SET tpo.DD_TPO_DESCRIPCION = ''T. de depósito - HCJ'', tpo.DD_TPO_XML_JBPM      = ''hcj_tramiteDeposito'' WHERE tpo.DD_TPO_CODIGO = ''H034''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap SET tap.TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoAAEEE() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>Es necesario adjuntar el documento Documento que acredite el acuerdo de la entrega y la entrega efectiva</p></div></div>'''''' WHERE tap.TAP_CODIGO = ''H034_AcuerdoEntrega''';
	
	EXECUTE IMMEDIATE 'DELETE FROM  '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id = (SELECT tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H034_ContactarDeudor'')';
    EXECUTE IMMEDIATE 'DELETE FROM  '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS where tap_id = (SELECT tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H034_ContactarDeudor'')';
    --EXECUTE IMMEDIATE 'DELETE FROM  '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H034_ContactarDeudor''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_H034_ContactarDeudor'',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''ACAMPOS'' WHERE TAP_CODIGO=''H034_ContactarDeudor''';
    
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
	
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/ 
EXIT;

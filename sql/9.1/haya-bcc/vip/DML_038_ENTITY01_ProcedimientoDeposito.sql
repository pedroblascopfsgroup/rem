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
	EXECUTE IMMEDIATE 'DELETE FROM  '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id = (SELECT tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H034_ContactarDeudor'')';
    EXECUTE IMMEDIATE 'DELETE FROM  '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS where tap_id = (SELECT tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H034_ContactarDeudor'')';
    EXECUTE IMMEDIATE 'DELETE FROM  '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H034_ContactarDeudor''';
    
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

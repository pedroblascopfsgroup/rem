--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.16-hy-rc01
--## INCIDENCIA_LINK=HR-1763
--## PRODUCTO=NO
--## Finalidad: Actualización de las validaciones de la tarea.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
       
BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando TAP_SCRIPT_VALIDACION'); 
     
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALIDACION = NULL, TFI_ERROR_VALIDACION = NULL WHERE TAP_ID in (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H007_Impugnacion'')	AND TFI_NOMBRE IN (''fechaImpugnacion'',''vistaImpugnacion'',''comboResultado'')';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI && !comprobarExisteDocumentoEIC()) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el escrito de impugnaci&oacute;n (Costas)</div>'''' : ((valores[''''H007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI) ? ((valores[''''H007_Impugnacion''''][''''fechaImpugnacion''''] != '''''''' && valores[''''H007_Impugnacion''''][''''fechaImpugnacion''''] != null && valores[''''H007_Impugnacion''''][''''vistaImpugnacion''''] != '''''''' && valores[''''H007_Impugnacion''''][''''vistaImpugnacion''''] != null) ? ((valores[''''H007_Impugnacion''''][''''comboResultado''''] != '''''''' && valores[''''H007_Impugnacion''''][''''comboResultado''''] != null) ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario rellenar el combo de motivo de impugnaci&oacute;n (Costas)</div>'''') : ''''Es necesario rellenar Fecha y Fecha vista'''') : null)'' ';
    EXECUTE IMMEDIATE V_MSQL;
    
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
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

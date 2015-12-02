--/*
--##########################################
--## AUTOR=Nacho Arcos
--## FECHA_CREACION=20151118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-hy-rc01
--## INCIDENCIA_LINK=HR-1530
--## PRODUCTO=NO
--## Finalidad: DML para actualizar el trámite de aceptación de litigios
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
	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''PCO_PREDOC'')' ||
			  ' WHERE TAP_CODIGO = ''H068_SubsanarErrDocumentacion''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gestor de la tarea H068_SubsanarErrDocumentacion');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Gestor de la tarea actualizado.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALOR_INICIAL = ''(tieneProcedimientoPadre() && valoresBPMPadre[''''H067_seleccionarProcedimiento''''] != null) ? valoresBPMPadre[''''H067_seleccionarProcedimiento''''][''''comboProcedimiento''''] : '''''''' '' ' ||
			  ' WHERE TFI_NOMBRE = ''tipoPropuestoEntidad'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H068_registrarProcedimiento'' )';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gestor de la tarea H068_SubsanarErrDocumentacion');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Gestor de la tarea actualizado.');
    
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

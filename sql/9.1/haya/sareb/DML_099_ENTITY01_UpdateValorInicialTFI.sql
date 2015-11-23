--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.13-hy-rc01
--## INCIDENCIA_LINK=HR-1572
--## PRODUCTO=NO
--## Finalidad: DML para actualizar el valor por defecto del combo de una tarea.
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
	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_VALOR_INICIAL = ''H001''' ||
			  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
			  ' WHERE TAP_CODIGO = ''PCO_AsignacionGestores''' ||
			  ' AND BORRADO = 0)' ||
			  ' AND TFI_NOMBRE = ''procPropuesto''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Valor por defecto en el combo procPropuesto de la tarea PCO_AsignacionGestores actualizado.');

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

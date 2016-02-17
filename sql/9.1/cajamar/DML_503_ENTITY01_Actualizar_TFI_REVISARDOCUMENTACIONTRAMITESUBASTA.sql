--/*
--##########################################
--## AUTOR=Salvador Gorrita
--## FECHA_CREACION=20160217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-2060
--## PRODUCTO=NO
--## Finalidad: DML para actualizar las instrucciones de algunas tareas
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

   
BEGIN
	
	V_SQL := 'select count(1) from cm01.tfi_tareas_form_items tfi inner join CM01.TAP_TAREA_PROCEDIMIENTO tap on tfi.tap_id = tap.tap_id where tap.tap_codigo in (''H002_RevisarDocumentacion'', ''H004_RevisarDocumentacion'') and tap.borrado = 0 and tfi.tfi_nombre = ''titulo''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
					  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si todos los bienes incluidos en la Subasta han de ser efectivamente subastados o, por el contrario, excluya manualmente los que no deban ser subastados</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la certificaci&oacute;n de cargas de cada uno de los bienes en la ficha del bien. En caso de que tengan una antigüedad superior a 3 meses, solicite las notas simples actualizadas.</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la de la tasaci&oacute;n de cada uno de los bienes. En caso de que sea superior a 6 meses solicite una nueva tasaci&oacute;n a trav&eacute;s de la ficha del bien.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario el informe fiscal en cuyo caso deber&aacute; solicitarlo a la entidad una vez tenga las tasaciones actualizadas.</p><p style="margin-bottom: 10px">Una vez determine qu&eacute; documentaci&oacute;n necesita deber&aacute; ponerse en contacto con el departamento correspondiente para solicitarla y dejar constancia en Recovery.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; se&ntilde;alar la fecha en la que hace esta revisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Preparar informe de subasta" y:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si ha indicado que solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjuntar tasaciones".</p><p style="margin-bottom: 10px; margin-left: 40px;"></p><p style="margin-bottom: 10px; margin-left: 40px;">-Si no ha solicitado tasaciones y ha indicado que va a solicitar el informe fiscal, se lanzar&aacute; la tarea "Adjuntar informe fiscal".</p></div>''' ||
					  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
					  ' WHERE TAP_CODIGO in (''H002_RevisarDocumentacion'', ''H004_RevisarDocumentacion'')' ||
					  ' AND BORRADO = 0)' ||
					  ' AND TFI_NOMBRE = ''titulo''';
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones actualizadas.');
		    
		    COMMIT;
     ELSE
	     DBMS_OUTPUT.PUT_LINE('[ERROR] No existe el registro a modificar.');
     END IF;
        
   
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
    
    commit;
	
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

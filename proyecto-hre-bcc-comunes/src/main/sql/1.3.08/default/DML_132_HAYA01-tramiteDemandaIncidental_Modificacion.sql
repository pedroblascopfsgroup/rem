/*
--######################################################################
--## Author: Nacho
--## BPM: H023 Trámite Demandada Incidental - modificación del BPM
--## Finalidad: Modificación del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
    
	--HR-481
     V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya/tramiteDemandaIncidental/admisionOposicionSenyalamientoVista'' '
 				|| ' WHERE TAP_CODIGO = ''H023_admisionOposicionYSenalamientoVista''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(((valores[''''H023_admisionOposicionYSenalamientoVista''''][''''comboAdmision''''] == DDSiNo.SI) && (valores[''''H023_admisionOposicionYSenalamientoVista''''][''''fecha''''] == null)) || ((valores[''''H023_admisionOposicionYSenalamientoVista''''][''''comboVista''''] == DDSiNo.SI) && (valores[''''H023_admisionOposicionYSenalamientoVista''''][''''fechaVista''''] == null))) ? ''''tareaExterna.error.faltaAlgunaFecha'''' : null'' '
 				|| ' WHERE TAP_CODIGO = ''H023_admisionOposicionYSenalamientoVista''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-480
     V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H023_confirmarOposicion''''][''''comboOposicion''''] == DDSiNo.SI ? (!comprobarExisteDocumentoEODI() ? ''''Para poder continuar debe adjuntar el documento "Escrito de oposici&oacute;n".'''' : (valores[''''H023_confirmarOposicion''''][''''comboVista''''] == null ? ''''El campo "Vista" es obligatorio'''' : ((valores[''''H023_confirmarOposicion''''][''''fechaOposicion''''] == null) || ((valores[''''H023_confirmarOposicion''''][''''comboVista''''] == DDSiNo.SI) && (valores[''''H023_confirmarOposicion''''][''''fechaVista''''] == null)) ? ''''tareaExterna.error.faltaAlgunaFecha'''' : null))) : null'' '
 				|| ' WHERE TAP_CODIGO = ''H023_confirmarOposicion''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
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
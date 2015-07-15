--######################################################################
--## Author: Nacho
--## BPM: T. Ejecución Notarial (H036)
--## Finalidad: modificación de datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
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
	V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''Número de otros titulares de carga'' '
				|| ' WHERE TFI_NOMBRE = ''numeroDeOtrosTitulares'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarRecepcionCertCargas'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''((valores[''''H036_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == DDResultadoComiteConcursal.CONCEDIDO) || (valores[''''H036_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == DDResultadoComiteConcursal.CONCEDIDO_CON_MODIFICACIONES)) ? ''''Aceptada'''' : ( valores[''''H036_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == DDResultadoComiteConcursal.MODIFICAR ? ''''Modificada'''' : ''''Rechazada'''') '' '
				|| ' WHERE TAP_CODIGO = ''H036_ElevarPropuestaAComite'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = '''' '
				|| ' WHERE TAP_CODIGO = ''H036_CelebracionSubasta'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H036_CelebracionSubasta''''][''''celebrada''''] == DDSiNo.SI && !comprobarExisteDocumentoASU() ? ''''Es necesario adjuntar el Acta de subasta'''' : null'' '
				|| ' WHERE TAP_CODIGO = ''H036_CelebracionSubasta'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''valores[''''H036_CelebracionSubasta''''][''''celebrada''''] == DDSiNo.NO ? ''''SUSPENDIDA'''' : (valores[''''H036_CelebracionSubasta''''][''''adjudicacionEntidad''''] == DDSiNo.SI ? (valores[''''H036_CelebracionSubasta''''][''''cesionRemate''''] == DDSiNo.SI ? ''''ADJUDICACICONCESION'''' : ''''ADJUDICACIONSINCESION'''') : ''''TERCEROS'''')'' '
				|| ' WHERE TAP_CODIGO = ''H036_CelebracionSubasta'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET BORRADO = 1 '
				|| ' WHERE TAP_CODIGO = ''H036_BPMTramitePosesion'' ';
 
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
    
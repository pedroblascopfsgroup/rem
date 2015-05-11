/*
--######################################################################
--## Author: Manuel
--## BPM: T. Costas (H007) - modificación del BPM
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
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    
    
BEGIN
    
    --HR-569 
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
    		|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI) && ((valores[''''H007_Impugnacion''''][''''fechaImpugnacion''''] == ''''''''))) ? ''''tareaExterna.error.H007_Impugnacion.fechasOblgatorias'''' : ((valores[''''H007_Impugnacion''''][''''comboImpugnacion''''] == DDSiNo.SI) && (!comprobarExisteDocumentoEIC())) ? ''''Es necesario adjuntar el escrito de impugnaci&oacute;n (Costas)'''' : null '','
			|| ' TAP_SCRIPT_VALIDACION = '''' '
    		|| ' where TAP_CODIGO = ''H007_Impugnacion''';
			
 	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;		
	
	V_MSQL := 'UPDATE DD_TFA_FICHERO_ADJUNTO '
    		|| ' SET DD_TAC_ID = (SELECT DD_TAC_ID FROM DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''TR'')'
			|| '  WHERE DD_TFA_CODIGO = ''EIC''';
 	
			
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
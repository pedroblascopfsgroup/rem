/*
--######################################################################
--## Author: Carlos P.
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
    
	 DBMS_OUTPUT.PUT_LINE('[INICIO] - HR-372');
     V_MSQL := 'update '|| V_ESQUEMA ||'.tfi_tareas_form_items '
		|| 'set tfi_label = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Seg&uacute;n criterio de la Entidad, y en los casos que se estime preciso, se podr&aacute; practicar tasaci&oacute;n interna de los bienes sobre los que se inicia el apremio. Para ello debemos indicar si se ha solicitado o por el contrario no se practica, as&iacute; como, en caso afirmativo, debemos informar la fecha en la que hemos realizado la petici&oacute;n anterior.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">En caso de que se solicite tasaci&oacute;n interna la siguiente tarea ser&aacute; "Obtener tasaci&oacute;n interna".</br>En caso contrario, la siguiente tarea ser&aacute; "Estudiar conformidad o alegaci&oacute;n", una vez se haya completado tambi&eacute;n la tarea "Obtenci&oacute;n Eval&uacute;o".</p></div>'''
		|| 'where tfi_tipo = ''label'' and tfi_nombre = ''titulo'' and tap_id = (select tap_id from '|| V_ESQUEMA ||'.tap_tarea_procedimiento where tap_codigo = ''H058_SolitarTasacionInterna'')';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;
    
     DBMS_OUTPUT.PUT_LINE('[FIN] - HR-372');
    
 
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
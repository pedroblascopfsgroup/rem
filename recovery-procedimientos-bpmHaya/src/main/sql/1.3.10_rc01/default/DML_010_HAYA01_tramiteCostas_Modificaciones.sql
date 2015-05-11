--######################################################################
--## Author: Nacho
--## BPM: T. Costas (H007)
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
	--HR-337   
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(new BigDecimal(valores[''''H007_SolicitudTasacion''''][''''cuantiaLetrado''''])).compareTo(new BigDecimal((damePrincipal() * 5 / 100))) == 1 ? ''''Las costas del letrado no pueden superar el 5% del principal'''' : null'' '
				|| ' WHERE TAP_CODIGO = ''H007_SolicitudTasacion'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(new BigDecimal(valores[''''H007_TasacionCostas''''][''''cuantiaLetrado''''])).compareTo(new BigDecimal((damePrincipal() * 5 / 100))) == 1 ? ''''Las costas del letrado no pueden superar el 5% del principal'''' : null'' '
				|| ' WHERE TAP_CODIGO = ''H007_TasacionCostas'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    V_MSQL := 'UPDATE DD_TFA_FICHERO_ADJUNTO '
				|| ' SET DD_TAC_ID = (SELECT DD_TAC_ID FROM DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''TR'') '
				|| ' WHERE DD_TFA_CODIGO = ''EIC'' ';
 
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
    
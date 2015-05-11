/*
--######################################################################
--## Author: Carlos P.
--## Finalidad: Modificación del BPM
--## Incidencia: HR-430
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] - HR-430');
    
    V_MSQL := 'UPDATE ' || V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO '
				|| ' SET BORRADO = 0 '
				|| ' WHERE DD_TPO_CODIGO = ''P94''';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - PROCEDIMIENTO P94 ELIMINADO');
 
    V_MSQL := 'UPDATE ' || V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO '
				|| ' SET DD_TPO_XML_JBPM = ''haya_tramiteReaperturaConcurso'' '
				|| ' WHERE DD_TPO_CODIGO = ''H043''';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - PROCEDIMIENTO H043 MODIFICADO SU BPM');
    
        V_MSQL := 'UPDATE ' || V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO ' 
				|| ' SET DD_TPO_ID_BPM = (select dd_tpo_id from ' || V_ESQUEMA ||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''H024'')'
				|| ' WHERE TAP_CODIGO = ''H043_BPMtramiteFaseComunOrdinario''';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - AÑADIDO EL TRAMITE F.ORDINARIO AL H043');    
    
   
   
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
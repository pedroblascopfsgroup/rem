/*
--######################################################################
--## Author: Nacho
--## DD: Modificación del Diccionario DD_RCC_RES_COMITE_CONCURS y bpms que lo utilizan
--## Finalidad: Modificación del del Diccionario DD_RCC_RES_COMITE_CONCURS y de los bpms H002, H003, H004, H0036 que lo utilizan
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
	
	--HR-437
	--DD_RCC_RES_COMITE_CONCURS
	V_MSQL := 'UPDATE DD_RCC_RES_COMITE_CONCURS '
				|| ' SET DD_RCC_CODIGO = ''CONCEDIDO'' '
				|| ' WHERE DD_RCC_CODIGO = ''ACEPTADA'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE DD_RCC_RES_COMITE_CONCURS '
				|| ' SET DD_RCC_CODIGO = ''CONCONMOD'' '
				|| ' WHERE DD_RCC_CODIGO = ''ACCONCAM'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --H002 Subasta Sareb
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( valores[''''H002_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCEDIDO'''' ? ''''ACEPTADA'''' : ( valores[''''H002_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCONMOD'''' ? ''''ACCONCAM'''' : ''''DENEGADA'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H002_RegistrarRespuestaSareb'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
     V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( (valores[''''H002_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''CONCEDIDO'''' || valores[''''H002_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''CONCONMOD'''' ) ? ''''Aceptada'''' : ( valores[''''H002_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''MODIFICAR'''' ? ''''Modificar'''' : ''''Rechazada'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H002_ElevarPropuestaAComite'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --H003 Subasta Concursal
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( valores[''''H003_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCEDIDO'''' ? ''''ACEPTADA'''' : ( valores[''''H003_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCONMOD'''' ? ''''ACCONCAM'''' : ''''DENEGADA'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H003_RegistrarRespuestaSareb'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
     V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( (valores[''''H003_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''CONCEDIDO'''' || valores[''''H003_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''CONCONMOD'''' ) ? ''''Aceptada'''' : ( valores[''''H003_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''MODIFICAR'''' ? ''''Modificar'''' : ''''Rechazada'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H003_ElevarPropuestaAComite'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --H004 Subasta Terceros
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( valores[''''H004_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCEDIDO'''' ? ''''ACEPTADA'''' : ( valores[''''H004_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCONMOD'''' ? ''''ACCONCAM'''' : ''''DENEGADA'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H004_RegistrarRespuestaSareb'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( (valores[''''H004_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''CONCEDIDO'''' || valores[''''H004_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''CONCONMOD'''' ) ? ''''Aceptada'''' : ( valores[''''H004_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''MODIFICAR'''' ? ''''Modificar'''' : ''''Rechazada'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H004_ElevarPropuestaAComite'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --H036
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( valores[''''H036_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCEDIDO'''' ? ''''ACEPTADA'''' : ( valores[''''H036_RegistrarRespuestaSareb''''][''''comboResultadoResolucion''''] == ''''CONCONMOD'''' ? ''''ACCONCAM'''' : ''''DENEGADA'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H036_ElevarPropuestaAComite'' ';
 
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
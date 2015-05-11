--/*
--##########################################
--## Autor: #AUTOR#
--## Descripción: Resolución BKNIVDOS_1549
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
set define off;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

 
BEGIN

    
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se anula la obligatoriedad del campo fechaSenyalamiento');	
	execute immediate 'update '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = NULL, TFI_VALIDACION = NULL,  USUARIOMODIFICAR = ''JMVILLEL'', FECHAMODIFICAR = SYSDATE WHERE TFI_NOMBRE = ''fechaSenyalamiento'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P418_RegistrarAdmisionYEmplazamiento'')';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se añade validación POST para que el campo fechaSenyalamiento sea obligatorio en función del valor del campo comboVista');	
	execute immediate 'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''comboVista''''] == DDSiNo.SI && valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''fechaSenyalamiento''''] == null ? ''''La fecha de se&ntilde;alamiento es obligatoria'''' : null'', USUARIOMODIFICAR = ''JMVILLEL'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''P418_RegistrarAdmisionYEmplazamiento''';

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
 
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
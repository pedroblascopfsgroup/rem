--/*
--##########################################
--## Autor: #AUTOR#
--## Descripción: Resolución FASE-1232
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

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

	DBMS_OUTPUT.PUT_LINE('[INFO] Se modifica el campo DD_PTP_PLAZO_SCRIPT para que solamente se llame a la función dame plazo si tenemos informada la fecha.');	
	execute immediate 'update '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''((valores[''''P413_SolicitudTestimonioDecretoAdjudicacion''''][''''fecha'''']) != '''''''' && (valores[''''P413_SolicitudTestimonioDecretoAdjudicacion''''][''''fecha''''] != null)) ? damePlazo(valores[''''P413_SolicitudTestimonioDecretoAdjudicacion''''][''''fecha''''])+30*24*60*60*1000L : 30*24*60*60*1000L'', USUARIOMODIFICAR = ''FASE_1232'', FECHAMODIFICAR = SYSDATE WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P413_ConfirmarTestimonio'')';

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
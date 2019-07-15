--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6948
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TFI_TAP_CODIGO VARCHAR2(100 CHAR);
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR);
    V_TFI_CAMPO VARCHAR2(100 CHAR);
    V_TFI_VALOR VARCHAR2(4000 CHAR);
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_TFI_TAP_CODIGO := 'T004_EleccionPresupuesto';
  	V_TFI_TFI_NOMBRE := 'titulo';
  	V_TFI_CAMPO := 'tfi_label';
  	V_TFI_VALOR := '<p style="margin-bottom: 10px">Una vez recibidos los presupuestos de los proveedores, debe proceder a la elección de uno de ellos.</p><p>Para ello, con carácter previo a la cumplimentación de la presente tarea, deberá anotar la información relativa a los presupuestos recibidos en la pestaña "gestión económica" del trabajo, autorizando uno de ellos.</p><p>Si no puede aceptar ningún presupuesto porque ninguno de los que le han sido remitidos es válido, deberá hacer constar el motivo. En este caso, la siguiente tarea del trámite será de nuevo la de "solicitud presupuestos".</p><p>En el caso de que sí que haya algún presupuesto que pueda ser seleccionado, deberá hacer constar la fecha en que efectúa la elección. Si la cartera es Jaipur, Ágora, Egeo o Apple la siguiente tarea que se lanzará será la de "Solicitud disposición extraordinaria al propietario". En caso de que la cartera no es ni Jaipur ni Ágora ni Egeo ni Apple la siguiente tarea que se lanzará será la de "disponibilidad de saldo".</p><p>En el campo "observaciones" puede consignar cualquier aspecto que considere levante  y que debe quedar reflejado en este punto del trámite.</p>';

  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
				SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''',
				USUARIOMODIFICAR = ''HREOS-5457'', 
				FECHAMODIFICAR = SYSDATE 
				WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
				AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''';
  	
	EXECUTE IMMEDIATE V_MSQL;
  	DBMS_OUTPUT.PUT_LINE('	[INFO] Campo '||V_TFI_TFI_NOMBRE||' de la tarea '||V_TFI_TAP_CODIGO||' actualizado correctamente');
	
	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   			
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;
/
EXIT
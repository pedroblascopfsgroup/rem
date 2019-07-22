--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6948
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar label Observaciones
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
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-6948'; -- Usuario modificar
    V_TFI_TAP_CODIGO VARCHAR2(100 CHAR);
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR);
    V_TFI_CAMPO VARCHAR2(100 CHAR);
    V_TFI_VALOR VARCHAR2(4000 CHAR);
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_TFI_TAP_CODIGO := 'T013_InstruccionesReserva';
  	V_TFI_TFI_NOMBRE := 'observaciones';
  	V_TFI_CAMPO := 'TFI_LABEL';
  	V_TFI_VALOR := 'Observaciones';

  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
				SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''', 
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
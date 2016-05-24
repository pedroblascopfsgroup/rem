--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=CMREC-3220
--## PRODUCTO=NO
--##
--## Finalidad: Cambio de 
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-3220');
	
	V_TAREA:='H039_registrarConclusionConcurso';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea deber&aacute; indicar si el concurso definitivamente ha llegado a conclusi&oacute;n o no, as&iacute; como la fecha de tal resoluci&oacute;n.</p><p style="margin-bottom: 10px">En caso de conclusi&oacute;n definitiva, se generar&aacute; una notificación a Control de Gesti&oacute;n Haya (ControldegestionHaya@cajamar.int) y  al Staff de consultor&iacute;a (StaffJuridicoConsultoriayContratacion@cajamar.int) y administraci&oacute;n contable (administracioncontab@cajamar.int) para que realicen las actuaciones pertinentes.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; para el caso de la no conclusi&oacute;n una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable  de la entidad, para el caso de que s&iacute; haya concluido el concurso se dar&aacute; por finalizado el mismo.</p></div>''' || 
					', USUARIOMODIFICAR = ''CMREC-3220'', FECHAMODIFICAR = SYSDATE ' ||
					' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-3220');
		
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
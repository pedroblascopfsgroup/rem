--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: DML
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarMinimoBienLote() ? (comprobarBienInformado() ? (comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? validacionesCelebracionSubastaPRE() : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote</div>'''''','||
'tap_script_validacion_jbpm = ''valores[''''P401_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : validacionesCelebracionSubastaPOST()) : validacionesCelebracionSubastaPOST() ))'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_CelebracionSubasta'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarGestoriaAsignadaPrc() ? comprobarAdjuntoDecretoFirmeAdjudicacion() ? validacionesConfirmarTestimonioPRE() : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>'''' : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe asignar la Gestor&iacute;a encargada de tramitar la adjudicaci&oacute;n.</div>'''''', tap_script_validacion_jbpm = ''valores[''''P413_ConfirmarTestimonio''''][''''comboSubsanacion''''] == DDSiNo.SI ? validacionesConfirmarTestimonioPOST() : ((valores[''''P413_ConfirmarTestimonio''''][''''fechaTestimonio''''] == null || valores[''''P413_ConfirmarTestimonio''''][''''fechaEnvioGestoria''''] == null) ? ''''Las fechas testimonio y envio gestoría son obligatorias'''' : validacionesConfirmarTestimonioPOST())'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P413_ConfirmarTestimonio'')';

--BKNIVDOS-1102
--alta_bpm_instances;
--alta_bpm_instances_subastas;
--alta_bpm_instances_subastas_2;

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


--/*
--##########################################
--## Author: Óscar
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

    V_TEXT1 VARCHAR(1500 CHAR);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Modificando campos TAP_SCRIPT_DECISION en P401_SenyalamientoSubasta');
	V_TEXT1 := 'comprobarMinimoBienLote() ? (comprobarBienInformado() ? (comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote</div>''''';
	execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion='''|| V_TEXT1 ||''' where tap_codigo = ''P401_SenyalamientoSubasta''';

	DBMS_OUTPUT.PUT_LINE('[INICIO] Modificando campos TAP_SCRIPT_DECISION en P401_CelebracionSubasta');
	V_TEXT1 := 'comprobarMinimoBienLote() ? (comprobarBienInformado() ? (comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? (comprobarImporteEntidadAdjudicacionBienes() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote</div>''''';
	execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion='''|| V_TEXT1 ||''' where tap_codigo = ''P401_CelebracionSubasta''';

	DBMS_OUTPUT.PUT_LINE('[INICIO] Modificando campos TAP_SCRIPT_DECISION en P409_SenyalamientoSubasta');
	V_TEXT1 := 'comprobarMinimoBienLote() ? (comprobarBienInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote.</div>''''';
	execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion='''|| V_TEXT1 ||''' where tap_codigo = ''P409_SenyalamientoSubasta''';

	DBMS_OUTPUT.PUT_LINE('[INICIO] Modificando campos TAP_SCRIPT_DECISION en P409_CelebracionSubasta');
	V_TEXT1 := 'comprobarMinimoBienLote() ? (comprobarBienInformado() ? (comprobarExisteDocumentoESRAS() ? (comprobarImporteEntidadAdjudicacionBienes() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote.</div>''''';
	execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion='''|| V_TEXT1 ||''' where tap_codigo = ''P409_CelebracionSubasta''';
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Fin modificacion');

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

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


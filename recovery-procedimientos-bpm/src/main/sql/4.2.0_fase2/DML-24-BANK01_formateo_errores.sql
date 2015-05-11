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

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>'''''' where tap_codigo = ''P22_RegistrarResolucion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Antes de realizar la tarea es necesario marcar los bienes con fecha de registro de embargo</div>'''' : null''  where tap_codigo = ''P14_RegistrarAnotacionEnRegistro''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P34_registrarResolucion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P30_RegResolucionConvenio''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P25_RegistrarResolucion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P28_registrarResolucion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoPI() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento planes de liquidación.</div>'''''' where tap_codigo = ''P31_InformeLiquidacion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P31_registrarResolucion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P62_registrarResolucion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P94_RegistrarResolucion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P96_registrarResolucionOposicion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P96_registrarResolucionAllanamiento''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote</div>''''''  where tap_codigo = ''P401_SolicitudSubasta''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote</div>''''''  where tap_codigo = ''P409_SolicitudSubasta''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resolución acordando señalamiento</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de subasta</div>''''''  where tap_codigo = ''P409_SenyalamientoSubasta''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">El bien debe estar asociado al trámite, asócielo desde la pestaña de Bienes del procedimiento para poder finalizar esta tarea.</div>''''''  where tap_codigo = ''P413_SolicitudDecretoAdjudicacion''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoIPAC() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento informe provisional del AC.</div>''''''  where tap_codigo = ''P412_RegistrarInformeAdmonConcursal''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoECC() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento escrito de comunicación de créditos.</div>''''''  where tap_codigo = ''P412_RegistrarInsinuacionCreditos''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoADC() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto de declaración del concurso.</div>''''''  where tap_codigo = ''P412_RegistrarPublicacionBOE''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoTDAC() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento textos definitivos del AC.</div>''''''  where tap_codigo = ''P412_RegistrarResolucionFaseComun''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarExisteDocumentoASDJM() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.</div>''''''  where tap_codigo = ''P406_RegistrarResHomologacionJudicial''';
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion=''comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resolución acordando señalamiento</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de subasta</div>''''''  where tap_codigo = ''P401_SenyalamientoSubasta''';

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


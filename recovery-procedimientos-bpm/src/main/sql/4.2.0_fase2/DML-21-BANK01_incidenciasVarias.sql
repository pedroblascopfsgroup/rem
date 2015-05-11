--/*
--##########################################
--## Author: Gonzalo
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

--INC 87
execute immediate 'update '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT=''(valores[''''P401_RegistrarActaSubasta'''']!=null && valores[''''P401_RegistrarActaSubasta''''][''''fecha''''] != null) ? damePlazo(valores[''''P401_RegistrarActaSubasta''''][''''fecha''''])+1*24*60*60*1000L : 1*24*60*60*1000L'' WHERE TAP_ID IN (SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO LIKE ''P401_ContabilizarCierreDeuda'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoDSCC() ? null : ''''Es necesario adjuntar el documento demanda sellada + certificación de cargas (cuando se obtenga)'''')'' where tap_codigo = ''P01_DemandaCertificacionCargas''';

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


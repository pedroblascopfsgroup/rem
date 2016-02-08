--/*
--##########################################
--## Author: JoseVi
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    --Variables necesarias para nuevo formato de scripts SQL
    --V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    --V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    --v_RSR_NOMBRE_SCRIPT VARCHAR2(255 CHAR) := '&&1';
    --v_RSR_FECHACREACION VARCHAR2(20 CHAR) := '&&2';
    --v_RSR_RESULTADO VARCHAR2(100 CHAR) := '&&3';
    --v_RSR_ERROR_SQL VARCHAR2(255 CHAR) := '&&4';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO] BKNIVDOS-1287');

-- BKNIVDOS-723 - Cambio YA realizado en esta tarea - T. Adjudicación
--DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAP_TAREA_PROCEDIMIENTO - Incidencia BKNIVDOS-723...');
--EXECUTE IMMEDIATE ('update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' where tap_codigo = ''P413_SolicitudDecretoAdjudicacion''');

-- P95_registrarAnuncioSubasta - No alteramos la validación porque la lógica está invertida y el mensaje ya es claro
--DBMS_OUTPUT.PUT_LINE('[INFO] Cambio mensaje validación 1 bien - T. de ejecución notarial - P95_registrarAnuncioSubasta...');
--EXECUTE IMMEDIATE ('update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' where tap_codigo = ''P95_registrarAnuncioSubasta''');
-- Groovy anterior: !comprobarBienAsociadoPrc() ? '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; registrar al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes.</p></div>': ( !tieneAlgunBienConFichaSubasta2() ? '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; dictar instrucciones para subasta en al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes de la ficha del Procedimiento correspondiente y proceder a dictar instrucciones.</p></div>' : null)

DBMS_OUTPUT.PUT_LINE('[INFO] Cambio mensaje validación 1 bien - T. de saneamiento de cargas - P415_RevisarEstadoCargas');
EXECUTE IMMEDIATE ('update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienInscrito() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para cada una de las cargas, debe especificar el tipo y estado.</div>''''): ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' where tap_codigo = ''P415_RevisarEstadoCargas''');
-- Groovy anterior: comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienInscrito() ? null : '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para cada una de las cargas, debe especificar el tipo y estado.</div>'): '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe tener un bien asociado al procedimiento.</div>'

DBMS_OUTPUT.PUT_LINE('[INFO] Cambio mensaje validación 1 bien - T. de Posesión - P416_RegistrarSolicitudPosesion');
EXECUTE IMMEDIATE ('update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' where tap_codigo = ''P416_RegistrarSolicitudPosesion''');
-- Groovy anterior: comprobarBienAsociadoPrc() ? null : '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe tener un bien asociado al procedimiento.</div>'

DBMS_OUTPUT.PUT_LINE('[INFO] Cambio mensaje validación 1 bien - T. de gestión de llaves - P417_RegistrarCambioCerradura');
EXECUTE IMMEDIATE ('update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' where tap_codigo = ''P417_RegistrarCambioCerradura''');
-- Groovy anterior: comprobarBienAsociadoPrc() ? null : '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe seleccionar un BIEN para poder realizar el tramite de gesti&oacute;n de llaves.</div>'

DBMS_OUTPUT.PUT_LINE('[INFO] Cambio mensaje validación 1 bien - T. de moratoria de lanzamiento - P418_RegistrarSolicitudMoratoria');
EXECUTE IMMEDIATE ('update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' where tap_codigo = ''P418_RegistrarSolicitudMoratoria''');
-- Groovy anterior: comprobarBienAsociadoPrc() ? null : '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>'

DBMS_OUTPUT.PUT_LINE('[INFO] Cambio mensaje validación 1 bien - T. de ocupantes - P419_TrasladoDocuDeteccionOcupantes');
EXECUTE IMMEDIATE ('update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Este tr&aacute;mite requiere tener un solo bien asociado. Vaya a la pesta&nacute;a de bienes del procedimiento y aseg&uacute;rese de que hay un bien asociado y no m&aacute;s de uno.</div>'''' '' where tap_codigo = ''P419_TrasladoDocuDeteccionOcupantes''');
-- Groovy anterior: comprobarBienAsociadoPrc() ? null : '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>'



COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA BKNIVDOS-1287');

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


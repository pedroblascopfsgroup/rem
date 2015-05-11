--/*
--##########################################
--## Author: JoseVi - Alberto
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
  DBMS_OUTPUT.PUT_LINE('[INICIO] INCIDENCIA [FASE-1058]--------------------------------------------------');

  DBMS_OUTPUT.PUT_LINE('[INFO] Revisión del indicador de cancelación en tareas de varios trámites para ajustar lo que indican sus BPM');
  DBMS_OUTPUT.PUT_LINE('[INFO] --------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('[INFO] Inicio modificacion');

	execute immediate 
    'update '||V_ESQUEMA||'.tap_tarea_procedimiento
      set tap_alert_vuelta_atras = null
      where tap_codigo in (''P417_Decision1'',''P417_RegistrarCambioCerradura'')';
  DBMS_OUTPUT.PUT_LINE('[INFO] T. Gestión de llaves - Corregidas 2 tareas');

  --T. Adjudicación revisado y OK - sin cambios
  DBMS_OUTPUT.PUT_LINE('[INFO] T. Adjudicación - Corregidas 0 tareas');

  execute immediate 
    'update '||V_ESQUEMA||'.tap_tarea_procedimiento
      set tap_alert_vuelta_atras = ''tareaExterna.cancelarTarea''
      where tap_codigo in (''P415_RegInsCancelacionCargasReg'',''P415_RevisarPropuestaCancelacionCargas'',''P415_LiquidarCargas'',''P415_RegInsCancelacionCargasEconomicas'',''P415_RegistrarPresentacionInscripcionEco'',''P415_RegInsCancelacionCargasRegEco'')';
  DBMS_OUTPUT.PUT_LINE('[INFO] T. Saneamiento de cargas - Corregidas 6 tareas');

  --T. Posesión revisado y OK - sin cambios
  DBMS_OUTPUT.PUT_LINE('[INFO] T. Posesión - Corregidas 0 tareas');

  execute immediate 
    'update '||V_ESQUEMA||'.tap_tarea_procedimiento
      set tap_alert_vuelta_atras = null
      where tap_codigo = ''P411_ConsultarTributacionDeBienes''';
  DBMS_OUTPUT.PUT_LINE('[INFO] T. Tributación de bienes - Corregidas 1 tareas');
  
  execute immediate 
    'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
	set tap_alert_vuelta_atras = null
	where tap_codigo in (''P401_ValidarPropuesta'',''P401_BPMTramiteAdjudicacionV4'')';
	
   execute immediate 
    'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
	set tap_alert_vuelta_atras = ''tareaExterna.cancelarTarea''
	where tap_codigo in (''P401_PrepararCesionRemate'',''P401_SuspenderSubasta'',''P401_RegistrarActaSubasta'',''P401_SolicitarMtoPago'',''P401_ContabilizarCierreDeuda'')';
  
  DBMS_OUTPUT.PUT_LINE('[INFO] T. Subasta - Corregidas 7 tareas');
  
  execute immediate 
    'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
	set tap_alert_vuelta_atras = null
	where tap_codigo in (''P409_ValidarPropuesta'',''P409_BPMTramiteAdjudicacionV4'')';
	
   execute immediate 
    'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
	set tap_alert_vuelta_atras = ''tareaExterna.cancelarTarea''
	where tap_codigo in (''P409_SolicitarMtoPago'')';
  
  DBMS_OUTPUT.PUT_LINE('[INFO] T. Subasta SAREB- Corregidas 3 tareas');

	DBMS_OUTPUT.PUT_LINE('[INFO] Fin modificacion');

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA-----------------------------------------------------------------');

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

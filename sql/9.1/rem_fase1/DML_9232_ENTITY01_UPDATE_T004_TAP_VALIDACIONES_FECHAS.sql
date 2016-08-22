--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.4
--## INCIDENCIA_LINK=HREOS-379
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza las validaciones de trámites
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --REGISTRO TFI ELEGIDO
    V_TAP_TAP_CODIGOS VARCHAR2(4000 CHAR) := '';

    --CAMPO TFI PARA ACTUALIZAR
    V_TAP_CAMPO VARCHAR2(100 CHAR)  := '';
    V_TAP_VALOR VARCHAR2(1000 CHAR) := '';


/* VALIDACIONES POST ANTIGUAS:
TAP_CODIGO  TAP_SCRIPT_VALIDACION TAP_SCRIPT_VALIDACION_JBPM
T004_AnalisisPeticion   valores['T004_AnalisisPeticion']['comboTramitar'] == DDSiNo.NO ? (valores['T004_AnalisisPeticion']['motivoDenegacion'] == '' ? 'Si deniega la petici&oacute;n debe indicar un motivo' : null) : ((valores['T004_AnalisisPeticion']['comboCubierto'] == DDSiNo.SI && valores['T004_AnalisisPeticion']['comboAseguradoras'] == '' ) ? 'Si el trabajo est&aacute; cubierto, debe indicar la compa&ntilde;&iacute;a de seguros' : null)
T004_AutorizacionPropietario    (valores['T004_AutorizacionPropietario']['comboAmpliacion'] == DDSiNo.SI && valores['T004_AutorizacionPropietario']['numIncremento'] == '' ) ? 'En caso de que se conceda la ampliaci&oacute;n de presupuesto solicitada, deber&aacute; anotar su importe' : null
T004_CierreEconomico    esFechaMenor(valores['T004_CierreEconomico']['fechaCierre'], fechaValidacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n' : null
T004_DisponibilidadSaldo    
T004_EleccionPresupuesto  comprobarExistePresupuestoTrabajo() == false? 'Debe asignar al menos un presupuesto al trabajo' : null  valores['T004_EleccionPresupuesto']['comboPresupuesto'] == DDSiNo.NO ? (valores['T004_EleccionPresupuesto']['motivoInvalidez'] == ''  ? 'Si no hay presupuesto v&aacute;lido, debe indicar un motivo de invalidez' : null) : (valores['T004_EleccionPresupuesto']['fechaEmision'] == ''  ? 'Si hay presupuesto v&aacute;lido, debe indicar la fecha de selecci&oacute;n' : null)
T004_EleccionProveedorYTarifa   (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? 'Debe asignar al menos un proveedor y al menos una tarifa al trabajo.' : (comprobarExisteProveedorTrabajo() == false ? 'Debe asignar al menos un proveedor al trabajo.' : (comprobarExisteTarifaTrabajo() == false ? 'Debe asignar al menos una tarifa al trabajo.' : null ) )
T004_FijacionPlazo    
T004_ResultadoNoTarificada    (valores['T004_ResultadoNoTarificada']['comboModificacion'] == DDSiNo.NO && valores['T004_ResultadoNoTarificada']['fechaFinalizacion'] == '' ) ? 'Si ya ha finalizado el trabajo, deber&aacute; indicar la fecha de finalizaci&oacute;n' : null
T004_ResultadoTarificada    
T004_SolicitudExtraordinaria    
T004_SolicitudPresupuestoComplementario   
T004_SolicitudPresupuestos    

T004_ValidacionTrabajo    (valores['T004_ValidacionTrabajo']['comboEjecutado'] == DDSiNo.NO ? (valores['T004_ValidacionTrabajo']['motivoIncorreccion'] == '' ? 'Si el trabajo no se ha ejecutado de forma correcta, debe indicar el motivo' : null) : (valores['T004_ValidacionTrabajo']['comboValoracion'] == '' ? 'Debe indicar la valoraci&oacute;n del proveedor' : null) )
*/

BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO VALIDACIONES - TRAMITE ACTUACION TECNICA: validaciones de fechas y documentos requeridos');


  --ACTUALIZACION DE VALIDACIONE POST 
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION_JBPM';

  -- ACTUACION TECNICA - ANALISIS PETICION - SIN Validación POST - Tarea sin fechas --------
  V_TAP_TAP_CODIGOS := ' ''T004_AnalisisPeticion'' ';
  V_TAP_VALOR := '';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  
  -- ACTUACION TECNICA - AUTORIZACION PROPIETARIO - Validación POST fecha mayora a aprobación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T004_AutorizacionPropietario'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_AutorizacionPropietario''''][''''fecha''''], fechaAprobacionTrabajo()) ? ''''Fecha autorizaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- ACTUACION TECNICA - CIERRE ECONOMICO - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T004_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- ACTUACION TECNICA - ELECCION PRESUPUESTO - Validación POST fecha mayor a aprobación Trabajo y comprobacion si hay presupuesto trabajo --------
  V_TAP_TAP_CODIGOS := ' ''T004_EleccionPresupuesto'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_EleccionPresupuesto''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha elecci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : (comprobarExistePresupuestoTrabajo() == false? ''''Debe asignar al menos un presupuesto al trabajo'''' : null)';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- ACTUACION TECNICA - ELECCION PROVEEDOR Y TARIFA - Validación POST fecha mayor a aprobación Trabajo y comprobaciones de proveedor y tarifa
  V_TAP_TAP_CODIGOS := ' ''T004_EleccionProveedorYTarifa'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_EleccionProveedorYTarifa''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha elecci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? ''''Debe asignar al menos un proveedor y al menos una tarifa al trabajo.'''' : (comprobarExisteProveedorTrabajo() == false ? ''''Debe asignar al menos un proveedor al trabajo.'''' : (comprobarExisteTarifaTrabajo() == false ? ''''Debe asignar al menos una tarifa al trabajo.'''' : null ) )';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- ACTUACION TECNICA - RESULTADO NO TARIFICADA - Validación POST fecha mayor a aprobación Trabajo --------
  V_TAP_TAP_CODIGOS := ' ''T004_ResultadoNoTarificada'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_ResultadoNoTarificada''''][''''fechaFinalizacion''''], fechaAprobacionTrabajo()) ? ''''Fecha finalizaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- ACTUACION TECNICA - RESULTADO TARIFICADA - Validación POST fecha mayor a aprobación Trabajo --------
  V_TAP_TAP_CODIGOS := ' ''T004_ResultadoTarificada'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_ResultadoTarificada''''][''''fechaFinalizacion''''], fechaAprobacionTrabajo()) ? ''''Fecha finalizaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


  -- ACTUACION TECNICA - SOLICITUD EXTRAORDINARIA - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T004_SolicitudExtraordinaria'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_SolicitudExtraordinaria''''][''''fecha''''], fechaAprobacionTrabajo()) ? ''''Fecha solicitud debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


  -- ACTUACION TECNICA - SOLICITUD EXTRAORDINARIA Y COMP. - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T004_SolicitudPresupuestoComplementario'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_SolicitudPresupuestoComplementario''''][''''fechaFinalizacion''''], fechaAprobacionTrabajo()) ? ''''Fecha finalizaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


  -- ACTUACION TECNICA - SOLICITUD PRESUPUESTOS - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T004_SolicitudPresupuestos'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_SolicitudPresupuestos''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha solicitud debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- ACTUACION TECNICA - VALIDACION TRABAJO - Validación POST fecha mayor a aprobación Trabajo --------
  V_TAP_TAP_CODIGOS := ' ''T004_ValidacionTrabajo'' ';
  V_TAP_VALOR := 'valores[''''T004_ValidacionTrabajo''''][''''comboEjecutado''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T004_ValidacionTrabajo''''][''''fechaValidacion''''], fechaAprobacionTrabajo()) ? ''''Fecha validaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null) : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;




  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');


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

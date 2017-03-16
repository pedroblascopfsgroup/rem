--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1618
--## PRODUCTO=NO
--##
--## Finalidad: Realiza las modificaciones necesarias para las tareas de Cierre Economico
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_TAP_CODIGO VARCHAR2(50);
    V_TAP_VALIDA_JBPM VARCHAR2(2000);
    V_TFI_AUDIT_USER VARCHAR2(4000 CHAR) := 'DML_99900101';
    
    
    /* ################################################################################
     ## MODIFICACIONES: Nuevas validaciones Todas tareas - Cierre Economico (excepto actuacion tecnica)
     ## - Para cerrar tarea debe haber asignado proveedor y tarifa
     ## - Todos los tramites de FASE1 a excepcion de actuacion tecnica que ya valida esto
     ##
      --T002_CierreEconomico-esFechaMenor(valores['T002_CierreEconomico']['fechaCierre'], fechaValidacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n del trabajo' : null
      --T003_CierreEconomico-esFechaMenor(valores['T003_CierreEconomico']['fechaCierre'], fechaValidacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n' : ( (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? 'Debe asignar al menos un proveedor y al menos una tarifa al trabajo.' : (comprobarExisteProveedorTrabajo() == false ? 'Debe asignar al menos un proveedor al trabajo.' : (comprobarExisteTarifaTrabajo() == false ? 'Debe asignar al menos una tarifa al trabajo.' : null )) )
      --T008_CierreEconomico-esFechaMenor(valores['T008_CierreEconomico']['fechaCierre'], fechaAprobacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo' : null
      --T005_CierreEconomico-esFechaMenor(valores['T005_CierreEconomico']['fechaCierre'], fechaAprobacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo' : null
      --T006_CierreEconomico-esFechaMenor(valores['T006_CierreEconomico']['fechaCierre'], fechaValidacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n' : null
     */
    
BEGIN

--  T002_CierreEconomico ------------------------------------------

    V_TAP_CODIGO := 'T002_CierreEconomico';
    V_TAP_VALIDA_JBPM := 'esFechaMenor(valores[''''T002_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : ( (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? ''''Debe asignar al menos un proveedor y al menos una tarifa al trabajo.'''' : (comprobarExisteProveedorTrabajo() == false ? ''''Debe asignar al menos un proveedor al trabajo.'''' : (comprobarExisteTarifaTrabajo() == false ? ''''Debe asignar al menos una tarifa al trabajo.'''' : null )) )';

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    '           SET tap_script_validacion_jbpm = '''||V_TAP_VALIDA_JBPM||''',
                USUARIOMODIFICAR = '''||V_TFI_AUDIT_USER||''',
                FECHAMODIFICAR = sysdate
                WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea - '||V_TAP_CODIGO||'.......');
    -- DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

--  T003_CierreEconomico ------------------------------------------

    V_TAP_CODIGO := 'T003_CierreEconomico';
    V_TAP_VALIDA_JBPM := 'esFechaMenor(valores[''''T003_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : ( (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? ''''Debe asignar al menos un proveedor y al menos una tarifa al trabajo.'''' : (comprobarExisteProveedorTrabajo() == false ? ''''Debe asignar al menos un proveedor al trabajo.'''' : (comprobarExisteTarifaTrabajo() == false ? ''''Debe asignar al menos una tarifa al trabajo.'''' : null )) )';

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    '           SET tap_script_validacion_jbpm = '''||V_TAP_VALIDA_JBPM||''',
                USUARIOMODIFICAR = '''||V_TFI_AUDIT_USER||''',
                FECHAMODIFICAR = sysdate
                WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea - '||V_TAP_CODIGO||'.......');
    -- DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

--  T005_CierreEconomico ------------------------------------------

    V_TAP_CODIGO := 'T005_CierreEconomico';
    V_TAP_VALIDA_JBPM := 'esFechaMenor(valores[''''T005_CierreEconomico''''][''''fechaCierre''''], fechaAprobacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : ( (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? ''''Debe asignar al menos un proveedor y al menos una tarifa al trabajo.'''' : (comprobarExisteProveedorTrabajo() == false ? ''''Debe asignar al menos un proveedor al trabajo.'''' : (comprobarExisteTarifaTrabajo() == false ? ''''Debe asignar al menos una tarifa al trabajo.'''' : null )) )';

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    '           SET tap_script_validacion_jbpm = '''||V_TAP_VALIDA_JBPM||''',
                USUARIOMODIFICAR = '''||V_TFI_AUDIT_USER||''',
                FECHAMODIFICAR = sysdate
                WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea - '||V_TAP_CODIGO||'.......');
    -- DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

--  T006_CierreEconomico ------------------------------------------

    V_TAP_CODIGO := 'T006_CierreEconomico';
    V_TAP_VALIDA_JBPM := 'esFechaMenor(valores[''''T006_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : ( (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? ''''Debe asignar al menos un proveedor y al menos una tarifa al trabajo.'''' : (comprobarExisteProveedorTrabajo() == false ? ''''Debe asignar al menos un proveedor al trabajo.'''' : (comprobarExisteTarifaTrabajo() == false ? ''''Debe asignar al menos una tarifa al trabajo.'''' : null )) )';

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    '           SET tap_script_validacion_jbpm = '''||V_TAP_VALIDA_JBPM||''',
                USUARIOMODIFICAR = '''||V_TFI_AUDIT_USER||''',
                FECHAMODIFICAR = sysdate
                WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea - '||V_TAP_CODIGO||'.......');
    -- DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

--  T008_CierreEconomico ------------------------------------------

    V_TAP_CODIGO := 'T008_CierreEconomico';
    V_TAP_VALIDA_JBPM := 'esFechaMenor(valores[''''T008_CierreEconomico''''][''''fechaCierre''''], fechaAprobacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : ( (comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? ''''Debe asignar al menos un proveedor y al menos una tarifa al trabajo.'''' : (comprobarExisteProveedorTrabajo() == false ? ''''Debe asignar al menos un proveedor al trabajo.'''' : (comprobarExisteTarifaTrabajo() == false ? ''''Debe asignar al menos una tarifa al trabajo.'''' : null )) )';

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    '           SET tap_script_validacion_jbpm = '''||V_TAP_VALIDA_JBPM||''',
                USUARIOMODIFICAR = '''||V_TFI_AUDIT_USER||''',
                FECHAMODIFICAR = sysdate
                WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea - '||V_TAP_CODIGO||'.......');
    -- DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;


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
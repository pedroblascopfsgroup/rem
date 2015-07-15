/*
--######################################################################
--## Author: JOSEVI
--## BPM: T. Calificacion (H035) - Correcciones HR51
--## Finalidad: Corregir datos BPM por incidencia
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR) := 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_UPD  VARCHAR2(100 CHAR); -- Tabla a modificar

    PAR_AUTHOR       VARCHAR2(100 CHAR) := 'JOSEVI'; -- Autor del Script
    PAR_AUTHOR_EMAIL VARCHAR2(200 CHAR) := 'josevicente.jimenez@pfsgroup.es';
    PAR_AUTHOR_TELF  VARCHAR2(200 CHAR) := '2032';


    BEGIN

        /****************************************************************************************************
        * HR51 - Correccion error validacion de tarea
        ****************************************************************************************************/
   
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* HR51 - Correccion Tramite Calificacion                                                             ');
        DBMS_OUTPUT.PUT_LINE('* .................................................................................................. ');
        DBMS_OUTPUT.PUT_LINE('* En tarea Registrar Oposicion NO se debe validar fecha si el combo = NO (no oposicion)              ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        -- UPDATE 1: TAP_TAREA_PROCEDIMIENTO ----------------------------------------------------------------------------------
        V_TABLA_UPD := 'TAP_TAREA_PROCEDIMIENTO';

        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA_UPD||' ' ||
                ' set tap_script_validacion_jbpm = ''((valores[''''H035_registrarOposicion''''][''''comboOposicion''''] == DDSiNo.SI) && ((valores[''''H035_registrarOposicion''''][''''fecha''''] == ''''''''))) ? ''''tareaExterna.error.H035_registrarOposicion.fechasOblgatorias'''' : null'' ' ||
                ' , tap_view = ''plugin/procedimientos-bpmHaya/tramiteCalificacion/validarFechaSiOposicion'' ' ||
                ' where tap_codigo = ''H035_registrarOposicion'' '
                ;
    
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' y repita ejecución');
            RETURN;
        END IF; 


        -- UPDATE 2: DD_PTP_PLAZOS_TAREAS_PLAZAS ----------------------------------------------------------------------------------
        V_TABLA_UPD := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';

        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA_UPD||' ' ||
                'set dd_ptp_plazo_script = ''valores[''''H035_registrarOposicion''''][''''fecha''''] == null ?  5*24*60*60*1000L :  (damePlazo(valores[''''H035_registrarOposicion''''][''''fecha'''']) + 2*24*60*60*1000L )'' ' ||
                'where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''H035_registrarResolucion'') '
                ;
    
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' y repita ejecución');
            RETURN;
        END IF; 


        -- UPDATE 3: TFI_TAREAS_FORM_ITEMS ----------------------------------------------------------------------------------
        V_TABLA_UPD := 'TFI_TAREAS_FORM_ITEMS';

        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'update tfi_tareas_form_items ' ||
                'set tfi_error_validacion = null, tfi_validacion = ''valor != null && valor != '''''''' ? true : false'' ' ||
                'where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''H035_registrarOposicion'') ' ||
                'and tfi_nombre = ''fecha'' '
                ;
    
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' y repita ejecución');
            RETURN;
        END IF; 


        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script HR51');
        RETURN;
    
    /*    
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */

EXCEPTION

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT('[KO]');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('SQL que ha fallado:');
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.put_line('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.put_line('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;   

END; --End Procedure
/

EXIT;
/*
--######################################################################
--## Author: JOSEVI
--## BPM: T. Investigación Judicial - Correcciones HR338
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
        * HR338 - Correccion errores T.Investigacion Judicial
        ****************************************************************************************************/
   
        DBMS_OUTPUT.PUT_LINE('/*****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* HR338 - Correccion errores T.Investigacion Judicial                                                 ');
        DBMS_OUTPUT.PUT_LINE('* ................................................................................................... ');
        DBMS_OUTPUT.PUT_LINE('* Error en tarea 3, no se muestra la info readonly registrada en tarea2                               ');
        DBMS_OUTPUT.PUT_LINE('*****************************************************************************************************/');
    
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
                ' set ' ||
                '  tap_view = ''plugin/procedimientos-bpmHaya/tramiteInvestigacionJudicial/revisarInvestigacion'' ' ||
                ' where tap_codigo = ''H044_RevisarInvestigacionYActualizacionDatos'' '
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
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script HR338');
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
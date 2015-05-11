--/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DML para actualizar tarea y plazo de T.Notificacion para adaptar Bankia --> Haya
--## INSTRUCCIONES:  Configurar las constantes del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    --Constantes
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_TABLA1_UPD VARCHAR2(100) := 'DD_PTP_PLAZOS_TAREAS_PLAZAS'; -- Constante con la tabla sobre la que se actualizan valores
    V_T1_COL1_UPD VARCHAR2(200) := 'DD_PTP_PLAZO_SCRIPT'; --Constante con la columna1 a actualizar
    V_TABLA2_UPD VARCHAR2(100) := 'TAP_TAREA_PROCEDIMIENTO'; -- Constante con la tabla sobre la que se actualizan valores
    V_T2_COL1_UPD VARCHAR2(200) := 'TAP_AUTOPRORROGA'; --Constante con la columna1 a actualizar
    V_T2_COL2_UPD VARCHAR2(200) := ''; --Constante con la columna1 a actualizar

    --Variables
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN   
    -- ******** Diccionarios previos ********
    -- No hay


    DBMS_OUTPUT.PUT_LINE('[INFO] Actualización de parámetros del trámite de Notificación de BANKIA para funcionar en HAYA'); 

    /****************************************
    * UPDATES TABLA 1
    *****************************************/
    --Se verifica si existe la tabla1  en el esquema indicado
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA1_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Solo si existe la tabla1 a actualizar, se ejecuta el script de actualización
    DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA1_UPD||', en esquema '||V_ESQUEMA||' CODIGO: P400_GestionarNotificaciones...'); 
    IF V_NUM_TABLAS > 0 THEN
        --Existe correcto
        V_MSQL := 
        ' update '||V_ESQUEMA||'.'||V_TABLA1_UPD||' '||
        '  set '||V_T1_COL1_UPD||' = ''60*24*60*60*1000L'' '||
        ' where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''P400_GestionarNotificaciones'') '
            ;
        --BANKIA = ''80*24*60*60*1000L''

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('OK');
    ELSE
        --No existe tabla
        DBMS_OUTPUT.PUT_LINE('KO');
        DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA1_UPD);
        DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones del script');
        DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA1_UPD||' con sus campos '||V_T1_COL1_UPD||' y repita ejecución');
        RETURN;
    END IF;


    /****************************************
    * UPDATE TABLA 2 
    *****************************************/
    --Se verifica si existe la tabla2  en el esquema indicado
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA2_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Solo si existe la tabla2 a actualizar, se ejecuta el script de actualización
    DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', en esquema '||V_ESQUEMA||' CODIGO: P400_GestionarNotificaciones...');     
    IF V_NUM_TABLAS > 0 THEN
        --Existe correcto

        V_MSQL := 
            ' update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' '||
            ' set '||V_T2_COL1_UPD||' = 0 '||
            ' where tap_codigo = ''P400_GestionarNotificaciones'' '
            ;
            --BANKIA = 1

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('OK');

    ELSE
        --No existe tabla
        DBMS_OUTPUT.PUT_LINE('KO');
        DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA2_UPD);
        DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones del script');
        DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA2_UPD||' con sus campos '||V_T2_COL1_UPD||' y repita ejecución');
        RETURN;
    END IF;


    COMMIT;
    DBMS_OUTPUT.put_line('[INFO] COMMIT. Script terminado correctamente.');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.PUT_LINE('KO'); 
    DBMS_OUTPUT.put_line('[INFO] ROLLBACK. Script terminado con errores.');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line('SQL que genera el error:');
    DBMS_OUTPUT.put_line(V_MSQL); 
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
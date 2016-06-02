--/*
--##########################################
--## Author: JoseVi
--## Finalidad: DML Insertar campos en T. Análisis de contratos
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    --Variables de tabla+columna única a actualizar/insertar
    V_TABLA_UPD   VARCHAR2(50);
    V_COL_UPD     VARCHAR2(50);
    V_COD_SEL     VARCHAR2(50);
    V_TABLE_INS   VARCHAR2(50);
    V_WHERE_UPD   VARCHAR2(5000);
    --Variables de tabla única y columnas múltiples a actualizar/insertar
    V_COL_UPD1    VARCHAR2(50);
    V_COL_UPD2    VARCHAR2(50);
    V_COL_UPD3    VARCHAR2(50);
    --Variables para tabla1 a insertar/actualizar
    V_TABLA1_UPD  VARCHAR2(50);
    V_T1_COL1_UPD VARCHAR2(50);
    V_T1_COL2_UPD VARCHAR2(50);
    V_T1_COL3_UPD VARCHAR2(50);
    V_T1_COD1_WRE VARCHAR2(50);
    --Variables para tabla2 a insertar/actualizar
    V_TABLA2_UPD  VARCHAR2(50);
    V_T2_COL1_UPD VARCHAR2(50);
    V_T2_COL2_UPD VARCHAR2(50);
    V_T2_COD1_WRE VARCHAR2(50);
    --Variables para verificaciones
    V_NUM_UPD     VARCHAR2(50);


    /*
    * ARRAYS TABLA4: TFI_TAREAS_FORM_ITEMS
    *-----------------------------------------------------------------------------------------------
    */
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(

         T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'P402_AnalisisOperacionesConcurso',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha fin de an&aacute;lisis',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'P402_AnalisisOperacionesConcurso',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observaciones',
            /*TFI_LABEL..............:*/ 'Observaciones',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ) --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila
    );
    V_TMP_TIPO_TFI T_TIPO_TFI;


BEGIN    

    --InicializaCION VAriables
    V_TABLA_UPD   := NULL;
    V_COL_UPD     := NULL;
    V_COD_SEL     := 'TAP_CODIGO';
    V_COL_UPD1    := NULL;
    V_COL_UPD2    := NULL;
    V_COL_UPD3    := NULL;
    V_TABLA1_UPD  := NULL;
    V_T1_COL1_UPD := NULL;
    V_T1_COL2_UPD := NULL;
    V_T1_COL3_UPD := NULL;
    V_T1_COD1_WRE := NULL;
    V_TABLA2_UPD  := NULL;
    V_T2_COL1_UPD := NULL;
    V_T2_COL2_UPD := NULL;
    V_T2_COD1_WRE := NULL;
    V_TABLE_INS   := 'TFI_TAREAS_FORM_ITEMS';
    V_WHERE_UPD   := NULL;
    V_NUM_TABLAS  := NULL;
    V_NUM_UPD     := NULL;


    DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-1148  Insertar campos en tarea  P402_AnalisisOperacionesConcurso                       ');
    DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');

    /************************************
    * VERIFICACION
    ************************************/
    --EXISTENCIA DE TABLA: Mediante consulta a tablas del sistema se verifica si existe la tabla
    -----------------------------------------------------------------------------------------------------------
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLE_INS || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Solo si existe la tabla1 a actualizar, se ejecuta el script de actualización
    DBMS_OUTPUT.PUT('[INFO] Verificando existencia de la tabla '||V_TABLE_INS||', en esquema '||V_ESQUEMA||'...'); 
    IF V_NUM_TABLAS > 0 THEN
        --Existe correcto
        DBMS_OUTPUT.PUT_LINE('OK');
        DBMS_OUTPUT.put_line('[INFO] Existe la tabla a insertar/actualizar '||V_TABLE_INS);        
    ELSE
        --No existe tabla
        DBMS_OUTPUT.PUT_LINE('KO');
        DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a insertar/actualizar '||V_TABLE_INS);
        DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones de este sub-procedimiento. No es posible insertar/actualizar registros');
        DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla y repita ejecución');
        RETURN;
    END IF;


    /********************************************************
    * LOOP INSERT TABLA CON VERIFICACION EXISTENCIA REGISTROS
    *********************************************************/
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertando/Actualizando registros en '||V_TABLE_INS);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_WHERE_UPD   := 'TFI_NOMBRE = '''|| V_TMP_TIPO_TFI(4) ||''' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE '||V_COD_SEL||' = '''||V_TMP_TIPO_TFI(1)||''')';

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- verificacion comparando campo TFA_CODIGO con CODIGO del array
        -----------------------------------------------------------------------------------------------------------
        V_NUM_TABLAS := NULL;
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE_INS||' WHERE '||V_WHERE_UPD;
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_COD_SEL||' = '''||V_TMP_TIPO_TFI(1)||''' Item = '''||V_TMP_TIPO_TFI(4)||'''-'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||V_TABLE_INS||', con codigo '||V_COD_SEL||' = '''||V_TMP_TIPO_TFI(1)||'''...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe ya registro en la tabla
            DBMS_OUTPUT.PUT_LINE('OK');
            DBMS_OUTPUT.PUT_LINE('[INFO] YA existe un registro en la tabla con codigo '||V_COD_SEL||' = '''||V_TMP_TIPO_TFI(1)||'''...'); 
            DBMS_OUTPUT.PUT('[INFO] Se realiza la modificación de los valores indicados en array...');
            
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLE_INS||' SET '||
                        'TFI_ORDEN ='              || ''''||V_TMP_TIPO_TFI(2)||'''' ||
                        ',TFI_TIPO ='              || ''''||V_TMP_TIPO_TFI(3)||'''' ||
                        ',TFI_LABEL ='             || ''''||V_TMP_TIPO_TFI(5)||'''' ||
                        ',TFI_ERROR_VALIDACION ='  || ''''||V_TMP_TIPO_TFI(6)||'''' ||
                        ',TFI_VALIDACION ='        || ''''||REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''')||'''' ||
                        ',TFI_VALOR_INICIAL ='     || ''''||V_TMP_TIPO_TFI(8)||'''' ||
                        ',TFI_BUSINESS_OPERATION ='|| ''''||V_TMP_TIPO_TFI(9)||'''' ||
                        ',VERSION ='               || ''''||V_TMP_TIPO_TFI(10)||'''' ||
                        ',USUARIOMODIFICAR ='      || ''''||V_TMP_TIPO_TFI(11)||'''' ||
                        ',FECHAMODIFICAR ='        || ''''||SYSDATE||'''' ||
                      ' WHERE '||V_WHERE_UPD;

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);      
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK - Modificado');
        ELSE
            --No existe registro en la tabla
            DBMS_OUTPUT.PUT_LINE('OK');
            DBMS_OUTPUT.put_line('[INFO] NO existe un registro en la tabla '||V_TABLE_INS||', con codigo '||V_COD_SEL||' = '''||V_TMP_TIPO_TFI(1)||'''');

          --INSERT DE REGISTROS
          -----------------------------------------------------------------------------------------------------------
          DBMS_OUTPUT.PUT('[INFO] Procediendo a insertar el registro...');
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLE_INS || 
                        '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                        'SELECT ' ||
                        'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE '||V_COD_SEL||' = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || 
                        ''',SYSDATE,0 FROM DUAL';
  
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('OK - Insertado');

        END IF;

    DBMS_OUTPUT.PUT_LINE('......................');

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('[INFO] Fin script insertar/actualizar');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] COMMIT');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[FIN] ROLLBACK');
          RAISE;          

END;

/

EXIT

/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite Saneamiento de Carga de Bienes Adj.
--## INSTRUCCIONES:  Verificar esquemas correctos en el Declare
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI_A IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI_A IS TABLE OF T_TIPO_TFI_A;
    V_TIPO_TFI_A T_ARRAY_TFI_A := T_ARRAY_TFI_A(
      T_TIPO_TFI_A('H010_ElevarPropuestaSareb',  '3',  'combo',  'comboTipoPropuesta', 'Tipo propuesta', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDTipoPropuestaSareb', '0',  'DD')
    ); 
    V_TMP_TIPO_TFI_A T_TIPO_TFI_A;


    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI_B IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI_B IS TABLE OF T_TIPO_TFI_B;
    V_TIPO_TFI_B T_ARRAY_TFI_B := T_ARRAY_TFI_B(
      T_TIPO_TFI_B('H012_InformarSarebAlegaciones',  '3',  'combo',  'comboTipoPropuesta', 'Tipo propuesta', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDTipoPropuestaSareb', '0',  'DD')
    ); 
    V_TMP_TIPO_TFI_B T_TIPO_TFI_B;

    
BEGIN	

    -- INSERT A: TRAMITE ELEVACION SAREB ADJUDICADOS-------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    V_TMP_TIPO_TFI_A := V_TIPO_TFI_A(1);
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE TFI_NOMBRE = '''|| V_TMP_TIPO_TFI_A(4) ||''' AND TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TMP_TIPO_TFI_A(1) ||''') ';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_TABLENAME);
    ELSE
        -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Insertando nuevo campo TFI de '|| V_TMP_TIPO_TFI_A(1) ||'');

        FOR I IN V_TIPO_TFI_A.FIRST .. V_TIPO_TFI_A.LAST
          LOOP
            V_TMP_TIPO_TFI_A := V_TIPO_TFI_A(I);
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                        '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                        'SELECT ' ||
                        'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI_A(1)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(5)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(7)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(9)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_A(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI_A(1) ||''','''||TRIM(V_TMP_TIPO_TFI_A(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
          END LOOP;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');
    END IF;



    -- INSERT B: TRAMITE ELEVACION SAREB LITIGIOS ---------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    V_TMP_TIPO_TFI_B := V_TIPO_TFI_B(1);
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE TFI_NOMBRE = '''|| V_TMP_TIPO_TFI_B(4) ||''' AND TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TMP_TIPO_TFI_B(1) ||''') ';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_TABLENAME);
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Insertando nuevo campo TFI de '|| V_TMP_TIPO_TFI_B(1) ||'');

        -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
        FOR I IN V_TIPO_TFI_B.FIRST .. V_TIPO_TFI_B.LAST
          LOOP
            V_TMP_TIPO_TFI_B := V_TIPO_TFI_B(I);
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                        '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                        'SELECT ' ||
                        'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI_B(1)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(5)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(7)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(9)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI_B(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI_B(1) ||''','''||TRIM(V_TMP_TIPO_TFI_B(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
          END LOOP;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

    END IF;


    -- UPDATES: TRAMITE ELEVACION SAREB LITIGIOS Y ADJUDICADOS---------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    -- Se reasigna el orden de los TFI de observaciones a la posición siguiente para dejar el hueco de los nuevos campos
    V_TMP_TIPO_TFI_A := V_TIPO_TFI_A(1);
    V_MSQL := 'update tfi_tareas_form_items set tfi_orden = 4 where tfi_nombre = ''observaciones'' and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo = '''|| V_TMP_TIPO_TFI_A(1) ||''')'; 
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Actualizando orden TFI observaciones de '|| V_TMP_TIPO_TFI_A(1) ||'');
    EXECUTE IMMEDIATE V_MSQL;

    V_TMP_TIPO_TFI_B := V_TIPO_TFI_B(1);
    V_MSQL := 'update tfi_tareas_form_items set tfi_orden = 4 where tfi_nombre = ''observaciones'' and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo = '''|| V_TMP_TIPO_TFI_B(1) ||''')'; 
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Actualizando orden TFI observaciones de '|| V_TMP_TIPO_TFI_B(1) ||'');
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
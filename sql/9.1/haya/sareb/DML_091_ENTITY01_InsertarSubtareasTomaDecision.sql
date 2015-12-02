--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20151009
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.11-hy-rc01
--## INCIDENCIA_LINK=HR-1451
--## PRODUCTO=NO
--##
--## Finalidad: Crear nuevos subtipos de tareas de precontencioso Haya para la toma de decision
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    VAR_CURR_TABLE VARCHAR2(50 CHAR);
    V_CAMPOCODIGO VARCHAR2(50 CHAR);
    V_NUMEROCAMPOCODIGO NUMBER(2);
    V_NUM_TABLAS NUMBER(16);
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);
    
     /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
  
    PAR_TABLENAME_SUBTTAREA VARCHAR2(50 CHAR) := 'DD_STA_SUBTIPO_TAREA_BASE';        -- [PARAMETRO] TABLA de Tipos de Subtipostareas
    PAR_TABLENAME_SUBTTAREACOD VARCHAR2(50 CHAR) := 'DD_STA_CODIGO';                 -- [PARAMETRO] Campo de código
    
     /*
    * ARRAY TABLA: DD_STA_SUBTIPO_TAREA_BASE
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_STB IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_STB IS TABLE OF T_TIPO_STB;
    V_TIPO_STB T_ARRAY_STB := T_ARRAY_STB(
        
        T_TIPO_STB(
        /*dd_sta_id..................:*/ V_ESQUEMA_M || '.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'PCO_DPREDOC',
        /*dd_sta_descripcion,........:*/ 'Toma de decisión del Gestor de Expedientes Judiciales',
        /*dd_sta_descripcion_larga...:*/ 'Toma de decisión del Gestor de Expedientes Judiciales',
        /*dd_tge_id..................:*/ 'PREDOC',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        )
        
    ); 
    V_TMP_TIPO_STB T_TIPO_STB;
    
BEGIN
    
    /*
    * LOOP ARRAY BLOCK-CODE: DD_STA_SUBTIPO_TAREA_BASE
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_SUBTTAREA;         -- Tabla actual
    V_CAMPOCODIGO := PAR_TABLENAME_SUBTTAREACOD;       -- Campo que tiene el código de la tabla
    V_NUMEROCAMPOCODIGO := 3;                        --Posición en el array del campo que contiene el código

    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||V_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_STB.FIRST .. V_TIPO_STB.LAST
      LOOP
        V_TMP_TIPO_STB := V_TIPO_STB(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada 
        DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CAMPOCODIGO||' = '''||V_TMP_TIPO_STB(V_NUMEROCAMPOCODIGO)||'''...');

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' WHERE '||V_CAMPOCODIGO||' = '''|| V_TMP_TIPO_STB(V_NUMEROCAMPOCODIGO) ||''' ';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);

       EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' ('
						||'DD_STA_ID,'
						||'DD_TAR_ID,'
						||'DD_STA_CODIGO,'
						||'DD_STA_DESCRIPCION,'
						||'DD_STA_DESCRIPCION_LARGA,'
						||'DD_TGE_ID,'
						||'DTYPE,'
						||'VERSION,'
						||'USUARIOCREAR,'
						||'FECHACREAR,'
						||'BORRADO'
						||') VALUES ('
						||REPLACE(TRIM(V_TMP_TIPO_STB(1)),'''''','''''''')||','
						||REPLACE(TRIM(V_TMP_TIPO_STB(2)),'''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(3)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(4)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(5)),'''','''''''')||''''||','
						||'(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_STB(6)),'''','''''''')||''''||'),'
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(7)),'''','''''''')||''''||','
						||REPLACE(TRIM(V_TMP_TIPO_STB(8)),'''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(9)),'''','''''''')||''''||','
						||REPLACE(TRIM(V_TMP_TIPO_STB(10)),'''','''''''')||','
						||REPLACE(TRIM(V_TMP_TIPO_STB(11)),'''','''''''')
						||')';

                VAR_CURR_ROWARRAY := I;
                DBMS_OUTPUT.PUT_LINE(V_MSQL);
                DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_STB(3) ||''','''||TRIM(V_TMP_TIPO_STB(6))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' Insert realizado correctamente.]');    
    

    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
 
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
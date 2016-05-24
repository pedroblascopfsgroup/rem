--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.3.13_rc01
--## INCIDENCIA_LINK=HR-596
--## PRODUCTO=NO
--##
--## Finalidad: Crear nuevos perfiles para Haya
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
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
     
    PAR_TABLENAME_TSUPER VARCHAR2(50 CHAR) := 'DD_SUP_SUPERVISORES';                 -- [PARAMETRO] TABLA de SUPERVISORES
    PAR_TABLENAME_TSUPERCOD VARCHAR2(50 CHAR) := 'DD_SUP_CODIGO';   
    
	 /*
    * ARRAY TABLA1: DD_SUP_SUPERVISORES
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_SUP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_SUP IS TABLE OF T_TIPO_SUP;
    V_TIPO_SUP T_ARRAY_SUP := T_ARRAY_SUP(
    
      T_TIPO_SUP(
        /*dd_sup_id..................:*/ V_ESQUEMA_M || '.S_DD_SUP_SUPERVISORES.NEXTVAL',
        /*dd_sup_codigo,.............:*/ 'SUPCO',
        /*dd_sup_descripcion,........:*/ 'Supervisor de Concursos',
        /*dd_sup_descripcion_larga,..:*/ 'Supervisor de Concursos',
        /*dd_tge_sup,................:*/ 'SUCO', 
        /*dd_tge_ges,................:*/ 'GUCO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        )
    );
    V_TMP_TIPO_SUP T_TIPO_SUP;
 
BEGIN
	
     /*
    * LOOP ARRAY BLOCK-CODE: DD_TGE_TIPO_GESTOR
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TSUPER;         -- Tabla actual
    V_CAMPOCODIGO := PAR_TABLENAME_TSUPERCOD;       -- Campo que tiene el código de la tabla
    V_NUMEROCAMPOCODIGO := 2;                        --Posición en el array del campo que contiene el código

    VAR_CURR_ROWARRAY := 0;
    
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||V_ESQUEMA_M||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_SUP.FIRST .. V_TIPO_SUP.LAST
      LOOP
        V_TMP_TIPO_SUP := V_TIPO_SUP(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada 
        DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CAMPOCODIGO||' = '''||V_TMP_TIPO_SUP(V_NUMEROCAMPOCODIGO)||'''...');

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' WHERE '||V_CAMPOCODIGO||' = '''|| V_TMP_TIPO_SUP(V_NUMEROCAMPOCODIGO) ||''' ';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);

       EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' ('
						||'DD_SUP_ID,'
						||'DD_SUP_CODIGO,'
						||'DD_SUP_DESCRIPCION,'
						||'DD_SUP_DESCRIPCION_LARGA,'
						||'DD_TGE_SUP,'
						||'DD_TGE_GES,'
						||'VERSION,'
						||'USUARIOCREAR,'
						||'FECHACREAR,'
						||'BORRADO'
						||') VALUES ('
						||REPLACE(TRIM(V_TMP_TIPO_SUP(1)),'''''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_SUP(2)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_SUP(3)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_SUP(4)),'''','''''''')||''''||','
						||'(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_SUP(5)),'''','''''''')||''''||'),'
						||'(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_SUP(6)),'''','''''''')||''''||'),'
						||REPLACE(TRIM(V_TMP_TIPO_SUP(7)),'''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_SUP(8)),'''','''''''')||''''||','
						||REPLACE(TRIM(V_TMP_TIPO_SUP(9)),'''','''''''')||','
						||REPLACE(TRIM(V_TMP_TIPO_SUP(10)),'''','''''''')
						||')';

                VAR_CURR_ROWARRAY := I;
                DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_SUP(1) ||''','''||TRIM(V_TMP_TIPO_SUP(2))||'''');
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
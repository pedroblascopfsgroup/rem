--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150804
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.3.4
--## INCIDENCIA_LINK=HR-998
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
     
    PAR_TABLENAME_TGESTOR VARCHAR2(50 CHAR) := 'DD_TGE_TIPO_GESTOR';                 -- [PARAMETRO] TABLA de Tipos de Gestor
    PAR_TABLENAME_TGESTORCOD VARCHAR2(50 CHAR) := 'DD_TGE_CODIGO';                   -- [PARAMETRO] Campo de código

    PAR_TABLENAME_TDESPACHO VARCHAR2(50 CHAR) := 'DD_TDE_TIPO_DESPACHO';             -- [PARAMETRO] TABLA de Tipos de Despacho
    PAR_TABLENAME_TDESPACHOCOD VARCHAR2(50 CHAR) := 'DD_TDE_CODIGO';                 -- [PARAMETRO] Campo de código

    PAR_TABLENAME_TGESTORPROP VARCHAR2(50 CHAR) := 'TGP_TIPO_GESTOR_PROPIEDAD';      -- [PARAMETRO] TABLA de Tipos de relación entre Despachos y Gestores

    PAR_TABLENAME_SUBTTAREA VARCHAR2(50 CHAR) := 'DD_STA_SUBTIPO_TAREA_BASE';        -- [PARAMETRO] TABLA de Tipos de Subtipostareas
    PAR_TABLENAME_SUBTTAREACOD VARCHAR2(50 CHAR) := 'DD_STA_CODIGO';                 -- [PARAMETRO] Campo de código
    
     /*
    * ARRAY TABLA1: DD_TGE_TIPO_GESTOR
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TGE IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TGE IS TABLE OF T_TIPO_TGE;
    V_TIPO_TGE T_ARRAY_TGE := T_ARRAY_TGE(
    
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ V_ESQUEMA_M || '.S_DD_TGE_TIPO_GESTOR.NEXTVAL',
        /*dd_tge_codigo,.............:*/ 'DSDE',
        /*dd_tge_descripcion,........:*/ 'Director Soporte Deuda',
        /*dd_tge_descripcion_larga,..:*/ 'Director Soporte Deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),  
        
        T_TIPO_TGE(
        /*dd_tge_id..................:*/ V_ESQUEMA_M || '.S_DD_TGE_TIPO_GESTOR.NEXTVAL',
        /*dd_tge_codigo,.............:*/ 'DADM',
        /*dd_tge_descripcion,........:*/ 'Director Admisión',
        /*dd_tge_descripcion_larga,..:*/ 'Director Admisión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),  
        
        T_TIPO_TGE(
        /*dd_tge_id..................:*/ V_ESQUEMA_M || '.S_DD_TGE_TIPO_GESTOR.NEXTVAL',
        /*dd_tge_codigo,.............:*/ 'DCON',
        /*dd_tge_descripcion,........:*/ 'Director Contabilidad',
        /*dd_tge_descripcion_larga,..:*/ 'Director Contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),  
        
        T_TIPO_TGE(
        /*dd_tge_id..................:*/ V_ESQUEMA_M || '.S_DD_TGE_TIPO_GESTOR.NEXTVAL',
        /*dd_tge_codigo,.............:*/ 'DDEU',
        /*dd_tge_descripcion,........:*/ 'Director Gestión Deuda',
        /*dd_tge_descripcion_larga,..:*/ 'Director Gestión Deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        )
    );
    V_TMP_TIPO_TGE T_TIPO_TGE;
    
    /*
    * ARRAY TABLA2: DD_TDE_TIPO_DESPACHO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TDE IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TDE IS TABLE OF T_TIPO_TDE;
    V_TIPO_TDE T_ARRAY_TDE := T_ARRAY_TDE(

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ V_ESQUEMA_M || '.S_DD_TDE_TIPO_DESPACHO.NEXTVAL',
        /*dd_tde_codigo,.............:*/ 'DDSDE',
        /*dd_tde_descripcion,........:*/ 'Despacho Director Soporte Deuda',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Director Soporte Deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),  
        
        T_TIPO_TDE(
        /*dd_tde_id..................:*/ V_ESQUEMA_M || '.S_DD_TDE_TIPO_DESPACHO.NEXTVAL',
        /*dd_tde_codigo,.............:*/ 'DDADM',
        /*dd_tde_descripcion,........:*/ 'Despacho Director Admisión',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Director Admisión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),   
        
        T_TIPO_TDE(
        /*dd_tde_id..................:*/ V_ESQUEMA_M || '.S_DD_TDE_TIPO_DESPACHO.NEXTVAL',
        /*dd_tde_codigo,.............:*/ 'DDCON',
        /*dd_tde_descripcion,........:*/ 'Despacho Director Contabilidad',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Director Contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),   
        
        T_TIPO_TDE(
        /*dd_tde_id..................:*/ V_ESQUEMA_M || '.S_DD_TDE_TIPO_DESPACHO.NEXTVAL',
        /*dd_tde_codigo,.............:*/ 'DDDEU',
        /*dd_tde_descripcion,........:*/ 'Despacho Director Gestión Deuda',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Director Gestión Deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        )
    ); 
    V_TMP_TIPO_TDE T_TIPO_TDE;
    
    /*
    * ARRAY TABLA3: TGP_TIPO_GESTOR_PROPIEDAD
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TGP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TGP IS TABLE OF T_TIPO_TGP;
    V_TIPO_TGP T_ARRAY_TGP := T_ARRAY_TGP(

      T_TIPO_TGP(
        /*tgp_id.....................:*/ V_ESQUEMA || '.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL',
        /*dd_tge_id..................:*/ 'DSDE',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DDSDE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),  
        
        T_TIPO_TGP(
        /*tgp_id.....................:*/ V_ESQUEMA || '.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL',
        /*dd_tge_id..................:*/ 'DADM',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DDADM',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),  
        
        T_TIPO_TGP(
        /*tgp_id.....................:*/ V_ESQUEMA || '.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL',
        /*dd_tge_id..................:*/ 'DCON',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DDCON',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),  
        
        T_TIPO_TGP(
        /*tgp_id.....................:*/ V_ESQUEMA || '.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL',
        /*dd_tge_id..................:*/ 'DDEU',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DDDEU',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        )
    ); 
    V_TMP_TIPO_TGP T_TIPO_TGP;
    
     /*
    * ARRAY TABLA4: DD_STA_SUBTIPO_TAREA_BASE
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_STB IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_STB IS TABLE OF T_TIPO_STB;
    V_TIPO_STB T_ARRAY_STB := T_ARRAY_STB(
    
      T_TIPO_STB(
        /*dd_sta_id..................:*/ V_ESQUEMA_M || '.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '826',
        /*dd_sta_descripcion,........:*/ 'Tarea del Director Soporte Deuda',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Director Soporte Deuda',
        /*dd_tge_id..................:*/ 'DSDE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
        
        T_TIPO_STB(
        /*dd_sta_id..................:*/ V_ESQUEMA_M || '.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '827',
        /*dd_sta_descripcion,........:*/ 'Tarea del Director Admisión',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Director Admisión',
        /*dd_tge_id..................:*/ 'DADM',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
        
        T_TIPO_STB(
        /*dd_sta_id..................:*/ V_ESQUEMA_M || '.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '829',
        /*dd_sta_descripcion,........:*/ 'Tarea del Director Contabilidad',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Director Contabilidad',
        /*dd_tge_id..................:*/ 'DCON',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
        
        T_TIPO_STB(
        /*dd_sta_id..................:*/ V_ESQUEMA_M || '.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '828',
        /*dd_sta_descripcion,........:*/ 'Tarea del Director Gestión Deuda',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Director Gestión Deuda',
        /*dd_tge_id..................:*/ 'DDEU',
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
    * LOOP ARRAY BLOCK-CODE: DD_TGE_TIPO_GESTOR
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TGESTOR;         -- Tabla actual
    V_CAMPOCODIGO := PAR_TABLENAME_TGESTORCOD;       -- Campo que tiene el código de la tabla
    V_NUMEROCAMPOCODIGO := 2;                        --Posición en el array del campo que contiene el código

    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||V_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_TGE.FIRST .. V_TIPO_TGE.LAST
      LOOP
        V_TMP_TIPO_TGE := V_TIPO_TGE(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada 
        DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CAMPOCODIGO||' = '''||V_TMP_TIPO_TGE(V_NUMEROCAMPOCODIGO)||'''...');

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' WHERE '||V_CAMPOCODIGO||' = '''|| V_TMP_TIPO_TGE(V_NUMEROCAMPOCODIGO) ||''' ';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);

       EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' ('
						||'DD_TGE_ID,'
						||'DD_TGE_CODIGO,'
						||'DD_TGE_DESCRIPCION,'
						||'DD_TGE_DESCRIPCION_LARGA,'
						||'VERSION,'
						||'USUARIOCREAR,'
						||'FECHACREAR,'
						||'BORRADO,'
						||'DD_TGE_EDITABLE_WEB'
						||') VALUES ('
						||REPLACE(TRIM(V_TMP_TIPO_TGE(1)),'''''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TGE(2)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TGE(3)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TGE(4)),'''','''''''')||''''||','
						||REPLACE(TRIM(V_TMP_TIPO_TGE(5)),'''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TGE(6)),'''','''''''')||''''||','
						||REPLACE(TRIM(V_TMP_TIPO_TGE(7)),'''','''''''')||','
						||REPLACE(TRIM(V_TMP_TIPO_TGE(8)),'''','''''''')
						||',0)';

                VAR_CURR_ROWARRAY := I;
                DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TGE(1) ||''','''||TRIM(V_TMP_TIPO_TGE(2))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' Insert realizado correctamente.]');

 	 /*
    * LOOP ARRAY BLOCK-CODE: DD_TDE_TIPO_DESPACHO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TDESPACHO;         -- Tabla actual
    V_CAMPOCODIGO := PAR_TABLENAME_TDESPACHOCOD;       -- Campo que tiene el código de la tabla
    V_NUMEROCAMPOCODIGO := 2;                        --Posición en el array del campo que contiene el código

    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||V_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_TDE.FIRST .. V_TIPO_TDE.LAST
      LOOP
        V_TMP_TIPO_TDE := V_TIPO_TDE(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada 
        DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CAMPOCODIGO||' = '''||V_TMP_TIPO_TDE(V_NUMEROCAMPOCODIGO)||'''...');

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' WHERE '||V_CAMPOCODIGO||' = '''|| V_TMP_TIPO_TDE(V_NUMEROCAMPOCODIGO) ||''' ';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);

       EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||VAR_CURR_TABLE||' ('
						||'DD_TDE_ID,'
						||'DD_TDE_CODIGO,'
						||'DD_TDE_DESCRIPCION,'
						||'DD_TDE_DESCRIPCION_LARGA,'
						||'VERSION,'
						||'USUARIOCREAR,'
						||'FECHACREAR,'
						||'BORRADO'
						||') VALUES ('
						||REPLACE(TRIM(V_TMP_TIPO_TDE(1)),'''''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TDE(2)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TDE(3)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TDE(4)),'''','''''''')||''''||','
						||REPLACE(TRIM(V_TMP_TIPO_TDE(5)),'''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_TDE(6)),'''','''''''')||''''||','
						||REPLACE(TRIM(V_TMP_TIPO_TDE(7)),'''','''''''')||','
						||REPLACE(TRIM(V_TMP_TIPO_TDE(8)),'''','''''''')
						||')';

                VAR_CURR_ROWARRAY := I;
                DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TGE(1) ||''','''||TRIM(V_TMP_TIPO_TGE(2))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' Insert realizado correctamente.]');
    
   
    
    /*
    * LOOP ARRAY BLOCK-CODE: TGP_TIPO_GESTOR_PROPIEDAD
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TGESTORPROP;         -- Tabla actual

    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||V_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_TGP.FIRST .. V_TIPO_TGP.LAST
      LOOP
        V_TMP_TIPO_TGP := V_TIPO_TGP(I);     
                        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_CURR_TABLE
			||' WHERE DD_TGE_ID=(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || REPLACE(TRIM(V_TMP_TIPO_TGP(2)),'''''','''''''') ||''')'
			||'       and TGP_VALOR='''|| REPLACE(TRIM(V_TMP_TIPO_TGP(4)),'''''','''''''') || '''';

        DBMS_OUTPUT.PUT_LINE(V_MSQL);

        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;        
        
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');        

        	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||VAR_CURR_TABLE||' ('
					||'TGP_ID,'
					||'DD_TGE_ID,'
					||'TGP_CLAVE,'
					||'TGP_VALOR,'
					||'VERSION,'
					||'USUARIOCREAR,'
					||'FECHACREAR,'
					||'BORRADO'
					||') VALUES ('
					||REPLACE(TRIM(V_TMP_TIPO_TGP(1)),'''''','''''''')||','
					||'(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TGP(2)),'''','''''''')||''''||'),'
					||''''||REPLACE(TRIM(V_TMP_TIPO_TGP(3)),'''','''''''')||''''||','
					||''''||REPLACE(TRIM(V_TMP_TIPO_TGP(4)),'''','''''''')||''''||','
					||REPLACE(TRIM(V_TMP_TIPO_TGP(5)),'''','''''''')||','
					||''''||REPLACE(TRIM(V_TMP_TIPO_TGP(6)),'''','''''''')||''''||','
					||REPLACE(TRIM(V_TMP_TIPO_TGP(7)),'''','''''''')||','
					||REPLACE(TRIM(V_TMP_TIPO_TGP(8)),'''','''''''')
					||')';

	        VAR_CURR_ROWARRAY := I;
	        DBMS_OUTPUT.PUT_LINE(V_MSQL);
	        --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TGE(1) ||''','''||TRIM(V_TMP_TIPO_TGE(2))||'''');
	        EXECUTE IMMEDIATE V_MSQL;
        END IF;        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' Insert realizado correctamente.]');    
    
    
    
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
                DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TGE(1) ||''','''||TRIM(V_TMP_TIPO_TGE(2))||'''');
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
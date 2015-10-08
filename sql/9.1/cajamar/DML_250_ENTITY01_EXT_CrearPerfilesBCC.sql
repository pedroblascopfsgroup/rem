--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hcj
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    /*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas

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
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Altas de Perfiles para BCC';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Gonzalo';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'gonzalo.estelles@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2034';                              -- [PARAMETRO] Teléfono del autor

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.


    VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones
    V_CAMPOCODIGO VARCHAR2(100 CHAR);                         -- Variable con la tabla actual
    V_NUMEROCAMPOCODIGO NUMBER(2);                         -- Variable con la tabla actual

    /*
    * ARRAY TABLA1: DD_TGE_TIPO_GESTOR
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TGE IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TGE IS TABLE OF T_TIPO_TGE;
    V_TIPO_TGE T_ARRAY_TGE := T_ARRAY_TGE(
    
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GESHREIN',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor concursal HRE insinuación',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor concursal HRE insinuación',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        )

      , T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GESEXHRE',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor externo HRE',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor externo HRE',
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
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GESHREIN',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor concursal HRE insinuación',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor concursal HRE insinuación',
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
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GESHREIN',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GESHREIN',
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
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGESHREIN',
        /*dd_sta_descripcion,........:*/ 'Tarea Gestor concursal HRE insinuación',
        /*dd_sta_descripcion_larga...:*/ 'Tarea Gestor concursal HRE insinuación',
        /*dd_tge_id..................:*/ 'GESHREIN',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        )

     ,T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGESEXHRE',
        /*dd_sta_descripcion,........:*/ 'Tarea Gestor externo HRE',
        /*dd_sta_descripcion_larga...:*/ 'Tarea Gestor externo HRE',
        /*dd_tge_id..................:*/ 'GESEXHRE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        )
        
	  ----------------------        
      -- **** TOMAS DE DECISION ****
	  ----------------------        

      ,T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'DGESHREIN',
        /*dd_sta_descripcion,........:*/ 'Toma decisión gestor concursal HRE insinuación',
        /*dd_sta_descripcion_larga...:*/ 'Toma decisión gestor concursal HRE insinuación',
        /*dd_tge_id..................:*/ 'GESHREIN',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
        T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'DGESCHRE',
        /*dd_sta_descripcion,........:*/ 'Toma decisión gestor control de gestión HRE',
        /*dd_sta_descripcion_larga...:*/ 'Toma decisión gestor control de gestión HRE',
        /*dd_tge_id..................:*/ 'GESCHRE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ) 
        
	  ----------------------        
      -- **** FIN TOMAS DE DECISION ***
	  ----------------------        

    ); 
    V_TMP_TIPO_STB T_TIPO_STB;

    
BEGIN	

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');


    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE set dd_sta_descripcion=''Tarea Gestor concursal HRE'', dd_sta_descripcion_larga=''Tarea Gestor concursal HRE'' where dd_sta_codigo=''TGESHRE'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el subtarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] subtarea ya renombrado.');    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE set dd_sta_descripcion=''Tarea Supervisor concursal HRE'', dd_sta_descripcion_larga=''Tarea Supervisor concursal HRE'' where dd_sta_codigo=''TSUHRE'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el subtarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] subtarea ya renombrado.');    

    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO set dd_tde_descripcion=''Despacho Gestor concursal HRE'', dd_tde_descripcion_larga=''Despacho Gestor concursal HRE'' where dd_tde_codigo=''D-GESHRE'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el despacho.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] despacho ya renombrado.');    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO set dd_tde_descripcion=''Despacho Supervisor concursal HRE'', dd_tde_descripcion_larga=''Despacho Supervisor concursal HRE'' where dd_tde_codigo=''D-SUHRE'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el despacho.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] despacho ya renombrado.');    
    
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.dd_tge_tipo_gestor set dd_tge_descripcion=''Gestor concursal HRE'', dd_tge_descripcion_larga=''Gestor concursal HRE'' where dd_tge_codigo=''GESHRE'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el gestor.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Gestor ya renombrado.');    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.dd_tge_tipo_gestor set dd_tge_descripcion=''Supervisor concursal HRE'', dd_tge_descripcion_larga=''Supervisor concursal HRE'' where dd_tge_codigo=''SUHRE'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el gestor.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Gestor ya renombrado.');    
	
    
	--Actualizamos el usuario "BANKMASTER" y lo renombramos como "HAYAMASTER"
/*	
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.usu_usuarios set usu_username=''HAYAMASTER'' where usu_username=''BANKMASTER'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el usuario BANKMASTER a HAYAMASTER.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario BANKMASTER ya renombrado a HAYAMASTER.');
*/
    /* YA NO HACEMOS ESTO, ASÍ HEMOS QUEDADO CON JORGE
    --Actualizamos el usuario "GESTOR" y lo renombramos como "LETRADO"
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.usu_usuarios set usu_username=''LETRADO'', usu_nombre=''LETRADO'' where usu_username=''GESTOR'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el usuario GESTOR a LETRADO.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario GESTOR ya renombrado a LETRADO.');    
    */
    
    
    
    /*
    * LOOP ARRAY BLOCK-CODE: DD_TGE_TIPO_GESTOR
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TGESTOR;         -- Tabla actual
    V_CAMPOCODIGO := PAR_TABLENAME_TGESTORCOD;       -- Campo que tiene el código de la tabla
    V_NUMEROCAMPOCODIGO := 2;                        --Posición en el array del campo que contiene el código

    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||PAR_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_TGE.FIRST .. V_TIPO_TGE.LAST
      LOOP
        V_TMP_TIPO_TGE := V_TIPO_TGE(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada 
        DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CAMPOCODIGO||' = '''||V_TMP_TIPO_TGE(V_NUMEROCAMPOCODIGO)||'''...');

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA_MASTER||'.'||VAR_CURR_TABLE||' WHERE '||V_CAMPOCODIGO||' = '''|| V_TMP_TIPO_TGE(V_NUMEROCAMPOCODIGO) ||''' ';
        DBMS_OUTPUT.PUT_LINE(V_SQL);

       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'insert into '||PAR_ESQUEMA_MASTER||'.'||VAR_CURR_TABLE||' ('
						||'dd_tge_id,'
						||'dd_tge_codigo,'
						||'dd_tge_descripcion,'
						||'dd_tge_descripcion_larga,'
						||'version,'
						||'usuariocrear,'
						||'fechacrear,'
						||'borrado,'
						||'dd_tge_editable_web'
						||') values ('
						||PAR_ESQUEMA_MASTER||'.'||REPLACE(TRIM(V_TMP_TIPO_TGE(1)),'''''','''''''')||','
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
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||PAR_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_TDE.FIRST .. V_TIPO_TDE.LAST
      LOOP
        V_TMP_TIPO_TDE := V_TIPO_TDE(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada 
        DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CAMPOCODIGO||' = '''||V_TMP_TIPO_TDE(V_NUMEROCAMPOCODIGO)||'''...');

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA_MASTER||'.'||VAR_CURR_TABLE||' WHERE '||V_CAMPOCODIGO||' = '''|| V_TMP_TIPO_TDE(V_NUMEROCAMPOCODIGO) ||''' ';
        DBMS_OUTPUT.PUT_LINE(V_SQL);

       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'insert into '||PAR_ESQUEMA_MASTER||'.'||VAR_CURR_TABLE||' ('
						||'dd_tde_id,'
						||'dd_tde_codigo,'
						||'dd_tde_descripcion,'
						||'dd_tde_descripcion_larga,'
						||'version,'
						||'usuariocrear,'
						||'fechacrear,'
						||'borrado'
						||') values ('
						||PAR_ESQUEMA_MASTER||'.'||REPLACE(TRIM(V_TMP_TIPO_TDE(1)),'''''','''''''')||','
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
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||PAR_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_TGP.FIRST .. V_TIPO_TGP.LAST
      LOOP
        V_TMP_TIPO_TGP := V_TIPO_TGP(I);     
                        
        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE
			||' WHERE DD_TGE_ID=(select dd_tge_id from '||PAR_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''' || REPLACE(TRIM(V_TMP_TIPO_TGP(2)),'''''','''''''') ||''')';
			--||'       and TGP_VALOR='''|| REPLACE(TRIM(V_TMP_TIPO_TGP(4)),'''''','''''''') || '''';

        DBMS_OUTPUT.PUT_LINE(V_SQL);

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;        
        
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');        

        	V_MSQL := 'insert into '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' ('
					||'tgp_id,'
					||'dd_tge_id,'
					||'tgp_clave,'
					||'tgp_valor,'
					||'version,'
					||'usuariocrear,'
					||'fechacrear,'
					||'borrado'
					||') values ('
					||PAR_ESQUEMA||'.'||REPLACE(TRIM(V_TMP_TIPO_TGP(1)),'''''','''''''')||','
					||'(select dd_tge_id from '||PAR_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo='''||REPLACE(TRIM(V_TMP_TIPO_TGP(2)),'''','''''''')||''''||'),'
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
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||PAR_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_STB.FIRST .. V_TIPO_STB.LAST
      LOOP
        V_TMP_TIPO_STB := V_TIPO_STB(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada 
        DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CAMPOCODIGO||' = '''||V_TMP_TIPO_STB(V_NUMEROCAMPOCODIGO)||'''...');

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA_MASTER||'.'||VAR_CURR_TABLE||' WHERE '||V_CAMPOCODIGO||' = '''|| V_TMP_TIPO_STB(V_NUMEROCAMPOCODIGO) ||''' ';
        DBMS_OUTPUT.PUT_LINE(V_SQL);

       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'insert into '||PAR_ESQUEMA_MASTER||'.'||VAR_CURR_TABLE||' ('
						||'dd_sta_id,'
						||'dd_tar_id,'
						||'dd_sta_codigo,'
						||'dd_sta_descripcion,'
						||'dd_sta_descripcion_larga,'
						||'dd_tge_id,'
						||'dtype,'
						||'version,'
						||'usuariocrear,'
						||'fechacrear,'
						||'borrado'
						||') values ('
						||PAR_ESQUEMA_MASTER||'.'||REPLACE(TRIM(V_TMP_TIPO_STB(1)),'''''','''''''')||','
						||REPLACE(TRIM(V_TMP_TIPO_STB(2)),'''','''''''')||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(3)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(4)),'''','''''''')||''''||','
						||''''||REPLACE(TRIM(V_TMP_TIPO_STB(5)),'''','''''''')||''''||','
						||'(select dd_tge_id from '||PAR_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo='''||REPLACE(TRIM(V_TMP_TIPO_STB(6)),'''','''''''')||''''||'),'
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
          DBMS_OUTPUT.PUT_LINE('[KO]');
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.PUT_LINE('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE('SQL que ha fallado:');
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.PUT_LINE('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.PUT_LINE('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;   
END;
/

EXIT;
/*
--######################################################################
--## Author: Roberto
--## Finalidad: Crear nuevos perfiles para Haya
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    /*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';    -- [PARAMETRO] Configuracion Esquemas

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
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Altas de Perfiles para Haya';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Roberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'roberto.lavalle@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2035';                              -- [PARAMETRO] Teléfono del autor

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
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'LETR',
        /*dd_tge_descripcion,........:*/ 'Letrado',
        /*dd_tge_descripcion_larga,..:*/ 'Letrado',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),  
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SUCL',
        /*dd_tge_descripcion,........:*/ 'Supervisor UCL',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor Unidad Concursos y Litigios',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),        
    
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GUCL',
        /*dd_tge_descripcion,........:*/ 'Gestor UCL',
        /*dd_tge_descripcion_larga,..:*/ 'Gestor Unidad Concursos y Litigios',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GSUB',
        /*dd_tge_descripcion,........:*/ 'Gestor subastas',
        /*dd_tge_descripcion_larga,..:*/ 'Gestor subastas',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SSUB',
        /*dd_tge_descripcion,........:*/ 'Supervisor subastas',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor subastas',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GDEU',
        /*dd_tge_descripcion,........:*/ 'Gestor deuda',
        /*dd_tge_descripcion_larga,..:*/ 'Gestor deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SDEU',
        /*dd_tge_descripcion,........:*/ 'Supervisor gestión deuda',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor gestión deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GSDE',
        /*dd_tge_descripcion,........:*/ 'Gestor soporte deuda',
        /*dd_tge_descripcion_larga,..:*/ 'Gestor soporte deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SSDE',
        /*dd_tge_descripcion,........:*/ 'Supervisor soporte deuda',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor soporte deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'UCON',
        /*dd_tge_descripcion,........:*/ 'Usuario contabilidad',
        /*dd_tge_descripcion_larga,..:*/ 'Usuario contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SCON',
        /*dd_tge_descripcion,........:*/ 'Supervisor contabilidad',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'UFIS',
        /*dd_tge_descripcion,........:*/ 'Usuario fiscal',
        /*dd_tge_descripcion_larga,..:*/ 'Usuario fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SFIS',
        /*dd_tge_descripcion,........:*/ 'Supervisor fiscal',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GAREO',
        /*dd_tge_descripcion,........:*/ 'Gestor admisión REO',
        /*dd_tge_descripcion_larga,..:*/ 'Gestor admisión REO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SAREO',
        /*dd_tge_descripcion,........:*/ 'Supervisor admisión REO',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor admisión REO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 'HAYAMASTER.s_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'DUCL',
        /*dd_tge_descripcion,........:*/ 'Director Unidad Concursos y Litigios',
        /*dd_tge_descripcion_larga,..:*/ 'Director Unidad Concursos y Litigios',
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
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DLETR',
        /*dd_tde_descripcion,........:*/ 'Despacho Letrado',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Letrado',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
    
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DSUCL',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor UCyL',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor Unidad Concursos y Litigios',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
    
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DGUCL',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor UCyL',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor Unidad Concursos y Litigios',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DGSUB',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor subastas',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor subastas',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DSSUB',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor subastas',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor subastas',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DGDEU',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor deuda',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DSDEU',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor gestión deuda',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor gestión deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DGSDE',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor soporte deuda',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor soporte deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DSSDE',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor soporte deuda',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor soporte deuda',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DUCON',
        /*dd_tde_descripcion,........:*/ 'Despacho Usuario contabilidad',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Usuario contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DSCON',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor contabilidad',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DUFIS',
        /*dd_tde_descripcion,........:*/ 'Despacho Usuario fiscal',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Usuario fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DSFIS',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor fiscal',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DGAREO',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor admisión REO',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor admisión REO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DSAREO',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor admisión REO',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor admisión REO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),
        
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 'HAYAMASTER.s_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'DDUCL',
        /*dd_tde_descripcion,........:*/ 'Despacho Director Unidad Concursos y Litigios',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Director Unidad Concursos y Litigios',
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
        /*dd_tge_id..................:*/ 'LETR',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DLETR',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
        
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SUCL',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DSUCL',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),        
    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GUCL',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DGUCL',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GSUB',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DGSUB',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SSUB',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DSSUB',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GDEU',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DGDEU',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SDEU',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DSDEU',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GSDE',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DGSDE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SSDE',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DSSDE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'UCON',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DUCON',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SCON',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DSCON',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'UFIS',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DUFIS',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SFIS',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DSFIS',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GAREO',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DGAREO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SAREO',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DSAREO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
        
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'DUCL',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'DDUCL',
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
        /*dd_sta_codigo,.............:*/ '814',
        /*dd_sta_descripcion,........:*/ 'Tarea del Letrado',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Letrado',
        /*dd_tge_id..................:*/ 'LETR',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
        
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '815',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor UCL',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor UCL',
        /*dd_tge_id..................:*/ 'SUCL',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),         
    
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '800',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor UCL',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor UCL',
        /*dd_tge_id..................:*/ 'GUCL',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '801',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor subastas',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor subastas',
        /*dd_tge_id..................:*/ 'GSUB',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '802',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor subastas',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor subastas',
        /*dd_tge_id..................:*/ 'SSUB',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '803',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor deuda',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor deuda',
        /*dd_tge_id..................:*/ 'GDEU',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '804',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor gestión deuda',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor gestión deuda',
        /*dd_tge_id..................:*/ 'SDEU',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '805',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor soporte deuda',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor soporte deuda',
        /*dd_tge_id..................:*/ 'GSDE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '806',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor soporte deuda',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor soporte deuda',
        /*dd_tge_id..................:*/ 'SSDE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '807',
        /*dd_sta_descripcion,........:*/ 'Tarea del Usuario contabilidad',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Usuario contabilidad',
        /*dd_tge_id..................:*/ 'UCON',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '808',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor contabilidad',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor contabilidad',
        /*dd_tge_id..................:*/ 'SCON',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '809',
        /*dd_sta_descripcion,........:*/ 'Tarea del Usuario fiscal',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Usuario fiscal',
        /*dd_tge_id..................:*/ 'UFIS',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '810',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor fiscal',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor fiscal',
        /*dd_tge_id..................:*/ 'SFIS',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '811',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor admisión REO',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor admisión REO',
        /*dd_tge_id..................:*/ 'GAREO',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),

      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '812',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor admisión REO',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor admisión REO',
        /*dd_tge_id..................:*/ 'SAREO',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
        
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ '813',
        /*dd_sta_descripcion,........:*/ 'Tarea del Director UCL',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Director UCL',
        /*dd_tge_id..................:*/ 'DUCL',
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
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');



    --Actualizamos el usuario "SUPERVISOR" y lo renombramos como "SUPER_UCL"
    /* YA NO HACEMOS ESTO, ASÍ HEMOS QUEDADO CON JORGE
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.usu_usuarios set usu_username=''SUPER_UCL'', usu_nombre=''SUPER_UCL'' where usu_username=''SUPERVISOR'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el usuario SUPERVISOR a SUPER_UCL.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario SUPERVISOR ya renombrado a SUPER_UCL.');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.dd_tge_tipo_gestor set dd_tge_descripcion=''Supervisor Unidad Concursos y Litigios'', dd_tge_descripcion_larga=''Supervisor Unidad Concursos y Litigios'' where dd_tge_codigo=''SUP'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el gestor Supervisor a Supervisor Unidad Concursos y Litigios.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Gestor Supervisor ya renombrado a Supervisor Unidad Concursos y Litigios.');    
	*/
    
	--Actualizamos el usuario "BANKMASTER" y lo renombramos como "HAYAMASTER"
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.usu_usuarios set usu_username=''HAYAMASTER'' where usu_username=''BANKMASTER'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando el usuario BANKMASTER a HAYAMASTER.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario BANKMASTER ya renombrado a HAYAMASTER.');

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
    DBMS_OUTPUT.PUT_LINE('    [INSERT] '||PAR_ESQUEMA||'.' || VAR_CURR_TABLE || '......');
    FOR I IN V_TIPO_TGP.FIRST .. V_TIPO_TGP.LAST
      LOOP
        V_TMP_TIPO_TGP := V_TIPO_TGP(I);     
                        
        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE
			||' WHERE DD_TGE_ID=(select dd_tge_id from '||PAR_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''' || REPLACE(TRIM(V_TMP_TIPO_TGP(2)),'''''','''''''') ||''')'
			||'       and TGP_VALOR='''|| REPLACE(TRIM(V_TMP_TIPO_TGP(4)),'''''','''''''') || '''';

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
					||REPLACE(TRIM(V_TMP_TIPO_TGP(1)),'''''','''''''')||','
					||'(select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='''||REPLACE(TRIM(V_TMP_TIPO_TGP(2)),'''','''''''')||''''||'),'
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
						||'(select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='''||REPLACE(TRIM(V_TMP_TIPO_STB(6)),'''','''''''')||''''||'),'
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
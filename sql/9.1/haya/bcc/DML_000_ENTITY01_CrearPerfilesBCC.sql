--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-383
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
        /*dd_tge_codigo,.............:*/ 'DRECU',
        /*dd_tge_descripcion,........:*/ 'CJ - Dirección recuperaciones',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Dirección recuperaciones',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),  
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-GAREO',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor admisión',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor admisión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),        
    
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GAEST',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor análisis estudio',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor análisis estudio',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GAFIS',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor Aseoría Fiscal',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor Aseoría Fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GAJUR',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor Asesoría jurídica',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor Asesoría jurídica',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GCON',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor contabilidad',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GCONGE',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor contencioso gestión',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor contencioso gestión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GCONPR',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor contencioso procesal',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor contencioso procesal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GCTRGE',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor control gestión HRE',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor control gestión HRE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'GGESDOC',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor de gestión documentario',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor de gestión documentario',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-GESTLLA',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor HRE gestión llaves',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor HRE gestión llaves',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-LETR',
        /*dd_tge_descripcion,........:*/ 'CJ - Letrado',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Letrado',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-SAREO',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor admisión',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor admisión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SAEST',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor análisis estudio',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor análisis estudio',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-SFIS',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor Asesoría Fiscal',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor Asesoría Fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SAJUR',
        /*dd_tge_descripcion,........:*/ 'Supervisor Asesoría jurídica',
        /*dd_tge_descripcion_larga,..:*/ 'Supervisor Asesoría jurídica',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-SCON',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor contabilidad',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SUCONT',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor contencioso',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor contencioso',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SUCONGE',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor contencioso gestión',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor contencioso gestión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SUCONPR',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor contencioso procesal',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor contencioso procesal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SCTRGE',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor control gestión HRE',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor control gestión HRE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SGESDOC',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor de gestión documentario',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor de gestión documentario',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
	
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SPGL',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor HRE gestión llaves',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor HRE gestión llaves',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),

      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-GESEXT',
        /*dd_tge_descripcion,........:*/ 'CJ - Gestor Externo',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Gestor Externo',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'CJ-SUEXT',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor Externo',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor Externo',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0',
        /*dd_tge_editable_web........:*/ '1'
        ),
        
      T_TIPO_TGE(
        /*dd_tge_id..................:*/ 's_dd_tge_tipo_gestor.nextval',
        /*dd_tge_codigo,.............:*/ 'SUCONGEN2',
        /*dd_tge_descripcion,........:*/ 'CJ - Supervisor contencioso gestión nivel 2',
        /*dd_tge_descripcion_larga,..:*/ 'CJ - Supervisor contencioso gestión nivel 2',
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
        /*dd_tde_codigo,.............:*/ 'D-DRECU',
        /*dd_tde_descripcion,........:*/ 'Despacho Dirección recuperaciones',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Dirección recuperaciones',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-GAREO',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor admisión',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor admisión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GAEST',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor análisis estudio',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor análisis estudio',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GAFIS',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor Aseoría Fiscal',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor Aseoría Fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GAJUR',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor Asesoría jurídica',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor Asesoría jurídica',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GCON',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor contabilidad',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GCONGE',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor contencioso gestión',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor contencioso gestión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GCONPR',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor contencioso procesal',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor contencioso procesal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GCTRGE',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor control gestión HRE',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor control gestión HRE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),    
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-GGESDOC',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor de gestión documentario',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor de gestión documentario',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-GESTLLA',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor HRE gestión llaves',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor HRE gestión llaves',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-LETR',
        /*dd_tde_descripcion,........:*/ 'Despacho Letrado',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Letrado',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-SAREO',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor admisión',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor admisión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SAEST',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor análisis estudio',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor análisis estudio',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-SFIS',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor Asesoría Fiscal',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor Asesoría Fiscal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SAJUR',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor Asesoría jurídica',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor Asesoría jurídica',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-SCON',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor contabilidad',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor contabilidad',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SUCONT',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor contencioso',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor contencioso',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SUCONGE',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor contencioso gestión',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor contencioso gestión',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SUCONPR',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor contencioso procesal',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor contencioso procesal',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SCTRGE',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor control gestión HRE',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor control gestión HRE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SGESDOC',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor de gestión documentario',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor de gestión documentario',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SPGL',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor HRE gestión llaves',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor HRE gestión llaves',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),

      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-GESEXT',
        /*dd_tde_descripcion,........:*/ 'Despacho Gestor Externo',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Gestor Externo',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-CJ-SUEXT',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor Externo',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor Externo',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0'
        ),	
	
      T_TIPO_TDE(
        /*dd_tde_id..................:*/ 's_dd_tde_tipo_despacho.nextval',
        /*dd_tde_codigo,.............:*/ 'D-SUCONGEN2',
        /*dd_tde_descripcion,........:*/ 'Despacho Supervisor contencioso gestión nivel 2',
        /*dd_tde_descripcion_larga,..:*/ 'Despacho Supervisor contencioso gestión nivel 2',
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
        /*dd_tge_id..................:*/ 'DRECU',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-DRECU',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-GAREO',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-GAREO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GAEST',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GAEST',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GAFIS',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GAFIS',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GAJUR',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GAJUR',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GCON',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GCON',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GCONGE',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GCONGE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GCONPR',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GCONPR',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GCTRGE',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GCTRGE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'GGESDOC',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-GGESDOC',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-GESTLLA',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-GESTLLA',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-LETR',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-LETR',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-SAREO',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-SAREO',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SAEST',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SAEST',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-SFIS',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-SFIS',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SAJUR',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SAJUR',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-SCON',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-SCON',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SUCONT',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SUCONT',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SUCONGE',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SUCONGE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SUCONPR',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SUCONPR',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SCTRGE',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SCTRGE',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SGESDOC',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SGESDOC',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),    
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'SPGL',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-SPGL',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-GESEXT',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-GESEXT',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_TGP(
        /*tgp_id.....................:*/ 's_tgp_tipo_gestor_propiedad.nextval',
        /*dd_tge_id..................:*/ 'CJ-SUEXT',
        /*tgp_clave,.................:*/ 'DES_VALIDOS',
        /*tgp_valor,.................:*/ 'D-CJ-SUEXT',
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
        /*dd_sta_codigo,.............:*/ 'TDRECU',
        /*dd_sta_descripcion,........:*/ 'Tarea de Dirección recuperaciones',
        /*dd_sta_descripcion_larga...:*/ 'Tarea de Dirección recuperaciones',
        /*dd_tge_id..................:*/ 'DRECU',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-811',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor admisión REO',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor admisión REO',
        /*dd_tge_id..................:*/ 'CJ-GAREO',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGAEST',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor análisis estudio',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor análisis estudio',
        /*dd_tge_id..................:*/ 'GAEST',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGAFIS',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor Aseoría Fiscal',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor Aseoría Fiscal',
        /*dd_tge_id..................:*/ 'GAFIS',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGAJUR',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor Asesoría jurídica',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor Asesoría jurídica',
        /*dd_tge_id..................:*/ 'GAJUR',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGCON',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor contabilidad',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor contabilidad',
        /*dd_tge_id..................:*/ 'GCON',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
        T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGCONGE',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor contencioso gestión',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor contencioso gestión',
        /*dd_tge_id..................:*/ 'GCONGE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGCONPR',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor contencioso procesal',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor contencioso procesal',
        /*dd_tge_id..................:*/ 'GCONPR',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGCTRGE',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor control gestión HRE',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor control gestión HRE',
        /*dd_tge_id..................:*/ 'GCTRGE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TGGESDOC',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor de gestión documentario',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor de gestión documentario',
        /*dd_tge_id..................:*/ 'GGESDOC',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-104',
        /*dd_sta_descripcion,........:*/ 'Tarea gestion de llaves',
        /*dd_sta_descripcion_larga...:*/ 'Tarea gestion de llaves',
        /*dd_tge_id..................:*/ 'CJ-GESTLLA',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-814',
        /*dd_sta_descripcion,........:*/ 'Tarea del Letrado',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Letrado',
        /*dd_tge_id..................:*/ 'CJ-LETR',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-812',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor admisión REO',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor admisión REO',
        /*dd_tge_id..................:*/ 'CJ-SAREO',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSAEST',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor análisis estudio',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor análisis estudio',
        /*dd_tge_id..................:*/ 'SAEST',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-810',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor fiscal',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor fiscal',
        /*dd_tge_id..................:*/ 'CJ-SFIS',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSAJUR',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor Asesoría jurídica',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor Asesoría jurídica',
        /*dd_tge_id..................:*/ 'SAJUR',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-808',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor contabilidad',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor contabilidad',
        /*dd_tge_id..................:*/ 'CJ-SCON',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSUCONT',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor contencioso',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor contencioso',
        /*dd_tge_id..................:*/ 'SUCONT',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSUCONGE',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor contencioso gestión',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor contencioso gestión',
        /*dd_tge_id..................:*/ 'SUCONGE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSUCONPR',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor contencioso procesal',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor contencioso procesal',
        /*dd_tge_id..................:*/ 'SUCONPR',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSCTRGE',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor control gestión HRE',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor control gestión HRE',
        /*dd_tge_id..................:*/ 'SCTRGE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSGESDOC',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor de gestión documentario',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor de gestión documentario',
        /*dd_tge_id..................:*/ 'SGESDOC',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSPGL',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor HRE gestión llaves',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor HRE gestión llaves',
        /*dd_tge_id..................:*/ 'SPGL',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-TGESEXT',
        /*dd_sta_descripcion,........:*/ 'Tarea del Gestor Externo',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Gestor Externo',
        /*dd_tge_id..................:*/ 'CJ-GESEXT',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-TSUEXT',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor Externo',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor Externo',
        /*dd_tge_id..................:*/ 'CJ-SUEXT',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),   
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'TSUCONGEN2',
        /*dd_sta_descripcion,........:*/ 'Tarea del Supervisor contencioso gestión nivel 2',
        /*dd_sta_descripcion_larga...:*/ 'Tarea del Supervisor contencioso gestión nivel 2',
        /*dd_tge_id..................:*/ 'SUCONGEN2',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
        
        
	  ----------------------        
      -- **** TOMAS DE DECISION ****
	  ----------------------        
      
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'DGCONGE',
        /*dd_sta_descripcion,........:*/ 'Toma decisión gestor contencioso gestión',
        /*dd_sta_descripcion_larga...:*/ 'Toma decisión gestor contencioso gestión',
        /*dd_tge_id..................:*/ 'GCONGE',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'DGCONPR',
        /*dd_sta_descripcion,........:*/ 'Toma decisión gestor contencioso procesal',
        /*dd_sta_descripcion_larga...:*/ 'Toma decisión gestor contencioso procesal',
        /*dd_tge_id..................:*/ 'GCONPR',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-DECGLL',
        /*dd_sta_descripcion,........:*/ 'Toma de decision gestor llaves',
        /*dd_sta_descripcion_larga...:*/ 'Toma de decision gestor llaves',
        /*dd_tge_id..................:*/ 'CJ-GESTLLA',
        /*dtype......................:*/ 'EXTSubtipoTarea',
        /*version,...................:*/ '0',
        /*usuariocrear,..............:*/ 'DD',
        /*fechacrear,................:*/ 'sysdate',
        /*borrado,...................:*/ '0' 
        ),
      T_TIPO_STB(
        /*dd_sta_id..................:*/ 's_dd_sta_subtipo_tarea_base.nextval',
        /*dd_tar_id..................:*/ '1',
        /*dd_sta_codigo,.............:*/ 'CJ-819',
        /*dd_sta_descripcion,........:*/ 'Toma de decisión del Letrado',
        /*dd_sta_descripcion_larga...:*/ 'Toma de decisión del Letrado',
        /*dd_tge_id..................:*/ 'CJ-LETR',
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
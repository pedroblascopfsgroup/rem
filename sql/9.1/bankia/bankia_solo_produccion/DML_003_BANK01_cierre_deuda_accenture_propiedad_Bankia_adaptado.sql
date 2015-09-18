--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20150914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.15-bk
--## INCIDENCIA_LINK=no_tiene
--## PRODUCTO=NO
--## Finalidad: DML
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


--Script perteneciente a NO_PROTOCOLO adaptado para el resto de entornos BANKIA
DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESTCDD''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE  
        -- crear nuevo tipo de gestor 

        V_SQL := 'insert into '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge (tge.DD_TGE_ID, tge.DD_TGE_CODIGO, tge.DD_TGE_DESCRIPCION, tge.DD_TGE_DESCRIPCION_LARGA, tge.DD_TGE_EDITABLE_WEB, tge.FECHACREAR, tge.USUARIOCREAR)
        values ('||V_ESQUEMA_M||'.s_DD_TGE_TIPO_GESTOR.nextval, ''GESTCDD'', ''Gestor cierre de deuda'', ''Gestor cierre de deuda'', 1, sysdate, ''SAG'')';
         EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD WHERE DD_TGE_ID = (select dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''GESTCDD'') AND TGP_VALOR= ''GESTESP''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE  
        V_SQL := 'insert into '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
        values 
        ('||V_ESQUEMA||'.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''GESTCDD''),
         ''DES_VALIDOS'', ''GESTESP'',
        ''SAG'', sysdate)';
        EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
 END IF;
 
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base WHERE DD_STA_CODIGO = ''120'' AND DD_TGE_ID =  (select dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge where tge.dd_tge_codigo = ''GESTCDD'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'insert into '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base
          (dd_sta_id, dd_tar_id, dd_sta_codigo, dd_sta_descripcion, dd_sta_descripcion_larga, fechacrear, usuariocrear, dd_tge_id)
        values
          ('||V_ESQUEMA_M||'.s_dd_sta_subtipo_tarea_base.nextval, 1, ''120'', ''Tarea gestor cierre de deuda'', ''Tarea gestor cierre de deuda'', sysdate, ''SAG'', 
           (select dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge where tge.dd_tge_codigo = ''GESTCDD''))';
           EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
   END IF;
   
   
    V_SQL := 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set 
    dd_tsup_id = null,
    dd_sta_id = (select dd_sta_id from '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base where dd_sta_codigo = ''120'')
    where tap_codigo in (''P401_ContabilizarCierreDeuda'',''P413_ContabilizarCierreDeuda'')';
    EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha actualizado el registro');
-- actualizar las tareas ya creadas

    V_SQL := 'update '||V_ESQUEMA||'.tar_tareas_notificaciones tar set tar.dd_sta_id = (select dd_sta_id from '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base where dd_sta_codigo = ''120'')
    where tar.tar_id in (
      select tar.tar_id
      from '||V_ESQUEMA||'.tar_tareas_notificaciones tar inner join
           '||V_ESQUEMA||'.tex_tarea_externa tex on tex.tar_id = tar.tar_id inner join
           '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tap.tap_id = tex.tap_id
      where tap.tap_codigo in (''P401_ContabilizarCierreDeuda'',''P413_ContabilizarCierreDeuda''))';    
    EXECUTE IMMEDIATE V_SQL ; 
    DBMS_OUTPUT.put_line('[INFO] Se ha actualizado el registro');

-- insertar nueva carterización

-- BANKIA

    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''BPO1 ACCENTURE''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....1'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'Insert into '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO (DES_ID,DES_DESPACHO,DES_TIPO_VIA,DES_DOMICILIO,DES_DOMICILIO_PLAZA,DES_CODIGO_POSTAL,DES_PERSONA_CONTACTO,DES_TELEFONO2,DES_TELEFONO1,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,ZON_ID,DD_TDE_ID,DES_CODIGO) values ('||V_ESQUEMA||'.S_DES_DESPACHO_EXTERNO.NEXTVAL,''BPO1 ACCENTURE'',null,null,null,null,null,null,null,0,''SAG'',SYSDATE,null,null,null,null,0,12501,1,null)';
        EXECUTE IMMEDIATE V_SQL ; 
    END IF;

    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''HAYA GESTOR ESPECIALIZADO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....2'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'Insert into '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO (DES_ID,DES_DESPACHO,DES_TIPO_VIA,DES_DOMICILIO,DES_DOMICILIO_PLAZA,DES_CODIGO_POSTAL,DES_PERSONA_CONTACTO,DES_TELEFONO2,DES_TELEFONO1,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,ZON_ID,DD_TDE_ID,DES_CODIGO) values ('||V_ESQUEMA||'.S_DES_DESPACHO_EXTERNO.NEXTVAL,''HAYA GESTOR ESPECIALIZADO'',null,null,null,null,null,null,null,0,''SAG'',SYSDATE,null,null,null,null,0,12501,1,null)';
        EXECUTE IMMEDIATE V_SQL ; 
    END IF;



    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE usu_username = ''BPO1ACCEN''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....3'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'Insert into '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP) 
        values ('||V_ESQUEMA_M||'.s_usu_usuarios.nextval,1,''BPO1ACCEN'',''1234'',''GRUPO - BPO1 ACCETURE'',null,null,null,null,0,''SAG'',sysdate,1,null,1)';
        EXECUTE IMMEDIATE V_SQL ; 
    END IF;

V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS WHERE usu_id = (select usu_id from '||V_ESQUEMA_M||'.USU_USUARIOS WHERE usu_username = ''BPO1ACCEN'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....4'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'Insert into '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS (USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,30807,(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''HAYA GESTOR ESPECIALIZADO''),1,0,0,''SAG'',SYSDATE,null,null,null,null,0)';
        EXECUTE IMMEDIATE V_SQL ; 
    END IF;


    
    
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO WHERE usd_id = (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'' AND USD.BORRADO=0) and 
            dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....5'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
        select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
               (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'' AND USD.BORRADO=0) usd_id,
               (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''), ''SAG'', sysdate
        from 
         (
          select asu.asu_id
          from '||V_ESQUEMA||'.asu_asuntos asu where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                                (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''))
          and asu_id in (select asuu.asu_id
                            from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                                 '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                                 '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                            where pas.dd_pas_codigo = ''BANKIA'')                    
          ) aux ';
          DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro '||V_SQL);
          
           EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
   END IF;
  
 V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO WHERE GAH_GESTOR_ID = (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'' AND USD.BORRADO=0) and 
            GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....6'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
        select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'' AND USD.BORRADO=0) usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''), ''SAG'', sysdate
        from 
         (select asu_id
          from '||V_ESQUEMA||'.asu_asuntos asu where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
                                (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''))
          and asu.asu_id in (select asuu.asu_id
                            from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                                 '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                                 '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                            where pas.dd_pas_codigo = ''BANKIA'')
         ) aux';
           EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
   END IF;
   
   
-- HAYA

       V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE usu_username = ''HAYAGESP''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....7'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'Insert into '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO) 
        values ('||V_ESQUEMA_M||'.s_usu_usuarios.nextval,1,''HAYAGESP'',''1234'',''GRUPO - HAYA GESTOR ESPECIALIZADO'',null,null,null,null,0,''SAG'',sysdate,1,1)';
        EXECUTE IMMEDIATE V_SQL ; 
    END IF;

V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS WHERE usu_id = (select usu_id from '||V_ESQUEMA_M||'.USU_USUARIOS WHERE usu_username = ''HAYAGESP'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....8'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'Insert into '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS (USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''HAYAGESP''),(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''HAYA GESTOR ESPECIALIZADO''),1,0,0,''SAG'',SYSDATE,null,null,null,null,0)';
        EXECUTE IMMEDIATE V_SQL ; 
         DBMS_OUTPUT.put_line('[INFO] INSERTADO' ||V_SQL);
         COMMIT;
    END IF;


   
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO WHERE usd_id = (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYAGESP'') and 
            dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....9'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
        select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
               (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYAGESP'') usd_id,
               (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''), ''SAG'', sysdate
        from 
         (
          select asu.asu_id
          from '||V_ESQUEMA||'.asu_asuntos asu where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                                (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''))
          and asu_id in (select asuu.asu_id
                            from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                                 '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                                 '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                            where pas.dd_pas_codigo = ''SAREB'')                    
          ) aux ';
     EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
   END IF;
   
   
   
 V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO WHERE GAH_GESTOR_ID = (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYAGESP'') and 
            GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
            select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
                   (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYAGESP'') usd_id,
                   sysdate, (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''), ''SAG'', sysdate
            from 
             (select asu_id
              from '||V_ESQUEMA||'.asu_asuntos asu where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
                                    (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTCDD''))
              and asu.asu_id in (select asuu.asu_id
                                from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                                     '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                                     '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                                where  pas.dd_pas_codigo = ''SAREB'')  
             ) aux ';
 
     EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
   END IF;
   
   
   
V_SQL := 'update  '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base set dd_sta_codigo = ''600'' where dd_sta_codigo = ''6001''';    
   -- EXECUTE IMMEDIATE V_SQL ; 
    DBMS_OUTPUT.put_line('[INFO] Se ha actualizado el registro');

V_SQL := 'update  '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base set dd_sta_codigo = ''601'' where dd_sta_codigo = ''6011''';    
   -- EXECUTE IMMEDIATE V_SQL ; 
    DBMS_OUTPUT.put_line('[INFO] Se ha actualizado el registro');

V_SQL := 'update  '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base set dd_sta_codigo = ''600'' where dd_sta_codigo = ''120''';    
   -- EXECUTE IMMEDIATE V_SQL ; 
    DBMS_OUTPUT.put_line('[INFO] Se ha actualizado el registro');

V_SQL := 'update  '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base set dd_sta_codigo = ''601'' where dd_sta_codigo = ''110''';    
    --EXECUTE IMMEDIATE V_SQL ; 
    DBMS_OUTPUT.put_line('[INFO] Se ha actualizado el registro');
    
    
--commit;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
    

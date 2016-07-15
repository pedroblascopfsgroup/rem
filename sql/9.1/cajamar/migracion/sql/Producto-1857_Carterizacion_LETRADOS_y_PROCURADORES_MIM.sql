--/*
--##########################################
--## AUTOR=JAIME SANCHEZ-CUENCA
--## FECHA_CREACION=20151223
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=PRODUCTO-1857
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de datos (usuarios procuradores y letrados, y usuarios_despachos procuradores y letrados).
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        v_procurador CM01.MIG_PROCEDIMS_CABECERA_MIM.CD_PROCURADOR%TYPE;
        v_usuario_id CMMASTER.USU_USUARIOS.USU_ID%TYPE;
        v_letrado    CM01.MIG_PROCEDIMS_ACTORES_MIM.CD_ACTOR%TYPE;

        V_MSQL  VARCHAR2(2500);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        V_USUARIO VARCHAR2(25 CHAR):= 'RECOV-1557';        

        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;
        v_gaa_id CM01.gaa_gestor_adicional_asunto.gaa_id%TYPE;
        v_usuariocrear CM01.gaa_gestor_adicional_asunto.usuariocrear%TYPE;
        v_usuariomodificar CM01.gaa_gestor_adicional_asunto.usuariomodificar%TYPE;
        v_des_codigo CM01.des_despacho_externo.des_codigo%TYPE;
        v_dd_tge_id cmmaster.dd_tge_tipo_gestor.dd_tge_id%TYPE;
		v_n_insert_proc      NUMBER;
		v_n_insert_letr      NUMBER;
		v_n_update_proc      NUMBER;
		v_n_update_letr      NUMBER;


BEGIN


/**************************************************************************************************/
/**********************************    PROCURADORES                    ****************************/
/**************************************************************************************************/

-- COMPROBAMOS SI EXISTE EL DESPACHO PROCURADOR:

--     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''Despacho Procuradores''' INTO V_COUNT;
--
--    IF V_COUNT = 0 THEN
--        
--       EXECUTE IMMEDIATE' 
--       INSERT INTO '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO(DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, ZON_ID, DD_TDE_ID)
--       VALUES ('||V_ESQUEMA||'.S_DES_DESPACHO_EXTERNO.NEXTVAL,
--              ''Despacho Procuradores'',
--              0,
--              '''||V_USUARIO||''',
--              SYSDATE,
--              0,
--              (SELECT MIN(ZON_ID) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''BANCO DE CREDITO SOCIAL COOPERATIVO SA''),
--              (SELECT DD_TDE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_DESCRIPCION = ''Despacho Procurador'')
--          )';
--
--        DBMS_OUTPUT.PUT_LINE('Despacho Procurador INSERTADO');
--   
--   END IF;
--
--  COMMIT;

-- Insertamos los procuradores

FOR v_procurador IN (SELECT DISTINCT CD_PROCURADOR FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) LOOP

  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.usu_usuarios (
            usu_id
          , entidad_id
          , usu_username
          , usu_password
          , usu_nombre
          , usu_apellido1
          , usu_apellido2
          , usu_mail
          , usuariocrear
          , fechacrear
          , usu_externo
          , usu_grupo)  
   values  ( 
             '||V_ESQUEMA_MASTER||'.s_usu_usuarios.nextval
            , (select ID from '||V_ESQUEMA_MASTER||'.ENTIDAD where DESCRIPCION = ''CAJAMAR'')
            , '''||v_procurador.CD_PROCURADOR||'''
            , ''1234''
            , (select DES_DESPACHO from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO where DES_CODIGO = '''||v_procurador.CD_PROCURADOR||''')
            , ''''
            , ''''
            , '''' 
            , '''||V_USUARIO||'''
            , sysdate
            , 1
            , 0
          )';

  SELECT COUNT(*)
  INTO V_EXISTE
  FROM CMMASTER.USU_USUARIOS
  WHERE USU_USERNAME = ''||v_procurador.CD_PROCURADOR;
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el USUARIO procurador '||v_procurador.CD_PROCURADOR||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El USUARIO procurador '||v_procurador.CD_PROCURADOR||' YA EXISTE!');
  END IF;
          
END LOOP;



-- Insertamos la relación de usuarios despachos para procuradores USD_USUARIOS_DESPACHOS , .DES_DESPACHO_EXTERNO      
FOR v_usuario_id IN (SELECT USU_ID, USU_USERNAME 
                       FROM CMMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_PROCURADOR FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) procs
                            WHERE USU.USU_USERNAME = PROCS.CD_PROCURADOR
                    ) 
                 LOOP

  V_MSQL:= 'insert into '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  
               (
                usd_id
              , usu_id
              , des_id
              , usd_gestor_defecto
              , usd_supervisor
              , usuariocrear
              , fechacrear
              )
        values (
                '||V_ESQUEMA||'.s_usd_usuarios_despachos.nextval
              , '||v_usuario_id.USU_ID||'
              , (select des.des_id from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = '''||v_usuario_id.USU_USERNAME||''')
              , 0
              , 0 
              , '''||V_USUARIO||'''
              , sysdate 
               )';
    
  SELECT COUNT(*) INTO V_EXISTE
  FROM CM01.USD_USUARIOS_DESPACHOS
  WHERE USU_ID = v_usuario_id.USU_ID
    AND DES_ID = (select des.des_id from CM01.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = v_usuario_id.USU_USERNAME);
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el usuario procurador '||v_usuario_id.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario procurador '||v_usuario_id.USU_ID||' YA EXISTE!');
  END IF;
          
END LOOP;


-- zonificar usuarios procuradores

FOR v_procurador IN (SELECT USU_ID, USU_USERNAME 
                       FROM CMMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_PROCURADOR FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) procs
                            WHERE USU.USU_USERNAME = PROCS.CD_PROCURADOR
                     ) 
                 LOOP

  V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.zon_pef_usu zpu
               ( zpu.zpu_id
               , zpu.zon_id
               , zpu.pef_id
               , zpu.usu_id
               , zpu.usuariocrear
               , zpu.fechacrear
               )
                 VALUES('||V_ESQUEMA||'.s_zon_pef_usu.nextval
                , (select max(zon_id) from cm01.zon_zonificacion where zon_cod = ''01'')
                , (select pef_id from cm01.pef_perfiles where pef_codigo = ''GEST_EXTERNO'')
                , (select usu_id from cmmaster.usu_usuarios where usu_username = '''||v_procurador.USU_USERNAME||''')
                , '''||V_USUARIO||'''
                , sysdate)';
            
   SELECT COUNT(*) INTO V_EXISTE
  FROM CM01.ZON_PEF_USU
  WHERE ZON_ID = (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01')
    AND PEF_ID = (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO')
    AND USU_ID = (select usu_id from cmmaster.usu_usuarios where usu_username = v_procurador.USU_USERNAME);
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando zonificación para el usuario procurador '||v_procurador.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El el usuario procurador '||v_procurador.USU_ID||' YA ESTA ZONIFICADO!');
  END IF;
          
END LOOP;           


    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USU_USUARIOS Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USD_USUARIOS_DESPACHOS Analizada');


   -- Procuradores procedimientos  
    ------------------------------ ++
    select dd_tge_id into v_dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'PROC';
	
    v_n_insert_proc :=0;
    v_n_update_proc :=0;
	
FOR v_procurador IN (
   SELECT DISTINCT CD_PROCURADOR, mig.numero_exp_nuse, asu.asu_id, d.usd_id
          FROM cm01.MIG_PROCEDIMS_CABECERA_MIM mig, cm01.exp_expedientes exp, cm01.asu_asuntos asu,
           (select usd.usd_id, des.des_codigo
              FROM cm01.des_despacho_externo des 
                   inner join cm01.usd_usuarios_despachos usd on usd.des_id = des.des_id AND usd.borrado = 0
                   inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 AND usu.borrado = 0 and usu_username = des.des_codigo
            ) d 
      WHERE mig.cd_expediente_nuse = exp.cd_expediente_nuse
        AND exp.exp_id = asu.exp_id
        AND exp.borrado = 0
        AND asu.borrado = 0
        and mig.CD_PROCURADOR = d.des_codigo) LOOP
   begin
      select gaa.gaa_id, gaa.usuariocrear, gaa.usuariomodificar into v_gaa_id, v_usuariocrear, v_usuariomodificar
        from CM01.gaa_gestor_adicional_asunto gaa
       where gaa.asu_id = v_procurador.asu_id
         and gaa.usd_id = v_procurador.usd_id
         and gaa.dd_tge_id = v_dd_tge_id
	     and gaa.borrado = 0;
   exception
      when others then
         v_gaa_id := 0;
   end;
     -- Si no tiene procurador
     if v_gaa_id = 0 
     then
        -- ACTIVO
        insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
        values (cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval,
                v_procurador.asu_id,
                v_procurador.usd_id,
                v_dd_tge_id,
                V_USUARIO,
                TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
        );
		v_n_insert_proc := v_n_insert_proc +1;
        -- HISTORICO
        insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
        values (cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval,
                v_procurador.asu_id,
                v_procurador.usd_id,
                TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF'),
                v_dd_tge_id,
                V_USUARIO,
                TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
        );
     else 
        -- Tiene procurador
        if v_usuariocrear = 'MIGRACM01' and v_usuariomodificar IS null then
           -- es de la migracion y no se ha modificado
           UPDATE cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa
              SET asu_id = (select usd.usd_id
                                  FROM cm01.des_despacho_externo des 
                                 inner join cm01.usd_usuarios_despachos usd on usd.des_id = des.des_id 
                                 inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = des.des_codigo
                                 WHERE des.des_codigo = v_procurador.CD_PROCURADOR),
                  usuariomodificar = V_USUARIO, 
                  fechamodificar = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
            where gaa.gaa_id = v_gaa_id
              and gaa.usd_id = v_procurador.usd_id;
           v_n_update_proc := v_n_update_proc + 1;
           UPDATE cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah
              SET gah_asu_id = (select usd.usd_id
                            FROM cm01.des_despacho_externo des 
                                 inner join cm01.usd_usuarios_despachos usd on usd.des_id = des.des_id 
                                 inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = des.des_codigo
                                 WHERE des.des_codigo = v_procurador.CD_PROCURADOR),
                  usuariomodificar = V_USUARIO, 
                  fechamodificar = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
            where gah.gah_asu_id = v_procurador.asu_id
              and gah.gah_gestor_id = v_procurador.usd_id
              and gah.gah_fecha_hasta is null;
         end if;
     end if;
 

END LOOP;       
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores insertados. '||v_n_insert_proc||' Filas.');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores actualizados. '||v_n_update_proc||' Filas.');

    
    
    -- Procuradores
    --------------------------
-- FOR v_procurador IN (SELECT DISTINCT CD_PROCURADOR FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) LOOP
-- END LOOP;           
    
    -- DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');
 


 
 
--/***************************************
--*     FIN PROCURADORES  *
--***************************************/

/**************************************************************************************************/
/**********************************    LETRADOS                        ****************************/
/**************************************************************************************************/

-- COMPROBAMOS SI EXISTE EL DESPACHO LETRADO

--     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''Despacho Letrado''' INTO V_COUNT;
--
--    IF V_COUNT = 0 THEN
--        
--       EXECUTE IMMEDIATE' 
--       INSERT INTO '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO(DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, ZON_ID, DD_TDE_ID)
--       VALUES ('||V_ESQUEMA||'.S_DES_DESPACHO_EXTERNO.NEXTVAL,
--              ''Despacho Letrado'',
--              0,
--              '''||V_USUARIO||''',
--              SYSDATE,
--              0,
--              (SELECT MIN(ZON_ID) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''BANCO DE CREDITO SOCIAL COOPERATIVO SA''),
--              (SELECT DD_TDE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_DESCRIPCION = ''Despacho Letrado'')
--          )';
--
--        DBMS_OUTPUT.PUT_LINE('Despacho Letrado INSERTADO');
--   
--   END IF;
--
--  COMMIT;

-- Insertamos los usuarios letrados

FOR v_letrado IN (SELECT DISTINCT CD_ACTOR FROM CM01.MIG_PROCEDIMS_ACTORES_MIM WHERE TIPO_ACTOR = 1) LOOP

  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.usu_usuarios (
            usu_id
          , entidad_id
          , usu_username
          , usu_password
          , usu_nombre
          , usu_apellido1
          , usu_apellido2
          , usu_mail
          , usuariocrear
          , fechacrear
          , usu_externo
          , usu_grupo)  
   values  ( 
             '||V_ESQUEMA_MASTER||'.s_usu_usuarios.nextval
            , (select ID from '||V_ESQUEMA_MASTER||'.ENTIDAD where DESCRIPCION = ''CAJAMAR'')
            , '''||v_letrado.CD_ACTOR||'''
            , ''1234''
            ,  (select DES_DESPACHO from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO where DES_CODIGO = '''||v_letrado.CD_ACTOR||''')
            , ''''
            , ''''
            , '''' 
            , '''||V_USUARIO||'''
            , sysdate
            , 1
            , 0
          )';

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM CMMASTER.USU_USUARIOS
    WHERE USU_USERNAME = v_letrado.CD_ACTOR
      AND USU_GRUPO = 0;
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el USUARIO LETRADO '||v_letrado.CD_ACTOR||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El USUARIO Letrado '||v_letrado.CD_ACTOR||' YA EXISTE!');
  END IF;
  
  
-- Insertamos los usuarios letrados de grupo  
  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.usu_usuarios (
            usu_id
          , entidad_id
          , usu_username
          , usu_password
          , usu_nombre
          , usu_apellido1
          , usu_apellido2
          , usu_mail
          , usuariocrear
          , fechacrear
          , usu_externo
          , usu_grupo)  
   values  ( 
             '||V_ESQUEMA_MASTER||'.s_usu_usuarios.nextval
            , (select ID from '||V_ESQUEMA_MASTER||'.ENTIDAD where DESCRIPCION = ''CAJAMAR'')
            , ''GRUPO-'||v_letrado.CD_ACTOR||'''
            , ''1234''
            , (select ''GRUPO-''||DES_DESPACHO from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO where DES_CODIGO = '''||v_letrado.CD_ACTOR||''')
            , ''''
            , ''''
            , '''' 
            , '''||V_USUARIO||'''
            , sysdate
            , 1
            , 1
          )';

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM CMMASTER.USU_USUARIOS
    WHERE USU_USERNAME = 'GRUPO-'||v_letrado.CD_ACTOR
      AND USU_GRUPO = 1;
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el USUARIO de GRUPO LETRADO '||v_letrado.CD_ACTOR||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El USUARIO de GRUPO Letrado '||v_letrado.CD_ACTOR||' YA EXISTE!');
  END IF;
  
END LOOP;



-- Insertamos la relación de usuarios despachos para letrados USD_USUARIOS_DESPACHOS , .DES_DESPACHO_EXTERNO      
FOR v_usuario_id IN (SELECT USU_ID, USU_USERNAME 
                       FROM CMMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_DESPACHO FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) procs
                            WHERE USU.USU_USERNAME = PROCS.CD_DESPACHO
                    ) 
                 LOOP

  V_MSQL:= 'insert into '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  
               (
                usd_id
              , usu_id
              , des_id
              , usd_gestor_defecto
              , usd_supervisor
              , usuariocrear
              , fechacrear
              )
        values (
                '||V_ESQUEMA||'.s_usd_usuarios_despachos.nextval
              , '||v_usuario_id.USU_ID||'
              , (select des.des_id from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = '''||v_usuario_id.USU_USERNAME||''')
              , 0
              , 0 
              , '''||V_USUARIO||'''
              , sysdate 
               )';
    
  SELECT COUNT(*) INTO V_EXISTE
  FROM CM01.USD_USUARIOS_DESPACHOS
  WHERE USU_ID = v_usuario_id.USU_ID
    AND DES_ID = (select des.des_id from CM01.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = v_usuario_id.USU_USERNAME);
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el usuario procurador '||v_usuario_id.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario procurador '||v_usuario_id.USU_ID||' YA EXISTE!');
  END IF;
          
-- relacion usuarios grupo con despacho

  
          
END LOOP;


FOR v_usuario_id IN (SELECT USU_ID, USU_USERNAME , PROCS.CD_DESPACHO AS USERNAME 
                       FROM CMMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_DESPACHO FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) procs
                            WHERE USU.USU_USERNAME = 'GRUPO-'||PROCS.CD_DESPACHO
                    ) 
                 LOOP
  V_MSQL:= 'insert into '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  
               (
                usd_id
              , usu_id
              , des_id
              , usd_gestor_defecto
              , usd_supervisor
              , usuariocrear
              , fechacrear
              )
        values (
                '||V_ESQUEMA||'.s_usd_usuarios_despachos.nextval
              , '||v_usuario_id.USU_ID||'
              , (select des.des_id from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = '''||v_usuario_id.USERNAME||''')
              , 0
              , 0 
              , '''||V_USUARIO||'''
              , sysdate 
               )';
    
  SELECT COUNT(*) INTO V_EXISTE
  FROM CM01.USD_USUARIOS_DESPACHOS
  WHERE USU_ID = v_usuario_id.USU_ID
    AND DES_ID = (select des.des_id from CM01.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = v_usuario_id.USU_USERNAME);
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el usuario procurador '||v_usuario_id.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario procurador '||v_usuario_id.USU_ID||' YA EXISTE!');
  END IF;

END LOOP;


-- zonificar usuarios letrados

FOR v_letrado IN (SELECT USU_ID, USU_USERNAME 
                       FROM CMMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_DESPACHO FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) procs
                            WHERE USU.USU_USERNAME = PROCS.CD_DESPACHO
                     ) 
                 LOOP

  V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.zon_pef_usu zpu
               ( zpu.zpu_id
               , zpu.zon_id
               , zpu.pef_id
               , zpu.usu_id
               , zpu.usuariocrear
               , zpu.fechacrear
               )
                 VALUES('||V_ESQUEMA||'.s_zon_pef_usu.nextval
                , (select max(zon_id) from cm01.zon_zonificacion where zon_cod = ''01'')
                , (select pef_id from cm01.pef_perfiles where pef_codigo = ''GEST_EXTERNO'')
                , (select usu_id from cmmaster.usu_usuarios where usu_username = '''||v_letrado.USU_USERNAME||''')
                , '''||V_USUARIO||'''
                , sysdate)';
            
   SELECT COUNT(*) INTO V_EXISTE
  FROM CM01.ZON_PEF_USU
  WHERE ZON_ID = (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01')
    AND PEF_ID = (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO')
    AND USU_ID = (select usu_id from cmmaster.usu_usuarios where usu_username = v_letrado.USU_USERNAME);
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando zonificación para el usuario procurador '||v_letrado.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El el usuario procurador '||v_letrado.USU_ID||' YA ESTA ZONIFICADO!');
  END IF;
          
END LOOP; 

  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USU_USUARIOS Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USD_USUARIOS_DESPACHOS Analizada');

-- Asignar grupos a letrados
FOR v_letrado IN (SELECT USU_ID, USU_USERNAME , 'GRUPO-'||USU_USERNAME AS USERNAME 
                       FROM CMMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_DESPACHO FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) procs
                            WHERE USU.USU_USERNAME = PROCS.CD_DESPACHO
                     ) 
                 LOOP
                 
  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.GRU_GRUPOS_USUARIOS gru 
                  (gru.GRU_ID, gru.USU_ID_GRUPO, gru.USU_ID_USUARIO, gru.USUARIOCREAR, gru.FECHACREAR) 
           VALUES ('||V_ESQUEMA_MASTER||'.s_GRU_GRUPOS_USUARIOS.nextval
                 , (select usu_id from '||V_ESQUEMA_MASTER||'.usu_usuarios where usu_username = '''||v_letrado.USERNAME||''')
                 , (select usu_id from '||V_ESQUEMA_MASTER||'.usu_usuarios where usu_username = '''||v_letrado.USU_USERNAME||''')
                 , '''||V_USUARIO||'''
                 , sysdate)';

  SELECT COUNT(*) INTO V_EXISTE
  FROM CMMASTER.GRU_GRUPOS_USUARIOS
  WHERE USU_ID_GRUPO = (select usu_id from CMMASTER.usu_usuarios where usu_username = v_letrado.USERNAME)
    AND USU_ID_USUARIO = (select usu_id from CMMASTER.usu_usuarios where usu_username = v_letrado.USU_USERNAME)
   ;
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando grupos para el usuario letrado '||v_letrado.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El el usuario letrado '||v_letrado.USU_ID||' YA TIENE GRUPO!');
  END IF;
  
END LOOP; 

/*
   -- LETRADOS EN LA GAA
    ------------------------------

FOR v_letrado IN (SELECT DISTINCT CD_DESPACHO FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) LOOP
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GESCON''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.MIG_PROCEDIMS_CABECERA_MIM migp on migp.cd_procedimiento = asu.asu_id_externo  and migp.CD_DESPACHO = '''||v_letrado.CD_DESPACHO||''' inner join
               '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_codigo = '''||v_letrado.CD_DESPACHO||''' inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on usd.des_id = des.des_id                    inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = '''||v_letrado.CD_DESPACHO||'''       
         where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo=''GESCON'')
                          )
      ) auxi where auxi.ranking = 1
     ) aux');

END LOOP;       
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrados. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- letrados en GAH
    --------------------------
FOR v_letrado IN (SELECT DISTINCT CD_DESPACHO FROM CM01.MIG_PROCEDIMS_CABECERA_MIM) LOOP
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GESCON''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.MIG_PROCEDIMS_CABECERA_MIM migp on migp.cd_procedimiento = asu.asu_id_externo  and migp.CD_DESPACHO = '''||v_letrado.CD_DESPACHO||''' inner join
               '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_codigo = '''||v_letrado.CD_DESPACHO||''' inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd on usd.des_id = des.des_id                     inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = '''||v_letrado.CD_DESPACHO||'''       
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo=''GESCON'')
                            )
      ) auxi where auxi.ranking = 1
     ) aux');    
     
 END LOOP;     
     
    

 
*/

   -- LETRADOS EN LA GAA
    ------------------------------
    select dd_tge_id into v_dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'LETR';
    v_n_insert_letr :=0;
    v_n_update_letr :=0;

FOR v_letrado IN (
      SELECT DISTINCT CD_DESPACHO, mig.numero_exp_nuse, asu.asu_id, d.usd_id
       FROM cm01.MIG_PROCEDIMS_CABECERA_MIM mig, cm01.exp_expedientes exp, cm01.asu_asuntos asu,
           (select usd.usd_id, des.des_codigo
              FROM cm01.des_despacho_externo des 
                   inner join cm01.usd_usuarios_despachos usd on usd.des_id = des.des_id AND usd.borrado = 0
                   inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 AND usu.borrado = 0 and usu_username = des.des_codigo
            ) d 
      WHERE mig.cd_expediente_nuse = exp.cd_expediente_nuse
        AND exp.exp_id = asu.exp_id
        AND exp.borrado = 0
        AND asu.borrado = 0
        and mig.CD_DESPACHO = d.des_codigo
) LOOP
  
   begin
   select gaa.gaa_id, gaa.usuariocrear, gaa.usuariomodificar into v_gaa_id, v_usuariocrear, v_usuariomodificar
     from CM01.gaa_gestor_adicional_asunto gaa
    where gaa.asu_id = v_letrado.asu_id
      and gaa.usd_id = v_letrado.usd_id
      and gaa.dd_tge_id = v_dd_tge_id
	  and gaa.borrado = 0;
   exception
      when others then
         v_gaa_id := 0;
   end;
 
     -- Si no tiene procurador
     if v_gaa_id = 0 
     then
        -- ACTIVO
        insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
        values (cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval,
                v_letrado.asu_id,
                v_letrado.usd_id,
                v_dd_tge_id,
                V_USUARIO,
                TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF'));
        v_n_insert_letr := v_n_insert_letr + 1;
        -- HISTORICO
        insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
        values (cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval,
                v_letrado.asu_id,
                v_letrado.usd_id,
                TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF'),
                v_dd_tge_id,
                V_USUARIO,
                TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF'));
        
     else 
        -- Tiene procurador
        if v_usuariocrear = 'MIGRACM01' and v_usuariomodificar IS null then
           -- es de la migracion y no se ha modificado
           UPDATE cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa
              SET asu_id = (select usd.usd_id
                                  FROM cm01.des_despacho_externo des 
                                 inner join cm01.usd_usuarios_despachos usd on usd.des_id = des.des_id 
                                 inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = des.des_codigo
                                 WHERE des.des_codigo = v_letrado.CD_DESPACHO),
                  usuariomodificar = V_USUARIO, 
                  fechamodificar = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
            where gaa.gaa_id = v_gaa_id
              and gaa.usd_id = v_letrado.usd_id;
           v_n_update_letr := v_n_update_letr + 1;
           UPDATE cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah
              SET gah_asu_id = (select usd.usd_id
                            FROM cm01.des_despacho_externo des 
                                 inner join cm01.usd_usuarios_despachos usd on usd.des_id = des.des_id 
                                 inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = des.des_codigo
                                 WHERE des.des_codigo = v_letrado.CD_DESPACHO),
                  usuariomodificar = V_USUARIO, 
                  fechamodificar = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
            where gah.gah_asu_id = v_letrado.asu_id
              and gah.gah_gestor_id = v_letrado.usd_id
              and gah.gah_fecha_hasta is null;
         end if;
     end if;


END LOOP;

COMMIT;
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores insertados. '||v_n_insert_letr||' Filas.');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores actualizados. '||v_n_update_letr||' Filas.');    
	
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');
 
 
--/***************************************
--*     FIN LETRADOS  *
--***************************************/




  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_MSQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;


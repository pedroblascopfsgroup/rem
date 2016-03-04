--/*
--##########################################
--## AUTOR=JAIME SANCHEZ-CUENCA
--## FECHA_CREACION=20151223
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1449
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

        v_procurador HAYA02.MIG_PROCEDIMIENTOS_CABECERA.CD_PROCURADOR%TYPE;
        v_usuario_id HAYAMASTER.USU_USUARIOS.USU_ID%TYPE;
	v_letrado    HAYA02.MIG_PROCEDIMIENTOS_ACTORES.CD_ACTOR%TYPE;

        V_MSQL  VARCHAR2(2500);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        V_USUARIO VARCHAR2(25 CHAR):= 'MIGRAHAYA02';        

        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

  
BEGIN


/**************************************************************************************************/
/**********************************    PROCURADORES                    ****************************/
/**************************************************************************************************/

-- COMPROBAMOS SI EXISTE EL DESPACHO PROCURADOR:

--     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''Despacho Procuradores''' INTO V_COUNT;
--
--	IF V_COUNT = 0 THEN
--		
--	   EXECUTE IMMEDIATE' 
--	   INSERT INTO '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO(DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, ZON_ID, DD_TDE_ID)
--	   VALUES ('||V_ESQUEMA||'.S_DES_DESPACHO_EXTERNO.NEXTVAL,
--              ''Despacho Procuradores'',
--              0,
--              '''||V_USUARIO||''',
--              SYSDATE,
--              0,
--              (SELECT MIN(ZON_ID) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''BANCO DE CREDITO SOCIAL COOPERATIVO SA''),
--              (SELECT DD_TDE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_DESCRIPCION = ''Despacho Procurador'')
--		  )';
--
--	    DBMS_OUTPUT.PUT_LINE('Despacho Procurador INSERTADO');
--   
--   END IF;
--
--  COMMIT;

-- Insertamos los procuradores

FOR v_procurador IN (SELECT DISTINCT CD_PROCURADOR FROM MIG_PROCEDIMIENTOS_CABECERA) LOOP

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
  FROM HAYAMASTER.USU_USUARIOS
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
                       FROM HAYAMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_PROCURADOR FROM MIG_PROCEDIMIENTOS_CABECERA) procs
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
  FROM HAYA02.USD_USUARIOS_DESPACHOS
  WHERE USU_ID = v_usuario_id.USU_ID
    AND DES_ID = (select des.des_id from HAYA02.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = v_usuario_id.USU_USERNAME);
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el usuario procurador '||v_usuario_id.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario procurador '||v_usuario_id.USU_ID||' YA EXISTE!');
  END IF;
          
END LOOP;


-- zonificar usuarios procuradores

FOR v_procurador IN (SELECT USU_ID, USU_USERNAME 
                       FROM HAYAMASTER.USU_USUARIOS usu
                         , (SELECT DISTINCT CD_PROCURADOR FROM MIG_PROCEDIMIENTOS_CABECERA) procs
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
                , (select max(zon_id) from haya02.zon_zonificacion where zon_cod = ''01'')
                , (select pef_id from haya02.pef_perfiles where pef_codigo = ''HAYAGESTEXT'')
                , (select usu_id from hayamaster.usu_usuarios where usu_username = '''||v_procurador.USU_USERNAME||''')
                , '''||V_USUARIO||'''
                , sysdate)';
            
   SELECT COUNT(*) INTO V_EXISTE
  FROM HAYA02.ZON_PEF_USU
  WHERE ZON_ID = (select max(zon_id) from haya02.zon_zonificacion where zon_cod = '01')
    AND PEF_ID = (select pef_id from haya02.pef_perfiles where pef_codigo = 'HAYAGESTEXT')
    AND USU_ID = (select usu_id from hayamaster.usu_usuarios where usu_username = v_procurador.USU_USERNAME);
  
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
    ------------------------------

FOR v_procurador IN (SELECT DISTINCT CD_PROCURADOR FROM MIG_PROCEDIMIENTOS_CABECERA) LOOP
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''2''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo  and migp.CD_PROCURADOR = '''||v_procurador.CD_PROCURADOR||''' inner join
               '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_codigo = '''||v_procurador.CD_PROCURADOR||''' inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on usd.des_id = des.des_id                    inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = '''||v_procurador.CD_PROCURADOR||'''       
         where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo=''2'')
                          )
      ) auxi where auxi.ranking = 1
     ) aux');

END LOOP;       
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- Procuradores
    --------------------------
FOR v_procurador IN (SELECT DISTINCT CD_PROCURADOR FROM MIG_PROCEDIMIENTOS_CABECERA) LOOP
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''2''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo  and migp.CD_PROCURADOR = '''||v_procurador.CD_PROCURADOR||''' inner join
               '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_codigo = '''||v_procurador.CD_PROCURADOR||''' inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd on usd.des_id = des.des_id                     inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = '''||v_procurador.CD_PROCURADOR||'''       
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo=''2'')
                            )
      ) auxi where auxi.ranking = 1
     ) aux');    
     
 END LOOP;           
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
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
--	IF V_COUNT = 0 THEN
--		
--	   EXECUTE IMMEDIATE' 
--	   INSERT INTO '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO(DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, ZON_ID, DD_TDE_ID)
--	   VALUES ('||V_ESQUEMA||'.S_DES_DESPACHO_EXTERNO.NEXTVAL,
--              ''Despacho Letrado'',
--              0,
--              '''||V_USUARIO||''',
--              SYSDATE,
--              0,
--              (SELECT MIN(ZON_ID) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''BANCO DE CREDITO SOCIAL COOPERATIVO SA''),
--              (SELECT DD_TDE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_DESCRIPCION = ''Despacho Letrado'')
--		  )';
--
--	    DBMS_OUTPUT.PUT_LINE('Despacho Letrado INSERTADO');
--   
--   END IF;
--
--  COMMIT;

-- Insertamos los usuarios letrados

--FOR v_letrado IN (SELECT DISTINCT CD_ACTOR FROM MIG_PROCEDIMIENTOS_ACTORES WHERE TIPO_ACTOR = 1) LOOP
--
--  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.usu_usuarios (
--            usu_id
--          , entidad_id
--          , usu_username
--          , usu_password
--          , usu_nombre
--          , usu_apellido1
--          , usu_apellido2
--          , usu_mail
--          , usuariocrear
--          , fechacrear
--          , usu_externo
--          , usu_grupo)  
--   values  ( 
--             '||V_ESQUEMA_MASTER||'.s_usu_usuarios.nextval
--            , (select ID from '||V_ESQUEMA_MASTER||'.ENTIDAD where DESCRIPCION = ''CAJAMAR'')
--            , '''||v_letrado.CD_ACTOR||'''
--            , ''1234''
--            ,  (select DES_DESPACHO from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO where DES_CODIGO = '''||v_letrado.CD_ACTOR||''')
--            , ''''
--            , ''''
--            , '''' 
--            , '''||V_USUARIO||'''
--            , sysdate
--            , 1
--            , 0
--          )';
--
--	SELECT COUNT(*)
--	INTO V_EXISTE
--	FROM HAYAMASTER.USU_USUARIOS
--	WHERE USU_USERNAME = v_letrado.CD_ACTOR
--	  AND USU_GRUPO = 0;
--  
--  IF V_EXISTE = 0 THEN
--     EXECUTE IMMEDIATE V_MSQL;
--     DBMS_OUTPUT.PUT_LINE('Insertando el USUARIO LETRADO '||v_letrado.CD_ACTOR||'');
--  ELSE
--     DBMS_OUTPUT.PUT_LINE('El USUARIO Letrado '||v_letrado.CD_ACTOR||' YA EXISTE!');
--  END IF;
  
  
-- Insertamos los usuarios letrados de grupo  
--  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.usu_usuarios (
--            usu_id
--          , entidad_id
--          , usu_username
--          , usu_password
--          , usu_nombre
--          , usu_apellido1
--          , usu_apellido2
--          , usu_mail
--          , usuariocrear
--          , fechacrear
--          , usu_externo
--          , usu_grupo)  
--   values  ( 
--             '||V_ESQUEMA_MASTER||'.s_usu_usuarios.nextval
--            , (select ID from '||V_ESQUEMA_MASTER||'.ENTIDAD where DESCRIPCION = ''CAJAMAR'')
--            , ''GRUPO-'||v_letrado.CD_ACTOR||'''
--            , ''1234''
--            , (select ''GRUPO-''||DES_DESPACHO from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO where DES_CODIGO = '''||v_letrado.CD_ACTOR||''')
--            , ''''
--            , ''''
--            , '''' 
--            , '''||V_USUARIO||'''
--            , sysdate
--            , 1
--            , 1
--          )';
--
--	SELECT COUNT(*)
--	INTO V_EXISTE
--	FROM HAYAMASTER.USU_USUARIOS
--	WHERE USU_USERNAME = 'GRUPO-'||v_letrado.CD_ACTOR
--	  AND USU_GRUPO = 1;
--  
--  IF V_EXISTE = 0 THEN
--     EXECUTE IMMEDIATE V_MSQL;
--     DBMS_OUTPUT.PUT_LINE('Insertando el USUARIO de GRUPO LETRADO '||v_letrado.CD_ACTOR||'');
--  ELSE
--     DBMS_OUTPUT.PUT_LINE('El USUARIO de GRUPO Letrado '||v_letrado.CD_ACTOR||' YA EXISTE!');
--  END IF;
--  
--END LOOP;



-- Insertamos la relación de usuarios despachos para letrados USD_USUARIOS_DESPACHOS , .DES_DESPACHO_EXTERNO      
--FOR v_usuario_id IN (SELECT USU_ID, USU_USERNAME 
--                       FROM HAYAMASTER.USU_USUARIOS usu
--                         , (SELECT DISTINCT CD_DESPACHO FROM MIG_PROCEDIMIENTOS_CABECERA) procs
--                            WHERE USU.USU_USERNAME = PROCS.CD_DESPACHO
--                    ) 
--                 LOOP
--
--  V_MSQL:= 'insert into '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  
--               (
--                usd_id
--              , usu_id
--              , des_id
--              , usd_gestor_defecto
--              , usd_supervisor
--              , usuariocrear
--              , fechacrear
--              )
--        values (
--                '||V_ESQUEMA||'.s_usd_usuarios_despachos.nextval
--              , '||v_usuario_id.USU_ID||'
--              , (select des.des_id from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = '''||v_usuario_id.USU_USERNAME||''')
--              , 0
--              , 0 
--              , '''||V_USUARIO||'''
--              , sysdate 
--               )';
--    
--  SELECT COUNT(*) INTO V_EXISTE
--  FROM HAYA02.USD_USUARIOS_DESPACHOS
--  WHERE USU_ID = v_usuario_id.USU_ID
--    AND DES_ID = (select des.des_id from HAYA02.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = v_usuario_id.USU_USERNAME);
--  
--  IF V_EXISTE = 0 THEN
--     EXECUTE IMMEDIATE V_MSQL;
--     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el usuario procurador '||v_usuario_id.USU_ID||'');
--  ELSE
--     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario procurador '||v_usuario_id.USU_ID||' YA EXISTE!');
--  END IF;
--          
---- relacion usuarios grupo con despacho
--
--  
--          
--END LOOP;


--FOR v_usuario_id IN (SELECT USU_ID, USU_USERNAME , PROCS.CD_DESPACHO AS USERNAME 
--                       FROM HAYAMASTER.USU_USUARIOS usu
--                         , (SELECT DISTINCT CD_DESPACHO FROM MIG_PROCEDIMIENTOS_CABECERA) procs
--                            WHERE USU.USU_USERNAME = 'GRUPO-'||PROCS.CD_DESPACHO
--                    ) 
--                 LOOP
--  V_MSQL:= 'insert into '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  
--               (
--                usd_id
--              , usu_id
--              , des_id
--              , usd_gestor_defecto
--              , usd_supervisor
--              , usuariocrear
--              , fechacrear
--              )
--        values (
--                '||V_ESQUEMA||'.s_usd_usuarios_despachos.nextval
--              , '||v_usuario_id.USU_ID||'
--              , (select des.des_id from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = '''||v_usuario_id.USERNAME||''')
--              , 0
--              , 0 
--              , '''||V_USUARIO||'''
--              , sysdate 
--               )';
--    
--  SELECT COUNT(*) INTO V_EXISTE
--  FROM HAYA02.USD_USUARIOS_DESPACHOS
--  WHERE USU_ID = v_usuario_id.USU_ID
--    AND DES_ID = (select des.des_id from HAYA02.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_CODIGO = v_usuario_id.USU_USERNAME);
--  
--  IF V_EXISTE = 0 THEN
--     EXECUTE IMMEDIATE V_MSQL;
--     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el usuario procurador '||v_usuario_id.USU_ID||'');
--  ELSE
--     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario procurador '||v_usuario_id.USU_ID||' YA EXISTE!');
--  END IF;
--
--END LOOP;


-- zonificar usuarios letrados

--FOR v_letrado IN (SELECT USU_ID, USU_USERNAME 
--                       FROM HAYAMASTER.USU_USUARIOS usu
--                         , (SELECT DISTINCT CD_DESPACHO FROM MIG_PROCEDIMIENTOS_CABECERA) procs
--                            WHERE USU.USU_USERNAME = PROCS.CD_DESPACHO
--                     ) 
--                 LOOP
--
--  V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.zon_pef_usu zpu
--               ( zpu.zpu_id
--               , zpu.zon_id
--               , zpu.pef_id
--               , zpu.usu_id
--               , zpu.usuariocrear
--               , zpu.fechacrear
--               )
--                 VALUES('||V_ESQUEMA||'.s_zon_pef_usu.nextval
--                , (select max(zon_id) from haya02.zon_zonificacion where zon_cod = ''01'')
--                , (select pef_id from haya02.pef_perfiles where pef_codigo = ''HAYAGESTEXT'')
--                , (select usu_id from hayamaster.usu_usuarios where usu_username = '''||v_letrado.USU_USERNAME||''')
--                , '''||V_USUARIO||'''
--                , sysdate)';
--            
--   SELECT COUNT(*) INTO V_EXISTE
--  FROM HAYA02.ZON_PEF_USU
--  WHERE ZON_ID = (select max(zon_id) from haya02.zon_zonificacion where zon_cod = '01')
--    AND PEF_ID = (select pef_id from haya02.pef_perfiles where pef_codigo = 'HAYAGESTEXT')
--    AND USU_ID = (select usu_id from hayamaster.usu_usuarios where usu_username = v_letrado.USU_USERNAME);
--  
--  IF V_EXISTE = 0 THEN
--     EXECUTE IMMEDIATE V_MSQL;
--     DBMS_OUTPUT.PUT_LINE('Insertando zonificación para el usuario procurador '||v_letrado.USU_ID||'');
--  ELSE
--     DBMS_OUTPUT.PUT_LINE('El el usuario procurador '||v_letrado.USU_ID||' YA ESTA ZONIFICADO!');
--  END IF;
--          
--END LOOP; 
--
--  
--    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO COMPUTE STATISTICS');
--    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USU_USUARIOS Analizada');
--
--
--
--    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS COMPUTE STATISTICS');
--    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USD_USUARIOS_DESPACHOS Analizada');

-- Asignar grupos a letrados
--FOR v_letrado IN (SELECT USU_ID, USU_USERNAME , 'GRUPO-'||USU_USERNAME AS USERNAME 
--                       FROM HAYAMASTER.USU_USUARIOS usu
--                         , (SELECT DISTINCT CD_DESPACHO FROM MIG_PROCEDIMIENTOS_CABECERA) procs
--                            WHERE USU.USU_USERNAME = PROCS.CD_DESPACHO
--                     ) 
--                 LOOP
--                 
--  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.GRU_GRUPOS_USUARIOS gru 
--                  (gru.GRU_ID, gru.USU_ID_GRUPO, gru.USU_ID_USUARIO, gru.USUARIOCREAR, gru.FECHACREAR) 
--           VALUES ('||V_ESQUEMA_MASTER||'.s_GRU_GRUPOS_USUARIOS.nextval
--                 , (select usu_id from '||V_ESQUEMA_MASTER||'.usu_usuarios where usu_username = '''||v_letrado.USERNAME||''')
--                 , (select usu_id from '||V_ESQUEMA_MASTER||'.usu_usuarios where usu_username = '''||v_letrado.USU_USERNAME||''')
--                 , '''||V_USUARIO||'''
--                 , sysdate)';
--
--  SELECT COUNT(*) INTO V_EXISTE
--  FROM HAYAMASTER.GRU_GRUPOS_USUARIOS
--  WHERE USU_ID_GRUPO = (select usu_id from HAYAMASTER.usu_usuarios where usu_username = v_letrado.USERNAME)
--    AND USU_ID_USUARIO = (select usu_id from HAYAMASTER.usu_usuarios where usu_username = v_letrado.USU_USERNAME)
--   ;
--  
--  IF V_EXISTE = 0 THEN
--     EXECUTE IMMEDIATE V_MSQL;
--     DBMS_OUTPUT.PUT_LINE('Insertando grupos para el usuario letrado '||v_letrado.USU_ID||'');
--  ELSE
--     DBMS_OUTPUT.PUT_LINE('El el usuario letrado '||v_letrado.USU_ID||' YA TIENE GRUPO!');
--  END IF;
--  
--END LOOP; 

   -- LETRADOS EN LA GAA
    ------------------------------

FOR v_letrado IN (SELECT DISTINCT CD_DESPACHO FROM MIG_PROCEDIMIENTOS_CABECERA) LOOP
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
--      select distinct auxi.asu_id, auxi.usd_id
--      from (
          select distinct asu.asu_id, usd.usd_id
--                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo  and migp.CD_DESPACHO = '''||v_letrado.CD_DESPACHO||''' inner join
               '||V_ESQUEMA||'.DD_LHC_LETR_HAYA_CAJAMAR    lhc  on  lhc.dd_lhc_bcc_codigo = '''||v_letrado.CD_DESPACHO||'''  inner join              
   --               '||V_ESQUEMA||'.des_despacho_externo   des  on des.des_codigo = '''||v_letrado.CD_DESPACHO||''' inner join 
               '||V_ESQUEMA_MASTER||'.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               '||V_ESQUEMA_MASTER||'.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id 
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo=''GEXT'')
                          )
  --  ) auxi where auxi.ranking = 1
     ) aux');

END LOOP;       
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrados. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- letrados en GAH
    --------------------------
FOR v_letrado IN (SELECT DISTINCT CD_DESPACHO FROM MIG_PROCEDIMIENTOS_CABECERA) LOOP
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
--      select distinct auxi.asu_id, auxi.usd_id
--      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo  and migp.CD_DESPACHO = '''||v_letrado.CD_DESPACHO||''' inner join
               '||V_ESQUEMA||'.DD_LHC_LETR_HAYA_CAJAMAR    lhc  on  lhc.dd_lhc_bcc_codigo = '''||v_letrado.CD_DESPACHO||'''  inner join              
   --               '||V_ESQUEMA||'.des_despacho_externo   des  on des.des_codigo = '''||v_letrado.CD_DESPACHO||''' inner join 
               '||V_ESQUEMA_MASTER||'.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               '||V_ESQUEMA_MASTER||'.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id  
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo=''GEXT'')
                            )
--      ) auxi where auxi.ranking = 1
     ) aux');    
     
 END LOOP;     
     
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Letrados. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

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


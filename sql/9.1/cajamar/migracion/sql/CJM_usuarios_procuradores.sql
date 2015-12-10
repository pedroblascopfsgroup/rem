--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de datos (usuarios procuradores y usuarios despachos procuradores ..) a partir de tabla MIG_PROCEDIMIENTOS_CABECERA
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        v_procurador MIG_PROCEDIMIENTOS_CABECERA%ROWTYPE;
        v_usuario_id CMMASTER.USU_USUARIOS%ROWTYPE;        
        V_MSQL  VARCHAR2(2500);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        V_USUARIO VARCHAR2(25 CHAR):= 'MIGRACM01';        

        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

  
BEGIN


/**************************************************************************************************/
/**********************************    PROCURADORES                    ****************************/
/**************************************************************************************************/

-- Insertamos los procuradores

FOR v_procurador IN (SELECT DISTINCT CD_PROCURADOR FROM MIG_PROCEDIMIENTOS_CABECERA) LOOP

  V_MSQL:= 'insert into hayamaster.usu_usuarios (
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
              hayamaster.s_usu_usuarios.nextval
            , (select ID from '||V_ESQUEMA_MASTER||'.ENTIDAD where DESCRIPCION = ''CAJAMAR'')
            , ''val.PROCU_'||v_procurador.CD_PROCURADOR||'''
            , ''1234''
            , ''Procurador PROCU_'||v_procurador.CD_PROCURADOR||'''
            , ''''
            , ''''
            , '''' 
            , '''||V_USUARIO||'''
            , sysdate
            , 1
            , 0
          )';

  SELECT COUNT(*) INTO V_EXISTE
  FROM CMMASTER.USU_USUARIOS
  WHERE USU_USERNAME = 'val.PROCU_'||v_procurador.CD_PROCURADOR||'';
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el USUARIO procurador '||v_procurador.CD_PROCURADOR||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El USUARIO procurador '||v_procurador.CD_PROCURADOR||' YA EXISTE!');
  END IF;
          
END LOOP;

COMMIT;


-- Insertamos la relación de usuarios despachos para procuradores USD_USUARIOS_DESPACHOS , .DES_DESPACHO_EXTERNO      
FOR v_usuario_id IN (SELECT USU_ID FROM CMMASTER.USU_USUARIOS WHERE UPPER(USU_USERNAME) LIKE 'VAL.PROCU%') LOOP

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
              , (select des.des_id from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_DESPACHO = ''Despacho Procuradores'')
              , 0
              , 0 
              , '''||V_USUARIO||'''
              , sysdate 
               )';
    
  SELECT COUNT(*) INTO V_EXISTE
  FROM CM01.USD_USUARIOS_DESPACHOS
  WHERE USU_ID = v_usuario_id.USU_ID
    AND DES_ID = (select des.des_id from CM01.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des.DES_DESPACHO = 'Despacho Procuradores');
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el usuario procurador '||v_usuario_id.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario procurador '||v_usuario_id.USU_ID||' YA EXISTE!');
  END IF;
          
END LOOP;

COMMIT;    

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USU_USUARIOS Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - USD_USUARIOS_DESPACHOS Analizada');

 
 
--/***************************************
--*     FIN PROCURADORES  *
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


--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de datos (Asuntos, procedimientos, tareas ..) a partir de tabla intermedia de migración
--## INSTRUCCIONES:  
--## VERSIONES:
--##         0.1 Versión inicial
--##         0.2 Se incluyen procedimientos de tipo concursos.
--##         0.3 Se adapta a SYS_GUID para las tablas PRC_PROCEDIMIENTOS
--##                                                 ASU_ASUNTOS
--##                                                 PRB_PRC_BIE
--##                                                 CEX_CONTRATOS_EXPEDIENTES
--##                                                 TAR_TAREAS_NOTIFICACIONES
--##                                                 RCR_RECURSOS_PROCEDIMIENTOS
--##                                                 SUB_SUBASTAS
--##                                                 LOS_LOTE_SUBASTAS
--## 20151124 0.4 Se cruza con la tabla de BIE_BIENES para cargar LOB_LOTE_BIEN y PRB_PRC_BIE
--##              se quita el min PK de LOS_LOTE_SUBASTA
--##              Se saca del script la caracterizacion de procuradores
--## 20151217 0.5 Se adapta a SYS_GUID para la tabla de EXP_EXPEDIENTES
--## 20151229 0.6 Se modifica Nombre Asunto a la cadena: contrato+NIF/CIF+NombreApellidos
--## 20160114 0.7 GMN Se asigna el DD_TPX_ID (tipo de expediente a recuperaciones - RECU)
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        V_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRACM01';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN

    
    -- BORRADO PREVIO DE TAREAS DUPLICADAS:
    ---------------------------------------
    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_BORRADO_TAR_DUP'' AND OWNER=''CM01''') INTO V_COUNT;

    IF V_COUNT = 0 THEN

        EXECUTE IMMEDIATE('CREATE INDEX '||V_ESQUEMA||'.IDX_BORRADO_TAR_DUP ON '||V_ESQUEMA||'.MIG_MAESTRA_HITOS(prc_id, tar_id, tap_codigo)');

    END IF;

    EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.MIG_MAESTRA_HITOS COMPUTE STATISTICS';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.MIG_MAESTRA_HITOS ANALIZADA');

    EXECUTE IMMEDIATE 'ANALYZE TABLE MIG_MAESTRA_HITOS_VALORES COMPUTE STATISTICS';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.MIG_MAESTRA_HITOS_VALORES ANALIZADA');

    EXECUTE IMMEDIATE 'alter table '||V_ESQUEMA||'.MIG_MAESTRA_HITOS_VALORES DISABLE CONSTRAINT FK_MIG_MAESTRA_HITOS';           

    EXECUTE IMMEDIATE 'delete from '||V_ESQUEMA||'.mig_maestra_hitos_valores misi
        where misi.tar_id in (
          select tar_id from (
            select prc_id, tar_id, tap_codigo, rank() over (partition by prc_id, tap_codigo order by tar_tarea_finalizada, tar_id) as rankin
            from '||V_ESQUEMA||'.mig_maestra_hitos
            where prc_id in (
              select prc_id from (
                select prc_id, tap_codigo, count(*) cuenta
                from '||V_ESQUEMA||'.mig_maestra_hitos
                group by prc_id, tap_codigo )
              where cuenta > 1 )
          ) where rankin >= 2
        )';
    COMMIT;

    EXECUTE IMMEDIATE 'delete from '||V_ESQUEMA||'.mig_maestra_hitos misi
        where misi.tar_id in (
          select tar_id from (
            select prc_id, tar_id, tap_codigo, rank() over (partition by prc_id, tap_codigo order by tar_tarea_finalizada, tar_id) as rankin
            from '||V_ESQUEMA||'.mig_maestra_hitos
            where prc_id in (
              select prc_id from (
                select prc_id, tap_codigo, count(*) cuenta
                from '||V_ESQUEMA||'.mig_maestra_hitos
                group by prc_id, tap_codigo )
              where cuenta > 1 )
          ) where rankin >= 2
        )';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'-'||SQL%ROWCOUNT||' TAREAS DUPLICADAS BORRADAS EN '||V_ESQUEMA||'.MIG_MAESTRA_HITOS');
    COMMIT;      

    EXECUTE IMMEDIATE 'alter table '||V_ESQUEMA||'.MIG_MAESTRA_HITOS_VALORES ENABLE CONSTRAINT FK_MIG_MAESTRA_HITOS';
 
    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_BORRADO_TAR_DUP'' AND OWNER=''CM01''') INTO V_COUNT;

    IF V_COUNT = 1 THEN

        EXECUTE IMMEDIATE('DROP INDEX '||V_ESQUEMA||'.IDX_BORRADO_TAR_DUP');

    END IF;

--/***************************************
--*  INICIO MIGRACION DESDE MAESTRA      *
--***************************************/

    SELECT COUNT(1)
    INTO V_COUNT
    FROM ALL_SEQUENCES
    WHERE SEQUENCE_NAME  = 'S_ASU_ASUNTOS'
    AND SEQUENCE_OWNER = V_ESQUEMA;

    IF V_COUNT = 1 THEN

      v_SQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_ASU_ASUNTOS';
      
      EXECUTE IMMEDIATE(v_SQL);
      
      v_SQL := 'CREATE SEQUENCE  '||V_ESQUEMA||'.S_ASU_ASUNTOS  MINVALUE 100000000 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 100000000 CACHE 20 NOORDER  NOCYCLE';
      
      EXECUTE IMMEDIATE(v_SQL);
      
    ELSE

      v_SQL := 'CREATE SEQUENCE  '||V_ESQUEMA||'.S_ASU_ASUNTOS  MINVALUE 100000000 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 100000000 CACHE 20 NOORDER  NOCYCLE';
      
      EXECUTE IMMEDIATE(v_SQL);
      
    END IF;
    
    COMMIT;

/*    
    
    SELECT COUNT(1)
    INTO EXISTE
    FROM ALL_SEQUENCES
    WHERE SEQUENCE_NAME  = 'S_BIE_BIEN'
    AND SEQUENCE_OWNER = V_ESQUEMA;

    IF EXISTE = 1 THEN

      V_SQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_BIE_BIEN';
      
      EXECUTE IMMEDIATE(V_SQL);
      
      V_SQL := 'CREATE SEQUENCE  '||V_ESQUEMA||'.S_BIE_BIEN  MINVALUE 100000000 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 100000000 CACHE 20 NOORDER  NOCYCLE';
      
      EXECUTE IMMEDIATE(V_SQL);
      
    ELSE

      V_SQL := 'CREATE SEQUENCE  '||V_ESQUEMA||'.S_BIE_BIEN  MINVALUE 100000000 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 100000000 CACHE 20 NOORDER  NOCYCLE';
      
      EXECUTE IMMEDIATE(V_SQL);
      
    END IF;
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' SECUENCIAS S_BIE_BIEN y S_ASU_ASUNTOS INICIALIZADAS');
    
 
    ---------------------
    --    BIE_BIEN     --
    ---------------------
    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.BIE_BIEN 
    (   BIE_ID, DD_TBI_ID
      , BIE_PARTICIPACION
      , BIE_VALOR_ACTUAL
      , BIE_IMPORTE_CARGAS
      , BIE_SUPERFICIE
      , BIE_POBLACION
      , BIE_DATOS_REGISTRALES
      , BIE_REFERENCIA_CATASTRAL
      , VERSION, USUARIOCREAR, FECHACREAR
      , USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR
      , BORRADO
      , BIE_DESCRIPCION
      , BIE_FECHA_VERIFICACION
      , DD_ORIGEN_ID, BIE_MARCA_EXTERNOS, DD_TPO_CARGA_ID
      , BIE_CODIGO_INTERNO
      , DTYPE
      , BIE_SOLVENCIA_NO_ENCONTRADA, BIE_OBSERVACIONES
      , DD_SPO_ID
      , BIE_VIVIENDA_HABITUAL
      , BIE_NUMERO_ACTIVO
      , BIE_LICENCIA_PRI_OCUPACION, BIE_PRIMERA_TRANSMISION, BIE_CONTRATO_ALQUILER, BIE_OBRA_EN_CURSO
      , BIE_CODIGO_EXTERNO
      , BIE_TIPO_SUBASTA
    )  
      SELECT '||V_ESQUEMA||'.S_BIE_BIEN.NEXTVAL
           , TBI.DD_TBI_ID
           , null
           , PRO.VALOR_ACTUAL
           , CAR.BIE_IMPORTE_CARGAS
           , BIE.SUPERFICIE
           , BIE.POBLACION
           , null
           , NVL(BIE.REFERENCIA_CATASTRAL,ADJ.REFERENCIA_CATASTRAL)
           , 0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
           , null, null, null, null
           , 0
           , substr(BIE.DESCRIPCION_DEL_BIEN,1,250) as DESCRIPCION_DEL_BIEN
           ,null
           , 1 ,0, null
           , BIE.ID_BIEN_NUSE
           , ''NMBBien''
           , 0 ,null 
           , POS.DD_SPO_ID 
           , PRO.VIVIENDA_HABITUAL 
           , BIE.NUMERO_ACTIVO
           , null ,null ,null, null 
           , BIE.CD_BIEN
           , PRO.TIPO_SUBASTA
      FROM (SELECT max(cd_bien) cd_bien, id_bien_nuse, numero_activo 
            FROM '||V_ESQUEMA||'.MIG_BIENES 
            GROUP BY id_bien_nuse, numero_activo)           GUI
         , '||V_ESQUEMA||'.MIG_BIENES                       BIE
         , (SELECT DISTINCT BIE_CODIGO_INTERNO
                          , BIE_NUMERO_ACTIVO
                          , BIE_CODIGO_EXTERNO  
            FROM '||V_ESQUEMA||'.BIE_BIEN)                  ANT
         , (SELECT prb.*
            FROM (select cd_bien,
                  max(cd_procedimiento) cd_prc 
                  from '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES 
                  group by cd_bien ) prc
               , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES prb
            WHERE PRC.CD_BIEN = PRB.CD_BIEN
            AND PRC.CD_PRC  = PRB.CD_PROCEDIMIENTO)         PRO
         , '||V_ESQUEMA||'.MIG_BIENES_ACTIVOS_ADJUDICADOS   ADJ
         , (SELECT CD_BIEN, 
            SUM(IMPORTE_REGISTRAL) BIE_IMPORTE_CARGAS 
            FROM '||V_ESQUEMA||'.MIG_BIENES_CARGAS 
            GROUP BY CD_BIEN)                               CAR
         , '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA       POS
         , '||V_ESQUEMA||'.DD_TBI_TIPO_BIEN                 TBI
     WHERE GUI.CD_BIEN = BIE.CD_BIEN
       AND BIE.CD_BIEN = PRO.CD_BIEN(+)
       AND BIE.ID_BIEN_NUSE  = ANT.BIE_CODIGO_INTERNO(+) 
       AND BIE.NUMERO_ACTIVO = ANT.BIE_NUMERO_ACTIVO(+) 
       AND ANT.BIE_CODIGO_INTERNO IS NULL
       AND GUI.CD_BIEN = ADJ.CD_BIEN(+)
       AND BIE.CD_BIEN = CAR.CD_BIEN(+)
       AND PRO.SITUACION_POSESORIA = POS.DD_SPO_CODIGO(+)
       AND decode(BIE.TIPO_BIEN
                 ,''INM'',    ''01''
                 ,''BMB'',    ''02''
                 ,''VAL'',    ''05''
                 ,''VEH'',    ''03''
                 ,''MOB'',    ''02''
                 ,''EFE'',    ''03''
                 , BIE.TIPO_BIEN) = TBI.DD_TBI_CODIGO');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_BIEN Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;   
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_BIEN COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_BIEN analizada');
    
   


    --------------------
    -- ADJUDICACIONES --
    --------------------
    
    --** Creamos temporal con activos-adjudicados que no estan ya en procedimientos-bienes
    --
    EXISTE := 0;
    v_sql:= 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG_TMP_PRB_ADJ01'' AND OWNER = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe>0) THEN
       EXECUTE IMMEDIATE('DROP TABLE '||V_ESQUEMA||'.MIG_TMP_PRB_ADJ01');
    END IF; 
    EXECUTE IMMEDIATE('CREATE TABLE '||V_ESQUEMA||'.MIG_TMP_PRB_ADJ01 AS 
                         select adj.numero_activo
                              , adj.id_bien_nuse                        
                              , adj.cd_bien
                           from '||V_ESQUEMA||'.MIG_BIENES bie
                              , '||V_ESQUEMA||'.MIG_BIENES_ACTIVOS_ADJUDICADOS adj 
                              , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES prb
                          where bie.numero_activo = adj.numero_activo
                            and bie.cd_bien = prb.cd_bien(+) and prb.cd_bien is null
                            and bie.numero_activo <> 0');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_TMP_PRB_ADJ01 Creada. '||SQL%ROWCOUNT||' Filas.');
    
    --** Insertamos
    --
    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION
           ( BIE_ADJ_ID
           , BIE_ID
           , BIE_ADJ_F_DECRETO_N_FIRME 
           , BIE_ADJ_F_DECRETO_FIRME
           , BIE_ADJ_F_ENTREGA_GESTOR
           , BIE_ADJ_F_PRESEN_HACIENDA
           , BIE_ADJ_F_SEGUNDA_PRESEN
           , BIE_ADJ_F_RECPCION_TITULO
           , BIE_ADJ_F_INSCRIP_TITULO
           , BIE_ADJ_F_ENVIO_ADICION
           , BIE_ADJ_F_PRESENT_REGISTRO
           , BIE_ADJ_F_SOL_POSESION
           , BIE_ADJ_F_SEN_POSESION
           , BIE_ADJ_F_REA_POSESION
           , BIE_ADJ_F_SOL_LANZAMIENTO
           , BIE_ADJ_F_SEN_LANZAMIENTO
           , BIE_ADJ_F_REA_LANZAMIENTO
           , BIE_ADJ_F_SOL_MORATORIA
           , BIE_ADJ_F_RES_MORATORIA
           , BIE_ADJ_F_CONTRATO_ARREN
           , BIE_ADJ_F_CAMBIO_CERRADURA
           , BIE_ADJ_F_ENVIO_LLAVES
           , BIE_ADJ_F_RECEP_DEPOSITARIO
           , BIE_ADJ_F_ENVIO_DEPOSITARIO
           , BIE_ADJ_OCUPADO
           , BIE_ADJ_POSIBLE_POSESION
           , BIE_ADJ_OCUPANTES_DILIGENCIA
           , BIE_ADJ_LANZAMIENTO_NECES
           , BIE_ADJ_ENTREGA_VOLUNTARIA
           , BIE_ADJ_NECESARIA_FUERA_PUB
           , BIE_ADJ_EXISTE_INQUILINO
           , BIE_ADJ_LLAVES_NECESARIAS
           , BIE_ADJ_GESTORIA_ADJUDIC 
           , BIE_ADJ_NOMBRE_ARRENDATARIO
           , BIE_ADJ_NOMBRE_DEPOSITARIO
           , BIE_ADJ_NOMBRE_DEPOSITARIO_F
           , DD_EAD_ID
           , DD_SIT_ID
           , DD_FAV_ID
           , VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO
           , BIE_ADJ_F_RECEP_DEPOSITARIO_F
           , DD_TFO_ID
           , BIE_ADJ_REQ_SUBSANACION
           , BIE_ADJ_NOTIF_DEMANDADOS
           , BIE_ADJ_F_REV_PROP_CAN
           , BIE_ADJ_F_PROP_CAN
           , BIE_ADJ_F_REV_CARGAS
           , BIE_ADJ_F_PRES_INS_ECO
           , BIE_ADJ_F_PRES_INS
           , BIE_ADJ_F_CAN_REG_ECO
           , BIE_ADJ_F_CAN_REG
           , BIE_ADJ_F_CAN_ECO
           , BIE_ADJ_F_LIQUIDACION
           , BIE_ADJ_F_RECEPCION
           , BIE_ADJ_F_CANCELACION
           , BIE_ADJ_IMPORTE_ADJUDICACION
           , BIE_ADJ_CESION_REMATE
           , BIE_ADJ_CESION_REMATE_IMP
           ) 
      SELECT '||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION.NEXTVAL, todos.*
      FROM
      (
      --------------------------
      --** Bienes-Adjudicados
      --------------------------
      SELECT bie.BIE_ID  
           , adj.FECHA_DECRETO_ADJ_NO_FIRME 
           , adj.FECHA_DECRETO_ADJ_FIRME
           , adj.FECHA_ENTREGA_TITULO_GESTOR
           , adj.FECHA_PRESENTACION_HACIENDA
           , adj.FECHA_SEGUNDA_PRES_REGISTRO
           , adj.FECHA_RECEPCION_TITULO
           , adj.FECHA_INSCRIPCION_TITULO
           , adj.FECHA_ENVIO_AUTO_ADICION as BIE_ADJ_F_ENVIO_ADICION  
           , adj.FECHA_PRESENTACION_REGISTRO
           , adj.FECHA_SOLICITUD_POSESION
           , adj.FECHA_SENYALAMIENTO_POSESION
           , adj.FECHA_REALIZACION_POSESION
           , adj.FECHA_SOLICITUD_LANZAMIENTO
           , adj.FECHA_SENYALAMIENTO_LANZAM
           , adj.FECHA_LANZAMIENTO_EFECTIVO
           , adj.FECHA_SOLICITUD_MORATORIA
           , adj.FECHA_RESOLUCION_MORATORIA
           , adj.FECHA_CONTRATO_ARREND
           , adj.FECHA_CAMBIO_CERRADURA
           , adj.FECHA_ENVIO_DEPOS_FINAL as BIE_ADJ_F_ENVIO_LLAVES
           , adj.FECHA_RECEP_PRIMER_DEPOS
           , adj.FECHA_ENVIO_PRIMER_DEPOS
           , adj.OCUPANTES
           , adj.POSIBLE_POSESION
           , adj.OCUPANTES_REALIZ_DILIGENCIA
           , adj.LANZAMIENTO_NECESARIO
           , adj.ENTREGA_VOLUNTARIA_POSESION
           , adj.NECESARIA_FUERZA_LANZAMIENTO as BIE_ADJ_NECESARIA_FUERA_PUB
           , adj.EXISTE_INQUILINO
           , adj.GESTION_LLAVES_NECESARIA
           , ges.USU_ID
           , adj.NOMBRE_ARRENDATARIO
           , adj.NOMBRE_PRIMER_DEPOSITARIO
           , adj.NOMBRE_DEPOSITARIO_FINAL
           , (select DD_EAD_ID from '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA where DD_EAD_CODIGO=''1'') as DD_EAD_ID
           , sit.DD_SIT_ID
           , fav.DD_FAV_ID
           , 0 as VERSION ,'''||USUARIO||''' as USUARIOCREAR , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR 
           , null as USUARIOMODIFICAR,null as FECHAMODIFICAR
           , null as USUARIOBORRAR   ,null as FECHABORRAR ,0 as BORRADO
           , adj.FECHA_RECEP_DEPOS_FINAL
           , fon.DD_TFO_ID
           , null as BIE_ADJ_REQ_SUBSANACION  
           , null as BIE_ADJ_NOTIF_DEMANDADOS 
           , null as BIE_ADJ_F_REV_PROP_CAN 
           , null as BIE_ADJ_F_PROP_CAN
           , null as BIE_ADJ_F_REV_CARGAS
           , null as BIE_ADJ_F_PRES_INS_ECO
           , null as BIE_ADJ_F_PRES_INS
           , null as BIE_ADJ_F_CAN_REG_ECO
           , null as BIE_ADJ_F_CAN_REG
           , null as BIE_ADJ_F_CAN_ECO
           , null as BIE_ADJ_F_LIQUIDACION
           , null as BIE_ADJ_F_RECEPCION
           , null as BIE_ADJ_F_CANCELACION
           , null as BIE_ADJ_IMPORTE_ADJUDICACION
           , null as BIE_ADJ_CESION_REMATE
           , null as BIE_ADJ_CESION_REMATE_IMP
        FROM '||V_ESQUEMA||'.MIG_TMP_PRB_ADJ01              gui
           , '||V_ESQUEMA||'.MIG_BIENES_ACTIVOS_ADJUDICADOS adj
           , '||V_ESQUEMA||'.BIE_BIEN                       bie
           , (select usu.USU_ID, 
                     usu.DES_ID,
                     des.DES_DESPACHO
                from '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  usu,
                     '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO    des,
                     '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO tde
              where usu.DES_ID = des.DES_ID
                and tde.DD_TDE_id = des.DD_TDE_id
                and tde.DD_TDE_CODIGO = ''GESTORIA'')       ges
           , '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO              fon
           , '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO        sit
           , '||V_ESQUEMA_MASTER||'.DD_FAV_FAVORABLE            fav
       WHERE gui.cd_bien = bie.bie_codigo_externo
         AND gui.cd_bien = adj.cd_bien
         AND adj.gestoria_adjudicacion = ges.des_despacho(+)
         AND adj.fondo                 = fon.DD_TFO_CODIGO_UVEM(+)
         AND adj.SITUACION_TITULO      = sit.DD_SIT_CODIGO(+)
         AND decode(adj.RESOLUCION_MORATORIA
             ,1  ,''01''
             ,0  ,''02''
             , adj.RESOLUCION_MORATORIA) = fav.DD_FAV_CODIGO(+)
      --
      UNION
      ----------------------------------------------------------
      --** Procedimientos-Bienes (procedimiento más reciente)
      ----------------------------------------------------------      
      SELECT bie.BIE_ID  
           , prb.FECHA_DECRETO_ADJ_NO_FIRME 
           , prb.FECHA_DECRETO_ADJ_FIRME
           , prb.FECHA_ENTREGA_TITULO_GESTOR
           , prb.FECHA_PRESENTACION_HACIENDA
           , prb.FECHA_SEGUNDA_PRES_REGISTRO
           , prb.FECHA_RECEPCION_TITULO
           , prb.FECHA_INSCRIPCION_TITULO
           , prb.FECHA_ENVIO_AUTO_ADICION as BIE_ADJ_F_ENVIO_ADICION  
           , prb.FECHA_PRESENTACION_REGISTRO
           , prb.FECHA_SOLICITUD_POSESION
           , prb.FECHA_SENYALAMIENTO_POSESION
           , prb.FECHA_REALIZACION_POSESION
           , prb.FECHA_SOLICITUD_LANZAMIENTO
           , prb.FECHA_SENYALAMIENTO_LANZAM
           , prb.FECHA_LANZAMIENTO as FECHA_LANZAMIENTO_EFECTIVO
           , prb.FECHA_SOLICITUD_MORATORIA
           , prb.FECHA_RESOLUCION_MORATORIA
           , prb.FECHA_CONTRATO_ARREND
           , prb.FECHA_CAMBIO_CERRADURA
           , prb.FECHA_ENVIO_DEPOS_FINAL as BIE_ADJ_F_ENVIO_LLAVES
           , prb.FECHA_RECEP_PRIMER_DEPOS
           , prb.FECHA_ENVIO_PRIMER_DEPOS
           , prb.OCUPANTES
           , prb.POSIBLE_POSESION
           , prb.OCUPANTES_REALIZ_DILIGENCIA
           , prb.LANZAMIENTO_NECESARIO
           , prb.ENTREGA_VOLUNTARIA_POSESION
           , prb.NECESARIA_FUERZA_LANZAMIENTO as BIE_ADJ_NECESARIA_FUERA_PUB
           , prb.EXISTE_INQUILINO
           , prb.GESTION_LLAVES_NECESARIA
           , ges.USU_ID
           , prb.NOMBRE_ARRENDATARIO
           , prb.NOMBRE_PRIMER_DEPOSITARIO
           , prb.NOMBRE_DEPOSITARIO_FINAL
           , ead.DD_EAD_ID
           , sit.DD_SIT_ID
           , fav.DD_FAV_ID
           , 0 as VERSION ,'''||USUARIO||''' as USUARIOCREAR , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR 
           , null as USUARIOMODIFICAR,null as FECHAMODIFICAR
           , null as USUARIOBORRAR   ,null as FECHABORRAR ,0 as BORRADO
           , prb.FECHA_RECEP_DEPOS_FINAL
           , fon.DD_TFO_ID
           , nvl(dem.REQUERIDO,''2'') as BIE_ADJ_REQ_SUBSANACION  
           , decode(prb.FECHA_NOTIFICACION_ACREEDORES
                   ,null,0,1)       as BIE_ADJ_NOTIF_DEMANDADOS 
           , null as BIE_ADJ_F_REV_PROP_CAN 
           , null as BIE_ADJ_F_PROP_CAN
           , null as BIE_ADJ_F_REV_CARGAS
           , null as BIE_ADJ_F_PRES_INS_ECO
           , null as BIE_ADJ_F_PRES_INS
           , null as BIE_ADJ_F_CAN_REG_ECO
           , null as BIE_ADJ_F_CAN_REG
           , null as BIE_ADJ_F_CAN_ECO
           , null as BIE_ADJ_F_LIQUIDACION
           , null as BIE_ADJ_F_RECEPCION
           , null as BIE_ADJ_F_CANCELACION
           , prb.IMPORTE_ADJUDICACION as BIE_ADJ_IMPORTE_ADJUDICACION
           , prb.CESION_REMATE
           , null as BIE_ADJ_CESION_REMATE_IMP
        FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES      prb
           , (select cd_bien, 
                     max(cd_procedimiento) cd_prc 
                from '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES
               group by cd_bien )                           prc
           , '||V_ESQUEMA||'.BIE_BIEN                       bie
           , (select usu.USU_ID, 
                     usu.DES_ID,
                     des.DES_DESPACHO
                from '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  usu,
                     '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO    des,
                     '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO tde
              where usu.DES_ID = des.DES_ID
                and tde.DD_TDE_id = des.DD_TDE_id
                and tde.DD_TDE_CODIGO = ''GESTORIA'')       ges
           , '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA        ead
           , '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO              fon
           , '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO        sit
           , '||V_ESQUEMA_MASTER||'.DD_FAV_FAVORABLE            fav
           , (select cd_procedimiento,
                     max(requerido) as requerido
              from '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_DEMANDADOS
              group by cd_procedimiento )                   dem
       WHERE prb.cd_bien = prc.cd_bien 
         AND prb.cd_procedimiento = prc.cd_prc
         AND prb.cd_bien = bie.bie_codigo_externo
         AND prb.gestoria_adjudicacion = ges.des_despacho(+)
         AND decode(prb.entidad_adjudicataria
                   ,''Entidad'' ,''1''
                   ,''Terceros'',''2'') = ead.DD_EAD_CODIGO(+)
         AND prb.fondo                  = fon.DD_TFO_CODIGO_UVEM(+)
         AND prb.SITUACION_TITULO       = sit.DD_SIT_CODIGO(+)
         AND decode(prb.RESOLUCION_MORATORIA
                  ,1  ,''01''
                  ,0  ,''02''
           , prb.RESOLUCION_MORATORIA)  = fav.DD_FAV_CODIGO(+)
         AND prc.cd_prc = dem.cd_procedimiento) TODOS');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_ADJ_ADJUDICACION Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_ADJ_ADJUDICACION Analizada');


    --------------------
    --    CARGAS      --
    --------------------
    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.BIE_CAR_CARGAS 
         ( 
             BIE_ID
           , BIE_CAR_ID
           , DD_TPC_ID
           , BIE_CAR_LETRA
           , BIE_CAR_TITULAR
           , BIE_CAR_IMPORTE_REGISTRAL
           , BIE_CAR_IMPORTE_ECONOMICO
           , BIE_CAR_REGISTRAL
           , DD_SIC_ID
           , BIE_CAR_FECHA_PRESENTACION
           , BIE_CAR_FECHA_INSCRIPCION
           , BIE_CAR_FECHA_CANCELACION
           , BIE_CAR_ECONOMICA
           , VERSION, USUARIOCREAR, FECHACREAR
           , USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_SIC_ID2
         ) 
      SELECT b.BIE_ID
           , '||V_ESQUEMA||'.S_BIE_CAR_CARGAS.NEXTVAL
           , DD_TPC_ID
           , CD_CARGA
           , TITULAR_CARGAS
           , IMPORTE_REGISTRAL
           , IMPORTE_ECONOMICO_REAL
           , CONTENIDO_REGISTRAL
           , SITUACION_REGISTRAL
           , FECHA_PRESENT_REGISTRO_CANC
           , FECHA_INSCRIPCION_CARGA
           , FECHA_CANCELACION_CARGA
           , CONTENIDO_ECONOMICO
           , 0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
           , null, null, null, null, 0, 3
      FROM (
             SELECT
                 b.BIE_ID
               , (SELECT DD_TPC_ID FROM DD_TPC_TIPO_CARGA WHERE DD_TPC_CODIGO = a.CARGA) as DD_TPC_ID
               , CD_CARGA
               , TITULAR_CARGAS
               , IMPORTE_REGISTRAL
               , IMPORTE_ECONOMICO_REAL
               , CONTENIDO_REGISTRAL
               , (SITUACION_REGISTRAL + 1) SITUACION_REGISTRAL
               , FECHA_PRESENT_REGISTRO_CANC
               , FECHA_INSCRIPCION_CARGA
               , FECHA_CANCELACION_CARGA
               , CONTENIDO_ECONOMICO 
             FROM MIG_BIENES_CARGAS a
                 ,BIE_BIEN b
             where a.CD_BIEN = ''-''||to_char(b.BIE_NUMERO_ACTIVO)
             ORDER BY TO_NUMBER(SUBSTR(CD_CARGA, 1,INSTR(CD_CARGA,''-'')-1)), SUBSTR(CD_CARGA, INSTR(CD_CARGA,''-'')+1)
           )'
         );
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_CAR_CARGAS Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('Analyze table '||V_ESQUEMA||'.BIE_CAR_CARGAS compute statistics');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_CAR_CARGAS Analizada');




    --------------------
    -- TMP CONTRATOS  --
    --------------------
    existe := 0;
    v_sql:= 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG_BIE_TMP_CNT_ID'' AND OWNER = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe>0) THEN
       EXECUTE IMMEDIATE('DROP TABLE '||V_ESQUEMA||'.MIG_BIE_TMP_CNT_ID');
    END IF; 
  
    
       --
    EXECUTE IMMEDIATE('CREATE TABLE '||V_ESQUEMA||'.MIG_BIE_TMP_CNT_ID AS
		SELECT distinct BOP.CD_BIEN
		              , BOP.NUMERO_ACTIVO
		              , substr(LPAD(''0'',5,''0'')||LPAD(BOP.TIPO_PRODUCTO,5,''0'')||LPAD(BOP.NUMERO_CONTRATO,17,''0'')||LPAD(TO_CHAR(BOP.NUMERO_ESPEC),15,''0''),1,50) AS CONTRATO
		              , CNT.CNT_ID
		FROM '||V_ESQUEMA||'.MIG_BIENES_OPERACIONES BOP
		LEFT JOIN  '||V_ESQUEMA||'.CNT_CONTRATOS CNT 
		      ON (LPAD(''0'',5,''0'')||LPAD(BOP.TIPO_PRODUCTO,5,''0'')||LPAD(BOP.NUMERO_CONTRATO,17,''0'')||LPAD(TO_CHAR(BOP.NUMERO_ESPEC),15,''0'') = CNT.CNT_CONTRATO)
		LEFT JOIN '||V_ESQUEMA||'.EXT_IAC_INFO_ADD_CONTRATO IAC ON cnt.cnt_id = iac.cnt_id');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_BIE_TMP_CNT_ID Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_BIE_TMP_CNT_ID COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_BIE_TMP_CNT_ID Analizada');

    --------------------
    --    CONTRATOS   --
    --------------------
    EXECUTE IMMEDIATE ('
        INSERT INTO '||V_ESQUEMA||'.BIE_CNT
               ( BIE_CNT_ID
               , CNT_ID
               , BIE_ID
               , DD_TBC_ID
               , DD_EBC_ID
               , BIE_CNT_IMPORTE_GARANTIZADO ,BIE_CNT_FECHA_INICIO, BIE_CNT_FECHA_CIERRE
               , VERSION, USUARIOCREAR, FECHACREAR
               , USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO
               )
               SELECT '||V_ESQUEMA||'.S_BIE_CNT.NEXTVAL, CNT_ID, BIE_ID, DD_TBC_ID, DD_EBC_ID, IMPORTE_GARANTIZADO, FECHA_INICIO_RELACION, FECHA_FIN_RELACION
                    , 0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
                    , NULL, NULL, NULL, NULL, 0
                 FROM (SELECT DISTINCT b.CNT_ID
			    , c.BIE_ID
			    , 1 as DD_TBC_ID
			    , 2 as DD_EBC_ID
			    , a.IMPORTE_GARANTIZADO
			    , a.FECHA_INICIO_RELACION
			    , a.FECHA_FIN_RELACION
			FROM '||V_ESQUEMA||'.MIG_BIENES_OPERACIONES a, '||V_ESQUEMA||'.MIG_BIE_TMP_CNT_ID b,'||V_ESQUEMA||'.BIE_BIEN C
			WHERE b.CONTRATO = LPAD(''0'',5,''0'')||LPAD(a.TIPO_PRODUCTO,5,''0'')||LPAD(a.NUMERO_CONTRATO,17,''0'')||LPAD(TO_CHAR(a.NUMERO_ESPEC),15,''0'')
			AND B.CD_BIEN = A.CD_BIEN
			AND B.CD_BIEN = c.BIE_CODIGO_EXTERNO)');
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_CNT Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_CNT COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_CNT Analizada');

    --------------------
    --  TMP PERSONAS  --
    --------------------
    existe := 0;
    v_sql:= 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG_BIE_TMP_PER_ID'' AND OWNER = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe>0) THEN
       EXECUTE IMMEDIATE('DROP TABLE '||V_ESQUEMA||'.MIG_BIE_TMP_PER_ID');
    END IF; 
    

    EXECUTE IMMEDIATE('CREATE TABLE '||V_ESQUEMA||'.MIG_BIE_TMP_PER_ID AS
    SELECT DISTINCT  BPER.CD_BIEN, BPER.NUMERO_ACTIVO, BPER.CODIGO_PERSONA, BPER.CODIGO_ENTIDAD, PER.PER_ID 
    FROM '||V_ESQUEMA||'.MIG_BIENES_PERSONAS BPER
    LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER 
       ON (BPER.CODIGO_PERSONA = PER.PER_COD_CLIENTE_ENTIDAD)
    WHERE BPER.CODIGO_PERSONA>0');    

    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_BIE_TMP_PER_ID Creada. '||SQL%ROWCOUNT||' Filas.');
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_BIE_TMP_PER_ID COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_BIE_TMP_PER_ID Analizada');


    --------------------
    --    PERSONAS    --
    --------------------
    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.BIE_PER
    (
       BIE_ID
     , PER_ID
     , VERSION
     , BIE_PER_PARTICIPACION
     , USUARIOCREAR
     , FECHACREAR
     , USUARIOMODIFICAR
     , FECHAMODIFICAR
     , USUARIOBORRAR
     , FECHABORRAR
     , BORRADO
     , BIE_PER_ID
    ) 
    SELECT BIE_ID
         , PER_ID
         , 0
         , PORCENTAJE_PROPIEDAD
         ,'''||USUARIO||'''
         , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
         , NULL, NULL, NULL, NULL, 0
         , '||V_ESQUEMA||'.S_BIE_PER.NEXTVAL
    FROM (SELECT D.BIE_ID, b.PER_ID, max(a.PORCENTAJE_PROPIEDAD) PORCENTAJE_PROPIEDAD
          FROM '||V_ESQUEMA||'.MIG_BIENES_PERSONAS a ,'||V_ESQUEMA||'.MIG_BIE_TMP_PER_ID  b, '||V_ESQUEMA||'.PER_PERSONAS C, '||V_ESQUEMA||'.BIE_BIEN D
          WHERE B.CD_BIEN = D.BIE_CODIGO_EXTERNO
            AND B.CD_BIEN = A.CD_BIEN
            AND B.PER_ID=C.PER_ID
          GROUP BY D.BIE_ID, b.PER_ID');
    

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_PER Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_PER COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_PER Analizada');

    --------------------
    --  D_REGISTRALES --
    --------------------
    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES
        (BIE_DREG_ID
        ,BIE_ID
        ,BIE_DREG_REFERENCIA_CATASTRAL
        ,BIE_DREG_SUPERFICIE
        ,BIE_DREG_SUPERFICIE_CONSTRUIDA
        ,BIE_DREG_TOMO
        ,BIE_DREG_LIBRO
        ,BIE_DREG_FOLIO
        ,BIE_DREG_INSCRIPCION
        ,BIE_DREG_FECHA_INSCRIPCION
        ,BIE_DREG_NUM_REGISTRO
        ,BIE_DREG_MUNICIPIO_LIBRO
        ,BIE_DREG_CODIGO_REGISTRO
        ,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO
        ,BIE_DREG_NUM_FINCA
        )  
        SELECT '||V_ESQUEMA||'.S_BIE_DATOS_REGISTRALES.NEXTVAL
             , BIE.BIE_ID
             , DREG.REFERENCIA_CATASTRAL
             , DREG.SUPERFICIE
             , DREG.SUPERFICIE_CONSTRUIDA
             , DREG.TOMO
             , DREG.LIBRO
             , DREG.FOLIO
             , todos.INSCRIPCION
             , todos.FECHA_INSCRIPCION
             , DREG.NUMERO_REGISTRO
             , DREG.MUNICIPIO_LIBRO
             , DREG.CODIGO_POSTAL 
             , 0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), null, null, null, null, 0
             , DREG.NUMERO_FINCA 
          FROM '||V_ESQUEMA||'.MIG_BIENES   DREG
             , '||V_ESQUEMA||'.BIE_BIEN     BIE
             , (SELECT GUI.CD_BIEN
                     , VAL.INSCRIPCION
                     , VAL.FECHA_INSCRIPCION
                  FROM '||V_ESQUEMA||'.MIG_TMP_PRB_ADJ01              GUI
                     , '||V_ESQUEMA||'.MIG_BIENES_ACTIVOS_ADJUDICADOS VAL
                 WHERE GUI.CD_BIEN = VAL.CD_BIEN
               UNION ALL     
                SELECT prb.cd_bien
                     , prb.INSCRIPCION
                     , prb.FECHA_INSCRIPCION
                    FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES prb
                       , (select cd_bien, 
                                 max(cd_procedimiento) cd_prc 
                            from '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES 
                           group by cd_bien ) prc
                   WHERE prb.cd_bien = prc.cd_bien 
                     AND prb.cd_procedimiento = prc.cd_prc
               ) TODOS
         WHERE BIE.BIE_CODIGO_EXTERNO = DREG.CD_BIEN(+)
           AND BIE.BIE_CODIGO_EXTERNO = TODOS.CD_BIEN(+)');
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_DATOS_REGISTRALES Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_DATOS_REGISTRALES Analizada');


    --------------------
    --  LOCALIZACION  --
    --------------------
    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.BIE_LOCALIZACION
           ( BIE_LOC_ID
            ,BIE_ID
            ,BIE_LOC_POBLACION
            ,BIE_LOC_DIRECCION
            ,BIE_LOC_COD_POST
            ,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO
            ,DD_PRV_ID
           )
      SELECT '||V_ESQUEMA||'.S_BIE_LOCALIZACION.NEXTVAL
            , BIE.BIE_ID
            , POBLACION
            , DIRECCION
            , CODIGO_POSTAL
            , 0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), null, null, null, null, 0
            , PRV.DD_PRV_ID
      FROM '||V_ESQUEMA||'.MIG_BIENES           LOC 
         , '||V_ESQUEMA||'.BIE_BIEN             BIE
         , '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA  PRV
     WHERE BIE.BIE_CODIGO_EXTERNO = LOC.CD_BIEN(+) 
       AND substr(LOC.CODIGO_POSTAL,1,2) = PRV.DD_PRV_CODIGO(+)');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_LOCALIZACION Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_LOCALIZACION COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_LOCALIZACION Analizada');
    
    

    --------------------
    --  VALORACIONES  --
    --------------------
    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.BIE_VALORACIONES
    ( BIE_VAL_ID
    , BIE_ID
    , BIE_FECHA_VALOR_SUBJETIVO
    , BIE_IMPORTE_VALOR_SUBJETIVO
    , BIE_FECHA_VALOR_APRECIACION
    , BIE_IMPORTE_VALOR_APRECIACION
    , BIE_FECHA_VALOR_TASACION
    , BIE_IMPORTE_VALOR_TASACION
    , VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO
    , BIE_RESPUESTA_CONSULTA
    , BIE_VALOR_TASACION_EXT
    , BIE_F_TAS_EXTERNA
    , DD_TRA_ID
    , BIE_F_SOL_TASACION
    )
    SELECT '||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL
         , bie.BIE_ID
         , null --BIE_FECHA_VALOR_SUBJETIVO
         , null --BIE_IMPORTE_VALOR_SUBJETIVO
         , null --BIE_FECHA_VALOR_APRECIACION
         , null --BIE_IMPORTE_VALOR_APRECIACION
         , todos.FECHA_ULTIMA_TASACION
         , todos.VALOR_TASACION
         , 0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), null, null, null, null, 0
         , null --BIE_RESPUESTA_CONSULTA
         , null ---BIE_VALOR_TASACION_EXT
         , null --BIE_F_TAS_EXTERNA
         , todos.DD_TRA_ID
         , todos.FECHA_SOLICITUD_ULT_TASACION
    FROM   
   (
    --** Bienes-Adjudicados
    --
    SELECT GUI.CD_BIEN
         , VAL.FECHA_ULTIMA_TASACION
         , VAL.VALOR_TASACION
         , TAS.DD_TRA_ID
         , VAL.FECHA_SOLICITUD_ULT_TASACION
      FROM '||V_ESQUEMA||'.MIG_TMP_PRB_ADJ01               GUI
         , '||V_ESQUEMA||'.MIG_BIENES_ACTIVOS_ADJUDICADOS  VAL
         , '||V_ESQUEMA||'.DD_TRA_TASADORA                 TAS
     WHERE GUI.CD_BIEN = VAL.CD_BIEN
       AND VAL.TASADORA = TAS.DD_TRA_CODIGO(+)
    --
    UNION ALL
    --
    --** Procedimientos-Bienes (procedimiento mas reciente)
    -- 
    SELECT prb.cd_bien
         , prb.FECHA_ULTIMA_TASACION
         , prb.VALOR_TASACION
         , TAS.DD_TRA_ID
         , prb.FECHA_SOLICITUD_ULT_TASACION
        FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES      prb
           , (select cd_bien, 
                     max(cd_procedimiento) cd_prc 
                from '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES 
               group by cd_bien )                           prc
           , '||V_ESQUEMA||'.DD_TRA_TASADORA TAS
       WHERE prb.cd_bien = prc.cd_bien 
         AND prb.cd_procedimiento = prc.cd_prc
         AND prb.tasadora = tas.dd_tra_codigo(+)
    ) TODOS,
    '||V_ESQUEMA||'.BIE_BIEN BIE
    WHERE BIE.BIE_CODIGO_EXTERNO = TODOS.CD_BIEN(+)');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_VALORACIONES Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_VALORACIONES COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_VALORACIONES Analizada');
    
    
    ---------------------
    --  BIE_ADICIONAL  --
    ---------------------
    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.BIE_ADICIONAL
    (BIE_ADI_ID, BIE_ID, DD_TPB_ID, DD_TPN_ID
    ,VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO,BIE_ADI_DEUDA_SEGUN_JUZ)
    SELECT '||V_ESQUEMA||'.S_BIE_ADICIONAL.NEXTVAL
         , BIE.BIE_ID
         , BIE.DD_TBI_ID
         , TPN.DD_TPN_ID
         , 0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), null, null, null, null, 0, PSLB.DEUDA_SEGUN_JUZ
      FROM '||V_ESQUEMA||'.BIE_BIEN BIE
         , (select cd_bien,tipo_bienbk,tipo_inmueblebk 
            from '||V_ESQUEMA||'.MIG_BIENES
            union
            select cd_bien,tipo_bienbk,tipo_inmueblebk 
            from '||V_ESQUEMA||'.MIG_BIENES_ACTIVOS_ADJUDICADOS
           ) MIG
	 , MIG_PROCS_SUBASTAS_LOTES_BIEN PSLB
         , '||V_ESQUEMA||'.DD_TPN_TIPO_INMUEBLE TPN
     WHERE BIE.BIE_CODIGO_EXTERNO = MIG.CD_BIEN(+)
       AND BIE.BIE_CODIGO_EXTERNO = PSLB.CD_BIEN(+)
       AND MIG.TIPO_BIENBK||MIG.TIPO_INMUEBLEBK = TPN.DD_TPN_CODIGO(+)');
      
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_ADICIONAL Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_ADICIONAL COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIE_ADICIONAL Analizada');
    
    
    -- Borrado temporal
    EXECUTE IMMEDIATE('DROP TABLE '||V_ESQUEMA||'.MIG_TMP_PRB_ADJ01');
    
    
    

    ------  FIN DE LA MIGRACION DE LAS INTERFACES DE BIENES.
    ----------------------------------------------------------
          
*/

    -------------------------
    --TEMPORAL DE CONTRATOS:
    -------------------------
    existe := 0;
    v_sql:= 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG_TMP_CNT_ID'' AND OWNER = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe>0) THEN
       EXECUTE IMMEDIATE('DROP TABLE '||V_ESQUEMA||'.MIG_TMP_CNT_ID');
    END IF;


    v_sql:= 'CREATE TABLE '||V_ESQUEMA||'.MIG_TMP_CNT_ID AS 
          SELECT DISTINCT PRO.CD_PROCEDIMIENTO
                        , PRO.CODIGO_ENTIDAD
                        , PRO.NUMERO_CONTRATO AS CONTRATO
                        , CNT.CNT_ID 
          FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_OPERACIONES PRO
          LEFT JOIN  '||V_ESQUEMA||'.CNT_CONTRATOS CNT 
                 ON (PRO.NUMERO_CONTRATO = CNT.CNT_CONTRATO)
        UNION
          SELECT DISTINCT PRO.CD_CONCURSO  CD_PROCEDIMIENTO
                        , PRO.CODIGO_PROPIETARIO CODIGO_ENTIDAD   --> Los concursos son todos de CAJAMAR? Entidad 0240?
                        , PRO.NUMERO_CONTRATO AS CONTRATO
                        , CNT.CNT_ID
          FROM '||V_ESQUEMA||'.MIG_CONCURSOS_OPERACIONES PRO
          LEFT JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT 
                 ON (PRO.NUMERO_CONTRATO = CNT.CNT_CONTRATO)
          ORDER BY 1,4';

    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_TMP_CNT_ID Creada. '||SQL%ROWCOUNT||' Filas.');

    existe := 0;
    v_sql:= 'SELECT COUNT(*) FROM all_constraints WHERE constraint_name = ''UK_MIG_TMP_CNT_ID'' AND OWNER = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('alter table '||V_ESQUEMA||'.MIG_TMP_CNT_ID add constraint UK_MIG_TMP_CNT_ID unique(CD_PROCEDIMIENTO,CONTRATO,CNT_ID) using index ');
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' índice UK_MIG_TMP_CNT_ID creado.');
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_TMP_CNT_ID COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_TMP_CNT_ID Analizada');


    -------------------------
    --TEMPORAL DE PERSONAS:
    -------------------------

    existe := 0;
    v_sql:= 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG_TMP_PER_ID'' AND OWNER = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe>0) THEN
       EXECUTE IMMEDIATE('DROP TABLE '||V_ESQUEMA||'.MIG_TMP_PER_ID');
    END IF;

    v_sql:= 'CREATE TABLE '||V_ESQUEMA||'.MIG_TMP_PER_ID AS
             SELECT DISTINCT PRD.CD_PROCEDIMIENTO
                           , PRD.CODIGO_ENTIDAD
                           , PRD.CODIGO_PROPIETARIO
                           , PRD.CODIGO_PERSONA
                           , PER.PER_ID 
             FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_DEMANDADOS PRD 
                LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER 
                    ON ( PRD.CODIGO_PERSONA = PER.PER_COD_CLIENTE_ENTIDAD)';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_TMP_PER_ID Creada. '||SQL%ROWCOUNT||' Filas.');
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_TMP_PER_ID COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_TMP_PER_ID Analizada');



    -------------
    -- CLIENTES:
    -------------

    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.CLI_CLIENTES 
                              (
                                  CLI_ID
                                , PER_ID
                                , ARQ_ID
                                , DD_EST_ID
                                , CLI_FECHA_EST_ID
                                , CLI_PROCESS_BPM
                                , VERSION
                                , USUARIOCREAR
                                , FECHACREAR
                                , USUARIOMODIFICAR
                                , FECHAMODIFICAR
                                , USUARIOBORRAR
                                , FECHABORRAR
                                , BORRADO
                                , PTE_ID
                                , CLI_FECHA_CREACION
                                , DD_ECL_ID
                                , CLI_TELECOBRO
                                , CLI_FECHA_GV
                                , OFI_ID
                              )
                       SELECT '||V_ESQUEMA||'.S_CLI_CLIENTES.NEXTVAL as CLI_ID 
                                , PER_ID
                                , ARQ_ID --> GMN: ARQUETIPO asignado por defecto 
                                , 1 as DD_EST_ID
                                , PER_FECHA_EXTRACCION as CLI_FECHA_EST_ID
                                , null as CLI_PROCESS_BPM
                                , 0  as VERSION
                                , '''||USUARIO||''' as USUARIOCREAR
                                , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR
                                , null as USUARIOMODIFICAR
                                , null as FECHABORRAR
                                , '''||USUARIO||''' as USUARIOBORRAR
                                , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHABORRAR     
                                , 1    as BORRADO
                                , null as PTE_ID
                                , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as CLI_FECHA_CREACION
                                , 3    as DD_ECL_ID
                                , 0    as CLI_TELECOBRO
                                , null as CLI_FECHA_GV
                                , OFI_ID 
                       FROM  (
                               SELECT DISTINCT TPI.PER_ID
                                             , PER.PER_FECHA_EXTRACCION
                                             , PER.OFI_ID 
                                             , ARQ.ARQ_ID
                               FROM '||V_ESQUEMA||'.MIG_TMP_PER_ID TPI
                                  , '||V_ESQUEMA||'.PER_PERSONAS PER
                                  , (SELECT ARQ_ID FROM '||V_ESQUEMA||'.ARQ_ARQUETIPOS WHERE ARQ_NOMBRE = ''Migracion''  AND BORRADO = 1) ARQ
                               WHERE TPI.PER_ID IS NOT NULL
                                 AND TPI.PER_ID = PER.PER_ID
                              )'
                    );
    --23.165 filas insertadas.

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' CLI_CLIENTES Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.CLI_CLIENTES COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' CLI_CLIENTES Analizada');



    ---------------------
    --CONTRATOS_CLIENTE:
    ---------------------

    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE 
                         (
                           CCL_ID, CNT_ID, CLI_ID, CCL_PASE, VERSION, USUARIOCREAR, FECHACREAR, 
                           USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO
                        )
                       SELECT '||V_ESQUEMA||'.S_CCL_CONTRATOS_CLIENTE.NEXTVAL,
                               CNT_ID, CLI_ID, 1,
                               0, '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), null, null, null, null, 0
                       FROM(
                             SELECT DISTINCT TMP_CNT.CNT_ID, CLI.CLI_ID
                             FROM '||V_ESQUEMA||'.MIG_TMP_PER_ID TMP_PER
                                , '||V_ESQUEMA||'.MIG_TMP_CNT_ID TMP_CNT
                                , '||V_ESQUEMA||'.CLI_CLIENTES CLI
                             WHERE TMP_PER.CD_PROCEDIMIENTO = TMP_CNT.CD_PROCEDIMIENTO 
                               AND TMP_PER.PER_ID IS NOT NULL
                               AND TMP_CNT.CNT_ID IS NOT NULL
                               AND TMP_PER.PER_ID = CLI.PER_ID
                           )'
                     ); 
    
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' CCL_CONTRATOS_CLIENTE Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' CCL_CONTRATOS_CLIENTE Analizada');


    -----------------
    -- EXPEDIENTES:
    -----------------

    --OJO. VAMOS A MANTENER LA RELACION 1 EXP--> 1 ASUNTO--> 1 PROC. NECESITAMOS LA COLUMNA TEMPORAL CD_PROCEDIMIENTO EN EXPEDIENTES PARA MIGRAR OS ASUNTOS.
    existe := 0;
    v_sql:= 'Select count(*) from all_tab_columns where table_name=''EXP_EXPEDIENTES'' and column_name=''CD_PROCEDIMIENTO'' and owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('ALTER TABLE '||V_ESQUEMA||'.EXP_EXPEDIENTES ADD CD_PROCEDIMIENTO NUMBER');
    END IF;

    --
    
    
    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.EXP_EXPEDIENTES 
          (
             EXP_ID
           , AAA_ID
           , DCO_ID
           , DD_EST_ID
           , EXP_FECHA_EST_ID
           , OFI_ID
           , ARQ_ID
           , COM_ID
           , EXP_PROCESS_BPM
           , EXP_MANUAL
           , VERSION
           , USUARIOCREAR
           , FECHACREAR
           , USUARIOMODIFICAR
           , FECHAMODIFICAR
           , USUARIOBORRAR
           , FECHABORRAR
           , BORRADO
           , DD_EEX_ID
           , EXP_DESCRIPCION
           , DD_TPX_ID
           , CD_EXPEDIENTE_NUSE
           , NUMERO_EXP_NUSE
           , CD_PROCEDIMIENTO
           , SYS_GUID
           )        
    SELECT '||V_ESQUEMA||'.S_EXP_EXPEDIENTES.NEXTVAL as EXP_ID
           , null as AAA_ID
           , null as DCO_ID
           , 5 as DD_EST_ID
           , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as EXP_FECHA_EST_ID
           , 10417 as OFI_ID
           , ARQ_ID 
           , null  as COM_ID           
           , null  as EXP_PROCESS_BPM
           , 0 as EXP_MANUAL
           , 0 as VERSION
           , '''||USUARIO||''' as USUARIOCREAR
           , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR
           , null as USUARIOMODIFICAR
           , null as FECHAMODIFICAR
           , null as USUARIOBORRAR
           , null as FECHABORRAR
           , 0    as BORRADO
           , 4    as DD_EEX_ID
           , null as EXP_DESCRIPCION
           , (select dd_TPX_ID from '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE where DD_TPX_CODIGO = ''RECU'') as DD_TPX_ID
           , PRC.CD_EXPEDIENTE_NUSE
           , PRC.NUMERO_EXP_NUSE
           , PRC.CD_PROCEDIMIENTO
           , SYS_GUID() as SYS_GUID               
      FROM 
      	(        
        SELECT CD_PROCEDIMIENTO, CD_EXPEDIENTE_NUSE , NUMERO_EXP_NUSE FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA            	
      UNION
    	  SELECT CD_CONCURSO CD_PROCEDIMIENTO, NULL CD_EXPEDIENTE_NUSE , NULL NUMERO_EXP_NUSE FROM '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA
    	) PRC
    	, (SELECT DISTINCT CD_PROCEDIMIENTO FROM MIG_MAESTRA_HITOS) MAE
        , (SELECT ARQ_ID FROM '||V_ESQUEMA||'.ARQ_ARQUETIPOS WHERE ARQ_NOMBRE = ''Migracion''  AND BORRADO = 1) ARQ             	
     WHERE MAE.CD_PROCEDIMIENTO = PRC.CD_PROCEDIMIENTO');

    -- 23.316 filas insertadas. <-- 1 CD_PROCEDIMIENTO = 1 EXPEDIENTE. Las mismas que el count distinct cd_procedimiento de mig_maestra_hitos
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' EXP_EXPEDIENTES Cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    ------------------------
    --  PERSONAS_EXPEDIENTE:
    ------------------------    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MIG_TMP_PER_ID'' and table_name=''MIG_TMP_PER_ID'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_TMP_PER_ID ON '||V_ESQUEMA||'.MIG_TMP_PER_ID(CD_PROCEDIMIENTO, CODIGO_PERSONA) ');
    END IF;
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MIG_PROCEDIMIENTOS_DEMAND'' and table_name=''MIG_PROCEDIMIENTOS_DEMANDADOS'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_PROCEDIMIENTOS_DEMAND ON '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_DEMANDADOS(CD_PROCEDIMIENTO, CODIGO_PERSONA) ');
    END IF;
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_EXP_MIGRAR_TIRAR'' and table_name=''EXP_EXPEDIENTES'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_EXP_MIGRAR_TIRAR ON '||V_ESQUEMA||'.EXP_EXPEDIENTES(CD_EXPEDIENTE_NUSE, CD_PROCEDIMIENTO) ');
    END IF;
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_PROC_CAB_1'' and table_name=''MIG_PROCEDIMIENTOS_CABECERA'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_PROC_CAB_1 ON '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA(CD_EXPEDIENTE_NUSE, CD_PROCEDIMIENTO) ');
    END IF;
    

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Indices de EXPEDIENTES creados');
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.EXP_EXPEDIENTES COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' EXP_EXPEDIENTES Analizada');
    
    
    
    -----------------------------
    --  PEX_PERSONAS_EXPEDIENTE
    -----------------------------

    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE 
                               (
                                   PEX_ID
                                 , PER_ID
                                 , EXP_ID
                                 , DD_AEX_ID
                                 , PEX_PASE
                                 , VERSION
                                 , USUARIOCREAR
                                 , FECHACREAR
                                 , USUARIOMODIFICAR
                                 , FECHAMODIFICAR
                                 , USUARIOBORRAR
                                 , FECHABORRAR
                                 , BORRADO
                               ) 
                        SELECT  '||V_ESQUEMA||'.S_PEX_PERSONAS_EXPEDIENTE.NEXTVAL as PEX_ID
                                 , PER_ID
                                 , EXP_ID
                                 , 9 as DD_AEX_ID
                                 , null as PEX_PASE
                                 , 0 as VERSION
                                 , '''||USUARIO||''' as USUARIOCREAR
                                 , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR
                                 , null as USUARIOMODIFICAR
                                 , null as FECHAMODIFICAR
                                 , null as USUARIOBORRAR
                                 , null as FECHABORRAR
                                 , 0    as BORRADO
                        FROM(
                               SELECT DISTINCT TPI.PER_ID, EXP.EXP_ID
                               FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP
                                  , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA PRC
                                  , '||V_ESQUEMA||'.MIG_TMP_PER_ID TPI
                                  , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_DEMANDADOS PRD
                               WHERE TPI.PER_ID IS NOT NULL
                                 AND EXP.CD_EXPEDIENTE_NUSE IS NOT NULL
                                 AND EXP.USUARIOCREAR = '''||USUARIO||'''
                                 AND EXP.CD_EXPEDIENTE_NUSE = PRC.CD_EXPEDIENTE_NUSE 
                                 AND PRC.CD_PROCEDIMIENTO = TPI.CD_PROCEDIMIENTO
                                 AND PRC.CD_PROCEDIMIENTO = PRD.CD_PROCEDIMIENTO
                                 AND PRD.CODIGO_PERSONA = TPI.CODIGO_PERSONA 
                           UNION
                               SELECT DISTINCT PER.PER_ID, EXP.EXP_ID
                               FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP
                                  , '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA CON
                                  , '||V_ESQUEMA||'.PER_PERSONAS PER
                               WHERE EXP.CD_PROCEDIMIENTO = CON.CD_CONCURSO
                                 AND EXP.USUARIOCREAR = '''||USUARIO||'''
                                 AND CON.NIF = PER.PER_DOC_ID
                           )'
                     );
    

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' PEX_PERSONAS_EXPEDIENTE cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' PEX_PERSONAS_EXPEDIENTE Analizada');
    EXECUTE IMMEDIATE('DROP INDEX IDX_EXP_MIGRAR_TIRAR');



    -------------------------------
    --   CONTRATOS_EXPEDIENTE:
    -------------------------------
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MIG_OP_1'' and table_name=''MIG_PROCEDIMIENTOS_OPERACIONES'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_OP_1 ON '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_OPERACIONES(LPAD(TO_CHAR(CODIGO_PROPIETARIO),5,''0'')||LPAD(TIPO_PRODUCTO,5,''0'')||LPAD(NUMERO_CONTRATO,17,''0'')||LPAD(TO_CHAR(NUMERO_ESPEC),15,''0'')) ');
    END IF;
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MIG_OP_2'' and table_name=''MIG_CONCURSOS_OPERACIONES'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_OP_2 ON '||V_ESQUEMA||'.MIG_CONCURSOS_OPERACIONES(LPAD(TO_CHAR(CODIGO_PROPIETARIO),5,''0'')||LPAD(TIPO_PRODUCTO,5,''0'')||LPAD(NUMERO_CONTRATO,17,''0'')||LPAD(TO_CHAR(NUMERO_ESPEC),15,''0'')) ');
    END IF;


    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_OPERACIONES COMPUTE STATISTICS for all indexes');
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_CONCURSOS_OPERACIONES COMPUTE STATISTICS for all indexes');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Indices para contratos en MIGs Creados');


    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE 
                         (
                           CEX_ID
                         , CNT_ID
                         , EXP_ID
                         , CEX_PASE
                         , CEX_SIN_ACTUACION
                         , VERSION
                         , USUARIOCREAR
                         , FECHACREAR
                         , USUARIOMODIFICAR
                         , FECHAMODIFICAR
                         , USUARIOBORRAR
                         , FECHABORRAR
                         , BORRADO
                         , DD_AEX_ID
                         , SYS_GUID
                         )
                   SELECT  '||V_ESQUEMA||'.S_CEX_CONTRATOS_EXPEDIENTE.NEXTVAL as  CEX_ID
                         , CNT_ID 
                         , EXP_ID
                         , 1 as CEX_PASE
                         , 0 as CEX_SIN_ACTUACION
                         , 0 as VERSION
                         , '''||USUARIO||''' as USUARIOCREAR
                         , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR
                         , null as USUARIOMODIFICAR
                         , null as FECHAMODIFICAR
                         , null as USUARIOBORRAR
                         , null as FECHABORRAR
                         , 0    as BORRADO
                         , 9    as DD_AEX_ID
                         , SYS_GUID() as SYS_GUID                         
                   FROM(
                         SELECT DISTINCT TCI.CNT_ID, EXP.EXP_ID
                         FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP
                            , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA PRC
                            , '||V_ESQUEMA||'.MIG_TMP_CNT_ID TCI
                            , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_OPERACIONES PRO
                         WHERE TCI.CNT_ID IS NOT NULL
                           AND EXP.CD_EXPEDIENTE_NUSE IS NOT NULL
                           AND EXP.CD_EXPEDIENTE_NUSE = PRC.CD_EXPEDIENTE_NUSE
                           AND EXP.CD_PROCEDIMIENTO   = PRC.CD_PROCEDIMIENTO 
                           AND PRC.CD_PROCEDIMIENTO   = TCI.CD_PROCEDIMIENTO
                           AND PRC.CD_PROCEDIMIENTO   = PRO.CD_PROCEDIMIENTO
                           AND PRO.NUMERO_CONTRATO    = TCI.CONTRATO 
                       UNION
                         SELECT DISTINCT TCI.CNT_ID, EXP.EXP_ID
                         FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP
                            , '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA PRC
                            , '||V_ESQUEMA||'.MIG_TMP_CNT_ID TCI
                            , '||V_ESQUEMA||'.MIG_CONCURSOS_OPERACIONES PRO
                         WHERE TCI.CNT_ID IS NOT NULL
                           AND EXP.CD_PROCEDIMIENTO IS NOT NULL
                           AND EXP.CD_PROCEDIMIENTO = PRC.CD_CONCURSO 
                           AND PRC.CD_CONCURSO      = TCI.CD_PROCEDIMIENTO
                           AND PRC.CD_CONCURSO      = PRO.CD_CONCURSO
                           AND PRO.NUMERO_CONTRATO  = TCI.CONTRATO 
                         )'
                    );
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  CEX_CONTRATOS_EXPEDIENTE cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  CEX_CONTRATOS_EXPEDIENTE Analizada');


   ---------------
   --   ASUNTOS:
   ---------------
   
    EXECUTE IMMEDIATE (' INSERT INTO '||V_ESQUEMA||'.ASU_ASUNTOS 
     ( 
       ASU_ID
     , GAS_ID
     , DD_EST_ID
     , ASU_FECHA_EST_ID
     , ASU_PROCESS_BPM
     , ASU_NOMBRE
     , EXP_ID
     , VERSION
     , USUARIOCREAR
     , FECHACREAR
     , USUARIOMODIFICAR
     , FECHAMODIFICAR
     , USUARIOBORRAR
     , FECHABORRAR
     , BORRADO
     , DD_EAS_ID
     , ASU_ASU_ID
     , ASU_OBSERVACION
     , SUP_ID
     , SUP_COM_ID
     , COM_ID
     , DCO_ID
     , ASU_FECHA_RECEP_DOC
     , USD_ID
     , DTYPE
     , DD_UCL_ID
     , REF_ASESORIA
     , LOTE
     , DD_TAS_ID
     , ASU_ID_EXTERNO
     , DD_PAS_ID
     , DD_GES_ID
     , SYS_GUID     
     )
    SELECT '||V_ESQUEMA||'.S_ASU_ASUNTOS.NEXTVAL as  ASU_ID
           , null as GAS_ID
           , 6 as DD_EST_ID
           , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as ASU_FECHA_EST_ID
           , null as ASU_PROCESS_BPM
           , CAB.NOMBRE_ASUNTO as ASU_NOMBRE
           , EXP.EXP_ID
           , 0 as EXP_ID
           , '''||USUARIO||''' as USUARIOCREAR
           , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR
           , null as USUARIOMODIFICAR
           , null as FECHAMODIFICAR
           , null as USUARIOBORRAR
           , null as FECHABORRAR
           , 0 as BORRADO
           , 3 as DD_EAS_ID  --> estado asunto Aceptado
           , null as ASU_ASU_ID
           , null as ASU_OBSERVACION
           , null as SUP_ID
           , null as SUP_COM_ID
           , null as COM_ID
           , null as DCO_ID
           , null as ASU_FECHA_RECEP_DOC
           , null as USD_ID
           , ''EXTAsunto''  as DTYPE
           , null as DD_UCL_ID
           , null as REF_ASESORIA
           , null as LOTE
           , CAB.DD_TAS_ID as DD_TAS_ID 
           , HIT.CD_PROCEDIMIENTO as ASU_ID_EXTERNO
           , PAS.DD_PAS_ID as DD_PAS_ID
           , GES.DD_GES_ID as DD_GES_ID
           , SYS_GUID() as SYS_GUID           
    FROM (SELECT DISTINCT CD_PROCEDIMIENTO FROM '||V_ESQUEMA||'.MIG_MAESTRA_HITOS ) HIT, 
         (SELECT PCAB.CD_PROCEDIMIENTO
               ,  substr(max (cnt.cnt_contrato || '' | '' || per_doc_id || '' '' || per_nom50),1,50) AS NOMBRE_ASUNTO
               ,  (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'') AS DD_TAS_ID
               ,  PCAB.ENTIDAD_PROPIETARIA
               ,  PCAB.GESTION_PLATAFORMA
            from '||V_ESQUEMA||'.mig_procedimientos_cabecera pcab 
               left join '||V_ESQUEMA||'.mig_procedimientos_demandados pdem 
                      on pdem.CD_PROCEDIMIENTO = pcab.CD_PROCEDIMIENTO
               left join '||V_ESQUEMA||'.per_personas per 
                      on per.per_cod_cliente_entidad = pdem.CODIGO_PERSONA
               left join '||V_ESQUEMA||'.cpe_contratos_personas cpe
                      on per.per_id = cpe.per_id
               left join '||V_ESQUEMA||'.cnt_contratos cnt
                      on cpe.cnt_id = cnt.cnt_id                                  
             GROUP BY PCAB.CD_PROCEDIMIENTO, PCAB.ENTIDAD_PROPIETARIA, PCAB.GESTION_PLATAFORMA
          UNION
          SELECT CD_CONCURSO AS CD_PROCEDIMIENTO
               , substr(max(cnt.cnt_contrato || '' | '' || nif || '' '' || per_nom50),1,50) AS NOMBRE_ASUNTO
               , (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Concursal'') AS DD_TAS_ID
               , ENTIDAD_PROPIETARIA
               , GESTION_PLATAFORMA
            from '||V_ESQUEMA||'.mig_concursos_cabecera 
               left join  '||V_ESQUEMA||'.per_personas per 
                      on per.per_doc_id = nif
               left join '||V_ESQUEMA||'.cpe_contratos_personas cpe
                      on per.per_id = cpe.per_id
               left join '||V_ESQUEMA||'.cnt_contratos cnt
                      on cpe.cnt_id = cnt.cnt_id                              
             GROUP BY CD_CONCURSO,ENTIDAD_PROPIETARIA, GESTION_PLATAFORMA
          ) CAB,        
          '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP,
          '||V_ESQUEMA||'.DD_GES_GESTION_ASUNTO GES,
          '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO PAS
    WHERE EXP.CD_PROCEDIMIENTO = HIT.CD_PROCEDIMIENTO
    AND EXP.CD_PROCEDIMIENTO = CAB.CD_PROCEDIMIENTO
    AND CASE WHEN CAB.DD_TAS_ID = 1 THEN 
                 decode(CAB.GESTION_PLATAFORMA,''N'',''HAYA'',''S'',''HAYA'') 
             ELSE
                 decode(CAB.GESTION_PLATAFORMA,''N'',''CAJAMAR'',''S'',''CAJAMAR'')              
         END = GES.DD_GES_CODIGO                       
    AND decode(CAB.ENTIDAD_PROPIETARIA,''0240'',''CAJAMAR'',''05074'',''SAREB'') = PAS.DD_PAS_CODIGO');  
    
-- 23.316 Asuntos cargados.
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  ASU_ASUNTOS cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ASU_ASUNTOS COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  ASU_ASUNTOS Analizada');
    
    EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.asu_asuntos asuc 
                          set asuc.fechacrear = (select nvl(fecha_publicacion_boe, TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')) 
                                                 from '||V_ESQUEMA||'.mig_concursos_cabecera 
                                                 where cd_concurso = asuc.asu_id_externo)
                       where exists (select 1 from '||V_ESQUEMA_MASTER||'.dd_tas_tipos_asunto tas1 
                                     where tas1.dd_tas_id = asuc.dd_tas_id 
                                     and tas1.dd_tas_codigo = ''02'')');

-- updateados 7.931 registros 
                                     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  ASU_ASUNTOS.FechaCrear cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


    --------------------
    --  PROCEDIMIENTOS
    --------------------
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MAE_COMPUESTO'' and table_name=''MIG_MAESTRA_HITOS'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MAE_COMPUESTO ON '||V_ESQUEMA||'.MIG_MAESTRA_HITOS(CD_PROCEDIMIENTO, PRC_ID, PRC_PRC_ID, DD_TPO_CODIGO)');
    END IF;
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MAE_PRC'' and table_name=''MIG_MAESTRA_HITOS'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE(' create index idx_mae_prc on '||V_ESQUEMA||'.MIG_MAESTRA_HITOS (PRC_ID)');
    END IF;

    EXECUTE IMMEDIATE('analyze table '||V_ESQUEMA||'.MIG_MAESTRA_HITOS compute statistics');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - índice IDX_MAE_COMPUESTO creado y MIG_MAESTRA_HITOS analizada');
   
    
    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS 
       ( 
          PRC_ID
        , ASU_ID
        , DD_TAC_ID
        , DD_TRE_ID
        , DD_TPO_ID
        , PRC_PORCENTAJE_RECUPERACION
        , PRC_PLAZO_RECUPERACION
        , PRC_SALDO_ORIGINAL_VENCIDO
        , PRC_SALDO_ORIGINAL_NO_VENCIDO
        , PRC_SALDO_RECUPERACION
        , VERSION
        , USUARIOCREAR
        , FECHACREAR
        , USUARIOMODIFICAR
        , FECHAMODIFICAR
        , USUARIOBORRAR
        , FECHABORRAR
        , BORRADO
        , PRC_PRC_ID
        , DD_JUZ_ID
        , PRC_COD_PROC_EN_JUZGADO
        , PRC_DECIDIDO
        , PRC_PROCESS_BPM
        , PRC_DOC_FECHA
        , PRC_DOC_OBSERVACIONES
        , DD_EPR_ID
        , ITE_ID, DTYPE
        , TIPO_PROC_ORIGINAL
        , PRC_PARALIZADO
        , PRC_PLAZO_PARALIZ_MILS
        , PRC_FECHA_PARALIZADO
        , T_REFERENCIA
        , RPR_REFERENCIA
        , SYS_GUID
      )     
SELECT  a.PRC_ID
      , a.ASU_ID
      , a.DD_TAC_ID
      , a.DD_TRE_ID
      , a.DD_TPO_ID
      , a.PRC_PORCENTAJE_RECUPERACION
      , a.PRC_PLAZO_RECUPERACION
      , a.PRC_SALDO_ORIGINAL_VENCIDO
      , a.PRC_SALDO_ORIGINAL_NO_VENCIDO
      , a.PRC_SALDO_RECUPERACION
      , a.VERSION
      , a.USUARIOCREAR
      , a.FECHACREAR
      , a.USUARIOMODIFICAR
      , a.FECHAMODIFICAR
      , a.USUARIOBORRAR
      , a.FECHABORRAR
      , a.BORRADO
      , a.PRC_PRC_ID
      , a.DD_JUZ_ID
      , a.PRC_COD_PROC_EN_JUZGADO
      , a.PRC_DECIDIDO
      , a.PRC_PROCESS_BPM
      , a.PRC_DOC_FECHA
      , a.PRC_DOC_OBSERVACIONES
      , a.DD_EPR_ID
      , a.ITE_ID, DTYPE
      , a.TIPO_PROC_ORIGINAL
      , a.PRC_PARALIZADO
      , a.PRC_PLAZO_PARALIZ_MILS
      , a.PRC_FECHA_PARALIZADO
      , a.T_REFERENCIA
      , a.RPR_REFERENCIA
      , SYS_GUID() as SYS_GUID
FROM (           
   SELECT DISTINCT
              MAE.PRC_ID as PRC_ID
            , ASU.ASU_ID as ASU_ID
            , TPO.DD_TAC_ID  as DD_TAC_ID
            , 1    as DD_TRE_ID
            , TPO.DD_TPO_ID as DD_TPO_ID
            , 100  as PRC_PORCENTAJE_RECUPERACION
            , 18   as PRC_PLAZO_RECUPERACION
            , null as  PRC_SALDO_ORIGINAL_VENCIDO
            , null as PRC_SALDO_ORIGINAL_NO_VENCIDO
            , CAB.IMPORTE_PRINCIPAL as PRC_SALDO_RECUPERACION
            , 0 as VERSION
            , '''||USUARIO||''' as USUARIOCREAR 
            , NVL(CAB.FECHA_PUBLICACION_BOE, TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''))  as FECHACREAR
            , null as USUARIOMODIFICAR
            , null as FECHAMODIFICAR
            , null as USUARIOBORRAR
            , null as FECHABORRAR
            , 0 as BORRADO
            , CASE MAE.PRC_PRC_ID 
                 WHEN 0 then nulL
                 ELSE MAE.PRC_PRC_ID
              END as PRC_PRC_ID
            , DD_JUZ_ID as DD_JUZ_ID
            , CAB.NUM_AUTO_SIN_FORMATO as PRC_COD_PROC_EN_JUZGADO
            , 0 as PRC_DECIDIDO
            , null as PRC_PROCESS_BPM
            , null as PRC_DOC_FECHA
            , null as PRC_DOC_OBSERVACIONES
--GMN si es padre entonces 3 (Aceptado) si es hijo 6 (Derivado)            
--            , decode(MAE.PRC_PRC_ID,0,32,35) as DD_EPR_ID (para cargar en AMAZON)
            , decode(MAE.PRC_PRC_ID,0,3,6) as DD_EPR_ID
            , null as ITE_ID
            , ''MEJProcedimiento'' as DTYPE
            , CASE 
                 WHEN MAE.PRC_PRC_ID = 0 THEN NULL
                 ELSE (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO A WHERE A.DD_TPO_CODIGO IN (SELECT min(DD_TPO_CODIGO) FROM '||V_ESQUEMA||'.MIG_MAESTRA_HITOS B WHERE B.PRC_ID = MAE.PRC_ID AND B.PRC_PRC_ID = MAE.PRC_PRC_ID))
              END AS TIPO_PROC_ORIGINAL
            , 0 as PRC_PARALIZADO
            , null as PRC_PLAZO_PARALIZ_MILS
            , null as PRC_FECHA_PARALIZADO
            , null as T_REFERENCIA
            , null as RPR_REFERENCIA
      FROM (select distinct CD_PROCEDIMIENTO, PRC_ID, PRC_PRC_ID, DD_TPO_CODIGO from  '||V_ESQUEMA||'.MIG_MAESTRA_HITOS Z ) MAE,
           (SELECT DISTINCT CD_PROCEDIMIENTO, null FECHA_PUBLICACION_BOE, JUZGADO, IMPORTE_PRINCIPAL, NUM_AUTO_SIN_FORMATO 
              FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA
            UNION
            SELECT DISTINCT CD_CONCURSO CD_PROCEDIMIENTO, FECHA_PUBLICACION_BOE, JUZGADO, IMPORTE_PRINCIPAL, NUM_AUTO_SIN_FORMATO 
              FROM '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA K 
             WHERE NOT EXISTS(SELECT 1 FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA L WHERE K.CD_CONCURSO = L.CD_PROCEDIMIENTO)
            ) CAB,
--GMN Solo migramos procedimientos abiertos            
--GMN       (SELECT PRC_ID, PRC_PRC_ID, MAX(TAR_TAREA_FINALIZADA) AS PRC_FINALIZADO FROM '||V_ESQUEMA||'.MIG_MAESTRA_HITOS GROUP BY PRC_ID, PRC_PRC_ID) MJ,
            '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP,
            '||V_ESQUEMA||'.ASU_ASUNTOS ASU,
            '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO,
            '||V_ESQUEMA||'.DD_JUZ_JUZGADOS_PLAZA JUZ
      WHERE  ASU.EXP_ID = EXP.EXP_ID
      AND EXP.CD_PROCEDIMIENTO = CAB.CD_PROCEDIMIENTO
      AND CAB.CD_PROCEDIMIENTO = MAE.CD_PROCEDIMIENTO   
      AND TPO.DD_TPO_CODIGO = MAE.DD_TPO_CODIGO 
      AND CAB.JUZGADO = JUZ.DD_JUZ_CODIGO (+)
--GMN      AND MJ.PRC_ID = MAE.PRC_ID
      ORDER BY 1) a');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRC_PROCEDIMIENTOS cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRC_PROCEDIMIENTOS Analizada');

-- 31.373 procedimientos cargados

    --------------
    --  PRC_PER:
    --------------

    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.PRC_PER (PRC_ID,PER_ID,VERSION)  
    SELECT DISTINCT PRC.PRC_ID,
             PEX.PER_ID,         
             0
        FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
       INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS             ASU ON PRC.ASU_ID = ASU.ASU_ID
       INNER JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES         EXP ON ASU.EXP_ID = EXP.EXP_ID
       INNER JOIN '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX ON EXP.EXP_ID = PEX.EXP_ID
       WHERE PRC.USUARIOCREAR = '''||USUARIO||'''');

    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRC_PER cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PRC_PER COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRC_PER Analizada');

-- 51.956 registros cargados
 

    --------------
    --  PRC_CEX:
    --------------

    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.PRC_CEX (PRC_ID,CEX_ID,VERSION)  
      SELECT DISTINCT
             PRC.PRC_ID,
             CEX.CEX_ID,
             0
        FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
       INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS              ASU ON ASU.ASU_ID = PRC.ASU_ID   
       INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID = ASU.EXP_ID
       WHERE PRC.USUARIOCREAR = '''||USUARIO||'''');

    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRC_CEX cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PRC_CEX COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRC_CEX Analizada');
    
--    31.175 registros cargados

   
    -------------------------------
    --  TAR_TAREAS_NOTIFICACIONES
    -------------------------------
       
    
    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES
         (
           TAR_ID
         , ASU_ID
         , TAR_TAR_ID
         , DD_EST_ID
         , DD_EIN_ID
         , DD_STA_ID
         , TAR_CODIGO
         , TAR_TAREA
         , TAR_DESCRIPCION
         , TAR_FECHA_FIN
         , TAR_FECHA_INI
         , TAR_TAREA_FINALIZADA
         , USUARIOCREAR
         , FECHACREAR
         , BORRADO
         , PRC_ID
         , SYS_GUID
         )
        SELECT DISTINCT 
                 MAE.TAR_ID
               , PRC.ASU_ID
               , NULL AS TAR_TAR_ID
               , 6 AS DD_EST_ID --ASUNTO en DD_EST_ESTADOS ITINERARIOS
               , 5 AS DD_EIN_ID ---PROCEDIMIENTO en DD_EIN_ENTIDAD_INFORMACION
               , 39 AS DD_STA_ID ---GESTOR POR DEFECTO (). LUEGO UN PROCESO UPDATEARA A GESTOR/SUPERVISOR 
               , 1 AS TAR_CODIGO
               , MAE.TAR_TAREA
               , MAE.TAR_TAREA as TAR_DESCRIPCION
               , CASE TAR_TAREA_FINALIZADA
                    WHEN 0 THEN NULL
                    WHEN 1 THEN NVL(MAE.TAR_FECHA, TRUNC(SYSDATE))
                 END AS TAR_FECHA_FIN
               , NVL(MAE.TAR_FECHA, TRUNC(SYSDATE)) AS TAR_FECHA_INI
               , MAE.TAR_TAREA_FINALIZADA
               , '''||USUARIO||''' AS USUARIOCREAR
               , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
               , MAE.TAR_TAREA_FINALIZADA AS BORRADO
               , MAE.PRC_ID
               , SYS_GUID() as SYS_GUID               
        FROM '||V_ESQUEMA||'.MIG_MAESTRA_HITOS MAE
           , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
           , '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
           , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO
        WHERE MAE.PRC_ID = PRC.PRC_ID
          AND MAE.TAP_CODIGO = TAP.TAP_CODIGO
          AND MAE.DD_TPO_CODIGO = TPO.DD_TPO_CODIGO
          AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
        ORDER BY 1');
    

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  TAR_TAREAS_NOTIFICACIONES cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  TAR_TAREAS_NOTIFICACIONES Analizada');
    
    -- 112.252 registros cargados
    
    -------------------------------
    --  TEV_TAREA_EXTERNA
    -------------------------------   
    
    
     EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA
         (
            TEX_ID
          , TAR_ID
          , TAP_ID
          , USUARIOCREAR
          , FECHACREAR
          , BORRADO
          , FECHABORRAR
         )
         SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL AS TEX_ID
                , TAR_ID
                , TAP_ID
                , USUARIOCREAR
                , FECHACREAR
                , BORRADO
                , FECHABORRAR
         FROM (
                SELECT DISTINCT 
                   A.TAR_ID
                 , D.TAP_ID
                 , '''||USUARIO||''' AS USUARIOCREAR
                 , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') AS FECHACREAR
                 , A.TAR_TAREA_FINALIZADA AS BORRADO
                 , CASE A.TAR_TAREA_FINALIZADA
                      WHEN 0 THEN NULL
                      WHEN 1 THEN NVL(A.TAR_FECHA, TRUNC(SYSDATE))
                   END AS FECHABORRAR
                FROM '||V_ESQUEMA||'.MIG_MAESTRA_HITOS A
                   , '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES C
                   , '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO D
                   , '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO E
                   , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                WHERE C.TAR_ID = A.TAR_ID
                  AND A.PRC_ID = PRC.PRC_ID
                  AND A.TAP_CODIGO = D.TAP_CODIGO
                  AND D.DD_TPO_ID = E.DD_TPO_ID
                  AND A.DD_TPO_CODIGO = E.DD_TPO_CODIGO
                  AND E.DD_TPO_ID = PRC.DD_TPO_ID
                  ORDER BY 1
                )'
             );

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  TEX_TAREA_EXTERNA cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  TEX_TAREA_EXTERNA Analizada');
    
    
    
    -------------------------------
    --  TEV_TAREA_EXTERNA_VALOR
    -------------------------------   

    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_MAEV_INSERT'' AND OWNER= ''' || V_ESQUEMA || '''') INTO V_COUNT;
    IF V_COUNT = 0 THEN

        EXECUTE IMMEDIATE('CREATE INDEX '||V_ESQUEMA||'.IDX_MAEV_INSERT ON '||V_ESQUEMA||'.MIG_MAESTRA_HITOS_VALORES(TAR_ID,TAP_CODIGO,TEV_NOMBRE)');

    END IF;
  
       
    EXECUTE IMMEDIATE ('INSERT INTO '||V_ESQUEMA ||'.TEV_TAREA_EXTERNA_VALOR
        (
            TEV_ID
          , TEX_ID
          , TEV_NOMBRE
          , TEV_VALOR
          , USUARIOCREAR
          , FECHACREAR
          , DTYPE
        )
        SELECT DISTINCT
            A.TEV_ID
          , B.TEX_ID
          , TEV_NOMBRE
          , CASE WHEN C.TFI_TIPO = ''date''
                    THEN TO_CHAR(TO_DATE(A.TEV_VALOR,''dd-mm-yyyy''),''yyyy-mm-dd'')
                 WHEN C.TFI_BUSINESS_OPERATION IN (''DDSiNo'',''DDPositivoNegativo'',''DDSiNoAllanamiento'')
                    THEN DECODE( A.TEV_VALOR, ''0'', ''02''
                                      , ''1'', ''01''
                                      , ''S'', ''01''
                                      , ''N'', ''02'', A.TEV_VALOR)
                 ELSE REPLACE(A.TEV_VALOR,'','',''.'')
            END as TEV_VALOR
         , '''||USUARIO||'''
         , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
         , ''EXTTareaExternaValor''
        FROM '||V_ESQUEMA ||'.MIG_MAESTRA_HITOS_VALORES A
           , '||V_ESQUEMA ||'.TEX_TAREA_EXTERNA         B
           , '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS     C
           , '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO   D
        WHERE A.TAR_ID = B.TAR_ID
          AND A.TAP_CODIGO = D.TAP_CODIGO  
          AND C.TAP_ID =  D.TAP_ID (+)
          AND A.TEV_NOMBRE = C.TFI_NOMBRE(+)
        ORDER BY 1');


    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  TEV_TAREA_EXTERNA_VALOR cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_TEVEXTVAL_TEVNOM'' AND OWNER= ''' || V_ESQUEMA || '''') INTO V_COUNT;
    IF V_COUNT = 0 
      THEN
        EXECUTE IMMEDIATE('Create index IDX_TEVEXTVAL_TEVNOM on '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR (tev_nombre) nologging');
        DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Indice IDX_TEVEXTVAL_TEVNOM Creado');
    END IF;

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  TEV_TAREA_EXTERNA_VALOR Analizada');

    
/*    
    ------------------
    --    EMBARGOS
    ------------------

    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS (
            EMP_ID,
            BIE_ID,
            PRC_ID,
            EMP_FECHA_SOLICITUD_EMBARGO,
            EMP_FECHA_DECRETO_EMBARGO,
            EMP_FECHA_REGISTRO_EMBARGO,
            EMP_FECHA_ADJUDICACION_EMBARGO,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO,
            EMP_IMPORTE_AVAL,
            EMP_FECHA_AVAL,
            EMP_IMPORTE_TASACION,
            EMP_FECHA_TASACION,
            EMP_IMPORTE_ADJUDICACION,
            EMP_IMPORTE_VALOR,
            EMP_LETRA,
            EMP_FECHA_DENEGACION_EMBARGO )
        SELECT '||V_ESQUEMA||'.S_EMP_EMBARGOS_PROCEDIMIENTOS.NEXTVAL,
             BIE_ID,
             PRC_ID,
             FECHA_SOLICITUD_EMBARGO
            ,FECHA_DECRETO_EMBARGO
            ,FECHA_REGISTRO_EMBARGO
            ,FECHA_ADJUDICACION_EMBARGO
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,BORRADO
            ,IMPORTE_AVALUO
            ,FECHA_AVALUO
            ,IMPORTE_TASACION
            ,FECHA_TASACION
            ,IMPORTE_ADJUDICACION
            ,IMPORTE_VALOR
            ,LETRA
            ,EMP_FECHA_DENEGACION_EMBARGO
        FROM(    
        SELECT DISTINCT -- EJECUTIVOS
            BIE.BIE_ID,
            (SELECT MIN(PRC_ID) MIN_PRC FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC, '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO WHERE PRC.DD_TPO_ID = TPO.DD_TPO_ID AND DD_TPO_CODIGO = ''P15'' AND PRC.ASU_ID = ASU.ASU_ID) AS PRC_ID,
            MPE.FECHA_SOLICITUD_EMBARGO,
            MPE.FECHA_DECRETO_EMBARGO,
            MPE.FECHA_REGISTRO_EMBARGO,
            MPE.FECHA_ADJUDICACION_EMBARGO,
            0 AS VERSION,
            '''||USUARIO||''' AS USUARIOCREAR,
            TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') FECHACREAR,
            0 AS BORRADO,
            MPE.IMPORTE_AVALUO,
            MPE.FECHA_AVALUO,
            MPE.IMPORTE_TASACION,
            MPE.FECHA_TASACION,
            ADJ.BIE_ADJ_IMPORTE_ADJUDICACION as IMPORTE_ADJUDICACION,
            MPE.IMPORTE_VALOR,
            MPE.LETRA,
            NULL AS EMP_FECHA_DENEGACION_EMBARGO
        FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_EMBARGOS MPE
           , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA CAB
           , '||V_ESQUEMA||'.ASU_ASUNTOS ASU
           , '||V_ESQUEMA||'.BIE_BIEN BIE
           , '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ
        WHERE CAB.ESTADO_PROCEDIMIENTO=''VIV''
        AND CAB.TIPO_PROCEDIMIENTO = ''EJECUTIVO''
        AND CAB.CD_PROCEDIMIENTO = MPE.CD_PROCEDIMIENTO
        AND MPE.CD_PROCEDIMIENTO = ASU.ASU_ID_EXTERNO
        AND MPE.CD_BIEN = BIE.BIE_CODIGO_EXTERNO
        AND BIE.BIE_ID = ADJ.BIE_ID (+))');
        

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  EMP_NMBEMBARGOS_PROCEDIMIENTOS cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  EMP_NMBEMBARGOS_PROCEDIMIENTOS Analizada');
     
  */
    ---------------
    --  SUBASTAS  --
    ---------------  
        
    EXECUTE IMMEDIATE ('
    INSERT INTO  '||V_ESQUEMA||'.SUB_SUBASTA
                (
                    SUB_ID
                  , ASU_ID
                  , PRC_ID
                  , SUB_NUM_AUTOS
                  , DD_TSU_ID
                  , SUB_FECHA_SOLICITUD
                  , SUB_FECHA_ANUNCIO
                  , SUB_FECHA_SENYALAMIENTO
                  , DD_ESU_ID
                  , DD_REC_ID
                  , DD_MSS_ID
                  , DD_MCS_ID
                  , SUB_TASACION
                  , SUB_INFO_LETRADO
                  , SUB_INSTRUCCIONES
                  , SUB_SUBASTA_REVISADA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , SUB_COSTAS_LETRADO
                  , CD_SUBASTA_ORIG
                  , DEUDA_JUDICIAL_MIG
                  , SYS_GUID
                )
            SELECT '||V_ESQUEMA||'.S_SUB_SUBASTA.NEXTVAL
                   , ASU_ID
                   , PRC_ID
                   , SUB_NUM_AUTOS
                   , DD_TSU_ID
                   , SUB_FECHA_SOLICITUD
                   , SUB_FECHA_ANUNCIO
                   , SUB_FECHA_SENYALAMIENTO
                   , DD_ESU_ID
                   , DD_REC_ID
                   , DD_MSS_ID
                   , DD_MCS_ID
                   , SUB_TASACION
                   , SUB_INFO_LETRADO
                   , SUB_INSTRUCCIONES
                   , SUB_SUBASTA_REVISADA
                   , VERSION
                   , USUARIOCREAR
                   , FECHACREAR
                   , BORRADO
                   , SUB_COSTAS_LETRADO
                   , CD_SUBASTA_ORIG
                   , DEUDA_JUDICIAL 
                   , SYS_GUID() as SYS_GUID                   
            FROM (
                  SELECT DISTINCT 
                           ASU.ASU_ID
                         , PRC.PRC_ID
                         , NULL as SUB_NUM_AUTOS
                         , 2 as DD_TSU_ID --> MPS.TIPO_SUBASTA_ Vienen ceros
                         , MPS.FECHA_SOLICITUD_SUBASTA AS SUB_FECHA_SOLICITUD
                         , NULL as SUB_FECHA_ANUNCIO
                         , MPS.FECHA_SENALAMIENTO_SUBASTA AS SUB_FECHA_SENYALAMIENTO
                         , esu.DD_ESU_ID
                         , rec.DD_REC_ID
                         , mss.DD_MSS_ID
                         , mcs.DD_MCS_ID
                         , 0 AS SUB_TASACION
                         , 0 AS SUB_INFO_LETRADO
                         , 0 AS SUB_INSTRUCCIONES
                         , 0 AS SUB_SUBASTA_REVISADA
                         , 0 AS VERSION
                         , '''||USUARIO||''' AS USUARIOCREAR
                         , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') AS FECHACREAR
                         , 0 AS BORRADO
                         , MINUTA_LETRADO AS SUB_COSTAS_LETRADO
                         , MPS.CD_SUBASTA AS CD_SUBASTA_ORIG
                         , MPS.DEUDA_JUDICIAL
                   FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                      , '||V_ESQUEMA||'.MIG_MAESTRA_HITOS MMH
                      , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_SUBASTAS MPS
                      , '||V_ESQUEMA||'.ASU_ASUNTOS ASU
                      , '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA esu
                      , '||V_ESQUEMA||'.DD_REC_RESULTADO_COMITE rec
                      , '||V_ESQUEMA||'.DD_MSS_MOT_SUSP_SUBASTA mss 
                      , '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA mcs
                   WHERE MMH.DD_TPO_CODIGO = ''H002''
                     AND PRC.PRC_ID           = MMH.PRC_ID  
                     AND MPS.CD_PROCEDIMIENTO = MMH.CD_PROCEDIMIENTO
                     AND ASU.ASU_ID           = PRC.ASU_ID
        --Jaime Sanchez-Cuenca: 
                     AND Case When mps.SUSPENDIDA_POR <> 0 or trim(mps.MOTIVO_SUSPENSION) is not null
                                        Then ''SUS''
                              When mps.SUBASTA_CELEBRADA=1
                                        Then ''CEL''
                              WHEN mps.SUBASTA_CELEBRADA = 0 
                                        THEN ''PIN''
                              When mps.MOTIVO_SUBASTA_CANCELADA <> 0
                                        Then ''CAN''
                              Else null
                         End = esu.DD_ESU_CODIGO
                     AND decode(mps.RESOLUCION_COMITE,0,''ACE'',1,''REC'',null) = rec.DD_REC_CODIGO(+)
                     AND decode(mps.SUSPENDIDA_POR,1,''SOOT'',2,''SEOT'',null) = mss.DD_MSS_CODIGO(+)
                     AND decode(mps.MOTIVO_SUBASTA_CANCELADA,0,null) = mcs.DD_MCS_CODIGO(+) --Falta ver que valores se reciben
                   ORDER BY 20
                 )'
       );

 --4.227 subastas
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  SUB_SUBASTA cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.SUB_SUBASTA COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  SUB_SUBASTA Analizada');



    -- cambiar el estado de la subasta según hito actual del trámite de subasta
    ------------------------------------------------------------------------------
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_SUB_PRC_ID'' and table_name=''SUB_SUBASTA'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_SUB_PRC_ID ON SUB_SUBASTA(PRC_ID)');
    END IF;
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_PRC_BORRAR'' and table_name=''PRC_PROCEDIMIENTOS'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_PRC_BORRAR ON PRC_PROCEDIMIENTOS (DD_TPO_ID,USUARIOCREAR)');
    END IF;
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_TAR_PENDIENTES'' and table_name=''TAR_TAREAS_NOTIFICACIONES'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_TAR_PENDIENTES ON TAR_TAREAS_NOTIFICACIONES(TAR_FECHA_FIN, BORRADO)');
    END IF;
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_TEX_TAR_ID_TAP_ID'' and table_name=''TEX_TAREA_EXTERNA'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_TEX_TAR_ID_TAP_ID ON TEX_TAREA_EXTERNA(TAR_ID,TAP_ID)');
    END IF;
    
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.SUB_SUBASTA COMPUTE STATISTICS FOR ALL INDEXES');
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS COMPUTE STATISTICS FOR ALL INDEXES');
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES COMPUTE STATISTICS FOR ALL INDEXES');
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA COMPUTE STATISTICS FOR ALL INDEXES');
    
        
    -- cambiar el estado de la subasta según hito actual del trámite de subasta
    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_descripcion = ''CELEBRADA'')
        where sub.sub_id in (
            select subb.sub_id 
            from 
             (  select distinct prc.asu_id, prc.prc_id, 
                        (select max(tar.tar_id)
                         from   '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
                         where  tar.prc_id = prc.prc_id 
                         and    TAR.BORRADO= 0
                         AND    tar.TAR_FECHA_FIN is NOT null) ultima_tarea_FINALIZADA
                from '||V_ESQUEMA||'.prc_procedimientos prc 
                     , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
                where prc.dd_tpo_id = tpo.dd_tpo_id
--GMN Cambiamos por select y descripcion para recuperar ID:   where prc.dd_tpo_id = 2145                
                AND prc.usuariocrear = '''||USUARIO||'''
             ) aux
             , tex_tarea_externa tex
             , tap_tarea_procedimiento tap
             , sub_subasta subb 
            where ultima_tarea_FINALIZADA IS NOT NULL
              AND tap.TAP_CODIGO in ( ''H002_CelebracionSubasta'' )
              AND tex.tar_id = aux.ultima_tarea_FINALIZADA
              AND tex.TAP_ID = tap.tap_id
              AND subb.prc_id = aux.prc_id
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PAC'')
        where sub.sub_id in (
            select subb.sub_id 
            from 
             (  select distinct prc.asu_id, prc.prc_id, 
                        (select max(tar.tar_id)
                         from   '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
                         where  tar.prc_id = prc.prc_id 
                         and    TAR.BORRADO= 0
                         AND    tar.TAR_FECHA_FIN is null) ultima_tarea_pendiente
                from '||V_ESQUEMA||'.prc_procedimientos prc 
                     , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
                where prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''
             ) aux
             , tex_tarea_externa tex
             , tap_tarea_procedimiento tap
             , sub_subasta subb 
            where aux.ultima_tarea_pendiente IS NOT NULL
              AND tap.TAP_CODIGO in (''H002_LecturaConfirmacionInstrucciones'',''H002_ObtenerValidacionComite'',''H002_DictarInstruccionesSubasta'')
              AND tex.tar_id = aux.ultima_tarea_pendiente
              AND tex.TAP_ID = tap.tap_id
              AND subb.prc_id = aux.prc_id
        )');


    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PCO'')
        where sub.sub_id in (
            select subb.sub_id 
            from 
             (  select distinct prc.asu_id, prc.prc_id, 
                        (select max(tar.tar_id)
                         from   '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
                         where  tar.prc_id = prc.prc_id 
                         and    TAR.BORRADO= 0
                         AND    tar.TAR_FECHA_FIN is null) ultima_tarea_pendiente
                from '||V_ESQUEMA||'.prc_procedimientos prc 
                     , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
                where prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''
             ) aux
            , tex_tarea_externa tex
            , tap_tarea_procedimiento tap
            , sub_subasta subb 
            where aux.ultima_tarea_pendiente IS NOT NULL
              AND tap.TAP_CODIGO in (''H002_ValidarInformeDeSubasta'')
              AND tex.tar_id = aux.ultima_tarea_pendiente
              AND tex.TAP_ID = tap.tap_id
              AND subb.prc_id = aux.prc_id
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PPR'')
          where sub.sub_id in (
            select subb.sub_id 
            from 
             (  select distinct prc.asu_id, prc.prc_id, 
                        (select max(tar.tar_id)
                         from   '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
                         where  tar.prc_id = prc.prc_id 
                         and    TAR.BORRADO= 0
                         AND    tar.TAR_FECHA_FIN is null) ultima_tarea_pendiente
                from '||V_ESQUEMA||'.prc_procedimientos prc 
                     , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
                where prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''
             ) aux, tex_tarea_externa tex, tap_tarea_procedimiento tap, sub_subasta subb 
            where aux.ultima_tarea_pendiente IS NOT NULL
            AND tap.TAP_CODIGO in (''H002_PrepararInformeSubasta'')
            AND tex.tar_id = aux.ultima_tarea_pendiente
            AND tex.TAP_ID = tap.tap_id
            AND subb.prc_id = aux.prc_id
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PCE'')
        where sub.sub_id in (
            select subb.sub_id 
            from 
             (  select distinct prc.asu_id, prc.prc_id, 
                        (select max(tar.tar_id)
                         from   '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
                         where  tar.prc_id = prc.prc_id 
                         and    TAR.BORRADO= 0
                         AND    tar.TAR_FECHA_FIN is null) ultima_tarea_pendiente
                from '||V_ESQUEMA||'.prc_procedimientos prc 
                     , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
                where prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''
             ) aux
            , tex_tarea_externa tex
            , tap_tarea_procedimiento tap
            , sub_subasta subb 
            where aux.ultima_tarea_pendiente IS NOT NULL
              AND tap.TAP_CODIGO in (''H002_CelebracionSubasta'')
              AND tex.tar_id = aux.ultima_tarea_pendiente
            AND tex.TAP_ID = tap.tap_id
            AND subb.prc_id = aux.prc_id
        )');

        -- 4227 filas actualizadas
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''PIN'')
        where sub.sub_id in (
            select subb.sub_id 
            from 
             (  select distinct prc.asu_id, prc.prc_id, 
                        (select max(tar.tar_id)
                         from   '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
                         where  tar.prc_id = prc.prc_id 
                         and    TAR.BORRADO= 0
                         AND    tar.TAR_FECHA_FIN is null) ultima_tarea_pendiente
                from '||V_ESQUEMA||'.prc_procedimientos prc 
                     , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
                where prc.dd_tpo_id = tpo.dd_tpo_id
                AND prc.usuariocrear = '''||USUARIO||'''
             ) aux
             , tex_tarea_externa tex
             , tap_tarea_procedimiento tap
             , sub_subasta subb 
            where aux.ultima_tarea_pendiente IS NOT NULL
            AND tap.TAP_CODIGO in (''H002_SolicitudSubasta'',''H002_SenyalamientoSubasta'',''H002_RevisarDocumentacion'')
            AND tex.tar_id = aux.ultima_tarea_pendiente
            AND tex.TAP_ID = tap.tap_id
            AND subb.prc_id = aux.prc_id
        )');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MM:SS')||'  SUB_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE sub_subasta sub set sub.DD_ESU_ID = (select dd_esu_id from DD_ESU_ESTADO_SUBASTA esu where esu.dd_esu_codigo = ''SUS'')
        where sub.sub_id in (
            select subb.sub_id 
            from 
               (  select distinct prc.asu_id, prc.prc_id, 
                          (select max(tar.tar_id)
                           from   '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
                           where  tar.prc_id = prc.prc_id 
                             and  TAR.BORRADO= 0
                             AND  tar.TAR_FECHA_FIN is null) ultima_tarea_pendiente
                   from '||V_ESQUEMA||'.prc_procedimientos prc 
                     , (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_DESCRIPCION = ''T. de subasta - HCJ'') TPO
                where prc.dd_tpo_id = tpo.dd_tpo_id
                     AND prc.usuariocrear = '''||USUARIO||'''
               ) aux
               , tex_tarea_externa tex
               , tap_tarea_procedimiento tap
               , sub_subasta subb 
            where aux.ultima_tarea_pendiente IS NOT NULL
              AND tap.TAP_CODIGO in (''H002_DictarInstruccionesDeneSuspension'')
              AND tex.tar_id = aux.ultima_tarea_pendiente
              AND tex.TAP_ID = tap.tap_id
              AND subb.prc_id = aux.prc_id
        )');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  SUB_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    EXECUTE IMMEDIATE('drop index '||V_ESQUEMA||'.IDX_PRC_BORRAR');

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.SUB_SUBASTA COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  SUB_SUBASTA Analizada');



      ------------------------
    --- LOS_LOTE_SUBASTA
    ------------------------
      
    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.LOS_LOTE_SUBASTA
               ( 
                  LOS_ID
                , SUB_ID 
                , LOS_PUJA_SIN_POSTORES
                , LOS_PUJA_POSTORES_DESDE 
                , LOS_PUJA_POSTORES_HASTA
                , LOS_50_DEL_TIPO_SUBASTA 
                , LOS_60_DEL_TIPO_SUBASTA 
                , LOS_70_DEL_TIPO_SUBASTA 
                , LOS_OBSERVACIONES
                , VERSION 
                , USUARIOCREAR 
                , FECHACREAR 
                , USUARIOMODIFICAR 
                , FECHAMODIFICAR 
                , USUARIOBORRAR 
                , FECHABORRAR
                , BORRADO
                , CD_LOTE
                , LOS_NUM_LOTE
                , SYS_GUID
               ) 
            SELECT '||V_ESQUEMA||'.S_LOS_LOTE_SUBASTA.NEXTVAL LOS_ID
                , SUB_ID 
                , LOS_PUJA_SIN_POSTORES
                , LOS_PUJA_POSTORES_DESDE 
                , LOS_PUJA_POSTORES_HASTA
                , LOS_50_DEL_TIPO_SUBASTA 
                , LOS_60_DEL_TIPO_SUBASTA 
                , LOS_70_DEL_TIPO_SUBASTA 
                , LOS_OBSERVACIONES
                , VERSION 
                , USUARIOCREAR 
                , FECHACREAR 
                , USUARIOMODIFICAR 
                , FECHAMODIFICAR 
                , USUARIOBORRAR 
                , FECHABORRAR
                , BORRADO
                , CD_LOTE
                , LOS_NUM_LOTE 
                , SYS_GUID() as SYS_GUID                
              FROM 
                    (SELECT DISTINCT
                                    SUB.SUB_ID 
                                  , PSL.PUJA_SIN_POSTORES       AS LOS_PUJA_SIN_POSTORES
                                  , PSL.PUJA_CON_POSTORES_DESDE AS LOS_PUJA_POSTORES_DESDE
                                  , PSL.PUJA_CON_POSTORES_HASTA AS LOS_PUJA_POSTORES_HASTA
                                  , NULL as LOS_50_DEL_TIPO_SUBASTA
                                  , NULL as LOS_60_DEL_TIPO_SUBASTA
                                  , NULL as LOS_70_DEL_TIPO_SUBASTA
                                  , NULL as LOS_OBSERVACIONES
                                  , 0    as VERSION
                                  , '''||USUARIO||''' as USUARIOCREAR
                                  , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') as FECHACREAR
                                  , NULL as USUARIOMODIFICAR
                                  , NULL as FECHAMODIFICAR
                                  , NULL as USUARIOBORRAR
                                  , NULL as FECHABORRAR
                                  , 0    as BORRADO
                                  , PSL.CD_LOTE
                                  , PSL.NUMERO_LOTE AS LOS_NUM_LOTE
                                FROM  '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES PSL 
                                    , '||V_ESQUEMA||'.SUB_SUBASTA SUB 
                                WHERE PSL.CD_SUBASTA = SUB.CD_SUBASTA_ORIG
                            )'
                       );
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  LOS_LOTE_SUBASTA fin insert inicial. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    -- Actualizamos estadisticas de los origenes
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ESTIMATE STATISTICS SAMPLE 20 PERCENT');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' LOS_LOTE_SUBASTA Analizada');
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES ESTIMATE STATISTICS SAMPLE 20 PERCENT');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_PROCS_SUBASTAS_LOTES Analizada');
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN ESTIMATE STATISTICS SAMPLE 20 PERCENT');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_PROCS_SUBASTAS_LOTES_BIEN Analizada');


/* No aplica en CAJAMAR ya que solo tenemos un lote por subasta

    EXECUTE IMMEDIATE ('UPDATE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA LOS
                           SET LOS_VALOR_SUBASTA = ( 
                                                     SELECT SUM(PSLB.VALOR_JUDICIAL_SUBASTA)
                                                     FROM '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES PSL            
                                                        LEFT JOIN '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN PSLB 
                                                               ON PSLB.CD_LOTE = PSL.CD_LOTE
                                                     WHERE PSL.CD_LOTE = LOS.CD_LOTE
                                                    )
                      ');                        
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  LOS_LOTE_SUBASTA.LOS_VALOR_SUBASTA actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' LOS_LOTE_SUBASTA cargada');
    
*/
    --------------------
    ---  LOB_LOTE_BIEN
    --------------------
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MIG_1'' and table_name=''MIG_PROCS_SUBASTA_LOTES_BIENES'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=1) THEN
       EXECUTE IMMEDIATE('DROP INDEX IDX_MIG_1');
    END IF;    
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MIG_1'' and table_name=''MIG_PROCS_SUBASTAS_LOTES_BIEN'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_1 ON '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN (CD_LOTE,CD_BIEN) ');
    END IF;
    
    EXECUTE IMMEDIATE('Analyze table '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN compute statistics FOR ALL INDEXES');
    
    EXECUTE IMMEDIATE('Analyze table '||V_ESQUEMA||'.LOS_LOTE_SUBASTA compute statistics FOR ALL INDEXES');

    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_BIE_CODIGO_EXTERNO'' and table_name=''BIE_BIEN'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_BIE_CODIGO_EXTERNO ON '||V_ESQUEMA||'.BIE_BIEN (BIE_CODIGO_EXTERNO) ');
    END IF;
    
    EXECUTE IMMEDIATE('analyze table '||V_ESQUEMA||'.BIE_BIEN compute statistics FOR ALL INDEXES'); 

    -- MIG_PROCEDIMIENTOS_BIENES
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_MIG_PRC_BIE_X'' and table_name=''MIG_PROCEDIMIENTOS_BIENES'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_PRC_BIE_X ON '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES (CD_PROCEDIMIENTO, CD_BIEN) ');
    END IF;
    
    EXECUTE IMMEDIATE('Analyze table '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES compute statistics FOR ALL INDEXES');

/*
    EXECUTE IMMEDIATE ('INSERT INTO  '||V_ESQUEMA||'.LOB_LOTE_BIEN
                            (  
                                LOS_ID
                              , BIE_ID
                              , VERSION 
                            ) 
                            SELECT DISTINCT 
                                     LOS.LOS_ID
                                   , BIE.BIE_ID
                                   , LOS.VERSION 
                            FROM  '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN SLB 
                                , '||V_ESQUEMA||'.LOS_LOTE_SUBASTA LOS
                                , '||V_ESQUEMA||'.BIE_BIEN BIE
                            WHERE SLB.CD_LOTE = LOS.CD_LOTE  
                              AND SLB.CD_BIEN = BIE.BIE_CODIGO_INTERNO'
                       );
    */
--Se utiliza un unico bien 100314414. el cd_bien no cruza con el de BIE_BIEN
    EXECUTE IMMEDIATE ('INSERT INTO  '||V_ESQUEMA||'.LOB_LOTE_BIEN
                            (  
                                LOS_ID
                              , BIE_ID
                              , VERSION 
                            ) 
                            SELECT /*+ ordered */ DISTINCT 
                                     LOS.LOS_ID
                                   , E.BIE_ID
                                   , LOS.VERSION 
                            FROM  '||V_ESQUEMA||'.LOS_LOTE_SUBASTA LOS,
								  '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES A,
								  '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN B,
								  '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_SUBASTAS C,
								  '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES D,
								  '||V_ESQUEMA||'.BIE_BIEN E
                            WHERE A.CD_LOTE = LOS.CD_LOTE
                              AND C.CD_SUBASTA = A.CD_SUBASTA
							  AND B.CD_LOTE = A.CD_LOTE
							  AND C.CD_PROCEDIMIENTO = D.CD_PROCEDIMIENTO
							  AND D.CD_BIEN = E.BIE_CODIGO_INTERNO'
                       );
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  LOB_LOTE_BIEN cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.LOB_LOTE_BIEN COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  LOB_LOTE_BIEN Analizada');

    -- 4.188 registros cargados
    
    ----------------
    -- PRB_PCR_BIE
    ----------------

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_BIEN COMPUTE STATISTICS');
	DBMS_OUTPUT.PUT_LINE('[WARN-ACC] - '||to_char(sysdate,'HH24:MI:SS')||'  BIE_BIEN Analizada');
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_MAESTRA_HITOS COMPUTE STATISTICS');
	DBMS_OUTPUT.PUT_LINE('[WARN-ACC] - '||to_char(sysdate,'HH24:MI:SS')||'  MIG_MAESTRA_HITOS Analizada');	
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES COMPUTE STATISTICS');
	DBMS_OUTPUT.PUT_LINE('[WARN-ACC] - '||to_char(sysdate,'HH24:MI:SS')||'  MIG_PROCEDIMIENTOS_BIENES Analizada');		
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS COMPUTE STATISTICS');
	DBMS_OUTPUT.PUT_LINE('[WARN-ACC] - '||to_char(sysdate,'HH24:MI:SS')||'  PRC_PROCEDIMIENTOS Analizada');		

    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.PRB_PRC_BIE
            (
                PRB_ID
              , PRC_ID
              , BIE_ID
              , DD_SGB_ID
              , USUARIOCREAR
              , FECHACREAR
              , SYS_GUID              
            )
            SELECT '||V_ESQUEMA||'.S_PRB_PRC_BIE.NEXTVAL AS PRB_ID,
                   PRC_ID,
                   BIE_ID,
                   1 AS DD_SGB_ID, 
                   '''||USUARIO||''' AS USUARIOCREAR,
                   TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') AS FECHACREAR,
                   SYS_GUID() as SYS_GUID
            FROM(
                   SELECT DISTINCT A.PRC_ID, B.BIE_ID
                   FROM '||V_ESQUEMA||'.MIG_MAESTRA_HITOS A
                      , '||V_ESQUEMA||'.BIE_BIEN B
                   WHERE A.CD_BIEN IS NOT NULL 
                     AND A.CD_BIEN = B.BIE_CODIGO_INTERNO
                 UNION
                   SELECT DISTINCT D.PRC_ID, B.BIE_ID 
                   FROM '||V_ESQUEMA||'.BIE_BIEN B
                      , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES C
                      , '||V_ESQUEMA||'.MIG_MAESTRA_HITOS D
                      , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS E
                   WHERE D.CD_BIEN IS NULL                     
                     AND D.PRC_ID = E.PRC_ID
                     AND D.CD_PROCEDIMIENTO = C.CD_PROCEDIMIENTO
                     AND C.CD_BIEN = B.BIE_CODIGO_INTERNO
                    ORDER BY 1,2)'
                 );
    
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRB_PRC_BIE cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PRB_PRC_BIE COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRB_PRC_BIE Analizada');

    -- 21.416 registros cargados
    

    -- Actualizamos el dd_stda_id de tareas para CONCURSOS DD_TAS_ID = 2
    
    EXECUTE IMMEDIATE ('
       MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
       USING (select tap.dd_sta_id, tex.tar_id 
              from '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
                 inner join '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap on tex.tap_id = tap.tap_id 
                 inner join '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES t on t.TAR_ID   = tex.TAR_ID 
                 inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS      prc on prc.PRC_ID = t.PRC_ID         
                 inner join '||V_ESQUEMA||'.ASU_ASUNTOS             asu on prc.asu_id = asu.asu_id                    
                 where asu.usuariocrear='''||USUARIO||''' 
                   and asu.DD_TAS_ID = 2  
              ) tmp
                      on (tmp.tar_id = tar.tar_id)                        
       WHEN MATCHED THEN UPDATE SET tar.dd_sta_id = tmp.dd_sta_id,
            tar.usuariomodificar = tar.dd_sta_id, tar.fechamodificar = sysdate'
                     );
       
      COMMIT;    
    
    --------------------------------
    -- Carterizar asuntos letrado  -
    --------------------------------
    -- GAA_GESTOR_ADICIONAL_ASUNTO
    ----------------------------------
/*    
    --letrado procedimientos:
    --------------------------
    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO 
                             (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
                       select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk
                              , aux.asu_id
                              , aux.usd_id
                              , (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT'')
                                     , '''||USUARIO||'''
                                     , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
                       from 
                          (
                           select distinct auxi.asu_id, auxi.usd_id
                           from (
                               select distinct asu.asu_id, usd.usd_id,
                                      rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
                               from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
                                    '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo inner join 
                                    '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_despacho = migp.cd_despacho          inner join 
                                    '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on usd.des_id = des.des_id                    inner join 
                                    '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 --and usu.usu_gestor_por_defecto
                               where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                                                                  from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                                                  where dd_tge_codigo=''GEXT''))
                           ) auxi where auxi.ranking = 1
                          ) aux'
                       );

     -- 15.385 registros insertados
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrados de los Litigios. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


    --letrado en los concursos:
    --------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                         inner join 
               '||V_ESQUEMA||'.mig_concursos_cabecera  migp on migp.cd_concurso = asu.asu_id_externo   inner join
               '||V_ESQUEMA||'.des_despacho_externo    des  on des.des_despacho = migp.cd_despacho       inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos  usd  on usd.des_id = des.des_id                 inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios     usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                                             from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                             where dd_tge_codigo=''GEXT''))
      ) auxi where auxi.ranking = 1
     ) aux'); 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrados de los Concursos. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
  
    
    
    -- Procuradores procedimientos  
    ------------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''PROC''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_despacho = migp.cd_procurador        inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on usd.des_id = des.des_id                    inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1
         where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                                            from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                            where dd_tge_codigo=''PROC'')
                          )
      ) auxi where auxi.ranking = 1
     ) aux');
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    
       
    --Procurador en los concursos:
    ------------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''PROC''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                      inner join 
               '||V_ESQUEMA||'.mig_concursos_cabecera migp on migp.cd_concurso = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo   des  on des.des_despacho = migp.cd_procurador   inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos usd  on usd.des_id = des.des_id               inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios    usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                                             from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                             where dd_tge_codigo=''PROC''))
      ) auxi where auxi.ranking = 1
     ) aux'); 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrados de los Concursos. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    --** Carterizar gestorias (procedimientos-bienes)
    ----------------------------------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
        select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk
               , aux.asu_id
               , aux.usd_id
               , (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SGADJ'')
               , '''||USUARIO||'''
               , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
        from 
           (
             select distinct auxi.asu_id, auxi.usd_id
             from (
                    select distinct asu.asu_id, usd.usd_id, usu.usu_username,
                           rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
                    from '||V_ESQUEMA||'.asu_asuntos asu                                                                 inner join 
                         '||V_ESQUEMA||'.mig_procedimientos_bienes   migp on migp.cd_procedimiento = asu.asu_id_externo  inner join
                         '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_despacho = migp.gestoria_adjudicacion inner join 
                         '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on usd.des_id = des.des_id                     inner join
                         '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1
                    where not exists (select 1 from CM01.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                                              from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor
                                                                                                                                              where dd_tge_codigo=''SGADJ'')
                                     )
                   ) auxi 
             where auxi.ranking = 1
            ) aux'
        );
      
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO cargada. Gestorias de adjudicacion. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
     
     
    --** Carterizar gestorias (bienes-adjudicados)
    ----------------------------------------------------
    
     */   
    ------------------------------------
    -- GGAH_GESTOR_ADICIONAL_HISTORICO
    ------------------------------------

    --letrado procedimientos:
    --------------------------    
/*
    EXECUTE IMMEDIATE('INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO GAH (GAH.GAH_ID, GAH.GAH_ASU_ID, GAH.GAH_GESTOR_ID, GAH.GAH_FECHA_DESDE, GAH.GAH_TIPO_GESTOR_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                 inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera  migp on migp.cd_procedimiento = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo         des  on des.des_despacho = migp.cd_despacho          inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos       usd  on usd.des_id = des.des_id                    inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios          usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                                                         from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                                         where dd_tge_codigo=''GEXT''))
      ) auxi where auxi.ranking = 1
     ) aux');
     
-- 15.385 registros insertados
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Letrados de los Litigios. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
        
    
    -- Procuradores
    --------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''PROC''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo        des on des.des_despacho = migp.cd_procurador         inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd on usd.des_id = des.des_id                     inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                                                         from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                                         where dd_tge_codigo=''PROC''))
      ) auxi where auxi.ranking = 1
     ) aux');    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    --letrado en los concursos:
    --------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu inner join 
               '||V_ESQUEMA||'.mig_concursos_cabecera migp on migp.cd_concurso = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo des on des.des_despacho = migp.cd_despacho inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos usd on usd.des_id = des.des_id inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                                                         from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor
                                                                                                                                                        where dd_tge_codigo=''GEXT''))
      ) auxi where auxi.ranking = 1
     ) aux'); 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO_historico cargada. Letrados de los Concursos. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    */
    /*

    --** Carterizar gestorias
    --------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SGADJ''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu inner join 
               '||V_ESQUEMA||'.mig_procedimientos_bienes migp on migp.cd_procedimiento = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo des on des.des_despacho = migp.gestoria_adjudicacion inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos usd on usd.des_id = des.des_id inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                                     from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor
                                                                                                                                    where dd_tge_codigo=''SGADJ''))
      ) auxi where auxi.ranking = 1
     ) aux'); 
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO_HISTORICO cargada. Gestorias de adjudicacion. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


-- INSERTAR GESTOR ESPECIALIZADO en todos los litigios  

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTESP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
  select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTESP''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio''))
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. GESTOR ESPECIALIZADO en todos los litigios. '||SQL%ROWCOUNT||' Filas.');


EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'') usd_id,  TRUNC(SYSDATE),
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTESP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
  select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTESP''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio''))
  ) aux';


--  SUPERVISORES según propiedad  o SAREB y gestion 
  
-- SUPERVISOR NIVEL 1

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO2DELOIT'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP''))
    and asu.asu_id in (select asuu.asu_id
                        from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                             '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                             '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                        where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
                          and ges.dd_ges_codigo = ''CAJAMAR'')
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. SUPERVISOR NIVEL 1 según propiedad  o SAREB y gestion. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id
       ,  (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO2DELOIT'') usd_id
       ,  TRUNC(SYSDATE)
       ,  (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP'')
       , '''||USUARIO||'''
       , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
    select asu_id
    from '||V_ESQUEMA||'.asu_asuntos asu 
    where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                            (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP''))
      and asu.asu_id in (select asuu.asu_id
                         from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                              '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                              '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                         where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
                           and ges.dd_ges_codigo = ''CAJAMAR'')
  ) aux';


-- SUPERVISOR NIVEL 2

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO2LV2DEL'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
  select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2''))
    and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
                      and ges.dd_ges_codigo = ''CAJAMAR'')
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. SUPERVISOR NIVEL 2 según propiedad  o SAREB y gestion . '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id
       , (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO2LV2DEL'') usd_id
       , TRUNC(SYSDATE)
       , (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2'')
       , '''||USUARIO||'''
       , TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
     select asu_id
     from '||V_ESQUEMA||'.asu_asuntos asu 
     where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2''))
       and asu.asu_id in (select asuu.asu_id
                       from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                            '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                            '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                       where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
                         and ges.dd_ges_codigo = ''CAJAMAR'')
  ) aux';
*/
  
/*  
-- propiedad  y gestion haya

-- SUPERVISOR NL 1

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYA'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. SUPERVISOR NIVEL 1 según propiedad  o SAREB y gestion HAYA. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYA'') usd_id, TRUNC(SYSDATE),
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUP''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';


-- SUPERVISOR NIVEL 2

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYALV2'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';

V_SQL:= 'gaa SUPERVISOR 2';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. SUPERVISOR NIVEL 2 según propiedad  o SAREB y gestion HAYA. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYALV2'') usd_id, TRUNC(SYSDATE),
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUPNVL2''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';

V_SQL:= 'gah Nivel 2';


-- insertar gestor de propuesta de subasta

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYA'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. gestor de propuesta de subasta con gestion HAYA. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

V_SQL:= 'gaa gestor de propuesta';

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYA'') usd_id, TRUNC(SYSDATE),
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';

V_SQL:= 'gah gestor de propuesta';

-- insertar gestor de llaves de subasta en los asuntos con trámite de subasta, hipotecario o ETNJ

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYA'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTLLA''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTLLA''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. gestor de llaves de subasta con gestion HAYA. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

V_SQL:= 'gaa gestor de llaves';

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''HAYA'') usd_id, TRUNC(SYSDATE),
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTLLA''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTLLA''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''HAYA'')
  ) aux';

*/
-- insertar gestor de propuesta de subasta en los asuntos con trámite de subasta, hipotecario o ETNJ
/*
EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from CM01.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''))
  and asu.asu_id in (select distinct asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id and tpo.DD_TPO_CODIGO in (''P409'',''P401'',''P01'',''P15'') inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''CAJAMAR'')
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. gestor de propuesta de subasta en los asuntos con trámite de supasta, hipotecario o ETNJ con gestion . '||SQL%ROWCOUNT||' Filas.');
    COMMIT;


EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'') usd_id, TRUNC(SYSDATE),
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
select asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu 
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''))
  and asu.asu_id in (select distinct asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id and tpo.DD_TPO_CODIGO in (''P409'',''P401'',''P01'',''P15'') inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
and ges.dd_ges_codigo = ''CAJAMAR'')
  ) aux';


 -- insertar gestor de llaves de subasta en los asuntos con trámite de supasta, hipotecario o ETNJ

EXECUTE IMMEDIATE'
insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''BPO1ACCEN'') usd_id,
(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTLLA''), '''||USUARIO||''', TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
from 
 (
   select asu_id
     from '||V_ESQUEMA||'.asu_asuntos asu 
     where not exists (select 1 from CM01.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                           (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTLLA''))
     and asu.asu_id in (select distinct asuu.asu_id
                       from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                            '||V_ESQUEMA||'.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                            '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id and tpo.DD_TPO_CODIGO in (''P409'',''P401'',''P01'',''P15'') inner join
                            '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                            '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                       where asuu.DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_MASTER||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_DESCRIPCION_LARGA = ''Litigio'')
                         and ges.dd_ges_codigo = ''CAJAMAR'')
  ) aux';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. gestor de llaves de subasta en los asuntos con trámite de subasta, hipotecario o ETNJ con gestion. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;




    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');

  
    --** update dd_tge_id
     EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.gaa_gestor_adicional_asunto set dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEST'')
                        where dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SGADJ'')');
     
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' gaa_gestor_adicional_asunto actualizada. Gestores de adjudicacion. '||SQL%ROWCOUNT||' Filas.');
     COMMIT;

     EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO set gah_tipo_gestor_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEST'')
                        where gah_tipo_gestor_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SGADJ'')');
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GAH_GESTOR_ADICIONAL_HISTORICO actualizada. Gestores de adjudicacion. '||SQL%ROWCOUNT||' Filas.');
     COMMIT;
  
  
     --** Actualizamos fechas tareas
     EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
     set tar.tar_fecha_venc = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') +10, tar_fecha_venc_real = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') + 10, tar.TAR_TAREA_FINALIZADA = 0, 
         tar.borrado = 0, tar.fechaborrar = null, tar.usuarioborrar = null, tar.usuariomodificar = ''SAG-INS'', tar.fechamodificar = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
     where tar.tar_id in (
         select tar.tar_id
         from '||V_ESQUEMA||'.mig_procedimientos_bienes mip                                                         inner join 
              '||V_ESQUEMA||'.mig_bienes mib on mib.CD_BIEN = mip.CD_BIEN                                           inner join 
              '||V_ESQUEMA||'.mig_bienes_activos_adjudicados mia on mia.NUMERO_ACTIVO = mib.NUMERO_ACTIVO           inner join 
              '||V_ESQUEMA||'.asu_asuntos asu on asu.asu_id_externo = mip.cd_procedimiento                          inner join
              '||V_ESQUEMA||'.prc_procedimientos prc on prc.asu_id = asu.asu_id and prc.dd_tpo_id = 2150            inner join
              '||V_ESQUEMA||'.prb_prc_bie prb on prb.prc_id = prc.prc_id                                            inner join
              '||V_ESQUEMA||'.bie_bien bie on bie.bie_id = prb.bie_id and bie.BIE_NUMERO_ACTIVO = mib.NUMERO_ACTIVO inner join
              '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.prc_id = prc.prc_id                              inner join
              '||V_ESQUEMA||'.tex_tarea_externa tex on tex.tar_id = tar.tar_id                                      inner join
              '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tap.tap_id = tex.tap_id and tap.tap_codigo = ''P413_RegistrarPresentacionEnRegistro''
         where mip.ULTIMO_HITO_BIEN_PROC in (''B0135'', ''B0140'', ''B0150'', ''B0160'', ''B0170'')
           and mia.GESTORIA_ADJUDICACION is not null
           and mia.FECHA_INSCRIPCION is null 
     )');
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' tar_tareas_notificaciones actualizada. '||SQL%ROWCOUNT||' Filas.');
     COMMIT;

     EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.tex_tarea_externa tex  
     set tex.borrado = 0, tex.fechaborrar = null, tex.usuarioborrar = null, tex.usuariomodificar = ''SAG-INS'', tex.fechamodificar = TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
     where tex.tar_id in (
         select tar.tar_id
         from '||V_ESQUEMA||'.mig_procedimientos_bienes mip                                                         inner join 
              '||V_ESQUEMA||'.mig_bienes mib on mib.CD_BIEN = mip.CD_BIEN                                           inner join 
              '||V_ESQUEMA||'.mig_bienes_activos_adjudicados mia on mia.NUMERO_ACTIVO = mib.NUMERO_ACTIVO           inner join 
              '||V_ESQUEMA||'.asu_asuntos asu on asu.asu_id_externo = mip.cd_procedimiento                          inner join
              '||V_ESQUEMA||'.prc_procedimientos prc on prc.asu_id = asu.asu_id and prc.dd_tpo_id = 2150            inner join
              '||V_ESQUEMA||'.prb_prc_bie prb on prb.prc_id = prc.prc_id                                            inner join
              '||V_ESQUEMA||'.bie_bien bie on bie.bie_id = prb.bie_id and bie.BIE_NUMERO_ACTIVO = mib.NUMERO_ACTIVO inner join
              '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.prc_id = prc.prc_id                              inner join
              '||V_ESQUEMA||'.tex_tarea_externa tex  on tex.tar_id = tar.tar_id                                     inner join
              '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tap.tap_id = tex.tap_id and tap.tap_codigo = ''P413_RegistrarPresentacionEnRegistro'' 
         where mip.ULTIMO_HITO_BIEN_PROC in (''B0135'', ''B0140'', ''B0150'', ''B0160'', ''B0170'')
           and mia.GESTORIA_ADJUDICACION is not null
           and mia.FECHA_INSCRIPCION is null 
     )');
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' tex_tarea_externa actualizada. '||SQL%ROWCOUNT||' Filas.');
     COMMIT;


   -----------------------------------------
    -- REVISAMOS INFORMACION DE TPO_RECOBRO
    -----------------------------------------
    EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''P100''') 
     INTO V_COUNT;

      IF (V_COUNT = 0) 
       THEN
       
        EXECUTE IMMEDIATE('Insert into '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,DD_TPO_HTML,DD_TPO_XML_JBPM
          ,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE) 
        values ('||V_ESQUEMA||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL,''P100'',''Procedimiento de Recobro'',''Procedimiento de Recobro''
              ,null,''recobro'',''0'',''DD'',TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''),null,null,null,null,''0'',''23'',null,null,''1'',''MEJTipoProcedimiento'')');

      END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Informacion de TPO_RECOBRO insertada en DD_TPO_TIPO_PROCEDIMIENTO. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
      
   
EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID = (SELECT DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo = ''P100'')
      AND TAP_CODIGO = ''P100_nodoEsperaController''') INTO V_COUNT;
      
      IF (V_COUNT = 0) 
       THEN
        EXECUTE IMMEDIATE('Insert into '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO (TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION
          ,DD_TPO_ID_BPM,TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO
          ,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) 
        values ('||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,(SELECT DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo = ''P100'')
          ,''P100_nodoEsperaController'',null,null,null,''comprobarMetaVolante() == true ?''''avanzaBPM'''' : ''''marcarExpediente'''''',null,''0'',''Nodo espera Controller'',''0'',''DD'',TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''),null,null,null,null,''0'',null,null,''9'',''1'',''EXTTareaProcedimiento'',''3'',null,''39'',null,null,null)');
        
      END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Informacion P100_nodoEsperaController insertada en TAP_TAREA_PROCEDIMIENTO. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;      
    
    EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
                        WHERE DD_TPO_ID = (SELECT DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo = ''P100'')
                          AND TAP_CODIGO = ''P100_nodoInicioPorSQL''') INTO V_COUNT;
      IF (V_COUNT = 0) 
       THEN
       
        EXECUTE IMMEDIATE('Insert into '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO (TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION
          ,DD_TPO_ID_BPM,TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO
          ,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) 
        values ('||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL,(SELECT DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_codigo = ''P100'')
        ,''P100_nodoInicioPorSQL'',null,null,null,null,null,''0'',''Nodo inicio SQL'',''0'',''DD'',TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''),null,null,null,null,''0'',null,null,''9'',''1'',''EXTTareaProcedimiento'',''3'',null,''39'',null,null,null)');
        
      END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Informacion P100_nodoInicioPorSQL insertada en TAP_TAREA_PROCEDIMIENTO. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    /*
    ----------------
    --  Recursos  --
    ----------------
    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS
        ( RCR_ID
        , PRC_ID
        , DD_ACT_ID
        , DD_DTR_ID
        , DD_CRE_ID
        , DD_DRR_ID
        , DD_FAV_ID
        , TAR_ID
        , RCR_FECHA_RECURSO	
        , RCR_FECHA_IMPUGNACION
        , RCR_FECHA_VISTA
        , RCR_FECHA_RESOLUCION
        , RCR_OBSERVACIONES
        , RCR_OBSERVACIONES_IMPUGNACION
        , RCR_OBSERVACIONES_RESOLUCION
        , RCR_OBSERVACIONES_VISTA
        , RCR_CONFIRM_VISTA
        , RCR_CONFIRM_IMPUGNACION
        , DTYPE
        , RCR_SUSPENSIVO
        , VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO
        , SYS_GUID 
        )
        SELECT '||V_ESQUEMA||'.S_RCR_RECURSOS_PROCEDIMIENTOS.nextval, 
        grc.PRC_ID
             , act.DD_ACT_ID
             , dtr.DD_DTR_ID
             , cre.DD_CRE_ID
             , drr.DD_DRR_ID
             , fav.DD_FAV_ID
             , null as TAR_ID
             , grc.FECHA_ADMISION as RCR_FECHA_RECURSO
             , null as RCR_FECHA_IMPUGNACION
             , grc.FECHA_CELEBRACION_VISTA as RCR_FECHA_VISTA
             , grc.FECHA_SENTENCIA_RESOLUCION as RCR_FECHA_RESOLUCION
             , null as RCR_OBSERVACIONES
             , null as RCR_OBSERVACIONES_IMPUGNACION
             , null as RCR_OBSERVACIONES_RESOLUCION
             , null as RCR_OBSERVACIONES_VISTA
             , grc.CONFIRMACION_VISTA as RCR_CONFIRM_VISTA
             , grc.CONFIRMACION_IMPUGNACION as RCR_CONFIRM_IMPUGNACION
             , ''MEJRecurso'' as DTYPE
             , grc.SUSPENSIVO as RCR_SUSPENSIVO
             ,0
             ,'''||USUARIO||'''
             ,TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
             ,NULL
             ,NULL 
             ,NULL 
             ,NULL
             ,0
             , SYS_GUID() AS SYS_GUID 
             FROM 
             (select a.cd_procedimiento_padre,  a.SENTENCIA_RESOLUCION, a.causa, a.tipo_recurso, a.actor, a.suspensivo,
                     a.CONFIRMACION_IMPUGNACION, a.CONFIRMACION_VISTA, a.FECHA_SENTENCIA_RESOLUCION,
                     a.FECHA_CELEBRACION_VISTA, a.FECHA_ADMISION,
                 c.asu_id, c.prc_id prc_id
            from '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_RECURSOS a,   
                  '||V_ESQUEMA||'.ASU_ASUNTOS d,
                  '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS c
                where  a.cd_procedimiento_padre = d.asu_id_externo  
                   and d.asu_id = c.asu_id
                   and c.prc_prc_id is null )             GRC
             , '||V_ESQUEMA||'.DD_ACT_ACTOR             ACT
             , '||V_ESQUEMA||'.DD_DTR_TIPO_RECURSO      DTR
             , '||V_ESQUEMA||'.DD_CRE_CAUSA_RECURSO     CRE
             , '||V_ESQUEMA||'.DD_DRR_RESULTADO_RESOL       DRR
             , '||V_ESQUEMA_MASTER||'.DD_FAV_FAVORABLE          FAV
         WHERE decode(grc.actor
                 ,''CAJA'',''01''
                 ,''TERCERO'',''02'')     = act.dd_act_codigo(+)
         AND decode(grc.tipo_recurso
                 ,''001'',''09'' --apelacion
                 )                    = dtr.dd_dtr_codigo(+)
         AND grc.causa                = cre.dd_cre_codigo(+)
         AND decode(grc.sentencia_resolucion
                 ,0,''01''--favorable
                 ,1,''02''--desfavorable
                 )                    = drr.dd_drr_codigo(+)
         AND decode(grc.sentencia_resolucion
                 ,0,''01''--favorable
                 ,1,''02''--desfavorable
                 )                    = fav.dd_fav_codigo(+)
    ');

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  RCR_RECURSOS_PROCEDIMIENTOS fin insert inicial. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS COMPUTE STATISTICS';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS ANALIZADA');
   
   
    
    -- Consulta, procedimientos sin BPM
    ------------------------------------
    
    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''MIG_MAESTRA_HITOS_VALORES_1'' and table_name=''MIG_MAESTRA_HITOS_VALORES'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX '||V_ESQUEMA||'.MIG_MAESTRA_HITOS_VALORES_1 ON '||V_ESQUEMA||'.MIG_MAESTRA_HITOS_VALORES(TAP_CODIGO, TEV_NOMBRE, TEV_VALOR) ');
    END IF;

    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''TAP_TAREA_PROCEDIMIENTO_IND_2'' and table_name=''TAP_TAREA_PROCEDIMIENTO'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO_IND_2 ON '||V_ESQUEMA||'.MIG_MAESTRA_HITOS_VALORES(TAP_CODIGO) ');
    END IF;


    ALTA_BPM_INSTANCES();
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin procedure '||V_ESQUEMA||'.ALTA_BPM_INSTANCES');
    
    ALTA_BPM_INSTANCES_SUBASTAS();
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin procedure '||V_ESQUEMA||'.ALTA_BPM_INSTANCES_SUBASTAS');

    -- Nuevo código que ha pasado BRUNO en la petición FASE-855
    ALTA_BPM_INSTANCES_SUBASTAS_2();
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin procedure '||V_ESQUEMA||'.ALTA_BPM_INSTANCES_SUBASTAS_2');

    -- Nuevo código que habría que incorporar
    ALTA_BPM_TRANSICIONES_AUTO();
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin procedure '||V_ESQUEMA||'.ALTA_BPM_TRANSICIONES_AUTO');
    
    MIG_TAR_LAMIN_TAREAS_CONFDES();
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin procedure '||V_ESQUEMA||'.MIG_TAR_LAMIN_TAREAS_CONFDES');

    MIG_TAR_TAREAS_PERENTORIAS();
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin procedure '||V_ESQUEMA||'.MIG_TAR_TAREAS_PERENTORIAS');

    MIG_TAR_LAMINACION_TAREAS();
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin procedure '||V_ESQUEMA||'.MIG_TAR_LAMINACION_TAREAS');
*/

--/***************************************
--*     FIN MIGRACION DESDE MAESTRA      *
--***************************************/

DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;






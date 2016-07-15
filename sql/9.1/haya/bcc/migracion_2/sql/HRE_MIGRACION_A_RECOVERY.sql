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
--##                  0.1 Versión inicial
--##                  0.2 Se incluyen procedimientos de tipo concursos.
--##       20151118 - 0.3 Adaptación a migracion HRE. NO migramos concursos.
--##                                                 LOS_LOTE_SUBASTAS
--##       20151123 - 0.4 Se cruza con la tabla de BIE_BIENES para cargar LOB_LOTE_BIEN y PRB_PRC_BIE
--##       20151127 - 0.5 Ponemos propiedad CAJAMAR - Gestion HAYA
--##       20151211 - 0.6 Seleccionamos arquetipo específico migración
--##       20160114 - 0.7 GMN Se asigna el DD_TPX_ID (tipo de expediente a recuperaciones - RECU)
--##       20160210 - 0.8 GMN Se filtra por marca HAYA y motivos ('EX','CN','IM','AR','MA','SC')
--##       20160321 - 0.9 GMN CMREC-2850: Se filtra por marca HAYA y motivos ('EX','CN','IM','AR','MA') EXCLUIMOs LA MARCA SC
--##       20160329 - 0.10 GMN Se incluye AL (ALCALA) en el filtro HAYA
--##       20160556 - 0.11 JTD nueva marca Haya 'CA'
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        V_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRA2HAYA02';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN

    
    -- BORRADO PREVIO DE TAREAS DUPLICADAS:
    ---------------------------------------
    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_BORRADO_TAR_DUP'' AND OWNER=''HAYA02''') INTO V_COUNT;

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
 
    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_BORRADO_TAR_DUP'' AND OWNER=''HAYA02''') INTO V_COUNT;

    IF V_COUNT = 1 THEN

        EXECUTE IMMEDIATE('DROP INDEX '||V_ESQUEMA||'.IDX_BORRADO_TAR_DUP');

    END IF;

--/***************************************
--*  INICIO MIGRACION DESDE MAESTRA      *
--***************************************/
 
          
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
          LEFT JOIN '||V_ESQUEMA||'.EXT_IAC_INFO_ADD_CONTRATO IAC 
                 ON cnt.cnt_id = iac.cnt_id
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
      FROM 
      	(        
        SELECT CD_PROCEDIMIENTO, CD_EXPEDIENTE_NUSE , NUMERO_EXP_NUSE FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA            	
--      UNION
--    	  SELECT CD_CONCURSO CD_PROCEDIMIENTO, NULL CD_EXPEDIENTE_NUSE , NULL NUMERO_EXP_NUSE FROM '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA
    	) PRC
    	, (SELECT DISTINCT CD_PROCEDIMIENTO FROM MIG_MAESTRA_HITOS) MAE
        , (SELECT ARQ_ID FROM '||V_ESQUEMA||'.ARQ_ARQUETIPOS WHERE ARQ_NOMBRE = ''Migracion''  AND BORRADO = 1) ARQ
        , ( select DISTINCT op.CD_PROCEDIMIENTO, op.numero_contrato
              from '||V_ESQUEMA||'.mig_procedimientos_operaciones op
                 , '||V_ESQUEMA||'.cnt_contratos cnt
                 , '||V_ESQUEMA||'.dd_ges_gestion_especial b
                 , '||V_ESQUEMA||'.dd_cre_condiciones_remun_ext r
             where op.numero_contrato = cnt.cnt_contrato
               and cnt.dd_ges_id = b.dd_ges_id 
               and cnt.dd_cre_id = r.dd_cre_id
               and b.dd_ges_codigo = ''HAYA'' 
               and r.dd_cre_codigo  in (''EX'',''CN'',''IM'',''AR'',''MA'',''AL'',''CA'') ) MARCA
     WHERE MAE.CD_PROCEDIMIENTO = PRC.CD_PROCEDIMIENTO
       AND PRC.CD_PROCEDIMIENTO = MARCA.CD_PROCEDIMIENTO');

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

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_OPERACIONES COMPUTE STATISTICS for all indexes');
--    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.MIG_CONCURSOS_OPERACIONES COMPUTE STATISTICS for all indexes');
    
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
          ) CAB,        
          '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP,
          '||V_ESQUEMA||'.DD_GES_GESTION_ASUNTO GES,
          '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO PAS
    WHERE EXP.CD_PROCEDIMIENTO = HIT.CD_PROCEDIMIENTO
    AND EXP.CD_PROCEDIMIENTO = CAB.CD_PROCEDIMIENTO
    AND decode(CAB.GESTION_PLATAFORMA,''N'',''HAYA'',''S'',''HAYA'') = GES.DD_GES_CODIGO                       
    AND decode(CAB.ENTIDAD_PROPIETARIA,''0240'',''CAJAMAR'',''05074'',''SAREB'') = PAS.DD_PAS_CODIGO');  
    
-- 23.316 Asuntos cargados.
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  ASU_ASUNTOS cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ASU_ASUNTOS COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  ASU_ASUNTOS Analizada');
    
--    EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.asu_asuntos asuc 
--                          set asuc.fechacrear = (select nvl(fecha_publicacion_boe, TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')) 
--                                                 from '||V_ESQUEMA||'.mig_concursos_cabecera 
--                                                 where cd_concurso = asuc.asu_id_externo)
--                       where exists (select 1 from '||V_ESQUEMA_MASTER||'.dd_tas_tipos_asunto tas1 
--                                     where tas1.dd_tas_id = asuc.dd_tas_id 
--                                     and tas1.dd_tas_codigo = ''02'')');
--
---- updateados 7.931 registros 
--                                     
--    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  ASU_ASUNTOS.FechaCrear cargada. '||SQL%ROWCOUNT||' Filas.');
--    COMMIT;


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
      )     
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
      ORDER BY 1');
    
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
         )
        SELECT DISTINCT 
                 MAE.TAR_ID
               , PRC.ASU_ID
               , NULL AS TAR_TAR_ID
               , 6 AS DD_EST_ID --ASUNTO en DD_EST_ESTADOS ITINERARIOS
               , 5 AS DD_EIN_ID ---PROCEDIMIENTO en DD_EIN_ENTIDAD_INFORMACION
               , NVL(tap.dd_sta_id,39) AS DD_STA_ID ---GESTOR POR DEFECTO (). LUEGO UN PROCESO UPDATEARA A GESTOR/SUPERVISOR ++
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

    ---------------
    --  SUBASTAS  --> MODIFICACIONES A CAUSA DE DUPLICADOS EN ORIGEN 
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
       EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_1 ON '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN(CD_LOTE,CD_BIEN) ');
    END IF;
    
    EXECUTE IMMEDIATE('Analyze table '||V_ESQUEMA||'.MIG_PROCS_SUBASTAS_LOTES_BIEN compute statistics FOR ALL INDEXES');
    
    EXECUTE IMMEDIATE('Analyze table '||V_ESQUEMA||'.LOS_LOTE_SUBASTA compute statistics FOR ALL INDEXES');

    existe := 0;
    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_BIE_CODIGO_EXTERNO'' and table_name=''BIE_BIEN'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE v_sql INTO existe;
    IF (existe=0) THEN
       EXECUTE IMMEDIATE('CREATE INDEX IDX_BIE_CODIGO_EXTERNO ON '||V_ESQUEMA||'.BIE_BIEN(BIE_CODIGO_EXTERNO) ');
    END IF;
    
    EXECUTE IMMEDIATE('analyze table '||V_ESQUEMA||'.BIE_BIEN compute statistics FOR ALL INDEXES'); 


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
							  AND D.CD_BIEN = E.BIE_CODIGO_INTERNO
                AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.LOB_LOTE_BIEN llb WHERE llb.los_id = los.los_id AND llb.bie_id = e.bie_id)'
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
            )
            SELECT '||V_ESQUEMA||'.S_PRB_PRC_BIE.NEXTVAL AS PRB_ID,
                   PRC_ID,
                   BIE_ID,
                   1 AS DD_SGB_ID, --SOLVENCIA
                   '''||USUARIO||''' AS USUARIOCREAR,
                   TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') AS FECHACREAR
            FROM(
                   SELECT DISTINCT A.PRC_ID, B.BIE_ID
                   FROM '||V_ESQUEMA||'.MIG_MAESTRA_HITOS A
                      , '||V_ESQUEMA||'.BIE_BIEN B
		      , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS C
                   WHERE A.CD_BIEN IS NOT NULL --tRAMITES DE aDJUDICACION PARA ARRIBA
                     AND A.CD_BIEN = B.BIE_CODIGO_INTERNO
		     AND A.PRC_ID = C.PRC_ID
                 UNION
                   SELECT DISTINCT D.PRC_ID, B.BIE_ID --SUBASTAS
                   FROM '||V_ESQUEMA||'.BIE_BIEN B
                      , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES C
                      , '||V_ESQUEMA||'.MIG_MAESTRA_HITOS D
                      , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS E
                   WHERE D.CD_BIEN IS NULL
                     AND D.DD_TPO_CODIGO = ''H002''
                     AND D.PRC_ID = E.PRC_ID
                     AND D.CD_PROCEDIMIENTO = C.CD_PROCEDIMIENTO
                     AND C.CD_BIEN = B.BIE_CODIGO_INTERNO
                 UNION
                    SELECT DISTINCT D.PRC_ID, B.BIE_ID --RESTO
                    FROM '||V_ESQUEMA||'.BIE_BIEN B
                       , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES C
                       , '||V_ESQUEMA||'.MIG_MAESTRA_HITOS D
                       , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS E
                    WHERE D.CD_BIEN IS NULL
                      AND D.PRC_ID = E.PRC_ID
                      AND D.DD_TPO_CODIGO <> ''H002''
                      AND D.CD_PROCEDIMIENTO = C.CD_PROCEDIMIENTO
                      AND C.CD_BIEN = B.BIE_CODIGO_INTERNO
                    ORDER BY 1,2)'
                 );

    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRB_PRC_BIE cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.PRB_PRC_BIE COMPUTE STATISTICS');    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  PRB_PRC_BIE Analizada');

    -- 21.416 registros cargados




    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');



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






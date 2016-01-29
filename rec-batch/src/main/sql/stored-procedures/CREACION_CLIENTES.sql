--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=NO-DISPONIBLE
--## INCIDENCIA_LINK=NO-DISPONIBLE
--## PRODUCTO=SI
--##
--## Finalidad: Procedure para la creación automática de clientes
--## INSTRUCCIONES: --
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

CREATE OR REPLACE PROCEDURE "CREACION_CLIENTES" IS

  V_ESQUEMA VARCHAR(30) := '#ESQUEMA#'; --HAYA01
  V_ESQUEMA_MASTER VARCHAR(30) := '#ESQUEMA_MASTER#'; --HAYAMASTER
  V_SQL VARCHAR2(4000);
  
BEGIN
	
        DBMS_OUTPUT.PUT_LINE('[START] CREACION CLIENTES');
        
        
        DBMS_OUTPUT.PUT_LINE('[INFO] Insertar personas arquetipadas en TMP_PER_ARQUETIPO_RECUPERACION');
        /************************************************* 
         Insertar las personas arquetipadas en TMP_PER_ARQUETIPO_RECUPERACION
         -----------------------------------------------------
        Solo insertamos las personas que su arquetipo sea de gestión
        **************************************************/
        
        V_SQL := 'TRUNCATE TABLE ' || V_ESQUEMA || '.TMP_PER_ARQUETIPO_RECUPERACION';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_PER_ARQUETIPO_RECUPERACION borrada');
        
        V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.TMP_PER_ARQUETIPO_RECUPERACION (
          PER_ID, ARQ_ID, CLI_ID, DD_TIT_CODIGO)
          WITH ARR AS (
          SELECT DISTINCT PER_ID, ARQ_ID FROM (
              SELECT PER_ID, ARQ_ID, ROW_NUMBER() OVER (PARTITION BY PER_ID ORDER BY ARQ_DATE DESC) ORD
              FROM ' || V_ESQUEMA || '.ARR_ARQ_RECUPERACION_PERSONA
            ) WHERE ORD = 1
          )
          --SELECT COUNT(ARR.PER_ID) FROM ARR
          SELECT ARR.PER_ID, ARR.ARQ_ID, ' || V_ESQUEMA || '.S_CLI_CLIENTES.NEXTVAL AS CLI_ID, TIT.DD_TIT_CODIGO FROM ARR
          INNER JOIN ' || V_ESQUEMA || '.ARQ_ARQUETIPOS ARQ ON ARR.ARQ_ID = ARQ.ARQ_ID AND ARQ.ARQ_GESTION = 1
          INNER JOIN ' || V_ESQUEMA || '.ITI_ITINERARIOS ITI ON ARQ.ITI_ID = ITI.ITI_ID
          INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_TIT_TIPO_ITINERARIOS TIT ON ITI.DD_TIT_ID = TIT.DD_TIT_ID
          WHERE NOT EXISTS ( -- No sea un cliente activo
          SELECT 1 FROM ' || V_ESQUEMA || '.CLI_CLIENTES CLI WHERE CLI.PER_ID = ARR.PER_ID AND (CLI.BORRADO=0 OR 
          CLI.DD_ECL_ID <> (SELECT DD_ECL_ID FROM ' || V_ESQUEMA_MASTER || '.DD_ECL_ESTADO_CLIENTE WHERE DD_ECL_CODIGO = ''2'')
          ))
          AND NOT EXISTS ( -- No tenga ningún expediente recuperación
          SELECT 1 FROM ' || V_ESQUEMA || '.PEX_PERSONAS_EXPEDIENTE PEX 
          INNER JOIN ' || V_ESQUEMA || '.EXP_EXPEDIENTES EXP ON PEX.EXP_ID = EXP.EXP_ID WHERE PEX.PER_ID = ARR.PER_ID AND PEX.BORRADO=0 AND EXP.BORRADO=0
          AND EXP.DD_EEX_ID <> (SELECT DD_EEX_ID FROM ' || V_ESQUEMA_MASTER || '.DD_EEX_ESTADO_EXPEDIENTE EEX WHERE EEX.DD_EEX_CODIGO = ''5'') -- El exp. no esta cancelado
          AND NOT EXISTS (SELECT 1 FROM ' || V_ESQUEMA || '.EXR_EXPEDIENTE_RECOBRO EXR WHERE EXR.EXP_ID = EXP.EXP_ID) -- El exp. no es de recobro
          )';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_PER_ARQUETIPO_RECUPERACION rellenada');
        
        
        
        
        /************************************************* 
         Insertar los contratos libres para todas las personas en TMP_CNT_NUEVOS_CLI
         -----------------------------------------------------
         Para averiguar el contrato de pase tendremos que aplicar distintos criterios según si
         El cliente es de recuperación (fecha pos vencida más antigua)
         El cliente es de seguimiento (riesgo mayor)
        **************************************************/
        
        V_SQL := 'TRUNCATE TABLE TMP_CNT_NUEVOS_CLI';
        EXECUTE IMMEDIATE V_SQL;
        
        V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.TMP_CNT_NUEVOS_CLI
        with vcpe as (select cpe_.per_id, cpe_.cnt_id --Obtengo solo los contratos con los titulares
              from ' || V_ESQUEMA || '.cpe_contratos_personas cpe_ 
              inner join ' || V_ESQUEMA || '.dd_tin_tipo_intervencion tin on cpe_.dd_tin_id = tin.dd_tin_id
              where tin.dd_tin_titular = 1
              AND NOT EXISTS (SELECT CEX.CEX_ID FROM ' || V_ESQUEMA || '.cex_contratos_expediente CEX WHERE CEX.CNT_ID = CPE_.CNT_ID)
              AND NOT EXISTS (SELECT CCL.CCL_ID FROM ' || V_ESQUEMA || '.CCL_CONTRATOS_CLIENTE CCL WHERE CCL.CNT_ID = CPE_.CNT_ID))
        , mov as (  --De los anteriores personas y titulares, ordenados por fecha pos vencida ó riesgo
            select vcpe.per_id, row_mov.cnt_id, row_mov.mov_fecha_extraccion, row_mov.mov_fecha_pos_vencida, row_mov.mov_riesgo
              , row_number () over (partition by per_id order by row_mov.mov_fecha_pos_vencida) n_fecha_pos_vencida
              , row_number () over (partition by per_id order by row_mov.mov_riesgo desc) n_mov_riesgo
            from vcpe inner join ' || V_ESQUEMA || '.mov_movimientos row_mov on vcpe.cnt_id = row_mov.cnt_id    
        )
        select distinct tmp.per_id, cpe.cnt_id, cnt.ofi_id, mov.mov_fecha_pos_vencida
          --, case when NVL(mov.titular,0) = 1 then --Comentamos porque ahora son todos titulares
                  ,case when tmp.dd_tit_codigo = ''REC'' then -- Recuperacion, vamos por fecha
                        case mov.n_fecha_pos_vencida when 1 then 1 else 0 end
                      else -- Seguimiento, vamos por riesgo
                        case mov.n_mov_riesgo when 1 then 1 else 0 end
                      end es_cnt_pase
        --      else 0 -- si no es titular directamente no es contrato de pase
        --    end es_cnt_pase
        from ' || V_ESQUEMA || '.TMP_PER_ARQUETIPO_RECUPERACION tmp
          join ' || V_ESQUEMA || '.cpe_contratos_personas cpe on tmp.per_id = cpe.per_id
          join ' || V_ESQUEMA || '.cnt_contratos cnt on cpe.cnt_id = cnt.cnt_id 
          left join mov on cnt.cnt_id = mov.cnt_id and cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion and mov.per_id = tmp.per_id';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Tabla temporal TMP_CNT_NUEVOS_CLI rellenada');
        
        
        --
        -- ATENCIÓN: Debemos poner en marcha el BATCH que calcula los antecedentes de la persona PER_PERSONAS.ANT_ID
        --
        
        
        /************************************************* 
        Insertar los clientes
        *************************************************/
        V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.CLI_CLIENTES
          (
            CLI_ID, PER_ID,ARQ_ID, DD_EST_ID, CLI_FECHA_EST_ID, CLI_PROCESS_BPM, DD_ECL_ID,
            VERSION, USUARIOCREAR, FECHACREAR, BORRADO,
            OFI_ID, CLI_FECHA_CREACION,
            PTE_ID, CLI_TELECOBRO, CLI_FECHA_GV
          )
        SELECT TMP.CLI_ID, TMP.PER_ID, TMP.ARQ_ID, EST.DD_EST_ID
          , SYSDATE AS CLI_FECHA_EST_ID
          , NULL AS CLI_PROCESS_BPM 
          , ECL.DD_ECL_ID 
          , 0 AS VERSION , ''BATCH'' AS USUARIOCREAR ,SYSDATE AS FECHACREAR , 0 AS BORRADO -- Auditoria
          , TMP_CNT.OFI_ID
          , NVL(TMP_CNT.FECHA_POS_VENCIDA, SYSDATE) AS CLI_FECHA_CREACION
          , NULL AS PTE_ID --PROVEEDOR TELECOBRO
          , ''0'' AS CLI_TELECOBRO --CLIENTE TELECOBRO
          , NULL AS CLI_FECHA_GV -- FECHA GESTION VENCIDOS
        FROM ' || V_ESQUEMA || '.TMP_PER_ARQUETIPO_RECUPERACION TMP
          JOIN HAYAMASTER.dd_est_estados_itinerarios EST ON EST.DD_EST_CODIGO = ''CAR''
          join HAYAMASTER.dd_ecl_estado_cliente ECL ON ECL.DD_ECL_CODIGO = ''1''
          JOIN TMP_CNT_NUEVOS_CLI TMP_CNT ON TMP.PER_ID = TMP_CNT.PER_ID AND TMP_CNT.ES_CNT_PASE = 1'
        ;
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Clientes insertados');
        
        --DELETE FROM CLI_CLIENTES WHERE USUARIOCREAR = 'BATCH'
        
        
        /************************************************* 
        Insertar los contratos de los clientes
        **************************************************/
        V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.CCL_CONTRATOS_CLIENTE
        (CCL_ID, CLI_ID, CNT_ID, CCL_PASE
          ,VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
        WITH contratos AS (
        SELECT DISTINCT TMP.CLI_ID
          , CPE.CNT_ID
          , NVL(TCNT.ES_CNT_PASE, 0) AS CCL_PASE
          FROM ' || V_ESQUEMA || '.TMP_PER_ARQUETIPO_RECUPERACION TMP 
          inner join ' || V_ESQUEMA || '.cpe_contratos_personas cpe on tmp.per_id = cpe.per_id
          RIGHT JOIN ' || V_ESQUEMA || '.TMP_CNT_NUEVOS_CLI TCNT ON CPE.PER_ID = TCNT.PER_ID AND CPE.CNT_ID = TCNT.CNT_ID  
        )  
        SELECT ' || V_ESQUEMA || '.S_CCL_CONTRATOS_CLIENTE.NEXTVAL, CNT.CLI_ID, CNT.CNT_ID, CNT.CCL_PASE
        , 0 AS VERSION , ''BATCH'' AS USUARIOCREAR ,SYSDATE AS FECHACREAR , 0 AS BORRADO -- Auditoria
        FROM ' || V_ESQUEMA || '.contratos CNT';
        
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Contratos de los clientes insertados');



        COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN] CREACION CLIENTES');

  EXCEPTION
       WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN: '||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);

            ROLLBACK;
            RAISE;

END;
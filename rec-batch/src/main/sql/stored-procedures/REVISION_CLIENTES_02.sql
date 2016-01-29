CREATE OR REPLACE 
PACKAGE BODY PKG_REVISION_CLIENTES
IS
  V_ESQUEMA        VARCHAR(30) := 'HAYA01';
  V_ESQUEMA_MASTER VARCHAR(30) := 'HAYAMASTER';
  V_SQL            VARCHAR2(4000);
  

PROCEDURE cancelarClientes
AS
BEGIN
  DBMS_OUTPUT.PUT_LINE( '[START] CANCELAR CLIENTES');
  DBMS_OUTPUT.PUT_LINE('[INFO] Borrar contratos de los clientes de la tabla TMP_CLI_A_CANCELAR');
  -- borrar contratos
  V_SQL := 'UPDATE ' || V_ESQUEMA || '.CCL_CONTRATOS_CLIENTE CCL      
      SET BORRADO    =1,        
          USUARIOBORRAR=''REV-JOB'',        
          FECHABORRAR  = SYSDATE      
      WHERE EXISTS        
        (SELECT CLI_ID FROM ' || V_ESQUEMA || '.TMP_CLI_A_CANCELAR TMP WHERE CCL.CLI_ID = TMP.CLI_ID)';
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE ('[INFO] Contratos de los clientes borrados');
  -- setear el estado = 2 al cliente (Cancelado)
  V_SQL := 'UPDATE ' || V_ESQUEMA || '.CLI_CLIENTES CLI      
      SET BORRADO    =1,        
          USUARIOBORRAR=''REV-JOB'',        
          FECHABORRAR  =SYSDATE,        
          DD_ECL_ID    =        
            (SELECT DD_ECL_ID        
            FROM ' || V_ESQUEMA_MASTER || '.DD_ECL_ESTADO_CLIENTE        
            WHERE DD_ECL_CODIGO = 2)      
      WHERE EXISTS        
        (SELECT CLI_ID FROM ' || V_ESQUEMA || '.TMP_CLI_A_CANCELAR TMP WHERE CLI.CLI_ID = TMP.CLI_ID)';
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE ('[INFO] Clientes cancelados');
  --Eliminar favoritos por entidad
  V_SQL := 'UPDATE ' || V_ESQUEMA || '.HAC_HISTORICO_ACCESOS HAC      
      SET BORRADO   = 1,        
          USUARIOBORRAR = ''REV-JOB'',        
          FECHABORRAR   = SYSDATE       
      WHERE EXISTS        
        (SELECT CLI.PER_ID          
        FROM ' || V_ESQUEMA || '.TMP_CLI_A_CANCELAR TMP          
        INNER JOIN ' || V_ESQUEMA || '.CLI_CLIENTES CLI          
          ON TMP.CLI_ID    = CLI.CLI_ID          
        WHERE cli.per_id = HAC.PER_ID)';
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE ('[INFO] Eliminados los clientes del panel de favoritos');
  
  DBMS_OUTPUT.PUT_LINE('[FIN] CANCELAR CLIENTES');
END;

PROCEDURE registrarAntecedentes
AS
BEGIN

/***************************
SI LOS CONTRATOS ESTÁN SALDADOS SE ACTUALIZAN LOS ANTECEDENTES
****************************/

  /********************************
  INCREMENTAR ANTECEDENTES
  ********************************/
  V_SQL := 'UPDATE ' || V_ESQUEMA || '.ant_antecedentes
        SET ANT_REINCIDENCIA_INTERNOS=NVL(ANT_REINCIDENCIA_INTERNOS+1, 1),
            USUARIOMODIFICAR=''REV-JOB'',
            FECHAMODIFICAR=SYSDATE
        WHERE ANT_ID IN 
        (
          SELECT p.ant_id 
          FROM ' || V_ESQUEMA || '.cpe_contratos_personas cpe, ' || V_ESQUEMA || '.per_personas p, 
            ' || V_ESQUEMA || '.dd_tin_tipo_intervencion tin
          WHERE p.per_id = cpe.per_id
            AND tin.DD_TIN_ID = cpe.DD_TIN_ID
            AND tin.DD_TIN_TITULAR = 1 
            AND EXISTS
            (          
              SELECT TMP_MOV.CNT_ID
                FROM ' || V_ESQUEMA || '.TMP_MOV_REVISADOS TMP_MOV    
                  INNER JOIN ' || V_ESQUEMA || '.ccl_contratos_cliente CCL    
                    ON TMP_MOV.CNT_ID                = CCL.CNT_ID    
                WHERE     
                  TMP_MOV.CANCELADO = 0 
                  AND TMP_MOV.SALDADO = 1  
                  AND NOT tmp_mov.fechavencido IS NULL         
                  AND tmp_mov.cnt_id = cpe.cnt_id
            )
        )';
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE ('[INFO] Antecedentes incrementados');
/************************************
ACTUALIZAR ANTECEDENTES INTERNOS
************************************/
  V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.AIN_ANTECEDENTEINTERNOS AIN USING (
    SELECT DISTINCT TMP_MOV.CNT_ID, tmp_mov.fechaextraccion-TMP_MOV.FECHAVENCIDO DIAS_DESCUBIERTO, TMP_MOV.IMPORTEANTERIOR, TMP_MOV.FECHAEXTRACCION
        FROM ' || V_ESQUEMA || '.TMP_MOV_REVISADOS TMP_MOV    
        INNER JOIN ' || V_ESQUEMA || '.ccl_contratos_cliente CCL ON TMP_MOV.CNT_ID      = CCL.CNT_ID    
        WHERE     
          TMP_MOV.CANCELADO = 0 
          AND TMP_MOV.SALDADO = 1  
          AND NOT tmp_mov.fechavencido IS NULL
  ) ORIGEN ON (AIN.CNT_ID = ORIGEN.CNT_ID)
  WHEN MATCHED THEN
  UPDATE 
    SET AIN_POS_IRREGULAR_MAX=CASE WHEN(ABS(AIN_POS_IRREGULAR_MAX ) > ABS(ORIGEN.IMPORTEANTERIOR)) THEN AIN_POS_IRREGULAR_MAX ELSE ORIGEN.IMPORTEANTERIOR END,
            AIN_DIAS_MAX_IRREGULAR=CASE WHEN(AIN_DIAS_MAX_IRREGULAR > ORIGEN.DIAS_DESCUBIERTO) THEN AIN_DIAS_MAX_IRREGULAR ELSE ORIGEN.DIAS_DESCUBIERTO END,
            AIN_FECHA_ULT_REGULARIZACION= ORIGEN.FECHAEXTRACCION, --to_date(?, ''yyyy-MM-dd''),
            USUARIOMODIFICAR=''REV-JOB'',
            FECHAMODIFICAR=SYSDATE
  WHEN NOT MATCHED THEN
    INSERT (AIN_ID, CNT_ID, AIN_POS_IRREGULAR_MAX, AIN_DIAS_MAX_IRREGULAR, AIN_FECHA_ULT_REGULARIZACION, USUARIOCREAR, FECHACREAR)
        values (s_ain_antecedenteinternos.nextVal, ORIGEN.CNT_ID, ORIGEN.IMPORTEANTERIOR, ORIGEN.DIAS_DESCUBIERTO, ORIGEN.FECHAEXTRACCION, ''REV-JOB'', SYSDATE)' ;
  EXECUTE IMMEDIATE V_SQL;
  
DBMS_OUTPUT.PUT_LINE ('[INFO] Antecedentes internos actualizados');

END;

PROCEDURE informarContratosReducidos
AS
BEGIN

    V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.REC_RECUPERACIONES (REC_ID, CNT_ID, REC_FECHA_ENTREGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
      WITH V_MOV AS (
      SELECT DISTINCT (TMP_MOV.CNT_ID), TMP_MOV.FECHAEXTRACCION
      FROM ' || V_ESQUEMA || '.TMP_MOV_REVISADOS TMP_MOV
      WHERE TMP_MOV.DIFERENCIA > 0
      AND NOT EXISTS
        (SELECT rec_id
        FROM ' || V_ESQUEMA || '.rec_recuperaciones
        WHERE cnt_id           = TMP_MOV.CNT_ID  
        AND rec_fecha_entrega  = TMP_MOV.FECHAEXTRACCION
        )
      )
  SELECT S_REC_RECUPERACIONES.NEXTVAL,  CCL.cnt_id,  V_MOV.FECHAEXTRACCION,  0 ,  ''REV-JOB'',  SYSDATE,  0
    FROM ' || V_ESQUEMA || '.V_MOV INNER JOIN ' || V_ESQUEMA || '.ccl_contratos_cliente CCL ON V_MOV.CNT_ID = CCL.CNT_ID AND CCL.BORRADO = 0';
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE ('[INFO] Contratos reducidos almacenados en REC_RECUPERACIONES');
  
END;

PROCEDURE revisarContratosPase
AS  
BEGIN

    dbms_output.put_line ('[INFO] Revisar contratos ');
    
    
    /***********************************
    CONTRATOS CANCELADOS DE PASE - Se cancelan siempre todos los clientes    
    ***********************************/
     V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.TMP_CLI_A_CANCELAR TMP_CLI USING 
        (    
          SELECT DISTINCT (CCL.CLI_ID)    
            FROM ' || V_ESQUEMA || '.TMP_MOV_REVISADOS TMP_MOV    
            INNER JOIN ' || V_ESQUEMA || '.ccl_contratos_cliente CCL    
              ON TMP_MOV.CNT_ID   = CCL.CNT_ID 
              AND CCL.CCL_PASE    = 1   
              AND CCL.BORRADO     = 0
          WHERE     
            (TMP_MOV.CANCELADO = 1)
              AND TMP_MOV.ES_PASE = 1              
        ) ORIGEN ON (TMP_CLI.CLI_ID  = ORIGEN.CLI_ID)
        WHEN NOT MATCHED THEN  
          INSERT (CLI_ID) VALUES (ORIGEN.CLI_ID)';
    EXECUTE IMMEDIATE V_SQL;
    
        
    /**************************************
    CONTRATOS SALDADOS DE PASE - Cancelamos los clientes que 
    su itinerario sea de recuperación
    **************************************/
    V_SQL := 'MERGE INTO TMP_CLI_A_CANCELAR TMP_CLI USING 
        (    
          SELECT DISTINCT (CCL.CLI_ID)    
            FROM ' || V_ESQUEMA || '.TMP_MOV_REVISADOS TMP_MOV    
            INNER JOIN ' || V_ESQUEMA || '.ccl_contratos_cliente CCL    
              ON TMP_MOV.CNT_ID   = CCL.CNT_ID 
              AND CCL.CCL_PASE    = 1
              AND CCL.BORRADO     = 0
          WHERE     
          (TMP_MOV.CANCELADO = 0 
          AND (
                TMP_MOV.SALDADO = 1 
                  OR 
                TMP_MOV.SALDADOSINMOVANTERIOR = 1)
              )    
          AND TMP_MOV.ES_PASE       = 1          
          AND TMP_MOV.DD_TIT_CODIGO = ''REC''          
      ) ORIGEN ON (TMP_CLI.CLI_ID      = ORIGEN.CLI_ID)
        WHEN NOT MATCHED THEN  
          INSERT (CLI_ID) VALUES (ORIGEN.CLI_ID)';
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE ('[INFO] Añadido los nuevos clientes a cancelar que han saldado su deuda');
END;


PROCEDURE borrarCntCancelados
AS  
BEGIN

    dbms_output.put_line ('[INFO] cancelar contratos ');
    
    
    /***********************************
    CONTRATOS CANCELADOS NO PASE - Se cancelan los contratos    
    ***********************************/
     V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.CCL_CONTRATOS_CLIENTE CCL USING 
        (    
          SELECT DISTINCT (TMP_MOV.CNT_ID)    
            FROM ' || V_ESQUEMA || '.TMP_MOV_REVISADOS TMP_MOV            
          WHERE     
            (TMP_MOV.CANCELADO = 1)
              AND TMP_MOV.ES_PASE = 0              
        ) ORIGEN ON (CCL.CNT_ID  = ORIGEN.CNT_ID)
        WHEN MATCHED THEN 
        UPDATE
          SET BORRADO = 1,
              USUARIOBORRAR = ''REV-JOB'',
              FECHABORRAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    

    DBMS_OUTPUT.PUT_LINE ('[INFO] Contratos cancelados');
END;


PROCEDURE insertarNuevosContratos
AS
      ESTADO_PRC_PROPUESTO CONSTANT VARCHAR(2) := '01';
      ESTADO_PRC_CONFIRMADO CONSTANT VARCHAR(2) := '02';
      ESTADO_PRC_ACEPTADO CONSTANT VARCHAR(2) := '03';
      ESTADO_PRC_DERIVADO CONSTANT VARCHAR(2) := '06';
      ESTADO_PRC_EN_CONFORMACION CONSTANT VARCHAR(2) := '07';
      
      ESTADO_EXP_ACTIVO CONSTANT VARCHAR(2) := '1';
      ESTADO_EXP_BLOQUEADO CONSTANT VARCHAR(2) := '4';
      ESTADO_EXP_CONGELADO CONSTANT VARCHAR(2) := '2';
            
BEGIN

  V_SQL := 'INSERT INTO ccl_contratos_cliente (CCL_ID, CNT_ID, CLI_ID, CCL_PASE, USUARIOCREAR, FECHACREAR)
      SELECT s_ccl_contratos_cliente.nextVal, cpe.cnt_id, cli_id, 0,  ''REV-JOB'', sysdate
      FROM ' || V_ESQUEMA || '.cli_clientes cli, ' || V_ESQUEMA || '.cpe_contratos_personas cpe, ' || V_ESQUEMA || '.cnt_contratos cnt
          WHERE cli.cli_id IN (SELECT CLI_ID FROM TMP_CLI_PER_ARQ)
          AND cpe.per_id = cli.per_id
          AND cpe.cnt_id = cnt.cnt_id        
          AND cli.borrado = 0 AND cpe.borrado = 0 AND cnt.borrado = 0
          /* Que el contrato no esté en algún procedimiento en curso */
          AND NOT EXISTS (
              SELECT DISTINCT cex.cnt_id 
              FROM ' || V_ESQUEMA || '.CEX_CONTRATOS_EXPEDIENTE cex, ' || V_ESQUEMA || '.PRC_CEX pce, ' || V_ESQUEMA || '.PRC_PROCEDIMIENTOS prc, ' || V_ESQUEMA_MASTER || '.DD_EPR_ESTADO_PROCEDIMIENTO epr
              WHERE cex.cnt_id = cnt.cnt_id
              and cex.cex_id = pce.cex_id
              and pce.prc_id = prc.prc_id
              and cex.borrado = 0 and prc.borrado = 0
              and prc.dd_epr_id = epr.dd_epr_id
              and dd_epr_codigo IN (''' || ESTADO_PRC_PROPUESTO || ''', ''' || ESTADO_PRC_CONFIRMADO || ''', ''' || ESTADO_PRC_ACEPTADO || ''', ''' || ESTADO_PRC_DERIVADO || ''', ''' || ESTADO_PRC_EN_CONFORMACION || ''')
          )
          /* Que el contrato no esté en algún expediente en curso */
          AND NOT EXISTS (
              SELECT DISTINCT cex.cnt_id 
              FROM ' || V_ESQUEMA || '.cex_contratos_expediente cex, ' || V_ESQUEMA_MASTER || '.dd_eex_estado_expediente eex, ' || V_ESQUEMA || '.exp_expedientes exp 
              WHERE cnt.cnt_id = cnt.cnt_id 
              and exp.exp_id = cex.exp_id 
              and cex.borrado = 0 
              and eex.dd_eex_id = exp.dd_eex_id
              and eex.dd_eex_codigo IN (''' || ESTADO_EXP_ACTIVO || ''', ''' || ESTADO_EXP_BLOQUEADO || ''', ''' || ESTADO_EXP_CONGELADO || ''')
          ) 
          /* Que ese mismo contrato no pertenezca ya al cliente */
          AND NOT EXISTS (
              SELECT cnt_id FROM ' || V_ESQUEMA || '.ccl_contratos_cliente 
              WHERE cnt_id = cnt.cnt_id
              and cli_id = cli.cli_id 
              and borrado = 0
          )';
  EXECUTE IMMEDIATE V_SQL;
      
  DBMS_OUTPUT.PUT_LINE ('[INFO] Añadido los nuevos contratos de los clientes');
END;

PROCEDURE marcarClientesSinGestion
AS
BEGIN


  /*********************************************
  Insertamos los clientes a borrar en TMP_CLI_A_CANCELAR
  que su arquetipo ya no sea de gestión
  *********************************************/
   
  V_SQL := 'TRUNCATE TABLE ' || V_ESQUEMA || '.TMP_CLI_A_CANCELAR';
  EXECUTE IMMEDIATE V_SQL;  
  DBMS_OUTPUT.PUT_LINE ('[INFO] tabla temporal tmp_cli_a_cancelar truncada');  
 
  V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.TMP_CLI_A_CANCELAR      
      (SELECT CLI_ID        
        FROM ' || V_ESQUEMA || '.TMP_CLI_PER_ARQ        
      WHERE ARQ_CLIENTE <> ARQ_PERSONA AND ES_ARQ_GESTION = 0)';
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE ('[INFO] Preparados clientes a borrar con distinto arquetipo y gestion = 0');
  
  
END;


PROCEDURE asignarNuevosArquetipos
AS
BEGIN

/*************************************************
  Asignar nuevo arquetipo al cliente
  ************************************************/
  V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.CLI_CLIENTES CLI USING 
    (
      SELECT CLI_ID, ARQ_PERSONA 
        FROM ' || V_ESQUEMA || '.TMP_CLI_PER_ARQ   
        WHERE ARQ_CLIENTE <> ARQ_PERSONA  AND ES_ARQ_GESTION = 1
    ) ORIGEN ON (CLI.CLI_ID = ORIGEN.CLI_ID)
    WHEN MATCHED THEN
      UPDATE 
        SET CLI.ARQ_ID = ARQ_PERSONA,
          USUARIOMODIFICAR = ''REV-JOB'',
          FECHAMODIFICAR = SYSDATE';
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE ('[INFO] Asignados nuevos arquetipos al cliente');
  
  
END;

PROCEDURE recalcularEstadosCliente
AS
BEGIN

  V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.CLI_CLIENTES CLI USING
		(     
    WITH fechasEstados AS
		  (SELECT SYSDATE - ((((SUM(est.est_plazo)/1000)/24)/60)/60) fecha,
		    ARQ_ID
		  FROM ' || V_ESQUEMA || '.arq_arquetipos arq
		  INNER JOIN ' || V_ESQUEMA || '.iti_itinerarios iti
		    ON arq.iti_id = iti.iti_id
		  INNER JOIN ' || V_ESQUEMA || '.est_estados est
		    ON iti.iti_id = est.iti_id
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.dd_est_estados_itinerarios dd_est
		    ON est.dd_est_id         = dd_est.dd_est_id
		    AND DD_EST.DD_EST_ORDEN <= --Sumamos todos los plazos que estén por debajo de Carencia si los hubiera
		      (SELECT DD_EST_ORDEN
		      FROM ' || V_ESQUEMA_MASTER || '.DD_EST_ESTADOS_ITINERARIOS
		      WHERE DD_EST_CODIGO = ''CAR''
		      )
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_EIN_ENTIDAD_INFORMACION DD_EIN --Solo los de la entidad cliente
		    ON DD_EST.DD_EIN_ID = DD_EIN.DD_EIN_ID
		    AND DD_EIN_CODIGO   = ''1''
		  GROUP BY ARQ.ARQ_ID
		  )
		  SELECT cli.cli_id
		  FROM ' || V_ESQUEMA || '.cli_clientes cli
		  INNER JOIN ' || V_ESQUEMA || '.fechasEstados vFechas
		    ON cli.arq_id = vFechas.arq_id
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.dd_est_estados_itinerarios dd_est --Los itinerarios de Carencia
		    ON cli.dd_est_id  = dd_est.dd_est_id
		    AND dd_est.dd_est_codigo = ''CAR''
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_EIN_ENTIDAD_INFORMACION DD_EIN --Los de la entidad cliente
		    ON DD_EST.DD_EIN_ID                             = DD_EIN.DD_EIN_ID
		    AND DD_EIN_CODIGO                               = ''1''
		  WHERE CLI.BORRADO                               = 0
		    AND TO_DATE(CLI.CLI_FECHA_CREACION,''DD/MM/YY'') <= vFechas.fecha  --Que no haya pasado el plazo del itinerario
		) ORIGEN ON (CLI.CLI_ID = ORIGEN.CLI_ID)
		WHEN MATCHED THEN
		  UPDATE
		  SET CLI.DD_EST_ID = --Cambiamos el estado a GestiónVencidos de la entidad cliente
		    (SELECT dd_est.dd_est_id
		    FROM ' || V_ESQUEMA_MASTER || '.dd_est_estados_itinerarios dd_est
		    INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_EIN_ENTIDAD_INFORMACION DD_EIN
		    ON DD_EST.DD_EIN_ID = DD_EIN.DD_EIN_ID
		    AND DD_EIN_CODIGO   = ''1''
		    WHERE dd_est_codigo = ''GV''
		    ) ,
		    CLI_FECHA_EST_ID = SYSDATE,
        USUARIOMODIFICAR = ''REV-JOB'',
        FECHAMODIFICAR = SYSDATE'; --Fecha que cambió el estado
        
  EXECUTE IMMEDIATE V_SQL;
                
  DBMS_OUTPUT.PUT_LINE ('[INFO] Clientes pasados a GV');
        
        
        
  V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.CLI_CLIENTES CLI USING
		(            
    WITH fechasEstados AS
		  (SELECT SYSDATE - ((((SUM(est.est_plazo)/1000)/24)/60)/60) fecha,
		    ARQ_ID
		  FROM ' || V_ESQUEMA || '.arq_arquetipos arq
		  INNER JOIN ' || V_ESQUEMA || '.iti_itinerarios iti
		    ON arq.iti_id = iti.iti_id
		  INNER JOIN ' || V_ESQUEMA || '.est_estados est
		    ON iti.iti_id = est.iti_id
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.dd_est_estados_itinerarios dd_est
		    ON est.dd_est_id         = dd_est.dd_est_id
		    AND DD_EST.DD_EST_ORDEN <= --Sumamos todos los plazos que estén por debajo de Carencia si los hubiera
		      (SELECT DD_EST_ORDEN
		      FROM ' || V_ESQUEMA_MASTER || '.DD_EST_ESTADOS_ITINERARIOS
		      WHERE DD_EST_CODIGO = ''CAR''
		      )
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_EIN_ENTIDAD_INFORMACION DD_EIN --Solo los de la entidad cliente
		    ON DD_EST.DD_EIN_ID = DD_EIN.DD_EIN_ID
		    AND DD_EIN_CODIGO   = ''1''
		  GROUP BY ARQ.ARQ_ID
		  )
		  SELECT cli.cli_id, cli.cli_fecha_creacion, vFechas.fecha
		  FROM ' || V_ESQUEMA || '.cli_clientes cli
		  INNER JOIN ' || V_ESQUEMA || '.fechasEstados vFechas
		    ON cli.arq_id = vFechas.arq_id
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.dd_est_estados_itinerarios dd_est --Los itinerarios de Carencia
		    ON cli.dd_est_id  = dd_est.dd_est_id
		    AND dd_est.dd_est_codigo = ''GV''
		  INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_EIN_ENTIDAD_INFORMACION DD_EIN --Los de la entidad cliente
		    ON DD_EST.DD_EIN_ID                             = DD_EIN.DD_EIN_ID
		    AND DD_EIN_CODIGO                               = ''1''
		  WHERE CLI.BORRADO                               = 0
		    AND TO_DATE(CLI.CLI_FECHA_CREACION,''DD/MM/YY'') >= vFechas.fecha  --Que haya pasado el plazo del itinerario
	) ORIGEN ON (CLI.CLI_ID = ORIGEN.CLI_ID)
		WHEN MATCHED THEN
		  UPDATE
		  SET CLI.DD_EST_ID = --Cambiamos el estado a GestiónVencidos de la entidad cliente
		    (SELECT dd_est.dd_est_id
		    FROM ' || V_ESQUEMA_MASTER || '.dd_est_estados_itinerarios dd_est
		    INNER JOIN ' || V_ESQUEMA_MASTER || '.DD_EIN_ENTIDAD_INFORMACION DD_EIN
		    ON DD_EST.DD_EIN_ID = DD_EIN.DD_EIN_ID
		    AND DD_EIN_CODIGO   = ''1''
		    WHERE dd_est_codigo = ''GV''
		    ) ,
		    CLI_FECHA_EST_ID = SYSDATE,
        USUARIOMODIFICAR = ''REV-JOB'',
        FECHAMODIFICAR = SYSDATE'; --Fecha que cambió el estado
        
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE ('[INFO] Clientes vueltos a CAR');

END;

PROCEDURE marcarMovARevisar
AS
BEGIN

/***************************************************
  Revisar movimientos 
  -- TODO - y generar notificaciones
  *****************************************************/
 
  V_SQL := 'TRUNCATE TABLE TMP_MOV_REVISADOS';
  EXECUTE IMMEDIATE V_SQL;  
  DBMS_OUTPUT.PUT_LINE ('[INFO] Borrar tabla temporal TMP_MOV_REVISADOS');
  
  V_SQL :=
  'INSERT INTO ' || V_ESQUEMA || '.TMP_MOV_REVISADOS 
      WITH vTMP_CNT AS
      ( --Obtenemos los contratos de los clientes que el iti. es de gestión      
      SELECT ccl.CNT_ID, tmp.cli_id, tmp.arq_persona, dd_tit.dd_tit_codigo, ccl.ccl_pase es_pase      
        FROM ' || V_ESQUEMA || '.tmp_cli_per_arq tmp      
        INNER JOIN ' || V_ESQUEMA || '.ccl_contratos_cliente ccl ON tmp.cli_id  = ccl.cli_id  AND tmp.es_arq_gestion = 1 and ccl.borrado = 0
        inner join ' || V_ESQUEMA || '.arq_arquetipos arq on tmp.arq_cliente = arq.arq_id and arq.borrado=0
        inner join ' || V_ESQUEMA || '.iti_itinerarios iti on arq.iti_id = iti.iti_id and iti.borrado=0
        inner join ' || V_ESQUEMA_MASTER || '.dd_tit_tipo_itinerarios dd_tit on iti.dd_tit_id = dd_tit.dd_tit_id and dd_tit.borrado=0      
      )
(SELECT C.CNT_ID, v.CLI_ID, v.arq_persona, v.dd_tit_codigo, v.es_pase,     
CASE 
    WHEN e.dd_esc_codigo <> 0 --Cancelado es cualquier tipo que no sea activo, no solo el 7   
      THEN 1        
    ELSE 0      
  END Cancelado,      
CASE 
    WHEN (movAct.mov_deuda_irregular = 0)        
      THEN 1        
    ELSE 0      
  END SaldadoSinMovAnterior,      
CASE        
    WHEN (movAct.mov_deuda_irregular = 0 AND movAnt.mov_deuda_irregular  <> 0)        
      THEN 1        
    ELSE 0      
  END Saldado,      
  NVL(movAnt.mov_deuda_irregular - movAct.mov_deuda_irregular, 0) Diferencia,      
  movAct.mov_deuda_irregular Importe,      
  movAnt.mov_deuda_irregular ImporteAnterior,      
  t.dd_tpe_activo activo,      
  movAnt.MOV_FECHA_POS_VENCIDA fechaVencido,      
  movAct.mov_fecha_extraccion fechaExtraccion    
FROM ' || V_ESQUEMA || '.cnt_contratos c,      
  ' || V_ESQUEMA || '.dd_tpe_tipo_prod_entidad t,      
  ' || V_ESQUEMA || '.mov_movimientos movAct,      
  ' || V_ESQUEMA || '.mov_movimientos movAnt,      
  ' || V_ESQUEMA_MASTER || '.dd_esc_estado_cnt e,      
  ' || V_ESQUEMA || '.VTMP_CNT V    
WHERE c.dd_tpe_id = t.dd_tpe_id    
  AND C.CNT_ID IN (SELECT CNT_ID FROM vTMP_CNT)          
  AND c.dd_esc_id                 = e.dd_esc_id    
  AND movAct.cnt_id               = c.cnt_id    
  AND movAct.MOV_FECHA_EXTRACCION = c.cnt_fecha_extraccion    
  AND movAnt.cnt_id               = c.cnt_id    
  AND movAnt.MOV_FECHA_EXTRACCION =      
  (SELECT        
    CASE          
        WHEN MAX(mov_fecha_extraccion)IS NULL          
          THEN c.cnt_fecha_extraccion          
        ELSE MAX(mov_fecha_extraccion)        
    END      
  FROM mov_movimientos      
  WHERE mov_fecha_extraccion < c.cnt_fecha_extraccion      
    AND CNT_ID                 = c.cnt_id      
)    
AND V.CNT_ID = C.CNT_ID  
)';
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE ('[INFO] Almacenados los movimientos para revisar en la tabla temporal TMP_MOV_REVISADOS');
  
END;

PROCEDURE marcarCliPerArq
AS
BEGIN

  /*************************************************
  Insertar los clientes activos, personas, sus respectivos arquetipos
  y si son de gestion en TMP_CLI_PER_ARQ
  **************************************************/
  V_SQL := 'TRUNCATE TABLE ' || V_ESQUEMA || '.TMP_CLI_PER_ARQ';
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE ('[INFO] Truncar tabla temporal TMP_CLI_PER_ARQ');
  
  V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.TMP_CLI_PER_ARQ 
    WITH ARR AS (
      SELECT DISTINCT PER_ID, ARQ_ID FROM (
          SELECT PER_ID, ARQ_ID, ROW_NUMBER() OVER (PARTITION BY PER_ID ORDER BY ARQ_DATE DESC) ORD
          FROM ' || V_ESQUEMA || '.ARR_ARQ_RECUPERACION_PERSONA
        ) WHERE ORD = 1
      )
    (      
      SELECT cli.CLI_ID, cli.per_id, cli.arq_id arq_cliente, arr.arq_id arq_persona, arq.arq_gestion            
      FROM CLI_CLIENTES cli             
        inner join ' || V_ESQUEMA_MASTER || '.DD_ECL_ESTADO_CLIENTE ecl on cli.DD_ECL_ID = ecl.DD_ECL_ID AND ecl.DD_ECL_CODIGO = 1
        inner join arr on cli.per_id = arr.per_id          
        inner join ' || V_ESQUEMA || '.arq_arquetipos arq on cli.arq_id = arq.arq_id            
      WHERE cli.BORRADO = 0                
    )';
    
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE ('[INFO] tabla temporal TMP_CLI_PER_ARQ rellenada');
  
END;

PROCEDURE PC_REVISION_CLIENTES
AS
  V_TIME_START TIMESTAMP := SYSTIMESTAMP;
BEGIN
  
  DBMS_OUTPUT.PUT_LINE( '[START] REVISION CLIENTES');
  
  
  /*************************************************
  Insertar los clientes activos, personas, sus respectivos arquetipos
  y si son de gestion en TMP_CLI_PER_ARQ
  **************************************************/
  marcarCliPerArq;


  /*********************************************
  Insertamos los clientes a borrar en TMP_CLI_A_CANCELAR
  que su arquetipo ya no sea de gestión
  *********************************************/
  marcarClientesSinGestion;


  /*************************************************
  Asignar nuevo arquetipo al cliente
  ************************************************/
  asignarNuevosArquetipos;
  
  /**********************************************
  Recalcular gestion vencidos y nuevos itinerarios
  ********************************************/
  recalcularEstadosCliente;
 
  /*************************************
  Revisar movimientos CNT pase 
  -- TODO - y generar notificaciones
  ***************************************/
  marcarMovARevisar;
  
  /*********************************************
  Si alguno de los contratos tiene reducción de saldo
  se inserta en REC_RECUPERACIONES
  ***********************************************/
  informarContratosReducidos;
 
  
  /***********************************
  CONTRATOS SALDADOS - registramos todos los antecedentes 
  de todos los contratos en esta situación
  ***********************************/
  registrarAntecedentes;
    
  
  /*******************************************
  Añadimos los nuevos clientes a cancelar que el contrato de pase este
  cancelado, saldado o el mov. actual del cnt sea 0
  **********************************************/  
  revisarContratosPase;
  
  
  /***********************************
  Insertar nuevos contratos
  ************************************/
  insertarNuevosContratos;
  
  /***********************************************
  CANCELAR TODOS LOS CLIENTES MARCADOS PREVIAMENTE
  ************************************************/
  cancelarClientes;
  
  /**********************************
  Borrar contratos cancelados
  **********************************/
  borrarCntCancelados;

   
  COMMIT;
  
  --ROLLBACK;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] INICIO PROCESO: ' || V_TIME_START);
  DBMS_OUTPUT.PUT_LINE('[INFO] FIN PROCESO: ' || SYSTIMESTAMP);
  
  DBMS_OUTPUT.PUT_LINE('[FIN] REVISION CLIENTES');
  
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN: '||TO_CHAR(SQLCODE));
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE(SQLERRM);
  ROLLBACK;
  RAISE;
END PC_REVISION_CLIENTES;
END PKG_REVISION_CLIENTES;
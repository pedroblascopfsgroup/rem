WHENEVER SQLERROR EXIT ROLLBACK;

/* Formatted on 2014/07/23 18:45 (Formatter Plus v4.8.8) */
/***************************************/
-- CREAR ASUNTOS LINDORFF
-- Creador: Pepe Company
-- Fecha: 24/05/2013
/***************************************/

-- GENERADOR DE EXCEL ALTA ASUNTOS
/*
select
cnt_contrato AS N_Caso
,iac_value AS N_Referencia
,3 as Despacho
,'ES001639' as Letrado
,NULL as Grupo_gestores
,1148 as Tipo_procedimiento
,'PR107271' as Procurador
,15881 as Plaza
,null as Juzgado
,MOV_POS_VIVA_VENCIDA as Principal_demanda
from
(select distinct cnt_contrato, iac_value, mov.MOV_POS_VIVA_VENCIDA from cnt_contratos cnt
join mov_movimientos mov on cnt.cnt_id=mov.cnt_id
join EXT_IAC_INFO_ADD_CONTRATO iac on iac.cnt_id=cnt.cnt_id and dd_ifc_id=31
where mov.MOV_POS_VIVA_VENCIDA > 9090 and mov.MOV_POS_VIVA_VENCIDA < 9100 and mov_fichero_carga='CONTRATOS-9999-20130611.csv'
and cnt_contrato not in (select n_caso from lin_asuntos_nuevos)
and cnt.cnt_id not in (SELECT CNT_ID FROM CEX_CONTRATOS_EXPEDIENTE))
*/

/**************************************************/
/** ACTUALIZA EL ESTADO DE LOS ASUNTOS CREADOS   **/
/**************************************************/

UPDATE lin_asuntos_nuevos
   SET creado = 'S'
 WHERE creado = 'N'
   AND n_caso IN (
          SELECT DISTINCT lin.n_caso
                     FROM cnt_contratos cnt JOIN lin_asuntos_nuevos lin
                          ON cnt.cnt_contrato = lin.n_caso
                          JOIN cex_contratos_expediente cex
                          ON cex.cnt_id = cnt.cnt_id
                          JOIN prc_cex ON prc_cex.cex_id = cex.cex_id
                          JOIN prc_procedimientos prc
                          ON prc.prc_id = prc_cex.prc_id
                          JOIN asu_asuntos asu ON asu.asu_id = prc.asu_id
                    WHERE prc.borrado = 0
                      AND cex.borrado = 0
                      AND asu.dd_eas_id NOT IN (
                                    SELECT eas6.dd_eas_id
                                      FROM hayamaster.dd_eas_estado_asuntos eas6
                                     WHERE eas6.dd_eas_codigo IN ('05', '06')));

/***************************************************/
/** CREAMOS LA TABLA INDICE PARA GENERAR ASUNTOS  **/
/***************************************************/


DROP TABLE lin_asuntos_para_crear;


CREATE TABLE lin_asuntos_para_crear AS
SELECT tabla.*,
s_cli_clientes.NEXTVAL AS cli_id,
s_exp_expedientes.NEXTVAL AS exp_id,
s_prc_procedimientos.NEXTVAL AS prc_id,
s_asu_asuntos.NEXTVAL AS asu_id
FROM
(SELECT DISTINCT lin.n_caso, cnt.cnt_id, cpe.per_id, cnt.ofi_id,dd_tin_id, lin.DD_TAS_CODIGO
FROM lin_asuntos_nuevos lin
JOIN cnt_contratos cnt ON lin.n_caso=cnt.cnt_contrato
JOIN cpe_contratos_personas cpe ON cpe.cnt_id=cnt.cnt_id AND dd_tin_id in (SELECT dd_tin_id FROM dd_tin_tipo_intervencion WHERE (dd_tin_codigo = 10 or dd_tin_codigo = 15 or dd_tin_codigo = 20 or dd_tin_codigo = 21))
WHERE lin.creado='N') tabla;


/***************************************/
/**       haya01.CLI_CLIENTES         **/
/***************************************/

INSERT INTO haya01.cli_clientes
            (cli_id, per_id, arq_id, dd_est_id, dd_ecl_id, cli_fecha_est_id,
             VERSION, usuariocrear, fechacrear, borrado, cli_fecha_creacion,
             cli_telecobro, ofi_id)
   (SELECT apc.cli_id, apc.per_id, (SELECT arq_id
                                      FROM arq_arquetipos
                                     WHERE (arq_nombre = 'Generico seguimiento' OR arq_nombre = 'Generico seguimiento')) AS arq_id,
           1 AS dd_est_id, 3 AS dd_ecl_id, SYSDATE, 0 AS VERSION,
           'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear, 1 AS borrado,
           SYSDATE AS cli_fecha_creacion, 0 AS cli_telecobro, apc.ofi_id
      FROM lin_asuntos_para_crear apc);


--OK
/*************************************************/
/** haya01.haya01.CCL_CONTRATOS_CLIENTES      **/
/*************************************************/

INSERT INTO haya01.ccl_contratos_cliente
            (ccl_id, cnt_id, cli_id, ccl_pase, VERSION, usuariocrear,
             fechacrear, borrado)
   (SELECT s_ccl_contratos_cliente.NEXTVAL AS ccl_id, apc.cnt_id AS cnt_id,
           apc.cli_id AS cli_id, 1 AS ccl_pase, 0 AS VERSION,
           'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear, 0 AS borrado
      FROM lin_asuntos_para_crear apc);



--OK
/*************************************************/
/** haya01.haya01.EXP_EXPEDIENTES             **/
/*************************************************/

INSERT INTO haya01.exp_expedientes
            (exp_id, dd_est_id, exp_fecha_est_id, ofi_id, arq_id, VERSION,
             usuariocrear, fechacrear, borrado, dd_eex_id, exp_descripcion)
   (SELECT apc.exp_id, 5 AS dd_est_id, SYSDATE AS exp_fecha_est_id,
           apc.ofi_id AS ofi_id, (SELECT arq_id
                                    FROM arq_arquetipos
                                   WHERE (arq_nombre = 'Generico seguimiento' OR arq_nombre = 'Generico seguimiento')) AS arq_id,
           0 AS VERSION, 'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear,
           0 AS borrado, 4 AS dd_eex_id,
           apc.n_caso || '-'
           || (SELECT MAX (per_nom50)
                 FROM per_personas
                WHERE per_id = apc.per_id) AS exp_descripcion
      FROM lin_asuntos_para_crear apc);



--OK
/**********************************************/
/** haya01.haya01.CEX_CONTRATOS_EXPEDIENTE **/
/**********************************************/

INSERT INTO haya01.cex_contratos_expediente
            (cex_id, cnt_id, exp_id, cex_pase, cex_sin_actuacion, VERSION,
             usuariocrear, fechacrear, borrado, dd_aex_id)
   (SELECT s_cex_contratos_expediente.NEXTVAL AS cex_id, apc.cnt_id AS cnt_id,
           apc.exp_id AS exp_id, 1 AS cex_pase, 0 AS cex_sin_actuacion,
           0 AS VERSION, 'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear,
           0 AS borrado, 9 AS dd_aex_id
      FROM lin_asuntos_para_crear apc);



--OK
/*********************************************/
/** haya01.haya01.PEX_PERSONAS_EXPEDIENTE **/
/*********************************************/

INSERT INTO haya01.pex_personas_expediente
            (pex_id, per_id, exp_id, dd_aex_id, pex_pase, VERSION,
             usuariocrear, fechacrear, borrado)
   (SELECT s_pex_personas_expediente.NEXTVAL AS pex_id, apc.per_id AS per_id,
           apc.exp_id AS exp_id, 9 AS dd_aex_id, 1 AS pex_pase, 0 AS VERSION,
           'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear, 0 AS borrado
      FROM lin_asuntos_para_crear apc);



--OK
/*********************************************/
/** haya01.haya01.ASU_ASUNTOS **************/
/*********************************************/

/** TIPO ASUNTO
01 -> litigio
02 -> concursal
**/

INSERT INTO haya01.asu_asuntos
            (asu_id, dd_est_id, asu_fecha_est_id, asu_nombre, exp_id, VERSION,
             usuariocrear, fechacrear, borrado, dd_eas_id, dtype, lote, dd_tas_id, DD_PAS_ID)
   (SELECT apc.asu_id AS asu_id, 6 AS dd_est_id, SYSDATE AS asu_fecha_est_id,
           SUBSTR (apc.n_caso || '-' || (SELECT MAX (per_nom50)
                                           FROM per_personas
                                          WHERE per_id = apc.per_id),
                   0,
                   50
                  ) AS asu_nombre,
           apc.exp_id AS exp_id, 0 AS VERSION, 'CARGA_PCO' AS usuariocrear,
           SYSDATE AS fechacrear, 0 AS borrado, 3 AS dd_eas_id,
           'EXTAsunto' AS dtype,
           (SELECT n_lote
              FROM lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso AND creado = 'N') AS lote, (select dd_tas_id from hayamaster.dd_tas_tipos_asunto where dd_tas_codigo = apc.DD_TAS_CODIGO) AS DD_TAS_ID,
             (select DD_PAS_ID from dd_pas_propiedad_asunto where dd_pas_codigo = 'SAREB') AS DD_PAS_ID
      FROM lin_asuntos_para_crear apc);



--OK
/********************************/
/** haya01.PRC_PROCEDIMIENTOS **/
/********************************/

INSERT INTO haya01.prc_procedimientos
            (prc_id, asu_id, dd_tac_id, dd_tre_id, dd_tpo_id,
             prc_porcentaje_recuperacion, prc_plazo_recuperacion,
             prc_saldo_original_vencido, prc_saldo_original_no_vencido,
             prc_saldo_recuperacion, dd_juz_id, VERSION, usuariocrear,
             fechacrear, borrado, dd_epr_id, dtype)
   (SELECT apc.prc_id AS prc_id, apc.asu_id AS asu_id,
           (SELECT dd_tac_id
              FROM dd_tpo_tipo_procedimiento
             WHERE dd_tpo_id =
                      (SELECT tipo_proc
                         FROM lin_asuntos_nuevos
                        WHERE n_caso = apc.n_caso
                          AND creado = 'N')) AS dd_tac_id,
           1 AS dd_tre_id,
           (SELECT tipo_proc
              FROM lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso AND creado = 'N') AS dd_tpo_id,
           100 AS prc_porcentaje_recuperacion, 30 AS prc_plazo_recuperacion,
           (SELECT SUM (mov_pos_viva_vencida + mov_pos_viva_no_vencida
                       )
              FROM cpe_contratos_personas cpe JOIN mov_movimientos mov
                   ON mov.cnt_id = cpe.cnt_id
             WHERE mov_fichero_carga =
                      (SELECT *
                         FROM (SELECT DISTINCT (mov_fichero_carga)
                                          FROM mov_movimientos
                                      ORDER BY mov_fichero_carga DESC)
                        WHERE ROWNUM <= 1)
               AND per_id = apc.per_id) AS prc_saldo_original_vencido,
           0 AS prc_saldo_original_no_vencido,
           (SELECT principal
              FROM lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso
               AND creado = 'N') AS prc_saldo_recuperacion,
           (SELECT juzgado
              FROM lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso AND creado = 'N') AS dd_juz_id,
           0 AS VERSION, 'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear,
           0 AS borrado, 3 AS dd_epr_id, 'MEJProcedimiento' AS dtype
      FROM lin_asuntos_para_crear apc);



--OK
/**********************/
/** BANK01.PRC_PER  **/
/**********************/

INSERT INTO haya01.prc_per
            (prc_id, per_id, VERSION)
   (SELECT apc.prc_id, apc.per_id, 0 AS VERSION
      FROM lin_asuntos_para_crear apc);




--OK
/**********************/
/** haya01.PRC_CEX  **/
/**********************/

INSERT INTO haya01.prc_cex
            (prc_id, cex_id, VERSION)
    (SELECT apc.prc_id,
           (SELECT distinct cex_id
              FROM cex_contratos_expediente
             WHERE fechacrear > SYSDATE - 1 AND cnt_id = apc.cnt_id and rownum=1)                                                                   AS cex_id,
           0 AS VERSION
      FROM lin_asuntos_para_crear apc);



/******************************************************************************/
/** inserta las personas relacionadas en la demanda no incluidas previamente **/
/******************************************************************************/

INSERT INTO haya01.prc_per
            (prc_id, per_id, VERSION)
   select * from (SELECT DISTINCT (SELECT MAX (prc_id)
                      FROM prc_cex JOIN cex_contratos_expediente cex
                           ON prc_cex.cex_id = cex.cex_id
                     WHERE cnt_id = a.cnt_id) AS prc_id, a.per_id,
                   0 AS VERSION
              FROM (SELECT DISTINCT per_id, cnt_id
                               FROM cpe_contratos_personas
                              WHERE cnt_id IN (SELECT cnt_id
                                                 FROM cex_contratos_expediente)
                    MINUS
                    SELECT prc_per.per_id, cnt.cnt_id
                      FROM prc_per JOIN prc_cex
                           ON prc_per.prc_id = prc_cex.prc_id
                           JOIN cex_contratos_expediente cex
                           ON cex.cex_id = prc_cex.cex_id
                           JOIN cnt_contratos cnt ON cex.cnt_id = cnt.cnt_id
                           ) a) where prc_id is not null;




/*************************************/
/** CREAR TABLA PARA GENERAR BPM'S  **/
/*************************************/

DROP TABLE tmp_ugaspfs_bpm_input_con1;


/*
CREATE TABLE tmp_ugaspfs_bpm_input_con1 AS
SELECT prc_id,
(SELECT MAX(tap.tap_id)
FROM dd_tpo_tipo_procedimiento tpo
    JOIN (SELECT name_, MAX(id_) maxid FROM hayamaster.jbpm_processdefinition GROUP BY name_) pdm ON tpo.dd_tpo_xml_jbpm = pdm.name_
    JOIN hayamaster.jbpm_node node ON pdm.maxid = node.processdefinition_ AND node.name_ = 'Inicio'
    JOIN hayamaster.jbpm_transition tr ON node.id_ = tr.from_
    JOIN hayamaster.jbpm_node dest ON tr.to_ = dest.id_
    JOIN tap_tarea_procedimiento tap ON dest.name_ = tap.tap_codigo
WHERE tap.borrado=0 AND tpo.borrado=0
AND tpo.dd_tpo_id=(SELECT tipo_proc FROM lin_asuntos_nuevos WHERE n_caso=apc.n_caso AND creado='N')) AS tap_id
FROM lin_asuntos_para_crear apc; */

-- Trampeo para que se genere directamente la tarea de Asignación de Gestores de PCO-Litigio
CREATE TABLE tmp_ugaspfs_bpm_input_con1 AS
SELECT prc_id,
(select tap_id from haya01.tap_tarea_procedimiento tap where tap.tap_codigo='PCO_RegistrarAceptacion') AS tap_id
FROM lin_asuntos_para_crear apc;



/*************************************/
/** ASOCIAR GESTORES POR DEFECTO    **/
/*************************************/

-- GESTOR

/*
INSERT INTO gaa_gestor_adicional_asunto
            (gaa_id, asu_id, usd_id, dd_tge_id, VERSION, usuariocrear,
             fechacrear, borrado)
   (SELECT s_gaa_gestor_adicional_asunto.NEXTVAL, asu_id AS asu_id,
           (SELECT CASE
                      WHEN lin.letrado IS NULL
                           AND lin.grupo IS NULL
                         THEN (SELECT MAX (usd_id) AS usd_id
                                 FROM lin_asuntos_nuevos lin JOIN usd_usuarios_despachos usd
                                      ON lin.despacho = usd.des_id
                                      JOIN hayamaster.usu_usuarios usu
                                      ON usu.usu_id = usd.usu_id
                                WHERE lin.creado = 'N'
                                  AND lin.n_caso = a.n_caso
                                  AND usd.usd_supervisor = 0
                                  AND usu.usu_grupo = 1)
                      WHEN lin.letrado IS NOT NULL
                         THEN (SELECT MAX (usd_id) AS usd_id
                                 FROM lin_asuntos_nuevos lin JOIN hayamaster.usu_usuarios usu
                                      ON usu.usu_username = lin.letrado
                                      JOIN usd_usuarios_despachos usd
                                      ON usu.usu_id = usd.usu_id
                                WHERE lin.creado = 'N'
                                  AND lin.n_caso = a.n_caso
                                  AND usd.usd_supervisor = 0
                                  AND usu.usu_grupo = 0)
                      WHEN lin.grupo IS NOT NULL
                         THEN (SELECT MAX (usd_id) AS usd_id
                                 FROM lin_asuntos_nuevos lin JOIN hayamaster.usu_usuarios usu
                                      ON usu.usu_username = lin.grupo
                                      JOIN usd_usuarios_despachos usd
                                      ON usu.usu_id = usd.usu_id
                                WHERE lin.creado = 'N'
                                  AND lin.n_caso = a.n_caso
                                  AND usd.usd_supervisor = 0
                                  AND usu.usu_grupo = 1)
                      ELSE NULL
                   END AS usd_id
              FROM lin_asuntos_nuevos lin
             WHERE lin.creado = 'N' AND lin.n_caso = a.n_caso) AS usd_id,
           2 AS dd_tge_id,                                            --Gestor
                          0 AS VERSION, 'CARGA_PCO' AS usuariocrear,
           SYSDATE AS fechacrear, 0 AS borrado
      FROM (SELECT n_caso, asu_id
              FROM lin_asuntos_nuevos lin JOIN cnt_contratos cnt
                   ON cnt.cnt_contrato = lin.n_caso
                   LEFT JOIN cex_contratos_expediente cex ON cex.cnt_id =
                                                                    cnt.cnt_id
                   JOIN asu_asuntos asu ON asu.exp_id = cex.exp_id
             WHERE lin.creado = 'N'
               AND asu_id NOT IN (SELECT asu_id
                                    FROM gaa_gestor_adicional_asunto
                                   WHERE dd_tge_id = 2)) a);



-- SUPERVISOR

INSERT INTO gaa_gestor_adicional_asunto
            (gaa_id, asu_id, usd_id, dd_tge_id, VERSION, usuariocrear,
             fechacrear, borrado)
   (SELECT s_gaa_gestor_adicional_asunto.NEXTVAL, a.asu_id AS asu_id,
           a.sup_id AS usd_id, 3 AS dd_tge_id, 0 AS VERSION,
           'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear, 0 AS borrado
      FROM (SELECT n_caso, asu_id,
                   (SELECT MAX (usd2.usd_id)
                      FROM gaa_gestor_adicional_asunto gaa JOIN usd_usuarios_despachos usd
                           ON usd.usd_id = gaa.usd_id
                           JOIN usd_usuarios_despachos usd2
                           ON usd2.des_id = usd.des_id
                     WHERE gaa.asu_id = asu.asu_id
                       AND gaa.dd_tge_id = 2
                       AND usd2.usd_supervisor = 1) sup_id
              FROM lin_asuntos_nuevos lin JOIN cnt_contratos cnt
                   ON cnt.cnt_contrato = lin.n_caso
                   JOIN cex_contratos_expediente cex ON cex.cnt_id =
                                                                    cnt.cnt_id
                   JOIN asu_asuntos asu ON asu.exp_id = cex.exp_id
             WHERE lin.creado = 'N'
               AND asu_id NOT IN (SELECT asu_id
                                    FROM gaa_gestor_adicional_asunto
                                   WHERE dd_tge_id = 3)) a);



-- procurador

INSERT INTO gaa_gestor_adicional_asunto
            (gaa_id, asu_id, usd_id, dd_tge_id, VERSION, usuariocrear,
             fechacrear, borrado)
   (SELECT s_gaa_gestor_adicional_asunto.NEXTVAL, asu_id AS asu_id,
           (SELECT CASE
                      WHEN lin.procurador IS NOT NULL
                         THEN (SELECT MAX (usd_id) AS usd_id
                                 FROM lin_asuntos_nuevos lin JOIN hayamaster.usu_usuarios usu
                                      ON usu.usu_username =
                                                     lin.procurador
                                      JOIN usd_usuarios_despachos usd
                                      ON usu.usu_id = usd.usu_id
                                WHERE lin.creado = 'N'
                                  AND lin.n_caso = a.n_caso
                                  AND usd.usd_supervisor = 0
                                  --AND usu.usu_grupo = 0
                                  )
                      ELSE NULL
                   END AS usd_id
              FROM lin_asuntos_nuevos lin
             WHERE lin.creado = 'N' AND lin.n_caso = a.n_caso) AS usd_id,
           4 AS dd_tge_id,                                        --Procurador
                          0 AS VERSION, 'CARGA_PCO' AS usuariocrear,
           SYSDATE AS fechacrear, 0 AS borrado
      FROM (SELECT n_caso, asu_id
              FROM lin_asuntos_nuevos lin JOIN cnt_contratos cnt
                   ON cnt.cnt_contrato = lin.n_caso
                   JOIN cex_contratos_expediente cex ON cex.cnt_id =
                                                                    cnt.cnt_id
                   JOIN asu_asuntos asu ON asu.exp_id = cex.exp_id
             WHERE lin.creado = 'N'
               AND lin.procurador IS NOT NULL
               AND asu_id NOT IN (SELECT asu_id
                                    FROM gaa_gestor_adicional_asunto
                                   WHERE dd_tge_id = 4)) a);


*/

--SUPERVISOR PCO
/***************************************************/
INSERT INTO GAA_GESTOR_ADICIONAL_ASUNTO 
	(GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL, asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID, 
		hayamaster.dd_tge_tipo_gestor.DD_TGE_ID ,0, 'CARGA_PCO', SYSDATE, 0 
	FROM ASU_ASUNTOS asu 
    INNER JOIN lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
		INNER JOIN hayamaster.USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='SUP_PCO'
		INNER JOIN USD_USUARIOS_DESPACHOS ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID 
		INNER JOIN hayamaster.dd_tge_tipo_gestor ON dd_tge_codigo = 'SUP_PCO' 
	WHERE NOT EXISTS (SELECT 1 FROM GAA_GESTOR_ADICIONAL_ASUNTO gaa 
						WHERE gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 
							(SELECT dd_tge_id FROM hayamaster.dd_tge_tipo_gestor WHERE dd_tge_codigo = 'SUP_PCO'));


INSERT INTO GAH_GESTOR_ADICIONAL_HISTORICO gah 
	(gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
SELECT s_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL ,asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID ,sysdate, HAYAMASTER.dd_tge_tipo_gestor.DD_TGE_ID ,'CARGA_PCO', SYSDATE 
	FROM ASU_ASUNTOS asu 
		INNER JOIN lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id 
		INNER JOIN HAYAMASTER.USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='SUP_PCO' 
		INNER JOIN USD_USUARIOS_DESPACHOS ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID  AND USD_GESTOR_DEFECTO=1
		INNER JOIN HAYAMASTER.dd_tge_tipo_gestor ON dd_tge_codigo = 'SUP_PCO' 
	WHERE NOT EXISTS (SELECT 1 FROM GAH_GESTOR_ADICIONAL_HISTORICO gaa 
						WHERE gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
							(SELECT dd_tge_id FROM HAYAMASTER.dd_tge_tipo_gestor WHERE dd_tge_codigo = 'SUP_PCO'));

              
/***********************************************************/
/** ACTUALIZA DE NUEVO EL ESTADO DE LOS ASUNTOS CREADOS   **/
/***********************************************************/

UPDATE lin_asuntos_nuevos
   SET creado = 'S'
 WHERE creado = 'N'
   AND n_caso IN (
          SELECT DISTINCT lin.n_caso
                     FROM cnt_contratos cnt JOIN lin_asuntos_nuevos lin
                          ON cnt.cnt_contrato = lin.n_caso
                          JOIN cex_contratos_expediente cex
                          ON cex.cnt_id = cnt.cnt_id
                          JOIN prc_cex ON prc_cex.cex_id = cex.cex_id
                          JOIN prc_procedimientos prc
                          ON prc.prc_id = prc_cex.prc_id
                          JOIN asu_asuntos asu ON asu.asu_id = prc.asu_id
                    WHERE prc.borrado = 0
                      AND cex.borrado = 0
                      AND asu.dd_eas_id NOT IN (
                                    SELECT eas6.dd_eas_id
                                      FROM hayamaster.dd_eas_estado_asuntos eas6
                                     WHERE eas6.dd_eas_codigo IN ('05', '06')));

COMMIT;

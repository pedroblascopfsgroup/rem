SET ECHO ON
WHENEVER SQLERROR EXIT ROLLBACK;

/*************************************************************************************/
/** INSERCIÓN DE DATOS DE PRUEBA PARA PROCESO DE CARGA DE ASUNTOS CON PRECONTENCIOS **/
/*************************************************************************************/

--PRECONDICION: TENEMOS DATOS NO PROCESADOS EN LAS TABLAS:
-- CNV_AUX_ALTA_PRC_BCK
-- CNV_AUX_ALTA_PRC_CNT_BCK
-- CNV_AUX_ALTA_PRC_PER_BCK

DEFINE num_pco_concursos = 20
DEFINE num_pco_litigios = 30
DEFINE master = &&ESQUEMA_MASTER

-- truncate de las tablas con datos de origen
TRUNCATE TABLE CNV_AUX_ALTA_PRC;
TRUNCATE TABLE CNV_AUX_ALTA_PRC_CNT;
TRUNCATE TABLE CNV_AUX_ALTA_PRC_PER;
TRUNCATE TABLE CNV_AUX_ALTA_PCO;

COMMIT;

-- Eliminar anteriores
delete from CNV_AUX_ALTA_PRC_BCK where codigo_procedimiento_nuse in
(select codigo_procedimiento_nuse from CNV_AUX_ALTA_PRC);

delete from cnv_aux_alta_prc_cnt_bck where codigo_procedimiento in
(select codigo_procedimiento_nuse from CNV_AUX_ALTA_PRC);

delete from cnv_aux_alta_prc_cnt_bck where codigo_procedimiento in
(select codigo_procedimiento_nuse from CNV_AUX_ALTA_PRC);

-- inserción de concursos en CNV_AUX_ALTA_PRC
INSERT INTO CNV_AUX_ALTA_PRC
select * from (
  select codigo_procedimiento_nuse, codigo_expediente_nuse, fecha_pase_a_litigio, tipo_procedimiento,
    'LET_PCO', 'PROCURADOR', 'Letrado', numero_exp_nuse, fecha_proceso
  from cnv_aux_alta_prc_bck prc
  where prc.codigo_procedimiento_nuse not in (select codigo_procedimiento_nuse from cnv_aux_alta_prc)
  and prc.tipo_procedimiento='CONCURSO' AND ROWNUM<=&num_pco_concursos);

-- inserción de litigios en CNV_AUX_ALTA_PRC
INSERT INTO CNV_AUX_ALTA_PRC
select * from (
  select codigo_procedimiento_nuse, codigo_expediente_nuse, fecha_pase_a_litigio, tipo_procedimiento,
    'LET_PCO', 'PROCURADOR', 'Letrado', numero_exp_nuse, fecha_proceso
  from cnv_aux_alta_prc_bck prc
  where prc.codigo_procedimiento_nuse not in (select codigo_procedimiento_nuse from cnv_aux_alta_prc)
  and prc.tipo_procedimiento!='CONCURSO' AND ROWNUM<=&num_pco_litigios);

-- inserción en la tabla de contratos CNV_AUX_ALTA_PRC_CNT
INSERT INTO CNV_AUX_ALTA_PRC_CNT
SELECT * FROM CNV_AUX_ALTA_PRC_CNT_BCK CNT
WHERE CNT.CODIGO_PROCEDIMIENTO IN 
	(SELECT CODIGO_PROCEDIMIENTO_NUSE FROM CNV_AUX_ALTA_PRC);

-- actualizamos los números de contrato con contratos existentes
update cnv_aux_alta_prc_cnt set codigo_entidad=rownum;

merge into cnv_aux_alta_prc_cnt tc
using (select rownum "fila",cnt_contrato from cnt_contratos
where cnt_id not in 
  (select cnt_id from cex_contratos_expediente)) cnt
on (cnt."fila"=tc.codigo_entidad)
when matched then
  update set tc.numero_contrato=substr(cnt.cnt_contrato, 11,17);

-- inserción en la tabla de personas CNV_AUX_ALTA_PRC_PER
INSERT INTO CNV_AUX_ALTA_PRC_PER
SELECT * FROM CNV_AUX_ALTA_PRC_PER_BCK PER
WHERE PER.CODIGO_PROCEDIMIENTO IN 
	(SELECT CODIGO_PROCEDIMIENTO_NUSE FROM CNV_AUX_ALTA_PRC);

--ESTA TABLA LA ALIMENTAREMOS MANUALMENTE:
-- CNV_AUX_ALTA_PCO (esta última contiene los datos particulares de PRECONTENCIOSO)

-- inserción de precontenciosos de concurso
INSERT INTO CNV_AUX_ALTA_PCO
SELECT PRC.codigo_procedimiento_nuse, PREDOC.USU_USERNAME, 
  DECODE(MOD(ROWNUM,2), 0, 1, 0) PRETURNADO, DECODE(MOD(ROWNUM,2), 0, 'CO', 'SE') TIPO_PREPARACION
FROM CNV_AUX_ALTA_PRC PRC, 
(SELECT USU.usu_username USU_USERNAME
FROM &master .USU_USUARIOS USU 
INNER JOIN usd_usuarios_despachos USD ON usd.usu_id=USU.usu_id
INNER JOIN des_despacho_externo DES ON DES.des_id=usd.des_id
INNER JOIN &master .dd_tde_tipo_despacho TDE ON tde.dd_tde_id=des.dd_tde_id
where tde.dd_tde_codigo='PREDOC' and rownum=1) PREDOC
WHERE PRC.tipo_procedimiento='CONCURSO' AND ROWNUM<=&num_pco_concursos;

-- inserción de precontenciosos de litigio
INSERT INTO CNV_AUX_ALTA_PCO
SELECT PRC.codigo_procedimiento_nuse, PREDOC.USU_USERNAME, 
  DECODE(MOD(ROWNUM,2), 0, 1, 0) PRETURNADO, DECODE(MOD(ROWNUM,2), 0, 'CO', 'SE') TIPO_PREPARACION
FROM CNV_AUX_ALTA_PRC PRC, 
(SELECT USU.usu_username USU_USERNAME
FROM  &master .USU_USUARIOS USU 
INNER JOIN usd_usuarios_despachos USD ON usd.usu_id=USU.usu_id
INNER JOIN des_despacho_externo DES ON DES.des_id=usd.des_id
INNER JOIN &master .dd_tde_tipo_despacho TDE ON tde.dd_tde_id=des.dd_tde_id
where tde.dd_tde_codigo='PREDOC' and rownum=1) PREDOC
WHERE PRC.tipo_procedimiento!='CONCURSO' AND ROWNUM<=&num_pco_litigios;

commit;
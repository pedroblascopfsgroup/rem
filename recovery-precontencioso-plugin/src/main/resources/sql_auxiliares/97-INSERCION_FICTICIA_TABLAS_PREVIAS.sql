SET ECHO ON
WHENEVER SQLERROR EXIT ROLLBACK;

/*************************************************************************************/
/** INSERCIÓN DE DATOS DE PRUEBA PARA PROCESO DE CARGA DE ASUNTOS CON PRECONTENCIOS **/
/*************************************************************************************/

--PRECONDICION: TENEMOS DATOS NO PROCESADOS EN LAS TABLAS:
-- CNV_AUX_ALTA_PRC_BCK
-- CNV_AUX_ALTA_PRC_CNT_BCK
-- CNV_AUX_ALTA_PRC_PER_BCK

DEFINE num_concursos = 4
DEFINE num_litigios = 6
DEFINE num_pco_concursos = 3
DEFINE num_pco_litigios = 4

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

-- inserción de 4 concursos en CNV_AUX_ALTA_PRC
INSERT INTO CNV_AUX_ALTA_PRC
SELECT * FROM CNV_AUX_ALTA_PRC_BCK PRC
WHERE NOT EXISTS 
  (SELECT 1 FROM ASU_ASUNTOS A WHERE PRC.CODIGO_PROCEDIMIENTO_NUSE=A.ASU_ID_EXTERNO)
AND PRC.tipo_procedimiento='CONCURSO'
AND ROWNUM<=&num_concursos;

-- inserción de 7 concursos en CNV_AUX_ALTA_PRC
INSERT INTO CNV_AUX_ALTA_PRC
SELECT * FROM CNV_AUX_ALTA_PRC_BCK PRC
WHERE NOT EXISTS 
  (SELECT 1 FROM ASU_ASUNTOS A WHERE PRC.CODIGO_PROCEDIMIENTO_NUSE=A.ASU_ID_EXTERNO)
AND PRC.tipo_procedimiento!='CONCURSO'
AND ROWNUM<=&num_litigios;

-- inserción en la tabla de contratos CNV_AUX_ALTA_PRC_CNT
INSERT INTO CNV_AUX_ALTA_PRC_CNT
SELECT * FROM CNV_AUX_ALTA_PRC_CNT_BCK CNT
WHERE CNT.CODIGO_PROCEDIMIENTO IN 
	(SELECT CODIGO_PROCEDIMIENTO_NUSE FROM CNV_AUX_ALTA_PRC);

-- inserción en la tabla de personas CNV_AUX_ALTA_PRC_CNT
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
FROM HAYAMASTER.USU_USUARIOS USU 
INNER JOIN usd_usuarios_despachos USD ON usd.usu_id=USU.usu_id
INNER JOIN des_despacho_externo DES ON DES.des_id=usd.des_id
INNER JOIN hayamaster.dd_tde_tipo_despacho TDE ON tde.dd_tde_id=des.dd_tde_id
where tde.dd_tde_codigo='PREDOC' and rownum=1) PREDOC
WHERE PRC.tipo_procedimiento='CONCURSO' AND ROWNUM<=&num_pco_concursos;

-- inserción de precontenciosos de litigio
INSERT INTO CNV_AUX_ALTA_PCO
SELECT PRC.codigo_procedimiento_nuse, PREDOC.USU_USERNAME, 
  DECODE(MOD(ROWNUM,2), 0, 1, 0) PRETURNADO, DECODE(MOD(ROWNUM,2), 0, 'CO', 'SE') TIPO_PREPARACION
FROM CNV_AUX_ALTA_PRC PRC, 
(SELECT USU.usu_username USU_USERNAME
FROM HAYAMASTER.USU_USUARIOS USU 
INNER JOIN usd_usuarios_despachos USD ON usd.usu_id=USU.usu_id
INNER JOIN des_despacho_externo DES ON DES.des_id=usd.des_id
INNER JOIN hayamaster.dd_tde_tipo_despacho TDE ON tde.dd_tde_id=des.dd_tde_id
where tde.dd_tde_codigo='PREDOC' and rownum=1) PREDOC
WHERE PRC.tipo_procedimiento!='CONCURSO' AND ROWNUM<=&num_pco_litigios;

commit;
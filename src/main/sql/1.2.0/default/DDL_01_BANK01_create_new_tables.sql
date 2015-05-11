SET DEFINE OFF;

WHENEVER SQLERROR CONTINUE;

Insert into BANK01.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (137, 'Dias irreguar - Compara1Valor (Calculado)', 'dias_irregular', 'compare1', 'number', 'Contrato', 'PCOMPANY', SYSDATE, 0);
Insert into BANK01.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (138, 'Domiciliacion Externa - Compara1Valor (Carga)', 'CNT_DOMICI_EXT', 'compare1', 'number', 'Contrato', 'PCOMPANY', SYSDATE, 0);
Insert into BANK01.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (139, 'Servicio Nomina_Pension - Compara1Valor (Carga)', 'SERV_NOMINA_PENSION', 'compare1', 'number', 'Persona', 'PCOMPANY', SYSDATE, 0);
Insert into BANK01.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (140, 'Riesgo Dispuesto de la persona - Compara1Valor (Carga)', 'TMP_PER_RIESGO_DISPUESTO', 'compare1', 'number', 'Persona', 'PCOMPANY', SYSDATE, 0);
Insert into BANK01.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (141, 'Aplicativo Origen Contrato (Carga)', 'dd_apo_id', 'dictionary', 'number', 'DDAplicativoOrigen', 'Contrato', 'PCOMPANY', SYSDATE, 0);
Insert into BANK01.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (142, 'Fecha de Nacimiento de la Persona - Compare1Valor (Carga)', 'per_fecha_nacimiento', 'compare1', 'date', 'Persona', 'DD', SYSDATE, 0);

COMMIT;

Insert into BANK01.RULE_DEFINITION (RD_ID, RD_NAME, RD_DEFINITION, RD_NAME_LONG, USUARIOCREAR, FECHACREAR, BORRADO) Values
(300, 'RECOBRO mayor a 210', '<rule title="RECOBRO MENOR A 50001 (MAS DE 210 DIAS)" type="and"><rule values="[50001]" ruleid="18" operator="lessThan" title="Riesgo Directo de la Persona menor que 50001">Riesgo Directo de la Persona menor que 50001</rule><rule values="[0]" ruleid="55" operator="greaterThan" title="Deuda Irregular del Contrato mayor que 0">Deuda Irregular del Contrato mayor que 0</rule><rule values="[209]" ruleid="137" operator="greaterThan" title="Dias irregular mayor que 209">Dias irregular mayor que 209</rule></rule>', 'Todos aquellos clientes que tienen al menos una operación en irregular con una antigüedad mayor o igual que 210 días.', 'BANKMASTER', SYSDATE, 0);

Insert into BANK01.RULE_DEFINITION (RD_ID, RD_NAME, RD_DEFINITION, RD_NAME_LONG, USUARIOCREAR, FECHACREAR, BORRADO) Values
(301, 'EXCLUSIONES', '
    <rule title="Personas Excluidas Sociedad Cobro" type="or">                
        <rule title="PROMOTORES" type="or">                                
            <rule values="[24]" ruleid="2" operator="equal" title="Tipo Segmento PROMOTORES">Tipo Segmento PROMOTORES                                
            </rule>                                
            <rule values="[17]" ruleid="2" operator="equal" title="Tipo Segmento MICROPROMOTORES">Tipo Segmento MICROPROMOTORES                                
            </rule>                                
            <rule values="[27]" ruleid="2" operator="equal" title="Tipo Segmento PEQUENYOS Y MEDIANOS PROMOTORES">Tipo Segmento PEQUENYOS Y MEDIANOS PROMOTORES                                
            </rule>                    
        </rule>                
        <rule values="[0]" ruleid="66" operator="greaterThan" title="Riesgo Garantizado mayor que 0">Riesgo Garantizado mayor que 0                
        </rule>            
        <rule values="[10738]" ruleid="9" operator="equal" title="Oficina Gestora igual 10738">Oficina Gestora igual 10738        
        </rule>    
        <rule values="[51]" ruleid="130" operator="lessThan" title="Deuda Irregular de la persona menor que 51">Deuda Irregular de la persona menor que 51
        </rule>
    </rule>', 'Clientes excluidos de las sociedades de cobro', 'BANKMASTER', SYSDATE, 0);

Insert into BANK01.RULE_DEFINITION (RD_ID, RD_NAME, RD_DEFINITION, RD_NAME_LONG, USUARIOCREAR, FECHACREAR, BORRADO) Values
(302, 'TELECOBRO entre 6 y 34', '<rule title="TELECOBRO MENOR A 50001" type="and">
        <rule values="[50001]" ruleid="18" operator="lessThan" title="Riesgo Directo de la Persona menor que 50001">Riesgo Directo de la Persona menor que 50001
        </rule>
        <rule values="[0]" ruleid="55" operator="greaterThan" title="Deuda Irregular del Contrato mayor que 0">Deuda Irregular del Contrato mayor que 0
        </rule>
        <rule values="[6]" ruleid="137" operator="greaterThan" title="Dias irregular mayor que 6">Dias irregular mayor que 6
        </rule>
        <rule values="[35]" ruleid="137" operator="lessThan" title="Dias irregular menor que 35">Dias irregular menor que 35
        </rule>
    </rule>', 'Todos aquellos clientes cuyas operaciones en irregular tengan una antigüedad mayor que 6 días y menor o igual que 34 días.', 'BANKMASTER', SYSDATE, 0);

Insert into BANK01.RULE_DEFINITION (RD_ID, RD_NAME, RD_DEFINITION, RD_NAME_LONG, USUARIOCREAR, FECHACREAR, BORRADO) Values
(303, 'PREFALLIDOS', '<rule title="PREFALLIDOS MENOR A 50001" type="and">
        <rule values="[50001]" ruleid="18" operator="lessThan" title="Riesgo Directo de la Persona menor que 50001">Riesgo Directo de la Persona menor que 50001
        </rule>
        <rule values="[20]" ruleid="45" operator="equal" title="Situacion Contable igual a PREFALLIDO">Situacion Contable igual a PREFALLIDO
        </rule>
    </rule> ', 'Todos aquellos clientes con alguna operación en situación contable Prefallido y Riesgo Directo menor 50001', 'BANKMASTER', SYSDATE, 0);

Insert into BANK01.RULE_DEFINITION (RD_ID, RD_NAME, RD_DEFINITION, RD_NAME_LONG, USUARIOCREAR, FECHACREAR, BORRADO) Values
(304, 'RECOBRO entre 35 y 210', '<rule title="RECOBRO MENOR A 50001" type="and">        
        <rule values="[50001]" ruleid="18" operator="lessThan" title="Riesgo Directo de la Persona menor que 50001">Riesgo Directo de la Persona menor que 50001        
        </rule>        
        <rule values="[0]" ruleid="55" operator="greaterThan" title="Deuda Irregular del Contrato mayor que 0">Deuda Irregular del Contrato mayor que 0        
        </rule>        
        <rule values="[35]" ruleid="137" operator="greaterThan" title="Dias irregular mayor que 34">Dias irregular mayor que 34
        </rule>        
        <rule values="[210]" ruleid="137" operator="lessThan" title="Dias irregular menor que 210">Dias irregular menor que 210
        </rule>    
    </rule>', 'Todos aquellos clientes que tienen al menos una operación en irregular con una antigüedad mayor o igual que 35 días y menor que 210 días', 'BANKMASTER', SYSDATE, 0);

COMMIT;

CREATE TABLE TMP_REC_EXP_SIN_PERSONAS_SUB (
  EXP_ID NUMBER(16) NOT NULL
);

CREATE TABLE TMP_REC_EXP_SIN_CONTRATOS_SUB (
  EXP_ID NUMBER(16) NOT NULL
);

create index IDX_H_REC_FIC_CONT_FEC_HIST on H_REC_FICHERO_CONTRATOS (FECHA_HIST);


DROP MATERIALIZED VIEW DATA_RULE_ENGINE;

CREATE MATERIALIZED VIEW DATA_RULE_ENGINE
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
SELECT per.per_id, per.dd_sce_id, per.dd_tpe_id, per.per_ecv, per.dd_pol_id,
       per.per_nacionalidad, per.per_pais_nacimiento, per.per_sexo,
       per.ofi_id, per.dd_rex_id, per.per_riesgo, per.per_riesgo_ind,
       per.per_fecha_constitucion, per.per_fecha_nacimiento,cnt.dd_ct1_id, 
       cnt.dd_mon_id, cnt.dd_efc_id, cnt.dd_efc_id_ant, cnt.dd_gc1_id,
       cnt.dd_fno_id, cnt.dd_fcn_id, mov.mov_riesgo, mov.mov_deuda_irregular,
       mov.mov_saldo_dudoso, mov.mov_dispuesto, mov.mov_provision,
       mov.mov_int_remuneratorios, mov.mov_int_moratorios, mov.mov_comisiones,
       mov.mov_gastos, mov.mov_saldo_pasivo, cnt.cnt_limite_ini,
       cnt.cnt_limite_fin, mov.mov_riesgo_garant, mov.mov_saldo_exce,
       mov.mov_ltv_ini, mov.mov_ltv_fin, mov.mov_limite_desc, 
       cnt.cnt_fecha_creacion, mov.mov_fecha_pos_vencida, TRUNC(SYSDATE - mov.MOV_CNT_FECHA_INI_EPI_IRREG) AS dias_irregular,
       mov.mov_fecha_dudoso, cnt.cnt_fecha_efc, cnt.cnt_fecha_efc_ant,
       cnt.cnt_fecha_esc, cnt.cnt_fecha_constitucion, cnt.cnt_fecha_venc,
       per.arq_id_calculado, per.per_deuda_irregular, per.per_deuda_irregular_dir,
       per.per_deuda_irregular_ind, cnt.dd_esc_id
  FROM per_personas per LEFT JOIN cpe_contratos_personas cpe
       ON per.per_id = cpe.per_id                                    --PER_CPE
       LEFT JOIN cnt_contratos cnt ON cpe.cnt_id = cnt.cnt_id        --CPE_CNT
       LEFT JOIN mov_movimientos mov
       ON cnt.cnt_id = mov.cnt_id
          AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion         --CNT_MOV
       LEFT JOIN ant_antecedentes ant ON ant.ant_id = per.ant_id
       LEFT JOIN pto_puntuacion_total pto
       ON pto.per_id = per.per_id
          AND (pto.pto_activo = 1 OR pto.pto_activo IS NULL)              --PER_PTO
       LEFT JOIN per_gcl pg ON pg.per_id = per.per_id
       LEFT JOIN gcl_grupos_clientes gcl ON pg.gcl_id = gcl.gcl_id;



-- Creamos la tabla sin regristros para que el primer dia arquetipe todo
CREATE TABLE DATA_RULE_ENGINE_ANTERIOR 
AS SELECT * from DATA_RULE_ENGINE WHERE rownum < 1;

DROP VIEW BANK01.TMP_REC_DATA_RULE_ENGINE;

CREATE table tmp_rec_data_rule_engine 
   AS
   SELECT "PER_ID", "DD_SCE_ID", "DD_TPE_ID", "PER_ECV", "DD_POL_ID",
  "PER_NACIONALIDAD", "PER_PAIS_NACIMIENTO", "PER_SEXO", "OFI_ID",
  "DD_REX_ID", "PER_RIESGO", "PER_RIESGO_IND", "PER_FECHA_CONSTITUCION",
  "PER_FECHA_NACIMIENTO", "DD_CT1_ID", "DD_MON_ID",
  "DD_EFC_ID", "DD_EFC_ID_ANT", "DD_GC1_ID", "DD_FNO_ID",
  "DD_FCN_ID", "MOV_RIESGO", "MOV_DEUDA_IRREGULAR", "MOV_SALDO_DUDOSO", 
  "MOV_DISPUESTO", "MOV_PROVISION", "MOV_INT_REMUNERATORIOS", "MOV_INT_MORATORIOS",
  "MOV_COMISIONES", "MOV_GASTOS", "MOV_SALDO_PASIVO",
  "CNT_LIMITE_INI", "CNT_LIMITE_FIN", "MOV_RIESGO_GARANT",
  "MOV_SALDO_EXCE", "MOV_LTV_INI", "MOV_LTV_FIN", "MOV_LIMITE_DESC",
  "CNT_FECHA_CREACION", "MOV_FECHA_POS_VENCIDA", "DIAS_IRREGULAR", 
  "MOV_FECHA_DUDOSO", "CNT_FECHA_EFC", "CNT_FECHA_EFC_ANT", "CNT_FECHA_ESC", 
  "CNT_FECHA_CONSTITUCION", "CNT_FECHA_VENC", "ARQ_ID_CALCULADO",
  "PER_DEUDA_IRREGULAR", "PER_DEUDA_IRREGULAR_DIR",
  "PER_DEUDA_IRREGULAR_IND", "DD_ESC_ID"
 FROM ((select * from data_rule_engine) minus (select * from data_rule_engine_anterior))
 WHERE per_id IN (SELECT DISTINCT (per_id) FROM tmp_rec_cnt_libres); 

DROP VIEW BATCH_DATOS_CNT_PER;

CREATE MATERIALIZED VIEW 
batch_datos_cnt_per (
    cnt_id, per_id, cnt_per_tin, cnt_per_oin)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS
SELECT cpe.cnt_id, cpe.per_id, tin.dd_tin_codigo AS cnt_per_tin, cpe.cpe_orden AS cnt_per_oin
FROM cpe_contratos_personas cpe 
JOIN dd_tin_tipo_intervencion tin ON cpe.dd_tin_id = tin.dd_tin_id
WHERE cpe.borrado = 0 AND (dd_tin_exp_recobro_sn = 1);


DROP VIEW BATCH_DATOS_CNT;

CREATE MATERIALIZED VIEW 
batch_datos_cnt (cnt_id, ofi_id, cnt_riesgo)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS
SELECT cnt.cnt_id, cnt.ofi_id, NVL (mov.mov_deuda_irregular, 0) AS cnt_riesgo
FROM cnt_contratos cnt JOIN bankmaster.dd_esc_estado_cnt esc
      ON cnt.dd_esc_id = esc.dd_esc_id
      JOIN mov_movimientos mov
      ON cnt.cnt_id = mov.cnt_id
    AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion
WHERE cnt.borrado = 0 AND esc.dd_esc_codigo = '0';

DROP VIEW BATCH_DATOS_PER;

CREATE MATERIALIZED VIEW 
batch_datos_per (per_id, per_nombre, per_apellido1, per_apellido2,
	per_deuda_irregular, per_riesgo_directo, per_riesgo_indirecto)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
SELECT per_id, NVL (per_nombre, '') AS per_nombre,
  NVL (per_apellido1, '') AS per_apellido1,
  NVL (per_apellido2, '') AS per_apellido2,
  NVL (per_deuda_irregular, 0) AS per_deuda_irregular,
  NVL (per_riesgo, 0) AS per_riesgo_directo,
  NVL (per_riesgo_ind, 0) AS per_riesgo_indirecto
FROM per_personas
WHERE borrado = 0;


DROP VIEW BANK01.BATCH_DATOS_CNT_EXP;

CREATE MATERIALIZED VIEW  
batch_datos_cnt_exp (exp_id, cnt_id)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
SELECT cex.exp_id, cex.cnt_id
  FROM cex_contratos_expediente cex
WHERE cex.borrado = 0;

DROP VIEW BATCH_DATOS_EXP;

CREATE MATERIALIZED VIEW  
batch_datos_exp (exp_id, arq_id, exp_borrado, dd_tpe_codigo, dd_eex_codigo,
	rcf_esq_id, rcf_age_id, rcf_sca_id,exp_marcado_bpm, exp_manual)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY		
AS
SELECT EXP.exp_id, EXP.arq_id AS arq_id, 0 AS exp_borrado,
          'RECOBRO' AS dd_tpe_codigo, eex.dd_eex_codigo,
      cre.rcf_esq_id AS rcf_esq_id, cre.rcf_age_id AS rcf_age_id,
      cre.rcf_sca_id AS rcf_sca_id, -1 AS exp_marcado_bpm, EXP.exp_manual
FROM exp_expedientes EXP JOIN exr_expediente_recobro rec
      ON EXP.exp_id = rec.exp_id
      JOIN bankmaster.dd_eex_estado_expediente eex
      ON EXP.dd_eex_id = eex.dd_eex_id
      JOIN cre_ciclo_recobro_exp cre ON EXP.exp_id = cre.exp_id
WHERE EXP.borrado = 0 AND eex.dd_eex_codigo = '1' AND EXP.exp_manual = 0;


DROP VIEW BATCH_DATOS_CNT_INFO;

CREATE MATERIALIZED VIEW  
batch_datos_cnt_info (cnt_id, codigo_propietario, tipo_producto, numero_contrato)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
SELECT DISTINCT cnt.cnt_id, pro.dd_pro_codigo codigo_propietario,
       tpe.dd_tpe_codigo tipo_producto,
       cnt.cnt_contrato numero_contrato
FROM batch_datos_cnt bdcnt JOIN cnt_contratos cnt
       ON bdcnt.cnt_id = cnt.cnt_id
       JOIN dd_pro_propietarios pro ON cnt.dd_pro_id = pro.dd_pro_id
       JOIN dd_tpe_tipo_prod_entidad tpe
       ON cnt.dd_tpe_id = tpe.dd_tpe_id;
       
       
DROP VIEW BATCH_DATOS_PER_EXP;

CREATE MATERIALIZED VIEW  
batch_datos_per_exp (exp_id, per_id)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
SELECT pex.exp_id, pex.per_id
   FROM pex_personas_expediente pex
WHERE pex.borrado = 0;  


DROP VIEW BATCH_DATOS_CLI;

CREATE MATERIALIZED VIEW 
batch_datos_cli (cli_id, per_id)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
SELECT cli.cli_id, cli.per_id
FROM cli_clientes cli JOIN bankmaster.dd_ecl_estado_cliente ecl
   ON cli.dd_ecl_id = ecl.dd_ecl_id
WHERE cli.borrado = 0 AND ecl.dd_ecl_codigo <> '2';


DROP VIEW BATCH_DATOS_EXCEPTUADOS;

CREATE MATERIALIZED VIEW 
batch_datos_exceptuados (per_id, cnt_id, dd_mob_id, dd_mob_codigo, dd_mob_borrado, exc_id)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
   SELECT CAST (NULL AS NUMBER (16)) AS per_id,
          CAST (cnt.cnt_id AS NUMBER (16)) AS cnt_id,
          exc.dd_moe_id AS dd_mob_id, moe.dd_moe_codigo AS dd_mob_codigo,
          moe.borrado AS dd_mob_borrado, exc.exc_id
     FROM exc_exceptuacion exc JOIN dd_moe_motivo_exceptuacion moe
          ON exc.dd_moe_id = moe.dd_moe_id
          JOIN eco_exceptuacion_contrato cnt ON exc.exc_id = cnt.exc_id
    WHERE exc.borrado = 0 AND TRUNC (exc.exc_fecha_hasta) > TRUNC (SYSDATE)
   UNION
   SELECT CAST (per.per_id AS NUMBER (16)) AS per_id,
          CAST (NULL AS NUMBER (16)) AS cnt_id, exc.dd_moe_id AS dd_mob_id,
          moe.dd_moe_codigo AS dd_mob_codigo, moe.borrado AS dd_mob_borrado,
          exc.exc_id
     FROM exc_exceptuacion exc JOIN dd_moe_motivo_exceptuacion moe
          ON exc.dd_moe_id = moe.dd_moe_id
          JOIN epe_exceptuacion_persona per ON exc.exc_id = per.exc_id
    WHERE exc.borrado = 0 AND TRUNC (exc_fecha_hasta) > TRUNC (SYSDATE);
    
    
DROP VIEW BATCH_DATOS_EXP_MANUAL;

CREATE MATERIALIZED VIEW 
batch_datos_exp_manual (exp_id, arq_id, exp_borrado, dd_tpe_codigo,
	dd_eex_codigo, rcf_esq_id, rcf_age_id, rcf_sca_id, exp_marcado_bpm, exp_manual)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
SELECT EXP.exp_id, esc.rcf_car_id AS arq_id, 0 AS exp_borrado,
          'RECOBRO' AS dd_tpe_codigo, eex.dd_eex_codigo,
      cre.rcf_esq_id AS rcf_esq_id, cre.rcf_age_id AS rcf_age_id,
      cre.rcf_sca_id AS rcf_sca_id,
      NVL (cre.cre_marcado_bpm, 0) AS exp_marcado_bpm, EXP.exp_manual
 FROM exp_expedientes EXP JOIN exr_expediente_recobro rec
      ON EXP.exp_id = rec.exp_id
      JOIN bankmaster.dd_eex_estado_expediente eex
      ON EXP.dd_eex_id = eex.dd_eex_id
      JOIN cre_ciclo_recobro_exp cre ON EXP.exp_id = cre.exp_id
      JOIN rcf_esc_esquema_carteras esc ON cre.rcf_esc_id = esc.rcf_esc_id
WHERE EXP.borrado = 0 AND eex.dd_eex_codigo = '1' AND EXP.exp_manual = 1;


DROP VIEW BATCH_DATOS_GCL;

CREATE MATERIALIZED VIEW 
batch_datos_gcl (gcl_id, per_id)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY	
AS
   SELECT DISTINCT pgcl.gcl_id, pgcl.per_id
              FROM per_gcl pgcl JOIN gcl_grupos_clientes gcl
                   ON pgcl.gcl_id = gcl.gcl_id AND gcl.borrado = 0
                   JOIN batch_datos_per per ON pgcl.per_id = per.per_id
             WHERE pgcl.borrado = 0;

 
DROP VIEW TMP_ARQ_RECOBRO;

DROP VIEW BATCH_RCF_ENTRADA;

DROP VIEW TMP_REC_PER_DATA_RULE_ENGINE;

CREATE OR REPLACE FORCE VIEW tmp_rec_per_data_rule_engine 
AS
SELECT "PER_ID", "DD_SCE_ID", "DD_TPE_ID", "PER_ECV", "DD_POL_ID",
    "PER_NACIONALIDAD", "PER_PAIS_NACIMIENTO", "PER_SEXO", "OFI_ID",
    "DD_REX_ID", "PER_RIESGO", "PER_RIESGO_IND", "PER_FECHA_CONSTITUCION",
    "PER_FECHA_NACIMIENTO", "DD_CT1_ID", "DD_MON_ID",
    "DD_EFC_ID", "DD_EFC_ID_ANT", "DD_GC1_ID", "DD_FNO_ID",
    "DD_FCN_ID", "MOV_RIESGO", "MOV_DEUDA_IRREGULAR", "MOV_SALDO_DUDOSO", 
    "MOV_DISPUESTO", "MOV_PROVISION", "MOV_INT_REMUNERATORIOS", "MOV_INT_MORATORIOS",
    "MOV_COMISIONES", "MOV_GASTOS", "MOV_SALDO_PASIVO",
    "CNT_LIMITE_INI", "CNT_LIMITE_FIN", "MOV_RIESGO_GARANT",
    "MOV_SALDO_EXCE", "MOV_LTV_INI", "MOV_LTV_FIN", "MOV_LIMITE_DESC",
    "CNT_FECHA_CREACION", "MOV_FECHA_POS_VENCIDA", "DIAS_IRREGULAR", 
    "MOV_FECHA_DUDOSO", "CNT_FECHA_EFC", "CNT_FECHA_EFC_ANT", "CNT_FECHA_ESC", 
    "CNT_FECHA_CONSTITUCION", "CNT_FECHA_VENC", "ARQ_ID_CALCULADO",
    "PER_DEUDA_IRREGULAR", "PER_DEUDA_IRREGULAR_DIR",
    "PER_DEUDA_IRREGULAR_IND", "DD_ESC_ID"
FROM data_rule_engine
WHERE per_id IN (SELECT DISTINCT (per_id) FROM tmp_rec_exp_desnormalizado);


CREATE TABLE TMP_ARP_ARQ_RECOBRO_PERSONA(
  ARP_ID            NUMBER(16),
  PER_ID            NUMBER(16),
  ARQ_ID            NUMBER(16),
  ARQ_NAME          VARCHAR2(100 CHAR),
  ARQ_PRIO          NUMBER(16),
  ARQ_DATE          TIMESTAMP(6),
  VERSION           NUMBER(1)                   DEFAULT 0,
  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR        TIMESTAMP(6)                DEFAULT SYSDATE               NOT NULL,
  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
  FECHAMODIFICAR    TIMESTAMP(6),
  USUARIOBORRAR     VARCHAR2(10 CHAR),
  FECHABORRAR       TIMESTAMP(6),
  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
);

CREATE INDEX IDX_TMP_ARP_PER_ID ON TMP_ARP_ARQ_RECOBRO_PERSONA (PER_ID);

CREATE INDEX IDX_TMP_ARP_ARQ_DATE ON TMP_ARP_ARQ_RECOBRO_PERSONA (ARQ_DATE);

CREATE TABLE ARP_ARQ_RECOBRO_PERSONA_SIM(
  ARP_ID            NUMBER(16),
  PER_ID            NUMBER(16),
  ARQ_ID            NUMBER(16),
  ARQ_NAME          VARCHAR2(100 CHAR),
  ARQ_PRIO          NUMBER(16),
  ARQ_DATE          TIMESTAMP(6),
  VERSION           NUMBER(1)                   DEFAULT 0,
  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR        TIMESTAMP(6)                DEFAULT SYSDATE               NOT NULL,
  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
  FECHAMODIFICAR    TIMESTAMP(6),
  USUARIOBORRAR     VARCHAR2(10 CHAR),
  FECHABORRAR       TIMESTAMP(6),
  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
);

CREATE INDEX IDX_ARP_PER_ID_SI ON ARP_ARQ_RECOBRO_PERSONA_SIM (PER_ID);

CREATE INDEX IDX_ARP_ARQ_DATE_SI ON ARP_ARQ_RECOBRO_PERSONA_SIM (ARQ_DATE);

CREATE SEQUENCE S_ARP_ARQ_RECOBRO_PER_SIM;

CREATE INDEX IDX_TMP_REC_EXP_SIN_RIESGOS ON TMP_REC_EXP_SIN_RIESGOS (EXP_ID);

CREATE INDEX IDX_TMP_REC_CONTRATOS_BAJA_CNT ON TMP_REC_CONTRATOS_BAJA (CNT_ID);


-- LO SIGUIENTE NO SE EJECUTA, DE MOMENTO ESTA DE BACKUP
/*
 		  CREATE MATERIALIZED VIEW BATCH_RCF_ENTRADA 
 		   (rcf_esq_id,
           rcf_esq_plazo,
           rcf_esq_fecha_lib,
           rcf_esq_borrado,
           rcf_dd_ees_id,
           rcf_dd_ees_codigo,
           rcf_dd_ees_borrado,
           rcf_dd_mtr_id,
           rcf_dd_mtr_codigo,
           rcf_dd_mtr_borrado,
           rcf_car_id,
           rcf_car_nombre,
           rcf_car_borrado,
           rcf_dd_eca_id,
           rcf_dd_eca_codigo,
           rcf_dd_eca_borrado,
           rd_id,
           rd_name,
           rd_definition,
           rd_borrado,
           rcf_age_id,
           rcf_age_nombre,
           rcf_age_codigo,
           rcf_age_borrado,
           rcf_esc_id,
           rcf_esc_prioridad,
           rcf_esc_borrado,
           rcf_dd_tce_id,
           rcf_dd_tce_codigo,
           rcf_dd_tce_borrado,
           rcf_dd_tgc_id,
           rcf_dd_tgc_codigo,
           rcf_dd_tgc_borrado,
           rcf_dd_aer_id,
           rcf_dd_aer_codigo,
           rcf_dd_aer_borrado,
           rcf_sca_id,
           rcf_sca_nombre,
           rcf_sca_particion,
           rcf_sca_borrado,
           rcf_dd_tpr_id,
           rcf_dd_tpr_codigo,
           rcf_dd_tpr_borrado,
           rcf_itv_id,
           rcf_itv_nombre,
           rcf_itv_fecha_alta,
           rcf_itv_plazo_max,
           rcf_itv_no_gest,
           rcf_itv_borrado,
           rcf_mfa_id,
           rcf_mfa_nombre,
           rcf_mfa_borrado,
           rcf_poa_id,
           rcf_poa_codigo,
           rcf_poa_borrado,
           rcf_mor_id,
           rcf_mor_nombre,
           rcf_mor_borrado,
           rcf_sua_id,
           rcf_sua_coeficiente,
           rcf_sua_borrado,
           rcf_sur_id,
           rcf_sur_posicion,
           rcf_sur_porcentaje,
           rcf_sur_borrado
          )
	BUILD IMMEDIATE
	REFRESH FORCE ON DEMAND
	WITH PRIMARY KEY
	AS
   SELECT esq.rcf_esq_id AS rcf_esq_id, esq.rcf_esq_plazo AS rcf_esq_plazo,
          esq.rcf_esq_fecha_lib AS rcf_esq_fecha_lib,
          esq.borrado AS rcf_esq_borrado, ees.rcf_dd_ees_id AS rcf_dd_ees_id,
          ees.rcf_dd_ees_codigo AS rcf_dd_ees_codigo,
          ees.borrado AS rcf_dd_ees_borrado,
          mtr.rcf_dd_mtr_id AS rcf_dd_mtr_id,
          mtr.rcf_dd_mtr_codigo AS rcf_dd_mtr_codigo,
          mtr.borrado AS rcf_dd_mtr_borrado, car.rcf_car_id AS rcf_car_id,
          car.rcf_car_nombre AS rcf_car_nombre,
          car.borrado AS rcf_car_borrado,
          CAST (NULL AS NUMBER (16)) AS rcf_dd_eca_id,   --ECA.RCF_DD_ECA_ID ,
          CAST (NULL AS NUMBER (16)) AS rcf_dd_eca_codigo,
                                                     --ECA.RCF_DD_ECA_CODIGO ,
          CAST (NULL AS NUMBER (16)) AS rcf_dd_eca_borrado,    --ECA.BORRADO ,
          rul.rd_id AS rd_id, rul.rd_name AS rd_name,
          rul.rd_definition AS rd_definition, rul.borrado AS rd_borrado,
          age.rcf_age_id AS rcf_age_id, age.rcf_age_nombre AS rcf_age_nombre,
          age.rcf_age_codigo AS rcf_age_codigo,
          age.borrado AS rcf_age_borrado, esc.rcf_esc_id AS rcf_esc_id,
          esc.rcf_esc_prioridad AS rcf_esc_prioridad,
          esc.borrado AS rcf_esc_borrado, tce.dd_tce_id AS rcf_dd_tce_id,
          tce.dd_tce_codigo AS rcf_dd_tce_codigo,
          tce.borrado AS rcf_dd_tce_borrado, tgc.dd_tgc_id AS rcf_dd_tgc_id,
          tgc.dd_tgc_codigo AS rcf_dd_tgc_codigo,
          tgc.borrado AS rcf_dd_tgc_borrado, aer.dd_aer_id AS rcf_dd_aer_id,
          aer.dd_aer_codigo AS rcf_dd_aer_codigo,
          aer.borrado AS rcf_dd_aer_borrado, sca.rcf_sca_id AS rcf_sca_id,
          sca.rcf_sca_nombre AS rcf_sca_nombre,
          sca.rcf_sca_particion AS rcf_sca_particion,
          sca.borrado AS rcf_sca_borrado, tpr.rcf_dd_tpr_id AS rcf_dd_tpr_id,
          tpr.rcf_dd_tpr_codigo AS rcf_dd_tpr_codigo,
          tpr.borrado AS rcf_dd_tpr_borrado, itv.rcf_itv_id AS rcf_itv_id,
          itv.rcf_itv_nombre AS rcf_itv_nombre,
          itv.rcf_itv_fecha_alta AS rcf_itv_fecha_alta,
          itv.rcf_itv_plazo_max AS rcf_itv_plazo_max,
          itv.rcf_itv_no_gest AS rcf_itv_no_gest,
          itv.borrado AS rcf_itv_borrado, mfa.rcf_mfa_id AS rcf_mfa_id,
          mfa.rcf_mfa_nombre AS rcf_mfa_nombre,
          mfa.borrado AS rcf_mfa_borrado, poa.rcf_poa_id AS rcf_poa_id,
          poa.rcf_poa_codigo AS rcf_poa_codigo,
          poa.borrado AS rcf_poa_borrado, mor.rcf_mor_id AS rcf_mor_id,
          mor.rcf_mor_nombre AS rcf_mor_nombre,
          mor.borrado AS rcf_mor_borrado, sua.rcf_sua_id AS rcf_sua_id,
          sua.rcf_sua_coeficiente AS rcf_sua_coeficiente,
          sua.borrado AS rcf_sua_borrado, sur.rcf_sur_id AS rcf_sur_id,
          sur.rcf_sur_posicion AS rcf_sur_posicion,
          sur.rcf_sur_porcentaje AS rcf_sur_porcentaje,
          sur.borrado AS rcf_sur_borrado
     FROM rcf_esq_esquema esq JOIN rcf_dd_mtr_modelo_transicion mtr
          ON esq.rcf_dd_mtr_id = mtr.rcf_dd_mtr_id
          JOIN rcf_dd_ees_estado_esquema ees
          ON esq.rcf_dd_ees_id = ees.rcf_dd_ees_id
          JOIN rcf_esc_esquema_carteras esc ON esq.rcf_esq_id = esc.rcf_esq_id
          LEFT JOIN rcf_dd_tgc_tipo_gestion_cart tgc ON esc.dd_tgc_id =
                                                                 tgc.dd_tgc_id
          JOIN rcf_dd_tce_tipo_cartera_esq tce ON esc.dd_tce_id =
                                                                 tce.dd_tce_id
          LEFT JOIN rcf_dd_aer_ambito_exp_rec aer ON esc.dd_aer_id = aer.dd_aer_id
          JOIN rcf_car_cartera car ON esc.rcf_car_id = car.rcf_car_id
          --JOIN RCF_DD_ECA_ESTADO_CARTERA ECA ON CAR.RCF_DD_ECA_ID = ECA.RCF_DD_ECA_ID
          JOIN rule_definition rul ON car.rd_id = rul.rd_id
          LEFT JOIN rcf_sca_subcartera sca
          ON esc.rcf_esc_id = sca.rcf_esc_id AND sca.borrado = 0
          LEFT JOIN rcf_dd_tpr_tipo_reparto_subc tpr
          ON sca.rcf_dd_tpr_id = tpr.rcf_dd_tpr_id AND tpr.borrado = 0
          LEFT JOIN rcf_itv_iti_metas_volantes itv
          ON sca.rcf_itv_id = itv.rcf_itv_id AND itv.borrado = 0
          LEFT JOIN rcf_mfa_modelos_facturacion mfa
          ON sca.rcf_mfa_id = mfa.rcf_mfa_id AND mfa.borrado = 0
          LEFT JOIN rcf_sua_subcartera_agencias sua
          ON sca.rcf_sca_id = sua.rcf_sca_id AND sua.borrado = 0
          LEFT JOIN rcf_age_agencias age
          ON sua.rcf_age_id = age.rcf_age_id AND age.borrado = 0
          LEFT JOIN rcf_sur_subcartera_ranking sur
          ON sca.rcf_sca_id = sur.rcf_sur_id AND sur.borrado = 0
          LEFT JOIN rcf_poa_politica_acuerdos poa
          ON sca.rcf_poa_id = poa.rcf_poa_id AND poa.borrado = 0
          LEFT JOIN rcf_mor_modelo_ranking mor ON sca.rcf_mor_id =
                                                                mor.rcf_mor_id
    WHERE ees.rcf_dd_ees_codigo IN ('EXG', 'LBR');
   
     
 */
       
/*
 BACKUP - NO SE EJECUTA
 
 				CREATE MATERIALIZED VIEW DATA_RULE_ENGINE
				BUILD IMMEDIATE
				REFRESH FORCE ON DEMAND
				WITH PRIMARY KEY
				AS 
				SELECT per.per_id, per.dd_sce_id, per.dd_tpe_id, per.per_ecv, per.dd_pol_id,
				       per.per_nacionalidad, per.per_pais_nacimiento, per.per_sexo,
				       per.ofi_id, per.zon_id, per.pef_id, per.usu_id, per.dd_gge_id,
				       per.dd_rex_id, per.dd_rax_id, per.dd_px3_id, per.dd_px4_id,
				       per.per_riesgo, per.per_riesgo_ind, per.per_vr_daniado_otras_ent,
				       per.per_vr_otras_ent, per_nro_socios, per.per_nro_empleados num_emp,
				       per.per_extra_1, per.per_extra_2, per.per_fecha_constitucion,
				       per.per_extra_5, per.per_extra_6, per.tpl_id prepo_cal,
				       per.per_riesgo_dir_danyado ris_dir, gcl.gcl_riesgo_dir ris_dir_gru,
				       gcl.gcl_riesgo_dir_danyado ris_dir_dan_gru,
				       per.per_ultima_operacion fecha_ult_oper, ant.ant_reincidencia_internos,
				       pto.pto_puntuacion, pto.pto_intervalo, cnt.dd_ct1_id, cnt.dd_ct2_id,
				       cnt.dd_ct3_id, cnt.dd_ct4_id, cnt.dd_ct5_id, cnt.dd_ct6_id,
				       cnt.dd_mon_id, cnt.dd_efc_id, cnt.dd_efc_id_ant, cnt.dd_gc1_id,
				       cnt.dd_gc2_id, cnt.dd_fno_id, cnt.dd_fcn_id, mov.dd_mx3_id,
				       mov.dd_mx4_id, mov.mov_riesgo, mov.mov_deuda_irregular,
				       mov.mov_saldo_dudoso, mov.mov_dispuesto, mov.mov_provision,
				       mov.mov_int_remuneratorios, mov.mov_int_moratorios, mov.mov_comisiones,
				       mov.mov_gastos, mov.mov_saldo_pasivo, cnt.cnt_limite_ini,
				       cnt.cnt_limite_fin, mov.mov_riesgo_garant, mov.mov_saldo_exce,
				       mov.mov_ltv_ini, mov.mov_ltv_fin, mov.mov_limite_desc, mov.mov_extra_1,
				       mov.mov_extra_2, cnt.cnt_fecha_creacion, mov.mov_fecha_pos_vencida,
				       mov.mov_fecha_dudoso, cnt.cnt_fecha_efc, cnt.cnt_fecha_efc_ant,
				       cnt.cnt_fecha_esc, cnt.cnt_fecha_constitucion, cnt.cnt_fecha_venc,
				       mov.mov_extra_5, mov.mov_extra_6, per.arq_id_calculado,
				       per.per_deuda_irregular, per.per_deuda_irregular_dir,
				       per.per_deuda_irregular_ind, cnt.dd_esc_id
				  FROM per_personas per LEFT JOIN cpe_contratos_personas cpe
				       ON per.per_id = cpe.per_id                                    --PER_CPE
				       LEFT JOIN cnt_contratos cnt ON cpe.cnt_id = cnt.cnt_id        --CPE_CNT
				       LEFT JOIN mov_movimientos mov
				       ON cnt.cnt_id = mov.cnt_id
				     AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion         --CNT_MOV
				       LEFT JOIN ant_antecedentes ant ON ant.ant_id = per.ant_id
				       LEFT JOIN pto_puntuacion_total pto
				       ON pto.per_id = per.per_id
				     AND (pto.pto_activo = 1 OR pto.pto_activo IS NULL)              --PER_PTO
				       LEFT JOIN per_gcl pg ON pg.per_id = per.per_id
				       LEFT JOIN gcl_grupos_clientes gcl ON pg.gcl_id = gcl.gcl_id
  
 */       
       

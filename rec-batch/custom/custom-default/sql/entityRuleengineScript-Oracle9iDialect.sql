
--Creacion de la Tabla de datos para las ejecucion de reglas
create MATERIALIZED view DATA_RULE_ENGINE as
SELECT per.per_id, per.dd_sce_id, per.dd_tpe_id, per.per_ecv, per.dd_pol_id, per.per_nacionalidad, per.per_pais_nacimiento, per.per_sexo, per.ofi_id, per.zon_id, per.pef_id, per.usu_id, 
    per.dd_gge_id, per.dd_rex_id, per.dd_rax_id, per.dd_px3_id, per.dd_px4_id, per.per_riesgo, per.per_riesgo_ind, per.per_vr_daniado_otras_ent, per.per_vr_otras_ent, per_nro_socios, 
    per.PER_NRO_EMPLEADOS num_emp, per.per_extra_1, per.per_extra_2, per.per_fecha_constitucion, per.per_extra_5, per.per_extra_6, per.TPL_ID prepo_cal, per.PER_RIESGO_DIR_DANYADO ris_dir, 
    gcl.GCL_RIESGO_DIR ris_dir_gru, gcl.GCL_RIESGO_DIR_DANYADO ris_dir_dan_gru, per.PER_ULTIMA_OPERACION fecha_ult_oper, ant.ant_reincidencia_internos, pto.pto_puntuacion, pto.pto_intervalo, 
    cnt.dd_ct1_id, cnt.dd_ct2_id, cnt.dd_ct3_id, cnt.dd_ct4_id, cnt.dd_ct5_id, cnt.dd_ct6_id, cnt.dd_mon_id, cnt.dd_efc_id, cnt.dd_efc_id_ant, cnt.dd_gc1_id, cnt.dd_gc2_id, cnt.dd_fno_id, 
    cnt.dd_fcn_id, mov.dd_mx3_id, mov.dd_mx4_id, mov.mov_riesgo, mov.mov_deuda_irregular, mov.mov_saldo_dudoso, mov.mov_dispuesto, mov.mov_provision, mov.mov_int_remuneratorios, 
    mov.mov_int_moratorios, mov.mov_comisiones, mov.mov_gastos, mov.mov_saldo_pasivo, cnt.cnt_limite_ini, cnt.cnt_limite_fin, mov.mov_riesgo_garant, mov.mov_saldo_exce, mov.mov_ltv_ini, 
    mov.mov_ltv_fin, mov.mov_limite_desc, mov.mov_extra_1, mov.mov_extra_2, cnt.cnt_fecha_creacion, mov.mov_fecha_pos_vencida, mov.mov_fecha_dudoso, cnt.cnt_fecha_efc, cnt.cnt_fecha_efc_ant, 
    cnt.cnt_fecha_esc, cnt.cnt_fecha_constitucion, cnt.cnt_fecha_venc, mov.mov_extra_5, mov.mov_extra_6, per.ARQ_ID_CALCULADO,per.PER_DEUDA_IRREGULAR, per.PER_DEUDA_IRREGULAR_DIR, 
    per.PER_DEUDA_IRREGULAR_IND, cnt.dd_esc_id
FROM PER_PERSONAS per
left join  CPE_CONTRATOS_PERSONAS cpe
        on per.per_id = cpe.per_id --PER_CPE
left join CNT_CONTRATOS cnt
        on cpe.cnt_id = cnt.cnt_id --CPE_CNT
left join MOV_MOVIMIENTOS mov
        on cnt.cnt_id = mov.cnt_id AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion --CNT_MOV
left join ANT_ANTECEDENTES ant
        on ant.ant_id = per.ant_id
left join PTO_PUNTUACION_TOTAL pto
        on pto.per_id = per.per_id AND (pto.pto_activo = 1 OR pto.pto_activo IS NULL) --PER_PTO
left join PER_GCL pg
        on pg.per_id = per.per_id
left join GCL_GRUPOS_CLIENTES gcl
        on pg.gcl_id = gcl.gcl_id;
        
        
        
        
CREATE SEQUENCE S_DD_RULE_DEFINITION START WITH ${initialId} NOCYCLE CACHE 100;

CREATE TABLE DD_RULE_DEFINITION (
	RD_ID				 NUMBER(16)							 NOT NULL,
	RD_TITLE             VARCHAR2(100 CHAR)         	     NOT NULL,
	RD_COLUMN            VARCHAR2(100 CHAR)             	 NOT NULL,
	RD_TYPE              VARCHAR2(100 CHAR)             	 NOT NULL,
	RD_VALUE_FORMAT  	 VARCHAR2(50  CHAR)					 NOT NULL,
	RD_BO_VALUES         VARCHAR2(50  CHAR),
	RD_TAB               VARCHAR2(50  CHAR),
	USUARIOCREAR         VARCHAR2(10 BYTE) DEFAULT 'DD'      NOT NULL,
   	FECHACREAR           TIMESTAMP(6)      DEFAULT sysdate   NOT NULL,
   	USUARIOMODIFICAR     VARCHAR2(10 BYTE),
   	FECHAMODIFICAR       TIMESTAMP(6),
   	USUARIOBORRAR        VARCHAR2(10 BYTE),
   	FECHABORRAR          TIMESTAMP(6),
   	BORRADO              NUMBER(1)       DEFAULT 0           NOT NULL,
	CONSTRAINT PK_DD_RULE_DEFINITION PRIMARY KEY (RD_ID)
);

INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_id','per_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'SCE','dd_sce_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Tipo Persona','dd_tpe_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_ecv','per_ecv','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_pol_id','dd_pol_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_nacionalidad','per_nacionalidad','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_pais_nacimiento','per_pais_nacimiento','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Sexo','per_sexo','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'ofi_id','ofi_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'zon_id','zon_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'pef_id','pef_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'usu_id','usu_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_gge_id','dd_gge_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_rex_id','dd_rex_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_rax_id','dd_rax_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_px3_id','dd_px3_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_px4_id','dd_px4_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Persona Riesgo','per_riesgo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Persona Riesgo','per_riesgo','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_riesgo_ind','per_riesgo_ind','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_vr_daniado_otras_ent','per_vr_daniado_otras_ent','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_vr_otras_ent','per_vr_otras_ent','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_nro_socios','per_nro_socios','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'num_emp','num_emp','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_extra_1','per_extra_1','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_extra_2','per_extra_2','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_fecha_constitucion','per_fecha_constitucion','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_extra_5','per_extra_5','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'per_extra_6','per_extra_6','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'prepo_cal','prepo_cal','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'is_dir','is_dir','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'ris_dir_gru','ris_dir_gru','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'ris_dir_dan_gru','ris_dir_dan_gru','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'fecha_ult_oper','fecha_ult_oper','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'ant.ant_reincidencia_internos','ant.ant_reincidencia_internos','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'pto_puntuacion','pto_puntuacion','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'pto_intervalo','pto_intervalo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_ct1_id','dd_ct1_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_ct2_id','dd_ct2_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_ct3_id','dd_ct3_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_ct4_id','dd_ct4_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_ct5_id','dd_ct5_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_ct6_id','dd_ct6_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_mon_id','dd_mon_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_efc_id','dd_efc_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_efc_id_ant','dd_efc_id_ant','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_gc1_id','dd_gc1_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_gc2_id','dd_gc2_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_fno_id','dd_fno_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_fcn_id','dd_fcn_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_mx3_id','dd_mx3_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'dd_mx4_id','dd_mx4_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Movimiento Riesgo','mov_riesgo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Movimiento Riesgo','mov_riesgo','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_deuda_irregular','mov_deuda_irregular','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_saldo_dudoso','mov_saldo_dudoso','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_dispuesto','mov_dispuesto','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_provision','mov_provision','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_int_remuneratorios','mov_int_remuneratorios','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_int_moratorios','mov_int_moratorios','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_comisiones','mov_comisiones','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_gastos','mov_gastos','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_saldo_pasivo','mov_saldo_pasivo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_limite_ini','cnt_limite_ini','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_limite_fin','cnt_limite_fin','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_riesgo_garant','mov_riesgo_garant','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_saldo_exce','mov_saldo_exce','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_ltv_ini','mov_ltv_ini','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_ltv_fin','mov_ltv_fin','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_limite_desc','mov_limite_desc','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_extra_1','mov_extra_1','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_extra_2','mov_extra_2','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_fecha_creacion','cnt_fecha_creacion','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_fecha_pos_vencida','mov_fecha_pos_vencida','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_fecha_dudoso','mov_fecha_dudoso','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_fecha_efc','cnt_fecha_efc','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_fecha_efc_ant','cnt_fecha_efc_ant','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_fecha_esc','cnt_fecha_esc','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_fecha_constitucion','cnt_fecha_constitucion','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'cnt_fecha_venc','cnt_fecha_venc','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_extra_5','mov_extra_5','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'mov_extra_6','mov_extra_6','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Nuevo Arquetipo Persona','ARQ_ID_CALCULADO','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextval,'Nuevo Arquetipo Persona','ARQ_ID_CALCULADO','nullable','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra1 de la Entidad para la Persona - Compara2Valores (Carga)','per_extra_1','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra1 del Movimiento del Contrato - Compara2Valores (Carga)','mov_extra_1','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra2 de la Entidad para la Persona - Compara2Valores (Carga)','per_extra_2','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra2 del Movimiento del Contrato - Compara2Valores (Carga)','mov_extra_2','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra5 de la Entidad para la Persona - Compara2Valores (Carga)','per_extra_5','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra5 del Movimiento del Contrato - Compara2Valores (Carga)','mov_extra_5','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra6 de la Entidad para la Persona - Compara2Valores (Carga)','per_extra_6','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Campo Extra6 del Movimiento del Contrato - Compara2Valores (Carga)','mov_extra_6','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval, 'Comisiones del Movimiento del Contrato - Compara2Valores (Carga)','mov_comisiones','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Deuda Irregular del Movimiento del Contrato - Compara2Valores (Carga)','mov_deuda_irregular','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Disponible del Movimiento del Contrato - Compara2Valores (Carga)','mov_limite_desc','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Dispuesto del Movimiento del Contrato - Compara2Valores (Carga)','mov_dispuesto','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha de Constitución de la Persona - Compare2Valores (Carga)','per_fecha_constitucion','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha de Constitución del Contrato - Compara2Valores (Carga)','cnt_fecha_constitucion','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha de Creación del Contrato - Compara2Valores (Carga)','cnt_fecha_creacion','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha de Inicio de la Posición Vencida del Movimiento del Contrato - Compara2Valores (Carga)','mov_fecha_pos_vencida','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha de Inicio Dudoso del Movimiento del Contrato - Compara2Valores (Carga)','mov_fecha_dudoso','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha Estado del Contrato - Compara2Valores (Carga)','cnt_fecha_esc','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha Estado Financiero Anterior del Contrato - Compara2Valores (Carga)','cnt_fecha_efc_ant','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha Estado Financiero del Contrato - Compara2Valores (Carga)','cnt_fecha_efc','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha Ultima Operación Concedida de la Persona - Compara2Valores (Calculado)','fecha_ult_oper','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Fecha Vencimiento del Contrato - Compara2Valores (Carga)','cnt_fecha_ven','compare2','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Gastos del Movimiento del Contrato - Compara2Valores (Carga)','mov_gastos','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Intereses Moratorios del Movimiento del Contrato - Compara2Valores (Carga)','mov_int_moratorios','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Intereses Remuneratorios del Movimiento del Contrato - Compara2Valores (Carga)','mov_int_remuneratorios','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Intervalo de la Puntuacion Total de las Alertas de la Persona - Compara2Valores (Calculado)','pto_intervalo','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Limite Final del Contrato - Compara2Valores (Carga)','cnt_limite_fin','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Limite Inicial del Contrato - Compara2Valores (Carga)','cnt_limite_fin','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'LTV Final del Movimiento del Contrato - Compara2Valores (Carga)','mov_ltv_fin','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'LTV Inicial del Movimiento del Contrato - Compara2Valores (Carga)','mov_ltv_ini','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Número de Empleados de la Persona - Compara2Valores (Carga)','num_emp','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Número de Socios de la Persona - Compara2Valores (Carga)','per_nro_socios','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Provision del Movimiento del Contrato - Compara2Valores (Carga)','mov_provision','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Puntuacion Total del Último Scoring de las Alertas de la Persona - Compara2Valores (Calculado)','pto_puntuacion','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Reincidencia de los Antecedentes Internos de la Persona - Compara2Valores (Calculado)','ant.ant_reincidencia_internos','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Riesgo Dañado de la Persona en Otras Entidades - Compara2Valores (Carga)','per_vr_daniado_otras_ent','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Riesgo de la Persona en Otras Entidades - Compara2Valores (Carga)','per_vr_otras_ent','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Riesgo Directo Dañado de la Persona - Compara2Valores (Calculado)','ris_dir','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Riesgo Directo Dañado del Grupo de la Persona - Compara2Valores (Calculado)','ris_dir_dan_gru','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Riesgo Directo del Grupo de la Persona - Compara2Valores (Calculado)','ris_dir_gru','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Riesgo Garantizado del Movimiento del Contrato - Compara2Valores (Carga)','mov_riesgo_garant','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Riesgo Indirecto de la Persona - Compara2Valores (Carga)','per_riesgo_ind','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Dudoso del Movimiento del Contrato - Compara2Valores (Carga)','mov_saldo_dudoso','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Excedido del Movimiento del Contrato - Compara2Valores (Carga)','mov_saldo_exce','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Pasivo del Movimiento del Contrato - Compara2Valores (Carga)','mov_saldo_pasivo','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Irregular de la persona - Compara1Valores (Carga)','PER_DEUDA_IRREGULAR','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Irregular de la persona - Compara2Valores (Carga)','PER_DEUDA_IRREGULAR','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Directo Irregular de la persona - Compara1Valores (Carga)','PER_DEUDA_IRREGULAR_DIR','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Directo Irregular de la persona - Compara2Valores (Carga)','PER_DEUDA_IRREGULAR_DIR','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Indirecto Irregular de la persona - Compara1Valores (Carga)','PER_DEUDA_IRREGULAR_IND','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Saldo Indirecto Irregular de la persona - Compara2Valores (Carga)','PER_DEUDA_IRREGULAR_IND','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN,RD_TYPE, RD_VALUE_FORMAT)VALUES (S_DD_RULE_DEFINITION.nextval,'Estado financiero de la persona','dd_esc_id','dictionary','number');



CREATE SEQUENCE S_RULE_DEFINITION START WITH ${initialId} NOCYCLE CACHE 100;

CREATE TABLE RULE_DEFINITION (
	RD_ID				 NUMBER(16)						 NOT NULL,
	RD_NAME              VARCHAR2(250  CHAR)             NOT NULL,
	RD_NAME_LONG         VARCHAR2(500 BYTE),
	RD_DEFINITION        VARCHAR2(4000 CHAR)             NOT NULL,
	USUARIOCREAR         VARCHAR2(10 BYTE) DEFAULT 'DD'      NOT NULL,
   	FECHACREAR           TIMESTAMP(6)      DEFAULT sysdate   NOT NULL,
   	USUARIOMODIFICAR     VARCHAR2(10 BYTE),
   	FECHAMODIFICAR       TIMESTAMP(6),
   	USUARIOBORRAR        VARCHAR2(10 BYTE),
   	FECHABORRAR          TIMESTAMP(6),
   	BORRADO              NUMBER(1)       DEFAULT 0           NOT NULL,
	CONSTRAINT PK_RULE_DEFINITION PRIMARY KEY (RD_ID)
);


ALTER TABLE ARQ_ARQUETIPOS    ADD (CONSTRAINT FK_ARQ_ARQU_FK_RULE_DEFINITION FOREIGN  KEY (RD_ID) REFERENCES RULE_DEFINITION (RD_ID));
ALTER TABLE TPL_TIPO_POLITICA ADD (CONSTRAINT FK_TPL_T_P_FK_RULE_DEFINITION FOREIGN KEY (RD_ID) REFERENCES RULE_DEFINITION (RD_ID));


--- BusinessOperations ---

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDSegmento'
where RD_COLUMN='dd_sce_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDTipoPersona'
where RD_COLUMN='dd_tpe_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDPolitica'
where RD_COLUMN='dd_pol_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDPais'
where RD_COLUMN='per_nacionalidad' OR RD_COLUMN='per_pais_nacimiento';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDSexo'
where RD_COLUMN='per_sexo';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDGrupoGestor'
where RD_COLUMN='dd_gge_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDRatingExterno'
where RD_COLUMN='dd_rex_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDRatingAuxiliar'
where RD_COLUMN='dd_rax_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDPersonaExtra3'
where RD_COLUMN='dd_px3_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDPersonaExtra4'
where RD_COLUMN='dd_px4_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'Arquetipo'
where RD_COLUMN='ARQ_ID_CALCULADO' and rd_type='dictionary';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDCatalogo1'
where RD_COLUMN='dd_ct1_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDCatalogo2'
where RD_COLUMN='dd_ct2_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDCatalogo3'
where RD_COLUMN='dd_ct3_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDCatalogo4'
where RD_COLUMN='dd_ct4_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDCatalogo5'
where RD_COLUMN='dd_ct5_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDCatalogo6'
where RD_COLUMN='dd_ct6_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDMoneda'
where RD_COLUMN='dd_mon_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDEstadoFinanciero'
where RD_COLUMN='dd_efc_id' or RD_COLUMN='dd_efc_id_ant';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDGarantiaContrato'
where RD_COLUMN='dd_gc1_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDGarantiaContable'
where RD_COLUMN='dd_gc2_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDFinalidadOficial'
where RD_COLUMN='dd_fno_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDFinalidadContrato'
where RD_COLUMN='dd_fcn_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDMovimientoExtra3'
where RD_COLUMN='dd_mx3_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDMovimientoExtra4'
where RD_COLUMN='dd_mx4_id';

update DD_RULE_DEFINITION set RD_BO_VALUES = 'DDEstadoContrato'
where RD_COLUMN='dd_esc_id';


--- Tabs ---

update DD_RULE_DEFINITION set RD_TAB='SinTab';

update DD_RULE_DEFINITION set RD_TAB='Persona'
where RD_COLUMN IN ('per_ecv', 'ofi_id', 'zon_id', 'pef_id', 'usu_id', 'per_nro_socios', 'num_emp', 'per_extra_1', 'per_extra_2', 'per_fecha_constitucion', 'per_extra_5', 'per_extra_6'
, 'prepo_cal', 'ant.ant_reincidencia_internos', 'pto_puntuacion', 'pto_intervalo', 'ARQ_ID_CALCULADO', 'per_extra_1', 'per_extra_2', 'per_extra_5', 'per_extra_6', 'PER_DEUDA_IRREGULAR_IND'
, 'PER_DEUDA_IRREGULAR_DIR', 'PER_DEUDA_IRREGULAR_DIR', 'PER_DEUDA_IRREGULAR', 'PER_DEUDA_IRREGULAR', 'ris_dir', 'PER_DEUDA_IRREGULAR_IND'
, 'per_id', 'dd_tpe_id', 'dd_pol_id', 'per_nacionalidad', 'per_pais_nacimiento', 'per_sexo', 'dd_gge_id', 'dd_rex_id', 'dd_rax_id', 'dd_px3_id', 'dd_px4_id', 'dd_sce_id');


update DD_RULE_DEFINITION set RD_TAB='Contrato'
where RD_COLUMN IN ('fecha_ult_oper', 'mov_deuda_irregular', 'mov_saldo_dudoso', 'mov_dispuesto', 'mov_provision', 'mov_int_remuneratorios', 'mov_int_moratorios', 'mov_comisiones', 'mov_gastos'
, 'mov_saldo_pasivo', 'cnt_limite_ini', 'cnt_limite_fin', 'mov_riesgo_garant', 'mov_saldo_exce', 'mov_ltv_ini', 'mov_ltv_fin', 'mov_limite_desc', 'mov_extra_1', 'mov_extra_2', 'cnt_fecha_creacion'
, 'mov_fecha_pos_vencida', 'mov_fecha_dudoso', 'cnt_fecha_efc', 'cnt_fecha_efc_ant', 'cnt_fecha_esc', 'cnt_fecha_constitucion', 'cnt_fecha_venc', 'mov_extra_5', 'mov_extra_6', 'mov_extra_1'
, 'mov_extra_2', 'mov_extra_5', 'mov_extra_6', 'mov_comisiones', 'cnt_fecha_ven'
, 'dd_fno_id', 'dd_ct1_id', 'dd_ct2_id', 'dd_ct3_id', 'dd_ct4_id', 'dd_ct5_id', 'dd_ct6_id', 'dd_mon_id', 'dd_efc_id', 'dd_efc_id_ant', 'dd_gc1_id', 'dd_gc2_id', 'dd_fcn_id', 'dd_mx3_id', 'dd_mx4_id'
, 'dd_esc_id');
 

update DD_RULE_DEFINITION set RD_TAB='Riesgo'
where RD_COLUMN IN ('per_riesgo', 'per_riesgo_ind', 'per_vr_daniado_otras_ent', 'per_vr_otras_ent', 'is_dir', 'ris_dir_gru', 'ris_dir_dan_gru', 'mov_riesgo');

select S_RULE_DEFINITION.nextVal from RULE_DEFINITION




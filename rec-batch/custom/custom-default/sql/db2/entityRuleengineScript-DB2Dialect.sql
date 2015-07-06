
--Creacion de la vista para las ejecucion de reglas
create or replace view V_ARQUETIPOS as
SELECT per.per_id, per.dd_sce_id, per.dd_tpe_id, per.per_ecv, per.dd_pol_id, per.per_nacionalidad, per.per_pais_nacimiento, per.per_sexo, per.ofi_id, per.zon_id, per.pef_id, per.usu_id, 
    per.dd_gge_id, per.dd_rex_id, per.dd_rax_id, per.dd_px3_id, per.dd_px4_id, per.per_riesgo, per.per_riesgo_ind, per.per_vr_daniado_otras_ent, per.per_vr_otras_ent, per_nro_socios, 
    '*** Numero empleados' num_emp, per.per_extra_1, per.per_extra_2, per.per_fecha_constitucion, per.per_extra_5, per.per_extra_6, '*** Prepolitica calculada' prepo_cal, '*** Riesgo directo dañado' ris_dir, 
    '*** Riesgo directo grupo' ris_dir_gru, '*** Riesgo directo dañado grupo' ris_dir_dan_gru, '*** Fecha ultima operacion' fecha_ult_oper, ant.ant_reincidencia_internos, pto.pto_puntuacion, pto.pto_intervalo, 
    cnt.dd_ct1_id, cnt.dd_ct2_id, cnt.dd_ct3_id, cnt.dd_ct4_id, cnt.dd_ct5_id, cnt.dd_ct6_id, cnt.dd_mon_id, cnt.dd_efc_id, cnt.dd_efc_id_ant, cnt.dd_gc1_id, cnt.dd_gc2_id, cnt.dd_fno_id, 
    cnt.dd_fcn_id, mov.dd_mx3_id, mov.dd_mx4_id, mov.mov_riesgo, mov.mov_deuda_irregular, mov.mov_saldo_dudoso, mov.mov_dispuesto, mov.mov_provision, mov.mov_int_remuneratorios, 
    mov.mov_int_moratorios, mov.mov_comisiones, mov.mov_gastos, mov.mov_saldo_pasivo, cnt.cnt_limite_ini, cnt.cnt_limite_fin, mov.mov_riesgo_garant, mov.mov_saldo_exce, mov.mov_ltv_ini, 
    mov.mov_ltv_fin, mov.mov_limite_desc, mov.mov_extra_1, mov.mov_extra_2, cnt.cnt_fecha_creacion, mov.mov_fecha_pos_vencida, mov.mov_fecha_dudoso, cnt.cnt_fecha_efc, cnt.cnt_fecha_efc_ant, 
    cnt.cnt_fecha_esc, cnt.cnt_fecha_constitucion, cnt.cnt_fecha_venc, mov.mov_extra_5, mov.mov_extra_6, per.ARQ_ID_CALCULADO
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
        on pto.per_id = per.per_id AND (pto.pto_activo = 1 OR pto.pto_activo IS NULL); --PER_PTO
        
        
        
        
CREATE SEQUENCE S_DD_RULE_DEFINITION START WITH ${initialId} NOCYCLE CACHE 100;

CREATE TABLE DD_RULE_DEFINITION (
	RD_ID				 NUMBER(16)						NOT NULL,
	RD_TITLE             VARCHAR2(100 CHAR)             NOT NULL,
	RD_COLUMN            VARCHAR2(100 CHAR)             NOT NULL,
	RD_TYPE              VARCHAR2(100 CHAR)             NOT NULL,
	RD_VALUE_FORMAT  	 VARCHAR2(50  CHAR)				NOT NULL,
	CONSTRAINT PK_DD_RULE_DEFINITION PRIMARY KEY (RD_ID)
);

INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_id','per_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'SCE','dd_sce_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Tipo Persona','dd_tpe_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_ecv','per_ecv','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_pol_id','dd_pol_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_nacionalidad','per_nacionalidad','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_pais_nacimiento','per_pais_nacimiento','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Sexo','per_sexo','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'ofi_id','ofi_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'zon_id','zon_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'pef_id','pef_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'usu_id','usu_id','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_gge_id','dd_gge_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_rex_id','dd_rex_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_rax_id','dd_rax_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_px3_id','dd_px3_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_px4_id','dd_px4_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Persona Riesgo','per_riesgo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Persona Riesgo','per_riesgo','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_riesgo_ind','per_riesgo_ind','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_vr_daniado_otras_ent','per_vr_daniado_otras_ent','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_vr_otras_ent','per_vr_otras_ent','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_nro_socios','per_nro_socios','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'num_emp','num_emp','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_extra_1','per_extra_1','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_extra_2','per_extra_2','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_fecha_constitucion','per_fecha_constitucion','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_extra_5','per_extra_5','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'per_extra_6','per_extra_6','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'prepo_cal','prepo_cal','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'is_dir','is_dir','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'ris_dir_gru','ris_dir_gru','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'ris_dir_dan_gru','ris_dir_dan_gru','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'fecha_ult_oper','fecha_ult_oper','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'ant.ant_reincidencia_internos','ant.ant_reincidencia_internos','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'pto_puntuacion','pto_puntuacion','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'pto_intervalo','pto_intervalo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_ct1_id','dd_ct1_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_ct2_id','dd_ct2_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_ct3_id','dd_ct3_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_ct4_id','dd_ct4_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_ct5_id','dd_ct5_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_ct6_id','dd_ct6_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_mon_id','dd_mon_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_efc_id','dd_efc_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_efc_id_ant','dd_efc_id_ant','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_gc1_id','dd_gc1_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_gc2_id','dd_gc2_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_fno_id','dd_fno_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_fcn_id','dd_fcn_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_mx3_id','dd_mx3_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'dd_mx4_id','dd_mx4_id','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Movimiento Riesgo','mov_riesgo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Movimiento Riesgo','mov_riesgo','compare2','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_deuda_irregular','mov_deuda_irregular','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_saldo_dudoso','mov_saldo_dudoso','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_dispuesto','mov_dispuesto','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_provision','mov_provision','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_int_remuneratorios','mov_int_remuneratorios','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_int_moratorios','mov_int_moratorios','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_comisiones','mov_comisiones','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_gastos','mov_gastos','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_saldo_pasivo','mov_saldo_pasivo','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_limite_ini','cnt_limite_ini','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_limite_fin','cnt_limite_fin','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_riesgo_garant','mov_riesgo_garant','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_saldo_exce','mov_saldo_exce','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_ltv_ini','mov_ltv_ini','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_ltv_fin','mov_ltv_fin','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_limite_desc','mov_limite_desc','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_extra_1','mov_extra_1','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_extra_2','mov_extra_2','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_fecha_creacion','cnt_fecha_creacion','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_fecha_pos_vencida','mov_fecha_pos_vencida','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_fecha_dudoso','mov_fecha_dudoso','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_fecha_efc','cnt_fecha_efc','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_fecha_efc_ant','cnt_fecha_efc_ant','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_fecha_esc','cnt_fecha_esc','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_fecha_constitucion','cnt_fecha_constitucion','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'cnt_fecha_venc','cnt_fecha_venc','compare1','date');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_extra_5','mov_extra_5','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'mov_extra_6','mov_extra_6','compare1','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Nuevo Arquetipo Persona','ARQ_ID_CALCULADO','dictionary','number');
INSERT INTO DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT) VALUES (S_DD_RULE_DEFINITION.nextVal,'Nuevo Arquetipo Persona','ARQ_ID_CALCULADO','nullable','number');

CREATE SEQUENCE S_RULE_DEFINITION START WITH ${initialId} NOCYCLE CACHE 100;

CREATE TABLE RULE_DEFINITION (
	RD_ID				 NUMBER(16)						 NOT NULL,
	RD_NAME             VARCHAR2(250  CHAR)             NOT NULL,
	RD_DEFINITION       VARCHAR2(4000 CHAR)             NOT NULL,
	CONSTRAINT PK_RULE_DEFINITION PRIMARY KEY (RD_ID)
);

INSERT INTO RULE_DEFINITION ( RD_ID, RD_NAME, RD_DEFINITION ) VALUES (1, 'Hombres', '{type:''compare1'', title:''Hombre'', ruleId: 8, operator: ''equal'', values: [''1'']}');
INSERT INTO RULE_DEFINITION ( RD_ID, RD_NAME, RD_DEFINITION ) VALUES (2, 'Mujer', '{type:''compare1'', title:''Mujer'', ruleId: 8, operator: ''equal'', values: [''2'']}');


ALTER TABLE ARQ_ARQUETIPOS ADD (CONSTRAINT FK_ARQ_ARQU_FK_RULE_DEFINITION FOREIGN KEY (RD_ID) REFERENCES RULE_DEFINITION (RD_ID));




CREATE TABLE H_REC_FICHERO_CONTRATOS(	
    "FECHA_HIST" TIMESTAMP (6) NOT NULL ENABLE, 
    "RCF_AGE_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"RCF_SCA_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"ID_ENVIO" NUMBER(24,0) NOT NULL ENABLE, 
	"ID_EXPEDIENTE" NUMBER(16,0) NOT NULL ENABLE, 
	"ID_CARTERA" NUMBER(16,0) NOT NULL ENABLE, 
	"CARTERA_EXPEDIENTE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"CODIGO_ENTIDAD" NUMBER(4,0) NOT NULL ENABLE, 
	"COD_ENTIDAD_OFI_ADMIN" NUMBER(5,0) NOT NULL ENABLE, 
	"COD_OFI_ADMIN" NUMBER(5,0) NOT NULL ENABLE, 
	"DIR_OFI_ADMIN" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"CODIGO_PROPIETARIO" NUMBER(5,0) NOT NULL ENABLE, 
	"TIPO_PRODUCTO" VARCHAR2(5 CHAR) NOT NULL ENABLE, 
	"NUMERO_CONTRATO" NUMBER(17,0) NOT NULL ENABLE, 
	"NUMERO_ESPEC" NUMBER(15,0) NOT NULL ENABLE, 
	"IBAN_CONTRATO" VARCHAR2(24 CHAR), 
	"CNT_DOMICILIACION" VARCHAR2(20 CHAR), 
	"IBAN_CNT_DOMICILIACION" VARCHAR2(24 CHAR), 
	"CD_SITUACION_CONTABLE" VARCHAR2(3 CHAR) NOT NULL ENABLE, 
	"SITUACION_CONTABLE" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"POS_VIVA_NO_VENCIDA" NUMBER(16,2) NOT NULL ENABLE, 
	"POS_VIVA_VENCIDA" NUMBER(16,2) NOT NULL ENABLE, 
	"INT_ORDIN_DEVEN" NUMBER(16,2) NOT NULL ENABLE, 
	"INT_MORAT_DEVEN" NUMBER(16,2) NOT NULL ENABLE, 
	"COMISIONES" NUMBER(16,2) NOT NULL ENABLE, 
	"GASTOS" NUMBER(16,2) NOT NULL ENABLE, 
	"IMPUESTOS" NUMBER(16,2), 
	"ENTREGAS" NUMBER(16,2) NOT NULL ENABLE, 
	"INT_ENTREGAS" NUMBER(16,2) NOT NULL ENABLE, 
	"DEUDA_IRREGULAR" NUMBER(16,2) NOT NULL ENABLE, 
	"LIMITE_INICIAL" NUMBER(16,2) NOT NULL ENABLE, 
	"LIMITE_ACTUAL" NUMBER(16,2) NOT NULL ENABLE, 
	"FECHA_CREACION" TIMESTAMP (6) NOT NULL ENABLE, 
	"FECHA_INI_IRREGU" TIMESTAMP (6), 
	"FECHA_POS_VENCIDA" TIMESTAMP (6) NOT NULL ENABLE, 
	"CD_PRODUCTO_COMERCIAL" VARCHAR2(1024 BYTE) NOT NULL ENABLE, 
	"CATALOGO1" VARCHAR2(1024 CHAR) NOT NULL ENABLE, 
	"CATALOGO2" VARCHAR2(1024 CHAR) NOT NULL ENABLE, 
	"CD_GARANTIA1" NUMBER(4,0), 
	"GARANTIA1" VARCHAR2(255 CHAR), 
	"CD_GARANTIA2" NUMBER(4,0), 
	"GARANTIA2" VARCHAR2(255 CHAR), 
	"CONTACTO_ENTIDAD_NOMBRE" VARCHAR2(255 CHAR), 
	"CONTACTO_ENTIDAD_TEL" VARCHAR2(25 CHAR), 
	"CONTACTO_ENTIDAD_EMAIL" VARCHAR2(255 CHAR), 
	"SITUACION_GESTION" VARCHAR2(3 CHAR), 
	"CUOTA_IMPORTE" NUMBER(16,2), 
	"CUOTA_PERIODICIDAD" NUMBER(3,0), 
	"CD_FINALIDAD" VARCHAR2(5 CHAR), 
	"DESC_OFICIAL_FINALIDAD" VARCHAR2(255 CHAR), 
	"FECHA_VENCIMIENTO" TIMESTAMP (6) NOT NULL ENABLE, 
	"CD_SISTEMA_AMORTIZACION" VARCHAR2(8 CHAR), 
	"SISTEMA_AMORTIZACION" VARCHAR2(255 CHAR), 
	"TIPO_INTERES" NUMBER(7,5) NOT NULL ENABLE, 
	"FECHA_PLAZO_MINIMO_GESTION" TIMESTAMP (6) NOT NULL ENABLE, 
	"FECHA_MAX_COBRO_PARCIAL" TIMESTAMP (6), 
	"FECHA_MAX_REGULARIZACION" TIMESTAMP (6) NOT NULL ENABLE, 
	"FECHA_EXTRA1" TIMESTAMP (6), 
	"FECHA_EXTRA2" TIMESTAMP (6), 
	"FECHA_EXTRA3" TIMESTAMP (6), 
	"FECHA_EXTRA4" TIMESTAMP (6), 
	"FECHA_EXTRA5" TIMESTAMP (6), 
	"FECHA_EXTRA6" TIMESTAMP (6), 
	"FECHA_EXTRA7" TIMESTAMP (6), 
	"FECHA_EXTRA8" TIMESTAMP (6), 
	"FECHA_EXTRA9" TIMESTAMP (6), 
	"FECHA_EXTRA10" TIMESTAMP (6), 
	"NUMERO_EXTRA1" NUMBER(16,2), 
	"NUMERO_EXTRA2" NUMBER(16,2), 
	"NUMERO_EXTRA3" NUMBER(16,2), 
	"NUMERO_EXTRA4" NUMBER(16,2), 
	"NUMERO_EXTRA5" NUMBER(16,2), 
	"NUMERO_EXTRA6" NUMBER(16,2), 
	"NUMERO_EXTRA7" NUMBER(16,2), 
	"NUMERO_EXTRA8" NUMBER(16,2), 
	"NUMERO_EXTRA9" NUMBER(16,2), 
	"NUMERO_EXTRA10" NUMBER(16,2), 
	"LCHAR_EXTRA1" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA2" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA3" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA4" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA5" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA6" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA7" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA8" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA9" VARCHAR2(250 CHAR), 
	"LCHAR_EXTRA10" VARCHAR2(250 CHAR)
   );                           
            
ALTER TABLE TMP_REC_FICHERO_CONTRATOS MODIFY CNT_CONTRATO VARCHAR2(50 char);

ALTER TABLE REC_FICHERO_PERSONAS MODIFY DS_TIPO_DOCUMENTO VARCHAR2(50 char);

ALTER TABLE REC_FICHERO_TELEFONOS MODIFY ULTIMO_CONTACTO  DEFAULT 0;

ALTER TABLE REC_FICHERO_CONTRATOS MODIFY CD_PRODUCTO_COMERCIAL VARCHAR2(1024 BYTE);

create index IDX_EXP_EXPEDIENTES_DD_EEX_ID on EXP_EXPEDIENTES(DD_EEX_ID);

create index IDX_EXC_EXCEPTUACION_DD_MOE_ID on EXC_EXCEPTUACION(DD_MOE_ID);

create index IDX_EXC_EXCEPTUACION_BORRADO on EXC_EXCEPTUACION(BORRADO);

create index IDX_GEE_GESTOR_ENTIDAD_USU_ID on GEE_GESTOR_ENTIDAD (USU_ID);

create index IDX_GEE_GESTOR_ENTIDAD_TGE_ID on GEE_GESTOR_ENTIDAD (DD_TGE_ID);

create index IDX_TMP_REC_FICH_CNT_CNT_ID on TMP_REC_FICHERO_CONTRATOS (CNT_ID);

create index IDX_TMP_REC_FICH_CNT_CNT_CON on TMP_REC_FICHERO_CONTRATOS (CNT_CONTRATO);

create index IDX_TMP_REC_EXP_REP_AGE_EXP_ID on TMP_REC_EXP_REPARTO_AGENCIAS (EXP_ID);

CREATE TABLE TMP_REC_EXP_AGE_MAR_SUB (
	RCF_AGE_ID   	NUMBER(16) NOT NULL,
	RCF_SCA_ID   	NUMBER(16) NOT NULL, 
	EXP_ID      	NUMBER(16) NOT NULL,
	PER_ID      	NUMBER(16) NOT NULL
);

CREATE TABLE TMP_REC_EXP_SIN_RIESGOS_SUB (
   EXP_ID NUMBER(16) NOT NULL,
   RIESGO NUMBER(14, 2) NOT NULL
);
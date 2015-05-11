CREATE TABLE CPR_COBROS_PAGOS_RECOBRO (
    CPR_ID          	NUMBER(16) NOT NULL,
	CPA_ID          	NUMBER(16) NOT NULL,
	CPA_FECHA       	DATE NOT NULL,
	CNT_ID          	NUMBER(16) NOT NULL,
	EXP_ID          	NUMBER(16) NOT NULL,
	RCF_AGE_ID      	NUMBER(16) NOT NULL,
	RCF_SCA_ID			NUMBER(16) NOT NULL 
);

CREATE TABLE CCR_CONTROL_COBROS_RECOBRO (
    CCR_ID		NUMBER(16) NOT NULL,
	CCR_FECHA		TIMESTAMP(6) NOT NULL
);

CREATE TABLE TMP_RECOBRO_DETALLE_FACTURA (    
    PFS_ID                  NUMBER(16)          NOT NULL,
    CPA_ID                  NUMBER(16)          NOT NULL,
    CNT_ID                  NUMBER(16)          NOT NULL,
    EXP_ID                  NUMBER(16)          NOT NULL,
	RCF_SCA_ID              NUMBER(16)          NOT NULL,
    RCF_AGE_ID              NUMBER(16)          NOT NULL,
    RDF_FECHA_COBRO         TIMESTAMP(6)	  NOT NULL,
    RDF_PORCENTAJE          NUMBER(16,2),
    RDF_IMPORTE_A_PAGAR     NUMBER(16,2)        NOT NULL
);

CREATE TABLE TMP_RECOBRO_DETALLE_FACTURA_CO (    
    PFS_ID                  NUMBER(16)          NOT NULL,
    CPA_ID                  NUMBER(16)          NOT NULL,
    CNT_ID                  NUMBER(16)          NOT NULL,
    EXP_ID                  NUMBER(16)          NOT NULL,
	RCF_SCA_ID              NUMBER(16)          NOT NULL,
    RCF_AGE_ID              NUMBER(16)          NOT NULL,
	RDF_FECHA_COBRO         TIMESTAMP(6)	  	NOT NULL,    
	RDF_PORCENTAJE          NUMBER(16,2),
    RDF_IMPORTE_A_PAGAR     NUMBER(16,2)        NOT NULL
);

CREATE TABLE H_RECOBRO_DETALLE_FACTURA (    
	FECHA_HIST			TIMESTAMP(6) 	   		NOT NULL,
	H_RDF_ID                NUMBER(16)          NOT NULL,
    PFS_ID                  NUMBER(16)          NOT NULL,
    CPA_ID                  NUMBER(16)          NOT NULL,
    CNT_ID                  NUMBER(16)          NOT NULL,
    EXP_ID                  NUMBER(16)          NOT NULL,
	RCF_SCA_ID              NUMBER(16)          NOT NULL,
    RCF_AGE_ID              NUMBER(16)          NOT NULL,
    RDF_FECHA_COBRO         TIMESTAMP(6)	  	NOT NULL,
    RDF_PORCENTAJE          NUMBER(16,2),
    RDF_IMPORTE_A_PAGAR     NUMBER(16,2)        NOT NULL
);

CREATE TABLE H_RECOBRO_DETALLE_FACTURA_CO (    
	FECHA_HIST				TIMESTAMP(6) 	   	NOT NULL,
	H_RDF_ID                NUMBER(16)          NOT NULL,
    PFS_ID                  NUMBER(16)          NOT NULL,
    CPA_ID                  NUMBER(16)          NOT NULL,
    CNT_ID                  NUMBER(16)          NOT NULL,
    EXP_ID                  NUMBER(16)          NOT NULL,
	RCF_SCA_ID              NUMBER(16)          NOT NULL,
    RCF_AGE_ID              NUMBER(16)          NOT NULL,
	RDF_FECHA_COBRO         TIMESTAMP(6)	  	NOT NULL,    
	RDF_PORCENTAJE          NUMBER(16,2),
    RDF_IMPORTE_A_PAGAR     NUMBER(16,2)        NOT NULL
);


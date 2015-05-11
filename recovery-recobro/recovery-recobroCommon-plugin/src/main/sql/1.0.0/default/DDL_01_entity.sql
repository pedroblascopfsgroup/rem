-- AMPLIACION EXPEDIENTES DE RECOBRO

CREATE SEQUENCE S_DD_TPX_TIPO_EXPEDIENTE;

CREATE TABLE DD_TPX_TIPO_EXPEDIENTE (
   DD_TPX_ID                    NUMBER(16)                 NOT NULL,        
   DD_TPX_CODIGO                VARCHAR2(20 CHAR)          NOT NULL,
   DD_TPX_DESCRIPCION           VARCHAR2(100 CHAR),
   DD_TPX_DESCRIPCION_LARGA     VARCHAR2(250 CHAR),
   VERSION                      INTEGER DEFAULT 0          NOT NULL,
   USUARIOCREAR                 VARCHAR2(10 CHAR)          NOT NULL,
   FECHACREAR                   TIMESTAMP(6)               NOT NULL,
   USUARIOMODIFICAR             VARCHAR2(10 CHAR),
   FECHAMODIFICAR               TIMESTAMP(6),
   USUARIOBORRAR                VARCHAR2(10 CHAR),
   FECHABORRAR                  TIMESTAMP(6),
   BORRADO                      NUMBER(1)  DEFAULT 0       NOT NULL,
   CONSTRAINT PK_DD_TPX PRIMARY KEY (DD_TPX_ID),
   CONSTRAINT UK_DD_TPX_CODIGO UNIQUE (DD_TPX_CODIGO)
);

ALTER TABLE EXP_EXPEDIENTES ADD (
 DD_TPX_ID NUMBER(16)
);

ALTER TABLE EXP_EXPEDIENTES ADD CONSTRAINT
FK_EXP_TPX FOREIGN KEY (DD_TPX_ID) REFERENCES    DD_TPX_TIPO_EXPEDIENTE (DD_TPX_ID);


CREATE TABLE EXR_EXPEDIENTE_RECOBRO (
  EXP_ID     NUMBER(16)                             NOT NULL,  
  CONSTRAINT PK_EXP_REC PRIMARY KEY (EXP_ID),
  CONSTRAINT FK_EXP_REC FOREIGN KEY (EXP_ID) REFERENCES EXP_EXPEDIENTES (EXP_ID)
);

CREATE SEQUENCE S_CRE_CICLO_RECOBRO_EXP;

CREATE TABLE CRE_CICLO_RECOBRO_EXP (
  CRE_ID                    NUMBER(16)        NOT NULL, 
  EXP_ID                    NUMBER(16)        NOT NULL, 
  CRE_FECHA_ALTA            TIMESTAMP(6),
  CRE_FECHA_BAJA            TIMESTAMP(6),
  RCF_ESQ_ID                NUMBER(16),  
  RCF_ESC_ID                NUMBER(16),
  RCF_SCA_ID                NUMBER(16), 
  RCF_SUA_ID                NUMBER(16), 
  RCF_AGE_ID                NUMBER(16)      NOT NULL, 
  RCF_MFA_ID                NUMBER(16), 
  DD_TGC_ID                 NUMBER(16),
  DD_MOB_ID                 NUMBER(16), 
  CRE_POS_VIVA_NO_VENCIDA   NUMBER(16,2), 
  CRE_POS_VIVA_VENCIDA      NUMBER(16,2), 
  CRE_INT_ORDIN_DEVEN       NUMBER(16,2), 
  CRE_INT_MORAT_DEVEN       NUMBER(16,2), 
  CRE_COMISIONES            NUMBER(16,2), 
  CRE_GASTOS                NUMBER(16,2), 
  CRE_IMPUESTOS             NUMBER(16,2),
  CRE_MARCADO_BPM           NUMBER(1),
  CRE_MARCADO_BPM_FECHA     TIMESTAMP(6),
  CRE_PROCESS_BPM       NUMBER(16),
  VERSION                   INTEGER           DEFAULT 0 NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR                TIMESTAMP(6)                NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)         DEFAULT 0 NOT NULL,
  CONSTRAINT PK_CRE PRIMARY KEY (CRE_ID),
  CONSTRAINT FK_CRE_EXP FOREIGN KEY (EXP_ID) REFERENCES EXR_EXPEDIENTE_RECOBRO (EXP_ID),
  CONSTRAINT FK_CRE_ESQ FOREIGN KEY (RCF_ESQ_ID) REFERENCES RCF_ESQ_ESQUEMA (RCF_ESQ_ID),
  CONSTRAINT FK_CRE_SCA FOREIGN KEY (RCF_SCA_ID) REFERENCES RCF_SCA_SUBCARTERA (RCF_SCA_ID),
  CONSTRAINT FK_CRE_SUA FOREIGN KEY (RCF_SUA_ID) REFERENCES RCF_SUA_SUBCARTERA_AGENCIAS (RCF_SUA_ID),
  CONSTRAINT FK_CRE_AGE FOREIGN KEY (RCF_AGE_ID) REFERENCES RCF_AGE_AGENCIAS (RCF_AGE_ID),
  CONSTRAINT FK_CRE_MFA FOREIGN KEY (RCF_MFA_ID) REFERENCES RCF_MFA_MODELOS_FACTURACION (RCF_MFA_ID),
  CONSTRAINT FK_CRE_TGC FOREIGN KEY (DD_TGC_ID) REFERENCES RCF_DD_TGC_TIPO_GESTION_CART (DD_TGC_ID),
  CONSTRAINT FK_CRE_MOB FOREIGN KEY (DD_MOB_ID) REFERENCES BANKMASTER.DD_MOB_MOTIVOS_BAJA (DD_MOB_ID));
  
CREATE SEQUENCE S_CRC_CICLO_RECOBRO_CNT;

CREATE TABLE CRC_CICLO_RECOBRO_CNT (
  CRC_ID                    NUMBER(16)        NOT NULL,  
  CRC_ID_ENVIO              NUMBER(16),
  CNT_ID               NUMBER(16)        NOT NULL,  
  CRE_ID                    NUMBER (16)       NOT NULL, 
  DD_MOB_ID                 NUMBER(16),   
  EXC_ID                    NUMBER(16),
  CRC_FECHA_ALTA            TIMESTAMP(6),
  CRC_FECHA_BAJA            TIMESTAMP(6),
  CRC_POS_VIVA_NO_VENCIDA   NUMBER(16,2) DEFAULT 0,  
  CRC_POS_VIVA_VENCIDA      NUMBER(16,2) DEFAULT 0,  
  CRC_INT_ORDIN_DEVEN       NUMBER(16,2) DEFAULT 0,  
  CRC_INT_MORAT_DEVEN       NUMBER(16,2) DEFAULT 0,  
  CRC_COMISIONES            NUMBER(16,2) DEFAULT 0,  
  CRC_GASTOS                NUMBER(16,2) DEFAULT 0,  
  CRC_IMPUESTOS             NUMBER(16,2) DEFAULT 0,  
  VERSION                   INTEGER           DEFAULT 0 NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR                TIMESTAMP(6)                NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)         DEFAULT 0 NOT NULL,
  CONSTRAINT PK_CRC PRIMARY KEY (CRC_ID),
  CONSTRAINT FK_CRC_CNT FOREIGN KEY (CNT_ID) REFERENCES CNT_CONTRATOS (CNT_ID),
  CONSTRAINT FK_CRC_CDE FOREIGN KEY (CRE_ID) REFERENCES CRE_CICLO_RECOBRO_EXP (CRE_ID),
  CONSTRAINT FK_CRC_MOB FOREIGN KEY (DD_MOB_ID) REFERENCES BANKMASTER.DD_MOB_MOTIVOS_BAJA (DD_MOB_ID)
  /*CONSTRAINT FK_CRC_EXC FOREIGN KEY (EXC_ID) REFERENCES EXC_EXCEPTUACION (EXC_ID)*/);

CREATE SEQUENCE S_CRP_CICLO_RECOBRO_PER;

CREATE TABLE CRP_CICLO_RECOBRO_PER (
  CRP_ID                    NUMBER(16)        NOT NULL,  
  PER_ID                    NUMBER(16)        NOT NULL,  
  CRE_ID                    NUMBER (16)       NOT NULL, 
  DD_MOB_ID                 NUMBER(16),   
  EXC_ID                    NUMBER(16),
  CRP_FECHA_ALTA            TIMESTAMP(6),
  CRP_FECHA_BAJA            TIMESTAMP(6),
  CRP_RIESGO_DIRECTO        NUMBER(16,2),  
  CRP_RIESGO_INDIRECTO      NUMBER(16,2),  
  VERSION                   INTEGER           DEFAULT 0 NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR                TIMESTAMP(6)                NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)         DEFAULT 0 NOT NULL,
  CONSTRAINT PK_CRP PRIMARY KEY (CRP_ID),
  CONSTRAINT FK_CRP_PER FOREIGN KEY (PER_ID) REFERENCES PER_PERSONAS (PER_ID),
  CONSTRAINT FK_CRP_EPX FOREIGN KEY (CRE_ID) REFERENCES CRE_CICLO_RECOBRO_EXP (CRE_ID),
 CONSTRAINT FK_CRP_MOB FOREIGN KEY (DD_MOB_ID) REFERENCES BANKMASTER.DD_MOB_MOTIVOS_BAJA (DD_MOB_ID));


CREATE SEQUENCE S_CRT_CICLO_RECOBRO_TAREA_NOTI;

CREATE TABLE CRT_CICLO_RECOBRO_TAREA_NOTI (    
    CRT_ID                  NUMBER(16)          NOT NULL,
    CRE_ID                  NUMBER(16)          NOT NULL,
    TAR_ID                NUMBER(16)          NOT NULL,
    VERSION                 INTEGER    DEFAULT 0 NOT NULL,
    USUARIOCREAR            VARCHAR2(10 CHAR)    NOT NULL,
    FECHACREAR              TIMESTAMP(6)         NOT NULL,
    USUARIOMODIFICAR        VARCHAR2(10 CHAR),
    FECHAMODIFICAR          TIMESTAMP(6),
    USUARIOBORRAR           VARCHAR2(10 CHAR),
    FECHABORRAR             TIMESTAMP(6),
    BORRADO                 NUMBER(1)  DEFAULT 0  NOT NULL
);

CREATE UNIQUE INDEX PK_CRT_CICLO_RECOBRO_TAREA_NOT ON CRT_CICLO_RECOBRO_TAREA_NOTI (CRT_ID);

CREATE INDEX IX_CRT_CRE_ID ON CRT_CICLO_RECOBRO_TAREA_NOTI (CRE_ID);

CREATE INDEX IX_CRT_TAR_ID ON CRT_CICLO_RECOBRO_TAREA_NOTI (TAR_ID);

ALTER TABLE CRT_CICLO_RECOBRO_TAREA_NOTI ADD CONSTRAINT FK_CRT_FK_CRE_CRE_ID FOREIGN KEY (CRE_ID) 
 REFERENCES CRE_CICLO_RECOBRO_EXP (CRE_ID);
 
ALTER TABLE CRT_CICLO_RECOBRO_TAREA_NOTI ADD CONSTRAINT FK_CRT_FK_TAR_TAR_ID FOREIGN KEY (TAR_ID) 
 REFERENCES TAR_TAREAS_NOTIFICACIONES (TAR_ID); 

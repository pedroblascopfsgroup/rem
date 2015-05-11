-- tabla de documentos pendientes de generar
CREATE SEQUENCE S_MSV_GDP_GENERACION_DOCS_PTES;

CREATE TABLE  MSV_GDP_GENERACION_DOCS_PTES (
   GDP_ID                         NUMBER(16)            NOT NULL,
   ASU_ID                           NUMBER(16)            NOT NULL,
   PRC_ID                       NUMBER(16)            NOT NULL,
   GDP_NUMERO_CASO_NOVA            VARCHAR2(250 BYTE),
   BPM_DD_TIN_ID                NUMBER(16)            NOT NULL,
   DD_TPO_ID                    NUMBER(16)            NOT NULL,
   DD_EPF_ID                    NUMBER(16)            NOT NULL,
   GDP_PROCESO_TOKEN                     NUMBER(16)            NOT NULL,
   GDP_MAIL                        NUMBER(1),
   VERSION                      INTEGER         DEFAULT 0      NOT NULL,
   USUARIOCREAR                 VARCHAR2(10 BYTE)                   NOT NULL,
   FECHACREAR                   TIMESTAMP(6)                        NOT NULL,
   USUARIOMODIFICAR             VARCHAR2(10 BYTE),
   FECHAMODIFICAR               TIMESTAMP(6),
   USUARIOBORRAR                VARCHAR2(10 BYTE),
   FECHABORRAR                  TIMESTAMP(6),
   BORRADO                          NUMBER(1)       DEFAULT 0        NOT NULL,   
   CONSTRAINT PK_MSV_GDP_GEN_DOCS_PTES PRIMARY KEY (GDP_ID),
   CONSTRAINT FK_MSV_GDP_ASU_ID FOREIGN KEY (ASU_ID)REFERENCES ASU_ASUNTOS (ASU_ID),
   CONSTRAINT FK_MSV_GDP_PRC_ID FOREIGN KEY (PRC_ID)REFERENCES PRC_PROCEDIMIENTOS (PRC_ID),
   CONSTRAINT FK_MSV_BPM_DD_TIN_ID FOREIGN KEY (BPM_DD_TIN_ID) REFERENCES  BPM_DD_TIN_TIPO_INPUT (BPM_DD_TIN_ID),
   CONSTRAINT FK_MSV_DD_TPO_ID FOREIGN KEY (DD_TPO_ID)REFERENCES DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID),
   CONSTRAINT UK_MSV_GDP_PROCESO_TOKEN UNIQUE (GDP_PROCESO_TOKEN)
);  
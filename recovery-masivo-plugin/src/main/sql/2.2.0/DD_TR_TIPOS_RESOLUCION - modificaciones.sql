ALTER TABLE DD_TR_TIPOS_RESOLUCION ADD (BPM_DD_TAC_ID NUMBER(16));

ALTER TABLE DD_TR_TIPOS_RESOLUCION ADD 
CONSTRAINT FK_DD_TR_TIPOS_RESOLUCION_1
 FOREIGN KEY (BPM_DD_TAC_ID)
 REFERENCES BPM_DD_TAC_TIPO_ACCION (BPM_DD_TAC_ID)
 ENABLE
 VALIDATE
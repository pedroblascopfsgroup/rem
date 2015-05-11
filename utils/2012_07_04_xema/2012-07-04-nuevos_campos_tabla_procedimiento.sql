ALTER TABLE UGAS001.PRC_PROCEDIMIENTOS
MODIFY(DTYPE  DEFAULT 'MEJProcedimiento');

ALTER TABLE UGAS001.PRC_PROCEDIMIENTOS
 ADD (PRC_PARALIZADO  NUMBER(1)                     DEFAULT 0                     NOT NULL);
 
ALTER TABLE UGAS001.PRC_PROCEDIMIENTOS
 ADD (PRC_PLAZO_PARALIZ_MILS  NUMBER(16)); 

ALTER TABLE UGAS001.PRC_PROCEDIMIENTOS
 ADD (PRC_FECHA_PARALIZADO  TIMESTAMP(6));

ALTER TABLE UGAS001.PRC_PROCEDIMIENTOS
MODIFY(PRC_PARALIZADO  DEFAULT 0);

 

COMMIT; 

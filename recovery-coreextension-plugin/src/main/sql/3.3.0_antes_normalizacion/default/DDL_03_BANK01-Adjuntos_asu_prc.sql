ALTER TABLE BANK01.ADA_ADJUNTOS_ASUNTOS
 ADD (PRC_ID  NUMBER(16));

ALTER TABLE BANK01.ADA_ADJUNTOS_ASUNTOS
 ADD CONSTRAINT ADA_PRC_ID 
 FOREIGN KEY (PRC_ID) 
 REFERENCES BANK01.PRC_PROCEDIMIENTOS (PRC_ID);

ALTER TABLE BIE_LOCALIZACION ADD DD_PRV_ID NUMBER(16);

ALTER TABLE LIN001.BIE_LOCALIZACION ADD (
  CONSTRAINT FK_BIE_PRV_ID 
 FOREIGN KEY (DD_PRV_ID) 
 REFERENCES LINMASTER.DD_PRV_PROVINCIA (DD_PRV_ID));
ALTER TABLE RES_RESOLUCIONES_MASIVO
ADD RES_TAR_ID NUMBER(16);

ALTER TABLE RES_RESOLUCIONES_MASIVO ADD (
  CONSTRAINT FK_RES_TAR_ID
 FOREIGN KEY (RES_TAR_ID) 
 REFERENCES TAR_TAREAS_NOTIFICACIONES (TAR_ID));


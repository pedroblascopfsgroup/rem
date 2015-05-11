-- Ejecutar en la entidad.

ALTER TABLE DD_INFORMES
ADD (DD_DOCUMENTO_ADICIONAL NUMBER(1) DEFAULT 0);


-- Actualizamos los informes que adjuntan documentos adicionales. 

UPDATE dd_informes dd
   SET dd.dd_documento_adicional = 1
 WHERE dd.dd_informe_codigo IN ('DEMANDA_MONITORIO_CPROC', 'DEMANDA_MONITORIO_SPROC');
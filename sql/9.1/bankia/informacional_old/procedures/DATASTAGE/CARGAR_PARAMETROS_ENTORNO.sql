create or replace PROCEDURE CARGAR_PARAMETROS_ENTORNO (O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI Bankia
--
-- Descripción: Procedimiento almancenado que carga los parametros de entorno
-- ===============================================================================================
BEGIN

  declare
    nCount NUMBER;

  BEGIN
  
    insert into PARAMETROS_ENTORNO values ('ESQUEMA_DATASTAGE', 'RECOVERY_BANKIA_DATASTAGE');
    insert into PARAMETROS_ENTORNO values ('FORMATO_FECHA_DDMMYY', 'DD/MM/YY');
    insert into PARAMETROS_ENTORNO values ('ORIGEN_01', 'BANK01');
    insert into PARAMETROS_ENTORNO values ('ESQUEMA_DWH', 'RECOVERY_BANKIA_DWH');
    
    commit;

  End;
END;
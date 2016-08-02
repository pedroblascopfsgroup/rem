create or replace PROCEDURE CARGAR_PARAMETROS_ENTORNO (O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 14/04/2016
-- Motivos del cambio: Parametrización índices con esquema indices
-- Cliente: Recovery BI Producto
--
-- Descripción: Procedimiento almancenado que carga los parametros de entorno
-- ===============================================================================================
BEGIN

  declare
    nCount NUMBER;

  BEGIN
  
    insert into PARAMETROS_ENTORNO values ('ESQUEMA_DATASTAGE', 'RECOVERY_PRODUC_DATASTAGE');
    insert into PARAMETROS_ENTORNO values ('FORMATO_FECHA_DDMMYY', 'DD/MM/YY');
    insert into PARAMETROS_ENTORNO values ('ORIGEN_01', 'PRODUC01');
    insert into PARAMETROS_ENTORNO values ('ESQUEMA_DWH', 'RECOVERY_PRODUC_DWH');
    insert into PARAMETROS_ENTORNO values ('ESQUEMA_INDEX', 'IRECOVERYDWH8M');
    commit;

  End;
END;
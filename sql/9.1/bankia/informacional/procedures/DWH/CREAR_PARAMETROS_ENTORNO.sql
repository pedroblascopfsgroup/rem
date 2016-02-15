create or replace PROCEDURE CREAR_PARAMETROS_ENTORNO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego P�rez, PFS Group
-- Fecha creacion: Septiembre 2015
-- Responsable ultima modificacion: 
-- Fecha ultima modificacion: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que crea las tablas relacionadas con los parametros del entorno
-- ===============================================================================================


BEGIN
  declare
    V_NOMBRE VARCHAR2(50) := 'CREAR_PARAMETROS_ENTORNO';
    V_SQL varchar2(16000); 
    
  BEGIN

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''PARAMETROS_ENTORNO'', 
                      ''PARAMETRO VARCHAR2(100),
                        VALOR VARCHAR2(100)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
  End;
END;
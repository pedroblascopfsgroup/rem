create or replace PROCEDURE TRUNCAR_H_SUB (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Rafael Aracil, PFS Group
-- Fecha creación: Agosto 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 03/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Asunto.
-- ===============================================================================================

  V_NOMBRE VARCHAR2(50) := 'TRUNCAR_H_SUB';
  V_SQL VARCHAR2(16000);
  
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_SUB_ANIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_SUB_TRIMESTRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_SUB_MES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_SUB_SEMANA'', '''', :O_ERROR_STATUS); END;';  
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''H_SUB'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;


   commit;
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_H_SUB;
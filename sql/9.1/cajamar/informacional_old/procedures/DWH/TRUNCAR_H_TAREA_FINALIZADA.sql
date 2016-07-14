create or replace PROCEDURE TRUNCAR_H_TAREA_FINALIZADA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 03/02/2015
-- Motivos del cambio: LOG's
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almancenado que trunca las tablas deL hechoTarea Finalizada
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_H_TAREA_FINALIZADA';

BEGIN
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  
  execute immediate 'TRUNCATE TABLE H_TAR_FINALIZADA';

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_H_TAREA_FINALIZADA;
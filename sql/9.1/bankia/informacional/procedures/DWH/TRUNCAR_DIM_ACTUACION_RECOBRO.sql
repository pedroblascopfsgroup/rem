create or replace PROCEDURE TRUNCAR_DIM_ACTUACION_RECOBRO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 28/01/2015
-- Motivos del cambio: Adaptacion LOG's
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que trunca las tablas de la dimension Actuacion Recobro
-- ===============================================================================================
  
  V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_ACTUACION_RECOBRO';
  
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
 
  execute immediate 'TRUNCATE TABLE D_ACT_REC_MODELO';  
  execute immediate 'TRUNCATE TABLE D_ACT_REC_PROVEEDOR';
  execute immediate 'TRUNCATE TABLE D_ACT_REC_TIPO';
  execute immediate 'TRUNCATE TABLE D_ACT_REC_RESULTADO';  

  --Log_Proceso 
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

END TRUNCAR_DIM_ACTUACION_RECOBRO;
create or replace PROCEDURE  CARGA_FECHAS_MOV (O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Mayo 2015
-- Responsable ultima modificacion:Maria Villanueva, PFS Group
-- Fecha ultima modificacion: 16/11/2015
-- Motivos del cambio:Usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento para cargar las ultimas fechas de H_MOV y MOV
-- ===============================================================================================


  nCount NUMBER;
  
  V_DATASTAGE VARCHAR2(100);
  V_HAYA01 VARCHAR2(100);
  V_NOMBRE VARCHAR2(50) := 'FECHAS_MOV';
  V_SQL VARCHAR2(16000);

  max_dia_h date;
  max_dia_mov date;
  penult_dia_mov date;
  
BEGIN                

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Empieza ' || V_NOMBRE, 3; 
  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  select valor into V_HAYA01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';

   execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_HAYA01 || '.H_MOV_MOVIMIENTOS' into max_dia_h;  
   execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_DATASTAGE || '.MOV_MOVIMIENTOS' into max_dia_mov;  
   execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_DATASTAGE || '.MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) < to_date(''' || max_dia_mov || ''')' into penult_dia_mov;

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''FECHAS_MOV'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  insert into FECHAS_MOV (MAX_DIA_H, MAX_DIA_MOV, PENULT_DIA_MOV) select max_dia_h, MAX_DIA_MOV, PENULT_DIA_MOV from DUAL;
  commit;


  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Termina ' || V_NOMBRE, 3;  
  
END;

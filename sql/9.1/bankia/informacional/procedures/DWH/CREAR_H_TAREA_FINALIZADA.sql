create or replace PROCEDURE CREAR_H_TAREA_FINALIZADA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 04/02/2015
-- Motivos del cambio: LOG's
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que crea las tablas del Hecho Tarea Finalizada
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO TAREA_FINALIZADA
    -- H_TAR_FINALIZADA
BEGIN

  declare
  nCount NUMBER;
  v_sql LONG;
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_TAREA_FINALIZADA';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ H_TAR_FINALIZADA --------------------------
    select count(*) into nCount from user_tables where table_name = 'H_TAR_FINALIZADA';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE H_TAR_FINALIZADA(
                              FECHA_FIN_TAREA DATE NOT NULL,
                              FECHA_CARGA_DATOS DATE NOT NULL,                                    -- Fecha ?ltimo d?a cargado
                              TAREA_ID NUMBER(16,0) NOT NULL,
                              PROCEDIMIENTO_ID NUMBER(16,0) ,                                -- ID de la primera fase del procedimiento (PRC_PRC_ID = ). Identifica al procedimiento (Secuencia de actuaciones)
                              FASE_ACTUAL_PROCEDIMIENTO NUMBER(16,0) ,
                              ASUNTO_ID NUMBER(16,0) ,                                       -- Asunto al que pertenece el procedimiento
                              FECHA_CREACION_TAREA DATE ,
                              FECHA_VENC_ORIGINAL_TAREA DATE ,
                              FECHA_VENCIMIENTO_TAREA DATE ,
                              -- Dimensiones
                              RESPONSABLE_TAREA_ID NUMBER(16,0) ,
                              TIPO_PROCEDIMIENTO_DETALLE_ID NUMBER(16,0) ,
                              CARTERA_PROCEDIMIENTO_ID NUMBER(16,0)  ,
                              GESTOR_RECOVERY_PRC_ID NUMBER(16,0)  ,
                              -- M?tricas
                              NUM_TAREAS_FINALIZADAS INTEGER ,
                              DURACION_TAREA_FINALIZADA INTEGER ,
                              NUM_DIAS_VENCIDO INTEGER
                              )';

      execute immediate 'CREATE INDEX H_TAR_FINALIZADA_IX ON H_TAR_FINALIZADA (FECHA_FIN_TAREA, TAREA_ID)';
      execute immediate 'CREATE INDEX H_TAR_FINALIZADA_PRC_IX ON H_TAR_FINALIZADA (FECHA_FIN_TAREA, PROCEDIMIENTO_ID)';

    end if;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_TAREA_FINALIZADA;
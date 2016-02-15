create or replace PROCEDURE CREAR_H_ACTUACION_RECOBRO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Joaquín Sánchez, PFS Group
-- Fecha ultima modificacion: 10/08/2015
-- Motivos del cambio: Usuario Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripci?n: Procedimiento almancenado que crea las tablas del Hecho Actuacion Recobro
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- HECHO ACTUACION RECOBRO
    -- H_ACT_REC

begin
  declare
  nCount NUMBER;
  V_NOMBRE VARCHAR2(50) := 'CREAR_H_ACTUACION_RECOBRO';
  V_SQL varchar2(16000); 
  
  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

    ------------------------------ H_ACT_REC ------------------------------
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''H_ACT_REC'', 
                            ''DIA_ACTUACION_RECOBRO DATE NOT NULL,
                              ACTUACION_RECOBRO_ID NUMBER(16,0) NOT NULL,
                              CONTRATO_ID NUMBER(16,0),
                              PERSONA_ID NUMBER(16,0),
                              MODELO_ACT_REC_ID NUMBER(16,0),
                              PROVEEDOR_ACT_REC_ID NUMBER(16,0),
                              TIPO_ACT_REC_ID NUMBER(16,0),
                              RESULTADO_ACT_REC_ID NUMBER(16,0),
                              FECHA_PAGO_COMPROMETIDO DATE,
                              NUM_ACTUACIONES_RECOBRO INTEGER,
                              IMPORTE_COMPROMETIDO NUMBER(14,2),
                              IMPORTE_PROPUESTO NUMBER(14,2),
                              IMPORTE_ACEPTADO NUMBER(14,2),
                            IMPORTE_APROBADO NUMBER(14,2)'', 
                            :error); END;';
      execute immediate V_SQL USING OUT error;    
      
      
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_ACT_REC_IX'', ''H_ACT_REC (DIA_ACTUACION_RECOBRO, ACTUACION_RECOBRO_ID)'', ''S'', '''', :error); END;';
      execute immediate V_SQL USING OUT error;  
    

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_H_ACTUACION_RECOBRO;
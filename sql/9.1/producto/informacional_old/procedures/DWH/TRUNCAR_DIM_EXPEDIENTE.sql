create or replace PROCEDURE TRUNCAR_DIM_EXPEDIENTE (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable última modificación: María Villanueva, PFS Groupp
-- Fecha última modificación: 03/11/2015
-- Motivos del cambio:  Cambio a usuario porpietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que trunca las tablas de la dimensionExpediente
-- ===============================================================================================

  V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_EXPEDIENTE';
   V_SQL VARCHAR2(16000);
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ACTITUD'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_AMBITO_EXPEDIENTE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ARQUETIPO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_CAUSA_IMPAGO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_COMITE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_DECISION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ENTIDAD_INFORMACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ESTADO_EXPEDIENTE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ESTADO_ITINERARIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ITINERARIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_NIVEL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_OFICINA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_PROPUESTA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_PROVINCIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_SESION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_ITINERARIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ZONA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ESQUEMA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_CARTERA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_SUBCARTERA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_AGENCIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ENVIADO_AGENCIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_T_SALDO_TOTAL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_T_SALDO_IRREGULAR'', '''', :O_ERROR_STATUS); END;';
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_T_DEUDA_IRREGULAR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_T_DEUDA_IRREGULAR_ENV'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  
  /*
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_COBRO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_COBRO_FACTURADO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_REMESA_FACTURA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  */
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_SALIDA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_MOTIVO_SALIDA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_PALANCA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ESTADO_PALANCA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_SANCION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_INCIDENCIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ESTADO_INCIDENCIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_RESULTADO_GESTION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''_EXP_RESULTADO_GESTION_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_T_ROTACIONES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TD_ENTRADA_GESTION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TD_CREACION_EXP_COBRO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_GESTION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_GESTION_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_MOTIVO_BAJA_CR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ESQUEMA_CR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_CARTERA_CR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_SUBCARTERA_CR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_AGENCIA_CR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_ENVIADO_AGENCIA_CR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_GESTOR_COMITE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_FASE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_EXP_TIPO_EXPEDIENTE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
 
   
  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
END TRUNCAR_DIM_EXPEDIENTE;

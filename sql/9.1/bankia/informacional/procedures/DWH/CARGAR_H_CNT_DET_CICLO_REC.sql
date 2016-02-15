create or replace PROCEDURE CARGAR_H_CNT_DET_CICLO_REC (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Mayo 2015
-- Responsable ultima modificacion: Diego P�rez, PFS Group
-- Fecha ultima modificacion: 20/08/2015
-- Motivos del cambio: Usuario/Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_CNT_DET_CICLO_REC.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_CONTRATO';
  V_ROWCOUNT NUMBER;
  V_SQL VARCHAR2(16000);
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  nCount NUMBER;

  min_dia_semana date;
  max_dia_semana date;
  min_dia_mes date;
  max_dia_mes date;
  min_dia_trimestre date;
  max_dia_trimestre date;
  min_dia_anio date;
  max_dia_anio date;

  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_anterior date;

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA ORDER BY 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  INSERT_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

BEGIN

-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_CICLO_REC
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;
    exit when c_fecha%NOTFOUND;


  /*  20150219
    ---------------------- CARGA CICLO RECOBRO ----------------------
    -- Borrando indices TMP_CNT_DET_CICLO_REC
    select count(*) into nCount from USER_INDEXES where INDEX_NAME = 'TMP_CNT_DET_CICLO_REC_IX';
      if(nCount > 0) then execute immediate 'DROP INDEX TMP_CNT_DET_CICLO_REC_IX'; end if;

    execute immediate 'truncate table TMP_CNT_DET_CICLO_REC';
    */
  --   execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_CNT_DET_CICLO_REC
  /*      (DIA_ID,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC
        )
      select
        '''||fecha||''',
        CRC_FECHA_ALTA,
        CRC_FECHA_BAJA,
        '''||fecha||''',
        CNT_ID,
        DD_MOB_ID,
        1,
        CRC_POS_VIVA_VENCIDA,
        CRC_POS_VIVA_NO_VENCIDA,
        CRC_INT_ORDIN_DEVEN,
        CRC_INT_MORAT_DEVEN,
        CRC_COMISIONES,
        CRC_GASTOS,
        CRC_IMPUESTOS
    from '||V_DATASTAGE||'.CRC_CICLO_RECOBRO_CNT where trunc(CRC_FECHA_ALTA) <= '''||fecha||''' and BORRADO = 0';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices TMP_CNT_DET_CICLO_REC
    execute immediate 'CREATE INDEX TMP_CNT_DET_CICLO_REC_IX ON TMP_CNT_DET_CICLO_REC (DIA_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)';
    commit;

    -- Ciclo de recobro
    -- Fecha del contrato el dia entro en ciclo de recobro
    update TMP_CNT_DET_CICLO_REC tmp set ESQUEMA_CR_ID = (select ESQUEMA_CONTRATO_ID from H_CNT h where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID = tmp.FECHA_ALTA_CICLO_REC) where tmp.DIA_ID = fecha;
    update TMP_CNT_DET_CICLO_REC tmp set SUBCARTERA_CR_ID = (select SUBCARTERA_EXPEDIENTE_CNT_ID from H_CNT h where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID = tmp.FECHA_ALTA_CICLO_REC) where tmp.DIA_ID = fecha;
    update TMP_CNT_DET_CICLO_REC tmp set AGENCIA_CR_ID = (select AGENCIA_CONTRATO_ID from H_CNT h where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID = tmp.FECHA_ALTA_CICLO_REC) where tmp.DIA_ID = fecha;
    update TMP_CNT_DET_CICLO_REC tmp set SEGMENTO_CARTERA_CR_ID = (select SEGMENTO_CARTERA_ID from H_CNT h where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID = tmp.FECHA_ALTA_CICLO_REC) where tmp.DIA_ID = fecha;
    update TMP_CNT_DET_CICLO_REC tmp set ENVIADO_AGENCIA_CR_ID = (select ENVIADO_AGENCIA_CNT_ID from H_CNT h where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID = tmp.FECHA_ALTA_CICLO_REC) where tmp.DIA_ID = fecha;
*/

      ---------------------- CARGA CICLO RECOBRO ----------------------
      -- Borrando indices TMP_CNT_DET_CICLO_REC
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_DET_CICLO_REC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_DET_CICLO_REC'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_ENTSAL_D1_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_ENTSAL_D2_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_ENTSAL_D1'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_ENTSAL_D2'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;


      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Truncado de tabla y borrado de índices', 4;

      --Cálculo fecha
      select max(DIA_ID) into fecha_anterior from H_CNT where DIA_ID < fecha;

      --Inserción en TMP_ENTSAL_D1. Fecha - 1
      insert into TMP_ENTSAL_D1
        (
          DIA_ID,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select DIA_ID,
          CONTRATO_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          ESQUEMA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          AGENCIA_CONTRATO_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          1,
          POS_VIVA_VENC,
          POS_VIVA_NO_VENC,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          null,
          DEUDA_IRREGULAR
      from H_CNT
      where DIA_ID = fecha_anterior;

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_ENTSAL_D1. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


      --Inserción en TMP_ENTSAL_D2. Fecha
      insert into TMP_ENTSAL_D2
        (
          DIA_ID,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select DIA_ID,
          CONTRATO_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          ESQUEMA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          AGENCIA_CONTRATO_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          1,
          POS_VIVA_VENC,
          POS_VIVA_NO_VENC,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          null,
          DEUDA_IRREGULAR
      from H_CNT
      where DIA_ID = fecha;

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_ENTSAL_D2. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


      --Indices para TMP_ENTSAL_D1 y TMP_ENTSAL_D2
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ENTSAL_D1_IX'', ''TMP_ENTSAL_D1 (CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_ENTSAL_D2_IX'', ''TMP_ENTSAL_D2 (CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
       --ALTAS Caso 0 Contratos en D2 enviados a agencia y que no están en D1
      insert into TMP_CNT_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_CICLO_REC,
          FECHA_BAJA_CICLO_REC,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select
          DIA_ID,
          DIA_ID,
          null,
          DIA_ID,
          CONTRATO_ID,
          NULL AS MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
      from TMP_ENTSAL_D2 d2 where d2.ENVIADO_AGENCIA_CR_ID = 1 and d2.CONTRATO_ID not in (select d1.CONTRATO_ID from TMP_ENTSAL_D1 d1);

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Registros Insertados(1): ' || TO_CHAR(V_ROWCOUNT), 4;


      --BAJAS Caso 0 Contratos en D1 enviados a agencia y que no están en D2
      insert into TMP_CNT_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_CICLO_REC,
          FECHA_BAJA_CICLO_REC,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select
          fecha,
          null,
          fecha,
          fecha,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
      from TMP_ENTSAL_D1 d1 where d1.ENVIADO_AGENCIA_CR_ID = 1 and d1.CONTRATO_ID not in (select d2.CONTRATO_ID from TMP_ENTSAL_D2 d2);

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Registros Insertados(2): ' || TO_CHAR(V_ROWCOUNT), 4;


      --ALTAS Caso 1 Está en D1 y D2, pero en D1 no tiene agencia, pero en D2 sí
      insert into TMP_CNT_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_CICLO_REC,
          FECHA_BAJA_CICLO_REC,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select
          DIA_ID,
          DIA_ID,
          null,
          DIA_ID,
          CONTRATO_ID,
          NULL AS MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
      from TMP_ENTSAL_D2 d2 where d2.ENVIADO_AGENCIA_CR_ID = 1 and d2.CONTRATO_ID in (select d1.CONTRATO_ID from TMP_ENTSAL_D1 d1 where (d1.subcartera_cr_id=d2.subcartera_cr_id and d1.ENVIADO_AGENCIA_CR_ID = 0)
                                                                                                                                  or (d2.subcartera_cr_id is null and d1.ENVIADO_AGENCIA_CR_ID = 0));
      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Registros Insertados(3): ' || TO_CHAR(V_ROWCOUNT), 4;


      --BAJAS Caso 1
      insert into TMP_CNT_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_CICLO_REC,
          FECHA_BAJA_CICLO_REC,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select
          fecha,
          null,
          fecha,
          fecha,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
      from TMP_ENTSAL_D1 d1 where d1.ENVIADO_AGENCIA_CR_ID = 1 and d1.CONTRATO_ID in (select d2.CONTRATO_ID from TMP_ENTSAL_D2 d2 where d2.ENVIADO_AGENCIA_CR_ID = 0);

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Registros Insertados(4): ' || TO_CHAR(V_ROWCOUNT), 4;

      -- Eliminar no enviados a agencia
      --delete from TMP_ENTSAL_D1 where ENVIADO_AGENCIA_CR_ID = 0;
      --delete from TMP_ENTSAL_D2 where ENVIADO_AGENCIA_CR_ID = 0;
      --commit;


      --ALTAS Caso 2
      insert into TMP_CNT_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_CICLO_REC,
          FECHA_BAJA_CICLO_REC,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select
          d2.DIA_ID,
          d2.DIA_ID,
          null,
          d2.DIA_ID,
          d2.CONTRATO_ID,
          NULL AS MOTIVO_BAJA_CR_ID,
          d2.ESQUEMA_CR_ID,
          d2.SUBCARTERA_CR_ID,
          d2.AGENCIA_CR_ID,
          d2.SEGMENTO_CARTERA_CR_ID,
          d2.ENVIADO_AGENCIA_CR_ID,
          d2.NUM_CONTRATO_CICLO_REC,
          d2.POSICION_VENCIDA_CICLO_REC,
          d2.POSICION_NO_VENCIDA_CICLO_REC,
          d2.INT_ORDINARIOS_CICLO_REC,
          d2.INT_MORATORIOS_CICLO_REC,
          d2.COMISIONES_CICLO_REC,
          d2.GASTOS_CICLO_REC,
          d2.IMPUESTOS_CICLO_REC,
          d2.DEUDA_IRREGULAR_CICLO_REC
      from TMP_ENTSAL_D2 d2, TMP_ENTSAL_D1 d1
      where d1.CONTRATO_ID = d2.CONTRATO_ID
      and ((d1.SUBCARTERA_CR_ID <> d2.SUBCARTERA_CR_ID and d2.ENVIADO_AGENCIA_CR_ID =1)or(d1.SUBCARTERA_CR_ID is null and d2.SUBCARTERA_CR_ID is not null and d2.ENVIADO_AGENCIA_CR_ID =1));

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Registros Insertados(5): ' || TO_CHAR(V_ROWCOUNT), 4;


      --BAJAS Caso 2
      insert into TMP_CNT_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_CICLO_REC,
          FECHA_BAJA_CICLO_REC,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          MOTIVO_BAJA_CR_ID,
          ESQUEMA_CR_ID,
          SUBCARTERA_CR_ID,
          AGENCIA_CR_ID,
          SEGMENTO_CARTERA_CR_ID,
          ENVIADO_AGENCIA_CR_ID,
          NUM_CONTRATO_CICLO_REC,
          POSICION_VENCIDA_CICLO_REC,
          POSICION_NO_VENCIDA_CICLO_REC,
          INT_ORDINARIOS_CICLO_REC,
          INT_MORATORIOS_CICLO_REC,
          COMISIONES_CICLO_REC,
          GASTOS_CICLO_REC,
          IMPUESTOS_CICLO_REC,
          DEUDA_IRREGULAR_CICLO_REC
        )
      select
          fecha,
          null,
          fecha,
          fecha,
          d1.CONTRATO_ID,
          d1.MOTIVO_BAJA_CR_ID,
          d1.ESQUEMA_CR_ID,
          d1.SUBCARTERA_CR_ID,
          d1.AGENCIA_CR_ID,
          d1.SEGMENTO_CARTERA_CR_ID,
          d1.ENVIADO_AGENCIA_CR_ID,
          d1.NUM_CONTRATO_CICLO_REC,
          d1.POSICION_VENCIDA_CICLO_REC,
          d1.POSICION_NO_VENCIDA_CICLO_REC,
          d1.INT_ORDINARIOS_CICLO_REC,
          d1.INT_MORATORIOS_CICLO_REC,
          d1.COMISIONES_CICLO_REC,
          d1.GASTOS_CICLO_REC,
          d1.IMPUESTOS_CICLO_REC,
          d1.DEUDA_IRREGULAR_CICLO_REC
      from TMP_ENTSAL_D2 d2, TMP_ENTSAL_D1 d1
      where d1.CONTRATO_ID = d2.CONTRATO_ID
      and ((d1.SUBCARTERA_CR_ID <> d2.SUBCARTERA_CR_ID and d1.ENVIADO_AGENCIA_CR_ID=1 and d2.enviado_agencia_cr_id=1)or(d2.SUBCARTERA_CR_ID is not null and d1.SUBCARTERA_CR_ID is null and d1.ENVIADO_AGENCIA_CR_ID =1 and d2.ENVIADO_AGENCIA_CR_ID =1)or(d2.SUBCARTERA_CR_ID is null and d1.SUBCARTERA_CR_ID is not null and d1.ENVIADO_AGENCIA_CR_ID =1 and d2.ENVIADO_AGENCIA_CR_ID =1));

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_CICLO_REC. Registros Insertados(6): ' || TO_CHAR(V_ROWCOUNT), 4;


      -- Crear indices TMP_CNT_DET_CICLO_REC
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_DET_CICLO_REC_IX'', ''TMP_CNT_DET_CICLO_REC (DIA_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
    -- ROTACIONES:
      UPDATE TMP_CNT_DET_CICLO_REC Z
         SET IND_TIPO_CAMBIO = 3
      WHERE EXISTS(SELECT 1
                    FROM TMP_CNT_DET_CICLO_REC X
                    WHERE X.DIA_ID = Z.DIA_ID
                    AND X.CONTRATO_ID = Z.CONTRATO_ID
                    AND (X.FECHA_ALTA_CICLO_REC IS NOT NULL AND Z.FECHA_BAJA_CICLO_REC IS NOT NULL AND X.FECHA_ALTA_CICLO_REC = Z.FECHA_BAJA_CICLO_REC)
                    AND(X.AGENCIA_CR_ID IS NOT NULL AND Z.AGENCIA_CR_ID IS NOT NULL AND X.AGENCIA_CR_ID <> Z.AGENCIA_CR_ID)
                    );
      COMMIT;
      
      update  TMP_CNT_DET_CICLO_REC
        set IND_TIPO_CAMBIO = nvl(IND_TIPO_CAMBIO, 6)  where dia_id = fecha and FECHA_BAJA_CICLO_REC is not null;
      commit;

      merge into TMP_CNT_DET_CICLO_REC dc 
      using (select contrato_id, MOTIVO_SALIDA_EXP_CNT_ID from H_CNT where dia_id = fecha and motivo_salida_exp_cnt_id = 9) cf
      on (cf.contrato_id = dc.contrato_id)  
      when matched then update set dc.IND_TIPO_CAMBIO = 7 where dc.dia_id = fecha and dc.IND_TIPO_CAMBIO = 6 and dc.FECHA_BAJA_CICLO_REC is not null;
      commit;

      

    -- Borrando indices H_CNT_DET_CICLO_REC
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CICLO_REC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado del día a insertar
    delete from H_CNT_DET_CICLO_REC where DIA_ID = fecha;
    commit;

    insert into H_CNT_DET_CICLO_REC
        (DIA_ID,
        FECHA_ALTA_CICLO_REC,
        FECHA_BAJA_CICLO_REC,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        MOTIVO_BAJA_CR_ID,
        ESQUEMA_CR_ID,
        SUBCARTERA_CR_ID,
        AGENCIA_CR_ID,
        SEGMENTO_CARTERA_CR_ID,
        ENVIADO_AGENCIA_CR_ID,
        NUM_CONTRATO_CICLO_REC,
        POSICION_VENCIDA_CICLO_REC,
        POSICION_NO_VENCIDA_CICLO_REC,
        INT_ORDINARIOS_CICLO_REC,
        INT_MORATORIOS_CICLO_REC,
        COMISIONES_CICLO_REC,
        GASTOS_CICLO_REC,
        IMPUESTOS_CICLO_REC,
        DEUDA_IRREGULAR_CICLO_REC,
	IND_TIPO_CAMBIO
        )
      select
        DIA_ID,
        FECHA_ALTA_CICLO_REC,
        FECHA_BAJA_CICLO_REC,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        MOTIVO_BAJA_CR_ID,
        ESQUEMA_CR_ID,
        SUBCARTERA_CR_ID,
        AGENCIA_CR_ID,
        SEGMENTO_CARTERA_CR_ID,
        ENVIADO_AGENCIA_CR_ID,
        NUM_CONTRATO_CICLO_REC,
        POSICION_VENCIDA_CICLO_REC,
        POSICION_NO_VENCIDA_CICLO_REC,
        INT_ORDINARIOS_CICLO_REC,
        INT_MORATORIOS_CICLO_REC,
        COMISIONES_CICLO_REC,
        GASTOS_CICLO_REC,
        IMPUESTOS_CICLO_REC,
        DEUDA_IRREGULAR_CICLO_REC,
	IND_TIPO_CAMBIO
      from TMP_CNT_DET_CICLO_REC where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    end loop;
  close c_fecha;


  -- Crear indices H_CNT_DET_CICLO_REC
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_IX'', ''H_CNT_DET_CICLO_REC (DIA_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;


  -- -------------------------- C�?LCULO DEL RESTO DE PERIODOS ----------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_CNT_DET_CICLO_REC;
  commit;
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_CICLO_REC_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_SEMANA. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  select max(SEMANA_ID) into V_NUMBER from H_CNT_DET_CICLO_REC_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX)
    select max(SEMANA_ID) from H_CNT_DET_CICLO_REC_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
  commit;

  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;

  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;

  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  commit;

  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;
    exit when c_semana%NOTFOUND;

    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    select min(DIA_H) into min_dia_semana from TMP_FECHA where SEMANA_H = semana;

    -- Borrado indices H_CNT_DET_CICLO_REC_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CICLO_REC_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de las semanas a insertar
    delete from H_CNT_DET_CICLO_REC_SEMANA where SEMANA_ID = semana;
    commit;

    insert into H_CNT_DET_CICLO_REC_SEMANA
        (SEMANA_ID,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
        )
    select semana,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         max_dia_semana,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
    from H_CNT_DET_CICLO_REC
    where (FECHA_ALTA_CICLO_REC between min_dia_semana and max_dia_semana)
    or    (FECHA_BAJA_CICLO_REC between min_dia_semana and max_dia_semana);
    --from H_CNT_DET_CICLO_REC where DIA_ID = max_dia_semana;  20150219

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_CNT_DET_CICLO_REC_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_SEMANA_IX'', ''H_CNT_DET_CICLO_REC_SEMANA (SEMANA_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

  end loop C_SEMANAS_LOOP;
close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_SEMANA. Termina bucle', 3;

*/
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_CICLO_REC_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_MES. Empieza bucle', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_CNT_DET_CICLO_REC_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);

  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;

  merge into TMP_FECHA dc
  using (select MES_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.MES_H = cf.MES_ID;
  commit;

  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  commit;

  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;
    exit when c_mes%NOTFOUND;

      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
      select min(DIA_H) into min_dia_mes from TMP_FECHA where MES_H = mes;

    -- Borrado indices H_CNT_DET_CICLO_REC_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CICLO_REC_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de las semanas a insertar
    delete from H_CNT_DET_CICLO_REC_MES where MES_ID = mes;
    commit;

    insert into H_CNT_DET_CICLO_REC_MES
        (MES_ID,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
        )
    select mes,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         max_dia_mes,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
    from H_CNT_DET_CICLO_REC
    where (FECHA_ALTA_CICLO_REC between min_dia_mes and max_dia_mes)
    or    (FECHA_BAJA_CICLO_REC between min_dia_mes and max_dia_mes);
    --from H_CNT_DET_CICLO_REC where DIA_ID = max_dia_mes; 20150219

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_CICLO_REC_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_MES_IX'', ''H_CNT_DET_CICLO_REC_MES (MES_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  end loop C_MESES_LOOP;
  close c_mes;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_MES. Termina bucle', 3;


----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_CICLO_REC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_TRIMESTRE. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_CNT_DET_CICLO_REC_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  commit;

  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;

  merge into TMP_FECHA dc
  using (select TRIMESTRE_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.TRIMESTRE_H = cf.TRIMESTRE_ID;
  commit;

  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  commit;

  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;
    exit when c_trimestre%NOTFOUND;

      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
      select min(DIA_H) into min_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    -- Borrado indices H_CNT_DET_CICLO_REC_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CICLO_REC_TRI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de los trimestres a insertar
    delete from H_CNT_DET_CICLO_REC_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;

    insert into H_CNT_DET_CICLO_REC_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
        )
  select trimestre,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         max_dia_trimestre,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
    from H_CNT_DET_CICLO_REC
    where (FECHA_ALTA_CICLO_REC between min_dia_trimestre and max_dia_trimestre)
    or    (FECHA_BAJA_CICLO_REC between min_dia_trimestre and max_dia_trimestre);
    --from H_CNT_DET_CICLO_REC where DIA_ID = max_dia_trimestre; 20150219

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_CICLO_REC_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_TRI_IX'', ''H_CNT_DET_CICLO_REC_TRIMESTRE (TRIMESTRE_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_TRIMESTRE. Termina bucle', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_CICLO_REC_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_CNT_DET_CICLO_REC_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  commit;

  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;

  merge into TMP_FECHA dc
  using (select ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.ANIO_H = cf.ANIO_ID;

  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  commit;

  -- Bucle que recorre los años
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;
    exit when c_anio%NOTFOUND;

      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
      select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;


    -- Borrado indices H_CNT_DET_CICLO_REC_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CICLO_REC_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de los años a insertar
    delete from H_CNT_DET_CICLO_REC_ANIO where ANIO_ID = anio;
    commit;

    insert into H_CNT_DET_CICLO_REC_ANIO
        (ANIO_ID,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
        )
    select anio,
         FECHA_ALTA_CICLO_REC,
         FECHA_BAJA_CICLO_REC,
         max_dia_anio,
         CONTRATO_ID,
         MOTIVO_BAJA_CR_ID,
         ESQUEMA_CR_ID,
         SUBCARTERA_CR_ID,
         AGENCIA_CR_ID,
         SEGMENTO_CARTERA_CR_ID,
         ENVIADO_AGENCIA_CR_ID,
         NUM_CONTRATO_CICLO_REC,
         POSICION_VENCIDA_CICLO_REC,
         POSICION_NO_VENCIDA_CICLO_REC,
         INT_ORDINARIOS_CICLO_REC,
         INT_MORATORIOS_CICLO_REC,
         COMISIONES_CICLO_REC,
         GASTOS_CICLO_REC,
         IMPUESTOS_CICLO_REC,
         DEUDA_IRREGULAR_CICLO_REC,
	 IND_TIPO_CAMBIO
    from H_CNT_DET_CICLO_REC
    where (FECHA_ALTA_CICLO_REC between min_dia_anio and max_dia_anio)
    or    (FECHA_BAJA_CICLO_REC between min_dia_anio and max_dia_anio);
   -- from H_CNT_DET_CICLO_REC where DIA_ID = max_dia_anio; 20150219

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_CICLO_REC_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CICLO_REC_ANIO_IX'', ''H_CNT_DET_CICLO_REC_ANIO (ANIO_ID, FECHA_ALTA_CICLO_REC, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CICLO_REC_ANIO. Termina bucle', 3;
*/
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


  /*
EXCEPTION
  when OBJECTEXISTS then
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  when INSERT_NULL then
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;
  when PARAMETERS_NUMBER then
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;
  when OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;
    */
end;

end CARGAR_H_CNT_DET_CICLO_REC;
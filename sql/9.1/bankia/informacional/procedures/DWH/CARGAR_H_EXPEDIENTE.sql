create or replace PROCEDURE CARGAR_H_EXPEDIENTE (DATE_START in date, DATE_END in date, O_ERROR_STATUS OUT VARCHAR2) AS

-- ===============================================================================================
-- Autor: Fran Gutiérrez, PFS Group
-- Fecha creación: Julio 2014
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 13/08/2015
-- Motivos del cambio: Usuario/Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_EXP
-- ===============================================================================================

-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_EXPEDIENTE';
  V_ROWCOUNT NUMBER;

  V_NUM_ROW NUMBER(10);
  V_NUM_TABLE NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_BANK01 VARCHAR2(100);
  V_SQL VARCHAR2(16000);
  nCount NUMBER;
  V_NUMBER  NUMBER(16,0);

  formato_fecha VARCHAR2(100);

  max_dia_semana DATE;
  min_dia_semana DATE;
  max_dia_mes DATE;
  min_dia_mes DATE;
  max_dia_trimestre DATE;
  min_dia_trimestre DATE;
  max_dia_anio DATE;
  min_dia_anio DATE;

  max_dia_carga DATE;
  semana INT;
  mes INT;
  trimestre INT;
  anio INT;
  fecha DATE;
  fecha_anterior date;

  max_dia_h date;
  max_dia_mov date;
  penult_dia_mov date;
  max_dia_con_contratos date;
  max_dia_enviado_agencia date;

  l_last_row integer := 0;

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor C_FECHA_RELLENAR is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA order BY 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order BY 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order BY 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order BY 1;

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
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';
  select valor into V_BANK01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';

-- ----------------------------------------------------------------------------------------------
--                                      H_EXP
-- ----------------------------------------------------------------------------------------------
/*
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_BANK01 || '.H_MOV_MOVIMIENTOS' into max_dia_h;
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_DATASTAGE || '.MOV_MOVIMIENTOS' into max_dia_mov;
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_DATASTAGE || '.MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) < to_date(''' || max_dia_mov || ''')' into penult_dia_mov;
*/
  execute immediate 'select max_dia_h, max_dia_mov, penult_dia_mov from ' || V_DATASTAGE || '.FECHAS_MOV' into max_dia_h, max_dia_mov, penult_dia_mov;

-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop
    fetch c_fecha into fecha;
    exit when c_fecha%NOTFOUND;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    -- Borrado indices TMP_H_EXP
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_EXP_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_EXP_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Termina Borrado de Indices', 4;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_EXP'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate 'insert into TMP_H_EXP
        (DIA_ID,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_CREACION_EXPEDIENTE,
        FECHA_ROTURA_EXPEDIENTE,
        FECHA_ENTRADA_AGENCIA_EXP,
        FECHA_SALIDA_AGENCIA_EXP,
        ENVIADO_AGENCIA_EXP_ID,
        ESQUEMA_EXPEDIENTE_ID,
        AGENCIA_EXPEDIENTE_ID,
        SUBCARTERA_EXPEDIENTE_ID,
        MOTIVO_SALIDA_ID,
        RESULTADO_GESTION_EXP_ID,
        NUM_EXPEDIENTES
        )
    select
        ''' || fecha || ''',
        ''' || fecha || ''',
        exp.EXP_ID,
        exp.FECHACREAR,
        exp.FECHABORRAR,
        cre.CRE_FECHA_ALTA,
        cre.CRE_FECHA_BAJA,
        0,
        COALESCE(cre.RCF_ESQ_ID, -1),
        COALESCE(cre.RCF_AGE_ID, -1),
        COALESCE(cre.RCF_SCA_ID, -1),
        COALESCE(cre.DD_MOB_ID, -1),
        COALESCE(cre.DD_TGC_ID, -1),
        1
    from ' || V_DATASTAGE || '.EXP_EXPEDIENTES exp
    inner join ' || V_DATASTAGE || '.CRE_CICLO_RECOBRO_EXP cre on exp.EXP_ID = cre.EXP_ID
    where exp.BORRADO = 0 and cre.BORRADO = 0 and ''' || fecha || ''' >= trunc(exp.FECHACREAR) and (trunc(cre.CRE_FECHA_BAJA) >= ''' || fecha || ''' OR cre.CRE_FECHA_BAJA is null)';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices TMP_H_EXP
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_IX'', ''TMP_H_EXP (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_CNT_IX'', ''TMP_H_EXP (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Termina Creación de Indices', 4;

    -- Borrado indices TMP_H_EXP_DET_CNT
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_EXP_DET_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_EXP_DET_CNT_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP_DET_CNT. Termina Borrado de Indices', 4;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_EXP_DET_CNT'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate 'insert into TMP_H_EXP_DET_CNT
        (DIA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_EXPEDIENTE
        )
    select
         ''' || fecha || ''',
         ''' || fecha || ''',
         EXP_ID,
         CNT_ID,
         1
     from ' || V_DATASTAGE || '.CEX_CONTRATOS_EXPEDIENTE where ''' || fecha || ''' >= trunc(FECHACREAR) and BORRADO = 0';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP_DET_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices TMP_H_EXP_DET_CNT
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_DET_CNT_IX'', ''TMP_H_EXP_DET_CNT (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_DET_CNT_CNT_IX'', ''TMP_H_EXP_DET_CNT (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP_DET_CNT. Termina Creación de Indices', 4;

    -- Borrado indices TMP_EXP_CNT
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_CNT_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_CNT_CEX_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Borrado de Indices', 4;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_CNT'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- Fecha de analisis en H_MOV_MOVIMIENTOS (fecha menor que el ultimno día de H_MOV_MOVIMIENTOS o mayor que este, pero menor que el penúltimo dia de MOV_MOVIMIENTOS)
    if((fecha <= max_dia_h) or ((fecha > max_dia_h) and (fecha < penult_dia_mov))) then
      execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_BANK01 || '.H_MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) <= to_date(''' || fecha || ''')' into max_dia_con_contratos;

    execute immediate 'insert into TMP_EXP_CNT
            (EXPEDIENTE_ID,
             CONTRATO,
             CEX_ID,
             SALDO_VENCIDO,
             SALDO_NO_VENCIDO,
             DEUDA_IRREGULAR,
             SALDO_DUDOSO,
             SALDO_RECLAMAR,
             INT_REMUNERATORIOS,
             INT_MORATORIOS,
             COMISIONES,
             GASTOS
             )
    select cex.EXP_ID,
             mov.CNT_ID,
             cex.CEX_ID,
             mov.MOV_POS_VIVA_VENCIDA,
             mov.MOV_POS_VIVA_NO_VENCIDA,
             mov.MOV_DEUDA_IRREGULAR,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_INT_REMUNERATORIOS,
             mov.MOV_INT_MORATORIOS,
             mov.MOV_COMISIONES,
             mov.MOV_GASTOS
        from ' || V_DATASTAGE || '.CEX_CONTRATOS_EXPEDIENTE cex
        join ' || V_BANK01 || '.H_MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
        where mov.MOV_FECHA_EXTRACCION = ''' || max_dia_con_contratos || '''';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Registros Insertados (1): ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Fecha de análisis en MOV_MOVIMIENTOS - Penúltimo o último día
    elsif(fecha = penult_dia_mov or fecha = max_dia_mov) then
    execute immediate 'insert into TMP_EXP_CNT
            (EXPEDIENTE_ID,
             CONTRATO,
             CEX_ID,
             SALDO_VENCIDO,
             SALDO_NO_VENCIDO,
             DEUDA_IRREGULAR,
             SALDO_DUDOSO,
             SALDO_RECLAMAR,
             INT_REMUNERATORIOS,
             INT_MORATORIOS,
             COMISIONES,
             GASTOS
             )
    select cex.EXP_ID,
             mov.CNT_ID,
             cex.CEX_ID,
             mov.MOV_POS_VIVA_VENCIDA,
             mov.MOV_POS_VIVA_NO_VENCIDA,
             mov.MOV_DEUDA_IRREGULAR,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_INT_REMUNERATORIOS,
             mov.MOV_INT_MORATORIOS,
             mov.MOV_COMISIONES,
             mov.MOV_GASTOS
        from ' || V_DATASTAGE || '.CEX_CONTRATOS_EXPEDIENTE cex
        join ' || V_DATASTAGE || '.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
        where mov.MOV_FECHA_EXTRACCION = ''' || fecha || '''';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Registros Insertados (2): ' || TO_CHAR(V_ROWCOUNT), 4;

    end if;

    -- Crear indices TMP_EXP_CNT
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_IX'', ''TMP_EXP_CNT (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_CNT_IX'', ''TMP_EXP_CNT (CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_CEX_IX'', ''TMP_EXP_CNT (CEX_ID, CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Creación de Indices', 4;


    -- Borrado indices TMP_EXP_ACCIONES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_ACCIONES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_ACCIONES. Termina Borrado de Indices', 4;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_ACCIONES'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate 'insert into TMP_EXP_ACCIONES
            (CONTRATO,
             FECHA_ACTUACION,
             FECHA_COMPROMETIDA_PAGO,
             IMPORTE_COMPROMETIDO,
             TIPO_GESTION,
             RESULTADO_ACTUACION
             )
    select SUBSTR(ACE_ENVIO_ID, 9, LENGTH(ACE_ENVIO_ID)),
           ACE_FECHA_GESTION,
           ACE_FECHA_PAGO_COMPROMETIDO,
           ACE_IMPORTE_COMPROMETIDO,
           DD_TGE_ID,
           DD_RGT_ID
      from ' || V_DATASTAGE || '.ACE_ACCIONES_EXTRAJUDICIALES
      where ACE_FECHA_GESTION <= ''' || fecha || '''';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_ACCIONES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices TMP_EXP_ACCIONES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_ACCIONES_IX'', ''TMP_EXP_ACCIONES (CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_ACCIONES. Termina Creación de Indices', 4;

   /*COBROS
    execute immediate 'truncate table TMP_EXP_COBROS';

    -- Borrado indices TMP_EXP_COBROS_IX
  	select count(*) into nCount from USER_INDEXES where INDEX_NAME = 'TMP_EXP_COBROS_IX';
    if(nCount > 0) then execute immediate 'DROP INDEX TMP_EXP_COBROS_IX'; end if;

    execute immediate 'insert into TMP_EXP_COBROS
                            (EXPEDIENTE_ID,
                             FECHA_ULTIMO_COBRO)
                       select EXPEDIENTE_ID,
                              max(FECHA_COBRO)
                       from H_EXP_DET_COBRO where DIA_ID = ''' || fecha || ''' GROUP BY EXPEDIENTE_ID';
    commit;

    -- Crear indices TMP_EXP_COBROS
    execute immediate 'CREATE INDEX TMP_EXP_COBROS_IX on TMP_EXP_COBROS (EXPEDIENTE_ID)';
*/

    -- ----------------------------- updates -------------------------------
    execute immediate 'update TMP_H_EXP set NUM_DIAS_CREACION_A_ROTURA = NVL(FECHA_CREACION_EXPEDIENTE - FECHA_ROTURA_EXPEDIENTE, 0) where DIA_ID = ''' || fecha || '''';
    execute immediate 'update TMP_H_EXP set NUM_DIAS_CREACION = NVL(FECHA_CREACION_EXPEDIENTE - to_date(''' || fecha || ''',''dd/MM/YY'') , 0) where DIA_ID = ''' || fecha || '''';
    execute immediate 'select max(TRUNC(FECHA_HIST)) from ' || V_DATASTAGE || '.H_REC_FICHERO_CONTRATOS where TRUNC(FECHA_HIST) <= to_date(''' || fecha || ''')' into max_dia_enviado_agencia;
    execute immediate 'merge into TMP_H_EXP hc
          using (select distinct ID_EXPEDIENTE from '||V_DATASTAGE||'.H_REC_FICHERO_CONTRATOS where to_char(TRUNC(FECHA_HIST), '''||formato_fecha||''') = '''||max_dia_enviado_agencia||''') crc
          on (crc.ID_EXPEDIENTE = hc.EXPEDIENTE_ID)
          when matched then update set hc.ENVIADO_AGENCIA_EXP_ID = 1 where hc.DIA_ID = '''||fecha||'''';
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Termina Updates(1)', 4;


    -- ---------------------------------- Updates asociados a los contratos del expediente ----------------------------------

    -- Contrato enviado a agencia
    execute immediate 'merge into TMP_EXP_CNT hc
          using (select distinct SUBSTR(hrec.ID_ENVIO, 9, LENGTH(ID_ENVIO)) as CONTRATO from '||V_DATASTAGE||'.H_REC_FICHERO_CONTRATOS hrec where to_char(TRUNC(FECHA_HIST), '''||formato_fecha||''') = '''||max_dia_enviado_agencia||''') crc
          on (crc.CONTRATO = hc.CONTRATO)
          when matched then update set hc.ENVIADO_AGENCIA = 1';
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Updates(1)', 4;

    merge into TMP_H_EXP a
    using (select EXPEDIENTE_ID,
              sum(SALDO_VENCIDO) as SALDO_VENCIDO,
              sum(SALDO_NO_VENCIDO) as SALDO_NO_VENCIDO,
              sum(SALDO_DUDOSO) as SALDO_DUDOSO,
              sum(SALDO_RECLAMAR) as SALDO_RECLAMAR,
              sum(INT_REMUNERATORIOS) as INT_REMUNERATORIOS,
              sum(INT_MORATORIOS) as INT_MORATORIOS,
              sum(COMISIONES) as COMISIONES,
              sum(GASTOS) as GASTOS,
              sum(DEUDA_IRREGULAR) as DEUDA_IRREGULAR
            from TMP_EXP_CNT group by EXPEDIENTE_ID) b
    on (b.EXPEDIENTE_ID = a.EXPEDIENTE_ID)
    when matched then update
        set a.SALDO_VENCIDO = b.SALDO_VENCIDO,
            a.SALDO_NO_VENCIDO = b.SALDO_NO_VENCIDO,
            a.SALDO_DUDOSO = b.SALDO_DUDOSO,
            a.SALDO_A_RECLAMAR = b.SALDO_RECLAMAR,
            a.INTERESES_REMUNERATORIOS = b.INT_REMUNERATORIOS,
            a.INTERESES_MORATORIOS = b.INT_MORATORIOS,
            a.COMISIONES = b.COMISIONES,
            a.GASTOS = b.GASTOS,
            a.SALDO_TOTAL = b.SALDO_VENCIDO + b.SALDO_NO_VENCIDO,
            a.DEUDA_IRREGULAR = b.DEUDA_IRREGULAR,
            a.RIESGO_VIVO = b.SALDO_NO_VENCIDO + b.DEUDA_IRREGULAR
        where a.DIA_ID = fecha;
    commit;

    merge into TMP_H_EXP a
    using (select EXPEDIENTE_ID,
              sum(SALDO_NO_VENCIDO) as SALDO_NO_VENCIDO,
              sum(DEUDA_IRREGULAR) as DEUDA_IRREGULAR
            from TMP_EXP_CNT where ENVIADO_AGENCIA = 1 group by EXPEDIENTE_ID) b
    on (b.EXPEDIENTE_ID = a.EXPEDIENTE_ID)
    when matched then update
        set a.SALDO_NO_VENCIDO_ENV_AGENCIA = b.SALDO_NO_VENCIDO,
            a.DEUDA_IRREGULAR_ENV_AGENCIA = b.DEUDA_IRREGULAR,
            a.RIESGO_VIVO_ENV_AGENCIA = b.SALDO_NO_VENCIDO + b.DEUDA_IRREGULAR
        where a.DIA_ID = fecha;
    commit;


    execute immediate 'update TMP_H_EXP set T_SALDO_TOTAL_EXP_ID = (case when SALDO_TOTAL <= 30000 then 0
                                                                         when SALDO_TOTAL > 30000 and SALDO_TOTAL <= 60000 then 1
                                                                         when SALDO_TOTAL > 60000 and SALDO_TOTAL <= 90000 then 2
                                                                         when SALDO_TOTAL > 90000 and SALDO_TOTAL <= 300000 then 3
                                                                         when SALDO_TOTAL > 300000 then 4
                                                                         else -1 end) where DIA_ID = ''' || fecha || '''';

    execute immediate 'update TMP_H_EXP set T_SALDO_IRREGULAR_EXP_ID = (case when SALDO_VENCIDO <= 30000 then 0
                                                                             when SALDO_VENCIDO > 30000 and SALDO_VENCIDO <= 60000 then 1
                                                                             when SALDO_VENCIDO > 60000 and SALDO_VENCIDO <= 90000 then 2
                                                                             when SALDO_VENCIDO > 90000 and SALDO_VENCIDO <= 300000 then 3
                                                                             when SALDO_VENCIDO > 300000 then 4
                                                                             else -1 end) where DIA_ID = ''' || fecha || '''';

    execute immediate 'update TMP_H_EXP set T_DEUDA_IRREGULAR_EXP_ID = (case when DEUDA_IRREGULAR >= 0 and DEUDA_IRREGULAR <= 25000 then 0
                                                                             when DEUDA_IRREGULAR > 25000 and DEUDA_IRREGULAR <= 50000 then 1
                                                                             when DEUDA_IRREGULAR > 50000 and DEUDA_IRREGULAR <= 75000 then 2
                                                                             when DEUDA_IRREGULAR > 75000 then 3
                                                                             else -1 end) where DIA_ID = ''' || fecha || '''';

    execute immediate 'update TMP_H_EXP set T_DEUDA_IRREGULAR_ENV_EXP_ID = (case when DEUDA_IRREGULAR_ENV_AGENCIA >= 0 and DEUDA_IRREGULAR_ENV_AGENCIA <= 25000 then 0
                                                                                 when DEUDA_IRREGULAR_ENV_AGENCIA > 25000 and DEUDA_IRREGULAR_ENV_AGENCIA <= 50000 then 1
                                                                                 when DEUDA_IRREGULAR_ENV_AGENCIA > 50000 and DEUDA_IRREGULAR_ENV_AGENCIA <= 75000 then 2
                                                                                 when DEUDA_IRREGULAR_ENV_AGENCIA > 75000 then 3
                                                                                 else -1 end) where DIA_ID = ''' || fecha || '''';
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Termina Updates(2)', 4;


    -- Asignación de prioridades: 1 NO CORRESPONDE CON EL DEUDOR - 9 PROMESA PAGO TOTAL
    update TMP_EXP_ACCIONES set PRIORIDAD_ACTUACION = (case when RESULTADO_ACTUACION = 7 then 1
                                                            when RESULTADO_ACTUACION = 6 then 2
                                                            when RESULTADO_ACTUACION = 3 then 3
                                                            when RESULTADO_ACTUACION = 2 then 4
                                                            when RESULTADO_ACTUACION = 4 then 5
                                                            when RESULTADO_ACTUACION = 5 then 6
                                                            when RESULTADO_ACTUACION = 1 then 7
                                                            when RESULTADO_ACTUACION = 8 then 8
                                                            when RESULTADO_ACTUACION = 9 then 9
                                                            else -1 end);
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_ACCIONES. Termina Updates(1)', 4;

    merge into TMP_EXP_CNT a
    using (select CONTRATO,
              max(FECHA_COMPROMETIDA_PAGO) as FECHA_COMPROMETIDA_PAGO,
              max(PRIORIDAD_ACTUACION) as PRIORIDAD_ACTUACION
            from TMP_EXP_ACCIONES group by CONTRATO) b
    on (b.CONTRATO = a.CONTRATO)
    when matched then update
        set a.FECHA_COMPROMETIDA_PAGO = b.FECHA_COMPROMETIDA_PAGO,
            a.MAX_PRIORIDAD_ACTUACION = b.PRIORIDAD_ACTUACION;
    commit;

    merge into TMP_EXP_CNT a
    using (select CONTRATO,
              FECHA_COMPROMETIDA_PAGO,
              max(IMPORTE_COMPROMETIDO) as IMPORTE_COMPROMETIDO
            from TMP_EXP_ACCIONES group by CONTRATO, FECHA_COMPROMETIDA_PAGO) b
    on (b.CONTRATO = a.CONTRATO and b.FECHA_COMPROMETIDA_PAGO = a.FECHA_COMPROMETIDA_PAGO)
    when matched then update
        set a.IMPORTE_COMPROMETIDO = b.IMPORTE_COMPROMETIDO;
    commit;

    merge into TMP_EXP_CNT a
    using (select CONTRATO,
              PRIORIDAD_ACTUACION,
              max(FECHA_ACTUACION) as FECHA_ACTUACION,
              max(TIPO_GESTION) as TIPO_GESTION,
              max(RESULTADO_ACTUACION) as RESULTADO_ACTUACION
            from TMP_EXP_ACCIONES group by CONTRATO, PRIORIDAD_ACTUACION) b
    on (b.CONTRATO = a.CONTRATO and b.PRIORIDAD_ACTUACION = a.MAX_PRIORIDAD_ACTUACION)
    when matched then update
        set a.FECHA_ACTUACION = b.FECHA_ACTUACION,
            a.TIPO_GESTION = b.TIPO_GESTION,
            a.RESULTADO_ACTUACION = b.RESULTADO_ACTUACION;
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Updates(2)', 4;

    merge into TMP_H_EXP_DET_CNT a
    using (select CONTRATO,
              max(FECHA_ACTUACION) as FECHA_ACTUACION,
              max(FECHA_COMPROMETIDA_PAGO) as FECHA_COMPROMETIDA_PAGO,
              max(IMPORTE_COMPROMETIDO) as IMPORTE_COMPROMETIDO,
              max(RESULTADO_ACTUACION) as RESULTADO_ACTUACION,
              max(TIPO_GESTION) as TIPO_GESTION
            from TMP_EXP_CNT group by CONTRATO) b
    on (b.CONTRATO = a.CONTRATO_ID)
    when matched then update
        set a.FECHA_GESTION = b.FECHA_ACTUACION,
            a.FECHA_COMPROMETIDA_PAGO = b.FECHA_COMPROMETIDA_PAGO,
            a.IMPORTE_COMPROMETIDO = b.IMPORTE_COMPROMETIDO,
            a.RESULTADO_GESTION_EXP_CNT_ID = b.RESULTADO_ACTUACION,
            a.TIPO_GESTION_EXP_CNT_ID = b.TIPO_GESTION
        where DIA_ID = fecha;
    commit;

    execute immediate 'update TMP_H_EXP_DET_CNT det set RESULTADO_GESTION_EXP_CNT_ID = -2 where DIA_ID = ''' || fecha || ''' and RESULTADO_GESTION_EXP_CNT_ID is null';
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP_DET_CNT. Termina Updates(1)', 4;

    merge into TMP_H_EXP a
    using (select EXPEDIENTE_ID,
              max(RESULTADO_ACTUACION) as RESULTADO_ACTUACION,
              max(IMPORTE_COMPROMETIDO) as IMPORTE_COMPROMETIDO,
              max(TIPO_GESTION) as TIPO_GESTION,
              max(FECHA_ACTUACION) as FECHA_ACTUACION
            from TMP_EXP_CNT group by EXPEDIENTE_ID) b
    on (b.EXPEDIENTE_ID = a.EXPEDIENTE_ID)
    when matched then update
        set a.RESULTADO_GESTION_EXP_ID = b.RESULTADO_ACTUACION,
            a.IMPORTE_COMPROMETIDO = b.IMPORTE_COMPROMETIDO,
            a.TIPO_GESTION_EXP_ID = b.TIPO_GESTION,
            a.FECHA_MEJOR_GESTION = b.FECHA_ACTUACION
        where DIA_ID = fecha;
    commit;

    execute immediate 'update TMP_H_EXP det set RESULTADO_GESTION_EXP_ID = -2 where DIA_ID = ''' || fecha || ''' and RESULTADO_GESTION_EXP_ID is null';
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Termina Updates(3)', 4;


    /*
    -- ---------------------------------- COBROS ----------------------------------
    execute immediate 'update H_EXP set FECHA_ULTIMO_COBRO = (select tmp.FECHA_ULTIMO_COBRO from TMP_EXP_COBROS tmp where H_EXP.EXPEDIENTE_ID = tmp.EXPEDIENTE_ID and H_EXP.DIA_ID = ''' || fecha || ''')';
    execute immediate 'update H_EXP set NUM_DIAS_CREACION_EXP_COBRO = NVL(FECHA_CREACION_EXPEDIENTE - FECHA_ULTIMO_COBRO, 0) where DIA_ID = ''' || fecha || '''';
    execute immediate 'update H_EXP set TD_CREACION_EXP_COBRO_ID = (case when NUM_DIAS_CREACION_EXP_COBRO <= 15 then 0
                                                                         when NUM_DIAS_CREACION_EXP_COBRO > 15 and NUM_DIAS_CREACION_EXP_COBRO <= 30 then 1
                                                                         when NUM_DIAS_CREACION_EXP_COBRO > 30 and NUM_DIAS_CREACION_EXP_COBRO <= 60 then 2
                                                                         when NUM_DIAS_CREACION_EXP_COBRO > 60 and NUM_DIAS_CREACION_EXP_COBRO <= 90 then 3
                                                                         when NUM_DIAS_CREACION_EXP_COBRO > 90 and NUM_DIAS_CREACION_EXP_COBRO <= 120 then 4
                                                                         when NUM_DIAS_CREACION_EXP_COBRO > 120 then 5
                                                                         else -1 end) where DIA_ID = ''' || fecha || '''';
    */



    -- Borrado del día a insertar
    delete from H_EXP where DIA_ID = fecha;
    commit;

    -- Borrado indices H_EXP
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_EXP_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Termina Borrado Indices', 4;


    insert into H_EXP
        ( DIA_ID,
          FECHA_CARGA_DATOS,
          EXPEDIENTE_ID,
          FECHA_CREACION_EXPEDIENTE,
          FECHA_ROTURA_EXPEDIENTE,
          FECHA_ENTRADA_AGENCIA_EXP,
          FECHA_SALIDA_AGENCIA_EXP,
          FECHA_OFRECIMIENTO_PROPUESTA,
          FECHA_FORMALIZACION_PROPUESTA,
          FECHA_SANCION_PROPUESTA,
          FECHA_ACTIVACION_INCIDENCIA,
          FECHA_RESOLUCION_INCIDENCIA,
          FECHA_ELEVACION_COMITE,
          FECHA_ULTIMO_COBRO,
          FECHA_MEJOR_GESTION,
          ENVIADO_AGENCIA_EXP_ID,
          ESQUEMA_EXPEDIENTE_ID,
          AGENCIA_EXPEDIENTE_ID,
          SUBCARTERA_EXPEDIENTE_ID,
          TIPO_SALIDA_ID,
          MOTIVO_SALIDA_ID,
          TIPO_PALANCA_ID,
          ESTADO_PALANCA_ID,
          TIPO_SANCION_ID,
          TIPO_INCIDENCIA_ID,
          ESTADO_INCIDENCIA_ID,
          TIPO_GESTION_EXP_ID,
          RESULTADO_GESTION_EXP_ID,
          T_SALDO_TOTAL_EXP_ID,
          T_SALDO_IRREGULAR_EXP_ID,
          T_DEUDA_IRREGULAR_EXP_ID,
          T_DEUDA_IRREGULAR_ENV_EXP_ID,
          T_ROTACIONES_EXP_ID,
          TD_ENTRADA_GEST_EXP_ID,
          TD_CREACION_EXP_COBRO_ID,
          NUM_EXPEDIENTES,
          NUM_CONTRATOS,
          NUM_COBROS,
          NUM_ROTACIONES,
          NUM_DIAS_CREACION_A_ROTURA,
          NUM_DIAS_CREACION,
          NUM_DIAS_SANCION_FORMALIZACION,
          NUM_DIAS_ACTIVACION_RESOLUCION,
          NUM_DIAS_OFREC_PROPUESTA,
          NUM_DIAS_COMITE_SANCION,
          NUM_DIAS_CREACION_EXP_COBRO,
          SALDO_VENCIDO,
          SALDO_NO_VENCIDO,
          SALDO_NO_VENCIDO_ENV_AGENCIA,
          SALDO_TOTAL,
          RIESGO_VIVO,
          RIESGO_VIVO_ENV_AGENCIA,
          DEUDA_IRREGULAR,
          DEUDA_IRREGULAR_ENV_AGENCIA,
          SALDO_DUDOSO,
          SALDO_A_RECLAMAR,
          IMPORTE_COBROS,
          INTERESES_REMUNERATORIOS,
          INTERESES_MORATORIOS,
          COMISIONES,
          GASTOS,
          IMPORTE_COMPROMETIDO
        )
    select * from TMP_H_EXP where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    delete from H_EXP_DET_CNT where DIA_ID = fecha;
    commit;

    -- Borrado indices H_EXP_DET_CNT
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT. Termina Borrado Indices', 4;


    insert into H_EXP_DET_CNT
      ( DIA_ID,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        CONTRATO_ID,
        FECHA_GESTION,
        TIPO_GESTION_EXP_CNT_ID,
        RESULTADO_GESTION_EXP_CNT_ID,
        FECHA_COMPROMETIDA_PAGO,
        NUM_CONTRATOS_EXPEDIENTE,
        IMPORTE_COMPROMETIDO
      )
    select * from TMP_H_EXP_DET_CNT where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

/*COBROS
    -- Borrado indices H_EXP_DET_COBRO
    select count(*) into nCount from USER_INDEXES where INDEX_NAME = 'H_EXP_DET_COBRO_IX';
    if(nCount > 0) then execute immediate 'ALTER INDEX H_EXP_DET_COBRO_IX UNUSABLE'; end if;
    commit;

  select count(*) into nCount from USER_INDEXES where INDEX_NAME = 'H_EXP_DET_COBRO_IX';
    if(nCount > 0) then execute immediate 'DROP INDEX H_EXP_DET_COBRO_IX'; end if;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_COBRO. Termina Borrado Indices', 4;
*/

      ---------------------- CARGA CICLO RECOBRO ----------------------
      -- Borrando indices TMP_EXP_DET_CICLO_REC
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_DET_CICLO_REC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_DET_CICLO_REC'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_ENTSAL_D1_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_ENTSAL_D2_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_ENTSAL_D1'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_ENTSAL_D2'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_DET_CICLO_REC. Truncado de tabla y borrado de índices', 4;

      --Cálculo fecha
      select max(DIA_ID) into fecha_anterior from H_EXP where DIA_ID < fecha;

      --Inserción en TMP_EXP_ENTSAL_D1. Fecha - 1
      insert into TMP_EXP_ENTSAL_D1
        (
          DIA_ID,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select DIA_ID,
          EXPEDIENTE_ID,
          null,
          ESQUEMA_EXPEDIENTE_ID,
          SUBCARTERA_EXPEDIENTE_ID,
          AGENCIA_EXPEDIENTE_ID,
          ENVIADO_AGENCIA_EXP_ID,
          1,
          SALDO_VENCIDO,
          SALDO_NO_VENCIDO,
          SALDO_TOTAL,
          RIESGO_VIVO,
          DEUDA_IRREGULAR
          from H_EXP
          where DIA_ID = fecha_anterior;

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_ENTSAL_D1. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


      --Inserción en TMP_EXP_ENTSAL_D2. Fecha -
      insert into TMP_EXP_ENTSAL_D2
        (
          DIA_ID,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select DIA_ID,
          EXPEDIENTE_ID,
          null,
          ESQUEMA_EXPEDIENTE_ID,
          SUBCARTERA_EXPEDIENTE_ID,
          AGENCIA_EXPEDIENTE_ID,
          ENVIADO_AGENCIA_EXP_ID,
          1,
          SALDO_VENCIDO,
          SALDO_NO_VENCIDO,
          SALDO_TOTAL,
          RIESGO_VIVO,
          DEUDA_IRREGULAR
          from H_EXP
          where DIA_ID = fecha;

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_ENTSAL_D2. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


      --Indices para TMP_EXP_ENTSAL_D1 y TMP_EXP_ENTSAL_D2
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_ENTSAL_D1_IX'', ''TMP_EXP_ENTSAL_D1 (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_ENTSAL_D2_IX'', ''TMP_EXP_ENTSAL_D2 (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;


       --ALTAS Caso 0 Contratos en D2 enviados a agencia y que no están en D1
      insert into TMP_EXP_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_EXP_CR,
          FECHA_BAJA_EXP_CR,
          FECHA_CARGA_DATOS,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select
        DIA_ID,
        DIA_ID,
        null,
        DIA_ID,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
      from TMP_EXP_ENTSAL_D2 d2 where d2.ENVIADO_AGENCIA_EXP_CR_ID = 1 and d2.EXPEDIENTE_ID not in (select d1.EXPEDIENTE_ID from TMP_EXP_ENTSAL_D1 d1);

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_DET_CICLO_REC. Registros Insertados(1): ' || TO_CHAR(V_ROWCOUNT), 4;



      --BAJAS Caso 0 Contratos en D1 enviados a agencia y que no están en D2
      insert into TMP_EXP_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_EXP_CR,
          FECHA_BAJA_EXP_CR,
          FECHA_CARGA_DATOS,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select
        fecha,
        null,
        fecha,
        fecha,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
      from TMP_EXP_ENTSAL_D1 d1 where d1.ENVIADO_AGENCIA_EXP_CR_ID = 1 and d1.EXPEDIENTE_ID not in (select d2.EXPEDIENTE_ID from TMP_EXP_ENTSAL_D2 d2);

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_DET_CICLO_REC. Registros Insertados(2): ' || TO_CHAR(V_ROWCOUNT), 4;


      --ALTAS Caso 1 Está en D1 y D2, pero en D1 no tiene agencia, pero en D2 sí
      insert into TMP_EXP_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_EXP_CR,
          FECHA_BAJA_EXP_CR,
          FECHA_CARGA_DATOS,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select
        d2.DIA_ID,
        d2.DIA_ID,
        null,
        d2.DIA_ID,
        d2.EXPEDIENTE_ID,
        d2.MOTIVO_BAJA_EXP_CR_ID,
        d2.ESQUEMA_EXP_CR_ID,
        d2.SUBCARTERA_EXP_CR_ID,
        d2.AGENCIA_EXP_CR_ID,
        d2.ENVIADO_AGENCIA_EXP_CR_ID,
        d2.NUM_EXPEDIENTE_CICLO_REC,
        d2.SALDO_VENCIDO_EXP_CR,
        d2.SALDO_NO_VENCIDO_EXP_CR,
        d2.SALDO_TOTAL_EXP_CR,
        d2.RIESGO_VIVO_EXP_CR,
        d2.DEUDA_IRREGULAR_EXP_CR
      from TMP_EXP_ENTSAL_D2 d2,  TMP_EXP_ENTSAL_D1 d1
      where d2.ENVIADO_AGENCIA_EXP_CR_ID = 1
      and   d1.ENVIADO_AGENCIA_EXP_CR_ID = 0
      and   d2.EXPEDIENTE_ID = d1.EXPEDIENTE_ID
      and   (d1.SUBCARTERA_EXP_CR_ID=d2.SUBCARTERA_EXP_CR_ID or d2.SUBCARTERA_EXP_CR_ID is null);
--      from TMP_EXP_ENTSAL_D2 d2 where d2.ENVIADO_AGENCIA_EXP_CR_ID = 1 and d2.EXPEDIENTE_ID in (select d1.EXPEDIENTE_ID from TMP_EXP_ENTSAL_D1 d1 where (d1.SUBCARTERA_EXP_CR_ID=d2.SUBCARTERA_EXP_CR_ID and d1.ENVIADO_AGENCIA_EXP_CR_ID = 0)
--                                                                                                                                  or (d2.SUBCARTERA_EXP_CR_ID is null and d1.ENVIADO_AGENCIA_EXP_CR_ID = 0));
      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_DET_CICLO_REC. Registros Insertados(3): ' || TO_CHAR(V_ROWCOUNT), 4;


      --BAJAS Caso 1
      insert into TMP_EXP_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_EXP_CR,
          FECHA_BAJA_EXP_CR,
          FECHA_CARGA_DATOS,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select
        fecha,
        null,
        fecha,
        fecha,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
      from TMP_EXP_ENTSAL_D1 d1 where d1.ENVIADO_AGENCIA_EXP_CR_ID = 1 and d1.EXPEDIENTE_ID in (select d2.EXPEDIENTE_ID from TMP_EXP_ENTSAL_D2 d2 where d2.ENVIADO_AGENCIA_EXP_CR_ID = 0);

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_DET_CICLO_REC. Registros Insertados(4): ' || TO_CHAR(V_ROWCOUNT), 4;

      -- Eliminar no enviados a agencia
      --delete from TMP_EXP_ENTSAL_D1 where ENVIADO_AGENCIA_EXP_CR_ID = 0;
      --delete from TMP_EXP_ENTSAL_D2 where ENVIADO_AGENCIA_EXP_CR_ID = 0;
      --commit;


      --ALTAS Caso 2
      insert into TMP_EXP_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_EXP_CR,
          FECHA_BAJA_EXP_CR,
          FECHA_CARGA_DATOS,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select
        d2.DIA_ID,
        d2.DIA_ID,
        null,
        d2.DIA_ID,
        d2.EXPEDIENTE_ID,
        d2.MOTIVO_BAJA_EXP_CR_ID,
        d2.ESQUEMA_EXP_CR_ID,
        d2.SUBCARTERA_EXP_CR_ID,
        d2.AGENCIA_EXP_CR_ID,
        d2.ENVIADO_AGENCIA_EXP_CR_ID,
        d2.NUM_EXPEDIENTE_CICLO_REC,
        d2.SALDO_VENCIDO_EXP_CR,
        d2.SALDO_NO_VENCIDO_EXP_CR,
        d2.SALDO_TOTAL_EXP_CR,
        d2.RIESGO_VIVO_EXP_CR,
        d2.DEUDA_IRREGULAR_EXP_CR
      from TMP_EXP_ENTSAL_D2 d2, TMP_EXP_ENTSAL_D1 d1
      where d1.EXPEDIENTE_ID = d2.EXPEDIENTE_ID
      and ((d1.SUBCARTERA_EXP_CR_ID <> d2.SUBCARTERA_EXP_CR_ID and d2.ENVIADO_AGENCIA_EXP_CR_ID =1)or(d1.SUBCARTERA_EXP_CR_ID is null and d2.SUBCARTERA_EXP_CR_ID is not null and d2.ENVIADO_AGENCIA_EXP_CR_ID =1));

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_DET_CICLO_REC. Registros Insertados(5): ' || TO_CHAR(V_ROWCOUNT), 4;


      --BAJAS Caso 2
      insert into TMP_EXP_DET_CICLO_REC
        (
          DIA_ID,
          FECHA_ALTA_EXP_CR,
          FECHA_BAJA_EXP_CR,
          FECHA_CARGA_DATOS,
          EXPEDIENTE_ID,
          MOTIVO_BAJA_EXP_CR_ID,
          ESQUEMA_EXP_CR_ID,
          SUBCARTERA_EXP_CR_ID,
          AGENCIA_EXP_CR_ID,
          ENVIADO_AGENCIA_EXP_CR_ID,
          NUM_EXPEDIENTE_CICLO_REC,
          SALDO_VENCIDO_EXP_CR,
          SALDO_NO_VENCIDO_EXP_CR,
          SALDO_TOTAL_EXP_CR,
          RIESGO_VIVO_EXP_CR,
          DEUDA_IRREGULAR_EXP_CR
        )
      select
        fecha,
        null,
        fecha,
        fecha,
        d1.EXPEDIENTE_ID,
        d1.MOTIVO_BAJA_EXP_CR_ID,
        d1.ESQUEMA_EXP_CR_ID,
        d1.SUBCARTERA_EXP_CR_ID,
        d1.AGENCIA_EXP_CR_ID,
        d1.ENVIADO_AGENCIA_EXP_CR_ID,
        d1.NUM_EXPEDIENTE_CICLO_REC,
        d1.SALDO_VENCIDO_EXP_CR,
        d1.SALDO_NO_VENCIDO_EXP_CR,
        d1.SALDO_TOTAL_EXP_CR,
        d1.RIESGO_VIVO_EXP_CR,
        d1.DEUDA_IRREGULAR_EXP_CR
      from TMP_EXP_ENTSAL_D2 d2, TMP_EXP_ENTSAL_D1 d1
      where d1.EXPEDIENTE_ID = d2.EXPEDIENTE_ID
      and ((d1.SUBCARTERA_EXP_CR_ID <> d2.SUBCARTERA_EXP_CR_ID and d1.ENVIADO_AGENCIA_EXP_CR_ID=1 and d2.ENVIADO_AGENCIA_EXP_CR_ID=1)or(d2.SUBCARTERA_EXP_CR_ID is not null and d1.SUBCARTERA_EXP_CR_ID is null and d1.ENVIADO_AGENCIA_EXP_CR_ID =1 and d2.ENVIADO_AGENCIA_EXP_CR_ID =1));

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_DET_CICLO_REC. Registros Insertados(6): ' || TO_CHAR(V_ROWCOUNT), 4;


      -- Crear indices TMP_EXP_DET_CICLO_REC
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_DET_CICLO_REC_IX'', ''TMP_EXP_DET_CICLO_REC (DIA_ID, FECHA_ALTA_EXP_CR, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      -- Borrando indices H_EXP_DET_CICLO_REC
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CICLO_REC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- Borrado del día a insertar
    delete from H_EXP_DET_CICLO_REC where DIA_ID = fecha;
    commit;


    insert into H_EXP_DET_CICLO_REC
        (DIA_ID,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
        )
      select * from TMP_EXP_DET_CICLO_REC where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CICLO_REC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;



   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Termnina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

  end loop;
  close c_fecha;


  -- Crear indices H_EXP
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_IX'', ''H_EXP (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_EXP_IX'', ''H_EXP (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  commit;

 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Termina Creación de Indices', 3;

/*COBROS
  -- Crear indices H_EXP_DET_COBRO
  select count(*) into nCount from USER_INDEXES where INDEX_NAME = 'H_EXP_DET_COBRO_IX';
  if(nCount = 0) then
    execute immediate 'CREATE INDEX H_EXP_DET_COBRO_IX on H_EXP_DET_COBRO (DIA_ID, EXPEDIENTE_ID)';
  else
    execute immediate 'ALTER INDEX H_EXP_DET_COBRO_IX REBUILD PARALLEL';
  end if;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_COBRO. Termina Creación de Indices', 3;
*/

  -- Crear indices H_EXP_DET_CNT
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_IX'', ''H_EXP_DET_CNT (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_CNT_IX'', ''H_EXP_DET_CNT (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- Crear indices H_EXP_DET_CICLO_REC
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_IX'', ''H_EXP_DET_CICLO_REC (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT. Termina Creación de Indices', 3;

  commit;

-- --------------------------- Fin loop de insercion ---------------------------

-- ----------------------------- Loop de updates -------------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;
    exit when c_fecha%NOTFOUND;




	/*
execute immediate 'update H_EXP set NUM_DIAS_SANCION_FORMALIZACION = NVL(FECHA_SANCION_PROPUESTA - FECHA_FORMALIZACION_PROPUESTA, 0) where DIA_ID = fecha';
execute immediate 'update H_EXP set NUM_DIAS_OFREC_PROPUESTA = NVL(FECHA_OFRECIMIENTO_PROPUESTA - FECHA_FORMALIZACION_PROPUESTA, 0) where DIA_ID = fecha';
execute immediate 'update H_EXP set NUM_DIAS_ACTIVACION_RESOLUCION = NVL(FECHA_ACTIVACION_INCIDENCIA - FECHA_RESOLUCION_INCIDENCIA, ) where DIA_ID = fecha';
execute immediate 'update H_EXP set NUM_DIAS_COMITE_SANCION = NVL(FECHA_ELEVACION_COMITE - FECHA_SANCION_PROPUESTA) where DIA_ID = fecha';

execute immediate 'update H_EXP set T_ROTACIONES_EXP_ID = (case when NUM_ROTACIONES = 0 then 0
                                             when NUM_ROTACIONES > 0 and NUM_ROTACIONES <= 1 then 1
                                             when NUM_ROTACIONES > 1 and NUM_ROTACIONES <= 2 then 2
                                             when NUM_ROTACIONES > 2 and NUM_ROTACIONES <= 3 then 3
                                             when NUM_ROTACIONES > 3 and NUM_ROTACIONES <= 4 then 4
                                             when NUM_ROTACIONES > 4 then 5
                                                                else -1 end) where DIA_ID = ''' || fecha || '''';

execute immediate 'update H_EXP set TD_ENTRADA_GEST_EXP_ID = (case when NUM_DIAS_CREACION <= 15 then 0
                                                when NUM_DIAS_CREACION > 15 and NUM_DIAS_CREACION <= 30 then 1
                                                when NUM_DIAS_CREACION > 30 and NUM_DIAS_CREACION <= 60 then 2
                                                when NUM_DIAS_CREACION > 60 and NUM_DIAS_CREACION <= 90 then 3
                                                when NUM_DIAS_CREACION > 90 and NUM_DIAS_CREACION <= 120 then 4
                                                when NUM_DIAS_CREACION >120 then 5
                                                else -1 end) where DIA_ID = ''' || fecha || '''';
*/

  commit;





    /*
    -- Insertamos el resto de procedimientos cuyo contrato ya no aparece en esa fecha.
    insert into TMP_EXP_CNT (EXPEDIENTE_ID, CONTRATO)
    select cex.EXP_ID, cex.CNT_ID from desarrollo_recovery_ugas_datastage.CEX_CONTRATOS_EXPEDIENTE cex
    where cex.CEX_ID not in (select CEX_ID from TMP_EXP_CNT);

    update TMP_EXP_CNT tpc set MAX_MOV_ID = (select max(MOV_ID) from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) where tpc.CEX_ID is null;
    -- Si algún contrato no se encuentra en H_MOV_MOVIMIENTOS lo borramos
    delete from TMP_EXP_CNT where CEX_ID is null and MAX_MOV_ID is null;
    -- Excepciones - Rellenar
    -- update TMP_EXP_CNT tpc set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    -- update TMP_EXP_CNT tpc set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    update TMP_EXP_CNT tpc set SALDO_DUDOSO = (select h.MOV_SALDO_DUDOSO from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    -- Cambiar SALDO_RECLAMAR
    update TMP_EXP_CNT tpc set SALDO_RECLAMAR = (select h.MOV_SALDO_DUDOSO from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    update TMP_EXP_CNT tpc set INT_REMUNERATORIOS = (select h.MOV_INT_REMUNERATORIOS from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    update TMP_EXP_CNT tpc set INT_MORATORIOS = (select h.MOV_INT_MORATORIOS from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    update TMP_EXP_CNT tpc set COMISIONES = (select h.MOV_COMISIONES from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    update TMP_EXP_CNT tpc set GASTOS = (select h.MOV_GASTOS from desarrollo_recovery_ugas_datastage.H_MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) where CEX_ID is null;
    */

  end loop;
  close c_fecha;


  -- -------------------------- CÁLCULO DEL RESTO DE PERIODOS ----------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_EXP;
  commit;
-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  select max(SEMANA_ID) into V_NUMBER from H_CNT_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX)
    select max(SEMANA_ID) from H_CNT_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
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

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Empieza Semana: '||TO_CHAR(semana), 3;

    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    select min(DIA_H) into min_dia_semana from TMP_FECHA where SEMANA_H = semana;

    -- Borrado de las semanas a insertar
    delete from H_EXP_SEMANA where SEMANA_ID = semana;
    commit;

    -- Borrado indices H_EXP_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Termina Borrado de Indices', 4;


    -- INSERTADO DE SEMANAS (ÚLTIMO DÍA DE LA semana DISPONIBLE EN H_EXP)
    insert into H_EXP_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
        )
    select semana,
         max_dia_semana,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
    from H_EXP where DIA_ID = max_dia_semana;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_EXP_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_SEMANA_IX'', ''H_EXP_SEMANA (SEMANA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Termina Creación de Indices', 4;



    ---------------------- Detalle ciclo recobro Semana ----------------------
    -- Borrado indices H_EXP_DET_CICLO_REC_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CICLO_REC_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    -- Borrado de las semanas a insertar
    delete from H_EXP_DET_CICLO_REC_SEMANA where SEMANA_ID = semana;
    commit;

    insert into H_EXP_DET_CICLO_REC_SEMANA
        (SEMANA_ID,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
        )
    select semana,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        max_dia_semana,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
    from H_EXP_DET_CICLO_REC
    where (FECHA_ALTA_EXP_CR between min_dia_semana and max_dia_semana)
    or    (FECHA_BAJA_EXP_CR between min_dia_semana and max_dia_semana);

    -- Crear indices H_CNT_DET_CICLO_REC_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_SEMANA_IX'', ''H_EXP_DET_CICLO_REC_SEMANA (SEMANA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;



    ---------------------- Detalle Contratos Semana----------------------
    -- Borrado de las semanas a insertar
    delete from H_EXP_DET_CNT_SEMANA where SEMANA_ID = semana;
    commit;

    -- Borrado indices H_EXP_DET_CNT_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_SEMANA_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_SEMANA. Termina Creación de Indices', 4;


    insert into H_EXP_DET_CNT_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
         )
    select semana,
         max_dia_semana,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
    from H_EXP_DET_CNT where DIA_ID = max_dia_semana;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_EXP_DET_CNT_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_SEMANA_IX'', ''H_EXP_DET_CNT_SEMANA (SEMANA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_SEMANA_CNT_IX'', ''H_EXP_DET_CNT_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_SEMANA. Termina Creación de Indices', 4;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Termina Semana: '||TO_CHAR(semana), 3;

  end loop;
  close c_semana;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_MES
-- ----------------------------------------------------------------------------------------------
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_CNT_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);

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

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Empieza Mes: '||TO_CHAR(mes), 3;

    select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
    select min(DIA_H) into min_dia_mes from TMP_FECHA where MES_H = mes;

    -- Borrado de los meses a insertar
    delete from H_EXP_MES where MES_ID = mes;
    commit;

    -- Borrado indices H_EXP_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Termina Borrado de Indices', 4;


    insert into H_EXP_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
        )
    select mes,
         max_dia_mes,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
    from H_EXP where DIA_ID = max_dia_mes;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_EXP_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_MES_IX'', ''H_EXP_MES (MES_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Termina Creación de Indices', 4;


    ---------------------- Detalle ciclo recobro Mes ----------------------
    -- Borrado indices H_EXP_DET_CICLO_REC_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CICLO_REC_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    -- Borrado de las semanas a insertar
    delete from H_EXP_DET_CICLO_REC_MES where MES_ID = mes;
    commit;

    insert into H_EXP_DET_CICLO_REC_MES
        (MES_ID,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
        )
    select mes,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        max_dia_mes,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
    from H_EXP_DET_CICLO_REC
    where (FECHA_ALTA_EXP_CR between min_dia_mes and max_dia_mes)
    or    (FECHA_BAJA_EXP_CR between min_dia_mes and max_dia_mes);

    -- Crear indices H_EXP_DET_CICLO_REC_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_MES_IX'', ''H_EXP_DET_CICLO_REC_MES (MES_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;



    ---------------------- Detalle Contratos ----------------------
     -- Borrado de los meses a insertar
    delete from H_EXP_DET_CNT_MES where MES_ID = mes;
    commit;

    -- Borrado indices H_EXP_DET_CNT_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_MES_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_MES. Termina Borrado de Indices', 4;


    insert into H_EXP_DET_CNT_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
         )
    select mes,
         max_dia_mes,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
    from H_EXP_DET_CNT where DIA_ID = max_dia_mes;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


	  -- Crear indices H_EXP_DET_CNT_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_MES_IX'', ''H_EXP_DET_CNT_MES (MES_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_MES_CNT_IX'', ''H_EXP_DET_CNT_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_MES. Termina Creación de Indices', 4;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Termina Mes: '||TO_CHAR(mes), 3;

  end loop;
  close c_mes;



-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_CNT_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
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

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Empieza Trimestre: '||TO_CHAR(trimestre), 3;


    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
    select min(DIA_H) into min_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    -- Borrado de los trimestres a insertar
    delete from H_EXP_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;

    -- Borrar indices H_EXP_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Termina Borrado de Indices', 4;


    insert into H_EXP_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
        )
    select trimestre,
         max_dia_trimestre,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
    from H_EXP where DIA_ID = max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_EXP_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_TRIMESTRE_IX'', ''H_EXP_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Termina Creación de Indices', 4;


    ---------------------- Detalle ciclo recobro Trimestre ----------------------
    -- Borrado indices H_EXP_DET_CICLO_REC_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CICLO_REC_TRI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    -- Borrado de las semanas a insertar
    delete from H_EXP_DET_CICLO_REC_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;

    insert into H_EXP_DET_CICLO_REC_TRIMESTRE
        (TRIMESTRE_ID,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
        )
    select trimestre,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        max_dia_trimestre,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
    from H_EXP_DET_CICLO_REC
    where (FECHA_ALTA_EXP_CR between min_dia_trimestre and max_dia_trimestre)
    or    (FECHA_BAJA_EXP_CR between min_dia_trimestre and max_dia_trimestre);

    -- Crear indices H_EXP_DET_CICLO_REC_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_TRI_IX'', ''H_EXP_DET_CICLO_REC (TRIMESTRE_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;



    ---------------------- Detalle Contratos Trimestre ----------------------
    -- Borrado de los trimestres a insertar
    delete from H_EXP_DET_CNT_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;

    -- Borrar indices H_EXP_DET_CNT_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_TRIMESTRE_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_TRIMESTRE. Termina Borrado de Indices', 4;


    insert into H_EXP_DET_CNT_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
        )
    select trimestre,
         max_dia_trimestre,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
     from H_EXP_DET_CNT where DIA_ID = max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_EXP_DET_CNT_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_TRIMESTRE_IX'', ''H_EXP_DET_CNT_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_TRIMESTRE_CNT_IX'', ''H_EXP_DET_CNT_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_TRIMESTRE. Termina Creación de Indices', 4;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Termina Trimestre: '||TO_CHAR(trimestre), 3;

  end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_ANIO
-- ----------------------------------------------------------------------------------------------
/*
	-- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_CNT_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
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

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_ANIO. Empieza Año: '||TO_CHAR(anio), 3;

    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
    select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;

    -- Borrado de los años a insertar
    delete from H_EXP_ANIO where ANIO_ID = anio;
    commit;

    -- Borrar indices H_CNT_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Termina Borrado de Indices', 4;

    insert into H_EXP_ANIO
        (ANIO_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
        )
    select anio,
         max_dia_anio,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_ENTRADA_AGENCIA_EXP,
         FECHA_SALIDA_AGENCIA_EXP,
         FECHA_OFRECIMIENTO_PROPUESTA,
         FECHA_FORMALIZACION_PROPUESTA,
         FECHA_SANCION_PROPUESTA,
         FECHA_ACTIVACION_INCIDENCIA,
         FECHA_RESOLUCION_INCIDENCIA,
         FECHA_ELEVACION_COMITE,
         FECHA_ULTIMO_COBRO,
         FECHA_MEJOR_GESTION,
         ESQUEMA_EXPEDIENTE_ID,
         AGENCIA_EXPEDIENTE_ID,
         SUBCARTERA_EXPEDIENTE_ID,
         TIPO_SALIDA_ID,
         MOTIVO_SALIDA_ID,
         TIPO_PALANCA_ID,
         ESTADO_PALANCA_ID,
         TIPO_SANCION_ID,
         TIPO_INCIDENCIA_ID,
         ESTADO_INCIDENCIA_ID,
         TIPO_GESTION_EXP_ID,
         RESULTADO_GESTION_EXP_ID,
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_ENV_EXP_ID,
         T_ROTACIONES_EXP_ID,
         TD_ENTRADA_GEST_EXP_ID,
         TD_CREACION_EXP_COBRO_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_COBROS,
         NUM_ROTACIONES,
         NUM_DIAS_CREACION_A_ROTURA,
         NUM_DIAS_CREACION,
         NUM_DIAS_SANCION_FORMALIZACION,
         NUM_DIAS_OFREC_PROPUESTA,
         NUM_DIAS_ACTIVACION_RESOLUCION,
         NUM_DIAS_COMITE_SANCION,
         NUM_DIAS_CREACION_EXP_COBRO,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_NO_VENCIDO_ENV_AGENCIA,
         SALDO_TOTAL,
         RIESGO_VIVO,
         RIESGO_VIVO_ENV_AGENCIA,
         DEUDA_IRREGULAR,
         DEUDA_IRREGULAR_ENV_AGENCIA,
         SALDO_DUDOSO,
         SALDO_A_RECLAMAR,
         IMPORTE_COBROS,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS,
         IMPORTE_COMPROMETIDO
    from H_EXP where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_EXP_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_ANIO_IX'', ''H_EXP_ANIO (ANIO_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Termina Creación de Indices', 4;


   ---------------------- Detalle ciclo recobro anio ----------------------
    -- Borrado indices H_EXP_DET_CICLO_REC_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CICLO_REC_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    -- Borrado de las semanas a insertar
    delete from H_EXP_DET_CICLO_REC_ANIO where ANIO_ID = anio;
    commit;

    insert into H_EXP_DET_CICLO_REC_ANIO
        (ANIO_ID,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
        )
    select anio,
        FECHA_ALTA_EXP_CR,
        FECHA_BAJA_EXP_CR,
        max_dia_anio,
        EXPEDIENTE_ID,
        MOTIVO_BAJA_EXP_CR_ID,
        ESQUEMA_EXP_CR_ID,
        SUBCARTERA_EXP_CR_ID,
        AGENCIA_EXP_CR_ID,
        ENVIADO_AGENCIA_EXP_CR_ID,
        NUM_EXPEDIENTE_CICLO_REC,
        SALDO_VENCIDO_EXP_CR,
        SALDO_NO_VENCIDO_EXP_CR,
        SALDO_TOTAL_EXP_CR,
        RIESGO_VIVO_EXP_CR,
        DEUDA_IRREGULAR_EXP_CR
    from H_EXP_DET_CICLO_REC
    where (FECHA_ALTA_EXP_CR between min_dia_anio and max_dia_anio)
    or    (FECHA_BAJA_EXP_CR between min_dia_anio and max_dia_anio);

    -- Crear indices H_EXP_DET_CICLO_REC_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CICLO_REC_ANIO_IX'', ''H_EXP_DET_CICLO_REC_ANIO (ANIO_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;



    ---------------------- Detalle Contratos Año ----------------------
    -- Borrado de los años a insertar
    delete from H_EXP_DET_CNT_ANIO where ANIO_ID = anio;
    commit;

    -- Borrar indices H_EXP_DET_CNT_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CNT_ANIO_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_ANIO. Termina Borrado de Indices', 4;


    insert into H_EXP_DET_CNT_ANIO
        (ANIO_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
        )
    select anio,
         max_dia_anio,
         EXPEDIENTE_ID,
         CONTRATO_ID,
         FECHA_GESTION,
         TIPO_GESTION_EXP_CNT_ID,
         RESULTADO_GESTION_EXP_CNT_ID,
         NUM_CONTRATOS_EXPEDIENTE,
         IMPORTE_COMPROMETIDO
    from H_EXP_DET_CNT where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_EXP_DET_CNT_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_ANIO_IX'', ''H_EXP_DET_CNT_ANIO (ANIO_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CNT_ANIO_CNT_IX'', ''H_EXP_DET_CNT_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CNT_ANIO. Termina Creación de Indices', 4;


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_ANIO. Termina Año: '||TO_CHAR(anio), 3;

  end loop;
  close c_anio;

*/

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


EXCEPTION
  /*when OBJECTEXISTS then
    --O_ERROR_STATUS := 'La tabla ya existe';
    DBMS_OUTPUT.PUT_LINE('La tabla ya existe');
    --ROLLBACK;
  when INSERT_NULL then
    --O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    DBMS_OUTPUT.PUT_LINE('Has intentado insertar un valor nulo');
    --ROLLBACK;
  when PARAMETERS_NUMBER then
    --O_ERROR_STATUS := 'Número de parámetros incorrecto';
    DBMS_OUTPUT.PUT_LINE('Número de parámetros incorrecto');
    --ROLLBACK;    */
  when OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --DBMS_OUTPUT.PUT_LINE('Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM);
    --ROLLBACK;



end CARGAR_H_EXPEDIENTE;
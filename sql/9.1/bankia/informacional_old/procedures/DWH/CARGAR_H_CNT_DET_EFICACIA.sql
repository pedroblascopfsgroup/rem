create or replace PROCEDURE CARGAR_H_CNT_DET_EFICACIA (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Mayo 2015
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 13/08/2015
-- Motivos del cambio: Usuario/Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripción: Procedimiento almacenado que carga las tablas hechos CARGAR_H_CNT_DET_EFICACIA.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaración de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_CONTRATO';
  V_ROWCOUNT NUMBER;

  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  nCount NUMBER;

  formato_fecha VARCHAR2(100);

  min_dia_semana date;
  max_dia_semana date;
  min_dia_mes date;
  max_dia_mes date;
  min_dia_trimestre date;
  max_dia_trimestre date;
  min_dia_anio date;
  max_dia_anio date;
  max_dia_carga date;
  dia_periodo_ant date;
  semana_periodo_ant int;
  mes_periodo_ant int;
  trimestre_periodo_ant int;
  anio_periodo_ant int;
  hay_datos int;
  primer_dia_mes date;
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_anterior date;
  fecha_rellena date;
  
  semana_rellena int;
  mes_relleno int;
  trimestre_relleno int;
  anio_relleno int;

  max_dia_h date;
  max_dia_mov date;
  penult_dia_mov date;
  max_dia_con_contratos date;

  V_SQL VARCHAR2(16000);

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END order by 1;
  cursor c_semana is select distinct (SEMANA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_mes is select distinct (MES_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_trimestre is select distinct (TRIMESTRE_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_anio is select distinct (ANIO_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;

  
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
--                                      H_CNT_DET_EFICACIA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';

-- ----------------------------- Buscamos últimas fechas cargadas en H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO-----------------------------  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (DIA_AUX) select distinct(a.DIA_ID) from H_CNT_DET_CICLO_REC a where a.DIA_ID <= DATE_END;
  commit;
  insert into TMP_FECHA_AUX (DIA_AUX) select distinct(a.DIA_ID) from H_CNT_DET_COBRO a where a.DIA_ID <= DATE_END;
  commit;

  insert into TMP_FECHA (DIA_H) select distinct DIA_AUX from TMP_FECHA_AUX where DIA_AUX is not null group by DIA_AUX having count(*) > 1;
  commit;

-- ----------------------------- Buscamos últimas fechas cargadas anteriores en H_CNT-----------------------------  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (DIA_AUX) select distinct(DIA_ID) from H_CNT where DIA_ID < DATE_END;
  commit;  
  
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

	--Nos quedamos con la fecha cargada más reciente en H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO <= a la fecha a cargar
	select MAX(DIA_H) into fecha_rellena from TMP_FECHA where DIA_H <= fecha;
	--Nos quedamos con la fecha cargada más reciente en H_CNT anterior a la fecha de H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO
	select MAX(DIA_AUX) into fecha_anterior from TMP_FECHA_AUX where DIA_AUX < fecha_rellena;
	
    -- Borrando indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_EFICACIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT_DET_EFICACIA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Truncado de tabla y borrado de índices', 4;

    -- Stock inicial. Periodo n-1
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_EFICACIA
         (DIA_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || fecha || ''' DIA_ID,
         CONTRATO_ID,
         ESQUEMA_CONTRATO_ID,
         AGENCIA_CONTRATO_ID,
         SUBCARTERA_EXPEDIENTE_CNT_ID,
         sum(DEUDA_IRREGULAR),
		  0,
		  0  
    from  H_CNT
    where DIA_ID = ''' || fecha_anterior || ''' and ENVIADO_AGENCIA_CNT_ID = 1 and ESQUEMA_CONTRATO_ID is not null and AGENCIA_CONTRATO_ID is not null and SUBCARTERA_EXPEDIENTE_CNT_ID is not null
    group by DIA_ID, CONTRATO_ID, ESQUEMA_CONTRATO_ID, AGENCIA_CONTRATO_ID, SUBCARTERA_EXPEDIENTE_CNT_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;	
	
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Stock inicial. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Entradas. Periodo n. Nota: cambiar POSICION_VENCIDA_CICLO_REC por DEUDA_IRREGULAR_CICLO_REC cuando tenga valores
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_EFICACIA
         (DIA_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || fecha || ''' DIA_ID,
         CONTRATO_ID,
         ESQUEMA_CR_ID,
         AGENCIA_CR_ID,
         SUBCARTERA_CR_ID,
         0,
		 sum(POSICION_VENCIDA_CICLO_REC),
		 0 
    from  H_CNT_DET_CICLO_REC
    where DIA_ID = ''' || fecha_rellena || ''' and FECHA_BAJA_CICLO_REC is null and ENVIADO_AGENCIA_CR_ID = 1 and ESQUEMA_CR_ID is not null and AGENCIA_CR_ID is not null and SUBCARTERA_CR_ID is not null
    group by DIA_ID, CONTRATO_ID, ESQUEMA_CR_ID, AGENCIA_CR_ID, SUBCARTERA_CR_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Entradas. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
	
    -- Cobros. Periodo n.
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_EFICACIA
         (DIA_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || fecha || ''' DIA_ID,
         CONTRATO_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         0,
		 0,
		 sum(IMPORTE_COBRO)
    from  H_CNT_DET_COBRO
    where DIA_ID = ''' || fecha_rellena || ''' and ENVIADO_AGENCIA_COBRO_ID = 1 and TIPO_COBRO_DET_ID in (409, 410, 415, 416) AND COBRO_FACTURADO_ID = 1
		and ESQUEMA_COBRO_ID is not null and AGENCIA_COBRO_ID is not null and SUBCARTERA_COBRO_ID is not null
    group by DIA_ID, CONTRATO_ID, ESQUEMA_COBRO_ID, AGENCIA_COBRO_ID, SUBCARTERA_COBRO_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Cobros. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

	
    -- FECHA_CARGA_DATOS periodo n. Coger la FECHA_CARGA_DATOS de las entradas que acabamos de insertar. 
    update TMP_H_CNT_DET_EFICACIA set FECHA_CARGA_DATOS = fecha;
    commit;
    
    -- Crear indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_EFICACIA_IX'', ''TMP_H_CNT_DET_EFICACIA (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrando indices H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_EFICACIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado del día a insertar
    delete from H_CNT_DET_EFICACIA where DIA_ID = fecha;
    commit;

    insert into H_CNT_DET_EFICACIA
         (DIA_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS
        )
    select DIA_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS
    from TMP_H_CNT_DET_EFICACIA  
    where DIA_ID = fecha;
    V_ROWCOUNT := sql%rowcount;
    commit;
	
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_IX'', ''H_CNT_DET_EFICACIA (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    end loop;
  close c_fecha;


-- -------------------------- CÁLCULO DEL RESTO DE PERIODOS ----------------------------
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_EFICACIA_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_SEMANA. Empieza bucle', 3;

  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;

  merge into TMP_FECHA_AUX dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_AUX)
  when matched then update set dc.SEMANA_AUX = cf.SEMANA_ID;
  commit;
  
  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;
    exit when c_semana%NOTFOUND;

  	--Nos quedamos con la fecha cargada más reciente en H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO <= a la fecha a cargar
	select MAX(SEMANA_H) into semana_rellena from TMP_FECHA where SEMANA_H <= semana;
	--Nos quedamos con la fecha cargada más reciente en H_CNT anterior a la fecha de H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO
	select MAX(SEMANA_AUX) into semana_periodo_ant from TMP_FECHA_AUX where SEMANA_AUX < semana_rellena;
	--fecha carga datos
	select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_SEMANA. Empieza semana: '||TO_CHAR(semana), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_SEMANA. semana rellena: '||TO_CHAR(semana_rellena), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_SEMANA. semana ant rellena: '||TO_CHAR(semana_periodo_ant), 3;
	
    -- Borrando indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_EFICACIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT_DET_EFICACIA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Truncado de tabla y borrado de índices', 4;

    -- Stock inicial. Periodo n-1
	execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (SEMANA_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || semana || ''' SEMANA_ID,
         CONTRATO_ID,
         ESQUEMA_CONTRATO_ID,
         AGENCIA_CONTRATO_ID,
         SUBCARTERA_EXPEDIENTE_CNT_ID,
         sum(DEUDA_IRREGULAR),
		  0,
		  0  
    from  H_CNT_SEMANA
    where SEMANA_ID = ''' || semana_periodo_ant || ''' and ENVIADO_AGENCIA_CNT_ID = 1 and ESQUEMA_CONTRATO_ID is not null and AGENCIA_CONTRATO_ID is not null and SUBCARTERA_EXPEDIENTE_CNT_ID is not null
    group by SEMANA_ID, CONTRATO_ID, ESQUEMA_CONTRATO_ID, AGENCIA_CONTRATO_ID, SUBCARTERA_EXPEDIENTE_CNT_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;	
	
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Stock inicial. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    
    -- Entradas. Periodo n
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (SEMANA_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || semana || ''' SEMANA_ID,
         CONTRATO_ID,
         ESQUEMA_CR_ID,
         AGENCIA_CR_ID,
         SUBCARTERA_CR_ID,
         0,
		 sum(POSICION_VENCIDA_CICLO_REC),
		 0 
    from  H_CNT_DET_CICLO_REC_SEMANA
    where SEMANA_ID = ''' || semana_rellena || ''' and FECHA_BAJA_CICLO_REC is null and ENVIADO_AGENCIA_CR_ID = 1 and ESQUEMA_CR_ID is not null and AGENCIA_CR_ID is not null and SUBCARTERA_CR_ID is not null
    group by SEMANA_ID, CONTRATO_ID, ESQUEMA_CR_ID, AGENCIA_CR_ID, SUBCARTERA_CR_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Entradas. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
	-- Cobros. Periodo n.
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (SEMANA_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || semana || ''' SEMANA_ID,
         CONTRATO_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         0,
		 0,
		 sum(IMPORTE_COBRO)
    from  H_CNT_DET_COBRO_SEMANA
    where SEMANA_ID = ''' || semana_rellena || ''' and ENVIADO_AGENCIA_COBRO_ID = 1 and TIPO_COBRO_DET_ID in (409, 410, 415, 416) AND COBRO_FACTURADO_ID = 1
		and ESQUEMA_COBRO_ID is not null and AGENCIA_COBRO_ID is not null and SUBCARTERA_COBRO_ID is not null
    group by SEMANA_ID, CONTRATO_ID, ESQUEMA_COBRO_ID, AGENCIA_COBRO_ID, SUBCARTERA_COBRO_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Cobros. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

	
    -- FECHA_CARGA_DATOS periodo n. Coger la FECHA_CARGA_DATOS de las entradas que acabamos de insertar. H_CNT_DET_CICLO_REC_SEMANA (semana, mes...)
    update TMP_H_CNT_DET_EFICACIA set FECHA_CARGA_DATOS = max_dia_semana;
    commit;
    
    -- Crear indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_EFICACIA_IX'', ''TMP_H_CNT_DET_EFICACIA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrando indices H_CNT_DET_EFICACIA_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_EFICACIA_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- Borrado del día a insertar
    delete from H_CNT_DET_EFICACIA_SEMANA where SEMANA_ID = semana;
    commit;

    insert into H_CNT_DET_EFICACIA_SEMANA
         (SEMANA_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS
        )
    select SEMANA_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS 
    from TMP_H_CNT_DET_EFICACIA  
    where SEMANA_ID = semana;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_EFICACIA_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_SEMANA_IX'', ''H_CNT_DET_EFICACIA_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_SEMANA. Termina semana: '||TO_CHAR(semana), 3;

  end loop C_SEMANAS_LOOP;
close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_SEMANA. Termina bucle', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_EFICACIA_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_MES. Empieza bucle', 3;

  merge into TMP_FECHA dc
  using (select MES_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.MES_H = cf.MES_ID;
  commit;

  merge into TMP_FECHA_AUX dc
  using (select MES_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_AUX)
  when matched then update set dc.MES_AUX = cf.MES_ID;
  commit;

  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;
    exit when c_mes%NOTFOUND;

    --Nos quedamos con la fecha cargada más reciente en H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO <= a la fecha a cargar
	select MAX(MES_H) into mes_relleno from TMP_FECHA where MES_H <= mes;
	--Nos quedamos con la fecha cargada más reciente en H_CNT anterior a la fecha de H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO
	select MAX(MES_AUX) into mes_periodo_ant from TMP_FECHA_AUX where MES_AUX < mes_relleno;
	--fecha carga datos
	select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_MES. Empieza mes: '||TO_CHAR(mes), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_MES. mes relleno: '||TO_CHAR(mes_relleno), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_MES. mes ant relleno: '||TO_CHAR(mes_periodo_ant), 3;
	
    -- Borrando indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_EFICACIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT_DET_EFICACIA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Truncado de tabla y borrado de índices', 4;

    -- Stock inicial. Periodo n-1
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_EFICACIA
         (MES_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || mes || ''' MES_ID,
         CONTRATO_ID,
         ESQUEMA_CONTRATO_ID,
         AGENCIA_CONTRATO_ID,
         SUBCARTERA_EXPEDIENTE_CNT_ID,
         sum(DEUDA_IRREGULAR),
		  0,
		  0  
    from  H_CNT_MES
    where MES_ID = ''' || mes_periodo_ant || ''' and ENVIADO_AGENCIA_CNT_ID = 1 and ESQUEMA_CONTRATO_ID is not null and AGENCIA_CONTRATO_ID is not null and SUBCARTERA_EXPEDIENTE_CNT_ID is not null
    group by MES_ID, CONTRATO_ID, ESQUEMA_CONTRATO_ID, AGENCIA_CONTRATO_ID, SUBCARTERA_EXPEDIENTE_CNT_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;	

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Stock inicial. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Entradas. Periodo n. Nota: cambiar POSICION_VENCIDA_CICLO_REC por DEUDA_IRREGULAR_CICLO_REC cuando tenga valores
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_EFICACIA
         (MES_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || mes || ''' MES_ID,
         CONTRATO_ID,
         ESQUEMA_CR_ID,
         AGENCIA_CR_ID,
         SUBCARTERA_CR_ID,
         0,
		 sum(POSICION_VENCIDA_CICLO_REC),
		 0 
    from  H_CNT_DET_CICLO_REC_MES
    where MES_ID = ''' || mes_relleno || ''' and FECHA_BAJA_CICLO_REC is null and ENVIADO_AGENCIA_CR_ID = 1 and ESQUEMA_CR_ID is not null and AGENCIA_CR_ID is not null and SUBCARTERA_CR_ID is not null
    group by MES_ID, CONTRATO_ID, ESQUEMA_CR_ID, AGENCIA_CR_ID, SUBCARTERA_CR_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Entradas. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
	-- Cobros. Periodo n.
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_EFICACIA
         (MES_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || mes || ''' MES_ID,
         CONTRATO_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         0,
		 0,
		 sum(IMPORTE_COBRO)
    from  H_CNT_DET_COBRO_MES
    where MES_ID = ''' || mes_relleno || ''' and ENVIADO_AGENCIA_COBRO_ID = 1 and TIPO_COBRO_DET_ID in (409, 410, 415, 416) AND COBRO_FACTURADO_ID = 1
		and ESQUEMA_COBRO_ID is not null and AGENCIA_COBRO_ID is not null and SUBCARTERA_COBRO_ID is not null
    group by MES_ID, CONTRATO_ID, ESQUEMA_COBRO_ID, AGENCIA_COBRO_ID, SUBCARTERA_COBRO_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Cobros. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

	
    -- FECHA_CARGA_DATOS periodo n. Coger la FECHA_CARGA_DATOS de las entradas que acabamos de insertar. H_CNT_DET_CICLO_REC_MES (semana, mes...)
    update TMP_H_CNT_DET_EFICACIA set FECHA_CARGA_DATOS = max_dia_mes;
    commit;
    
    -- Crear indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_EFICACIA_IX'', ''TMP_H_CNT_DET_EFICACIA (MES_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrando indices H_CNT_DET_EFICACIA_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_EFICACIA_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado del día a insertar
    delete from H_CNT_DET_EFICACIA_MES where MES_ID = mes;
    commit;

    insert into H_CNT_DET_EFICACIA_MES
         (MES_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS
        )
    select MES_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS 
    from TMP_H_CNT_DET_EFICACIA  
    where MES_ID = mes;
    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_EFICACIA_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_MES_IX'', ''H_CNT_DET_EFICACIA_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_MES. Termina mes: '||TO_CHAR(mes), 3;


  end loop C_MESES_LOOP;
  close c_mes;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_MES. Termina bucle', 3;


-- ----------------------------------------------------------------------------------------------
--                                     H_CNT_DET_EFICACIA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_TRIMESTRE. Empieza bucle', 3;

  merge into TMP_FECHA dc
  using (select TRIMESTRE_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.TRIMESTRE_H = cf.TRIMESTRE_ID;
  commit;

  merge into TMP_FECHA_AUX dc
  using (select TRIMESTRE_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_AUX)
  when matched then update set dc.TRIMESTRE_AUX = cf.TRIMESTRE_ID;
  commit;

  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;
    exit when c_trimestre%NOTFOUND;

  	--Nos quedamos con la fecha cargada más reciente en H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO <= a la fecha a cargar
	select MAX(TRIMESTRE_H) into trimestre_relleno from TMP_FECHA where TRIMESTRE_H <= trimestre;
	--Nos quedamos con la fecha cargada más reciente en H_CNT anterior a la fecha de H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO
	select MAX(TRIMESTRE_AUX) into trimestre_periodo_ant from TMP_FECHA_AUX where TRIMESTRE_AUX < trimestre_relleno;
	--fecha carga datos
	select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_TRIMESTRE. Empieza trimestre: '||TO_CHAR(trimestre), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_TRIMESTRE. trimestre relleno: '||TO_CHAR(trimestre_relleno), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_TRIMESTRE. trimestre ant relleno: '||TO_CHAR(trimestre_periodo_ant), 3;
  
    -- Borrando indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_EFICACIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT_DET_EFICACIA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Truncado de tabla y borrado de índices', 4;

    -- Stock inicial. Periodo n-1
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (TRIMESTRE_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || trimestre || ''' TRIMESTRE_ID,
         CONTRATO_ID,
         ESQUEMA_CONTRATO_ID,
         AGENCIA_CONTRATO_ID,
         SUBCARTERA_EXPEDIENTE_CNT_ID,
         sum(DEUDA_IRREGULAR),
		  0,
		  0  
    from  H_CNT_TRIMESTRE
    where TRIMESTRE_ID = ''' || trimestre_periodo_ant || ''' and ENVIADO_AGENCIA_CNT_ID = 1 and ESQUEMA_CONTRATO_ID is not null and AGENCIA_CONTRATO_ID is not null and SUBCARTERA_EXPEDIENTE_CNT_ID is not null
    group by TRIMESTRE_ID, CONTRATO_ID, ESQUEMA_CONTRATO_ID, AGENCIA_CONTRATO_ID, SUBCARTERA_EXPEDIENTE_CNT_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;	
	
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Stock inicial. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Entradas. Periodo n. Nota: cambiar POSICION_VENCIDA_CICLO_REC por DEUDA_IRREGULAR_CICLO_REC cuando tenga valores
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (TRIMESTRE_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || trimestre || ''' TRIMESTRE_ID,
         CONTRATO_ID,
         ESQUEMA_CR_ID,
         AGENCIA_CR_ID,
         SUBCARTERA_CR_ID,
         0,
		 sum(POSICION_VENCIDA_CICLO_REC),
		 0 
    from  H_CNT_DET_CICLO_REC_TRIMESTRE
    where TRIMESTRE_ID = ''' || trimestre_relleno || ''' and FECHA_BAJA_CICLO_REC is null and ENVIADO_AGENCIA_CR_ID = 1 and ESQUEMA_CR_ID is not null and AGENCIA_CR_ID is not null and SUBCARTERA_CR_ID is not null
    group by TRIMESTRE_ID, CONTRATO_ID, ESQUEMA_CR_ID, AGENCIA_CR_ID, SUBCARTERA_CR_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Entradas. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
	
	-- Cobros. Periodo n.
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (TRIMESTRE_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || trimestre || ''' TRIMESTRE_ID,
         CONTRATO_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         0,
		 0,
		 sum(IMPORTE_COBRO)
    from  H_CNT_DET_COBRO_TRIMESTRE
    where TRIMESTRE_ID = ''' || trimestre_relleno || ''' and ENVIADO_AGENCIA_COBRO_ID = 1 and TIPO_COBRO_DET_ID in (409, 410, 415, 416) AND COBRO_FACTURADO_ID = 1
		and ESQUEMA_COBRO_ID is not null and AGENCIA_COBRO_ID is not null and SUBCARTERA_COBRO_ID is not null
    group by TRIMESTRE_ID, CONTRATO_ID, ESQUEMA_COBRO_ID, AGENCIA_COBRO_ID, SUBCARTERA_COBRO_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Cobros. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

	
    -- FECHA_CARGA_DATOS periodo n. Coger la FECHA_CARGA_DATOS de las entradas que acabamos de insertar. H_CNT_DET_CICLO_REC_TRIMESTRE (semana, trimestre...)
    update TMP_H_CNT_DET_EFICACIA set FECHA_CARGA_DATOS = max_dia_trimestre;
    commit;
    
    -- Crear indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_EFICACIA_IX'', ''TMP_H_CNT_DET_EFICACIA (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrando indices H_CNT_DET_EFICACIA_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_EFICACIA_TRI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- Borrado del día a insertar
    delete from H_CNT_DET_EFICACIA_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;

    insert into H_CNT_DET_EFICACIA_TRIMESTRE
         (TRIMESTRE_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS
        )
    select TRIMESTRE_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS 
    from TMP_H_CNT_DET_EFICACIA  
    where TRIMESTRE_ID = trimestre;
    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_EFICACIA_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_TRI_IX'', ''H_CNT_DET_EFICACIA_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_TRIMESTRE. Termina trimestre: '||TO_CHAR(trimestre), 3;

   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_TRIMESTRE. Termina bucle', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_EFICACIA_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_ANIO. Empieza bucle', 3;

  merge into TMP_FECHA dc
  using (select ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.ANIO_H = cf.ANIO_ID;
  commit;

  merge into TMP_FECHA_AUX dc
  using (select ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_AUX)
  when matched then update set dc.ANIO_AUX = cf.ANIO_ID;
  commit;

  -- Bucle que recorre los años
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;
    exit when c_anio%NOTFOUND;

   	--Nos quedamos con la fecha cargada más reciente en H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO <= a la fecha a cargar
	select MAX(ANIO_H) into anio_relleno from TMP_FECHA where ANIO_H <= anio;
	--Nos quedamos con la fecha cargada más reciente en H_CNT anterior a la fecha de H_CNT_DET_CICLO_REC, H_CNT_DET_COBRO
	select MAX(ANIO_AUX) into anio_periodo_ant from TMP_FECHA_AUX where ANIO_AUX < anio_relleno;
	--fecha carga datos
	select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_ANIO. Empieza anio: '||TO_CHAR(anio), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_ANIO. anio relleno: '||TO_CHAR(anio_relleno), 3;
	execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_ANIO. anio ant relleno: '||TO_CHAR(anio_periodo_ant), 3;

    -- Borrando indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_EFICACIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT_DET_EFICACIA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
	commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Truncado de tabla y borrado de índices', 4;

    -- Stock inicial. Periodo n-1
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (ANIO_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || anio || ''' ANIO_ID,
         CONTRATO_ID,
         ESQUEMA_CONTRATO_ID,
         AGENCIA_CONTRATO_ID,
         SUBCARTERA_EXPEDIENTE_CNT_ID,
         sum(DEUDA_IRREGULAR),
		  0,
		  0  
    from  H_CNT_ANIO
    where ANIO_ID = ''' || fecha_anterior || ''' and ENVIADO_AGENCIA_CNT_ID = 1 and ESQUEMA_CONTRATO_ID is not null and AGENCIA_CONTRATO_ID is not null and SUBCARTERA_EXPEDIENTE_CNT_ID is not null
    group by ANIO_ID, CONTRATO_ID, ESQUEMA_CONTRATO_ID, AGENCIA_CONTRATO_ID, SUBCARTERA_EXPEDIENTE_CNT_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;	
	
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Stock inicial. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Entradas. Periodo n. Nota: cambiar POSICION_VENCIDA_CICLO_REC por DEUDA_IRREGULAR_CICLO_REC cuando tenga valores
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (ANIO_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || anio || ''' ANIO_ID,
         CONTRATO_ID,
         ESQUEMA_CR_ID,
         AGENCIA_CR_ID,
         SUBCARTERA_CR_ID,
         0,
		 sum(POSICION_VENCIDA_CICLO_REC),
		 0 
    from  H_CNT_DET_CICLO_REC_ANIO
    where ANIO_ID = ''' || anio_relleno || ''' and FECHA_BAJA_CICLO_REC is null and ENVIADO_AGENCIA_CR_ID = 1 and ESQUEMA_CR_ID is not null and AGENCIA_CR_ID is not null and SUBCARTERA_CR_ID is not null
    group by ANIO_ID, CONTRATO_ID, ESQUEMA_CR_ID, AGENCIA_CR_ID, SUBCARTERA_CR_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Entradas. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
	
	-- Cobros. Periodo n.
    execute immediate 'insert  into TMP_H_CNT_DET_EFICACIA
         (ANIO_ID,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS,
		  ER_IMPORTE_COBRO
        )
     select ''' || anio || ''' ANIO_ID,
         CONTRATO_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         0,
		 0,
		 sum(IMPORTE_COBRO)
    from  H_CNT_DET_COBRO_ANIO
    where ANIO_ID = ''' || anio_relleno || ''' and ENVIADO_AGENCIA_COBRO_ID = 1 and TIPO_COBRO_DET_ID in (409, 410, 415, 416) AND COBRO_FACTURADO_ID = 1
		and ESQUEMA_COBRO_ID is not null and AGENCIA_COBRO_ID is not null and SUBCARTERA_COBRO_ID is not null
    group by ANIO_ID, CONTRATO_ID, ESQUEMA_COBRO_ID, AGENCIA_COBRO_ID, SUBCARTERA_COBRO_ID'; 
    V_ROWCOUNT := sql%rowcount;
    commit;   
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_EFICACIA. Cobros. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

	
    -- FECHA_CARGA_DATOS periodo n. Coger la FECHA_CARGA_DATOS de las entradas que acabamos de insertar. H_CNT_DET_CICLO_REC_ANIO (semana, anio...)
    update TMP_H_CNT_DET_EFICACIA set FECHA_CARGA_DATOS = max_dia_anio;
    commit;
    
    -- Crear indices TMP_H_CNT_DET_EFICACIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_EFICACIA_IX'', ''TMP_H_CNT_DET_EFICACIA (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrando indices H_CNT_DET_EFICACIA_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_EFICACIA_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado del día a insertar
    delete from H_CNT_DET_EFICACIA_ANIO where ANIO_ID = anio;
    commit;

    insert into H_CNT_DET_EFICACIA_ANIO
         (ANIO_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS
        )
    select ANIO_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          ESQUEMA_ER_ID,
          AGENCIA_ER_ID,
          SUBCARTERA_ER_ID,
          ER_IMPORTE_COBRO,
		  ER_DEUDA_IRREGULAR_STOCK_INI,
		  ER_DEUDA_IRREGULAR_ENTRADAS 
    from TMP_H_CNT_DET_EFICACIA  
    where ANIO_ID = anio;
    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices H_CNT_DET_EFICACIA_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_EFICACIA_ANIO_IX'', ''H_CNT_DET_EFICACIA_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_ANIO. Termina anio: '||TO_CHAR(anio), 3;

  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_EFICACIA_ANIO. Termina bucle', 3;
*/
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


  
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
    
end;

end CARGAR_H_CNT_DET_EFICACIA;
create or replace PROCEDURE CARGAR_H_CNT_DET_ACUERD_SOL (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Gonzalo Mart?n, PFS Group
-- Fecha creaci?n: Mayo 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Cajamar
--
-- Descripci?n: Procedimiento almancenado que carga las tablas hechos H_CNT_DET_ACUERD_SOL.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracaci?n de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_CONTRATO';
  V_ROWCOUNT NUMBER;
  
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
  max_dia_carga date;
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  V_SQL varchar2(16000);
  
  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA ORDER BY 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1; 

-- --------------------------------------------------------------------------------
-- DEFINICI?N DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  INSERT_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

BEGIN

-- ----------------------------------------------------------------------------------------------
--                                     H_CNT_DET_ACUERD_SOL
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    ---------------------- CARGA ACUERDOS ----------------------    
    -- Borrando indices TMP_CNT_DET_ACUERD_SOL
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_DET_ACUERD_SOL_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;    
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_DET_ACUERD_SOL'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_ACUERD_SOL. Truncado de tabla y borrado de ?ndices', 4;
    
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_CNT_DET_ACUERD_SOL 
         (DIA_ID,
          FECHA_CARGA_DATOS,
          ACUERDO_ID,
          CONTRATO_ID,
          SOL_PREVISTA_ID,
          FECHA_SOL_PREVISTA_CNT,        
          TIPO_SOL_PREVISTA_ID, 
          NUM_SOL_PREVISTA
        )
     select ''' || fecha || ''',
         ''' || fecha || ''',
         acu.ACU_ID,
         tec.CNT_ID,
		 ter.TEA_ID,
         TRUNC(ope.OP_FECHA_SOL_PREVISTA),
         NVL(ter.DD_TPA_ID, -1),
         1
    from  ' || V_DATASTAGE || '.ACU_ACUERDO_PROCEDIMIENTOS acu,  ' || V_DATASTAGE || '.TEA_CNT tec,  ' || V_DATASTAGE || '.TEA_TERMINOS_ACUERDO ter, ' || V_DATASTAGE || '.ACU_OPERACIONES_TERMINOS ope
    where acu.BORRADO = 0 and tec.BORRADO = 0 and TRUNC(ACU_FECHA_PROPUESTA)<=''' || fecha || ''' and acu.ACU_ID = ter.ACU_ID and ter.BORRADO = 0 and tec.tea_id = ter.tea_id and ter.TEA_ID = ope.TEA_ID and ope.BORRADO = 0';
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_ACUERD_SOL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
    
    -- Crear indices TMP_CNT_DET_ACUERD_SOL    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_DET_ACUERD_SOL_IX'', ''TMP_CNT_DET_ACUERD_SOL (DIA_ID, FECHA_SOL_PREVISTA_CNT, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrando indices H_CNT_DET_ACUERD_SOL
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_ACUERD_SOL_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
    -- Borrado del d?a a insertar
    delete from H_CNT_DET_ACUERD_SOL where DIA_ID = fecha;
    commit;
    
    insert into H_CNT_DET_ACUERD_SOL
         (DIA_ID,
          FECHA_CARGA_DATOS,
          ACUERDO_ID,
          CONTRATO_ID,
          SOL_PREVISTA_ID,
          FECHA_SOL_PREVISTA_CNT,        
          TIPO_SOL_PREVISTA_ID, 
          NUM_SOL_PREVISTA
        )
    select DIA_ID,
          FECHA_CARGA_DATOS,
          ACUERDO_ID,
          CONTRATO_ID,
          SOL_PREVISTA_ID,
          FECHA_SOL_PREVISTA_CNT,        
          TIPO_SOL_PREVISTA_ID, 
          NUM_SOL_PREVISTA
    from TMP_CNT_DET_ACUERD_SOL  where DIA_ID = fecha; 
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
    end loop;
  close c_fecha;  
  

  -- Crear indices H_CNT_DET_ACUERD_SOL   
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERD_SOL_IX'', ''H_CNT_DET_ACUERD_SOL (DIA_ID, FECHA_SOL_PREVISTA_CNT, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- -------------------------- C?LCULO DEL RESTO DE PERIODOS ----------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_CNT_DET_ACUERD_SOL;
  commit;
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_ACUERD_SOL_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_CNT_DET_ACUERD_SOL_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) select max(SEMANA_ID) from H_CNT_DET_ACUERD_SOL_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
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
    
    -- Borrado indices H_CNT_DET_ACUERD_SOL_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_ACUERD_SOL_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    
    -- Borrado de las semanas a insertar
    delete from H_CNT_DET_ACUERD_SOL_SEMANA where SEMANA_ID = semana;
    commit;
    
    insert into H_CNT_DET_ACUERD_SOL_SEMANA
        ( SEMANA_ID,
          FECHA_CARGA_DATOS,
          ACUERDO_ID,
          CONTRATO_ID,
          SOL_PREVISTA_ID,
          FECHA_SOL_PREVISTA_CNT,        
          TIPO_SOL_PREVISTA_ID, 
          NUM_SOL_PREVISTA
       )
    select semana,  
          max_dia_semana,
          ACUERDO_ID,
          CONTRATO_ID,
          SOL_PREVISTA_ID,
          FECHA_SOL_PREVISTA_CNT,        
          TIPO_SOL_PREVISTA_ID, 
          NUM_SOL_PREVISTA
    from H_CNT_DET_ACUERD_SOL where DIA_ID = max_dia_semana;
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    -- Crear indices H_CNT_DET_ACUERD_SOL_SEMANA          
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERD_SOL_SEMANA_IX'', ''H_CNT_DET_ACUERD_SOL_SEMANA (SEMANA_ID, FECHA_SOL_PREVISTA_CNT, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
   
  end loop C_SEMANAS_LOOP;
close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_SEMANA. Termina bucle', 3;
*/   
   
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_ACUERD_SOL_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_MES. Empieza bucle', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_CNT_DET_ACUERD_SOL_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
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

    -- Borrado indices H_CNT_DET_ACUERD_SOL_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_ACUERD_SOL_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de los meses a insertar
    delete from H_CNT_DET_ACUERD_SOL_MES where MES_ID = mes;
    commit;
    
    insert into H_CNT_DET_ACUERD_SOL_MES
        (MES_ID,
        FECHA_CARGA_DATOS,
        ACUERDO_ID,
        CONTRATO_ID,
        SOL_PREVISTA_ID,
        FECHA_SOL_PREVISTA_CNT,        
        TIPO_SOL_PREVISTA_ID, 
        NUM_SOL_PREVISTA
       )
    select mes,    
        max_dia_mes,
        ACUERDO_ID,
        CONTRATO_ID,
        SOL_PREVISTA_ID,
        FECHA_SOL_PREVISTA_CNT,        
        TIPO_SOL_PREVISTA_ID, 
        NUM_SOL_PREVISTA
    from H_CNT_DET_ACUERD_SOL where DIA_ID = max_dia_mes;
    commit;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_CNT_DET_ACUERD_SOL_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERD_SOL_MES_IX'', ''H_CNT_DET_ACUERD_SOL_MES (MES_ID, FECHA_SOL_PREVISTA_CNT, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

  end loop C_MESES_LOOP;
  close c_mes;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_MES. Termina bucle', 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_ACUERD_SOL_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_CNT_DET_ACUERD_SOL_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
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

    -- Borrado indices H_CNT_DET_ACUERD_SOL_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_ACUERD_SOL_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    
    -- Borrado de los trimestres a insertar
    delete from H_CNT_DET_ACUERD_SOL_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;
    
    insert into H_CNT_DET_ACUERD_SOL_TRIMESTRE
        (TRIMESTRE_ID,
        FECHA_CARGA_DATOS,
        ACUERDO_ID,
        CONTRATO_ID,
        SOL_PREVISTA_ID,
        FECHA_SOL_PREVISTA_CNT,        
        TIPO_SOL_PREVISTA_ID, 
        NUM_SOL_PREVISTA
       )
    select trimestre,    
        max_dia_trimestre,
        ACUERDO_ID,
        CONTRATO_ID,
        SOL_PREVISTA_ID,
        FECHA_SOL_PREVISTA_CNT,        
        TIPO_SOL_PREVISTA_ID, 
        NUM_SOL_PREVISTA
    from H_CNT_DET_ACUERD_SOL where DIA_ID = max_dia_trimestre;
    commit;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_CNT_DET_ACUERD_SOL_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERD_SOL_TRIMESTRE_IX'', ''H_CNT_DET_ACUERD_SOL_TRIMESTRE (TRIMESTRE_ID, FECHA_SOL_PREVISTA_CNT, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
            
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_TRIMESTRE. Termina bucle', 3;
*/   
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_ACUERD_SOL_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_CNT_DET_ACUERD_SOL_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
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
  
  -- Bucle que recorre los a?os
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
    select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;
        
    -- Borrado indices H_CNT_DET_ACUERD_SOL_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_ACUERD_SOL_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de loa a?os a insertar
    delete from H_CNT_DET_ACUERD_SOL_ANIO where ANIO_ID = anio;
    commit;
    
    insert into H_CNT_DET_ACUERD_SOL_ANIO
        (ANIO_ID,
        FECHA_CARGA_DATOS,
        ACUERDO_ID,
        CONTRATO_ID,
        SOL_PREVISTA_ID,
        FECHA_SOL_PREVISTA_CNT,        
        TIPO_SOL_PREVISTA_ID, 
        NUM_SOL_PREVISTA
       )
    select anio,    
        max_dia_anio,
        ACUERDO_ID,
        CONTRATO_ID,
        SOL_PREVISTA_ID,
        FECHA_SOL_PREVISTA_CNT,        
        TIPO_SOL_PREVISTA_ID, 
        NUM_SOL_PREVISTA
    from H_CNT_DET_ACUERD_SOL where DIA_ID = max_dia_anio;
    commit;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_CNT_DET_ACUERD_SOL_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_ACUERD_SOL_ANIO_IX'', ''H_CNT_DET_ACUERD_SOL_ANIO (ANIO_ID, FECHA_SOL_PREVISTA_CNT, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_ACUERD_SOL_ANIO. Termina bucle', 3;
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
    O_ERROR_STATUS := 'N?mero de par?metros incorrecto';
    --ROLLBACK;    
  when OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;   
    */
end;

end CARGAR_H_CNT_DET_ACUERD_SOL;
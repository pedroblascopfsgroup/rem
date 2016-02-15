create or replace PROCEDURE CARGAR_H_PRC_DET_COBRO(DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creación: Julio 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 24/11/2015
-- Motivos del cambio: USUARIO PROPIETARIO
-- Cliente: Recovery BI PRODUCTO
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_PRC_DET_COBRO.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PRC_DET_COBRO';
  V_ROWCOUNT NUMBER;
  
  V_NUM_ROW NUMBER(10);

   V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  nCount NUMBER;


   V_SQL VARCHAR2(16000);

   formato_fecha VARCHAR2(100);

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
  min_dia_cobro date;
  max_dia_cobro date;
  f_cobro date;
  fecha_incidencia230615 date;
  
  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_ID from D_F_DIA where DIA_ID  between min_dia_cobro and max_dia_cobro order by 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between min_dia_cobro and max_dia_cobro order by 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro order by 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between min_dia_cobro and max_dia_cobro order by 1;
  

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
--                                      H_PRC_DET_COBRO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  	select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
    select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';
      
  fecha_incidencia230615 := '28/05/2015';    
  
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, ' H_PRC_DET_COBRO. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
 -- ---------------------- Cobros nuevos ----------------------
    -- Borrado indices TMP_H_PRC_DET_COBRO


    	   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRC_DET_COBRO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;		
     commit;    
       
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRC_DET_COBRO'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;  
      
      
  execute immediate 'INSERT
INTO TMP_H_PRC_DET_COBRO
  (
    DIA_ID,
    FECHA_CARGA_DATOS,
    PROCEDIMIENTO_ID,
    ASUNTO_ID,
    CONTRATO_ID,
    COBRO_ID,
    FECHA_COBRO,
    FECHA_ASUNTO,
    TIPO_COBRO_DETALLE_ID,
    NUM_COBROS,
    IMPORTE_COBRO,
    NUM_DIAS_CREACION_ASU_COBRO
  )
 select distinct
  cnt.DIA_ID,
  cnt.FECHA_CARGA_DATOS,
  prc.PROCEDIMIENTO_ID,
  prc.ASUNTO_ID,
  cnt.CONTRATO_ID,
  cnt.COBRO_ID,
  cnt.FECHA_COBRO,
  prc.FECHA_CREACION_ASUNTO as FECHA_ASUNTO,
  cnt.TIPO_COBRO_DET_ID as TIPO_COBRO_DETALLE_ID,
  cnt.NUM_COBROS,
  cnt.IMPORTE_COBRO,
  (cnt.FECHA_COBRO -prc.FECHA_CREACION_ASUNTO) as NUM_DIAS_CREACION_ASU_COBRO
from 
   H_PRC prc  JOIN H_PRC_DET_CONTRATO c  on c.PROCEDIMIENTO_ID=prc.PROCEDIMIENTO_ID
  JOIN H_CNT_DET_COBRO cnt on cnt.CONTRATO_ID=c.CONTRATO_ID  
  where  prc.dia_id= ''' || fecha || ''' and prc.DIA_ID=c.DIA_ID and FECHA_COBRO <= ''' || fecha || ''' and cnt.COBRO_ID not in (select cobro_id from H_PRC_DET_COBRO)';

 V_ROWCOUNT := sql%rowcount;     
    commit;
      
 --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRC_DET_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
     -- Crear indices TMP_H_PRC_DET_COBRO


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_DET_COBRO_IX'', ''TMP_H_PRC_DET_COBRO (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    

   -- Borrado indices H_PRC_DET_COBRO


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_COBRO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;		
     commit;        
      
  delete from H_PRC_DET_COBRO where DIA_ID =fecha;
    commit;  
    
  INSERT
  INTO H_PRC_DET_COBRO
  (
    DIA_ID,
    FECHA_CARGA_DATOS,
    PROCEDIMIENTO_ID,
    ASUNTO_ID,
    CONTRATO_ID,
    FECHA_COBRO,
    FECHA_ASUNTO,
    TIPO_COBRO_DETALLE_ID,
    NUM_COBROS,
    IMPORTE_COBRO,
    NUM_DIAS_CREACION_ASU_COBRO,
    COBRO_ID
  )
 select DIA_ID,
    FECHA_CARGA_DATOS,
    PROCEDIMIENTO_ID,
    ASUNTO_ID,
    CONTRATO_ID,
    FECHA_COBRO,
    FECHA_ASUNTO,
    TIPO_COBRO_DETALLE_ID,
    NUM_COBROS,
    IMPORTE_COBRO,
    NUM_DIAS_CREACION_ASU_COBRO,
    COBRO_ID
    from TMP_H_PRC_DET_COBRO;
 
  V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO (Cobros nuevos). Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
 
 end loop;
  close c_fecha;
  
  
       -- Crear indices H_PRC_DET_COBRO
       


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_IX'', ''H_PRC_DET_COBRO (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- -------------------------- CÁLCULO DEL RESTO DE PERIODOS ----------------------------
    
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	 
  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_PRC where DIA_ID<=fecha;
  commit;
  
  select max(DIA_ID) into max_dia_cobro from H_PRC where DIA_ID<=fecha ;  
  min_dia_cobro := max_dia_cobro;  
    
    
  -- ----------------------------------------------------------------------------------------------
--                                      H_PRC_DET_COBRO_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_SEMANA. Empieza bucle', 3;
 
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  
  -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
  select max(SEMANA_ID) into V_NUMBER from H_PRC_DET_COBRO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PRC_DET_COBRO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
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
     
    -- Borrado indices H_PRC_DET_COBRO_SEMANA


    	   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_COBRO_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	
    commit;
    
    -- Borrado de las semanas a insertar
    delete from H_PRC_DET_COBRO_SEMANA where SEMANA_ID = semana;
    commit;
    
     INSERT
INTO H_PRC_DET_COBRO_SEMANA
  (
    SEMANA_ID,
    FECHA_CARGA_DATOS,
    PROCEDIMIENTO_ID,
    ASUNTO_ID,
    CONTRATO_ID,
    FECHA_COBRO,
    FECHA_ASUNTO,
    TIPO_COBRO_DETALLE_ID,
    NUM_COBROS,
    IMPORTE_COBRO,
    NUM_DIAS_CREACION_ASU_COBRO,
    COBRO_ID
  )
  
 SELECT 
  semana,    
  max_dia_semana,
  PROCEDIMIENTO_ID,
  ASUNTO_ID,
  CONTRATO_ID,
  FECHA_COBRO,
  FECHA_ASUNTO,
  TIPO_COBRO_DETALLE_ID,
  NUM_COBROS,
  IMPORTE_COBRO,
  NUM_DIAS_CREACION_ASU_COBRO,
  COBRO_ID
FROM H_PRC_DET_COBRO
where (FECHA_COBRO between min_dia_semana and max_dia_semana);

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
  --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
     
    -- Crear indices H_PRC_DET_COBRO_SEMANA


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_SEMANA_IX'', ''H_PRC_DET_COBRO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
    
  end loop C_SEMANAS_LOOP;
close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_SEMANA. Termina bucle', 3; 
    
    -- ----------------------------------------------------------------------------------------------
--                                     H_PRC_DET_COBRO_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_MES. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)



  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  
   -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
   select max(MES_ID) into V_NUMBER from H_PRC_DET_COBRO_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
    if(V_NUMBER) is not null then
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PRC_DET_COBRO_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  end if;
  commit;
  
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
      
      -- Borrado indices H_PRC_DET_COBRO_MES


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_COBRO_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;		
    
      -- Borrado de los meses a insertar
      delete from H_PRC_DET_COBRO_MES where MES_ID = mes;
      commit;
      
       INSERT
INTO H_PRC_DET_COBRO_MES
  (
    MES_ID,
    FECHA_CARGA_DATOS,
    PROCEDIMIENTO_ID,
    ASUNTO_ID,
    CONTRATO_ID,
    FECHA_COBRO,
    FECHA_ASUNTO,
    TIPO_COBRO_DETALLE_ID,
    NUM_COBROS,
    IMPORTE_COBRO,
    NUM_DIAS_CREACION_ASU_COBRO,
    COBRO_ID
  )
   
 SELECT  mes,    
         max_dia_mes,
  PROCEDIMIENTO_ID,
  ASUNTO_ID,
  CONTRATO_ID,
  FECHA_COBRO,
  FECHA_ASUNTO,
  TIPO_COBRO_DETALLE_ID,
  NUM_COBROS,
  IMPORTE_COBRO,
  NUM_DIAS_CREACION_ASU_COBRO,
  COBRO_ID
  FROM H_PRC_DET_COBRO
    where (FECHA_COBRO between min_dia_mes and max_dia_mes);  

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
       --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_PRC_DET_COBRO_MES


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_MES_IX'', ''H_PRC_DET_COBRO_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
      
  end loop C_MESES_LOOP;
  
  close c_mes;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_MES. Termina bucle', 3;  
   
  
  -- ----------------------------------------------------------------------------------------------
--                                      H_PRC_DET_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)



  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
  select max(TRIMESTRE_ID) into V_NUMBER from H_PRC_DET_COBRO_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
      if(V_NUMBER) is not null then
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PRC_DET_COBRO_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  end if;
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

      -- Borrado indices H_PRC_DET_COBRO_TRIMESTRE


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_COBRO_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;		
      commit;
      
      -- Borrado de los trimestres a insertar
      delete from H_PRC_DET_COBRO_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;
      
      INSERT
INTO H_PRC_DET_COBRO_TRIMESTRE
  (
    TRIMESTRE_ID,
    FECHA_CARGA_DATOS,
    PROCEDIMIENTO_ID,
    ASUNTO_ID,
    CONTRATO_ID,
    FECHA_COBRO,
    FECHA_ASUNTO,
    TIPO_COBRO_DETALLE_ID,
    NUM_COBROS,
    IMPORTE_COBRO,
    NUM_DIAS_CREACION_ASU_COBRO,
    COBRO_ID
  )
 
 SELECT trimestre,
  max_dia_trimestre,
  PROCEDIMIENTO_ID,
  ASUNTO_ID,
  CONTRATO_ID,
  FECHA_COBRO,
  FECHA_ASUNTO,
  TIPO_COBRO_DETALLE_ID,
  NUM_COBROS,
  IMPORTE_COBRO,
  NUM_DIAS_CREACION_ASU_COBRO,
  COBRO_ID
FROM H_PRC_DET_COBRO 
 where (FECHA_COBRO between min_dia_trimestre and max_dia_trimestre);
 
  V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      
      -- Crear indices H_PRC_DET_COBRO_TRIMESTRE


       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_TRIMESTRE_IX'', ''H_PRC_DET_COBRO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;    
    
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_TRIMESTRE. Termina bucle', 3;
  
  
  
  
  -- ----------------------------------------------------------------------------------------------
--                                      H_PRC_DET_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)



  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
     select max(ANIO_ID) into V_NUMBER from H_PRC_DET_COBRO_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
      if(V_NUMBER) is not null then
   
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PRC_DET_COBRO_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
 end if;
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
    
      -- Borrado indices H_PRC_DET_COBRO_ANIO


     	   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_COBRO_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;		
      commit;
      
      -- Borrado de los años a insertar
      delete from H_PRC_DET_COBRO_ANIO where ANIO_ID = anio;
      commit;
  
  
  INSERT
INTO H_PRC_DET_COBRO_ANIO
  (
    ANIO_ID,
    FECHA_CARGA_DATOS,
    PROCEDIMIENTO_ID,
    ASUNTO_ID,
    CONTRATO_ID,
    FECHA_COBRO,
    FECHA_ASUNTO,
    TIPO_COBRO_DETALLE_ID,
    NUM_COBROS,
    IMPORTE_COBRO,
    NUM_DIAS_CREACION_ASU_COBRO,
    COBRO_ID
  )
 SELECT  ANIO,  
         MAX_DIA_ANIO,
  PROCEDIMIENTO_ID,
  ASUNTO_ID,
  CONTRATO_ID,
  FECHA_COBRO,
  FECHA_ASUNTO,
  TIPO_COBRO_DETALLE_ID,
  NUM_COBROS,
  IMPORTE_COBRO,
  NUM_DIAS_CREACION_ASU_COBRO,
  COBRO_ID
FROM H_PRC_DET_COBRO 
 where (FECHA_COBRO between min_dia_anio and max_dia_anio);
 
    V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      
        -- Crear indices H_PRC_DET_COBRO_ANIO


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_COBRO_ANIO_IX'', ''H_PRC_DET_COBRO_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;       
    
  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_DET_COBRO_ANIO. Termina bucle', 3;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    end;
END CARGAR_H_PRC_DET_COBRO;
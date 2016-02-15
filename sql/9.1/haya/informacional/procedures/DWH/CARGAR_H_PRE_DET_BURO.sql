create or replace PROCEDURE CARGAR_H_PRE_DET_BURO(DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 13/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_PRE_DET_BURO.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PRE_DET_BURO';
  V_ROWCOUNT NUMBER;
  
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  V_SQL VARCHAR2(16000);
  nCount NUMBER;

  formato_fecha VARCHAR(25) := 'DD/MM/YY';

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

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA ORDER BY 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1; 
  

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  insert_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(insert_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);
  
  BEGIN
-- ----------------------------------------------------------------------------------------------
--                                     H_PRE_DET_BURO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2; 
 select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3; 
    
    -- Borrando indices TMP_H_PRE_DET_BURO
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRE_DET_BURO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRE_DET_BURO_PER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRE_DET_BURO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_BURO. Truncado de tabla y borrado de indices', 4;

    execute immediate 'insert into TMP_H_PRE_DET_BURO 
                 (DIA_ID,
                  FECHA_CARGA_DATOS,
                  PROCEDIMIENTO_ID,
                  BUROFAX_ID,
                  ESTADO_BUROFAX_ID,
                  PERSONA_ID,
                  NUM_BUROFAX
                  )
          select  '''||fecha||''',
                  '''||fecha||''',
                  PRC_ID,
                  PCO_BUR_BUROFAX_ID,
                  nvl(DD_PCO_BFE_ID, -1),
                  PER_ID,
                  1
          from '||V_DATASTAGE||'.PCO_BUR_BUROFAX bur, '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS pco
          where bur.PCO_PRC_ID = pco.PCO_PRC_ID and bur.PCO_PRC_ID = pco.PCO_PRC_ID and trunc(bur.FECHACREAR) <= '''||fecha||''' and bur.BORRADO = 0';
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_BURO. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
    commit;
    
    -- Crear indices TMP_H_PRE_DET_BURO
    
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_BURO_IX'', ''TMP_H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;  

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_BURO_PER_IX'', ''TMP_H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;  
    
/* Mirar bien
    execute immediate'
     merge into TMP_H_PRE_DET_BURO BURO
          using (
          select PCO_BUR_BUROFAX_ID, MAX(DD_PCO_BFR_ID) MAXRESULT
          from '||V_DATASTAGE||'.PCO_BUR_ENVIO
          GROUP BY PCO_BUR_BUROFAX_ID) B
     ON (B.PCO_BUR_BUROFAX_ID = BURO.BUROFAX_ID)
     WHEN MATCHED THE UPDATE RESULTADO_BUROFAX_ID = B.MAXRESULT';      
     commit;  
  */
    -- Borrado del dia a insertar
    delete from H_PRE_DET_BURO where DIA_ID = fecha;
    commit;   
    
    -- Borrando indices H_PRE_DET_BURO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
            
    insert into H_PRE_DET_BURO
            (DIA_ID,
            FECHA_CARGA_DATOS,
            PROCEDIMIENTO_ID,
            BUROFAX_ID,
            ESTADO_BUROFAX_ID,
            RESULTADO_BUROFAX_ID,
            PERSONA_ID,
            NUM_BUROFAX
           )
     select DIA_ID,
            FECHA_CARGA_DATOS,
            PROCEDIMIENTO_ID,
            BUROFAX_ID,
            ESTADO_BUROFAX_ID,
            RESULTADO_BUROFAX_ID,
            PERSONA_ID,
            NUM_BUROFAX
     from TMP_H_PRE_DET_BURO where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;


    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3; 

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRE_DET_BURO_ENV_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRE_DET_BURO_ENV'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS; 

    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_BURO_ENV. Truncado de tabla y borrado de indices', 4;

    execute immediate 'insert into TMP_H_PRE_DET_BURO_ENV
                 (DIA_ID,
                  FECHA_CARGA_DATOS,
                  PROCEDIMIENTO_ID,
                  BUROFAX_ENVIO_ID,
                  BUROFAX_ID,
                  TIPO_BUROFAX_ENVIO_ID,
                  RESULTADO_BUROFAX_ENVIO_ID,
                  FECHA_SOLICITUD_BURO_ENV,
                  FECHA_ENVIO_BURO_ENV,
                  FECHA_ACUSE_BURO_ENV,
                  NUM_ENVIOS_BUROFAX,
                  P_BURO_SOLICITUD_ACUSE
                  )
          select   '''||fecha||''',
                   '''||fecha||''',
                   PRC_ID,
                   PCO_BUR_ENVIO_ID,
                   bur.PCO_BUR_BUROFAX_ID,
                   DD_PCO_BFT_ID,
                   DD_PCO_BFR_ID,
                   PCO_BUR_ENVIO_FECHA_SOLICITUD,
                   PCO_BUR_ENVIO_FECHA_ENVIO,
                   PCO_BUR_ENVIO_FECHA_ACUSO,
                   1,
                   trunc(PCO_BUR_ENVIO_FECHA_ACUSO)- trunc(PCO_BUR_ENVIO_FECHA_SOLICITUD)                  
          from '||V_DATASTAGE||'.PCO_BUR_BUROFAX bur, '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS pco, '||V_DATASTAGE||'.PCO_BUR_ENVIO env
          where bur.PCO_PRC_ID = pco.PCO_PRC_ID and bur.PCO_BUR_BUROFAX_ID = env.PCO_BUR_BUROFAX_ID
          and trunc(env.FECHACREAR) = '''||fecha||''' and env.BORRADO = 0';

    V_ROWCOUNT := sql%rowcount;     
    commit;  
  
     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_BURO_ENV. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;
    
    -- Crear indices TMP_H_PRE_DET_BURO_ENV
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_BURO_ENV_IX'', ''TMP_H_PRE_DET_BURO_ENV (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
    
    -- Borrado del dia a insertar
    delete from H_PRE_DET_BURO_ENV where DIA_ID = fecha;
    commit;   
            
    -- Borrando indices H_PRE_DET_BURO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_ENV_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

    insert into H_PRE_DET_BURO_ENV
        ( DIA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          BUROFAX_ENVIO_ID,
          BUROFAX_ID,
          TIPO_BUROFAX_ENVIO_ID,
          RESULTADO_BUROFAX_ENVIO_ID,
          FECHA_SOLICITUD_BURO_ENV,
          FECHA_ENVIO_BURO_ENV,
          FECHA_ACUSE_BURO_ENV,
          NUM_ENVIOS_BUROFAX,
          P_BURO_SOLICITUD_ACUSE
        )
    select DIA_ID,
            FECHA_CARGA_DATOS,
            PROCEDIMIENTO_ID,
            BUROFAX_ENVIO_ID,
            BUROFAX_ID,
            TIPO_BUROFAX_ENVIO_ID,
            RESULTADO_BUROFAX_ENVIO_ID,
            FECHA_SOLICITUD_BURO_ENV,
            FECHA_ENVIO_BURO_ENV,
            FECHA_ACUSE_BURO_ENV,
            NUM_ENVIOS_BUROFAX,
            P_BURO_SOLICITUD_ACUSE
    from TMP_H_PRE_DET_BURO_ENV where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;     
    commit;    

     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    commit;
    
    end loop;
  close c_fecha;  
  
  -- Crear indices H_PRE_DET_BURO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_IX'', ''H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_IX'', ''H_PRE_DET_BURO (DIA_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
  
  -- Crear indices H_PRE_DET_BURO_ENV
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_IX'', ''H_PRE_DET_BURO_ENV (DIA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 


-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_BURO_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_BURO_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PRE_DET_BURO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PRE_DET_BURO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_BURO;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  

  -- Borrado indices H_PRE_DET_BURO_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_PER_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
  
  -- Borrado indices H_PRE_DET_BURO_ENV_SEMANA
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_ENV_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
    
  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    -- Borrado de las semanas a insertar
    delete from H_PRE_DET_BURO_SEMANA where SEMANA_ID = semana;
    commit;

    insert into H_PRE_DET_BURO_SEMANA
        (
          SEMANA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          BUROFAX_ID,
          ESTADO_BUROFAX_ID,
          RESULTADO_BUROFAX_ID,
          PERSONA_ID,
          NUM_BUROFAX
        )
     select semana,
            max_dia_semana,
            PROCEDIMIENTO_ID,
            BUROFAX_ID,
            ESTADO_BUROFAX_ID,
            RESULTADO_BUROFAX_ID,
            PERSONA_ID,
            NUM_BUROFAX
    from H_PRE_DET_BURO where DIA_ID = max_dia_semana;

    V_ROWCOUNT := sql%rowcount;     
    commit;    
    
   --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_SEMANA. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    select min(DIA_H) into min_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    -- Borrado del dia a insertar
    delete from H_PRE_DET_BURO_ENV_SEMANA where SEMANA_ID = semana;
    commit;   
            
     insert into H_PRE_DET_BURO_ENV_SEMANA
        ( SEMANA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          BUROFAX_ENVIO_ID,
          BUROFAX_ID,
          TIPO_BUROFAX_ENVIO_ID,
          RESULTADO_BUROFAX_ENVIO_ID,
          FECHA_SOLICITUD_BURO_ENV,
          FECHA_ENVIO_BURO_ENV,
          FECHA_ACUSE_BURO_ENV,
          NUM_ENVIOS_BUROFAX,
          P_BURO_SOLICITUD_ACUSE
        )
     select semana,
            max_dia_semana,
            PROCEDIMIENTO_ID,
            BUROFAX_ENVIO_ID,
            BUROFAX_ID,
            TIPO_BUROFAX_ENVIO_ID,
            RESULTADO_BUROFAX_ENVIO_ID,
            FECHA_SOLICITUD_BURO_ENV,
            FECHA_ENVIO_BURO_ENV,
            FECHA_ACUSE_BURO_ENV,
            NUM_ENVIOS_BUROFAX,
            P_BURO_SOLICITUD_ACUSE
     from H_PRE_DET_BURO_ENV where (DIA_ID between min_dia_semana and max_dia_semana);

    V_ROWCOUNT := sql%rowcount;     
    commit;   

     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV_SEMANA. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV_SEMANA. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    commit;

  end loop C_SEMANAS_LOOP;
close c_semana;
  --Log_Proceso

  -- Crear indices H_PRE_DET_BURO_SEMANA      
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_SEMANA_IX'', ''H_PRE_DET_BURO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;   
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_SEMANA_IX'', ''H_PRE_DET_BURO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

  commit;  
  
  -- Crear indices H_PRE_DET_BURO_ENV_SEMANA      
  
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_SEMANA_IX'', ''H_PRE_DET_BURO_ENV_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;   


  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_SEMANA. Termina bucle', 3;   
    
    
-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_BURO_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_MES. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PRE_DET_BURO_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_BURO;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  

  -- Borrado indices H_PRE_DET_BURO_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_PER_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
  
  -- Borrado indices H_PRE_DET_BURO_ENV_MES
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_ENV_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;

  commit;  
    
  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
   
    -- Borrado de los meses a insertar
    delete from H_PRE_DET_BURO_MES where MES_ID = mes;
    commit;
    
    insert into H_PRE_DET_BURO_MES
              (
                MES_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                BUROFAX_ID,
                ESTADO_BUROFAX_ID,
                RESULTADO_BUROFAX_ID,
                PERSONA_ID,
                NUM_BUROFAX
        )
     select mes,
            max_dia_mes,
            PROCEDIMIENTO_ID,
            BUROFAX_ID,
            ESTADO_BUROFAX_ID,
            RESULTADO_BUROFAX_ID,
            PERSONA_ID,
            NUM_BUROFAX
    from H_PRE_DET_BURO where DIA_ID = max_dia_mes;

    V_ROWCOUNT := sql%rowcount;     
    commit;   
    
   --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_MES. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
    select min(DIA_H) into min_dia_mes from TMP_FECHA where MES_H = mes;
      
    -- Borrado del dia a insertar
    delete from H_PRE_DET_BURO_ENV_MES where MES_ID = mes;
    commit;   
            
    insert into H_PRE_DET_BURO_ENV_MES
        ( MES_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          BUROFAX_ENVIO_ID,
          BUROFAX_ID,
          TIPO_BUROFAX_ENVIO_ID,
          RESULTADO_BUROFAX_ENVIO_ID,
          FECHA_SOLICITUD_BURO_ENV,
          FECHA_ENVIO_BURO_ENV,
          FECHA_ACUSE_BURO_ENV,
          NUM_ENVIOS_BUROFAX,
          P_BURO_SOLICITUD_ACUSE
        )
     select mes,
            max_dia_mes,
            PROCEDIMIENTO_ID,
            BUROFAX_ENVIO_ID,
            BUROFAX_ID,
            TIPO_BUROFAX_ENVIO_ID,
            RESULTADO_BUROFAX_ENVIO_ID,
            FECHA_SOLICITUD_BURO_ENV,
            FECHA_ENVIO_BURO_ENV,
            FECHA_ACUSE_BURO_ENV,
            NUM_ENVIOS_BUROFAX,
            P_BURO_SOLICITUD_ACUSE
    from H_PRE_DET_BURO_ENV where DIA_ID between min_dia_mes and max_dia_mes;  

    V_ROWCOUNT := sql%rowcount;     
    commit;   

     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV_MES. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV_MES. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

  end loop C_MESES_LOOP;
  close c_mes;


  -- Crear indices H_PRE_DET_BURO_MES
  
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_MES_IX'', ''H_PRE_DET_BURO_MES (MES_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

  commit;    
 
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_MES_IX'', ''H_PRE_DET_BURO_MES (MES_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;    
  
  -- Crear indices H_PRE_DET_BURO_ENV_MES
  select count(*) into nCount from USER_INDEXES where INDEX_NAME = 'H_PRE_DET_BURO_ENV_MES_IX';  
  
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_MES_IX'', ''H_PRE_DET_BURO_ENV_MES (MES_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;    

  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_MES. Termina bucle', 3;   
  

  -- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_BURO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PRE_DET_BURO_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_BURO;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  -- Borrado indices H_PRE_DET_BURO_TRIMESTRE
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_PER_TRI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  -- Borrado indices H_PRE_DET_BURO_ENV_TRIMESTRE
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_ENV_TRIMEST_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
    
 -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    -- Borrado de los trimestres a insertar
    delete from H_PRE_DET_BURO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;  
    
    insert into H_PRE_DET_BURO_TRIMESTRE
              (
                TRIMESTRE_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                BUROFAX_ID,
                ESTADO_BUROFAX_ID,
                RESULTADO_BUROFAX_ID,
                PERSONA_ID,
                NUM_BUROFAX
              )
     select trimestre,
            max_dia_trimestre,
            PROCEDIMIENTO_ID,
            BUROFAX_ID,
            ESTADO_BUROFAX_ID,
            RESULTADO_BUROFAX_ID,
            PERSONA_ID,
            NUM_BUROFAX
     from H_PRE_DET_BURO where DIA_ID = max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;     
    commit;  
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_TRIMESTRE. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;
    
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
    select min(DIA_H) into min_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
      
-- Borrado del dia a insertar
    delete from H_PRE_DET_BURO_ENV_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;   
            
    insert into H_PRE_DET_BURO_ENV_TRIMESTRE
        ( TRIMESTRE_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          BUROFAX_ENVIO_ID,
          BUROFAX_ID,
          TIPO_BUROFAX_ENVIO_ID,
          RESULTADO_BUROFAX_ENVIO_ID,
          FECHA_SOLICITUD_BURO_ENV,
          FECHA_ENVIO_BURO_ENV,
          FECHA_ACUSE_BURO_ENV,
          NUM_ENVIOS_BUROFAX,
          P_BURO_SOLICITUD_ACUSE
        )
     select trimestre,
            max_dia_trimestre,
            PROCEDIMIENTO_ID,
            BUROFAX_ENVIO_ID,
            BUROFAX_ID,
            TIPO_BUROFAX_ENVIO_ID,
            RESULTADO_BUROFAX_ENVIO_ID,
            FECHA_SOLICITUD_BURO_ENV,
            FECHA_ENVIO_BURO_ENV,
            FECHA_ACUSE_BURO_ENV,
            NUM_ENVIOS_BUROFAX,
            P_BURO_SOLICITUD_ACUSE
     from H_PRE_DET_BURO_ENV where DIA_ID between min_dia_trimestre and max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;     
    commit;

     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV_TRIMESTRE. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
    
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

    -- Crear indices H_PRE_DET_ACUERDO_TRIMESTRE
   
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_TRIMESTRE_IX'', ''H_PRE_DET_BURO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;    
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_TRI_IX'', ''H_PRE_DET_BURO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;   
    
    -- Crear indices H_PRE_DET_BURO_ENV_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_TRIMEST_IX'', ''H_PRE_DET_BURO_ENV_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;    

  
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_TRIMESTRE. Termina bucle', 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_BURO_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PRE_DET_BURO_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_BURO;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
 
  -- Borrado indices H_PRE_DET_BURO_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_PER_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
      -- Borrado indices H_PRE_DET_BURO_ENV_ANIO
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_BURO_ENV_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
 
  -- Bucle que recorre los aios
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
        
    -- Borrado de loa aios a insertar
    delete from H_PRE_DET_BURO_ANIO where ANIO_ID = anio;
    commit;
  
    insert into H_PRE_DET_BURO_ANIO
              (
                ANIO_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                BUROFAX_ID,
                ESTADO_BUROFAX_ID,
                RESULTADO_BUROFAX_ID,
                PERSONA_ID,
                NUM_BUROFAX
              )
     select anio,
            max_dia_anio,
            PROCEDIMIENTO_ID,
            BUROFAX_ID,
            ESTADO_BUROFAX_ID,
            RESULTADO_BUROFAX_ID,
            PERSONA_ID,
            NUM_BUROFAX
     from H_PRE_DET_BURO  where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ANIO. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;
    
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
    select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;
      
-- Borrado del dia a insertar
    delete from H_PRE_DET_BURO_ENV_ANIO where ANIO_ID = anio;
    commit;   
            
     insert into H_PRE_DET_BURO_ENV_ANIO
        ( ANIO_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          BUROFAX_ENVIO_ID,
          BUROFAX_ID,
          TIPO_BUROFAX_ENVIO_ID,
          RESULTADO_BUROFAX_ENVIO_ID,
          FECHA_SOLICITUD_BURO_ENV,
          FECHA_ENVIO_BURO_ENV,
          FECHA_ACUSE_BURO_ENV,
          NUM_ENVIOS_BUROFAX,
          P_BURO_SOLICITUD_ACUSE
        )
     select anio,
            max_dia_anio,
            PROCEDIMIENTO_ID,
            BUROFAX_ENVIO_ID,
            BUROFAX_ID,
            TIPO_BUROFAX_ENVIO_ID,
            RESULTADO_BUROFAX_ENVIO_ID,
            FECHA_SOLICITUD_BURO_ENV,
            FECHA_ENVIO_BURO_ENV,
            FECHA_ACUSE_BURO_ENV,
            NUM_ENVIOS_BUROFAX,
            P_BURO_SOLICITUD_ACUSE
     from H_PRE_DET_BURO_ENV  where DIA_ID between min_dia_anio and max_dia_anio;

    V_ROWCOUNT := sql%rowcount;     
    commit;  

     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ENV_ANIO. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
    
  end loop C_ANIO_LOOP;
  close c_anio;

    -- Crear indices H_PRE_DET_BURO_TRIMESTRE
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ANIO_IX'', ''H_PRE_DET_BURO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 
   
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_PER_ANIO_IX'', ''H_PRE_DET_BURO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

    -- Crear indices H_PRE_DET_BURO_TRIMESTRE
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_BURO_ENV_ANIO_IX'', ''H_PRE_DET_BURO_ENV_ANIO (ANIO_ID, PROCEDIMIENTO_ID, BUROFAX_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_BURO_ANIO. Termina bucle', 3;
      
   --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;           
    end;
END CARGAR_H_PRE_DET_BURO;
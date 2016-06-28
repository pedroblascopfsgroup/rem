--/*
--##########################################
--## AUTOR=Maria V.
--## FECHA_CREACION=20160413
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2389
--## PRODUCTO=NO
--## 
--## Finalidad: Se  quita la carga de ARQUETIPO_PERSONA_ID en D_PER
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE CARGAR_H_PER_DET_ALERTA(DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Maria Villanueva, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 12/04/16
-- Motivos del cambio: Se cambia la carga de alertas
-- Cliente: Recovery BI Cajamar
--
-- Descripci�n: Procedimiento almancenado que carga las tablas hechos H_PER_DET_ALERTA.
-- ===============================================================================================
BEGIN
 DECLARE
-- ===============================================================================================
--                                                                      Declaracación de variables
-- ===============================================================================================
  v_num_row NUMBER(10);
  v_datastage  VARCHAR2(100);
  v_CM01     VARCHAR2(100);
  


  V_NUMBER  NUMBER(16,0);
  V_SQL    VARCHAR2(16000);

  max_dia_con_contratos date;
  min_dia_semana date;
  max_dia_semana date;
  min_dia_mes date;
  max_dia_mes date;
  min_dia_trimestre date;
  max_dia_trimestre date;
  min_dia_anio date;
  max_dia_anio date;
  max_dia_add_bi_h date;
  max_dia_add_bi date;
  max_dia_pre_start date;
  existe_date_start int;
  
  
  max_dia_carga date;
  dia_periodo_ant date;
  semana_periodo_ant int;
  mes_periodo_ant int;
  trimestre_periodo_ant int;
  anio_periodo_ant int;
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_rellenar date;
  
  
  max_dia_h date;
  max_dia_mov date;
  penult_dia_mov date;
  
  
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PER_DET_ALERTA';
  V_ROWCOUNT NUMBER;  
  nCount NUMBER;

  cursor c_fecha_rellenar is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_fecha is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA order by 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1; 
  
-- --------------------------------------------------------------------------------
-- DEFINICI�N DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  INSERT_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);  
  
  BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
      select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
        select valor into V_CM01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';
  -- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ALERTA
-- ----------------------------------------------------------------------------------------------
 -- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3; 

    ---------------------- CARGA ALERTAS ----------------------    
    -- Borrando indices TMP_H_PER_DET_ALERTA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ALERTA_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PER_DET_ALERTA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;
    
    execute immediate 'insert into TMP_H_PER_DET_ALERTA
            (
              DIA_ID,
              FECHA_CARGA_DATOS,
              PERSONA_ID,
              ALERTA_ID,
              CONTRATO_ID,
              TIPO_ALERTA_ID,
              CALIFICACION_ALERTA_ID,
              GESTION_ALERTA_ID,
              NUM_ALERTAS
            )
            select '''||fecha||''',
                   '''||fecha||''',
                   PER_ID,
                   ALE_ID,
                   CNT_ID,
                   nvl(TAL_ID, -1),
                   nvl(NGR_ID, -1),
                   -1,
                   1
            from '||V_DATASTAGE||'.ALE_ALERTAS 
            where TRUNC(ALE_FECHA_EXTRACCION)=(select max(TRUNC(ALE_FECHA_EXTRACCION)) from '||V_DATASTAGE||'.ALE_ALERTAS where  TRUNC(ALE_FECHA_EXTRACCION)<= '''||fecha||''')
                   and ALE_ACTIVO = 1 and BORRADO = 0';

    --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PER_DET_ALERTA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;   
    
    -- Crear indices TMP_H_PER_DET_ALERTA


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PER_DET_ALERTA_IX'', ''TMP_H_PER_DET_ALERTA (DIA_ID, PERSONA_ID, ALERTA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



      commit;    
      
      -- Borrando indices H_PER_DET_ALERTA
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ALERTA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
      
    -- Borrado del día a insertar
    delete from H_PER_DET_ALERTA where DIA_ID = fecha;
    commit;
      
    insert into H_PER_DET_ALERTA
      (
        DIA_ID,
        FECHA_CARGA_DATOS,
        PERSONA_ID,
        ALERTA_ID,
        CONTRATO_ID,
        TIPO_ALERTA_ID,
        CALIFICACION_ALERTA_ID,
        GESTION_ALERTA_ID,
        NUM_ALERTAS
      )
      select DIA_ID,
      FECHA_CARGA_DATOS,
      PERSONA_ID,
      ALERTA_ID,
      CONTRATO_ID,
      TIPO_ALERTA_ID,
      CALIFICACION_ALERTA_ID,
      GESTION_ALERTA_ID,
      NUM_ALERTAS
    from TMP_H_PER_DET_ALERTA where DIA_ID = fecha; 
      
    V_ROWCOUNT := sql%rowcount;     
    commit;
      
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
    end loop;
  close c_fecha;        
  
  -- Crear indices H_PER_DET_ALERTA


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_IX'', ''H_PER_DET_ALERTA (DIA_ID, PERSONA_ID, ALERTA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;   
  

-- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ALERTA_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_SEMANA. Empieza bucle', 3;
 
  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PER_DET_ALERTA_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PER_DET_ALERTA_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ALERTA;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
   
 -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    select min(DIA_H) into min_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    -- Borrado indices H_PER_DET_ALERTA_SEMANA
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ALERTA_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
    
    -- Borrado de las semanas a insertar
    delete from H_PER_DET_ALERTA_SEMANA where SEMANA_ID = semana;
    commit;  
      
      insert into H_PER_DET_ALERTA_SEMANA
      (
        SEMANA_ID,
        FECHA_CARGA_DATOS,
        PERSONA_ID,
        ALERTA_ID,
        CONTRATO_ID,
        TIPO_ALERTA_ID,
        CALIFICACION_ALERTA_ID,
        GESTION_ALERTA_ID,
        NUM_ALERTAS
      )
    select semana,  
        max_dia_semana,
        PERSONA_ID,
        ALERTA_ID,
        CONTRATO_ID,
        TIPO_ALERTA_ID,
        CALIFICACION_ALERTA_ID,
        GESTION_ALERTA_ID,
        NUM_ALERTAS
    from H_PER_DET_ALERTA where DIA_ID = max_dia_semana;    
      
      V_ROWCOUNT := sql%rowcount;     
    commit;
      
 --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    -- Crear indices H_PER_DET_ALERTA_SEMANA      


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_SEMANA_IX'', ''H_PER_DET_ALERTA_SEMANA (SEMANA_ID, PERSONA_ID, ALERTA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;   
   
      end loop C_SEMANAS_LOOP;
      close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_SEMANA. Termina bucle', 3;
      
-- ----------------------------------------------------------------------------------------------
--                                     H_PER_DET_ALERTA_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_MES. Empieza bucle', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PER_DET_ALERTA_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ALERTA;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);

  
 -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
      select min(DIA_H) into min_dia_mes from TMP_FECHA where MES_H = mes;

    -- Borrado indices H_PER_DET_ALERTA_MES
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ALERTA_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;    
    
    -- Borrado de los meses a insertar
    delete from H_PER_DET_ALERTA_MES where MES_ID = mes;
    commit;  
      
      
    insert into H_PER_DET_ALERTA_MES
        (
          MES_ID,
          FECHA_CARGA_DATOS,
          PERSONA_ID,
          ALERTA_ID,
          CONTRATO_ID,
          TIPO_ALERTA_ID,
          CALIFICACION_ALERTA_ID,
          GESTION_ALERTA_ID,
          NUM_ALERTAS
        )
      select  mes,    
        max_dia_mes,
        PERSONA_ID,
        ALERTA_ID,
        CONTRATO_ID,
        TIPO_ALERTA_ID,
        CALIFICACION_ALERTA_ID,
        GESTION_ALERTA_ID,
        NUM_ALERTAS
      from H_PER_DET_ALERTA  where DIA_ID = max_dia_mes;
      
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_PER_DET_ALERTA_MES


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_MES_IX'', ''HH_PER_DET_ALERTA_MES (MES_ID, PERSONA_ID, ALERTA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;    

  end loop C_MESES_LOOP;
  close c_mes;
  
  
  -- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ALERTA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PER_DET_ALERTA_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ALERTA;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
    select min(DIA_H) into min_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    -- Borrado indices H_PER_DET_ALERTA_TRIMESTRE
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ALERTA_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
    
    -- Borrado de los trimestres a insertar
    delete from H_PER_DET_ALERTA_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;
      
      insert into H_PER_DET_ALERTA_TRIMESTRE
        (
          TRIMESTRE_ID,
          FECHA_CARGA_DATOS,
          PERSONA_ID,
          ALERTA_ID,
          CONTRATO_ID,
          TIPO_ALERTA_ID,
          CALIFICACION_ALERTA_ID,
          GESTION_ALERTA_ID,
          NUM_ALERTAS
        )
      select trimestre,    
        max_dia_trimestre,
        PERSONA_ID,
        ALERTA_ID,
        CONTRATO_ID,
        TIPO_ALERTA_ID,
        CALIFICACION_ALERTA_ID,
        GESTION_ALERTA_ID,
        NUM_ALERTAS
     from H_PER_DET_ALERTA where DIA_ID = max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_PER_DET_ALERTA_TRIMESTRE


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_TRIMESTRE_IX'', ''H_PER_DET_ALERTA_TRIMESTRE (TRIMESTRE_ID, PERSONA_ID, ALERTA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;    
        
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_TRIMESTRE. Termina bucle', 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ALERTA_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
         



  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PER_DET_ALERTA_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ALERTA;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
  -- Bucle que recorre los a�os
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
    select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;
        
    -- Borrado indices H_PER_DET_ALERTA_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ALERTA_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
    
    -- Borrado de loa a�os a insertar
    delete from H_PER_DET_ALERTA_ANIO where ANIO_ID = anio;
    commit;
    
    insert into H_PER_DET_ALERTA_ANIO
        (
          ANIO_ID,
          FECHA_CARGA_DATOS,
          PERSONA_ID,
          ALERTA_ID,
          CONTRATO_ID,
          TIPO_ALERTA_ID,
          CALIFICACION_ALERTA_ID,
          GESTION_ALERTA_ID,
          NUM_ALERTAS
        )
    select anio,    
           max_dia_anio,
           PERSONA_ID,
           ALERTA_ID,
           CONTRATO_ID,
           TIPO_ALERTA_ID,
           CALIFICACION_ALERTA_ID,
           GESTION_ALERTA_ID,
           NUM_ALERTAS
      from H_PER_DET_ALERTA where DIA_ID = max_dia_anio;
    commit;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_PER_DET_ALERTA_ANIO


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ALERTA_ANIO_IX'', ''H_PER_DET_ALERTA_ANIO (ANIO_ID, PERSONA_ID, ALERTA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;    
    
  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ALERTA_ANIO. Termina bucle', 3;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2; 
  
end;
end CARGAR_H_PER_DET_ALERTA;
/ 
EXIT;
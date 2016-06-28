--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160627
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BI-131 y BI-123
--## PRODUCTO=NO
--## 
--## Finalidad:  Gestores, supervisores; y nuevos detalles expediente-contratos, expediente-personas.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE CARGAR_H_EXP_DET_CONTRATO (DATE_START in date, DATE_END in date, O_ERROR_STATUS OUT VARCHAR2) AS 

-- ===============================================================================================
-- Autor: Fran Gutiérrez, PFS group
-- Fecha creación: Julio 2014
-- Responsable ultima modificacion: Pedro S., PFS group
-- Fecha última modificación: 27/06/2016
-- Motivos del cambio: Gestores, supervisores; y nuevos detalles expediente-contratos, expediente-personas.
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_EXP_DET_CONTRATO
-- ===============================================================================================
 
-- ===============================================================================================
--                                    Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_EXPEDIENTE';
  V_ROWCOUNT NUMBER;
  
  V_DATASTAGE VARCHAR2(100);
  V_CM01 VARCHAR2(100);
  V_SQL VARCHAR2(16000);
  V_NUMBER NUMBER(16,0);
  
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
  
  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA order by 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1; 

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
  select valor into V_CM01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';
-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_DET_CONTRATO
-- ----------------------------------------------------------------------------------------------
  
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop
    fetch c_fecha into fecha;  
    exit when c_fecha%NOTFOUND;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
	
	execute immediate 'merge into TMP_EXP_CNT a
			using (SELECT DISTINCT EXP_ID, CNT_ID, CEX_PASE
			FROM '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE
			WHERE BORRADO = 0 and FECHACREAR <= '''||fecha||''') b
    on (b.EXP_ID = a.EXPEDIENTE_ID and b.CNT_ID = a.CONTRATO)   
    when matched then update 
        set a.CNT_ES_PASE_ID = b.CEX_PASE';
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Updates(1)', 4;
	
    -- Borrado del día a insertar
    delete from H_EXP_DET_CONTRATO where DIA_ID = fecha;
    commit;

    -- Borrado indices H_EXP_DET_CONTRATO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CONTRATO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit; 

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO. Termina Borrado Indices', 4;
    
          
    insert into H_EXP_DET_CONTRATO
        ( DIA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS   
        )
    select fecha, 
         fecha,
         EXPEDIENTE_ID,
         CONTRATO,
		 CNT_ES_PASE_ID,
         1
    from TMP_EXP_CNT;
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
  end loop;
  close c_fecha;  
  

  -- Crear indices H_EXP_DET_CONTRATO
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CONTRATO_IX'', ''H_EXP_DET_CONTRATO (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

  
  commit;

 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO. Termina Creación de Indices', 3;
  

  
-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_DET_CONTRATO_SEMANA
-- ----------------------------------------------------------------------------------------------
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS; 
  
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_EXP_DET_CONTRATO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_EXP_DET_CONTRATO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP_DET_CONTRATO;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  
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
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_SEMANA. Empieza Semana: '||TO_CHAR(semana), 3;

    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    select min(DIA_H) into min_dia_semana from TMP_FECHA where SEMANA_H = semana;

    -- Borrado de las semanas a insertar
    delete from H_EXP_DET_CONTRATO_SEMANA where SEMANA_ID = semana;
    commit;
    
    -- Borrado indices H_EXP_DET_CONTRATO_SEMANA 
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CONTRATO_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_SEMANA. Termina Borrado de Indices', 4;

        insert into H_EXP_DET_CONTRATO_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS  
        )
    select semana, 
         max_dia_semana,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS
    from H_EXP_DET_CONTRATO where DIA_ID = max_dia_semana;

    V_ROWCOUNT := sql%rowcount;     
    commit;
	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;   

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_SEMANA. Termina Semana: '||TO_CHAR(semana), 3;
    
  end loop;
  close c_semana;

  -- Crear indices H_EXP_DET_CONTRATO_SEMANA
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CONTRATO_SEMANA_IX'', ''H_EXP_DET_CONTRATO_SEMANA (SEMANA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_SEMANA. Termina Creación de Indices', 4;



-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_DET_CONTRATO_MES
-- ----------------------------------------------------------------------------------------------
   -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS; 
  
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_EXP_DET_CONTRATO_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP_DET_CONTRATO;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  
  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND; 

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_MES. Empieza Mes: '||TO_CHAR(mes), 3;

    select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
    select min(DIA_H) into min_dia_mes from TMP_FECHA where MES_H = mes;

    -- Borrado de los meses a insertar
    delete from H_EXP_DET_CONTRATO_MES where MES_ID = mes;
    commit;
    
    -- Borrado indices H_EXP_DET_CONTRATO_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CONTRATO_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_MES. Termina Borrado de Indices', 4;
    
    
    insert into H_EXP_DET_CONTRATO_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS    
        )
    select mes, 
         max_dia_mes,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS   
    from H_EXP_DET_CONTRATO where DIA_ID = max_dia_mes;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
  end loop;
  close c_mes;

  -- Crear indices H_EXP_DET_CONTRATO_MES
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CONTRATO_MES_IX'', ''H_EXP_DET_CONTRATO_MES (MES_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  

  commit;
  
 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_MES. Termina Creación de Indices', 4;

  
-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_DET_CONTRATO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------  
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS; 
  
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_EXP_DET_CONTRATO_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP_DET_CONTRATO;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_TRIMESTRE. Empieza Trimestre: '||TO_CHAR(trimestre), 3;
    
    
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
    select min(DIA_H) into min_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    -- Borrado de los trimestres a insertar
    delete from H_EXP_DET_CONTRATO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;
    
    -- Borrar indices H_EXP_DET_CONTRATO_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CONTRATO_TRI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_TRIMESTRE. Termina Borrado de Indices', 4;
    
    
    insert into H_EXP_DET_CONTRATO_TRIMESTRE
        (TRIMESTRE_ID,   
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS   
        )
    select trimestre, 
         max_dia_trimestre,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS   
    from H_EXP_DET_CONTRATO where DIA_ID = max_dia_trimestre;
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
     
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_TRIMESTRE. Termina Trimestre: '||TO_CHAR(trimestre), 3;
 
  end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

  -- Crear indices H_EXP_DET_CONTRATO_TRIMESTRE
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CONTRATO_TRI_IX'', ''H_EXP_DET_CONTRATO_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_TRIMESTRE. Termina Creación de Indices', 4;
  

-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_DET_CONTRATO_ANIO
-- ----------------------------------------------------------------------------------------------
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS; 
  
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_EXP_DET_CONTRATO_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP_DET_CONTRATO;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
-- Bucle que recorre los años
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;       

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_ANIO. Empieza Año: '||TO_CHAR(anio), 3;
    
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;    
    select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;    

    -- Borrado de los años a insertar
    delete from H_EXP_DET_CONTRATO_ANIO where ANIO_ID = anio;    
    commit;
    
    -- Borrar indices H_CNT_ANIO
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_DET_CONTRATO_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_ANIO. Termina Borrado de Indices', 4;
    
    insert into H_EXP_DET_CONTRATO_ANIO
        (ANIO_ID,      
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS    
        )
    select anio,   
         max_dia_anio,
         EXPEDIENTE_ID,
         CONTRATO_ID,
		 CNT_ES_PASE_ID,
         NUM_CONTRATOS    
    from H_EXP_DET_CONTRATO where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_ANIO. Termina Año: '||TO_CHAR(anio), 3;

  end loop;
  close c_anio;

  -- Crear indices H_EXP_DET_CONTRATO_ANIO
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_DET_CONTRATO_ANIO_IX'', ''H_EXP_DET_CONTRATO_ANIO (ANIO_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_DET_CONTRATO_ANIO. Termina Creación de Indices', 4;

  
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



end CARGAR_H_EXP_DET_CONTRATO;
/
EXIT
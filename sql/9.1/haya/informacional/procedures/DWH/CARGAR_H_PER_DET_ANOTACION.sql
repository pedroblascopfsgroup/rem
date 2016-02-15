create or replace PROCEDURE CARGAR_H_PER_DET_ANOTACION (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS  
-- ===============================================================================================
-- Autor: Maria Villanueva, PFS Group
-- Fecha creación: ENERO 2016
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 27/01/2016
-- Motivos del cambio: Modificacion de anotaciones
-- Cliente: Recovery BI HAYA SAREB
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_PER_DET_ANOTACION.
-- ===============================================================================================
BEGIN
 DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  v_num_row NUMBER(10);
  v_datastage  VARCHAR2(100);
  v_HAYA01     VARCHAR2(100);
  


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
  
  
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PER_DET_ANOTACION';
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
	select valor into v_HAYA01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';
	

-- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ANOTACION
-- ----------------------------------------------------------------------------------------------
 -- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3; 


 ---------------------- CARGA ANOTACIONES ----------------------    
 
    -- Borrando indices TMP_H_PER_DET_ANOTACION
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PER_DET_ANOTACION_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;
	
	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PER_DET_ANOTACION'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;
	
	execute immediate 'insert into TMP_H_PER_DET_ANOTACION
            (
             DIA_ID,
			FECHA_CARGA_DATOS,
			ANOTACION_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			USU_ID
            )
            select '''||fecha||''',
                   '''||fecha||''',
                   REG_ID,
				   TRG_EIN_CODIGO,
				   TRUNC(FECHACREAR),
				   1,
			USU_ID
            from '||V_DATASTAGE||'.MEJ_REG_REGISTRO 
            where TRUNC(FECHACREAR)= '''||fecha||''' and BORRADO = 0';
			
	 --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PER_DET_ANOTACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;   		
	  
	  
	  -------------------------------- UPDATES TMP_H_PER_DET_ANOTACION --------------------------------------
	  
	  
	 	  -------------------------------- UPDATES TMP_H_PER_DET_ANOTACION --------------------------------------
	  
	  -- PERSONA_ID
	  
	  -- 1) ANOTACION EN PERSONA NOTACION_ENT_INF_ID=9
	  
	  execute immediate'
	merge into TMP_H_PER_DET_ANOTACION t1
	using ( select distinct TRG_EIN_ID, REG_ID  
	from '||V_DATASTAGE||'.MEJ_REG_REGISTRO where TRG_EIN_CODIGO=9) t2
	on(t1.ANOTACION_ID=t2.REG_ID)
	when matched then update
	set t1.PERSONA_ID=t2.TRG_EIN_ID';
	
	 commit;
	
	 -- ANOTACION_TIPO_ID
	  execute immediate' 
	merge into TMP_H_PER_DET_ANOTACION T1
	using (select  DISTINCT T3.REG_ID,T3.IRG_CLAVE, IRG_VALOR, T4.ANOTACION_TIPO_ID from '||V_DATASTAGE||'.MEJ_IRG_INFO_REGISTRO T3 join D_PER_ANOTACION_TIPO T4 
	on T3.IRG_VALOR=T4.ANOTACION_TIPO_CODIGO
	where IRG_CLAVE like''TIPO_ANO%'' ) T2
	on(T1.ANOTACION_ID=T2.REG_ID)
    when matched then update
    set  T1.ANOTACION_TIPO_ID=T2.ANOTACION_TIPO_ID';

COMMIT;

execute immediate '
	merge into TMP_H_PER_DET_ANOTACION T1
	using (SELECT distinct USU.USU_ID,
     TGES.DD_TGE_ID
  FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD 
  
    JOIN '||V_DATASTAGE||'.MEJ_REG_REGISTRO USU ON USD.USU_ID = USU.USU_ID     
    JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
    JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID) T2
	on (T1.USU_ID=T2.USU_ID)
	when matched then update
	set T1.TIPO_GESTOR_PER_ID=T2.DD_TGE_ID';
	COMMIT;
	
	
-- Crear indices TMP_H_PER_DET_ANOTACION


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PER_DET_ANOTACION_IX'', ''TMP_H_PER_DET_ANOTACION (DIA_ID, PERSONA_ID, ANOTACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
			
   commit;    
	
	-- Borrando indices H_PER_DET_ANOTACION
    	    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ANOTACION_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	 
		 
	  -- Borrado del día a insertar
    delete from H_PER_DET_ANOTACION where DIA_ID = fecha;
    commit;	 
		 
		 
	insert
	into H_PER_DET_ANOTACION
		(
			DIA_ID,
			FECHA_CARGA_DATOS,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
		)
	select  DIA_ID,
			FECHA_CARGA_DATOS,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
	from TMP_H_PER_DET_ANOTACION where DIA_ID = fecha; 	 
	
	
 V_ROWCOUNT := sql%rowcount;     
    commit;
	
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    	
	
 end loop;
  close c_fecha;  
  
  -- Crear indices H_PER_DET_ANOTACION


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ANOTACION_IX'', ''H_PER_DET_ANOTACION (DIA_ID, PERSONA_ID, ANOTACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;


  commit;   
  
  -- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ANOTACION_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_SEMANA. Empieza bucle', 3;
 
  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PER_DET_ANOTACION_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PER_DET_ANOTACION_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ANOTACION;
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
    
    -- Borrado indices H_PER_DET_ANOTACION_SEMANA
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ANOTACION_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
	
	-- Borrado de las semanas a insertar
    delete from H_PER_DET_ANOTACION_SEMANA where SEMANA_ID = semana;
    commit;
	
	insert
	into H_PER_DET_ANOTACION_SEMANA
		(
			SEMANA_ID,
			FECHA_CARGA_DATOS,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
		)
	select  semana,  
            max_dia_semana,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
	from H_PER_DET_ANOTACION where DIA_ID = max_dia_semana;
	
	
 V_ROWCOUNT := sql%rowcount;     
    commit;
	
	--Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    -- Crear indices H_PER_DET_ANOTACION_SEMANA      


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ANOTACION_SEMANA_IX'', ''H_PER_DET_ANOTACION_SEMANA (SEMANA_ID, PERSONA_ID, ANOTACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;   
   
	end loop C_SEMANAS_LOOP;
	close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_SEMANA. Termina bucle', 3;
	
	-- ----------------------------------------------------------------------------------------------
--                                     H_PER_DET_ANOTACION_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_MES. Empieza bucle', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PER_DET_ANOTACION_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ANOTACION;
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

    -- Borrado indices H_PER_DET_ANOTACION_MES
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ANOTACION_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;    
    
    -- Borrado de los meses a insertar
    delete from H_PER_DET_ANOTACION_MES where MES_ID = mes;
    commit;  
	
	
	insert
	into H_PER_DET_ANOTACION_MES
		(
			MES_ID,
			FECHA_CARGA_DATOS,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
		)
	select  mes,  
            max_dia_mes,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
	from H_PER_DET_ANOTACION where DIA_ID = max_dia_mes;
	
	
 V_ROWCOUNT := sql%rowcount;     
    commit;
	
	  --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_PER_DET_ANOTACION_MES


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ANOTACION_MES_IX'', ''H_PER_DET_ANOTACION_MES (MES_ID, PERSONA_ID, ANOTACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;    

  end loop C_MESES_LOOP;
  close c_mes;
	
	 -- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ANOTACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PER_DET_ANOTACION_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ANOTACION;
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

    -- Borrado indices H_PER_DET_ANOTACION_TRIMESTRE
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ANOTACION_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
	
	-- Borrado de los trimestres a insertar
    delete from H_PER_DET_ANOTACION_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;
	
	insert
	into H_PER_DET_ANOTACION_TRIMESTRE
		(
			TRIMESTRE_ID,
			FECHA_CARGA_DATOS,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
		)
	select  trimestre,  
            max_dia_trimestre,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
	from H_PER_DET_ANOTACION where DIA_ID = max_dia_trimestre;
	
	
 V_ROWCOUNT := sql%rowcount;     
    commit;
	
	  --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_PER_DET_ANOTACION_TRIMESTRE


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ANOTACION_TRIMESTRE_IX'', ''H_PER_DET_ANOTACION_TRIMESTRE (TRIMESTRE_ID, PERSONA_ID, ANOTACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;    
        
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_TRIMESTRE. Termina bucle', 3;
  
  
  -- ----------------------------------------------------------------------------------------------
--                                      H_PER_DET_ANOTACION_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   



  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PER_DET_ANOTACION_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER_DET_ANOTACION;
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
        
    -- Borrado indices H_PER_DET_ANOTACION_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_DET_ANOTACION_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
    
    -- Borrado de loa a�os a insertar
    delete from H_PER_DET_ANOTACION_ANIO where ANIO_ID = anio;
    commit;
    
	
		insert
	into H_PER_DET_ANOTACION_ANIO
		(
			ANIO_ID,
			FECHA_CARGA_DATOS,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
		)
	select  anio,  
            max_dia_anio,
			PERSONA_ID,
			ANOTACION_ID,
			ANOTACION_TIPO_ID,
			ANOTACION_ENT_INF_ID,
			FECHA_ANOTACION,
			NUM_ANOTACIONES,
			TIPO_GESTOR_PER_ID
	from H_PER_DET_ANOTACION where DIA_ID = max_dia_anio;
	
	
 V_ROWCOUNT := sql%rowcount;     
    commit;
	
	  --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_PER_DET_ANOTACION_ANIO


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_DET_ANOTACION_ANIO_IX'', ''H_PER_DET_ANOTACION_ANIO (ANIO_ID, PERSONA_ID, ANOTACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;    
    
  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PER_DET_ANOTACION_ANIO. Termina bucle', 3;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2; 
	
  end;
END CARGAR_H_PER_DET_ANOTACION;

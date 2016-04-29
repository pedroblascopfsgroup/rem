--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160429
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3200
--## PRODUCTO=NO
--## 
--## Finalidad: Se corrige la carga de la tmp_h_pre_det_doc, se estaba insertando PROCEDIMIENTO_ID, en SOLICITUD_DOCUMENTO_ID y viceversa.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

create or replace PROCEDURE CARGAR_H_PRE_DET_DOC(DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 29/04/2016
-- Motivos del cambio: Se corrige la carga de la tmp_h_pre_det_doc, se estaba insertando PROCEDIMIENTO_ID, en SOLICITUD_DOCUMENTO_ID y viceversa.
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_PRE_DET_DOC
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PRE_DET_DOC';
  V_ROWCOUNT NUMBER;
   V_SQL VARCHAR2(16000);
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
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
  fecha date;  
  semana int;
  mes int;
  trimestre int;
  anio int;  
  fecha_ant date;
  semana_ant int;
  mes_ant int;
  trimestre_ant int;
  anio_ant int;  

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
--                                     H_PRE_DET_DOC
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;  
  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3; 

     -- Borrando indices TMP_H_PRE_DET_DOC
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    -- Borrando indices TMP_H_PRE_DET_DOC
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRE_DET_DOC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRE_DET_DOC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_DOC. truncado de tabla y borrado de indices', 4;

    --Dia anterior
    select max(dia_id) into fecha_ant from H_PRE_DET_DOC where dia_id < fecha;

    execute immediate 'insert into TMP_H_PRE_DET_DOC
                 (DIA_ID,
                  FECHA_CARGA_DATOS,
                  PROCEDIMIENTO_ID,
                  DOCUMENTO_ID,
                  TIPO_DOCUMENTO_ID,
                  ESTADO_DOCUMENTO_ID,
                  ESTADO_DOCUMENTO_PER_ANT_ID,
                  NUM_DOCUMENTOS
                  )
          select  '''||fecha||''',
                  '''||fecha||''',
                  PRC_ID,
                  PCO_DOC_PDD_ID,
                  DD_TFA_ID,
                  DD_PCO_DED_ID,
                  -2,
                  1
          from '||V_DATASTAGE||'.PCO_DOC_DOCUMENTOS doc, '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS pco
          where doc.PCO_PRC_ID = pco.PCO_PRC_ID and trunc(doc.FECHACREAR) <= '''||fecha||''' and doc.BORRADO = 0';

    V_ROWCOUNT := sql%rowcount;     
    commit;          
    
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_DOC. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    

    
    --ESTADO_DOCUMENTO_PER_ANT_ID
    if fecha_ant is not null then
      merge into TMP_H_PRE_DET_DOC t1
      using (select PROCEDIMIENTO_ID, DOCUMENTO_ID, ESTADO_DOCUMENTO_ID from H_PRE_DET_DOC where DIA_ID = fecha_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.DOCUMENTO_ID = t2.DOCUMENTO_ID)
      when matched then update set t1.ESTADO_DOCUMENTO_PER_ANT_ID = t2.ESTADO_DOCUMENTO_ID;    
      
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_DOC. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    
    end if;    
    
    -- Crear indices TMP_H_PRE_DET_DOC
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_DOC_IX'', ''TMP_H_PRE_DET_DOC (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    

    -- Borrado del dia a insertar
    delete from H_PRE_DET_DOC where DIA_ID = fecha;
    commit;   
            
    insert into H_PRE_DET_DOC
          (DIA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          DOCUMENTO_ID,
          TIPO_DOCUMENTO_ID,
          ESTADO_DOCUMENTO_ID,
          ESTADO_DOCUMENTO_PER_ANT_ID,
          NUM_DOCUMENTOS
        )
    select DIA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          DOCUMENTO_ID,
          TIPO_DOCUMENTO_ID,
          ESTADO_DOCUMENTO_ID,
          ESTADO_DOCUMENTO_PER_ANT_ID,
          NUM_DOCUMENTOS
    from TMP_H_PRE_DET_DOC where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;
    commit;
        
     --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
    

    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3; 

      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRE_DET_DOC_SOL_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRE_DET_DOC_SOL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_DOC_SOL. truncado de tabla y borrado de indices', 4;

    execute immediate 'insert into TMP_H_PRE_DET_DOC_SOL
                 (DIA_ID,
                  FECHA_CARGA_DATOS,
                  PROCEDIMIENTO_ID,
                  SOLICITUD_DOCUMENTO_ID,
                  DOCUMENTO_ID,
                  RESULTADO_SOLICITUD_ID,
                  TIPO_ACTOR_SOLICITUD_ID,
                  USUARIO_SOLICITUD_ID,
                  FECHA_SOLICITUD_DOC_SOL,
                  FECHA_ENVIO_DOC_SOL,
                  FECHA_RESULT_DOC_SOL,
                  FECHA_RECEP_DOC_SOL,
                  NUM_SOLICITUDES,
                  P_DOC_SOLICITUD_ENVIO,
                  P_DOC_SOLICITUD_RESULTADO,
                  P_DOC_SOLICITUD_RECEPCION
                  )
          select   '''||fecha||''',
                   '''||fecha||''',
                   PRC_ID,
                   sol.PCO_DOC_DSO_ID,
                   doc.PCO_DOC_PDD_ID,
                   NVL(SOL.DD_PCO_DSR_ID,-1),
                   NVL(DD_PCO_DSA_ID,-1),
                   des.USU_ID,
                   trunc(PCO_DOC_DSO_FECHA_SOLICITUD),
                   trunc(PCO_DOC_DSO_FECHA_ENVIO),
                   trunc(PCO_DOC_DSO_FECHA_RESULTADO),
                   trunc(PCO_DOC_DSO_FECHA_RECEPCION),
                   1,
                   trunc(PCO_DOC_DSO_FECHA_ENVIO) - trunc(PCO_DOC_DSO_FECHA_SOLICITUD),
                   trunc(PCO_DOC_DSO_FECHA_RESULTADO) - trunc(PCO_DOC_DSO_FECHA_SOLICITUD),
                   trunc(PCO_DOC_DSO_FECHA_RECEPCION) - trunc(PCO_DOC_DSO_FECHA_SOLICITUD)
          from '||V_DATASTAGE||'.PCO_DOC_DOCUMENTOS doc, '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS pco, '||V_DATASTAGE||'.PCO_DOC_SOLICITUDES sol, '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS des
          where doc.PCO_PRC_ID = pco.PCO_PRC_ID and doc.PCO_DOC_PDD_ID = sol.PCO_DOC_PDD_ID and sol.USD_ID = des.USD_ID
          and trunc(sol.FECHACREAR) <= '''||fecha||''' and sol.BORRADO = 0';

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_DOC_SOL. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;
    
    -- Crear indices TMP_H_PRE_DET_DOC_SOL
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_DOC_SOL_IX'', ''TMP_H_PRE_DET_DOC_SOL (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
 
    -- Borrado del dia a insertar
    delete from H_PRE_DET_DOC_SOL where DIA_ID = fecha;
    commit;   
            
    -- Borrando indices H_PRE_DET_DOC_SOL
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_SOL_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

     insert into H_PRE_DET_DOC_SOL
        ( DIA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          SOLICITUD_DOCUMENTO_ID,
          DOCUMENTO_ID,
          RESULTADO_SOLICITUD_ID,
          TIPO_ACTOR_SOLICITUD_ID,
          USUARIO_SOLICITUD_ID,
          FECHA_SOLICITUD_DOC_SOL,
          FECHA_ENVIO_DOC_SOL,
          FECHA_RESULT_DOC_SOL,
          FECHA_RECEP_DOC_SOL,
          NUM_SOLICITUDES,
          P_DOC_SOLICITUD_ENVIO,
          P_DOC_SOLICITUD_RESULTADO,
          P_DOC_SOLICITUD_RECEPCION
        )
     select DIA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          SOLICITUD_DOCUMENTO_ID,
          DOCUMENTO_ID,
          RESULTADO_SOLICITUD_ID,
          TIPO_ACTOR_SOLICITUD_ID,
          USUARIO_SOLICITUD_ID,
          FECHA_SOLICITUD_DOC_SOL,
          FECHA_ENVIO_DOC_SOL,
          FECHA_RESULT_DOC_SOL,
          FECHA_RECEP_DOC_SOL,
          NUM_SOLICITUDES,
          P_DOC_SOLICITUD_ENVIO,
          P_DOC_SOLICITUD_RESULTADO,
          P_DOC_SOLICITUD_RECEPCION
    from TMP_H_PRE_DET_DOC_SOL where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
    end loop;
  close c_fecha;  
  
  -- Crear indices H_PRE_DET_DOC
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_IX'', ''H_PRE_DET_DOC (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
  
  -- Crear indices H_PRE_DET_DOC_SOL
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_IX'', ''H_PRE_DET_DOC_SOL (DIA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 


-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_DOC_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DOC_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PRE_DET_DOC_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PRE_DET_DOC_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_DOC;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  
  
  -- Borrado indices H_PRE_DET_DOC_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  

  -- Borrado indices H_PRE_DET_DOC_SOL_SEMANA
   
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_SOL_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
    
  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;

    --Semana anterior
    select max(SEMANA_ID) into semana_ant from H_PRE_DET_DOC_SEMANA where SEMANA_ID < semana;
        
    -- Borrado de las semanas a insertar
    delete from H_PRE_DET_DOC_SEMANA where SEMANA_ID = semana;
    commit;

     insert into H_PRE_DET_DOC_SEMANA
        (
          SEMANA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          DOCUMENTO_ID,
          TIPO_DOCUMENTO_ID,
          ESTADO_DOCUMENTO_ID,
          NUM_DOCUMENTOS
        )
     select semana,
            max_dia_semana,
            PROCEDIMIENTO_ID,
            DOCUMENTO_ID,
            TIPO_DOCUMENTO_ID,
            ESTADO_DOCUMENTO_ID,
            NUM_DOCUMENTOS
    from H_PRE_DET_DOC where DIA_ID = max_dia_semana;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
   --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SEMANA. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- ESTADO_DOCUMENTO_PER_ANT_ID
    if semana_ant is not null then
      -- Crear indices H_PRE_DET_DOC_SEMANA      
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SEMANA_IX'', ''H_PRE_DET_DOC_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;   
    
      merge into H_PRE_DET_DOC_SEMANA t1
      using (select PROCEDIMIENTO_ID, DOCUMENTO_ID, ESTADO_DOCUMENTO_ID from H_PRE_DET_DOC_SEMANA where SEMANA_ID = semana_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.DOCUMENTO_ID = t2.DOCUMENTO_ID)
      when matched then update set t1.ESTADO_DOCUMENTO_PER_ANT_ID = t2.ESTADO_DOCUMENTO_ID
      where SEMANA_ID = semana;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SEMANA. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_DOC_SEMANA
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;        
    end if;    
 
 
    -- Borrado de la semana a insertar
    delete from H_PRE_DET_DOC_SOL_SEMANA where SEMANA_ID = semana;
    commit;   
            
     insert into H_PRE_DET_DOC_SOL_SEMANA
        (
          SEMANA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          SOLICITUD_DOCUMENTO_ID,
          DOCUMENTO_ID,
          RESULTADO_SOLICITUD_ID,
          TIPO_ACTOR_SOLICITUD_ID,
          USUARIO_SOLICITUD_ID,
          FECHA_SOLICITUD_DOC_SOL,
          FECHA_ENVIO_DOC_SOL,
          FECHA_RESULT_DOC_SOL,
          FECHA_RECEP_DOC_SOL,
          NUM_SOLICITUDES,
          P_DOC_SOLICITUD_ENVIO,
          P_DOC_SOLICITUD_RESULTADO,
          P_DOC_SOLICITUD_RECEPCION
        )
     select semana,
            max_dia_semana,
            PROCEDIMIENTO_ID,
            SOLICITUD_DOCUMENTO_ID,
            DOCUMENTO_ID,
            RESULTADO_SOLICITUD_ID,
            TIPO_ACTOR_SOLICITUD_ID,
            USUARIO_SOLICITUD_ID,
            FECHA_SOLICITUD_DOC_SOL,
            FECHA_ENVIO_DOC_SOL,
            FECHA_RESULT_DOC_SOL,
            FECHA_RECEP_DOC_SOL,
            NUM_SOLICITUDES,
            P_DOC_SOLICITUD_ENVIO,
            P_DOC_SOLICITUD_RESULTADO,
            P_DOC_SOLICITUD_RECEPCION
      from H_PRE_DET_DOC_SOL where DIA_ID = max_dia_semana;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL_SEMANA. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL_SEMANA. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    commit;

  end loop C_SEMANAS_LOOP;
close c_semana;
  --Log_Proceso

    -- Crear indices H_PRE_DET_DOC_SEMANA      
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SEMANA_IX'', ''H_PRE_DET_DOC_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;   

    -- Crear indices H_PRE_DET_DOC_SOL_SEMANA      
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_SEMANA_IX'', ''H_PRE_DET_DOC_SOL_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;   


    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SEMANA. Termina bucle', 3;   
    
    
-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_DOC_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_MES. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PRE_DET_DOC_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_DOC;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  
  -- Borrado indices H_PRE_DET_DOC_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  

  -- Borrado indices H_PRE_DET_DOC_SOL_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_SOL_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
    
   -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;

    --Mes anterior
    select max(MES_ID) into mes_ant from H_PRE_DET_DOC_MES where MES_ID < mes;
   
    -- Borrado de los meses a insertar
    delete from H_PRE_DET_DOC_MES where MES_ID = mes;
    commit;
    
    insert into H_PRE_DET_DOC_MES
              (
                MES_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                DOCUMENTO_ID,
                TIPO_DOCUMENTO_ID,
                ESTADO_DOCUMENTO_ID,
                NUM_DOCUMENTOS
        )
     select mes,
            max_dia_mes,
            PROCEDIMIENTO_ID,
            DOCUMENTO_ID,
            TIPO_DOCUMENTO_ID,
            ESTADO_DOCUMENTO_ID,
            NUM_DOCUMENTOS
    from H_PRE_DET_DOC  where DIA_ID = max_dia_mes;
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
    
   --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_MES. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- ESTADO_DOCUMENTO_PER_ANT_ID
    if mes_ant is not null then
      -- Crear indices H_PRE_DET_DOC_MES
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_MES_IX'', ''H_PRE_DET_DOC_MES (MES_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;    
    
      merge into H_PRE_DET_DOC_MES t1
      using (select PROCEDIMIENTO_ID, DOCUMENTO_ID, ESTADO_DOCUMENTO_ID from H_PRE_DET_DOC_MES where MES_ID = mes_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.DOCUMENTO_ID = t2.DOCUMENTO_ID)
      when matched then update set t1.ESTADO_DOCUMENTO_PER_ANT_ID = t2.ESTADO_DOCUMENTO_ID
      where MES_ID = mes;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_MES. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_DOC_MES
      
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;        
    end if;   
    
    -- Borrado del dia a insertar
    delete from H_PRE_DET_DOC_SOL_MES where MES_ID = mes;
    commit;   
            
     insert into H_PRE_DET_DOC_SOL_MES
        ( MES_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          SOLICITUD_DOCUMENTO_ID,
          DOCUMENTO_ID,
          RESULTADO_SOLICITUD_ID,
          TIPO_ACTOR_SOLICITUD_ID,
          USUARIO_SOLICITUD_ID,
          FECHA_SOLICITUD_DOC_SOL,
          FECHA_ENVIO_DOC_SOL,
          FECHA_RESULT_DOC_SOL,
          FECHA_RECEP_DOC_SOL,
          NUM_SOLICITUDES,
          P_DOC_SOLICITUD_ENVIO,
          P_DOC_SOLICITUD_RESULTADO,
          P_DOC_SOLICITUD_RECEPCION
        )
     select mes,
            max_dia_mes,
            PROCEDIMIENTO_ID,
            SOLICITUD_DOCUMENTO_ID,
            DOCUMENTO_ID,
            RESULTADO_SOLICITUD_ID,
            TIPO_ACTOR_SOLICITUD_ID,
            USUARIO_SOLICITUD_ID,
            FECHA_SOLICITUD_DOC_SOL,
            FECHA_ENVIO_DOC_SOL,
            FECHA_RESULT_DOC_SOL,
            FECHA_RECEP_DOC_SOL,
            NUM_SOLICITUDES,
            P_DOC_SOLICITUD_ENVIO,
            P_DOC_SOLICITUD_RESULTADO,
            P_DOC_SOLICITUD_RECEPCION
     from H_PRE_DET_DOC_SOL  where DIA_ID = max_dia_mes;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL_MES. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL_MES. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    commit;

  end loop C_MESES_LOOP;
  close c_mes;

    
    -- Crear indices H_PRE_DET_DOC_MES
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_MES_IX'', ''H_PRE_DET_DOC_MES (MES_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    

    -- Crear indices H_PRE_DET_DOC_SOL_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_MES_IX'', ''H_PRE_DET_DOC_SOL_MES (MES_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    


  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_MES. Termina bucle', 3;   
  

-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_DOC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PRE_DET_DOC_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_DOC;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  
  -- Borrado indices H_PRE_DET_DOC_TRIMESTRE
    
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

  -- Borrado indices H_PRE_DET_DOC_SOL_TRIMESTRE
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_SOL_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
    
 -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    --Trimestre anterior
    select max(TRIMESTRE_ID) into trimestre_ant from H_PRE_DET_DOC_TRIMESTRE where TRIMESTRE_ID < trimestre;

    -- Borrado de los trimestres a insertar
    delete from H_PRE_DET_DOC_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;  
    
    insert into H_PRE_DET_DOC_TRIMESTRE
              (
                TRIMESTRE_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                DOCUMENTO_ID,
                TIPO_DOCUMENTO_ID,
                ESTADO_DOCUMENTO_ID,
                NUM_DOCUMENTOS
              )
     select trimestre,
            max_dia_trimestre,
            PROCEDIMIENTO_ID,
            DOCUMENTO_ID,
            TIPO_DOCUMENTO_ID,
            ESTADO_DOCUMENTO_ID,
            NUM_DOCUMENTOS
     from H_PRE_DET_DOC  where DIA_ID = max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_TRIMESTRE. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;

    --ESTADO_DOCUMENTO_PER_ANT_ID
    if mes_ant is not null then
      -- Crear indices H_PRE_DET_DOC_TRIMESTRE
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_TRIMESTRE_IX'', ''H_PRE_DET_DOC_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;    
    
      merge into H_PRE_DET_DOC_TRIMESTRE t1
      using (select PROCEDIMIENTO_ID, DOCUMENTO_ID, ESTADO_DOCUMENTO_ID from H_PRE_DET_DOC_TRIMESTRE where TRIMESTRE_ID = trimestre_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.DOCUMENTO_ID = t2.DOCUMENTO_ID)
      when matched then update set t1.ESTADO_DOCUMENTO_PER_ANT_ID = t2.ESTADO_DOCUMENTO_ID
      where TRIMESTRE_ID = trimestre;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_MES. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_DOC_TRIMESTRE
        
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;      
    end if;   
    
-- Borrado del dia a insertar
    delete from H_PRE_DET_DOC_SOL_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;   
            
     insert into H_PRE_DET_DOC_SOL_TRIMESTRE
        ( TRIMESTRE_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          SOLICITUD_DOCUMENTO_ID,
          DOCUMENTO_ID,
          RESULTADO_SOLICITUD_ID,
          TIPO_ACTOR_SOLICITUD_ID,
          USUARIO_SOLICITUD_ID,
          FECHA_SOLICITUD_DOC_SOL,
          FECHA_ENVIO_DOC_SOL,
          FECHA_RESULT_DOC_SOL,
          FECHA_RECEP_DOC_SOL,
          NUM_SOLICITUDES,
          P_DOC_SOLICITUD_ENVIO,
          P_DOC_SOLICITUD_RESULTADO,
          P_DOC_SOLICITUD_RECEPCION
        )
     select trimestre,
            max_dia_trimestre,
            PROCEDIMIENTO_ID,
            SOLICITUD_DOCUMENTO_ID,
            DOCUMENTO_ID,
            RESULTADO_SOLICITUD_ID,
            TIPO_ACTOR_SOLICITUD_ID,
            USUARIO_SOLICITUD_ID,
            FECHA_SOLICITUD_DOC_SOL,
            FECHA_ENVIO_DOC_SOL,
            FECHA_RESULT_DOC_SOL,
            FECHA_RECEP_DOC_SOL,
            NUM_SOLICITUDES,
            P_DOC_SOLICITUD_ENVIO,
            P_DOC_SOLICITUD_RESULTADO,
            P_DOC_SOLICITUD_RECEPCION
     from H_PRE_DET_DOC_SOL  where DIA_ID = max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL_TRIMESTRE. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

    -- Crear indices H_PRE_DET_DOC_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_TRIMESTRE_IX'', ''H_PRE_DET_DOC_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
    
    -- Crear indices H_PRE_DET_DOC_SOL_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_TRIMESTRE_IX'', ''H_PRE_DET_DOC_SOL_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    

  
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_TRIMESTRE. Termina bucle', 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_DOC_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PRE_DET_DOC_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_DOC;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
  -- Borrado indices H_PRE_DET_DOC_ANIO
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
      -- Borrado indices H_PRE_DET_DOC_SOL_ANIO
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_SOL_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
 
  -- Bucle que recorre los aios
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;

    --Año anterior
    select max(ANIO_ID) into anio_ant from H_PRE_DET_DOC_ANIO where ANIO_ID < anio;
  
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
        
    -- Borrado de loa aios a insertar
    delete from H_PRE_DET_DOC_ANIO where ANIO_ID = anio;
    commit;
  
    insert into H_PRE_DET_DOC_ANIO
              (
                ANIO_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                DOCUMENTO_ID,
                TIPO_DOCUMENTO_ID,
                ESTADO_DOCUMENTO_ID,
                NUM_DOCUMENTOS
              )
     select anio,
            max_dia_anio,
                PROCEDIMIENTO_ID,
                DOCUMENTO_ID,
                TIPO_DOCUMENTO_ID,
                ESTADO_DOCUMENTO_ID,
                NUM_DOCUMENTOS
     from H_PRE_DET_DOC  where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_ANIO. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;

    --ESTADO_DOCUMENTO_PER_ANT_ID
    if mes_ant is not null then
      -- Crear indices H_PRE_DET_DOC_ANIO
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_ANIO_IX'', ''H_PRE_DET_DOC_ANIO (ANIO_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit; 
    
      merge into H_PRE_DET_DOC_ANIO t1
      using (select PROCEDIMIENTO_ID, DOCUMENTO_ID, ESTADO_DOCUMENTO_ID from H_PRE_DET_DOC_ANIO where ANIO_ID = anio_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.DOCUMENTO_ID = t2.DOCUMENTO_ID)
      when matched then update set t1.ESTADO_DOCUMENTO_PER_ANT_ID = t2.ESTADO_DOCUMENTO_ID
      where ANIO_ID = anio;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_MES. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_DOC_ANIO
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_DOC_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;      
    end if;   
    
-- Borrado del dia a insertar
    delete from H_PRE_DET_DOC_SOL_ANIO where ANIO_ID = anio;
    commit;   
            
     insert into H_PRE_DET_DOC_SOL_ANIO
        ( ANIO_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          SOLICITUD_DOCUMENTO_ID,
          DOCUMENTO_ID,
          RESULTADO_SOLICITUD_ID,
          TIPO_ACTOR_SOLICITUD_ID,
          USUARIO_SOLICITUD_ID,
          FECHA_SOLICITUD_DOC_SOL,
          FECHA_ENVIO_DOC_SOL,
          FECHA_RESULT_DOC_SOL,
          FECHA_RECEP_DOC_SOL,
          NUM_SOLICITUDES,
          P_DOC_SOLICITUD_ENVIO,
          P_DOC_SOLICITUD_RESULTADO,
          P_DOC_SOLICITUD_RECEPCION
        )
     select anio,
            max_dia_anio,
            PROCEDIMIENTO_ID,
            SOLICITUD_DOCUMENTO_ID,
            DOCUMENTO_ID,
            RESULTADO_SOLICITUD_ID,
            TIPO_ACTOR_SOLICITUD_ID,
            USUARIO_SOLICITUD_ID,
            FECHA_SOLICITUD_DOC_SOL,
            FECHA_ENVIO_DOC_SOL,
            FECHA_RESULT_DOC_SOL,
            FECHA_RECEP_DOC_SOL,
            NUM_SOLICITUDES,
            P_DOC_SOLICITUD_ENVIO,
            P_DOC_SOLICITUD_RESULTADO,
            P_DOC_SOLICITUD_RECEPCION
     from H_PRE_DET_DOC_SOL  where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_SOL_ANIO. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
    
  end loop C_ANIO_LOOP;
  close c_anio;

    -- Crear indices H_PRE_DET_DOC_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_ANIO_IX'', ''H_PRE_DET_DOC_ANIO (ANIO_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

    -- Crear indices H_PRE_DET_DOC_SOL_ANIO
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_DOC_SOL_ANIO_IX'', ''H_PRE_DET_DOC_SOL_ANIO (ANIO_ID, PROCEDIMIENTO_ID, DOCUMENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    commit; 

  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_DOC_ANIO. Termina bucle', 3;
      
   --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;           
    end;
END CARGAR_H_PRE_DET_DOC;
/
EXIT
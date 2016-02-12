create or replace PROCEDURE CARGAR_H_CNT_DET_COBRO (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Mayo 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 23/11/2015
-- Motivos del cambio:usuario propietario
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_CNT_DET_COBRO.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_CONTRATO';
  V_ROWCOUNT NUMBER;
  
  V_NUM_ROW NUMBER(10);

  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_CM01 VARCHAR2(100);


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
  cursor c_fecha_cobro is select distinct FECHA_COBRO from TMP_H_CNT_DET_COBRO order by 1;
  

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
--                                      H_CNT_DET_COBRO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
    select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';
    select valor into V_CM01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';
      
  fecha_incidencia230615 := '28/05/2015';       
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
   
    -- ---------------------- Cobros nuevos ----------------------
    -- Borrado indices TMP_H_CNT_DET_COBRO






          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_COBRO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;
		 
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_COBRO_FCOB_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
   	   
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_COBRO_FCNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
	   
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_COBRO_COBRO_ID_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    commit;    
       
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT_DET_COBRO'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_COBRO 
        (DIA_ID,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_COBRO,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO
        )
     select  trunc(cpa.CPA_FECHA_VALOR),
         trunc(cpa.CPA_FECHA_VALOR),
         cpa.CNT_ID,
         cpa.CPA_ID,
         trunc(cpa.CPA_FECHA_VALOR),
         cpa.DD_SCP_ID,
         0,

         1,
         cpa.CPA_IMPORTE,
         cpa.CPA_CAPITAL,
         cpa.CPA_CAPITAL_NO_VENCIDO,
         cpa.CPA_INTERESES_ORDINAR,
         cpa.CPA_INTERESES_MORATOR,
         cpa.CPA_COMISIONES,
         cpa.CPA_GASTOS    
    from ' || V_DATASTAGE || '.CPA_COBROS_PAGOS cpa where trunc(cpa.CPA_FECHA_VALOR) >= ''' || fecha_incidencia230615 || '''
    and  trunc(cpa.CPA_FECHA_VALOR) <= ''' || fecha || ''' and cpa.CPA_ID not in (select COBRO_ID FROM H_CNT_DET_COBRO)';

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices TMP_H_CNT_DET_COBRO


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COBRO_IX'', ''TMP_H_CNT_DET_COBRO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';





            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COBRO_FCOB_IX'', ''TMP_H_CNT_DET_COBRO (FECHA_COBRO, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';





            execute immediate V_SQL USING OUT O_ERROR_STATUS;   
	
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COBRO_FCNT_IX'', ''TMP_H_CNT_DET_COBRO (FECHA_CONTRATO, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';





            execute immediate V_SQL USING OUT O_ERROR_STATUS;
	
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_COB_COBRO_ID_IX'', ''TMP_H_CNT_DET_COBRO (COBRO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS; 

    commit;
    
    -- ---------------------- Datos Facturación ----------------------
    -- Borrado indices TMP_CNT_FACTURACION y TMP_DET_COBROS_PAGOS


         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_FACTURACION_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	 
    commit;


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_DET_COBROS_PAGOS_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    commit;

    
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_FACTURACION'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DET_COBROS_PAGOS'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   
    commit;

    execute immediate 'insert into TMP_DET_COBROS_PAGOS (CPA_ID, CPA_CODIGO_COBRO, CPA_FECHA_VALOR)
    select a.CPA_ID, a.CPA_CODIGO_COBRO, CPA_FECHA_VALOR
              from ' || V_DATASTAGE || '.CPA_COBROS_PAGOS a 
                  right outer join TMP_H_CNT_DET_COBRO b on a.CPA_ID = b.COBRO_ID';
    commit;

    -- Crear indices TMP_CNT_FACTURACION


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DET_COBROS_PAGOS_IX'', ''TMP_DET_COBROS_PAGOS (CPA_CODIGO_COBRO, CPA_FECHA_VALOR)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

/* PSM no se gestiona para CM
    execute immediate 'insert into TMP_CNT_FACTURACION
            ( COBRO_ID,
              CODIGO_COBRO,
              FECHA_FACTURA,
              FACTURA_ID,
              IMPORTE_FACTURA,
              TARIFA,
              CORRECTOR
            )
            select  a.CPA_ID,
                    m.CODIGO_COBRO,
                    m.FECHA_LIBERACION_FAC,
                    m.IDFACTURACION,
                    m.IMPORTE_FACTURA,
                    m.TARIFA,
                    m.CORRECTOR 
            from  ' || V_DATASTAGE || '.MINIRECOVERY_FACT m, TMP_DET_COBROS_PAGOS a
            where m.CODIGO_COBRO = a.CPA_CODIGO_COBRO and TRUNC(m.FECHA_VALOR) = TRUNC(a.CPA_FECHA_VALOR)';

    V_ROWCOUNT := sql%rowcount;     
    commit;
  */
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_FACTURACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
    -- Crear indices TMP_CNT_FACTURACION


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_FACTURACION_IX'', ''TMP_CNT_FACTURACION (COBRO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
    
    --Updates a TMP_H_CNT_DET_COBRO    
    merge into TMP_H_CNT_DET_COBRO dc
    using (select max(FECHA_FACTURA) as MAX_FECHA_FACTURA, COBRO_ID from TMP_CNT_FACTURACION group by COBRO_ID) cf
    on (cf.COBRO_ID = dc.COBRO_ID)   
    when matched then update set dc.FECHA_FACTURA = cf.MAX_FECHA_FACTURA where dc.FECHA_FACTURA is null;
    commit;

    merge into TMP_H_CNT_DET_COBRO dc
    using (select MAX(FACTURA_ID) MAX_FACTURA_ID, COBRO_ID from TMP_CNT_FACTURACION group by COBRO_ID) cf
    on (cf.COBRO_ID = dc.COBRO_ID)   
    when matched then update set dc.FACTURA_COBRO_ID = cf.MAX_FACTURA_ID  where dc.FACTURA_COBRO_ID is null;
    commit;

    merge into TMP_H_CNT_DET_COBRO dc
    using (select max(NVL(IMPORTE_FACTURA, -1)) as MAX_IMPORTE_FACTURA, COBRO_ID from TMP_CNT_FACTURACION group by COBRO_ID) cf
    on (cf.COBRO_ID = dc.COBRO_ID)   
    when matched then update set dc.IMPORTE_FACTURA_TARIFA = cf.MAX_IMPORTE_FACTURA  where dc.IMPORTE_FACTURA_TARIFA is null;
    commit;

    merge into TMP_H_CNT_DET_COBRO dc
    using (select max(NVL(CORRECTOR, -1)) as MAX_CORRECTOR, COBRO_ID from TMP_CNT_FACTURACION group by COBRO_ID) cf
    on (cf.COBRO_ID = dc.COBRO_ID)   
    when matched then update set dc.CORRECTOR_FACTURA = cf.MAX_CORRECTOR  where dc.CORRECTOR_FACTURA is null;
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Updates', 4;
      
    -- ----------------------------- Cobros -------------------------------         
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza Bucle de Cobros', 4;
     
    open c_fecha_cobro;
    loop --READ_LOOP
      fetch c_fecha_cobro into f_cobro;        
      exit when c_fecha_cobro%NOTFOUND;
      
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Empieza Fecha: '||TO_CHAR(f_cobro, 'dd/mm/yyyy'), 5;
     
        -- Borrado indices TMP_CNT_ENVIO_AGENCIA


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_ENVIO_AGENCIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
          
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_ENVIO_AGENCIA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
        commit;
        
        execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ INTO TMP_CNT_ENVIO_AGENCIA(
          CONTRATO_ID,
          EXPEDIENTE_ID,
          AGENCIA_COBRO_ID,
          SUBCARTERA_COBRO_ID,
          POS_VIVA_NO_VENCIDA,
          POS_VIVA_VENCIDA,
          INT_ORDIN_DEVEN,
          INT_MORAT_DEVEN,
          COMISIONES,
          GASTOS,
          IMPUESTOS,
          ENTREGAS,
          INT_ENTREGAS,
          DEUDA_IRREGULAR)
        select 
          SUBSTR(ID_ENVIO, 9, LENGTH(ID_ENVIO)),
          ID_EXPEDIENTE,
          RCF_AGE_ID, -- agencia
          RCF_SCA_ID, -- subcartera
          POS_VIVA_NO_VENCIDA,
          POS_VIVA_VENCIDA,
          INT_ORDIN_DEVEN,
          INT_MORAT_DEVEN,
          COMISIONES,
          GASTOS,
          IMPUESTOS,
          ENTREGAS,
          INT_ENTREGAS,
          DEUDA_IRREGULAR
        from '||V_DATASTAGE||'.H_REC_FICHERO_CONTRATOS where trunc(FECHA_HIST) = '''||f_cobro||''' ';	

        V_ROWCOUNT := sql%rowcount;     
        commit;
      
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_ENVIO_AGENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;
        
        
        -- Crear indices TMP_CNT_ENVIO_AGENCIA_IX


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_ENVIO_AGENCIA_IX'', ''TMP_CNT_ENVIO_AGENCIA (CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
        commit;    

        merge into TMP_H_CNT_DET_COBRO hc
        using (select distinct CONTRATO_ID from TMP_CNT_ENVIO_AGENCIA) crc
        on (crc.CONTRATO_ID = hc.CONTRATO_ID)   
        when matched then update set hc.ENVIADO_AGENCIA_COBRO_ID = 1 where hc.FECHA_COBRO = f_cobro;            
        commit;

         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 1', 5;
        
        -- Borrado indices TMP_CNT_COBRO


        
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_COBRO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	  
        commit;

    

         V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_COBRO'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
        commit;
        insert into TMP_CNT_COBRO(CONTRATO_ID, FECHA_COBRO) select distinct CONTRATO_ID, FECHA_COBRO from TMP_H_CNT_DET_COBRO where FECHA_COBRO = f_cobro and ENVIADO_AGENCIA_COBRO_ID = 1;
        commit;
        
        -- Crear indices TMP_CNT_COBRO


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_COBRO_IX'', ''TMP_CNT_COBRO (CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
        commit;            

        merge into TMP_CNT_COBRO hc
        using (select CONTRATO_ID from H_CNT where DIA_ID = to_date(f_cobro) -1) crc
        on (crc.CONTRATO_ID = hc.CONTRATO_ID)   
        when matched then update set hc.MAX_FECHA_CONTRATO = hc.FECHA_COBRO -1;            
        commit;

         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_COBRO. Update', 5;
        
        merge into TMP_H_CNT_DET_COBRO hc
        using (select CONTRATO_ID, MAX_FECHA_CONTRATO from TMP_CNT_COBRO where FECHA_COBRO = f_cobro and MAX_FECHA_CONTRATO is not null) crc
        on (crc.CONTRATO_ID = hc.CONTRATO_ID)   
        when matched then update set hc.FECHA_CONTRATO = crc.MAX_FECHA_CONTRATO where hc.FECHA_COBRO = f_cobro;    
        commit;

         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 2', 5;

        -- Fecha del expediente el dia de envio del contrato a agencia
        update TMP_H_CNT_DET_COBRO hdc set ESQUEMA_COBRO_ID = (select ESQUEMA_CONTRATO_ID from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(1)', 5;
        
        update TMP_H_CNT_DET_COBRO hdc set AGENCIA_COBRO_ID = (select AGENCIA_CONTRATO_ID from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(2)', 5;
        
        update TMP_H_CNT_DET_COBRO hdc set SUBCARTERA_COBRO_ID = (select SUBCARTERA_EXPEDIENTE_CNT_ID from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(3)', 5;                    
        

        -- Contratos que entran en ciclo de recobro el mismo día del envio a agencia        
        merge into TMP_H_CNT_DET_COBRO a
        using (select CONTRATO_ID, ESQUEMA_CONTRATO_ID from H_CNT where DIA_ID = f_cobro and ESQUEMA_CONTRATO_ID is not null) b
        on (b.CONTRATO_ID = a.CONTRATO_ID)   
        when matched then update set  a.ESQUEMA_COBRO_ID = b.ESQUEMA_CONTRATO_ID
                          where  a.FECHA_COBRO = f_cobro 
                          and a.ESQUEMA_COBRO_ID is null;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 4', 5;

        merge into TMP_H_CNT_DET_COBRO a
        using (select CONTRATO_ID, AGENCIA_CONTRATO_ID from H_CNT  where DIA_ID = f_cobro and AGENCIA_CONTRATO_ID is not null) b
        on (b.CONTRATO_ID = a.CONTRATO_ID)   
        when matched then update set  a.AGENCIA_COBRO_ID = b.AGENCIA_CONTRATO_ID
                          where  a.FECHA_COBRO = f_cobro and a.AGENCIA_COBRO_ID is null;
        commit;

         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 5', 5;

        merge into TMP_H_CNT_DET_COBRO a
        using (select CONTRATO_ID, SUBCARTERA_EXPEDIENTE_CNT_ID from H_CNT  where DIA_ID = f_cobro and SUBCARTERA_EXPEDIENTE_CNT_ID is not null) b
        on (b.CONTRATO_ID = a.CONTRATO_ID)   
        when matched then update set  a.SUBCARTERA_COBRO_ID = b.SUBCARTERA_EXPEDIENTE_CNT_ID
                          where  a.FECHA_COBRO = f_cobro and a.SUBCARTERA_COBRO_ID is null;
        commit;

         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 6', 5;
        
        -- Fecha del contrato el dia anterior al envio del contrato a agencia
        update TMP_H_CNT_DET_COBRO hdc set SEGMENTO_CARTERA_COBRO_ID = (select SEGMENTO_CARTERA_ID from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 7(1)', 5;  

        update TMP_H_CNT_DET_COBRO hdc set TD_IRREG_COBRO_ID = (select T_IRREG_DIAS_ID from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(1)', 5;
        
        update TMP_H_CNT_DET_COBRO hdc set T_DEUDA_IRREGULAR_COBRO_ID = (select T_DEUDA_IRREGULAR_CNT_ID from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(2)', 5;
        
        update TMP_H_CNT_DET_COBRO hdc set DEUDA_IRREGULAR_COBRO = (select DEUDA_IRREGULAR from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(3)', 5;
        
        update TMP_H_CNT_DET_COBRO hdc set RIESGO_VIVO_COBRO = (select RIESGO_VIVO from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(4)', 5;
        
        update TMP_H_CNT_DET_COBRO hdc set NUM_DIAS_VENCIDOS_COBRO = (select NUM_DIAS_VENCIDOS from H_CNT h where h.CONTRATO_ID = hdc.CONTRATO_ID and h.DIA_ID = hdc.FECHA_CONTRATO) where hdc.FECHA_COBRO = f_cobro;
        commit;
         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 3(5)', 5;
        
/*        
        merge into TMP_H_CNT_DET_COBRO a
        using (select CONTRATO_ID, DIA_ID, SEGMENTO_CARTERA_ID, T_IRREG_DIAS_ID, T_DEUDA_IRREGULAR_CNT_ID, DEUDA_IRREGULAR, RIESGO_VIVO, NUM_DIAS_VENCIDOS from H_CNT) b
        on (b.CONTRATO_ID = a.CONTRATO_ID and b.DIA_ID = a.FECHA_CONTRATO)           
        when matched then update set  a.SEGMENTO_CARTERA_COBRO_ID = b.SEGMENTO_CARTERA_ID,
                                      a.TD_IRREG_COBRO_ID = b.T_IRREG_DIAS_ID,
                                      a.T_DEUDA_IRREGULAR_COBRO_ID = b.T_DEUDA_IRREGULAR_CNT_ID,
                                      a.DEUDA_IRREGULAR_COBRO = b.DEUDA_IRREGULAR,
                                      a.RIESGO_VIVO_COBRO = b.RIESGO_VIVO,
                                      a.NUM_DIAS_VENCIDOS_COBRO = b.NUM_DIAS_VENCIDOS
                          where  a.FECHA_COBRO = f_cobro;
        commit;
*/

        execute immediate 'merge into TMP_H_CNT_DET_COBRO a
              using (select CNT_ID, NVL(DD_TPE_ID, -1) as DD_TPE_ID, NVL(DD_GC1_ID, -1) as DD_GC1_ID from '||V_DATASTAGE||'.CNT_CONTRATOS) b
              on (b.CNT_ID = a.CONTRATO_ID)   
              when matched then update set a.TIPO_PRODUCTO_COBRO_ID = b.DD_TPE_ID, a.GARANTIA_COBRO_ID = b.DD_GC1_ID where a.FECHA_COBRO = '''||f_cobro||'''';       
        commit;     
     
              --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 4', 5;

      end loop;
    close c_fecha_cobro;    

-- JaimeSC 22/06/2015: Merge desde la CPR: Lo hacemos fuera del bucle de f_cobro porque la fecha es Irrelevante:

       execute immediate '   
          merge into TMP_H_CNT_DET_COBRO a
          using (select CPA_ID, RCF_AGE_ID, RCF_SCA_ID, RCF_ESQ_ID from '||V_DATASTAGE||'.CPR_COBROS_PAGOS_RECOBRO) b
                 on (b.CPA_ID = a.COBRO_ID)   
          when matched then update set  a.ESQUEMA_COBRO_ID = b.RCF_ESQ_ID,
                                        a.AGENCIA_COBRO_ID = b. RCF_AGE_ID,
                                        a.SUBCARTERA_COBRO_ID = b.RCF_SCA_ID,
                                        a.COBRO_FACTURADO_ID = 1,
                                        a.ENVIADO_AGENCIA_COBRO_ID = 1';
                                        
       commit;

        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_COBRO. Update 5', 5;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina Bucle de Cobros', 4;
     
    -- Borrado indices H_CNT_DET_COBRO


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_COBRO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	 



            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_COBRO_FECHA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
      
    -- Cobros nuevos
    insert into H_CNT_DET_COBRO
        (DIA_ID,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,  
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA)
    select 
         DIA_ID,
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,  
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA    
    from TMP_H_CNT_DET_COBRO; 

     V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO (Cobros nuevos). Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
    end loop;
  close c_fecha;  
  
   -- Crear indices H_CNT_DET_COBRO


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_IX'', ''H_CNT_DET_COBRO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';





            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_FECHA_IX'', ''H_CNT_DET_COBRO (FECHA_COBRO, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  commit;    


  -- -------------------------- CÁLCULO DEL RESTO DE PERIODOS ----------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_CNT_DET_COBRO;
  commit;
  
  select min(FECHA_COBRO) into min_dia_cobro from TMP_H_CNT_DET_COBRO;
  select max(FECHA_COBRO) into max_dia_cobro from TMP_H_CNT_DET_COBRO;
  
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_COBRO_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_SEMANA. Empieza bucle', 3;
 
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
  select max(SEMANA_ID) into V_NUMBER from H_CNT_DET_COBRO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_CNT_DET_COBRO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
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
     
    -- Borrado indices H_CNT_DET_COBRO_SEMANA


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_COBRO_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    commit;
    
    -- Borrado de las semanas a insertar
    delete from H_CNT_DET_COBRO_SEMANA where SEMANA_ID = semana;
    commit;
    
    insert into H_CNT_DET_COBRO_SEMANA
        (SEMANA_ID,  
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,  
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA
        )
    select semana,    
         max_dia_semana,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA
    from H_CNT_DET_COBRO
    where (FECHA_COBRO between min_dia_semana and max_dia_semana);

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
     
    -- Crear indices H_CNT_DET_COBRO_SEMANA


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_SEMANA_IX'', ''H_CNT_DET_COBRO_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    

    
  end loop C_SEMANAS_LOOP;
close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_SEMANA. Termina bucle', 3;
    
  
-- ----------------------------------------------------------------------------------------------
--                                     H_CNT_DET_COBRO_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_MES. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_CNT_DET_COBRO_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
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
      
      -- Borrado indices H_CNT_DET_COBRO_MES


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_COBRO_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    
      -- Borrado de los meses a insertar
      delete from H_CNT_DET_COBRO_MES where MES_ID = mes;
      commit;
      
      insert into H_CNT_DET_COBRO_MES
        (MES_ID,  
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA
        )
    select mes,    
         max_dia_mes,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA
    from H_CNT_DET_COBRO
    where (FECHA_COBRO between min_dia_mes and max_dia_mes);  

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- Crear indices H_CNT_DET_COBRO_MES


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_MES_IX'', ''H_CNT_DET_COBRO_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    commit;    
      
  end loop C_MESES_LOOP;
  close c_mes;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_MES. Termina bucle', 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_CNT_DET_COBRO_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
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

      -- Borrado indices H_CNT_DET_COBRO


         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_COBRO_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
      commit;
      
      -- Borrado de los trimestres a insertar
      delete from H_CNT_DET_COBRO_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;
      
      insert into H_CNT_DET_COBRO_TRIMESTRE
          (TRIMESTRE_ID,
           FECHA_CARGA_DATOS,
           CONTRATO_ID,
           COBRO_ID,
           FECHA_CONTRATO,
           FECHA_COBRO,
           FECHA_FACTURA,
           TIPO_COBRO_DET_ID,
           COBRO_FACTURADO_ID,
           REMESA_FACTURA_ID,
           ESQUEMA_COBRO_ID,
           AGENCIA_COBRO_ID,
           SUBCARTERA_COBRO_ID,
           TIPO_PRODUCTO_COBRO_ID,
           GARANTIA_COBRO_ID,
           SEGMENTO_CARTERA_COBRO_ID,
           TD_IRREG_COBRO_ID,
           T_DEUDA_IRREGULAR_COBRO_ID,
           ENVIADO_AGENCIA_COBRO_ID,
           FACTURA_COBRO_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           POSICION_VENCIDA_COBRO,
           POSICION_NO_VENCIDA_COBRO,
           INT_REMUNERATORIOS_COBRO,
           INT_MORATORIOS_COBRO,
           COMISIONES_COBRO,
           GASTOS_COBRO,
           DEUDA_IRREGULAR_COBRO,
           RIESGO_VIVO_COBRO,
           NUM_DIAS_VENCIDOS_COBRO,
           IMPORTE_FACTURA_TOTAL,
           IMPORTE_FACTURA_TARIFA,
           CORRECTOR_FACTURA,
           POSICION_VENCIDA_FACTURA,
           POSICION_NO_VENCIDA_FACTURA,
           INT_REMUNERATORIOS_FACTURA,
           INT_MORATORIOS_FACTURA,
           COMISIONES_FACTURA,
           GASTOS_FACTURA
          )
      select trimestre,
           max_dia_trimestre,
           CONTRATO_ID,
           COBRO_ID,
           FECHA_CONTRATO,
           FECHA_COBRO,
           FECHA_FACTURA,
           TIPO_COBRO_DET_ID,
           COBRO_FACTURADO_ID,
           REMESA_FACTURA_ID,
           ESQUEMA_COBRO_ID,
           AGENCIA_COBRO_ID,
           SUBCARTERA_COBRO_ID,
           TIPO_PRODUCTO_COBRO_ID,
           GARANTIA_COBRO_ID,
           SEGMENTO_CARTERA_COBRO_ID,
           TD_IRREG_COBRO_ID,
           T_DEUDA_IRREGULAR_COBRO_ID,
           ENVIADO_AGENCIA_COBRO_ID,
           FACTURA_COBRO_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           POSICION_VENCIDA_COBRO,
           POSICION_NO_VENCIDA_COBRO,
           INT_REMUNERATORIOS_COBRO,
           INT_MORATORIOS_COBRO,
           COMISIONES_COBRO,
           GASTOS_COBRO,
           DEUDA_IRREGULAR_COBRO,
           RIESGO_VIVO_COBRO,
           NUM_DIAS_VENCIDOS_COBRO,
           IMPORTE_FACTURA_TOTAL,
           IMPORTE_FACTURA_TARIFA,
           CORRECTOR_FACTURA,
           POSICION_VENCIDA_FACTURA,
           POSICION_NO_VENCIDA_FACTURA,
           INT_REMUNERATORIOS_FACTURA,
           INT_MORATORIOS_FACTURA,
           COMISIONES_FACTURA,
           GASTOS_FACTURA
      from H_CNT_DET_COBRO
      where (FECHA_COBRO between min_dia_trimestre and max_dia_trimestre);            

      V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
      -- Crear indices H_CNT_DET_COBRO_TRIMESTRE


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_TRIMESTRE_IX'', ''H_CNT_DET_COBRO_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;    
    
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_TRIMESTRE. Termina bucle', 3;
    
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between min_dia_cobro and max_dia_cobro;
  -- Insert max día anterior al periodo de carga - Periodo anterior de min_dia_cobro 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_CNT_DET_COBRO_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
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
    
      -- Borrado indices H_CNT_DET_COBRO_ANIO


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_COBRO_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	 
      commit;
      
      -- Borrado de los años a insertar
      delete from H_CNT_DET_COBRO_ANIO where ANIO_ID = anio;
      commit;
      
      insert into H_CNT_DET_COBRO_ANIO
        (ANIO_ID, 
         FECHA_CARGA_DATOS,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA
        )
    select ANIO,  
         MAX_DIA_ANIO,
         CONTRATO_ID,
         COBRO_ID,
         FECHA_CONTRATO,
         FECHA_COBRO,
         FECHA_FACTURA,
         TIPO_COBRO_DET_ID,
         COBRO_FACTURADO_ID,
         REMESA_FACTURA_ID,
         ESQUEMA_COBRO_ID,
         AGENCIA_COBRO_ID,
         SUBCARTERA_COBRO_ID,
         TIPO_PRODUCTO_COBRO_ID,
         GARANTIA_COBRO_ID,
         SEGMENTO_CARTERA_COBRO_ID,
         TD_IRREG_COBRO_ID,
         T_DEUDA_IRREGULAR_COBRO_ID,
         ENVIADO_AGENCIA_COBRO_ID,
         FACTURA_COBRO_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         POSICION_VENCIDA_COBRO,
         POSICION_NO_VENCIDA_COBRO,
         INT_REMUNERATORIOS_COBRO,
         INT_MORATORIOS_COBRO,
         COMISIONES_COBRO,
         GASTOS_COBRO,
         DEUDA_IRREGULAR_COBRO,
         RIESGO_VIVO_COBRO,
         NUM_DIAS_VENCIDOS_COBRO,
         IMPORTE_FACTURA_TOTAL,
         IMPORTE_FACTURA_TARIFA,
         CORRECTOR_FACTURA,
         POSICION_VENCIDA_FACTURA,
         POSICION_NO_VENCIDA_FACTURA,
         INT_REMUNERATORIOS_FACTURA,
         INT_MORATORIOS_FACTURA,
         COMISIONES_FACTURA,
         GASTOS_FACTURA
      from H_CNT_DET_COBRO
      where (FECHA_COBRO between min_dia_anio and max_dia_anio);                     

      V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      
    -- Crear indices H_CNT_DET_COBRO_ANIO


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_COBRO_ANIO_IX'', ''H_CNT_DET_COBRO_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;       
    
  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_COBRO_ANIO. Termina bucle', 3;

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

end CARGAR_H_CNT_DET_COBRO;

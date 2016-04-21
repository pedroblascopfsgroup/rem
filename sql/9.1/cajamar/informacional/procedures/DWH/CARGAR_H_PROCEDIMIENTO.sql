create or replace PROCEDURE CARGAR_H_PROCEDIMIENTO (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable ultima modificación: María Villanueva ., PFS Group
-- Fecha ultima modificación: 21-04-2016
-- Motivos del cambio: se modifica tipo de procedimiento agregado concursal
-- Cliente: Recovery BI Cajamar
--
-- Descripción�n: Procedimiento almancenado que carga las tablas hechos H_PRC.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                                    Declaracación de variables
-- ===============================================================================================
  v_num_row NUMBER(10);
  V_SQL VARCHAR2(16000);
  V_DATASTAGE VARCHAR2(100);
  V_CM01 VARCHAR2(100);

  V_NUMBER  NUMBER(16,0);

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
  
  
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PROCEDIMIENTO';
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
--                                      H_PRC
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'H_PRC. Empiezo Carga', 3;

  execute immediate 'select max_dia_h, max_dia_mov, penult_dia_mov from ' || V_DATASTAGE || '.FECHAS_MOV' into max_dia_h, max_dia_mov, penult_dia_mov;

-- ------------------------------- PRIORIDADES PROCEDIMIENTOS ----------------------------------- 
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CODIGO_PRIORIDAD'', '''', :O_ERROR_STATUS); END;';
             execute immediate V_SQL USING OUT O_ERROR_STATUS;


  --insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P198', 3);
  --insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P199', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H036', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H037', 3);
  --insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P56', 3);
  --insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P63', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H041', 3);
  --insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P24', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H023', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H025', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H019', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H029', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H017', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H031', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H033', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H035', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H001', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H022', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H020', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H016', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H021', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H039', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H024', 2);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H026', 2);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('H018', 1);

-- --------------------------------------------------------------- PRC_PROCEDIMIENTOS_JERARQUIA ---------------------------------------------------------------
  -- Borrado �ndices TMP_PRC_JERARQUIA
 
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_JERARQUIA_ITER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_JERARQUIA_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_JERARQUIA_ULT_FASE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;    
      
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
             execute immediate V_SQL USING OUT O_ERROR_STATUS;

  commit;
  
  -- Si DATE_START no existe en PRC_PROCEDIMIENTOS_JERARQUIA cogemos la última anterior que haya en PRC_PROCEDIMIENTOS_JERARQUIA
  execute immediate 'select count(1) from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO = '''||DATE_START||'''' into existe_date_start;
  
  if(existe_date_start = 0) then
    execute immediate 'select max(FECHA_PROCEDIMIENTO) from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO <= '''||DATE_START||'''' into max_dia_pre_start;

    execute immediate 'insert into TMP_PRC_JERARQUIA (
      DIA_ID,                               
      ITER,
      FASE_ACTUAL, 
      NIVEL,
      CONTEXTO,
      CODIGO_FASE_ACTUAL,
      PRIORIDAD_FASE,
      CANCELADO_FASE,
      ASU_ID,
      MOTIVO_PARALIZACION_ID
    ) 
  select '''||DATE_START||''',
      pj_PADRE,
      PRC_ID,
      NIVEL,
      PATH_DERIVACION,
      PRC_TPO,
      NVL(PRIORIDAD, 0),
      CANCEL_PRC,
      ASU_ID,
      -1
  from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA
  left join TMP_PRC_CODIGO_PRIORIDAD on PRC_TPO = DD_TIPO_CODIGO
  where FECHA_PROCEDIMIENTO = '''||max_dia_pre_start||'''';
  commit;
  end if;
  
  execute immediate 'insert into TMP_PRC_JERARQUIA (
      DIA_ID,                               
      ITER,
      FASE_ACTUAL, 
      NIVEL,
      CONTEXTO,
      CODIGO_FASE_ACTUAL,
      PRIORIDAD_FASE,
      CANCELADO_FASE,
      ASU_ID
    ) 
  select FECHA_PROCEDIMIENTO,
      pj_PADRE,
      PRC_ID,
      NIVEL,
      PATH_DERIVACION,
      PRC_TPO,
      NVL(PRIORIDAD, 0),
      CANCEL_PRC,
      ASU_ID
  from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA
  left join TMP_PRC_CODIGO_PRIORIDAD on PRC_TPO = DD_TIPO_CODIGO
  where FECHA_PROCEDIMIENTO between '''||DATE_START||''' and '''||DATE_END||'''';
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_JERARQUIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    

  
  -- Rellenar los d�as que no tienen entradas de procedimientos. No ha existido ning�n movimiento. La foto es la del d�a anterior.  
  open c_fecha_rellenar;
  loop --RELLENAR_LOOP
    fetch c_fecha_rellenar into fecha_rellenar;        
    exit when c_fecha_rellenar%NOTFOUND;
      
      -- Si un d�a no ha habido movimiento copiamos dia anterior
      select count(DIA_ID) into v_num_row from TMP_PRC_JERARQUIA where DIA_ID = fecha_rellenar;
      if(v_num_row = 0) then 
        insert into TMP_PRC_JERARQUIA(
            DIA_ID,                               
            ITER,   
            FASE_ACTUAL, 
            NIVEL,
            CONTEXTO,
            CODIGO_FASE_ACTUAL,    
            PRIORIDAD_FASE,
            CANCELADO_FASE,
            ASU_ID 
            )
        select DIA_ID + 1,                             
            ITER,   
            FASE_ACTUAL, 
            NIVEL,
            CONTEXTO,
            CODIGO_FASE_ACTUAL,   
            PRIORIDAD_FASE,
            CANCELADO_FASE,
            ASU_ID
        from TMP_PRC_JERARQUIA where DIA_ID = (fecha_rellenar-1);
      end if; 
      
      -- Tabla auxiliar de recovery para hist�ricos BI (subtotal...)
      select count(FECHA_VALOR) into v_num_row from TMP_PRC_EXTRAS_RECOVERY_BI where FECHA_VALOR = fecha_rellenar;
      if(v_num_row = 0) then 
      insert into TMP_PRC_EXTRAS_RECOVERY_BI(
          FECHA_VALOR,
          TIPO_ENTIDAD,
          UNIDAD_GESTION,
          DD_IFB_ID,
          VALOR
          )
      select FECHA_VALOR+1,                             
          TIPO_ENTIDAD,
          UNIDAD_GESTION,
          DD_IFB_ID,
          VALOR
          from TMP_PRC_EXTRAS_RECOVERY_BI where FECHA_VALOR = (fecha_rellenar - 1);
      end if;  
  end loop;
  close c_fecha_rellenar;


  -- Crear indices TMP_PRC_JERARQUIA


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_JERARQUIA_ITER_IX'', ''TMP_PRC_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;  


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_JERARQUIA_FASE_ACT_IX'', ''TMP_PRC_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;  


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_JERARQUIA_ULT_FASE_IX'', ''TMP_PRC_JERARQUIA (DIA_ID, ULTIMA_FASE)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;




  commit;  
    

-- ------------------------------------------------------------- FIN PRC_PROCEDIMIENTOS_JERARQUIA -------------------------------------------------------------
  /*
  -- Tabla temporal de cobros asociados a contratos
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_COBROS'', '''', :O_ERROR_STATUS); END;';
             execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  execute immediate
  'insert into TMP_PRC_COBROS (FECHA_COBRO, CONTRATO, IMPORTE, REFERENCIA)
  select trunc(FECHA_COBRO), CNT_ID, IMPORTE, REFERENCIA from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO IAC
  join '||V_DATASTAGE||'.MOVIMIENTO_GALICIA MG on IAC.IAC_VALUE_COBRO = MG.NUM_CONTRATO where DD_IFC_ID=34';
  
  insert into TMP_PRC_COBROS (FECHA_COBRO, CONTRATO, IMPORTE, REFERENCIA)
  select trunc(FECHA_COBRO), CNT_ID, IMPORTE, REFERENCIA from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO IAC
  join '||V_DATASTAGE||'.CPA_COBROS_PAGOS MG on IAC.IAC_VALUE_COBRO = MG.NUM_CONTRATO where DD_IFC_ID=34; 
  */
  
  -- Borrado �ndices TMP_PRC_CARTERA
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_CARTERA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;   
  
  -- Tabla temporal con relaci�n contrato-cartera a la que pertenece
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CARTERA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

  
  execute immediate 'insert into TMP_PRC_CARTERA (CONTRATO, CARTERA)
                      select CNT.CNT_ID, (case IAC_VALUE when ''2038'' then 0
                                                         when ''05074'' then 1
                                                         else -1 end)                                                       
                      from '||V_DATASTAGE||'.CNT_CONTRATOS cnt 
                      join '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO iac on cnt.CNT_ID = iac.CNT_ID
                      where cnt.BORRADO = 0 and iac.DD_IFC_ID = 31';
  V_ROWCOUNT := sql%rowcount;     
  commit;

  -- Crear indices TMP_PRC_CARTERA
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_CARTERA_IX'', ''TMP_PRC_CARTERA (CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;






  commit;    
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_CARTERA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
  
  /*
  execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  execute immediate
  'insert into TMP_PRC_EXTRAS_RECOVERY_BI(FECHA_VALOR, TIPO_ENTIDAD, UNIDAD_GESTION, DD_IFB_ID, VALOR)
  select trunc(IAB_FECHA_VALOR), DD_EIN_ID, IAB_ID_UNIDAD_GESTION, DD_IFB_ID, IAB_VALOR from '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI_H';
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_EXTRAS_RECOVERY_BI. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
  */
   /* 
  -- Tabla temporal con relaci�n contrato-fecha contable de litigio
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_FECHA_CONTABLE_LITIGIO'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  execute immediate
  'insert into TMP_PRC_FECHA_CONTABLE_LITIGIO (CONTRATO, FECHA_CONTABLE_LITIGIO)
  select CNT.CNT_ID, trunc(IAC_VALUE)
  from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO IAC 
  join '||V_DATASTAGE||'.CNT_CONTRATOS CNT on CNT.CNT_ID = IAC.CNT_ID
  join '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE CEX on IAC.CNT_ID = CEX.CNT_ID
  where CNT.BORRADO = 0 and DD_IFC_ID = 12 and CEX.CEX_PASE=1
  group by CNT.CNT_ID, IAC_VALUE';
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_FECHA_CONTABLE_LITIGIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
  */
  
   /* 
  -- Incluir fechas que vienen con otro formato
  execute immediate
  'update TMP_PRC_FECHA_CONTABLE_LITIGIO TPFC set FECHA_CONTABLE_LITIGIO = (select trunc(IAC_VALUE) from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO IAC where IAC.CNT_ID = TPFC.CONTRATO and DD_IFC_ID = 12)
  where FECHA_CONTABLE_LITIGIO is null';
  */
  
  
  -- Tabla temporal con relaci�n contrato-primer titular del contrato con pase
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TITULAR'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

  
  execute immediate 'insert into TMP_PRC_TITULAR (PROCEDIMIENTO, CONTRATO, TITULAR_PROCEDIMIENTO)
                      select PRC_ID, cex.CNT_ID, p.PER_ID 
                      from '||V_DATASTAGE||'.PER_PERSONAS p
                      join '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS cpe on p.PER_ID = cpe.PER_ID
                      join '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex on cpe.CNT_ID = cex.CNT_ID
                      join '||V_DATASTAGE||'.PRC_CEX prcex on prcex.CEX_ID = cex.CEX_ID
                      JOIN '||V_DATASTAGE||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID
                      where DD_TIN_TITULAR = 1 and CPE_ORDEN = 1 and cex.CEX_PASE = 1
                      group by PRC_ID, cex.CNT_ID, p.PER_ID';
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
  
    
  -- Tabla temporal con relaci�n de los contratos asociados al procedimiento en el que el/los demandados intervienen como 1er o 2� titular
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_DEMANDADO'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

  
  execute immediate 'insert into TMP_PRC_DEMANDADO (PROCEDIMIENTO, CONTRATO, DEMANDADO)
                      select PRCPER.PRC_ID, CNT_ID, PRCPER.PER_ID 
                      from '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS CPE
                      join '||V_DATASTAGE||'.PRC_PER PRCPER on CPE.PER_ID = PRCPER.PER_ID 
                      JOIN '||V_DATASTAGE||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID
                      where DD_TIN_TITULAR = 1 and CPE_ORDEN = 1';
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_DEMANDADO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
 
 
 
-- ------------------------------------------------------------------ BUCLE TMP_H_PRC -------------------------------------------------------------------
-- Bucle que recorre los d�as. Para cada d�a calculo el tipo de procedimiento (m�ximo valor de las actuaciones que lo conforman)

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'Empiezo Bucle H_PRC', 4;
  
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;
      
    -- TMP_PRC_DETALLE - Tabla auxiliar con el detalle diario. Reinicio para cada d�a
    -- Borrado �ndices TMP_PRC_DETALLE
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_DETALLE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_DETALLE'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate 'insert into TMP_PRC_DETALLE(ITER) select distinct ITER from TMP_PRC_JERARQUIA where DIA_ID = '''||fecha||'''';    
    commit;
    
    -- Crear indices TMP_PRC_DETALLE
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_DETALLE_IX'', ''TMP_PRC_DETALLE (ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;






    commit;    

    

    -- -------------------------------------------- FASE MAX PRIORIDAD -------------------------------------------- -------------------------------------
    --29/04/2015 --- se pasa al SP CREAR_H_PROCEDIMIENTO --> 24/11/2015.

   -- select count(*) into nCount  from user_tables where table_name = 'TMP_PRC_ITER_JERARQUIA';
  --  if nCount = 0 then execute immediate 'CREATE TABLE TMP_PRC_ITER_JERARQUIA (iter NUMBER(16,0), MAX_PRIORIDAD NUMBER(16,0), MAX_FASE_ACTUAL NUMBER(16,0), NUM_FASES NUMBER(16,0), CANCELADO_FASE  NUMBER(16,0))'; end if;
   -- commit;

    -- Borrar indices TMP_PRC_ITER_JERARQUIA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_ITER_JERARQUIA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
  
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ITER_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate 'insert into TMP_PRC_ITER_JERARQUIA(ITER, MAX_PRIORIDAD, MAX_FASE_ACTUAL, NUM_FASES, CANCELADO_FASE) select ITER,  MAX(PRIORIDAD_FASE), MAX(FASE_ACTUAL), count(*), SUM(CANCELADO_FASE) from TMP_PRC_JERARQUIA group by ITER';    
    commit;

    -- Crear indices TMP_PRC_MAX_JERARQUIA


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ITER_JERARQUIA_IX'', ''TMP_PRC_ITER_JERARQUIA (iter)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS; 




    --Merge TMP_PRC_DETALLE
    execute immediate 'merge into TMP_PRC_DETALLE t1 using TMP_PRC_ITER_JERARQUIA t2 on (t1.ITER = t2.ITER) when matched then update set t1.MAX_PRIORIDAD = t2.MAX_PRIORIDAD, t1.NUM_FASES = t2.NUM_FASES, t1.CANCELADO_FASE = t2.CANCELADO_FASE';      
    commit;
    --29/04/2015
    
    
    -- Calculamos la m�xima prioridad del procedimiento en la fecha.
--    execute immediate 'update TMP_PRC_DETALLE pd set MAX_PRIORIDAD = (select MAX(PRIORIDAD_FASE) from TMP_PRC_JERARQUIA pj where pj.DIA_ID = '''||fecha||'''  and pj.ITER = pd.ITER)';      
--    commit;
    -- Asignamos la prioridad a todos las actuaciones del procedimiento.
    execute immediate 'merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t1.ITER = t2.ITER) when matched then update set t1.PRIORIDAD_PROCEDIMIENTO = t2.MAX_PRIORIDAD where DIA_ID = '''||fecha||'''';  
    commit;
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select MAX(FASE_ACTUAL) MAX_FASE_ACTUAL, ITER from TMP_PRC_JERARQUIA where DIA_ID = '''||fecha||''' and PRIORIDAD_PROCEDIMIENTO = PRIORIDAD_FASE group by ITER) t2 on (t1.ITER = t2.ITER) when matched then update set t1.FASE_MAX_PRIORIDAD = t2.MAX_FASE_ACTUAL';      
    commit;
    execute immediate 'merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t1.ITER = t2.ITER) when matched then update set t1.FASE_MAX_PRIORIDAD = t2.FASE_MAX_PRIORIDAD where DIA_ID = '''||fecha||'''';  
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_DETALLE y TMP_PRC_JERARQUIA. Update 1', 5;
      
      
    -- -------------------------------------------- PROCEDIMIENTO CANCELADO -----------------------------------------------------------------------------
  -- Fechas EXT_IAB_INFO_ADD_BI_H / EXT_IAB_INFO_ADD_BI
    execute immediate 'select max(TRUNC(IAB_FECHA_VALOR)) from '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI_H where TRUNC(IAB_FECHA_VALOR) <= '''||fecha||'''' into max_dia_add_bi_h;
    execute immediate 'select max(TRUNC(IAB_FECHA_VALOR)) from '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI' into max_dia_add_bi;

    -- N�mero de fases del procedimiento ese d�a
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select count(*) NUM_FASES, ITER from TMP_PRC_JERARQUIA where DIA_ID = '''||fecha||''' GROUP BY ITER) t2 on (t1.ITER = t2.ITER) when matched then update set t1.NUM_FASES = t2.NUM_FASES';
    commit;

    -- Procedimiento cancelado si todas sus fases est�n canceladas
 -- Fecha de an�lisis en EXT_IAB_INFO_ADD_BI_H 
    if (fecha <= max_dia_add_bi_h) then
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select SUM(decode(IAB_VALOR, 4, 1, 5, 1, 9, 1, 0)) SUM_CANCELADO_FASE, IAB_ID_UNIDAD_GESTION from '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI_H where DD_IFB_ID = 2 and TRUNC(IAB_FECHA_VALOR) = '''||fecha||''' GROUP BY IAB_ID_UNIDAD_GESTION) t2 on (t1.ITER = t2.IAB_ID_UNIDAD_GESTION) when matched then update set t1.CANCELADO_FASE = t2.SUM_CANCELADO_FASE';
    commit;
    end if;
    -- Fecha de an�lisis en EXT_IAB_INFO_ADD_BI - �ltimo d�a
    if (fecha = max_dia_add_bi) then
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select SUM(decode(IAB_VALOR, 4, 1, 5, 1, 9, 1, 0)) SUM_CANCELADO_FASE, IAB_ID_UNIDAD_GESTION from '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI where DD_IFB_ID = 2 and TRUNC(IAB_FECHA_VALOR) = '''||fecha||''' GROUP BY IAB_ID_UNIDAD_GESTION) t2 on (t1.ITER = t2.IAB_ID_UNIDAD_GESTION) when matched then update set t1.CANCELADO_FASE = t2.SUM_CANCELADO_FASE';
    commit;
    end if;


/*
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select SUM(CANCELADO_FASE) SUM_CANCELADO_FASE, ITER from TMP_PRC_JERARQUIA where DIA_ID = '''||fecha||''' GROUP BY ITER) t2 on (t1.ITER = t2.ITER) when matched then update set t1.CANCELADO_FASE = t2.SUM_CANCELADO_FASE';
    commit;
*/

    execute immediate 'update TMP_PRC_DETALLE set CANCELADO_PROCEDIMIENTO = (case when NUM_FASES = CANCELADO_FASE then 1 else 0 end)';
    commit;

    -- Asignamos cancelado (1) o no Cancelado (0) a todos las actuaciones del procedimiento y Calculamos n�mero de fases
    execute immediate 'merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t1.ITER = t2.ITER) when matched then update set t1.CANCELADO_PROCEDIMIENTO = t2.CANCELADO_PROCEDIMIENTO, t1.NUM_FASES = t2.NUM_FASES where DIA_ID = '''||fecha||''''; 
  commit;
    
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_DETALLE y TMP_PRC_JERARQUIA. Update 2', 5;
      
      
    -- ------------------ ULT_TAR_CREADA / ULT_TAR_FIN / ULTIMA_TAREA_ACTUALIZADA / ULT_TAR_PEND ------------------------------
    -- Borrado �ndices TMP_PRC_TAREA
   
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_TAREA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TAREA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

      
    execute immediate 'insert into TMP_PRC_TAREA(ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA) 
      select pj.ITER, pj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN, tar.TAR_TAREA 
        from TMP_PRC_JERARQUIA pj
        join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on pj.FASE_ACTUAL = tar.PRC_ID 
      where DIA_ID = '''||fecha||''' and trunc(tar.TAR_FECHA_INI) <= '''||fecha||'''';
    V_ROWCOUNT := sql%rowcount;     
    commit;
    
     -- Crear indices TMP_PRC_TAREA
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_TAREA_IX'', ''TMP_PRC_TAREA (ITER, TAREA)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;






    commit;    
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TAREA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;    
       
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_AUTO_PRORROGAS'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;


    execute immediate 'insert into TMP_PRC_AUTO_PRORROGAS (TAREA, FECHA_AUTO_PRORROGA) 
                        select tex.TAR_ID, trunc(mej.FECHACREAR)
                        from '||V_DATASTAGE||'.MEJ_REG_REGISTRO mej
                        join '||V_DATASTAGE||'.MEJ_IRG_INFO_REGISTRO info on mej.REG_ID = info.REG_ID
                        join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on info.IRG_VALOR = tex.TEX_ID
                        where mej.DD_TRG_ID = 4 and info.IRG_CLAVE = ''tarID'' and trunc(mej.FECHACREAR) <= '''||fecha||'''';
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_AUTO_PRORROGAS. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;    

                                                                    
    -- Incluir las fechas de prr�rroga y autopr�rroga
    execute immediate 'merge into TMP_PRC_TAREA t1 using (select max(FECHA_AUTO_PRORROGA) MAX_FECHA_AUTO_PRORROGA, TAREA from TMP_PRC_AUTO_PRORROGAS group by TAREA) t2 on (t1.TAREA = t2.TAREA) when matched then update set t1.FECHA_AUTO_PRORROGA = t2.MAX_FECHA_AUTO_PRORROGA'; 
    commit;
    
    execute immediate 'merge into TMP_PRC_TAREA t1 using (select max(FECHACREAR) MAX_FECHACREAR, TAR_ID from '||V_DATASTAGE||'.SPR_SOLICITUD_PRORROGA where trunc(FECHACREAR) <= '''||fecha||''' group by TAR_ID) t2 on (t1.TAREA = t2.TAR_ID) when matched then update set t1.FECHA_PRORROGA = t2.MAX_FECHACREAR'; 
    commit;
      -- ULT_TAR_CREADA de cada procedimiento
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(FECHA_INI) MAX_FECHA_INI, ITER from TMP_PRC_TAREA where trunc(FECHA_INI) <= '''||fecha||''' and FECHA_INI is not null group by ITER) t2 on (t1.ITER = t2.ITER) when matched then update set t1.FECHA_ULT_TAR_CREADA = t2.MAX_FECHA_INI'; 
    commit;
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(TAREA) MAX_TAREA, ITER, FECHA_INI from TMP_PRC_TAREA group by ITER, FECHA_INI) t2 on (t1.ITER = t2.ITER and t1.FECHA_ULT_TAR_CREADA = t2.FECHA_INI) when matched then update set t1.ULT_TAR_CREADA = t2.MAX_TAREA';
    commit;
    -- ULT_TAR_FIN de cada procedimiento
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(FECHA_FIN) MAX_FECHA_FIN, ITER, FECHA_INI from TMP_PRC_TAREA where trunc(FECHA_FIN) <= '''||fecha||''' and FECHA_FIN is not null group by ITER, FECHA_INI) t2 on (t1.ITER = t2.ITER and t1.FECHA_ULT_TAR_CREADA = t2.FECHA_INI) when matched then update set t1.FECHA_ULT_TAR_FIN = t2.MAX_FECHA_FIN'; 
    commit;
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(TAREA) MAX_TAREA, ITER, FECHA_FIN from TMP_PRC_TAREA group by ITER, FECHA_FIN) t2 on (t1.ITER = t2.ITER and t1.FECHA_ULT_TAR_FIN = t2.FECHA_FIN) when matched then update set t1.ULT_TAR_FIN = t2.MAX_TAREA'; 
    commit;
    -- ULTIMA_TAREA_ACTUALIZADA de cada procedimiento (Algoritmo voraz)
    execute immediate 'update TMP_PRC_TAREA set FECHA_ACTUALIZACION = FECHA_INI where trunc(FECHA_INI) <= '''||fecha||'''';
    commit;
    execute immediate 'update TMP_PRC_TAREA set FECHA_ACTUALIZACION = FECHA_FIN where FECHA_FIN >= FECHA_ACTUALIZACION and trunc(FECHA_FIN) <= '''||fecha||'''';
    commit;
    execute immediate 'update TMP_PRC_TAREA set FECHA_ACTUALIZACION = FECHA_PRORROGA where FECHA_PRORROGA >= FECHA_ACTUALIZACION and trunc(FECHA_PRORROGA) <= '''||fecha||'''';
    commit;
    execute immediate 'update TMP_PRC_TAREA set FECHA_ACTUALIZACION = FECHA_AUTO_PRORROGA where FECHA_PRORROGA >= FECHA_ACTUALIZACION and trunc(FECHA_AUTO_PRORROGA) <= '''||fecha||'''';
    commit;
                                                                         
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(FECHA_ACTUALIZACION) MAX_FECHA_ACTUALIZACION, ITER from TMP_PRC_TAREA where FECHA_ACTUALIZACION is not null group by ITER) t2 on (t1.ITER = t2.ITER) when matched then update set t1.FECHA_ULTIMA_TAREA_ACTUALIZADA = t2.MAX_FECHA_ACTUALIZACION'; 
    commit;
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(TAREA) MAX_TAREA, ITER, FECHA_ACTUALIZACION from TMP_PRC_TAREA group by ITER, FECHA_ACTUALIZACION) t2 on (t1.ITER = t2.ITER and t2.FECHA_ACTUALIZACION = t1.FECHA_ULTIMA_TAREA_ACTUALIZADA) when matched then update set t1.ULTIMA_TAREA_ACTUALIZADA = t2.MAX_TAREA'; 
    commit;
    -- ULT_TAR_PEND de cada procedimiento
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(FECHA_INI) MAX_FECHA_INI, ITER from TMP_PRC_TAREA where trunc(FECHA_INI) <= '''||fecha||''' and FECHA_INI is not null and FECHA_FIN is null group by ITER) t2 on (t1.ITER = t2.ITER) when matched then update set t1.FECHA_ULT_TAR_PEND = t2.MAX_FECHA_INI'; 
    commit;
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(TAREA) MAX_TAREA, ITER, FECHA_INI from TMP_PRC_TAREA group by ITER, FECHA_INI) t2 on (t1.ITER = t2.ITER and t2.FECHA_INI = t1.FECHA_ULT_TAR_PEND) when matched then update set t1.ULT_TAR_PEND = t2.MAX_TAREA'; 
    commit;
    
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TAREA y TMP_PRC_DETALLE. Updates', 5;
    
      
    -- Actualizamos TMP_PRC_JERARQUIA
  execute immediate 'merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t1.ITER = t2.ITER) when matched then update set t1.ULT_TAR_CREADA = t2.ULT_TAR_CREADA, t1.FECHA_ULT_TAR_CREADA = t2.FECHA_ULT_TAR_CREADA, t1.ULT_TAR_FIN = t2.ULT_TAR_FIN, t1.FECHA_ULT_TAR_FIN = t2.FECHA_ULT_TAR_FIN, t1.ULTIMA_TAREA_ACTUALIZADA = t2.ULTIMA_TAREA_ACTUALIZADA, t1.FECHA_ULTIMA_TAREA_ACTUALIZADA = t2.FECHA_ULTIMA_TAREA_ACTUALIZADA, t1.ULT_TAR_PEND = t2.ULT_TAR_PEND, t1.FECHA_ULT_TAR_PEND = t2.FECHA_ULT_TAR_PEND where DIA_ID = '''||fecha||''''; 
    commit;
      
    -- Fase actual = Fase que tiene la �ltima tarea creada. Si no tiene tarea la obtenemos por el prc_id. 
  execute immediate 'merge into TMP_PRC_DETALLE t1 using TMP_PRC_TAREA t2 on (t1.ITER = t2.ITER and t2.TAREA = t1.ULT_TAR_CREADA) when matched then update set t1.FASE_ACTUAL = t2.FASE'; 
    commit;
    execute immediate 'merge into TMP_PRC_DETALLE t1 using (select max(FASE_ACTUAL) MAX_FASE_ACTUAL, ITER from TMP_PRC_JERARQUIA where DIA_ID = '''||fecha||''' group by ITER) t2 on (t1.ITER = t2.ITER) when matched then update set t1.FASE_ACTUAL = t2.MAX_FASE_ACTUAL WHERE FASE_ACTUAL is null'; 
    commit;
    -- Seleccionamos la fase que usaremos para insertar en H_PRC                                                         
    execute immediate 'merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t1.ITER = t2.ITER) when matched then update set t1.ULTIMA_FASE = t2.FASE_ACTUAL where DIA_ID = '''||fecha||''''; 
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_JERARQUIA. Updates', 5;  
 /*     
    -- ------------------------------------------------------------ FECHAS COMUNES ------------------------------------------------------------
    -- Fecha Interposici�n demanda - Truncamos y volvemos a usar la tabla TMP_PRC_TAREA para las demandas
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TAREA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

      
    execute immediate
      'insert into TMP_PRC_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
      select  Tpj.ITER, Tpj.FASE_ACTUAL, TAR.TAR_ID, TAR.TAR_FECHA_INI, NVL(TAR.TAR_FECHA_FIN, ''0000-00-00 00:00:00''), TAR.TAR_TAREA ,TAP_ID,tex.TEX_ID, TEV_NOMBRE, trunc(TEV_VALOR)
      from TMP_PRC_JERARQUIA Tpj
          join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR on Tpj.FASE_ACTUAL = TAR.PRC_ID 
          join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on TAR.TAR_ID = tex.TAR_ID
          join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV on tex.TEX_ID = TEV.TEX_ID
          where DIA_ID =  :fecha and trunc(TAR.TAR_FECHA_INI) <= :fecha and
            TEV.TEV_NOMBRE IN (''fecha'', ''fechaSolicitud'', ''fechainterposicion'', ''fechaInterposicion'', ''fechaDemanda'') 
          and tex.TAP_ID IN (229, 240, 256, 270, 281, 301, 317, 427)' USING fecha, fecha;
     V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TAREA. Registros Insertados (1): ' || TO_CHAR(V_ROWCOUNT), 5;    
          
    execute immediate 'update TMP_PRC_DETALLE pd set FECHA_INTERPOSICION_DEMANDA = (select max(FECHA_FORMULARIO) from TMP_PRC_TAREA pt where pd.ITER = pt.ITER and trunc(pt.FECHA_INI) <= '''||fecha||''' and FECHA_FIN <> ''0000-00-00 00:00:00'')';
    execute immediate 'update TMP_PRC_JERARQUIA pj set FECHA_INTERPOSICION_DEMANDA = (select FECHA_INTERPOSICION_DEMANDA from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = '''||fecha||''''; 
      
    -- Fecha Aceptaci�n - Fecha de Tr�mite de aceptaci�n y decisi�n (Fecha final de la tarea "Registrar toma de decisi�n")
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TAREA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

      
    execute immediate
      'insert into TMP_PRC_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
      select Tpj.ITER, Tpj.FASE_ACTUAL, TAR.TAR_ID, TAR.TAR_FECHA_INI, NVL(TAR.TAR_FECHA_FIN, ''0000-00-00 00:00:00''), TAR.TAR_TAREA ,TAP_ID,tex.TEX_ID, TEV_NOMBRE, trunc(TEV_VALOR)
      from TMP_PRC_JERARQUIA Tpj
          join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR on Tpj.FASE_ACTUAL = TAR.PRC_ID 
          join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on TAR.TAR_ID = tex.TAR_ID
          join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV on tex.TEX_ID = TEV.TEX_ID
          where DIA_ID = :fecha and trunc(TAR.TAR_FECHA_INI) <= :fecha and TEV.TEV_NOMBRE IN (''fecha'') and tex.TAP_ID IN (1004, 10000000000200)' USING fecha, fecha;
     V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TAREA. Registros Insertados (2): ' || TO_CHAR(V_ROWCOUNT), 5;    
            
    execute immediate 'update TMP_PRC_DETALLE pd set FECHA_ACEPTACION = (select max(FECHA_FORMULARIO) from TMP_PRC_TAREA pt where pd.ITER = pt.ITER and trunc(pt.FECHA_INI) <= '''||fecha||''' and FECHA_FIN <> ''0000-00-00 00:00:00'')';
    execute immediate 'update TMP_PRC_JERARQUIA pj set FECHA_ACEPTACION = (select FECHA_ACEPTACION from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = '''||fecha||''''; 
  
    -- Recogida de documentaci�n y aceptaci�n (1� tarea del Tr�mite de aceptaci�n y decisi�n)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TAREA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;


    execute immediate      
      'insert into TMP_PRC_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA) 
      select Tpj.ITER, Tpj.FASE_ACTUAL, TAR.TAR_ID, TAR.TAR_FECHA_INI, NVL(TAR.TAR_FECHA_FIN, ''0000-00-00 00:00:00''), TAR.TAR_TAREA
      from TMP_PRC_JERARQUIA Tpj
      join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR on Tpj.FASE_ACTUAL = TAR.PRC_ID 
          where DIA_ID = :fecha and trunc(TAR.TAR_FECHA_INI) <= :fecha and TAR_TAREA = ''Recogida de documentaci�n y aceptaci�n'' and TAR.TAR_FECHA_FIN is not null' USING fecha, fecha;
     V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TAREA. Registros Insertados (3): ' || TO_CHAR(V_ROWCOUNT), 5;    
           
    execute immediate 'update TMP_PRC_DETALLE pd set FECHA_RECOGIDA_DOC_Y_ACEPT = (select max(FECHA_FIN) from TMP_PRC_TAREA pt where pd.ITER = pt.ITER and trunc(pt.FECHA_INI) <= '''||fecha||''')';
    execute immediate 'update TMP_PRC_JERARQUIA pj set FECHA_RECOGIDA_DOC_Y_ACEPT = (select FECHA_RECOGIDA_DOC_Y_ACEPT from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = '''||fecha||''''; 
  
    -- Registrar toma de decisi�n (2� tarea del Tr�mite de aceptaci�n y decisi�n)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TAREA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;



    execute immediate      
      'insert into TMP_PRC_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA) 
      select Tpj.ITER, Tpj.FASE_ACTUAL, TAR.TAR_ID, TAR.TAR_FECHA_INI, NVL(TAR.TAR_FECHA_FIN, ''0000-00-00 00:00:00''), TAR.TAR_TAREA
      from TMP_PRC_JERARQUIA Tpj
      join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR on Tpj.FASE_ACTUAL = TAR.PRC_ID 
          where DIA_ID = :fecha and trunc(TAR.TAR_FECHA_INI) <= :fecha and TAR_TAREA = ''Registrar toma de decisi�n'' and TAR.TAR_FECHA_FIN is not null' USING fecha, fecha;
     V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TAREA. Registros Insertados (4): ' || TO_CHAR(V_ROWCOUNT), 5;    
            
    execute immediate 'update TMP_PRC_DETALLE pd set FECHA_REGISTRAR_TOMA_DECISION = (select max(FECHA_FIN) from TMP_PRC_TAREA pt where pd.ITER = pt.ITER and trunc(pt.FECHA_INI) <= '''||fecha||''')';
    execute immediate 'update TMP_PRC_JERARQUIA pj set FECHA_REGISTRAR_TOMA_DECISION = (select FECHA_REGISTRAR_TOMA_DECISION from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = '''||fecha||''''; 
  
    -- Fecha recepci�n documentaci�n completa - (Fecha introducida por pantalla en la 2� tarea del Tr�mite de aceptaci�n y decisi�n)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_TAREA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

    
    execute immediate  
      'insert into TMP_PRC_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
      select Tpj.ITER, Tpj.FASE_ACTUAL, TAR.TAR_ID, TAR.TAR_FECHA_INI, NVL(TAR.TAR_FECHA_FIN, ''0000-00-00 00:00:00''), TAR.TAR_TAREA ,TAP_ID,tex.TEX_ID, TEV_NOMBRE, trunc(TEV_VALOR)
      from TMP_PRC_JERARQUIA Tpj
          join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR on Tpj.FASE_ACTUAL = TAR.PRC_ID 
          join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on TAR.TAR_ID = tex.TAR_ID
          join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV on tex.TEX_ID = TEV.TEX_ID
          where DIA_ID = :fecha and trunc(TAR.TAR_FECHA_INI) <= :fecha and TEV.TEV_NOMBRE IN (''fecha'') and tex.TAP_ID IN (1004, 10000000000200)' USING fecha, fecha;
     V_ROWCOUNT := sql%rowcount;     
      commit;
    
       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_TAREA. Registros Insertados (5): ' || TO_CHAR(V_ROWCOUNT), 5;    
          
    execute immediate 'update TMP_PRC_DETALLE pd set FECHA_RECEPCION_DOC_COMPLETA = (select max(FECHA_FORMULARIO) from TMP_PRC_TAREA pt where pd.ITER = pt.ITER and trunc(pt.FECHA_INI) <= '''||fecha||''' and FECHA_FIN <> ''0000-00-00 00:00:00'')';
    execute immediate 'update TMP_PRC_JERARQUIA pj set FECHA_RECEPCION_DOC_COMPLETA = (select FECHA_RECEPCION_DOC_COMPLETA from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = '''||fecha||''''; 
 */
 
    -- ----------------------------------------------------------------------------------------------
    -- TEMP_PROCEDIMIENTO_CONTRATO - SALDOS DE CONTRATOS ASOCIADOS A PROCEDIMIENTOS
    -- ----------------------------------------------------------------------------------------------
    -- Borrado �ndices TMP_PRC_CONTRATO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_CONTRATO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_CONTRATO_CEX_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CONTRATO'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

    
    -- Fecha de analisis en H_MOV_MOVIMIENTOS (fecha menor que el ultimno d�a de H_MOV_MOVIMIENTOS o mayor que este, pero menor que el pen�ltimo dia de MOV_MOVIMIENTOS)
    if((fecha <= max_dia_h) or ((fecha > max_dia_h) and (fecha < penult_dia_mov))) then
      execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_CM01 || '.H_MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) <= to_date(''' || fecha || ''')' into max_dia_con_contratos;  
    
      execute immediate 'insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
                          select prc.PRC_ID, hmov.CNT_ID, cex.CEX_ID, hmov.MOV_POS_VIVA_VENCIDA, hmov.MOV_POS_VIVA_NO_VENCIDA, hmov.MOV_EXTRA_1, hmov.MOV_FECHA_POS_VENCIDA 
                               from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc
                               join '||V_DATASTAGE||'.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                               join '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                               join '||V_CM01||'.H_MOV_MOVIMIENTOS hmov on cex.CNT_ID = hmov.CNT_ID
                          where MOV_FECHA_EXTRACCION = :max_dia_con_contratos' USING max_dia_con_contratos;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_PRC_CONTRATO. H_MOV_MOVIMIENTOS 1. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;
    
      -- Contratos anteriores que ya no vienen y tienen sus �ltimos movimientos en MOV_MOVIMIENTOS
      execute immediate 'insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
                          select prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA 
                               from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc
                               join '||V_DATASTAGE||'.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                               join '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                               join '||V_DATASTAGE||'.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
                           where MOV_FECHA_EXTRACCION <= :penult_dia_mov and MOV_FECHA_EXTRACCION <= :fecha 
                           group by prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA  having count(*) >= 2'
                           USING penult_dia_mov, fecha;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_PRC_CONTRATO. H_MOV_MOVIMIENTOS 2. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;
    
    -- Fecha de an�lisis en MOV_MOVIMIENTOS - Pen�ltimo o �ltimo d�a
    elsif(fecha = penult_dia_mov or fecha = max_dia_mov) then
    
    execute immediate 'insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
                          select prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA 
                               from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc
                               join '||V_DATASTAGE||'.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                               join '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                               join '||V_DATASTAGE||'.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
                          where MOV_FECHA_EXTRACCION = :fecha' USING fecha;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_PRC_CONTRATO. MOV_MOVIMIENTOS 1. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;
      
      -- Contratos anteriores que ya no vienen y tienen sus �ltimos movimientos en MOV_MOVIMIENTOS
      execute immediate 'insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
                        select prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA 
                             from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc
                             join '||V_DATASTAGE||'.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                             join '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                             join '||V_DATASTAGE||'.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
                        where MOV_FECHA_EXTRACCION <= :penult_dia_mov and MOV_FECHA_EXTRACCION <= :fecha 
                        group by prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA  having count(*) >= 2'
                        USING penult_dia_mov, fecha;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_PRC_CONTRATO. MOV_MOVIMIENTOS 2. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;
      
    end if;  
         
    V_ROWCOUNT := sql%rowcount;     
    commit;
      
    -- Crear indices TMP_PRC_CONTRATO


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_CONTRATO_IX'', ''TMP_PRC_CONTRATO (ITER, CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_CONTRATO_CEX_IX'', ''TMP_PRC_CONTRATO (CEX_ID, CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



    commit;    
        
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_CONTRATO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 5;    

    /*  
    execute immediate 'merge into TMP_PRC_CONTRATO t1 using (select max(MOV_ID) MAX_MOV_ID, CNT_ID from '||V_CM01||'.H_MOV_MOVIMIENTOS group by CNT_ID) t2 on (t1.CONTRATO = t2.CNT_ID) when matched then update set t1.MAX_MOV_ID = t2.MAX_MOV_ID WHERE CEX_ID is null';
    -- Si alg�n contrato no se encuentra en H_MOV_MOVIMIENTOS lo borramos
    execute immediate 'delete from TMP_PRC_CONTRATO where CEX_ID is null and MAX_MOV_ID is null';
    -- Excepciones - Rellenar
    execute immediate 'merge into TMP_PRC_CONTRATO t1 using '||V_CM01||'.H_MOV_MOVIMIENTOS t2 on (t2.MOV_ID = t1.MAX_MOV_ID and t2.CNT_ID = t1.CONTRATO) when matched then update set t1.SALDO_VENCIDO = t2.MOV_POS_VIVA_VENCIDA, t1.SALDO_NO_VENCIDO = t2.MOV_POS_VIVA_NO_VENCIDA, t1.INGRESOS_PENDIENTES_APLICAR = t2.MOV_EXTRA_1, t1.FECHA_POS_VENCIDA = t2.MOV_FECHA_POS_VENCIDA where CEX_ID is null'; 
    commit;
    */
      --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'TMP_PRC_CONTRATO. Updates', 5;  
      
  
      -- GARANTIA REAL CONTRATO (Modificar lista seg�n DD_GC1_ID
    execute immediate 'merge into TMP_PRC_CONTRATO t1 using '||V_DATASTAGE||'.CNT_CONTRATOS t2 on (t2.CNT_ID = t1.CONTRATO) when matched then update set t1.GARANTIA_CONTRATO = t2.DD_GC1_ID'; 
    commit;
    update TMP_PRC_CONTRATO tpc set GARANTIA_CONTRATO = (case when GARANTIA_CONTRATO IN (10, 1, 2, 6, 3, 4, 8, 9, 5, 22, 7, 24, 11, 12, 13) then 1 else 0 end); 
    commit;
    merge into TMP_PRC_DETALLE t1 using (select SUM(GARANTIA_CONTRATO) SUM_GARANTIA_CONTRATO, ITER from TMP_PRC_CONTRATO group by ITER) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.GARANTIA_CONTRATO = t2.SUM_GARANTIA_CONTRATO;
    commit;
    update TMP_PRC_DETALLE pd set GARANTIA_CONTRATO = (case when GARANTIA_CONTRATO >=1 then 1 else 0 end);
    commit;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.GARANTIA_CONTRATO = t2.GARANTIA_CONTRATO  where DIA_ID = fecha;
    commit;
      
    -- Calculamos los saldos para los contratos asociados a la �ltima fase (Fase actual en detalle)
    merge into TMP_PRC_DETALLE t1 using (select SUM(SALDO_VENCIDO) SALDO_VENCIDO, SUM(SALDO_NO_VENCIDO) SALDO_NO_VENCIDO, SUM(INGRESOS_PENDIENTES_APLICAR) INGRESOS_PENDIENTES_APLICAR, count(*) COUNT_NUM, ITER from TMP_PRC_CONTRATO group by ITER) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.SALDO_VENCIDO = t2.SALDO_VENCIDO, t1.SALDO_NO_VENCIDO = t2.SALDO_NO_VENCIDO, t1.INGRESOS_PENDIENTES_APLICAR = t2.INGRESOS_PENDIENTES_APLICAR, t1.NUM_CONTRATOS = t2.COUNT_NUM;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.SALDO_VENCIDO = t2.SALDO_VENCIDO, t1.SALDO_NO_VENCIDO = t2.SALDO_NO_VENCIDO, t1.INGRESOS_PENDIENTES_APLICAR = t2.INGRESOS_PENDIENTES_APLICAR, t1.NUM_CONTRATOS = t2.NUM_CONTRATOS, t1.SUBTOTAL = t2.INGRESOS_PENDIENTES_APLICAR  where DIA_ID = fecha;
    commit;
    -- Saldos Concursos (contratos asociados a procedimientos en los que el/los demandados intervienen como 1er o 2� titular)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CONCURSO_CONTRATO'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

      
    insert into TMP_PRC_CONCURSO_CONTRATO(ITER, CONTRATO, SALDO_CONCURSOS_VENCIDO, SALDO_CONCURSOS_NO_VENCIDO, DEMANDADO)
    select ITER, pc.CONTRATO, SALDO_VENCIDO, SALDO_NO_VENCIDO, pd.DEMANDADO
      from TMP_PRC_CONTRATO pc
      join TMP_PRC_DEMANDADO pd on pc.ITER = pd.PROCEDIMIENTO and pc.CONTRATO = pd.CONTRATO;
    commit;
    
    merge into TMP_PRC_DETALLE t1 using (select SUM(SALDO_CONCURSOS_VENCIDO) SUM_SALDO_CONCURSOS_VENCIDO, SUM(SALDO_CONCURSOS_NO_VENCIDO) SUM_SALDO_CONCURSOS_NO_VENCIDO, ITER from TMP_PRC_CONCURSO_CONTRATO group by ITER) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.SALDO_CONCURSOS_VENCIDO = t2.SUM_SALDO_CONCURSOS_VENCIDO, t1.SALDO_CONCURSOS_NO_VENCIDO = t2.SUM_SALDO_CONCURSOS_NO_VENCIDO;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.SALDO_CONCURSOS_VENCIDO = t2.SALDO_CONCURSOS_VENCIDO, t1.SALDO_CONCURSOS_NO_VENCIDO = t2.SALDO_CONCURSOS_NO_VENCIDO  where DIA_ID = fecha;
    commit;
    -- NUM_MAX_DIAS_CONTRATO_VENCIDO 
    update TMP_PRC_CONTRATO tpc set NUM_DIAS_VENCIDO = (fecha-FECHA_POS_VENCIDA);
    merge into TMP_PRC_DETALLE t1 using (select max(NUM_DIAS_VENCIDO) MAX_NUM_DIAS_VENCIDO, ITER from TMP_PRC_CONTRATO group by ITER) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.NUM_DIAS_VENCIDO = t2.MAX_NUM_DIAS_VENCIDO;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.NUM_DIAS_VENCIDO = t2.NUM_DIAS_VENCIDO where DIA_ID = fecha;
    commit;
    
    -- FECHA_ULTIMA_POSICION_VENCIDA - Fecha de la �ltima posici�n vencida asociada de los contratos asociados al procedimiento
    merge into TMP_PRC_DETALLE t1 using (select MIN(FECHA_POS_VENCIDA) MIN_FECHA_POS_VENCIDA, ITER from TMP_PRC_CONTRATO group by ITER) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.FECHA_ULTIMA_POSICION_VENCIDA = t2.MIN_FECHA_POS_VENCIDA;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.FECHA_ULTIMA_POSICION_VENCIDA = t2.FECHA_ULTIMA_POSICION_VENCIDA where DIA_ID = fecha;
    commit;
  
    -- FECHA_ULTIMA_ESTIMACION
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESTIMACION'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

   
    execute immediate 'insert into TMP_PRC_ESTIMACION (ITER, FASE, FECHA_ESTIMACION, IRG_CLAVE, IRG_VALOR)
                        select Tpj.ITER, Tpj.FASE_ACTUAL, INFO.FECHACREAR, IRG_CLAVE, IRG_VALOR
                        from TMP_PRC_JERARQUIA Tpj
                        join '||V_DATASTAGE||'.MEJ_REG_REGISTRO mej on mej.TRG_EIN_ID = Tpj.FASE_ACTUAL
                        join '||V_DATASTAGE||'.MEJ_IRG_INFO_REGISTRO INFO on mej.REG_ID = INFO.REG_ID
                        where DIA_ID =  :fecha and trunc(INFO.FECHACREAR) <= :fecha 
                        and DD_TRG_ID = 3 and IRG_CLAVE IN (''estNew'', ''estNew'', ''estOld'', ''plaNew'', ''plaOld'',''pplNew'', ''pplOld'')'  USING fecha, fecha;
      
    merge into TMP_PRC_DETALLE t1 using (select trunc(max(FECHA_ESTIMACION)) MAX_FECHA_ESTIMACION, ITER from TMP_PRC_ESTIMACION where trunc(FECHA_ESTIMACION) <= fecha group by ITER) t2 on (t2.ITER = t1.ITER) when matched then update set t1.FECHA_ULTIMA_ESTIMACION = t2.MAX_FECHA_ESTIMACION;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.FECHA_ULTIMA_ESTIMACION = t2.FECHA_ULTIMA_ESTIMACION where DIA_ID = fecha;
      
    -- CARTERA_PROCEDIMIENTO - 0 Haya / 1 SAREB / 2 Compartida    
    merge into TMP_PRC_CONTRATO t1 using TMP_PRC_CARTERA t2 on (t2.CONTRATO = t1.CONTRATO) when matched then update set t1.CARTERA = t2.CARTERA;
    -- Procedimientos con cartera compartida (CARTERA = 2)                                                      
    merge into TMP_PRC_DETALLE t1 using (select ITER from (select ITER, count(distinct CARTERA) NUM_CARTERAS_DISTINTAS from TMP_PRC_CONTRATO pc where CARTERA IN (0, 1) group by ITER) aux 
      where aux.NUM_CARTERAS_DISTINTAS > 1) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.CARTERA = 2;    
    commit;
    
    -- Resto de procedimientos (CARTERA = 0 o 1)                                                                         
    merge into TMP_PRC_DETALLE t1 using (select nvl(max(CARTERA), -1) MAX_CARTERA, ITER from TMP_PRC_CONTRATO group by ITER) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.CARTERA = t2.MAX_CARTERA where CARTERA is null;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.CARTERA = t2.CARTERA  where DIA_ID = fecha; 
    commit;
    
    -- FECHA_CONTABLE_LITIGIO
    merge into TMP_PRC_CONTRATO t1 using TMP_PRC_FECHA_CONTABLE_LITIGIO t2 on (t2.CONTRATO = t1.CONTRATO) when matched then update set t1.FECHA_CONTABLE_LITIGIO = t2.FECHA_CONTABLE_LITIGIO;
    merge into TMP_PRC_DETALLE t1 using (select MIN(FECHA_CONTABLE_LITIGIO) MIN_FECHA_CONTABLE_LITIGIO, ITER from TMP_PRC_CONTRATO group by ITER) t2 on (t2.ITER = t1.FASE_ACTUAL) when matched then update set t1.FECHA_CONTABLE_LITIGIO = t2.MIN_FECHA_CONTABLE_LITIGIO;
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.FECHA_CONTABLE_LITIGIO = t2.FECHA_CONTABLE_LITIGIO  where DIA_ID = fecha;
    commit;
    
    -- TITULAR_PROCEDIMIENTO
    merge into TMP_PRC_DETALLE t1 using (select max(TITULAR_PROCEDIMIENTO) MAX_TITULAR_PROCEDIMIENTO, PROCEDIMIENTO from TMP_PRC_TITULAR group by PROCEDIMIENTO) t2 on (t2.PROCEDIMIENTO = t1.FASE_ACTUAL) when matched then update set t1.TITULAR_PROCEDIMIENTO = t2.MAX_TITULAR_PROCEDIMIENTO;
    update TMP_PRC_DETALLE pd set TITULAR_PROCEDIMIENTO = -1 where TITULAR_PROCEDIMIENTO is null; 
    merge into TMP_PRC_JERARQUIA t1 using TMP_PRC_DETALLE t2 on (t2.ITER = t1.ITER) when matched then update set t1.TITULAR_PROCEDIMIENTO = t2.TITULAR_PROCEDIMIENTO  where DIA_ID = fecha;  
    commit;  
  
    -- Borrado �ndices TMP_H_PRC
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRC_FASE_ACTUAL_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRC'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;

 -- add  by MAria falta probar
      
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_DECISION'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
   insert into TMP_PRC_DECISION (FASE_ACTUAL, FASE_PARALIZADA, FASE_FINALIZADA, FECHA_HASTA,MOTIVO_PARALIZACION_ID)
  select PRC_ID, DPR_PARALIZA, DPR_FINALIZA,  max(trunc(DPR_FECHA_PARA)),DD_DPA_ID
  from  '||V_DATASTAGE||'.DPR_DECISIONES_PROCEDIMIENTOS
  where (DD_EDE_ID = 2 and DPR_PARALIZA = 1)
  and trunc(FECHACREAR) <= '''||fecha||''' group by PRC_ID, DPR_PARALIZA, DPR_FINALIZA,DD_DPA_ID';

    V_ROWCOUNT := sql%rowcount;
    commit;
 --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_PRC_DECISION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


merge into TMP_PRC_JERARQUIA a
using (select distinct FECHA_HASTA, FASE_ACTUAL,MOTIVO_PARALIZACION_ID from TMP_PRC_DECISION where FASE_PARALIZADA = 1) b
on (b.FASE_ACTUAL = a.FASE_ACTUAL and  a.DIA_ID<= b.FECHA_HASTA)
when matched then update set a.FASE_PARALIZADA = 1, a.FECHA_PARALIZACION=b.FECHA_HASTA,a.MOTIVO_PARALIZACION_ID=b.MOTIVO_PARALIZACION_ID;
commit;

--- Fin add  Maria SIN PROBAR

    -- Insertamos en TMP_H_PRC s�lo el registro que tiene la �ltima actuaci�n
    insert into TMP_H_PRC
      (DIA_ID,   
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID, 
       FASE_ACTUAL,
       ULT_TAR_CREADA,
       ULT_TAR_FIN,
       ULTIMA_TAREA_ACTUALIZADA,
       ULT_TAR_PEND,
       FECHA_CONTABLE_LITIGIO,
       FECHA_ULT_TAR_CREADA,
       FECHA_ULT_TAR_FIN, 
       FECHA_ULTIMA_TAREA_ACTUALIZADA,  
       FECHA_ULT_TAR_PEND,
       FECHA_ACEPTACION,
       FECHA_RECOGIDA_DOC_Y_ACEPT,
       FECHA_REGISTRAR_TOMA_DECISION,
       FECHA_RECEPCION_DOC_COMPLETA,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_ULTIMA_POSICION_VENCIDA,
       FECHA_ULTIMA_ESTIMACION,
       ASUNTO_ID,                                
       FASE_MAX_PRIORIDAD, 
       CONTEXTO_FASE,
       NIVEL,
       ESTADO_PROCEDIMIENTO_ID,               -- 0 Activo, 1 No Activo
       CNT_GARANTIA_REAL_ASOC_ID,
       CARTERA_PROCEDIMIENTO_ID,
       TITULAR_PROCEDIMIENTO_ID,
       NUM_PROCEDIMIENTOS,
       NUM_FASES,
       NUM_DIAS_ULT_ACTUALIZACION,
       NUM_MAX_DIAS_CONTRATO_VENCIDO,
       NUM_CONTRATOS,
       SALDO_ACTUAL_VENCIDO,            
       SALDO_ACTUAL_NO_VENCIDO,
       SALDO_CONCURSOS_VENCIDO,
       SALDO_CONCURSOS_NO_VENCIDO,
       INGRESOS_PENDIENTES_APLICAR,
       DURACION_ULT_TAREA_PENDIENTE,           -- Duraci�n tarea en d�as (Fecha inicio hasta fecha fin o fecha actual)
       PRC_PARALIZADO_ID,
        FECHA_PARALIZACION,
       MOTIVO_PARALIZACION_ID
      )
      select DIA_ID,   
       DIA_ID,   
       ITER,   
       FASE_ACTUAL,
       ULT_TAR_CREADA,
       ULT_TAR_FIN,
       ULTIMA_TAREA_ACTUALIZADA,
       ULT_TAR_PEND,
       FECHA_CONTABLE_LITIGIO,
       FECHA_ULT_TAR_CREADA,
       FECHA_ULT_TAR_FIN, 
       FECHA_ULTIMA_TAREA_ACTUALIZADA,
       FECHA_ULT_TAR_PEND,
       FECHA_ACEPTACION,
       FECHA_RECOGIDA_DOC_Y_ACEPT,
       FECHA_REGISTRAR_TOMA_DECISION,
       FECHA_RECEPCION_DOC_COMPLETA,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_ULTIMA_POSICION_VENCIDA,
       FECHA_ULTIMA_ESTIMACION,
       ASU_ID,
       FASE_MAX_PRIORIDAD,
       CONTEXTO,
       NIVEL, 
       CANCELADO_PROCEDIMIENTO,
       GARANTIA_CONTRATO,
       CARTERA,
       TITULAR_PROCEDIMIENTO,
       1,
       NUM_FASES,
       to_date(fecha, 'DD/MM/YY') - trunc(FECHA_ULTIMA_TAREA_ACTUALIZADA),
       NUM_DIAS_VENCIDO,
       NUM_CONTRATOS,
       SALDO_VENCIDO,         
       SALDO_NO_VENCIDO,
       SALDO_CONCURSOS_VENCIDO,
       SALDO_CONCURSOS_NO_VENCIDO,
       INGRESOS_PENDIENTES_APLICAR,
       to_date(fecha, 'DD/MM/YY') - trunc(FECHA_ULT_TAR_PEND),
        NVL(FASE_PARALIZADA,0),
         FECHA_PARALIZACION,
       MOTIVO_PARALIZACION_ID
      from TMP_PRC_JERARQUIA where DIA_ID = fecha and FASE_ACTUAL = ULTIMA_FASE;
      commit;
      
      -- Crear indices TMP_H_PRC
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_IX'', ''TMP_H_PRC (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;






      commit;    


       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_FASE_ACTUAL_IX'', ''TMP_H_PRC (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      



      commit;    

    -- CAMBIO A PETICI�N DE UGAS (recovery BI v7 03/06/2013)
    -- Litigios --> FECHA_CREACION_ASUNTO =  FECHA_CONTABLE_LITIGIO. La FECHA_CREACION_ASUNTO para los concursos se establece al final de los updates
    update H_PRC set FECHA_CREACION_ASUNTO = FECHA_CONTABLE_LITIGIO where DIA_ID = fecha;
    
    execute immediate 'merge into TMP_H_PRC t1 using '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS t2 on (t2.PRC_ID = t1.FASE_MAX_PRIORIDAD) when matched then update set t1.TIPO_PROCEDIMIENTO_DET_ID = t2.DD_TPO_ID where DIA_ID = :fecha' USING fecha;
    commit;
    -- FECHA_CREACION_ASUNTO Concursos y nulos
    execute immediate 'merge into TMP_H_PRC t1 using '||V_DATASTAGE||'.ASU_ASUNTOS t2 on (t2.ASU_ID = t1.ASUNTO_ID) when matched then update set t1.FECHA_CREACION_ASUNTO = trunc(t2.FECHACREAR) where DIA_ID = :fecha and (FECHA_CREACION_ASUNTO is null OR TIPO_PROCEDIMIENTO_DET_ID IN (141,142,143,144,145,146,147,148,149,150,151,152,541,542,543,841,1141))' USING fecha;
    commit;


    -- Fecha asunto cancelado
 -- Fecha de an�lisis en EXT_IAB_INFO_ADD_BI_H 
    if (fecha <= max_dia_add_bi_h) then
    execute immediate 'merge into TMP_H_PRC t1 using (select max(FECHA_CANCELACION) MAX_FECHA_CANCELACION, IAB_ID_UNIDAD_GESTION from '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI_H where DD_IFB_ID = 1 and TRUNC(IAB_FECHA_VALOR) = '''||fecha||''' and FECHA_CANCELACION is not null GROUP BY IAB_ID_UNIDAD_GESTION) t2 on (t1.ASUNTO_ID = t2.IAB_ID_UNIDAD_GESTION) when matched then update set t1.FECHA_CANCELACION_ASUNTO = t2.MAX_FECHA_CANCELACION where t1.FECHA_CANCELACION_ASUNTO is null';
    commit;
    end if;
    -- Fecha de an�lisis en EXT_IAB_INFO_ADD_BI - �ltimo d�a
    if (fecha = max_dia_add_bi) then
    execute immediate 'merge into TMP_H_PRC t1 using (select max(FECHA_CANCELACION) MAX_FECHA_CANCELACION, IAB_ID_UNIDAD_GESTION from '||V_DATASTAGE||'.EXT_IAB_INFO_ADD_BI where DD_IFB_ID = 1 and TRUNC(IAB_FECHA_VALOR) = '''||fecha||''' and FECHA_CANCELACION is not null GROUP BY IAB_ID_UNIDAD_GESTION) t2 on (t1.ASUNTO_ID = t2.IAB_ID_UNIDAD_GESTION) when matched then update set t1.FECHA_CANCELACION_ASUNTO = t2.MAX_FECHA_CANCELACION where t1.FECHA_CANCELACION_ASUNTO is null';
    commit;
    end if;
  
    /*
    -- Detalle Cobros D�a
    insert into H_PRC_DET_COBRO 
      (DIA_ID,                               
       PROCEDIMIENTO_ID,   
       ASUNTO_ID,
       CONTRATO_ID,
       FECHA_COBRO,
       FECHA_ASUNTO,
       TIPO_COBRO_DETALLE_ID,
       NUM_COBROS,
       IMPORTE_COBRO,
       NUM_DIAS_CREACION_ASU_COBRO)
      select DIA_ID, 
       PROCEDIMIENTO_ID, 
       ASUNTO_ID,
       PCNT.CONTRATO,  
       FECHA_COBRO, 
       FECHA_CREACION_ASUNTO,
       REFERENCIA, 
       1, 
       IMPORTE,
       (FECHA_COBRO - FECHA_CREACION_ASUNTO) 
      from TMP_PRC_CONTRATO PCNT
      join TMP_PRC_COBROS PCOB on PCNT.CONTRATO=PCOB.CONTRATO
      join H_PRC H on H.FASE_ACTUAL=PCNT.ITER 
      where DIA_ID = fecha and FECHA_COBRO <= fecha and REFERENCIA IN (50,89,90,91,92,93,94,95,96,97,98,99);
  */
    
    -- Borrado �ndices TMP_H_PRC_DET_CONTRATO
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRC_DET_CONTRATO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRC_DET_CONTRATO'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;
    -- Detalle Contratos
    execute immediate
    'insert into TMP_H_PRC_DET_CONTRATO
      (DIA_ID, 
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       ASUNTO_ID,
       CONTRATO_ID,
       NUM_CONTRATOS_PROCEDIMIENTO)
    select :fecha, 
       :fecha, 
       pd.ITER, 
       PRC.ASU_ID, 
       pc.CONTRATO, 
       1 
       from TMP_PRC_DETALLE pd
       join TMP_PRC_CONTRATO pc on  pc.ITER = pd.FASE_ACTUAL
       join '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS PRC on pc.ITER = PRC.PRC_ID' USING fecha, fecha;
    commit;

      -- Crear indices TMP_H_PRC_DET_CONTRATO


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRC_DET_CONTRATO_IX'', ''TMP_H_PRC_DET_CONTRATO (DIA_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



      commit;          

-- ------------------------------------------------------------------ UPDATES H_PRC -----------------------------------------------------------------

    -- !!! Algunos procedimientos est�n asociados a contratos que no existen en CEX_CONTRATOS_EXPEDIENTE.
    --delete from TMP_H_PRC where DIA_ID = fecha and NUM_CONTRATOS = 0;
    
    -- Updates

    update TMP_H_PRC set SALDO_ACTUAL_TOTAL = SALDO_ACTUAL_VENCIDO + SALDO_ACTUAL_NO_VENCIDO where DIA_ID = fecha;
    update TMP_H_PRC set SALDO_CONCURSOS_TOTAL = SALDO_CONCURSOS_VENCIDO + SALDO_CONCURSOS_NO_VENCIDO where DIA_ID = fecha;
    commit;   
      
    -- SALDO_TOTAL: 0  < 1MM  / 1  >= 1 MM 
    update TMP_H_PRC set T_SALDO_TOTAL_PRC_ID = (case when SALDO_ACTUAL_TOTAL < 1000000 then 0
                                                      else 1 end) where DIA_ID = fecha;                                                        
    
    -- SALDO_CONCURSOS_TOTAL: 0 < 1MM  / 1 >= 1 MM 
    update TMP_H_PRC set T_SALDO_TOTAL_CONCURSO_ID = (case when SALDO_CONCURSOS_TOTAL < 1000000 then 0
                                                           when SALDO_CONCURSOS_TOTAL >= 1000000 then 1
                                                           else -2 end) where DIA_ID = fecha;
                                                                     
    update TMP_H_PRC set TD_CONTRATO_VENCIDO_ID = (case when NUM_MAX_DIAS_CONTRATO_VENCIDO <=30 then 0
                                                        when NUM_MAX_DIAS_CONTRATO_VENCIDO >30 and NUM_MAX_DIAS_CONTRATO_VENCIDO <= 60 then 1
                                                        when NUM_MAX_DIAS_CONTRATO_VENCIDO >60 and NUM_MAX_DIAS_CONTRATO_VENCIDO <= 90 then 2
                                                        when NUM_MAX_DIAS_CONTRATO_VENCIDO >60 and NUM_MAX_DIAS_CONTRATO_VENCIDO > 90 then 3
                                                        else -2 end) where DIA_ID = fecha;  
    commit;
    
    -- Cumplimiento �LTIMA TAREA FINALIZADA
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TAR_ID, TAR_FECHA_VENC_REAL, TAR_FECHA_VENC from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES) t2
                          on (t1.ULT_TAR_FIN = t2.TAR_ID)
                       when matched then update set t1.FECHA_VENC_ORIG_ULT_TAR_FIN = t2.TAR_FECHA_VENC_REAL,
                                                    t1.FECHA_VENC_ACT_ULT_TAR_FIN = t2.TAR_FECHA_VENC
                                          where t1.DIA_ID = '''||fecha||'''';
    commit;  
    -- !!!!!!!!!! DURACION_ULT_TAREA_FINALIZADA
    -- update TMP_H_PRC set DURACION_ULT_TAREA_FINALIZADA = max_dia_mes, FECHA_ULT_TAR_PEND
    -- (datediff(DIA_ID, FECHA_VENC_ACT_ULT_TAR_FIN)); 
    update TMP_H_PRC set NUM_DIAS_EXCED_ULT_TAR_FIN = ((FECHA_ULT_TAR_FIN - FECHA_VENC_ACT_ULT_TAR_FIN)) where DIA_ID = fecha;                               -- N�mero d�as desde fecha vencimiento (vigente) hasta fecha actual (valores positivos si la tarea excede la fecha de vencimiento)
    commit;
    update TMP_H_PRC set NUM_DIAS_VENC_ULT_TAR_FIN = ((FECHA_VENC_ACT_ULT_TAR_FIN - FECHA_ULT_TAR_FIN)) where DIA_ID = fecha;                      -- N�mero d�as desde fecha actual hasta fecha vencimiento (valores negativos si no quedan d�as)
    commit;
    update TMP_H_PRC set NUM_DIAS_PRORROG_ULT_TAR_FIN = ((FECHA_VENC_ACT_ULT_TAR_FIN - FECHA_VENC_ORIG_ULT_TAR_FIN)) where DIA_ID = fecha;          -- N�mero d�as desde fecha vencimineto real (original) hasta fecha vencimiento vigente
    commit;
    -- CUMPLIMIENTO_ULT_TAR_FIN_ID: -2 Ninguna Tarea FINALIZADA Asocidada, 0 En Plazo, 1 Fuera De Plazo, -1 �ltima Tarea Finalizada Sin Fecha de Vencimiento
    update TMP_H_PRC set CUMPLIMIENTO_ULT_TAR_FIN_ID = (case when NUM_DIAS_VENC_ULT_TAR_FIN >= 0 then 0
                                                             when NUM_DIAS_VENC_ULT_TAR_FIN < 0 then 1
                                                             when NUM_DIAS_VENC_ULT_TAR_FIN is null and FECHA_ULT_TAR_FIN is not null then -1
                                                             else -2 end) where DIA_ID = fecha;
    commit;

    -- Cumplimiento �LTIMA TAREA PENDIENTE
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TAR_ID, TAR_FECHA_VENC_REAL, TAR_FECHA_VENC from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES) t2
                          on (t1.ULT_TAR_PEND = t2.TAR_ID)
                       when matched then update set t1.FECHA_VENC_ORIG_ULT_TAR_PEND = t2.TAR_FECHA_VENC_REAL,
                                                    t1.FECHA_VENC_ACT_ULT_TAR_PEND = t2.TAR_FECHA_VENC
                                         where t1.DIA_ID = '''||fecha||'''';
    commit;
    update TMP_H_PRC set NUM_DIAS_EXCEDIDO_ULT_TAR_PEND = ((DIA_ID - FECHA_VENC_ACT_ULT_TAR_PEND)) where DIA_ID = fecha;                                                     -- N�mero d�as desde fecha vencimiento (vigente) hasta fecha actual (valores positivos si la tarea excede la fecha de vencimiento)
    commit;
    update TMP_H_PRC set NUM_DIAS_VENC_ULT_TAR_PEND = ((FECHA_VENC_ACT_ULT_TAR_PEND - DIA_ID)) where DIA_ID = fecha;                                            -- N�mero d�as desde fecha actual hasta fecha vencimiento (valores negativos si no quedan d�as)
    commit;
    update TMP_H_PRC set NUM_DIAS_PRORROG_ULT_TAR_PEND = ((FECHA_VENC_ACT_ULT_TAR_PEND - FECHA_VENC_ORIG_ULT_TAR_PEND)) where DIA_ID = fecha;          -- N�mero d�as desde fecha vencimineto real (original) hasta fecha vencimiento vigente
    commit;  
    -- CUMPLIMIENTO_ULT_TAR_PEND_ID: -2 Ninguna Tarea Pendiente Asocidada, 0 En Plazo, 1 Fuera De Plazo, -1 �ltima Tarea Pendiente Sin Fecha de Vencimiento
    update TMP_H_PRC set CUMPLIMIENTO_ULT_TAR_PEND_ID = (case when NUM_DIAS_VENC_ULT_TAR_PEND >= 0 then 0
                                                              when NUM_DIAS_VENC_ULT_TAR_PEND < 0 then 1
                                                              when NUM_DIAS_VENC_ULT_TAR_PEND is null and ULT_TAR_PEND is not null then -1
                                                              else -2 end) where DIA_ID = fecha; 
    commit;  
    -- FALTA---------
    --  NUM_PRORROG_ULT_TAR_PEND                  -- N�mero pr�rrogas pedidas para la tarea 
    -- FALTA---------

    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, PRC_PRC_ID, DD_EPR_ID, DD_TPO_ID from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.FASE_ACTUAL = t2.PRC_ID)
                       when matched then update set t1.FASE_ANTERIOR = t2.PRC_PRC_ID, t1.ESTADO_FASE_ACTUAL_ID = t2.DD_EPR_ID,
                                                    t1.FASE_ACTUAL_DETALLE_ID = t2.DD_TPO_ID
                                          where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, DD_EPR_ID, DD_TPO_ID from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.FASE_ANTERIOR = t2.PRC_ID)
                       when matched then update set t1.ESTADO_FASE_ANTERIOR_ID = t2.DD_EPR_ID,
                                                    t1.FASE_ANTERIOR_DETALLE_ID = t2.DD_TPO_ID
                                         where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TAR_ID, DD_STA_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES) t2
                          on (t1.ULT_TAR_CREADA = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_CREADA_TIPO_DET_ID = t2.DD_STA_ID where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TAR_ID, DD_STA_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES) t2
                          on (t1.ULT_TAR_FIN = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_FIN_TIPO_DET_ID = t2.DD_STA_ID where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TAR_ID, DD_STA_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES) t2
                          on (t1.ULTIMA_TAREA_ACTUALIZADA = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_ACT_TIPO_DET_ID = t2.DD_STA_ID where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TAR_ID, DD_STA_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES) t2
                          on (t1.ULT_TAR_PEND = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_PEND_TIPO_DET_ID = t2.DD_STA_ID where t1.DIA_ID = '''||fecha||'''';
    commit;                                                                                                   
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TN.TAR_ID, TD.ULT_TAR_CREADA_DESC_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TN
                                join D_PRC_ULT_TAR_CREADA_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_CREADA_DESC_DESC ) t2
                          on (t1.ULT_TAR_CREADA = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_CREADA_DESC_ID = t2.ULT_TAR_CREADA_DESC_ID where t1.DIA_ID = '''||fecha||'''';
    commit;                                                                                                    
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TN.TAR_ID, TD.ULT_TAR_FIN_DESC_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TN
                              join D_PRC_ULT_TAR_FIN_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_FIN_DESC_DESC ) t2
                          on (t1.ULT_TAR_FIN = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_FIN_DESC_ID = t2.ULT_TAR_FIN_DESC_ID where t1.DIA_ID = '''||fecha||'''';
    commit;                                                                                                    
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TN.TAR_ID, TD.ULT_TAR_ACT_DESC_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TN
                              join D_PRC_ULT_TAR_ACT_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_ACT_DESC_DESC ) t2
                          on (t1.ULTIMA_TAREA_ACTUALIZADA = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_ACT_DESC_ID = t2.ULT_TAR_ACT_DESC_ID where t1.DIA_ID = '''||fecha||'''';
    commit;                                                                                                       
    execute immediate 'merge into TMP_H_PRC t1
                       using (select TN.TAR_ID, TD.ULT_TAR_PEND_DESC_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TN
                              join D_PRC_ULT_TAR_PEND_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_PEND_DESC_DESC) t2
                          on (t1.ULT_TAR_PEND = t2.TAR_ID)
                       when matched then update set t1.ULT_TAR_PEND_DESC_ID = t2.ULT_TAR_PEND_DESC_ID where t1.DIA_ID = '''||fecha||'''';
    commit;
    -- Si es un Iter no aplican (-2 No Aplica (Iter) y Update Procedimientos que no tienen tareas asociadas
    update TMP_H_PRC set ESTADO_FASE_ANTERIOR_ID = -2 where DIA_ID = fecha and ESTADO_FASE_ANTERIOR_ID is null;
    commit;
    update TMP_H_PRC set FASE_ANTERIOR_DETALLE_ID =  -2 where DIA_ID = fecha and FASE_ANTERIOR_DETALLE_ID is null;
    commit;  
    
    -- Update Procedimientos que no tienen tareas asociadas
    update TMP_H_PRC set ULT_TAR_CREADA_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_CREADA_TIPO_DET_ID is null;
    commit;
    update TMP_H_PRC set ULT_TAR_FIN_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_FIN_TIPO_DET_ID is null;
    commit;
    update TMP_H_PRC set ULT_TAR_ACT_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_ACT_TIPO_DET_ID is null;
    commit;
    update TMP_H_PRC set ULT_TAR_PEND_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_PEND_TIPO_DET_ID is null;
    commit;
    update TMP_H_PRC set ULT_TAR_CREADA_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_CREADA_DESC_ID is null;
    commit;
    update TMP_H_PRC set ULT_TAR_FIN_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_FIN_DESC_ID is null;
    commit;
    update TMP_H_PRC set ULT_TAR_ACT_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_ACT_DESC_ID is null;
    commit;
    update TMP_H_PRC set ULT_TAR_PEND_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_PEND_DESC_ID is null;
    commit;  
      
    -- Update fechas Creaci�n procedimiento y fases
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, FECHACREAR from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_CREACION_PROCEDIMIENTO = t2.FECHACREAR where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, FECHACREAR from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.FASE_MAX_PRIORIDAD = t2.PRC_ID)
                       when matched then update set t1.FECHA_CREACION_FASE_MAX_PRIO = t2.FECHACREAR where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, FECHACREAR
                              from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.FASE_ANTERIOR = t2.PRC_ID)
                       when matched then update set t1.FECHA_CREACION_FASE_ANTERIOR = t2.FECHACREAR where t1.DIA_ID = '''||fecha||'''';
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, FECHACREAR
                              from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.FASE_ACTUAL = t2.PRC_ID)
                       when matched then update set t1.FECHA_CREACION_FASE_ACTUAL = t2.FECHACREAR where t1.DIA_ID = '''||fecha||'''';
    commit;
    
    -- Update N�mero m�ximo de d�as vencidos de un contrato asociado al procedimiento respecto a la creaci�n del asunto
    update TMP_H_PRC set NUM_MAX_DIAS_CNT_VENC_CREA_ASU = ((FECHA_ULTIMA_POSICION_VENCIDA - FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;
    commit;
    update TMP_H_PRC set TD_CNT_VENC_CREACION_ASU_ID = (case when NUM_MAX_DIAS_CNT_VENC_CREA_ASU > 0 and NUM_MAX_DIAS_CNT_VENC_CREA_ASU <= 30 then 0 
                                                             when NUM_MAX_DIAS_CNT_VENC_CREA_ASU > 30 and NUM_MAX_DIAS_CNT_VENC_CREA_ASU <= 60 then 1
                                                             when NUM_MAX_DIAS_CNT_VENC_CREA_ASU > 60 and NUM_MAX_DIAS_CNT_VENC_CREA_ASU <= 90 then 2
                                                             when NUM_MAX_DIAS_CNT_VENC_CREA_ASU > 90 and NUM_MAX_DIAS_CNT_VENC_CREA_ASU <= 120 then 3
                                                             when NUM_MAX_DIAS_CNT_VENC_CREA_ASU > 120 and NUM_MAX_DIAS_CNT_VENC_CREA_ASU <= 150 then 4
                                                             when NUM_MAX_DIAS_CNT_VENC_CREA_ASU > 150 and NUM_MAX_DIAS_CNT_VENC_CREA_ASU <= 180 then 5
                                                             when NUM_MAX_DIAS_CNT_VENC_CREA_ASU > 180 then 6
                                                             else -2 end) where DIA_ID = fecha; 
    commit;  
    -- Si NUM_DIAS_ULT_ACTUALIZACION es null
    update TMP_H_PRC set NUM_DIAS_ULT_ACTUALIZACION = (DIA_ID - FECHA_CREACION_FASE_ACTUAL) where DIA_ID = fecha and NUM_DIAS_ULT_ACTUALIZACION is null;
    commit;
    -- TD_ULT_ACTUALIZACION_PRC_ID: 0 si <= 30 D�as / 1 si 31 - 60 D�as / 2 si 61 - 90 D�as/ 3 si > 90 D�as
    update TMP_H_PRC set TD_ULT_ACTUALIZACION_PRC_ID = (case when NUM_DIAS_ULT_ACTUALIZACION <=30 then 0
                                                             when NUM_DIAS_ULT_ACTUALIZACION >30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
                                                             when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
                                                             when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
                                                             else -1 end) where DIA_ID = fecha; 
    commit;
    
    
    
    
                                                 
    -- Update saldos Originales (PRC_PROCEDIMIENTOS)
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, PRC_PORCENTAJE_RECUPERACION, PRC_PLAZO_RECUPERACION, PRC_SALDO_RECUPERACION from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.FASE_ACTUAL = t2.PRC_ID)
                       when matched then update set t1.PORCENTAJE_RECUPERACION = t2.PRC_PORCENTAJE_RECUPERACION, 
                                                    t1.P_RECUPERACION = t2.PRC_PLAZO_RECUPERACION,
                                                    t1.SALDO_RECUPERACION = t2.PRC_SALDO_RECUPERACION
                                         where t1.DIA_ID = '''||fecha||'''';
    commit;
    update TMP_H_PRC set ESTIMACION_RECUPERACION = (SALDO_RECUPERACION * (PORCENTAJE_RECUPERACION/100)) where DIA_ID = fecha;
    commit;
    execute immediate 'merge into TMP_H_PRC t1
                       using (select PRC_ID, PRC_SALDO_ORIGINAL_VENCIDO, PRC_SALDO_ORIGINAL_NO_VENCIDO from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.FASE_ACTUAL = t2.PRC_ID)
                       when matched then update set t1.SALDO_ORIGINAL_VENCIDO = t2.PRC_SALDO_ORIGINAL_VENCIDO,
                                                    t1.SALDO_ORIGINAL_NO_VENCIDO = t2.PRC_SALDO_ORIGINAL_NO_VENCIDO
                                         where t1.DIA_ID = '''||fecha||'''';
    commit;  
    
    -- SALDO_RECUPERACION: 0  < 1MM ? / 1  >= 1 MM ?
    update TMP_H_PRC set T_SALDO_RECUPERACION_PRC_ID = (case when SALDO_RECUPERACION < 1000000 then 0
                                                             when SALDO_RECUPERACION >= 1000000 then 1
                                                             else -1 end) where DIA_ID = fecha;        
    commit;
    
    -- Update Plazos Comunes a Procedimientos
    update TMP_H_PRC set P_CREA_ASU_A_INTERP_DEM = ((FECHA_INTERPOSICION_DEMANDA - FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;     
    commit;
    update TMP_H_PRC set P_CREACION_ASU_ACEP = ((FECHA_ACEPTACION - FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;         
    commit;
    update TMP_H_PRC set P_ACEPT_ASU_INTERP_DEM = ((FECHA_INTERPOSICION_DEMANDA - FECHA_ACEPTACION)) where DIA_ID = fecha;     
 
    -- SALDO_RECUPERACION: 0  < 1MM ? / 1  >= 1 MM ? y Update Plazos Comunes a Procedimientos
    update TMP_H_PRC set TD_CREA_ASU_A_INTERP_DEM_ID = (case when P_CREA_ASU_A_INTERP_DEM > 0 and P_CREA_ASU_A_INTERP_DEM <= 10 then 0 
                                                             when P_CREA_ASU_A_INTERP_DEM > 10 and P_CREA_ASU_A_INTERP_DEM <= 20 then 1
                                                             when P_CREA_ASU_A_INTERP_DEM > 20 and P_CREA_ASU_A_INTERP_DEM <= 30 then 2
                                                             when P_CREA_ASU_A_INTERP_DEM > 30 then 3
                                                             else -1 end) where DIA_ID = fecha; 
    commit;                                                                                         
    update TMP_H_PRC set TD_CREACION_ASU_ACEPT_ID = (case when P_CREACION_ASU_ACEP > 0 and P_CREACION_ASU_ACEP <= 5 then 0 
                                                          when P_CREACION_ASU_ACEP > 5 and P_CREACION_ASU_ACEP <= 10 then 1
                                                          when P_CREACION_ASU_ACEP > 10 and P_CREACION_ASU_ACEP <= 20 then 2
                                                          when P_CREACION_ASU_ACEP > 20 then 3
                                                          else -1 end) where DIA_ID = fecha; 
    commit;                                                                                  
    update TMP_H_PRC set TD_ACEPT_ASU_INTERP_DEM_ID = (case when P_ACEPT_ASU_INTERP_DEM > 0 and P_ACEPT_ASU_INTERP_DEM <= 5 then 0 
                                                            when P_ACEPT_ASU_INTERP_DEM > 5 and P_ACEPT_ASU_INTERP_DEM <= 10 then 1
                                                            when P_ACEPT_ASU_INTERP_DEM > 10 and P_ACEPT_ASU_INTERP_DEM <= 20 then 2
                                                            when P_ACEPT_ASU_INTERP_DEM > 20 then 3
                                                            else -1 end) where DIA_ID = fecha; 
    commit;  
    update TMP_H_PRC set P_CREA_ASU_REC_DOC_ACEP = ((FECHA_RECOGIDA_DOC_Y_ACEPT - FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;  
    commit;
    update TMP_H_PRC set P_REC_DOC_ACEP_REG_TD = ((FECHA_REGISTRAR_TOMA_DECISION - FECHA_RECOGIDA_DOC_Y_ACEPT)) where DIA_ID = fecha;  
    commit;
    update TMP_H_PRC set P_REC_DOC_ACEP_RECEP_DC = ((FECHA_RECEPCION_DOC_COMPLETA - FECHA_RECOGIDA_DOC_Y_ACEPT)) where DIA_ID = fecha;  
    commit;
    update TMP_H_PRC set TD_CREA_ASU_REC_DOC_ACEP_ID = (case when P_CREA_ASU_REC_DOC_ACEP > 0 and P_CREA_ASU_REC_DOC_ACEP <= 5 then 0 
                                                             when P_CREA_ASU_REC_DOC_ACEP > 5 and P_CREA_ASU_REC_DOC_ACEP <= 10 then 1
                                                             when P_CREA_ASU_REC_DOC_ACEP > 10 and P_CREA_ASU_REC_DOC_ACEP <= 20 then 2
                                                             when P_CREA_ASU_REC_DOC_ACEP > 20 then 3
                                                             else -1 end) where DIA_ID = fecha; 
    commit;    
    update TMP_H_PRC set TD_REC_DOC_ACEPT_REG_TD_ID = (case when P_REC_DOC_ACEP_REG_TD > 0 and P_REC_DOC_ACEP_REG_TD <= 5 then 0 
                                                            when P_REC_DOC_ACEP_REG_TD > 5 and P_REC_DOC_ACEP_REG_TD <= 10 then 1
                                                            when P_REC_DOC_ACEP_REG_TD > 10 and P_REC_DOC_ACEP_REG_TD <= 20 then 2
                                                            when P_REC_DOC_ACEP_REG_TD > 20 then 3
                                                            else -1 end) where DIA_ID = fecha; 
    commit;
    update TMP_H_PRC set TD_REC_DOC_ACEPT_REC_DC_ID = (case when P_REC_DOC_ACEP_RECEP_DC > 0 and P_REC_DOC_ACEP_RECEP_DC <= 5 then 0 
                                                            when P_REC_DOC_ACEP_RECEP_DC > 5 and P_REC_DOC_ACEP_RECEP_DC <= 10 then 1
                                                            when P_REC_DOC_ACEP_RECEP_DC > 10 and P_REC_DOC_ACEP_RECEP_DC <= 20 then 2
                                                            when P_REC_DOC_ACEP_RECEP_DC > 20 then 3
                                                            else -1 end) where DIA_ID = fecha; 
    commit;  
    -- Update Fecha Estimada de cobro (Si la fecha de �ltima estimaci�n no se ha cambiado usamos la de creaci�n del procedimiento)
    update TMP_H_PRC set FECHA_ULTIMA_ESTIMACION = (FECHA_CREACION_PROCEDIMIENTO) where DIA_ID = fecha and FECHA_ULTIMA_ESTIMACION is null;
    commit;
    update TMP_H_PRC set FECHA_ESTIMADA_COBRO = (ADD_MONTHS(FECHA_ULTIMA_ESTIMACION, P_RECUPERACION)) where DIA_ID = fecha;
    commit;
    
    -- Update N�mero de d�as trasncurridos desde la �ltima estimaci�n
    update TMP_H_PRC set NUM_DIAS_DESDE_ULT_ESTIMACION = (DIA_ID - FECHA_ULTIMA_ESTIMACION) where DIA_ID = fecha;
    commit;
    -- Actualizaci�n Estimaciones: 0 No Actualizada En �ltimo Semestre / 1 Actualizada En �ltimo Semestre
    update TMP_H_PRC set ACT_ESTIMACIONES_ID = (case when MONTHS_between(FECHA_ULTIMA_ESTIMACION, DIA_ID) >= 6 then 0
                                                     when MONTHS_between(FECHA_ULTIMA_ESTIMACION, DIA_ID) < 6 and MONTHS_between(FECHA_ULTIMA_ESTIMACION, DIA_ID) >= 0 then 1
                                                     else -1 end) where DIA_ID = fecha;
    commit;                                                     
     -- Subtotal
     update TMP_H_PRC tmph set tmph.SUBTOTAL = (select tpe.VALOR from TMP_PRC_EXTRAS_RECOVERY_BI tpe where tmph.DIA_ID = fecha and tmph.FASE_ACTUAL = tpe.UNIDAD_GESTION and tpe.FECHA_VALOR = fecha and TIPO_ENTIDAD = 5 and DD_IFB_ID = 1);
     commit;  
     -- FASE_ACTUAL_AGR_ID
  
  /* merge into TMP_H_PRC t1 using D_PRC_TIPO_PROCEDIMIENTO_DET t2 on(t1.TIPO_PROCEDIMIENTO_DET_ID=t2.TIPO_PROCEDIMIENTO_DET_ID)
   when matched then update set t1.FASE_ACTUAL_AGR_ID=t2.TIPO_PROCEDIMIENTO_AGR_ID
     where t1.DIA_ID =fecha;*/
   
   update TMP_H_PRC set FASE_ACTUAL_AGR_ID = (case when TIPO_PROCEDIMIENTO_DET_ID IN (2452) then 1
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2377) then 2
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2378) then 3
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2353) then 4
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2382) then 5
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2381) then 6
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2543) then 7
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2544) then 8
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2450) then 9
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944,2372,2750) then 10
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2375) then 11
                           when TIPO_PROCEDIMIENTO_DET_ID IN (2842) then 15
                                                     when TIPO_PROCEDIMIENTO_DET_ID NOT IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944,2375) and ESTADO_FASE_ACTUAL_ID=3 then 13
                                                     when TIPO_PROCEDIMIENTO_DET_ID IS NULL then -1
                                                     else 14 end) where DIA_ID = fecha;
   
   
 
    commit;                                                     
    
  /* merge into TMP_H_PRC t1 using D_PRC_FASE_ACTUAL_DETALLE t2 on(t1.FASE_ACTUAL_DETALLE_ID=t2.FASE_ACTUAL_DETALLE_ID)
   when matched then update set t1.FASE_ACTUAL_AGR_ID=t2.FASE_ACTUAL_AGR_ID
     where t1.DIA_ID =fecha;  */
   
    update TMP_H_PRC set FASE_ACTUAL_AGR_ID = (case when FASE_ACTUAL_DETALLE_ID IN (2452) then 1
                                                     when FASE_ACTUAL_DETALLE_ID IN (2377) then 2
                                                     when FASE_ACTUAL_DETALLE_ID IN (2378) then 3
                                                     when FASE_ACTUAL_DETALLE_ID IN (2353) then 4
                                                     when FASE_ACTUAL_DETALLE_ID IN (2382) then 5
                                                     when FASE_ACTUAL_DETALLE_ID IN (2381) then 6
                                                     when FASE_ACTUAL_DETALLE_ID IN (2543) then 7
                                                     when FASE_ACTUAL_DETALLE_ID IN (2544) then 8
                                                     when FASE_ACTUAL_DETALLE_ID IN (2450) then 9
                                                     when FASE_ACTUAL_DETALLE_ID IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944) then 10
                                                     when FASE_ACTUAL_DETALLE_ID IN (2375) then 11
                           when FASE_ACTUAL_DETALLE_ID IN (2842) then 15
                                                     when FASE_ACTUAL_DETALLE_ID NOT IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944,2375) and ESTADO_FASE_ACTUAL_ID=3 then 13
                                                     else FASE_ACTUAL_AGR_ID end) where DIA_ID = fecha;
   
   
   
    commit;     

    ---- procurador -----------------------------------------------------------------------------------------------------------------------------

     execute immediate 'merge into TMP_H_PRC t1 using 
    (select prc.PRC_ID, usu.USU_ID
                from '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS usd 
                join '||V_DATASTAGE||'.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
                join '||V_DATASTAGE||'.GAH_GESTOR_ADICIONAL_HISTORICO gah on gah.GAH_GESTOR_ID = usd.USD_ID
                join '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR tges on gah.GAH_TIPO_GESTOR_ID = tges.DD_TGE_ID
                join '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc on gah.GAH_ASU_ID = prc.ASU_ID
                where tges.DD_TGE_DESCRIPCION = ''Procurador'' and trunc(gah.GAH_FECHA_DESDE) <='''||fecha||''') t2
        on(t1.PROCEDIMIENTO_ID=t2.PRC_ID)
                 when matched then update set t1.PROCURADOR_PRC_ID=t2.USU_ID
                 where t1.DIA_ID = '''||fecha||'''';
    commit;
    ---- fin procurador -------------------------------------------------------------------------------------------------------------------------

                                                    
-- ----------------------------------------------------------- FIN UPDATES TMP_H_PRC ------------------------------------------------------------

    -- Borrado �ndices H_PRC
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_FASE_ACTUAL_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
  
    -- Borrado del d�a a insertar
    delete from H_PRC where DIA_ID = fecha;
    commit;
    
    insert into H_PRC(
        DIA_ID,
        FECHA_CARGA_DATOS,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULT_TAR_CREADA,
        ULT_TAR_FIN,
        ULTIMA_TAREA_ACTUALIZADA,
        ULT_TAR_PEND,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIO,
        FECHA_CREACION_FASE_ANTERIOR,
        FECHA_CREACION_FASE_ACTUAL,
        FECHA_ULT_TAR_CREADA,
        FECHA_ULT_TAR_FIN,
        FECHA_ULTIMA_TAREA_ACTUALIZADA,
        FECHA_ULT_TAR_PEND,
        FECHA_VENC_ORIG_ULT_TAR_FIN,
        FECHA_VENC_ACT_ULT_TAR_FIN,
        FECHA_VENC_ORIG_ULT_TAR_PEND,
        FECHA_VENC_ACT_ULT_TAR_PEND,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPT,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DET_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULT_TAR_CREADA_TIPO_DET_ID,
        ULT_TAR_CREADA_DESC_ID,
        ULT_TAR_FIN_TIPO_DET_ID,
        ULT_TAR_FIN_DESC_ID,
        ULT_TAR_ACT_TIPO_DET_ID,
        ULT_TAR_ACT_DESC_ID,
        ULT_TAR_PEND_TIPO_DET_ID,
        ULT_TAR_PEND_DESC_ID,
        CUMPLIMIENTO_ULT_TAR_FIN_ID,
        CUMPLIMIENTO_ULT_TAR_PEND_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        T_SALDO_TOTAL_PRC_ID,
        T_SALDO_RECUPERACION_PRC_ID,
        T_SALDO_TOTAL_CONCURSO_ID,
        TD_ULT_ACTUALIZACION_PRC_ID,
        TD_CONTRATO_VENCIDO_ID,
        TD_CNT_VENC_CREACION_ASU_ID,
        TD_CREA_ASU_A_INTERP_DEM_ID,
        TD_CREACION_ASU_ACEPT_ID,
        TD_ACEPT_ASU_INTERP_DEM_ID,
        TD_CREA_ASU_REC_DOC_ACEP_ID,
        TD_REC_DOC_ACEPT_REG_TD_ID,
        TD_REC_DOC_ACEPT_REC_DC_ID,
        CNT_GARANTIA_REAL_ASOC_ID,
        ACT_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        NUM_DIAS_ULT_ACTUALIZACION,
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        NUM_MAX_DIAS_CNT_VENC_CREA_ASU,
        PORCENTAJE_RECUPERACION,
        P_RECUPERACION,
        SALDO_RECUPERACION,
        ESTIMACION_RECUPERACION,
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCED_ULT_TAR_FIN,
        NUM_DIAS_VENC_ULT_TAR_FIN,
        NUM_DIAS_PRORROG_ULT_TAR_FIN,
        NUM_PRORROG_ULT_TAR_FIN,
        DURACION_ULT_TAREA_PENDIENTE,
        NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
        NUM_DIAS_VENC_ULT_TAR_PEND,
        NUM_DIAS_PRORROG_ULT_TAR_PEND,
        NUM_PRORROG_ULT_TAR_PEND,
        P_CREA_ASU_A_INTERP_DEM,
        P_CREACION_ASU_ACEP,
        P_ACEPT_ASU_INTERP_DEM,
        P_CREA_ASU_REC_DOC_ACEP,
        P_REC_DOC_ACEP_REG_TD,
        P_REC_DOC_ACEP_RECEP_DC,
        NUM_DIAS_DESDE_ULT_ESTIMACION,
        FECHA_CANCELACION_ASUNTO,
        PRC_PARALIZADO_ID,
        FECHA_PARALIZACION,
        MOTIVO_PARALIZACION_ID,
        FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
      )
    select * from TMP_H_PRC where DIA_ID = fecha;
  
  
  
    -- delete from H_PRC_DET_COBRO where DIA_ID between DATE_START and DATE_END;
  
    -- Borrado �ndices H_PRC
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_CONTRATO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;


    commit;
    
    -- Borrado del d�a a insertar
    delete from H_PRC_DET_CONTRATO where DIA_ID = fecha;
    commit;
    
    insert into H_PRC_DET_CONTRATO
    (
      DIA_ID,
      FECHA_CARGA_DATOS,
      PROCEDIMIENTO_ID,
      ASUNTO_ID,
      CONTRATO_ID,
      NUM_CONTRATOS_PROCEDIMIENTO
    )
    select * from TMP_H_PRC_DET_CONTRATO;
    commit;
    
  end loop;
  close c_fecha;
  
  -- Crear indices H_PRC
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_IX'', ''H_PRC (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;






  commit;      
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_FASE_ACTUAL_IX'', ''H_PRC (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;






  commit;    
    
  
  -- Crear indices H_PRC_DET_CONTRATO


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_IX'', ''H_PRC_DET_CONTRATO (DIA_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;      

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'Termino Bucle H_PRC', 4;
  
-- ---------------------------------------------------------------- FIN BUCLE H_PRC -----------------------------------------------------------------
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'H_PRC. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_PRC_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;



  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PRC_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PRC_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRC;
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
    
    -- Borrado indices H_PRC_SEMANA 
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
     
    -- Borrado de las semanas a insertar
    delete from H_PRC_SEMANA where SEMANA_ID = semana;
    commit;
    
    insert into H_PRC_SEMANA
          (SEMANA_ID,   
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA,
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          NUM_DIAS_ULT_ACTUALIZACION,
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          DURACION_ULT_TAREA_PENDIENTE,
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,          
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
          )
      select semana, 
          max_dia_semana,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA, 
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          to_date(max_dia_semana, 'DD/MM/YY') - trunc(FECHA_ULTIMA_TAREA_ACTUALIZADA),
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          to_date(max_dia_semana, 'DD/MM/YY') - trunc(FECHA_ULT_TAR_PEND),
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,          
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
      from H_PRC where DIA_ID = max_dia_semana;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      -- Crear indices H_PRC_SEMANA    


       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_SEMANA_IX'', ''H_PRC_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



      commit;          

      -- Si no tiene tareas asociadas actualizo a la fecha de creaci�n de la �ltima fase
      update H_PRC_SEMANA set NUM_DIAS_ULT_ACTUALIZACION = to_date(max_dia_semana, 'DD/MM/YY') - trunc(FECHA_CREACION_FASE_ACTUAL) where NUM_DIAS_ULT_ACTUALIZACION is null;                                                         
      -- TD_ULT_ACTUALIZACION_PRC_ID: 0 si <= 30 D�as / 1 si 31 - 60 D�as / 2 si 61 - 90 D�as/ 3 si > 90 D�as
      update H_PRC_SEMANA set TD_ULT_ACTUALIZACION_PRC_ID = (case when NUM_DIAS_ULT_ACTUALIZACION <=30 then 0
                                                                  when NUM_DIAS_ULT_ACTUALIZACION > 30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
                                                                  when NUM_DIAS_ULT_ACTUALIZACION > 60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
                                                                  when NUM_DIAS_ULT_ACTUALIZACION > 60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
                                else -1 end) where TD_ULT_ACTUALIZACION_PRC_ID is null;
     
    -- Borrado indices H_PRC_DET_CONTRATO_SEMANA 
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_CONTRATO_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
     
    -- Borrado de las semanas a insertar
    delete from H_PRC_DET_CONTRATO_SEMANA where SEMANA_ID = semana;
    commit;
    
    -- Detalle Contratos Semana
    insert into H_PRC_DET_CONTRATO_SEMANA
          (SEMANA_ID,
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO
           )
      select semana,   
           max_dia_semana,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO
      from H_PRC_DET_CONTRATO where DIA_ID = max_dia_semana;    
    commit;
    
     --Log_Proceso
     execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  end loop C_SEMANAS_LOOP;
  close c_semana; 
  
  -- Crear indices H_PRC_DET_CONTRATO_SEMANA   


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_SEMANA_IX'', ''H_PRC_DET_CONTRATO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;    
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_SEMANA. Termina bucle', 3;
    

  
-- ----------------------------------------------------------------------------------------------
--                                      H_PRC_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_MES. Empieza Carga', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PRC_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRC;
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

      -- Borrado indices H_PRC_MES
     
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los meses a insertar
      delete from H_PRC_MES where MES_ID = mes;
      commit;
      
      -- Insertado de meses (�ltimo d�a del mes disponible en H_PRC)
      insert into H_PRC_MES
          (MES_ID,   
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA,
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          NUM_DIAS_ULT_ACTUALIZACION,
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          DURACION_ULT_TAREA_PENDIENTE,
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,          
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
          )
      select mes, 
          max_dia_mes,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA, 
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          to_date(max_dia_mes, 'DD/MM/YY') - trunc(FECHA_ULTIMA_TAREA_ACTUALIZADA), 
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          to_date(max_dia_mes, 'DD/MM/YY') - trunc(FECHA_ULT_TAR_PEND),  
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,          
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
      from H_PRC where DIA_ID = max_dia_mes;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
     
      -- Crear indices H_PRC_MES 
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_MES_IX'', ''H_PRC_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;






      commit;    
    
      -- Si no tiene tareas asociadas actualizo a la fecha de creaci�n de la �ltima fase
      update H_PRC_MES set NUM_DIAS_ULT_ACTUALIZACION = to_date(max_dia_mes, 'DD/MM/YY') - trunc(FECHA_CREACION_FASE_ACTUAL) where MES_ID = mes and NUM_DIAS_ULT_ACTUALIZACION is null;                                                         
      -- TD_ULT_ACTUALIZACION_PRC_ID: 0 si <= 30 D�as / 1 si 31 - 60 D�as / 2 si 61 - 90 D�as/ 3 si > 90 D�as
      update H_PRC_MES set TD_ULT_ACTUALIZACION_PRC_ID = (case when NUM_DIAS_ULT_ACTUALIZACION <=30 then 0
                                                               when NUM_DIAS_ULT_ACTUALIZACION >30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
                                                               when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
                                                               when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
                                                               else -1 end) where MES_ID = mes and TD_ULT_ACTUALIZACION_PRC_ID is null;   


      -- Borrado indices H_PRC_DET_CONTRATO_MES
     
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_CONTRATO_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los meses a insertar
      delete from H_PRC_DET_CONTRATO_MES where MES_ID = mes;
      commit;  

      -- Detalle Contratos Mes
      insert into H_PRC_DET_CONTRATO_MES
          (MES_ID,
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO
           )
      select mes,   
           max_dia_mes,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO
      from H_PRC_DET_CONTRATO where DIA_ID = max_dia_mes;
      commit;       
  
        /*     
      delete from H_PRC_DET_COBRO_MES where MES_ID = mes;
      
    -- Detalle Cobros Mes
      insert into H_PRC_DET_COBRO_MES
          (MES_ID,  
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,   
           ASUNTO_ID,
           CONTRATO_ID,
           FECHA_COBRO,
           FECHA_ASUNTO,
           TIPO_COBRO_DETALLE_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           NUM_DIAS_CREACION_ASU_COBRO
          )
      select mes,    
           max_dia_mes,
           PROCEDIMIENTO_ID,   
           ASUNTO_ID,
           CONTRATO_ID,
           FECHA_COBRO,
           FECHA_ASUNTO,
           TIPO_COBRO_DETALLE_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           NUM_DIAS_CREACION_ASU_COBRO
      from H_PRC_DET_COBRO where DIA_ID = max_dia_mes;
       
        */  
        
  end loop C_MESES_LOOP;
  close c_mes;

  -- Crear indices H_PRC_DET_CONTRATO_MES    


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_MES_IX'', ''H_PRC_DET_CONTRATO_MES (MES_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;    

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_MES. Termina bucle', 3;
  

-- ----------------------------------------------------------------------------------------------
--                                      H_PRC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PRC_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRC;
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
      
      -- Borrar indices H_PRC_TRIMESTRE
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los trimestres a insertar
      delete from H_PRC_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;
      
      insert into H_PRC_TRIMESTRE
          (TRIMESTRE_ID,   
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA, 
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          NUM_DIAS_ULT_ACTUALIZACION,
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          DURACION_ULT_TAREA_PENDIENTE,
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,          
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
          )
      select trimestre, 
          max_dia_trimestre,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA, 
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          to_date(max_dia_trimestre, 'DD/MM/YY') - trunc(FECHA_ULTIMA_TAREA_ACTUALIZADA),
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          to_date(max_dia_trimestre, 'DD/MM/YY') - trunc(FECHA_ULT_TAR_PEND),
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,          
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
      from H_PRC where DIA_ID = max_dia_trimestre;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
      -- Crear indices H_PRC_TRIMESTRE      


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_TRIMESTRE_IX'', ''H_PRC_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



      commit;    

      -- Si no tiene tareas asociadas actualizo a la fecha de creaci�n de la �ltima fase
      update H_PRC_TRIMESTRE set NUM_DIAS_ULT_ACTUALIZACION = to_date(max_dia_trimestre, 'DD/MM/YY') - trunc(FECHA_CREACION_FASE_ACTUAL) where TRIMESTRE_ID = trimestre and NUM_DIAS_ULT_ACTUALIZACION is null;
      -- TD_ULT_ACTUALIZACION_PRC_ID: 0 si <= 30 D�as / 1 si 31 - 60 D�as / 2 si 61 - 90 D�as/ 3 si > 90 D�as
      update H_PRC_TRIMESTRE set TD_ULT_ACTUALIZACION_PRC_ID = (case when NUM_DIAS_ULT_ACTUALIZACION <=30 then 0
                                                                                                when NUM_DIAS_ULT_ACTUALIZACION >30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
                                                                                                when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
                                                                                                when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
                                                                                                else -1 end) where TRIMESTRE_ID = trimestre and TD_ULT_ACTUALIZACION_PRC_ID is null;
       
      -- Borrado indices H_PRC_DET_CONTRATO_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_CONTRATO_TRI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los trimestres a insertar
      delete from H_PRC_DET_CONTRATO_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;  
      
      -- Detalle Contratos Trimestre
      insert into H_PRC_DET_CONTRATO_TRIMESTRE
          (TRIMESTRE_ID, 
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO)
      select trimestre, 
           max_dia_trimestre,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO
       from H_PRC_DET_CONTRATO where DIA_ID = max_dia_trimestre;
       commit;
       
      /*                                                                                          
      -- Detalle Cobros Trimestre
      insert into H_PRC_DET_COBRO_TRIMESTRE
          (TRIMESTRE_ID,
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,   
           ASUNTO_ID,
           CONTRATO_ID,
           FECHA_COBRO,
           FECHA_ASUNTO,
           TIPO_COBRO_DETALLE_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           NUM_DIAS_CREACION_ASU_COBRO
          )
      select trimestre,
           max_dia_trimestre,
           PROCEDIMIENTO_ID,   
           ASUNTO_ID,
           CONTRATO_ID,
           FECHA_COBRO,
           FECHA_ASUNTO,
           TIPO_COBRO_DETALLE_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           NUM_DIAS_CREACION_ASU_COBRO 
      from H_PRC_DET_COBRO where DIA_ID = max_dia_trimestre;
       */
       
  end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

  -- Crear indices H_PRC_DET_CONTRATO_TRIMESTRE     


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_TRI_IX'', ''H_PRC_DET_CONTRATO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;      

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'H_PRC_TRIMESTRE. Termina Carga', 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      H_PRC_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;


  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PRC_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRC;
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
      
      -- Crear indices H_PRC_ANIO
    
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los a�s a insertar
      delete from H_PRC_ANIO where ANIO_ID = anio;
      commit;
      insert into H_PRC_ANIO
          (ANIO_ID,      
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA, 
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          NUM_DIAS_ULT_ACTUALIZACION,
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          DURACION_ULT_TAREA_PENDIENTE,
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,          
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
          )
      select anio,   
          max_dia_anio,
          PROCEDIMIENTO_ID,
          FASE_MAX_PRIORIDAD,
          FASE_ANTERIOR,
          FASE_ACTUAL,
          ULT_TAR_CREADA,
          ULT_TAR_FIN,
          ULTIMA_TAREA_ACTUALIZADA,
          ULT_TAR_PEND,
          FECHA_CREACION_ASUNTO,
          FECHA_CONTABLE_LITIGIO,
          FECHA_CREACION_PROCEDIMIENTO,
          FECHA_CREACION_FASE_MAX_PRIO,
          FECHA_CREACION_FASE_ANTERIOR, 
          FECHA_CREACION_FASE_ACTUAL, 
          FECHA_ULT_TAR_CREADA, 
          FECHA_ULT_TAR_FIN, 
          FECHA_ULTIMA_TAREA_ACTUALIZADA, 
          FECHA_ULT_TAR_PEND,
          FECHA_VENC_ORIG_ULT_TAR_FIN, 
          FECHA_VENC_ACT_ULT_TAR_FIN,
          FECHA_VENC_ORIG_ULT_TAR_PEND, 
          FECHA_VENC_ACT_ULT_TAR_PEND,
          FECHA_ACEPTACION,
          FECHA_RECOGIDA_DOC_Y_ACEPT,
          FECHA_REGISTRAR_TOMA_DECISION,
          FECHA_RECEPCION_DOC_COMPLETA,
          FECHA_INTERPOSICION_DEMANDA,
          FECHA_ULTIMA_POSICION_VENCIDA,
          FECHA_ULTIMA_ESTIMACION,
          FECHA_ESTIMADA_COBRO,
          CONTEXTO_FASE,
          NIVEL,
          ASUNTO_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_DETALLE_ID,
          FASE_ANTERIOR_DETALLE_ID,
          ULT_TAR_CREADA_TIPO_DET_ID, 
          ULT_TAR_CREADA_DESC_ID, 
          ULT_TAR_FIN_TIPO_DET_ID,
          ULT_TAR_FIN_DESC_ID,
          ULT_TAR_ACT_TIPO_DET_ID,
          ULT_TAR_ACT_DESC_ID,
          ULT_TAR_PEND_TIPO_DET_ID,
          ULT_TAR_PEND_DESC_ID,
          CUMPLIMIENTO_ULT_TAR_FIN_ID,
          CUMPLIMIENTO_ULT_TAR_PEND_ID,
          ESTADO_PROCEDIMIENTO_ID,
          ESTADO_FASE_ACTUAL_ID,
          ESTADO_FASE_ANTERIOR_ID,
          T_SALDO_TOTAL_PRC_ID,
          T_SALDO_RECUPERACION_PRC_ID,
          T_SALDO_TOTAL_CONCURSO_ID,
          TD_CONTRATO_VENCIDO_ID,
          TD_CNT_VENC_CREACION_ASU_ID,
          TD_CREA_ASU_A_INTERP_DEM_ID,  
          TD_CREACION_ASU_ACEPT_ID,
          TD_ACEPT_ASU_INTERP_DEM_ID,
          TD_CREA_ASU_REC_DOC_ACEP_ID,
          TD_REC_DOC_ACEPT_REG_TD_ID, 
          TD_REC_DOC_ACEPT_REC_DC_ID,
          CNT_GARANTIA_REAL_ASOC_ID,
          ACT_ESTIMACIONES_ID,
          CARTERA_PROCEDIMIENTO_ID,
          TITULAR_PROCEDIMIENTO_ID,
          NUM_PROCEDIMIENTOS,
          NUM_CONTRATOS,
          NUM_FASES,
          to_date(max_dia_anio, 'DD/MM/YY') - trunc(FECHA_ULTIMA_TAREA_ACTUALIZADA),
          NUM_MAX_DIAS_CONTRATO_VENCIDO,
          PORCENTAJE_RECUPERACION,
          P_RECUPERACION,
          SALDO_RECUPERACION,
          ESTIMACION_RECUPERACION,
          SALDO_ORIGINAL_VENCIDO,
          SALDO_ORIGINAL_NO_VENCIDO,
          SALDO_ACTUAL_VENCIDO,
          SALDO_ACTUAL_NO_VENCIDO,
          SALDO_ACTUAL_TOTAL,
          SALDO_CONCURSOS_VENCIDO,
          SALDO_CONCURSOS_NO_VENCIDO,
          SALDO_CONCURSOS_TOTAL,
          INGRESOS_PENDIENTES_APLICAR,
          SUBTOTAL,
          DURACION_ULT_TAREA_FINALIZADA,
          NUM_DIAS_EXCED_ULT_TAR_FIN,
          NUM_DIAS_VENC_ULT_TAR_FIN,
          NUM_DIAS_PRORROG_ULT_TAR_FIN,          
          -- NUM_PRORROG_ULT_TAR_FIN,
          to_date(max_dia_anio, 'DD/MM/YY') - trunc(FECHA_ULT_TAR_PEND),
          NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
          NUM_DIAS_VENC_ULT_TAR_PEND,
          NUM_DIAS_PRORROG_ULT_TAR_PEND,         
          -- NUM_PRORROG_ULT_TAR_PEND 
          P_CREA_ASU_A_INTERP_DEM,  
          P_CREACION_ASU_ACEP,   
          P_ACEPT_ASU_INTERP_DEM,
          P_CREA_ASU_REC_DOC_ACEP,
          P_REC_DOC_ACEP_REG_TD,
          P_REC_DOC_ACEP_RECEP_DC,
          NUM_DIAS_DESDE_ULT_ESTIMACION,
          FECHA_CANCELACION_ASUNTO,
          PRC_PARALIZADO_ID,
          FECHA_PARALIZACION,
          MOTIVO_PARALIZACION_ID,
          FASE_ACTUAL_AGR_ID,
    PROCURADOR_PRC_ID
      from H_PRC where DIA_ID = max_dia_anio;
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRC_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
      -- Crear indices H_PRC_ANIO   


       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_ANIO_IX'', ''H_PRC_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



      commit;    

      -- Si no tiene tareas asociadas actualizo a la fecha de creaci�n de la �ltima fase
      update H_PRC_ANIO set NUM_DIAS_ULT_ACTUALIZACION = (max_dia_anio - FECHA_CREACION_FASE_ACTUAL) where ANIO_ID = anio and NUM_DIAS_ULT_ACTUALIZACION is null;
      
      -- TD_ULT_ACTUALIZACION_PRC_ID: 0 si <= 30 D�as / 1 si 31 - 60 D�as / 2 si 61 - 90 D�as/ 3 si > 90 D�as
      update H_PRC_ANIO set TD_ULT_ACTUALIZACION_PRC_ID = (case when NUM_DIAS_ULT_ACTUALIZACION <= 30 then 0
                                                                when NUM_DIAS_ULT_ACTUALIZACION > 30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
                                                                when NUM_DIAS_ULT_ACTUALIZACION > 60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
                                                                when NUM_DIAS_ULT_ACTUALIZACION > 60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
                                                                else -1 end) where ANIO_ID = anio and TD_ULT_ACTUALIZACION_PRC_ID is null;  
     
     -- Borrado indices H_PRC_DET_CONTRATO_ANIO
     
V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRC_DET_CONTRATO_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';

        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los a�os a insertar
      delete from H_PRC_DET_CONTRATO_ANIO where ANIO_ID = anio;
      commit;  
         
      -- Detalle Contratos A�o
      insert into H_PRC_DET_CONTRATO_ANIO
          (ANIO_ID,   
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO)
      select anio, 
           max_dia_anio,
           PROCEDIMIENTO_ID,
           ASUNTO_ID,
           CONTRATO_ID,
           NUM_CONTRATOS_PROCEDIMIENTO
      from H_PRC_DET_CONTRATO where DIA_ID = max_dia_anio;
      commit;
      
     /*                                                           
      -- Detalle Cobros A�o
      insert into H_PRC_DET_COBRO_ANIO
          (ANIO_ID, 
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,   
           ASUNTO_ID,
           CONTRATO_ID,
           FECHA_COBRO,
           FECHA_ASUNTO,
           TIPO_COBRO_DETALLE_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           NUM_DIAS_CREACION_ASU_COBRO
          )
      select anio,  
           max_dia_anio,
           PROCEDIMIENTO_ID,   
           ASUNTO_ID,
           CONTRATO_ID,
           FECHA_COBRO,
           FECHA_ASUNTO,
           TIPO_COBRO_DETALLE_ID,
           NUM_COBROS,
           IMPORTE_COBRO,
           NUM_DIAS_CREACION_ASU_COBRO  
      from H_PRC_DET_COBRO where DIA_ID = max_dia_anio;
       */
  end loop C_ANIO_LOOP; 
  close c_anio;
  
  -- Crear indices H_PRC_DET_CONTRATO_ANIO     


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRC_DET_CONTRATO_ANIO_IX'', ''H_PRC_DET_CONTRATO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  commit;      

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'H_PRC_ANIO. Termina Carga', 3;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
/*EXCEPTION
  when OBJECTEXISTS then
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  when INSERT_NULL then
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;    
  when PARAMETERS_NUMBER then
    O_ERROR_STATUS := 'N�mero de par�metros incorrecto';
    --ROLLBACK;    
  when OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;*/
    --ROLLBACK;  
end;
end CARGAR_H_PROCEDIMIENTO;
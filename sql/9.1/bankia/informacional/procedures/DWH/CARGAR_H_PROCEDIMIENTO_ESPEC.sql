create or replace PROCEDURE CARGAR_H_PROCEDIMIENTO_ESPEC (DATE_START IN DATE, DATE_END IN DATE, O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable última modificación: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 12/08/2015
-- Motivos del cambio: Usuario/Propietario

-- Cliente: Recovery BI Bankia
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos Concurso, Declarativo,
--              Ejecución Ordinaria, Hipotecario, Monitorio y Ejecución notarial.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- PROCEDIMIENTOS ESPECÍFICOS
    -- CONCURSOS
    -- DECLARATIVO
    -- EJECUCION_ORDINARIA
    -- HIPOTECARIO
    -- MONITORIO
    -- EJECUCION_NOTARIAL

-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);

  max_dia_semana date;
  max_dia_mes date;
  max_dia_trimestre date;
  max_dia_anio date;
  max_dia_carga date;
  trimestre int;
  anio int;
  fecha date;
  fecha_rellenar date;
  max_dia_pre_start date;
  existe_date_start int;


  nCount number;

  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PROCEDIMIENTO_ESPEC';
  V_ROWCOUNT NUMBER;
  V_SQL varchar2(16000);
  
  cursor c_fecha_rellenar is select distinct(DIA_ID) DIA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_fecha is select distinct(DIA_ID) DIA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA order by 1;
  cursor c_mes is select distinct MES_H from TMP_FECHA order by 1;
  cursor c_trimestre is select distinct TRIMESTRE_H from TMP_FECHA order by 1;
  cursor c_anio is select distinct ANIO_H from TMP_FECHA order by 1;

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


-- ------------------------------- PRIORIDADES PROCEDIMIENTOS -----------------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_CODIGO_PRIORIDAD'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P198', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P199', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P95', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P35', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P56', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P63', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P64', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P24', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P25', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P26', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P27', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P28', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P29', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P30', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P31', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P34', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P01', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P02', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P15', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P17', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P55', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P62', 3);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P03', 2);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P04', 2);
  insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TIPO_CODIGO, PRIORIDAD) values ('P16', 1);
  commit;


  -- Borrado índices TMP_PRC_ESPECIFICO_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_ESPEC_JRQ_ITER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_PRC_ESPEC_JRQ_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESPECIFICO_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- Si DATE_START no existe en PRC_PROCEDIMIENTOS_JERARQUIA cogemos la última anterior que haya en PRC_PROCEDIMIENTOS_JERARQUIA
  execute immediate 'select count(1) from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO = '''||DATE_START||'''' into existe_date_start;
  

  if(existe_date_start = 0) then
    execute immediate 'select max(FECHA_PROCEDIMIENTO) from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO <= '''||DATE_START||'''' into max_dia_pre_start;

    execute immediate 'insert into TMP_PRC_ESPECIFICO_JERARQUIA (
      DIA_ID,                               
      ITER,
      FASE_ACTUAL,
      NIVEL,
      CONTEXTO,
      CODIGO_FASE_ACTUAL,
      PRIORIDAD_FASE,
      ASUNTO
    ) 
  select '''||DATE_START||''',
      pj_PADRE,
      PRC_ID,
      NIVEL,
      PATH_DERIVACION,
      PRC_TPO,
      NVL(PRIORIDAD, 0),
      ASU_ID
  from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA
  left join TMP_PRC_CODIGO_PRIORIDAD on PRC_TPO = DD_TIPO_CODIGO
  where FECHA_PROCEDIMIENTO = '''||max_dia_pre_start||'''';
  commit;
  end if;
  

  execute immediate
    'insert into TMP_PRC_ESPECIFICO_JERARQUIA (
        DIA_ID,
        ITER,
        FASE_ACTUAL,
        NIVEL,
        CONTEXTO,
        CODIGO_FASE_ACTUAL,
        PRIORIDAD_FASE,
        ASUNTO
      )
    select FECHA_PROCEDIMIENTO,
        PJ_PADRE,
        PRC_ID,
        NIVEL,
        PATH_DERIVACION,
        PRC_TPO,
        NVL(PRIORIDAD, 0),
        ASU_ID
    from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA
    left join TMP_PRC_CODIGO_PRIORIDAD ON PRC_TPO = DD_TIPO_CODIGO
    where FECHA_PROCEDIMIENTO between '''||date_START||''' and '''||date_END||'''';
    commit;


   -- Rellenar los días que no tienen entradas de procedimientos. No ha existido ningún movimiento. La foto es la del día anterior.

  open c_fecha_rellenar;
  loop --RELLENAR_LOOP
    fetch c_fecha_rellenar into fecha_rellenar;
    exit when c_fecha_rellenar%NOTFOUND;

      -- Si un día no ha habido movimiento copiamos dia anterior
      select COUNT(DIA_ID)
      into V_NUM_ROW
      from TMP_PRC_JERARQUIA
      where DIA_ID = fecha_rellenar;

      if(V_NUM_ROW = 0) then

        insert into TMP_PRC_ESPECIFICO_JERARQUIA(
            DIA_ID,
            ITER,
            FASE_ACTUAL,
            NIVEL,
            CONTEXTO,
            CODIGO_FASE_ACTUAL,
            PRIORIDAD_FASE,
            ASUNTO
            )
        select DIA_ID + 1,
            ITER,
            FASE_ACTUAL,
            NIVEL,
            CONTEXTO,
            CODIGO_FASE_ACTUAL,
            PRIORIDAD_FASE,
            ASUNTO
            from TMP_PRC_ESPECIFICO_JERARQUIA
            where DIA_ID = (fecha_rellenar - 1);

        V_ROWCOUNT := sql%rowcount;
        commit;

         --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_PRC_ESPECIFICO_JERARQUIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

  end if;


    -- Update fase actual paralizada, fase finalizada en función de las decisiones asociadas
    -- Fase Actual Paralizada
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESPECIFICO_DECISION'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    execute immediate '
    insert into TMP_PRC_ESPECIFICO_DECISION (FASE_ACTUAL, FASE_PARALIZADA, FASE_FINALIZADA, FECHA_HASTA)
    select PRC_ID, DPR_PARALIZA, DPR_FINALIZA,  max(trunc(DPR_FECHA_PARA))
    from '||V_DATASTAGE||'.DPR_DECISIONES_PROCEDIMIENTOS
    where (DD_EDE_ID = 2 and DPR_PARALIZA = 1)
    and trunc(FECHACREAR) <= '''|| fecha_rellenar ||''' group by PRC_ID, DPR_PARALIZA, DPR_FINALIZA';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_PRC_ESPECIFICO_DECISION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    merge into TMP_PRC_ESPECIFICO_JERARQUIA a
    using (select distinct FECHA_HASTA, FASE_ACTUAL from TMP_PRC_ESPECIFICO_DECISION where FASE_PARALIZADA = 1) b
    on (b.FASE_ACTUAL = a.FASE_ACTUAL and a.DIA_ID <= b.FECHA_HASTA)
    when matched then update set a.FASE_PARALIZADA = 1;
    commit;

  end loop;
  close c_fecha_rellenar;

  -- Crear indices TMP_PRC_ESPECIFICO_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESPEC_JRQ_ITER_IX'', ''TMP_PRC_ESPECIFICO_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_PRC_ESPEC_JRQ_FASE_ACT_IX'', ''TMP_PRC_ESPECIFICO_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  open c_fecha;
  loop
    fetch c_fecha into fecha;
    exit when c_fecha%NOTFOUND;

    -- Tabla auxiliar con el detalle diario. Reinicio para cada día
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_ESPECIFICO_DETALLE'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    insert into TMP_PRC_ESPECIFICO_DETALLE(ITER)
    select distinct ITER from TMP_PRC_ESPECIFICO_JERARQUIA where DIA_ID = fecha;

    -- Calculamos la máxima prioridad del procedimiento en la fecha.
    merge into TMP_PRC_ESPECIFICO_DETALLE a
    using (select ITER, max(PRIORIDAD_FASE) as PRIORIDAD_FASE from TMP_PRC_ESPECIFICO_JERARQUIA where DIA_ID = fecha group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.MAX_PRIORIDAD = b.PRIORIDAD_FASE;
    commit;

    -- Asignamos la prioridad a todos las actuaciones del procedimiento.
    merge into TMP_PRC_ESPECIFICO_JERARQUIA a
    using (select ITER, MAX_PRIORIDAD from TMP_PRC_ESPECIFICO_DETALLE) b
    on (b.ITER = a.ITER)
    when matched then update set a.PRIORIDAD_PROCEDIMIENTO = b.MAX_PRIORIDAD where a.DIA_ID = fecha;
    commit;

    merge into TMP_PRC_ESPECIFICO_DETALLE a
    using (select ITER, max(FASE_ACTUAL) as FASE_ACTUAL from TMP_PRC_ESPECIFICO_JERARQUIA where DIA_ID = fecha and PRIORIDAD_PROCEDIMIENTO = PRIORIDAD_FASE group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FASE_MAX_PRIORIDAD = b.FASE_ACTUAL;
    commit;

    merge into TMP_PRC_ESPECIFICO_JERARQUIA a
    using (select ITER, FASE_MAX_PRIORIDAD from TMP_PRC_ESPECIFICO_DETALLE) b
    on (b.ITER = a.ITER)
    when matched then update set a.FASE_MAX_PRIORIDAD = b.FASE_MAX_PRIORIDAD where a.DIA_ID = fecha;
    commit;

  end loop;
  close c_fecha;

  -- Calcular tipo de procedimiento
   execute immediate 'merge into TMP_PRC_ESPECIFICO_JERARQUIA a
          using (select PRC_ID, DD_TPO_ID from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) b
          on (b.PRC_ID = a.FASE_MAX_PRIORIDAD)
          when matched then update set a.TIPO_PROCEDIMIENTO_DET = b.DD_TPO_ID';
   commit;

-- =========================================================================================================================================
--                  					                        				        CONCURSOS
-- =========================================================================================================================================
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU. Empieza Carga', 3;

  -- Borrado índices TMP_CONCU_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CONCU_JRQ_ITER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CONCU_JRQ_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate 'insert into TMP_CONCU_JERARQUIA
                      select a.* from TMP_PRC_ESPECIFICO_JERARQUIA a,
                                (select distinct DD_TPO_ID
                                 from '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO tp
                                 join '||V_DATASTAGE||'.DD_TAC_TIPO_ACTUACION ta
                                 on tp.DD_TAC_ID = ta.DD_TAC_ID
                                 where DD_TAC_DESCRIPCION = ''Concursal'') b
                      where a.TIPO_PROCEDIMIENTO_DET = b.DD_TPO_ID';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CONCU_JERARQUIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

  -- Crear indices TMP_CONCU_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_JRQ_ITER_IX'', ''TMP_CONCU_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_JRQ_FASE_ACT_IX'', ''TMP_CONCU_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  open c_fecha;
  loop
    fetch c_fecha into fecha;
    exit when c_fecha%NOTFOUND;

    -- ------------------ TAREAS ASOCIADAS -----------------------------
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Comienza TAREAS ASOCIADAS con fecha: ' || TO_CHAR(fecha, 'dd/mm/yyyy'), 4;


    -- Borrado índices TMP_CONCU_DETALLE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CONCU_DETALLE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- Calculo las fechas de los hitos a medir
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_DETALLE'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_DETALLE(ITER)
    select distinct ITER from  TMP_CONCU_JERARQUIA where DIA_ID = fecha;
    commit;

    -- Crear indices TMP_CONCU_DETALLE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CONCU_DETALLE_IX'', ''TMP_CONCU_DETALLE (ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- FECHA_AUTO_FASE_COMUN
    -- TAP_ID: 411 P23_registrarPublicacionBOE  FASE: T. fase común ordinario / TAP_ID: 419 P24_registrarPublicacionBOE  FASE: T. fase común abreviado
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_AUTO_FASE_COMUN', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and trunc(tar.TAR_FECHA_FIN) <= :fecha and tar.TAR_FECHA_FIN is not null
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002776)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fechaAuto''
    where  DIA_ID = :fecha' using fecha, fecha; -- 20150421
    --and tex.tap_id in (411, 419)';
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_AUTO_FASE_COMUN = b.FECHA_FOR;
    commit;

    -- FECHA_LIQUIDACION
    -- Fecha de inicio de la fase T. fase de liquidación
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_LIQUIDACION', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, trunc(prc.FECHACREAR)
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc on tpj.FASE_ACTUAL = prc.PRC_ID and trunc(prc.FECHACREAR) <= :fecha and prc.DD_TPO_ID=150 and prc.BORRADO = 0
    where  DIA_ID = :fecha ' using fecha, fecha;
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_LIQUIDACION = b.FECHA_FOR;
    commit;

    -- FECHA_PUBLICACION_BOE
    -- TAP_ID: 411 P23_registrarPublicacionBOE FASE: T. fase común ordinario / TAP_ID: 419 P24_registrarPublicacionBOE FASE: T. fase común abreviado
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_PUBLICACION_BOE', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002776)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
    where  DIA_ID = :fecha' using fecha, fecha; --20150421
    --and tex.tap_id in (411, 419)';
    commit;


    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_PUBLICACION_BOE = b.FECHA_FOR;
    commit;

    -- FECHA_INSINUACION_FINAL_CRED
    -- TAP_ID: 1102	P23_registrarFinFaseComun FASE: Registrar resolución finalización fase común / TAP_ID: 1106	P24_registrarFinFaseComun FASE: Registrar resolución finalización fase común
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_INSINUACION_FINAL_CRED', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002771)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
    where  DIA_ID = :fecha ' using fecha, fecha; --20150421
    --and tex.tap_id in (1106, 1102)';
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_INSINUACION_FINAL_CRED = b.FECHA_FOR;
    commit;

    -- FECHA_AUTO_APERTURA_CONVENIO
    -- TAP_ID: 449 P29_autoApertura  FASE: T. fase convenio
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_AUTO_APERTURA_CONVENIO', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002755)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fechaFase''
    where  DIA_ID = :fecha  ' using fecha, fecha; -- 20150421
    --and tex.tap_id in (449)';

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_AUTO_APERTURA_CONVENIO = b.FECHA_FOR;
    commit;

    -- FECHA_REGISTRAR_IAC
    -- TAP_ID: 416 P23_informeAdministracionConcursal  FASE: Registrar informe administración concursal TAP_ID: 424 P24_informeAdministracionConcursal
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_REGISTRAR_IAC', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002773)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
    where  DIA_ID = :fecha  ' using fecha, fecha; --20150421
    --and tex.tap_id in (416, 424)';
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_REGISTRAR_IAC = b.FECHA_FOR;
    commit;

    -- FECHA_INTERPOSICION_DEMANDA
    -- TAP_ID: 427 P25_interposicionDemanda  FASE: T. demanda incidental
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_INTERPOSICION_DEMANDA', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (427)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
    where  DIA_ID = :fecha   ' using fecha, fecha;
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_INTERPOSICION_DEMANDA = b.FECHA_FOR;
    commit;

    -- FECHA_JUNTA_ACREEDORES
    -- TAP_ID: 456 P29_registrarResultado  FASE: T. fase convenio
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_JUNTA_ACREEDORES', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, 
        case TEV_VALOR when ''0NaN-NaN-NaN'' then TO_date(TO_CHAR(tev.FECHACREAR, ''yyyy-mm-dd''), ''YYYY-MM-DD'') else TO_DATE(TEV_VALOR, ''YYYY-MM-DD'') end case
    from TMP_CONCU_JERARQUIA tpj    
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null  and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002758)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fechaJunta''
    where  DIA_ID = :fecha   ' using fecha, fecha; --20150421
    --and tex.tap_id in (456)';
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_JUNTA_ACREEDORES = b.FECHA_FOR;
    commit;

    -- FECHA_REG_RESOL_APERTURA_LIQ
    -- TAP_ID: 456 P31_aperturaFase  FASE: T. fase liquidación
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'FECHA_REG_RESOL_APERTURA_LIQ', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (467)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
    where  DIA_ID = :fecha  ' using fecha, fecha;
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_REG_RESOL_APERTURA_LIQ = b.FECHA_FOR;
    commit;

    -- ESTADO_CONVENIO
    -- TAP_ID: 1134	P64_registrarConvenio   Registrar convenio aprobado
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'ESTADO_CONVENIO', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, VALOR_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TEV_VALOR
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and (tar.TAR_FECHA_FIN is not null OR TRUNC(tar.TAR_FECHA_FIN) <= :fecha)
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002758)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''comboAlgunConvenio''
    where  DIA_ID = :fecha   ' using fecha, fecha;
    --and tex.tap_id in (1134)'; --20150421
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_AUX (ITER, TAREA, FECHA_INI)
    select ITER, TAREA, FECHA_INI from TMP_CONCU_TAREA;
    commit;

    merge into TMP_CONCU_AUX a
    using (select ITER,  max(FECHA_INI) as FECHA_INI from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.MAX_FECHA_INI = b.FECHA_INI;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_CONVENIO'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_CONVENIO (ITER, TAREA, FECHA_INI, FECHA_FIN, VALOR_FORMULARIO)
    select tctar.ITER, tctar.TAREA, tctar.FECHA_INI, FECHA_FIN, VALOR_FORMULARIO
    from TMP_CONCU_TAREA tctar
    join TMP_CONCU_AUX taux on tctar.ITER = taux.ITER
    where tctar.FECHA_INI = taux.MAX_FECHA_INI;
    commit;


/*
    -- 0	No Aprobado / 1	Aprobado
    update TMP_CONCU_DETALLE cd
      set ESTADO_CONVENIO = (select (case
                                      when FECHA_FIN is null then 0
                                      when FECHA_FIN is not null then 1
                                      else -1 end)
                            from TMP_CONCU_CONVENIO tc
                            where cd.ITER = tc.ITER);
*/

    -- 0	No Aprobado / 1	Aprobado
    merge into TMP_CONCU_DETALLE a
    using (select distinct ITER, (case when VALOR_FORMULARIO = '02' then 0
                              when VALOR_FORMULARIO = '01' then 1
                              else -1 end) as ESTADO_CONVENIO
           from TMP_CONCU_CONVENIO) b
    on (b.ITER = a.ITER)
    when matched then update set a.ESTADO_CONVENIO = b.ESTADO_CONVENIO;
    commit;


    -- CUANTIA_CONVENIO
    -- TAP_ID: 1134	P64_registrarConvenio   Registrar convenio aprobado
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'CUANTIA_CONVENIO', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, VALOR_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TEV_VALOR
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (1134)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''cuanti''
    where  DIA_ID = :fecha  ' using fecha, fecha;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_CONVENIO'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_CONVENIO (ITER, TAREA, FECHA_INI, FECHA_FIN, VALOR_FORMULARIO)
    select tctar.ITER, tctar.TAREA, tctar.FECHA_INI, FECHA_FIN, VALOR_FORMULARIO
    from TMP_CONCU_TAREA tctar
    join TMP_CONCU_AUX taux on tctar.ITER = taux.ITER
    where tctar.FECHA_INI = taux.MAX_FECHA_INI;
    commit;

    -- 0	No Aprobado / 1	Aprobado
    merge into TMP_CONCU_DETALLE a
    using (select distinct ITER,  VALOR_FORMULARIO from TMP_CONCU_CONVENIO) b
    on (b.ITER = a.ITER)
    when matched then update set a.CUANTIA_CONVENIO = b.VALOR_FORMULARIO;
    commit;

    -- QUITA_CONVENIO
    -- TAP_ID: 1134	P64_registrarConvenio   Registrar convenio aprobado
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'QUITA_CONVENIO', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, VALOR_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TEV_VALOR
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= :fecha
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (1134)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''quita''
    where  DIA_ID = :fecha   ' using fecha, fecha;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_CONVENIO'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_CONVENIO (ITER, FECHA_INI, FECHA_FIN, VALOR_FORMULARIO)
    select tctar.ITER, MAX(tctar.FECHA_INI), FECHA_FIN, VALOR_FORMULARIO
    from TMP_CONCU_TAREA tctar
    group by ITER, FECHA_FIN, VALOR_FORMULARIO;
    commit;

    -- 0	No Aprobado / 1	Aprobado
    merge into TMP_CONCU_DETALLE a
    using (select distinct ITER,  VALOR_FORMULARIO from TMP_CONCU_CONVENIO) b
    on (b.ITER = a.ITER)
    when matched then update set a.QUITA_CONVENIO = to_number(replace(b.VALOR_FORMULARIO,'.',','));
    commit;

    -- SEGUIMIENTO_CONVENIO
    -- TAP_ID: 1135	P64_registrarCumplimiento   Registrar cumplimiento de convenio
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'SEGUIMIENTO_CONVENIO', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_CONCU_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, VALOR_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TEV_VALOR
    from TMP_CONCU_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and (tar.TAR_FECHA_FIN is not null OR TRUNC(tar.TAR_FECHA_FIN) <= :fecha)
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (1135)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''comboCumplimiento''
    where  DIA_ID = :fecha   ' using fecha, fecha;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_AUX (ITER, TAREA, FECHA_INI)
    select ITER, TAREA, FECHA_INI from TMP_CONCU_TAREA;
    commit;

    merge into TMP_CONCU_AUX a
    using (select ITER,  max(FECHA_INI) as FECHA_INI from TMP_CONCU_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.MAX_FECHA_INI = b.FECHA_INI;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_CONVENIO'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_CONVENIO (ITER, TAREA, FECHA_INI, FECHA_FIN, VALOR_FORMULARIO)
    select tctar.ITER, tctar.TAREA, tctar.FECHA_INI, FECHA_FIN, VALOR_FORMULARIO
    from TMP_CONCU_TAREA tctar
    join TMP_CONCU_AUX taux on tctar.ITER = taux.ITER and tctar.FECHA_INI = taux.MAX_FECHA_INI;
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select distinct ITER, (case when VALOR_FORMULARIO = '02' then 0
                              when VALOR_FORMULARIO = '01' then 1
                               else -1 end) as SEGUIMIENTO_CONVENIO
           from TMP_CONCU_CONVENIO) b
    on (b.ITER = a.ITER)
    when matched then update set a.SEGUIMIENTO_CONVENIO = b.SEGUIMIENTO_CONVENIO;
    commit;

    -- GARANTIA_CONCURSO
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'GARANTIA_CONCURSO', 5;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CONCU_CONTRATO'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_CONCU_CONTRATO (PROCEDIMIENTO_ID, CONTRATO_ID)
    select PROCEDIMIENTO_ID, CONTRATO_ID
    from H_PRC_DET_CONTRATO hpdc
    join TMP_CONCU_DETALLE tcd on hpdc.PROCEDIMIENTO_ID = tcd.ITER
    where DIA_ID = fecha;
    commit;

    execute immediate 'merge into TMP_CONCU_CONTRATO a
            using (select distinct CNT_ID, DD_GC1_ID from '||V_DATASTAGE||'.CNT_CONTRATOS) b
            on (b.CNT_ID = a.CONTRATO_ID)
            when matched then update set a.GARANTIA = b.DD_GC1_ID';
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select distinct PROCEDIMIENTO_ID from TMP_CONCU_CONTRATO) b
    on (b.PROCEDIMIENTO_ID = a.ITER)
    when matched then update set a.GARANTIA_CONCURSO = 0;
    commit;

    merge into TMP_CONCU_DETALLE a
    using (select distinct PROCEDIMIENTO_ID from (select PROCEDIMIENTO_ID, count(distinct GARANTIA)
                                                    from TMP_CONCU_CONTRATO pc
                                                    where GARANTIA in (1,2,3,4,5,6,7)
                                                    group by PROCEDIMIENTO_ID
                                                    having count(distinct GARANTIA) >= 1)) b
    on (b.PROCEDIMIENTO_ID = a.ITER)
    when matched then update set a.GARANTIA_CONCURSO = 1;
    commit;

    update TMP_CONCU_DETALLE set GARANTIA_CONCURSO = -1 where GARANTIA_CONCURSO is null;
    commit;

    -- Borrar Indices H_CONCU
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CONCU_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de los días a insertar
    delete from H_CONCU where DIA_ID = fecha;
    commit;

    -- Insertamos en H_CONCU sólo el registro que tiene la última actuación
    insert into H_CONCU
    (DIA_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CRED,
     FECHA_AUTO_APERTURA_CONVENIO,
     FECHA_REGISTRAR_IAC,
     FECHA_INTERPOSICION_DEMANDA,
     FECHA_JUNTA_ACREEDORES,
     FECHA_REG_RESOL_APERTURA_LIQ,
     ESTADO_CONVENIO_ID,
     SEGUIMIENTO_CONVENIO_ID,
     GARANTIA_CONCURSO_ID,
     NUM_CONCURSOS,
     P_AUTO_FC_DIA_ANALISIS,
     P_AUTO_FC_LIQUIDACION,
     P_PUB_BOE_INSI_CRE,
     P_AUTO_FC_AUTO_APER_CONV,
     P_REG_IAC_INTERP_DEM,
     P_AUTO_APER_CONV_J_ACREE,
     P_AUTO_FC_REG_RESOL_APER_LIQ_D,
     P_AUTO_FC_REG_RESOL_APER_LIQ_C,
     CUANTIA_CONVENIO,
     QUITA_CONVENIO
    )
    select fecha,
     fecha,
     ITER,
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CRED,
     FECHA_AUTO_APERTURA_CONVENIO,
     FECHA_REGISTRAR_IAC,
     FECHA_INTERPOSICION_DEMANDA,
     FECHA_JUNTA_ACREEDORES,
     FECHA_REG_RESOL_APERTURA_LIQ,
     NVL(ESTADO_CONVENIO, -1),
     NVL(SEGUIMIENTO_CONVENIO, -1),
     GARANTIA_CONCURSO,
     1,
     (fecha - FECHA_AUTO_FASE_COMUN),
     (FECHA_LIQUIDACION - FECHA_AUTO_FASE_COMUN),
     (FECHA_INSINUACION_FINAL_CRED - FECHA_PUBLICACION_BOE),
     (FECHA_AUTO_APERTURA_CONVENIO - FECHA_AUTO_FASE_COMUN),
     (FECHA_INTERPOSICION_DEMANDA - FECHA_REGISTRAR_IAC),
     (FECHA_JUNTA_ACREEDORES - FECHA_AUTO_APERTURA_CONVENIO),
     (FECHA_REG_RESOL_APERTURA_LIQ - FECHA_AUTO_FASE_COMUN),
     (FECHA_REG_RESOL_APERTURA_LIQ - FECHA_AUTO_FASE_COMUN),
     CUANTIA_CONVENIO,
     QUITA_CONVENIO
    from TMP_CONCU_DETALLE;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_CONCU
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_IX'', ''H_CONCU (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- P_AUTO_FC_REG_RESOL_APER_LIQ_D -> Procedimiento que NO pasa por T. fase convenio (2644)
    execute immediate 'merge into H_CONCU a
          using (select distinct tpj.ITER from TMP_CONCU_JERARQUIA tpj
                             join '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc on tpj.FASE_ACTUAL = prc.PRC_ID
                             where  DIA_ID = :fecha
                             and  TRUNC(prc.FECHACREAR) <= :fecha
                             and prc.DD_TPO_ID = 2644 and prc.BORRADO=0) b
          on (b.ITER = a.PROCEDIMIENTO_ID)
          when matched then update set a.P_AUTO_FC_REG_RESOL_APER_LIQ_D = null where a.DIA_ID = :fecha' using fecha, fecha, fecha;
    commit;

    -- PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO -> Procedimiento que pasa por T. fase convenio (2644)
    execute immediate 'update H_CONCU set P_AUTO_FC_REG_RESOL_APER_LIQ_C = null 
    where DIA_ID = :fecha and PROCEDIMIENTO_ID not in (select  tpj.ITER from TMP_CONCU_JERARQUIA tpj 
                                   join recovery_bankia_datastage.PRC_PROCEDIMIENTOS prc on tpj.FASE_ACTUAL = prc.PRC_ID
                                   where  DIA_ID = :fecha and  TRUNC(prc.FECHACREAR) <= :fecha  and prc.DD_TPO_ID = 2644 and prc.BORRADO=0)' using fecha, fecha, fecha;
    
    commit;

  end loop;
  close c_fecha;


  update H_CONCU set T_PORCENTAJE_QUITA_ID = (case when QUITA_CONVENIO >= 0 and QUITA_CONVENIO <= 30 then 0
                                                   when QUITA_CONVENIO > 30 and QUITA_CONVENIO <= 50 then 1
                                                   when QUITA_CONVENIO > 50 and QUITA_CONVENIO <= 100 then 2
                                                   else -1 end);
  commit;
  update H_CONCU set TD_AUTO_FC_DIA_ANALISIS_ID = (case when P_AUTO_FC_DIA_ANALISIS <= 365 then 0
                                                        when P_AUTO_FC_DIA_ANALISIS > 365 then 1
                                                        else -1 end);
  commit;
  update H_CONCU set TD_AUTO_FC_LIQUIDACION_ID = (case when P_AUTO_FC_LIQUIDACION <= 365 then 0
                                                       when P_AUTO_FC_LIQUIDACION > 365 then 1
                                                       else -1 end);
   commit;
  -- Incluimos el último día cargado
  select max(DIA_ID) into max_dia_carga from H_CONCU;
  update H_CONCU set FECHA_CARGA_DATOS = max_dia_carga;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU. Termina Carga', 3;

-- ----------------------------------------------------------------------------------------------
--                                      H_CONCU_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_SEMANA. Empieza Carga', 3;

    -- Borrar Indices H_CONCU_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CONCU_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_FECHA (DIA_H)
    select distinct DIA_ID from H_CONCU where DIA_ID between date_start and date_end;
    commit;

    merge into TMP_FECHA dc
    using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
    on (cf.DIA_ID = dc.DIA_H)
    when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
    commit;

    for cc IN c_semana loop

      -- Borrado de los meses a insertar
      delete from H_CONCU_SEMANA where SEMANA_ID = cc.SEMANA_H;
      commit;

      select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = cc.SEMANA_H;

      insert into H_CONCU_SEMANA
      (SEMANA_ID,
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
      )
      select cc.SEMANA_H,
       max_dia_semana,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
      from H_CONCU
      where DIA_ID = max_dia_semana;
    commit;
    end loop;

    -- Crear indices H_CONCU_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_SEMANA_IX'', ''H_CONCU_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_SEMANA. Termina Carga', 3;

*/
-- ----------------------------------------------------------------------------------------------
--                                      H_CONCU_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_MES. Empieza Carga', 3;

    -- Borrar Indices H_CONCU_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CONCU_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_CONCU where DIA_ID between date_start and date_end;
    commit;

    merge into TMP_FECHA dc
    using (select MES_ID, TRIMESTRE_ID, ANIO_ID, DIA_ID from D_F_DIA) cf
    on (cf.DIA_ID = dc.DIA_H)
    when matched then update set dc.MES_H = cf.MES_ID, dc.TRIMESTRE_H = cf.TRIMESTRE_ID, dc.ANIO_H = cf.ANIO_ID;
    commit;

    for a IN c_mes loop

      -- Borrado de los meses a insertar
      delete from H_CONCU_MES where MES_ID = a.MES_H;
      commit;

      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = a.MES_H;

      insert into H_CONCU_MES
      (MES_ID,
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
      )
      select a.MES_H,
       max_dia_mes,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
      from H_CONCU
      where DIA_ID = max_dia_mes;
    commit;
  end loop;

    -- Crear indices H_CONCU_MES_IX
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_MES_IX'', ''H_CONCU_MES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_MES. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_CONCU_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_TRIMESTRE. Empieza Carga', 3;

    -- Borrar Indices H_CONCU_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CONCU_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Bucle que recorre los trimestres
    for b in c_trimestre loop

      -- Borrado de los meses a insertar
      delete from H_CONCU_TRIMESTRE where TRIMESTRE_ID = b.TRIMESTRE_H;
      commit;

      select max(DIA_H) into max_dia_trimestre from TMP_FECHA  where TRIMESTRE_H = b.TRIMESTRE_H;

      insert into H_CONCU_TRIMESTRE
      (TRIMESTRE_ID,
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
      )
      select b.TRIMESTRE_H,
       max_dia_trimestre,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
      from H_CONCU
      where DIA_ID = max_dia_trimestre;
      commit;
    end loop;

    -- Crear indices H_CONCU_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_TRIMESTRE_IX'', ''H_CONCU_TRIMESTRE (TRIMESTRE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_TRIMESTRE. Termina Carga', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_CONCU_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_ANIO. Empieza Carga', 3;

  -- Borrar Indices H_CONCU_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CONCU_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle que recorre los años
  for c IN c_anio loop

    delete from H_CONCU_ANIO where ANIO_ID = c.ANIO_H;
    commit;
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = c.ANIO_H;

    insert into H_CONCU_ANIO
      (ANIO_ID,
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
      )
      select c.ANIO_H,
       max_dia_anio,
       PROCEDIMIENTO_ID,
       FECHA_AUTO_FASE_COMUN,
       FECHA_LIQUIDACION,
       FECHA_PUBLICACION_BOE,
       FECHA_INSINUACION_FINAL_CRED,
       FECHA_AUTO_APERTURA_CONVENIO,
       FECHA_REGISTRAR_IAC,
       FECHA_INTERPOSICION_DEMANDA,
       FECHA_JUNTA_ACREEDORES,
       FECHA_REG_RESOL_APERTURA_LIQ,
       ESTADO_CONVENIO_ID,
       SEGUIMIENTO_CONVENIO_ID,
       GARANTIA_CONCURSO_ID,
       T_PORCENTAJE_QUITA_ID,
       TD_AUTO_FC_DIA_ANALISIS_ID,
       TD_AUTO_FC_LIQUIDACION_ID,
       NUM_CONCURSOS,
       P_AUTO_FC_DIA_ANALISIS,
       P_AUTO_FC_LIQUIDACION,
       P_PUB_BOE_INSI_CRE,
       P_AUTO_FC_AUTO_APER_CONV,
       P_REG_IAC_INTERP_DEM,
       P_AUTO_APER_CONV_J_ACREE,
       P_AUTO_FC_REG_RESOL_APER_LIQ_D,
       P_AUTO_FC_REG_RESOL_APER_LIQ_C,
       CUANTIA_CONVENIO,
       QUITA_CONVENIO
    from H_CONCU
    where DIA_ID = max_dia_anio;
    commit;
  end loop;

  -- Crear indices H_CONCU_ANIO_IX
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CONCU_ANIO_IX'', ''H_CONCU_ANIO (ANIO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CONCU_ANIO. Termina Carga', 3;
*/

-- =========================================================================================================================================
--                  					                        				        DECLARATIVO
-- =========================================================================================================================================
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL. Empieza Carga', 3;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DECL_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate '
  insert into TMP_DECL_JERARQUIA
  select a.* from TMP_PRC_ESPECIFICO_JERARQUIA a,
            (select distinct DD_TPO_ID
             from '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO tp
             join '||V_DATASTAGE||'.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
             where DD_TPO_DESCRIPCION = ''P. verbal'' or DD_TPO_DESCRIPCION = ''P. ordinario'') b
  where a.TIPO_PROCEDIMIENTO_DET = b.DD_TPO_ID';
  commit;

  for d in c_fecha loop

    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir

    -- Borrar Indices TMP_DECL_DETALLE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_DECL_DETALLE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DECL_DETALLE'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_DECL_DETALLE(ITER)
    select distinct ITER from  TMP_DECL_JERARQUIA where DIA_ID = d.DIA_ID;
    commit;

    -- Crear indices TMP_DECL_DETALLE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DECL_DETALLE_IX'', ''TMP_DECL_DETALLE (ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- FECHA_INTERP_DEM_DECLARATIVO
    -- TAP_ID: 301	P03_InterposicionDemanda (P. ordinario) / TAP_ID: 256	P04_InterposicionDemanda (P. verbal)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DECL_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;


    execute immediate '
    insert into TMP_DECL_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_DECL_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||d.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (301, 256)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE in (''fechainterposicion'', ''fecha'')
    where  DIA_ID = '''||d.DIA_ID||'''
    ';
    commit;

    merge into TMP_DECL_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_DECL_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_INTERP_DEM_DECLARATIVO = b.FECHA_FOR;
    commit;


    -- FECHA_RESOLUCION_FIRME
    -- TAP_ID: 308	P03_ResolucionFirme (P. ordinario) / TAP_ID: 262	P04_ResolucionFirme (P. verbal)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DECL_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_DECL_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_DECL_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||d.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (262, 308)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
    where  DIA_ID = '''||d.DIA_ID||'''
    ';
    commit;

    merge into TMP_DECL_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_DECL_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_RESOLUCION_FIRME = b.FECHA_FOR;
    commit;

    -- Borrar Indices H_DECL
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_DECL_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado de los días a insertar
    delete from H_DECL where DIA_ID = d.DIA_ID;
    commit;
    -- Insertamos en H_DECL sólo el registro que tiene la última actuación
    insert into H_DECL
    (DIA_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     FECHA_INTERP_DEM_DECLARATIVO,
     FECHA_RESOLUCION_FIRME,
     NUM_DECLARATIVOS,
     P_ID_DECL_RESOL_FIRME
    )
    select d.DIA_ID,
     d.DIA_ID,
     ITER,
     FECHA_INTERP_DEM_DECLARATIVO,
     FECHA_RESOLUCION_FIRME,
     1,
     (FECHA_RESOLUCION_FIRME - FECHA_INTERP_DEM_DECLARATIVO)
    from TMP_DECL_DETALLE;
    commit;

    -- Crear indices H_DECL
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_IX'', ''H_DECL (DIA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  end loop;

  update H_DECL set TD_ID_DECL_RESOL_FIRME_ID = (case when P_ID_DECL_RESOL_FIRME > 0 and P_ID_DECL_RESOL_FIRME <= 30 then 0
                                                             when P_ID_DECL_RESOL_FIRME > 30 and P_ID_DECL_RESOL_FIRME <= 60 then 1
                                                             when P_ID_DECL_RESOL_FIRME > 60 and P_ID_DECL_RESOL_FIRME <= 90 then 2
                                                             when P_ID_DECL_RESOL_FIRME > 90 and P_ID_DECL_RESOL_FIRME <= 120 then 3
                                                             when P_ID_DECL_RESOL_FIRME > 120 and P_ID_DECL_RESOL_FIRME <= 150 then 4
                                                             when P_ID_DECL_RESOL_FIRME > 150 then 5
                                                             else -1
                                                    end);

  -- Incluimos el último día cargado
  select max(DIA_ID) into max_dia_carga from H_DECL;

  update H_DECL set FECHA_CARGA_DATOS = max_dia_carga;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_DECL_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_SEMANA. Empieza Carga', 3;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_DECL where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;

  -- Borrar Indices H_DECL_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_DECL_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- Bucle que recorre las semanas
  for ee in c_semana loop
      delete from H_DECL_SEMANA where SEMANA_ID = ee.SEMANA_H;
      commit;

      select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = ee.SEMANA_H;

      insert into H_DECL_SEMANA
      (SEMANA_ID,
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       FECHA_INTERP_DEM_DECLARATIVO,
       FECHA_RESOLUCION_FIRME,
       TD_ID_DECL_RESOL_FIRME_ID,
       NUM_DECLARATIVOS,
       P_ID_DECL_RESOL_FIRME
      )
      select ee.SEMANA_H,
       max_dia_semana,
       PROCEDIMIENTO_ID,
       FECHA_INTERP_DEM_DECLARATIVO,
       FECHA_RESOLUCION_FIRME,
       TD_ID_DECL_RESOL_FIRME_ID,
       NUM_DECLARATIVOS,
       P_ID_DECL_RESOL_FIRME
      from H_DECL
      where DIA_ID = max_dia_semana;
      commit;
  end loop;

  -- Crear indices H_DECL_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_SEMANA_IX'', ''H_DECL_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_SEMANA. Termina Carga', 3;

*/
-- ----------------------------------------------------------------------------------------------
--                                      H_DECL_MES
-- ----------------------------------------------------------------------------------------------

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_MES. Empieza Carga', 3;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_DECL where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select MES_ID, TRIMESTRE_ID, ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.MES_H = cf.MES_ID, dc.TRIMESTRE_H = cf.TRIMESTRE_ID, dc.ANIO_H = cf.ANIO_ID;
  commit;

  -- Borrar Indices H_DECL_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_DECL_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle que recorre los meses
  for e in c_mes loop

      delete from H_DECL_MES where MES_ID = e.MES_H;
      commit;

      select max(DIA_H) into max_dia_mes from TMP_FECHA  where MES_H = e.MES_H;

      insert into H_DECL_MES
      (MES_ID,
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       FECHA_INTERP_DEM_DECLARATIVO,
       FECHA_RESOLUCION_FIRME,
       TD_ID_DECL_RESOL_FIRME_ID,
       NUM_DECLARATIVOS,
       P_ID_DECL_RESOL_FIRME
      )
      select e.MES_H,
       max_dia_mes,
       PROCEDIMIENTO_ID,
       FECHA_INTERP_DEM_DECLARATIVO,
       FECHA_RESOLUCION_FIRME,
       TD_ID_DECL_RESOL_FIRME_ID,
       NUM_DECLARATIVOS,
       P_ID_DECL_RESOL_FIRME
      from H_DECL
      where DIA_ID = max_dia_mes;
      commit;
  end loop;

  -- Crear indices H_DECL_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_MES_IX'', ''H_DECL_MES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_MES. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_DECL_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_TRIMESTRE. Empieza Carga', 3;

  -- Borrar Indices H_DECL_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_DECL_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  for f in c_trimestre loop
      -- Borrado de los meses a insertar
      delete from H_DECL_TRIMESTRE where TRIMESTRE_ID = f.TRIMESTRE_H;
      commit;

      select max(DIA_H) into max_dia_trimestre from TMP_FECHA  where TRIMESTRE_H = f.TRIMESTRE_H;

      insert into H_DECL_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_DECLARATIVO,
         FECHA_RESOLUCION_FIRME,
         TD_ID_DECL_RESOL_FIRME_ID,
         NUM_DECLARATIVOS,
         P_ID_DECL_RESOL_FIRME
        )
        select f.trimestre_H,
         max_dia_trimestre,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_DECLARATIVO,
         FECHA_RESOLUCION_FIRME,
         TD_ID_DECL_RESOL_FIRME_ID,
         NUM_DECLARATIVOS,
         P_ID_DECL_RESOL_FIRME
      from H_DECL
      where DIA_ID = max_dia_trimestre;
      commit;
  end loop;

  -- Crear indices H_DECL_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_TRIMESTRE_IX'', ''H_DECL_TRIMESTRE (TRIMESTRE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_TRIMESTRE. Termina Carga', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_DECL_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_ANIO. Empieza Carga', 3;

  -- Borrar Indices H_DECL_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_DECL_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle que recorre los años
  for g in c_anio loop

      -- Borrado de los meses a insertar
      delete from H_DECL_ANIO where ANIO_ID = g.ANIO_H;
      commit;

      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = g.ANIO_H;

      insert into H_DECL_ANIO
        (ANIO_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_DECLARATIVO,
         FECHA_RESOLUCION_FIRME,
         TD_ID_DECL_RESOL_FIRME_ID,
         NUM_DECLARATIVOS,
         P_ID_DECL_RESOL_FIRME
        )
        select g.ANIO_H,
         max_dia_anio,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_DECLARATIVO,
         FECHA_RESOLUCION_FIRME,
         TD_ID_DECL_RESOL_FIRME_ID,
         NUM_DECLARATIVOS,
         P_ID_DECL_RESOL_FIRME
      from H_DECL
      where DIA_ID = max_dia_anio;
      commit;
  end loop;

  -- Crear indices H_DECL_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_DECL_ANIO_IX'', ''H_DECL_ANIO (ANIO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_DECL_ANIO. Termina Carga', 3;
*/

-- =========================================================================================================================================
--                  					                        				        EJECUCION_ORDINARIA
-- =========================================================================================================================================
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD. Empieza Carga', 3;

-- Borrar Indices TMP_EJEC_ORD_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EJEC_ORD_JRQ_ITER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EJEC_ORD_JRQ_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_ORD_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate '
  insert into TMP_EJEC_ORD_JERARQUIA
  select a.* from TMP_PRC_ESPECIFICO_JERARQUIA a,
                  (select distinct DD_TPO_ID
                   from '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO tp
                   join '||V_DATASTAGE||'.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                   where DD_TPO_DESCRIPCION = ''P. Ej. de título no judicial'' or  DD_TPO_DESCRIPCION = ''P. Ej. de Título Judicial'') b
  where a.TIPO_PROCEDIMIENTO_DET = b.DD_TPO_ID ';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EJEC_ORD_JERARQUIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

  -- Crear indices TMP_EJEC_ORD_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_ORD_JRQ_ITER_IX'', ''TMP_EJEC_ORD_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_ORD_JRQ_FASE_ACT_IX'', ''TMP_EJEC_ORD_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- Borrar Indices H_EJEC_ORD
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_ORD_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle para las taras e inclusión en H_EJEC_ORD
  for h in c_fecha loop

    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_ORD_DETALLE'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    insert into TMP_EJEC_ORD_DETALLE(ITER)
    select distinct ITER  from TMP_EJEC_ORD_JERARQUIA where DIA_ID = h.DIA_ID;
    commit;

    -- FECHA_INTERP_DEM_EJEC_ORD
    -- TAP_ID:229	P16_InterposicionDemanda (P. Ej. de Título Judicial) / TAP_ID: 270	P15_InterposicionDemandaMasBienes (P. Ej. de título no judicial)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_ORD_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_EJEC_ORD_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_EJEC_ORD_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||h.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (270)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE in(''fechaInterposicion'')
    where  DIA_ID = '''||h.DIA_ID||'''
     ';
    commit;

    merge into TMP_EJEC_ORD_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_EJEC_ORD_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_INTERP_DEM_EJEC_ORD = b.FECHA_FOR;
    commit;

    -- FECHA_INICIO_APREMIO
    -- Fecha de inicio de la fase T. certificación de cargas y revisión (DD_TPO_ID=26)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_ORD_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_EJEC_ORD_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_EJEC_ORD_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||h.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (294)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE in(''fecha'')
    where  DIA_ID = '''||h.DIA_ID||'''
     ';
    commit;

    merge into TMP_EJEC_ORD_DETALLE a
    using (select ITER,  max(TRUNC(FECHA_FORMULARIO)) as FECHA_FOR from TMP_EJEC_ORD_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_INICIO_APREMIO = b.FECHA_FOR;
    commit;

    -- Borrado de los días a insertar
    delete from H_EJEC_ORD where DIA_ID = h.DIA_ID;
    commit;

        -- Insertamos en H_EJEC_ORD sólo el registro que tiene la última actuación
    insert into H_EJEC_ORD
      (DIA_ID,
       FECHA_CARGA_DATOS,
       PROCEDIMIENTO_ID,
       FECHA_INTERP_DEM_EJEC_ORD,
       FECHA_INICIO_APREMIO,
       NUM_EJECUCION_ORDINARIAS,
       P_ID_ORD_INI_APREMIO
      )
      select h.DIA_ID,
       h.DIA_ID,
       ITER,
       FECHA_INTERP_DEM_EJEC_ORD,
       FECHA_INICIO_APREMIO,
       1,
       FECHA_INICIO_APREMIO - FECHA_INTERP_DEM_EJEC_ORD
    from TMP_EJEC_ORD_DETALLE;
    commit;
  end loop;


  -- Crear indices H_EJEC_ORD
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_IX'', ''H_EJEC_ORD (DIA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  update H_EJEC_ORD set TD_ID_ORD_INI_APREMIO_ID = (case when P_ID_ORD_INI_APREMIO > 0 and P_ID_ORD_INI_APREMIO <= 30 then 0
                                                                when P_ID_ORD_INI_APREMIO > 30 and P_ID_ORD_INI_APREMIO <= 60 then 1
                                                                when P_ID_ORD_INI_APREMIO > 60 and P_ID_ORD_INI_APREMIO <= 90 then 2
                                                                when P_ID_ORD_INI_APREMIO > 90 and P_ID_ORD_INI_APREMIO <= 120 then 3
                                                                when P_ID_ORD_INI_APREMIO > 120 and P_ID_ORD_INI_APREMIO <= 150 then 4
                                                                when P_ID_ORD_INI_APREMIO > 150 then 5
                                                                else -1
                                                              end);
   commit;

   -- Incluimos el último día cargado
   select max(DIA_ID) into max_dia_carga from H_EJEC_ORD;
   update H_EJEC_ORD set FECHA_CARGA_DATOS = max_dia_carga;
   commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_ORD_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_SEMANA. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_ORD_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_ORD_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_EJEC_ORD where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;

-- Bucle que recorre las semanas
  for ii in c_semana loop

      -- Borrado de los meses a insertar
      delete from H_EJEC_ORD_SEMANA where SEMANA_ID = ii.SEMANA_H;
      commit;

      select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = ii.SEMANA_H;

      insert into H_EJEC_ORD_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
        )
        select ii.SEMANA_H,
         max_dia_semana,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
      from H_EJEC_ORD
      where DIA_ID = max_dia_semana;
    commit;
  end loop;

  -- Crear indices H_EJEC_ORD_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_SEMANA_IX'', ''H_EJEC_ORD_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_SEMANA. Termina Carga', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_ORD_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_MES. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_ORD_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_ORD_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_EJEC_ORD where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select MES_ID, TRIMESTRE_ID, ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.MES_H = cf.MES_ID, dc.TRIMESTRE_H = cf.TRIMESTRE_ID, dc.ANIO_H = cf.ANIO_ID;
  commit;

-- Bucle que recorre los meses
  for i IN c_mes loop
      -- Borrado de los meses a insertar
      delete from H_EJEC_ORD_MES where MES_ID = i.MES_H;
      commit;

      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = i.MES_H;

      insert into H_EJEC_ORD_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
        )
        select i.MES_H,
         max_dia_mes,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
      from H_EJEC_ORD
      where DIA_ID = max_dia_mes;
    commit;

  end loop;

  -- Crear indices H_EJEC_ORD_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_MES_IX'', ''H_EJEC_ORD_MES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_MES. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_ORD_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_TRIMESTRE. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_ORD_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_ORD_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- Bucle que recorre los trimestres
  for j in c_trimestre loop

      delete from H_EJEC_ORD_TRIMESTRE where TRIMESTRE_ID = j.trimestre_H;
      commit;

      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = j.trimestre_H;

      insert into H_EJEC_ORD_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
        )
        select j.trimestre_H,
         max_dia_trimestre,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
      from H_EJEC_ORD
      where DIA_ID = max_dia_trimestre;
      commit;

  end loop;

  -- Crear indices H_EJEC_ORD_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_TRIMESTRE_IX'', ''H_EJEC_ORD_TRIMESTRE (TRIMESTRE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_TRIMESTRE. Termina Carga', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_ORD_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_ANIO. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_ORD_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_ORD_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle que recorre los años
  for k IN c_anio loop

      -- Borrado de los meses a insertar
      delete from H_EJEC_ORD_ANIO where ANIO_ID = k.anio_H;
      commit;

      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = k.anio_H;

      insert into H_EJEC_ORD_ANIO
        (ANIO_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
        )
        select k.anio_H,
         max_dia_anio,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_EJEC_ORD,
         FECHA_INICIO_APREMIO,
         TD_ID_ORD_INI_APREMIO_ID,
         NUM_EJECUCION_ORDINARIAS,
         P_ID_ORD_INI_APREMIO
      from H_EJEC_ORD
      where DIA_ID = max_dia_anio;
      commit;
  end loop;

  -- Crear indices H_EJEC_ORD_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_ORD_ANIO_IX'', ''H_EJEC_ORD_ANIO (ANIO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_ORD_ANIO. Termina Carga', 3;
*/

-- =========================================================================================================================================
--                  					                        				        HIPOTECARIO
-- =========================================================================================================================================
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO. Empieza Carga', 3;

  -- Borrar Indices H_HIPO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_HIPO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
-- Borrar Indices TMP_HIPO_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_HIPO_JRQ_ITER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_HIPO_JRQ_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate '
  insert into TMP_HIPO_JERARQUIA
  select a.* from TMP_PRC_ESPECIFICO_JERARQUIA a,
    (select distinct DD_TPO_ID
       from '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO tp
       join '||V_DATASTAGE||'.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
       where DD_TPO_DESCRIPCION = ''P. hipotecario'' or DD_TPO_DESCRIPCION = ''T. de Subasta'' or DD_TPO_DESCRIPCION = ''T. de adjudicación'' or DD_TPO_DESCRIPCION = ''T. de cesión de remate'' ) b
  where a.TIPO_PROCEDIMIENTO_DET = b.DD_TPO_ID ';

  V_ROWCOUNT := sql%rowcount;
  commit;

       --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_HIPO_JERARQUIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

  -- Crear indices TMP_HIPO_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_HIPO_JRQ_ITER_IX'', ''TMP_HIPO_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_HIPO_JRQ_FASE_ACT_IX'', ''TMP_HIPO_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- Bucle para las taras e inclusión en H_HIPO
  for l in c_fecha loop
    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_DETALLE'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    insert into TMP_HIPO_DETALLE(ITER, ASUNTO)
    select distinct ITER, ASUNTO from TMP_HIPO_JERARQUIA where DIA_ID = l.DIA_ID;
    commit;

    -- FECHA_CREACION_ASUNTO
    execute immediate 'merge into TMP_HIPO_DETALLE a
          using (select ASU_ID, TRUNC(FECHACREAR) as FECHACREAR from '||V_DATASTAGE||'.ASU_ASUNTOS) b
          on (b.ASU_ID = a.ASUNTO)
          when matched then update set a.FECHA_CREACION_ASUNTO = b.FECHACREAR';
    commit;

    -- FECHA_INTERP_DEM_HIP
    -- TAP_ID: 240	P01_DemandaCertificacionCargas (P. hipotecario)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    execute immediate '
    insert into TMP_HIPO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_HIPO_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||l.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (240)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE in (''fechaSolicitud'')
    where  DIA_ID = '''||l.DIA_ID||'''
    and tpj.FASE_FINALIZADA is null
    and tpj.FASE_PARALIZADA is null
    and tpj.FASE_CON_RECURSO is null';
    commit;

    merge into TMP_HIPO_DETALLE a
    using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_HIPO_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_INTERP_DEM_HIP = b.FECHA_FORMULARIO;
    commit;

    -- FECHA_CESION_REMATE
    -- TAP_ID: 10000000002429 fecha
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_HIPO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_HIPO_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||l.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id = 10000000002429
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
    where  DIA_ID = '''||l.DIA_ID||'''
    and tpj.FASE_FINALIZADA is null
    and tpj.FASE_PARALIZADA is null
    and tpj.FASE_CON_RECURSO is null';
    commit;

    merge into TMP_HIPO_DETALLE a
    using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_HIPO_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_CESION_REMATE = b.FECHA_FORMULARIO;
    commit;

    -- FECHA_SUBASTA_SOLICITADA
    -- TAP_ID: 208	29	P11_SolicitudSubasta
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_HIPO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_HIPO_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||l.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID  and tex.tap_id in (10000000002829, 10000000002631)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fechaSolicitud''
    where  DIA_ID = '''||l.DIA_ID||'''
    and tpj.FASE_FINALIZADA is null
    and tpj.FASE_PARALIZADA is null
    and tpj.FASE_CON_RECURSO is null';
    commit;

    merge into TMP_HIPO_DETALLE a
    using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_HIPO_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_SUBASTA_SOLICITADA = b.FECHA_FORMULARIO;
    commit;

    -- FECHA_SUBASTA (SEÑALAMIENTO)
    -- TAP_ID: 10000000002830 y 10000000002632	T. Subasta Bankia + T. Subasta Sareb
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    execute immediate '
    insert into TMP_HIPO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_HIPO_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002830,10000000002632)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fechaSenyalamiento''
    where  DIA_ID = '''||l.DIA_ID||'''
    and tpj.FASE_FINALIZADA is null
    and tpj.FASE_PARALIZADA is null
    and tpj.FASE_CON_RECURSO is null';
    commit;

    merge into TMP_HIPO_DETALLE a
    using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_HIPO_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_SUBASTA = b.FECHA_FORMULARIO;
    commit;

    -- FECHA CELEBRACION SUBASTA (COMBOCELEBRADA) Y SEÑALAMIENTO DE SUBASTA 10000000002632,10000000002830 fechaSenyalamiento, 10000000002837, 10000000002639 comboCelebrada ='SI'
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_HIPO_TAREA (ITER)
    select  distinct tpj.ITER
    from TMP_HIPO_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002837,10000000002639)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''comboCelebrada'' and tev.TEV_VALOR = ''01''
    where  DIA_ID = '''||l.DIA_ID||'''
    and tpj.FASE_FINALIZADA is null
    and tpj.FASE_PARALIZADA is null
    and tpj.FASE_CON_RECURSO is null';
    commit;
	
    merge into TMP_HIPO_DETALLE a
    using (select distinct ITER from TMP_HIPO_TAREA) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_CELEBRACION_SUBASTA = a.FECHA_SUBASTA;
    commit;
	
    -- FECHA_ADJUDICACION
    -- TAP_ID: 255 P05_RegistrarAutoAdjudicacion
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_HIPO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
    from TMP_HIPO_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||l.DIA_ID||'''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (255)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fechaRegistro''
    where  DIA_ID = '''||l.DIA_ID||'''
    and tpj.FASE_FINALIZADA is null
    and tpj.FASE_PARALIZADA is null
    and tpj.FASE_CON_RECURSO is null';
    commit;

    merge into TMP_HIPO_DETALLE a
    using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_HIPO_TAREA group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_ADJUDICACION = b.FECHA_FORMULARIO;
    commit;

    -- FASE SUBASTA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_HIPO_TAREA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate '
    insert into TMP_HIPO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID)
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID
    from TMP_HIPO_JERARQUIA tpj
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and (tar.TAR_FECHA_FIN is not null or (tar.TAR_FECHA_FIN is null and tar.borrado = 0))
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (240, 10000000001200,
                           241, 242, 243, 244, 245, 246,
                           10000000002631, 10000000002829,
                           10000000002632,  10000000002830, 10000000002633, 10000000002831, 10000000002634, 10000000002832, 10000000002635, 10000000002833, 10000000002636, 10000000002834, 10000000002639, 10000000002837, 10000000002648, 10000000002649,
                           10000000002638, 10000000002635,
                           10000000002641, 10000000002839,10000000002646,10000000002844,10000000002645,10000000002634,10000000002429,10000000002432,
                           10000000002431,
                           10000000002643, 10000000002841,10000000002644,10000000002842,10000000002840,10000000003029,10000000002740, 10000000002742, 10000000002743,
                           10000000002741, 10000000002735, 10000000002736, 10000000002738, 10000000002739, 10000000002737,
                           10000000002557, 10000000002556, 10000000002554,
                           10000000002555, 10000000002553, 10000000002552)
    where  DIA_ID = '''||l.DIA_ID||'''
    ';
    commit;

    -- Calculamos la fase con el TAP_ID de la última tarea de cada procedimiento
    merge into TMP_HIPO_DETALLE a
    using (select ITER, max(FECHA_INI) as FECHA_INI from TMP_HIPO_TAREA where FECHA_INI is not null and TRUNC(FECHA_INI) <= l.DIA_ID group by ITER) b
    on (b.ITER = a.ITER)
    when matched then update set a.FECHA_ULT_TAR_CREADA = b.FECHA_INI;
    commit;

    merge into TMP_HIPO_DETALLE a
    using (select ITER, FECHA_INI, max(TAREA) as TAREA from TMP_HIPO_TAREA group by ITER, FECHA_INI) b
    on (b.ITER = a.ITER and b.FECHA_INI = a.FECHA_ULT_TAR_CREADA)
    when matched then update set a.ULT_TAR_CREADA = b.TAREA;
    commit;

    merge into TMP_HIPO_DETALLE a
    using (select ITER, TAREA, TAP_ID from TMP_HIPO_TAREA) b
    on (b.ITER = a.ITER and b.TAREA = a.ULT_TAR_CREADA)
    when matched then update set a.TAP_ID_ULT_TAR_CREADA = b.TAP_ID;
    commit;


    -- 1. Pendiente Interposición : 240, 10000000001200 ;
    -- 2. Demanda Presentada: 241, 242, 243, 244, 245, 246;
    -- 3. subasta Solicitada: 10000000002631, 10000000002829;
    -- 4. Subasta Señalada: 10000000002632,  10000000002830, 10000000002633, 10000000002831, 10000000002634, 10000000002832, 10000000002635, 10000000002833, 10000000002636, 10000000002834, 10000000002639, 10000000002837, 10000000002648, 10000000002649 ;
    -- 5. Subasta Suspendida: 10000000002638, 10000000002635;
    -- 6. Subasta Celebrada: Pte Cesión Remate: 10000000002641, 10000000002839,10000000002646,10000000002844,10000000002645,10000000002634,10000000002429,10000000002432 ;
    -- 7. Subasta Celebrada: con Cesión Remate: 10000000002431 ;
    -- 8. Subasta Celebrada: Pte Adjudicacion: 10000000002643, 10000000002841,10000000002644,10000000002842,10000000002840,10000000003029,10000000002740, 10000000002742, 10000000002743;
    -- 9. Adjudicación: 10000000002741, 10000000002735, 10000000002736, 10000000002738, 10000000002739, 10000000002737;
    -- 10. Pendiente Posesión: 10000000002557, 10000000002556, 10000000002554;
    -- 11. Posesión: 10000000002555, 10000000002553, 10000000002552
    update TMP_HIPO_DETALLE set FASE_SUBASTA = (case when TAP_ID_ULT_TAR_CREADA in (240, 10000000001200) then 1
                                                            when TAP_ID_ULT_TAR_CREADA in (241, 242, 243, 244, 245, 246) then 2
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002631, 10000000002829) then 3
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002632,  10000000002830, 10000000002633, 10000000002831, 10000000002634, 10000000002832, 10000000002635, 10000000002833, 10000000002636, 10000000002834, 10000000002639, 10000000002837, 10000000002648, 10000000002649) then 4
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002638, 10000000002635) then 5
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002641, 10000000002839,10000000002646,10000000002844,10000000002645,10000000002634,10000000002429,10000000002432) then 6
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002431) then 7
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002643, 10000000002841,10000000002644,10000000002842,10000000002840,10000000003029,10000000002740, 10000000002742, 10000000002743) then 8
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002741, 10000000002735, 10000000002736, 10000000002738, 10000000002739, 10000000002737) then 9
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002557, 10000000002556, 10000000002554) then 10
                                                            when TAP_ID_ULT_TAR_CREADA in (10000000002555, 10000000002553, 10000000002552) then 11
                                                            else 12
                                                      end);
    commit;
    -- Borrado de los días a insertar
    delete from H_HIPO where DIA_ID = l.DIA_ID;
    commit;

    -- Insertamos en H_HIPO sólo el registro que tiene la última actuación
    insert into H_HIPO
    (DIA_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     FECHA_CREACION_ASUNTO,
     FECHA_INTERP_DEM_HIP,
     FECHA_SUBASTA_SOLICITADA,
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FECHA_CELEBRACION_SUBASTA,
     FASE_SUBASTA_HIPOTECARIO_ID,
     ULT_TAR_FASE_HIP_ID,
     NUM_HIPOTECARIOS,
     P_CREACION_ASU_SUBASTA,
     P_CREACION_ASU_CESION_REMATE,
     P_CREACION_ASU_ADJUDICACION,
     P_ID_HIP_SUBASTA,
     P_INTERP_DEM_HIP_CESION_REMATE,
     P_INTERP_DEM_HIP_ADJUDICACION,
     P_SUBASTA_ADJUDICACION,
     P_SUB_SOL_SUB_CEL,
     P_SUB_CEL_CESION_REMATE
    )
    select l.DIA_ID,
     l.DIA_ID,
     ITER,
     FECHA_CREACION_ASUNTO,
     FECHA_INTERP_DEM_HIP,
     FECHA_SUBASTA_SOLICITADA,
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FECHA_CELEBRACION_SUBASTA,
     FASE_SUBASTA,
     NVL(TAP_ID_ULT_TAR_CREADA, -2),
     1,
     (FECHA_SUBASTA - FECHA_CREACION_ASUNTO),
     (FECHA_CESION_REMATE - FECHA_CREACION_ASUNTO),
     (FECHA_ADJUDICACION - FECHA_CREACION_ASUNTO),
     (FECHA_SUBASTA_SOLICITADA - FECHA_INTERP_DEM_HIP),
     (FECHA_CESION_REMATE - FECHA_INTERP_DEM_HIP),
     (FECHA_ADJUDICACION - FECHA_INTERP_DEM_HIP),
     (FECHA_ADJUDICACION - FECHA_SUBASTA),
     (FECHA_CELEBRACION_SUBASTA - FECHA_SUBASTA_SOLICITADA),
     (FECHA_CESION_REMATE - FECHA_CELEBRACION_SUBASTA)
    from TMP_HIPO_DETALLE;
    commit;
  end loop;

  -- Crear indices H_HIPO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_IX'', ''H_HIPO (DIA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  update H_HIPO set TD_ID_HIP_SUBASTA_ID = (case when P_ID_HIP_SUBASTA >= 0 and P_ID_HIP_SUBASTA <= 30 then 0
                                                        when P_ID_HIP_SUBASTA > 30 and P_ID_HIP_SUBASTA <= 60 then 1
                                                        when P_ID_HIP_SUBASTA > 60 and P_ID_HIP_SUBASTA <= 90 then 2
                                                        when P_ID_HIP_SUBASTA > 90 and P_ID_HIP_SUBASTA <= 120 then 3
                                                        when P_ID_HIP_SUBASTA > 120 and P_ID_HIP_SUBASTA <= 150 then 4
                                                        when P_ID_HIP_SUBASTA > 150 then 5
                                                        else -1
                                                    end);
  commit;
  update H_HIPO set TD_SUB_SOL_SUB_CEL_ID = (case when P_SUB_SOL_SUB_CEL >= 0 and P_SUB_SOL_SUB_CEL <= 30 then 0
                                                         when P_SUB_SOL_SUB_CEL > 30 and P_SUB_SOL_SUB_CEL <= 60 then 1
                                                         when P_SUB_SOL_SUB_CEL > 60 and P_SUB_SOL_SUB_CEL <= 90 then 2
                                                         when P_SUB_SOL_SUB_CEL > 90 then 3
                                                         else -1
                                                        end);
  commit;
  update H_HIPO set TD_SUB_CEL_CESION_REMATE_ID = (case when P_SUB_CEL_CESION_REMATE >= 0 and P_SUB_CEL_CESION_REMATE <= 30 then 0
                                                               when P_SUB_CEL_CESION_REMATE > 30 and P_SUB_CEL_CESION_REMATE <= 60 then 1
                                                               when P_SUB_CEL_CESION_REMATE > 60 and P_SUB_CEL_CESION_REMATE <= 90 then 2
                                                               when P_SUB_CEL_CESION_REMATE > 90 then 3
                                                               else -1
                                                            end);
  commit;

   -- Incluimos el último día cargado
  select max(DIA_ID) into max_dia_carga from H_HIPO;

  update H_HIPO set FECHA_CARGA_DATOS = max_dia_carga;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_HIPO_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_SEMANA. Empieza Carga', 3;

  -- Borrar Indices H_HIPO_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_HIPO_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_HIPO where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;

  for mm in c_semana loop

     -- Borrado de los meses a insertar
      delete from H_HIPO_SEMANA where SEMANA_ID = mm.SEMANA_H;
      commit;

      select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = mm.SEMANA_H;

      insert into H_HIPO_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
        )
      select mm.SEMANA_H,
         max_dia_semana,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
      from H_HIPO
      where DIA_ID = max_dia_semana;
    commit;
  end loop;

  -- Crear indices H_HIPO_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_SEMANA_IX'', ''H_HIPO_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_SEMANA. Termina Carga', 3;
*/


-- ----------------------------------------------------------------------------------------------
--                                      H_HIPO_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_MES. Empieza Carga', 3;

  -- Borrar Indices H_HIPO_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_HIPO_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_HIPO where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select MES_ID, TRIMESTRE_ID, ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.MES_H = cf.MES_ID, dc.TRIMESTRE_H = cf.TRIMESTRE_ID, dc.ANIO_H = cf.ANIO_ID;
  commit;

  for m in c_mes loop
     -- Borrado de los meses a insertar
      delete from H_HIPO_MES where MES_ID = m.mes_H;
      commit;

      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = m.mes_H;

      insert into H_HIPO_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
        )
      select m.mes_H,
         max_dia_mes,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
      from H_HIPO
      where DIA_ID = max_dia_mes;
    commit;
  end loop;

  -- Crear indices H_HIPO_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_MES_IX'', ''H_HIPO_MES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_MES. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_HIPO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_TRIMESTRE. Empieza Carga', 3;

  -- Borrar Indices H_HIPO_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_HIPO_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  for n in c_trimestre loop
      -- Borrado de los meses a insertar
      delete from H_HIPO_TRIMESTRE where TRIMESTRE_ID = n.trimestre_H;
      commit;

      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = n.trimestre_H;

      insert into H_HIPO_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
        )
        select n.trimestre_H,
         max_dia_trimestre,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
        from H_HIPO
        where DIA_ID = max_dia_trimestre;
      commit;
  end loop;

  -- Crear indices H_HIPO_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_TRIMESTRE_IX'', ''H_HIPO_TRIMESTRE (TRIMESTRE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_TRIMESTRE. Termina Carga', 3;

*/
-- ----------------------------------------------------------------------------------------------
--                                      H_HIPO_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_ANIO. Empieza Carga', 3;

  -- Borrar Indices H_HIPO_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_HIPO_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle que recorre los años
  for o in c_anio loop

      -- Borrado de los meses a insertar
      delete from H_HIPO_ANIO where ANIO_ID = o.anio_H;
      commit;

      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = o.anio_H;


      insert into H_HIPO_ANIO
        (ANIO_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
        )
        select o.anio_H,
         max_dia_anio,
         PROCEDIMIENTO_ID,
         FECHA_CREACION_ASUNTO,
         FECHA_INTERP_DEM_HIP,
         FECHA_SUBASTA_SOLICITADA,
         FECHA_SUBASTA,
         FECHA_CESION_REMATE,
         FECHA_ADJUDICACION,
         FECHA_CELEBRACION_SUBASTA,
         FASE_SUBASTA_HIPOTECARIO_ID,
         ULT_TAR_FASE_HIP_ID,
         TD_ID_HIP_SUBASTA_ID,
         TD_SUB_SOL_SUB_CEL_ID,
         TD_SUB_CEL_CESION_REMATE_ID,
         NUM_HIPOTECARIOS,
         P_CREACION_ASU_SUBASTA,
         P_CREACION_ASU_CESION_REMATE,
         P_CREACION_ASU_ADJUDICACION,
         P_ID_HIP_SUBASTA,
         P_INTERP_DEM_HIP_CESION_REMATE,
         P_INTERP_DEM_HIP_ADJUDICACION,
         P_SUBASTA_ADJUDICACION,
         P_SUB_SOL_SUB_CEL,
         P_SUB_CEL_CESION_REMATE
        from H_HIPO
        where DIA_ID = max_dia_anio;
      commit;
  end loop;

  -- Crear indices H_HIPO_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_HIPO_ANIO_IX'', ''H_HIPO_ANIO (ANIO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_HIPO_ANIO. Termina Carga', 3;
*/

-- =========================================================================================================================================
--                  					                        				        MONITORIO
-- =========================================================================================================================================
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON. Empieza Carga', 3;

  -- Borrar Indices H_MON
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_MON_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
-- Borrar Indices TMP_MON_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_MON_JRQ_ITER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_MON_JRQ_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MON_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate '
  insert into TMP_MON_JERARQUIA
  select a.* from TMP_PRC_ESPECIFICO_JERARQUIA a,
              (select distinct DD_TPO_ID from '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO tp
               join '||V_DATASTAGE||'.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
               where DD_TPO_DESCRIPCION = ''P. Monitorio'') b
  where a.TIPO_PROCEDIMIENTO_DET = b.DD_TPO_ID ';
  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_MON_JERARQUIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
    -- Crear indices TMP_MON_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_MON_JRQ_ITER_IX'', ''TMP_MON_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_MON_JRQ_FASE_ACT_IX'', ''TMP_MON_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

-- Bucle para las taras e inclusiOn en H_MON
  for p in c_fecha loop

      -- ------------------ TAREAS ASOCIADAS -----------------------------
      -- Calculo las fechas de los hitos a medir
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MON_DETALLE'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      insert into TMP_MON_DETALLE(ITER)
      select distinct ITER from TMP_MON_JERARQUIA where DIA_ID = p.DIA_ID;
      commit;

      -- FECHA_INTERP_DEM_MON
      -- TAP_ID: 318 P02_InterposicionDemanda
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MON_TAREA'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      execute immediate '
      insert into TMP_MON_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
      select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
      from TMP_MON_JERARQUIA tpj
      join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||p.DIA_ID||'''
      join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (317)
      join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fechaSolicitud''
      where  DIA_ID = '''||p.DIA_ID||'''
      ';
      commit;

      merge into TMP_MON_DETALLE a
      using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_MON_TAREA group by ITER) b
      on (b.ITER = a.ITER)
      when matched then update set a.FECHA_INTERP_DEM_MON = b.FECHA_FORMULARIO;
      commit;

      -- FECHA_DECRETO_FINALIZACION
      -- TAP_ID: 321	P02_RegAutodespachandoEjecucion
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_MON_TAREA'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      execute immediate '
      insert into TMP_MON_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
      select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
      from TMP_MON_JERARQUIA tpj
      join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||p.DIA_ID||'''
      join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (321)
      join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = ''fecha''
      where  DIA_ID = '''||p.DIA_ID||'''
      ';
      commit;

      merge into TMP_MON_DETALLE a
      using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_MON_TAREA group by ITER) b
      on (b.ITER = a.ITER)
      when matched then update set a.FECHA_DECRETO_FINALIZACION = b.FECHA_FORMULARIO;
      commit;

      -- Borrado de los días a insertar
      delete from H_MON where DIA_ID = p.DIA_ID;
      commit;

      -- Insertamos en H_MON sólo el registro que tiene la última actuación
      insert into H_MON
        (DIA_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_MON,
         FECHA_DECRETO_FINALIZACION,
         NUM_MONITORIOS,
         P_ID_MON_DECRETO_FIN
        )
      select p.DIA_ID,
             p.DIA_ID,
             ITER,
             FECHA_INTERP_DEM_MON,
             FECHA_DECRETO_FINALIZACION,
             1,
             (FECHA_DECRETO_FINALIZACION - FECHA_INTERP_DEM_MON)
      from TMP_MON_DETALLE;
    commit;
  end loop;

  -- Crear indices H_MON
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_IX'', ''H_MON (DIA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  update H_MON set TD_ID_MON_DECRETO_FIN_ID = (case when P_ID_MON_DECRETO_FIN > 0 and P_ID_MON_DECRETO_FIN <= 30 then 0
                                                           when P_ID_MON_DECRETO_FIN > 30 and P_ID_MON_DECRETO_FIN <= 60 then 1
                                                           when P_ID_MON_DECRETO_FIN > 60 and P_ID_MON_DECRETO_FIN <= 90 then 2
                                                           when P_ID_MON_DECRETO_FIN > 90 and P_ID_MON_DECRETO_FIN <= 120 then 3
                                                           when P_ID_MON_DECRETO_FIN > 120 and P_ID_MON_DECRETO_FIN <= 150 then 4
                                                           when P_ID_MON_DECRETO_FIN > 150 then 5
                                                           else -1
                                                       end);
   commit;

   -- Incluimos el último día cargado
  select max(DIA_ID) into max_dia_carga from H_MON;
  update H_MON set FECHA_CARGA_DATOS = max_dia_carga;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_MON_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_SEMANA. Empieza Carga', 3;

  -- Borrar Indices H_MON_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_MON_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_MON where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;

  for qq in c_semana loop

      -- Borrado de las semanas a insertar
      delete from H_MON_SEMANA where SEMANA_ID = qq.SEMANA_H;
      commit;

      select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = qq.SEMANA_H;

      insert into H_MON_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_MON,
         FECHA_DECRETO_FINALIZACION,
         TD_ID_MON_DECRETO_FIN_ID,
         NUM_MONITORIOS,
         P_ID_MON_DECRETO_FIN
        )
      select qq.SEMANA_H,
             max_dia_semana,
             PROCEDIMIENTO_ID,
             FECHA_INTERP_DEM_MON,
             FECHA_DECRETO_FINALIZACION,
             TD_ID_MON_DECRETO_FIN_ID,
             NUM_MONITORIOS,
             P_ID_MON_DECRETO_FIN
      from H_MON
      where DIA_ID = max_dia_semana;
    commit;
  end loop;


  -- Crear indices H_MON_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_SEMANA_IX'', ''H_MON_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_SEMANA. Termina Carga', 3;

*/
-- ----------------------------------------------------------------------------------------------
--                                      H_MON_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_MES. Empieza Carga', 3;

  -- Borrar Indices H_MON_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_MON_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_MON where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select MES_ID, TRIMESTRE_ID, ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.MES_H = cf.MES_ID, dc.TRIMESTRE_H = cf.TRIMESTRE_ID, dc.ANIO_H = cf.ANIO_ID;
  commit;

  for q in c_mes loop
      -- Borrado de los meses a insertar
      delete from H_MON_MES where MES_ID = q.mes_H;
      commit;

      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = q.mes_H;

      insert into H_MON_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         FECHA_INTERP_DEM_MON,
         FECHA_DECRETO_FINALIZACION,
         TD_ID_MON_DECRETO_FIN_ID,
         NUM_MONITORIOS,
         P_ID_MON_DECRETO_FIN
        )
      select q.mes_H,
             max_dia_mes,
             PROCEDIMIENTO_ID,
             FECHA_INTERP_DEM_MON,
             FECHA_DECRETO_FINALIZACION,
             TD_ID_MON_DECRETO_FIN_ID,
             NUM_MONITORIOS,
             P_ID_MON_DECRETO_FIN
      from H_MON
      where DIA_ID = max_dia_mes;
    commit;
  end loop;


  -- Crear indices H_MON_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_MES_IX'', ''H_MON_MES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_MES. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_MON_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_TRIMESTRE. Empieza Carga', 3;

  -- Borrar Indices H_MON_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_MON_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  for r IN c_trimestre loop

      -- Borrado de los meses a insertar
      delete from H_MON_TRIMESTRE where TRIMESTRE_ID = r.trimestre_H;
      commit;

      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = r.trimestre_H;

      insert into H_MON_TRIMESTRE
          (TRIMESTRE_ID,
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,
           FECHA_INTERP_DEM_MON,
           FECHA_DECRETO_FINALIZACION,
           TD_ID_MON_DECRETO_FIN_ID,
           NUM_MONITORIOS,
           P_ID_MON_DECRETO_FIN
          )
      select r.trimestre_H,
             max_dia_trimestre,
             PROCEDIMIENTO_ID,
             FECHA_INTERP_DEM_MON,
             FECHA_DECRETO_FINALIZACION,
             TD_ID_MON_DECRETO_FIN_ID,
             NUM_MONITORIOS,
             P_ID_MON_DECRETO_FIN
      from H_MON
      where DIA_ID = max_dia_trimestre;
    commit;
  END loop;

  -- Crear indices H_MON_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_TRIMESTRE_IX'', ''H_MON_TRIMESTRE (TRIMESTRE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_TRIMESTRE. Termina Carga', 3;

*/
-- ----------------------------------------------------------------------------------------------
--                                      H_MON_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_ANIO. Empieza Carga', 3;

  -- Borrar Indices H_MON_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_MON_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  for s in c_anio loop

      -- Borrado de los meses a insertar
      delete from H_MON_ANIO where ANIO_ID = s.anio_H;

      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = s.anio_H;

      insert into H_MON_ANIO
            (ANIO_ID,
             FECHA_CARGA_DATOS,
             PROCEDIMIENTO_ID,
             FECHA_INTERP_DEM_MON,
             FECHA_DECRETO_FINALIZACION,
             TD_ID_MON_DECRETO_FIN_ID,
             NUM_MONITORIOS,
             P_ID_MON_DECRETO_FIN
            )
      select s.anio_H,
             max_dia_anio,
             PROCEDIMIENTO_ID,
             FECHA_INTERP_DEM_MON,
             FECHA_DECRETO_FINALIZACION,
             TD_ID_MON_DECRETO_FIN_ID,
             NUM_MONITORIOS,
             P_ID_MON_DECRETO_FIN
      from H_MON
      where DIA_ID = max_dia_anio;
    commit;
  end loop;

  -- Crear indices H_MON_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_MON_ANIO_IX'', ''H_MON_ANIO (ANIO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_MON_ANIO. Termina Carga', 3;
*/

-- =========================================================================================================================================
--                  					                        				        EJECUCION_NOTARIAL
-- =========================================================================================================================================
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_NOT
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_NOT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Borrar Indices TMP_EJEC_NOT_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EJEC_NOT_JRQ_ITER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EJEC_NOT_JRQ_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_NOT_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate '
  insert into TMP_EJEC_NOT_JERARQUIA
  select a.* from TMP_PRC_ESPECIFICO_JERARQUIA a,
                  (select DD_TPO_ID from '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO tp
                   join '||V_DATASTAGE||'.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                   where DD_TPO_DESCRIPCION = ''T. de ejecución notarial'') b
  where a.TIPO_PROCEDIMIENTO_DET = b.DD_TPO_ID';
  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EJEC_NOT_JERARQUIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
    -- Crear indices TMP_MON_JERARQUIA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_NOT_JRQ_ITER_IX'', ''TMP_EJEC_NOT_JERARQUIA (DIA_ID, ITER)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EJEC_NOT_JRQ_FASE_ACT_IX'', ''TMP_EJEC_NOT_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
    

  -- Bucle para las taras e inclusión en H_EJEC_NOT
  for t in c_fecha loop

      -- ------------------ TAREAS ASOCIADAS -----------------------------
      -- Calculo las fechas de los hitos a medir
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_NOT_DETALLE'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      insert into TMP_EJEC_NOT_DETALLE(ITER)
      select distinct ITER from TMP_EJEC_NOT_JERARQUIA where DIA_ID = t.DIA_ID;
      commit;

      -- FECHA_SUBASTA_EJEC_NOT (SEÑALAMIENTO)
      -- TAP_ID: 10000000002830 y 10000000002632	(T. Subasta Bankia + T. Subasta Sareb)
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_NOT_TAREA'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      execute immediate '
      insert into TMP_EJEC_NOT_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO)
      select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')
      from TMP_EJEC_NOT_JERARQUIA tpj
      join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= '''||t.DIA_ID||'''
      join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000002830,10000000002632)
      join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE in (''fechaSenyalamiento'')
      where  DIA_ID = '''||t.DIA_ID||'''
      and tpj.FASE_FINALIZADA is null
      and tpj.FASE_PARALIZADA is null
      and tpj.FASE_CON_RECURSO is null';
      commit;



      merge into TMP_EJEC_NOT_DETALLE a
      using (select ITER, max(TRUNC(FECHA_FORMULARIO)) as FECHA_FORMULARIO from TMP_EJEC_NOT_TAREA group by ITER) b
      on (b.ITER = a.ITER)
      when matched then update set a.FECHA_SUBASTA_EJEC_NOT = b.FECHA_FORMULARIO;
      commit;

      -- FASE SUBASTA - 0	Demanda Presentada - 1 Subasta Solicitada - 2 Subasta Señalada -3 Subasta Celebrada: Pendiente Cesión de remate - 4 Subasta Celebrada: Con Cesión de Remate - 5 Subasta Celebrada: Pendiente Adjudicación - 6 Otros
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EJEC_NOT_TAREA'', '''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      execute immediate '
      insert into TMP_EJEC_NOT_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID)
      select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID
      from TMP_EJEC_NOT_JERARQUIA tpj
      join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID and (TRUNC(tar.TAR_FECHA_FIN) <= '''||t.DIA_ID||''' or (tar.TAR_FECHA_FIN is null and tar.BORRADO = 0))
      join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000000900, 10000000000901, 10000000000902, 10000000000903, 10000000000904, 10000000000905,
                           10000000000906,
                           10000000000909, 10000000000910, 10000000000911,
                           10000000000912, 10000000000914,
                           10000000000915)
      where  DIA_ID = '''||t.DIA_ID||'''
      ';
      commit;

      -- Calculamos la fase con el TAP_ID de la última tarea de cada procedimiento
      merge into TMP_EJEC_NOT_DETALLE a
      using (select ITER, max(FECHA_INI) as FECHA_INI from TMP_EJEC_NOT_TAREA where TRUNC(FECHA_INI) <= t.DIA_ID and FECHA_INI is not null group by ITER) b
      on (b.ITER = a.ITER)
      when matched then update set a.FECHA_ULT_TAR_CREADA = b.FECHA_INI;
      commit;

      merge into TMP_EJEC_NOT_DETALLE a
      using (select ITER, FECHA_INI, max(TAREA) as TAREA from TMP_EJEC_NOT_TAREA group by ITER, FECHA_INI) b
      on (b.ITER = a.ITER and b.FECHA_INI = a.FECHA_ULT_TAR_CREADA)
      when matched then update set a.ULT_TAR_CREADA = b.TAREA;
      commit;

	  merge into TMP_EJEC_NOT_DETALLE a
      using (select ITER, TAREA, max(TAP_ID) as TAP_ID from TMP_EJEC_NOT_TAREA group by ITER, TAREA) b
      on (b.ITER = a.ITER and b.TAREA = a.ULT_TAR_CREADA)
      when matched then update set a.TAP_ID_ULT_TAR_CREADA = b.TAP_ID;
      commit;
    -- 1	Demanda Presentada
    -- 2	Subasta Solicitada
    -- 3	Subasta Señalada
    -- 4	Subasta Celebrada: Con Cesión de Remate
    -- 5	Subasta Celebrada: Pendiente Adjudicación
    -- 6	Otros
    update TMP_EJEC_NOT_DETALLE set FASE_SUBASTA = (case when TAP_ID_ULT_TAR_CREADA in (10000000000900, 10000000000901, 10000000000902, 10000000000903, 10000000000904, 10000000000905) then 1
                                                                when TAP_ID_ULT_TAR_CREADA in (10000000000906) then 2
                                                                when TAP_ID_ULT_TAR_CREADA in (10000000000909, 10000000000910, 10000000000911) then 3
                                                                when TAP_ID_ULT_TAR_CREADA in (10000000000912, 10000000000914) then 4
                                                                when TAP_ID_ULT_TAR_CREADA in (10000000000915) then 5
                                                                else 6
                                                              end);
    commit;

    -- Borrado de los días a insertar
    delete from H_EJEC_NOT where DIA_ID = t.DIA_ID;
    commit;

    -- Insertamos en H_EJEC_NOT sólo el registro que tiene la última actuación
    insert into H_EJEC_NOT
              (DIA_ID,
               FECHA_CARGA_DATOS,
               PROCEDIMIENTO_ID,
               FECHA_SUBASTA_EJEC_NOT,
               F_SUBASTA_EJEC_NOTARIAL_ID,
               NUM_EJECUCIONES_NOTARIALES
              )
    select t.DIA_ID,
           t.DIA_ID,
           ITER,
           FECHA_SUBASTA_EJEC_NOT,
           FASE_SUBASTA,
           1
    from TMP_EJEC_NOT_DETALLE;
   commit;
  end loop;

  -- Crear indices H_EJEC_NOT
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_IX'', ''H_EJEC_NOT (DIA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

   -- Incluimos el último día cargado
  select max(DIA_ID) into max_dia_carga from H_EJEC_NOT;
  update H_EJEC_NOT set FECHA_CARGA_DATOS = max_dia_carga;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_NOT_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_SEMANA. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_NOT_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_NOT_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_EJEC_NOT where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;

  for uu in c_semana loop
      -- Borrado de los meses a insertar
    delete from H_EJEC_NOT_SEMANA where SEMANA_ID = uu.SEMANA_H;
    commit;

    select max(DIA_H)
    into max_dia_semana from TMP_FECHA where SEMANA_H = uu.SEMANA_H;
    commit;

    insert into H_EJEC_NOT_SEMANA
          (SEMANA_ID,
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,
           FECHA_SUBASTA_EJEC_NOT,
           F_SUBASTA_EJEC_NOTARIAL_ID,
           NUM_EJECUCIONES_NOTARIALES
          )
    select uu.SEMANA_H,
           max_dia_semana,
           PROCEDIMIENTO_ID,
           FECHA_SUBASTA_EJEC_NOT,
           F_SUBASTA_EJEC_NOTARIAL_ID,
           NUM_EJECUCIONES_NOTARIALES
    from H_EJEC_NOT
    where DIA_ID = max_dia_semana;
  commit;
  end loop;

  -- Crear indices H_EJEC_NOT_SEMANA
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_SEMANA_IX'', ''H_EJEC_NOT_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_SEMANA. Termina Carga', 3;

*/
-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_NOT_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_MES. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_NOT_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_NOT_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA (DIA_H)
  select distinct DIA_ID from H_EJEC_NOT where DIA_ID between date_start and date_end;
  commit;

  merge into TMP_FECHA dc
  using (select MES_ID, TRIMESTRE_ID, ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)
  when matched then update set dc.MES_H = cf.MES_ID, dc.TRIMESTRE_H = cf.TRIMESTRE_ID, dc.ANIO_H = cf.ANIO_ID;
  commit;

  for u in c_mes loop

      -- Borrado de los meses a insertar
    delete from H_EJEC_NOT_MES where MES_ID = u.mes_H;
    commit;

    select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = u.mes_H;

    insert into H_EJEC_NOT_MES
          (MES_ID,
           FECHA_CARGA_DATOS,
           PROCEDIMIENTO_ID,
           FECHA_SUBASTA_EJEC_NOT,
           F_SUBASTA_EJEC_NOTARIAL_ID,
           NUM_EJECUCIONES_NOTARIALES
          )
    select u.mes_H,
           max_dia_mes,
           PROCEDIMIENTO_ID,
           FECHA_SUBASTA_EJEC_NOT,
           F_SUBASTA_EJEC_NOTARIAL_ID,
           NUM_EJECUCIONES_NOTARIALES
    from H_EJEC_NOT
    where DIA_ID = max_dia_mes;
    commit;
  end loop;

  -- Crear indices H_EJEC_NOT_MES
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_MES_IX'', ''H_EJEC_NOT_MES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_MES. Termina Carga', 3;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_NOT_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_TRIMESTRE. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_NOT_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_NOT_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle que recorre los trimestres
  for v IN c_trimestre loop

      -- Borrado de los meses a insertar
      delete from H_EJEC_NOT_TRIMESTRE where TRIMESTRE_ID = v.trimestre_H;
      commit;

      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = v.trimestre_H;

      insert into H_EJEC_NOT_TRIMESTRE
                  (TRIMESTRE_ID,
                   FECHA_CARGA_DATOS,
                   PROCEDIMIENTO_ID,
                   FECHA_SUBASTA_EJEC_NOT,
                   F_SUBASTA_EJEC_NOTARIAL_ID,
                   NUM_EJECUCIONES_NOTARIALES
                  )
      select v.trimestre_H,
             max_dia_trimestre,
             PROCEDIMIENTO_ID,
             FECHA_SUBASTA_EJEC_NOT,
             F_SUBASTA_EJEC_NOTARIAL_ID,
             NUM_EJECUCIONES_NOTARIALES
      from H_EJEC_NOT
      where DIA_ID = max_dia_trimestre;
    commit;
  end loop;

  -- Crear indices H_EJEC_NOT_TRIMESTRE
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_TRIMESTRE_IX'', ''H_EJEC_NOT_TRIMESTRE (TRIMESTRE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_TRIMESTRE. Termina Carga', 3;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_EJEC_NOT_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_ANIO. Empieza Carga', 3;

  -- Borrar Indices H_EJEC_NOT_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EJEC_NOT_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  -- Bucle que recorre los años
  for w in c_anio loop

      -- Borrado de los meses a insertar
      delete from H_EJEC_NOT_ANIO where ANIO_ID = w.anio_H;
      commit;

      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = w.anio_H;

      insert into H_EJEC_NOT_ANIO
                (ANIO_ID,
                 FECHA_CARGA_DATOS,
                 PROCEDIMIENTO_ID,
                 FECHA_SUBASTA_EJEC_NOT,
                 F_SUBASTA_EJEC_NOTARIAL_ID,
                 NUM_EJECUCIONES_NOTARIALES
                )
      select w.anio_H,
             max_dia_anio,
             PROCEDIMIENTO_ID,
             FECHA_SUBASTA_EJEC_NOT,
             F_SUBASTA_EJEC_NOTARIAL_ID,
             NUM_EJECUCIONES_NOTARIALES
      from H_EJEC_NOT
      where DIA_ID = max_dia_anio;
    commit;
  end loop;


  -- Crear indices H_EJEC_NOT_ANIO
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EJEC_NOT_ANIO_IX'', ''H_EJEC_NOT_ANIO (ANIO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EJEC_NOT_ANIO. Termina Carga', 3;
*/
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


EXCEPTION
  WHEN OBJECTEXISTS then
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  WHEN INSERT_NULL then
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;
  WHEN PARAMETERS_NUMBER then
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;
  WHEN OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;
end;

END CARGAR_H_PROCEDIMIENTO_ESPEC;
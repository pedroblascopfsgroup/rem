create or replace PROCEDURE CARGAR_H_CNT_DET_CREDITO(DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS

-- ===============================================================================================

-- Autor: Jaime Sánchez-Cuenca, PFS Group

-- Fecha creación: 8 Junio 2015

-- Responsable ultima modificacion: María Villanueva, PFS Group

-- Fecha última modificación: 23/11/2015

-- Motivos del cambio: usuario propietario

-- Cliente: Recovery BI PRODUCTO

--

-- Descripción: Procedimiento almancenado que carga las tablas hechos H_CNT_DET_CREDITO.

-- ===============================================================================================

BEGIN

DECLARE

-- ===============================================================================================

--                  									Declaracación de variables

-- ===============================================================================================

  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_CNT_DET_CREDITO';

  V_ROWCOUNT NUMBER;



  V_NUM_ROW NUMBER(10);


  V_DATASTAGE VARCHAR2(100);
  V_SQL VARCHAR2(16000);

  V_NUMBER  NUMBER(16,0);

  nCount NUMBER;





   formato_fecha VARCHAR2(100);



  min_dia_semana date;

  max_dia_semana date;

  min_dia_mes date;

  max_dia_mes date;

  min_dia_trimestre date;

  max_dia_trimestre date;

  min_dia_anio date;

  max_dia_anio date;

  max_dia_carga date;

  dia_periodo_ant date;

  semana_periodo_ant int;

  mes_periodo_ant int;

  trimestre_periodo_ant int;

  anio_periodo_ant int;

  hay_datos int;

  primer_dia_mes date;

  fecha_inicio_campana_recobro date;

  fecha_recobro date;

  fecha_especializada date;

  semana int;

  mes int;

  trimestre int;

  anio int;

  fecha date;

  fecha_anterior date;

  fecha_rellenar date;



  max_dia_h date;

  max_dia_mov date;

  penult_dia_mov date;

  max_dia_con_contratos date;



  max_dia_enviado_agencia date;

  max_dia_enviado_cobro date;

  f_cobro date;

  max_fecha_cobro date;
  fecha_primer_credito date;


  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;

  cursor c_fecha_rellenar is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;



  cursor c_fecha_en_recobro is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;

  cursor c_fecha_especializada is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;



  cursor c_semana is select distinct SEMANA_H from TMP_FECHA ORDER BY 1;

  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;

  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;

  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;



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

--                                      H_CNT_DET_CREDITO

-- ----------------------------------------------------------------------------------------------

  --Log_Proceso
  
	select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
    select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  fecha_primer_credito := '07/11/2015';       


  -- Gestores de Créditos insinuados

  -- Borrando indices TMP_CNT_GESTOR_CREDITO






	   

         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_GESTOR_CREDITO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   

    commit;



 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_GESTOR_CREDITO'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate  'insert into TMP_CNT_GESTOR_CREDITO (PROCEDIMIENTO_ID, GESTOR_CREDITO_ID)

                      select prc.PRC_ID, usu.USU_ID

                      from  '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS usd

                      join  '||V_DATASTAGE||'.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID

                      join  '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID

                      join  '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID

                      join  '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS prc on gaa.ASU_ID = prc.ASU_ID

                      where tges.DD_TGE_DESCRIPCION = ''Letrado''';

  commit;



    -- Crear indices TMP_CNT_GESTOR_CREDITO












    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_GESTOR_CREDITO_IX'', ''TMP_CNT_GESTOR_CREDITO (PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;



-- ----------------------------- Loop fechas a cargar -----------------------------

  open c_fecha;

  loop --READ_LOOP

    fetch c_fecha into fecha;

    exit when c_fecha%NOTFOUND;



    --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;



    -- Borrando indices TMP_H_CNT_DET_CREDITO_IX





          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_DET_CREDITO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	  

    commit;



    --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_CREDITO. Borrado de índices', 4;





   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT_DET_CREDITO'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT_DET_CREDITO

                            (DIA_ID,

                             FECHA_CARGA_DATOS,

                             CREDITO_INSINUADO_ID,

                             CONTRATO_ID,

                             CEX_ID,

                             FECHA_CREDITO_INSINUADO,

                             ESTADO_INSI_CREDITO_ID,

                             CALIFICACION_INICIAL_ID,

                             CALIFICACION_GESTOR_ID,

                             CALIFICACION_FINAL_ID,

                             NUM_CREDITO_INSINUADO,

                             PRINCIPAL_INICIAL,

                             PRINCIPAL_GESTOR,

                             PRINCIPAL_FINAL)

                     select ''' || fecha || ''',

                            ''' || fecha || ''',

                            cre.CRE_CEX_ID,

                            cex.CNT_ID,

                            cex.CEX_ID,

                            trunc(cre.FECHACREAR),

                            nvl(cre.STD_CRE_ID, -1),

                            nvl(cre.TPO_CNT_ID_EXT, -1),

                            nvl(cre.TPO_CNT_ID_SUP, -1),

                            nvl(cre.TPO_CNT_ID_FINAL, -1),

                            1,

                            cre.CRE_PRINCIPAL_SUP,

                            cre.CRE_PRINCIPAL_FINAL,

                            cre.CRE_PRINCIPAL_FINAL

                    from '||V_DATASTAGE||'.CRE_PRC_CEX cre

                    join '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex on cre.CRE_PRC_CEX_CEXID = cex.CEX_ID
					left join (select CREDITO_INSINUADO_ID FROM H_CNT_DET_CREDITO) anti on cre.CRE_CEX_ID = anti.CREDITO_INSINUADO_ID

                    where cre.BORRADO = 0 and trunc(cre.FECHACREAR) <= ''' || fecha ||''' and trunc(cre.FECHACREAR) >= ''' || fecha_primer_credito || ''' and anti.CREDITO_INSINUADO_ID  is null';



    V_ROWCOUNT := sql%rowcount;

    commit;



     --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT_DET_CREDITO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;



    -- Crear indices TMP_H_CNT_DET_CREDITO












    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_DET_CREDITO_IX'', ''TMP_H_CNT_DET_CREDITO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;



    execute immediate 'update TMP_H_CNT_DET_CREDITO htmp set htmp.PROCEDIMIENTO_ID = (select max(PRC_ID) from '||V_DATASTAGE||'.PRC_CEX pcex where htmp.CEX_ID = pcex.CEX_ID)  where htmp.DIA_ID = '''||fecha||'''';

    commit;



       /*

    execute immediate 'merge into TMP_H_CNT_DET_CREDITO htmp

            using (select CEX_ID, PRC_ID from '||V_DATASTAGE||'.PRC_CEX) pcex

            on (htmp.CEX_ID = pcex.CEX_ID)

            when matched then update set htmp.PROCEDIMIENTO_ID = pcex.PRC_ID where htmp.DIA_ID = '''||fecha||'''';

     commit;

     */

    merge into TMP_H_CNT_DET_CREDITO htmp

    using (select nvl(GESTOR_CREDITO_ID, -1) GESTOR_CREDITO_ID, PROCEDIMIENTO_ID  from TMP_CNT_GESTOR_CREDITO) tges

    on (htmp.PROCEDIMIENTO_ID = tges.PROCEDIMIENTO_ID)

    when matched then update set htmp.GESTOR_CREDITO_ID = tges.GESTOR_CREDITO_ID where htmp.DIA_ID = fecha;

    commit;



    -- Borrando indices H_CNT_DET_CREDITO





         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CREDITO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   

    commit;



    --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO. Borrado de índices', 4;



    -- Borrado del día a insertar

    delete from H_CNT_DET_CREDITO where DIA_ID = fecha;

    commit;



    insert into H_CNT_DET_CREDITO

        (

          DIA_ID,

          FECHA_CARGA_DATOS,

          CREDITO_INSINUADO_ID,

          CONTRATO_ID,

          FECHA_CREDITO_INSINUADO,

          GESTOR_CREDITO_ID,

          ESTADO_INSI_CREDITO_ID,

          CALIFICACION_INICIAL_ID,

          CALIFICACION_GESTOR_ID,

          CALIFICACION_FINAL_ID,

          NUM_CREDITO_INSINUADO,

          PRINCIPAL_INICIAL,

          PRINCIPAL_GESTOR,

          PRINCIPAL_FINAL

        )

     select DIA_ID,

          FECHA_CARGA_DATOS,

          CREDITO_INSINUADO_ID,

          CONTRATO_ID,

          FECHA_CREDITO_INSINUADO,

          GESTOR_CREDITO_ID,

          ESTADO_INSI_CREDITO_ID,

          CALIFICACION_INICIAL_ID,

          CALIFICACION_GESTOR_ID,

          CALIFICACION_FINAL_ID,

          NUM_CREDITO_INSINUADO,

          PRINCIPAL_INICIAL,

          PRINCIPAL_GESTOR,

          PRINCIPAL_FINAL

      from TMP_H_CNT_DET_CREDITO where DIA_ID = fecha;



    -- Crear indices H_CNT_DET_CREDITO





 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CREDITO_IX'', ''H_CNT_DET_CREDITO (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';






            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;



    --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;



    end loop;

  close c_fecha;







  -- -------------------------- CÁLCULO DEL RESTO DE PERIODOS ----------------------------




 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_CNT_DET_CREDITO;

  commit;

-- ----------------------------------------------------------------------------------------------

--                                      H_CNT_DET_CREDITO_SEMANA

-- ----------------------------------------------------------------------------------------------
/*

  --Log_Proceso

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_SEMANA. Empieza bucle', 3;



  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)







 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;



  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;

  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start

  select max(SEMANA_ID) into V_NUMBER from H_CNT_DET_CREDITO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);

  if(V_NUMBER) is not null then

    insert into TMP_FECHA_AUX (SEMANA_AUX)

    select max(SEMANA_ID) from H_CNT_DET_CREDITO_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);

  end if;

  commit;



  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;

  commit;



  merge into TMP_FECHA dc

  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf

  on (cf.DIA_ID = dc.DIA_H)

  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;

  commit;



  delete from TMP_FECHA where SEMANA_H not in (select distinct SEMANA_AUX from TMP_FECHA_AUX);

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



    -- Borrado indices H_CNT_DET_CREDITO_SEMANA



	   

         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CREDITO_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   

    commit;



    -- Borrado de las semanas a insertar

    delete from H_CNT_DET_CREDITO_SEMANA where SEMANA_ID = semana;

    commit;



    insert into H_CNT_DET_CREDITO_SEMANA

        (SEMANA_ID,

         FECHA_CARGA_DATOS,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL)

    select semana,

         max_dia_semana,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL

    from H_CNT_DET_CREDITO

    where FECHA_CREDITO_INSINUADO between min_dia_semana and max_dia_semana;

    V_ROWCOUNT := sql%rowcount;

    commit;



     --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;



    -- Crear indices H_CNT_DET_CREDITO_SEMANA










     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CREDITO_SEMANA_IX'', ''H_CNT_DET_CREDITO_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';


            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;



  end loop C_SEMANAS_LOOP;

close c_semana;



    --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_SEMANA. Termina bucle', 3;

*/




-- ----------------------------------------------------------------------------------------------

--                                      H_CNT_DET_CREDITO_MES

-- ----------------------------------------------------------------------------------------------

  --Log_Proceso

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_MES. Empieza bucle', 3;





  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)






 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;



  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;

  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start

  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_CNT_DET_CREDITO_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);



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



    -- Borrado indices H_CNT_DET_CREDITO_MES




	   

         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CREDITO_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   

    commit;



    -- Borrado de las semanas a insertar

    delete from H_CNT_DET_CREDITO_MES where MES_ID = mes;

    commit;



    insert into H_CNT_DET_CREDITO_MES

        (MES_ID,

         FECHA_CARGA_DATOS,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL)

    select mes,

         max_dia_mes,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL

    from H_CNT_DET_CREDITO where FECHA_CREDITO_INSINUADO between min_dia_mes and max_dia_mes;

    V_ROWCOUNT := sql%rowcount;

    commit;



     --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;



    -- Crear indices H_CNT_DET_CREDITO_MES












   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CREDITO_MES_IX'', ''H_CNT_DET_CREDITO_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;



  end loop C_MESES_LOOP;

  close c_mes;



  --Log_Proceso

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_MES. Termina bucle', 3;





-- ----------------------------------------------------------------------------------------------

--                                     H_CNT_DET_CREDITO_TRIMESTRE

-- ----------------------------------------------------------------------------------------------
/*

  --Log_Proceso

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_TRIMESTRE. Empieza bucle', 3;



  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)





 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;



  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;

  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start

  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_CNT_DET_CREDITO_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);

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



    -- Borrado indices H_CNT_DET_CREDITO_TRIMESTRE






         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CREDITO_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   

    commit;



    -- Borrado de los trimestres a insertar

    delete from H_CNT_DET_INCI_TRIMESTRE where TRIMESTRE_ID = trimestre;

    commit;



    insert into H_CNT_DET_CREDITO_TRIMESTRE

        (TRIMESTRE_ID,

         FECHA_CARGA_DATOS,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL

       )

    select trimestre,

         max_dia_trimestre,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL

    from H_CNT_DET_CREDITO where FECHA_CREDITO_INSINUADO between min_dia_trimestre and max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;

    commit;



     --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;



    -- Crear indices H_CNT_DET_CREDITO_TRIMESTRE









    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CREDITO_TRIMESTRE_IX'', ''H_CNT_DET_CREDITO_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';


            execute immediate V_SQL USING OUT O_ERROR_STATUS;

    commit;



   end loop C_TRIMESTRE_LOOP;

  close c_trimestre;



  --Log_Proceso

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_TRIMESTRE. Termina bucle', 3;

*/




-- ----------------------------------------------------------------------------------------------

--                                      H_CNT_DET_CREDITO_ANIO

-- ----------------------------------------------------------------------------------------------
/*

  --Log_Proceso

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_ANIO. Empieza bucle', 3;



  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)





 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;



  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;

  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start

  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_CNT_DET_CREDITO_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);

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



    -- Borrado indices H_CNT_DET_CREDITO_ANIO



	   

         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_CREDITO_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   

    commit;



    -- Borrado de los años a insertar

    delete from H_CNT_DET_CREDITO_ANIO where ANIO_ID = anio;

    commit;



    insert into H_CNT_DET_CREDITO_ANIO

        (ANIO_ID,

         FECHA_CARGA_DATOS,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL

       )

    select anio,

         max_dia_anio,

         CREDITO_INSINUADO_ID,

         CONTRATO_ID,

         FECHA_CREDITO_INSINUADO,

         GESTOR_CREDITO_ID,

         ESTADO_INSI_CREDITO_ID,

         CALIFICACION_INICIAL_ID,

         CALIFICACION_GESTOR_ID,

         CALIFICACION_FINAL_ID,

         NUM_CREDITO_INSINUADO,

         PRINCIPAL_INICIAL,

         PRINCIPAL_GESTOR,

         PRINCIPAL_FINAL

    from H_CNT_DET_CREDITO where FECHA_CREDITO_INSINUADO between min_dia_anio and max_dia_anio;

    V_ROWCOUNT := sql%rowcount;

    commit;



     --Log_Proceso

    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;



    -- Crear indices H_CNT_DET_CREDITO_ANIO









   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_CREDITO_ANIO_IX'', ''H_CNT_DET_CREDITO_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;



  end loop C_ANIO_LOOP;

  close c_anio;



  --Log_Proceso

  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_CREDITO_ANIO. Termina bucle', 3;
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

    O_ERROR_STATUS := 'Número de parámetros incorrecto';

    --ROLLBACK;

  when OTHERS then

    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;

    --ROLLBACK;

    */

end;



end CARGAR_H_CNT_DET_CREDITO;

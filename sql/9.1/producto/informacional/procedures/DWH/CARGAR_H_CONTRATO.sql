create or replace PROCEDURE CARGAR_H_CONTRATO (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creaciÓn: Septiembre 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 13/04/2016
-- Motivos del cambio: tunning
-- Cliente: Recovery BI PRODUCTO
--
-- Descripci�n: Procedimiento almancenado que carga las tablas hechos H_CNT.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracaci�n de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_CONTRATO';
  V_ROWCOUNT NUMBER;

  V_NUM_ROW NUMBER(10);


 V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_PRODUC01 VARCHAR2(100);


 formato_fecha VARCHAR2(100);

  min_dia_semana date;
  max_dia_semana date;
  min_dia_mes date;
  max_dia_mes date;
  min_dia_trimestre date;
  max_dia_trimestre date;
  min_dia_anio date;
  max_dia_anio date;
  dia_periodo_ant date;
  semana_periodo_ant int;
  mes_periodo_ant int;
  trimestre_periodo_ant int;
  anio_periodo_ant int;
  fecha_inicio_campana_recobro date;
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;

  max_dia_h date;
  max_dia_mov date;
  penult_dia_mov date;
  max_dia_con_contratos date;
  max_dia_enviado_agencia date;

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA ORDER BY 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;


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

-- ----------------------------------------------------------------------------------------------
--                                      H_CNT
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
    select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';
    select valor into V_PRODUC01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';
/*
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_PRODUC01 || '.H_MOV_MOVIMIENTOS' into max_dia_h;
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_DATASTAGE || '.MOV_MOVIMIENTOS' into max_dia_mov;
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_DATASTAGE || '.MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) < to_date(''' || max_dia_mov || ''')' into penult_dia_mov;
*/
  execute immediate 'select max_dia_h, max_dia_mov, penult_dia_mov from ' || V_DATASTAGE || '.FECHAS_MOV' into max_dia_h, max_dia_mov, penult_dia_mov;

-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    -- Borrado indices TMP_H_CNT


	   
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    commit;


	   
	   
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_CNT_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    commit;


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_CNT'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- Fecha de analisis en H_MOV_MOVIMIENTOS (fecha menor que el ultimno d�a de H_MOV_MOVIMIENTOS o mayor que este, pero menor que el pen�ltimo dia de MOV_MOVIMIENTOS)
    if((fecha <= max_dia_h) or ((fecha > max_dia_h) and (fecha < penult_dia_mov))) then
      execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_PRODUC01 || '.H_MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) <= to_date(''' || fecha || ''')' into max_dia_con_contratos;

      execute immediate
      'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */  into TMP_H_CNT
       (DIA_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        CLASIFICACION_CNT_ID,
        ENVIADO_AGENCIA_CNT_ID,
        SITUACION_RESP_PER_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CNT_ID,
        ESTADO_FINANCIERO_ANT_ID,
        ESTADO_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        FECHA_CONSTITUCION_CONTRATO ,
        FECHA_CAMBIO_TRAMO ,
        FECHA_ALTA_DUDOSO ,
        FECHA_BAJA_DUDOSO  ,
        EN_GESTION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        NUM_CONTRATOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        RIESGO_VIVO,
        POS_VIVA_NO_VENC,
        POS_VIVA_VENC,
        SALDO_DUDOSO,
        PROVISION,
        INT_REMUNERATORIOS,
        INT_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        IMPORTE_A_RECLAMAR,
        CAPITAL_VIVO,
		PERIMETRO_GES_CONCU_ID,
		PERIMETRO_GES_PRE_ID,
		PERIMETRO_GES_JUDI_ID,
		PERIMETRO_GES_EXTRA_ID,
		PERIMETRO_EXP_REC_ID,
		PERIMETRO_EXP_SEG_ID,
		CONTRATO_JUDICIALIZADO_ID,
		PERIMETRO_SIN_GESTION_ID,
		SIT_CART_DANADA_ID
       )
      select '''||fecha||''',
        '''||fecha||''',
        CNT_ID,
        0,
        0,
        0,
        MOV_FECHA_POS_VENCIDA,
        MOV_FECHA_DUDOSO,
        NVL(DD_EFC_ID,-1),
        NVL(DD_EFC_ID_ANT,-1),
        NVL(DD_ESC_ID,-1),
        TO_DATE(CNT_FECHA_CREACION),
        TO_DATE(CNT_FECHA_CONSTITUCION),
        NULL,
        NULL,
        NULL,
        0,
        0,
        0,
        1,
        NVL((MOV_FECHA_EXTRACCION - MOV_FECHA_POS_VENCIDA),0),
        MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA,
        MOV_POS_VIVA_NO_VENCIDA + MOV_DEUDA_IRREGULAR,
        MOV_POS_VIVA_NO_VENCIDA,
        MOV_POS_VIVA_VENCIDA,
        MOV_SALDO_DUDOSO,
        MOV_PROVISION,
        MOV_INT_REMUNERATORIOS,
        MOV_INT_MORATORIOS,
        MOV_COMISIONES,
        MOV_GASTOS,
        MOV_RIESGO,
        MOV_DEUDA_IRREGULAR,
        MOV_DISPUESTO,
        MOV_SALDO_PASIVO,
        MOV_RIESGO_GARANT,
        MOV_SALDO_EXCE,
        MOV_LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        MOV_POS_VIVA_VENCIDA + MOV_GASTOS +  MOV_INT_REMUNERATORIOS + MOV_INT_MORATORIOS + MOV_COMISIONES,
        MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA AS CAPITAL_VIVO,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		2,
		-1
      from '||V_PRODUC01||'.H_MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION = '''||max_dia_con_contratos||''' and BORRADO = 0';

      V_ROWCOUNT := sql%rowcount;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

      commit;

    -- Fecha de an�lisis en MOV_MOVIMIENTOS - Pen�ltimo o �ltimo d�a
    elsif(fecha = penult_dia_mov or fecha = max_dia_mov) then
      execute immediate
      'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_H_CNT
       (DIA_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        CLASIFICACION_CNT_ID,
        ENVIADO_AGENCIA_CNT_ID,
        SITUACION_RESP_PER_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CNT_ID,
        ESTADO_FINANCIERO_ANT_ID,
        ESTADO_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        FECHA_CONSTITUCION_CONTRATO ,
        FECHA_CAMBIO_TRAMO ,
        FECHA_ALTA_DUDOSO ,
        FECHA_BAJA_DUDOSO  ,
        EN_GESTION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        NUM_CONTRATOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        RIESGO_VIVO,
        POS_VIVA_NO_VENC,
        POS_VIVA_VENC,
        SALDO_DUDOSO,
        PROVISION,
        INT_REMUNERATORIOS,
        INT_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        IMPORTE_A_RECLAMAR,
        CAPITAL_VIVO,
		PERIMETRO_GES_CONCU_ID,
		PERIMETRO_GES_PRE_ID,
		PERIMETRO_GES_JUDI_ID,
		PERIMETRO_GES_EXTRA_ID,
		PERIMETRO_EXP_REC_ID,
		PERIMETRO_EXP_SEG_ID,
		CONTRATO_JUDICIALIZADO_ID,
		PERIMETRO_SIN_GESTION_ID,
		SIT_CART_DANADA_ID
       )
      select '''||fecha||''',
        '''||fecha||''',
        mov.CNT_ID,
        0,
        0,
        0,
        MOV_FECHA_POS_VENCIDA,
        MOV_FECHA_DUDOSO,
        NVL(DD_EFC_ID,-1),
        NVL(DD_EFC_ID_ANT,-1),
        NVL(DD_ESC_ID,-1),
        TO_DATE(cnt.CNT_FECHA_CREACION),
        TO_DATE(cnt.CNT_FECHA_CONSTITUCION),
        NULL,
        NULL,
        NULL,
        0,
        0,
        0,
        1,
        NVL((MOV_FECHA_EXTRACCION - MOV_FECHA_POS_VENCIDA),0),
        MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA,
        MOV_POS_VIVA_NO_VENCIDA + MOV_DEUDA_IRREGULAR,
        MOV_POS_VIVA_NO_VENCIDA,
        MOV_POS_VIVA_VENCIDA,
        MOV_SALDO_DUDOSO,
        MOV_PROVISION,
        MOV_INT_REMUNERATORIOS,
        MOV_INT_MORATORIOS,
        MOV_COMISIONES,
        MOV_GASTOS,
        MOV_RIESGO,
        MOV_DEUDA_IRREGULAR,
        MOV_DISPUESTO,
        MOV_SALDO_PASIVO,
        MOV_RIESGO_GARANT,
        MOV_SALDO_EXCE,
        MOV_LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        MOV_POS_VIVA_VENCIDA + MOV_GASTOS +  MOV_INT_REMUNERATORIOS + MOV_INT_MORATORIOS + MOV_COMISIONES,
        MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA AS CAPITAL_VIVO,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		2,
		-1
        from '||V_DATASTAGE||'.MOV_MOVIMIENTOS mov,
             '||V_DATASTAGE||'.CNT_CONTRATOS cnt
      where mov.CNT_ID = cnt.CNT_ID and mov.MOV_FECHA_EXTRACCION = '''||fecha||''' and mov.BORRADO = 0';

      V_ROWCOUNT := sql%rowcount;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;

    end if;

    -- Crear indices TMP_H_CNT


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_IX'', ''TMP_H_CNT (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';





            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_CNT_CNT_IX'', ''TMP_H_CNT (CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    commit;


    -- ----------------------------- updates -------------------------------
    -- FAKE (no calculamos bajas de momento)  SITUACION_RESP_PER_ANT_ID = 0

    -- Clasificacion Contrato (En Agencia /  Resto)
     execute immediate 'merge into TMP_H_CNT hc
            using (select distinct CNT_ID from '||V_DATASTAGE||'.CRC_CICLO_RECOBRO_CNT where '''||fecha||''' >= trunc(CRC_FECHA_ALTA) and (trunc(CRC_FECHA_BAJA) > '''||fecha||''' or CRC_FECHA_BAJA is null)) crc
            on (crc.CNT_ID = hc.CONTRATO_ID)
            when matched then update set hc.CLASIFICACION_CNT_ID = 1 where hc.DIA_ID = '''||fecha||'''';
     commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 1', 4;

    -- DD_IFC_ID = 2 - haya - Segmento Cartera
     execute immediate 'merge into TMP_H_CNT hc
            using (select DISTINCT CNT_ID, DD_SEC_ID from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO 
            left join '||V_DATASTAGE||'.DD_SEC_SEGMENTO_CARTERA SEC ON SEC.DD_SEC_CODIGO = IAC_VALUE 
            where DD_IFC_ID IN (2)) crc
            on (crc.CNT_ID = hc.CONTRATO_ID)
            when matched then update set hc.SEGMENTO_CARTERA_ID = crc.DD_SEC_ID where hc.DIA_ID = '''||fecha||'''';
     commit;

    execute immediate 'update TMP_H_CNT h set SEGMENTO_CARTERA_ID = -1 where DIA_ID = '''||fecha||''' and SEGMENTO_CARTERA_ID is null';
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 2', 4;

    -- Contrato enviado a agencia
    /*Pedro S. tunning
    execute immediate 'select max(TRUNC(FECHA_HIST)) from ' || V_DATASTAGE || '.H_REC_FICHERO_CONTRATOS where TRUNC(FECHA_HIST) <= to_date(''' || fecha || ''')' into max_dia_enviado_agencia;

     execute immediate 'merge into TMP_H_CNT hc
            using (select distinct CNT_ID from '||V_DATASTAGE||'.H_REC_FICHERO_CONTRATOS where to_char(TRUNC(FECHA_HIST), '''||formato_fecha||''') = '''||max_dia_enviado_agencia||''') crc
            on (crc.CNT_ID = hc.CONTRATO_ID)
            when matched then update set hc.ENVIADO_AGENCIA_CNT_ID = 1 where hc.DIA_ID = '''||fecha||'''';
    */
    execute immediate 'merge into TMP_H_CNT hc
            using (select distinct CNT_ID from '||V_DATASTAGE||'.H_REC_FICHERO_CONTRATOS A,
            (select max(TRUNC(FECHA_HIST)) MAX_FECHA_HIST from ' || V_DATASTAGE || '.H_REC_FICHERO_CONTRATOS where TRUNC(FECHA_HIST) <= to_date(''' || fecha || ''')) B
            where TRUNC(A.FECHA_HIST) = B.MAX_FECHA_HIST) crc
            on (crc.CNT_ID = hc.CONTRATO_ID)
            when matched then update set hc.ENVIADO_AGENCIA_CNT_ID = 1 where hc.DIA_ID = '''||fecha||'''';

     commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 3', 4;
    commit;

    -- Calcular clientes y expedientes asociados a cada contrato
     execute immediate 'merge into TMP_H_CNT hc
            using (select CNT_ID, count(*) as NUM_CLIENTES from '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS group by CNT_ID) crc
            on (crc.CNT_ID = hc.CONTRATO_ID)
            when matched then update set hc.NUM_CLIENTES_ASOCIADOS = crc.NUM_CLIENTES where hc.DIA_ID = '''||fecha||'''';
     commit;

     execute immediate 'merge into TMP_H_CNT hc
            using (select CNT_ID, count(*) as NUM_EXPEDIENTES from '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE group by CNT_ID) crc
            on (crc.CNT_ID = hc.CONTRATO_ID)
            when matched then update set hc.NUM_EXPEDIENTES_ASOCIADOS = crc.NUM_EXPEDIENTES where hc.DIA_ID = '''||fecha||'''';
     commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 4', 4;

    -- Contrato en irregular
    update TMP_H_CNT set CONTRATO_EN_IRREGULAR_ID = (case when NUM_DIAS_VENCIDOS <= 0 then 0
                                                          when NUM_DIAS_VENCIDOS > 0 then 1
                                                          else -1 end) where DIA_ID = fecha;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 5', 4;

    -- Tramo Irregularidad - Fases (completa la carga incial)
    update TMP_H_CNT set T_IRREG_FASES_ID = 0 where T_IRREG_FASES_ID = -1 and NUM_DIAS_VENCIDOS <= 0 and DIA_ID = fecha;
    -- Tramo Irregularidad - D�as
    update TMP_H_CNT set T_IRREG_DIAS_ID = (case when NUM_DIAS_VENCIDOS <= 0 then 0
                                                 when NUM_DIAS_VENCIDOS > 0 and NUM_DIAS_VENCIDOS <= 30 then 1
                                                 when NUM_DIAS_VENCIDOS > 30 and NUM_DIAS_VENCIDOS <= 60 then 2
                                                 when NUM_DIAS_VENCIDOS > 60 and NUM_DIAS_VENCIDOS <= 90 then 3
                                                 when NUM_DIAS_VENCIDOS > 90 and NUM_DIAS_VENCIDOS <= 180 then 4
                                                 when NUM_DIAS_VENCIDOS > 180 and NUM_DIAS_VENCIDOS <= 270 then 5
                                                 when NUM_DIAS_VENCIDOS > 270 and NUM_DIAS_VENCIDOS <= 365  then 6
                                                 when NUM_DIAS_VENCIDOS > 365 and NUM_DIAS_VENCIDOS <= 730  then 7
                                                 when NUM_DIAS_VENCIDOS > 730 and NUM_DIAS_VENCIDOS <= 1460  then 8
                                                 when NUM_DIAS_VENCIDOS > 1460 then 9
                                                 else -1 end) where DIA_ID = fecha;
    commit;



    -- SIT_CART_DANADA_ID (Repasar cnt_id repetidos)
    execute immediate 'merge into TMP_H_CNT hc
                       using (select CNT_ID, IAC_VALUE from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 10) crc
                       on (crc.CNT_ID = hc.CONTRATO_ID)
                       when matched then update set hc.SIT_CART_DANADA_ID = crc.IAC_VALUE where hc.DIA_ID = '''||fecha||'''';


    commit;
/*       
    execute immediate 'merge into TMP_H_CNT h
                       using (select CNT_ID, exp.EXP_ID, NVL(DD_TPX_ID, -1) DD_TPX_ID
                              from '||V_CM01||'.EXP_EXPEDIENTES exp
                              join '||V_CM01||'.CEX_CONTRATOS_EXPEDIENTE cex on exp.EXP_ID = cex.EXP_ID
                              where cex.BORRADO = 0 and cex.FECHACREAR <= '''||fecha||''') texp
                       on (texp.CNT_ID = h.CONTRATO_ID)
                       when matched then update set h.TIPO_GESTION_EXP_ID = texp.DD_TPX_ID 
                       where h.DIA_ID = '''||fecha||'''';
    commit;     

 */      
    update TMP_H_CNT set TRAMO_ANTIGUEDAD_DEUDA_ID = (case when NUM_DIAS_VENCIDOS <= 0 then 0
                                                           when NUM_DIAS_VENCIDOS > 0 and NUM_DIAS_VENCIDOS <= 30 then 1
                                                           when NUM_DIAS_VENCIDOS > 30 and NUM_DIAS_VENCIDOS <= 60 then 2
                                                           when NUM_DIAS_VENCIDOS > 60 and NUM_DIAS_VENCIDOS <= 90 then 3
                                                           when NUM_DIAS_VENCIDOS > 90 then 4
                                                           else -1 end) where DIA_ID = fecha;
    commit;
  
	-- Tramo Riesgo vivo
    update TMP_H_CNT set TRAMO_RIESGO_CNT_ID = (case when RIESGO_VIVO <= 25000 then 0
                                                     when RIESGO_VIVO > 25000 and RIESGO_VIVO <= 50000 then 1
                                                     when RIESGO_VIVO > 50000 and RIESGO_VIVO <= 75000 then 2
                                                     when RIESGO_VIVO > 75000  then 3
                                                     else -1 end) where DIA_ID = fecha;
    commit;
	
		-- Tramo año de creación (concesión)
    update TMP_H_CNT set TA_FECHA_CREACION_ID = (case when EXTRACT(Year from FECHA_CREACION_CONTRATO) < 2000 then 0
                                                      when EXTRACT(Year from FECHA_CREACION_CONTRATO) >= 2000 and EXTRACT(Year from FECHA_CREACION_CONTRATO) < 2005 then 1
                                                      when EXTRACT(Year from FECHA_CREACION_CONTRATO) >= 2005 and EXTRACT(Year from FECHA_CREACION_CONTRATO) < 2010 then 2
                                                      when EXTRACT(Year from FECHA_CREACION_CONTRATO) >= 2010 and EXTRACT(Year from FECHA_CREACION_CONTRATO) < 2015 then 3
                                                      when EXTRACT(Year from FECHA_CREACION_CONTRATO) >= 2015 then 4
                                                      else -1 end) where DIA_ID = fecha;
    commit; 
	
    merge into TMP_H_CNT h
    using (select distinct CONTRATO_ID, DIA_ID from H_PRC_DET_CONTRATO where DIA_ID = fecha) hprc
    on (h.CONTRATO_ID = hprc.CONTRATO_ID)
    when matched then update set h.CONTRATO_JUDICIALIZADO_ID = 1
    where h.DIA_ID = fecha;
    commit;


     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 6', 4;


    select max(DIA_ID) into dia_periodo_ant from D_F_DIA where DIA_ID < fecha;

    if((dia_periodo_ant <= max_dia_h) or ((dia_periodo_ant > max_dia_h) and (dia_periodo_ant < penult_dia_mov))) then
       --execute immediate 'update TMP_H_CNT set NUM_DIAS_VENC_PERIODO_ANT = (select NVL((MOV_FECHA_EXTRACCION - MOV_FECHA_POS_VENCIDA),0) from '||V_PRODUC01||'.H_MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION = '''||dia_periodo_ant||''' and CNT_ID = CONTRATO_ID) where DIA_ID = '''||fecha||'''';
       execute immediate 'merge into TMP_H_CNT hc
              using (select NVL((MOV_FECHA_EXTRACCION - MOV_FECHA_POS_VENCIDA),0) as NUM_DIAS, CNT_ID from '||V_PRODUC01||'.H_MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION = '''||dia_periodo_ant||''') thc
              on (thc.CNT_ID = hc.CONTRATO_ID)
              when matched then update set hc.NUM_DIAS_VENC_PERIODO_ANT = thc.NUM_DIAS  where hc.DIA_ID = '''||fecha||'''';
       commit;
    elsif(dia_periodo_ant = penult_dia_mov or dia_periodo_ant = max_dia_mov) then
      --execute immediate 'update TMP_H_CNT set NUM_DIAS_VENC_PERIODO_ANT = (select NVL((MOV_FECHA_EXTRACCION - MOV_FECHA_POS_VENCIDA),0) from '||V_DATASTAGE||'.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION = '''||dia_periodo_ant||''' and CNT_ID = CONTRATO_ID) where DIA_ID = '''||fecha||'''';
       execute immediate 'merge into TMP_H_CNT hc
              using (select NVL((MOV_FECHA_EXTRACCION - MOV_FECHA_POS_VENCIDA),0) as NUM_DIAS, CNT_ID from '||V_DATASTAGE||'.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION = '''||dia_periodo_ant||''') thc
              on (thc.CNT_ID = hc.CONTRATO_ID)
              when matched then update set hc.NUM_DIAS_VENC_PERIODO_ANT = thc.NUM_DIAS  where hc.DIA_ID = '''||fecha||'''';
      commit;
    end if;

 commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 7', 4;

  --  execute immediate  'update H_CNT h set h.FECHA_CREACION_CONTRATO = (select TO_DATE(CNT.CNT_FECHA_CREACION) from '||V_DATASTAGE||'.CNT_CONTRATOS CNT where h.DIA_ID = '''||fecha||''' and h.CONTRATO_ID = CNT.CNT_ID)';

    update TMP_H_CNT set T_SALDO_TOTAL_CNT_ID = (case when SALDO_TOTAL >= 0 and SALDO_TOTAL <= 30000 then 0
                                                      when SALDO_TOTAL > 30000 and SALDO_TOTAL <= 60000 then 1
                                                      when SALDO_TOTAL > 60000 and SALDO_TOTAL <= 90000 then 2
                                                      when SALDO_TOTAL > 90000 and SALDO_TOTAL <= 120000 then 3
                                                      when SALDO_TOTAL > 120000 and SALDO_TOTAL <= 150000 then 4
                                                      when SALDO_TOTAL > 150000 and SALDO_TOTAL <= 180000 then 5
                                                      when SALDO_TOTAL > 180000 and SALDO_TOTAL <= 300000 then 6
                                                      when SALDO_TOTAL > 300000 and SALDO_TOTAL <= 400000 then 7
                                                      when SALDO_TOTAL > 400000 then 8
                                                      else -1 end) where DIA_ID = fecha;
    commit;
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 8', 4;

    update TMP_H_CNT set T_SALDO_IRREGULAR_CNT_ID = (case when POS_VIVA_VENC >= 0 and POS_VIVA_VENC <= 25000 then 0
                                                          when POS_VIVA_VENC > 25000 and POS_VIVA_VENC <= 50000 then 1
                                                          when POS_VIVA_VENC > 50000 and POS_VIVA_VENC <= 75000 then 2
                                                          when POS_VIVA_VENC > 75000 then 3
                                                          else -1 end) where DIA_ID = fecha;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 9', 4;

    update TMP_H_CNT set T_DEUDA_IRREGULAR_CNT_ID = (case when DEUDA_IRREGULAR >= 0 and DEUDA_IRREGULAR <= 30000 then 0
                                                          when DEUDA_IRREGULAR > 30000 and DEUDA_IRREGULAR <= 60000 then 1
                                                          when DEUDA_IRREGULAR > 60000 and DEUDA_IRREGULAR <= 90000 then 2
                                                          when DEUDA_IRREGULAR > 90000 and DEUDA_IRREGULAR <= 120000 then 3
                                                          when DEUDA_IRREGULAR > 120000 and DEUDA_IRREGULAR <= 150000 then 4
                                                          when DEUDA_IRREGULAR > 150000 and DEUDA_IRREGULAR <= 180000 then 5
                                                          when DEUDA_IRREGULAR > 180000 and DEUDA_IRREGULAR <= 300000 then 6
                                                          when DEUDA_IRREGULAR > 300000 and DEUDA_IRREGULAR <= 400000 then 7
                                                          when DEUDA_IRREGULAR > 400000 then 8
                                                          else -1 end) where DIA_ID = fecha;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Update 10', 4;

    -- Borrado indices TMP_CNT_EXPEDIENTE_IX


	   
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_EXPEDIENTE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
		 
    commit;



 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_EXPEDIENTE'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

    -- Contratos en ciclo de recobro
    execute immediate 'insert into TMP_CNT_EXPEDIENTE
        (CONTRATO_ID,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_SALIDA_AGENCIA_EXP,
         ESQUEMA_CONTRATO_ID,
         AGENCIA_CONTRATO_ID,
         SUBCARTERA_EXPEDIENTE_CNT_ID,
         TIPO_SALIDA_EXP_CNT_ID,
         MOTIVO_SALIDA_EXP_CNT_ID,
         TIPO_INCIDENCIA_EXP_CNT_ID,
         ESTADO_INCIDENCIA_EXP_CNT_ID
        )
    select crc.CNT_ID,
           cre.EXP_ID,
           h.FECHA_CREACION_EXPEDIENTE,
           h.FECHA_ROTURA_EXPEDIENTE,
           h.FECHA_SALIDA_AGENCIA_EXP,
           h.ESQUEMA_EXPEDIENTE_ID,
           h.AGENCIA_EXPEDIENTE_ID,
           h.SUBCARTERA_EXPEDIENTE_ID,
           h.TIPO_SALIDA_ID,
           h.MOTIVO_SALIDA_ID,
           h.TIPO_INCIDENCIA_ID,
           h.ESTADO_INCIDENCIA_ID
    from '||V_DATASTAGE||'.CRC_CICLO_RECOBRO_CNT crc, '||V_DATASTAGE||'.CRE_CICLO_RECOBRO_EXP cre,
        (select EXPEDIENTE_ID, FECHA_ENTRADA_AGENCIA_EXP, FECHA_CREACION_EXPEDIENTE, FECHA_ROTURA_EXPEDIENTE, FECHA_SALIDA_AGENCIA_EXP, ESQUEMA_EXPEDIENTE_ID,
                          AGENCIA_EXPEDIENTE_ID, SUBCARTERA_EXPEDIENTE_ID, TIPO_SALIDA_ID, MOTIVO_SALIDA_ID, TIPO_INCIDENCIA_ID, ESTADO_INCIDENCIA_ID
                      from H_EXP where DIA_ID = '''||fecha||''') h
    where crc.CRE_ID = cre.CRE_ID and cre.EXP_ID = h.EXPEDIENTE_ID and '''||fecha||''' >= trunc(CRC_FECHA_ALTA) and (trunc(CRC_FECHA_BAJA) >= '''||fecha||''' or CRC_FECHA_BAJA is null)
    and h.FECHA_ENTRADA_AGENCIA_EXP = (select max(h2.FECHA_ENTRADA_AGENCIA_EXP) from H_EXP h2 where h2.EXPEDIENTE_ID = h.EXPEDIENTE_ID and h2.DIA_ID = '''||fecha||''')
    and crc.CRC_FECHA_ALTA = (select max(crc2.CRC_FECHA_ALTA) from '||V_DATASTAGE||'.CRC_CICLO_RECOBRO_CNT crc2 where crc2.CNT_ID = crc.CNT_ID)';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_EXPEDIENTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Resto de contratos
    execute immediate ' insert into TMP_CNT_EXPEDIENTE
        (CONTRATO_ID,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_ROTURA_EXPEDIENTE,
         FECHA_SALIDA_AGENCIA_EXP,
         ESQUEMA_CONTRATO_ID,
         AGENCIA_CONTRATO_ID,
         SUBCARTERA_EXPEDIENTE_CNT_ID,
         TIPO_SALIDA_EXP_CNT_ID,
         MOTIVO_SALIDA_EXP_CNT_ID,
         TIPO_INCIDENCIA_EXP_CNT_ID,
         ESTADO_INCIDENCIA_EXP_CNT_ID
        )
    select CNT_ID,
           EXPEDIENTE_ID,
           FECHA_CREACION_EXPEDIENTE,
           FECHA_ROTURA_EXPEDIENTE,
           FECHA_SALIDA_AGENCIA_EXP,
           ESQUEMA_EXPEDIENTE_ID,
           AGENCIA_EXPEDIENTE_ID,
           SUBCARTERA_EXPEDIENTE_ID,
           TIPO_SALIDA_ID,
           MOTIVO_SALIDA_ID,
           TIPO_INCIDENCIA_ID,
           ESTADO_INCIDENCIA_ID
    from (select EXPEDIENTE_ID, FECHA_ENTRADA_AGENCIA_EXP, FECHA_CREACION_EXPEDIENTE, FECHA_ROTURA_EXPEDIENTE, FECHA_SALIDA_AGENCIA_EXP, ESQUEMA_EXPEDIENTE_ID,
                  AGENCIA_EXPEDIENTE_ID, SUBCARTERA_EXPEDIENTE_ID, TIPO_SALIDA_ID, MOTIVO_SALIDA_ID, TIPO_INCIDENCIA_ID, ESTADO_INCIDENCIA_ID
              from H_EXP where DIA_ID = '''||fecha||''') h,
          '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex
    where h.EXPEDIENTE_ID = cex.EXP_ID and  not exists (select 1 from TMP_CNT_EXPEDIENTE tmp where cex.CNT_ID = tmp.CONTRATO_ID)
    and h.FECHA_ENTRADA_AGENCIA_EXP = (select max(h2.FECHA_ENTRADA_AGENCIA_EXP) from H_EXP h2 where h2.EXPEDIENTE_ID = h.EXPEDIENTE_ID  and h2.DIA_ID = '''||fecha||''')';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_EXPEDIENTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    -- Crear indices TMP_CNT_EXPEDIENTE


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_EXPEDIENTE_IX'', ''TMP_CNT_EXPEDIENTE (CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    commit;

    --En el caso de tener varios expedientes abiertos para un contrato nos quedamos con el que tiene la fecha de creaci�n mas reciente
    delete from TMP_CNT_EXPEDIENTE a
    where exists (select 1 from TMP_CNT_EXPEDIENTE b where a.contrato_id = b.contrato_id and a.fecha_creacion_expediente < b.fecha_creacion_expediente);

    merge into TMP_H_CNT hc
    using (select CONTRATO_ID,
              max(EXPEDIENTE_ID) as MAX_EXPEDIENTE,
              max(FECHA_CREACION_EXPEDIENTE) as MAX_FECHA_CREACION_EXPEDIENTE,
              max(FECHA_ROTURA_EXPEDIENTE) as MAX_FECHA_ROTURA_EXPEDIENTE,
              max(ESQUEMA_CONTRATO_ID) as MAX_ESQUEMA_CONTRATO,
              max(AGENCIA_CONTRATO_ID) as MAX_AGENCIA_CONTRATO,
              max(SUBCARTERA_EXPEDIENTE_CNT_ID) as MAX_SUB_EXP_CNT,
              max(FECHA_SALIDA_AGENCIA_EXP) as MAX_FECHA_SALIDA_AG_EXP,
              max(TIPO_SALIDA_EXP_CNT_ID) as MAX_TIPO_SALIDA,
              max(MOTIVO_SALIDA_EXP_CNT_ID) as MAX_MOTIVO_SALIDA,
              max(TIPO_INCIDENCIA_EXP_CNT_ID) as MAX_TIPO_INC,
              max(ESTADO_INCIDENCIA_EXP_CNT_ID) as MAX_ESTADO_INC
            from TMP_CNT_EXPEDIENTE group by CONTRATO_ID) crc
    on (crc.CONTRATO_ID = hc.CONTRATO_ID)
    when matched then update
        set hc.EXPEDIENTE_ID = crc.MAX_EXPEDIENTE,
            hc.FECHA_CREACION_EXPEDIENTE = crc.MAX_FECHA_CREACION_EXPEDIENTE,
            hc.FECHA_ROTURA_EXPEDIENTE = crc.MAX_FECHA_ROTURA_EXPEDIENTE,
            hc.ESQUEMA_CONTRATO_ID = crc.MAX_ESQUEMA_CONTRATO,
            hc.AGENCIA_CONTRATO_ID = crc.MAX_AGENCIA_CONTRATO,
            hc.SUBCARTERA_EXPEDIENTE_CNT_ID = crc.MAX_SUB_EXP_CNT,
            hc.FECHA_SALIDA_AGENCIA_EXP = crc.MAX_FECHA_SALIDA_AG_EXP,
            hc.TIPO_SALIDA_EXP_CNT_ID = crc.MAX_TIPO_SALIDA,
            hc.MOTIVO_SALIDA_EXP_CNT_ID = crc.MAX_MOTIVO_SALIDA,
            hc.TIPO_INCIDENCIA_EXP_CNT_ID = crc.MAX_TIPO_INC,
            hc.ESTADO_INCIDENCIA_EXP_CNT_ID = crc.MAX_ESTADO_INC
        where hc.DIA_ID = fecha;

    commit;
	
/* PERÍMETRO  DE GESTIÓN , En función de si el contrato está judicializado y de si tiene agencia_id
  1. Sin gestión: contratos que no están siendo gestionados, por lo tanto no están en ninguno de los grupos siguiente.
  2. Expediente Seguimiento: el contrato está en un expediente de tipo seguimiento
  3. Expediente Recuperación: el contrato está en un expediente de tipo recuperación.
  4. Gestión Extrajudicial (amistosa): Contratos que están enviados a agencias
  5. Gestión Precontenciosa: contrato que está dentro de un asunto prejudicial.
  6. Gestión Judicial: contrato que está en un asunto de tipo Litigio (es decir en cualquier tipo de procedimiento agrupado menos en concursal)
  7. Gestión Concursal: contratos que están dentro de un concurso (tipo de procedimiento agrupado de dicho asunto es Concursal)
  */
    merge into TMP_H_CNT h
    using (select distinct c.CONTRATO_ID
            from H_PRC p
            join H_PRC_DET_CONTRATO c on p.PROCEDIMIENTO_ID = c.PROCEDIMIENTO_ID and p.DIA_ID = c.DIA_ID
            where c.DIA_ID = fecha and FASE_ACTUAL_AGR_ID in (10,11)) hprc
    on (h.CONTRATO_ID = hprc.CONTRATO_ID)
    when matched then update set h.PERIMETRO_GES_CONCU_ID = 1
    where h.DIA_ID = fecha;
    commit;
    

   -- 5. Gestión Precontenciosa: contrato que está dentro de un asunto prejudicial.
    execute immediate 'merge into TMP_H_CNT h 
    using (select distinct CNT_ID
           from '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex 
           join '||V_DATASTAGE||'.PRC_CEX pcex on cex.CEX_ID = pcex.CEX_ID
           join H_PRE pre on pre.PROCEDIMIENTO_ID = pcex.PRC_ID
           where pre.DIA_ID = '''||fecha||'''
           AND NOT EXISTS (SELECT 1
                      FROM '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS PCO, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP HEP
                      WHERE PCO.PCO_PRC_ID = HEP.PCO_PRC_ID
                      AND DD_PCO_PEP_ID IN (SELECT DD_PCO_PEP_ID FROM '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO IN (''FI''))
                      AND PCO_PRC_HEP_FECHA_FIN IS NULL
                      AND PCO.PRC_ID = PCEX.PRC_ID)
			) hprc
    on (h.CONTRATO_ID = hprc.CNT_ID)
    when matched then update set h.PERIMETRO_GES_PRE_ID = 1
    where h.DIA_ID = '''||fecha||'''';
    commit;
    


    -- 6. Gestión Judicial: contrato que está en un asunto de tipo Litigio (es decir en cualquier tipo de procedimiento agrupado menos en concursal)
    merge into TMP_H_CNT h
    using (select distinct c.CONTRATO_ID
            from H_PRC p
            join H_PRC_DET_CONTRATO c on p.PROCEDIMIENTO_ID = c.PROCEDIMIENTO_ID and p.DIA_ID = c.DIA_ID
            where c.DIA_ID = fecha and FASE_ACTUAL_AGR_ID not in (10,11)) hprc
    on (h.CONTRATO_ID = hprc.CONTRATO_ID)
    when matched then update set h.PERIMETRO_GES_JUDI_ID = 1
    where h.DIA_ID = fecha and h.PERIMETRO_GES_PRE_ID<>1;
    commit;
    

	

    -- 4. Gestión Extrajudicial (amistosa): Contratos que están enviados a agencias
    update TMP_H_CNT set PERIMETRO_GES_EXTRA_ID = 1 where AGENCIA_CONTRATO_ID is not null and AGENCIA_CONTRATO_ID <> -1 and DIA_ID = fecha;
    commit;
    


    -- 3. Expediente Recuperación: el contrato está en un expediente de tipo recuperación.
    execute immediate 'merge into TMP_H_CNT h 
    using (select distinct CNT_ID
           from '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex 
           join '||V_DATASTAGE||'.EXP_EXPEDIENTES exp on cex.EXP_ID = exp.EXP_ID
           where DD_TPX_ID = 21 and DD_EEX_ID <> 4) hprc
    on (h.CONTRATO_ID = hprc.CNT_ID)
    when matched then update set h.PERIMETRO_EXP_REC_ID = 1
    where h.DIA_ID = '''||fecha||'''';
    commit;
    

    
    -- 2. Expediente Seguimiento: el contrato está en un expediente de tipo seguimiento
    execute immediate 'merge into TMP_H_CNT h 
    using (select distinct CNT_ID
           from '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex 
           join '||V_DATASTAGE||'.EXP_EXPEDIENTES exp on cex.EXP_ID = exp.EXP_ID
           where DD_TPX_ID = 22) hprc
    on (h.CONTRATO_ID = hprc.CNT_ID)
    when matched then update set h.PERIMETRO_EXP_SEG_ID = 1
    where h.DIA_ID = '''||fecha||'''';
    commit;
    


    -- 1. Sin gestión: contratos que no están siendo gestionados, por lo tanto no están en ninguno de los grupos siguiente.
    update TMP_H_CNT set PERIMETRO_SIN_GESTION_ID = 1 
    where PERIMETRO_GES_CONCU_ID = 0 and
          PERIMETRO_GES_JUDI_ID = 0 and 
          PERIMETRO_GES_PRE_ID = 0 and
          PERIMETRO_GES_EXTRA_ID = 0 and 
          PERIMETRO_EXP_REC_ID = 0 and
          PERIMETRO_EXP_SEG_ID = 0    
          and DIA_ID = fecha;
    commit;
    

        
    update TMP_H_CNT set PERIMETRO_GESTION_ID = (case when PERIMETRO_GES_CONCU_ID = 1 then 7
                                                      when PERIMETRO_GES_JUDI_ID = 1 then 6
                                                      when PERIMETRO_GES_PRE_ID = 1 then 5
                                                      when PERIMETRO_GES_EXTRA_ID = 1 then 4
                                                      when PERIMETRO_EXP_REC_ID = 1 then 3
                                                      when PERIMETRO_EXP_SEG_ID = 1 then 2
                                                      when PERIMETRO_SIN_GESTION_ID = 1 then 1
                                                      else -1 end);
    commit;

       -- Borrado indices TMP_CNT_ACCIONES


         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_ACCIONES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_ACCIONES. Termina Borrado de Indices', 4;



 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_ACCIONES'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
    execute immediate 'insert into TMP_CNT_ACCIONES
            (CONTRATO,
             FECHA_ACCION,
             FECHA_COMPROMETIDA_PAGO,
             IMPORTE_COMPROMETIDO,
             TIPO_ACCION,
             RESULTADO_GESTION
             )
    select SUBSTR(ACE_ENVIO_ID, 9, LENGTH(ACE_ENVIO_ID)),
           ACE_FECHA_GESTION,
           ACE_FECHA_PAGO_COMPROMETIDO,
           ACE_IMPORTE_COMPROMETIDO,
           DD_TGE_ID,
           DD_RGT_ID
      from ' || V_DATASTAGE || '.ACE_ACCIONES_EXTRAJUDICIALES
      where ACE_FECHA_GESTION <= ''' || fecha || '''';

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_ACCIONES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices TMP_CNT_ACCIONES


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_ACCIONES_IX'', ''TMP_CNT_ACCIONES (CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_ACCIONES. Termina Creaci�n de Indices', 4;


    -- Asignaci�n de prioridades: 1 NO CORRESPONDE CON EL DEUDOR - 9 PROMESA PAGO TOTAL
    update TMP_CNT_ACCIONES set PRIORIDAD_GESTION = (case when RESULTADO_GESTION = 7 then 1
                                                            when RESULTADO_GESTION = 6 then 2
                                                            when RESULTADO_GESTION = 3 then 3
                                                            when RESULTADO_GESTION = 2 then 4
                                                            when RESULTADO_GESTION = 4 then 5
                                                            when RESULTADO_GESTION = 5 then 6
                                                            when RESULTADO_GESTION = 1 then 7
                                                            when RESULTADO_GESTION = 8 then 8
                                                            when RESULTADO_GESTION = 9 then 9
                                                            else -1 end);
    commit;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_ACCIONES. Termina Updates(1)', 4;

    merge into TMP_H_CNT a
    using (select CONTRATO,
              max(FECHA_COMPROMETIDA_PAGO) as FECHA_COMPROMETIDA_PAGO,
              max(PRIORIDAD_GESTION) as PRIORIDAD_GESTION
            from TMP_CNT_ACCIONES group by CONTRATO) b
    on (b.CONTRATO = a.CONTRATO_ID)
    when matched then update
        set a.FECHA_COMPROMETIDA_PAGO = b.FECHA_COMPROMETIDA_PAGO,
            a.MAX_PRIORIDAD_ACTUACION = b.PRIORIDAD_GESTION;
    commit;

    merge into TMP_H_CNT a
    using (select CONTRATO,
              FECHA_COMPROMETIDA_PAGO,
              max(IMPORTE_COMPROMETIDO) as IMPORTE_COMPROMETIDO
            from TMP_CNT_ACCIONES group by CONTRATO, FECHA_COMPROMETIDA_PAGO) b
    on (b.CONTRATO = a.CONTRATO_ID and b.FECHA_COMPROMETIDA_PAGO = a.FECHA_COMPROMETIDA_PAGO)
    when matched then update
        set a.IMPORTE_COMPROMETIDO = b.IMPORTE_COMPROMETIDO;
    commit;

    merge into TMP_H_CNT a
    using (select CONTRATO,
              PRIORIDAD_GESTION,
              max(FECHA_ACCION) as FECHA_ACCION,
              max(TIPO_ACCION) as TIPO_ACCION,
              max(RESULTADO_GESTION) as RESULTADO_GESTION
            from TMP_CNT_ACCIONES group by CONTRATO, PRIORIDAD_GESTION) b
    on (b.CONTRATO = a.CONTRATO_ID and b.PRIORIDAD_GESTION = a.MAX_PRIORIDAD_ACTUACION)
    when matched then update
        set a.FECHA_ACCION = b.FECHA_ACCION,
            a.TIPO_ACCION_ID = b.TIPO_ACCION,
            a.RESULTADO_GESTION_ID = b.RESULTADO_GESTION;

   update TMP_H_CNT set TIPO_ACCION_ID = -1 where TIPO_ACCION_ID IS NULL;
   update TMP_H_CNT set RESULTADO_GESTION_ID = -1 where RESULTADO_GESTION_ID IS NULL;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_CNT. Termina Updates(11)', 4;

    commit;   
    -- Borrado indices H_CNT
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
     -- Borrado del d�a a insertar
    delete from H_CNT where DIA_ID = fecha;
    commit;

    insert into H_CNT
        (DIA_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        CLASIFICACION_CNT_ID,
        SEGMENTO_CARTERA_ID,
        ENVIADO_AGENCIA_CNT_ID,
        SITUACION_CNT_DETALLE_ID,
        SITUACION_ANT_CNT_DETALLE_ID,
        SITUACION_RESP_PER_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CNT_ID,
        ESTADO_FINANCIERO_ANT_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CNT_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        T_IRREG_DIAS_ID,
        T_IRREG_DIAS_PERIODO_ANT_ID,
        TRAMO_ANTIGUEDAD_DEUDA_ID,
        T_IRREG_FASES_ID,
        TD_EN_GESTION_A_COBRO_ID,
        TD_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CNT_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CNT_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CNT_CON_CONTACTO_UTIL_ID,
        CNT_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CNT_CON_PREV_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREV_SITUACION_INICIAL_ID,
        PREV_SITUACION_AUTO_ID,
        PREV_SITUACION_MANUAL_ID,
        PREV_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPEC_ID,
        SUPERVISOR_N2_ESPEC_ID,
        SUPERVISOR_N3_ESPEC_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CNT_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        FECHA_CONSTITUCION_CONTRATO ,
        FECHA_CAMBIO_TRAMO,
        FECHA_ALTA_DUDOSO,
        FECHA_BAJA_DUDOSO,
        T_SALDO_TOTAL_CNT_ID,
        T_SALDO_IRREGULAR_CNT_ID,
        T_DEUDA_IRREGULAR_CNT_ID,
        TRAMO_RIESGO_CNT_ID,
        TA_FECHA_CREACION_ID,
        PERIMETRO_GESTION_ID,
        PERIMETRO_SIN_GESTION_ID,
        PERIMETRO_EXP_SEG_ID,
        PERIMETRO_EXP_REC_ID,
        PERIMETRO_GES_EXTRA_ID,
        PERIMETRO_GES_PRE_ID,
        PERIMETRO_GES_JUDI_ID,
        PERIMETRO_GES_CONCU_ID,  
        MOTIVO_ALTA_DUDOSO_ID,
        MOTIVO_BAJA_DUDOSO_ID,
        SIT_CART_DANADA_ID,
        TIPO_GESTION_EXP_ID,
        EXPEDIENTE_ID,
        FECHA_CREACION_EXPEDIENTE,
        FECHA_ROTURA_EXPEDIENTE,
        FECHA_SALIDA_AGENCIA_EXP,
        ESQUEMA_CONTRATO_ID,
        AGENCIA_CONTRATO_ID,
        SUBCARTERA_EXPEDIENTE_CNT_ID,
        TIPO_SALIDA_EXP_CNT_ID,
        MOTIVO_SALIDA_EXP_CNT_ID,
        TIPO_INCIDENCIA_EXP_CNT_ID,
        ESTADO_INCIDENCIA_EXP_CNT_ID,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        NUM_DIAS_VENC_PERIODO_ANT,
        SALDO_TOTAL,
        RIESGO_VIVO,
        POS_VIVA_NO_VENC,
        POS_VIVA_VENC,
        SALDO_DUDOSO,
        PROVISION,
        INT_REMUNERATORIOS,
        INT_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        CAPITAL_VIVO,
        IMPORTE_PTE_DIFER,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACT_REC_ACUMULADO,
        NUM_ACT_REC_CONTACTO_UTIL,
        NUM_ACT_REC_CONTACTO_UTIL_ACU,
        IMP_IRREGULAR_PREV_INICIO,
        IMP_IRREGULAR_PREV_AUTO,
        IMP_IRREGULAR_PREV_MANUAL,
        IMP_IRREGULAR_PREV_FINAL,
        IMP_RIESGO_PREV_INICIO,
        IMP_RIESGO_PREV_AUTO,
        IMP_RIESGO_PREV_MANUAL,
        IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
        )
    select DIA_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        CLASIFICACION_CNT_ID,
        SEGMENTO_CARTERA_ID,
        ENVIADO_AGENCIA_CNT_ID,
        SITUACION_CNT_DETALLE_ID,
        SITUACION_ANT_CNT_DETALLE_ID,
        SITUACION_RESP_PER_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CNT_ID,
        ESTADO_FINANCIERO_ANT_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CNT_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        T_IRREG_DIAS_ID,
        T_IRREG_DIAS_PERIODO_ANT_ID,
        TRAMO_ANTIGUEDAD_DEUDA_ID,
        T_IRREG_FASES_ID,
        TD_EN_GESTION_A_COBRO_ID,
        TD_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CNT_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CNT_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CNT_CON_CONTACTO_UTIL_ID,
        CNT_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CNT_CON_PREV_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREV_SITUACION_INICIAL_ID,
        PREV_SITUACION_AUTO_ID,
        PREV_SITUACION_MANUAL_ID,
        PREV_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPEC_ID,
        SUPERVISOR_N2_ESPEC_ID,
        SUPERVISOR_N3_ESPEC_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CNT_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        FECHA_CONSTITUCION_CONTRATO ,
        FECHA_CAMBIO_TRAMO ,
        FECHA_ALTA_DUDOSO ,
        FECHA_BAJA_DUDOSO  ,
        T_SALDO_TOTAL_CNT_ID,
        T_SALDO_IRREGULAR_CNT_ID,
        T_DEUDA_IRREGULAR_CNT_ID,
        TRAMO_RIESGO_CNT_ID,
        TA_FECHA_CREACION_ID,
        PERIMETRO_GESTION_ID,
        PERIMETRO_SIN_GESTION_ID,
        PERIMETRO_EXP_SEG_ID,
        PERIMETRO_EXP_REC_ID,
        PERIMETRO_GES_EXTRA_ID,
        PERIMETRO_GES_PRE_ID,
        PERIMETRO_GES_JUDI_ID,
        PERIMETRO_GES_CONCU_ID,  
        -1,
        -1,
        SIT_CART_DANADA_ID,
        TIPO_GESTION_EXP_ID,
        EXPEDIENTE_ID,
        FECHA_CREACION_EXPEDIENTE,
        FECHA_ROTURA_EXPEDIENTE,
        FECHA_SALIDA_AGENCIA_EXP,
        ESQUEMA_CONTRATO_ID,
        AGENCIA_CONTRATO_ID,
        SUBCARTERA_EXPEDIENTE_CNT_ID,
        TIPO_SALIDA_EXP_CNT_ID,
        MOTIVO_SALIDA_EXP_CNT_ID,
        TIPO_INCIDENCIA_EXP_CNT_ID,
        ESTADO_INCIDENCIA_EXP_CNT_ID,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        NUM_DIAS_VENC_PERIODO_ANT,
        SALDO_TOTAL,
        RIESGO_VIVO,
        POS_VIVA_NO_VENC,
        POS_VIVA_VENC,
        SALDO_DUDOSO,
        PROVISION,
        INT_REMUNERATORIOS,
        INT_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NULL,
        NULL,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACT_REC_ACUMULADO,
        NUM_ACT_REC_CONTACTO_UTIL,
        NUM_ACT_REC_CONTACTO_UTIL_ACU,
        IMP_IRREGULAR_PREV_INICIO,
        IMP_IRREGULAR_PREV_AUTO,
        IMP_IRREGULAR_PREV_MANUAL,
        IMP_IRREGULAR_PREV_FINAL,
        IMP_RIESGO_PREV_INICIO,
        IMP_RIESGO_PREV_AUTO,
        IMP_RIESGO_PREV_MANUAL,
        IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
    from TMP_H_CNT where DIA_ID = fecha;

     V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;









   
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    end loop;
  close c_fecha;

  -- Crear indices H_CNT


 
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_IX'', ''H_CNT (DIA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;


  -- -------------------------- C�LCULO DEL RESTO DE PERIODOS ----------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   
  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_CNT;
  commit;
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_SEMANA. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start
  select max(SEMANA_ID) into V_NUMBER from H_CNT_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX)
    select max(SEMANA_ID) from H_CNT_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
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

    -- Borrado indices H_CNT_SEMANA


         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
    commit;

    -- Borrado de las semanas a insertar
    delete from H_CNT_SEMANA where SEMANA_ID = semana;
    commit;

    -- /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */
    insert into H_CNT_SEMANA
        (SEMANA_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        CLASIFICACION_CNT_ID,
        SEGMENTO_CARTERA_ID,
        ENVIADO_AGENCIA_CNT_ID,
        SITUACION_CNT_DETALLE_ID,
        SITUACION_ANT_CNT_DETALLE_ID,
        SITUACION_RESP_PER_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CNT_ID,
        ESTADO_FINANCIERO_ANT_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CNT_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        T_IRREG_DIAS_ID,
        TRAMO_ANTIGUEDAD_DEUDA_ID,
        T_IRREG_FASES_ID,
        TD_EN_GESTION_A_COBRO_ID,
        TD_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CNT_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CNT_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CNT_CON_CONTACTO_UTIL_ID,
        CNT_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CNT_CON_PREV_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREV_SITUACION_INICIAL_ID,
        PREV_SITUACION_AUTO_ID,
        PREV_SITUACION_MANUAL_ID,
        PREV_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPEC_ID,
        SUPERVISOR_N2_ESPEC_ID,
        SUPERVISOR_N3_ESPEC_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CNT_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        FECHA_CONSTITUCION_CONTRATO ,
        FECHA_CAMBIO_TRAMO ,
        FECHA_ALTA_DUDOSO ,
        FECHA_BAJA_DUDOSO  ,
        T_SALDO_TOTAL_CNT_ID,
        T_SALDO_IRREGULAR_CNT_ID,
        T_DEUDA_IRREGULAR_CNT_ID,
        TRAMO_RIESGO_CNT_ID,
        TA_FECHA_CREACION_ID,
        PERIMETRO_GESTION_ID,
        PERIMETRO_SIN_GESTION_ID,
        PERIMETRO_EXP_SEG_ID,
        PERIMETRO_EXP_REC_ID,
        PERIMETRO_GES_EXTRA_ID,
        PERIMETRO_GES_PRE_ID,
        PERIMETRO_GES_JUDI_ID,
        PERIMETRO_GES_CONCU_ID,  
        MOTIVO_ALTA_DUDOSO_ID,
        MOTIVO_BAJA_DUDOSO_ID,
        SIT_CART_DANADA_ID,
        TIPO_GESTION_EXP_ID,
        EXPEDIENTE_ID,
        FECHA_CREACION_EXPEDIENTE,
        FECHA_ROTURA_EXPEDIENTE,
        FECHA_SALIDA_AGENCIA_EXP,
        ESQUEMA_CONTRATO_ID,
        AGENCIA_CONTRATO_ID,
        SUBCARTERA_EXPEDIENTE_CNT_ID,
        TIPO_SALIDA_EXP_CNT_ID,
        MOTIVO_SALIDA_EXP_CNT_ID,
        TIPO_INCIDENCIA_EXP_CNT_ID,
        ESTADO_INCIDENCIA_EXP_CNT_ID,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        RIESGO_VIVO,
        POS_VIVA_NO_VENC,
        POS_VIVA_VENC,
        SALDO_DUDOSO,
        PROVISION,
        INT_REMUNERATORIOS,
        INT_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        CAPITAL_VIVO,
        IMPORTE_PTE_DIFER,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACT_REC_ACUMULADO,
        NUM_ACT_REC_CONTACTO_UTIL,
        NUM_ACT_REC_CONTACTO_UTIL_ACU,
        IMP_IRREGULAR_PREV_INICIO,
        IMP_IRREGULAR_PREV_AUTO,
        IMP_IRREGULAR_PREV_MANUAL,
        IMP_IRREGULAR_PREV_FINAL,
        IMP_RIESGO_PREV_INICIO,
        IMP_RIESGO_PREV_AUTO,
        IMP_RIESGO_PREV_MANUAL,
        IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
        )
    select semana,
        max_dia_semana,
        CONTRATO_ID,
        CLASIFICACION_CNT_ID,
        SEGMENTO_CARTERA_ID,
        ENVIADO_AGENCIA_CNT_ID,
        SITUACION_CNT_DETALLE_ID,
        SITUACION_ANT_CNT_DETALLE_ID,
        SITUACION_RESP_PER_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CNT_ID,
        ESTADO_FINANCIERO_ANT_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CNT_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        T_IRREG_DIAS_ID,
        TRAMO_ANTIGUEDAD_DEUDA_ID,
        T_IRREG_FASES_ID,
        TD_EN_GESTION_A_COBRO_ID,
        TD_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CNT_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CNT_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CNT_CON_CONTACTO_UTIL_ID,
        CNT_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CNT_CON_PREV_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREV_SITUACION_INICIAL_ID,
        PREV_SITUACION_AUTO_ID,
        PREV_SITUACION_MANUAL_ID,
        PREV_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPEC_ID,
        SUPERVISOR_N2_ESPEC_ID,
        SUPERVISOR_N3_ESPEC_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CNT_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        FECHA_CONSTITUCION_CONTRATO ,
        FECHA_CAMBIO_TRAMO ,
        FECHA_ALTA_DUDOSO ,
        FECHA_BAJA_DUDOSO  ,
        T_SALDO_TOTAL_CNT_ID,
        T_SALDO_IRREGULAR_CNT_ID,
        T_DEUDA_IRREGULAR_CNT_ID,
        TRAMO_RIESGO_CNT_ID,
        TA_FECHA_CREACION_ID,
        PERIMETRO_GESTION_ID,
        PERIMETRO_SIN_GESTION_ID,
        PERIMETRO_EXP_SEG_ID,
        PERIMETRO_EXP_REC_ID,
        PERIMETRO_GES_EXTRA_ID,
        PERIMETRO_GES_PRE_ID,
        PERIMETRO_GES_JUDI_ID,
        PERIMETRO_GES_CONCU_ID,  
        MOTIVO_ALTA_DUDOSO_ID,
        MOTIVO_BAJA_DUDOSO_ID,
        SIT_CART_DANADA_ID,
        TIPO_GESTION_EXP_ID,
        EXPEDIENTE_ID,
        FECHA_CREACION_EXPEDIENTE,
        FECHA_ROTURA_EXPEDIENTE,
        FECHA_SALIDA_AGENCIA_EXP,
        ESQUEMA_CONTRATO_ID,
        AGENCIA_CONTRATO_ID,
        SUBCARTERA_EXPEDIENTE_CNT_ID,
        TIPO_SALIDA_EXP_CNT_ID,
        MOTIVO_SALIDA_EXP_CNT_ID,
        TIPO_INCIDENCIA_EXP_CNT_ID,
        ESTADO_INCIDENCIA_EXP_CNT_ID,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        RIESGO_VIVO,
        POS_VIVA_NO_VENC,
        POS_VIVA_VENC,
        SALDO_DUDOSO,
        PROVISION,
        INT_REMUNERATORIOS,
        INT_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        CAPITAL_VIVO,
        IMPORTE_PTE_DIFER,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACT_REC_ACUMULADO,
        NUM_ACT_REC_CONTACTO_UTIL,
        NUM_ACT_REC_CONTACTO_UTIL_ACU,
        IMP_IRREGULAR_PREV_INICIO,
        IMP_IRREGULAR_PREV_AUTO,
        IMP_IRREGULAR_PREV_MANUAL,
        IMP_IRREGULAR_PREV_FINAL,
        IMP_RIESGO_PREV_INICIO,
        IMP_RIESGO_PREV_AUTO,
        IMP_RIESGO_PREV_MANUAL,
        IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
    from H_CNT where DIA_ID = max_dia_semana; -- and SITUACION_RESP_PER_ANT_ID <> 2;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;


    -- Crear indices H_CNT_SEMANA


     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_SEMANA_IX'', ''H_CNT_SEMANA (SEMANA_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    commit;

    select max(SEMANA_ID) into semana_periodo_ant from D_F_SEMANA where SEMANA_ID < semana;

    merge into H_CNT_SEMANA dc
    using (select NUM_DIAS_VENCIDOS, T_IRREG_DIAS_ID, CONTRATO_ID from H_CNT_SEMANA where SEMANA_ID = semana_periodo_ant) cf
    on (cf.CONTRATO_ID = dc.CONTRATO_ID)
    when matched then update set  dc.NUM_DIAS_VENC_PERIODO_ANT = cf.NUM_DIAS_VENCIDOS,
                                  dc.T_IRREG_DIAS_PERIODO_ANT_ID = cf.T_IRREG_DIAS_ID where dc.SEMANA_ID = semana;
    commit;

  end loop C_SEMANAS_LOOP;
close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_SEMANA. Termina bucle', 3;

  


-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_MES. Empieza bucle', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_CNT_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);

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

      -- Borrado indices H_CNT_MES


         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   
      commit;

      -- Borrado de los meses a insertar
      delete from H_CNT_MES where MES_ID = mes;
      commit;

      insert into H_CNT_MES
          (MES_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          CLASIFICACION_CNT_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          SITUACION_CNT_DETALLE_ID,
          SITUACION_ANT_CNT_DETALLE_ID,
          SITUACION_RESP_PER_ANT_ID,
          DIA_POS_VENCIDA_ID,
          DIA_SALDO_DUDOSO_ID,
          ESTADO_FINANCIERO_CNT_ID,
          ESTADO_FINANCIERO_ANT_ID,
          ESTADO_CONTRATO_ID,
          CONTRATO_JUDICIALIZADO_ID,
          ESTADO_INSINUACION_CNT_ID,
          EN_GESTION_RECOBRO_ID,
          FECHA_ALTA_GESTION_RECOBRO,
          FECHA_BAJA_GESTION_RECOBRO,
          FECHA_COMPROMETIDA_PAGO,
          FECHA_DPS,
          T_IRREG_DIAS_ID,
          TRAMO_ANTIGUEDAD_DEUDA_ID,
          T_IRREG_FASES_ID,
          TD_EN_GESTION_A_COBRO_ID,
          TD_IRREGULAR_A_COBRO_ID,
          RESULTADO_ACTUACION_CNT_ID,
          MODELO_RECOBRO_CONTRATO_ID,
          PROVEEDOR_RECOBRO_CNT_ID,
          CONTRATO_EN_IRREGULAR_ID,
          CONTRATO_CON_DPS_ID,
          CNT_CON_CONTACTO_UTIL_ID,
          CNT_CON_ACTUACION_RECOBRO_ID,
          EN_GESTION_ESPECIALIZADA_ID,
          CONTRATO_CON_PREVISION_ID,
          CNT_CON_PREV_REVISADA_ID ,
          TIPO_PREVISION_ID,
          PREV_SITUACION_INICIAL_ID,
          PREV_SITUACION_AUTO_ID,
          PREV_SITUACION_MANUAL_ID,
          PREV_SITUACION_FINAL_ID,
          MOTIVO_PREVISION_ID,
          SITUACION_ESPECIALIZADA_ID,
          GESTOR_ESPECIALIZADA_ID,
          SUPERVISOR_N1_ESPEC_ID,
          SUPERVISOR_N2_ESPEC_ID,
          SUPERVISOR_N3_ESPEC_ID,
          EN_CARTERA_ESTUDIO_ID,
          MODELO_GESTION_CARTERA_ID,
          UNIDAD_GESTION_CARTERA_ID,
          CNT_CON_CAPITAL_FALLIDO_ID,
          TIPO_GESTION_CONTRATO_ID,
          FECHA_CREACION_CONTRATO,
          FECHA_CONSTITUCION_CONTRATO ,
          FECHA_CAMBIO_TRAMO ,
          FECHA_ALTA_DUDOSO ,
          FECHA_BAJA_DUDOSO  ,
          T_SALDO_TOTAL_CNT_ID,
          T_SALDO_IRREGULAR_CNT_ID,
          T_DEUDA_IRREGULAR_CNT_ID,
          TRAMO_RIESGO_CNT_ID,
          TA_FECHA_CREACION_ID,
          PERIMETRO_GESTION_ID,
          PERIMETRO_SIN_GESTION_ID,
          PERIMETRO_EXP_SEG_ID,
          PERIMETRO_EXP_REC_ID,
          PERIMETRO_GES_EXTRA_ID,
          PERIMETRO_GES_PRE_ID,
          PERIMETRO_GES_JUDI_ID,
          PERIMETRO_GES_CONCU_ID,  
          MOTIVO_ALTA_DUDOSO_ID,
          MOTIVO_BAJA_DUDOSO_ID,
          SIT_CART_DANADA_ID,
          TIPO_GESTION_EXP_ID,
          EXPEDIENTE_ID,
          FECHA_CREACION_EXPEDIENTE,
          FECHA_ROTURA_EXPEDIENTE,
          FECHA_SALIDA_AGENCIA_EXP,
          ESQUEMA_CONTRATO_ID,
          AGENCIA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          TIPO_SALIDA_EXP_CNT_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          TIPO_INCIDENCIA_EXP_CNT_ID,
          ESTADO_INCIDENCIA_EXP_CNT_ID,
          NUM_CONTRATOS,
          NUM_CLIENTES_ASOCIADOS,
          NUM_EXPEDIENTES_ASOCIADOS,
          NUM_DIAS_VENCIDOS,
          SALDO_TOTAL,
          RIESGO_VIVO,
          POS_VIVA_NO_VENC,
          POS_VIVA_VENC,
          SALDO_DUDOSO,
          PROVISION,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          RIESGO,
          DEUDA_IRREGULAR,
          DISPUESTO,
          SALDO_PASIVO,
          RIESGO_GARANTIA,
          SALDO_EXCE,
          LIMITE_DESC,
          MOV_EXTRA_1,
          MOV_EXTRA_2,
          MOV_LTV_INI,
          MOV_LTV_FIN,
          DD_MX3_ID,
          DD_MX4_ID,
          CNT_LIMITE_INI,
          CNT_LIMITE_FIN,
          NUM_CREDITOS_INSINUADOS,
          DEUDA_EXIGIBLE,
          CAPITAL_FALLIDO,
          CAPITAL_VIVO,
          IMPORTE_PTE_DIFER,
          NUM_DPS,
          NUM_DPS_ACUMULADO,
          DPS,
          DPS_CAPITAL,
          DPS_ICG,
          DPS_ACUMULADO,
          DPS_CAPITAL_ACUMULADO,
          DPS_ICG_ACUMULADO,
          SALDO_MAXIMO_GESTION,
          IMPORTE_A_RECLAMAR,
          NUM_DIAS_EN_GESTION_A_COBRO,
          NUM_DIAS_IRREGULAR_A_COBRO,
          NUM_ACTUACIONES_RECOBRO,
          NUM_ACT_REC_ACUMULADO,
          NUM_ACT_REC_CONTACTO_UTIL,
          NUM_ACT_REC_CONTACTO_UTIL_ACU,
          IMP_IRREGULAR_PREV_INICIO,
          IMP_IRREGULAR_PREV_AUTO,
          IMP_IRREGULAR_PREV_MANUAL,
          IMP_IRREGULAR_PREV_FINAL,
          IMP_RIESGO_PREV_INICIO,
          IMP_RIESGO_PREV_AUTO,
          IMP_RIESGO_PREV_MANUAL,
          IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
          )
      select mes,
          max_dia_mes,
          CONTRATO_ID,
          CLASIFICACION_CNT_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          SITUACION_CNT_DETALLE_ID,
          SITUACION_ANT_CNT_DETALLE_ID,
          SITUACION_RESP_PER_ANT_ID,
          DIA_POS_VENCIDA_ID,
          DIA_SALDO_DUDOSO_ID,
          ESTADO_FINANCIERO_CNT_ID,
          ESTADO_FINANCIERO_ANT_ID,
          ESTADO_CONTRATO_ID,
          CONTRATO_JUDICIALIZADO_ID,
          ESTADO_INSINUACION_CNT_ID,
          EN_GESTION_RECOBRO_ID,
          FECHA_ALTA_GESTION_RECOBRO,
          FECHA_BAJA_GESTION_RECOBRO,
          FECHA_COMPROMETIDA_PAGO,
          FECHA_DPS,
          T_IRREG_DIAS_ID,
          TRAMO_ANTIGUEDAD_DEUDA_ID,
          T_IRREG_FASES_ID,
          TD_EN_GESTION_A_COBRO_ID,
          TD_IRREGULAR_A_COBRO_ID,
          RESULTADO_ACTUACION_CNT_ID,
          MODELO_RECOBRO_CONTRATO_ID,
          PROVEEDOR_RECOBRO_CNT_ID,
          CONTRATO_EN_IRREGULAR_ID,
          CONTRATO_CON_DPS_ID,
          CNT_CON_CONTACTO_UTIL_ID,
          CNT_CON_ACTUACION_RECOBRO_ID,
          EN_GESTION_ESPECIALIZADA_ID,
          CONTRATO_CON_PREVISION_ID,
          CNT_CON_PREV_REVISADA_ID ,
          TIPO_PREVISION_ID,
          PREV_SITUACION_INICIAL_ID,
          PREV_SITUACION_AUTO_ID,
          PREV_SITUACION_MANUAL_ID,
          PREV_SITUACION_FINAL_ID,
          MOTIVO_PREVISION_ID,
          SITUACION_ESPECIALIZADA_ID,
          GESTOR_ESPECIALIZADA_ID,
          SUPERVISOR_N1_ESPEC_ID,
          SUPERVISOR_N2_ESPEC_ID,
          SUPERVISOR_N3_ESPEC_ID,
          EN_CARTERA_ESTUDIO_ID,
          MODELO_GESTION_CARTERA_ID,
          UNIDAD_GESTION_CARTERA_ID,
          CNT_CON_CAPITAL_FALLIDO_ID,
          TIPO_GESTION_CONTRATO_ID,
          FECHA_CREACION_CONTRATO,
          FECHA_CONSTITUCION_CONTRATO ,
          FECHA_CAMBIO_TRAMO ,
          FECHA_ALTA_DUDOSO ,
          FECHA_BAJA_DUDOSO  ,
          T_SALDO_TOTAL_CNT_ID,
          T_SALDO_IRREGULAR_CNT_ID,
          T_DEUDA_IRREGULAR_CNT_ID,
          TRAMO_RIESGO_CNT_ID,
          TA_FECHA_CREACION_ID,
          PERIMETRO_GESTION_ID,
          PERIMETRO_SIN_GESTION_ID,
          PERIMETRO_EXP_SEG_ID,
          PERIMETRO_EXP_REC_ID,
          PERIMETRO_GES_EXTRA_ID,
          PERIMETRO_GES_PRE_ID,
          PERIMETRO_GES_JUDI_ID,
          PERIMETRO_GES_CONCU_ID,  
          MOTIVO_ALTA_DUDOSO_ID,
          MOTIVO_BAJA_DUDOSO_ID,
          SIT_CART_DANADA_ID,
          TIPO_GESTION_EXP_ID,
          EXPEDIENTE_ID,
          FECHA_CREACION_EXPEDIENTE,
          FECHA_ROTURA_EXPEDIENTE,
          FECHA_SALIDA_AGENCIA_EXP,
          ESQUEMA_CONTRATO_ID,
          AGENCIA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          TIPO_SALIDA_EXP_CNT_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          TIPO_INCIDENCIA_EXP_CNT_ID,
          ESTADO_INCIDENCIA_EXP_CNT_ID,
          NUM_CONTRATOS,
          NUM_CLIENTES_ASOCIADOS,
          NUM_EXPEDIENTES_ASOCIADOS,
          NUM_DIAS_VENCIDOS,
          SALDO_TOTAL,
          RIESGO_VIVO,
          POS_VIVA_NO_VENC,
          POS_VIVA_VENC,
          SALDO_DUDOSO,
          PROVISION,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          RIESGO,
          DEUDA_IRREGULAR,
          DISPUESTO,
          SALDO_PASIVO,
          RIESGO_GARANTIA,
          SALDO_EXCE,
          LIMITE_DESC,
          MOV_EXTRA_1,
          MOV_EXTRA_2,
          MOV_LTV_INI,
          MOV_LTV_FIN,
          DD_MX3_ID,
          DD_MX4_ID,
          CNT_LIMITE_INI,
          CNT_LIMITE_FIN,
          NUM_CREDITOS_INSINUADOS,
          DEUDA_EXIGIBLE,
          CAPITAL_FALLIDO,
          CAPITAL_VIVO,
          IMPORTE_PTE_DIFER,
          NUM_DPS,
          NUM_DPS_ACUMULADO,
          DPS,
          DPS_CAPITAL,
          DPS_ICG,
          DPS_ACUMULADO,
          DPS_CAPITAL_ACUMULADO,
          DPS_ICG_ACUMULADO,
          SALDO_MAXIMO_GESTION,
          IMPORTE_A_RECLAMAR,
          NUM_DIAS_EN_GESTION_A_COBRO,
          NUM_DIAS_IRREGULAR_A_COBRO,
          NUM_ACTUACIONES_RECOBRO,
          NUM_ACT_REC_ACUMULADO,
          NUM_ACT_REC_CONTACTO_UTIL,
          NUM_ACT_REC_CONTACTO_UTIL_ACU,
          IMP_IRREGULAR_PREV_INICIO,
          IMP_IRREGULAR_PREV_AUTO,
          IMP_IRREGULAR_PREV_MANUAL,
          IMP_IRREGULAR_PREV_FINAL,
          IMP_RIESGO_PREV_INICIO,
          IMP_RIESGO_PREV_AUTO,
          IMP_RIESGO_PREV_MANUAL,
          IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
      from H_CNT where DIA_ID = max_dia_mes; -- and SITUACION_RESP_PER_ANT_ID<>2;

    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

      -- Crear indices H_CNT_MES


      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_MES_IX'', ''H_CNT_MES (MES_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;

      select max(MES_ID) into mes_periodo_ant from D_F_MES where MES_ID < mes;

      merge into H_CNT_MES dc
      using (select NUM_DIAS_VENCIDOS, T_IRREG_DIAS_ID, CONTRATO_ID from H_CNT_MES where MES_ID = mes_periodo_ant) cf
      on (cf.CONTRATO_ID = dc.CONTRATO_ID)
      when matched then update set  dc.NUM_DIAS_VENC_PERIODO_ANT = cf.NUM_DIAS_VENCIDOS,
                                    dc.T_IRREG_DIAS_PERIODO_ANT_ID = cf.T_IRREG_DIAS_ID where dc.MES_ID = mes;
      commit;

  end loop C_MESES_LOOP;
  close c_mes;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_MES. Termina bucle', 3;

 

-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_TRIMESTRE. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_CNT_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
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


      -- Borrar indices H_CNT_TRIMESTRE


          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	   

      -- Borrado de los trimestres a insertar
      delete from H_CNT_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;

      insert into H_CNT_TRIMESTRE
          (TRIMESTRE_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          CLASIFICACION_CNT_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          SITUACION_CNT_DETALLE_ID,
          SITUACION_ANT_CNT_DETALLE_ID,
          SITUACION_RESP_PER_ANT_ID,
          DIA_POS_VENCIDA_ID,
          DIA_SALDO_DUDOSO_ID,
          ESTADO_FINANCIERO_CNT_ID,
          ESTADO_FINANCIERO_ANT_ID,
          ESTADO_CONTRATO_ID,
          CONTRATO_JUDICIALIZADO_ID,
          ESTADO_INSINUACION_CNT_ID,
          EN_GESTION_RECOBRO_ID,
          FECHA_ALTA_GESTION_RECOBRO,
          FECHA_BAJA_GESTION_RECOBRO,
          FECHA_COMPROMETIDA_PAGO,
          FECHA_DPS,
          T_IRREG_DIAS_ID,
          TRAMO_ANTIGUEDAD_DEUDA_ID,
          T_IRREG_FASES_ID,
          TD_EN_GESTION_A_COBRO_ID,
          TD_IRREGULAR_A_COBRO_ID,
          RESULTADO_ACTUACION_CNT_ID,
          MODELO_RECOBRO_CONTRATO_ID,
          PROVEEDOR_RECOBRO_CNT_ID,
          CONTRATO_EN_IRREGULAR_ID,
          CONTRATO_CON_DPS_ID,
          CNT_CON_CONTACTO_UTIL_ID,
          CNT_CON_ACTUACION_RECOBRO_ID,
          EN_GESTION_ESPECIALIZADA_ID,
          CONTRATO_CON_PREVISION_ID,
          CNT_CON_PREV_REVISADA_ID ,
          TIPO_PREVISION_ID,
          PREV_SITUACION_INICIAL_ID,
          PREV_SITUACION_AUTO_ID,
          PREV_SITUACION_MANUAL_ID,
          PREV_SITUACION_FINAL_ID,
          MOTIVO_PREVISION_ID,
          SITUACION_ESPECIALIZADA_ID,
          GESTOR_ESPECIALIZADA_ID,
          SUPERVISOR_N1_ESPEC_ID,
          SUPERVISOR_N2_ESPEC_ID,
          SUPERVISOR_N3_ESPEC_ID,
          EN_CARTERA_ESTUDIO_ID,
          MODELO_GESTION_CARTERA_ID,
          UNIDAD_GESTION_CARTERA_ID,
          CNT_CON_CAPITAL_FALLIDO_ID,
          TIPO_GESTION_CONTRATO_ID,
          FECHA_CREACION_CONTRATO,
          FECHA_CONSTITUCION_CONTRATO ,
          FECHA_CAMBIO_TRAMO ,
          FECHA_ALTA_DUDOSO ,
          FECHA_BAJA_DUDOSO  ,
          T_SALDO_TOTAL_CNT_ID,
          T_SALDO_IRREGULAR_CNT_ID,
          T_DEUDA_IRREGULAR_CNT_ID,
          TRAMO_RIESGO_CNT_ID,
          TA_FECHA_CREACION_ID,
          PERIMETRO_GESTION_ID,
          PERIMETRO_SIN_GESTION_ID,
          PERIMETRO_EXP_SEG_ID,
          PERIMETRO_EXP_REC_ID,
          PERIMETRO_GES_EXTRA_ID,
          PERIMETRO_GES_PRE_ID,
          PERIMETRO_GES_JUDI_ID,
          PERIMETRO_GES_CONCU_ID,  
          MOTIVO_ALTA_DUDOSO_ID,
          MOTIVO_BAJA_DUDOSO_ID,
          SIT_CART_DANADA_ID,
          TIPO_GESTION_EXP_ID,
          EXPEDIENTE_ID,
          FECHA_CREACION_EXPEDIENTE,
          FECHA_ROTURA_EXPEDIENTE,
          FECHA_SALIDA_AGENCIA_EXP,
          ESQUEMA_CONTRATO_ID,
          AGENCIA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          TIPO_SALIDA_EXP_CNT_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          TIPO_INCIDENCIA_EXP_CNT_ID,
          ESTADO_INCIDENCIA_EXP_CNT_ID,
          NUM_CONTRATOS,
          NUM_CLIENTES_ASOCIADOS,
          NUM_EXPEDIENTES_ASOCIADOS,
          NUM_DIAS_VENCIDOS,
          SALDO_TOTAL,
          RIESGO_VIVO,
          POS_VIVA_NO_VENC,
          POS_VIVA_VENC,
          SALDO_DUDOSO,
          PROVISION,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          RIESGO,
          DEUDA_IRREGULAR,
          DISPUESTO,
          SALDO_PASIVO,
          RIESGO_GARANTIA,
          SALDO_EXCE,
          LIMITE_DESC,
          MOV_EXTRA_1,
          MOV_EXTRA_2,
          MOV_LTV_INI,
          MOV_LTV_FIN,
          DD_MX3_ID,
          DD_MX4_ID,
          CNT_LIMITE_INI,
          CNT_LIMITE_FIN,
          NUM_CREDITOS_INSINUADOS,
          DEUDA_EXIGIBLE,
          CAPITAL_FALLIDO,
          CAPITAL_VIVO,
          IMPORTE_PTE_DIFER,
          NUM_DPS,
          NUM_DPS_ACUMULADO,
          DPS,
          DPS_CAPITAL,
          DPS_ICG,
          DPS_ACUMULADO,
          DPS_CAPITAL_ACUMULADO,
          DPS_ICG_ACUMULADO,
          SALDO_MAXIMO_GESTION,
          IMPORTE_A_RECLAMAR,
          NUM_DIAS_EN_GESTION_A_COBRO,
          NUM_DIAS_IRREGULAR_A_COBRO,
          NUM_ACTUACIONES_RECOBRO,
          NUM_ACT_REC_ACUMULADO,
          NUM_ACT_REC_CONTACTO_UTIL,
          NUM_ACT_REC_CONTACTO_UTIL_ACU,
          IMP_IRREGULAR_PREV_INICIO,
          IMP_IRREGULAR_PREV_AUTO,
          IMP_IRREGULAR_PREV_MANUAL,
          IMP_IRREGULAR_PREV_FINAL,
          IMP_RIESGO_PREV_INICIO,
          IMP_RIESGO_PREV_AUTO,
          IMP_RIESGO_PREV_MANUAL,
          IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
          )
      select trimestre,
          max_dia_trimestre,
          CONTRATO_ID,
          CLASIFICACION_CNT_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          SITUACION_CNT_DETALLE_ID,
          SITUACION_ANT_CNT_DETALLE_ID,
          SITUACION_RESP_PER_ANT_ID,
          DIA_POS_VENCIDA_ID,
          DIA_SALDO_DUDOSO_ID,
          ESTADO_FINANCIERO_CNT_ID,
          ESTADO_FINANCIERO_ANT_ID,
          ESTADO_CONTRATO_ID,
          CONTRATO_JUDICIALIZADO_ID,
          ESTADO_INSINUACION_CNT_ID,
          EN_GESTION_RECOBRO_ID,
          FECHA_ALTA_GESTION_RECOBRO,
          FECHA_BAJA_GESTION_RECOBRO,
          FECHA_COMPROMETIDA_PAGO,
          FECHA_DPS,
          T_IRREG_DIAS_ID,
          TRAMO_ANTIGUEDAD_DEUDA_ID,
          T_IRREG_FASES_ID,
          TD_EN_GESTION_A_COBRO_ID,
          TD_IRREGULAR_A_COBRO_ID,
          RESULTADO_ACTUACION_CNT_ID,
          MODELO_RECOBRO_CONTRATO_ID,
          PROVEEDOR_RECOBRO_CNT_ID,
          CONTRATO_EN_IRREGULAR_ID,
          CONTRATO_CON_DPS_ID,
          CNT_CON_CONTACTO_UTIL_ID,
          CNT_CON_ACTUACION_RECOBRO_ID,
          EN_GESTION_ESPECIALIZADA_ID,
          CONTRATO_CON_PREVISION_ID,
          CNT_CON_PREV_REVISADA_ID ,
          TIPO_PREVISION_ID,
          PREV_SITUACION_INICIAL_ID,
          PREV_SITUACION_AUTO_ID,
          PREV_SITUACION_MANUAL_ID,
          PREV_SITUACION_FINAL_ID,
          MOTIVO_PREVISION_ID,
          SITUACION_ESPECIALIZADA_ID,
          GESTOR_ESPECIALIZADA_ID,
          SUPERVISOR_N1_ESPEC_ID,
          SUPERVISOR_N2_ESPEC_ID,
          SUPERVISOR_N3_ESPEC_ID,
          EN_CARTERA_ESTUDIO_ID,
          MODELO_GESTION_CARTERA_ID,
          UNIDAD_GESTION_CARTERA_ID,
          CNT_CON_CAPITAL_FALLIDO_ID,
          TIPO_GESTION_CONTRATO_ID,
          FECHA_CREACION_CONTRATO,
          FECHA_CONSTITUCION_CONTRATO ,
          FECHA_CAMBIO_TRAMO ,
          FECHA_ALTA_DUDOSO ,
          FECHA_BAJA_DUDOSO  ,
          T_SALDO_TOTAL_CNT_ID,
          T_SALDO_IRREGULAR_CNT_ID,
          T_DEUDA_IRREGULAR_CNT_ID,
          TRAMO_RIESGO_CNT_ID,
          TA_FECHA_CREACION_ID,
          PERIMETRO_GESTION_ID,
          PERIMETRO_SIN_GESTION_ID,
          PERIMETRO_EXP_SEG_ID,
          PERIMETRO_EXP_REC_ID,
          PERIMETRO_GES_EXTRA_ID,
          PERIMETRO_GES_PRE_ID,
          PERIMETRO_GES_JUDI_ID,
          PERIMETRO_GES_CONCU_ID,                            
          MOTIVO_ALTA_DUDOSO_ID,
          MOTIVO_BAJA_DUDOSO_ID,
          SIT_CART_DANADA_ID,
          TIPO_GESTION_EXP_ID,
          EXPEDIENTE_ID,
          FECHA_CREACION_EXPEDIENTE,
          FECHA_ROTURA_EXPEDIENTE,
          FECHA_SALIDA_AGENCIA_EXP,
          ESQUEMA_CONTRATO_ID,
          AGENCIA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          TIPO_SALIDA_EXP_CNT_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          TIPO_INCIDENCIA_EXP_CNT_ID,
          ESTADO_INCIDENCIA_EXP_CNT_ID,
          NUM_CONTRATOS,
          NUM_CLIENTES_ASOCIADOS,
          NUM_EXPEDIENTES_ASOCIADOS,
          NUM_DIAS_VENCIDOS,
          SALDO_TOTAL,
          RIESGO_VIVO,
          POS_VIVA_NO_VENC,
          POS_VIVA_VENC,
          SALDO_DUDOSO,
          PROVISION,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          RIESGO,
          DEUDA_IRREGULAR,
          DISPUESTO,
          SALDO_PASIVO,
          RIESGO_GARANTIA,
          SALDO_EXCE,
          LIMITE_DESC,
          MOV_EXTRA_1,
          MOV_EXTRA_2,
          MOV_LTV_INI,
          MOV_LTV_FIN,
          DD_MX3_ID,
          DD_MX4_ID,
          CNT_LIMITE_INI,
          CNT_LIMITE_FIN,
          NUM_CREDITOS_INSINUADOS,
          DEUDA_EXIGIBLE,
          CAPITAL_FALLIDO,
          CAPITAL_VIVO,
          IMPORTE_PTE_DIFER,
          NUM_DPS,
          NUM_DPS_ACUMULADO,
          DPS,
          DPS_CAPITAL,
          DPS_ICG,
          DPS_ACUMULADO,
          DPS_CAPITAL_ACUMULADO,
          DPS_ICG_ACUMULADO,
          SALDO_MAXIMO_GESTION,
          IMPORTE_A_RECLAMAR,
          NUM_DIAS_EN_GESTION_A_COBRO,
          NUM_DIAS_IRREGULAR_A_COBRO,
          NUM_ACTUACIONES_RECOBRO,
          NUM_ACT_REC_ACUMULADO,
          NUM_ACT_REC_CONTACTO_UTIL,
          NUM_ACT_REC_CONTACTO_UTIL_ACU,
          IMP_IRREGULAR_PREV_INICIO,
          IMP_IRREGULAR_PREV_AUTO,
          IMP_IRREGULAR_PREV_MANUAL,
          IMP_IRREGULAR_PREV_FINAL,
          IMP_RIESGO_PREV_INICIO,
          IMP_RIESGO_PREV_AUTO,
          IMP_RIESGO_PREV_MANUAL,
          IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
      from H_CNT where DIA_ID = max_dia_trimestre;-- and SITUACION_RESP_PER_ANT_ID<>2;

      V_ROWCOUNT := sql%rowcount;
      commit;

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

      -- Crear indices H_CNT_TRIMESTRE


 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_TRIMESTRE_IX'', ''H_CNT_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
      commit;

      select max(TRIMESTRE_ID) into trimestre_periodo_ant from D_F_TRIMESTRE where TRIMESTRE_ID < trimestre;

      merge into H_CNT_TRIMESTRE dc
      using (select NUM_DIAS_VENCIDOS, T_IRREG_DIAS_ID, CONTRATO_ID from H_CNT_TRIMESTRE where TRIMESTRE_ID = trimestre_periodo_ant) cf
      on (cf.CONTRATO_ID = dc.CONTRATO_ID)
      when matched then update set  dc.NUM_DIAS_VENC_PERIODO_ANT = cf.NUM_DIAS_VENCIDOS,
                                    dc.T_IRREG_DIAS_PERIODO_ANT_ID = cf.T_IRREG_DIAS_ID where dc.TRIMESTRE_ID = trimestre;
      commit;

   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_TRIMESTRE. Termina bucle', 3;



-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
	   
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_CNT_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
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

  -- Bucle que recorre los a�os
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;
    exit when c_anio%NOTFOUND;

      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
      select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;

      -- Crear indices H_CNT_ANIO


         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;

      -- Borrado de los a�os a insertar
      delete from H_CNT_ANIO where ANIO_ID = anio;
      commit;

      insert into H_CNT_ANIO
          (ANIO_ID,
          FECHA_CARGA_DATOS,
          CONTRATO_ID,
          CLASIFICACION_CNT_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          SITUACION_CNT_DETALLE_ID,
          SITUACION_ANT_CNT_DETALLE_ID,
          SITUACION_RESP_PER_ANT_ID,
          DIA_POS_VENCIDA_ID,
          DIA_SALDO_DUDOSO_ID,
          ESTADO_FINANCIERO_CNT_ID,
          ESTADO_FINANCIERO_ANT_ID,
          ESTADO_CONTRATO_ID,
          CONTRATO_JUDICIALIZADO_ID,
          ESTADO_INSINUACION_CNT_ID,
          EN_GESTION_RECOBRO_ID,
          FECHA_ALTA_GESTION_RECOBRO,
          FECHA_BAJA_GESTION_RECOBRO,
          FECHA_COMPROMETIDA_PAGO,
          FECHA_DPS,
          T_IRREG_DIAS_ID,
          TRAMO_ANTIGUEDAD_DEUDA_ID,
          T_IRREG_FASES_ID,
          TD_EN_GESTION_A_COBRO_ID,
          TD_IRREGULAR_A_COBRO_ID,
          RESULTADO_ACTUACION_CNT_ID,
          MODELO_RECOBRO_CONTRATO_ID,
          PROVEEDOR_RECOBRO_CNT_ID,
          CONTRATO_EN_IRREGULAR_ID,
          CONTRATO_CON_DPS_ID,
          CNT_CON_CONTACTO_UTIL_ID,
          CNT_CON_ACTUACION_RECOBRO_ID,
          EN_GESTION_ESPECIALIZADA_ID,
          CONTRATO_CON_PREVISION_ID,
          CNT_CON_PREV_REVISADA_ID ,
          TIPO_PREVISION_ID,
          PREV_SITUACION_INICIAL_ID,
          PREV_SITUACION_AUTO_ID,
          PREV_SITUACION_MANUAL_ID,
          PREV_SITUACION_FINAL_ID,
          MOTIVO_PREVISION_ID,
          SITUACION_ESPECIALIZADA_ID,
          GESTOR_ESPECIALIZADA_ID,
          SUPERVISOR_N1_ESPEC_ID,
          SUPERVISOR_N2_ESPEC_ID,
          SUPERVISOR_N3_ESPEC_ID,
          EN_CARTERA_ESTUDIO_ID,
          MODELO_GESTION_CARTERA_ID,
          UNIDAD_GESTION_CARTERA_ID,
          CNT_CON_CAPITAL_FALLIDO_ID,
          TIPO_GESTION_CONTRATO_ID,
          FECHA_CREACION_CONTRATO,
          FECHA_CONSTITUCION_CONTRATO ,
          FECHA_CAMBIO_TRAMO ,
          FECHA_ALTA_DUDOSO ,
          FECHA_BAJA_DUDOSO  ,
          T_SALDO_TOTAL_CNT_ID,
          T_SALDO_IRREGULAR_CNT_ID,
          T_DEUDA_IRREGULAR_CNT_ID,
          TRAMO_RIESGO_CNT_ID,
          TA_FECHA_CREACION_ID,
          PERIMETRO_GESTION_ID,
          PERIMETRO_SIN_GESTION_ID,
          PERIMETRO_EXP_SEG_ID,
          PERIMETRO_EXP_REC_ID,
          PERIMETRO_GES_EXTRA_ID,
          PERIMETRO_GES_PRE_ID,
          PERIMETRO_GES_JUDI_ID,
          PERIMETRO_GES_CONCU_ID,  
          MOTIVO_ALTA_DUDOSO_ID,
          MOTIVO_BAJA_DUDOSO_ID,
          SIT_CART_DANADA_ID,
          TIPO_GESTION_EXP_ID,
          EXPEDIENTE_ID,
          FECHA_CREACION_EXPEDIENTE,
          FECHA_ROTURA_EXPEDIENTE,
          FECHA_SALIDA_AGENCIA_EXP,
          ESQUEMA_CONTRATO_ID,
          AGENCIA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          TIPO_SALIDA_EXP_CNT_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          TIPO_INCIDENCIA_EXP_CNT_ID,
          ESTADO_INCIDENCIA_EXP_CNT_ID,
          NUM_CONTRATOS,
          NUM_CLIENTES_ASOCIADOS,
          NUM_EXPEDIENTES_ASOCIADOS,
          NUM_DIAS_VENCIDOS,
          SALDO_TOTAL,
          RIESGO_VIVO,
          POS_VIVA_NO_VENC,
          POS_VIVA_VENC,
          SALDO_DUDOSO,
          PROVISION,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          RIESGO,
          DEUDA_IRREGULAR,
          DISPUESTO,
          SALDO_PASIVO,
          RIESGO_GARANTIA,
          SALDO_EXCE,
          LIMITE_DESC,
          MOV_EXTRA_1,
          MOV_EXTRA_2,
          MOV_LTV_INI,
          MOV_LTV_FIN,
          DD_MX3_ID,
          DD_MX4_ID,
          CNT_LIMITE_INI,
          CNT_LIMITE_FIN,
          NUM_CREDITOS_INSINUADOS,
          DEUDA_EXIGIBLE,
          CAPITAL_FALLIDO,
          CAPITAL_VIVO,
          IMPORTE_PTE_DIFER,
          NUM_DPS,
          NUM_DPS_ACUMULADO,
          DPS,
          DPS_CAPITAL,
          DPS_ICG,
          DPS_ACUMULADO,
          DPS_CAPITAL_ACUMULADO,
          DPS_ICG_ACUMULADO,
          SALDO_MAXIMO_GESTION,
          IMPORTE_A_RECLAMAR,
          NUM_DIAS_EN_GESTION_A_COBRO,
          NUM_DIAS_IRREGULAR_A_COBRO,
          NUM_ACTUACIONES_RECOBRO,
          NUM_ACT_REC_ACUMULADO,
          NUM_ACT_REC_CONTACTO_UTIL,
          NUM_ACT_REC_CONTACTO_UTIL_ACU,
          IMP_IRREGULAR_PREV_INICIO,
          IMP_IRREGULAR_PREV_AUTO,
          IMP_IRREGULAR_PREV_MANUAL,
          IMP_IRREGULAR_PREV_FINAL,
          IMP_RIESGO_PREV_INICIO,
          IMP_RIESGO_PREV_AUTO,
          IMP_RIESGO_PREV_MANUAL,
          IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
          )
      select anio,
          max_dia_anio,
          CONTRATO_ID,
          CLASIFICACION_CNT_ID,
          SEGMENTO_CARTERA_ID,
          ENVIADO_AGENCIA_CNT_ID,
          SITUACION_CNT_DETALLE_ID,
          SITUACION_ANT_CNT_DETALLE_ID,
          SITUACION_RESP_PER_ANT_ID,
          DIA_POS_VENCIDA_ID,
          DIA_SALDO_DUDOSO_ID,
          ESTADO_FINANCIERO_CNT_ID,
          ESTADO_FINANCIERO_ANT_ID,
          ESTADO_CONTRATO_ID,
          CONTRATO_JUDICIALIZADO_ID,
          ESTADO_INSINUACION_CNT_ID,
          EN_GESTION_RECOBRO_ID,
          FECHA_ALTA_GESTION_RECOBRO,
          FECHA_BAJA_GESTION_RECOBRO,
          FECHA_COMPROMETIDA_PAGO,
          FECHA_DPS,
          T_IRREG_DIAS_ID,
          TRAMO_ANTIGUEDAD_DEUDA_ID,
          T_IRREG_FASES_ID,
          TD_EN_GESTION_A_COBRO_ID,
          TD_IRREGULAR_A_COBRO_ID,
          RESULTADO_ACTUACION_CNT_ID,
          MODELO_RECOBRO_CONTRATO_ID,
          PROVEEDOR_RECOBRO_CNT_ID,
          CONTRATO_EN_IRREGULAR_ID,
          CONTRATO_CON_DPS_ID,
          CNT_CON_CONTACTO_UTIL_ID,
          CNT_CON_ACTUACION_RECOBRO_ID,
          EN_GESTION_ESPECIALIZADA_ID,
          CONTRATO_CON_PREVISION_ID,
          CNT_CON_PREV_REVISADA_ID ,
          TIPO_PREVISION_ID,
          PREV_SITUACION_INICIAL_ID,
          PREV_SITUACION_AUTO_ID,
          PREV_SITUACION_MANUAL_ID,
          PREV_SITUACION_FINAL_ID,
          MOTIVO_PREVISION_ID,
          SITUACION_ESPECIALIZADA_ID,
          GESTOR_ESPECIALIZADA_ID,
          SUPERVISOR_N1_ESPEC_ID,
          SUPERVISOR_N2_ESPEC_ID,
          SUPERVISOR_N3_ESPEC_ID,
          EN_CARTERA_ESTUDIO_ID,
          MODELO_GESTION_CARTERA_ID,
          UNIDAD_GESTION_CARTERA_ID,
          CNT_CON_CAPITAL_FALLIDO_ID,
          TIPO_GESTION_CONTRATO_ID,
          FECHA_CREACION_CONTRATO,
          FECHA_CONSTITUCION_CONTRATO ,
          FECHA_CAMBIO_TRAMO ,
          FECHA_ALTA_DUDOSO ,
          FECHA_BAJA_DUDOSO  ,
          T_SALDO_TOTAL_CNT_ID,
          T_SALDO_IRREGULAR_CNT_ID,
          T_DEUDA_IRREGULAR_CNT_ID,
          TRAMO_RIESGO_CNT_ID,
          TA_FECHA_CREACION_ID,
          PERIMETRO_GESTION_ID,
          PERIMETRO_SIN_GESTION_ID,
          PERIMETRO_EXP_SEG_ID,
          PERIMETRO_EXP_REC_ID,
          PERIMETRO_GES_EXTRA_ID,
          PERIMETRO_GES_PRE_ID,
          PERIMETRO_GES_JUDI_ID,
          PERIMETRO_GES_CONCU_ID,  
          MOTIVO_ALTA_DUDOSO_ID,
          MOTIVO_BAJA_DUDOSO_ID,
          SIT_CART_DANADA_ID,
          TIPO_GESTION_EXP_ID,
          EXPEDIENTE_ID,
          FECHA_CREACION_EXPEDIENTE,
          FECHA_ROTURA_EXPEDIENTE,
          FECHA_SALIDA_AGENCIA_EXP,
          ESQUEMA_CONTRATO_ID,
          AGENCIA_CONTRATO_ID,
          SUBCARTERA_EXPEDIENTE_CNT_ID,
          TIPO_SALIDA_EXP_CNT_ID,
          MOTIVO_SALIDA_EXP_CNT_ID,
          TIPO_INCIDENCIA_EXP_CNT_ID,
          ESTADO_INCIDENCIA_EXP_CNT_ID,
          NUM_CONTRATOS,
          NUM_CLIENTES_ASOCIADOS,
          NUM_EXPEDIENTES_ASOCIADOS,
          NUM_DIAS_VENCIDOS,
          SALDO_TOTAL,
          RIESGO_VIVO,
          POS_VIVA_NO_VENC,
          POS_VIVA_VENC,
          SALDO_DUDOSO,
          PROVISION,
          INT_REMUNERATORIOS,
          INT_MORATORIOS,
          COMISIONES,
          GASTOS,
          RIESGO,
          DEUDA_IRREGULAR,
          DISPUESTO,
          SALDO_PASIVO,
          RIESGO_GARANTIA,
          SALDO_EXCE,
          LIMITE_DESC,
          MOV_EXTRA_1,
          MOV_EXTRA_2,
          MOV_LTV_INI,
          MOV_LTV_FIN,
          DD_MX3_ID,
          DD_MX4_ID,
          CNT_LIMITE_INI,
          CNT_LIMITE_FIN,
          NUM_CREDITOS_INSINUADOS,
          DEUDA_EXIGIBLE,
          CAPITAL_FALLIDO,
          CAPITAL_VIVO,
          IMPORTE_PTE_DIFER,
          NUM_DPS,
          NUM_DPS_ACUMULADO,
          DPS,
          DPS_CAPITAL,
          DPS_ICG,
          DPS_ACUMULADO,
          DPS_CAPITAL_ACUMULADO,
          DPS_ICG_ACUMULADO,
          SALDO_MAXIMO_GESTION,
          IMPORTE_A_RECLAMAR,
          NUM_DIAS_EN_GESTION_A_COBRO,
          NUM_DIAS_IRREGULAR_A_COBRO,
          NUM_ACTUACIONES_RECOBRO,
          NUM_ACT_REC_ACUMULADO,
          NUM_ACT_REC_CONTACTO_UTIL,
          NUM_ACT_REC_CONTACTO_UTIL_ACU,
          IMP_IRREGULAR_PREV_INICIO,
          IMP_IRREGULAR_PREV_AUTO,
          IMP_IRREGULAR_PREV_MANUAL,
          IMP_IRREGULAR_PREV_FINAL,
          IMP_RIESGO_PREV_INICIO,
          IMP_RIESGO_PREV_AUTO,
          IMP_RIESGO_PREV_MANUAL,
          IMP_RIESGO_PREV_FINAL,
        FECHA_ACCION,
        TIPO_ACCION_ID,
        RESULTADO_GESTION_ID,
        IMPORTE_COMPROMETIDO
      from H_CNT where DIA_ID = max_dia_anio;-- and SITUACION_RESP_PER_ANT_ID<>2;

      V_ROWCOUNT := sql%rowcount;
      commit;

       --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

      -- Crear indices H_CNT_ANIO


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_ANIO_IX'', ''H_CNT_ANIO (ANIO_ID, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';



            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;

      select max(ANIO_ID) into anio_periodo_ant from D_F_ANIO where ANIO_ID < anio;

      merge into H_CNT_ANIO dc
      using (select NUM_DIAS_VENCIDOS, T_IRREG_DIAS_ID, CONTRATO_ID from H_CNT_ANIO where ANIO_ID = anio_periodo_ant) cf
      on (cf.CONTRATO_ID = dc.CONTRATO_ID)
      when matched then update set  dc.NUM_DIAS_VENC_PERIODO_ANT = cf.NUM_DIAS_VENCIDOS,
                                    dc.T_IRREG_DIAS_PERIODO_ANT_ID = cf.T_IRREG_DIAS_ID where dc.ANIO_ID = anio;
      commit;

  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Termina bucle', 3;

  

    /*  V_SQL :=  'BEGIN CARGAR_H_CNT_DET_ACUERDO('''||DATE_START||''', '''||DATE_END||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN CARGAR_H_CNT_DET_CICLO_REC('''||DATE_START||''', '''||DATE_END||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
*/
      V_SQL :=  'BEGIN CARGAR_H_CNT_DET_COBRO('''||DATE_START||''', '''||DATE_END||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
/*
      V_SQL :=  'BEGIN CARGAR_H_CNT_DET_INCI('''||DATE_START||''', '''||DATE_END||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;

      V_SQL :=  'BEGIN CARGAR_H_CNT_DET_EFICACIA('''||DATE_START||''', '''||DATE_END||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
*/
      V_SQL :=  'BEGIN CARGAR_H_CNT_DET_CREDITO('''||DATE_START||''', '''||DATE_END||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
	  
	  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


  
end;

end CARGAR_H_CONTRATO;
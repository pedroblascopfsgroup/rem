--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160226
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-1177
--## PRODUCTO=NO
--## 
--## Finalidad: duplicidades lanzamientos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE CARGAR_H_SUBASTA (DATE_START IN DATE, DATE_END IN DATE, O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable última modificación: María Villanueva, PFS Group
-- Fecha ultima modificacion: 25/02/2016
-- Motivos del cambio: Se modifica la carga del atributo nuúmero de auto

-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas de hechos de Subasta
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================

-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  V_SQL VARCHAR2(16000);

  max_dia_semana date;
  max_dia_mes date;
  max_dia_trimestre date;
  max_dia_anio date;
  max_dia_carga date;
  
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_rellenar date;

  nCount number;

  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_SUBASTA';
  V_ROWCOUNT NUMBER;

--  cursor c_fecha_rellenar is select distinct(DIA_ID) DIA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
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


  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    -- Borrado índices TMP_H_PRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_SUB_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_SUB'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	

     execute immediate
        'insert into TMP_H_SUB(
                    DIA_ID,
                    FECHA_CARGA_DATOS,
                    ASUNTO_ID,
                    PROCEDIMIENTO_ID,
                    SUBASTA_ID,
                    LOTE_ID,
                    NUMERO_AUTO_ID,
                    TIPO_SUBASTA_ID,
                    ESTADO_SUBASTA_ID,
                    MOTIVO_SUSPEN_ID,
                    SUBMOTIVO_SUSPEN_ID,
                    MOTIVO_CANCEL_ID,
                    TIPO_ADJUDICACION_ID,
                    FECHA_ANUNCIO_SUBASTA,
                    FECHA_SOLICITUD_SUBASTA,
                    FECHA_SENYALAMIENTO_SUBASTA,
                    IMP_PUJA_SIN_POSTORES,
                    IMP_PUJA_CON_POSTORES_DESDE,
                    IMP_PUJA_CON_POSTORES_HASTA,
                    IMP_VALOR_SUBASTA,
                    IMP_DEUDA_JUDICIAL,
                    IMP_DEUDA_JUDICIAL_SUB,
                    P_ANUNCIO_SOLICITUD,
                    P_SENYALAMIENTO_ANUNCIO,
                    P_SENYALAMIENTO_SOLICITUD,
                    NUM_PROCEDIMIENTO
                   )
            SELECT  distinct
                    ''' || fecha || ''',
                    ''' || fecha || ''',
                     SUB.ASU_ID,
                     SUB.PRC_ID,
                     SUB.SUB_ID,
                     lOS.LOS_ID,
                     SUB2.SUB_NUM_AUTOS,
                     NVL(DD_TSU_ID,-1),
                     NVL(DD_ESU_ID,-1),
                     NVL(DD_MSS_ID,-1),
                     NULL AS SUBMOTIVO_SUSPEN_ID,
                     NVL(DD_MCS_ID,-1),
                     NULL AS TIPO_ADJUDICACION_ID,
                     TRUNC(SUB_FECHA_ANUNCIO),
                     TRUNC(SUB_FECHA_SOLICITUD),
                     TRUNC(SUB_FECHA_SENYALAMIENTO),
                     NVL(LOS.LOS_PUJA_SIN_POSTORES,0),
                     NVL(LOS.LOS_PUJA_POSTORES_DESDE,0),
                     NVL(LOS.LOS_PUJA_POSTORES_HASTA,0),
                     NVL(LOS_VALOR_SUBASTA,0),
                     NVL(LOS.LOS_DEUDA_JUDICIAL,0),
                     NVL(SUB.DEUDA_JUDICIAL_MIG,0),
                     (NVL(TRUNC(SUB_FECHA_ANUNCIO), TRUNC(SYSDATE)) - TRUNC(SUB_FECHA_SOLICITUD)) AS P_ANUNCIO_SOLICITUD,
                     (NVL(TRUNC(SUB_FECHA_SENYALAMIENTO), TRUNC(SYSDATE)) - TRUNC(SUB_FECHA_ANUNCIO)) AS P_SENYALAMIENTO_ANUNCIO,
                     (NVL(TRUNC(SUB_FECHA_SENYALAMIENTO), TRUNC(SYSDATE)) - TRUNC(SUB_FECHA_SOLICITUD)) AS P_SENYALAMIENTO_SOLICITUD,
                     1 AS NUM_PROCEDIMIENTO
            FROM '||V_DATASTAGE||'.SUB_SUBASTA SUB, '||V_DATASTAGE||'.LOS_LOTE_SUBASTA LOS, '||V_DATASTAGE||'.LOB_LOTE_BIEN LOB,
            (select distinct ASU_ID, NVL(PRC_COD_PROC_EN_JUZGADO,0) SUB_NUM_AUTOS  from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS where BORRADO = 0 and ''' || fecha || ''' >= trunc(FECHACREAR)) SUB2
            WHERE LOS.SUB_ID(+) = SUB.SUB_ID
            AND SUB.ASU_ID = SUB2.ASU_ID(+)
            AND (SUB.BORRADO = 0 AND LOS.BORRADO(+) = 0 and ''' || fecha || ''' >= trunc(SUB.FECHACREAR) and ''' || fecha || ''' >= trunc(LOS.FECHACREAR(+)))
            AND LOB.LOS_ID(+) = LOS.LOS_ID';

        V_ROWCOUNT := sql%rowcount;

        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_SUB. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT) ||' para la Fecha ='||TO_CHAR(fecha, 'DD/MM/YYYY'), 4;
        commit;
        
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_SUB_IX'', ''TMP_H_SUB (DIA_ID, ASUNTO_ID, PROCEDIMIENTO_ID, SUBASTA_ID, LOTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;


        MERGE INTO TMP_H_SUB SUB
         USING (SELECT DIA_ID,
                      ASUNTO_ID,
                      PROCEDIMIENTO_ID,
                      SUBASTA_ID,
                      LOTE_ID, 
                      CASE WHEN P_ANUNCIO_SOLICITUD BETWEEN 0 AND 30 THEN 0
                            WHEN P_ANUNCIO_SOLICITUD BETWEEN 31 AND 60 THEN 1
                            WHEN P_ANUNCIO_SOLICITUD BETWEEN 61 AND 90 THEN 2
                            WHEN P_ANUNCIO_SOLICITUD BETWEEN 91 AND 120 THEN 3
                            WHEN P_ANUNCIO_SOLICITUD BETWEEN 121 AND 150 THEN 4
                            WHEN P_ANUNCIO_SOLICITUD > 150 THEN 5
                       ELSE -1 END AS TD_ANUNCIO_SOLICITUD,
                       CASE WHEN P_SENYALAMIENTO_ANUNCIO BETWEEN 0 AND 30 THEN 0
                            WHEN P_SENYALAMIENTO_ANUNCIO BETWEEN 31 AND 60 THEN 1
                            WHEN P_SENYALAMIENTO_ANUNCIO BETWEEN 61 AND 90 THEN 2
                            WHEN P_SENYALAMIENTO_ANUNCIO BETWEEN 91 AND 120 THEN 3
                            WHEN P_SENYALAMIENTO_ANUNCIO BETWEEN 121 AND 150 THEN 4
                            WHEN P_SENYALAMIENTO_ANUNCIO > 150 THEN 5
                       ELSE -1 END AS TD_SENYALAMIENTO_ANUNCIO,
                       CASE WHEN P_SENYALAMIENTO_SOLICITUD BETWEEN 0 AND 30 THEN 0
                            WHEN P_SENYALAMIENTO_SOLICITUD BETWEEN 31 AND 60 THEN 1
                            WHEN P_SENYALAMIENTO_SOLICITUD BETWEEN 61 AND 90 THEN 2
                            WHEN P_SENYALAMIENTO_SOLICITUD BETWEEN 91 AND 120 THEN 3
                            WHEN P_SENYALAMIENTO_SOLICITUD BETWEEN 121 AND 150 THEN 4
                            WHEN P_SENYALAMIENTO_SOLICITUD > 150 THEN 5
                       ELSE -1 END AS TD_SENYALAMIENTO_SOLICITUD
                 FROM TMP_H_SUB) CASES
          ON (SUB.DIA_ID = CASES.DIA_ID AND SUB.ASUNTO_ID = CASES.ASUNTO_ID AND SUB.PROCEDIMIENTO_ID = CASES.PROCEDIMIENTO_ID AND SUB.SUBASTA_ID = CASES.SUBASTA_ID AND SUB.LOTE_ID = CASES.LOTE_ID)
          WHEN MATCHED THEN UPDATE
              SET TD_ANUNCIO_SOLICITUD = CASES.TD_ANUNCIO_SOLICITUD,
                  TD_SENYALAMIENTO_ANUNCIO = CASES.TD_SENYALAMIENTO_ANUNCIO,
                  TD_SENYALAMIENTO_SOLICITUD = CASES.TD_SENYALAMIENTO_SOLICITUD
           where SUB.DIA_ID = ''||fecha||'';

        V_ROWCOUNT := sql%rowcount;

        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_SUB. Update (1): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;
        
        -- Borrado del día a insertar
        delete from H_SUB where DIA_ID = fecha;
        commit;
        
         -- Borrado índices H_SUB
		V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_SUB_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
		execute immediate V_SQL USING OUT O_ERROR_STATUS;
         commit;
        
          INSERT INTO H_SUB(
                            DIA_ID,
                            FECHA_CARGA_DATOS,
                            ASUNTO_ID,
                            PROCEDIMIENTO_ID,
                            SUBASTA_ID,
                            LOTE_ID,
                            NUMERO_AUTO_ID,
                            TIPO_SUBASTA_ID,
                            ESTADO_SUBASTA_ID,
                            MOTIVO_SUSPEN_ID,
                            SUBMOTIVO_SUSPEN_ID,
                            MOTIVO_CANCEL_ID,
                            TIPO_ADJUDICACION_ID,
                            FECHA_ANUNCIO_SUBASTA,
                            FECHA_SOLICITUD_SUBASTA,
                            FECHA_SENYALAMIENTO_SUBASTA,
                            TD_ANUNCIO_SOLICITUD,
                            TD_SENYALAMIENTO_ANUNCIO,
                            TD_SENYALAMIENTO_SOLICITUD,
                            IMP_PUJA_SIN_POSTORES,
                            IMP_PUJA_CON_POSTORES_DESDE,
                            IMP_PUJA_CON_POSTORES_HASTA,
                            IMP_VALOR_SUBASTA,
                            IMP_DEUDA_JUDICIAL,
                            IMP_DEUDA_JUDICIAL_SUB,
                            P_ANUNCIO_SOLICITUD,
                            P_SENYALAMIENTO_ANUNCIO,
                            P_SENYALAMIENTO_SOLICITUD,
                            NUM_PROCEDIMIENTO
                            )
          SELECT  DIA_ID,
                  FECHA_CARGA_DATOS,
                  ASUNTO_ID,
                  PROCEDIMIENTO_ID,
                  SUBASTA_ID,
                  LOTE_ID,
                  NUMERO_AUTO_ID,
                  TIPO_SUBASTA_ID,
                  ESTADO_SUBASTA_ID,
                  MOTIVO_SUSPEN_ID,
                  SUBMOTIVO_SUSPEN_ID,
                  MOTIVO_CANCEL_ID,
                  TIPO_ADJUDICACION_ID,
                  FECHA_ANUNCIO_SUBASTA,
                  FECHA_SOLICITUD_SUBASTA,
                  FECHA_SENYALAMIENTO_SUBASTA,
                  TD_ANUNCIO_SOLICITUD,
                  TD_SENYALAMIENTO_ANUNCIO,
                  TD_SENYALAMIENTO_SOLICITUD,
                  IMP_PUJA_SIN_POSTORES,
                  IMP_PUJA_CON_POSTORES_DESDE,
                  IMP_PUJA_CON_POSTORES_HASTA,
                  IMP_VALOR_SUBASTA,
                  IMP_DEUDA_JUDICIAL,
                  IMP_DEUDA_JUDICIAL_SUB,
                  P_ANUNCIO_SOLICITUD,
                  P_SENYALAMIENTO_ANUNCIO,
                  P_SENYALAMIENTO_SOLICITUD,
                  NUM_PROCEDIMIENTO
          FROM TMP_H_SUB;

        V_ROWCOUNT := sql%rowcount;
     
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_IX'', ''H_SUB (DIA_ID, ASUNTO_ID, SUBASTA_ID, LOTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    end loop;
  close c_fecha;

      
-- ----------------------------------------------------------------------------------------------
--                                      H_SUB_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_SUB_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_SUB_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_SUB;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);

  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    -- Borrado indices H_PRC_SEMANA 
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_SUB_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
     
    -- Borrado de las semanas a insertar
    delete from H_SUB_SEMANA where SEMANA_ID = semana;
    commit;
    
    insert into H_SUB_SEMANA(
                            SEMANA_ID,
                            FECHA_CARGA_DATOS,
                            ASUNTO_ID,
                            PROCEDIMIENTO_ID,
                            SUBASTA_ID,
                            LOTE_ID,
                            NUMERO_AUTO_ID,
                            TIPO_SUBASTA_ID,
                            ESTADO_SUBASTA_ID,
                            MOTIVO_SUSPEN_ID,
                            SUBMOTIVO_SUSPEN_ID,
                            MOTIVO_CANCEL_ID,
                            TIPO_ADJUDICACION_ID,
                            FECHA_ANUNCIO_SUBASTA,
                            FECHA_SOLICITUD_SUBASTA,
                            FECHA_SENYALAMIENTO_SUBASTA,
                            TD_ANUNCIO_SOLICITUD,
                            TD_SENYALAMIENTO_ANUNCIO,
                            TD_SENYALAMIENTO_SOLICITUD,
                            IMP_PUJA_SIN_POSTORES,
                            IMP_PUJA_CON_POSTORES_DESDE,
                            IMP_PUJA_CON_POSTORES_HASTA,
                            IMP_VALOR_SUBASTA,
                            IMP_DEUDA_JUDICIAL,
                            IMP_DEUDA_JUDICIAL_SUB,
                            P_ANUNCIO_SOLICITUD,
                            P_SENYALAMIENTO_ANUNCIO,
                            P_SENYALAMIENTO_SOLICITUD,
                            NUM_PROCEDIMIENTO
                            )
    select semana, 
           max_dia_semana,
            ASUNTO_ID,
            PROCEDIMIENTO_ID,
            SUBASTA_ID,
            LOTE_ID,
            NUMERO_AUTO_ID,
            TIPO_SUBASTA_ID,
            ESTADO_SUBASTA_ID,
            MOTIVO_SUSPEN_ID,
            SUBMOTIVO_SUSPEN_ID,
            MOTIVO_CANCEL_ID,
            TIPO_ADJUDICACION_ID,
            FECHA_ANUNCIO_SUBASTA,
            FECHA_SOLICITUD_SUBASTA,
            FECHA_SENYALAMIENTO_SUBASTA,
            TD_ANUNCIO_SOLICITUD,
            TD_SENYALAMIENTO_ANUNCIO,
            TD_SENYALAMIENTO_SOLICITUD,
            IMP_PUJA_SIN_POSTORES,
            IMP_PUJA_CON_POSTORES_DESDE,
            IMP_PUJA_CON_POSTORES_HASTA,
            IMP_VALOR_SUBASTA,
            IMP_DEUDA_JUDICIAL,
            IMP_DEUDA_JUDICIAL_SUB,
            P_ANUNCIO_SOLICITUD,
            P_SENYALAMIENTO_ANUNCIO,
            P_SENYALAMIENTO_SOLICITUD,
            NUM_PROCEDIMIENTO
     from H_SUB
     where DIA_ID = max_dia_semana;
     
     V_ROWCOUNT := sql%rowcount;
     
     
     --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;
      
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_SEMANA_IX'', ''H_SUB_SEMANA (SEMANA_ID, ASUNTO_ID, SUBASTA_ID, LOTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    end loop C_SEMANAS_LOOP;
    close c_semana; 

-- ----------------------------------------------------------------------------------------------
--                                      H_SUB_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_MES. Empieza Carga', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_SUB_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_SUB;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  
  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;

      -- Borrado indices H_PRC_MES
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_SUB_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los meses a insertar
      delete from H_SUB_MES where MES_ID = mes;
      commit;
      
      -- Insertado de meses (�ltimo d�a del mes disponible en H_PRC)
      insert into H_SUB_MES(
                  MES_ID,
                  FECHA_CARGA_DATOS,
                  ASUNTO_ID,
                  PROCEDIMIENTO_ID,
                  SUBASTA_ID,
                  LOTE_ID,
                  NUMERO_AUTO_ID,
                  TIPO_SUBASTA_ID,
                  ESTADO_SUBASTA_ID,
                  MOTIVO_SUSPEN_ID,
                  SUBMOTIVO_SUSPEN_ID,
                  MOTIVO_CANCEL_ID,
                  TIPO_ADJUDICACION_ID,
                  FECHA_ANUNCIO_SUBASTA,
                  FECHA_SOLICITUD_SUBASTA,
                  FECHA_SENYALAMIENTO_SUBASTA,
                  TD_ANUNCIO_SOLICITUD,
                  TD_SENYALAMIENTO_ANUNCIO,
                  TD_SENYALAMIENTO_SOLICITUD,
                  IMP_PUJA_SIN_POSTORES,
                  IMP_PUJA_CON_POSTORES_DESDE,
                  IMP_PUJA_CON_POSTORES_HASTA,
                  IMP_VALOR_SUBASTA,
                  IMP_DEUDA_JUDICIAL,
                  IMP_DEUDA_JUDICIAL_SUB,
                  P_ANUNCIO_SOLICITUD,
                  P_SENYALAMIENTO_ANUNCIO,
                  P_SENYALAMIENTO_SOLICITUD,
                  NUM_PROCEDIMIENTO
                  )
      select mes,
             max_dia_mes,
            ASUNTO_ID,
            PROCEDIMIENTO_ID,
            SUBASTA_ID,
            LOTE_ID,
            NUMERO_AUTO_ID,
            TIPO_SUBASTA_ID,
            ESTADO_SUBASTA_ID,
            MOTIVO_SUSPEN_ID,
            SUBMOTIVO_SUSPEN_ID,
            MOTIVO_CANCEL_ID,
            TIPO_ADJUDICACION_ID,
            FECHA_ANUNCIO_SUBASTA,
            FECHA_SOLICITUD_SUBASTA,
            FECHA_SENYALAMIENTO_SUBASTA,
            TD_ANUNCIO_SOLICITUD,
            TD_SENYALAMIENTO_ANUNCIO,
            TD_SENYALAMIENTO_SOLICITUD,
            IMP_PUJA_SIN_POSTORES,
            IMP_PUJA_CON_POSTORES_DESDE,
            IMP_PUJA_CON_POSTORES_HASTA,
            IMP_VALOR_SUBASTA,
            IMP_DEUDA_JUDICIAL,
            IMP_DEUDA_JUDICIAL_SUB,
            P_ANUNCIO_SOLICITUD,
            P_SENYALAMIENTO_ANUNCIO,
            P_SENYALAMIENTO_SOLICITUD,
            NUM_PROCEDIMIENTO
      from H_SUB where DIA_ID = max_dia_mes;
      
      V_ROWCOUNT := sql%rowcount;     

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
      -- Crear indices H_PRC_MES 
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_MES_IX'', ''H_SUB_MES (MES_ID, ASUNTO_ID, SUBASTA_ID, LOTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;  

   end loop C_MESES_LOOP;
  close c_mes;
--                                      H_SUB_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_SUB_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_SUB;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
      
      -- Borrar indices H_PRC_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_SUB_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los trimestres a insertar
      delete from H_SUB_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;
      
      insert into H_SUB_TRIMESTRE(
                  TRIMESTRE_ID,
                  FECHA_CARGA_DATOS,
                  ASUNTO_ID,
                  PROCEDIMIENTO_ID,
                  SUBASTA_ID,
                  LOTE_ID,
                  NUMERO_AUTO_ID,
                  TIPO_SUBASTA_ID,
                  ESTADO_SUBASTA_ID,
                  MOTIVO_SUSPEN_ID,
                  SUBMOTIVO_SUSPEN_ID,
                  MOTIVO_CANCEL_ID,
                  TIPO_ADJUDICACION_ID,
                  FECHA_ANUNCIO_SUBASTA,
                  FECHA_SOLICITUD_SUBASTA,
                  FECHA_SENYALAMIENTO_SUBASTA,
                  TD_ANUNCIO_SOLICITUD,
                  TD_SENYALAMIENTO_ANUNCIO,
                  TD_SENYALAMIENTO_SOLICITUD,
                  IMP_PUJA_SIN_POSTORES,
                  IMP_PUJA_CON_POSTORES_DESDE,
                  IMP_PUJA_CON_POSTORES_HASTA,
                  IMP_VALOR_SUBASTA,
                  IMP_DEUDA_JUDICIAL,
                  IMP_DEUDA_JUDICIAL_SUB,
                  P_ANUNCIO_SOLICITUD,
                  P_SENYALAMIENTO_ANUNCIO,
                  P_SENYALAMIENTO_SOLICITUD,
                  NUM_PROCEDIMIENTO
                  )
      select trimestre,
             max_dia_trimestre,
            ASUNTO_ID,
            PROCEDIMIENTO_ID,
            SUBASTA_ID,
            LOTE_ID,
            NUMERO_AUTO_ID,
            TIPO_SUBASTA_ID,
            ESTADO_SUBASTA_ID,
            MOTIVO_SUSPEN_ID,
            SUBMOTIVO_SUSPEN_ID,
            MOTIVO_CANCEL_ID,
            TIPO_ADJUDICACION_ID,
            FECHA_ANUNCIO_SUBASTA,
            FECHA_SOLICITUD_SUBASTA,
            FECHA_SENYALAMIENTO_SUBASTA,
            TD_ANUNCIO_SOLICITUD,
            TD_SENYALAMIENTO_ANUNCIO,
            TD_SENYALAMIENTO_SOLICITUD,
            IMP_PUJA_SIN_POSTORES,
            IMP_PUJA_CON_POSTORES_DESDE,
            IMP_PUJA_CON_POSTORES_HASTA,
            IMP_VALOR_SUBASTA,
            IMP_DEUDA_JUDICIAL,
            IMP_DEUDA_JUDICIAL_SUB,
            P_ANUNCIO_SOLICITUD,
            P_SENYALAMIENTO_ANUNCIO,
            P_SENYALAMIENTO_SOLICITUD,
            NUM_PROCEDIMIENTO
      from H_SUB where DIA_ID = max_dia_trimestre;
      
      V_ROWCOUNT := sql%rowcount;     

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
      -- Crear indices H_PRC_TRIMESTRE 
	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_TRIMESTRE_IX'', ''H_SUB_TRIMESTRE (TRIMESTRE_ID, ASUNTO_ID, SUBASTA_ID, LOTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;  

   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

-- ----------------------------------------------------------------------------------------------
--                                      H_SUB_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_SUB_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_SUB;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
  -- Bucle que recorre los a�os
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
      
      -- Crear indices H_PRC_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_SUB_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los a�s a insertar
      delete from H_SUB_ANIO where ANIO_ID = anio;
      commit;

      insert into H_SUB_ANIO(
                  ANIO_ID,
                  FECHA_CARGA_DATOS,
                  ASUNTO_ID,
                  PROCEDIMIENTO_ID,
                  SUBASTA_ID,
                  LOTE_ID,
                  NUMERO_AUTO_ID,
                  TIPO_SUBASTA_ID,
                  ESTADO_SUBASTA_ID,
                  MOTIVO_SUSPEN_ID,
                  SUBMOTIVO_SUSPEN_ID,
                  MOTIVO_CANCEL_ID,
                  TIPO_ADJUDICACION_ID,
                  FECHA_ANUNCIO_SUBASTA,
                  FECHA_SOLICITUD_SUBASTA,
                  FECHA_SENYALAMIENTO_SUBASTA,
                  TD_ANUNCIO_SOLICITUD,
                  TD_SENYALAMIENTO_ANUNCIO,
                  TD_SENYALAMIENTO_SOLICITUD,
                  IMP_PUJA_SIN_POSTORES,
                  IMP_PUJA_CON_POSTORES_DESDE,
                  IMP_PUJA_CON_POSTORES_HASTA,
                  IMP_VALOR_SUBASTA,
                  IMP_DEUDA_JUDICIAL,
                  IMP_DEUDA_JUDICIAL_SUB,
                  P_ANUNCIO_SOLICITUD,
                  P_SENYALAMIENTO_ANUNCIO,
                  P_SENYALAMIENTO_SOLICITUD,
                  NUM_PROCEDIMIENTO
                  )
      select anio,
             max_dia_anio,
            ASUNTO_ID,
            PROCEDIMIENTO_ID,
            SUBASTA_ID,
            LOTE_ID,
            NUMERO_AUTO_ID,
            TIPO_SUBASTA_ID,
            ESTADO_SUBASTA_ID,
            MOTIVO_SUSPEN_ID,
            SUBMOTIVO_SUSPEN_ID,
            MOTIVO_CANCEL_ID,
            TIPO_ADJUDICACION_ID,
            FECHA_ANUNCIO_SUBASTA,
            FECHA_SOLICITUD_SUBASTA,
            FECHA_SENYALAMIENTO_SUBASTA,
            TD_ANUNCIO_SOLICITUD,
            TD_SENYALAMIENTO_ANUNCIO,
            TD_SENYALAMIENTO_SOLICITUD,
            IMP_PUJA_SIN_POSTORES,
            IMP_PUJA_CON_POSTORES_DESDE,
            IMP_PUJA_CON_POSTORES_HASTA,
            IMP_VALOR_SUBASTA,
            IMP_DEUDA_JUDICIAL,
            IMP_DEUDA_JUDICIAL_SUB,
            P_ANUNCIO_SOLICITUD,
            P_SENYALAMIENTO_ANUNCIO,
            P_SENYALAMIENTO_SOLICITUD,
            NUM_PROCEDIMIENTO
      from H_SUB where DIA_ID = max_dia_anio;
      
      V_ROWCOUNT := sql%rowcount;     

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_SUB_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
      -- Crear indices H_PRC_ANIO 
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_SUB_ANIO_IX'', ''H_SUB_ANIO (ANIO_ID, ASUNTO_ID, SUBASTA_ID, LOTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit; 

   end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'H_SUB_ANIO. Termina Carga', 3;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

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

    DBMS_OUTPUT.PUT_LINE(SQLCODE||' -> '||SQLERRM);
    --ROLLBACK;
end;

END CARGAR_H_SUBASTA;
/
EXIT



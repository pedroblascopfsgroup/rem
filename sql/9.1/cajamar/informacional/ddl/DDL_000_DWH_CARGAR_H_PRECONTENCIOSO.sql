--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160503
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-3200
--## PRODUCTO=NO
--## 
--## Finalidad: e modifica el Plazo Inicio Exp Prejudicial a Finalizado utilizando com fecha de inicio FECHA_INICIO_PRE
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE CARGAR_H_PRECONTENCIOSO (DATE_START IN DATE, DATE_END IN DATE, O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: María V, PFS Group
-- Fecha ultima modificacion:03/05/16
-- Motivos del cambio: Se modifica el Plazo Inicio Exp Prejudicial a Finalizado utilizando com fecha de inicio FECHA_INICIO_PRE
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas de hechos de PreContencioso
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================

-- ===============================================================================================
--                                    Declaracación de variables
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

  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PRECONTENCIOSO';
  V_ROWCOUNT NUMBER;

  cursor c_fecha_rellenar is select distinct(DIA_ID) DIA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_fecha is select distinct(DIA_ID) DIA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA order by 1;
  cursor c_mes is select distinct MES_H from TMP_FECHA order by 1;
  cursor c_trimestre is select distinct TRIMESTRE_H from TMP_FECHA order by 1;
  cursor c_anio is select distinct ANIO_H from TMP_FECHA order by 1;

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HandLER DE ERROR
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
      
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
  
   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    execute immediate 'insert into TMP_H_PRE(
              DIA_ID,
              FECHA_CARGA_DATOS,
              PROCEDIMIENTO_ID,
              FECHA_INICIO_PRE,
              TIPO_PROCEDIMIENTO_PRE_ID,
              TIPO_PREPARACION_ID,
              GESTOR_PRE_ID, 
              NUM_PREJUDICIALES,
              GRADO_AVANCE_DOCUMENTOS,
              GRADO_AVANCE_LIQUIDACIONES,
              GRADO_AVANCE_BUROFAXES,
              TRAMO_AVANCE_DOCUMENTO_ID,
              TRAMO_AVANCE_LIQUIDACION_ID,
              TRAMO_AVANCE_BUROFAX_ID,
        ESTADO_PREPARACION_ID
              )
      select '''||fecha||''',
             '''||fecha||''',
             PRC_ID,  
             trunc(FECHACREAR),
             nvl(PCO_PRC_TIPO_PRC_PROP, -1),
             nvl(DD_PCO_PTP_ID, -1),
             -1,
             1,
             0,
             0,
             -1,
             -1,
             -1,
             -1,
       -1
      from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS 
      where trunc(FECHACREAR) <= '''||fecha||''' and BORRADO = 0';
      
    V_ROWCOUNT := sql%rowcount;
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    
    -- Crear indices TMP_H_PRE
  
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_IX'', ''TMP_H_PRE (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    commit;    
    
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRE_FECHA_ESTADO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    execute immediate 'insert into TMP_PRE_FECHA_ESTADO(
            PROCEDIMIENTO_ID, 
            PCO_PRC_ID,
            FECHA_ACTUAL_ESTADO)
        select PRC_ID,
               hprc.PCO_PRC_ID,
               max(PCO_PRC_HEP_FECHA_INCIO)
        from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc 
        where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
        group by PRC_ID, hprc.PCO_PRC_ID';
    commit;
    
        execute immediate 'merge into TMP_PRE_FECHA_ESTADO t1
                           using (select a.pco_prc_id, a.PCO_PRC_HEP_FECHA_INCIO, a.pco_prc_hep_id, a.DD_PCO_PEP_ID
                                  from '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP a 
                           left join 
                           (select PCO_PRC_ID, Max(PCO_PRC_HEP_FECHA_INCIO) as fecha, max(pco_prc_hep_id) as secuencial
                                  from '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP where trunc(FECHACREAR) <= '''||fecha||''' and BORRADO = 0
                                  group by pco_prc_id) b
                           on a.pco_prc_id=b.pco_prc_id and a.PCO_PRC_HEP_FECHA_INCIO=b.fecha and a.pco_prc_hep_id=b.secuencial and trunc(a.FECHACREAR) <= '''||fecha||''' and a.BORRADO = 0
                           where b.pco_prc_id is not null) t2

                           on (t1.PCO_PRC_ID = t2.PCO_PRC_ID and t1.FECHA_ACTUAL_ESTADO = t2.PCO_PRC_HEP_FECHA_INCIO)
                           when matched then update set t1.ESTADO_PREPARACION_ID = t2.DD_PCO_PEP_ID';
commit; 

  /* 
execute immediate 'merge into  TMP_PRE_FECHA_ESTADO t3
            using
          (select t1.PCO_PRC_ID,t2.DD_PCO_PEP_ID from
            (select PCO_PRC_ID, max(nvl(PCO_PRC_HEP_FECHA_FIN,''26/11/80'') ) as PCO_PRC_HEP_FECHA_FIN 
          from '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP 
          where trunc(PCO_PRC_HEP_FECHA_INCIO)<='''||fecha||'''
          group by PCO_PRC_ID) t1
          join 
          (select PCO_PRC_ID, nvl(PCO_PRC_HEP_FECHA_FIN,''26/11/80'') as PCO_PRC_HEP_FECHA_FIN,DD_PCO_PEP_ID  
          from '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP 
          where trunc(PCO_PRC_HEP_FECHA_INCIO)<='''||fecha||''') t2
          on t1.PCO_PRC_ID=t2.PCO_PRC_ID and t1.PCO_PRC_HEP_FECHA_FIN =t2.PCO_PRC_HEP_FECHA_FIN
        )t4
        
         on (t3.PCO_PRC_ID = t4.PCO_PRC_ID)
          when matched then update set t3.ESTADO_PREPARACION_ID = t4.DD_PCO_PEP_ID';
  */   
            
                         
    execute immediate 'merge into TMP_H_PRE t1
                       using (select PROCEDIMIENTO_ID, ESTADO_PREPARACION_ID from TMP_PRE_FECHA_ESTADO) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID)
                      when matched then update set t1.ESTADO_PREPARACION_ID = t2.ESTADO_PREPARACION_ID where t1.DIA_ID = '''||fecha||'''';
    commit;
  
    -- Fechas
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select PRC_ID, max(trunc(PCO_PRC_HEP_FECHA_INCIO)) as FECHA_ESTADO 
                              from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc, '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION dd
                              where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and hprc.DD_PCO_PEP_ID = dd.DD_PCO_PEP_ID and dd.DD_PCO_PEP_DESCRIPCION = ''En estudio'' and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
                              group by PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_ESTUDIO_PRE = t2.FECHA_ESTADO where t1.DIA_ID = '''||fecha||'''';
    commit;
   
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select PRC_ID, max(trunc(PCO_PRC_HEP_FECHA_INCIO)) as FECHA_ESTADO 
                              from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc, '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION dd
                              where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and hprc.DD_PCO_PEP_ID = dd.DD_PCO_PEP_ID and (dd.DD_PCO_PEP_DESCRIPCION = ''En Preparado'' or dd.DD_PCO_PEP_DESCRIPCION = ''Preparacion'') and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
                              group by PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_PREPARADO_PRE = t2.FECHA_ESTADO where t1.DIA_ID = '''||fecha||'''';
    commit;
  
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select PRC_ID, max(trunc(PCO_PRC_HEP_FECHA_INCIO)) as FECHA_ESTADO 
                              from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc, '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION dd
                              where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and hprc.DD_PCO_PEP_ID = dd.DD_PCO_PEP_ID and dd.DD_PCO_PEP_DESCRIPCION = ''Enviado'' and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
                              group by PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_ENV_LET_PRE = t2.FECHA_ESTADO where t1.DIA_ID = '''||fecha||'''';
    commit;
  
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select PRC_ID, max(trunc(PCO_PRC_HEP_FECHA_INCIO)) as FECHA_ESTADO 
                              from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc, '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION dd
                              where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and hprc.DD_PCO_PEP_ID = dd.DD_PCO_PEP_ID and dd.DD_PCO_PEP_DESCRIPCION = ''Finalizado'' and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
                              group by PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_FINALIZADO_PRE = t2.FECHA_ESTADO where t1.DIA_ID = '''||fecha||'''';
    commit;
  
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select PRC_ID, max(trunc(PCO_PRC_HEP_FECHA_INCIO)) as FECHA_ESTADO 
                              from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc, '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION dd
                              where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and hprc.DD_PCO_PEP_ID = dd.DD_PCO_PEP_ID and (dd.DD_PCO_PEP_DESCRIPCION = ''Subsanar'' or dd.DD_PCO_PEP_DESCRIPCION = ''Subsanar por cambio proc'') and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
                              group by PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_ULT_SUBSANACION_PRE = t2.FECHA_ESTADO where t1.DIA_ID = '''||fecha||'''';
    commit;
    
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select PRC_ID, max(trunc(PCO_PRC_HEP_FECHA_INCIO)) as FECHA_ESTADO 
                              from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc, '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION dd
                              where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and hprc.DD_PCO_PEP_ID = dd.DD_PCO_PEP_ID and dd.DD_PCO_PEP_DESCRIPCION = ''Cancelado'' and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
                              group by PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_CANCELADO_PRE = t2.FECHA_ESTADO where t1.DIA_ID = '''||fecha||'''';
    commit;
    
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select PRC_ID, max(trunc(PCO_PRC_HEP_FECHA_INCIO)) as FECHA_ESTADO 
                              from '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc, '||V_DATASTAGE||'.PCO_PRC_HEP_HISTOR_EST_PREP hprc, '||V_DATASTAGE||'.DD_PCO_PRC_ESTADO_PREPARACION dd
                              where prc.PCO_PRC_ID = hprc.PCO_PRC_ID and hprc.DD_PCO_PEP_ID = dd.DD_PCO_PEP_ID and dd.DD_PCO_PEP_DESCRIPCION = ''Paralizado'' and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0 and trunc(hprc.FECHACREAR) <= '''||fecha||''' and hprc.BORRADO = 0
                              group by PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.FECHA_PARALIZADO_PRE = t2.FECHA_ESTADO where t1.DIA_ID = '''||fecha||'''';
    commit;

    update TMP_H_PRE set P_PRE_INICIO_PREPARADO =  trunc(FECHA_PREPARADO_PRE) - trunc(FECHA_INICIO_PRE);
    update TMP_H_PRE set P_PRE_PREPARADO_ENV_LET =  trunc(FECHA_ENV_LET_PRE) - trunc(FECHA_PREPARADO_PRE);
    update TMP_H_PRE set P_PRE_ENV_LET_FINALIZADO =  trunc(FECHA_FINALIZADO_PRE) - trunc(FECHA_ENV_LET_PRE);
    update TMP_H_PRE set P_PRE_INICIO_FINALIZADO =  trunc(FECHA_FINALIZADO_PRE) - trunc(FECHA_INICIO_PRE);                   
    commit;

    --GESTOR_DOC_ID
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    EXECUTE IMMEDIATE
    'INSERT INTO TMP_PRC_GESTOR (PROCEDIMIENTO_ID, GESTOR_PRC_ID)
    SELECT PRC.PRC_ID, USU.USU_ID FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD
                      JOIN '||V_DATASTAGE||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
                      JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
                      JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID
                      JOIN '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS PRC ON GAA.ASU_ID = PRC.ASU_ID
                      WHERE TGES.DD_TGE_DESCRIPCION = ''Gestor de Documentación''';

    UPDATE TMP_H_PRE a SET GESTOR_PRE_ID = (SELECT GESTOR_PRC_ID FROM TMP_PRC_GESTOR b WHERE a.PROCEDIMIENTO_ID =  b.PROCEDIMIENTO_ID);
      commit;
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE. Termina Updates(1)', 4;

    --GRADO_AVANCE_DOCUMENTOS   select * from RECOVERY_CM_datastage.DD_PCO_DOC_ESTADO; --DD_PCO_DED_ID = 4 --Disponible/Recibido
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select  prc.PRC_ID, sum(case doc.DD_PCO_DED_ID when 4 then 1 else 0 end) / count(*) as porcentaje
                              from '||V_DATASTAGE||'.PCO_DOC_DOCUMENTOS doc,  '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc 
                              where doc.PCO_PRC_ID = prc.PCO_PRC_ID 
                              and trunc(doc.FECHACREAR) <= '''||fecha||''' and doc.BORRADO = 0
                              and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0
                              group by prc.PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.GRADO_AVANCE_DOCUMENTOS = t2.porcentaje where t1.DIA_ID = '''||fecha||'''';
    commit;
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE. Termina Update GRADO_AVANCE_DOCUMENTOS', 4;

    --GRADO_AVANCE_LIQUIDACIONES    select * from RECOVERY_CM_datastage.DD_PCO_LIQ_ESTADO; --DD_PCO_LIQ_ID = 4 --Confirmada
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select  prc.PRC_ID, sum(case doc.DD_PCO_LIQ_ID when 4 then 1 else 0 end) / count(*) as porcentaje
                              from '||V_DATASTAGE||'.PCO_LIQ_LIQUIDACIONES doc,  '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc 
                              where doc.PCO_PRC_ID = prc.PCO_PRC_ID 
                              and trunc(doc.FECHACREAR) <= '''||fecha||''' and doc.BORRADO = 0
                              and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0
                              group by prc.PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.GRADO_AVANCE_LIQUIDACIONES = t2.porcentaje where t1.DIA_ID = '''||fecha||'''';
    commit;
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE. Termina Update GRADO_AVANCE_LIQUIDACIONES', 4;

    --GRADO_AVANCE_BUROFAXES    select * from RECOVERY_CM_datastage.DD_PCO_BFE_ESTADO; --DD_PCO_BFE_ID = 1 --Notificado
    execute immediate 'merge into TMP_H_PRE t1  
                       using (select  prc.PRC_ID, sum(case doc.DD_PCO_BFE_ID when 1 then 1 else 0 end) / count(*) as porcentaje
                              from '||V_DATASTAGE||'.PCO_BUR_BUROFAX doc,  '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS prc 
                              where doc.PCO_PRC_ID = prc.PCO_PRC_ID 
                              and trunc(doc.FECHACREAR) <= '''||fecha||''' and doc.BORRADO = 0
                              and trunc(prc.FECHACREAR) <= '''||fecha||''' and prc.BORRADO = 0
                              group by prc.PRC_ID) t2
                       on (t1.PROCEDIMIENTO_ID = t2.PRC_ID)
                       when matched then update set t1.GRADO_AVANCE_BUROFAXES = t2.porcentaje where t1.DIA_ID = '''||fecha||'''';
    commit;
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE. Termina Update GRADO_AVANCE_BUROFAXES', 4;

    update TMP_H_PRE
    set TRAMO_AVANCE_DOCUMENTO_ID = case  when GRADO_AVANCE_DOCUMENTOS >= 0 and GRADO_AVANCE_DOCUMENTOS < 0.25 then 1
                                          when GRADO_AVANCE_DOCUMENTOS >= 0.25 and GRADO_AVANCE_DOCUMENTOS < 0.50 then 2
                                          when GRADO_AVANCE_DOCUMENTOS >= 0.50 and GRADO_AVANCE_DOCUMENTOS < 0.75 then 3
                                          when GRADO_AVANCE_DOCUMENTOS >= 0.75 and GRADO_AVANCE_DOCUMENTOS <= 1 then 4
                                          else -1
                                    end,
        TRAMO_AVANCE_LIQUIDACION_ID = case  when GRADO_AVANCE_LIQUIDACIONES >= 0 and GRADO_AVANCE_LIQUIDACIONES < 0.25 then 1
                                          when GRADO_AVANCE_LIQUIDACIONES >= 0.25 and GRADO_AVANCE_LIQUIDACIONES < 0.50 then 2
                                          when GRADO_AVANCE_LIQUIDACIONES >= 0.50 and GRADO_AVANCE_LIQUIDACIONES < 0.75 then 3
                                          when GRADO_AVANCE_LIQUIDACIONES >= 0.75 and GRADO_AVANCE_LIQUIDACIONES <= 1 then 4
                                          else -1
                                    end,                                      
        TRAMO_AVANCE_BUROFAX_ID = case  when GRADO_AVANCE_BUROFAXES >= 0 and GRADO_AVANCE_BUROFAXES < 0.25 then 1
                                          when GRADO_AVANCE_BUROFAXES >= 0.25 and GRADO_AVANCE_BUROFAXES < 0.50 then 2
                                          when GRADO_AVANCE_BUROFAXES >= 0.50 and GRADO_AVANCE_BUROFAXES < 0.75 then 3
                                          when GRADO_AVANCE_BUROFAXES >= 0.75 and GRADO_AVANCE_BUROFAXES <= 1 then 4
                                          else -1
                                    end;                                
    commit;
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE. Termina Update TRAMOS AVANCE', 4;

    
    -- Borrado del día a insertar
    delete from H_PRE where DIA_ID = fecha;
    commit;
    
    -- Borrado índices H_PRE
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    insert into H_PRE(DIA_ID,
                      FECHA_CARGA_DATOS, 
                      PROCEDIMIENTO_ID,
                      FECHA_INICIO_PRE,
                      FECHA_ESTUDIO_PRE,
                      FECHA_PREPARADO_PRE,
                      FECHA_ENV_LET_PRE,
                      FECHA_FINALIZADO_PRE,
                      FECHA_ULT_SUBSANACION_PRE,
                      FECHA_CANCELADO_PRE,
                      FECHA_PARALIZADO_PRE,
                      PROPIETARIO_PRC_ID,
                      TIPO_PROCEDIMIENTO_PRE_ID,
                      ESTADO_PREPARACION_ID,
                      TIPO_PREPARACION_ID,
                      GESTOR_PRE_ID,                      
                      MOTIVO_CANCELACION_ID,
                      MOTIVO_SUBSANACION_ID,
                      TRAMO_SUBSANACION_ID,
                      TRAMO_AVANCE_DOCUMENTO_ID,
                      TRAMO_AVANCE_LIQUIDACION_ID,
                      TRAMO_AVANCE_BUROFAX_ID,
                      NUM_PREJUDICIALES,
                      P_PRE_INICIO_PREPARADO,
                      P_PRE_PREPARADO_ENV_LET,
                      P_PRE_ENV_LET_FINALIZADO,
                      P_PRE_INICIO_FINALIZADO,
                      GRADO_AVANCE_DOCUMENTOS,
                      GRADO_AVANCE_LIQUIDACIONES,
                      GRADO_AVANCE_BUROFAXES)  
    select  DIA_ID,
              FECHA_CARGA_DATOS, 
              PROCEDIMIENTO_ID,
              FECHA_INICIO_PRE,
              FECHA_ESTUDIO_PRE,
              FECHA_PREPARADO_PRE,
              FECHA_ENV_LET_PRE,
              FECHA_FINALIZADO_PRE,
              FECHA_ULT_SUBSANACION_PRE,
              FECHA_CANCELADO_PRE,
              FECHA_PARALIZADO_PRE,
              PROPIETARIO_PRC_ID,
              TIPO_PROCEDIMIENTO_PRE_ID,
              ESTADO_PREPARACION_ID,
              TIPO_PREPARACION_ID,
              GESTOR_PRE_ID,               
              MOTIVO_CANCELACION_ID,
              MOTIVO_SUBSANACION_ID,
              TRAMO_SUBSANACION_ID,
              TRAMO_AVANCE_DOCUMENTO_ID,
              TRAMO_AVANCE_LIQUIDACION_ID,
              TRAMO_AVANCE_BUROFAX_ID,
              NUM_PREJUDICIALES,
              P_PRE_INICIO_PREPARADO,
              P_PRE_PREPARADO_ENV_LET,
              P_PRE_ENV_LET_FINALIZADO,
              P_PRE_INICIO_FINALIZADO,
              GRADO_AVANCE_DOCUMENTOS,
              GRADO_AVANCE_LIQUIDACIONES,
              GRADO_AVANCE_BUROFAXES
      from TMP_H_PRE;

    V_ROWCOUNT := sql%rowcount;
    commit;
  
    update h_pre set gestor_pre_id=-1 where gestor_pre_id is null
  and dia_id=fecha;
  commit;
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;

    end loop;
  close c_fecha;
  
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE. Registros Insertados y updateados: ' || TO_CHAR(V_ROWCOUNT), 4;
  commit;
  
  -- Crear índices TMP_H_PRE
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_IX'', ''H_PRE (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;
  


/*
ELIMINAR TIPO_PROCEDIMIENTO_PRE_ID NUMBER(16,0),
                              
MOTIVO_CANCELACION_ID NUMBER(16,0) NULL,
MOTIVO_SUBSANACION_ID NUMBER(16,0) NULL,
TRAMO_SUBSANACION_ID NUMBER(16,0) NULL,

*/   


-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PRE_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PRE_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);

  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    -- Borrado de las semanas a insertar
    delete from H_PRE_SEMANA where SEMANA_ID = semana;
    commit;
    
    -- Borrado indices H_PRE_SEMANA 
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    insert into H_PRE_SEMANA(SEMANA_ID,
                              FECHA_CARGA_DATOS, 
                              PROCEDIMIENTO_ID,
                              FECHA_INICIO_PRE,
                              FECHA_ESTUDIO_PRE,
                              FECHA_PREPARADO_PRE,
                              FECHA_ENV_LET_PRE,
                              FECHA_FINALIZADO_PRE,
                              FECHA_ULT_SUBSANACION_PRE,
                              FECHA_CANCELADO_PRE,
                              FECHA_PARALIZADO_PRE,
                              PROPIETARIO_PRC_ID,
                              TIPO_PROCEDIMIENTO_PRE_ID,
                              ESTADO_PREPARACION_ID,
                              TIPO_PREPARACION_ID,
                              GESTOR_PRE_ID,                                
                              MOTIVO_CANCELACION_ID,
                              MOTIVO_SUBSANACION_ID,
                              TRAMO_SUBSANACION_ID,
                              TRAMO_AVANCE_DOCUMENTO_ID,
                              TRAMO_AVANCE_LIQUIDACION_ID,
                              TRAMO_AVANCE_BUROFAX_ID,
                              NUM_PREJUDICIALES,
                              P_PRE_INICIO_PREPARADO,
                              P_PRE_PREPARADO_ENV_LET,
                              P_PRE_ENV_LET_FINALIZADO,
                              P_PRE_INICIO_FINALIZADO,
                              GRADO_AVANCE_DOCUMENTOS,
                              GRADO_AVANCE_LIQUIDACIONES,
                              GRADO_AVANCE_BUROFAXES
                              )
    select semana, 
            max_dia_semana,
            PROCEDIMIENTO_ID,
            FECHA_INICIO_PRE,
            FECHA_ESTUDIO_PRE,
            FECHA_PREPARADO_PRE,
            FECHA_ENV_LET_PRE,
            FECHA_FINALIZADO_PRE,
            FECHA_ULT_SUBSANACION_PRE,
            FECHA_CANCELADO_PRE,
            FECHA_PARALIZADO_PRE,
            PROPIETARIO_PRC_ID,
            TIPO_PROCEDIMIENTO_PRE_ID,
            ESTADO_PREPARACION_ID,
            TIPO_PREPARACION_ID,
            GESTOR_PRE_ID,             
            MOTIVO_CANCELACION_ID,
            MOTIVO_SUBSANACION_ID,
            TRAMO_SUBSANACION_ID,
            TRAMO_AVANCE_DOCUMENTO_ID,
            TRAMO_AVANCE_LIQUIDACION_ID,
            TRAMO_AVANCE_BUROFAX_ID,
            NUM_PREJUDICIALES,
            P_PRE_INICIO_PREPARADO,
            P_PRE_PREPARADO_ENV_LET,
            P_PRE_ENV_LET_FINALIZADO,
            P_PRE_INICIO_FINALIZADO,
            GRADO_AVANCE_DOCUMENTOS,
            GRADO_AVANCE_LIQUIDACIONES,
            GRADO_AVANCE_BUROFAXES
     from H_PRE
     where DIA_ID = max_dia_semana;
     
    V_ROWCOUNT := sql%rowcount;
    commit;

     --Log_Proceso
     execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
     
      
    end loop C_SEMANAS_LOOP;
    close c_semana; 
    
    -- Crear índices H_PRE_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_SEMANA_IX'', ''H_PRE_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;

-- ----------------------------------------------------------------------------------------------
--                                     H_PRE_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_MES. Empieza Carga', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PRE_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  
  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;

      -- Borrado de los meses a insertar
      delete from H_PRE_MES where MES_ID = mes;
      commit;
      
      -- Borrado indices H_PRE_MES
      
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Insertado de meses (último día del mes disponible en H_PRE)
      insert into H_PRE_MES(MES_ID,
                            FECHA_CARGA_DATOS, 
                            PROCEDIMIENTO_ID,
                            FECHA_INICIO_PRE,
                            FECHA_ESTUDIO_PRE,
                            FECHA_PREPARADO_PRE,
                            FECHA_ENV_LET_PRE,
                            FECHA_FINALIZADO_PRE,
                            FECHA_ULT_SUBSANACION_PRE,
                            FECHA_CANCELADO_PRE,
                            FECHA_PARALIZADO_PRE,
                            PROPIETARIO_PRC_ID,
                            TIPO_PROCEDIMIENTO_PRE_ID,
                            ESTADO_PREPARACION_ID,
                            TIPO_PREPARACION_ID,
                            GESTOR_PRE_ID,                             
                            MOTIVO_CANCELACION_ID,
                            MOTIVO_SUBSANACION_ID,
                            TRAMO_SUBSANACION_ID,
                            TRAMO_AVANCE_DOCUMENTO_ID,
                            TRAMO_AVANCE_LIQUIDACION_ID,
                            TRAMO_AVANCE_BUROFAX_ID,
                            NUM_PREJUDICIALES,
                            P_PRE_INICIO_PREPARADO,
                            P_PRE_PREPARADO_ENV_LET,
                            P_PRE_ENV_LET_FINALIZADO,
                            P_PRE_INICIO_FINALIZADO,
                            GRADO_AVANCE_DOCUMENTOS,
                            GRADO_AVANCE_LIQUIDACIONES,
                            GRADO_AVANCE_BUROFAXES
                            )
      select mes,
            max_dia_mes,
            PROCEDIMIENTO_ID,
            FECHA_INICIO_PRE,
            FECHA_ESTUDIO_PRE,
            FECHA_PREPARADO_PRE,
            FECHA_ENV_LET_PRE,
            FECHA_FINALIZADO_PRE,
            FECHA_ULT_SUBSANACION_PRE,
            FECHA_CANCELADO_PRE,
            FECHA_PARALIZADO_PRE,
            PROPIETARIO_PRC_ID,
            TIPO_PROCEDIMIENTO_PRE_ID,
            ESTADO_PREPARACION_ID,
            TIPO_PREPARACION_ID,
            GESTOR_PRE_ID,             
            MOTIVO_CANCELACION_ID,
            MOTIVO_SUBSANACION_ID,
            TRAMO_SUBSANACION_ID,
            TRAMO_AVANCE_DOCUMENTO_ID,
            TRAMO_AVANCE_LIQUIDACION_ID,
            TRAMO_AVANCE_BUROFAX_ID,
            NUM_PREJUDICIALES,
            P_PRE_INICIO_PREPARADO,
            P_PRE_PREPARADO_ENV_LET,
            P_PRE_ENV_LET_FINALIZADO,
            P_PRE_INICIO_FINALIZADO,
            GRADO_AVANCE_DOCUMENTOS,
            GRADO_AVANCE_LIQUIDACIONES,
            GRADO_AVANCE_BUROFAXES
      from H_PRE where DIA_ID = max_dia_mes;

      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
   end loop C_MESES_LOOP;
  close c_mes;
      
  -- Crear indices H_PRE_MES 
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_MES_IX'', ''H_PRE_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  

-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PRE_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
      
      -- Borrado de los trimestres a insertar
      delete from H_PRE_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;
      
      -- Borrar indices H_PRE_TRIMESTRE
      
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      insert into H_PRE_TRIMESTRE(TRIMESTRE_ID,
                                  FECHA_CARGA_DATOS, 
                                  PROCEDIMIENTO_ID,
                                  FECHA_INICIO_PRE,
                                  FECHA_ESTUDIO_PRE,
                                  FECHA_PREPARADO_PRE,
                                  FECHA_ENV_LET_PRE,
                                  FECHA_FINALIZADO_PRE,
                                  FECHA_ULT_SUBSANACION_PRE,
                                  FECHA_CANCELADO_PRE,
                                  FECHA_PARALIZADO_PRE,
                                  PROPIETARIO_PRC_ID,
                                  TIPO_PROCEDIMIENTO_PRE_ID,
                                  ESTADO_PREPARACION_ID,
                                  TIPO_PREPARACION_ID,
                                  GESTOR_PRE_ID,                                   
                                  MOTIVO_CANCELACION_ID,
                                  MOTIVO_SUBSANACION_ID,
                                  TRAMO_SUBSANACION_ID,
                                  TRAMO_AVANCE_DOCUMENTO_ID,
                                  TRAMO_AVANCE_LIQUIDACION_ID,
                                  TRAMO_AVANCE_BUROFAX_ID,
                                  NUM_PREJUDICIALES,
                                  P_PRE_INICIO_PREPARADO,
                                  P_PRE_PREPARADO_ENV_LET,
                                  P_PRE_ENV_LET_FINALIZADO,
                                  P_PRE_INICIO_FINALIZADO,
                                  GRADO_AVANCE_DOCUMENTOS,
                                  GRADO_AVANCE_LIQUIDACIONES,
                                  GRADO_AVANCE_BUROFAXES
                                  )
      select trimestre,
            max_dia_trimestre,
            PROCEDIMIENTO_ID,
            FECHA_INICIO_PRE,
            FECHA_ESTUDIO_PRE,
            FECHA_PREPARADO_PRE,
            FECHA_ENV_LET_PRE,
            FECHA_FINALIZADO_PRE,
            FECHA_ULT_SUBSANACION_PRE,
            FECHA_CANCELADO_PRE,
            FECHA_PARALIZADO_PRE,
            PROPIETARIO_PRC_ID,
            TIPO_PROCEDIMIENTO_PRE_ID,
            ESTADO_PREPARACION_ID,
            TIPO_PREPARACION_ID,
            GESTOR_PRE_ID,           
            MOTIVO_CANCELACION_ID,
            MOTIVO_SUBSANACION_ID,
            TRAMO_SUBSANACION_ID,
            TRAMO_AVANCE_DOCUMENTO_ID,
            TRAMO_AVANCE_LIQUIDACION_ID,
            TRAMO_AVANCE_BUROFAX_ID,
            NUM_PREJUDICIALES,
            P_PRE_INICIO_PREPARADO,
            P_PRE_PREPARADO_ENV_LET,
            P_PRE_ENV_LET_FINALIZADO,
            P_PRE_INICIO_FINALIZADO,
            GRADO_AVANCE_DOCUMENTOS,
            GRADO_AVANCE_LIQUIDACIONES,
            GRADO_AVANCE_BUROFAXES
      from H_PRE where DIA_ID = max_dia_trimestre;
      
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
      
      -- Crear indices H_PRE_TRIMESTRE 
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_TRIMESTRE_IX'', ''H_PRE_TRIMESTRE (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;  


-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d?a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PRE_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
  -- Bucle que recorre los a?os
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
      
      -- Borrado de los a?s a insertar
      delete from H_PRE_ANIO where ANIO_ID = anio;
      commit;
      
      -- Crear indices H_PRE_ANIO
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      insert into H_PRE_ANIO(ANIO_ID,
                            FECHA_CARGA_DATOS, 
                            PROCEDIMIENTO_ID,
                            FECHA_INICIO_PRE,
                            FECHA_ESTUDIO_PRE,
                            FECHA_PREPARADO_PRE,
                            FECHA_ENV_LET_PRE,
                            FECHA_FINALIZADO_PRE,
                            FECHA_ULT_SUBSANACION_PRE,
                            FECHA_CANCELADO_PRE,
                            FECHA_PARALIZADO_PRE,
                            PROPIETARIO_PRC_ID,
                            TIPO_PROCEDIMIENTO_PRE_ID,
                            ESTADO_PREPARACION_ID,
                            TIPO_PREPARACION_ID,
                            GESTOR_PRE_ID,                             
                            MOTIVO_CANCELACION_ID,
                            MOTIVO_SUBSANACION_ID,
                            TRAMO_SUBSANACION_ID,
                            TRAMO_AVANCE_DOCUMENTO_ID,
                            TRAMO_AVANCE_LIQUIDACION_ID,
                            TRAMO_AVANCE_BUROFAX_ID,
                            NUM_PREJUDICIALES,
                            P_PRE_INICIO_PREPARADO,
                            P_PRE_PREPARADO_ENV_LET,
                            P_PRE_ENV_LET_FINALIZADO,
                            P_PRE_INICIO_FINALIZADO,
                            GRADO_AVANCE_DOCUMENTOS,
                            GRADO_AVANCE_LIQUIDACIONES,
                            GRADO_AVANCE_BUROFAXES
                            )
      select anio,
            max_dia_anio,
            PROCEDIMIENTO_ID,
            FECHA_INICIO_PRE,
            FECHA_ESTUDIO_PRE,
            FECHA_PREPARADO_PRE,
            FECHA_ENV_LET_PRE,
            FECHA_FINALIZADO_PRE,
            FECHA_ULT_SUBSANACION_PRE,
            FECHA_CANCELADO_PRE,
            FECHA_PARALIZADO_PRE,
            PROPIETARIO_PRC_ID,
            TIPO_PROCEDIMIENTO_PRE_ID,
            ESTADO_PREPARACION_ID,
            TIPO_PREPARACION_ID,
            GESTOR_PRE_ID,              
            MOTIVO_CANCELACION_ID,
            MOTIVO_SUBSANACION_ID,
            TRAMO_SUBSANACION_ID,
            TRAMO_AVANCE_DOCUMENTO_ID,
            TRAMO_AVANCE_LIQUIDACION_ID,
            TRAMO_AVANCE_BUROFAX_ID,
            NUM_PREJUDICIALES,
            P_PRE_INICIO_PREPARADO,
            P_PRE_PREPARADO_ENV_LET,
            P_PRE_ENV_LET_FINALIZADO,
            P_PRE_INICIO_FINALIZADO,
            GRADO_AVANCE_DOCUMENTOS,
            GRADO_AVANCE_LIQUIDACIONES,
            GRADO_AVANCE_BUROFAXES
      from H_PRE where DIA_ID = max_dia_anio;
      
      V_ROWCOUNT := sql%rowcount;     
      commit;
      
      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
   end loop C_ANIO_LOOP;
  close c_anio;
      
    -- Crear indices H_PRE_ANIO 
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_ANIO_IX'', ''H_PRE_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'H_PRE_ANIO. Termina Carga', 3;  


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
    --ROLLBACK;
end;

END CARGAR_H_PRECONTENCIOSO;
/
EXIT


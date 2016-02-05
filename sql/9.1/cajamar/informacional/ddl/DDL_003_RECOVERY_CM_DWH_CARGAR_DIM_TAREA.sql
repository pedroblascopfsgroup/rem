--/*
--##########################################
--## AUTOR=Maria Villanueva
--## FECHA_CREACION=20160202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-1058
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de tabla D_CNT_ZONA y D_EXP_ZONA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


create or replace PROCEDURE CARGAR_DIM_TAREA(O_ERROR_STATUS OUT VARCHAR2) AS

-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN TAREA
    -- D_TAR_ALERTA;
    -- D_TAR_AMBITO;
    -- D_TAR_CUMPLIMIENTO;
    -- D_TAR_ESTADO_PRORROGA;
    -- D_TAR_PENDIENTE_RESPUESTA;
    -- D_TAR_MOTIVO_PRORROGA;
    -- D_TAR_RESOLUCION_PRORROGA;
    -- D_TAR_REALIZACION;
    -- D_TAR_TIPO;
    -- D_TAR_TIPO_DETALLE;
    -- D_TAR_GESTOR;
    -- D_TAR_TIPO_GESTOR
    -- D_TAR_SUPERVISOR;
    -- D_TAR_DESP_GESTOR;
    -- D_TAR_DESP_SUPERVISOR;
    -- D_TAR_TIPO_DESP_GESTOR; 
    -- D_TAR_TIPO_DESP_SUPERVISOR;
    -- D_TAR_ENTIDAD_GESTOR;
    -- D_TAR_ENTIDAD_SUPERVISOR; 
    -- D_TAR_NIVEL_DESP_GESTOR;
    -- D_TAR_NIVEL_DESP_SUPERVISOR;
    -- D_TAR_OFICINA_DESP_GESTOR;
    -- D_TAR_OFICINA_DESP_SUPERVISOR;
    -- D_TAR_PROV_DESP_GESTOR;
    -- D_TAR_PROV_DESP_SUPERVISOR;
    -- D_TAR_ZONA_DESP_GESTOR;
    -- D_TAR_ZONA_DESP_SUPERVISOR;
    -- D_TAR_DESCRIPCION;
    -- D_TAR_RESPONSABLE;
    -- D_TAR_ESTADO;
    -- D_TAR;

BEGIN
DECLARE

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
OBJECTEXISTS EXCEPTION;
INSERT_NULL EXCEPTION;
PARAMETERS_NUMBER EXCEPTION;
PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

V_NUM_ROW NUMBER(10);
V_DATASTAGE VARCHAR2(100);
V_MSQL VARCHAR(5000);

MAX_ID INT;
TAREA_DESC VARCHAR(100);
  
C_TAREA_DESC SYS_REFCURSOR;

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_TAREA';
V_ROWCOUNT NUMBER;

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_ALERTA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ALERTA WHERE TAREA_ALERTA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ALERTA (TAREA_ALERTA_ID, TAREA_ALERTA_DESC) VALUES (0, 'No Alerta');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ALERTA WHERE TAREA_ALERTA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ALERTA (TAREA_ALERTA_ID, TAREA_ALERTA_DESC) VALUES (1, 'Alerta');
  END IF;

  COMMIT;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_ALERTA. Realizados INSERTS', 3;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_AMBITO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_AMBITO WHERE AMBITO_TAREA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_AMBITO (AMBITO_TAREA_ID, AMBITO_TAREA_DESC) VALUES (0, 'Interno');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_AMBITO WHERE AMBITO_TAREA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_AMBITO (AMBITO_TAREA_ID, AMBITO_TAREA_DESC) VALUES (1, 'Externo');
  END IF;
  
  COMMIT;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_AMBITO. Realizados INSERTS', 3;

  
-- ----------------------------------------------------------------------------------------------
--                      D_TAR_CUMPLIMIENTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_CUMPLIMIENTO WHERE CUMPLIMIENTO_TAREA_ID = -2;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) VALUES (-2, 'Sin Fecha Vencimiento');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_CUMPLIMIENTO WHERE CUMPLIMIENTO_TAREA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) VALUES (-1, 'No Finalizada');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_CUMPLIMIENTO WHERE CUMPLIMIENTO_TAREA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) VALUES (0, 'En Plazo');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_CUMPLIMIENTO WHERE CUMPLIMIENTO_TAREA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) VALUES (1, 'Fuera De Plazo');
  END IF;

  COMMIT;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_CUMPLIMIENTO. Realizados INSERTS', 3;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_ESTADO_PRORROGA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ESTADO_PRORROGA WHERE ESTADO_PRORROGA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ESTADO_PRORROGA (ESTADO_PRORROGA_ID, ESTADO_PRORROGA_DESC) VALUES (0, 'No Respondido');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ESTADO_PRORROGA WHERE ESTADO_PRORROGA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ESTADO_PRORROGA (ESTADO_PRORROGA_ID, ESTADO_PRORROGA_DESC) VALUES (1, 'Respondido');
  END IF;

  COMMIT;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_ESTADO_PRORROGA. Realizados INSERTS', 3;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_MOTIVO_PRORROGA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_MOTIVO_PRORROGA WHERE MOTIVO_PRORROGA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_MOTIVO_PRORROGA (MOTIVO_PRORROGA_ID, MOTIVO_PRORROGA_DESC, MOTIVO_PRORROGA_DESC_2) VALUES (-1, 'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_MOTIVO_PRORROGA(MOTIVO_PRORROGA_ID, MOTIVO_PRORROGA_DESC, MOTIVO_PRORROGA_DESC_2)
     SELECT DD_CPR_ID, DD_CPR_DESCRIPCION, DD_CPR_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_CPR_CAUSA_PRORROGA';   
    
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_MOTIVO_PRORROGA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_PENDIENTE_RESPUESTA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_PENDIENTE_RESPUESTA WHERE PENDIENTE_RESPUESTA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_PENDIENTE_RESPUESTA (PENDIENTE_RESPUESTA_ID, PENDIENTE_RESPUESTA_DESC) VALUES (0, 'No En Espera');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_PENDIENTE_RESPUESTA WHERE PENDIENTE_RESPUESTA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_PENDIENTE_RESPUESTA (PENDIENTE_RESPUESTA_ID, PENDIENTE_RESPUESTA_DESC) VALUES (1, 'En Espera');
  END IF;

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_PENDIENTE_RESPUESTA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_REALIZACION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_REALIZACION WHERE REALIZACION_TAREA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_REALIZACION (REALIZACION_TAREA_ID, REALIZACION_TAREA_DESC) VALUES (0, 'Pendiente');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_REALIZACION WHERE REALIZACION_TAREA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_REALIZACION (REALIZACION_TAREA_ID, REALIZACION_TAREA_DESC) VALUES (1, 'Finalizada');
  END IF;

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_REALIZACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
  
-- ----------------------------------------------------------------------------------------------
--                                   D_TAR_RESOLUCION_PRORROGA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_RESOLUCION_PRORROGA WHERE RESOLUCION_PRORROGA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_RESOLUCION_PRORROGA (RESOLUCION_PRORROGA_ID, RESOLUCION_PRORROGA_DESC, RESOLUCION_PRORROGA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_RESOLUCION_PRORROGA(RESOLUCION_PRORROGA_ID, RESOLUCION_PRORROGA_DESC, RESOLUCION_PRORROGA_DESC_2)
     SELECT DD_RPR_ID, DD_RPR_DESCRIPCION, DD_RPR_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_RPR_RAZON_PRORROGA';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_RESOLUCION_PRORROGA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
  
-- ----------------------------------------------------------------------------------------------
--                                   D_TAR_TIPO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_TIPO WHERE TIPO_TAREA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_TIPO (TIPO_TAREA_ID, TIPO_TAREA_DESC, TIPO_TAREA_DESC_2) VALUES (-1 ,'Desconocido', -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_TIPO(TIPO_TAREA_ID, TIPO_TAREA_DESC, TIPO_TAREA_DESC_2)
     SELECT DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TAR_TIPO_TAREA_BASE';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_TIPO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
  
-- ----------------------------------------------------------------------------------------------
--                                  D_TAR_TIPO_DETALLE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_TIPO_DETALLE WHERE TIPO_TAREA_DETALLE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_TIPO_DETALLE (TIPO_TAREA_DETALLE_ID, TIPO_TAREA_DETALLE_DESC, TIPO_TAREA_DETALLE_DESC_2, TIPO_TAREA_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_TIPO_DETALLE(TIPO_TAREA_DETALLE_ID, TIPO_TAREA_DETALLE_DESC, TIPO_TAREA_DETALLE_DESC_2, TIPO_TAREA_ID)
     SELECT DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID FROM '||V_DATASTAGE||'.DD_STA_SUBTIPO_TAREA_BASE';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_TIPO_DETALLE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_GESTOR
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_GESTOR WHERE GESTOR_TAREA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_GESTOR(
      GESTOR_TAREA_ID,
      GESTOR_TAREA_NOMBRE_COMP,
      GESTOR_TAREA_NOMBRE,
      GESTOR_TAREA_APELLIDO1,
      GESTOR_TAREA_APELLIDO2,
      ENTIDAD_GESTOR_TAR_ID, 
      DESPACHO_GESTOR_TAR_ID)
    VALUES
      (-1 ,'Sin Gestor Asignado','Sin Gestor Asignado', 'Sin Gestor Asignado', 'Sin Gestor Asignado', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
  'INSERT INTO D_TAR_GESTOR (
      GESTOR_TAREA_ID,
      GESTOR_TAREA_NOMBRE_COMP,
      GESTOR_TAREA_NOMBRE,
      GESTOR_TAREA_APELLIDO1,
      GESTOR_TAREA_APELLIDO2,
      ENTIDAD_GESTOR_TAR_ID, 
      DESPACHO_GESTOR_TAR_ID)
  SELECT USU.USU_ID,
      NVL(TRIM(REPLACE(USU.USU_NOMBRE ||'' ''||USU.USU_APELLIDO1||'' ''||USU.USU_APELLIDO2,''  '','' '')), ''Desconocido''),
      NVL(USU.USU_NOMBRE, ''Desconocido''),
      NVL(USU.USU_APELLIDO1, ''Desconocido''),
      NVL(USU.USU_APELLIDO2, ''Desconocido''),
      USU.ENTIDAD_ID,
      USD.DES_ID 
  FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD 
    JOIN '||V_DATASTAGE||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID     
    JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
    JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID
  WHERE TGES.DD_TGE_DESCRIPCION = ''Letrado''
  GROUP BY USU.USU_ID, USU.USU_NOMBRE, USU.USU_APELLIDO1, USU.USU_APELLIDO2, USU.ENTIDAD_ID, USD.DES_ID';
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  

-- ----------------------------------------------------------------------------------------------
--                                  D_TAR_TIPO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_TIPO_GESTOR WHERE TIPO_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_TIPO_GESTOR (TIPO_GESTOR_TAR_ID, TIPO_GESTOR_TAR_DESC, TIPO_GESTOR_TAR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_TIPO_GESTOR (TIPO_GESTOR_TAR_ID, TIPO_GESTOR_TAR_DESC, TIPO_GESTOR_TAR_DESC_2)
     select DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA from  '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_TIPO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_SUPERVISOR WHERE SUPERVISOR_TAREA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_SUPERVISOR(
      SUPERVISOR_TAREA_ID,
      SUPERVISOR_TAREA_NOMBRE_COMP,
      SUPERVISOR_TAREA_NOMBRE,
      SUPERVISOR_TAREA_APELLIDO1,
      SUPERVISOR_TAREA_APELLIDO2,
      ENTIDAD_SUPER_TAR_ID, 
      DESPACHO_SUPER_TAR_ID)
    VALUES 
      (-1 ,'Sin Supervisor Asignado', 'Sin Supervisor Asignado', 'Sin Supervisor Asignado', 'Sin Supervisor Asignado', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
  'INSERT INTO D_TAR_SUPERVISOR (
      SUPERVISOR_TAREA_ID,
      SUPERVISOR_TAREA_NOMBRE_COMP,
      SUPERVISOR_TAREA_NOMBRE,
      SUPERVISOR_TAREA_APELLIDO1,
      SUPERVISOR_TAREA_APELLIDO2,
      ENTIDAD_SUPER_TAR_ID, 
      DESPACHO_SUPER_TAR_ID)
  SELECT USU.USU_ID,
      NVL(TRIM(REPLACE(USU.USU_NOMBRE||'' ''||USU.USU_APELLIDO1||'' ''||USU.USU_APELLIDO2,''  '','' '')), ''Desconocido''),
      NVL(USU.USU_NOMBRE, ''Desconocido''),
      NVL(USU.USU_APELLIDO1, ''Desconocido''),
      NVL(USU.USU_APELLIDO2, ''Desconocido''),
      USU.ENTIDAD_ID,
      USD.DES_ID 
  FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD 
    JOIN '||V_DATASTAGE||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID     
    JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
    JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID
  WHERE TGES.DD_TGE_DESCRIPCION = ''Supervisor nivel 1''
  GROUP BY USU.USU_ID, USU.USU_NOMBRE, USU.USU_APELLIDO1, USU.USU_APELLIDO2, USU.ENTIDAD_ID, USD.DES_ID';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  
-- ----------------------------------------------------------------------------------------------
--          D_TAR_DESP_GESTOR / D_TAR_DESP_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_DESP_GESTOR WHERE DESPACHO_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_DESP_GESTOR (DESPACHO_GESTOR_TAR_ID, DESPACHO_GESTOR_TAR_DESC, TIPO_DESP_GESTOR_TAR_ID, ZONA_DESP_GESTOR_TAR_ID) VALUES (-1 ,'Desconocido', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_DESP_GESTOR(DESPACHO_GESTOR_TAR_ID, DESPACHO_GESTOR_TAR_DESC, TIPO_DESP_GESTOR_TAR_ID, ZONA_DESP_GESTOR_TAR_ID)
     SELECT DES_ID, DES_DESPACHO, NVL(DD_TDE_ID, -1), NVL(ZON_ID, -1) FROM '||V_DATASTAGE||'.DES_DESPACHO_EXTERNO';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_DESP_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_DESP_SUPERVISOR WHERE DESPACHO_SUPER_TAR_ID = -1;  
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_DESP_SUPERVISOR (DESPACHO_SUPER_TAR_ID, DESPACHO_SUPER_TAR_DESC, TIPO_DESP_SUPER_TAR_ID, ZONA_DESP_SUPER_TAR_ID) VALUES (-1 ,'Desconocido', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_DESP_SUPERVISOR(DESPACHO_SUPER_TAR_ID, DESPACHO_SUPER_TAR_DESC, TIPO_DESP_SUPER_TAR_ID, ZONA_DESP_SUPER_TAR_ID)
     SELECT DES_ID, DES_DESPACHO, NVL(DD_TDE_ID, -1), NVL(ZON_ID, -1) FROM '||V_DATASTAGE||'.DES_DESPACHO_EXTERNO';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_DESP_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
  
-- ----------------------------------------------------------------------------------------------
--      D_TAR_TIPO_DESP_GESTOR / D_TAR_TIPO_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_TIPO_DESP_GESTOR WHERE TIPO_DESP_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_TIPO_DESP_GESTOR (TIPO_DESP_GESTOR_TAR_ID, TIPO_DESP_GESTOR_TAR_DESC, TIPO_DESP_GESTOR_TAR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_TIPO_DESP_GESTOR(TIPO_DESP_GESTOR_TAR_ID, TIPO_DESP_GESTOR_TAR_DESC, TIPO_DESP_GESTOR_TAR_DESC_2)
     SELECT DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TDE_TIPO_DESPACHO';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_TIPO_DESP_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
         
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_TIPO_DESP_SUPERVISOR WHERE TIPO_DESP_SUPER_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_TIPO_DESP_SUPERVISOR (TIPO_DESP_SUPER_TAR_ID, TIPO_DESP_SUPER_TAR_DESC, TIPO_DESP_SUPER_TAR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_TIPO_DESP_SUPERVISOR(TIPO_DESP_SUPER_TAR_ID, TIPO_DESP_SUPER_TAR_DESC, TIPO_DESP_SUPER_TAR_DESC_2)
     SELECT DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TDE_TIPO_DESPACHO';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_TIPO_DESP_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
  
-- ----------------------------------------------------------------------------------------------
--            D_TAR_ENTIDAD_GESTOR / D_TAR_ENTIDAD_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ENTIDAD_GESTOR WHERE ENTIDAD_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ENTIDAD_GESTOR (ENTIDAD_GESTOR_TAR_ID, ENTIDAD_GESTOR_TAR_DESC) VALUES (-1, 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_ENTIDAD_GESTOR(ENTIDAD_GESTOR_TAR_ID, ENTIDAD_GESTOR_TAR_DESC)
     SELECT ENT_ID, ENT_DESCRIPCION FROM '||V_DATASTAGE||'.ENTIDAD';   
      
  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_ENTIDAD_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
       
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ENTIDAD_SUPERVISOR WHERE ENTIDAD_SUPER_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ENTIDAD_SUPERVISOR (ENTIDAD_SUPER_TAR_ID, ENTIDAD_SUPER_TAR_DESC) VALUES (-1, 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_ENTIDAD_SUPERVISOR(ENTIDAD_SUPER_TAR_ID, ENTIDAD_SUPER_TAR_DESC)
     SELECT ENT_ID, ENT_DESCRIPCION FROM '||V_DATASTAGE||'.ENTIDAD';      

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_ENTIDAD_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
  
-- ----------------------------------------------------------------------------------------------
--    D_TAR_NIVEL_DESP_GESTOR / D_TAR_NIVEL_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_NIVEL_DESP_GESTOR WHERE NIVEL_DESP_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_NIVEL_DESP_GESTOR (NIVEL_DESP_GESTOR_TAR_ID, NIVEL_DESP_GESTOR_TAR_DESC, NIVEL_DESP_GESTOR_TAR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_NIVEL_DESP_GESTOR(NIVEL_DESP_GESTOR_TAR_ID, NIVEL_DESP_GESTOR_TAR_DESC, NIVEL_DESP_GESTOR_TAR_DESC_2)
     SELECT NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.NIV_NIVEL';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_NIVEL_DESP_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
         
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_NIVEL_DESP_SUPERVISOR WHERE NIVEL_DESP_SUPER_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_NIVEL_DESP_SUPERVISOR (NIVEL_DESP_SUPER_TAR_ID, NIVEL_DESP_SUPER_TAR_DESC, NIVEL_DESP_SUPER_TAR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_NIVEL_DESP_SUPERVISOR(NIVEL_DESP_SUPER_TAR_ID, NIVEL_DESP_SUPER_TAR_DESC, NIVEL_DESP_SUPER_TAR_DESC_2)
     SELECT NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.NIV_NIVEL';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_NIVEL_DESP_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
     

-- ----------------------------------------------------------------------------------------------
--   D_TAR_OFICINA_DESP_GESTOR / D_TAR_OFICINA_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_OFICINA_DESP_GESTOR WHERE OFICINA_DESP_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_OFICINA_DESP_GESTOR (OFICINA_DESP_GESTOR_TAR_ID, OFICINA_DESP_GESTOR_TAR_DESC, OFICINA_DESP_GESTOR_TAR_DESC_2, PROV_DESP_GESTOR_TAR_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_OFICINA_DESP_GESTOR(OFICINA_DESP_GESTOR_TAR_ID, OFICINA_DESP_GESTOR_TAR_DESC, PROV_DESP_GESTOR_TAR_ID)
     SELECT OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM '||V_DATASTAGE||'.OFI_OFICINAS';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_OFICINA_DESP_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_OFICINA_DESP_SUPERVISOR WHERE OFICINA_DESP_SUPER_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_OFICINA_DESP_SUPERVISOR (OFICINA_DESP_SUPER_TAR_ID, OFICINA_DESP_SUPER_TAR_DESC, OFICINA_DESP_SUPER_TAR_DESC_2, PROV_DESP_SUPER_TAR_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_OFICINA_DESP_SUPERVISOR(OFICINA_DESP_SUPER_TAR_ID, OFICINA_DESP_SUPER_TAR_DESC, PROV_DESP_SUPER_TAR_ID)
     SELECT OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM '||V_DATASTAGE||'.OFI_OFICINAS';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_OFICINA_DESP_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  
-- ----------------------------------------------------------------------------------------------
--  D_TAR_PROV_DESP_GESTOR / D_TAR_PROV_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------    
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_PROV_DESP_GESTOR WHERE PROV_DESP_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_PROV_DESP_GESTOR (PROV_DESP_GESTOR_TAR_ID, PROV_DESP_GESTOR_TAR_DESC, PROV_DESP_GESTOR_TAR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_PROV_DESP_GESTOR(PROV_DESP_GESTOR_TAR_ID, PROV_DESP_GESTOR_TAR_DESC, PROV_DESP_GESTOR_TAR_DESC_2)
     SELECT DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_PRV_PROVINCIA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_PROV_DESP_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_PROV_DESP_SUPERVISOR WHERE PROV_DESP_SUPER_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_PROV_DESP_SUPERVISOR (PROV_DESP_SUPER_TAR_ID, PROV_DESP_SUPER_TAR_DESC, PROV_DESP_SUPER_TAR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_PROV_DESP_SUPERVISOR(PROV_DESP_SUPER_TAR_ID, PROV_DESP_SUPER_TAR_DESC, PROV_DESP_SUPER_TAR_DESC_2)
     SELECT DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_PRV_PROVINCIA';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_PROV_DESP_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
  
-- ----------------------------------------------------------------------------------------------
--     D_TAR_ZONA_DESP_GESTOR / D_TAR_ZONA_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ZONA_DESP_GESTOR WHERE ZONA_DESP_GESTOR_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ZONA_DESP_GESTOR (ZONA_DESP_GESTOR_TAR_ID, ZONA_DESP_GESTOR_TAR_DESC, ZONA_DESP_GESTOR_TAR_DESC_2, NIVEL_DESP_GESTOR_TAR_ID, OFICINA_DESP_GESTOR_TAR_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_ZONA_DESP_GESTOR(ZONA_DESP_GESTOR_TAR_ID, ZONA_DESP_GESTOR_TAR_DESC, ZONA_DESP_GESTOR_TAR_DESC_2, NIVEL_DESP_GESTOR_TAR_ID, OFICINA_DESP_GESTOR_TAR_ID)
     SELECT ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, NVL(OFI_ID, -1) FROM '||V_DATASTAGE||'.ZON_ZONIFICACION';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_ZONA_DESP_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ZONA_DESP_SUPERVISOR WHERE ZONA_DESP_SUPER_TAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ZONA_DESP_SUPERVISOR (ZONA_DESP_SUPER_TAR_ID, ZONA_DESP_SUPER_TAR_DESC, ZONA_DESP_SUPER_TAR_DESC_2, NIVEL_DESP_SUPER_TAR_ID, OFICINA_DESP_SUPER_TAR_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_TAR_ZONA_DESP_SUPERVISOR(ZONA_DESP_SUPER_TAR_ID, ZONA_DESP_SUPER_TAR_DESC, ZONA_DESP_SUPER_TAR_DESC_2, NIVEL_DESP_SUPER_TAR_ID, OFICINA_DESP_SUPER_TAR_ID)
     SELECT ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, NVL(OFI_ID, -1) FROM '||V_DATASTAGE||'.ZON_ZONIFICACION';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_ZONA_DESP_SUPERVISOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  

-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_DESCRIPCION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_DESCRIPCION WHERE DESCRIPCION_TAREA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_DESCRIPCION (DESCRIPCION_TAREA_ID, DESCRIPCION_TAREA_DESC) VALUES (-1, 'Desconocido');
  END IF;
  
  V_MSQL := 'SELECT DISTINCT TAR_TAREA 
    FROM '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES 
    ORDER BY 1';
    
  OPEN C_TAREA_DESC FOR V_MSQL;
  LOOP
    FETCH C_TAREA_DESC INTO TAREA_DESC;        
    EXIT WHEN C_TAREA_DESC%NOTFOUND;  
    
    SELECT MAX(DESCRIPCION_TAREA_ID)+1 INTO MAX_ID FROM D_TAR_DESCRIPCION;
    INSERT INTO D_TAR_DESCRIPCION (DESCRIPCION_TAREA_ID, DESCRIPCION_TAREA_DESC)
    VALUES (MAX_ID,TAREA_DESC);
  
  END LOOP;
  CLOSE C_TAREA_DESC;

  COMMIT;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_DESCRIPCION. Realizados INSERTS', 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_RESPONSABLE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_RESPONSABLE WHERE RESPONSABLE_TAREA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_RESPONSABLE (RESPONSABLE_TAREA_ID, RESPONSABLE_TAREA_DESC) VALUES (-1, 'Desconocido');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_RESPONSABLE WHERE RESPONSABLE_TAREA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_RESPONSABLE (RESPONSABLE_TAREA_ID, RESPONSABLE_TAREA_DESC) VALUES (0, 'Gestor');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_RESPONSABLE WHERE RESPONSABLE_TAREA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_RESPONSABLE (RESPONSABLE_TAREA_ID, RESPONSABLE_TAREA_DESC) VALUES (1, 'Supervisor');
  END IF;

  COMMIT;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_RESPONSABLE. Realizados INSERTS', 3;
  
    
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR_ESTADO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ESTADO WHERE ESTADO_TAREA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ESTADO (ESTADO_TAREA_ID, ESTADO_TAREA_DESC) VALUES (-1, 'Desconocido');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ESTADO WHERE ESTADO_TAREA_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ESTADO (ESTADO_TAREA_ID, ESTADO_TAREA_DESC) VALUES (0, 'Pendiente');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_TAR_ESTADO WHERE ESTADO_TAREA_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_TAR_ESTADO (ESTADO_TAREA_ID, ESTADO_TAREA_DESC) VALUES (1, 'Finalizada');
  END IF;

  COMMIT;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR_ESTADO. Realizados INSERTS', 3;
  
    
-- ----------------------------------------------------------------------------------------------
--                                      D_TAR
-- ----------------------------------------------------------------------------------------------
  execute immediate 'ALTER TABLE D_TAR DISABLE CONSTRAINT D_TAR_PK';

  EXECUTE IMMEDIATE
  'INSERT /*+ APPEND PARALLEL(D_TAR_1, 16) PQ_DISTRIBUTE(D_TAR_1, NONE) */ INTO D_TAR
  (TAREA_ID,
    TAREA_EMISOR,
    DESCRIPCION_TAREA_ID,
    TIPO_GESTOR_TAR_ID,
    FECHA_INICIO_TAREA,
    FECHA_FIN_TAREA,
    FECHA_VENCIMIENTO_TAREA,
    FECHA_VENCIMIENTO_REAL_TAREA,
    TIPO_TAREA_DETALLE_ID,
    PENDIENTE_RESPUESTA_ID,
    TAREA_ALERTA_ID,
    CUMPLIMIENTO_TAREA_ID
   )
  SELECT  TAR_ID,
    TAR_EMISOR,
    TD.DESCRIPCION_TAREA_ID,
    -1,
    trunc(TAR_FECHA_INI),
    trunc(TAR_FECHA_FIN),
    trunc(TAR_FECHA_VENC),
    trunc(TAR_FECHA_VENC_REAL),
    DD_STA_ID,
    TAR_EN_ESPERA,
    TAR_ALERTA,
    (CASE WHEN (trunc(TAR_FECHA_FIN)-trunc(TAR_FECHA_VENC)) <= 0 THEN 0
          WHEN (trunc(TAR_FECHA_FIN)-trunc(TAR_FECHA_VENC)) > 0 THEN 1
          WHEN trunc(TAR_FECHA_VENC) IS NULL THEN -2
          ELSE -1 END)                                                                           
 FROM '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TN
 JOIN D_TAR_DESCRIPCION TD ON TN.TAR_TAREA = TD.DESCRIPCION_TAREA_DESC';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  

  execute immediate 'ALTER TABLE D_TAR ENABLE CONSTRAINT D_TAR_PK';
  execute immediate 'ANALYZE TABLE D_TAR COMPUTE STATISTICS';

  -- TIPO_GESTOR_TAR_ID
  EXECUTE IMMEDIATE
  'UPDATE D_TAR
  set D_TAR.TIPO_GESTOR_TAR_ID = NVL((select  t.TIPO_GESTOR_TAR_ID 
                                  FROM  '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES n,
                                        '||V_DATASTAGE||'.DD_STA_SUBTIPO_TAREA_BASE b,
                                        D_TAR_TIPO_GESTOR t
                                  where D_TAR.TAREA_ID = n.TAR_ID
                                  and   n.DD_STA_ID = b.DD_STA_ID
                                  and   b.DD_TGE_ID = t.TIPO_GESTOR_TAR_ID), -1)';
   
  -- Tarea Externa o Interna
  EXECUTE IMMEDIATE
  'UPDATE D_TAR SET AMBITO_TAREA_ID = (CASE WHEN TAREA_ID IN (SELECT TAR_ID FROM '||V_DATASTAGE||'.TEX_TAREA_EXTERNA) THEN 1
                                             ELSE 0 END)';
  commit;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR. Realizados UPDATES', 3;


  EXECUTE IMMEDIATE
  'INSERT INTO TMP_TAR_GESTOR (TAREA_ID, GESTOR_TAREA_ID)
  SELECT TAR.TAR_ID, USU.USU_ID FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD 
                    JOIN '||V_DATASTAGE||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID     
                    JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
                    JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID
                    JOIN '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS PRC ON GAA.ASU_ID = PRC.ASU_ID
                    JOIN '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
                    WHERE TGES.DD_TGE_DESCRIPCION = ''Letrado''';

  EXECUTE IMMEDIATE  
  'INSERT INTO TMP_TAR_SUPERVISOR (TAREA_ID, SUPERVISOR_TAREA_ID)
  SELECT TAR.TAR_ID, USU.USU_ID FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD 
                    JOIN '||V_DATASTAGE||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID     
                    JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
                    JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID
                    JOIN '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS PRC ON GAA.ASU_ID = PRC.ASU_ID
                    JOIN '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
                    WHERE TGES.DD_TGE_DESCRIPCION = ''Supervisor nivel 1''';
                   
  UPDATE D_TAR DPRC SET GESTOR_TAREA_ID = (SELECT GESTOR_TAREA_ID FROM TMP_TAR_GESTOR TPG WHERE DPRC.TAREA_ID =  TPG.TAREA_ID);
  UPDATE D_TAR SET GESTOR_TAREA_ID = -1 WHERE  GESTOR_TAREA_ID IS NULL;
  UPDATE D_TAR DPRC SET SUPERVISOR_TAREA_ID =(SELECT NVL(SUPERVISOR_TAREA_ID, -1) FROM TMP_TAR_SUPERVISOR TPS WHERE DPRC.TAREA_ID = TPS.TAREA_ID);
  UPDATE D_TAR SET SUPERVISOR_TAREA_ID = -1 WHERE  SUPERVISOR_TAREA_ID IS NULL;
  
  COMMIT;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_TAR. Realizados UPDATES', 3;

 
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  
EXCEPTION
  WHEN OBJECTEXISTS THEN
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  WHEN INSERT_NULL THEN
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;    
  WHEN PARAMETERS_NUMBER THEN
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;    
  WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;  
END;
END CARGAR_DIM_TAREA;
/
EXIT

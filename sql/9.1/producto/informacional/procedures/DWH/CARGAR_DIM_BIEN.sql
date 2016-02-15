create or replace PROCEDURE CARGAR_DIM_BIEN(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca, PFS Group
-- Fecha creacion: Septiembre 2015
--- Responsable ultima modificacion: María Villanueva , PFS Group
-- Fecha ultima modificacion:04/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension Subasta
-- ===============================================================================================
 

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION SUBASTA

    -- D_BIE
    -- D_BIE_TIPO_BIEN
    -- D_BIE_SUBTIPO_BIEN
    -- D_BIE_POBLACION
    -- D_BIE_ADJUDICADO
    -- D_BIE_ADJ_CESION_REM
    -- D_BIE_CODIGO_ACTIVO
    -- D_BIE_ENTIDAD_ADJUDICATARIA
    -- D_BIE_FASE_ACTUAL_DETALLE

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_BIEN';
V_ROWCOUNT NUMBER;

BEGIN
DECLARE

OBJECTEXISTS EXCEPTION;
INSERT_NULL EXCEPTION;
PARAMETERS_NUMBER EXCEPTION;
PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

V_NUM_ROW NUMBER(10);
V_DATASTAGE VARCHAR2(100);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

 
-- ----------------------------------------------------------------------------------------------
--                                      D_BIE
-- ----------------------------------------------------------------------------------------------

  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE(BIE_ID, BIE_DESC, BIE_DESC_2, BIE_DESC_3)
     SELECT BIE_ID, BIE_DATOS_REGISTRALES, BIE_DESCRIPCION, TO_CHAR(BIE_ID) FROM '||V_DATASTAGE||'.BIE_BIEN';

  V_ROWCOUNT := sql%rowcount;     
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit; 


-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_TIPO_BIEN
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_TIPO_BIEN WHERE TIPO_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_TIPO_BIEN (TIPO_BIEN_ID, TIPO_BIEN_DESC, TIPO_BIEN_DESC_2) VALUES (-1 ,'Tipo de Bien Desconocido', 'Tipo de Bien Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_TIPO_BIEN (TIPO_BIEN_ID, TIPO_BIEN_DESC, TIPO_BIEN_DESC_2)
     SELECT DD_TBI_ID, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TBI_TIPO_BIEN';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_TIPO_BIEN. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;


-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_SUBTIPO_BIEN
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_SUBTIPO_BIEN WHERE SUBTIPO_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_SUBTIPO_BIEN(SUBTIPO_BIEN_ID, SUBTIPO_BIEN_DESC, SUBTIPO_BIEN_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_SUBTIPO_BIEN(SUBTIPO_BIEN_ID, SUBTIPO_BIEN_DESC, SUBTIPO_BIEN_DESC_2)
     SELECT DD_TPN_ID,DD_TPN_DESCRIPCION, DD_TPN_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TPN_TIPO_INMUEBLE';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_SUBTIPO_BIEN. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_POBLACION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_POBLACION WHERE POBLACION_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_POBLACION (POBLACION_BIEN_ID, POBLACION_BIEN_DESC, POBLACION_BIEN_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_POBLACION (POBLACION_BIEN_ID, POBLACION_BIEN_DESC, POBLACION_BIEN_DESC_2)
     SELECT DD_LOC_ID, DD_LOC_DESCRIPCION, DD_LOC_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_LOC_LOCALIDAD';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_POBLACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_ADJUDICADO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJUDICADO WHERE BIEN_ADJUDICADO_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJUDICADO (BIEN_ADJUDICADO_ID, BIEN_ADJUDICADO_DESC, BIEN_ADJUDICADO_DESC_2) VALUES (0 ,'No', 'Bien No Adjudicado');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJUDICADO WHERE BIEN_ADJUDICADO_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJUDICADO (BIEN_ADJUDICADO_ID, BIEN_ADJUDICADO_DESC, BIEN_ADJUDICADO_DESC_2) VALUES (1 ,'Si', 'Bien Adjudicado');
  END IF;

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ADJUDICADO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  
  

-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_ADJ_CESION_REM
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJ_CESION_REM WHERE ADJ_CESION_REM_BIEN_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJ_CESION_REM (ADJ_CESION_REM_BIEN_ID, ADJ_CESION_REM_BIEN_DESC, ADJ_CESION_REM_BIEN_DESC_2) VALUES (0 ,'Bien Sin Cesión Remate', 'Bien Sin Cesión Remate');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJ_CESION_REM WHERE ADJ_CESION_REM_BIEN_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJ_CESION_REM (ADJ_CESION_REM_BIEN_ID, ADJ_CESION_REM_BIEN_DESC, ADJ_CESION_REM_BIEN_DESC_2) VALUES (1 ,'Bien Con Cesión Remate', 'Bien Con Cesión Remate');
  END IF;

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ADJ_CESION_REM. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  

-- ----------------------------------------------------------------------------------------------
--                                     D_BIE_CODIGO_ACTIVO
-- ----------------------------------------------------------------------------------------------

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_CODIGO_ACTIVO WHERE CODIGO_ACTIVO_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_CODIGO_ACTIVO (CODIGO_ACTIVO_BIEN_ID, CODIGO_ACTIVO_BIEN_DESC) VALUES (-1 ,'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_CODIGO_ACTIVO (CODIGO_ACTIVO_BIEN_ID, CODIGO_ACTIVO_BIEN_DESC)
     SELECT DISTINCT BIE_NUMERO_ACTIVO, BIE_NUMERO_ACTIVO FROM '||V_DATASTAGE||'.BIE_BIEN WHERE BIE_NUMERO_ACTIVO IS NOT NULL ORDER BY 1';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_CODIGO_ACTIVO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  

-- ----------------------------------------------------------------------------------------------
--                                     D_BIE_ENTIDAD_ADJUDICATARIA
-- ----------------------------------------------------------------------------------------------

--  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ENTIDAD_ADJUDICATARIA WHERE ENTIDAD_ADJUDICATARIA_ID = -1;
--  IF (V_NUM_ROW = 0) THEN
--    INSERT INTO D_BIE_ENTIDAD_ADJUDICATARIA (ENTIDAD_ADJUDICATARIA_ID, ENTIDAD_ADJUDICATARIA_DESC, ENTIDAD_ADJUDICATARIA_DESC_2) VALUES (-1 ,' ', ' ');
--  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_ENTIDAD_ADJUDICATARIA (ENTIDAD_ADJUDICATARIA_ID, ENTIDAD_ADJUDICATARIA_DESC, ENTIDAD_ADJUDICATARIA_DESC_2)
     SELECT DD_EAD_ID, DD_EAD_DESCRIPCION, DD_EAD_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_EAD_ENTIDAD_ADJUDICA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ENTIDAD_ADJUDICATARIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit; 

-- ----------------------------------------------------------------------------------------------
--                           D_BIE_FASE_ACTUAL_DETALLE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_FASE_ACTUAL_DETALLE WHERE BIE_FASE_ACTUAL_DETALLE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_FASE_ACTUAL_DETALLE (BIE_FASE_ACTUAL_DETALLE_ID, BIE_FASE_ACTUAL_DETALLE_DESC, BIE_FASE_ACTUAL_DETALLE_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_FASE_ACTUAL_DETALLE(BIE_FASE_ACTUAL_DETALLE_ID, BIE_FASE_ACTUAL_DETALLE_DESC, BIE_FASE_ACTUAL_DETALLE_DESC_2)
     SELECT DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_FASE_ACTUAL_DETALLE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;  

-------------------------
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
    O_ERROR_STATUS := 'N�mero de par�metros incorrecto';
    --ROLLBACK;    
  WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;
END;
END CARGAR_DIM_BIEN;
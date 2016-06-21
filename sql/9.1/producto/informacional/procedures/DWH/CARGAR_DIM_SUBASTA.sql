create or replace PROCEDURE CARGAR_DIM_SUBASTA(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca, PFS Group
-- Fecha creacion: Septiembre 2015
-- Responsable ultima modificacion: María Villanueva , PFS Group
-- Fecha ultima modificacion:04/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension Subasta
-- ===============================================================================================
 

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION SUBASTA

    -- D_SUB
    -- D_SUB_LOTE
    -- D_SUB_TIPO_SUBASTA
    -- D_SUB_ESTADO_SUBASTA
    -- D_SUB_MOTIVO_SUSPEN
    -- D_SUB_SUBMOTIVO_SUSPEN
    -- D_SUB_MOTIVO_CANCEL
    -- D_SUB_TIPO_ADJUDICACION
    -- D_SUB_TD_SENYALAMIENTO_SOCLI
    -- D_SUB_TD_SENYALAMIENTO_ANUNC
    -- D_SUB_TD_ANUNCIO_SOLICITUD

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_SUBASTA';
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
--                                      D_SUB
-- ----------------------------------------------------------------------------------------------

  EXECUTE IMMEDIATE
    'INSERT INTO D_SUB(SUBASTA_ID, SUBASTA_DESC, SUBASTA_DESC_2)
     SELECT SUB_ID, SUB_NUM_AUTOS, TO_CHAR(SUB_ID) FROM '||V_DATASTAGE||'.SUB_SUBASTA';

  V_ROWCOUNT := sql%rowcount;     
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit; 


-- ----------------------------------------------------------------------------------------------
--                                      D_SUB_LOTE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_LOTE WHERE LOTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_LOTE (LOTE_ID, LOTE_DESC, LOTE_DESC_2) VALUES (-1 ,'Subasta sin Lote informado', 'Subasta sin Lote informado');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_SUB_LOTE (LOTE_ID, LOTE_DESC, LOTE_DESC_2)
     SELECT LOS_ID, LOS_NUM_LOTE, TO_CHAR(LOS_ID) FROM '||V_DATASTAGE||'.LOS_LOTE_SUBASTA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_LOTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;


-- ----------------------------------------------------------------------------------------------
--                                      D_SUB_TIPO_SUBASTA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TIPO_SUBASTA WHERE TIPO_SUBASTA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TIPO_SUBASTA(TIPO_SUBASTA_ID, TIPO_SUBASTA_DESC, TIPO_SUBASTA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_SUB_TIPO_SUBASTA(TIPO_SUBASTA_ID, TIPO_SUBASTA_DESC, TIPO_SUBASTA_DESC_2)
     SELECT DD_TSU_ID,DD_TSU_DESCRIPCION, DD_TSU_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TSU_TIPO_SUBASTA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_TIPO_SUBASTA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_SUB_ESTADO_SUBASTA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_ESTADO_SUBASTA WHERE ESTADO_SUBASTA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_ESTADO_SUBASTA (ESTADO_SUBASTA_ID, ESTADO_SUBASTA_DESC, ESTADO_SUBASTA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_SUB_ESTADO_SUBASTA(ESTADO_SUBASTA_ID, ESTADO_SUBASTA_DESC, ESTADO_SUBASTA_DESC_2)
     SELECT DD_ESU_ID, DD_ESU_DESCRIPCION, DD_ESU_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_ESU_ESTADO_SUBASTA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_ESTADO_SUBASTA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_SUB_MOTIVO_SUSPEN
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_MOTIVO_SUSPEN WHERE MOTIVO_SUSPEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_MOTIVO_SUSPEN (MOTIVO_SUSPEN_ID, MOTIVO_SUSPEN_DESC, MOTIVO_SUSPEN_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_SUB_MOTIVO_SUSPEN(MOTIVO_SUSPEN_ID, MOTIVO_SUSPEN_DESC, MOTIVO_SUSPEN_DESC_2) 
     SELECT DD_MSS_ID, DD_MSS_DESCRIPCION, DD_MSS_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_MSS_MOT_SUSP_SUBASTA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_MOTIVO_SUSPEN. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  
  

-- ----------------------------------------------------------------------------------------------
--                                      D_SUB_MOTIVO_CANCEL
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_MOTIVO_CANCEL WHERE MOTIVO_CANCEL_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_MOTIVO_CANCEL (MOTIVO_CANCEL_ID, MOTIVO_CANCEL_DESC, MOTIVO_CANCEL_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_SUB_MOTIVO_CANCEL(MOTIVO_CANCEL_ID, MOTIVO_CANCEL_DESC, MOTIVO_CANCEL_DESC_2) 
     SELECT DD_MCS_ID, DD_MCS_DESCRIPCION, DD_MCS_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_MCS_MOT_CANCEL_SUBASTA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_MOTIVO_CANCEL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  

-- ----------------------------------------------------------------------------------------------
--                                     D_SUB_TD_SENYALAMIENTO_SOLIC
-- ----------------------------------------------------------------------------------------------

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_SOLIC WHERE TD_SENYALAMIENTO_SOLIC_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID, TD_SENYALAMIENTO_SOLIC_DESC) VALUES (-1 ,'Desconocido');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_SOLIC WHERE TD_SENYALAMIENTO_SOLIC_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID, TD_SENYALAMIENTO_SOLIC_DESC) VALUES (0,'0 - 30');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_SOLIC WHERE TD_SENYALAMIENTO_SOLIC_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID, TD_SENYALAMIENTO_SOLIC_DESC) VALUES (1,'30 - 60');
  END IF;
   SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_SOLIC WHERE TD_SENYALAMIENTO_SOLIC_ID = 2;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID, TD_SENYALAMIENTO_SOLIC_DESC) VALUES (2 ,'60 - 90');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_SOLIC WHERE TD_SENYALAMIENTO_SOLIC_ID = 3;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID, TD_SENYALAMIENTO_SOLIC_DESC) VALUES (3 ,'90 - 120');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_SOLIC WHERE TD_SENYALAMIENTO_SOLIC_ID = 4;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID, TD_SENYALAMIENTO_SOLIC_DESC) VALUES (4,'120 - 150');
  END IF;
    SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_SOLIC WHERE TD_SENYALAMIENTO_SOLIC_ID = 5;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_SOLIC (TD_SENYALAMIENTO_SOLIC_ID, TD_SENYALAMIENTO_SOLIC_DESC) VALUES (5,'> 150');
  END IF;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_TD_SENYALAMIENTO_SOLIC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  


-- ----------------------------------------------------------------------------------------------
--                                     D_SUB_TD_SENYALAMIENTO_ANUNC
-- ----------------------------------------------------------------------------------------------

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_ANUNC WHERE TD_SENYALAMIENTO_ANUNC_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID, TD_SENYALAMIENTO_ANUNC_DESC) VALUES (-1 ,'Desconocido');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_ANUNC WHERE TD_SENYALAMIENTO_ANUNC_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID, TD_SENYALAMIENTO_ANUNC_DESC) VALUES (0,'0 - 30');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_ANUNC WHERE TD_SENYALAMIENTO_ANUNC_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID, TD_SENYALAMIENTO_ANUNC_DESC) VALUES (1,'30 - 60');
  END IF;
   SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_ANUNC WHERE TD_SENYALAMIENTO_ANUNC_ID = 2;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID, TD_SENYALAMIENTO_ANUNC_DESC) VALUES (2 ,'60 - 90');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_ANUNC WHERE TD_SENYALAMIENTO_ANUNC_ID = 3;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID, TD_SENYALAMIENTO_ANUNC_DESC) VALUES (3 ,'90 - 120');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_ANUNC WHERE TD_SENYALAMIENTO_ANUNC_ID = 4;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID, TD_SENYALAMIENTO_ANUNC_DESC) VALUES (4,'120 - 150');
  END IF;
    SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_SENYALAMIENTO_ANUNC WHERE TD_SENYALAMIENTO_ANUNC_ID = 5;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_SENYALAMIENTO_ANUNC (TD_SENYALAMIENTO_ANUNC_ID, TD_SENYALAMIENTO_ANUNC_DESC) VALUES (5,'> 150');
  END IF;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_TD_SENYALAMIENTO_ANUNC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  

-- ----------------------------------------------------------------------------------------------
--                                     D_SUB_TD_ANUNCIO_SOLICITUD
-- ----------------------------------------------------------------------------------------------

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_ANUNCIO_SOLICITUD WHERE TD_ANUNCIO_SOLICITUD_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID, TD_ANUNCIO_SOLICITUD_DESC) VALUES (-1 ,'Desconocido');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_ANUNCIO_SOLICITUD WHERE TD_ANUNCIO_SOLICITUD_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID, TD_ANUNCIO_SOLICITUD_DESC) VALUES (0,'0 - 30');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_ANUNCIO_SOLICITUD WHERE TD_ANUNCIO_SOLICITUD_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID, TD_ANUNCIO_SOLICITUD_DESC) VALUES (1,'30 - 60');
  END IF;
   SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_ANUNCIO_SOLICITUD WHERE TD_ANUNCIO_SOLICITUD_ID = 2;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID, TD_ANUNCIO_SOLICITUD_DESC) VALUES (2 ,'60 - 90');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_ANUNCIO_SOLICITUD WHERE TD_ANUNCIO_SOLICITUD_ID = 3;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID, TD_ANUNCIO_SOLICITUD_DESC) VALUES (3 ,'90 - 120');
  END IF;
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_ANUNCIO_SOLICITUD WHERE TD_ANUNCIO_SOLICITUD_ID = 4;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID, TD_ANUNCIO_SOLICITUD_DESC) VALUES (4,'120 - 150');
  END IF;
    SELECT COUNT(*) INTO V_NUM_ROW FROM D_SUB_TD_ANUNCIO_SOLICITUD WHERE TD_ANUNCIO_SOLICITUD_ID = 5;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_SUB_TD_ANUNCIO_SOLICITUD (TD_ANUNCIO_SOLICITUD_ID, TD_ANUNCIO_SOLICITUD_DESC) VALUES (5,'> 150');
  END IF;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_SUB_TD_ANUNCIO_SOLICITUD. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;

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
END CARGAR_DIM_SUBASTA;
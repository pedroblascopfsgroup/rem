create or replace PROCEDURE CARGAR_H_TAREA_FINALIZADA (DATE_START IN DATE, DATE_END IN DATE, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable última modificación: Diego Pérez, PFS Group
-- Fecha última modificación: 03/02/2015
-- Motivos del cambio: LOG's
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos Tareas Finalizadas.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR(25) := 'RECOVERY_CM_datastage';

  FECHA DATE;
  FECHA_RELLENAR DATE;
  MAX_DIA_CARGA DATE;

  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_TAREA_FINALIZADA';
  V_ROWCOUNT NUMBER;

  CURSOR C_FECHA IS SELECT DISTINCT(DIA_ID) FROM D_F_DIA WHERE DIA_ID BETWEEN DATE_START AND DATE_END; 
  CURSOR C_FECHA_RELLENAR IS SELECT DISTINCT(DIA_ID) FROM D_F_DIA WHERE DIA_ID BETWEEN DATE_START AND DATE_END; 

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

  
-- ----------------------------------------------------------------------------------------------
--                                      H_TAR_FINALIZADA
-- ----------------------------------------------------------------------------------------------

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_TAR_FINALIZADA. Empieza Carga', 3;


  EXECUTE IMMEDIATE
    'TRUNCATE TABLE TMP_TAR_JERARQUIA';
  
  EXECUTE IMMEDIATE
    'INSERT INTO TMP_TAR_JERARQUIA (DIA_ID, ITER, FASE_ACTUAL) 
    SELECT FECHA_PROCEDIMIENTO, PJ_PADRE, PRC_ID
    FROM '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA WHERE FECHA_PROCEDIMIENTO BETWEEN :DATE_START AND :DATE_END' USING DATE_START, DATE_END;
  
  -- Rellenar los días que no tienen entradas de procedimientos. No ha existido ningún movimiento. La foto es la del día anterior.
  
  OPEN C_FECHA_RELLENAR;
  LOOP --RELLENAR_LOOP
    FETCH C_FECHA_RELLENAR INTO FECHA_RELLENAR;        
    EXIT WHEN C_FECHA_RELLENAR%NOTFOUND;
      -- Si un día no ha habido movimiento copiamos dia anterior
      SELECT COUNT(DIA_ID) INTO V_NUM_ROW FROM TMP_TAR_JERARQUIA WHERE DIA_ID = FECHA_RELLENAR;
      IF(V_NUM_ROW = 0) THEN 
      INSERT INTO TMP_TAR_JERARQUIA(DIA_ID, ITER, FASE_ACTUAL)
      SELECT (DIA_ID+1), ITER, FASE_ACTUAL
          FROM TMP_TAR_JERARQUIA WHERE DIA_ID = (FECHA_RELLENAR-1);
      END IF; 
      
  END LOOP;
  CLOSE C_FECHA_RELLENAR;    
  
  -- Obtenemos el último día cargado en el sistema
  SELECT MAX(DIA_ID) INTO MAX_DIA_CARGA FROM H_PRC;
  
  -- Borrado de los días a insertar
  DELETE FROM H_TAR_FINALIZADA WHERE FECHA_FIN_TAREA BETWEEN DATE_START AND DATE_END;
  
  
  -- Insertamos las tareas finalizadas de cada día
  OPEN C_FECHA;
  LOOP --READ_LOOP
    FETCH C_FECHA INTO FECHA;        
    EXIT WHEN C_FECHA%NOTFOUND;
      
    EXECUTE IMMEDIATE
    'INSERT INTO H_TAR_FINALIZADA (FECHA_FIN_TAREA, FECHA_CARGA_DATOS, TAREA_ID, FASE_ACTUAL_PROCEDIMIENTO,
      ASUNTO_ID, FECHA_CREACION_TAREA, FECHA_VENC_ORIGINAL_TAREA, FECHA_VENCIMIENTO_TAREA,
      RESPONSABLE_TAREA_ID, NUM_TAREAS_FINALIZADAS, DURACION_TAREA_FINALIZADA, NUM_DIAS_VENCIDO)
    SELECT TO_DATE(TAR_FECHA_FIN), :MAX_DIA_CARGA, TAR.TAR_ID, TAR.PRC_ID, 
      TAR.ASU_ID, TO_DATE(TAR_FECHA_INI), TO_DATE(TAR_FECHA_VENC_REAL), TO_DATE(TAR_FECHA_VENC),
      TAP_SUPERVISOR, 1, (TO_DATE(TAR_FECHA_FIN) - TO_DATE(TAR_FECHA_INI)), (TO_DATE(TAR_FECHA_FIN) - TO_DATE(TAR_FECHA_VENC))
    FROM '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR 
      JOIN '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
      JOIN '||V_DATASTAGE||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
    WHERE TAR.TAR_FECHA_FIN IS NOT NULL AND TO_DATE(TAR.TAR_FECHA_FIN) = :FECHA' USING MAX_DIA_CARGA, FECHA;
  
  -- Borramos las tareas de procedimientos borrados (No existen en Recovery)
  EXECUTE IMMEDIATE
  'DELETE FROM H_TAR_FINALIZADA 
  WHERE FECHA_FIN_TAREA = :FECHA 
    AND FASE_ACTUAL_PROCEDIMIENTO IN (SELECT PRC_ID 
                                      FROM '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS 
                                      WHERE BORRADO=1)' USING FECHA;
  
  UPDATE H_TAR_FINALIZADA TAR
  SET TAR.PROCEDIMIENTO_ID = (SELECT TTJ.ITER 
                              FROM TMP_TAR_JERARQUIA TTJ 
                              WHERE TAR.FECHA_FIN_TAREA = FECHA AND TAR.FECHA_FIN_TAREA = TTJ.DIA_ID AND TAR.FASE_ACTUAL_PROCEDIMIENTO = TTJ.FASE_ACTUAL);
  
  UPDATE H_TAR_FINALIZADA TAR
  SET TAR.TIPO_PROCEDIMIENTO_DETALLE_ID = (SELECT H.TIPO_PROCEDIMIENTO_DET_ID 
                                            FROM H_PRC H 
                                            WHERE TAR.FECHA_FIN_TAREA = FECHA AND TAR.FECHA_FIN_TAREA = H.DIA_ID AND TAR.PROCEDIMIENTO_ID = H.PROCEDIMIENTO_ID);
  
  UPDATE H_TAR_FINALIZADA TAR
  SET TAR.CARTERA_PROCEDIMIENTO_ID = (SELECT H.CARTERA_PROCEDIMIENTO_ID 
                                      FROM H_PRC H 
                                      WHERE TAR.FECHA_FIN_TAREA = FECHA AND TAR.FECHA_FIN_TAREA = H.DIA_ID AND TAR.PROCEDIMIENTO_ID = H.PROCEDIMIENTO_ID);
  
  UPDATE H_TAR_FINALIZADA TAR SET GESTOR_RECOVERY_PRC_ID = (SELECT GESTOR_RECOVERY_PRC_ID 
                                                                           FROM D_PRC PRC
                                                                           JOIN D_PRC_GESTOR GES ON PRC.GESTOR_PRC_ID = GES.GESTOR_PRC_ID
                                                                           WHERE TAR.PROCEDIMIENTO_ID = PRC.PROCEDIMIENTO_ID) WHERE TAR.FECHA_FIN_TAREA = FECHA;
                                                                           
  END LOOP;
  CLOSE C_FECHA;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_TAR_FINALIZADA. Termina Carga', 3;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;  
  
END;
END CARGAR_H_TAREA_FINALIZADA;
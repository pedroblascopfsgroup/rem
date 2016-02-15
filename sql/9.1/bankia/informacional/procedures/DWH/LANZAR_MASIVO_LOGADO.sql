create or replace PROCEDURE  LANZAR_MASIVO_LOGADO IS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Enero 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento lanzar de manera masiva procesos logados en LOG_GENERAL_PARAMETROS
-- ===============================================================================================

  V_ORDEN NUMBER;
  V_NOMBRE_PROCESO VARCHAR2(250); 
  
  V_NOMBRE VARCHAR2(50) := 'LANZAR_MASIVO_LOGADO';
  
  --V_FECHA_CARGA_INI VARCHAR2(50);
  --V_FECHA_CARGA_END VARCHAR2(50);
  V_OTROS_PARAMETROS VARCHAR2(250);
  V_FORZAR_EJECUCION VARCHAR2(1) := 'S';
  O_ERROR_STATUS VARCHAR2(250);
  
  V_SQL VARCHAR2(500);

  Cursor C1 is  select ORDEN, NOMBRE_PROCESO, OTROS_PARAMETROS
                from LOG_GENERAL_PARAMETROS 
                where ACTIVO = 'S' 
                --and NUM_OTROS_PARAMETROS = 0
                order by ORDEN;   
   
BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 0;
  
   OPEN C1;
    LOOP
      FETCH C1 INTO V_ORDEN, V_NOMBRE_PROCESO, V_OTROS_PARAMETROS;
      EXIT WHEN C1%NOTFOUND;

      V_SQL :=  'BEGIN LANZA_PROCESO_LOGADO('''||V_NOMBRE_PROCESO||''', null, null, '''||V_OTROS_PARAMETROS||''', '''||V_FORZAR_EJECUCION||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;                      
   
    END LOOP;  
    CLOSE C1;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 0;    
  
END;
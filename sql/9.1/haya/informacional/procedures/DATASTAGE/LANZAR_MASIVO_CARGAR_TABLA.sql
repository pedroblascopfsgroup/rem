create or replace PROCEDURE  LANZAR_MASIVO_CARGAR_TABLA(NUM_BLOQUE IN NUMBER, FORZAR_EJECUCION CHAR) IS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Abril 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion: 29/04/2015
-- Motivos del cambio: Parametro Forzar Ejecución
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento lanzar de manera masiva bloques de carga de tablas
-- ===============================================================================================

  V_ORDEN NUMBER;
  V_NOMBRE_TABLA_DESTINO VARCHAR2(100); 
  V_OTROS_PARAMETROS varchar2(250) := '';
  
  V_NOMBRE VARCHAR2(50) := 'LANZAR_MASIVO_CARGAR_TABLA';
  
  V_FORZAR_EJECUCION VARCHAR2(1) :=  SUBSTR(NVL(FORZAR_EJECUCION, 'N'), 1, 1);
  O_ERROR_STATUS VARCHAR2(250);

  V_NUM_BLOQUE NUMBER := NVL(NUM_BLOQUE, 0);
  
  V_SQL VARCHAR2(500);

  Cursor C1 is  select ORDEN, NOMBRE_TABLA_DESTINO
                from CARGAR_TABLA_PARAMETROS 
                where ACTIVO = 'S' 
                and BLOQUE = V_NUM_BLOQUE
                order by ORDEN;   
   
BEGIN
  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, V_NUM_BLOQUE, 0, 'Empieza ' || V_NOMBRE, 0;  
  
   OPEN C1;
    LOOP
      FETCH C1 INTO V_ORDEN, V_NOMBRE_TABLA_DESTINO;
      EXIT WHEN C1%NOTFOUND;

      V_SQL :=  'BEGIN LANZA_CARGAR_TABLA('''||V_NOMBRE_TABLA_DESTINO||''', '''||V_OTROS_PARAMETROS||''', '''||V_FORZAR_EJECUCION||''', :O_ERROR_STATUS); END;';
      execute immediate V_SQL USING OUT O_ERROR_STATUS;                      
   
    END LOOP;  
    CLOSE C1;

  --Asignar Grants
  V_SQL :=  'BEGIN ASIGNAR_GRANTS(:O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;                      
     
  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, V_NUM_BLOQUE, 0, 'Termina ' || V_NOMBRE, 0;  
  
END;
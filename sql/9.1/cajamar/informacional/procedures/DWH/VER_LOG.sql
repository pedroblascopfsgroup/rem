create or replace PROCEDURE  VER_LOG (NOMBRE_PROCESO VARCHAR2, FECHA_LANZAMIENTO DATE) IS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Enero 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almacenado para ver la información logada por proceso de la tabla LOG_PROCESO
-- ===============================================================================================


  V_NOMBRE_PROCESO VARCHAR2(50) := NOMBRE_PROCESO;
  V_FECHA_INICIO DATE := FECHA_LANZAMIENTO; 
  V_COUNT NUMBER;
  V_NUM_BLOQUE NUMBER;
  V_MIN_FECHA DATE;
  V_MAX_FECHA DATE;
  V_F_INI DATE;
  V_F_FIN DATE;
  V_ESTADO VARCHAR2(50);
  V_TIEMPO NUMBER;
  
  V_FILA_INI_ID NUMBER;
  V_FILA_FIN_ID NUMBER;  
  V_SID NUMBER;
  
  V_FILA NUMBER;
  V_LOG VARCHAR2(500);

  Cursor C1 is select NUM_BLOQUE 
                from LOG_GENERAL
                where NOMBRE_PROCESO = V_NOMBRE_PROCESO 
                and TO_CHAR(FECHA_INICIO, 'dd/mm/yyyy') =  TO_CHAR(V_FECHA_INICIO, 'dd/mm/yyyy')
                group by NUM_BLOQUE;    

  Cursor C2 is select fila_id, '** ' || lpad(' ',5 * TAB,' ') || descripcion from LOG_PROCESO 
                where fila_id between V_FILA_INI_ID and V_FILA_FIN_ID                
                order by 1;                  

begin
  --Validar Fecha
  if V_FECHA_INICIO IS NULL then
    SELECT TRUNC(sysdate) INTO V_FECHA_INICIO FROM DUAL; 
  end if;
  
  
  select count(*) into V_COUNT from LOG_GENERAL where NOMBRE_PROCESO = V_NOMBRE_PROCESO and TO_CHAR(FECHA_INICIO, 'dd/mm/yyyy') =  TO_CHAR(V_FECHA_INICIO, 'dd/mm/yyyy') group by NUM_BLOQUE;
  
  if V_COUNT > 0 then
    
    OPEN C1;
    LOOP
      FETCH C1 INTO V_NUM_BLOQUE;
      EXIT WHEN C1%NOTFOUND;
      
        select MIN(FECHA_CARGA), MAX(FECHA_CARGA), ESTADO, FECHA_INICIO, FECHA_FIN, SUM(TIEMPO_MEDIO_CARGA_DIA)
        into V_MIN_FECHA, V_MAX_FECHA, V_ESTADO, V_F_INI, V_F_FIN, V_TIEMPO
        from  LOG_GENERAL
        where NUM_BLOQUE = V_NUM_BLOQUE
        group by ESTADO, FECHA_INICIO, FECHA_FIN; --Es el mismo Estado y fechas para cualquier bloque, pero es la única manera para sumar el tiempo

      DBMS_OUTPUT.put_line(lpad('*',80,'*'));
      DBMS_OUTPUT.put_line('** PROCESO: '  || V_NOMBRE_PROCESO);
      DBMS_OUTPUT.put_line('** Fecha Carga: ' || TO_CHAR(V_MIN_FECHA, 'dd/mm/yyyy') || ' a ' || TO_CHAR(V_MAX_FECHA, 'dd/mm/yyyy'));
      DBMS_OUTPUT.put_line('** Inicio Carga: ' || TO_CHAR(V_F_INI, 'dd/mm/yyyy HH24:MI:SS') || ' - Fin Carga: ' || TO_CHAR(V_F_FIN, 'dd/mm/yyyy HH24:MI:SS'));
      DBMS_OUTPUT.put_line('** Tiempo Total: '  || TO_CHAR(trunc(sysdate) + (V_F_FIN - V_F_INI),'hh24:mi:ss'));
      DBMS_OUTPUT.put_line('** Estado: '  || V_ESTADO);
      DBMS_OUTPUT.put_line('** Número de Bloque: '  || TO_CHAR(V_NUM_BLOQUE));
      DBMS_OUTPUT.put_line(lpad('*',80,'*'));


      select MAX(FILA_ID) into V_FILA_INI_ID 
      from LOG_PROCESO 
      where NOMBRE_PROCESO = 'LANZA_PROCESO_LOGADO'
      and DESCRIPCION like 'INICIO - NOMBRE_PROCESO: '||V_NOMBRE_PROCESO||'%'
      and FILA_ID < (select MAX(FILA_ID) from LOG_PROCESO
                    where NOMBRE_PROCESO = 'LANZA_PROCESO_LOGADO'
                    --and DESCRIPCION like 'INICIO - NOMBRE_PROCESO: '||V_NOMBRE_PROCESO||'%'
                    and DESCRIPCION like 'VALIDADO - NOMBRE_PROCESO: '||V_NOMBRE_PROCESO||', FECHA_CARGA_INI: ' || TO_CHAR(V_MIN_FECHA, 'yyyymmdd') ||'%' 
                    and TO_CHAR(FECHA, 'dd/mm/yyyy') = TO_CHAR(V_F_INI, 'dd/mm/yyyy')
                    );
                    
      select NUM_SID INTO V_SID
      from LOG_PROCESO
      where FILA_ID = V_FILA_INI_ID;

      if V_ESTADO in ('OK' , 'ERROR') then
        select MIN(FILA_ID) into V_FILA_FIN_ID
        from LOG_PROCESO
        where NUM_SID = V_SID
        and FILA_ID > V_FILA_INI_ID
        and NOMBRE_PROCESO = 'LANZA_PROCESO_LOGADO'
        and DESCRIPCION like 'FIN - %';
      else
        select MAX(FILA_ID) into V_FILA_FIN_ID
        from LOG_PROCESO        
        where NUM_SID = V_SID
        and TO_CHAR(FECHA, 'dd/mm/yyyy') = TO_CHAR(V_F_INI, 'dd/mm/yyyy'); --Realmente puede haber saltos dentro del log que se pueden controlar buscando un INICIO
      end if;
      
      DBMS_OUTPUT.put_line('** FILA_ID Inicio: '  || TO_CHAR(V_FILA_INI_ID) || ', FILA_FIN_ID: '  || TO_CHAR(V_FILA_FIN_ID) || ', SID: '  || TO_CHAR(V_SID));
      DBMS_OUTPUT.put_line(lpad('*',80,'*'));

      --Cursor de LOG_PROCESO
      OPEN C2;
      LOOP
        FETCH C2 INTO V_FILA, V_LOG;
        EXIT WHEN C2%NOTFOUND;
  
        DBMS_OUTPUT.put_line(V_LOG);
        
      END LOOP;  
      CLOSE C2;

      DBMS_OUTPUT.put_line(lpad('*',80,'*'));
       
    END LOOP;  
    CLOSE C1;
    
        
  else
    DBMS_OUTPUT.put_line(lpad('*',80,'*'));
    DBMS_OUTPUT.put_line('No se encuentran lanzamientos para ' || V_NOMBRE_PROCESO || ' en el día ' || TO_CHAR(V_FECHA_INICIO, 'dd/mm/yyyy'));
    DBMS_OUTPUT.put_line(lpad('*',80,'*'));
  end if;

EXCEPTION  
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line(lpad('*',80,'*'));
    DBMS_OUTPUT.put_line('No se encuentran lanzamientos para ' || V_NOMBRE_PROCESO || ' en el día ' || TO_CHAR(V_FECHA_INICIO, 'dd/mm/yyyy'));
    DBMS_OUTPUT.put_line(lpad('*',80,'*'));
end;
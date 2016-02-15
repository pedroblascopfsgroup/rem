create or replace PROCEDURE  LANZA_PROCESO_LOGADO (NOMBRE_PROCESO IN VARCHAR2, FECHA_CARGA_INI IN DATE, FECHA_CARGA_END IN DATE, OTROS_PARAMETROS IN VARCHAR2, FORZAR_EJECUCION IN VARCHAR2, O_ERROR_STATUS OUT VARCHAR2) IS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Enero 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almacenado para lanzar procesos y logarlos.
--              Necesita las tablas: LOG_GENERAL_PARAMETROS, LOG_GENERAL y LOG_PROCESO
--              Necesita las funciones: CONTAR_TOKENS y DEVUELVE_TOKEN
--              Necesita el procedure: INSERTAR_LOG_PROCESO
--              El LOG generado puede visualizarse con el proceso: VER_LOG
-- ===============================================================================================

  V_NOMBRE_PROCESO VARCHAR2(250);
  V_FECHA_CARGA_INI DATE; 
  V_FECHA_CARGA_END DATE;
  V_OTROS_PARAMETROS VARCHAR2(250);
  V_FORZAR_EJECUCION VARCHAR2(1);

  V_NOMBRE VARCHAR2(250) := 'LANZA_PROCESO_LOGADO';
  V_COUNT  NUMBER := 0;
  V_COUNT2  NUMBER := 0;
  V_COUNT_FECHAS  NUMBER := 0;
  V_NUM_BLOQUE  NUMBER;
  V_EJECUTAR BOOLEAN := FALSE;
  V_ESTADO VARCHAR2(20) := '';
  V_FECHA_INICIO timestamp;
  V_FECHA_FIN timestamp;
  V_HORA varchar2(8);
  V_SEGUNDOS NUMBER;
  
  V_PARAMETROS VARCHAR2(250);
  V_PARAMETRO_DATE_INI VARCHAR2(50);
  V_PARAMETRO_DATE_FIN VARCHAR2(50);
  V_PARAMETRO_ON_ERROR VARCHAR2(50); 
  V_NUM_OTROS_PARAMETROS INTEGER;

  V_SQL VARCHAR2(500);
  
  V_NUM_TOKENS_PARAMETROS NUMBER := 0;
  V_NUM_TOKENS_OTROS_PARAMETROS NUMBER := 0;
  V_NUM_TOKENS NUMBER := 0;
  V_SEPARADOR VARCHAR2(1) := ',';
  V_TOKEN VARCHAR2(50);
  V_TOKEN2 VARCHAR2(50);
  
Begin 
  
  --Log_Proceso 
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                    USING IN V_NOMBRE, 'INICIO - NOMBRE_PROCESO: ' || NOMBRE_PROCESO || 
                ', FECHA_CARGA_INI: ' || TO_CHAR(FECHA_CARGA_INI, 'yyyymmdd') || ', FECHA_CARGA_END: ' || TO_CHAR(FECHA_CARGA_END, 'yyyymmdd') ||
                ', OTROS_PARAMETROS: ' || OTROS_PARAMETROS ||
                ', FORZAR_EJECUCION: ' || NVL(FORZAR_EJECUCION, '')  , 0;
  
  ----------------------------
  --Asignación de variables  
  ---------------------------- 
  V_NOMBRE_PROCESO := NOMBRE_PROCESO;
  V_FECHA_CARGA_INI := FECHA_CARGA_INI; 
  V_FECHA_CARGA_END := FECHA_CARGA_END; 
  V_OTROS_PARAMETROS := NVL(OTROS_PARAMETROS, '');  
  V_FORZAR_EJECUCION := NVL(FORZAR_EJECUCION, 'N');  
  
  ------------------------------------
  --Validación de V_FORZAR_EJECUCION
  ------------------------------------
  V_FORZAR_EJECUCION := UPPER(V_FORZAR_EJECUCION);
  
  if V_FORZAR_EJECUCION IS NULL OR V_FORZAR_EJECUCION NOT IN ('N','S') then
    V_FORZAR_EJECUCION := 'N'; 
  end if;

  ------------------------------------------------
  --Validación en LOG_GENERAL_PARAMETROS y FECHAS
  ------------------------------------------------
  select count(*) into V_COUNT from LOG_GENERAL_PARAMETROS 
  where NOMBRE_PROCESO = V_NOMBRE_PROCESO
  and ACTIVO = 'S'; 
  
  if V_COUNT <> 1 then
    V_EJECUTAR := FALSE;
    V_ESTADO := 'ERROR';
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE, 'No se encuentra '|| NOMBRE_PROCESO || ' en LOG_GENERAL_PARAMETROS o no está activo.' , 1;
        
  else
    --Construcción de V_SQL
    select PARAMETROS, PARAMETRO_DATE_INI, PARAMETRO_DATE_FIN, PARAMETRO_ON_ERROR, NUM_OTROS_PARAMETROS
      INTO V_PARAMETROS, V_PARAMETRO_DATE_INI, V_PARAMETRO_DATE_FIN, V_PARAMETRO_ON_ERROR, V_NUM_OTROS_PARAMETROS
    from LOG_GENERAL_PARAMETROS 
    where NOMBRE_PROCESO = V_NOMBRE_PROCESO
    and ACTIVO = 'S'; 

    V_PARAMETROS := NVL(V_PARAMETROS, '');  
    V_PARAMETRO_DATE_INI := NVL(V_PARAMETRO_DATE_INI, '');  
    V_PARAMETRO_DATE_FIN := NVL(V_PARAMETRO_DATE_FIN, '');      
    V_PARAMETRO_ON_ERROR := NVL(V_PARAMETRO_ON_ERROR, '');  
    V_NUM_OTROS_PARAMETROS := NVL(V_NUM_OTROS_PARAMETROS, 0);
    V_SQL := V_PARAMETROS;
    
    if V_PARAMETRO_ON_ERROR is not null then
      V_SQL := replace(V_SQL, V_PARAMETRO_ON_ERROR, ':O_ERROR_STATUS');
    end if;

    if V_PARAMETRO_DATE_INI is not null AND V_PARAMETRO_DATE_FIN is not null then    
       --Validación de V_FECHA_CARGA_INI
      if V_FECHA_CARGA_INI IS NULL then
        SELECT MAX(DIA_ID) INTO V_FECHA_CARGA_INI FROM H_CNT;
        if V_FECHA_CARGA_INI IS NULL then
            SELECT sysdate - 1 INTO V_FECHA_CARGA_INI FROM DUAL;      
        else
            V_FECHA_CARGA_INI := V_FECHA_CARGA_INI + 1;  
        end if;      
      end if;
        
      --Validación de V_FECHA_CARGA_END
      if V_FECHA_CARGA_END IS NULL then
        --SELECT MAX(mov_fecha_extraccion) INTO V_FECHA_CARGA_END FROM recovery_haya_datastage.MOV_MOVIMIENTOS;
        SELECT max_dia_mov INTO V_FECHA_CARGA_END FROM recovery_haya_datastage.FECHAS_MOV;
        if V_FECHA_CARGA_END IS NULL then
            SELECT sysdate - 1 INTO V_FECHA_CARGA_END FROM DUAL;                    
        end if;    
      end if;

----------- Cambio 20140318
      V_FECHA_CARGA_INI := V_FECHA_CARGA_END;
      
      --Validación Fechas
      if V_FECHA_CARGA_INI > V_FECHA_CARGA_END then -- Cargamos el último día de datos de Datastage
        if  V_FORZAR_EJECUCION = 'S' then
          V_FECHA_CARGA_INI := V_FECHA_CARGA_END;
        else
          select count(*) INTO V_COUNT 
          from LOG_GENERAL 
          where NOMBRE_PROCESO = V_NOMBRE_PROCESO 
          and FECHA_CARGA = V_FECHA_CARGA_END; 
          
          if V_COUNT = 0 then V_FECHA_CARGA_INI := V_FECHA_CARGA_END; end if;
          
        end if;
      end if;     
      
      V_COUNT_FECHAS := (V_FECHA_CARGA_END - V_FECHA_CARGA_INI) + 1;

      V_SQL := replace(V_SQL, V_PARAMETRO_DATE_INI, ''''||TO_CHAR(V_FECHA_CARGA_INI, 'dd/mm/yyyy')||'''');

      V_SQL := replace(V_SQL, V_PARAMETRO_DATE_FIN, ''''||TO_CHAR(V_FECHA_CARGA_END, 'dd/mm/yyyy')||'''');
    else
      --fechas en blanco
      V_FECHA_CARGA_INI := systimestamp - 1;
      V_FECHA_CARGA_END := V_FECHA_CARGA_INI;
      V_COUNT_FECHAS := 1;            
    end if;
    
    --Log_Proceso después de validar 
    execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE,  'VALIDADO - NOMBRE_PROCESO: ' || NOMBRE_PROCESO || 
                  ', FECHA_CARGA_INI: ' || TO_CHAR(V_FECHA_CARGA_INI, 'yyyymmdd') || ', FECHA_CARGA_END: ' || TO_CHAR(V_FECHA_CARGA_END, 'yyyymmdd') ||
                  ', OTROS_PARAMETROS: ' || V_OTROS_PARAMETROS ||
                  ', FORZAR_EJECUCION: ' || V_FORZAR_EJECUCION, 1;
    

    --Tratamiento de parámetros
    V_NUM_TOKENS_PARAMETROS := Contar_Tokens(V_PARAMETROS, V_SEPARADOR);
    V_NUM_TOKENS_OTROS_PARAMETROS := Contar_Tokens(V_OTROS_PARAMETROS, V_SEPARADOR);

    if NVL(length(V_PARAMETRO_DATE_INI), 0) > 0 then
      V_NUM_TOKENS := V_NUM_TOKENS + 1;
    end if; 

    if NVL(length(V_PARAMETRO_DATE_FIN), 0) > 0 then
      V_NUM_TOKENS := V_NUM_TOKENS + 1;
    end if; 

    if NVL(length(V_PARAMETRO_ON_ERROR), 0) > 0 then
      V_NUM_TOKENS := V_NUM_TOKENS + 1;
    end if; 
    
    if V_NUM_TOKENS_PARAMETROS = V_NUM_TOKENS_OTROS_PARAMETROS + V_NUM_TOKENS  and  V_NUM_TOKENS_OTROS_PARAMETROS = V_NUM_OTROS_PARAMETROS then
      if V_NUM_OTROS_PARAMETROS > 0 then   
        --Ciclo FOR para ir sustituyendo los parámetros
        FOR V_COUNT IN 1..V_NUM_TOKENS_PARAMETROS
        LOOP         
          V_TOKEN := DEVUELVE_TOKEN (V_PARAMETROS, V_SEPARADOR, V_COUNT);
          if V_TOKEN != NVL(V_PARAMETRO_DATE_INI, '-') and  V_TOKEN != NVL(V_PARAMETRO_DATE_FIN, '-') and V_TOKEN != NVL(V_PARAMETRO_ON_ERROR, '-') then
            V_COUNT2 := V_COUNT2 + 1;
            V_TOKEN2 := DEVUELVE_TOKEN (V_OTROS_PARAMETROS, V_SEPARADOR, V_COUNT2);
            V_SQL := replace(V_SQL, V_TOKEN, V_TOKEN2);  
          end if;
        END LOOP;
     
      end if;
 
      V_EJECUTAR := TRUE;              

    else
      V_EJECUTAR := FALSE;
      V_ESTADO := 'ERROR';

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                        USING IN V_NOMBRE, 'ERROR - No se corresponden los números de otros parámetros('||TO_CHAR(V_NUM_OTROS_PARAMETROS)||') y parámetros('||TO_CHAR(V_NUM_TOKENS)||') con ''' || V_PARAMETROS || '''', 1;        
    end if;
--------------------------------  


    -- Construcción de la query
    V_SQL := 'BEGIN ' || V_NOMBRE_PROCESO || '(' || V_SQL || ')' || '; END;';
   

    if V_FECHA_CARGA_INI > V_FECHA_CARGA_END 
      then V_EJECUTAR := FALSE; 
    end if;
    
    
    ---------------------------
    --Validación de Ejecución  
    ---------------------------
    if V_EJECUTAR = TRUE then -- Viene de la validación por parámetros
      V_EJECUTAR := FALSE;
      
      if V_FORZAR_EJECUCION = 'S' OR V_COUNT_FECHAS > 1 then
        delete from LOG_GENERAL where NOMBRE_PROCESO = V_NOMBRE_PROCESO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') BETWEEN TO_CHAR(V_FECHA_CARGA_INI, 'YYYYMMDD') AND TO_CHAR(V_FECHA_CARGA_END, 'YYYYMMDD');
        commit;
        
        V_EJECUTAR := TRUE;
      else 
        select count(*) into V_COUNT from LOG_GENERAL 
        where NOMBRE_PROCESO = V_NOMBRE_PROCESO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA_INI, 'YYYYMMDD');
        
        CASE V_COUNT
          WHEN 0 THEN --No se ha ejecutado aún para esa fecha
            V_EJECUTAR := TRUE;
            
          WHEN 1 THEN --Se ha ejecutado para esa fecha, hay que mirar el estado
            select ESTADO into V_ESTADO from LOG_GENERAL
            where NOMBRE_PROCESO = V_NOMBRE_PROCESO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA_INI, 'YYYYMMDD');
            
            if V_ESTADO in ('EN PROCESO', 'OK') then --O está ejecutándose o se ejecutó correctamente
              V_EJECUTAR := FALSE;
            else --Se ejecutó erroneamente con lo que se puede lanzar de nuevo
              delete from LOG_GENERAL where NOMBRE_PROCESO = V_NOMBRE_PROCESO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA_INI, 'YYYYMMDD');
              commit;
                
              V_EJECUTAR := TRUE;          
            end if;
            
          ELSE  --Demás casos, se borran todas las líneas de LOG_GENERAL
            delete from LOG_GENERAL where NOMBRE_PROCESO = V_NOMBRE_PROCESO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA_INI, 'YYYYMMDD');
            commit;
              
            V_EJECUTAR := TRUE;
        END CASE;
    
      end if;
    end if;
  end if;
  
  
  ----------------------
  --BLOQUE PROGRAMACION
  ----------------------  
  if V_EJECUTAR THEN
    V_ESTADO := 'EN PROCESO';
    
    select NVL(MAX(NUM_BLOQUE), 0) + 1 INTO V_NUM_BLOQUE FROM LOG_GENERAL;        
    
    V_FECHA_INICIO := systimestamp;
    
    FOR V_COUNT IN 1..V_COUNT_FECHAS LOOP
      insert into LOG_GENERAL (FECHA_CARGA, FECHA_INICIO, FECHA_FIN, NOMBRE_PROCESO, ESTADO, TIEMPO_MEDIO_CARGA_DIA, NUM_BLOQUE) 
        values (V_FECHA_CARGA_INI + (V_COUNT - 1), V_FECHA_INICIO, null, V_NOMBRE_PROCESO, V_ESTADO, 0, V_NUM_BLOQUE);
      commit;
    END LOOP;
    
    
    V_ESTADO := 'OK'; --Se cambia el estado a lo largo del proceso en caso necesario
    
    ---------------------
    --LLAMADA AL PROCESO
    ---------------------
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE, 'Inicio llamada al proceso ' || V_SQL, 1;
 
    if V_PARAMETRO_ON_ERROR is not null then
      execute immediate V_SQL USING OUT O_ERROR_STATUS;
    else
      execute immediate V_SQL;
    end if;
    
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE, 'Fin llamada al proceso ' || V_NOMBRE_PROCESO, 1;
     

    ------------------
    --FIN DEL PROCESO
    ------------------
    V_FECHA_FIN := systimestamp;
    V_HORA := (to_char(trunc(sysdate) + (V_FECHA_FIN - V_FECHA_INICIO),'hh24:mi:ss'));
    V_SEGUNDOS := (TO_NUMBER(SUBSTR(V_HORA, 1, 2)) * 3600) +  (TO_NUMBER(SUBSTR(V_HORA, 4, 2)) * 60) + (TO_NUMBER(SUBSTR(V_HORA, 7, 2)));
    --select (V_FECHA_FIN - V_FECHA_INICIO)*84600 datediff into V_SEGUNDOS FROM DUAL;
    
    update LOG_GENERAL 
    set   FECHA_FIN = V_FECHA_FIN, 
          ESTADO = V_ESTADO,
          TIEMPO_MEDIO_CARGA_DIA = V_SEGUNDOS / V_COUNT_FECHAS
    where NUM_BLOQUE = V_NUM_BLOQUE;
    commit;
 
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE, 'Terminada la ejecución'  , 1;
                      
  else
    --Log_Proceso  
    execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE, 'No se ejecuta'  , 1;
      
  end if;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                    USING IN V_NOMBRE, 'FIN - '|| V_ESTADO , 0;
  

    
EXCEPTION  
  WHEN OTHERS THEN
    V_ESTADO := 'ERROR';
    V_FECHA_FIN := systimestamp;
    V_HORA := (to_char(trunc(sysdate) + (V_FECHA_FIN - V_FECHA_INICIO),'hh24:mi:ss'));
    V_SEGUNDOS := (TO_NUMBER(SUBSTR(V_HORA, 1, 2)) * 3600) +  (TO_NUMBER(SUBSTR(V_HORA, 4, 2)) * 60) + (TO_NUMBER(SUBSTR(V_HORA, 7, 2)));
    
    update LOG_GENERAL 
    set   FECHA_FIN = V_FECHA_FIN, 
          ESTADO = V_ESTADO,
          TIEMPO_MEDIO_CARGA_DIA = V_SEGUNDOS / V_COUNT_FECHAS
    where NUM_BLOQUE = V_NUM_BLOQUE;      
    commit;
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_LOG_PROCESO(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE, 'FIN - ERROR: '||O_ERROR_STATUS , 0;
                    
    --ROLLBACK;  
    
    
end;
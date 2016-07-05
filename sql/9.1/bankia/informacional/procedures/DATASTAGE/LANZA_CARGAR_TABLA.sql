create or replace PROCEDURE  LANZA_CARGAR_TABLA (NOMBRE_TABLA IN VARCHAR2, OTROS_PARAMETROS IN VARCHAR2, FORZAR_EJECUCION IN VARCHAR2, O_ERROR_STATUS OUT VARCHAR2) IS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Abril 2015
-- Responsable ultima modificacion:  Diego Pérez, PFS Group
-- Fecha ultima modificacion: 21/08/2015
-- Motivos del cambio: Usuario/Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almacenado para lanzar Cargas de tablas
-- ===============================================================================================

  
  nCount NUMBER;
  V_ESQUEMA VARCHAR2(100);
  V_OTROS_PARAMETROS VARCHAR(250) := NVL(OTROS_PARAMETROS, '');
  V_NUM_BLOQUE NUMBER;
  V_NUM_ORDEN NUMBER;
  V_FORZAR_EJECUCION VARCHAR2(1) := FORZAR_EJECUCION;
  V_INDEX_NAME VARCHAR2(100);
  V_STATUS VARCHAR2(100);
  
  V_EJECUTAR BOOLEAN := FALSE;
  V_ESTADO VARCHAR2(20) := '';
  V_ROWCOUNT NUMBER(10);
  
  V_NOMBRE_TABLA_DESTINO VARCHAR2(100) := NVL(NOMBRE_TABLA, '');
  V_TIPO_CARGA NUMBER; --1: TRUNCATE-INSERT-SELECT (POR DEFECTO), 2: DROP-CREATE-SELECT (COLUMNAS), 3: DROP-CREATE-SELECT (*), 4: DELETE-INSERT
  V_COLUMNAS VARCHAR2(4000);     
  V_CLAUSULA_SELECT VARCHAR2(4000);
  V_CLAUSULA_FROM VARCHAR2(4000);  
  V_CLAUSULA_WHERE VARCHAR2(4000);  
  V_INDICE1 VARCHAR2(4000);
  V_INDICE2 VARCHAR2(4000);
  V_INDICE3 VARCHAR2(4000);
  V_INDICE4 VARCHAR2(4000);
  V_CLAUSULA_CREATE VARCHAR2(4000);
  
  V_FECHA_CARGA DATE := TRUNC(systimestamp) - 1;
  V_FECHA_INICIO DATE; 
  V_FECHA_FIN DATE;  
  V_HORA varchar2(8);
  V_SEGUNDOS NUMBER;
  
  V_SQL VARCHAR2(16000);
  
  cursor c_index is select INDEX_NAME, STATUS from USER_INDEXES where UPPER(TABLE_NAME) = V_NOMBRE_TABLA_DESTINO and UPPER(TABLE_NAME) <> 'H_REC_FICHERO_CONTRATOS' and UPPER(TABLE_NAME) <> 'CPA_COBROS_PAGOS' and TABLESPACE_NAME = V_ESQUEMA and INDEX_NAME not like 'SYS%' ;

  
BEGIN

  select valor into V_ESQUEMA from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;'
                      USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, 'INICIO - NOMBRE_TABLA: ' || NOMBRE_TABLA || 
                ', OTROS_PARAMETROS: ' || OTROS_PARAMETROS ||
                ', FORZAR_EJECUCION: ' || NVL(FORZAR_EJECUCION, '')  , 1;
                
  ------------------------------------
  --Validación de V_FORZAR_EJECUCION
  ------------------------------------
  V_FORZAR_EJECUCION := NVL(FORZAR_EJECUCION, 'N');  
  V_FORZAR_EJECUCION := UPPER(V_FORZAR_EJECUCION);
  
  if V_FORZAR_EJECUCION IS NULL OR V_FORZAR_EJECUCION NOT IN ('N','S') then
    V_FORZAR_EJECUCION := 'N'; 
  end if;
  
  ------------------------------------------------
  --Validación en CARGAR_TABLA_PARAMETROS
  ------------------------------------------------
  --Podemos tener la misma tabla en varios bloques de carga pero solo se cargaría una vez
  select count(*) into nCount 
  from CARGAR_TABLA_PARAMETROS 
  where NOMBRE_TABLA_DESTINO = V_NOMBRE_TABLA_DESTINO 
  and ACTIVO = 'S'; 
  
  if nCount < 1 then
    V_EJECUTAR := FALSE;
    V_ESTADO := 'ERROR';
    
    --Log_Cargar_Tabla
    execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                      USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, 'No se encuentra '|| V_NOMBRE_TABLA_DESTINO || ' en CARGAR_TABLA_PARAMETROS o no está activo.' , 2;

  else        
    select NVL(NOMBRE_TABLA_DESTINO, ''), NVL(TIPO_CARGA, 0), COLUMNAS, CLAUSULA_SELECT, CLAUSULA_FROM, CLAUSULA_WHERE, INDICE1, INDICE2, INDICE3, INDICE4, CLAUSULA_CREATE, BLOQUE, ORDEN 
      INTO V_NOMBRE_TABLA_DESTINO, V_TIPO_CARGA, V_COLUMNAS, V_CLAUSULA_SELECT, V_CLAUSULA_FROM, V_CLAUSULA_WHERE, V_INDICE1, V_INDICE2, V_INDICE3, V_INDICE4, V_CLAUSULA_CREATE, V_NUM_BLOQUE, V_NUM_ORDEN
    from (select *      
          from CARGAR_TABLA_PARAMETROS 
          where NOMBRE_TABLA_DESTINO = V_NOMBRE_TABLA_DESTINO
          and ACTIVO = 'S'
          order by BLOQUE, ORDEN)
    WHERE ROWNUM <=1; 

    --Validación TIPO_CARGA      
    if V_TIPO_CARGA NOT IN (1, 2, 3, 4, 5, 6) then
      V_TIPO_CARGA := 1; 
    end if;

    --Forzar_Ejecución
    if V_FORZAR_EJECUCION = 'S' then
      delete from LOG_CARGAR_TABLA_GENERAL where NOMBRE_TABLA = V_NOMBRE_TABLA_DESTINO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA, 'YYYYMMDD');
      commit;    
        
      V_EJECUTAR := TRUE;
    else 
      select count(*) into nCount from LOG_CARGAR_TABLA_GENERAL 
      where NOMBRE_TABLA = V_NOMBRE_TABLA_DESTINO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA, 'YYYYMMDD');
        
      CASE nCount
        WHEN 0 THEN --No se ha ejecutado aún para esa fecha
          V_EJECUTAR := TRUE;          
        ELSE --Se ha ejecutado para esa fecha, hay que mirar el estado
          select count(*) into nCount from LOG_CARGAR_TABLA_GENERAL
          where NOMBRE_TABLA = V_NOMBRE_TABLA_DESTINO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA, 'YYYYMMDD')
          and estado not in ('EN PROCESO', 'OK');
          
          if nCount > 0 then --Se ejecutó erroneamente con lo que se puede lanzar de nuevo
            delete from LOG_CARGAR_TABLA_GENERAL where NOMBRE_TABLA = V_NOMBRE_TABLA_DESTINO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA, 'YYYYMMDD');
            commit;
              
            V_EJECUTAR := TRUE;            
          else -- está ejecutándose o se ejecutó correctamente          
            V_EJECUTAR := FALSE;

            --Log_Cargar_Tabla
            execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                              USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Error: En proceso de Carga o Terminado sin Forzar Ejecución' , 2;                               
          end if;          
      END CASE;
    
    end if;    


    ---------------------
    --Validacion final
    ---------------------      
    if V_EJECUTAR then   
      V_FECHA_INICIO := systimestamp;
      V_ESTADO := 'EN PROCESO';

      insert into LOG_CARGAR_TABLA_GENERAL (FECHA_CARGA, FECHA_INICIO, FECHA_FIN, NOMBRE_TABLA, ESTADO, TIEMPO_CARGA_DIA, NUM_BLOQUE, NUM_ORDEN) 
      select V_FECHA_CARGA, V_FECHA_INICIO, null, NOMBRE_TABLA_DESTINO, V_ESTADO, 0, BLOQUE, ORDEN
        from CARGAR_TABLA_PARAMETROS 
        where NOMBRE_TABLA_DESTINO = V_NOMBRE_TABLA_DESTINO
        and ACTIVO = 'S';

      CASE  
      WHEN V_TIPO_CARGA in (1, 4, 5, 6) THEN --1: TRUNCATE-INSERT-SELECT. 4: TRUNCATE-INSERT-SELECT-WHERE. 5: INSERT-SELECT-WHERE. 6: TRUNCATE-LLAMADA A PROCESO
        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Empieza Carga Tabla. Tipo ' || TO_CHAR(V_TIPO_CARGA) , 2;
              
        --Crear o Truncar 
        select count(*) into nCount from user_tables where table_name = V_NOMBRE_TABLA_DESTINO and TABLESPACE_NAME = V_ESQUEMA;

        if(nCount = 0) then 
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''' || V_NOMBRE_TABLA_DESTINO || ''', ''' || V_CLAUSULA_CREATE || ''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Fin CREATE' , 3;
          
          --Indices
          if V_INDICE1 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE1'', ''' || V_INDICE1 || ''', ''S'', '''', :O_ERROR_STATUS); END;';          
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
            --Log_Cargar_Tabla
            execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                              USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 1' , 3;          
          end if;

          if V_INDICE2 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE2'', ''' || V_INDICE2 || ''', ''S'', '''', :O_ERROR_STATUS); END;';          
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
            --Log_Cargar_Tabla
            execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                              USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 2' , 3;          
          end if;

          if V_INDICE3 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE3'', ''' || V_INDICE3 || ''', ''S'', '''', :O_ERROR_STATUS); END;';          
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
            --Log_Cargar_Tabla
            execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                              USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 3' , 3;          
          end if;

          if V_INDICE4 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE4'', ''' || V_INDICE4 || ''', ''S'', '''', :O_ERROR_STATUS); END;';                    
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
            --Log_Cargar_Tabla
            execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                              USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 4' , 3;          
          end if;
          
        else
          if V_TIPO_CARGA not in (5, 6) then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''' || V_NOMBRE_TABLA_DESTINO || ''', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
            --Log_Cargar_Tabla
            execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                              USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Fin TRUNCATE' , 3;                                       
          end if;                              
        end if;

        --Desactivación Índices
        OPEN c_index;
          LOOP
            FETCH c_index INTO V_INDEX_NAME, V_STATUS;
            EXIT WHEN c_index%NOTFOUND;
/*            
              if V_STATUS = 'VALID' then execute immediate 'ALTER INDEX ' || V_INDEX_NAME || ' UNUSABLE'; end if;
              commit;
*/                          
              V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''' || V_INDEX_NAME || ''', '''', ''S'', '''', :O_ERROR_STATUS); END;';
              execute immediate V_SQL USING OUT O_ERROR_STATUS;
              
              --Log_Cargar_Tabla
              execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                                USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Desactivado Índice ' || V_INDEX_NAME , 3;                   
          END LOOP; 
        CLOSE c_index;            

        --Inserción
        case 
        when V_TIPO_CARGA in (1) then
          execute immediate 'INSERT INTO ' || V_NOMBRE_TABLA_DESTINO || ' (' || V_COLUMNAS || ') SELECT ' || V_CLAUSULA_SELECT || ' FROM ' || V_CLAUSULA_FROM;                      
          V_ROWCOUNT := sql%rowcount;     
          commit;          
          
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Registros Insertados: ' || to_char(V_ROWCOUNT) , 3;                             
        when V_TIPO_CARGA in (4, 5) then
          execute immediate 'INSERT INTO ' || V_NOMBRE_TABLA_DESTINO || ' (' || V_COLUMNAS || ') SELECT ' || V_CLAUSULA_SELECT || ' FROM ' || V_CLAUSULA_FROM || ' WHERE ' || V_CLAUSULA_WHERE ;                      
          V_ROWCOUNT := sql%rowcount;     
          commit;          
          
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Registros Insertados: ' || to_char(V_ROWCOUNT) , 3;                             
        when V_TIPO_CARGA in (6) then  
          execute immediate 'BEGIN ' || V_CLAUSULA_SELECT || '; END;';
        end case;

        --Activación de Índices
        OPEN c_index;
          LOOP
            FETCH c_index INTO V_INDEX_NAME, V_STATUS;
            EXIT WHEN c_index%NOTFOUND;
/*            
              if V_STATUS = 'UNUSABLE' then execute immediate 'ALTER INDEX ' || V_INDEX_NAME || ' REBUILD PARALLEL'; end if;
              commit;          
*/
              V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_INDEX_NAME || ''', '''', ''S'', '''', :O_ERROR_STATUS); END;';
              execute immediate V_SQL USING OUT O_ERROR_STATUS;

              --Log_Cargar_Tabla
              execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                                USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Activado Índice ' || V_INDEX_NAME , 3;                   
          END LOOP; 
        CLOSE c_index;              

        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Termina Carga Tabla. Tipo ' || TO_CHAR(V_TIPO_CARGA) , 2;                   

      WHEN V_TIPO_CARGA = 2 THEN --2: DROP-CREATE-SELECT (COLUMNAS)  
        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Empieza Carga Tabla. Tipo 2' , 2;

        --Drop Table
        select count(*) into nCount from user_tables where table_name = V_NOMBRE_TABLA_DESTINO and TABLESPACE_NAME = V_ESQUEMA;

        if(nCount > 0) then           
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''DROP'', ''' || V_NOMBRE_TABLA_DESTINO || ''', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Fin DROP' , 3;
        end if;
                        
        --CREATE AS SELECT
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE_AS'', ''' || V_NOMBRE_TABLA_DESTINO || ''', '' as select ' || V_CLAUSULA_SELECT || ' FROM ' || V_CLAUSULA_FROM || ''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Registros Insertados: ' || to_char(V_ROWCOUNT) , 3;                   
                            
        --Indices
        if V_INDICE1 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE1'', ''' || V_INDICE1 || ''', ''S'', '''', :O_ERROR_STATUS); END;';                             
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 1' , 3;          
        end if;

        if V_INDICE2 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE2'', ''' || V_INDICE2 || ''', ''S'', '''', :O_ERROR_STATUS); END;';          
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 2' , 3;          
        end if;

        if V_INDICE3 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE3'', ''' || V_INDICE3 || ''', ''S'', '''', :O_ERROR_STATUS); END;';          
            execute immediate V_SQL USING OUT O_ERROR_STATUS;

          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 3' , 3;          
        end if;

        if V_INDICE4 is not null then
            V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE4'', ''' || V_INDICE4 || ''', ''S'', '''', :O_ERROR_STATUS); END;';                  
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 4' , 3;          
        end if;
        
        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Termina Carga Tabla. Tipo 2' , 3;
                
      WHEN V_TIPO_CARGA = 3 THEN --3: DROP-CREATE-SELECT (*)           
        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Empieza Carga Tabla. Tipo 3' , 3;

        --Drop Table
        select count(*) into nCount from user_tables where table_name = V_NOMBRE_TABLA_DESTINO and TABLESPACE_NAME = V_ESQUEMA;

        if(nCount > 0) then           
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''DROP'', ''' || V_NOMBRE_TABLA_DESTINO || ''', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;

          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Fin DROP' , 3;
        end if;
                        
        --CREATE AS SELECT
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE_AS'', ''' || V_NOMBRE_TABLA_DESTINO || ''', '' as select * FROM ' || V_CLAUSULA_FROM || ''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Registros Insertados: ' || to_char(V_ROWCOUNT) , 3;                   
                            
        --Indices
        if V_INDICE1 is not null then
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE1'', ''' || V_INDICE1 || ''', ''S'', '''', :O_ERROR_STATUS); END;';          
          execute immediate V_SQL USING OUT O_ERROR_STATUS;

        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 1' , 3;          
        end if;

        if V_INDICE2 is not null then
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE2'', ''' || V_INDICE2 || ''', ''S'', '''', :O_ERROR_STATUS); END;';                  
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 2' , 3;          
        end if;

        if V_INDICE3 is not null then
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE3'', ''' || V_INDICE3 || ''', ''S'', '''', :O_ERROR_STATUS); END;';          
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 3' , 3;          
        end if;

        if V_INDICE4 is not null then
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE_AS'', ''V_INDICE4'', ''' || V_INDICE4 || ''', ''S'', '''', :O_ERROR_STATUS); END;';                  
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
        
          --Log_Cargar_Tabla
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                            USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Creado Índice 4' , 3;          
        end if;
        
        --Log_Cargar_Tabla
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' 
                          USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Termina Carga Tabla. Tipo 3' , 2;
      
/*        
      when 4 then --3: DELETE-INSERT 
        --Existe Tabla?. Crear o Truncar
        
        DBMS_OUTPUT.put_line(V_NOMBRE_TABLA_DESTINO || '. Empieza Carga Tabla. Tipo 4');          
        DBMS_OUTPUT.put_line(V_NOMBRE_TABLA_DESTINO || '. Termina Carga Tabla. Tipo 4');          
*/       
      END CASE;


      --FIN DEL PROCESO
      V_ESTADO := 'OK';
      V_FECHA_FIN := systimestamp;
      V_HORA := (to_char(trunc(sysdate) + (V_FECHA_FIN - V_FECHA_INICIO),'hh24:mi:ss'));
      V_SEGUNDOS := (TO_NUMBER(SUBSTR(V_HORA, 1, 2)) * 3600) +  (TO_NUMBER(SUBSTR(V_HORA, 4, 2)) * 60) + (TO_NUMBER(SUBSTR(V_HORA, 7, 2)));
      
      
      update LOG_CARGAR_TABLA_GENERAL 
      set   FECHA_FIN = V_FECHA_FIN, 
            ESTADO = V_ESTADO,
            TIEMPO_CARGA_DIA = V_SEGUNDOS
      where NOMBRE_TABLA = V_NOMBRE_TABLA_DESTINO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA, 'YYYYMMDD');
      commit;
    
    else
      V_ESTADO := 'ERROR';
      
      --Log_Cargar_Tabla
      execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;'
                        USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, V_NOMBRE_TABLA_DESTINO || '. Error en Validación Final'  , 2;
    end if;
    
  end if;

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;'
                    USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, 'FIN - '|| V_ESTADO  , 1;

  
EXCEPTION  
  WHEN OTHERS THEN
    V_ESTADO := 'ERROR';
    V_FECHA_FIN := systimestamp;
    V_HORA := (to_char(trunc(sysdate) + (V_FECHA_FIN - V_FECHA_INICIO),'hh24:mi:ss'));
    V_SEGUNDOS := (TO_NUMBER(SUBSTR(V_HORA, 1, 2)) * 3600) +  (TO_NUMBER(SUBSTR(V_HORA, 4, 2)) * 60) + (TO_NUMBER(SUBSTR(V_HORA, 7, 2)));
    
    update LOG_CARGAR_TABLA_GENERAL 
    set   FECHA_FIN = V_FECHA_FIN, 
          ESTADO = V_ESTADO,
          TIEMPO_CARGA_DIA = V_SEGUNDOS
    where NOMBRE_TABLA = V_NOMBRE_TABLA_DESTINO and TO_CHAR(FECHA_CARGA, 'YYYYMMDD') = TO_CHAR(V_FECHA_CARGA, 'YYYYMMDD');
    commit;    

    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;

    --Log_Cargar_Tabla
    execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;'
                      USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, O_ERROR_STATUS  , 2;
    --Log_Cargar_Tabla
    execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;'
                      USING IN V_NOMBRE_TABLA_DESTINO, V_NUM_BLOQUE, V_NUM_ORDEN, 'FIN - '|| V_ESTADO  , 1;
                    
    --ROLLBACK;  
    
END;

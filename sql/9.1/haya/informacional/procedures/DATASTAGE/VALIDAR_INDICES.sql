create or replace PROCEDURE  VALIDAR_INDICES(ACTIVAR IN varchar2, O_ERROR_STATUS OUT VARCHAR2) IS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Abril 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 23/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento para validar los índices activándolos o desactivádonlos
-- ===============================================================================================

  V_NOMBRE_PROCESO VARCHAR2(4000) := 'VALIDAR_INDICES';
  V_NOMBRE_TABLA_DESTINO  VARCHAR2(100); 
  V_INDICE1 VARCHAR2(4000); 
  V_INDICE2 VARCHAR2(4000);
  V_INDICE3 VARCHAR2(4000);
  V_INDICE4 VARCHAR2(4000);
  V_ESQUEMA VARCHAR2(100);
  V_STATUS VARCHAR2(100);
  V_COUNT number;
  V_SQL VARCHAR2(1000);
  V_ACTIVAR  VARCHAR2(1); -- := 'S';

  V_NOMBRE_IND VARCHAR2(4000);
  V_PARAMETROS_IND VARCHAR2(4000);

  Cursor C1 is  select NOMBRE_TABLA_DESTINO, INDICE1, INDICE2, INDICE3, INDICE4 
                from CARGAR_TABLA_PARAMETROS
                where INDICE1 is not null
                and ACTIVO = 'S';
     
begin

  select valor into V_ESQUEMA from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  
  --Validar V_ACTIVAR
  V_ACTIVAR := UPPER(ACTIVAR);
  
  if V_ACTIVAR IS NULL OR V_ACTIVAR NOT IN ('N','S') then
    V_ACTIVAR := 'S'; 
  end if;    
  
  --Log
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Empieza ' || V_NOMBRE_PROCESO || '. ACTIVAR = ' || V_ACTIVAR, 0;  
  
  OPEN C1;
  LOOP
    FETCH C1 INTO V_NOMBRE_TABLA_DESTINO, V_INDICE1, V_INDICE2, V_INDICE3, V_INDICE4;
    EXIT WHEN C1%NOTFOUND;
       
    --V_INDICE1   
    if V_INDICE1 is not null then

      --NOMBRE INDICE
      V_NOMBRE_IND :=  SUBSTR(V_INDICE1, 1, INSTR(V_INDICE1, ' ') -1);
      --PARAMETROS INDICE
      V_PARAMETROS_IND :=  SUBSTR(V_INDICE1, INSTR(V_INDICE1, ' ON ') + 4, LENGTH(V_INDICE1));
    
      --Log
      execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, V_NOMBRE_TABLA_DESTINO || ' - ' || V_INDICE1, 1;  
    
      execute immediate 'select count(*) from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE1 || ''', 1, INSTR(''' || V_INDICE1 || ''', '' '') - 1)' INTO V_COUNT;               
                         
      if V_COUNT = 0 then    
        --Crear Índice 
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''N'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;

        --Log
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Creado', 2;          
      end if;
       
      execute immediate 'select STATUS from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE1 || ''', 1, INSTR(''' || V_INDICE1 || ''', '' '') - 1)' INTO V_STATUS;                                              

      if V_ACTIVAR = 'S' then
        if V_STATUS <> 'VALID' then
          --Rebuild Index
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Activado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se activa, ya estaba activado', 2;          
        end if;
      else      
        if V_STATUS = 'VALID' then
          --Unusable Index        
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''' || V_NOMBRE_IND || ''', '''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Desactivado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se desactiva, ya estaba desactivado', 2;          
        end if;        
      end if;                          
    end if;
  
    --V_INDICE2   
    if V_INDICE2 is not null then

      --NOMBRE INDICE
      V_NOMBRE_IND :=  SUBSTR(V_INDICE2, 1, INSTR(V_INDICE2, ' ') -1);
      --PARAMETROS INDICE
      V_PARAMETROS_IND :=  SUBSTR(V_INDICE2, INSTR(V_INDICE2, ' ON ') + 4, LENGTH(V_INDICE2));
    
      --Log
      execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, V_NOMBRE_TABLA_DESTINO || ' - ' || V_INDICE2, 1;  
    
      execute immediate 'select count(*) from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE2 || ''', 1, INSTR(''' || V_INDICE2 || ''', '' '') - 1)' INTO V_COUNT;               
                         
      if V_COUNT = 0 then    
        --Crear Índice 
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''N'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;

        --Log
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Creado', 2;          
      end if;
       
      execute immediate 'select STATUS from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE2 || ''', 1, INSTR(''' || V_INDICE2 || ''', '' '') - 1)' INTO V_STATUS;                                              

      if V_ACTIVAR = 'S' then
        if V_STATUS <> 'VALID' then
          --Rebuild Index
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Activado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se activa, ya estaba activado', 2;          
        end if;
      else      
        if V_STATUS = 'VALID' then
          --Unusable Index        
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''' || V_NOMBRE_IND || ''', '''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Desactivado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se desactiva, ya estaba desactivado', 2;          
        end if;        
      end if;                          
    end if;

    --V_INDICE3   
    if V_INDICE3 is not null then

      --NOMBRE INDICE
      V_NOMBRE_IND :=  SUBSTR(V_INDICE3, 1, INSTR(V_INDICE3, ' ') -1);
      --PARAMETROS INDICE
      V_PARAMETROS_IND :=  SUBSTR(V_INDICE3, INSTR(V_INDICE3, ' ON ') + 4, LENGTH(V_INDICE3));
    
      --Log
      execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, V_NOMBRE_TABLA_DESTINO || ' - ' || V_INDICE3, 1;  
    
      execute immediate 'select count(*) from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE3 || ''', 1, INSTR(''' || V_INDICE3 || ''', '' '') - 1)' INTO V_COUNT;               
                         
      if V_COUNT = 0 then    
        --Crear Índice 
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''N'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;

        --Log
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Creado', 2;          
      end if;
       
      execute immediate 'select STATUS from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE3 || ''', 1, INSTR(''' || V_INDICE3 || ''', '' '') - 1)' INTO V_STATUS;                                              

      if V_ACTIVAR = 'S' then
        if V_STATUS <> 'VALID' then
          --Rebuild Index
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Activado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se activa, ya estaba activado', 2;          
        end if;
      else      
        if V_STATUS = 'VALID' then
          --Unusable Index        
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''' || V_NOMBRE_IND || ''', '''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Desactivado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se desactiva, ya estaba desactivado', 2;          
        end if;        
      end if;                          
    end if;
    
    --V_INDICE4   
    if V_INDICE4 is not null then

      --NOMBRE INDICE
      V_NOMBRE_IND :=  SUBSTR(V_INDICE4, 1, INSTR(V_INDICE4, ' ') -1);
      --PARAMETROS INDICE
      V_PARAMETROS_IND :=  SUBSTR(V_INDICE4, INSTR(V_INDICE4, ' ON ') + 4, LENGTH(V_INDICE4));
    
      --Log
      execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, V_NOMBRE_TABLA_DESTINO || ' - ' || V_INDICE4, 1;  
    
      execute immediate 'select count(*) from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE4 || ''', 1, INSTR(''' || V_INDICE4 || ''', '' '') - 1)' INTO V_COUNT;               
                         
      if V_COUNT = 0 then    
        --Crear Índice 
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''N'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;

        --Log
        execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Creado', 2;          
      end if;
       
      execute immediate 'select STATUS from USER_INDEXES 
                        where TABLE_NAME = UPPER(''' || V_NOMBRE_TABLA_DESTINO || ''') 
                        and TABLE_OWNER = UPPER(''' || V_ESQUEMA || ''')
                        and INDEX_NAME = SUBSTR(''' || V_INDICE4 || ''', 1, INSTR(''' || V_INDICE4 || ''', '' '') - 1)' INTO V_STATUS;                                              

      if V_ACTIVAR = 'S' then
        if V_STATUS <> 'VALID' then
          --Rebuild Index
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''' || V_NOMBRE_IND || ''', ''' || V_PARAMETROS_IND || ''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Activado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se activa, ya estaba activado', 2;          
        end if;
      else      
        if V_STATUS = 'VALID' then
          --Unusable Index        
          V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''' || V_NOMBRE_IND || ''', '''', ''S'', '''', :O_ERROR_STATUS); END;';
          execute immediate V_SQL USING OUT O_ERROR_STATUS;
          
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice Desactivado', 2;          
        else
          --Log
          execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Indice no se desactiva, ya estaba desactivado', 2;          
        end if;        
      end if;                          
    end if;

    
  END LOOP;  
  CLOSE C1;
    
  --Log
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Termina ' || V_NOMBRE_PROCESO || '. ACTIVAR = ' ||  V_ACTIVAR, 0;  

EXCEPTION  
  WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;

    --Log
    execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, O_ERROR_STATUS, 1;  

    --Log
    execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE_PROCESO, 0, 0, 'Termina ' || V_NOMBRE_PROCESO || '. ACTIVAR = ' ||  V_ACTIVAR, 0;  
                    
    --ROLLBACK; 
    
end;

create or replace package body OPERACION_DDL  as

  --** Funcion para validar la existencia del objeto
  function existe_objeto (tipo IN VARCHAR2, esquema IN VARCHAR2, nombre IN VARCHAR2)
  return boolean
  is
    v_count   integer;
    v_tipo    varchar2(30);
    v_esquema varchar2(30);
    v_nombre  varchar2(30);
    retorno boolean;
  begin

    v_tipo    := trim(UPPER(tipo));
    v_esquema := trim(UPPER(esquema));
    v_nombre  := trim(UPPER(nombre));

    Select nvl(count(*),0) into v_count
      From all_objects
     Where owner = v_esquema
       And object_name = v_nombre
       And object_type = v_tipo;

    If v_count > 0
     Then retorno := TRUE;
          DBMS_OUTPUT.PUT_LINE('Existe');
     Else retorno := FALSE;
          DBMS_OUTPUT.PUT_LINE('No existe');
    End if;

    Return retorno;
  end existe_objeto;



  --** Función que ejecuta la operación
  procedure ejecuta_str (sentencia IN varchar2)
  is
    cur     PLS_INTEGER;
    fdbk    PLS_INTEGER;
  begin
    DBMS_OUTPUT.PUT_LINE(sentencia);
    cur := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE (cur, sentencia, DBMS_SQL.NATIVE);
    fdbk := DBMS_SQL.EXECUTE (cur);
    Commit;
    DBMS_SQL.CLOSE_CURSOR (cur);
         
  end ejecuta_str;

  --** Procedimiento para insercion en log
  procedure  insertar_log_operacion_dll ( TIPO IN VARCHAR2
                                        , OPERACION IN VARCHAR2
                                        , ESQUEMA IN VARCHAR2
                                        , OBJETO IN VARCHAR2
                                        , PARAMETROS IN VARCHAR2
                                        , ESTADO IN VARCHAR2) 
  as
  
    V_SID NUMBER;
    V_ESQUEMA VARCHAR2(30);
    
  begin
  
    /* DEFINICION DE LA TABLA DESTINO Y LA SECUENCIA ID:
      
        CREATE TABLE LOG_OPERACION_DLL
          ( FILA_ID     NUMBER     not null,
            FECHA       TIMESTAMP  not null,
            NUM_SID     NUMBER     not null,
            TIPO        VARCHAR2(100),
            OPERACION   VARCHAR2(100),
            ESQUEMA     VARCHAR2(100),
            OBJETO      VARCHAR2(100),
            PARAMETROS  VARCHAR2(250),
            ESTADO      VARCHAR(250)
          ); 

          CREATE SEQUENCE INCR_LOG_OPERACION_DLL
            MINVALUE 1
            INCREMENT BY 1 
            START WITH 1
            nomaxvalue;    
    */
    
    select sys_context('USERENV','SID') INTO V_SID from dual;
    V_ESQUEMA := upper(ESQUEMA);
    
    insert into LOG_OPERACION_DLL (FILA_ID, FECHA, NUM_SID, TIPO, OPERACION, ESQUEMA, OBJETO, PARAMETROS, ESTADO)
         values ( INCR_LOG_OPERACION_DLL.nextval
                , systimestamp
                , V_SID
                , substr(TIPO, 1, 100)
                , substr(OPERACION, 1, 100)
                , V_ESQUEMA
                , substr(OBJETO, 1, 100)
                , substr(PARAMETROS, 1, 250)
                , substr(ESTADO, 1, 250));
    commit;   
    
  end insertar_log_operacion_dll;
  

  -- ==========================
  --  Operaciones sobre tablas
  -- ==========================
  procedure DDL_Table ( operacion  IN VARCHAR2
                 --   , esquema    IN VARCHAR2
                      , nombre     IN VARCHAR2
                      , parametros IN VARCHAR2  DEFAULT NULL)
  is

    V_OPERACION  VARCHAR2(100);
    V_ESQUEMA    VARCHAR2(100);
    V_NOMBRE     VARCHAR2(100);
    V_PARAMETROS VARCHAR2(4000);
    V_TIPO       VARCHAR2(100);
    V_EST_PERC   NUMBER(3);
    V_FC_STAT    CHAR(10);


  begin

    V_OPERACION := upper(operacion);
    V_NOMBRE := upper(nombre);
    V_PARAMETROS := upper(parametros);
    V_TIPO := 'TABLE';
    
    select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;

    if V_OPERACION = 'DROP' then
     If OPERACION_DDL.Existe_Objeto('TABLE', v_esquema, v_nombre)
      then OPERACION_DDL.ejecuta_str('BEGIN DROP_TEMP_TABLES ('''||V_ESQUEMA||''', '''||V_NOMBRE||'''); END;');
           --**Log
           execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;'
           using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
      else DBMS_OUTPUT.PUT_LINE(''|| V_OPERACION || ' TABLE ' || V_ESQUEMA || '.' || V_NOMBRE || ' ' || V_PARAMETROS||'');
           raise OBJECTNOTEXISTS;
     End if;
    end if;
    
    if V_OPERACION = 'TRUNCATE' then
      If OPERACION_DDL.Existe_Objeto('TABLE', v_esquema, v_nombre)
          Then --**Recovery
               --OPERACION_DDL.ejecuta_str(''|| V_OPERACION || ' TABLE ' || V_ESQUEMA || '.' || V_NOMBRE);
               --**Bankia
               OPERACION_DDL.ejecuta_str('BEGIN TRUNCATE_TABLE('''||V_ESQUEMA||''', '''||V_NOMBRE||'''); END;');
               --**Log
               execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;'
               using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
          Else DBMS_OUTPUT.PUT_LINE(''|| V_OPERACION || ' TABLE ' || V_ESQUEMA || '.' || V_NOMBRE || ' ' || V_PARAMETROS||'');
               raise OBJECTNOTEXISTS; 
        End If;
    end if;

    if V_OPERACION in ('CREATE') then
        If not OPERACION_DDL.Existe_Objeto('TABLE', v_esquema, v_nombre)
          Then --**Recovery
                --OPERACION_DDL.ejecuta_str(''|| V_OPERACION || ' TABLE ' || V_ESQUEMA || '.' || V_NOMBRE || ' (' || V_PARAMETROS || ')');
               --**Bankia
               OPERACION_DDL.ejecuta_str('BEGIN CREA_TEMP_TABLES('''||V_ESQUEMA||''', '''||V_NOMBRE ||' '||V_PARAMETROS||'''); END;');
               --**Log
               execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
               using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
          Else Raise OBJECTEXISTS;
        End If;
    end if;
    
    if V_OPERACION in ('ANALYZE','STATS') then
      
      select decode(trim(translate(V_PARAMETROS,'0123456789',' ')),null, to_number(nvl(V_PARAMETROS,'20')),null) 
      into V_EST_PERC from dual;
      DBMS_OUTPUT.PUT_LINE(V_EST_PERC);
      
      If OPERACION_DDL.Existe_Objeto('TABLE', v_esquema, v_nombre)
          --**Recovery 
           --Then SYS.DBMS_STATS.GATHER_TABLE_STATS (ownname => V_ESQUEMA, tabname => V_NOMBRE, estimate_percent => V_EST_PERC);
          --**Bankia
          Then --ESTADISTICAS(V_ESQUEMA, V_NOMBRE, V_EST_PERC, 'STATS');
               select nvl(to_char(last_analyzed,'DD/MM/YYYY'),'Null') into V_FC_STAT from all_tables where table_name = V_NOMBRE;
               DBMS_OUTPUT.PUT_LINE('Ultima toma de estadísticas: '||V_FC_STAT);
               OPERACION_DDL.ejecuta_str('BEGIN ESTADISTICAS('''||V_ESQUEMA||''', '''||V_NOMBRE||''', '||V_EST_PERC||', ''STATS''); END;');
               select nvl(to_char(last_analyzed,'DD/MM/YYYY'),'Null') into V_FC_STAT from all_tables where table_name = V_NOMBRE;
               DBMS_OUTPUT.PUT_LINE('Nueva toma de estadísticas: '||V_FC_STAT);
               --**LOG
               execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
               using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
          Else DBMS_OUTPUT.PUT_LINE(''|| V_OPERACION || ' TABLE ' || V_ESQUEMA || '.' || V_NOMBRE || '');
               raise OBJECTNOTEXISTS; 
        End If;
    end if;

  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := 'La tabla ya existe';
      raise;
    WHEN OBJECTNOTEXISTS then
      O_ERROR_STATUS := 'La tabla no existe';
      raise;
    WHEN INSERT_NULL then
      O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
      raise;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS := 'Parámetros obligatorios ausentes o no especificados';
      raise;
    WHEN OTHERS then
      O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
      raise;
  end DDL_Table;



  -- ==========================
  --  Operaciones sobre índices
  -- ==========================
  procedure DDL_Index ( operacion  IN VARCHAR2
                  --  , esquema    IN VARCHAR2
                      , nombre     IN VARCHAR2
                      , parametros IN VARCHAR2 DEFAULT NULL
                      , desactivar IN VARCHAR2 DEFAULT 'S'
                      , tipo_index IN VARCHAR2 DEFAULT NULL)
  is

    V_OPERACION VARCHAR2(100);
    V_ESQUEMA VARCHAR2(100);
    V_NOMBRE VARCHAR2(100);
    V_PARAMETROS VARCHAR2(250);
    V_DESACTIVAR VARCHAR2(1);
    V_TIPO_INDEX VARCHAR(30); --BITMAP, UNIQUE,...
    V_TIPO VARCHAR(100);


  begin

    V_OPERACION := upper(operacion);
    V_NOMBRE := upper(nombre);
    V_PARAMETROS := upper(parametros);
    V_DESACTIVAR := upper(desactivar);
    V_TIPO_INDEX := upper(tipo_index);
    V_TIPO := upper(tipo_index)||' INDEX';
    
    select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;

    if V_OPERACION = 'DROP' then
      If OPERACION_DDL.Existe_Objeto('INDEX', v_esquema, v_nombre)
       Then
          If V_DESACTIVAR = 'S'
           then --OPERACION_DDL.ejecuta_str('ALTER INDEX ' || v_esquema || '.' || v_nombre || ' UNUSABLE');
                OPERACION_DDL.ejecuta_str('BEGIN ALTER_INDEX('''||v_esquema||''', '''||v_nombre||''', ''UNUSABLE''); END;');
                --**LOG
                execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
                using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
           else --OPERACION_DDL.ejecuta_str('DROP INDEX ' || v_esquema || '.' || v_nombre||'');
                OPERACION_DDL.ejecuta_str('BEGIN CREA_DROP_INDEX('''||V_ESQUEMA||''', '''||V_NOMBRE||''', null, ''DROP''); END;');
                --**LOG
                execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
                using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
          End if;
       Else Raise OBJECTNOTEXISTS;
      End if;
    End If;

    If V_OPERACION = 'CREATE' then
     If V_DESACTIVAR = 'S'
       Then
          If OPERACION_DDL.Existe_Objeto('INDEX', v_esquema, v_nombre)
           Then --OPERACION_DDL.ejecuta_str('ALTER INDEX ' || v_esquema || '.' || v_nombre || ' REBUILD PARALLEL');
                OPERACION_DDL.ejecuta_str('BEGIN ALTER_INDEX('''||v_esquema||''', '''||v_nombre||''', ''REBUILD''); END;');
                --**LOG
                execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
                using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
           Else Raise OBJECTNOTEXISTS;
          End If;
       Else
          If not OPERACION_DDL.Existe_Objeto('INDEX', v_esquema, v_nombre)
             Then --OPERACION_DDL.ejecuta_str('CREATE '|| v_tipo_index ||' INDEX ' || v_esquema || '.' || v_nombre || ' on ' || v_esquema || '.' || v_parametros ||'');
                  OPERACION_DDL.ejecuta_str('BEGIN CREA_DROP_INDEX('''||v_esquema||''', '''||v_nombre||''', '''||v_parametros||''', ''CREA''); END;');
                  --**LOG
                  execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
                  using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
             Else Raise OBJECTEXISTS;
          End If;
     End If;
    End If;

  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := 'EL índice ya existe';
      raise;
    WHEN OBJECTNOTEXISTS then
      O_ERROR_STATUS := 'El índice no existe';
      raise;
    WHEN INSERT_NULL then
      O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
      raise;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS :='Parámetros obligatorios ausentes o no especificados';
      raise;
    WHEN OTHERS then
      O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
      raise;        
  end DDL_Index;




  -- =========================================
  --  Operaciones sobre vistas materializadas
  -- =========================================
  procedure DDL_Materialized_View ( --operacion     IN VARCHAR2 --BORRAR/CREAR
                                  --, esquema       IN VARCHAR2, --OWNER
                                  nombre        IN VARCHAR2 --NOMBRE
                                  --, consulta      IN VARCHAR2  DEFAULT NULL --SENTENCIA
                                  --, refresh_b     IN CHAR DEFAULT NULL
                                  --, primary_key_b IN CHAR DEFAULT NULL
                                  --, logging_b     IN CHAR DEFAULT NULL 
                                  )
  is

    v_operacion   VARCHAR2(10);
    v_esquema     VARCHAR2(30);
    v_nombre      VARCHAR2(30);
  --v_sentencia   VARCHAR2(32000);
  --v_refresh     VARCHAR2(25);
  --v_logging     VARCHAR2(10);
  --v_primary_key VARCHAR2(25);
    v_tipo        VARCHAR2(100);
    v_parametros  VARCHAR2(250);
    v_est_perc    NUMBER(3);
    v_fc_stat     CHAR(10);

    err_num NUMBER;
    err_msg VARCHAR2(255);

  begin

    --** Asignamos valor a las variables
    v_operacion  := 'REFRESH'; --v_operacion  := UPPER(operacion);
    v_nombre     := UPPER(nombre); 
    --v_sentencia  := consulta;
    v_tipo       := 'MATERIALIZED VIEW';
    
    select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;

/*  If primary_key_b = 'S' Then v_primary_key := 'WITH PRIMARY KEY';
     Elsif primary_key_b = 'N' Then v_primary_key :=  'WITH ROWID';
    End If;

    If refresh_b = 'S' Then v_refresh := 'REFRESH FORCE ON DEMAND';
     Elsif refresh_b = 'N' Then v_refresh := 'NEVER REFRESH' ; v_primary_key :=  null;
    End If;

    If logging_b = 'S' Then v_logging := 'LOGGING';
     Elsif logging_b = 'N' Then v_logging := 'NOLOGGING';
    End If;
    
    v_parametros := v_primary_key||' '||v_refresh||' '||v_logging;

    --** Ejecución
*/  If v_operacion is null Then raise PARAMETERS_NUMBER; End If;

/*  If v_operacion in ('DROP','BORRAR')
     Then
      If v_esquema is not null and v_nombre is not null
       Then
        If OPERACION_DDL.Existe_Objeto('MATERIALIZED VIEW', v_esquema, v_nombre)
          Then OPERACION_DDL.ejecuta_str('DROP MATERIALIZED VIEW '||v_esquema||'.'||v_nombre||'');
          Else raise OBJECTNOTEXISTS;
        End If;
       Else raise PARAMETERS_NUMBER;
      End If;
    Elsif v_operacion in ('CREATE','CREAR')
     Then
      If v_esquema is not null and v_nombre is not null and v_sentencia is not null
       Then
        If not OPERACION_DDL.Existe_Objeto('MATERIALIZED VIEW', v_esquema, v_nombre)
          Then OPERACION_DDL.ejecuta_str('CREATE MATERIALIZED VIEW '||v_esquema||'.'||v_nombre||' '
                                       ||  v_logging
                                       ||' BUILD IMMEDIATE '
                                       ||  v_refresh     ||' '
                                       ||  v_primary_key ||' '
                                       ||' AS '
                                       ||  v_sentencia   ||'');
          Else Raise OBJECTEXISTS;
        End If;
       Else raise PARAMETERS_NUMBER;
      End If;
     Else
*/   If v_operacion in ('REFRESH','REFRESCA','REFRESCAR')
        Then 
         If v_esquema is not null and v_nombre is not null
          Then 
           If OPERACION_DDL.Existe_Objeto('MATERIALIZED VIEW', v_esquema, v_nombre)
            Then select nvl(to_char(last_refresh_date,'DD/MM/YYYY'),'Null') into V_FC_STAT from ALL_MVIEWS where mview_name = V_NOMBRE;
                 DBMS_OUTPUT.PUT_LINE('Ultima fecha de refresco: '||V_FC_STAT);
                 --**Recovery
                  --OPERACION_DDL.ejecuta_str('BEGIN DBMS_MVIEW.REFRESH('''||v_nombre||''', ''C''); END;');
                 --**Bankia                  
                 OPERACION_DDL.ejecuta_str('BEGIN REFRESCAR_MVIEW('''||v_nombre||'''); END;');
                 select nvl(to_char(last_refresh_date,'DD/MM/YYYY'),'Null') into V_FC_STAT from ALL_MVIEWS where mview_name = V_NOMBRE;
                 DBMS_OUTPUT.PUT_LINE('Nueva fecha de refresco: '||V_FC_STAT);
                 --**LOG
                 execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
                 using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
            Else Raise OBJECTNOTEXISTS;
           End If;
          Else raise PARAMETERS_NUMBER;
         End If;
        Else  raise PARAMETERS_NUMBER;
       End If; 
       
      If v_operacion in ('ANALYZE','STATS','STATISTICS','ESTADISTICAS') then
      
      select decode(trim(translate(V_PARAMETROS,'0123456789',' ')),null, to_number(nvl(V_PARAMETROS,'20')),null) 
      into V_EST_PERC from dual;
      DBMS_OUTPUT.PUT_LINE(V_EST_PERC);
      
      If OPERACION_DDL.Existe_Objeto(v_tipo, v_esquema, v_nombre)
          Then select nvl(to_char(last_analyzed,'DD/MM/YYYY'),'Null') into V_FC_STAT from all_tables where table_name = V_NOMBRE;
               DBMS_OUTPUT.PUT_LINE('Ultima toma de estadísticas: '||V_FC_STAT);
               OPERACION_DDL.ejecuta_str('BEGIN ESTADISTICAS('''||V_ESQUEMA||''', '''||V_NOMBRE||''', '||V_EST_PERC||', ''STATS''); END;');
               select nvl(to_char(last_analyzed,'DD/MM/YYYY'),'Null') into V_FC_STAT from all_tables where table_name = V_NOMBRE;
               DBMS_OUTPUT.PUT_LINE('Nueva toma de estadísticas: '||V_FC_STAT);
               --**LOG
               execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;' 
               using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK';
          Else DBMS_OUTPUT.PUT_LINE(''|| V_OPERACION || ' MVIEW ' || V_ESQUEMA || '.' || V_NOMBRE || '');
               raise OBJECTNOTEXISTS; 
        End If;
    end if;
--   End If;

  EXCEPTION
      WHEN PARAMETERS_NUMBER then
        O_ERROR_STATUS := 'Parámetros obligatorios ausentes o no especificados';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(O_ERROR_STATUS||'. '||err_msg);
        raise;
      WHEN OBJECTNOTEXISTS then
        O_ERROR_STATUS := 'La vista no existe';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(O_ERROR_STATUS||'. '||err_msg);
        raise;
      WHEN OTHERS then
        O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(O_ERROR_STATUS||'. '||err_msg);
        raise;

  end DDL_Materialized_View;

end OPERACION_DDL;

create or replace package body OPERACION_DDL as
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Cabecera Paquete de Operaciones DDL
-- ===============================================================================================
/*
    execute immediate '    
          CREATE TABLE LOG_OPERACION_DLL
          ( FILA_ID Number not null,
            FECHA TIMESTAMP not null,
            NUM_SID number not null,
            TIPO VARCHAR2(100),
            OPERACION VARCHAR2(100),
            ESQUEMA VARCHAR2(100),
            OBJETO VARCHAR2(100),
            PARAMETROS VARCHAR2(254),
            ESTADO VARCHAR(254)
           )'; 
    commit;
    
    execute immediate '   
          CREATE SEQUENCE INCR_LOG_OPERACION_DLL
            MINVALUE 1
            INCREMENT BY 1 
            START WITH 1
            nomaxvalue';    
    commit;  
*/

  --** Procedimiento para insercion en log
  PROCEDURE  INSERTAR_LOG_OPERACION_DLL (TIPO IN VARCHAR2, OPERACION IN VARCHAR2, ESQUEMA IN VARCHAR2, OBJETO IN VARCHAR2, PARAMETROS IN VARCHAR2, ESTADO IN VARCHAR2, INICIO IN TIMESTAMP) AS
  
    V_SID NUMBER;    
    V_PARAMETROS varchar2(250);
    --V_ESQUEMA VARCHAR2(250);
    
  BEGIN
    --select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;
    select sys_context('USERENV','SID') INTO V_SID from dual;
    
    V_PARAMETROS := substr(PARAMETROS, 1, 250);
    
    insert into LOG_OPERACION_DLL (FILA_ID, FECHA_INICIO, FECHA_FIN, NUM_SID, TIPO, OPERACION, ESQUEMA, OBJETO, PARAMETROS, ESTADO)
    values (INCR_LOG_OPERACION_DLL.nextval, INICIO, systimestamp,  V_SID, substr(TIPO, 1, 100), substr(OPERACION, 1, 100), substr(ESQUEMA, 1, 100), substr(OBJETO, 1, 100), V_PARAMETROS, substr(ESTADO, 1, 250));
    --values (INCR_LOG_OPERACION_DLL.nextval, INICIO, systimestamp,  V_SID, substr(TIPO, 1, 100), substr(OPERACION, 1, 100), substr(ESQUEMA, 1, 100), substr(OBJETO, 1, 100), substr(PARAMETROS, 1, 250), substr(ESTADO, 1, 250));
    commit;   
  END;


  --** Funcion para validar la existencia del objeto
  function existe_objeto (tipo IN VARCHAR2, esquema IN VARCHAR2, nombre IN VARCHAR2)
  return boolean
  is
    v_count   integer;
    v_tipo    varchar2(30);
    v_esquema varchar2(2500);
    v_nombre  varchar2(30);
    retorno boolean;
  begin

    v_tipo    := trim(UPPER(tipo));
    v_nombre  := trim(UPPER(nombre));
    v_esquema  := trim(UPPER(esquema));

    select sys_context('USERENV','CURRENT_USER') into v_esquema from dual;
    
    Select nvl(count(*),0) into v_count
      From all_objects
     Where owner = v_esquema
       And object_name = v_nombre
       And object_type = v_tipo;

    If v_count > 0
     Then retorno := TRUE;
          --DBMS_OUTPUT.PUT_LINE('Existe');
     Else retorno := FALSE;
          --DBMS_OUTPUT.PUT_LINE('No existe');
    End if;

    Return retorno;
  end existe_objeto;



  --** Función que ejecuta la operación
  procedure ejecuta_str (sentencia IN varchar2)
  is
    cur     PLS_INTEGER;
    fdbk    PLS_INTEGER;
  begin
    --DBMS_OUTPUT.PUT_LINE(sentencia);
    cur := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE (cur, sentencia, DBMS_SQL.NATIVE);
    fdbk := DBMS_SQL.EXECUTE (cur);
    Commit;
    DBMS_SQL.CLOSE_CURSOR (cur);
  end ejecuta_str;



  -- ==========================
  --  Operaciones sobre tablas
  -- ==========================
  procedure DDL_Table ( operacion  IN VARCHAR2
                      , nombre     IN VARCHAR2
                      , parametros IN VARCHAR2  DEFAULT NULL
                      , O_ERROR_STATUS OUT VARCHAR2)
  is

    V_OPERACION VARCHAR2(100);
    V_ESQUEMA VARCHAR2(100);
    V_NOMBRE VARCHAR2(100);
    V_PARAMETROS VARCHAR2(16000);
    V_TIPO VARCHAR2(50);
    V_FECHA TIMESTAMP := systimestamp;
    
  begin    
    V_TIPO := 'TABLE';
    V_OPERACION := upper(operacion);    
    V_NOMBRE := upper(nombre);
    V_PARAMETROS := upper(parametros);

    
    select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;

    if V_OPERACION in ('DROP', 'TRUNCATE', 'ALTER', 'ANALYZE', 'ALTER_CONSTRAINT') then
      If OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE)  Then 
          OPERACION_DDL.ejecuta_str(''|| V_OPERACION || ' ' || V_TIPO || ' ' || V_ESQUEMA || '.' || V_NOMBRE || ' ' || V_PARAMETROS||'');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
      Else 
        raise OBJECTNOTEXISTS;
      End If;
    end if;


    if V_OPERACION in ('CREATE') then
        If not OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE) Then 
          OPERACION_DDL.ejecuta_str(''|| V_OPERACION || ' ' || V_TIPO || ' ' || V_ESQUEMA || '.' || V_NOMBRE || ' (' || V_PARAMETROS || ')');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
        Else 
          Raise OBJECTEXISTS;
        End If;
    end if;

    if V_OPERACION in ('CREATE_AS') then
        If not OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE) Then 
          OPERACION_DDL.ejecuta_str('CREATE '|| V_TIPO || ' ' || V_ESQUEMA || '.' || V_NOMBRE || ' ' || V_PARAMETROS || '');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
        Else 
          Raise OBJECTEXISTS;
        End If;
    end if;

  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := 'La tabla ya existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OBJECTNOTEXISTS then      
      O_ERROR_STATUS := 'La tabla no existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN INSERT_NULL then
      O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS := 'Número de parámetros incorrecto';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OTHERS then
      O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || SQLERRM;      
      --ROLLBACK;
  end DDL_Table;


  -- ==========================
  --  Operaciones sobre Procedures
  -- ==========================
  procedure DDL_Procedure ( operacion  IN VARCHAR2
                      , nombre     IN VARCHAR2
                      , parametros IN VARCHAR2  DEFAULT NULL
                      , O_ERROR_STATUS OUT VARCHAR2)
  is

    V_OPERACION VARCHAR2(100);
    V_ESQUEMA VARCHAR2(100);
    V_NOMBRE VARCHAR2(100);
    V_PARAMETROS VARCHAR2(16000);
    V_TIPO VARCHAR2(50);
    V_FECHA TIMESTAMP := systimestamp;
    
  begin    
    V_TIPO := 'PROCEDURE';
    V_OPERACION := upper(operacion);    
    V_NOMBRE := upper(nombre);
    V_PARAMETROS := upper(parametros);

    select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;
    
    if V_OPERACION in ('ALTER') then
      If OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE)  Then 
          OPERACION_DDL.ejecuta_str(''|| V_OPERACION || ' ' || V_TIPO || ' ' || V_ESQUEMA || '.' || V_NOMBRE || ' ' || V_PARAMETROS||'');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
      Else 
        raise OBJECTNOTEXISTS;
      End If;
    end if;

  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := 'El procedure ya existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OBJECTNOTEXISTS then      
      O_ERROR_STATUS := 'El procedure no existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS := 'Número de parámetros incorrecto';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OTHERS then
      O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || SQLERRM;      
      --ROLLBACK;
  end DDL_Procedure;



  -- ==========================
  --  Operaciones sobre índices
  -- ==========================
  procedure DDL_Index ( operacion  IN VARCHAR2
                      , nombre     IN VARCHAR2
                      , parametros IN VARCHAR2 DEFAULT NULL
                      , desactivar IN VARCHAR2 DEFAULT 'S'
                      , tipo_index IN VARCHAR2 DEFAULT NULL                      
                      , O_ERROR_STATUS OUT VARCHAR2)
  is

    V_OPERACION VARCHAR2(100);
    V_ESQUEMA VARCHAR2(100);
    V_NOMBRE VARCHAR2(100);
    V_PARAMETROS VARCHAR2(16000);
    V_DESACTIVAR VARCHAR2(1);
    V_TIPO_INDEX VARCHAR(30); --BITMAP, UNIQUE,...
    V_TIPO VARCHAR2(50);
    V_FECHA TIMESTAMP := systimestamp;
    
  begin  
    V_TIPO := 'INDEX';
    V_OPERACION := upper(operacion);
    V_NOMBRE := upper(nombre);
    V_PARAMETROS := upper(parametros);
    V_DESACTIVAR := upper(nvl(desactivar, 'S'));
    V_TIPO_INDEX := upper(tipo_index);

    select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;  
    
    if V_OPERACION = 'DROP' then
      If OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE) Then
          If V_DESACTIVAR = 'S' then 
            OPERACION_DDL.ejecuta_str('ALTER INDEX ' || V_ESQUEMA || '.' || V_NOMBRE || ' UNUSABLE');
            execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
          else 
            OPERACION_DDL.ejecuta_str('DROP INDEX ' || V_ESQUEMA || '.' || V_NOMBRE||'');
            execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
          End if;
      End if;
      --Si no existe no tratamos la excepción... se continúa
    End If;

    If V_OPERACION = 'CREATE' then
      If not OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE) Then
          OPERACION_DDL.ejecuta_str('CREATE '|| V_TIPO_INDEX ||' INDEX ' || V_ESQUEMA || '.' || V_NOMBRE || ' on ' || V_ESQUEMA || '.' || V_PARAMETROS ||'');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
      Else 
          If V_DESACTIVAR = 'S' then 
            OPERACION_DDL.ejecuta_str('ALTER INDEX ' || V_ESQUEMA || '.' || V_NOMBRE || ' REBUILD PARALLEL 2');
            execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
          else 
            Raise OBJECTEXISTS;          
          End if;    
      End if;
    End if;    

    If V_OPERACION = 'CREATE_AS' then
      If not OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE) Then
          OPERACION_DDL.ejecuta_str('CREATE INDEX ' || V_PARAMETROS ||'');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
      End if;
    End if;    


  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := 'EL índice ya existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OBJECTNOTEXISTS then
      O_ERROR_STATUS := 'El índice no existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;            
      --ROLLBACK;
    WHEN INSERT_NULL then
      O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS := 'Número de parámetros incorrecto';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OTHERS then
      O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || SQLERRM, V_FECHA;      
      --ROLLBACK;
  end DDL_Index;



  -- =============================
  --  Operaciones sobre secuencias
  -- =============================
  procedure DDL_SEQUENCE ( operacion  IN VARCHAR2                         
                       , nombre     IN VARCHAR2
                       , minvalue   IN NUMBER
                       , increment  IN NUMBER
                       , start_with IN NUMBER
                       , parametros IN VARCHAR2 DEFAULT NULL
                       , O_ERROR_STATUS OUT VARCHAR2)
  is

    V_OPERACION VARCHAR2(100);
    V_ESQUEMA VARCHAR2(100);
    V_NOMBRE VARCHAR2(100);
    V_MINVALUE NUMBER;
    V_INCREMENT NUMBER;
    V_START_WITH NUMBER;
    V_PARAMETROS VARCHAR2(16000);
    V_TIPO VARCHAR2(50);
    V_FECHA TIMESTAMP := systimestamp;
    
  begin    
    V_TIPO := 'SEQUENCE';
    V_OPERACION := upper(operacion);    
    V_NOMBRE := upper(nombre);
    V_MINVALUE := nvl(minvalue, 1);
    V_INCREMENT := nvl(increment, 1);
    V_START_WITH := nvl(start_with, 1);    
    V_PARAMETROS := upper(parametros);
    
    select sys_context('USERENV','CURRENT_USER') into V_ESQUEMA from dual;

    if V_OPERACION in ('DROP') then
      If OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE)  Then 
          OPERACION_DDL.ejecuta_str(''|| V_OPERACION || ' ' || V_TIPO || ' ' || V_ESQUEMA || '.' || V_NOMBRE || ' ' || V_PARAMETROS||'');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
      Else 
        raise OBJECTNOTEXISTS;
      End If;
    end if;


    if V_OPERACION in ('CREATE') then
        If not OPERACION_DDL.Existe_Objeto(V_TIPO, V_ESQUEMA, V_NOMBRE) Then 
          OPERACION_DDL.ejecuta_str(''|| V_OPERACION || ' ' || V_TIPO || ' ' || V_ESQUEMA || '.' || V_NOMBRE || ' MINVALUE ' || TO_CHAR(V_MINVALUE) || ' INCREMENT BY ' || TO_CHAR(V_INCREMENT) || ' START WITH ' || TO_CHAR(V_START_WITH) || ' ' || V_PARAMETROS || '');
          execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'OK', V_FECHA;      
        Else 
          Raise OBJECTEXISTS;
        End If;
    end if;

  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := 'La tabla ya existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OBJECTNOTEXISTS then      
      O_ERROR_STATUS := 'La tabla no existe';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN INSERT_NULL then
      O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS := 'Número de parámetros incorrecto';
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || O_ERROR_STATUS, V_FECHA;      
      --ROLLBACK;
    WHEN OTHERS then
      O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
      execute immediate 'BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO, :INICIO); END;' USING IN V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, 'ERROR: ' || SQLERRM;      
      --ROLLBACK;
  end DDL_SEQUENCE;



  -- =========================================
  --  Operaciones sobre vistas materializadas
  -- =========================================
  procedure DDL_Materialized_View ( operacion     IN VARCHAR2 --BORRAR/CREAR
                                  , nombre        IN VARCHAR2 --NOMBRE
                                  , consulta      IN VARCHAR2  DEFAULT NULL --SENTENCIA
                                  , refresh_b     IN CHAR DEFAULT NULL
                                  , primary_key_b IN CHAR DEFAULT NULL
                                  , logging_b     IN CHAR DEFAULT NULL 
                                  , O_ERROR_STATUS OUT VARCHAR2
                                  )
  is

    v_operacion   VARCHAR2(10);
    v_nombre      VARCHAR2(30);
    v_esquema     VARCHAR(250);
    v_sentencia   VARCHAR2(32000);
    v_refresh     VARCHAR2(25);
    v_logging     VARCHAR2(10);
    v_primary_key VARCHAR2(25);

    err_num NUMBER;
    err_msg VARCHAR2(255);

  begin

    v_operacion  := UPPER(operacion);
    v_nombre     := UPPER(nombre);
    v_sentencia  := consulta;

    select sys_context('USERENV','CURRENT_USER') into v_esquema from dual;  
    
    If primary_key_b = 'S' Then v_primary_key := 'WITH PRIMARY KEY';
     Elsif primary_key_b = 'N' Then v_primary_key :=  'WITH ROWID';
    End If;

    If refresh_b = 'S' Then v_refresh := 'REFRESH FORCE ON DEMAND';
     Elsif refresh_b = 'N' Then v_refresh := 'NEVER REFRESH' ; v_primary_key :=  null;
    End If;

    If logging_b = 'S' Then v_logging := 'LOGGING';
     Elsif logging_b = 'N' Then v_logging := 'NOLOGGING';
    End If;

    If v_operacion is null Then raise PARAMETERS_NUMBER; End If;

    If v_operacion in ('DROP','BORRAR')
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
     End If;

  EXCEPTION
      WHEN PARAMETERS_NUMBER then
        O_ERROR_STATUS := 'Faltan parámetros obligatorios por especificar';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        --DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        --DBMS_OUTPUT.put_line(O_ERROR_STATUS||'. '||err_msg);
        raise;
        --ROLLBACK;
      WHEN OBJECTEXISTS then
        O_ERROR_STATUS := 'La vista ya existe';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        --DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        --DBMS_OUTPUT.put_line(O_ERROR_STATUS||'. '||err_msg);
        raise;
        --ROLLBACK;
      WHEN OBJECTNOTEXISTS then
        O_ERROR_STATUS := 'La vista no existe';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        --DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        --DBMS_OUTPUT.put_line(O_ERROR_STATUS||'. '||err_msg);
        raise;
        --ROLLBACK;
      WHEN OTHERS then
        O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
        err_num := SQLCODE;
        err_msg := SQLERRM;
        --DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        --DBMS_OUTPUT.put_line(O_ERROR_STATUS);
        raise;
        --ROLLBACK;

  end DDL_Materialized_View;

end OPERACION_DDL;

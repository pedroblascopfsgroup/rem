--/*   
--##########################################
--## AUTOR=Jose Manuel Pérez Barberá
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2458
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

    DBMS_OUTPUT.PUT_LINE('******** OPERACION_DDL ********'); 

    
    V_MSQL := 'create or replace PACKAGE '||V_ESQUEMA_M||'.OPERACION_DDL AS 
    
  --** Declaramos Variables, Constantes, Excepciones
    OBJECTEXISTS      EXCEPTION;
    OBJECTNOTEXISTS   EXCEPTION;
    INSERT_NULL       EXCEPTION;
    PARAMETERS_NUMBER EXCEPTION;

    PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
    PRAGMA EXCEPTION_INIT(OBJECTNOTEXISTS, -942);
    PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
    PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

    O_ERROR_STATUS VARCHAR2(1000);

  --** Declaramos funciones y procedimientos

    -- Comprueba si existe un objeto
    function existe_objeto (tipo IN VARCHAR2, esquema IN VARCHAR2, nombre IN VARCHAR2) return boolean;

    -- Ejecuta Sentencia Dinámica
    procedure ejecuta_str (sentencia IN VARCHAR2);
    
    -- Procedimiento para insercion en log
    procedure  insertar_log_operacion_dll ( tipo IN VARCHAR2
                                          , operacion IN VARCHAR2
                                          , ESQUEMA IN VARCHAR2
                                          , OBJETO IN VARCHAR2
                                          , PARAMETROS IN VARCHAR2
                                          , ESTADO IN VARCHAR2);

    -- Operativa sobre tablas
    procedure DDL_Table ( operacion  IN VARCHAR2
                        , nombre     IN VARCHAR2
                        , parametros IN VARCHAR2 DEFAULT NULL);

    -- Operativa sobre índices
    procedure  DDL_Index ( operacion  IN VARCHAR2
                         , nombre     IN VARCHAR2
                         , parametros IN VARCHAR2 DEFAULT NULL
                         , desactivar IN VARCHAR2 DEFAULT ''S''
                         , tipo_index IN VARCHAR2 DEFAULT NULL);

    -- Operativa sobre vistas materializadas
    procedure DDL_Materialized_View  ( operacion     IN VARCHAR2 --BORRAR/CREAR
                                     , nombre        IN VARCHAR2 --NOMBRE
                                     , consulta      IN VARCHAR2 DEFAULT NULL --SENTENCIA
                                     , refresh_b     IN CHAR DEFAULT NULL --opcional
                                     , primary_key_b IN CHAR DEFAULT NULL --opcional
                                     , logging_b     IN CHAR DEFAULT NULL --opcional
                                     );

end OPERACION_DDL;


-----------------------------------------------------------';

--DBMS_OUTPUT.PUT_LINE(V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] PACKAGE CREADO');


V_MSQL := 'create or replace package body '||V_ESQUEMA_M||'.OPERACION_DDL as

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
          DBMS_OUTPUT.PUT_LINE(''Existe'');
     Else retorno := FALSE;
          DBMS_OUTPUT.PUT_LINE(''No existe'');
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

    select sys_context(''USERENV'',''SID'') INTO V_SID from dual;
    --select sys_context(''USERENV'',''CURRENT_USER'') into V_ESQUEMA from dual;

    /*
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

                */
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
    V_TIPO := ''TABLE'';

    select sys_context(''USERENV'',''CURRENT_USER'') into V_ESQUEMA from dual;

    if V_OPERACION not in (''DROP'',''CREATE'',''TRUNCATE'',''ANALYZE'',''STATS'')
     Then Raise PARAMETERS_NUMBER;
    End if;

    if V_OPERACION = ''DROP'' then
     If OPERACION_DDL.Existe_Objeto(''TABLE'', v_esquema, v_nombre)
      then OPERACION_DDL.ejecuta_str(''''|| V_OPERACION || '' TABLE '' || V_ESQUEMA || ''.'' || V_NOMBRE);
           --**Log
           execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
           using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
      else DBMS_OUTPUT.PUT_LINE(''''|| V_OPERACION || '' TABLE '' || V_ESQUEMA || ''.'' || V_NOMBRE || '' '' || V_PARAMETROS||'''');
           raise OBJECTNOTEXISTS;
     End if;
    end if;

    if V_OPERACION = ''TRUNCATE'' then
      If OPERACION_DDL.Existe_Objeto(''TABLE'', v_esquema, v_nombre)
          Then OPERACION_DDL.ejecuta_str(''''|| V_OPERACION || '' TABLE '' || V_ESQUEMA || ''.'' || V_NOMBRE);
               --**Log
               execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
               using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
          Else DBMS_OUTPUT.PUT_LINE(''''|| V_OPERACION || '' TABLE '' || V_ESQUEMA || ''.'' || V_NOMBRE || '' '' || V_PARAMETROS||'''');
               raise OBJECTNOTEXISTS;
        End If;
    end if;

    if V_OPERACION in (''CREATE'') then
        If not OPERACION_DDL.Existe_Objeto(''TABLE'', v_esquema, v_nombre)
          Then OPERACION_DDL.ejecuta_str(''''|| V_OPERACION || '' TABLE '' || V_ESQUEMA || ''.'' || V_NOMBRE || '' ('' || V_PARAMETROS || '')'');
               --**Log
               execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
               using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
          Else Raise OBJECTEXISTS;
        End If;
    end if;

    if V_OPERACION in (''ANALYZE'',''STATS'') then

      select decode(trim(translate(V_PARAMETROS,''0123456789'','' '')),null, to_number(nvl(V_PARAMETROS,''20'')),null)
      into V_EST_PERC from dual;
      DBMS_OUTPUT.PUT_LINE(V_EST_PERC);

      If OPERACION_DDL.Existe_Objeto(''TABLE'', v_esquema, v_nombre)
          Then
               select nvl(to_char(last_analyzed,''DD/MM/YYYY''),''Null'') into V_FC_STAT from all_tables where table_name = V_NOMBRE;
               DBMS_OUTPUT.PUT_LINE(''Ultima toma de estadísticas: ''||V_FC_STAT);

               SYS.DBMS_STATS.GATHER_TABLE_STATS (ownname => V_ESQUEMA, tabname => V_NOMBRE, estimate_percent => V_EST_PERC);

               select nvl(to_char(last_analyzed,''DD/MM/YYYY''),''Null'') into V_FC_STAT from all_tables where table_name = V_NOMBRE;
               DBMS_OUTPUT.PUT_LINE(''Nueva toma de estadísticas: ''||V_FC_STAT);
               --**LOG
               execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
               using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
          Else DBMS_OUTPUT.PUT_LINE(''''|| V_OPERACION || '' TABLE '' || V_ESQUEMA || ''.'' || V_NOMBRE || '''');
               raise OBJECTNOTEXISTS;
        End If;
    end if;

  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := ''La tabla ya existe'';
      raise;
    WHEN OBJECTNOTEXISTS then
      O_ERROR_STATUS := ''La tabla no existe'';
      raise;
    WHEN INSERT_NULL then
      O_ERROR_STATUS := ''Has intentado insertar un valor nulo'';
      raise;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS := ''Parámetros obligatorios ausentes o no especificados'';
      raise;
    WHEN OTHERS then
      O_ERROR_STATUS := ''Se ha producido un error en el proceso: ''||SQLCODE||'' -> ''||SQLERRM;
      raise;
  end DDL_Table;



  -- ==========================
  --  Operaciones sobre índices
  -- ==========================
  procedure DDL_Index ( operacion  IN VARCHAR2
                    --  , esquema    IN VARCHAR2
                      , nombre     IN VARCHAR2
                      , parametros IN VARCHAR2 DEFAULT NULL
                      , desactivar IN VARCHAR2 DEFAULT ''S''
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
    V_TIPO := upper(tipo_index)||'' INDEX'';

    select sys_context(''USERENV'',''CURRENT_USER'') into V_ESQUEMA from dual;

    if V_OPERACION not in (''DROP'',''CREATE'')
     Then Raise PARAMETERS_NUMBER;
    End if;

    if V_OPERACION = ''DROP'' then
      If OPERACION_DDL.Existe_Objeto(''INDEX'', v_esquema, v_nombre)
       Then
          If V_DESACTIVAR = ''S''
           then OPERACION_DDL.ejecuta_str(''ALTER INDEX '' || v_esquema || ''.'' || v_nombre || '' UNUSABLE'');
                --**LOG
                execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
                using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
           else OPERACION_DDL.ejecuta_str(''DROP INDEX '' || v_esquema || ''.'' || v_nombre||'''');
                --**LOG
                execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
                using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
          End if;
       Else Raise OBJECTNOTEXISTS;
      End if;
    End If;

    If V_OPERACION = ''CREATE'' then
     If V_DESACTIVAR = ''S''
       Then
          If OPERACION_DDL.Existe_Objeto(''INDEX'', v_esquema, v_nombre)
           Then OPERACION_DDL.ejecuta_str(''ALTER INDEX '' || v_esquema || ''.'' || v_nombre || '' REBUILD PARALLEL'');
                --**LOG
                execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
                using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
           Else Raise OBJECTNOTEXISTS;
          End If;
       Else
          If not OPERACION_DDL.Existe_Objeto(''INDEX'', v_esquema, v_nombre)
             Then OPERACION_DDL.ejecuta_str(''CREATE ''|| v_tipo_index ||'' INDEX '' || v_esquema || ''.'' || v_nombre || '' on '' || v_esquema || ''.'' || v_parametros ||'''');
                  --**LOG
                  execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
                  using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
             Else Raise OBJECTEXISTS;
          End If;
     End If;
    End If;

  EXCEPTION
    WHEN OBJECTEXISTS then
      O_ERROR_STATUS := ''EL índice ya existe'';
      raise;
    WHEN OBJECTNOTEXISTS then
      O_ERROR_STATUS := ''El índice no existe'';
      raise;
    WHEN INSERT_NULL then
      O_ERROR_STATUS := ''Has intentado insertar un valor nulo'';
      raise;
    WHEN PARAMETERS_NUMBER then
      O_ERROR_STATUS :=''Parámetros obligatorios ausentes o no especificados'';
      raise;
    WHEN OTHERS then
      O_ERROR_STATUS := ''Se ha producido un error en el proceso: ''||SQLCODE||'' -> ''||SQLERRM;
      raise;
  end DDL_Index;




  -- =========================================
  --  Operaciones sobre vistas materializadas
  -- =========================================
  procedure DDL_Materialized_View ( operacion     IN VARCHAR2 --BORRAR/CREAR
                       --         , esquema       IN VARCHAR2 --OWNER
                                  , nombre        IN VARCHAR2 --NOMBRE
                                  , consulta      IN VARCHAR2  DEFAULT NULL --SENTENCIA
                                  , refresh_b     IN CHAR DEFAULT NULL
                                  , primary_key_b IN CHAR DEFAULT NULL
                                  , logging_b     IN CHAR DEFAULT NULL )
  is

    v_operacion   VARCHAR2(10);
    v_esquema     VARCHAR2(30);
    v_nombre      VARCHAR2(30);
    v_sentencia   VARCHAR2(32000);
    v_refresh     VARCHAR2(25);
    v_logging     VARCHAR2(10);
    v_primary_key VARCHAR2(25);
    v_tipo        VARCHAR2(100);
    v_parametros  VARCHAR2(250);

    err_num NUMBER;
    err_msg VARCHAR2(255);

  begin

    --** Asignamos valor a las variables
    v_operacion  := UPPER(operacion);
    v_nombre     := UPPER(nombre);
    v_sentencia  := consulta;
    v_tipo       := ''MATERIALIZED VIEW'';

    select sys_context(''USERENV'',''CURRENT_USER'') into V_ESQUEMA from dual;

    If primary_key_b = ''S'' Then v_primary_key := ''WITH PRIMARY KEY'';
     Elsif primary_key_b = ''N'' Then v_primary_key :=  ''WITH ROWID'';
    End If;

    If refresh_b = ''S'' Then v_refresh := ''REFRESH FORCE ON DEMAND'';
     Elsif refresh_b = ''N'' Then v_refresh := ''NEVER REFRESH'' ; v_primary_key :=  null;
    End If;

    If logging_b = ''S'' Then v_logging := ''LOGGING'';
     Elsif logging_b = ''N'' Then v_logging := ''NOLOGGING'';
    End If;

    v_parametros := v_primary_key||'' ''||v_refresh||'' ''||v_logging;

    --** Ejecución
    If v_operacion is null Then raise PARAMETERS_NUMBER; End If;

    If v_operacion in (''DROP'',''BORRAR'')
     Then
      If v_esquema is not null and v_nombre is not null
       Then
        If OPERACION_DDL.Existe_Objeto(''MATERIALIZED VIEW'', v_esquema, v_nombre)
          Then OPERACION_DDL.ejecuta_str(''DROP MATERIALIZED VIEW ''||v_esquema||''.''||v_nombre||'''');
          Else raise OBJECTNOTEXISTS;
        End If;
       Else raise PARAMETERS_NUMBER;
      End If;
    Elsif v_operacion in (''CREATE'',''CREAR'')
     Then
      If v_esquema is not null and v_nombre is not null and v_sentencia is not null
       Then
        If not OPERACION_DDL.Existe_Objeto(''MATERIALIZED VIEW'', v_esquema, v_nombre)
          Then OPERACION_DDL.ejecuta_str(''CREATE MATERIALIZED VIEW ''||v_esquema||''.''||v_nombre||'' ''
                                       ||  v_logging
                                       ||'' BUILD IMMEDIATE ''
                                       ||  v_refresh     ||'' ''
                                       ||  v_primary_key ||'' ''
                                       ||'' AS ''
                                       ||  v_sentencia   ||'''');
          Else Raise OBJECTEXISTS;
        End If;
       Else raise PARAMETERS_NUMBER;
      End If;
     Else
     If v_operacion in (''REFRESH'',''REFRESCA'',''REFRESCAR'')
        Then
         If v_esquema is not null and v_nombre is not null
          Then
           If OPERACION_DDL.Existe_Objeto(''MATERIALIZED VIEW'', v_esquema, v_nombre)
            Then DBMS_OUTPUT.PUT_LINE(''BEGIN DBMS_MVIEW.REFRESH(''''||v_nombre||'''', ''''C''''); END;'');
                 --OPERACION_DDL.ejecuta_str(''BEGIN DBMS_MVIEW.REFRESH(''''||v_nombre||'''', ''''C''''); END;'');
                 Execute Immediate ''BEGIN DBMS_MVIEW.REFRESH(''''||v_nombre||'''', ''''C''''); END;'';
                 --**LOG
                 execute immediate ''BEGIN OPERACION_DDL.INSERTAR_LOG_OPERACION_DLL(:TIPO, :OPERACION, :ESQUEMA, :OBJETO, :PARAMETROS, :ESTADO); END;''
                 using in V_TIPO, V_OPERACION, V_ESQUEMA, V_NOMBRE, V_PARAMETROS, ''OK'';
            Else Raise OBJECTNOTEXISTS;
           End If;
          Else raise PARAMETERS_NUMBER;
         End If;
        Else  raise PARAMETERS_NUMBER;
       End If;
     End If;

  EXCEPTION
      WHEN PARAMETERS_NUMBER then
        O_ERROR_STATUS := ''Parámetros obligatorios ausentes o no especificados'';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line(''Error:''||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(O_ERROR_STATUS||''. ''||err_msg);
        raise;
      WHEN OBJECTEXISTS then
        O_ERROR_STATUS := ''La vista ya existe'';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line(''Error:''||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(O_ERROR_STATUS||''. ''||err_msg);
        raise;
      WHEN OBJECTNOTEXISTS then
        O_ERROR_STATUS := ''La vista no existe'';
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line(''Error:''||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(O_ERROR_STATUS||''. ''||err_msg);
        raise;
      WHEN OTHERS then
        O_ERROR_STATUS := ''Se ha producido un error en el proceso: ''||SQLCODE||'' -> ''||SQLERRM;
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line(''Error:''||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(O_ERROR_STATUS||''. ''||err_msg);
        raise;

  end DDL_Materialized_View;

end OPERACION_DDL;';

--DBMS_OUTPUT.PUT_LINE (V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] PACKAGE BODY CREADO');

DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;

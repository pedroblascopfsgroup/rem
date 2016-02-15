create or replace PROCEDURE CREAR_LOG (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Enero 2015
-- Responsable ultima modificacion:María Villanueva, PFS Group
-- Fecha ultima modificacion:01/12/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI Producto
--
-- Descripcion: Procedimiento almancenado que crea las tablas relacionadas con los LOG's
-- ===============================================================================================


BEGIN
  declare
    nCount NUMBER;
    V_SQL VARCHAR2(16000);


  BEGIN
    --------------------------
    ---LOG_GENERAL_PARAMETROS
    --------------------------
    --truncate TABLE LOG_GENERAL_PARAMETROS;
    --select * from LOG_GENERAL_PARAMETROS order by orden;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''DROP'', ''LOG_GENERAL_PARAMETROS'', '''', :error); END;';



    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''LOG_GENERAL_PARAMETROS'', ''NOMBRE_PROCESO VARCHAR2(250),




            PARAMETROS  VARCHAR2(250),
            PARAMETRO_DATE_INI VARCHAR2(50),
            PARAMETRO_DATE_FIN VARCHAR2(50),
            PARAMETRO_ON_ERROR VARCHAR2(50),
            NUM_OTROS_PARAMETROS NUMBER,
            OTROS_PARAMETROS VARCHAR2(250),
            ACTIVO VARCHAR2(1),
            ORDEN NUMBER'', :error); END;';
    execute immediate V_SQL USING OUT error;







    --------------------------
    ---LOG_GENERAL
    --------------------------
    --truncate TABLE LOG_GENERAL;
    --select * from LOG_GENERAL order by num_bloque, fecha_carga;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''DROP'', ''LOG_GENERAL'', '''', :error); END;';



    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''LOG_GENERAL'', ''FECHA_CARGA DATE not null,




            FECHA_INICIO TIMESTAMP not null,
            FECHA_FIN TIMESTAMP,
            NOMBRE_PROCESO VARCHAR2(250),
            ESTADO VARCHAR2(20),
            TIEMPO_MEDIO_CARGA_DIA NUMBER,
            NUM_BLOQUE  NUMBER'', :error); END;';
    execute immediate V_SQL USING OUT error;






    --------------------------
    ---LOG_PROCESO
    --------------------------
    --truncate table LOG_PROCESO;
    --select * from LOG_PROCESO where fecha >= TO_DATE('28/01/2015') order by 1;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''DROP'', ''LOG_PROCESO'', '''', :error); END;';



    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''LOG_PROCESO'', ''FILA_ID Number not null,




            FECHA TIMESTAMP not null,
            NUM_SID number not null,
            NOMBRE_PROCESO varchar2(50),
            DESCRIPCION varchar(250),
            TAB integer'', :error); END;';
    execute immediate V_SQL USING OUT error;





    --Secuencia para LOG_PROCESO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_SEQUENCE(''DROP'', ''INCR_LOG_PROCESO'', 0, 0, 0, '''', :error); END;';


    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_SEQUENCE(''CREATE'', ''INCR_LOG_PROCESO'', 1, 1, 1, ''nomaxvalue'', :error); END;';
    execute immediate V_SQL USING OUT error;












  End;
END;

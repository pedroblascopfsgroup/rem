create or replace package OPERACION_DDL as
------------------------------------------------------------------------------------------------------
-- OPERACION DDL v.0.7
-- 23/09/2015
-- Luis Ruiz Carlavilla
--
-- Descripción:
-- Paquete PLSQL que actúa como capa intermedia para la ejecución de operaciones DDL restringidas
-- para los usuarios transaccionales en el área operacional de Recovery.
-- Versión adaptada a entornos Bankia.
--
-- Uso:
-- 1.- Truncado de tablas:
-- 2.- Creación de tablas temporales:
-- 3.- Borrado de tablas temporales:
-- 4.- Activación y desactivación de índices:
-- 5.- Creación y borrado de índices:
-- 6.- Refresco de vistas materializadas:
------------------------------------------------------------------------------------------------------

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

    -- Operativa sobre tablas (GTT)
    procedure DDL_Table ( operacion  IN VARCHAR2
                        , nombre     IN VARCHAR2
                        , parametros IN VARCHAR2 DEFAULT NULL);

    -- Operativa sobre índices
    procedure  DDL_Index ( operacion  IN VARCHAR2
                         , nombre     IN VARCHAR2
                         , parametros IN VARCHAR2 DEFAULT NULL
                         , desactivar IN VARCHAR2 DEFAULT 'S'
                         , tipo_index IN VARCHAR2 DEFAULT NULL);

    -- Operativa sobre vistas materializadas
    procedure DDL_Materialized_View ( --operacion     IN VARCHAR2 --BORRAR/CREAR
                                  --, esquema       IN VARCHAR2, --OWNER
                                      nombre        IN VARCHAR2 --NOMBRE
                                  --, consulta      IN VARCHAR2  DEFAULT NULL --SENTENCIA
                                  --, refresh_b     IN CHAR DEFAULT NULL
                                  --, primary_key_b IN CHAR DEFAULT NULL
                                  --, logging_b     IN CHAR DEFAULT NULL 
                                    );

end OPERACION_DDL;

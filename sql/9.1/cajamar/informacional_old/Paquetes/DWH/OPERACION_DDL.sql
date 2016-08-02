create or replace package OPERACION_DDL as
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion:María Villanueva Mares
-- Fecha ?ltima modificaci?n: 03/11/2015
-- Motivos del cambio: Paso a Haya
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Cuerpo Paquete de Operaciones DDL
-- ===============================================================================================
  --** Declaramos Variables, Constantes, Excepciones
    OBJECTEXISTS      EXCEPTION;
    OBJECTNOTEXISTS   EXCEPTION;
    INSERT_NULL       EXCEPTION;
    PARAMETERS_NUMBER EXCEPTION;

    PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
    PRAGMA EXCEPTION_INIT(OBJECTNOTEXISTS, -942);
    PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
    PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

    O_ERROR_STATUS VARCHAR2(1000); --lrc

  --** Declaramos funciones y procedimientos
  
    -- Insertar en Log
    PROCEDURE  INSERTAR_LOG_OPERACION_DLL (TIPO IN VARCHAR2, OPERACION IN VARCHAR2, ESQUEMA IN VARCHAR2, OBJETO IN VARCHAR2, PARAMETROS IN VARCHAR2, ESTADO IN VARCHAR2, INICIO IN TIMESTAMP);
    
    -- Comprueba si existe un objeto
    function existe_objeto (tipo IN VARCHAR2, esquema IN VARCHAR2, nombre IN VARCHAR2) return boolean;

    -- Ejecuta Sentencia Dinámica
    procedure ejecuta_str (sentencia IN VARCHAR2);

    -- Operativa sobre tablas
    procedure DDL_Table ( operacion  IN VARCHAR2                       
                        , nombre     IN VARCHAR2
                        , parametros IN VARCHAR2 DEFAULT NULL
                        , O_ERROR_STATUS OUT VARCHAR2);

    -- Operativa sobre índices
    procedure  DDL_Index ( operacion  IN VARCHAR2                         
                         , nombre     IN VARCHAR2
                         , parametros IN VARCHAR2 DEFAULT NULL
                         , desactivar IN VARCHAR2 DEFAULT 'S'
                         , tipo_index IN VARCHAR2 DEFAULT NULL
                         , O_ERROR_STATUS OUT VARCHAR2);

    -- Operativa sobre procedures
    procedure  DDL_Procedure ( operacion  IN VARCHAR2                         
                         , nombre     IN VARCHAR2
                         , parametros IN VARCHAR2 DEFAULT NULL
                         , O_ERROR_STATUS OUT VARCHAR2);

    -- Operativa sobre secuencias
    procedure DDL_SEQUENCE ( operacion  IN VARCHAR2                         
                         , nombre     IN VARCHAR2
                         , minvalue   IN NUMBER
                         , increment  IN NUMBER
                         , start_with IN NUMBER
                         , parametros IN VARCHAR2 DEFAULT NULL
                         , O_ERROR_STATUS OUT VARCHAR2); 

    -- Operativa sobre vistas materializadas
    procedure DDL_Materialized_View  ( operacion     IN VARCHAR2 --BORRAR/CREAR
                                     , nombre        IN VARCHAR2 --NOMBRE
                                     , consulta      IN VARCHAR2 DEFAULT NULL --SENTENCIA
                                     , refresh_b     IN CHAR DEFAULT NULL --opcional
                                     , primary_key_b IN CHAR DEFAULT NULL --opcional
                                     , logging_b     IN CHAR DEFAULT NULL --opcional
                                     , O_ERROR_STATUS OUT VARCHAR2
                                     );
                                     

end OPERACION_DDL;
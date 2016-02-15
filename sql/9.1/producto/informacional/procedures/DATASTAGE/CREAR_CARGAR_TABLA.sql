create or replace PROCEDURE CREAR_CARGAR_TABLA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Abril 2015
-- Responsable ultima modificacion:Maria Villanueva, PFS Group
-- Fecha ultima modificacion: 23/11/2015
-- Motivos del cambio:Usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que crea las tablas relacionadas con CARGAR_TABLA
-- ===============================================================================================


BEGIN
  declare
    nCount NUMBER;
	V_SQL VARCHAR2(16000);
  
  BEGIN  
    --------------------------
    ---CARGAR_TABLAS_PARAMETROS
    --------------------------      





    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''CARGAR_TABLA_PARAMETROS'', 
		  ''NOMBRE_TABLA_DESTINO VARCHAR2(100),
            TIPO_CARGA NUMBER, --1: TRUNCATE-INSERT-SELECT (POR DEFECTO), 2: DROP-CREATE-SELECT            
            COLUMNAS VARCHAR2(4000),            
            CLAUSULA_SELECT VARCHAR2(4000),
            CLAUSULA_FROM VARCHAR2(4000),
            CLAUSULA_WHERE VARCHAR2(4000),
            
            INDICE1 VARCHAR2(4000), 
            INDICE2 VARCHAR2(4000),
            INDICE3 VARCHAR2(4000),
            INDICE4 VARCHAR2(4000),
            
            CLAUSULA_CREATE VARCHAR2(4000),
                        
            ACTIVO VARCHAR2(1), --S/N
            BLOQUE NUMBER,
            ORDEN NUMBER'', :error); END;';
   execute immediate V_SQL USING OUT error;


   
    commit;
      
    --------------------------
    ---LOG_CARGAR_TABLA_GENERAL
    --------------------------  





     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''LOG_CARGAR_TABLA_GENERAL'', 
		  ''FECHA_CARGA DATE not null,
            FECHA_INICIO TIMESTAMP not null,
            FECHA_FIN TIMESTAMP,
            NOMBRE_TABLA VARCHAR2(250),
            ESTADO VARCHAR2(20),
            TIEMPO_CARGA_DIA NUMBER,
            NUM_BLOQUE  NUMBER,
            NUM_ORDEN NUMBER'', :error); END;';
   execute immediate V_SQL USING OUT error;


    
    commit;
  
    --------------------------
    ---LOG_CARGAR_TABLA
    --------------------------  
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''LOG_CARGAR_TABLA'', 






		  ''FILA_ID Number not null,
            FECHA TIMESTAMP not null,
            NUM_SID number not null,
            NUM_BLOQUE  NUMBER,
            NUM_ORDEN NUMBER,            
            NOMBRE_TABLA varchar2(50),
            DESCRIPCION varchar(250),
            TAB integer'', :error); END;';
   execute immediate V_SQL USING OUT error;


    commit;
    
    --Secuencia para LOG_CARGAR_TABLA
    select count(*) into nCount from ALL_SEQUENCES where sequence_name = 'INCR_LOG_CARGAR_TABLA';
    
    if(nCount > 0) then execute immediate 'DROP SEQUENCE INCR_LOG_CARGAR_TABLA'; end if;
    
    execute immediate '   
          CREATE SEQUENCE INCR_LOG_CARGAR_TABLA
            MINVALUE 1
            INCREMENT BY 1 
            START WITH 1
            nomaxvalue';    
    commit;  
  
    
  End;  
END;

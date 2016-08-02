create or replace PROCEDURE CREAR_CARGAR_TABLA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Abril 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio: 
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que crea las tablas relacionadas con CARGAR_TABLA
-- ===============================================================================================


BEGIN
  declare
    nCount NUMBER;
  
  BEGIN  
    --------------------------
    ---CARGAR_TABLAS_PARAMETROS
    --------------------------      
    select count(*) into nCount from all_tables where table_name = 'CARGAR_TABLA_PARAMETROS';
    
    if(nCount > 0) then execute immediate 'drop table CARGAR_TABLA_PARAMETROS'; end if;
      
    execute immediate '      
          CREATE TABLE CARGAR_TABLA_PARAMETROS (
            NOMBRE_TABLA_DESTINO VARCHAR2(100),
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
            ORDEN NUMBER
          )';
   
    commit;
      
    --------------------------
    ---LOG_CARGAR_TABLA_GENERAL
    --------------------------  
    select count(*) into nCount from all_tables where table_name = 'LOG_CARGAR_TABLA_GENERAL';
    
    if(nCount > 0) then execute immediate 'drop table LOG_CARGAR_TABLA_GENERAL'; end if;
      
    execute immediate '    
          CREATE TABLE LOG_CARGAR_TABLA_GENERAL
          ( FECHA_CARGA DATE not null,
            FECHA_INICIO TIMESTAMP not null,
            FECHA_FIN TIMESTAMP,
            NOMBRE_TABLA VARCHAR2(250),
            ESTADO VARCHAR2(20),
            TIEMPO_CARGA_DIA NUMBER,
            NUM_BLOQUE  NUMBER,
            NUM_ORDEN NUMBER
           )';
    
    commit;
  
    --------------------------
    ---LOG_CARGAR_TABLA
    --------------------------  
    select count(*) into nCount from all_tables where table_name = 'LOG_CARGAR_TABLA';
    
    if(nCount > 0) then execute immediate 'drop table LOG_CARGAR_TABLA'; end if;
      
    execute immediate '    
          CREATE TABLE LOG_CARGAR_TABLA
          ( FILA_ID Number not null,
            FECHA TIMESTAMP not null,
            NUM_SID number not null,
            NUM_BLOQUE  NUMBER,
            NUM_ORDEN NUMBER,            
            NOMBRE_TABLA varchar2(50),
            DESCRIPCION varchar(250),
            TAB integer
           )'; 
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
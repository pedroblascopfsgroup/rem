create or replace PROCEDURE CREAR_DIM_ACTUACION_RECOBRO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 04/02/2015
-- Motivos del cambio: LOG's
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Actuacion Recobro
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION ACTUACION RECOBRO
    -- D_ACT_REC_MODELO
    -- D_ACT_REC_PROVEEDOR
    -- D_ACT_REC_TIPO
    -- D_ACT_REC_RESULTADO

begin
  declare
  nCount NUMBER;
  v_sql LONG;
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_ACTUACION_RECOBRO';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
    ------------------------------ D_ACT_REC_MODELO ------------------------------
    select count(*) into nCount from user_tables where table_name = 'D_ACT_REC_MODELO';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE D_ACT_REC_MODELO(
                            MODELO_ACT_REC_ID NUMBER(16,0) NOT NULL,
                            MODELO_ACT_REC_ALT VARCHAR2(50 CHAR),
                            MODELO_ACT_REC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (MODELO_ACT_REC_ID))';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_ACT_REC_MODELO');
    end if;

    ------------------------------ D_ACT_REC_PROVEEDOR ------------------------------
    select count(*) into nCount from user_tables where table_name = 'D_ACT_REC_PROVEEDOR';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE D_ACT_REC_PROVEEDOR(
                            PROVEEDOR_ACT_REC_ID NUMBER(16,0) NOT NULL,
                            PROVEEDOR_ACT_REC_DESC VARCHAR2(50 CHAR),
                            PROVEEDOR_ACT_REC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROVEEDOR_ACT_REC_ID))';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_ACT_REC_PROVEEDOR');
    end if;

    ------------------------------ D_ACT_REC_TIPO ------------------------------
    select count(*) into nCount from user_tables where table_name = 'D_ACT_REC_TIPO';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE D_ACT_REC_TIPO(
                            TIPO_ACT_REC_ID NUMBER(16,0) NOT NULL,
                            TIPO_ACT_REC_DESC VARCHAR2(50 CHAR),
                            TIPO_ACT_REC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_ACT_REC_ID))';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_ACT_REC_TIPO');
    end if;

    ------------------------------ D_ACT_REC_RESULTADO ------------------------------
    select count(*) into nCount from user_tables where table_name = 'D_ACT_REC_RESULTADO';
    if(nCount <= 0) then
      execute immediate 'CREATE TABLE D_ACT_REC_RESULTADO(
                            RESULTADO_ACT_REC_ID NUMBER(16,0) NOT NULL,
                            RESULTADO_ACT_REC_DESC VARCHAR2(50 CHAR),
                            RESULTADO_ACT_REC_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (RESULTADO_ACT_REC_ID))';
      DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_ACT_REC_RESULTADO');
    end if;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    
  end;

END CREAR_DIM_ACTUACION_RECOBRO;
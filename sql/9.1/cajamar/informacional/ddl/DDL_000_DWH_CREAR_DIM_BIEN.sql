--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160330
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2314
--## PRODUCTO=NO
--## 
--## Finalidad: GARANTIA_NUM_OPE_BIE
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE CREAR_DIM_BIEN (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Rafael Aracil, PFS Group
-- Fecha creacion: Agosto 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 22/03/2016
-- Motivos del cambio: GARANTIA_NUM_OPE_BIE
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension SUBASTA.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION BIEN
    -- D_BIE
    -- D_BIE_TIPO_BIEN
    -- D_BIE_SUBTIPO_BIEN
    -- D_BIE_POBLACION
    -- D_BIE_ADJUDICADO
    -- D_BIE_ADJ_CESION_REM
    -- D_BIE_CODIGO_ACTIVO
    -- D_BIE_ENTIDAD_ADJUDICATARIA
    -- D_BIE_FASE_ACTUAL_DETALLE
    -- D_BIE_DESC_LANZAMIENTOS
    -- D_BIE_PRIMER_TITULAR
    -- D_BIE_NUM_OPERACION
    -- D_BIE_ZONA
    -- D_BIE_OFICINA
    -- D_BIE_ENTIDAD
	-- D_BIE_GARANTIA_NUM_OPE_BIE_AGR
	-- D_BIE_GARANTIA_NUM_OPE_BIE
    

BEGIN
  declare
  nCount NUMBER;
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_BIEN';
  
  begin
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
    
	

    ------------------------------ D_BIE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE'',
						  ''BIE_ID NUMBER(16,0) NOT NULL ENABLE,
                            BIE_DESC VARCHAR2(50 CHAR),
                            BIE_DESC_2 VARCHAR2(250 CHAR),
                            BIE_DESC_3 VARCHAR2(50 CHAR),
                            PRIMARY KEY (BIE_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_TIPO_BIEN--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_TIPO_BIEN'',
						  ''TIPO_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            TIPO_BIEN_DESC VARCHAR2(50 CHAR),
                            TIPO_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_SUBTIPO_BIEN --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_SUBTIPO_BIEN'',
                          ''SUBTIPO_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            SUBTIPO_BIEN_DESC VARCHAR2(50 CHAR),
                            SUBTIPO_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (SUBTIPO_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_POBLACION  --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_POBLACION'',
                          ''POBLACION_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            POBLACION_BIEN_DESC VARCHAR2(50 CHAR),
                            POBLACION_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (POBLACION_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_ADJUDICADO --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ADJUDICADO'',
                          ''BIEN_ADJUDICADO_ID NUMBER(16,0) NOT NULL ENABLE,
                            BIEN_ADJUDICADO_DESC VARCHAR2(50 CHAR),
                            BIEN_ADJUDICADO_DESC_2 VARCHAR2(250 CHAR),
                             PRIMARY KEY (BIEN_ADJUDICADO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_BIE_ADJ_CESION_REM --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ADJ_CESION_REM'',
						  ''ADJ_CESION_REM_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            ADJ_CESION_REM_BIEN_DESC VARCHAR2(50 CHAR),
                            ADJ_CESION_REM_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ADJ_CESION_REM_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_BIE_CODIGO_ACTIVO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_CODIGO_ACTIVO'',
                          ''CODIGO_ACTIVO_BIEN_ID NUMBER(16,0) NOT NULL ENABLE,
                            CODIGO_ACTIVO_BIEN_DESC VARCHAR2(50 CHAR),
                            CODIGO_ACTIVO_BIEN_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (CODIGO_ACTIVO_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_BIE_ENTIDAD_ADJUDICATARIA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ENTIDAD_ADJUDICATARIA'',
                          ''ENTIDAD_ADJUDICATARIA_ID NUMBER(16,0) NOT NULL ENABLE ,
                            ENTIDAD_ADJUDICATARIA_DESC VARCHAR2(50 CHAR),
                            ENTIDAD_ADJUDICATARIA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (ENTIDAD_ADJUDICATARIA_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ----------------------------- D_BIE_FASE_ACTUAL_DETALLE --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_FASE_ACTUAL_DETALLE'',
                         '' BIE_FASE_ACTUAL_DETALLE_ID NUMBER(16,0) NOT NULL,
                            BIE_FASE_ACTUAL_DETALLE_DESC VARCHAR2(100 CHAR),
                            BIE_FASE_ACTUAL_DETALLE_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (BIE_FASE_ACTUAL_DETALLE_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ----------------------------- D_BIE_DESC_LANZAMIENTOS --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_DESC_LANZAMIENTOS'',
                         '' DESC_LANZAMIENTO_ID NUMBER(16,0) NOT NULL,
                            DESC_LANZAMIENTO_DESC VARCHAR2(50 CHAR),
                            DESC_LANZAMIENTO_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (DESC_LANZAMIENTO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ----------------------------- D_BIE_PRIMER_TITULAR --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_PRIMER_TITULAR'',
                         '' PRIMER_TITULAR_BIE_ID   NUMBER(16,0) NOT NULL ,
                            PRIMER_TITULAR_BIE_DOCUMENT_ID  VARCHAR2(20),
                            PRIMER_TITULAR_BIE_NOMBRE  VARCHAR2(100 CHAR),
                            PRIMER_TITULAR_BIE_APELLIDO_1  VARCHAR2(100 CHAR),
                            PRIMER_TITULAR_BIE_APELLIDO_2  VARCHAR2(100 CHAR),
                        PRIMARY KEY (PRIMER_TITULAR_BIE_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ----------------------------- D_BIE_NUM_OPERACION --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_NUM_OPERACION'',
                         '' NUM_OPERACION_BIEN_ID NUMBER(16,0) NOT NULL,
                            NUM_OPERACION_BIEN_DESC VARCHAR2(50 CHAR),
                            NUM_OPERACION_BIEN_DESC_2 VARCHAR2(250 CHAR),
							GARANTIA_NUM_OPE_BIE_ID NUMBER(16,0),
                        PRIMARY KEY (NUM_OPERACION_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ----------------------------- D_BIE_ZONA --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ZONA'',
                         '' ZONA_BIEN_ID NUMBER(16,0) NOT NULL,
                            ZONA_BIEN_DESC VARCHAR2(50 CHAR),
                            ZONA_BIEN_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (ZONA_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;
    
   ----------------------------- D_BIE_OFICINA --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_OFICINA'',
                         '' OFICINA_BIEN_ID NUMBER(16,0) NOT NULL,
                            OFICINA_BIEN_DESC VARCHAR2(50 CHAR),
                            OFICINA_BIEN_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (OFICINA_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

   ----------------------------- D_BIE_ENTIDAD --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_ENTIDAD'',
                         '' ENTIDAD_BIEN_ID NUMBER(16,0) NOT NULL,
                            ENTIDAD_BIEN_DESC VARCHAR2(50 CHAR),
                            ENTIDAD_BIEN_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (ENTIDAD_BIEN_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

	------------------------------ D_BIE_GARANTIA_NUM_OPE_BIE_AGR -------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_GARANTIA_NUM_OPE_BIE_AGR'', 
						  ''GARANTIA_NUM_OPE_BIE_AGR_ID NUMBER(16,0) NOT NULL,
                            GARANTIA_NUM_OPE_BIE_AGR_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (GARANTIA_NUM_OPE_BIE_AGR_ID)'', :error); END;'; 		 
    execute immediate V_SQL USING OUT error;
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_BIE_GARANTIA_NUM_OPE_BIE_AGR');
	  
	  
    ------------------------------ D_BIE_GARANTIA_NUM_OPE_BIE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_BIE_GARANTIA_NUM_OPE_BIE'', 
						  ''GARANTIA_NUM_OPE_BIE_ID NUMBER(16,0) NOT NULL,
                            GARANTIA_NUM_OPE_BIE_DESC VARCHAR2(50 CHAR),
                            GARANTIA_NUM_OPE_BIE_DESC_2 VARCHAR2(250 CHAR),
                            GARANTIA_NUM_OPE_BIE_AGR_ID NUMBER(16,0),
                            PRIMARY KEY (GARANTIA_NUM_OPE_BIE_ID)'', :error); END;'; 		 
    execute immediate V_SQL USING OUT error;
    DBMS_OUTPUT.PUT_LINE('---- Creacion tabla D_BIE_GARANTIA_NUM_OPE_BIE');
   
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    

  end;

END CREAR_DIM_BIEN;
/
EXIT



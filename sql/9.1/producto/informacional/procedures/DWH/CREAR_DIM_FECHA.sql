create or replace PROCEDURE CREAR_DIM_FECHA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 14/04/2016
-- Motivos del cambio: Parametrización índices con esquema indices
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Fecha.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION FECHA
    -- D_F_ANIO
    -- D_F_DIA_SEMANA
    -- D_F_MES
    -- D_F_MES_ANIO
    -- D_F_TRIMESTRE
    -- D_F_DIA
    -- D_F_SEMANA
    -- D_F_SEMANA_ANIO
    -- D_F_MTD
    -- D_F_QTD
    -- D_F_YTD
    -- D_F_F_ULT_6_MESES
    -- D_F_F_ULT_12_MESES

BEGIN

  declare
  nCount NUMBER;
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_FECHA';
  
  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  
    
    ------------------------------ D_F_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANIO'',
						  ''ANIO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_ANIO_PK'', ''D_F_ANIO (ANIO_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DIA_SEMANA'',
						  ''DIA_SEMANA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_DIA_SEMANA_PK'', ''D_F_DIA_SEMANA (DIA_SEMANA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MES'',
						  ''MES_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ID INTEGER,
                            TRIMESTRE_ID INTEGER,
                            ANIO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_CIERRE_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_MES_PK'', ''D_F_MES (MES_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MES_ANIO'',
						  ''MES_ANIO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_MES_ANIO_PK'', ''D_F_MES_ANIO (MES_ANIO_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_TRIMESTRE'',
						  ''TRIMESTRE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_TRIMESTRE_PK'', ''D_F_TRIMESTRE (TRIMESTRE_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DIA'',
						  ''DIA_ID DATE NOT NULL,
                            DIA_SEMANA_ID INTEGER,
                            SEMANA_ID INTEGER,
                            MES_ID INTEGER,
                            TRIMESTRE_ID INTEGER,
                            ANIO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_DIA_PK'', ''D_F_DIA (DIA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SEMANA'',
						  ''SEMANA_ID INTEGER NOT NULL,
                            SEMANA_FECHA DATE,
                            SEMANA_DESC VARCHAR2(45),
                            SEMANA_DESC_ALT VARCHAR2(45),
                            SEMANA_ANIO_ID INTEGER,
                            SEMANA_DURACION INTEGER,
                            MES_ID INTEGER,
                            ANIO_ID INTEGER,
                            SEMANA_ANT_ID INTEGER,
                            SEMANA_DESC_EN VARCHAR2(45),
                            SEMANA_DESC_DE VARCHAR2(45),
                            SEMANA_DESC_FR VARCHAR2(45),
                            SEMANA_DESC_IT VARCHAR2(45)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_SEMANA_PK'', ''D_F_SEMANA (SEMANA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_SEMANA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SEMANA_ANIO'',
						  ''SEMANA_ANIO_ID INTEGER NOT NULL,
                            SEMANA_ANIO_DESC VARCHAR2(45),
                            SEMANA_ANIO_DESC_EN VARCHAR2(45),
                            SEMANA_ANIO_DESC_DE VARCHAR2(45),
                            SEMANA_ANIO_DESC_FR VARCHAR2(45),
                            SEMANA_ANIO_DESC_IT VARCHAR2(45)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_SEMANA_ANIO_PK'', ''D_F_SEMANA_ANIO (SEMANA_ANIO_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_MTD ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MTD'',
						  ''DIA_ID DATE NOT NULL,
                            MTD_DIA DATE'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_MTD_PK'', ''D_F_MTD (DIA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_QTD ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_QTD'',
						  ''DIA_ID DATE NOT NULL,
                            QTD_DIA DATE'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_QTD_PK'', ''D_F_QTD (DIA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_YTD ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_YTD'',
						  ''DIA_ID DATE NOT NULL,
                            YTD_DIA DATE'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 	V_SQL := 'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_YTD_PK'', ''D_F_YTD (DIA_ID)'', ''S'', ''UNIQUE'', :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_ULT_6_MESES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_6_MESES'',
						  ''MES_ID INTEGER NOT NULL,
                            ULT_6_MESES_ID INTEGER'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_ULT_6_MESES_IX'', ''D_F_ULT_6_MESES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
	execute immediate V_SQL USING OUT error;
     

    ------------------------------ D_F_ULT_12_MESES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_12_MESES'',
						  ''MES_ID INTEGER NOT NULL,
                            ULT_12_MESES_ID INTEGER'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_F_ULT_12_MESES_IX'', ''D_F_ULT_12_MESES (MES_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
	execute immediate V_SQL USING OUT error;
      
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


  end;

END CREAR_DIM_FECHA;
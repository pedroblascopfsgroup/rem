create or replace PROCEDURE CREAR_DIM_ASUNTO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 05/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension Asunto.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION ASUNTO
    -- D_ASU_DESPACHO
    -- D_ASU_DESPACHO_GESTOR
    -- D_ASU_ENTIDAD_GESTOR
    -- D_ASU_ESTADO
    -- D_ASU_GESTOR
    -- D_ASU_NVL_DESPACHO
    -- D_ASU_NVL_DESPACHO_GESTOR
    -- D_ASU_OFI_DESPACHO
    -- D_ASU_OFI_DESPACHO_GESTOR
    -- D_ASU_PROV_DESPACHO
    -- D_ASU_PROV_DESPACHO_GESTOR
    -- D_ASU_TIPO_DESPACHO
    -- D_ASU_TIPO_DESPACHO_GESTOR
    -- D_ASU_ROL_GESTOR
    -- D_ASU_ZONA_DESPACHO
    -- D_ASU_ZONA_DESPACHO_GESTOR
    -- D_ASU_PROPIETARIO_ASUNTO
    -- D_ASU
    -- TMP_DESPACHO_ASUNTO

BEGIN
  declare
  nCount NUMBER;
  -- v_sql LONG;
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_ASUNTO';
  V_SQL varchar2(16000);
  
  begin
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
	
    
    ------------------------------ D_ASU_ESTADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_ESTADO'', 



                      ''ESTADO_ASUNTO_ID NUMBER(16,0) NOT NULL,
                        ESTADO_ASUNTO_DESC VARCHAR2(50 CHAR),
                        ESTADO_ASUNTO_DESC_2 VARCHAR2(250 CHAR),
                      PRIMARY KEY (ESTADO_ASUNTO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_ASU_DESPACHO--------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_DESPACHO'', 



                      ''DESPACHO_ID NUMBER(16,0) NOT NULL,
                        DESPACHO_DESC VARCHAR2(250 CHAR),
                        TIPO_DESPACHO_ID NUMBER(16,0),
                        ZONA_DESPACHO_ID NUMBER(16,0),
                      PRIMARY KEY (DESPACHO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_ASU_TIPO_DESPACHO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_TIPO_DESPACHO'', 



                  ''TIPO_DESPACHO_ID NUMBER(16,0) NOT NULL,
                    TIPO_DESPACHO_DESC VARCHAR2(50 CHAR),
                    TIPO_DESPACHO_DESC_2 VARCHAR2(250 CHAR),
                  PRIMARY KEY (TIPO_DESPACHO_ID)'', 
                  :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_ASU_DESPACHO_GESTOR  --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_DESPACHO_GESTOR'', 



                  ''DESPACHO_GESTOR_ID NUMBER(16,0) NOT NULL,
                    DESPACHO_GESTOR_DESC VARCHAR2(250 CHAR),
                    TIPO_DESPACHO_GESTOR_ID NUMBER(16,0),
                    ZONA_DESPACHO_GESTOR_ID NUMBER(16,0),
                  PRIMARY KEY (DESPACHO_GESTOR_ID)'', 
                  :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_ASU_TIPO_DESPACHO_GESTOR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_TIPO_DESPACHO_GESTOR'', 
                            ''TIPO_DESPACHO_GESTOR_ID NUMBER(16,0) NOT NULL,
                              TIPO_DESPACHO_GESTOR_DESC VARCHAR2(50 CHAR),
                              TIPO_DESPACHO_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_DESPACHO_GESTOR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_ASU_GESTOR --------------------------
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_GESTOR'', 



                            ''GESTOR_ID NUMBER(16,0) NOT NULL,
                              GESTOR_NOMBRE VARCHAR2(250 CHAR),
                              GESTOR_APELLIDO1 VARCHAR2(250 CHAR),
                              GESTOR_APELLIDO2 VARCHAR2(250 CHAR),
                              ENTIDAD_GESTOR_ID NUMBER(16,0),
                              DESPACHO_GESTOR_ID NUMBER(16,0),
                            PRIMARY KEY (GESTOR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_ASU_ENTIDAD_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_ENTIDAD_GESTOR'', 



                            ''ENTIDAD_GESTOR_ID NUMBER(16,0) NOT NULL,
                              ENTIDAD_GESTOR_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (ENTIDAD_GESTOR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
	
    ------------------------------ D_ASU_ROL_GESTOR --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_ROL_GESTOR'', 
                            ''ROL_GESTOR_ID NUMBER(16,0) NOT NULL,
                              ROL_GESTOR_DESC VARCHAR2(50 CHAR),
                              ROL_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                              PRIMARY KEY (ROL_GESTOR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_ASU_NVL_DESPACHO --------------------------
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_NVL_DESPACHO'', 



                            ''NIVEL_DESPACHO_ID NUMBER(16,0) NOT NULL,
                              NIVEL_DESPACHO_DESC VARCHAR2(50 CHAR),
                              NIVEL_DESPACHO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NIVEL_DESPACHO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_ASU_OFI_DESPACHO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_OFI_DESPACHO'', 



                            ''OFICINA_DESPACHO_ID NUMBER(16,0) NOT NULL,
                              OFICINA_DESPACHO_DESC VARCHAR2(50 CHAR),
                              OFICINA_DESPACHO_DESC_2 VARCHAR2(250 CHAR),
                              PROVINCIA_DESPACHO_ID NUMBER(16,0),
                            PRIMARY KEY (OFICINA_DESPACHO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
	
    ------------------------------ D_ASU_PROV_DESPACHO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_PROV_DESPACHO'', 



                            ''PROVINCIA_DESPACHO_ID NUMBER(16,0) NOT NULL,
                              PROVINCIA_DESPACHO_DESC VARCHAR2(50 CHAR),
                              PROVINCIA_DESPACHO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROVINCIA_DESPACHO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

	
    ------------------------------ D_ASU_ZONA_DESPACHO --------------------------
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_ZONA_DESPACHO'', 



                            ''ZONA_DESPACHO_ID NUMBER(16,0) NOT NULL,
                              ZONA_DESPACHO_DESC VARCHAR2(50 CHAR),
                              ZONA_DESPACHO_DESC_2 VARCHAR2(250 CHAR),
                              NIVEL_DESPACHO_ID NUMBER(16,0),
                              OFICINA_DESPACHO_ID NUMBER(16,0),
                            PRIMARY KEY (ZONA_DESPACHO_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	

    ------------------------------ D_ASU_NVL_DESPACHO_GESTOR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_NVL_DESPACHO_GESTOR'', 
                          ''NIVEL_DESPACHO_GESTOR_ID NUMBER(16,0) NOT NULL,
                            NIVEL_DESPACHO_GESTOR_DESC VARCHAR2(50 CHAR),
                            NIVEL_DESPACHO_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                          PRIMARY KEY (NIVEL_DESPACHO_GESTOR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
	
	
    ------------------------------ D_ASU_OFI_DESPACHO_GESTOR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_OFI_DESPACHO_GESTOR'', 
                            ''OFICINA_DESPACHO_GESTOR_ID NUMBER(16,0) NOT NULL,
                              OFICINA_DESPACHO_GESTOR_DESC VARCHAR2(50 CHAR),
                              OFICINA_DESPACHO_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                              PROV_DESPACHO_GESTOR_ID NUMBER(16,0),
                            PRIMARY KEY (OFICINA_DESPACHO_GESTOR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
	

    ------------------------------ D_ASU_PROV_DESPACHO_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_PROV_DESPACHO_GESTOR'', 
                                ''PROV_DESPACHO_GESTOR_ID NUMBER(16,0) NOT NULL,
                                  PROV_DESPACHO_GESTOR_DESC VARCHAR2(50 CHAR),
                                  PROV_DESPACHO_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                                PRIMARY KEY (PROV_DESPACHO_GESTOR_ID)'', 
                                :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
	

    ------------------------------ D_ASU_ZONA_DESPACHO_GESTOR --------------------------
  

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_ZONA_DESPACHO_GESTOR'', 
                        ''ZONA_DESPACHO_GESTOR_ID NUMBER(16,0) NOT NULL,
                          ZONA_DESPACHO_GESTOR_DESC VARCHAR2(50 CHAR),
                          ZONA_DESPACHO_GESTOR_DESC_2 VARCHAR2(250 CHAR),
                          NIVEL_DESPACHO_GESTOR_ID NUMBER(16,0),
                          OFICINA_DESPACHO_GESTOR_ID NUMBER(16,0),
                        PRIMARY KEY (ZONA_DESPACHO_GESTOR_ID)'', 
                        :error); END;';
    execute immediate V_SQL USING OUT error;

	
	
    ------------------------------ D_ASU_PROPIETARIO_ASUNTO --------------------------
    

	V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU_PROPIETARIO_ASUNTO'', 
                          ''PROPIETARIO_ASUNTO_ID NUMBER(16,0) NOT NULL,
                              PROPIETARIO_ASUNTO_DESC VARCHAR2(50 CHAR),
                              PROPIETARIO_ASUNTO_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROPIETARIO_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_ASU --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_ASU'', 



                      ''ASUNTO_ID NUMBER(16,0) NOT NULL,
                          NOMBRE_ASUNTO VARCHAR2(310 CHAR),
                          ESTADO_ASUNTO_ID NUMBER(16,0),
                          EXPEDIENTE_ID NUMBER(16,0),
                          DESPACHO_ID NUMBER(16,0),
                          PROPIETARIO_ASUNTO_ID NUMBER(16,0),
                         
                        PRIMARY KEY (ASUNTO_ID)'', 
                      :error); END;';
    execute immediate V_SQL USING OUT error;

	
    ------------------------------ TMP_DESPACHO_ASUNTO --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_DESPACHO_ASUNTO'', 



              ''ASUNTO_ID NUMBER(16,0),
              DESPACHO_ID NUMBER(16,0) NOT NULL'', 
              :error); END;';
    execute immediate V_SQL USING OUT error;    


    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_DESPACHO_ASUNTO_IX'', ''TMP_DESPACHO_ASUNTO (ASUNTO_ID, DESPACHO_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;  

  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
    

  end;

END CREAR_DIM_ASUNTO;
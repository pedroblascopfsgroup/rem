create or replace PROCEDURE CREAR_DIM_TAREA (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva., PFS Group
-- Fecha ultima modificacion: 06/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Tarea
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION TAREA
    -- D_TAR_TIPO
    -- D_TAR_TIPO_DETALLE
    -- D_TAR_RESOLUCION_PRORROGA
    -- D_TAR_MOTIVO_PRORROGA
    -- D_TAR_PENDIENTE_RESPUESTA
    -- D_TAR_ESTADO_PRORROGA
    -- D_TAR_ALERTA
    -- D_TAR_AMBITO
    -- D_TAR_REALIZACION
    -- D_TAR_CUMPLIMIENTO
    -- D_TAR_DESP_GESTOR
    -- D_TAR_TIPO_DESP_GESTOR
    -- D_TAR_GESTOR
    -- D_TAR_TIPO_GESTOR
    -- D_TAR_ENTIDAD_GESTOR
    -- D_TAR_NIVEL_DESP_GESTOR
    -- D_TAR_OFICINA_DESP_GESTOR
    -- D_TAR_PROV_DESP_GESTOR
    -- D_TAR_ZONA_DESP_GESTOR
    -- D_TAR_DESP_SUPERVISOR
    -- D_TAR_TIPO_DESP_SUPERVISOR
    -- D_TAR_SUPERVISOR
    -- D_TAR_ENTIDAD_SUPERVISOR
    -- D_TAR_NIVEL_DESP_SUPERVISOR
    -- D_TAR_OFICINA_DESP_SUPERVISOR
    -- D_TAR_PROV_DESP_SUPERVISOR
    -- D_TAR_ZONA_DESP_SUPERVISOR
    -- D_TAR_DESCRIPCION
    -- D_TAR_RESPONSABLE
    -- D_TAR_ESTADO
    -- D_TAR
    -- TMP_TAR_GESTOR
    -- TMP_TAR_SUPERVISOR

BEGIN

declare
  nCount NUMBER;
 
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_TAREA';
  V_SQL varchar2(16000); 

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
	



    ------------------------------ D_TAR_TIPO --------------------------
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_TIPO'', 



                            ''TIPO_TAREA_ID NUMBER(16,0) NOT NULL,
                              TIPO_TAREA_DESC VARCHAR2(50 CHAR),
                              TIPO_TAREA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_TAREA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_TAR_TIPO_DETALLE --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_TIPO_DETALLE'', 



                            ''TIPO_TAREA_DETALLE_ID NUMBER(16,0) NOT NULL,
                              TIPO_TAREA_DETALLE_DESC VARCHAR2(250 CHAR),
                              TIPO_TAREA_DETALLE_DESC_2 VARCHAR2(250 CHAR),
                              TIPO_TAREA_ID NUMBER(16,0) NULL,
                            PRIMARY KEY (TIPO_TAREA_DETALLE_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

	
	
	
    ------------------------------ D_TAR_RESOLUCION_PRORROGA --------------------------
     
	 
	 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_RESOLUCION_PRORROGA'', 
                            ''RESOLUCION_PRORROGA_ID NUMBER(16,0) NOT NULL,
                              RESOLUCION_PRORROGA_DESC VARCHAR2(50 CHAR),
                              RESOLUCION_PRORROGA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (RESOLUCION_PRORROGA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

	
	
    ------------------------------ D_TAR_MOTIVO_PRORROGA --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_MOTIVO_PRORROGA'', 



                            ''MOTIVO_PRORROGA_ID NUMBER(16,0) NOT NULL,
                              MOTIVO_PRORROGA_DESC VARCHAR2(50 CHAR),
                              MOTIVO_PRORROGA_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (MOTIVO_PRORROGA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_PENDIENTE_RESPUESTA --------------------------
    
	
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_PENDIENTE_RESPUESTA'', 
                            ''PENDIENTE_RESPUESTA_ID NUMBER(16,0) NOT NULL,
                            PENDIENTE_RESPUESTA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (PENDIENTE_RESPUESTA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

	
	
    ------------------------------ D_TAR_ESTADO_PRORROGA --------------------------
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_ESTADO_PRORROGA'', 



                            ''ESTADO_PRORROGA_ID NUMBER(16,0) NOT NULL,
                              ESTADO_PRORROGA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (ESTADO_PRORROGA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_TAR_ALERTA --------------------------
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_ALERTA'', 



                            ''TAREA_ALERTA_ID NUMBER(16,0) NOT NULL,
                              TAREA_ALERTA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (TAREA_ALERTA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
    ------------------------------ D_TAR_AMBITO --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_AMBITO'', 



                            ''AMBITO_TAREA_ID NUMBER(16,0) NOT NULL,
                              AMBITO_TAREA_DESC VARCHAR2(50 CHAR),
                            PRIMARY KEY (AMBITO_TAREA_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
    ------------------------------ D_TAR_REALIZACION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_REALIZACION'', 



                                ''REALIZACION_TAREA_ID NUMBER(16,0) NOT NULL,
                                  REALIZACION_TAREA_DESC VARCHAR2(50 CHAR),
                                PRIMARY KEY (REALIZACION_TAREA_ID)'', 
                                :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_TAR_CUMPLIMIENTO --------------------------
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_CUMPLIMIENTO'', 



                                ''CUMPLIMIENTO_TAREA_ID NUMBER(16,0) NOT NULL,
                                  CUMPLIMIENTO_TAREA_DESC VARCHAR2(50 CHAR),
                                PRIMARY KEY (CUMPLIMIENTO_TAREA_ID)'', 
                                :error); END;';
    execute immediate V_SQL USING OUT error;

	
	
    ------------------------------ D_TAR_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_DESP_GESTOR'', 



                            ''DESPACHO_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              DESPACHO_GESTOR_TAR_DESC VARCHAR2(250 CHAR),
                              TIPO_DESP_GESTOR_TAR_ID NUMBER(16,0),
                              ZONA_DESP_GESTOR_TAR_ID NUMBER(16,0),
                            PRIMARY KEY (DESPACHO_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
    ------------------------------ D_TAR_TIPO_DESP_GESTOR --------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_TIPO_DESP_GESTOR'', 



                            ''TIPO_DESP_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              TIPO_DESP_GESTOR_TAR_DESC VARCHAR2(50 CHAR),
                              TIPO_DESP_GESTOR_TAR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_DESP_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_TAR_GESTOR--------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_GESTOR'', 



                            ''GESTOR_TAREA_ID NUMBER(16,0) NOT NULL,
                              GESTOR_TAREA_NOMBRE_COMP VARCHAR2(250 CHAR),
                              GESTOR_TAREA_NOMBRE VARCHAR2(250 CHAR),
                              GESTOR_TAREA_APELLIDO1 VARCHAR2(250 CHAR),
                              GESTOR_TAREA_APELLIDO2 VARCHAR2(250 CHAR),
                              ENTIDAD_GESTOR_TAR_ID NUMBER(16,0),
                              DESPACHO_GESTOR_TAR_ID NUMBER(16,0),
                            PRIMARY KEY (GESTOR_TAREA_ID,DESPACHO_GESTOR_TAR_ID)'', 
                            :error); END;';
      execute immediate V_SQL USING OUT error;
	  
	  
	  
    ------------------------------ D_TAR_TIPO_GESTOR--------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_TIPO_GESTOR'', 



                            ''TIPO_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              TIPO_GESTOR_TAR_DESC VARCHAR2(50 CHAR),
                              TIPO_GESTOR_TAR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
    
    ------------------------------ D_TAR_ENTIDAD_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_ENTIDAD_GESTOR'', 



                            ''ENTIDAD_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              ENTIDAD_GESTOR_TAR_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (ENTIDAD_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;

	
	
	
    ------------------------------ D_TAR_NIVEL_DESP_GESTOR --------------------------

	
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_NIVEL_DESP_GESTOR'', 
                            ''NIVEL_DESP_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              NIVEL_DESP_GESTOR_TAR_DESC VARCHAR2(50 CHAR),
                              NIVEL_DESP_GESTOR_TAR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (NIVEL_DESP_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	

    ------------------------------ D_TAR_OFICINA_DESP_GESTOR --------------------------
    
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_OFICINA_DESP_GESTOR'', 
                            ''OFICINA_DESP_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              OFICINA_DESP_GESTOR_TAR_DESC VARCHAR2(50 CHAR),
                              OFICINA_DESP_GESTOR_TAR_DESC_2 VARCHAR2(250 CHAR),
                              PROV_DESP_GESTOR_TAR_ID NUMBER(16,0),
                            PRIMARY KEY (OFICINA_DESP_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_PROV_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_PROV_DESP_GESTOR'', 
                            ''PROV_DESP_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              PROV_DESP_GESTOR_TAR_DESC VARCHAR2(50 CHAR),
                              PROV_DESP_GESTOR_TAR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (PROV_DESP_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_ZONA_DESP_GESTOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_ZONA_DESP_GESTOR'', 



                            ''ZONA_DESP_GESTOR_TAR_ID NUMBER(16,0) NOT NULL,
                              ZONA_DESP_GESTOR_TAR_DESC VARCHAR2(50 CHAR),
                              ZONA_DESP_GESTOR_TAR_DESC_2 VARCHAR2(250 CHAR),
                              NIVEL_DESP_GESTOR_TAR_ID NUMBER(16,0),
                              OFICINA_DESP_GESTOR_TAR_ID NUMBER(16,0),
                            PRIMARY KEY (ZONA_DESP_GESTOR_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_DESP_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_DESP_SUPERVISOR'', 



                            ''DESPACHO_SUPER_TAR_ID NUMBER(16,0) NOT NULL,
                              DESPACHO_SUPER_TAR_DESC VARCHAR2(250 CHAR),
                              TIPO_DESP_SUPER_TAR_ID NUMBER(16,0),
                              ZONA_DESP_SUPER_TAR_ID NUMBER(16,0),
                            PRIMARY KEY (DESPACHO_SUPER_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_TIPO_DESP_SUPERVISOR --------------------------
   

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_TIPO_DESP_SUPERVISOR'', 
                            ''TIPO_DESP_SUPER_TAR_ID NUMBER(16,0) NOT NULL,
                              TIPO_DESP_SUPER_TAR_DESC VARCHAR2(50 CHAR),
                              TIPO_DESP_SUPER_TAR_DESC_2 VARCHAR2(250 CHAR),
                            PRIMARY KEY (TIPO_DESP_SUPER_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_SUPERVISOR'', 



                            ''SUPERVISOR_TAREA_ID NUMBER(16,0) NOT NULL,
                              SUPERVISOR_TAREA_NOMBRE_COMP VARCHAR2(250 CHAR),
                              SUPERVISOR_TAREA_NOMBRE VARCHAR2(250 CHAR),
                              SUPERVISOR_TAREA_APELLIDO1 VARCHAR2(250 CHAR),
                              SUPERVISOR_TAREA_APELLIDO2 VARCHAR2(250 CHAR),
                              ENTIDAD_SUPER_TAR_ID NUMBER(16,0),
                              DESPACHO_SUPER_TAR_ID NUMBER(16,0),
                            PRIMARY KEY (SUPERVISOR_TAREA_ID)'',
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_ENTIDAD_SUPERVISOR --------------------------
   

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_ENTIDAD_SUPERVISOR'', 
                            ''ENTIDAD_SUPER_TAR_ID NUMBER(16,0) NOT NULL,
                              ENTIDAD_SUPER_TAR_DESC VARCHAR2(255 CHAR),
                            PRIMARY KEY (ENTIDAD_SUPER_TAR_ID)'', 
                            :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_NIVEL_DESP_SUPERVISOR --------------------------
    
	
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_NIVEL_DESP_SUPERVISOR'', 
                          ''NIVEL_DESP_SUPER_TAR_ID NUMBER(16,0) NOT NULL,
                            NIVEL_DESP_SUPER_TAR_DESC VARCHAR2(50 CHAR),
                            NIVEL_DESP_SUPER_TAR_DESC_2 VARCHAR2(250 CHAR),
                          PRIMARY KEY (NIVEL_DESP_SUPER_TAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_OFICINA_DESP_SUPERVISOR --------------------------
   

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_OFICINA_DESP_SUPERVISOR'', 
                        ''OFICINA_DESP_SUPER_TAR_ID NUMBER(16,0) NOT NULL,
                          OFICINA_DESP_SUPER_TAR_DESC VARCHAR2(50 CHAR),
                          OFICINA_DESP_SUPER_TAR_DESC_2 VARCHAR2(250 CHAR),
                          PROV_DESP_SUPER_TAR_ID NUMBER(16,0),
                        PRIMARY KEY (OFICINA_DESP_SUPER_TAR_ID)'', 
                        :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_TAR_PROV_DESP_SUPERVISOR --------------------------
   


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_PROV_DESP_SUPERVISOR'', 
                        ''PROV_DESP_SUPER_TAR_ID NUMBER(16,0) NOT NULL,
                        PROV_DESP_SUPER_TAR_DESC VARCHAR2(50 CHAR),
                        PROV_DESP_SUPER_TAR_DESC_2 VARCHAR2(250 CHAR),
                        PRIMARY KEY (PROV_DESP_SUPER_TAR_ID)'', 
                        :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_ZONA_DESP_SUPERVISOR --------------------------
   

   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_ZONA_DESP_SUPERVISOR'', 
                        ''ZONA_DESP_SUPER_TAR_ID NUMBER(16,0) NOT NULL,
                          ZONA_DESP_SUPER_TAR_DESC VARCHAR2(50 CHAR),
                          ZONA_DESP_SUPER_TAR_DESC_2 VARCHAR2(250 CHAR),
                          NIVEL_DESP_SUPER_TAR_ID NUMBER(16,0),
                          OFICINA_DESP_SUPER_TAR_ID NUMBER(16,0),
                        PRIMARY KEY (ZONA_DESP_SUPER_TAR_ID)'', 
                        :error); END;';
    execute immediate V_SQL USING OUT error;

	
	
    ------------------------------ D_TAR_DESCRIPCION --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_DESCRIPCION'', 



                  ''DESCRIPCION_TAREA_ID NUMBER(16,0) NOT NULL,
                    DESCRIPCION_TAREA_DESC VARCHAR2(100 CHAR),
                  PRIMARY KEY (DESCRIPCION_TAREA_ID)'', 
                  :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_RESPONSABLE --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_RESPONSABLE'', 



                  ''RESPONSABLE_TAREA_ID NUMBER(16,0) NOT NULL,
                    RESPONSABLE_TAREA_DESC VARCHAR2(100 CHAR),
                  PRIMARY KEY (RESPONSABLE_TAREA_ID)'', 
                  :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR_ESTADO --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR_ESTADO'', 



                        ''ESTADO_TAREA_ID NUMBER(16,0) NOT NULL,
                          ESTADO_TAREA_DESC VARCHAR2(50 CHAR),
                        PRIMARY KEY (ESTADO_TAREA_ID)'', 
                        :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ------------------------------ D_TAR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_TAR'', 



                        ''TAREA_ID NUMBER(16,0) NOT NULL,
                          TAREA_EMISOR VARCHAR2(50 CHAR),
                          DESCRIPCION_TAREA_ID NUMBER(16,0),
                          GESTOR_TAREA_ID NUMBER(16,0),
                          SUPERVISOR_TAREA_ID NUMBER(16,0),
                          TIPO_GESTOR_TAR_ID NUMBER(16,0),
                          FECHA_INICIO_TAREA DATE,
                          FECHA_FIN_TAREA DATE,
                          FECHA_VENCIMIENTO_TAREA DATE,
                          FECHA_VENCIMIENTO_REAL_TAREA DATE,
                          TIPO_TAREA_DETALLE_ID NUMBER(16,0),
                          AMBITO_TAREA_ID NUMBER(16,0),
                          PENDIENTE_RESPUESTA_ID NUMBER(16,0),
                          TAREA_ALERTA_ID NUMBER(16,0),
                          CUMPLIMIENTO_TAREA_ID NUMBER(16,0),
                        CONSTRAINT D_TAR_PK PRIMARY KEY (TAREA_ID)'', 
                        :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

    ----------------------------- TMP_TAR_GESTOR --------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_TAR_GESTOR'', 
                                              ''TAREA_ID NUMBER(16,0),
                                              GESTOR_TAREA_ID NUMBER(16,0)'', 
                                              :error); END;';
    execute immediate V_SQL USING OUT error;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_TAR_GESTOR_IX'', ''TMP_TAR_GESTOR (TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	
	
	
	
	
	

    ----------------------------- TMP_TAR_SUPERVISOR --------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''TMP_TAR_SUPERVISOR'', 
                                              ''TAREA_ID NUMBER(16,0),




                                              SUPERVISOR_TAREA_ID NUMBER(16,0)'', 
                                              :error); END;';
    execute immediate V_SQL USING OUT error;
    

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_TAR_SUPERVISOR_IX'', ''TMP_TAR_SUPERVISOR (TAREA_ID)'', ''S'', '''', :error); END;';
    execute immediate V_SQL USING OUT error;
	
	

	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_DIM_TAREA;
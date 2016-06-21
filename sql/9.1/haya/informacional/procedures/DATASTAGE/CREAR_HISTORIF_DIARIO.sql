create or replace PROCEDURE CREAR_HISTORIF_DIARIO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Pedro Sebastián, PFS Group
-- Fecha creación: Junio 2015
-- Responsable ultima modificacion:  María Villanueva, PFS Group
-- Fecha ultima modificacion: 23/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI Haya
--
-- Descripción: Procedimiento almancenado que carga las tablas ext_iab_info_add_bi_h y ext_iab_info_add_bi.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
    -- ext_iab_info_add_bi_h
    -- ext_iab_info_add_bi
BEGIN

  declare
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_HISTORIF_DIARIO';

  begin

 --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Empieza ' || V_NOMBRE, 3;  

    ------------------------------ EXT_IAB_INFO_ADD_BI --------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''EXT_IAB_INFO_ADD_BI '', 
		  ''IAB_ID NUMBER(16, 0) 
			, DD_EIN_ID NUMBER(16, 0) 
			, IAB_ID_UNIDAD_GESTION NUMBER(16, 0) 
			, DD_IFB_ID NUMBER(16, 0) 
			, IAB_VALOR VARCHAR2(50 BYTE) 
			, IAB_FECHA_VALOR DATE 
			, VERSION NUMBER NOT NULL 
			, USUARIOCREAR VARCHAR2(50 BYTE) NOT NULL 
			, FECHACREAR DATE 
			, USUARIOMODIFICAR VARCHAR2(50 BYTE) 
			, FECHAMODIFICAR DATE 
			, USUARIOBORRAR VARCHAR2(50 BYTE) 
			, FECHABORRAR DATE 
			, BORRADO NUMBER(1, 0) NOT NULL 
			, FECHA_CANCELACION date'', :error); END;';
   execute immediate V_SQL USING OUT error;


	
	   V_SQL :=  'BEGIN OPERACION_DDL.DDL_SEQUENCE(''CREATE'', ''S_EXT_IAB_INFO_ADD_BI'', 1, 1, 2901, ''CACHE 20 NOORDER  NOCYCLE'', :error); END;';
    execute immediate V_SQL USING OUT error;   

     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''EXT_IAB_INFO_ADD_BI_H'', 
		  ''IAB_ID NUMBER(16,0), 
			DD_EIN_ID NUMBER(16,0), 
			IAB_ID_UNIDAD_GESTION NUMBER(16,0), 
			DD_IFB_ID NUMBER(16,0), 
			IAB_VALOR VARCHAR2(50 CHAR), 
			IAB_FECHA_VALOR DATE, 
			VERSION NUMBER, 
			USUARIOCREAR VARCHAR2(50 CHAR), 
			FECHACREAR DATE, 
			USUARIOMODIFICAR VARCHAR2(50 CHAR), 
			FECHAMODIFICAR DATE, 
			USUARIOBORRAR VARCHAR2(50 CHAR), 
			FECHABORRAR DATE, 
			BORRADO NUMBER(1,0) DEFAULT 0,
			FECHA_CANCELACION date
   )
			  SEGMENT CREATION IMMEDIATE 
					TABLESPACE "RECOVERY_HAYA_DWH" 
                    PARTITION BY RANGE ("IAB_FECHA_VALOR")
                    INTERVAL(NUMTOYMINTERVAL(1, ''''MONTH''''))
                    (PARTITION "p1" VALUES LESS THAN (TO_DATE('''' 2014-11-01 00:00:00'''', ''''SYYYY-MM-DD HH24:MI:SS'''', ''''NLS_CALENDAR=GREGORIAN''''))'', :error); END;';
	 execute immediate V_SQL USING OUT error;

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Termina ' || V_NOMBRE, 3;  

  end;

END CREAR_HISTORIF_DIARIO;

create or replace PROCEDURE CARGAR_DIM_EXPEDIENTE( O_ERROR_STATUS OUT VARCHAR2) AS 

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable última modificación: Gonzalo Martín, PFS Groupp
-- Fecha última modificación: 23/03/2015
-- Motivos del cambio: D_EXP_ENVIADO_AGENCIA
-- Cliente: Recovery BI Bankia 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Expediente.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN EXPEDIENTE 
    -- D_EXP_ACTITUD
    -- D_EXP_AMBITO_EXPEDIENTE 
    -- D_EXP_ARQUETIPO
    -- D_EXP_CAUSA_IMPAGO 
    -- D_EXP_COMITE 
    -- D_EXP_DECISION 
    -- D_EXP_ENTIDAD_INFORMACION 
    -- D_EXP_ESTADO_EXPEDIENTE
    -- D_EXP_ESTADO_ITINERARIO 
    -- D_EXP_ITINERARIO
    -- D_EXP_NIVEL   
    -- D_EXP_OFICINA 
    -- D_EXP_PROPUESTA 
    -- D_EXP_PROVINCIA 
    -- D_EXP_SESION 
    -- D_EXP_TIPO_ITINERARIO 
    -- D_EXP_ZONA 
    -- D_EXP_ESQUEMA
    -- D_EXP_CARTERA
    -- D_EXP_SUBCARTERA
    -- D_EXP_AGENCIA   
    -- D_EXP_ENVIADO_AGENCIA
    -- D_EXP_T_SALDO_TOTAL;
    -- D_EXP_T_SALDO_IRREGULAR
    -- D_EXP_T_DEUDA_IRREGULAR
    -- D_EXP_T_DEUDA_IRREGULAR_ENV
    /*
    -- D_EXP_TIPO_COBRO
    -- D_EXP_COBRO_FACTURADO
    -- D_EXP_REMESA_FACTURA
    */
    -- D_EXP_MOTIVO_SALIDA
    -- D_EXP_TIPO_PALANCA;
    -- D_EXP_ESTADO_INCIDENCIA;
    -- D_EXP_TIPO_SANCION;
    -- D_EXP_TIPO_INCIDENCIA;
    -- D_EXP_ESTADO_INCIDENCIA;
    -- D_EXP_T_ROTACIONES
    -- D_EXP_TD_ENTRADA_GESTION
    -- D_EXP_TD_CREACION_EXP_COBRO
    -- D_EXP_RESULTADO_GESTION
    -- D_EXP_RESULTADO_GESTION_CNT
	  -- D_EXP_MODELOS_FACTURACION
    -- D_EXP_TIPO_GESTION
    -- D_EXP_TIPO_GESTION_CNT
    
    -- D_EXP_MOTIVO_BAJA_CR
    -- D_EXP_ESQUEMA_CR
    -- D_EXP_CARTERA_CR
    -- D_EXP_SUBCARTERA_CR
    -- D_EXP_AGENCIA_CR
    -- D_EXP_ENVIADO_AGENCIA_CR
    
    -- D_EXP


-- ===============================================================================================
 
-- ===============================================================================================
--                  									Declaración de variables
-- ===============================================================================================
OBJECTEXISTS EXCEPTION;
INSERT_NULL EXCEPTION;
PARAMETERS_NUMBER EXCEPTION;
PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

V_NUM_ROW NUMBER(10);
V_NUM_TABLE NUMBER(10);
V_SCHEMA_DS VARCHAR2(100);
V_SQL VARCHAR2(4000);

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_EXPEDIENTE';
V_ROWCOUNT NUMBER;

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  
  select valor into V_SCHEMA_DS from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
    
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ACTITUD
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ACTITUD WHERE ACTITUD_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ACTITUD (ACTITUD_ID, ACTITUD_DESC, ACTITUD_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL := 'insert into D_EXP_ACTITUD(ACTITUD_ID, ACTITUD_DESC, ACTITUD_DESC_2)
    	select DD_TAA_ID, DD_TAA_DESCRIPCION, DD_TAA_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_TAA_TIPO_AYUDA_ACTUACION TAA
	where not exists (select 1 from D_EXP_ACTITUD EXP WHERE EXP.ACTITUD_ID = TAA.DD_TAA_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ACTITUD. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_AMBITO_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_AMBITO_EXPEDIENTE WHERE AMBITO_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_AMBITO_EXPEDIENTE (AMBITO_EXPEDIENTE_ID, AMBITO_EXPEDIENTE_DESC, AMBITO_EXPEDIENTE_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_AMBITO_EXPEDIENTE(AMBITO_EXPEDIENTE_ID, AMBITO_EXPEDIENTE_DESC, AMBITO_EXPEDIENTE_DESC_2)
    select DD_AEX_ID, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_AEX_AMBITOS_EXPEDIENTE AEX
	where not exists (select 1 from D_EXP_AMBITO_EXPEDIENTE EXP WHERE EXP.AMBITO_EXPEDIENTE_ID = AEX.DD_AEX_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_AMBITO_EXPEDIENTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ARQUETIPO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ARQUETIPO WHERE ARQUETIPO_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ARQUETIPO (ARQUETIPO_EXPEDIENTE_ID, ARQUETIPO_EXPEDIENTE_DESC, ITINERARIO_EXPEDIENTE_ID) values (-1 ,''Desconocido'', -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_ARQUETIPO(ARQUETIPO_EXPEDIENTE_ID, ARQUETIPO_EXPEDIENTE_DESC, ITINERARIO_EXPEDIENTE_ID)
    select ARQ_ID, ARQ_NOMBRE, ITI_ID FROM ' || V_SCHEMA_DS || '.ARQ_ARQUETIPOS ARQ
	where not exists (select 1 from D_EXP_ARQUETIPO EXP WHERE EXP.ARQUETIPO_EXPEDIENTE_ID = ARQ.ARQ_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ARQUETIPO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_CAUSA_IMPAGO
-- ----------------------------------------------------------------------------------------------

  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_CAUSA_IMPAGO WHERE CAUSA_IMPAGO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_CAUSA_IMPAGO (CAUSA_IMPAGO_ID, CAUSA_IMPAGO_DESC, CAUSA_IMPAGO_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_CAUSA_IMPAGO(CAUSA_IMPAGO_ID, CAUSA_IMPAGO_DESC, CAUSA_IMPAGO_DESC_2)
    select DD_CIM_ID, DD_CIM_DESCRIPCION, DD_CIM_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_CIM_CAUSAS_IMPAGO CIM
	where not exists (select 1 from D_EXP_CAUSA_IMPAGO EXP WHERE EXP.CAUSA_IMPAGO_ID = CIM.DD_CIM_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_CAUSA_IMPAGO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
        
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_COMITE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_COMITE WHERE COMITE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_COMITE (COMITE_ID, COMITE_DESC, ZONA_EXPEDIENTE_ID) values (-1 ,''Desconocido'', -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_COMITE(COMITE_ID, COMITE_DESC, ZONA_EXPEDIENTE_ID)
    select COM_ID, COM_NOMBRE, ZON_ID FROM ' || V_SCHEMA_DS || '.COM_COMITES COM
	where not exists (select 1 from D_EXP_COMITE EXP WHERE EXP.COMITE_ID = COM.COM_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_COMITE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_DECISION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_DECISION WHERE DECISION_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_DECISION (DECISION_ID, DECISION_DESC, SESION_ID) values (-1 ,''Desconocido'', -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_DECISION(DECISION_ID, DECISION_DESC, SESION_ID)
    select DCO_ID, DCO_OBSERVACIONES, SES_ID FROM ' || V_SCHEMA_DS || '.DCO_DECISION_COMITE DCO
	where not exists (select 1 from D_EXP_DECISION EXP WHERE EXP.DECISION_ID = DCO.DCO_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_DECISION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ENTIDAD_INFORMACION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ENTIDAD_INFORMACION WHERE ENTIDAD_INFORMACION_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ENTIDAD_INFORMACION (ENTIDAD_INFORMACION_ID, ENTIDAD_INFORMACION_DESC, ENTIDAD_INFORMACION_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_ENTIDAD_INFORMACION(ENTIDAD_INFORMACION_ID, ENTIDAD_INFORMACION_DESC, ENTIDAD_INFORMACION_DESC_2)
    select DD_EIN_ID, DD_EIN_DESCRIPCION, DD_EIN_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_EIN_ENTIDAD_INFORMACION EIN
	where not exists (select 1 from D_EXP_ENTIDAD_INFORMACION EXP WHERE EXP.ENTIDAD_INFORMACION_ID = EIN.DD_EIN_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ENTIDAD_INFORMACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ESTADO_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ESTADO_EXPEDIENTE WHERE ESTADO_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ESTADO_EXPEDIENTE (ESTADO_EXPEDIENTE_ID, ESTADO_EXPEDIENTE_DESC, ESTADO_EXPEDIENTE_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_ESTADO_EXPEDIENTE(ESTADO_EXPEDIENTE_ID, ESTADO_EXPEDIENTE_DESC, ESTADO_EXPEDIENTE_DESC_2)
    select DD_EEX_ID, DD_EEX_DESCRIPCION, DD_EEX_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_EEX_ESTADO_EXPEDIENTE EEX
	where not exists (select 1 from D_EXP_ESTADO_EXPEDIENTE EXP WHERE EXP.ESTADO_EXPEDIENTE_ID = EEX.DD_EEX_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ESTADO_EXPEDIENTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ESTADO_ITINERARIO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ESTADO_ITINERARIO WHERE ESTADO_ITINERARIO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ESTADO_ITINERARIO (ESTADO_ITINERARIO_ID, ESTADO_ITINERARIO_DESC, ESTADO_ITINERARIO_DESC_2, ENTIDAD_INFORMACION_ID) values (-1 ,''Desconocido'', ''Desconocido'', -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_ESTADO_ITINERARIO(ESTADO_ITINERARIO_ID, ESTADO_ITINERARIO_DESC, ESTADO_ITINERARIO_DESC_2, ENTIDAD_INFORMACION_ID)
    select DD_EST_ID, DD_EST_DESCRIPCION, DD_EST_DESCRIPCION_LARGA, DD_EIN_ID FROM ' || V_SCHEMA_DS || '.DD_EST_ESTADOS_ITINERARIOS EST
	where not exists (select 1 from D_EXP_ESTADO_ITINERARIO EXP WHERE EXP.ESTADO_ITINERARIO_ID = EST.DD_EST_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ESTADO_ITINERARIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ITINERARIO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ITINERARIO WHERE ITINERARIO_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ITINERARIO (ITINERARIO_EXPEDIENTE_ID, ITINERARIO_EXPEDIENTE_DESC, TIPO_ITINERARIO_EXP_ID, AMBITO_EXPEDIENTE_ID) values (-1 ,''Desconocido'', -1, -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_ITINERARIO(ITINERARIO_EXPEDIENTE_ID, ITINERARIO_EXPEDIENTE_DESC, TIPO_ITINERARIO_EXP_ID, AMBITO_EXPEDIENTE_ID)
    select ITI_ID, ITI_NOMBRE, DD_TIT_ID, DD_AEX_ID FROM ' || V_SCHEMA_DS || '.ITI_ITINERARIOS ITI
	where not exists (select 1 from D_EXP_ITINERARIO EXP WHERE EXP.ITINERARIO_EXPEDIENTE_ID = ITI.ITI_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ITINERARIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_NIVEL
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_NIVEL WHERE NIVEL_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_NIVEL (NIVEL_EXPEDIENTE_ID, NIVEL_EXPEDIENTE_DESC, NIVEL_EXPEDIENTE_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_NIVEL(NIVEL_EXPEDIENTE_ID, NIVEL_EXPEDIENTE_DESC, NIVEL_EXPEDIENTE_DESC_2)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.NIV_NIVEL NIV
	where not exists (select 1 from D_EXP_NIVEL EXP WHERE EXP.NIVEL_EXPEDIENTE_ID = NIV.NIV_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_NIVEL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_OFICINA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_OFICINA WHERE OFICINA_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_OFICINA (OFICINA_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_DESC, OFICINA_EXPEDIENTE_DESC_2, PROVINCIA_EXPEDIENTE_ID) values (-1 ,''Desconocido'', ''Desconocido'', -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_OFICINA(OFICINA_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_DESC, PROVINCIA_EXPEDIENTE_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM ' || V_SCHEMA_DS || '.OFI_OFICINAS OFI
	where not exists (select 1 from D_EXP_OFICINA EXP WHERE EXP.OFICINA_EXPEDIENTE_ID = OFI.OFI_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_OFICINA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PROPUESTA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_PROPUESTA WHERE PROPUESTA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_PROPUESTA (PROPUESTA_ID, PROPUESTA_DESC, PROPUESTA_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_PROPUESTA(PROPUESTA_ID, PROPUESTA_DESC, PROPUESTA_DESC_2)
    select DD_PRA_ID, DD_PRA_DESCRIPCION, DD_PRA_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_PRA_PROPUESTA_AAA AAA
	where not exists (select 1 from D_EXP_PROPUESTA EXP WHERE EXP.PROPUESTA_ID = AAA.DD_PRA_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_PROPUESTA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PROVINCIA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_PROVINCIA WHERE PROVINCIA_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_PROVINCIA (PROVINCIA_EXPEDIENTE_ID, PROVINCIA_EXPEDIENTE_DESC, PROVINCIA_EXPEDIENTE_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_PROVINCIA(PROVINCIA_EXPEDIENTE_ID, PROVINCIA_EXPEDIENTE_DESC, PROVINCIA_EXPEDIENTE_DESC_2)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_PRV_PROVINCIA PRV
	where not exists (select 1 from D_EXP_PROVINCIA EXP WHERE EXP.PROVINCIA_EXPEDIENTE_ID = PRV.DD_PRV_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_PROVINCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_SESION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_SESION WHERE SESION_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_SESION (SESION_ID, SESION_FECHA_INICIO, SESION_FECHA_FIN, COMITE_ID) values (-1 , to_date(''1900-01-01'', ''RRRR-MM-DD''), to_date(''1900-01-01'', ''YYYY-MM-DD''), -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_SESION(SESION_ID, SESION_FECHA_INICIO, SESION_FECHA_FIN, COMITE_ID)
    select SES_ID, SES_FECHA_INI, SES_FECHA_FIN, COM_ID FROM ' || V_SCHEMA_DS || '.SES_SESIONES_COMITE SES
	where not exists (select 1 from D_EXP_SESION EXP WHERE EXP.SESION_ID = SES.SES_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_SESION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_ITINERARIO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_TIPO_ITINERARIO WHERE TIPO_ITINERARIO_EXP_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_TIPO_ITINERARIO (TIPO_ITINERARIO_EXP_ID, TIPO_ITINERARIO_EXP_DESC, TIPO_ITINERARIO_EXP_DESC_2) values (-1 ,''Desconocido'', ''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_TIPO_ITINERARIO(TIPO_ITINERARIO_EXP_ID, TIPO_ITINERARIO_EXP_DESC, TIPO_ITINERARIO_EXP_DESC_2)
    select DD_TIT_ID, DD_TIT_DESCRIPCION, DD_TIT_DESCRIPCION_LARGA FROM ' || V_SCHEMA_DS || '.DD_TIT_TIPO_ITINERARIOS TIT
	where not exists (select 1 from D_EXP_TIPO_ITINERARIO EXP WHERE EXP.TIPO_ITINERARIO_EXP_ID = TIT.DD_TIT_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_TIPO_ITINERARIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ZONA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ZONA WHERE ZONA_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ZONA (ZONA_EXPEDIENTE_ID, ZONA_EXPEDIENTE_DESC, ZONA_EXPEDIENTE_DESC_2, NIVEL_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_ID) values (-1 ,''Desconocido'', ''Desconocido'', -1, -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_ZONA(ZONA_EXPEDIENTE_ID, ZONA_EXPEDIENTE_DESC, ZONA_EXPEDIENTE_DESC_2, NIVEL_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, OFI_ID FROM ' || V_SCHEMA_DS || '.ZON_ZONIFICACION ZON
	where not exists (select 1 from D_EXP_ZONA EXP WHERE EXP.ZONA_EXPEDIENTE_ID = ZON.ZON_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ZONA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ESQUEMA
-- ----------------------------------------------------------------------------------------------

  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_ESQUEMA WHERE ESQUEMA_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_ESQUEMA (ESQUEMA_EXPEDIENTE_ID, ESQUEMA_EXPEDIENTE_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_ESQUEMA (ESQUEMA_EXPEDIENTE_ID, ESQUEMA_EXPEDIENTE_DESC)
    select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_SCHEMA_DS || '.RCF_ESQ_ESQUEMA RCF 
	where not exists (select 1 from D_EXP_ESQUEMA EXP WHERE EXP.ESQUEMA_EXPEDIENTE_ID = RCF.RCF_ESQ_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ESQUEMA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
        
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_CARTERA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_CARTERA WHERE CARTERA_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_CARTERA (CARTERA_EXPEDIENTE_ID, CARTERA_EXPEDIENTE_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_CARTERA (CARTERA_EXPEDIENTE_ID, CARTERA_EXPEDIENTE_DESC)
    select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_SCHEMA_DS || '.RCF_CAR_CARTERA RCF
	where not exists (select 1 from D_EXP_CARTERA EXP WHERE EXP.CARTERA_EXPEDIENTE_ID = RCF.RCF_CAR_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_CARTERA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_SUBCARTERA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_SUBCARTERA WHERE SUBCARTERA_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_SUBCARTERA (SUBCARTERA_EXPEDIENTE_ID, SUBCARTERA_EXPEDIENTE_DESC, CARTERA_EXPEDIENTE_ID) values (-1 ,''Desconocido'', -1)';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_SUBCARTERA (SUBCARTERA_EXPEDIENTE_ID, SUBCARTERA_EXPEDIENTE_DESC, CARTERA_EXPEDIENTE_ID)
    select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID  
	from ' || V_SCHEMA_DS || '.RCF_SCA_SUBCARTERA SUB
	INNER JOIN ' || V_SCHEMA_DS || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
	INNER JOIN ' || V_SCHEMA_DS || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
	where not exists (select 1 from D_EXP_SUBCARTERA EXP WHERE EXP.SUBCARTERA_EXPEDIENTE_ID = SUB.RCF_SCA_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_SUBCARTERA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_AGENCIA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_AGENCIA WHERE AGENCIA_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_AGENCIA (AGENCIA_EXPEDIENTE_ID, AGENCIA_EXPEDIENTE_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_AGENCIA (AGENCIA_EXPEDIENTE_ID, AGENCIA_EXPEDIENTE_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_SCHEMA_DS || '.RCF_AGE_AGENCIAS RCF
	where not exists (select 1 from D_EXP_AGENCIA EXP WHERE EXP.AGENCIA_EXPEDIENTE_ID = RCF.RCF_AGE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_AGENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ENVIADO_AGENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_ENVIADO_AGENCIA where ENVIADO_AGENCIA_EXP_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_ENVIADO_AGENCIA (ENVIADO_AGENCIA_EXP_ID, ENVIADO_AGENCIA_EXP_DESC) values (-1 ,'Desconocido');
  end if;
  
  select count(*) into V_NUM_ROW from D_EXP_ENVIADO_AGENCIA where ENVIADO_AGENCIA_EXP_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_ENVIADO_AGENCIA (ENVIADO_AGENCIA_EXP_ID, ENVIADO_AGENCIA_EXP_DESC) values (0 ,'No Enviado a Agencia');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_ENVIADO_AGENCIA where ENVIADO_AGENCIA_EXP_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_ENVIADO_AGENCIA (ENVIADO_AGENCIA_EXP_ID, ENVIADO_AGENCIA_EXP_DESC) values (1 ,'Enviado a Agencia');
  end if; 
  
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ENVIADO_AGENCIA. Realizados INSERTS', 3;
    
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_T_SALDO_TOTAL
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_TOTAL (T_SALDO_TOTAL_EXP_ID, T_SALDO_TOTAL_EXP_DESC) select -1 ,''Desconocido'' from dual where not exists (select 1 from D_EXP_T_SALDO_TOTAL where T_SALDO_TOTAL_EXP_ID = -1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_TOTAL (T_SALDO_TOTAL_EXP_ID, T_SALDO_TOTAL_EXP_DESC) select 0 ,''0 € - 30.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_TOTAL where T_SALDO_TOTAL_EXP_ID = 0)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_TOTAL (T_SALDO_TOTAL_EXP_ID, T_SALDO_TOTAL_EXP_DESC) select 1 ,''30.000 € - 60.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_TOTAL where T_SALDO_TOTAL_EXP_ID = 1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_TOTAL (T_SALDO_TOTAL_EXP_ID, T_SALDO_TOTAL_EXP_DESC) select 2 ,''60.000 € - 90.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_TOTAL where T_SALDO_TOTAL_EXP_ID = 2)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_TOTAL (T_SALDO_TOTAL_EXP_ID, T_SALDO_TOTAL_EXP_DESC) select 3 ,''90.000 €- 300.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_TOTAL where T_SALDO_TOTAL_EXP_ID = 3)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_TOTAL (T_SALDO_TOTAL_EXP_ID, T_SALDO_TOTAL_EXP_DESC) select 4 ,''> 300.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_TOTAL where T_SALDO_TOTAL_EXP_ID = 4)';
    
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_T_SALDO_TOTAL. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_T_SALDO_IRREGULAR
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_EXP_ID, T_SALDO_IRREGULAR_EXP_DESC) select -1, ''Desconocido'' from dual where not exists (select 1 from D_EXP_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_EXP_ID = -1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_EXP_ID, T_SALDO_IRREGULAR_EXP_DESC) select 0, ''0 € - 30.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_EXP_ID = 0)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_EXP_ID, T_SALDO_IRREGULAR_EXP_DESC) select 1, ''30.000 € - 60.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_EXP_ID = 1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_EXP_ID, T_SALDO_IRREGULAR_EXP_DESC) select 2, ''60.000 € - 90.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_EXP_ID = 2)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_EXP_ID, T_SALDO_IRREGULAR_EXP_DESC) select 3, ''90.000 € - 300.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_EXP_ID = 3)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_EXP_ID, T_SALDO_IRREGULAR_EXP_DESC) select 4, ''> 300.000 €'' from dual where not exists (select 1 from D_EXP_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_EXP_ID = 4)';

  COMMIT;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_T_SALDO_IRREGULAR. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_T_DEUDA_IRREGULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_EXP_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_EXP_ID, T_DEUDA_IRREGULAR_EXP_DESC) values (-1 ,'Desconocido');
  end if;
  
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_EXP_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_EXP_ID, T_DEUDA_IRREGULAR_EXP_DESC) values (0 ,'0 € - 25.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_EXP_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_EXP_ID, T_DEUDA_IRREGULAR_EXP_DESC) values (1 ,'25.000 € - 50.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_EXP_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_EXP_ID, T_DEUDA_IRREGULAR_EXP_DESC) values (2 ,'50.000 € - 75.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_EXP_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_EXP_ID, T_DEUDA_IRREGULAR_EXP_DESC) values (3 ,'> 75.000 €');
  end if;

  commit;  

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_T_DEUDA_IRREGULAR. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_T_DEUDA_IRREGULAR_ENV
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR_ENV where T_DEUDA_IRREGULAR_ENV_EXP_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR_ENV (T_DEUDA_IRREGULAR_ENV_EXP_ID, T_DEUDA_IRREGULAR_ENV_EXP_DESC) values (-1 ,'Desconocido');
  end if;
  
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR_ENV where T_DEUDA_IRREGULAR_ENV_EXP_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR_ENV (T_DEUDA_IRREGULAR_ENV_EXP_ID, T_DEUDA_IRREGULAR_ENV_EXP_DESC) values (0 ,'0 € - 25.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR_ENV where T_DEUDA_IRREGULAR_ENV_EXP_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR_ENV (T_DEUDA_IRREGULAR_ENV_EXP_ID, T_DEUDA_IRREGULAR_ENV_EXP_DESC) values (1 ,'25.000 € - 50.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR_ENV where T_DEUDA_IRREGULAR_ENV_EXP_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR_ENV (T_DEUDA_IRREGULAR_ENV_EXP_ID, T_DEUDA_IRREGULAR_ENV_EXP_DESC) values (2 ,'50.000 € - 75.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_T_DEUDA_IRREGULAR_ENV where T_DEUDA_IRREGULAR_ENV_EXP_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_T_DEUDA_IRREGULAR_ENV (T_DEUDA_IRREGULAR_ENV_EXP_ID, T_DEUDA_IRREGULAR_ENV_EXP_DESC) values (3 ,'> 75.000 €');
  end if;

  commit;  

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_T_DEUDA_IRREGULAR_ENV. Realizados INSERTS', 3;
  
/*    
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_COBRO
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_TIPO_COBRO WHERE TIPO_COBRO_EXPEDIENTE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_TIPO_COBRO (TIPO_COBRO_EXPEDIENTE_ID, TIPO_COBRO_EXPEDIENTE_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_TIPO_COBRO (TIPO_COBRO_EXPEDIENTE_ID, TIPO_COBRO_EXPEDIENTE_DESC)
    select DD_TCP_ID, DD_TCP_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_TCP_TIPO_COBRO_PAGO TCP
	where not exists (select 1 from D_EXP_TIPO_COBRO EXP WHERE EXP.TIPO_COBRO_EXPEDIENTE_ID = TCP.DD_TCP_ID)';
	EXECUTE IMMEDIATE (V_SQL);	
	
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('D_EXP_TIPO_COBRO');

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_COBRO_FACTURADO
-- ----------------------------------------------------------------------------------------------  
  EXECUTE IMMEDIATE 'insert into D_EXP_COBRO_FACTURADO (COBRO_FACTURADO_ID, COBRO_FACTURADO_DESC) select -1, ''Desconocido'' from dual where not exists (select 1 from D_EXP_COBRO_FACTURADO where COBRO_FACTURADO_ID = -1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_COBRO_FACTURADO (COBRO_FACTURADO_ID, COBRO_FACTURADO_DESC) select 0, ''No Facturado'' from dual where not exists (select 1 from D_EXP_COBRO_FACTURADO where COBRO_FACTURADO_ID = 0)';
  EXECUTE IMMEDIATE 'insert into D_EXP_COBRO_FACTURADO (COBRO_FACTURADO_ID, COBRO_FACTURADO_DESC) select 1, ''Facturado'' from dual where not exists (select 1 from D_EXP_COBRO_FACTURADO where COBRO_FACTURADO_ID = 1)';

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('D_EXP_COBRO_FACTURADO');

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_REMESA_FACTURA
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_REMESA_FACTURA WHERE REMESA_FACTURA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_REMESA_FACTURA (REMESA_FACTURA_ID, REMESA_FACTURA_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_REMESA_FACTURA (REMESA_FACTURA_ID, REMESA_FACTURA_DESC)
    select PRF_ID, PRF_NOMBRE from ' || V_SCHEMA_DS || '.PRF_PROCESO_FACTURACION PRF
	where not exists (select 1 from D_EXP_REMESA_FACTURA EXP WHERE EXP.REMESA_FACTURA_ID = PRF.PRF_ID)';
	EXECUTE IMMEDIATE (V_SQL);	

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('D_EXP_REMESA_FACTURA');
   
  */ 
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_MOTIVO_SALIDA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_MOTIVO_SALIDA WHERE MOTIVO_SALIDA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_MOTIVO_SALIDA (MOTIVO_SALIDA_ID, MOTIVO_SALIDA_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_MOTIVO_SALIDA (MOTIVO_SALIDA_ID, MOTIVO_SALIDA_DESC)
    select DD_MOB_ID, DD_MOB_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_MOB_MOTIVOS_BAJA MOB
	where MOB.DD_MOB_ID is not null and not exists (select 1 from D_EXP_MOTIVO_SALIDA EXP WHERE EXP.MOTIVO_SALIDA_ID = MOB.DD_MOB_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_MOTIVO_SALIDA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
          
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_PALANCA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_TIPO_PALANCA WHERE TIPO_PALANCA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_TIPO_PALANCA (TIPO_PALANCA_ID, TIPO_PALANCA_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_TIPO_PALANCA (TIPO_PALANCA_ID, TIPO_PALANCA_DESC)
    select RCF_TPP_ID, RCF_TPP_DESCRIPCION from ' || V_SCHEMA_DS || '.RCF_TPP_TIPO_PALANCA RFC
	where RFC.RCF_TPP_ID is not null and not exists (select 1 from D_EXP_TIPO_PALANCA EXP WHERE EXP.TIPO_PALANCA_ID = RFC.RCF_TPP_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_TIPO_PALANCA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
    
 /*
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ESTADO_PALANCA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_ESTADO_PALANCA where ESTADO_PALANCA_ID = -1) = 0) then
	insert into D_EXP_ESTADO_PALANCA (ESTADO_PALANCA_ID, ESTADO_PALANCA_DESC) values (-1 ,'Desconocido');
end if;
 insert into D_EXP_ESTADO_PALANCA (ESTADO_PALANCA_ID, ESTADO_PALANCA_DESC)
    select id_estado_palanca, desc_estado_palanca from recovery_bankia_datastage.expedientes_fake where id_estado_palanca is not null group by id_estado_palanca;
     
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('D_EXP_ESTADO_PALANCA');
  
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_SANCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_TIPO_SANCION where TIPO_SANCION_ID = -1) = 0) then
	insert into D_EXP_TIPO_SANCION (TIPO_SANCION_ID, TIPO_SANCION_DESC) values (-1 ,'Desconocido');
end if;
 insert into D_EXP_TIPO_SANCION (TIPO_SANCION_ID, TIPO_SANCION_DESC)
    select id_tipo_sancion, desc_tipo_sancion from recovery_bankia_datastage.expedientes_fake where id_tipo_sancion is not null group by id_tipo_sancion;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('D_EXP_TIPO_SANCION');
  */   
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_TIPO_INCIDENCIA WHERE TIPO_INCIDENCIA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_TIPO_INCIDENCIA (TIPO_INCIDENCIA_ID, TIPO_INCIDENCIA_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_TIPO_INCIDENCIA (TIPO_INCIDENCIA_ID, TIPO_INCIDENCIA_DESC)
    select DD_TII_ID, DD_TII_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_TII_TIPO_INCIDENCIA TII
	where TII.DD_TII_ID is not null and not exists (select 1 from D_EXP_TIPO_INCIDENCIA EXP WHERE EXP.TIPO_INCIDENCIA_ID = TII.DD_TII_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_TIPO_INCIDENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
     
/*     
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ESTADO_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_ESTADO_INCIDENCIA where ESTADO_INCIDENCIA_ID = -1) = 0) then
	insert into D_EXP_ESTADO_INCIDENCIA (ESTADO_INCIDENCIA_ID, ESTADO_INCIDENCIA_DESC) values (-1 ,'Desconocido');
end if;
 insert into D_EXP_ESTADO_INCIDENCIA (ESTADO_INCIDENCIA_ID, ESTADO_INCIDENCIA_DESC)
    select id_estado_incidencia, desc_estado_incidencia from recovery_bankia_datastage.expedientes_fake where id_estado_incidencia is not null group by id_estado_incidencia;
    
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('D_EXP_ESTADO_INCIDENCIA');
*/

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_T_ROTACIONES
-- ----------------------------------------------------------------------------------------------  
  EXECUTE IMMEDIATE 'insert into D_EXP_T_ROTACIONES (T_ROTACIONES_EXP_ID, T_ROTACIONES_EXP_DESC) select -1, ''Sin Rotaciones'' from dual where not exists (select 1 from D_EXP_T_ROTACIONES where T_ROTACIONES_EXP_ID = -1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_ROTACIONES (T_ROTACIONES_EXP_ID, T_ROTACIONES_EXP_DESC) select 0, ''1 Rotación'' from dual where not exists (select 1 from D_EXP_T_ROTACIONES where T_ROTACIONES_EXP_ID = 0)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_ROTACIONES (T_ROTACIONES_EXP_ID, T_ROTACIONES_EXP_DESC) select 1, ''2 Rotaciones'' from dual where not exists (select 1 from D_EXP_T_ROTACIONES where T_ROTACIONES_EXP_ID = 1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_ROTACIONES (T_ROTACIONES_EXP_ID, T_ROTACIONES_EXP_DESC) select 2, ''3 Rotaciones'' from dual where not exists (select 1 from D_EXP_T_ROTACIONES where T_ROTACIONES_EXP_ID = 2)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_ROTACIONES (T_ROTACIONES_EXP_ID, T_ROTACIONES_EXP_DESC) select 3, ''4 Rotaciones'' from dual where not exists (select 1 from D_EXP_T_ROTACIONES where T_ROTACIONES_EXP_ID = 3)';
  EXECUTE IMMEDIATE 'insert into D_EXP_T_ROTACIONES (T_ROTACIONES_EXP_ID, T_ROTACIONES_EXP_DESC) select 4, ''>= 5 Rotaciones'' from dual where not exists (select 1 from D_EXP_T_ROTACIONES where T_ROTACIONES_EXP_ID = 4)';

  COMMIT;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_T_ROTACIONES. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TD_ENTRADA_GESTION
-- ----------------------------------------------------------------------------------------------  
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID, TD_ENTRADA_GEST_EXP_DESC) select -1, ''Desconocido'' from dual where not exists (select 1 from D_EXP_TD_ENTRADA_GESTION where TD_ENTRADA_GEST_EXP_ID = -1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID, TD_ENTRADA_GEST_EXP_DESC) select 0, ''<= 15 Días'' from dual where not exists (select 1 from D_EXP_TD_ENTRADA_GESTION where TD_ENTRADA_GEST_EXP_ID = 0)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID, TD_ENTRADA_GEST_EXP_DESC) select 1, ''16-30 Días'' from dual where not exists (select 1 from D_EXP_TD_ENTRADA_GESTION where TD_ENTRADA_GEST_EXP_ID = 1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID, TD_ENTRADA_GEST_EXP_DESC) select 2, ''31-60 Días'' from dual where not exists (select 1 from D_EXP_TD_ENTRADA_GESTION where TD_ENTRADA_GEST_EXP_ID = 2)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID, TD_ENTRADA_GEST_EXP_DESC) select 3, ''61-90 Días'' from dual where not exists (select 1 from D_EXP_TD_ENTRADA_GESTION where TD_ENTRADA_GEST_EXP_ID = 3)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID, TD_ENTRADA_GEST_EXP_DESC) select 4, ''91-120 Días'' from dual where not exists (select 1 from D_EXP_TD_ENTRADA_GESTION where TD_ENTRADA_GEST_EXP_ID = 4)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_ENTRADA_GESTION (TD_ENTRADA_GEST_EXP_ID, TD_ENTRADA_GEST_EXP_DESC) select 5, ''>= 121 Días'' from dual where not exists (select 1 from D_EXP_TD_ENTRADA_GESTION where TD_ENTRADA_GEST_EXP_ID = 5)';

  COMMIT;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_TD_ENTRADA_GESTION. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TD_CREACION_EXP_COBRO
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID, TD_CREACION_EXP_COBRO_DESC) select -1, ''Desconocido'' from dual where not exists (select 1 from D_EXP_TD_CREACION_EXP_COBRO where TD_CREACION_EXP_COBRO_ID = -1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID, TD_CREACION_EXP_COBRO_DESC) select 0, ''<= 15 Días'' from dual where not exists (select 1 from D_EXP_TD_CREACION_EXP_COBRO where TD_CREACION_EXP_COBRO_ID = 0)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID, TD_CREACION_EXP_COBRO_DESC) select 1, ''16-30 Días'' from dual where not exists (select 1 from D_EXP_TD_CREACION_EXP_COBRO where TD_CREACION_EXP_COBRO_ID = 1)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID, TD_CREACION_EXP_COBRO_DESC) select 2, ''31-60 Días'' from dual where not exists (select 1 from D_EXP_TD_CREACION_EXP_COBRO where TD_CREACION_EXP_COBRO_ID = 2)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID, TD_CREACION_EXP_COBRO_DESC) select 3, ''61-90 Días'' from dual where not exists (select 1 from D_EXP_TD_CREACION_EXP_COBRO where TD_CREACION_EXP_COBRO_ID = 3)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID, TD_CREACION_EXP_COBRO_DESC) select 4, ''91-120 Días'' from dual where not exists (select 1 from D_EXP_TD_CREACION_EXP_COBRO where TD_CREACION_EXP_COBRO_ID = 4)';
  EXECUTE IMMEDIATE 'insert into D_EXP_TD_CREACION_EXP_COBRO (TD_CREACION_EXP_COBRO_ID, TD_CREACION_EXP_COBRO_DESC) select 5, ''>= 121 Días'' from dual where not exists (select 1 from D_EXP_TD_CREACION_EXP_COBRO where TD_CREACION_EXP_COBRO_ID = 5)';

  COMMIT;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_TD_CREACION_EXP_COBRO. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_RESULTADO_GESTION
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_RESULTADO_GESTION WHERE RESULTADO_GESTION_EXP_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_RESULTADO_GESTION (RESULTADO_GESTION_EXP_ID, RESULTADO_GESTION_EXP_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;
  
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_RESULTADO_GESTION WHERE RESULTADO_GESTION_EXP_ID = -2;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_RESULTADO_GESTION (RESULTADO_GESTION_EXP_ID, RESULTADO_GESTION_EXP_DESC) values (-2 ,''Sin Gestión'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;
  
	V_SQL :=  'insert into D_EXP_RESULTADO_GESTION (RESULTADO_GESTION_EXP_ID, RESULTADO_GESTION_EXP_DESC)
    select DD_RGT_ID, DD_RGT_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_RGT_RESULT_GESTION_TEL rgt
	where rgt.DD_RGT_ID is not null and not exists (select 1 from D_EXP_RESULTADO_GESTION exp WHERE exp.RESULTADO_GESTION_EXP_ID = rgt.DD_RGT_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_RESULTADO_GESTION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
	
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_RESULTADO_GESTION_CNT
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_RESULTADO_GESTION_CNT WHERE RESULTADO_GESTION_EXP_CNT_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_RESULTADO_GESTION_CNT (RESULTADO_GESTION_EXP_CNT_ID, RESULTADO_GESTION_EXP_CNT_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_RESULTADO_GESTION_CNT WHERE RESULTADO_GESTION_EXP_CNT_ID = -2;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_RESULTADO_GESTION_CNT (RESULTADO_GESTION_EXP_CNT_ID, RESULTADO_GESTION_EXP_CNT_DESC) values (-2 ,''Sin Gestión'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;
  
	V_SQL :=  'insert into D_EXP_RESULTADO_GESTION_CNT (RESULTADO_GESTION_EXP_CNT_ID, RESULTADO_GESTION_EXP_CNT_DESC)
    select DD_RGT_ID, DD_RGT_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_RGT_RESULT_GESTION_TEL rgt
	where rgt.DD_RGT_ID is not null and not exists (select 1 from D_EXP_RESULTADO_GESTION_CNT exp WHERE exp.RESULTADO_GESTION_EXP_CNT_ID = rgt.DD_RGT_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_RESULTADO_GESTION_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_MODELOS_FACTURACION
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_MODELOS_FACTURACION WHERE MODELOS_FACT_EXP_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_MODELOS_FACTURACION (MODELOS_FACT_EXP_ID, MODELOS_FACT_EXP_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_MODELOS_FACTURACION (MODELOS_FACT_EXP_ID, MODELOS_FACT_EXP_DESC)
    select RCF_MFA_ID, RCF_MFA_NOMBRE from ' || V_SCHEMA_DS || '.RCF_MFA_MODELOS_FACTURACION MFA
	where not exists (select 1 from D_EXP_MODELOS_FACTURACION EXP WHERE EXP.MODELOS_FACT_EXP_ID = MFA.RCF_MFA_ID)';
	EXECUTE IMMEDIATE (V_SQL);
	
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_MODELOS_FACTURACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_GESTION
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_TIPO_GESTION WHERE TIPO_GESTION_EXP_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_TIPO_GESTION (TIPO_GESTION_EXP_ID, TIPO_GESTION_EXP_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_TIPO_GESTION (TIPO_GESTION_EXP_ID, TIPO_GESTION_EXP_DESC)
    select  DD_TGE_ID, DD_TGE_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_TGE_TIPO_GESTION tge
	where not exists (select 1 from D_EXP_TIPO_GESTION exp WHERE exp.TIPO_GESTION_EXP_ID = tge.DD_TGE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_TIPO_GESTION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
 -- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_GESTION_CNT
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_EXP_TIPO_GESTION_CNT WHERE TIPO_GESTION_EXP_CNT_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_EXP_TIPO_GESTION_CNT (TIPO_GESTION_EXP_CNT_ID, TIPO_GESTION_EXP_CNT_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_EXP_TIPO_GESTION_CNT (TIPO_GESTION_EXP_CNT_ID, TIPO_GESTION_EXP_CNT_DESC)
    select  DD_TGE_ID, DD_TGE_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_TGE_TIPO_GESTION tge
	where not exists (select 1 from D_EXP_TIPO_GESTION_CNT exp WHERE exp.TIPO_GESTION_EXP_CNT_ID = tge.DD_TGE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_TIPO_GESTION_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_MOTIVO_BAJA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_MOTIVO_BAJA_CR where MOTIVO_BAJA_EXP_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_MOTIVO_BAJA_CR (MOTIVO_BAJA_EXP_CR_ID, MOTIVO_BAJA_EXP_CR_DESC) values (-1 ,'Desconocido');
  end if;
  
  execute immediate
    'insert into D_EXP_MOTIVO_BAJA_CR (MOTIVO_BAJA_EXP_CR_ID, MOTIVO_BAJA_EXP_CR_DESC)
     select DD_MOB_ID, DD_MOB_DESCRIPCION from ' || V_SCHEMA_DS || '.DD_MOB_MOTIVOS_BAJA MOB 
     where MOB.DD_MOB_ID is not null and not exists (select 1 from D_EXP_MOTIVO_BAJA_CR mot where mot.MOTIVO_BAJA_EXP_CR_ID = MOB.DD_MOB_ID)';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_MOTIVO_BAJA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
 
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ESQUEMA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_ESQUEMA_CR where ESQUEMA_EXP_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_ESQUEMA_CR (ESQUEMA_EXP_CR_ID, ESQUEMA_EXP_CR_DESC) values (-1 ,'Desconocido');
  end if;
  
  execute immediate
    'insert into D_EXP_ESQUEMA_CR (ESQUEMA_EXP_CR_ID, ESQUEMA_EXP_CR_DESC)
     select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_SCHEMA_DS || '.RCF_ESQ_ESQUEMA RCF
     where not exists (select 1 from D_EXP_ESQUEMA_CR EXP where EXP.ESQUEMA_EXP_CR_ID = RCF.RCF_ESQ_ID)';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ESQUEMA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
   
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_CARTERA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_CARTERA_CR where CARTERA_EXP_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_CARTERA_CR (CARTERA_EXP_CR_ID, CARTERA_EXP_CR_DESC) values (-1 ,'Desconocido');
  end if;
  
  execute immediate
    'insert into  D_EXP_CARTERA_CR (CARTERA_EXP_CR_ID, CARTERA_EXP_CR_DESC) 
     select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_SCHEMA_DS || '.RCF_CAR_CARTERA RCF
     where not exists (select 1 from D_EXP_CARTERA_CR EXP where EXP.CARTERA_EXP_CR_ID = RCF.RCF_CAR_ID)';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_CARTERA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
  
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_SUBCARTERA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_SUBCARTERA_CR where SUBCARTERA_EXP_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_SUBCARTERA_CR (SUBCARTERA_EXP_CR_ID, SUBCARTERA_EXP_CR_DESC, CARTERA_EXP_CR_ID) values (-1 ,'Desconocido', -1);
  end if;
  
  execute immediate
    'insert into D_EXP_SUBCARTERA_CR (SUBCARTERA_EXP_CR_ID, SUBCARTERA_EXP_CR_DESC, CARTERA_EXP_CR_ID)
      select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID  
      from ' || V_SCHEMA_DS || '.RCF_SCA_SUBCARTERA SUB
      INNER JOIN ' || V_SCHEMA_DS || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
      INNER JOIN ' || V_SCHEMA_DS || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
      where not exists (select 1 from D_EXP_SUBCARTERA_CR EXP where EXP.SUBCARTERA_EXP_CR_ID = SUB.RCF_SCA_ID)';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_SUBCARTERA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
   
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_AGENCIA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_AGENCIA_CR where AGENCIA_EXP_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_AGENCIA_CR (AGENCIA_EXP_CR_ID, AGENCIA_EXP_CR_DESC) values (-1 ,'Desconocido');
  end if;
  
  execute immediate
    'insert into D_EXP_AGENCIA_CR (AGENCIA_EXP_CR_ID, AGENCIA_EXP_CR_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_SCHEMA_DS || '.RCF_AGE_AGENCIAS RCF	where not exists (select 1 from D_EXP_AGENCIA_CR EXP where EXP.AGENCIA_EXP_CR_ID = RCF.RCF_AGE_ID)';
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_AGENCIA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
   
   
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ENVIADO_AGENCIA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_EXP_ENVIADO_AGENCIA_CR where ENVIADO_AGENCIA_EXP_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_ENVIADO_AGENCIA_CR (ENVIADO_AGENCIA_EXP_CR_ID, ENVIADO_AGENCIA_EXP_CR_DESC) values (-1 ,'Desconocido');
  end if;
  
  select count(*) into V_NUM_ROW from D_EXP_ENVIADO_AGENCIA_CR where ENVIADO_AGENCIA_EXP_CR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_ENVIADO_AGENCIA_CR (ENVIADO_AGENCIA_EXP_CR_ID, ENVIADO_AGENCIA_EXP_CR_DESC) values (0 ,'No Enviado a Agencia');
  end if;
  select count(*) into V_NUM_ROW from D_EXP_ENVIADO_AGENCIA_CR where ENVIADO_AGENCIA_EXP_CR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_EXP_ENVIADO_AGENCIA_CR (ENVIADO_AGENCIA_EXP_CR_ID, ENVIADO_AGENCIA_EXP_CR_DESC) values (1 ,'Enviado a Agencia');
  end if; 
  
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP_ENVIADO_AGENCIA_CR. Realizados INSERTS', 3;
    


  
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP
-- ---------------------------------------------------------------------------------------------- 
  SELECT COUNT(1) INTO V_NUM_TABLE FROM USER_TABLES WHERE TABLE_NAME = 'D_EXP';
   
  EXECUTE IMMEDIATE '
  insert into D_EXP
   (EXPEDIENTE_ID,
    EXPEDIENTE_DESC,
    ACTITUD_ID,
    ARQUETIPO_EXPEDIENTE_ID,
 -- CAUSA_IMPAGO_ID,
    COMITE_ID,
    DECISION_ID,
    ESTADO_EXPEDIENTE_ID,
    ESTADO_ITINERARIO_ID,
    OFICINA_EXPEDIENTE_ID
 -- PROPUESTA_ID
   )
  select EXPE.EXP_ID, 
        coalesce(EXPE.EXP_DESCRIPCION, ''Desconocido''),
        coalesce(TAA.DD_TAA_ID, -1),
        coalesce(EXPE.ARQ_ID, -1),
     -- coalesce(EXPE.DD_CIM_ID, -1),
        coalesce(EXPE.COM_ID, -1),
        coalesce(EXPE.DCO_ID, -1),
        coalesce(EXPE.DD_EEX_ID, -1),
        coalesce(EXPE.DD_EST_ID, -1),
        coalesce(EXPE.OFI_ID, -1)
     -- coalesce(EXPE.DD_PRA_ID, -1)
  from ' || V_SCHEMA_DS || '.EXP_EXPEDIENTES EXPE
  left join ' || V_SCHEMA_DS || '.AAA_ACTITUD_APTITUD_ACTUACION AAA ON EXPE.AAA_ID = AAA.AAA_ID
  LEFT JOIN ' || V_SCHEMA_DS || '.DD_TAA_TIPO_AYUDA_ACTUACION TAA ON AAA.DD_TAA_ID = TAA.DD_TAA_ID
  WHERE NOT EXISTS (SELECT 1 FROM D_EXP WHERE D_EXP.EXPEDIENTE_ID = EXPE.EXP_ID)'; 
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_EXP. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;




  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
EXCEPTION
  WHEN OBJECTEXISTS THEN
    --O_ERROR_STATUS := 'La tabla ya existe';
    DBMS_OUTPUT.PUT_LINE('La tabla ya existe');
    --ROLLBACK;
  WHEN INSERT_NULL THEN
    --O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    DBMS_OUTPUT.PUT_LINE('Has intentado insertar un valor nulo');
    --ROLLBACK;    
  WHEN PARAMETERS_NUMBER THEN
    --O_ERROR_STATUS := 'Número de parámetros incorrecto';
    DBMS_OUTPUT.PUT_LINE('Número de parámetros incorrecto');
    --ROLLBACK;*/    
  WHEN OTHERS THEN
    --O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
	DBMS_OUTPUT.PUT_LINE('Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM);
    --ROLLBACK;



END;
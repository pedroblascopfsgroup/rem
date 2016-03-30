create or replace PROCEDURE CARGAR_DIM_CONTRATO(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creacion: Septiembre 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 28/03/2016
-- Motivos del cambio: Corrijo GARANTIA_CONTRATO
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension contrato
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN CONTRATO
  -- D_CNT_CATALOGO_DETALLE_1;
  -- D_CNT_CATALOGO_DETALLE_2 ;
  -- D_CNT_CATALOGO_DETALLE_3 ;
  -- D_CNT_CATALOGO_DETALLE_4 ;
  -- D_CNT_CATALOGO_DETALLE_5 ;
  -- D_CNT_CATALOGO_DETALLE_6 ;
  -- D_CNT_ESTADO_CONTRATO ;
  -- D_CNT_ESTADO_FINANCIERO;
  -- D_CNT_ESTADO_FINANCIERO_AGR;
  -- D_CNT_ESTADO_FINANCIERO_ANT;
  -- D_CNT_ESTADO_FIN_ANT_AGR;
  -- D_CNT_FINALIDAD_CONTRATO ;
  -- D_CNT_FINALIDAD_OFICIAL ;
  -- D_CNT_GARANTIA_CONTABLE ;
  -- D_CNT_GARANTIA_CONTRATO ;
  -- D_CNT_JUDICIALIZADO;
  -- D_CNT_MONEDA ;
  -- D_CNT_NIVEL ;
  -- D_CNT_OFICINA;
  -- D_CNT_PRODUCTO;
  -- D_CNT_PROVINCIA;
  -- D_CNT_TIPO_PRODUCTO ;
  -- D_CNT_ZONA ;
  -- D_CNT_NACIONALIDAD_TITULAR ;
  -- D_CNT_POLITICA_TITULAR ;
  -- D_CNT_SEGMENTO_TITULAR ;
  -- D_CNT_SEXO_TITULAR ;
  -- D_CNT_SITUACION;
  -- D_CNT_SITUACION_DETALLE;
  -- D_CNT_SITUACION_ANTERIOR;
  -- D_CNT_SITUACION_ANT_DETALLE;
  -- D_CNT_SITUACION_RESP_PER_ANT;
  -- D_CNT_TIPO_PERSONA_TITULAR;
  -- D_CNT_EST_INSINUACION_CNT;
  -- D_CNT_CARTERA;
  -- D_CNT_T_IRREG_DIAS;
  -- D_CNT_T_IRREG_FASES;
  -- D_CNT_T_IRREG_FASES_AGR;
  -- D_CNT_T_IRREG_DIAS_PERIODO_ANT;
  -- D_CNT_T_IRREG_FASES_PER_ANT;
  -- D_CNT_T_IRREG_F_AGR_PER_ANT;
  -- D_CNT_TD_EN_GESTION_A_COBRO;
  -- D_CNT_TD_IRREGULAR_A_COBRO;
  -- D_CNT_GARANTIA_CONTRATO_AGR ;
  -- D_CNT_SEGMENTO_TITULAR_AGR;
  -- D_CNT_EN_GESTION_RECOBRO ;
  -- D_CNT_RESULTADO_ACTUACION;
  -- D_CNT_EN_IRREGULAR;
  -- D_CNT_MODELO_RECOBRO;
  -- D_CNT_PROVEEDOR_RECOBRO;
  -- D_CNT_CON_DPS;
  -- D_CNT_CON_ACTUACION_RECOBRO;
  -- D_CNT_EST_FIN_INI_CAMP_REC;
  -- D_CNT_EST_FIN_ANT_INI_CAMP_REC;
  -- D_CNT_EN_GEST_REC_INI_CAMP_REC;
  -- D_CNT_EN_IRREG_INI_CAMP_REC;
  -- D_CNT_MODELO_REC_INI_CAMP_REC;
  -- D_CNT_PROV_REC_INI_CAMP_REC;
  -- D_CNT_T_IRREG_D_INI_CAMP_REC;
  -- D_CNT_T_IRREG_F_INI_CAMP_REC ;
  -- D_CNT_T_IRREG_F_AGR_INI_REC;
  -- D_CNT_EN_GESTION_ESPEC ;
  -- D_CNT_CON_PREVISION ;
  -- D_CNT_CON_PREVISION_REVISADA;
  -- D_CNT_TIPO_PREVISION ;
  -- D_CNT_PREV_SITUACION_INICIAL ;
  -- D_CNT_PREV_SITUACION_AUTO ;
  -- D_CNT_PREV_SITUACION_MANUAL;
  -- D_CNT_PREV_SITUACION_FINAL;
  -- D_CNT_MOTIVO_PREVISION;
  -- D_CNT_SITUACION_ESPECIALIZADA;
  -- D_CNT_GESTOR_ESPECIALIZADA;
  -- D_CNT_SUPERVISOR_N1_ESPEC;
  -- D_CNT_SUPERVISOR_N2_ESPEC;
  -- D_CNT_SUPERVISOR_N3_ESPEC;
  -- D_CNT_EN_CARTERA_ESTUDIO;
  -- D_CNT_MODELO_GESTION_CARTERA;
  -- D_CNT_UNIDAD_GESTION_CARTERA;
  -- D_CNT_CON_CAPITAL_FALLIDO;
  -- D_CNT_TIPO_GESTION;
  -- D_CNT_ESQUEMA;
  -- D_CNT_AGENCIA;
  -- D_CNT_CARTERA_EXPEDIENTE;
  -- D_CNT_SUBCARTERA_EXPEDIENTE;
  -- D_CNT_TIPO_SALIDA_EXPEDIENTE;
  -- D_CNT_MOTIVO_SALIDA_EXP;
  -- D_CNT_TIPO_INCIDENCIA_EXP;
  -- D_CNT_ESTADO_INCIDENCIA_EXP;
  -- D_CNT_T_SALDO_TOTAL;
  -- D_CNT_T_SALDO_IRREGULAR;
  -- D_CNT_T_DEUDA_IRREGULAR
  -- D_CNT_TIPO_COBRO
  -- D_CNT_TIPO_COBRO_DETALLE
  -- D_CNT_COBRO_FACTURADO
  -- D_CNT_REMESA_FACTURA
  -- D_CNT_CLASIFICACION
  -- D_CNT_SEGMENTO_CARTERA
  -- D_CNT_ENVIADO_AGENCIA
  -- D_CNT_ESQUEMA_COBRO
  -- D_CNT_CARTERA_COBRO
  -- D_CNT_SUBCARTERA_COBRO
  -- D_CNT_AGENCIA_COBRO
  -- D_CNT_TIPO_PRODUCTO_COBRO
  -- D_CNT_GARANTIA_COBRO
  -- D_CNT_SEGMENTO_CARTERA_COBRO
  -- D_CNT_TD_IRREG_COBRO
  -- D_CNT_T_DEUDA_IRREGULAR_COBRO
  -- D_CNT_ENVIADO_AGENCIA_COBRO
  -- D_CNT_FACTURA_COBRO
  -- D_CNT_MOTIVO_BAJA_CR
  -- D_CNT_ESQUEMA_CR
  -- D_CNT_CARTERA_CR
  -- D_CNT_SUBCARTERA_CR
  -- D_CNT_AGENCIA_CR
  -- D_CNT_SEGMENTO_CARTERA_CR
  -- D_CNT_ENVIADO_AGENCIA_CR
  -- D_CNT_ESTADO_ACUERDO
  -- D_CNT_SOLICITANTE_ACUERDO
  -- D_CNT_TIPO_ACUERDO
	-- D_CNT_ESQUEMA_ACUERDO
  -- D_CNT_CARTERA_ACUERDO
  -- D_CNT_SUBCARTERA_ACUERDO
  -- D_CNT_AGENCIA_ACUERDO
  -- D_CNT_ENVIADO_AGENCIA_ACUERDO
  -- D_CNT_TIPO_INCIDENCIA
  -- D_CNT_SITUACION_INCIDENCIA
  -- D_CNT_ESQUEMA_INCIDENCIA
  -- D_CNT_CARTERA_INCIDENCIA
  -- D_CNT_SUBCARTERA_INCIDENCIA
  -- D_CNT_AGENCIA_INCIDENCIA
  -- D_CNT_ENVIADO_AGENCIA_INCI
  -- D_CNT_ESQUEMA_ER
  -- D_CNT_CARTERA_ER
  -- D_CNT_SUBCARTERA_ER
  -- D_CNT_AGENCIA_ER
  -- D_CNT_GESTOR_CREDITO
  -- D_CNT_DESPACHO_GESTOR_CREDITO
  -- D_CNT_ESTADO_INSI_CREDITO
  -- D_CNT_CALIF_INICIAL_CREDITO
  -- D_CNT_CALIF_GESTOR_CREDITO
  -- D_CNT_CALIF_FINAL_CREDITO
  -- D_CNT_TRAMO_RIESGO
  -- D_CNT_TA_FECHA_CREACION
  -- D_CNT_PERIMETRO_GESTION
  -- D_CNT_PERIMETRO_SIN_GESTION
  -- D_CNT_PERIMETRO_EXP_SEG
  -- D_CNT_PERIMETRO_EXP_REC
  -- D_CNT_PERIMETRO_GES_EXTRA
  -- D_CNT_PERIMETRO_GES_PRE
  -- D_CNT_PERIMETRO_GES_JUDI
  -- D_CNT_PERIMETRO_GES_CONCU    
  -- D_CNT_MOTIVO_BAJA_DUDOSO
  -- D_CNT_MOTIVO_ALTA_DUDOSO
  -- D_CNT_T_ANTIGUEDAD_DEUDA
  -- D_CNT_SITUACION_CARTERA_DANADA
  -- D_CNT_TIPO_GESTION_EXP
  -- D_CNT_TIPO_VENCIDO
  -- D_CNT_TRAMO_CAP_VIVO
  -- D_CNT_DIR_TERRITORIAL
  -- D_CNT_ENTIDAD
  -- D_CNT_PERIMETRO_GESTION_CM
  -- D_CNT_MOTIVO_COBRO
  -- D_CNT_TITULAR
  -- D_CNT_APLICATIVO_ORIGEN
  -- D_CNT_TIPO_SOL_PREVISTA
  -- D_CNT;
  
BEGIN
DECLARE


OBJECTEXISTS EXCEPTION;
INSERT_NULL EXCEPTION;
PARAMETERS_NUMBER EXCEPTION;
PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

V_NUM_ROW NUMBER(10);

V_DATASTAGE VARCHAR2(100);
V_DESCONOCIDO VARCHAR(25) := 'Desconocido';
V_SQL VARCHAR2(4000);
V_MSQL VARCHAR(5000);

IDFACTURACION INT;
NOMBRE_FACTURACION VARCHAR(500);
ncount NUMBER;
c_facturacion SYS_REFCURSOR;

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_CONTRATO';
V_ROWCOUNT NUMBER;

BEGIN

  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CATALOGO_DETALLE_1
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CATALOGO_DETALLE_1 where CATALOGO_DETALLE_1_ID = -1;
  if (V_NUM_ROW  = 0) then
    insert into D_CNT_CATALOGO_DETALLE_1 (CATALOGO_DETALLE_1_ID, CATALOGO_DETALLE_1_DESC, CATALOGO_DETALLE_1_DESC_2)
    values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_CATALOGO_DETALLE_1(CATALOGO_DETALLE_1_ID, CATALOGO_DETALLE_1_DESC, CATALOGO_DETALLE_1_DESC_2)
     select DD_CT1_ID, DD_CT1_DESCRIPCION, DD_CT1_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_CT1_CATALOGO_1';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CATALOGO_DETALLE_1. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT) , 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CATALOGO_DETALLE_2
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CATALOGO_DETALLE_2 where CATALOGO_DETALLE_2_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CATALOGO_DETALLE_2 (CATALOGO_DETALLE_2_ID, CATALOGO_DETALLE_2_DESC, CATALOGO_DETALLE_2_DESC_2, CATALOGO_DETALLE_1_ID)
    values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_CATALOGO_DETALLE_2(CATALOGO_DETALLE_2_ID, CATALOGO_DETALLE_2_DESC, CATALOGO_DETALLE_2_DESC_2, CATALOGO_DETALLE_1_ID)
    select DD_CT2_ID, DD_CT2_DESCRIPCION, DD_CT2_DESCRIPCION_LARGA, DD_CT1_ID from '||V_DATASTAGE||'.DD_CT2_CATALOGO_2';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CATALOGO_DETALLE_2. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CATALOGO_DETALLE_3
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CATALOGO_DETALLE_3 where CATALOGO_DETALLE_3_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CATALOGO_DETALLE_3 (CATALOGO_DETALLE_3_ID, CATALOGO_DETALLE_3_DESC, CATALOGO_DETALLE_3_DESC_2, CATALOGO_DETALLE_2_ID)
    values (-1 ,'Desconocido', 'Desconocido',-1);
  end if;

  execute immediate
  'insert into D_CNT_CATALOGO_DETALLE_3(CATALOGO_DETALLE_3_ID, CATALOGO_DETALLE_3_DESC, CATALOGO_DETALLE_3_DESC_2, CATALOGO_DETALLE_2_ID)
   select DD_CT3_ID, DD_CT3_DESCRIPCION, DD_CT3_DESCRIPCION_LARGA, DD_CT2_ID from '||V_DATASTAGE||'.DD_CT3_CATALOGO_3';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CATALOGO_DETALLE_3. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CATALOGO_DETALLE_4
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CATALOGO_DETALLE_4 where CATALOGO_DETALLE_4_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CATALOGO_DETALLE_4 (CATALOGO_DETALLE_4_ID, CATALOGO_DETALLE_4_DESC, CATALOGO_DETALLE_4_DESC_2, CATALOGO_DETALLE_3_ID)
    values (-1 ,'Desconocido', 'Desconocido',-1);
  end if;

  execute immediate
  'insert into D_CNT_CATALOGO_DETALLE_4(CATALOGO_DETALLE_4_ID, CATALOGO_DETALLE_4_DESC, CATALOGO_DETALLE_4_DESC_2, CATALOGO_DETALLE_3_ID)
    select DD_CT4_ID, DD_CT4_DESCRIPCION, DD_CT4_DESCRIPCION_LARGA, DD_CT3_ID from '||V_DATASTAGE||'.DD_CT4_CATALOGO_4';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CATALOGO_DETALLE_4. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CATALOGO_DETALLE_5
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CATALOGO_DETALLE_5 where CATALOGO_DETALLE_5_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CATALOGO_DETALLE_5 (CATALOGO_DETALLE_5_ID, CATALOGO_DETALLE_5_DESC, CATALOGO_DETALLE_5_DESC_2, CATALOGO_DETALLE_4_ID)
    values (-1 ,'Desconocido', 'Desconocido',-1);
  end if;

  execute immediate
  'insert into D_CNT_CATALOGO_DETALLE_5(CATALOGO_DETALLE_5_ID, CATALOGO_DETALLE_5_DESC, CATALOGO_DETALLE_5_DESC_2, CATALOGO_DETALLE_4_ID)
    select DD_CT5_ID, DD_CT5_DESCRIPCION, DD_CT5_DESCRIPCION_LARGA, DD_CT4_ID from '||V_DATASTAGE||'.DD_CT5_CATALOGO_5';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CATALOGO_DETALLE_5. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CATALOGO_DETALLE_6
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CATALOGO_DETALLE_6 where CATALOGO_DETALLE_6_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CATALOGO_DETALLE_6 (CATALOGO_DETALLE_6_ID, CATALOGO_DETALLE_6_DESC, CATALOGO_DETALLE_6_DESC_2, CATALOGO_DETALLE_5_ID)
    values (-1 ,'Desconocido', 'Desconocido',-1);
  end if;

  execute immediate
    'insert into D_CNT_CATALOGO_DETALLE_6(CATALOGO_DETALLE_6_ID, CATALOGO_DETALLE_6_DESC, CATALOGO_DETALLE_6_DESC_2, CATALOGO_DETALLE_5_ID)
    select DD_CT6_ID, DD_CT6_DESCRIPCION, DD_CT6_DESCRIPCION_LARGA, DD_CT5_ID from '||V_DATASTAGE||'.DD_CT6_CATALOGO_6';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CATALOGO_DETALLE_6. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESTADO_CONTRATO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_CONTRATO where ESTADO_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_CONTRATO (ESTADO_CONTRATO_ID, ESTADO_CONTRATO_DESC, ESTADO_CONTRATO_DESC_2)
    values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
  'insert into D_CNT_ESTADO_CONTRATO(ESTADO_CONTRATO_ID, ESTADO_CONTRATO_DESC, ESTADO_CONTRATO_DESC_2)
    select DD_ESC_ID, DD_ESC_DESCRIPCION, DD_ESC_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_ESC_ESTADO_CNT';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_CONTRATO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESTADO_FINANCIERO
--                                      D_CNT_ESTADO_FINANCIERO_ANT
-- ----------------------------------------------------------------------------------------------

  -- D_CNT_ESTADO_FINANCIERO
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO where ESTADO_FINANCIERO_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO (ESTADO_FINANCIERO_CNT_ID, ESTADO_FINANCIERO_CNT_DESC, ESTADO_FINANCIERO_CNT_DESC_2, ESTADO_FINANCIERO_CNT_AGR_ID)
    values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_ESTADO_FINANCIERO(ESTADO_FINANCIERO_CNT_ID, ESTADO_FINANCIERO_CNT_DESC, ESTADO_FINANCIERO_CNT_DESC_2)
    select DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_EFC_ESTADO_FINAN_CNT';

  V_ROWCOUNT := sql%rowcount;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_FINANCIERO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


  -- D_CNT_ESTADO_FINANCIERO_ANT (Misma tabla fuente)
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO_ANT where ESTADO_FINANCIERO_ANT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO_ANT (ESTADO_FINANCIERO_ANT_ID, ESTADO_FINANCIERO_ANT_DESC, ESTADO_FINANCIERO_ANT_DESC_2, ESTADO_FINANCIERO_ANT_AGR_ID)
    values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_ESTADO_FINANCIERO_ANT(ESTADO_FINANCIERO_ANT_ID, ESTADO_FINANCIERO_ANT_DESC, ESTADO_FINANCIERO_ANT_DESC_2)
    select DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_EFC_ESTADO_FINAN_CNT';

   V_ROWCOUNT := sql%rowcount;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_FINANCIERO_ANT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


  -- Incluimos ESTADO_FINANCIERO_CNT_AGR_ID y ESTADO_FINANCIERO_ANT_AGR_ID
  -- 0 - NORMAL
  update D_CNT_ESTADO_FINANCIERO SET ESTADO_FINANCIERO_CNT_AGR_ID = 0 where ESTADO_FINANCIERO_CNT_ID IN (101);
  update D_CNT_ESTADO_FINANCIERO_ANT SET ESTADO_FINANCIERO_ANT_AGR_ID = 0 where ESTADO_FINANCIERO_ANT_ID IN (101);
  -- 1 - LITIGIO
  update D_CNT_ESTADO_FINANCIERO SET ESTADO_FINANCIERO_CNT_AGR_ID = 1 where ESTADO_FINANCIERO_CNT_ID IN (102, 105);
  update D_CNT_ESTADO_FINANCIERO_ANT SET ESTADO_FINANCIERO_ANT_AGR_ID = 1 where ESTADO_FINANCIERO_ANT_ID IN (102, 105);
  -- 2 - IMPAGADO
  update D_CNT_ESTADO_FINANCIERO SET ESTADO_FINANCIERO_CNT_AGR_ID = 2 where ESTADO_FINANCIERO_CNT_ID IN (103);
  update D_CNT_ESTADO_FINANCIERO_ANT SET ESTADO_FINANCIERO_ANT_AGR_ID = 2 where ESTADO_FINANCIERO_ANT_ID IN (103);
  -- 3 - DUDOSO
  update D_CNT_ESTADO_FINANCIERO SET ESTADO_FINANCIERO_CNT_AGR_ID = 3 where ESTADO_FINANCIERO_CNT_ID IN (104);
  update D_CNT_ESTADO_FINANCIERO_ANT SET ESTADO_FINANCIERO_ANT_AGR_ID = 3 where ESTADO_FINANCIERO_ANT_ID IN (104);
  -- 4 - FALLIDO
  update D_CNT_ESTADO_FINANCIERO SET ESTADO_FINANCIERO_CNT_AGR_ID = 4 where ESTADO_FINANCIERO_CNT_ID IN (106);
  update D_CNT_ESTADO_FINANCIERO_ANT SET ESTADO_FINANCIERO_ANT_AGR_ID = 4 where ESTADO_FINANCIERO_ANT_ID IN (106);
  -- 4 - Desconocido
  update D_CNT_ESTADO_FINANCIERO SET ESTADO_FINANCIERO_CNT_AGR_ID = -1 where ESTADO_FINANCIERO_CNT_ID is null;
  update D_CNT_ESTADO_FINANCIERO_ANT SET ESTADO_FINANCIERO_ANT_AGR_ID = -1 where ESTADO_FINANCIERO_ANT_ID is null;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_FINANCIERO y D_CNT_ESTADO_FINANCIERO_ANT. Finalizado UPDATES', 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_ESTADO_FINANCIERO_AGR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO_AGR where ESTADO_FINANCIERO_CNT_AGR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO_AGR (ESTADO_FINANCIERO_CNT_AGR_ID, ESTADO_FINANCIERO_CNT_AGR_DESC)
    values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO_AGR where ESTADO_FINANCIERO_CNT_AGR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO_AGR (ESTADO_FINANCIERO_CNT_AGR_ID, ESTADO_FINANCIERO_CNT_AGR_DESC)
    values (0 ,'NORMAL');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO_AGR where ESTADO_FINANCIERO_CNT_AGR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO_AGR (ESTADO_FINANCIERO_CNT_AGR_ID, ESTADO_FINANCIERO_CNT_AGR_DESC)
    values (1 ,'LITIGIO');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO_AGR where ESTADO_FINANCIERO_CNT_AGR_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO_AGR (ESTADO_FINANCIERO_CNT_AGR_ID, ESTADO_FINANCIERO_CNT_AGR_DESC)
    values (2 ,'IMPAGADO');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO_AGR where ESTADO_FINANCIERO_CNT_AGR_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO_AGR (ESTADO_FINANCIERO_CNT_AGR_ID, ESTADO_FINANCIERO_CNT_AGR_DESC)
    values (3 ,'DUDOSO');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FINANCIERO_AGR where ESTADO_FINANCIERO_CNT_AGR_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FINANCIERO_AGR (ESTADO_FINANCIERO_CNT_AGR_ID, ESTADO_FINANCIERO_CNT_AGR_DESC)
    values (4 ,'FALLIDO');
  end if;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_FINANCIERO_AGR. Finalizado INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_ESTADO_FIN_ANT_AGR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FIN_ANT_AGR where ESTADO_FINANCIERO_ANT_AGR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FIN_ANT_AGR (ESTADO_FINANCIERO_ANT_AGR_ID, ESTADO_FINANCIERO_ANT_AGR_DESC)
    values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FIN_ANT_AGR where ESTADO_FINANCIERO_ANT_AGR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FIN_ANT_AGR (ESTADO_FINANCIERO_ANT_AGR_ID, ESTADO_FINANCIERO_ANT_AGR_DESC)
    values (0 ,'NORMAL');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FIN_ANT_AGR where ESTADO_FINANCIERO_ANT_AGR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FIN_ANT_AGR (ESTADO_FINANCIERO_ANT_AGR_ID, ESTADO_FINANCIERO_ANT_AGR_DESC)
    values (1 ,'LITIGIO');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FIN_ANT_AGR where ESTADO_FINANCIERO_ANT_AGR_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FIN_ANT_AGR (ESTADO_FINANCIERO_ANT_AGR_ID, ESTADO_FINANCIERO_ANT_AGR_DESC)
    values (2 ,'IMPAGADO');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FIN_ANT_AGR where ESTADO_FINANCIERO_ANT_AGR_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FIN_ANT_AGR (ESTADO_FINANCIERO_ANT_AGR_ID, ESTADO_FINANCIERO_ANT_AGR_DESC)
    values (3 ,'DUDOSO');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_FIN_ANT_AGR where ESTADO_FINANCIERO_ANT_AGR_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_FIN_ANT_AGR (ESTADO_FINANCIERO_ANT_AGR_ID, ESTADO_FINANCIERO_ANT_AGR_DESC)
    values (4 ,'FALLIDO');
  end if;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_FIN_ANT_AGR. Finalizado INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_FINALIDAD_CONTRATO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_FINALIDAD_CONTRATO where FINALIDAD_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_FINALIDAD_CONTRATO (FINALIDAD_CONTRATO_ID, FINALIDAD_CONTRATO_DESC, FINALIDAD_CONTRATO_DESC_2)
    values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
  'insert into D_CNT_FINALIDAD_CONTRATO(FINALIDAD_CONTRATO_ID, FINALIDAD_CONTRATO_DESC, FINALIDAD_CONTRATO_DESC_2)
  select DD_FCN_ID, DD_FCN_DESCRIPCION, DD_FCN_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_FCN_FINALIDAD_CONTRATO';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_FINALIDAD_CONTRATO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_FINALIDAD_OFICIAL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_FINALIDAD_OFICIAL where FINALIDAD_OFICIAL_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_FINALIDAD_OFICIAL (FINALIDAD_OFICIAL_ID, FINALIDAD_OFICIAL_DESC, FINALIDAD_OFICIAL_DESC_2)
    values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_FINALIDAD_OFICIAL(FINALIDAD_OFICIAL_ID, FINALIDAD_OFICIAL_DESC, FINALIDAD_OFICIAL_DESC_2)
    select DD_FNO_ID, DD_FNO_DESCRIPCION, DD_FNO_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_FNO_FINALIDAD_OFICIAL';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_FINALIDAD_OFICIAL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_GARANTIA_CONTABLE
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_CONTABLE where GARANTIA_CONTABLE_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_CONTABLE (GARANTIA_CONTABLE_ID, GARANTIA_CONTABLE_DESC, GARANTIA_CONTABLE_DESC_2)
    values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_GARANTIA_CONTABLE(GARANTIA_CONTABLE_ID, GARANTIA_CONTABLE_DESC, GARANTIA_CONTABLE_DESC_2)
    select DD_GCO_ID, DD_GCO_DESCRIPCION, DD_GCO_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_GCO_GARANTIA_CONTABLE';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_GARANTIA_CONTABLE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_GARANTIA_CONTRATO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_CONTRATO where GARANTIA_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_CONTRATO (GARANTIA_CONTRATO_ID, GARANTIA_CONTRATO_DESC, GARANTIA_CONTRATO_DESC_2,GARANTIA_CONTRATO_AGR_ID)
    values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

  execute immediate
  'insert into D_CNT_GARANTIA_CONTRATO(GARANTIA_CONTRATO_ID, GARANTIA_CONTRATO_DESC, GARANTIA_CONTRATO_DESC_2)
   select DD_GCN_ID, DD_GCN_DESCRIPCION, DD_GCN_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_GCN_GARANTIA_CONTRATO';

  V_ROWCOUNT := sql%rowcount;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_GARANTIA_CONTRATO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

  -- Incluimos GARANTIA_CONTRATO_AGR_ID
  -- 0 - Real Hipotecaria
  update D_CNT_GARANTIA_CONTRATO SET GARANTIA_CONTRATO_AGR_ID = 0 where GARANTIA_CONTRATO_ID IN (2,3,4,5,1,6,7,8,9,11,10,35);
  -- 1 - Resto
  update D_CNT_GARANTIA_CONTRATO SET GARANTIA_CONTRATO_AGR_ID = 1 where GARANTIA_CONTRATO_ID IN (33,32,31,30,29,27,26,25,28);
  -- 2 - Real Pignoraticias
  update D_CNT_GARANTIA_CONTRATO SET GARANTIA_CONTRATO_AGR_ID = 2 where GARANTIA_CONTRATO_ID IN (13,12,17,21,20,19,18,16,15,23,22,14,24);
  -- 3 - Personal
  update D_CNT_GARANTIA_CONTRATO SET GARANTIA_CONTRATO_AGR_ID = 3 where GARANTIA_CONTRATO_ID IN (34);
  -- 1 - Resto (sin identificar)
  update D_CNT_GARANTIA_CONTRATO SET GARANTIA_CONTRATO_AGR_ID = 1 where GARANTIA_CONTRATO_AGR_ID is null;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_GARANTIA_CONTRATO. Finalizado UPDATES', 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_JUDICIALIZADO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_JUDICIALIZADO where CONTRATO_JUDICIALIZADO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_JUDICIALIZADO (CONTRATO_JUDICIALIZADO_ID, CONTRATO_JUDICIALIZADO_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_JUDICIALIZADO where CONTRATO_JUDICIALIZADO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_JUDICIALIZADO (CONTRATO_JUDICIALIZADO_ID, CONTRATO_JUDICIALIZADO_DESC) values (0 ,'No Judicializado');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_JUDICIALIZADO where CONTRATO_JUDICIALIZADO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_JUDICIALIZADO (CONTRATO_JUDICIALIZADO_ID, CONTRATO_JUDICIALIZADO_DESC) values (1 ,'Judicializado');
  end if;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_JUDICIALIZADO.Finalizado INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_MONEDA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MONEDA where MONEDA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MONEDA (MONEDA_ID, MONEDA_DESC, MONEDA_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_MONEDA(MONEDA_ID, MONEDA_DESC, MONEDA_DESC_2)
     select DD_MON_ID, DD_MON_DESCRIPCION, DD_MON_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_MON_MONEDAS';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MONEDA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_NIVEL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_NIVEL where NIVEL_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_NIVEL (NIVEL_CONTRATO_ID, NIVEL_CONTRATO_DESC, NIVEL_CONTRATO_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_NIVEL(NIVEL_CONTRATO_ID, NIVEL_CONTRATO_DESC, NIVEL_CONTRATO_DESC_2)
     select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA from '||V_DATASTAGE||'.NIV_NIVEL';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_NIVEL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_OFICINA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_OFICINA where OFICINA_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_OFICINA (OFICINA_CONTRATO_ID, OFICINA_CONTRATO_DESC, OFICINA_CONTRATO_DESC_2, PROVINCIA_CONTRATO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_OFICINA(OFICINA_CONTRATO_ID, OFICINA_CONTRATO_DESC, OFICINA_CONTRATO_DESC_2, PROVINCIA_CONTRATO_ID)
    select OFI_ID, OFI_NOMBRE, OFI_CODIGO_OFICINA, DD_PRV_ID from '||V_DATASTAGE||'.OFI_OFICINAS';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_OFICINA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_PRODUCTO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PRODUCTO where PRODUCTO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PRODUCTO (PRODUCTO_ID, PRODUCTO_DESC, PRODUCTO_DESC_2, TIPO_PRODUCTO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_PRODUCTO(PRODUCTO_ID, PRODUCTO_DESC, PRODUCTO_DESC_2, TIPO_PRODUCTO_ID)
     select DD_TPR_ID, DD_TPR_DESCRIPCION, DD_TPR_DESCRIPCION_LARGA, DD_TPR_ID from '||V_DATASTAGE||'.DD_TPR_TIPO_PROD';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PRODUCTO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_PROVINCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PROVINCIA where PROVINCIA_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PROVINCIA (PROVINCIA_CONTRATO_ID, PROVINCIA_CONTRATO_DESC, PROVINCIA_CONTRATO_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_PROVINCIA(PROVINCIA_CONTRATO_ID, PROVINCIA_CONTRATO_DESC, PROVINCIA_CONTRATO_DESC_2)
     select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_PRV_PROVINCIA';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PROVINCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_TIPO_PRODUCTO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_PRODUCTO where TIPO_PRODUCTO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_PRODUCTO (TIPO_PRODUCTO_ID, TIPO_PRODUCTO_DESC, TIPO_PRODUCTO_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

 execute immediate
    'insert into D_CNT_TIPO_PRODUCTO(TIPO_PRODUCTO_ID, TIPO_PRODUCTO_DESC, TIPO_PRODUCTO_DESC_2)
    select DD_TPE_ID, DD_TPE_DESCRIPCION, DD_TPE_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_TPE_TIPO_PROD_ENTIDAD';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_PRODUCTO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_ZONA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ZONA where ZONA_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ZONA (ZONA_CONTRATO_ID, ZONA_CONTRATO_DESC, ZONA_CONTRATO_DESC_2, NIVEL_CONTRATO_ID, OFICINA_CONTRATO_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
  end if;

  execute immediate
    'insert into D_CNT_ZONA(ZONA_CONTRATO_ID, ZONA_CONTRATO_DESC, ZONA_CONTRATO_DESC_2, NIVEL_CONTRATO_ID, OFICINA_CONTRATO_ID)
     select distinct zon2.zon_id, Zon2.Zon_Descripcion, ofi.ofi_codigo_oficina, zon2.niv_id, ofi.ofi_id
     from  '||V_DATASTAGE||'.ofi_oficinas ofi 
     left join '||V_DATASTAGE||'.Zon_Zonificacion zon1 on ofi.ofi_id=zon1.ofi_id
     left join '||V_DATASTAGE||'.Zon_Zonificacion zon2 on zon1.zon_pid=zon2.zon_id';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ZONA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_NACIONALIDAD_TITULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_NACIONALIDAD_TITULAR where NACIONALIDAD_TITULAR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_NACIONALIDAD_TITULAR (NACIONALIDAD_TITULAR_ID, NACIONALIDAD_TITULAR_DESC, NACIONALIDAD_TITULAR_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_NACIONALIDAD_TITULAR(NACIONALIDAD_TITULAR_ID, NACIONALIDAD_TITULAR_DESC, NACIONALIDAD_TITULAR_DESC_2)
     select DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_CIC_CODIGO_ISO_CIRBE';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_NACIONALIDAD_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_POLITICA_TITULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_POLITICA_TITULAR where POLITICA_TITULAR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_POLITICA_TITULAR (POLITICA_TITULAR_ID, POLITICA_TITULAR_DESC, POLITICA_TITULAR_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_POLITICA_TITULAR(POLITICA_TITULAR_ID, POLITICA_TITULAR_DESC, POLITICA_TITULAR_DESC_2)
     select DD_POL_ID,DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_POL_POLITICAS';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_POLITICA_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SEGMENTO_TITULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SEGMENTO_TITULAR where SEGMENTO_TITULAR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SEGMENTO_TITULAR (SEGMENTO_TITULAR_ID, SEGMENTO_TITULAR_DESC, SEGMENTO_TITULAR_DESC_2, SEGMENTO_TITULAR_AGR_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

 execute immediate
    'insert into D_CNT_SEGMENTO_TITULAR(SEGMENTO_TITULAR_ID, SEGMENTO_TITULAR_DESC, SEGMENTO_TITULAR_DESC_2)
     select DD_SCE_ID, DD_SCE_DESCRIPCION, DD_SCE_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_SCE_SEGTO_CLI_ENTIDAD';

  V_ROWCOUNT := sql%rowcount;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SEGMENTO_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

  -- Incluimos SEGMENTO_TITULAR_AGR_ID
  -- 0-Micropymes
  update D_CNT_SEGMENTO_TITULAR SET SEGMENTO_TITULAR_AGR_ID = 0 where SEGMENTO_TITULAR_ID IN (14,15);
  -- 1-Particulares
  update D_CNT_SEGMENTO_TITULAR SET SEGMENTO_TITULAR_AGR_ID = 1 where SEGMENTO_TITULAR_ID IN (1,2,3,4,5,6,7);
  -- 2-Resto
  update D_CNT_SEGMENTO_TITULAR SET SEGMENTO_TITULAR_AGR_ID = 2 where SEGMENTO_TITULAR_AGR_ID is null;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SEGMENTO_TITULAR. Realizados UPDATES', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SEXO_TITULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SEXO_TITULAR where SEXO_TITULAR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SEXO_TITULAR (SEXO_TITULAR_ID, SEXO_TITULAR_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_SEXO_TITULAR(SEXO_TITULAR_ID, SEXO_TITULAR_DESC)
     select DD_SEX_ID, DD_SEX_DESCRIPCION from '||V_DATASTAGE||'.DD_SEX_SEXOS';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SEXO_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SITUACION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SITUACION where SITUACION_CONTRATO_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (-2 ,'Normalizado (Baja)'); -- Contrato Baja (Tiene estado anterior, pero no actual)
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION where SITUACION_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION where SITUACION_CONTRATO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (0 ,'Normal');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION where SITUACION_CONTRATO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (1 ,'Vencido No Dudoso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION where SITUACION_CONTRATO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (2 ,'Dudoso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION where SITUACION_CONTRATO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (3 ,'Fallido');
  end if;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SITUACION_DETALLE
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (-2 ,'Normalizado (Baja)', -2); -- Contrato Baja (Tiene estado anterior, pero no actual)
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (-1 ,'Desconocido', -1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (0 ,'Normal', 0);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (1 ,'Vencido <= 30 Días No Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (2 ,'Vencido 31-60 Días No Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (3 ,'Vencido > 60 Días No Litigio',1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (4 ,'Vencido <= 30 Días Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (5 ,'Vencido 31-60 Días Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (6 ,'Vencido > 60 Días Litigio',1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (7 ,'Dudoso No Litigio', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (8 ,'Dudoso Litigio', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (9 ,'Fallido Litigio', 3);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_DETALLE where SITUACION_CNT_DETALLE_ID = 10;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_DETALLE (SITUACION_CNT_DETALLE_ID, SITUACION_CNT_DETALLE_DESC , SITUACION_CONTRATO_ID) values (10 ,'Resto Fallido', 3);
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION_DETALLE. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SITUACION_ANTERIOR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANTERIOR where SITUACION_ANT_CNT_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANTERIOR (SITUACION_ANT_CNT_ID, SITUACION_ANT_CNT_DESC) values (-2 ,'No Existe (Alta)'); -- Contrato Alta (Tiene estado actual, pero no anterior)
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANTERIOR where SITUACION_ANT_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANTERIOR (SITUACION_ANT_CNT_ID, SITUACION_ANT_CNT_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANTERIOR where SITUACION_ANT_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANTERIOR (SITUACION_ANT_CNT_ID, SITUACION_ANT_CNT_DESC) values (0 ,'Normal');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANTERIOR where SITUACION_ANT_CNT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANTERIOR (SITUACION_ANT_CNT_ID, SITUACION_ANT_CNT_DESC) values (1 ,'Vencido No Dudoso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANTERIOR where SITUACION_ANT_CNT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANTERIOR (SITUACION_ANT_CNT_ID, SITUACION_ANT_CNT_DESC) values (2 ,'Dudoso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANTERIOR where SITUACION_ANT_CNT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANTERIOR (SITUACION_ANT_CNT_ID, SITUACION_ANT_CNT_DESC) values (3 ,'Fallido');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION_ANTERIOR. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SITUACION_ANT_DETALLE
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (-2 ,'Normalizado (Baja)', -2); -- Contrato Baja (Tiene estado anterior, pero no actual)
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (-1 ,'Desconocido', -1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (0 ,'Normal', 0);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (1 ,'Vencido <= 30 Días No Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (2 ,'Vencido 31-60 Días No Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (3 ,'Vencido > 60 Días No Litigio',1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (4 ,'Vencido <= 30 Días Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (5 ,'Vencido 31-60 Días Litigio', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (6 ,'Vencido > 60 Días Litigio',1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (7 ,'Dudoso No Litigio', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (8 ,'Dudoso Litigio', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (9 ,'Fallido Litigio', 3);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ANT_DETALLE where SITUACION_ANT_CNT_DETALLE_ID = 10;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ANT_DETALLE (SITUACION_ANT_CNT_DETALLE_ID, SITUACION_ANT_CNT_DETALLE_DESC , SITUACION_ANT_CNT_ID) values (10 ,'Resto Fallido', 3);
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION_ANT_DETALLE. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SITUACION_RESP_PER_ANT
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_RESP_PER_ANT where SITUACION_RESP_PER_ANT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_RESP_PER_ANT (SITUACION_RESP_PER_ANT_ID, SITUACION_RESP_PER_ANT_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_RESP_PER_ANT where SITUACION_RESP_PER_ANT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_RESP_PER_ANT (SITUACION_RESP_PER_ANT_ID, SITUACION_RESP_PER_ANT_DESC) values (0 ,'Mantiene');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_RESP_PER_ANT where SITUACION_RESP_PER_ANT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_RESP_PER_ANT (SITUACION_RESP_PER_ANT_ID, SITUACION_RESP_PER_ANT_DESC) values (1 ,'Alta');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_RESP_PER_ANT where SITUACION_RESP_PER_ANT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_RESP_PER_ANT (SITUACION_RESP_PER_ANT_ID, SITUACION_RESP_PER_ANT_DESC) values (2 ,'Baja');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION_RESP_PER_ANT. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_PERSONA_TITULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_PERSONA_TITULAR where TIPO_PERSONA_TITULAR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_PERSONA_TITULAR (TIPO_PERSONA_TITULAR_ID, TIPO_PERSONA_TITULAR_DESC, TIPO_PERSONA_TITULAR_DESC2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_TIPO_PERSONA_TITULAR(TIPO_PERSONA_TITULAR_ID, TIPO_PERSONA_TITULAR_DESC, TIPO_PERSONA_TITULAR_DESC2)
     select DD_TPE_ID, DD_TPE_DESCRIPCION, DD_TPE_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_TPE_TIPO_PERSONA';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_PERSONA_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EST_INSINUACION_CNT
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_EST_INSINUACION_CNT where ESTADO_INSINUACION_CNT_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EST_INSINUACION_CNT (ESTADO_INSINUACION_CNT_ID, ESTADO_INSINUACION_CNT_DESC, ESTADO_INSINUACION_CNT_DESC2) values (-2 ,'Sin Crédito Insinuado Asociado', 'Sin Crédito Insinuado Asociado');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_EST_INSINUACION_CNT where ESTADO_INSINUACION_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EST_INSINUACION_CNT (ESTADO_INSINUACION_CNT_ID, ESTADO_INSINUACION_CNT_DESC, ESTADO_INSINUACION_CNT_DESC2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

 execute immediate
    'insert into D_CNT_EST_INSINUACION_CNT(ESTADO_INSINUACION_CNT_ID, ESTADO_INSINUACION_CNT_DESC, ESTADO_INSINUACION_CNT_DESC2)
     select STD_CRE_ID, STD_CRE_DESCRIP, STD_CRE_DESCRIP_LARGA from '||V_DATASTAGE||'.DD_STD_CREDITO';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EST_INSINUACION_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CARTERA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CARTERA where CARTERA_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA (CARTERA_CONTRATO_ID, CARTERA_CONTRATO_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CARTERA where CARTERA_CONTRATO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA (CARTERA_CONTRATO_ID, CARTERA_CONTRATO_DESC) values (1 ,'HAYA');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CARTERA where CARTERA_CONTRATO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA (CARTERA_CONTRATO_ID, CARTERA_CONTRATO_DESC) values (2 ,'CAJAMAR');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CARTERA. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_DIAS
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (0 ,'Sin Irregularidad');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (1 ,'<= Hasta 30 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (2 ,'31-60 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (3 ,'61-90 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (4 ,'De 91 a 180 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (5 ,'De 181 a 270 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (6 ,'De 271 a 365 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (7 ,'365 - 2 años');
  end if;
   select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (8 ,'2 años - 4 años');
  end if;
   select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS where T_IRREG_DIAS_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS (T_IRREG_DIAS_ID, T_IRREG_DIAS_DESC) values (9 ,'> 4 años');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_DIAS. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_FASES
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (-1 ,'Fase No Informada', -1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (0 ,'Al Día',0);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (1 ,'A', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (2 ,'B', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (3 ,'C', 3);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (4 ,'D', 4);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (5 ,'E', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (6 ,'F', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (7 ,'G', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (8 ,'H', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES where T_IRREG_FASES_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES (T_IRREG_FASES_ID, T_IRREG_FASES_DESC, T_IRREG_FASES_AGR_ID) values (9 ,'X', 5);
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_FASES. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_FASES_AGR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_AGR where T_IRREG_FASES_AGR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_AGR (T_IRREG_FASES_AGR_ID, T_IRREG_FASES_AGR_DESC) values (-1 ,'Fase No Informada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_AGR where T_IRREG_FASES_AGR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_AGR (T_IRREG_FASES_AGR_ID, T_IRREG_FASES_AGR_DESC) values (0 ,'Al Día');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_AGR where T_IRREG_FASES_AGR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_AGR (T_IRREG_FASES_AGR_ID, T_IRREG_FASES_AGR_DESC) values (1 ,'A');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_AGR where T_IRREG_FASES_AGR_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_AGR (T_IRREG_FASES_AGR_ID, T_IRREG_FASES_AGR_DESC) values (2 ,'B');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_AGR where T_IRREG_FASES_AGR_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_AGR (T_IRREG_FASES_AGR_ID, T_IRREG_FASES_AGR_DESC) values (3 ,'C');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_AGR where T_IRREG_FASES_AGR_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_AGR (T_IRREG_FASES_AGR_ID, T_IRREG_FASES_AGR_DESC) values (4 ,'D');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_AGR where T_IRREG_FASES_AGR_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_AGR (T_IRREG_FASES_AGR_ID, T_IRREG_FASES_AGR_DESC) values (5 ,'>= E');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_FASES_AGR. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_DIAS_PERIODO_ANT
-- ----------------------------------------------------------------------------------------------
   select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (0 ,'Sin Irregularidad');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (1 ,'<= Hasta 30 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (2 ,'31-60 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (3 ,'61-90 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (4 ,'De 91 a 180 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (5 ,'De 181 a 270 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (6 ,'De 271 a 365 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (7 ,'365 - 2 años');
  end if;
   select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (8 ,'2 años - 4 años');
  end if;
   select count(*) into V_NUM_ROW from D_CNT_T_IRREG_DIAS_PERIODO_ANT where T_IRREG_DIAS_PERIODO_ANT_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_DIAS_PERIODO_ANT (T_IRREG_DIAS_PERIODO_ANT_ID, T_IRREG_DIAS_PERIODO_ANT_DESC) values (9 ,'> 4 años');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_DIAS_PERIODO_ANT. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_FASES_PER_ANT
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (-2 ,'No Existe En Periodo Anterior', -2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (-1 ,'Fase No Informada', -1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (0 ,'Al Día',0);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (1 ,'A', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (2 ,'B', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (3 ,'C', 3);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (4 ,'D', 4);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (5 ,'E', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (6 ,'F', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (7 ,'G', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (8 ,'H', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_FASES_PER_ANT where T_IRREG_FASES_PER_ANT_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_FASES_PER_ANT (T_IRREG_FASES_PER_ANT_ID, T_IRREG_FASES_PER_ANT_DESC, T_IRREG_F_AGR_PER_ANT_ID) values (9 ,'X', 5);
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_FASES_PER_ANT. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_F_AGR_PER_ANT
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (-2 ,'No Existe En Periodo Anterior');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (-1 ,'Fase No Informada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (0 ,'Al Día');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (1 ,'A');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (2 ,'B');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (3 ,'C');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (4 ,'D');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_PER_ANT where T_IRREG_F_AGR_PER_ANT_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_PER_ANT (T_IRREG_F_AGR_PER_ANT_ID, T_IRREG_F_AGR_PER_ANT_DESC) values (5 ,'>= E');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_F_AGR_PER_ANT. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TD_EN_GESTION_A_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = -3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (-3, 'Sin Cobro');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (-2, 'Sin Gestión Recobro');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (0, '<= 5 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (1, '6-10 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (2, '11-15 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (3, '16-20 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (4, '21-25 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_EN_GESTION_A_COBRO where TD_EN_GESTION_A_COBRO_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_EN_GESTION_A_COBRO (TD_EN_GESTION_A_COBRO_ID, TD_EN_GESTION_A_COBRO_DESC) values (5, '> 25 Días');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TD_EN_GESTION_A_COBRO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TD_IRREGULAR_A_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = -3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (-3, 'Sin Cobro');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (-2, 'Sin Gestión Recobro');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (-1, 'Contrato Sin Impago');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (0, '<= 30 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (1, '31-60 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (2, '61-90 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (3, '91 Días-1 Año');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (4, '1-3 Años');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREGULAR_A_COBRO where TD_IRREGULAR_A_COBRO_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREGULAR_A_COBRO (TD_IRREGULAR_A_COBRO_ID, TD_IRREGULAR_A_COBRO_DESC) values (5, '> 3 Años');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TD_IRREGULAR_A_COBRO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_GARANTIA_CONTRATO_AGR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_CONTRATO_AGR where GARANTIA_CONTRATO_AGR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_CONTRATO_AGR (GARANTIA_CONTRATO_AGR_ID, GARANTIA_CONTRATO_AGR_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_CONTRATO_AGR where GARANTIA_CONTRATO_AGR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_CONTRATO_AGR (GARANTIA_CONTRATO_AGR_ID, GARANTIA_CONTRATO_AGR_DESC) values (0 ,'Real Hipotecaria');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_CONTRATO_AGR where GARANTIA_CONTRATO_AGR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_CONTRATO_AGR (GARANTIA_CONTRATO_AGR_ID, GARANTIA_CONTRATO_AGR_DESC) values (1 ,'Resto');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_CONTRATO_AGR where GARANTIA_CONTRATO_AGR_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_CONTRATO_AGR (GARANTIA_CONTRATO_AGR_ID, GARANTIA_CONTRATO_AGR_DESC) values (2 ,'Real Pignoraticias');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_CONTRATO_AGR where GARANTIA_CONTRATO_AGR_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_CONTRATO_AGR (GARANTIA_CONTRATO_AGR_ID, GARANTIA_CONTRATO_AGR_DESC) values (3 ,'Personal');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_GARANTIA_CONTRATO_AGR. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SEGMENTO_TITULAR_AGR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SEGMENTO_TITULAR_AGR where SEGMENTO_TITULAR_AGR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SEGMENTO_TITULAR_AGR (SEGMENTO_TITULAR_AGR_ID, SEGMENTO_TITULAR_AGR_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SEGMENTO_TITULAR_AGR where SEGMENTO_TITULAR_AGR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SEGMENTO_TITULAR_AGR (SEGMENTO_TITULAR_AGR_ID, SEGMENTO_TITULAR_AGR_DESC) values (0 ,'Micropymes');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SEGMENTO_TITULAR_AGR where SEGMENTO_TITULAR_AGR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SEGMENTO_TITULAR_AGR (SEGMENTO_TITULAR_AGR_ID, SEGMENTO_TITULAR_AGR_DESC) values (1 ,'Particulares');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SEGMENTO_TITULAR_AGR where SEGMENTO_TITULAR_AGR_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SEGMENTO_TITULAR_AGR (SEGMENTO_TITULAR_AGR_ID, SEGMENTO_TITULAR_AGR_DESC) values (2 ,'Resto');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SEGMENTO_TITULAR_AGR. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_RESULTADO_ACTUACION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_RESULTADO_ACTUACION where RESULTADO_ACTUACION_CNT_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_RESULTADO_ACTUACION (RESULTADO_ACTUACION_CNT_ID, RESULTADO_ACTUACION_CNT_DESC) values (-2, 'No En Gestión');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_RESULTADO_ACTUACION where RESULTADO_ACTUACION_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_RESULTADO_ACTUACION (RESULTADO_ACTUACION_CNT_ID, RESULTADO_ACTUACION_CNT_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_RESULTADO_ACTUACION where RESULTADO_ACTUACION_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_RESULTADO_ACTUACION (RESULTADO_ACTUACION_CNT_ID, RESULTADO_ACTUACION_CNT_DESC) values (0, 'Sin Actuación');
  end if;


  execute immediate
    'insert into D_CNT_RESULTADO_ACTUACION(RESULTADO_ACTUACION_CNT_ID, RESULTADO_ACTUACION_CNT_DESC)
     select DD_RGT_ID, DD_RGT_DESCRIPCION from '||V_DATASTAGE||'.DD_RGT_RESULT_GESTION_TEL';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_RESULTADO_ACTUACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EN_GESTION_RECOBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_EN_GESTION_RECOBRO where EN_GESTION_RECOBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GESTION_RECOBRO (EN_GESTION_RECOBRO_ID, EN_GESTION_RECOBRO_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_GESTION_RECOBRO where EN_GESTION_RECOBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GESTION_RECOBRO (EN_GESTION_RECOBRO_ID, EN_GESTION_RECOBRO_DESC) values (0 ,'Sin Gestión Recobro');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_GESTION_RECOBRO where EN_GESTION_RECOBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GESTION_RECOBRO (EN_GESTION_RECOBRO_ID, EN_GESTION_RECOBRO_DESC) values (1 ,'En Gestión Recobro');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EN_GESTION_RECOBRO. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EN_IRREGULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_EN_IRREGULAR where CONTRATO_EN_IRREGULAR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_IRREGULAR (CONTRATO_EN_IRREGULAR_ID, CONTRATO_EN_IRREGULAR_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_IRREGULAR where CONTRATO_EN_IRREGULAR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_IRREGULAR (CONTRATO_EN_IRREGULAR_ID, CONTRATO_EN_IRREGULAR_DESC) values (0, 'Sin Impago');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_IRREGULAR where CONTRATO_EN_IRREGULAR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_IRREGULAR (CONTRATO_EN_IRREGULAR_ID, CONTRATO_EN_IRREGULAR_DESC) values (1, 'En Irregular');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EN_IRREGULAR. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MODELO_RECOBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MODELO_RECOBRO where MODELO_RECOBRO_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MODELO_RECOBRO (MODELO_RECOBRO_CONTRATO_ID, MODELO_RECOBRO_CONTRATO_DESC, MODELO_RECOBRO_CONTRATO_DESC_2) values (-1, 'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_MODELO_RECOBRO(MODELO_RECOBRO_CONTRATO_ID, MODELO_RECOBRO_CONTRATO_DESC, MODELO_RECOBRO_CONTRATO_DESC_2)
     select DD_MOR_ID, DD_MOR_DESCRIPCION, DD_MOR_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_MOR_MODELO_RECOBRO';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MODELO_RECOBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PROVEEDOR_RECOBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PROVEEDOR_RECOBRO where PROVEEDOR_RECOBRO_CNT_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PROVEEDOR_RECOBRO (PROVEEDOR_RECOBRO_CNT_ID, PROVEEDOR_RECOBRO_CNT_DESC, PROVEEDOR_RECOBRO_CNT_DESC_2) values (-2, 'No En Recobro', 'No En Recobro');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_PROVEEDOR_RECOBRO where PROVEEDOR_RECOBRO_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PROVEEDOR_RECOBRO (PROVEEDOR_RECOBRO_CNT_ID, PROVEEDOR_RECOBRO_CNT_DESC, PROVEEDOR_RECOBRO_CNT_DESC_2) values (-1, 'Desconocido', 'Desconocido');
  end if;

 execute immediate
    'insert into D_CNT_PROVEEDOR_RECOBRO (PROVEEDOR_RECOBRO_CNT_ID, PROVEEDOR_RECOBRO_CNT_DESC, PROVEEDOR_RECOBRO_CNT_DESC_2)
     select DD_PRE_ID, DD_PRE_DESCRIPCION, DD_PRE_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_PRE_PROVEEDORES_RECOBRO';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PROVEEDOR_RECOBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CON_DPS
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CON_DPS where CONTRATO_CON_DPS_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_DPS (CONTRATO_CON_DPS_ID, CONTRATO_CON_DPS_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_DPS where CONTRATO_CON_DPS_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_DPS (CONTRATO_CON_DPS_ID, CONTRATO_CON_DPS_DESC) values (0, 'Contrato Sin DPS');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_DPS where CONTRATO_CON_DPS_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_DPS (CONTRATO_CON_DPS_ID, CONTRATO_CON_DPS_DESC) values (1, 'Contrato Con DPS');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CON_DPS. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CON_CONTACTO_UTIL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CON_CONTACTO_UTIL where CNT_CON_CONTACTO_UTIL_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_CONTACTO_UTIL (CNT_CON_CONTACTO_UTIL_ID, CNT_CON_CONTACTO_UTIL_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_CONTACTO_UTIL where CNT_CON_CONTACTO_UTIL_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_CONTACTO_UTIL (CNT_CON_CONTACTO_UTIL_ID, CNT_CON_CONTACTO_UTIL_DESC) values (0, 'Sin Contacto útil');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_CONTACTO_UTIL where CNT_CON_CONTACTO_UTIL_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_CONTACTO_UTIL (CNT_CON_CONTACTO_UTIL_ID, CNT_CON_CONTACTO_UTIL_DESC) values (1, 'Con Contacto útil');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CON_CONTACTO_UTIL. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CON_ACTUACION_RECOBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CON_ACTUACION_RECOBRO where CNT_CON_ACTUACION_RECOBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_ACTUACION_RECOBRO (CNT_CON_ACTUACION_RECOBRO_ID, CNT_CON_ACTUACION_RECOBRO_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_ACTUACION_RECOBRO where CNT_CON_ACTUACION_RECOBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_ACTUACION_RECOBRO (CNT_CON_ACTUACION_RECOBRO_ID, CNT_CON_ACTUACION_RECOBRO_DESC) values (0, 'Sin Actuación Recobro');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_ACTUACION_RECOBRO where CNT_CON_ACTUACION_RECOBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_ACTUACION_RECOBRO (CNT_CON_ACTUACION_RECOBRO_ID, CNT_CON_ACTUACION_RECOBRO_DESC) values (1, 'Con Actuación Recobro');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CON_ACTUACION_RECOBRO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EST_FIN_INI_CAMP_REC
--                                      D_CNT_EST_FIN_ANT_INI_CAMP_REC
-- ----------------------------------------------------------------------------------------------

  -- D_CNT_EST_FIN_INI_CAMP_REC
  select count(*) into V_NUM_ROW from D_CNT_EST_FIN_INI_CAMP_REC where EST_FIN_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EST_FIN_INI_CAMP_REC (EST_FIN_INI_CAMP_REC_ID, EST_FIN_INI_CAMP_REC_DESC, EST_FIN_INI_CAMP_REC_DESC2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

 execute immediate
    'insert into D_CNT_EST_FIN_INI_CAMP_REC(EST_FIN_INI_CAMP_REC_ID, EST_FIN_INI_CAMP_REC_DESC, EST_FIN_INI_CAMP_REC_DESC2)
     select DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_EFC_ESTADO_FINAN_CNT';

  V_ROWCOUNT := sql%rowcount;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EST_FIN_INI_CAMP_REC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


  -- D_CNT_EST_FIN_ANT_INI_CAMP_REC (Misma tabla fuente)
  select count(*) into V_NUM_ROW from D_CNT_EST_FIN_ANT_INI_CAMP_REC where EST_FIN_ANT_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EST_FIN_ANT_INI_CAMP_REC (EST_FIN_ANT_INI_CAMP_REC_ID, EST_FIN_ANT_INI_CAMP_REC_DESC, EST_FIN_ANT_INI_CAMP_REC_DESC2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_EST_FIN_ANT_INI_CAMP_REC(EST_FIN_ANT_INI_CAMP_REC_ID, EST_FIN_ANT_INI_CAMP_REC_DESC, EST_FIN_ANT_INI_CAMP_REC_DESC2)
     select DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_EFC_ESTADO_FINAN_CNT';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EST_FIN_ANT_INI_CAMP_REC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EN_GEST_REC_INI_CAMP_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_EN_GEST_REC_INI_CAMP_REC where EN_GEST_REC_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GEST_REC_INI_CAMP_REC (EN_GEST_REC_INI_CAMP_REC_ID, EN_GEST_REC_INI_CAMP_REC_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_GEST_REC_INI_CAMP_REC where EN_GEST_REC_INI_CAMP_REC_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GEST_REC_INI_CAMP_REC (EN_GEST_REC_INI_CAMP_REC_ID, EN_GEST_REC_INI_CAMP_REC_DESC) values (0 ,'Sin Gestión Recobro');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_GEST_REC_INI_CAMP_REC where EN_GEST_REC_INI_CAMP_REC_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GEST_REC_INI_CAMP_REC (EN_GEST_REC_INI_CAMP_REC_ID, EN_GEST_REC_INI_CAMP_REC_DESC) values (1 ,'En Gestión Recobro');
  end if;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EN_GEST_REC_INI_CAMP_REC. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EN_IRREG_INI_CAMP_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_EN_IRREG_INI_CAMP_REC where EN_IRREG_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_IRREG_INI_CAMP_REC (EN_IRREG_INI_CAMP_REC_ID, EN_IRREG_INI_CAMP_REC_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_IRREG_INI_CAMP_REC where EN_IRREG_INI_CAMP_REC_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_IRREG_INI_CAMP_REC (EN_IRREG_INI_CAMP_REC_ID, EN_IRREG_INI_CAMP_REC_DESC) values (0, 'Sin Impago');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_IRREG_INI_CAMP_REC where EN_IRREG_INI_CAMP_REC_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_IRREG_INI_CAMP_REC (EN_IRREG_INI_CAMP_REC_ID, EN_IRREG_INI_CAMP_REC_DESC) values (1, 'En Irregular');
  end if;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EN_IRREG_INI_CAMP_REC. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MODELO_REC_INI_CAMP_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MODELO_REC_INI_CAMP_REC where MODELO_REC_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MODELO_REC_INI_CAMP_REC (MODELO_REC_INI_CAMP_REC_ID, MODELO_REC_INI_CAMP_REC_DESC, MODELO_REC_INI_CAMP_REC_DESC_2) values (-1, 'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_MODELO_REC_INI_CAMP_REC(MODELO_REC_INI_CAMP_REC_ID, MODELO_REC_INI_CAMP_REC_DESC, MODELO_REC_INI_CAMP_REC_DESC_2)
     select DD_MOR_ID, DD_MOR_DESCRIPCION, DD_MOR_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_MOR_MODELO_RECOBRO';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MODELO_REC_INI_CAMP_REC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PROV_REC_INI_CAMP_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PROV_REC_INI_CAMP_REC where PROV_REC_INI_CAMP_REC_ID = -2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PROV_REC_INI_CAMP_REC (PROV_REC_INI_CAMP_REC_ID, PROV_REC_INI_CAMP_REC_DESC, PROV_REC_INI_CAMP_REC_DESC_2) values (-2, 'No En Recobro', 'No En Recobro');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_PROV_REC_INI_CAMP_REC where PROV_REC_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PROV_REC_INI_CAMP_REC (PROV_REC_INI_CAMP_REC_ID, PROV_REC_INI_CAMP_REC_DESC, PROV_REC_INI_CAMP_REC_DESC_2) values (-1, 'Desconocido', 'Desconocido');
  end if;

 execute immediate
    'insert into D_CNT_PROV_REC_INI_CAMP_REC (PROV_REC_INI_CAMP_REC_ID, PROV_REC_INI_CAMP_REC_DESC, PROV_REC_INI_CAMP_REC_DESC_2)
     select DD_PRE_ID, DD_PRE_DESCRIPCION, DD_PRE_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_PRE_PROVEEDORES_RECOBRO';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PROV_REC_INI_CAMP_REC. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_D_INI_CAMP_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (0 ,'Sin Irregularidad');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (1 ,'<= 30 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (2 ,'31-60 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (3 ,'61-90 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (4 ,'91-120 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (5 ,'121 Días-1 Año');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (5 ,'1-3 Años');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_D_INI_CAMP_REC where T_IRREG_D_INI_CAMP_REC_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_D_INI_CAMP_REC (T_IRREG_D_INI_CAMP_REC_ID, T_IRREG_D_INI_CAMP_REC_DESC) values (6 ,'> 3 Años');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_D_INI_CAMP_REC. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_F_INI_CAMP_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (-1 ,'Fase No Informada', -1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (0 ,'Al Día',0);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (1 ,'A', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (2 ,'B', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (3 ,'C', 3);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (4 ,'D', 4);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (5 ,'E', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (6 ,'F', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (7 ,'G', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (8 ,'H', 5);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_INI_CAMP_REC where T_IRREG_F_INI_CAMP_REC_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_INI_CAMP_REC (T_IRREG_F_INI_CAMP_REC_ID, T_IRREG_F_INI_CAMP_REC_DESC, T_IRREG_F_AGR_INI_REC_ID) values (9 ,'X', 5);
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_F_INI_CAMP_REC. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_IRREG_F_AGR_INI_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_INI_REC where T_IRREG_F_AGR_INI_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_INI_REC (T_IRREG_F_AGR_INI_REC_ID, T_IRREG_F_AGR_INI_REC_DESC) values (-1 ,'Fase No Informada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_INI_REC where T_IRREG_F_AGR_INI_REC_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_INI_REC (T_IRREG_F_AGR_INI_REC_ID, T_IRREG_F_AGR_INI_REC_DESC) values (0 ,'Al Día');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_INI_REC where T_IRREG_F_AGR_INI_REC_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_INI_REC (T_IRREG_F_AGR_INI_REC_ID, T_IRREG_F_AGR_INI_REC_DESC) values (1 ,'A');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_INI_REC where T_IRREG_F_AGR_INI_REC_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_INI_REC (T_IRREG_F_AGR_INI_REC_ID, T_IRREG_F_AGR_INI_REC_DESC) values (2 ,'B');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_INI_REC where T_IRREG_F_AGR_INI_REC_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_INI_REC (T_IRREG_F_AGR_INI_REC_ID, T_IRREG_F_AGR_INI_REC_DESC) values (3 ,'C');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_INI_REC where T_IRREG_F_AGR_INI_REC_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_INI_REC (T_IRREG_F_AGR_INI_REC_ID, T_IRREG_F_AGR_INI_REC_DESC) values (4 ,'D');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_IRREG_F_AGR_INI_REC where T_IRREG_F_AGR_INI_REC_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_IRREG_F_AGR_INI_REC (T_IRREG_F_AGR_INI_REC_ID, T_IRREG_F_AGR_INI_REC_DESC) values (5 ,'>= E');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_IRREG_F_AGR_INI_REC. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EN_GESTION_ESPEC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_EN_GESTION_ESPEC where EN_GESTION_ESPECIALIZADA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GESTION_ESPEC (EN_GESTION_ESPECIALIZADA_ID, EN_GESTION_ESPECIALIZADA_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_GESTION_ESPEC where EN_GESTION_ESPECIALIZADA_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GESTION_ESPEC (EN_GESTION_ESPECIALIZADA_ID, EN_GESTION_ESPECIALIZADA_DESC) values (0, 'Sin Gestión Especializada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_GESTION_ESPEC where EN_GESTION_ESPECIALIZADA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_GESTION_ESPEC (EN_GESTION_ESPECIALIZADA_ID, EN_GESTION_ESPECIALIZADA_DESC) values (1, 'Con Gestión Especializada');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_EN_GESTION_ESPEC. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CON_PREVISION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CON_PREVISION where CONTRATO_CON_PREVISION_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_PREVISION (CONTRATO_CON_PREVISION_ID, CONTRATO_CON_PREVISION_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_PREVISION where CONTRATO_CON_PREVISION_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_PREVISION (CONTRATO_CON_PREVISION_ID, CONTRATO_CON_PREVISION_DESC) values (0, 'Sin Previsión');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_PREVISION where CONTRATO_CON_PREVISION_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_PREVISION (CONTRATO_CON_PREVISION_ID, CONTRATO_CON_PREVISION_DESC) values (1, 'Con Previsión');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CON_PREVISION. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CON_PREVISION_REVISADA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CON_PREVISION_REVISADA where CNT_CON_PREV_REVISADA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_PREVISION_REVISADA (CNT_CON_PREV_REVISADA_ID, CNT_CON_PREV_REVISADA_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_PREVISION_REVISADA where CNT_CON_PREV_REVISADA_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_PREVISION_REVISADA (CNT_CON_PREV_REVISADA_ID, CNT_CON_PREV_REVISADA_DESC) values (0, 'Sin Previsión Revisada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_PREVISION_REVISADA where CNT_CON_PREV_REVISADA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_PREVISION_REVISADA (CNT_CON_PREV_REVISADA_ID, CNT_CON_PREV_REVISADA_DESC) values (1, 'Con Previsión Revisada');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CON_PREVISION_REVISADA. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_PREVISION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_PREVISION where TIPO_PREVISION_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_PREVISION (TIPO_PREVISION_ID, TIPO_PREVISION_DESC) values (-1, 'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TIPO_PREVISION where TIPO_PREVISION_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_PREVISION (TIPO_PREVISION_ID, TIPO_PREVISION_DESC) values (0, 'Auto');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TIPO_PREVISION where TIPO_PREVISION_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_PREVISION (TIPO_PREVISION_ID, TIPO_PREVISION_DESC) values (1, 'Manual');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_PREVISION. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PREV_SITUACION_INICIAL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (-1 ,'Fase No Informada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (0 ,'Al Día');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (1 ,'A');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (2 ,'B');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (3 ,'C');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (4 ,'D');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (5 ,'E');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (6 ,'F');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (7 ,'G');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (8 ,'H');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_INICIAL where PREV_SITUACION_INICIAL_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_INICIAL (PREV_SITUACION_INICIAL_ID, PREV_SITUACION_INICIAL_DESC) values (9 ,'X');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PREV_SITUACION_INICIAL. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PREV_SITUACION_AUTO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (-1 ,'Fase No Informada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (0 ,'Al Día');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (1 ,'A');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (2 ,'B');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (3 ,'C');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (4 ,'D');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (5 ,'E');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (6 ,'F');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (7 ,'G');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (8 ,'H');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_AUTO where PREV_SITUACION_AUTO_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_AUTO (PREV_SITUACION_AUTO_ID, PREV_SITUACION_AUTO_DESC) values (9 ,'X');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PREV_SITUACION_AUTO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PREV_SITUACION_MANUAL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (-1 ,'Fase No Informada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (0 ,'Al Día');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (1 ,'A');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (2 ,'B');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (3 ,'C');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (4 ,'D');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (5 ,'E');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (6 ,'F');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (7 ,'G');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (8 ,'H');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_MANUAL where PREV_SITUACION_MANUAL_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_MANUAL (PREV_SITUACION_MANUAL_ID, PREV_SITUACION_MANUAL_DESC) values (9 ,'X');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PREV_SITUACION_MANUAL. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PREV_SITUACION_FINAL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (-1 ,'Fase No Informada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (0 ,'Al Día');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (1 ,'A');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (2 ,'B');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (3 ,'C');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (4 ,'D');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (5 ,'E');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (6 ,'F');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (7 ,'G');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (8 ,'H');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PREV_SITUACION_FINAL where PREV_SITUACION_FINAL_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PREV_SITUACION_FINAL (PREV_SITUACION_FINAL_ID, PREV_SITUACION_FINAL_DESC) values (9 ,'X');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PREV_SITUACION_FINAL. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MOTIVO_PREVISION
-- ----------------------------------------------------------------------------------------------
  /*select count(*) into V_NUM_ROW from D_CNT_MOTIVO_PREVISION where MOTIVO_PREVISION_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MOTIVO_PREVISION (MOTIVO_PREVISION_ID, MOTIVO_PREVISION_DESC) values (-1, 'Pase a Peor Situación');
  end if;*/

  /*execute immediate
    'insert into D_CNT_MOTIVO_PREVISION(MOTIVO_PREVISION_ID, MOTIVO_PREVISION_DESC)
     select MPR_ID, MPR_DESCRIPCION from '||V_DATASTAGE||'.DD_MPR_MOTIVO_PREVISION'; */

  commit;

/*
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SITUACION_ESPECIALIZADA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (-1, 'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (0 ,'Error');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (1 ,'Litigio');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (2 ,'Concurso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (3 ,'Anticipación');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (4 ,'Posible Anticipación');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (5 ,'Vencido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_ESPECIALIZADA where SITUACION_ESPECIALIZADA_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_ESPECIALIZADA (SITUACION_ESPECIALIZADA_ID, SITUACION_ESPECIALIZADA_DESC) values (6 ,'Fallido');
  end if;

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_GESTOR_ESPECIALIZADA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_GESTOR_ESPECIALIZADA where GESTOR_ESPECIALIZADA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GESTOR_ESPECIALIZADA (GESTOR_ESPECIALIZADA_ID, GESTOR_ESPECIALIZADA_DESC) values (-1, 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_GESTOR_ESPECIALIZADA(GESTOR_ESPECIALIZADA_ID, GESTOR_ESPECIALIZADA_DESC)
    select DISTINCT GESTOR_ESP_USD_ID, TRIM(UPPER(NOMBRE_DES_GESTOR_ESP)) from '||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA';

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUPERVISOR_N1_ESPEC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUPERVISOR_N1_ESPEC where SUPERVISOR_N1_ESPEC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUPERVISOR_N1_ESPEC (SUPERVISOR_N1_ESPEC_ID, SUPERVISOR_N1_ESPEC_DESC) values (-1, 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_SUPERVISOR_N1_ESPEC(SUPERVISOR_N1_ESPEC_ID, SUPERVISOR_N1_ESPEC_DESC)
     select DISTINCT SUPERVISOR_N1_ESP_USD_ID, TRIM(UPPER(NOMBRE_DES_SUPERVISOR_N1_ESP)) from '||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA';

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUPERVISOR_N2_ESPEC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUPERVISOR_N2_ESPEC where SUPERVISOR_N2_ESPEC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUPERVISOR_N2_ESPEC (SUPERVISOR_N2_ESPEC_ID, SUPERVISOR_N2_ESPEC_DESC) values (-1, 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_SUPERVISOR_N2_ESPEC(SUPERVISOR_N2_ESPEC_ID, SUPERVISOR_N2_ESPEC_DESC)
    select DISTINCT SUPERVISOR_N2_ESP_USD_ID, TRIM(UPPER(NOMBRE_DES_SUPERVISOR_N2_ESP))
    from '||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA
    where SUPERVISOR_N2_ESP_USD_ID is NOT null AND SUPERVISOR_N2_ESP_USD_ID NOT IN (select SUPERVISOR_N2_ESPEC_ID from  D_CNT_SUPERVISOR_N2_ESPEC)';

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUPERVISOR_N3_ESPEC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUPERVISOR_N3_ESPEC where SUPERVISOR_N3_ESPEC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUPERVISOR_N3_ESPEC (SUPERVISOR_N3_ESPEC_ID, SUPERVISOR_N3_ESPEC_DESC) values (-1, 'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_SUPERVISOR_N3_ESPEC(SUPERVISOR_N3_ESPEC_ID, SUPERVISOR_N3_ESPEC_DESC)
    select DISTINCT SUPERVISOR_N3_1_ESP_USD_ID, TRIM(UPPER(NOMBRE_DES_SUPERVISOR_N3_1_ESP))
    from '||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA
    where SUPERVISOR_N3_1_ESP_USD_ID is NOT null AND SUPERVISOR_N3_1_ESP_USD_ID NOT IN (select SUPERVISOR_N3_ESPEC_ID from  D_CNT_SUPERVISOR_N3_ESPEC)';

  execute immediate
    'insert into D_CNT_SUPERVISOR_N3_ESPEC(SUPERVISOR_N3_ESPEC_ID, SUPERVISOR_N3_ESPEC_DESC)
    select DISTINCT SUPERVISOR_N3_2_ESP_USD_ID, TRIM(UPPER(NOMBRE_DES_SUPERVISOR_N3_2_ESP))
    from '||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA
    where SUPERVISOR_N3_2_ESP_USD_ID is NOT null AND SUPERVISOR_N3_2_ESP_USD_ID NOT IN (select SUPERVISOR_N3_ESPEC_ID from  D_CNT_SUPERVISOR_N3_ESPEC)';

  execute immediate
    'insert into D_CNT_SUPERVISOR_N3_ESPEC(SUPERVISOR_N3_ESPEC_ID, SUPERVISOR_N3_ESPEC_DESC)
    select DISTINCT SUPERVISOR_N3_3_ESP_USD_ID, TRIM(UPPER(NOMBRE_DES_SUPERVISOR_N3_3_ESP))
    from '||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA
    where SUPERVISOR_N3_3_ESP_USD_ID is NOT null AND SUPERVISOR_N3_3_ESP_USD_ID NOT IN (select SUPERVISOR_N3_ESPEC_ID from  D_CNT_SUPERVISOR_N3_ESPEC)';

  execute immediate
    'insert into D_CNT_SUPERVISOR_N3_ESPEC(SUPERVISOR_N3_ESPEC_ID, SUPERVISOR_N3_ESPEC_DESC)
    select DISTINCT SUPERVISOR_N3_4_ESP_USD_ID, TRIM(UPPER(NOMBRE_DES_SUPERVISOR_N3_4_ESP))
    from '||V_DATASTAGE||'.CARTERIZACION_ESPECIALIZADA
    where SUPERVISOR_N3_4_ESP_USD_ID is NOT null AND SUPERVISOR_N3_4_ESP_USD_ID NOT IN (select SUPERVISOR_N3_ESPEC_ID from  D_CNT_SUPERVISOR_N3_ESPEC)';

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_EN_CARTERA_ESTUDIO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_EN_CARTERA_ESTUDIO where EN_CARTERA_ESTUDIO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_CARTERA_ESTUDIO (EN_CARTERA_ESTUDIO_ID, EN_CARTERA_ESTUDIO_DESC) values (-1, 'Desconocido');
  end if;

  -- Customizar valores de las descripciones según universo a estudiar
  select count(*) into V_NUM_ROW from D_CNT_EN_CARTERA_ESTUDIO where EN_CARTERA_ESTUDIO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_CARTERA_ESTUDIO (EN_CARTERA_ESTUDIO_ID, EN_CARTERA_ESTUDIO_DESC) values (0 ,'No En Cartera Estudio');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_EN_CARTERA_ESTUDIO where EN_CARTERA_ESTUDIO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_EN_CARTERA_ESTUDIO (EN_CARTERA_ESTUDIO_ID, EN_CARTERA_ESTUDIO_DESC) values (1 ,'En Fallidos Bankia-FROB');
  end if;

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MODELO_GESTION_CARTERA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MODELO_GESTION_CARTERA where MODELO_GESTION_CARTERA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MODELO_GESTION_CARTERA (MODELO_GESTION_CARTERA_ID, MODELO_GESTION_CARTERA_DESC) values (-1, 'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_MODELO_GESTION_CARTERA where MODELO_GESTION_CARTERA_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MODELO_GESTION_CARTERA (MODELO_GESTION_CARTERA_ID, MODELO_GESTION_CARTERA_DESC) values (0 ,'Masiva');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_MODELO_GESTION_CARTERA where MODELO_GESTION_CARTERA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MODELO_GESTION_CARTERA (MODELO_GESTION_CARTERA_ID, MODELO_GESTION_CARTERA_DESC) values (1 ,'Especializada');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_MODELO_GESTION_CARTERA where MODELO_GESTION_CARTERA_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MODELO_GESTION_CARTERA (MODELO_GESTION_CARTERA_ID, MODELO_GESTION_CARTERA_DESC) values (2 ,'Resto');
  end if;

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_UNIDAD_GESTION_CARTERA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_UNIDAD_GESTION_CARTERA where UNIDAD_GESTION_CARTERA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_UNIDAD_GESTION_CARTERA (UNIDAD_GESTION_CARTERA_ID, UNIDAD_GESTION_CARTERA_DESC) values (-1, 'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_UNIDAD_GESTION_CARTERA where UNIDAD_GESTION_CARTERA_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_UNIDAD_GESTION_CARTERA (UNIDAD_GESTION_CARTERA_ID, UNIDAD_GESTION_CARTERA_DESC) values (0 ,'Bankia 1');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_UNIDAD_GESTION_CARTERA where UNIDAD_GESTION_CARTERA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_UNIDAD_GESTION_CARTERA (UNIDAD_GESTION_CARTERA_ID, UNIDAD_GESTION_CARTERA_DESC) values (1 ,'Bankia 2');
  end if;

  commit;
  */
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CON_CAPITAL_FALLIDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CON_CAPITAL_FALLIDO where CNT_CON_CAPITAL_FALLIDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_CAPITAL_FALLIDO (CNT_CON_CAPITAL_FALLIDO_ID, CNT_CON_CAPITAL_FALLIDO_DESC) values (-1, 'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_CON_CAPITAL_FALLIDO where CNT_CON_CAPITAL_FALLIDO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_CAPITAL_FALLIDO (CNT_CON_CAPITAL_FALLIDO_ID, CNT_CON_CAPITAL_FALLIDO_DESC) values (0 ,'Sin Capital Fallido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CON_CAPITAL_FALLIDO where CNT_CON_CAPITAL_FALLIDO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CON_CAPITAL_FALLIDO (CNT_CON_CAPITAL_FALLIDO_ID, CNT_CON_CAPITAL_FALLIDO_DESC) values (1 ,'Con Capital Fallido');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CON_CAPITAL_FALLIDO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_GESTION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_GESTION where TIPO_GESTION_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_GESTION (TIPO_GESTION_CONTRATO_ID, TIPO_GESTION_CONTRATO_DESC) values (-1, 'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_TIPO_GESTION where TIPO_GESTION_CONTRATO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_GESTION (TIPO_GESTION_CONTRATO_ID, TIPO_GESTION_CONTRATO_DESC) values (0 ,'No Judicial');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TIPO_GESTION where TIPO_GESTION_CONTRATO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_GESTION (TIPO_GESTION_CONTRATO_ID, TIPO_GESTION_CONTRATO_DESC) values (1 ,'Litigio');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TIPO_GESTION where TIPO_GESTION_CONTRATO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_GESTION (TIPO_GESTION_CONTRATO_ID, TIPO_GESTION_CONTRATO_DESC) values (2 ,'Concurso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TIPO_GESTION where TIPO_GESTION_CONTRATO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_GESTION (TIPO_GESTION_CONTRATO_ID, TIPO_GESTION_CONTRATO_DESC) values (3 ,'Conjunta Litigio/Concurso');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_GESTION. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESQUEMA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESQUEMA where ESQUEMA_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESQUEMA (ESQUEMA_CONTRATO_ID, ESQUEMA_CONTRATO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_ESQUEMA (ESQUEMA_CONTRATO_ID, ESQUEMA_CONTRATO_DESC)
     select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_DATASTAGE || '.RCF_ESQ_ESQUEMA RCF
     where not exists (select 1 from D_CNT_ESQUEMA EXP where EXP.ESQUEMA_CONTRATO_ID = RCF.RCF_ESQ_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESQUEMA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CARTERA_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CARTERA_EXPEDIENTE where CARTERA_EXPEDIENTE_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA_EXPEDIENTE (CARTERA_EXPEDIENTE_CNT_ID, CARTERA_EXPEDIENTE_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_CARTERA_EXPEDIENTE (CARTERA_EXPEDIENTE_CNT_ID, CARTERA_EXPEDIENTE_CNT_DESC)
     select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_DATASTAGE || '.RCF_CAR_CARTERA RCF
     where not exists (select 1 from D_CNT_CARTERA_EXPEDIENTE EXP where EXP.CARTERA_EXPEDIENTE_CNT_ID = RCF.RCF_CAR_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CARTERA_EXPEDIENTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUBCARTERA_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUBCARTERA_EXPEDIENTE where SUBCARTERA_EXPEDIENTE_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUBCARTERA_EXPEDIENTE (SUBCARTERA_EXPEDIENTE_CNT_ID, SUBCARTERA_EXPEDIENTE_CNT_DESC, CARTERA_EXPEDIENTE_CNT_ID) values (-1 ,'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_SUBCARTERA_EXPEDIENTE (SUBCARTERA_EXPEDIENTE_CNT_ID, SUBCARTERA_EXPEDIENTE_CNT_DESC, CARTERA_EXPEDIENTE_CNT_ID)
      select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID
      from ' || V_DATASTAGE || '.RCF_SCA_SUBCARTERA SUB
      INNER JOIN ' || V_DATASTAGE || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
      INNER JOIN ' || V_DATASTAGE || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
      where not exists (select 1 from D_CNT_SUBCARTERA_EXPEDIENTE EXP where EXP.SUBCARTERA_EXPEDIENTE_CNT_ID = SUB.RCF_SCA_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SUBCARTERA_EXPEDIENTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_AGENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_AGENCIA where AGENCIA_CONTRATO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_AGENCIA (AGENCIA_CONTRATO_ID, AGENCIA_CONTRATO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_AGENCIA (AGENCIA_CONTRATO_ID, AGENCIA_CONTRATO_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_DATASTAGE || '.RCF_AGE_AGENCIAS RCF	where not exists (select 1 from D_CNT_AGENCIA EXP where EXP.AGENCIA_CONTRATO_ID = RCF.RCF_AGE_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_AGENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_SALIDA_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  /*select count(*) into V_NUM_ROW from D_CNT_TIPO_SALIDA_EXPEDIENTE where TIPO_SALIDA_EXP_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_SALIDA_EXPEDIENTE (TIPO_SALIDA_EXP_CNT_ID, TIPO_SALIDA_EXP_CNT_DESC) values (-1 ,'Desconocido');
  end if;*/

/*  execute immediate
    'insert into D_CNT_TIPO_SALIDA_EXPEDIENTE (TIPO_SALIDA_EXP_CNT_ID, TIPO_SALIDA_EXP_CNT_DESC)
     select ID_TIPO_SALIDA, DESC_TIPO_SALIDA from '||V_DATASTAGE||'.EXPEDIENTES_FAKE where ID_TIPO_SALIDA is NOT null GROUP BY ID_TIPO_SALIDA';*/

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MOTIVO_SALIDA_EXP
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MOTIVO_SALIDA_EXP where MOTIVO_SALIDA_EXP_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MOTIVO_SALIDA_EXP (MOTIVO_SALIDA_EXP_CNT_ID, MOTIVO_SALIDA_EXP_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_MOTIVO_SALIDA_EXP (MOTIVO_SALIDA_EXP_CNT_ID, MOTIVO_SALIDA_EXP_CNT_DESC)
     select DD_MOB_ID, DD_MOB_DESCRIPCION from ' || V_DATASTAGE || '.DD_MOB_MOTIVOS_BAJA MOB
     where MOB.DD_MOB_ID is not null and not exists (select 1 from D_CNT_MOTIVO_SALIDA_EXP EXP where EXP.MOTIVO_SALIDA_EXP_CNT_ID = MOB.DD_MOB_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MOTIVO_SALIDA_EXP. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

  /*
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_INCIDENCIA_EXP
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_INCIDENCIA_EXP where TIPO_INCIDENCIA_EXP_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_INCIDENCIA_EXP (TIPO_INCIDENCIA_EXP_CNT_ID, TIPO_INCIDENCIA_EXP_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_TIPO_INCIDENCIA_EXP (TIPO_INCIDENCIA_EXP_CNT_ID, TIPO_INCIDENCIA_EXP_CNT_DESC)
     select DD_TII_ID, DD_TII_DESCRIPCION from ' || V_DATASTAGE || '.DD_TII_TIPO_INCIDENCIA TII
     where TII.DD_TII_ID is not null and not exists (select 1 from D_CNT_TIPO_INCIDENCIA_EXP EXP where EXP.TIPO_INCIDENCIA_EXP_CNT_ID = TII.DD_TII_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_INCIDENCIA_EXP. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESTADO_INCIDENCIA_EXP
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_INCIDENCIA_EXP where ESTADO_INCIDENCIA_EXP_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_INCIDENCIA_EXP (ESTADO_INCIDENCIA_EXP_CNT_ID, ESTADO_INCIDENCIA_EXP_CNT_DESC) values (-1 ,'Desconocido');
  end if;*/

  /*execute immediate
    'insert into D_CNT_ESTADO_INCIDENCIA_EXP (ESTADO_INCIDENCIA_EXP_CNT_ID, ESTADO_INCIDENCIA_EXP_CNT_DESC)
    select ID_ESTADO_INCIDENCIA, DESC_ESTADO_INCIDENCIA from '||V_DATASTAGE||'.EXPEDIENTES_FAKE where ID_ESTADO_INCIDENCIA is NOT null GROUP BY ID_ESTADO_INCIDENCIA';*/

  commit;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_SALDO_TOTAL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (0 ,'0 € - 30.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (1 ,'30.000 € - 60.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (2 ,'60.000 € - 90.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (3 ,'90.000 € - 120.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (4 , '120.000 € - 150.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (5, '150.000 € - 180.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (6 ,'180.000 € - 300.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (7, '300.000 € - 400.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_TOTAL where T_SALDO_TOTAL_CNT_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_TOTAL (T_SALDO_TOTAL_CNT_ID, T_SALDO_TOTAL_CNT_DESC) values (8 ,'> 400.000 €');
  end if;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_SALDO_IRREGULAR. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_SALDO_IRREGULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_CNT_ID, T_SALDO_IRREGULAR_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_CNT_ID, T_SALDO_IRREGULAR_CNT_DESC) values (0 ,'0 € - 25.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_CNT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_CNT_ID, T_SALDO_IRREGULAR_CNT_DESC) values (1 ,'25.000 € - 50.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_CNT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_CNT_ID, T_SALDO_IRREGULAR_CNT_DESC) values (2 ,'50.000 € - 75.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_SALDO_IRREGULAR where T_SALDO_IRREGULAR_CNT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_SALDO_IRREGULAR (T_SALDO_IRREGULAR_CNT_ID, T_SALDO_IRREGULAR_CNT_DESC) values (3 ,'> 75.000 €');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_SALDO_IRREGULAR. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_DEUDA_IRREGULAR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (0 ,'0 € - 30.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (1 ,'30.000 € - 60.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (2 ,'60.000 € - 90.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (3 ,'90.000 € - 120.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (4 , '120.000 € - 150.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (5, '150.000 € - 180.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (6 ,'180.000 € - 300.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (7, '300.000 € - 400.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR where T_DEUDA_IRREGULAR_CNT_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR (T_DEUDA_IRREGULAR_CNT_ID, T_DEUDA_IRREGULAR_CNT_DESC) values (8 ,'> 400.000 €');
  end if;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_SALDO_IRREGULAR. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_COBRO
-- ----------------------------------------------------------------------------------------------

select count(1) into V_NUM_ROW from D_CNT_TIPO_COBRO where TIPO_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
	V_SQL := 'insert into D_CNT_TIPO_COBRO (TIPO_COBRO_ID, TIPO_COBRO_DESC) values (-1 ,''Desconocido'')';
   execute immediate(V_SQL);
  end if;

	V_SQL :=  'insert into D_CNT_TIPO_COBRO (TIPO_COBRO_ID, TIPO_COBRO_DESC)
    select DD_TCP_ID, DD_TCP_DESCRIPCION from ' || V_DATASTAGE || '.DD_TCP_TIPO_COBRO_PAGO tcp
	where not exists (select 1 from D_CNT_TIPO_COBRO cnt where cnt.TIPO_COBRO_ID = tcp.DD_TCP_ID)';
	execute immediate (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_COBRO_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(1) into V_NUM_ROW from D_CNT_TIPO_COBRO_DETALLE where TIPO_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
	V_SQL := 'insert into D_CNT_TIPO_COBRO_DETALLE (TIPO_COBRO_DET_ID, TIPO_COBRO_DET_DESC, TIPO_COBRO_ID) values (-1 ,''Desconocido'', -1)';
   execute immediate(V_SQL);
  end if;

	V_SQL :=  'insert into D_CNT_TIPO_COBRO_DETALLE (TIPO_COBRO_DET_ID, TIPO_COBRO_DET_DESC, TIPO_COBRO_ID)
    select DD_SCP_ID, DD_SCP_DESCRIPCION, DD_TCP_ID from ' || V_DATASTAGE || '.DD_SCP_SUBTIPO_COBRO_PAGO scp
	where not exists (select 1 from D_CNT_TIPO_COBRO_DETALLE cnt where cnt.TIPO_COBRO_DET_ID = scp.DD_SCP_ID)';
	execute immediate (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_COBRO_DETALLE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_COBRO_FACTURADO
-- ----------------------------------------------------------------------------------------------
  execute immediate 'insert into D_CNT_COBRO_FACTURADO (COBRO_FACTURADO_ID, COBRO_FACTURADO_DESC)
                    select -1, ''Desconocido'' from dual where not exists (select 1 from D_CNT_COBRO_FACTURADO where COBRO_FACTURADO_ID = -1)';

  execute immediate 'insert into D_CNT_COBRO_FACTURADO (COBRO_FACTURADO_ID, COBRO_FACTURADO_DESC)
                    select 0, ''No Facturado'' from dual where not exists (select 1 from D_CNT_COBRO_FACTURADO where COBRO_FACTURADO_ID = 0)';

  execute immediate 'insert into D_CNT_COBRO_FACTURADO (COBRO_FACTURADO_ID, COBRO_FACTURADO_DESC)
                    select 1, ''Facturado'' from dual where not exists (select 1 from D_CNT_COBRO_FACTURADO where COBRO_FACTURADO_ID = 1)';

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_COBRO_FACTURADO. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_REMESA_FACTURA
-- ----------------------------------------------------------------------------------------------

select count(1) into V_NUM_ROW from D_CNT_REMESA_FACTURA where REMESA_FACTURA_ID = -1;
  if (V_NUM_ROW = 0) then
	V_SQL := 'insert into D_CNT_REMESA_FACTURA (REMESA_FACTURA_ID, REMESA_FACTURA_DESC) values (-1 ,''Desconocido'')';
   execute immediate(V_SQL);
  end if;

	V_SQL :=  'insert into D_CNT_REMESA_FACTURA (REMESA_FACTURA_ID, REMESA_FACTURA_DESC)
    select PRF_ID, PRF_NOMBRE from ' || V_DATASTAGE || '.PRF_PROCESO_FACTURACION PRF
	where not exists (select 1 from D_CNT_REMESA_FACTURA EXP where EXP.REMESA_FACTURA_ID = PRF.PRF_ID)';
	execute immediate (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_REMESA_FACTURA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CLASIFICACION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CLASIFICACION where CLASIFICACION_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CLASIFICACION (CLASIFICACION_CNT_ID, CLASIFICACION_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_CLASIFICACION where CLASIFICACION_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CLASIFICACION (CLASIFICACION_CNT_ID, CLASIFICACION_CNT_DESC) values (0 ,'Resto');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_CLASIFICACION where CLASIFICACION_CNT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CLASIFICACION (CLASIFICACION_CNT_ID, CLASIFICACION_CNT_DESC) values (1 ,'En Ciclo de Recobro');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CLASIFICACION. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SEGMENTO_CARTERA
-- ----------------------------------------------------------------------------------------------

select count(1) into V_NUM_ROW from D_CNT_SEGMENTO_CARTERA where SEGMENTO_CARTERA_ID = -1;
  if (V_NUM_ROW = 0) then
	V_SQL := 'insert into D_CNT_SEGMENTO_CARTERA (SEGMENTO_CARTERA_ID, SEGMENTO_CARTERA_DESC) values (-1 ,''Desconocido'')';
   execute immediate(V_SQL);
  end if;

	V_SQL :=  'insert into D_CNT_SEGMENTO_CARTERA (SEGMENTO_CARTERA_ID, SEGMENTO_CARTERA_DESC)
    select DD_SEC_ID, DD_SEC_DESCRIPCION from ' || V_DATASTAGE || '.DD_SEC_SEGMENTO_CARTERA
	where not exists (select 1 from D_CNT_SEGMENTO_CARTERA where SEGMENTO_CARTERA_ID = DD_SEC_ID)';
	execute immediate (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SEGMENTO_CARTERA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ENVIADO_AGENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA where ENVIADO_AGENCIA_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA (ENVIADO_AGENCIA_CNT_ID, ENVIADO_AGENCIA_CNT_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA where ENVIADO_AGENCIA_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA (ENVIADO_AGENCIA_CNT_ID, ENVIADO_AGENCIA_CNT_DESC) values (0 ,'No Enviado a Agencia');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA where ENVIADO_AGENCIA_CNT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA (ENVIADO_AGENCIA_CNT_ID, ENVIADO_AGENCIA_CNT_DESC) values (1 ,'Enviado a Agencia');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ENVIADO_AGENCIA. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESQUEMA_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESQUEMA_COBRO where ESQUEMA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESQUEMA_COBRO (ESQUEMA_COBRO_ID, ESQUEMA_COBRO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_ESQUEMA_COBRO (ESQUEMA_COBRO_ID, ESQUEMA_COBRO_DESC)
     select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_DATASTAGE || '.RCF_ESQ_ESQUEMA RCF
     where not exists (select 1 from D_CNT_ESQUEMA_COBRO EXP where EXP.ESQUEMA_COBRO_ID = RCF.RCF_ESQ_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESQUEMA_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CARTERA_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CARTERA_COBRO where CARTERA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA_COBRO (CARTERA_COBRO_ID, CARTERA_COBRO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_CARTERA_COBRO (CARTERA_COBRO_ID, CARTERA_COBRO_DESC)
     select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_DATASTAGE || '.RCF_CAR_CARTERA RCF
     where not exists (select 1 from D_CNT_CARTERA_COBRO EXP where EXP.CARTERA_COBRO_ID = RCF.RCF_CAR_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CARTERA_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUBCARTERA_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUBCARTERA_COBRO where SUBCARTERA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUBCARTERA_COBRO (SUBCARTERA_COBRO_ID, SUBCARTERA_COBRO_DESC, CARTERA_COBRO_ID) values (-1 ,'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_SUBCARTERA_COBRO (SUBCARTERA_COBRO_ID, SUBCARTERA_COBRO_DESC, CARTERA_COBRO_ID)
      select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID
      from ' || V_DATASTAGE || '.RCF_SCA_SUBCARTERA SUB
      INNER JOIN ' || V_DATASTAGE || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
      INNER JOIN ' || V_DATASTAGE || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
      where not exists (select 1 from D_CNT_SUBCARTERA_COBRO EXP where EXP.SUBCARTERA_COBRO_ID = SUB.RCF_SCA_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SUBCARTERA_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_AGENCIA_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_AGENCIA_COBRO where AGENCIA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_AGENCIA_COBRO (AGENCIA_COBRO_ID, AGENCIA_COBRO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_AGENCIA_COBRO (AGENCIA_COBRO_ID, AGENCIA_COBRO_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_DATASTAGE || '.RCF_AGE_AGENCIAS RCF	where not exists (select 1 from D_CNT_AGENCIA_COBRO EXP where EXP.AGENCIA_COBRO_ID = RCF.RCF_AGE_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_AGENCIA_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_TIPO_PRODUCTO_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_PRODUCTO_COBRO where TIPO_PRODUCTO_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_PRODUCTO_COBRO (TIPO_PRODUCTO_COBRO_ID, TIPO_PRODUCTO_COBRO_DESC, TIPO_PRODUCTO_COBRO_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
  end if;

 execute immediate
    'insert into D_CNT_TIPO_PRODUCTO_COBRO(TIPO_PRODUCTO_COBRO_ID, TIPO_PRODUCTO_COBRO_DESC, TIPO_PRODUCTO_COBRO_DESC_2)
    select DD_TPE_ID, DD_TPE_DESCRIPCION, DD_TPE_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_TPE_TIPO_PROD_ENTIDAD';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_PRODUCTO_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                    D_CNT_GARANTIA_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_GARANTIA_COBRO where GARANTIA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_GARANTIA_COBRO (GARANTIA_COBRO_ID, GARANTIA_COBRO_DESC, GARANTIA_COBRO_DESC_2)
    values (-1 ,'Desconocido', 'Desconocido');
  end if;

  execute immediate
  'insert into D_CNT_GARANTIA_COBRO(GARANTIA_COBRO_ID, GARANTIA_COBRO_DESC, GARANTIA_COBRO_DESC_2)
   select DD_GCN_ID, DD_GCN_DESCRIPCION, DD_GCN_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_GCN_GARANTIA_CONTRATO';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_GARANTIA_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SEGMENTO_CARTERA_COBRO
-- ----------------------------------------------------------------------------------------------

select count(1) into V_NUM_ROW from D_CNT_SEGMENTO_CARTERA_COBRO where SEGMENTO_CARTERA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
	V_SQL := 'insert into D_CNT_SEGMENTO_CARTERA_COBRO (SEGMENTO_CARTERA_COBRO_ID, SEGMENTO_CARTERA_COBRO_DESC) values (-1 ,''Desconocido'')';
   execute immediate(V_SQL);
  end if;

	V_SQL :=  'insert into D_CNT_SEGMENTO_CARTERA_COBRO (SEGMENTO_CARTERA_COBRO_ID, SEGMENTO_CARTERA_COBRO_DESC)
    select DD_SEC_ID, DD_SEC_DESCRIPCION from ' || V_DATASTAGE || '.DD_SEC_SEGMENTO_CARTERA
	where not exists (select 1 from D_CNT_SEGMENTO_CARTERA_COBRO where SEGMENTO_CARTERA_COBRO_ID = DD_SEC_ID)';
	execute immediate (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SEGMENTO_CARTERA_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TD_IRREG_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (0 ,'Sin Irregularidad');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (1 ,'<= 30 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (2 ,'31-60 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (3 ,'61-90 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (4 ,'91-120 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (5 ,'121 Días-1 Año');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (6 ,'1-3 Años');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TD_IRREG_COBRO where TD_IRREG_COBRO_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TD_IRREG_COBRO (TD_IRREG_COBRO_ID, TD_IRREG_COBRO_DESC) values (7 ,'> 3 Años');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TD_IRREG_COBRO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_DEUDA_IRREGULAR_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR_COBRO where T_DEUDA_IRREGULAR_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR_COBRO (T_DEUDA_IRREGULAR_COBRO_ID, T_DEUDA_IRREGULAR_COBRO_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR_COBRO where T_DEUDA_IRREGULAR_COBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR_COBRO (T_DEUDA_IRREGULAR_COBRO_ID, T_DEUDA_IRREGULAR_COBRO_DESC) values (0 ,'0 € - 25.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR_COBRO where T_DEUDA_IRREGULAR_COBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR_COBRO (T_DEUDA_IRREGULAR_COBRO_ID, T_DEUDA_IRREGULAR_COBRO_DESC) values (1 ,'25.000 € - 50.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR_COBRO where T_DEUDA_IRREGULAR_COBRO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR_COBRO (T_DEUDA_IRREGULAR_COBRO_ID, T_DEUDA_IRREGULAR_COBRO_DESC) values (2 ,'50.000 € - 75.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_DEUDA_IRREGULAR_COBRO where T_DEUDA_IRREGULAR_COBRO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_DEUDA_IRREGULAR_COBRO (T_DEUDA_IRREGULAR_COBRO_ID, T_DEUDA_IRREGULAR_COBRO_DESC) values (3 ,'> 75.000 €');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_DEUDA_IRREGULAR_COBRO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ENVIADO_AGENCIA_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_COBRO where ENVIADO_AGENCIA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_COBRO (ENVIADO_AGENCIA_COBRO_ID, ENVIADO_AGENCIA_COBRO_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_COBRO where ENVIADO_AGENCIA_COBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_COBRO (ENVIADO_AGENCIA_COBRO_ID, ENVIADO_AGENCIA_COBRO_DESC) values (0 ,'No Enviado a Agencia');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_COBRO where ENVIADO_AGENCIA_COBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_COBRO (ENVIADO_AGENCIA_COBRO_ID, ENVIADO_AGENCIA_COBRO_DESC) values (1 ,'Enviado a Agencia');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ENVIADO_AGENCIA_COBRO. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_FACTURA_COBRO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_FACTURA_COBRO where FACTURA_COBRO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_FACTURA_COBRO (FACTURA_COBRO_ID, FACTURA_COBRO_DESC) values (-1 ,'Desconocido');
  end if; 
 
  select count(*) into V_NUM_ROW from D_CNT_FACTURA_COBRO where FACTURA_COBRO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_FACTURA_COBRO (FACTURA_COBRO_ID, FACTURA_COBRO_DESC) values (0 ,'FACTURACION RECOVERY 18.10 AL 30.11 DE 2014');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_FACTURA_COBRO where FACTURA_COBRO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_FACTURA_COBRO (FACTURA_COBRO_ID, FACTURA_COBRO_DESC) values (1 ,'FACTURACION RECOVERY 01.12 AL 31.12 DE 2014');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_FACTURA_COBRO where FACTURA_COBRO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_FACTURA_COBRO (FACTURA_COBRO_ID, FACTURA_COBRO_DESC) values (2 ,'FACTURACION RECOVERY 01.01 AL 31.01 DE 2015');
  end if;
  
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_FACTURA_COBRO. Realizados INSERTS', 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MOTIVO_BAJA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MOTIVO_BAJA_CR where MOTIVO_BAJA_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MOTIVO_BAJA_CR (MOTIVO_BAJA_CR_ID, MOTIVO_BAJA_CR_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_MOTIVO_BAJA_CR (MOTIVO_BAJA_CR_ID, MOTIVO_BAJA_CR_DESC)
     select DD_MOB_ID, DD_MOB_DESCRIPCION from ' || V_DATASTAGE || '.DD_MOB_MOTIVOS_BAJA MOB
     where MOB.DD_MOB_ID is not null and not exists (select 1 from D_CNT_MOTIVO_BAJA_CR mot where mot.MOTIVO_BAJA_CR_ID = MOB.DD_MOB_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MOTIVO_BAJA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESQUEMA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESQUEMA_CR where ESQUEMA_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESQUEMA_CR (ESQUEMA_CR_ID, ESQUEMA_CR_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_ESQUEMA_CR (ESQUEMA_CR_ID, ESQUEMA_CR_DESC)
     select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_DATASTAGE || '.RCF_ESQ_ESQUEMA RCF
     where not exists (select 1 from D_CNT_ESQUEMA_CR EXP where EXP.ESQUEMA_CR_ID = RCF.RCF_ESQ_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESQUEMA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CARTERA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CARTERA_CR where CARTERA_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA_CR (CARTERA_CR_ID, CARTERA_CR_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_CARTERA_CR (CARTERA_CR_ID, CARTERA_CR_DESC)
     select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_DATASTAGE || '.RCF_CAR_CARTERA RCF
     where not exists (select 1 from D_CNT_CARTERA_CR EXP where EXP.CARTERA_CR_ID = RCF.RCF_CAR_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CARTERA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUBCARTERA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUBCARTERA_CR where SUBCARTERA_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUBCARTERA_CR (SUBCARTERA_CR_ID, SUBCARTERA_CR_DESC, CARTERA_CR_ID) values (-1 ,'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_SUBCARTERA_CR (SUBCARTERA_CR_ID, SUBCARTERA_CR_DESC, CARTERA_CR_ID)
      select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID
      from ' || V_DATASTAGE || '.RCF_SCA_SUBCARTERA SUB
      INNER JOIN ' || V_DATASTAGE || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
      INNER JOIN ' || V_DATASTAGE || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
      where not exists (select 1 from D_CNT_SUBCARTERA_CR EXP where EXP.SUBCARTERA_CR_ID = SUB.RCF_SCA_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SUBCARTERA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_AGENCIA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_AGENCIA_CR where AGENCIA_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_AGENCIA_CR (AGENCIA_CR_ID, AGENCIA_CR_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_AGENCIA_CR (AGENCIA_CR_ID, AGENCIA_CR_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_DATASTAGE || '.RCF_AGE_AGENCIAS RCF	where not exists (select 1 from D_CNT_AGENCIA_CR EXP where EXP.AGENCIA_CR_ID = RCF.RCF_AGE_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_AGENCIA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SEGMENTO_CARTERA_CR
-- ----------------------------------------------------------------------------------------------

select count(1) into V_NUM_ROW from D_CNT_SEGMENTO_CARTERA_CR where SEGMENTO_CARTERA_CR_ID = -1;
  if (V_NUM_ROW = 0) then
	V_SQL := 'insert into D_CNT_SEGMENTO_CARTERA_CR (SEGMENTO_CARTERA_CR_ID, SEGMENTO_CARTERA_CR_DESC) values (-1 ,''Desconocido'')';
   execute immediate(V_SQL);
  end if;

	V_SQL :=  'insert into D_CNT_SEGMENTO_CARTERA_CR (SEGMENTO_CARTERA_CR_ID, SEGMENTO_CARTERA_CR_DESC)
    select DD_SEC_ID, DD_SEC_DESCRIPCION from ' || V_DATASTAGE || '.DD_SEC_SEGMENTO_CARTERA
	where not exists (select 1 from D_CNT_SEGMENTO_CARTERA_CR where SEGMENTO_CARTERA_CR_ID = DD_SEC_ID)';
	execute immediate (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SEGMENTO_CARTERA_CR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ENVIADO_AGENCIA_CR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_CR where ENVIADO_AGENCIA_CR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_CR (ENVIADO_AGENCIA_CR_ID, ENVIADO_AGENCIA_CR_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_CR where ENVIADO_AGENCIA_CR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_CR (ENVIADO_AGENCIA_CR_ID, ENVIADO_AGENCIA_CR_DESC) values (0 ,'No Enviado a Agencia');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_CR where ENVIADO_AGENCIA_CR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_CR (ENVIADO_AGENCIA_CR_ID, ENVIADO_AGENCIA_CR_DESC) values (1 ,'Enviado a Agencia');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ENVIADO_AGENCIA_CR. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESTADO_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESTADO_ACUERDO where ESTADO_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESTADO_ACUERDO (ESTADO_ACUERDO_ID, ESTADO_ACUERDO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_ESTADO_ACUERDO (ESTADO_ACUERDO_ID, ESTADO_ACUERDO_DESC)
     select DD_EAC_ID, DD_EAC_DESCRIPCION from ' || V_DATASTAGE || '.DD_EAC_ESTADO_ACUERDO eac
     where eac.DD_EAC_ID is not null and not exists (select 1 from D_CNT_ESTADO_ACUERDO deac where deac.ESTADO_ACUERDO_ID = eac.DD_EAC_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_ACUERDO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SOLICITANTE_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SOLICITANTE_ACUERDO where SOLICITANTE_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SOLICITANTE_ACUERDO (SOLICITANTE_ACUERDO_ID, SOLICITANTE_ACUERDO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_SOLICITANTE_ACUERDO (SOLICITANTE_ACUERDO_ID, SOLICITANTE_ACUERDO_DESC)
     select DD_SOL_ID, DD_SOL_DESCRIPCION from ' || V_DATASTAGE || '.DD_SOL_SOLICITANTE sol
     where sol.DD_SOL_ID is not null and not exists (select 1 from D_CNT_SOLICITANTE_ACUERDO dsol where dsol.SOLICITANTE_ACUERDO_ID = sol.DD_SOL_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SOLICITANTE_ACUERDO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_ACUERDO where TIPO_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_ACUERDO (TIPO_ACUERDO_ID, TIPO_ACUERDO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_TIPO_ACUERDO (TIPO_ACUERDO_ID, TIPO_ACUERDO_DESC)
     select RCF_TPP_ID, RCF_TPP_DESCRIPCION from ' || V_DATASTAGE || '.RCF_TPP_TIPO_PALANCA rcf
     where rcf.RCF_TPP_ID is not null and not exists (select 1 from D_CNT_TIPO_ACUERDO dtpa where dtpa.TIPO_ACUERDO_ID = rcf.RCF_TPP_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_ACUERDO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESQUEMA_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESQUEMA_ACUERDO where ESQUEMA_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESQUEMA_ACUERDO (ESQUEMA_ACUERDO_ID, ESQUEMA_ACUERDO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_ESQUEMA_ACUERDO (ESQUEMA_ACUERDO_ID, ESQUEMA_ACUERDO_DESC)
     select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_DATASTAGE || '.RCF_ESQ_ESQUEMA RCF
     where not exists (select 1 from D_CNT_ESQUEMA_ACUERDO EXP where EXP.ESQUEMA_ACUERDO_ID = RCF.RCF_ESQ_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESQUEMA_ACUERDO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CARTERA_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CARTERA_ACUERDO where CARTERA_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA_ACUERDO (CARTERA_ACUERDO_ID, CARTERA_ACUERDO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_CARTERA_ACUERDO (CARTERA_ACUERDO_ID, CARTERA_ACUERDO_DESC)
     select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_DATASTAGE || '.RCF_CAR_CARTERA RCF
     where not exists (select 1 from D_CNT_CARTERA_ACUERDO EXP where EXP.CARTERA_ACUERDO_ID = RCF.RCF_CAR_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CARTERA_ACUERDO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUBCARTERA_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUBCARTERA_ACUERDO where SUBCARTERA_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUBCARTERA_ACUERDO (SUBCARTERA_ACUERDO_ID, SUBCARTERA_ACUERDO_DESC, CARTERA_ACUERDO_ID) values (-1 ,'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_SUBCARTERA_ACUERDO (SUBCARTERA_ACUERDO_ID, SUBCARTERA_ACUERDO_DESC, CARTERA_ACUERDO_ID)
      select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID
      from ' || V_DATASTAGE || '.RCF_SCA_SUBCARTERA SUB
      INNER JOIN ' || V_DATASTAGE || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
      INNER JOIN ' || V_DATASTAGE || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
      where not exists (select 1 from D_CNT_SUBCARTERA_ACUERDO EXP where EXP.SUBCARTERA_ACUERDO_ID = SUB.RCF_SCA_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SUBCARTERA_ACUERDO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_AGENCIA_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_AGENCIA_ACUERDO where AGENCIA_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_AGENCIA_ACUERDO (AGENCIA_ACUERDO_ID, AGENCIA_ACUERDO_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_AGENCIA_ACUERDO (AGENCIA_ACUERDO_ID, AGENCIA_ACUERDO_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_DATASTAGE || '.RCF_AGE_AGENCIAS RCF	where not exists (select 1 from D_CNT_AGENCIA_ACUERDO EXP where EXP.AGENCIA_ACUERDO_ID = RCF.RCF_AGE_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_AGENCIA_ACUERDO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ENVIADO_AGENCIA_ACUERDO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_ACUERDO where ENVIADO_AGENCIA_ACUERDO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_ACUERDO (ENVIADO_AGENCIA_ACUERDO_ID, ENVIADO_AGENCIA_ACUERDO_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_ACUERDO where ENVIADO_AGENCIA_ACUERDO_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_ACUERDO (ENVIADO_AGENCIA_ACUERDO_ID, ENVIADO_AGENCIA_ACUERDO_DESC) values (0 ,'No Enviado a Agencia');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_ACUERDO where ENVIADO_AGENCIA_ACUERDO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_ACUERDO (ENVIADO_AGENCIA_ACUERDO_ID, ENVIADO_AGENCIA_ACUERDO_DESC) values (1 ,'Enviado a Agencia');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ENVIADO_AGENCIA_ACUERDO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_INCIDENCIA where TIPO_INCIDENCIA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_INCIDENCIA (TIPO_INCIDENCIA_ID, TIPO_INCIDENCIA_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_TIPO_INCIDENCIA (TIPO_INCIDENCIA_ID, TIPO_INCIDENCIA_DESC)
     select DD_TII_ID, DD_TII_DESCRIPCION from ' || V_DATASTAGE || '.DD_TII_TIPO_INCIDENCIA TII
     where TII.DD_TII_ID is not null and not exists (select 1 from D_CNT_TIPO_INCIDENCIA t where t.TIPO_INCIDENCIA_ID = TII.DD_TII_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_INCIDENCIA. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SITUACION_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SITUACION_INCIDENCIA where SITUACION_INCIDENCIA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SITUACION_INCIDENCIA (SITUACION_INCIDENCIA_ID, SITUACION_INCIDENCIA_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_SITUACION_INCIDENCIA (SITUACION_INCIDENCIA_ID, SITUACION_INCIDENCIA_DESC)
     select DD_SII_ID, DD_SII_DESCRIPCION from ' || V_DATASTAGE || '.DD_SII_SITUACION_EXPEDIENTE sii
     where sii.DD_SII_ID is not null and not exists (select 1 from D_CNT_SITUACION_INCIDENCIA s where s.SITUACION_INCIDENCIA_ID = sii.DD_SII_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION_INCIDENCIA. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESQUEMA_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESQUEMA_INCIDENCIA where ESQUEMA_INCIDENCIA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESQUEMA_INCIDENCIA (ESQUEMA_INCIDENCIA_ID, ESQUEMA_INCIDENCIA_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_ESQUEMA_INCIDENCIA (ESQUEMA_INCIDENCIA_ID, ESQUEMA_INCIDENCIA_DESC)
     select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_DATASTAGE || '.RCF_ESQ_ESQUEMA RCF
     where not exists (select 1 from D_CNT_ESQUEMA_INCIDENCIA EXP where EXP.ESQUEMA_INCIDENCIA_ID = RCF.RCF_ESQ_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESQUEMA_INCIDENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CARTERA_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CARTERA_INCIDENCIA where CARTERA_INCIDENCIA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA_INCIDENCIA (CARTERA_INCIDENCIA_ID, CARTERA_INCIDENCIA_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_CARTERA_INCIDENCIA (CARTERA_INCIDENCIA_ID, CARTERA_INCIDENCIA_DESC)
     select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_DATASTAGE || '.RCF_CAR_CARTERA RCF
     where not exists (select 1 from D_CNT_CARTERA_INCIDENCIA EXP where EXP.CARTERA_INCIDENCIA_ID = RCF.RCF_CAR_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CARTERA_INCIDENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUBCARTERA_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUBCARTERA_INCIDENCIA where SUBCARTERA_INCIDENCIA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUBCARTERA_INCIDENCIA (SUBCARTERA_INCIDENCIA_ID, SUBCARTERA_INCIDENCIA_DESC, CARTERA_INCIDENCIA_ID) values (-1 ,'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_SUBCARTERA_INCIDENCIA (SUBCARTERA_INCIDENCIA_ID, SUBCARTERA_INCIDENCIA_DESC, CARTERA_INCIDENCIA_ID)
      select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID
      from ' || V_DATASTAGE || '.RCF_SCA_SUBCARTERA SUB
      INNER JOIN ' || V_DATASTAGE || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
      INNER JOIN ' || V_DATASTAGE || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
      where not exists (select 1 from D_CNT_SUBCARTERA_INCIDENCIA EXP where EXP.SUBCARTERA_INCIDENCIA_ID = SUB.RCF_SCA_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SUBCARTERA_INCIDENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_AGENCIA_INCIDENCIA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_AGENCIA_INCIDENCIA where AGENCIA_INCIDENCIA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_AGENCIA_INCIDENCIA (AGENCIA_INCIDENCIA_ID, AGENCIA_INCIDENCIA_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_AGENCIA_INCIDENCIA (AGENCIA_INCIDENCIA_ID, AGENCIA_INCIDENCIA_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_DATASTAGE || '.RCF_AGE_AGENCIAS RCF	where not exists (select 1 from D_CNT_AGENCIA_INCIDENCIA EXP where EXP.AGENCIA_INCIDENCIA_ID = RCF.RCF_AGE_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_AGENCIA_INCIDENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ENVIADO_AGENCIA_INCI
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_INCI where ENVIADO_AGENCIA_INCI_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_INCI (ENVIADO_AGENCIA_INCI_ID, ENVIADO_AGENCIA_INCI_DESC) values (-1 ,'Desconocido');
  end if;

  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_INCI where ENVIADO_AGENCIA_INCI_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_INCI (ENVIADO_AGENCIA_INCI_ID, ENVIADO_AGENCIA_INCI_DESC) values (0 ,'No Enviado a Agencia');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_ENVIADO_AGENCIA_INCI where ENVIADO_AGENCIA_INCI_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ENVIADO_AGENCIA_INCI (ENVIADO_AGENCIA_INCI_ID, ENVIADO_AGENCIA_INCI_DESC) values (1 ,'Enviado a Agencia');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ENVIADO_AGENCIA_INCI. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESQUEMA_ER
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_ESQUEMA_ER where ESQUEMA_ER_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_ESQUEMA_ER (ESQUEMA_ER_ID, ESQUEMA_ER_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_ESQUEMA_ER (ESQUEMA_ER_ID, ESQUEMA_ER_DESC)
     select RCF_ESQ_ID, RCF_ESQ_NOMBRE from ' || V_DATASTAGE || '.RCF_ESQ_ESQUEMA RCF
     where not exists (select 1 from D_CNT_ESQUEMA_ER EXP where EXP.ESQUEMA_ER_ID = RCF.RCF_ESQ_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESQUEMA_ER. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CARTERA_ER
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_CARTERA_ER where CARTERA_ER_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_CARTERA_ER (CARTERA_ER_ID, CARTERA_ER_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_CARTERA_ER (CARTERA_ER_ID, CARTERA_ER_DESC)
     select RCF_CAR_ID, RCF_CAR_NOMBRE from ' || V_DATASTAGE || '.RCF_CAR_CARTERA RCF
     where not exists (select 1 from D_CNT_CARTERA_ER EXP where EXP.CARTERA_ER_ID = RCF.RCF_CAR_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CARTERA_ER. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SUBCARTERA_ER
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SUBCARTERA_ER where SUBCARTERA_ER_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SUBCARTERA_ER (SUBCARTERA_ER_ID, SUBCARTERA_ER_DESC, CARTERA_ER_ID) values (-1 ,'Desconocido', -1);
  end if;

  execute immediate
    'insert into D_CNT_SUBCARTERA_ER (SUBCARTERA_ER_ID, SUBCARTERA_ER_DESC, CARTERA_ER_ID)
      select SUB.RCF_SCA_ID, SUB.RCF_SCA_NOMBRE, CAR.RCF_CAR_ID
      from ' || V_DATASTAGE || '.RCF_SCA_SUBCARTERA SUB
      INNER JOIN ' || V_DATASTAGE || '.RCF_ESC_ESQUEMA_CARTERAS ESQCAR ON SUB.RCF_ESC_ID = ESQCAR.RCF_ESC_ID
      INNER JOIN ' || V_DATASTAGE || '.RCF_CAR_CARTERA CAR ON ESQCAR.RCF_CAR_ID = CAR.RCF_CAR_ID
      where not exists (select 1 from D_CNT_SUBCARTERA_ER EXP where EXP.SUBCARTERA_ER_ID = SUB.RCF_SCA_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SUBCARTERA_ER. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_AGENCIA_ER
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_AGENCIA_ER where AGENCIA_ER_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_AGENCIA_ER (AGENCIA_ER_ID, AGENCIA_ER_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'insert into D_CNT_AGENCIA_ER (AGENCIA_ER_ID, AGENCIA_ER_DESC)
    select RCF_AGE_ID, RCF_AGE_NOMBRE from ' || V_DATASTAGE || '.RCF_AGE_AGENCIAS RCF	where not exists (select 1 from D_CNT_AGENCIA_ER EXP where EXP.AGENCIA_ER_ID = RCF.RCF_AGE_ID)';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_AGENCIA_ER. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;





-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_RESULTADO_GESTION
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_RESULTADO_GESTION WHERE RESULTADO_GESTION_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_RESULTADO_GESTION (RESULTADO_GESTION_ID, RESULTADO_GESTION_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_RESULTADO_GESTION WHERE RESULTADO_GESTION_ID = -2;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_RESULTADO_GESTION (RESULTADO_GESTION_ID, RESULTADO_GESTION_DESC) values (-2 ,''Sin Gestión'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_CNT_RESULTADO_GESTION (RESULTADO_GESTION_ID, RESULTADO_GESTION_DESC)
    select DD_RGT_ID, DD_RGT_DESCRIPCION from ' || V_DATASTAGE || '.DD_RGT_RESULT_GESTION_TEL rgt
	where rgt.DD_RGT_ID is not null and not exists (select 1 from D_CNT_RESULTADO_GESTION RG WHERE RG.RESULTADO_GESTION_ID = rgt.DD_RGT_ID)';
	EXECUTE IMMEDIATE (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_RESULTADO_GESTION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_ACCION
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_TIPO_ACCION WHERE TIPO_ACCION_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_TIPO_ACCION (TIPO_ACCION_ID, TIPO_ACCION_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL :=  'insert into D_CNT_TIPO_ACCION (TIPO_ACCION_ID, TIPO_ACCION_DESC)
    select  DD_TGE_ID, DD_TGE_DESCRIPCION from ' || V_DATASTAGE || '.DD_TGE_TIPO_GESTION tge
	where not exists (select 1 from D_CNT_TIPO_ACCION TA WHERE TA.TIPO_ACCION_ID = tge.DD_TGE_ID)';
	EXECUTE IMMEDIATE (V_SQL);

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_ACCION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                 D_CNT_GESTOR_CREDITO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_CNT_GESTOR_CREDITO WHERE GESTOR_CREDITO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_CNT_GESTOR_CREDITO(
      GESTOR_CREDITO_ID,
      GESTOR_CREDITO_NOMBRE_COMPLETO,
      GESTOR_CREDITO_NOMBRE,
      GESTOR_CREDITO_APELLIDO1,
      GESTOR_CREDITO_APELLIDO2,
      DESPACHO_GESTOR_CREDITO_ID) VALUES (-1 ,'Sin Gestor Asignado','Sin Gestor Asignado', 'Sin Gestor Asignado', 'Sin Gestor Asignado', -1);
  END IF;

  EXECUTE IMMEDIATE
  'INSERT INTO D_CNT_GESTOR_CREDITO (
      GESTOR_CREDITO_ID,
      GESTOR_CREDITO_NOMBRE_COMPLETO,
      GESTOR_CREDITO_NOMBRE,
      GESTOR_CREDITO_APELLIDO1,
      GESTOR_CREDITO_APELLIDO2,
      DESPACHO_GESTOR_CREDITO_ID
      )
  SELECT USU.USU_ID,
      NVL(TRIM(REPLACE(USU.USU_NOMBRE||'' ''||USU.USU_APELLIDO1||'' ''||USU.USU_APELLIDO2,'' '',''  '')), ''Desconocido''),
      NVL(USU.USU_NOMBRE, ''Desconocido''),
      NVL(USU.USU_APELLIDO1, ''Desconocido''),
      NVL(USU.USU_APELLIDO2, ''Desconocido''),
      USD.DES_ID
  FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD
    JOIN '||V_DATASTAGE||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
    JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
    JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID
  WHERE TGES.DD_TGE_DESCRIPCION = ''Letrado''
  GROUP BY USU.USU_ID, USU.USU_NOMBRE, USU.USU_APELLIDO1, USU.USU_APELLIDO2, USU.ENTIDAD_ID, USD.DES_ID';

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_GESTOR_CREDITO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_DESPACHO_GESTOR_CREDITO
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_DESPACHO_GESTOR_CREDITO WHERE DESPACHO_GESTOR_CREDITO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_DESPACHO_GESTOR_CREDITO (DESPACHO_GESTOR_CREDITO_ID, DESPACHO_GESTOR_CREDITO_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL := 'insert into D_CNT_DESPACHO_GESTOR_CREDITO (DESPACHO_GESTOR_CREDITO_ID, DESPACHO_GESTOR_CREDITO_DESC)
    select DES_ID, DES_DESPACHO from ' || V_DATASTAGE || '.DES_DESPACHO_EXTERNO des
	where not exists (select 1 from D_CNT_DESPACHO_GESTOR_CREDITO dgc WHERE dgc.DESPACHO_GESTOR_CREDITO_ID = des.DES_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_DESPACHO_GESTOR_CREDITO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_ESTADO_INSI_CREDITO
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_ESTADO_INSI_CREDITO WHERE ESTADO_INSI_CREDITO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_ESTADO_INSI_CREDITO (ESTADO_INSI_CREDITO_ID, ESTADO_INSI_CREDITO_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL := 'insert into D_CNT_ESTADO_INSI_CREDITO (ESTADO_INSI_CREDITO_ID, ESTADO_INSI_CREDITO_DESC)
    select STD_CRE_ID, STD_CRE_DESCRIP from ' || V_DATASTAGE || '.DD_STD_CREDITO std
	where not exists (select 1 from D_CNT_ESTADO_INSI_CREDITO est WHERE est.ESTADO_INSI_CREDITO_ID = std.STD_CRE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ESTADO_INSI_CREDITO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CALIF_INICIAL_CREDITO
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_CALIF_INICIAL_CREDITO WHERE CALIFICACION_INICIAL_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_CALIF_INICIAL_CREDITO (CALIFICACION_INICIAL_ID, CALIFICACION_INICIAL_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL := 'insert into D_CNT_CALIF_INICIAL_CREDITO (CALIFICACION_INICIAL_ID, CALIFICACION_INICIAL_DESC)
    select CRE_ID, CRE_DESCRIP from ' || V_DATASTAGE || '.DD_TPO_CREDITO tpo
	where not exists (select 1 from D_CNT_CALIF_INICIAL_CREDITO cal WHERE cal.CALIFICACION_INICIAL_ID = tpo.CRE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CALIF_INICIAL_CREDITO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CALIF_GESTOR_CREDITO
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_CALIF_GESTOR_CREDITO WHERE CALIFICACION_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_CALIF_GESTOR_CREDITO (CALIFICACION_GESTOR_ID, CALIFICACION_GESTOR_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL := 'insert into D_CNT_CALIF_GESTOR_CREDITO (CALIFICACION_GESTOR_ID, CALIFICACION_GESTOR_DESC)
    select CRE_ID, CRE_DESCRIP from ' || V_DATASTAGE || '.DD_TPO_CREDITO tpo
	where not exists (select 1 from D_CNT_CALIF_GESTOR_CREDITO cal WHERE cal.CALIFICACION_GESTOR_ID = tpo.CRE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CALIF_GESTOR_CREDITO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_CALIF_FINAL_CREDITO
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO V_NUM_ROW FROM D_CNT_CALIF_FINAL_CREDITO WHERE CALIFICACION_FINAL_ID = -1;
  IF (V_NUM_ROW = 0) THEN
	V_SQL := 'insert into D_CNT_CALIF_FINAL_CREDITO (CALIFICACION_FINAL_ID, CALIFICACION_FINAL_DESC) values (-1 ,''Desconocido'')';
    EXECUTE IMMEDIATE (V_SQL);
  END IF;

	V_SQL := 'insert into D_CNT_CALIF_FINAL_CREDITO (CALIFICACION_FINAL_ID, CALIFICACION_FINAL_DESC)
    select CRE_ID, CRE_DESCRIP from ' || V_DATASTAGE || '.DD_TPO_CREDITO tpo
	where not exists (select 1 from D_CNT_CALIF_FINAL_CREDITO cal WHERE cal.CALIFICACION_FINAL_ID = tpo.CRE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_CALIF_FINAL_CREDITO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TRAMO_RIESGO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_RIESGO where TRAMO_RIESGO_CNT_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_RIESGO (TRAMO_RIESGO_CNT_ID, TRAMO_RIESGO_CNT_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_RIESGO where TRAMO_RIESGO_CNT_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_RIESGO (TRAMO_RIESGO_CNT_ID, TRAMO_RIESGO_CNT_DESC) values (0 ,' 0 € - 25.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_RIESGO where TRAMO_RIESGO_CNT_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_RIESGO (TRAMO_RIESGO_CNT_ID, TRAMO_RIESGO_CNT_DESC) values (1 ,'25.000 € - 50.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_RIESGO where TRAMO_RIESGO_CNT_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_RIESGO (TRAMO_RIESGO_CNT_ID, TRAMO_RIESGO_CNT_DESC) values (2 ,'50.000 € - 75.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_RIESGO where TRAMO_RIESGO_CNT_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_RIESGO (TRAMO_RIESGO_CNT_ID, TRAMO_RIESGO_CNT_DESC) values (3 ,' > 75.000 €');
  end if;
  
  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TRAMO_RIESGO. Realizados INSERTS', 3;  


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TA_FECHA_CREACION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TA_FECHA_CREACION where TA_FECHA_CREACION_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TA_FECHA_CREACION (TA_FECHA_CREACION_ID, TA_FECHA_CREACION_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TA_FECHA_CREACION where TA_FECHA_CREACION_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TA_FECHA_CREACION (TA_FECHA_CREACION_ID, TA_FECHA_CREACION_DESC) values (0 ,' < 2000');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TA_FECHA_CREACION where TA_FECHA_CREACION_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TA_FECHA_CREACION (TA_FECHA_CREACION_ID, TA_FECHA_CREACION_DESC) values (1 ,'2000 - 2005');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TA_FECHA_CREACION where TA_FECHA_CREACION_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TA_FECHA_CREACION (TA_FECHA_CREACION_ID, TA_FECHA_CREACION_DESC) values (2 ,'2005 - 2010');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TA_FECHA_CREACION where TA_FECHA_CREACION_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TA_FECHA_CREACION (TA_FECHA_CREACION_ID, TA_FECHA_CREACION_DESC) values (3 ,'2010 - 2015');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TA_FECHA_CREACION where TA_FECHA_CREACION_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TA_FECHA_CREACION (TA_FECHA_CREACION_ID, TA_FECHA_CREACION_DESC) values (4 ,'> 2015');
  end if;
  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TA_FECHA_CREACION. Realizados INSERTS', 3;  
  
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_GESTION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (1 ,'Sin Gestión');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (2 ,'Expediente Seguimiento');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (3 ,'Expediente Recuperación');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (4 ,'Gestión Extrajudicial (amistosa)');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (5 ,'Gestión Precontenciosa');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (6 ,'Gestión Judicial');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION where PERIMETRO_GESTION_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION (PERIMETRO_GESTION_ID, PERIMETRO_GESTION_DESC) values (7 ,'Gestión Concursal');
  end if;

  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_GESTION. Realizados INSERTS', 3;  
  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_SIN_GESTION
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_SIN_GESTION where PERIMETRO_SIN_GESTION_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_SIN_GESTION (PERIMETRO_SIN_GESTION_ID, PERIMETRO_SIN_GESTION_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_SIN_GESTION where PERIMETRO_SIN_GESTION_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_SIN_GESTION (PERIMETRO_SIN_GESTION_ID, PERIMETRO_SIN_GESTION_DESC) values (1 ,'Sin Gestión');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_SIN_GESTION where PERIMETRO_SIN_GESTION_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_SIN_GESTION (PERIMETRO_SIN_GESTION_ID, PERIMETRO_SIN_GESTION_DESC) values (2 ,'Con Gestión');
  end if;

  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_SIN_GESTION. Realizados INSERTS', 3;  
 
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_EXP_SEG
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_EXP_SEG where PERIMETRO_EXP_SEG_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_EXP_SEG (PERIMETRO_EXP_SEG_ID, PERIMETRO_EXP_SEG_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_EXP_SEG where PERIMETRO_EXP_SEG_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_EXP_SEG (PERIMETRO_EXP_SEG_ID, PERIMETRO_EXP_SEG_DESC) values (1 ,'En Expediente Seguimiento');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_EXP_SEG where PERIMETRO_EXP_SEG_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_EXP_SEG (PERIMETRO_EXP_SEG_ID, PERIMETRO_EXP_SEG_DESC) values (2 ,'Sin Expediente Seguimiento');
  end if;

  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_EXP_SEG. Realizados INSERTS', 3;  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_EXP_REC
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_EXP_REC where PERIMETRO_EXP_REC_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_EXP_REC (PERIMETRO_EXP_REC_ID, PERIMETRO_EXP_REC_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_EXP_REC where PERIMETRO_EXP_REC_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_EXP_REC (PERIMETRO_EXP_REC_ID, PERIMETRO_EXP_REC_DESC) values (1 ,'En Expediente Recuperación');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_EXP_REC where PERIMETRO_EXP_REC_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_EXP_REC (PERIMETRO_EXP_REC_ID, PERIMETRO_EXP_REC_DESC) values (2 ,'Sin Expediente Recuperación');
  end if;

  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_EXP_REC. Realizados INSERTS', 3;  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_GES_EXTRA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_EXTRA where PERIMETRO_GES_EXTRA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_EXTRA (PERIMETRO_GES_EXTRA_ID, PERIMETRO_GES_EXTRA_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_EXTRA where PERIMETRO_GES_EXTRA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_EXTRA (PERIMETRO_GES_EXTRA_ID, PERIMETRO_GES_EXTRA_DESC) values (1 ,'En Gestión Extrajudicial');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_EXTRA where PERIMETRO_GES_EXTRA_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_EXTRA (PERIMETRO_GES_EXTRA_ID, PERIMETRO_GES_EXTRA_DESC) values (2 ,'Sin Gestión Extrajudicial');
  end if;

  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_GES_EXTRA. Realizados INSERTS', 3;  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_GES_PRE
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_PRE where PERIMETRO_GES_PRE_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_PRE (PERIMETRO_GES_PRE_ID, PERIMETRO_GES_PRE_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_PRE where PERIMETRO_GES_PRE_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_PRE (PERIMETRO_GES_PRE_ID, PERIMETRO_GES_PRE_DESC) values (1 ,'En Gestión Precontenciosa');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_PRE where PERIMETRO_GES_PRE_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_PRE (PERIMETRO_GES_PRE_ID, PERIMETRO_GES_PRE_DESC) values (2 ,'Sin Gestión Precontenciosa');
  end if;

  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_GES_PRE. Realizados INSERTS', 3;  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_GES_JUDI
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_JUDI where PERIMETRO_GES_JUDI_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_JUDI (PERIMETRO_GES_JUDI_ID, PERIMETRO_GES_JUDI_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_JUDI where PERIMETRO_GES_JUDI_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_JUDI (PERIMETRO_GES_JUDI_ID, PERIMETRO_GES_JUDI_DESC) values (1 ,'En Gestión Judicial');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_JUDI where PERIMETRO_GES_JUDI_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_JUDI (PERIMETRO_GES_JUDI_ID, PERIMETRO_GES_JUDI_DESC) values (2 ,'Sin Gestión Judicial');
  end if;

  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_GES_JUDI. Realizados INSERTS', 3;  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_GES_CONCU
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_CONCU where PERIMETRO_GES_CONCU_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_CONCU (PERIMETRO_GES_CONCU_ID, PERIMETRO_GES_CONCU_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_CONCU where PERIMETRO_GES_CONCU_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_CONCU (PERIMETRO_GES_CONCU_ID, PERIMETRO_GES_CONCU_DESC) values (1 ,'En Gestión Concursal');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GES_CONCU where PERIMETRO_GES_CONCU_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GES_CONCU (PERIMETRO_GES_CONCU_ID, PERIMETRO_GES_CONCU_DESC) values (2 ,'Sin Gestión Concursal');
  end if;
  
  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_GES_CONCU. Realizados INSERTS', 3;  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MOTIVO_BAJA_DUDOSO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MOTIVO_BAJA_DUDOSO where MOTIVO_BAJA_DUDOSO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MOTIVO_BAJA_DUDOSO (MOTIVO_BAJA_DUDOSO_ID, MOTIVO_BAJA_DUDOSO_DESC) values (-1 ,'Desconocido');
  end if;
  
	V_SQL := 'insert into D_CNT_MOTIVO_BAJA_DUDOSO (MOTIVO_BAJA_DUDOSO_ID, MOTIVO_BAJA_DUDOSO_DESC)
    select DD_MBD_ID, DD_MBD_DESCRIPCION from ' || V_DATASTAGE || '.DD_MBD_MOTIVO_BAJA_DUDOSO MBD
	where not exists (select 1 from D_CNT_MOTIVO_BAJA_DUDOSO CNT WHERE CNT.MOTIVO_BAJA_DUDOSO_ID = MBD.DD_MBD_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
 


  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MOTIVO_BAJA_DUDOSO. Realizados INSERTS', 3;  
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_MOTIVO_ALTA_DUDOSO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_MOTIVO_ALTA_DUDOSO where MOTIVO_ALTA_DUDOSO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_MOTIVO_ALTA_DUDOSO (MOTIVO_ALTA_DUDOSO_ID, MOTIVO_ALTA_DUDOSO_DESC) values (-1 ,'Desconocido');
  end if;
  
  V_SQL := 'insert into D_CNT_MOTIVO_ALTA_DUDOSO (MOTIVO_ALTA_DUDOSO_ID, MOTIVO_ALTA_DUDOSO_DESC)
    select DD_MAD_ID, DD_MAD_DESCRIPCION from ' || V_DATASTAGE || '.DD_MAD_MOTIVO_ALTA_DUDOSO MAD
	where not exists (select 1 from D_CNT_MOTIVO_ALTA_DUDOSO CNT WHERE CNT.MOTIVO_ALTA_DUDOSO_ID = MAD.DD_MAD_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
  
  
  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MOTIVO_ALTA_DUDOSO. Realizados INSERTS', 3;  
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_T_ANTIGUEDAD_DEUDA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_T_ANTIGUEDAD_DEUDA where TRAMO_ANTIGUEDAD_DEUDA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_ANTIGUEDAD_DEUDA (TRAMO_ANTIGUEDAD_DEUDA_ID, TRAMO_ANTIGUEDAD_DEUDA_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_ANTIGUEDAD_DEUDA where TRAMO_ANTIGUEDAD_DEUDA_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_ANTIGUEDAD_DEUDA (TRAMO_ANTIGUEDAD_DEUDA_ID, TRAMO_ANTIGUEDAD_DEUDA_DESC) values (0,'Situación Normal');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_ANTIGUEDAD_DEUDA where TRAMO_ANTIGUEDAD_DEUDA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_ANTIGUEDAD_DEUDA (TRAMO_ANTIGUEDAD_DEUDA_ID, TRAMO_ANTIGUEDAD_DEUDA_DESC) values (1 ,'Vencidos < 30 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_ANTIGUEDAD_DEUDA where TRAMO_ANTIGUEDAD_DEUDA_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_ANTIGUEDAD_DEUDA (TRAMO_ANTIGUEDAD_DEUDA_ID, TRAMO_ANTIGUEDAD_DEUDA_DESC) values (2 ,'Vencidos 30 - 60 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_ANTIGUEDAD_DEUDA where TRAMO_ANTIGUEDAD_DEUDA_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_ANTIGUEDAD_DEUDA (TRAMO_ANTIGUEDAD_DEUDA_ID, TRAMO_ANTIGUEDAD_DEUDA_DESC) values (3 ,'Vencidos 60 - 90 Días');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_T_ANTIGUEDAD_DEUDA where TRAMO_ANTIGUEDAD_DEUDA_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_T_ANTIGUEDAD_DEUDA (TRAMO_ANTIGUEDAD_DEUDA_ID, TRAMO_ANTIGUEDAD_DEUDA_DESC) values (4 ,'Morosos (> 90 Días)');
  end if;
  
  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_T_ANTIGUEDAD_DEUDA. Realizados INSERTS', 3;  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SIT_CART_DANADA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (-1 ,'Desconocido', -1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (0,'Situación Normal', 0);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (1 ,'Situación Normal', 0);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (2 ,'Vencido/Excedido', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (3 ,'Dudoso No Vencido', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (4 ,'Dudoso Vencido', 2);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (5 ,'Moroso 3-6 Meses', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 6;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (6 ,'Moroso 6-12 Meses', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 7;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (7 ,'Moroso 12-18 Meses', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 8;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (8 ,'Moroso 18-21 Meses', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 9;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (9 ,'Moroso más de 21 Meses', 1);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 10;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (10 ,'Suspenso', 9);
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA where SIT_CART_DANADA_ID = 11;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA (SIT_CART_DANADA_ID, SIT_CART_DANADA_DESC, SIT_CART_DANADA_AGR_ID) values (11 ,'Subestandar', 2);
  end if;
  commit;  


  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION_CARTERA_DANADA. Realizados INSERTS', 3;  
  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_SIT_CART_DANADA_AGR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA_AGR where SIT_CART_DANADA_AGR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA_AGR (SIT_CART_DANADA_AGR_ID, SIT_CART_DANADA_AGR_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA_AGR where SIT_CART_DANADA_AGR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA_AGR (SIT_CART_DANADA_AGR_ID, SIT_CART_DANADA_AGR_DESC) values (0,'Situación Normal');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA_AGR where SIT_CART_DANADA_AGR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA_AGR (SIT_CART_DANADA_AGR_ID, SIT_CART_DANADA_AGR_DESC) values (1 ,'Dañada Objetiva');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_SIT_CART_DANADA_AGR where SIT_CART_DANADA_AGR_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_SIT_CART_DANADA_AGR (SIT_CART_DANADA_AGR_ID, SIT_CART_DANADA_AGR_DESC) values (2 ,'Dañada Subjetiva');
  end if;  




  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_SITUACION_CARTERA_DANADA_AGR. Realizados INSERTS', 3;
  
/*

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_GESTION_EXP
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_GESTION_EXP where TIPO_GESTION_EXP_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_GESTION_EXP (TIPO_GESTION_EXP_ID, TIPO_GESTION_EXP_DESC) values (-1 ,'Desconocido');
  end if;

  	V_SQL := 'insert into D_CNT_TIPO_GESTION_EXP (TIPO_GESTION_EXP_ID, TIPO_GESTION_EXP_DESC)
              select DD_TPX_ID, DD_TPX_DESCRIPCION from ' || V_DATASTAGE || '.DD_TPX_TIPO_EXPEDIENTE tpo
               where not exists (select 1 from D_CNT_TIPO_GESTION_EXP cal WHERE cal.TIPO_GESTION_EXP_ID = tpo.DD_TPX_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_GESTION_EXP. Realizados INSERTS', 3;  
 */ 
  

-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_VENCIDO

-- ----------------------------------------------------------------------------------------------
  
  
	V_SQL := 'insert into D_CNT_TIPO_VENCIDO (TIPO_VENCIDO_ID, TIPO_VENCIDO_DESC, TIPO_VENCIDO_DESC_2)
    select DD_TVE_ID, DD_TVE_DESCRIPCION, DD_TVE_DESCRIPCION_LARGA from ' || V_DATASTAGE || '.DD_TVE_TIPO_VENCIDO TVE
	where not exists (select 1 from D_CNT_TIPO_VENCIDO CNT WHERE CNT.TIPO_VENCIDO_ID = TVE.DD_TVE_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
 

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_VENCIDO. Realizados INSERTS', 3;    
  

  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TRAMO_CAP_VIVO
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_CAP_VIVO where TRAMO_CAP_VIVO_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_CAP_VIVO (TRAMO_CAP_VIVO_ID, TRAMO_CAP_VIVO_DESC) values (1 ,'< 6.000 €');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_CAP_VIVO where TRAMO_CAP_VIVO_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_CAP_VIVO (TRAMO_CAP_VIVO_ID, TRAMO_CAP_VIVO_DESC) values (2,'>= 6.000€ a 59.999€');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_CAP_VIVO where TRAMO_CAP_VIVO_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_CAP_VIVO (TRAMO_CAP_VIVO_ID, TRAMO_CAP_VIVO_DESC) values (3 ,'>= 60.000€ a 299.999€');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_TRAMO_CAP_VIVO where TRAMO_CAP_VIVO_ID = 4;

  if (V_NUM_ROW = 0) then
    insert into D_CNT_TRAMO_CAP_VIVO (TRAMO_CAP_VIVO_ID, TRAMO_CAP_VIVO_DESC) values (4 ,'>= 300.000€');

  end if;  
  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TRAMO_CAP_VIVO. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_DIR_TERRITORIAL
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_DIR_TERRITORIAL where DIR_TERRITORIAL_ID = -1;

  if (V_NUM_ROW = 0) then
    insert into D_CNT_DIR_TERRITORIAL (DIR_TERRITORIAL_ID, DIR_TERRITORIAL_DESC, DIR_TERRITORIAL_DESC_2) values (-1 ,'Desconocido','Desconocido');

  end if;
  
	V_SQL := 'insert into D_CNT_DIR_TERRITORIAL (DIR_TERRITORIAL_ID, DIR_TERRITORIAL_DESC, DIR_TERRITORIAL_DESC_2)
    select ZON_ID, ZON_DESCRIPCION, OFI.OFI_CODIGO_OFICINA from ' || V_DATASTAGE || '.ZON_ZONIFICACION ZON, ' || V_DATASTAGE || '.OFI_OFICINAS OFI 
	where ZON.NIV_ID = 3 AND OFI.OFI_ID = ZON.OFI_ID --(DT)
  AND not exists (select 1 from D_CNT_DIR_TERRITORIAL CNT WHERE CNT.DIR_TERRITORIAL_ID = ZON.ZON_ID)';
	EXECUTE IMMEDIATE (V_SQL);
  V_ROWCOUNT := sql%rowcount;
  commit;
 

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_DIR_TERRITORIAL. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                           D_CNT_ENTIDAD
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_CNT_ENTIDAD WHERE CONTRATO_ENTIDAD_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_CNT_ENTIDAD (CONTRATO_ENTIDAD_ID, CONTRATO_ENTIDAD_DESC, CONTRATO_ENTIDAD_DESC_2)
    VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_CNT_ENTIDAD (CONTRATO_ENTIDAD_ID, CONTRATO_ENTIDAD_DESC, CONTRATO_ENTIDAD_DESC_2)
       SELECT DISTINCT ENP.DD_ENP_ID, ENP.DD_ENP_DESCRIPCION, ENP.DD_ENP_DESCRIPCION_LARGA
       FROM '||V_DATASTAGE||'.DD_ENP_ENTIDADES_PROPIETARIAS ENP
       WHERE NOT EXISTS(SELECT 1 FROM D_CNT_ENTIDAD CNT WHERE CNT.CONTRATO_ENTIDAD_ID = ENP.DD_ENP_ID)
       ORDER BY 1'; 




        
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_ENTIDAD. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_PERIMETRO_GESTION_CM
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION_CM where PERIMETRO_GESTION_CM_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION_CM (PERIMETRO_GESTION_CM_ID, PERIMETRO_GESTION_CM_DESC) values (1 ,'Oficina (+120 días): contratos con más de 120 días impagado y que no esté en HRE (HAYA)');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION_CM where PERIMETRO_GESTION_CM_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION_CM (PERIMETRO_GESTION_CM_ID, PERIMETRO_GESTION_CM_DESC) values (2, 'Pendotraoperación (trámite paralizado con motivo otra operación)');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION_CM where PERIMETRO_GESTION_CM_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION_CM (PERIMETRO_GESTION_CM_ID, PERIMETRO_GESTION_CM_DESC) values (3 ,'Precontencioso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION_CM where PERIMETRO_GESTION_CM_ID = 4;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION_CM (PERIMETRO_GESTION_CM_ID, PERIMETRO_GESTION_CM_DESC) values (4 ,'Contencioso');
  end if;
   select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION_CM where PERIMETRO_GESTION_CM_ID = 5;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION_CM (PERIMETRO_GESTION_CM_ID, PERIMETRO_GESTION_CM_DESC) values (5 ,'Concurso');
  end if;
  select count(*) into V_NUM_ROW from D_CNT_PERIMETRO_GESTION_CM where PERIMETRO_GESTION_CM_ID = 6;

  if (V_NUM_ROW = 0) then
    insert into D_CNT_PERIMETRO_GESTION_CM (PERIMETRO_GESTION_CM_ID, PERIMETRO_GESTION_CM_DESC) values (6 ,'Insolvente (en Empresa externa, no gestionado por vía Judicial)');

  end if;    
  commit;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_PERIMETRO_GESTION_CM. Realizados INSERTS', 3;


-- ----------------------------------------------------------------------------------------------
--                           D_CNT_MOTIVO_COBRO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_CNT_MOTIVO_COBRO WHERE MOTIVO_COBRO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_CNT_MOTIVO_COBRO (MOTIVO_COBRO_ID, MOTIVO_COBRO_DESC, MOTIVO_COBRO_DESC_2)
    VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_CNT_MOTIVO_COBRO (MOTIVO_COBRO_ID, MOTIVO_COBRO_DESC, MOTIVO_COBRO_DESC_2)
       SELECT DISTINCT MC.DD_MC_ID, MC.DD_MC_DESCRIPCION, MC.DD_MC_DESCRIPCION_LARGA
       FROM '||V_DATASTAGE||'.DD_MC_MOTIVO_COBRO MC
       WHERE NOT EXISTS(SELECT 1 FROM D_CNT_MOTIVO_COBRO CNT WHERE CNT.MOTIVO_COBRO_ID = MC.DD_MC_ID)
       ORDER BY 1';
        
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_MOTIVO_COBRO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                           D_CNT_TITULAR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_CNT_TITULAR WHERE CNT_TITULAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_CNT_TITULAR (CNT_TITULAR_ID, CNT_TITULAR_DOCUMENTO_ID, CNT_TITULAR_NOMBRE, CNT_TITULAR_APELLIDO_1, CNT_TITULAR_APELLIDO_2)
    VALUES (-1 ,'Desconocido', 'Desconocido','Desconocido','Desconocido');
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_CNT_TITULAR (CNT_TITULAR_ID, CNT_TITULAR_DOCUMENTO_ID, CNT_TITULAR_NOMBRE, CNT_TITULAR_APELLIDO_1, CNT_TITULAR_APELLIDO_2)
       SELECT MAX(AUX_TITULARES.PER_ID) PER_ID, AUX_TITULARES.PER_DOC_ID, AUX_TITULARES.PER_NOMBRE, AUX_TITULARES.PER_APELLIDO1, AUX_TITULARES.PER_APELLIDO2
        FROM(
         SELECT DISTINCT PER.PER_ID, PER.PER_DOC_ID, PER.PER_NOMBRE, PER.PER_APELLIDO1, PER.PER_APELLIDO2, CNT.CNT_ID, CPE.CPE_ORDEN, rank() over (partition by CPE.CNT_ID order by cpe.cpe_orden) as ranking
         FROM '||V_DATASTAGE||'.CNT_CONTRATOS CNT,'||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS CPE, '||V_DATASTAGE||'.DD_TIN_TIPO_INTERVENCION TIN, '||V_DATASTAGE||'.PER_PERSONAS PER
                WHERE CNT.CNT_ID = CPE.CNT_ID
                AND CPE.DD_TIN_ID = TIN.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
                AND CPE.PER_ID = PER.PER_ID AND PER.BORRADO = 0 AND CNT.BORRADO = 0
                ) AUX_TITULARES
         WHERE AUX_TITULARES.RANKING = 1
         GROUP BY AUX_TITULARES.PER_DOC_ID, AUX_TITULARES.PER_NOMBRE, AUX_TITULARES.PER_APELLIDO1, AUX_TITULARES.PER_APELLIDO2
         ORDER BY 1';
        
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;



   -- ----------------------------------------------------------------------------------------------
--                                      D_CNT_APLICATIVO_ORIGEN
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_CNT_APLICATIVO_ORIGEN WHERE APLICATIVO_ORIGEN_CNT_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_CNT_APLICATIVO_ORIGEN (APLICATIVO_ORIGEN_CNT_ID, APLICATIVO_ORIGEN_CNT_DESC, APLICATIVO_ORIGEN_CNT_DESC2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_CNT_APLICATIVO_ORIGEN(APLICATIVO_ORIGEN_CNT_ID,APLICATIVO_ORIGEN_CNT_DESC,APLICATIVO_ORIGEN_CNT_DESC2)
     SELECT DD_APO_ID,DD_APO_DESCRIPCION,DD_APO_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_APO_APLICATIVO_ORIGEN';   
     

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_APLICATIVO_ORIGEN. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_CNT_TIPO_SOL_PREVISTA
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_CNT_TIPO_SOL_PREVISTA where TIPO_SOL_PREVISTA_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_CNT_TIPO_SOL_PREVISTA (TIPO_SOL_PREVISTA_ID, TIPO_SOL_PREVISTA_DESC) values (-1 ,'Desconocido');
  end if;

  execute immediate
    'INSERT INTO D_CNT_TIPO_SOL_PREVISTA (TIPO_SOL_PREVISTA_ID, TIPO_SOL_PREVISTA_DESC)
     select DD_TPA_ID, DD_TPA_DESCRIPCION from  '||V_DATASTAGE||'.DD_TPA_TIPO_ACUERDO';

  V_ROWCOUNT := sql%rowcount;
  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT_TIPO_SOL_PREVISTA. Realizados INSERTS', 3;  

-- ----------------------------------------------------------------------------------------------
--                                    D_CNT
-- ----------------------------------------------------------------------------------------------


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''ALTER'', ''D_CNT'', ''DISABLE CONSTRAINT D_CNT_PK'', :O_ERROR_STATUS); END;';
   execute immediate V_SQL USING OUT O_ERROR_STATUS;

   


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''D_CNT_COD_CONTRATO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;


   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''D_CNT_CCC_LITIGIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''D_CNT_NUC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  execute immediate
  'insert /*+ APPend PARALLEL(D_CNT_1, 16) PQ_DISTRIBUTE(D_CNT_1, NONE) */ into D_CNT
     (CONTRATO_ID,
      CONTRATO_COD_ENTIDAD,
      CONTRATO_COD_OFICINA,
      CONTRATO_COD_CENTRO,
      CONTRATO_COD_CONTRATO,
      TIPO_PRODUCTO_ID,
      PRODUCTO_ID,
      FINALIDAD_CONTRATO_ID,
      FINALIDAD_OFICIAL_ID,
      GARANTIA_CONTABLE_ID,
      GARANTIA_CONTRATO_ID,
      MONEDA_ID,
      ZONA_CONTRATO_ID,
      OFICINA_CONTRATO_ID,
      CATALOGO_DETALLE_6_ID,
      CARTERA_CONTRATO_ID,
	  APLICATIVO_ORIGEN_CNT_ID
      )
    select distinct cnt.CNT_ID,
      NVL(TO_CHAR(CNT_COD_ENTIDAD), '''||V_DESCONOCIDO||'''),
      NVL(TO_CHAR(CNT_COD_OFICINA), '''||V_DESCONOCIDO||'''),
      NVL(TO_CHAR(CNT_COD_CENTRO), '''||V_DESCONOCIDO||'''),
      NVL(TO_CHAR(CNT_CONTRATO), '''||V_DESCONOCIDO||'''),
      NVL(DD_TPE_ID, -1),
      NVL(DD_TPR_ID, -1),
      NVL(DD_FCN_ID, -1),
      NVL(DD_FNO_ID, -1),
      NVL(DD_GC2_ID, -1),
      NVL(DD_GC1_ID, -1),
      NVL(DD_MON_ID, -1),
      NVL(ZON_ID, -1),
      NVL(ofi.OFI_ID, -1),
      NVL(DD_CT6_ID, -1),
      NVL(CNT.DD_GES_ID,-1) AS CARTERA_CONTRATO_ID,
	  NVL(CNT.DD_APO_ID,-1) AS APLICATIVO_ORIGEN_CNT_ID
	  
      from '||V_DATASTAGE||'.CNT_CONTRATOS cnt
      left join '||V_DATASTAGE||'.ofi_oficinas ofi on cnt.ofi_id_admin = ofi.ofi_id      
      where cnt.BORRADO = 0';
      
--      left join '||V_DATASTAGE||'.ZONA_JERARQUIA zon on cnt.CNT_COD_OFICINA = zon.NIVEL_0

  V_ROWCOUNT := sql%rowcount;
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

  -- CARGAR el TITULAR del CONTRATO --> CNT_TITULAR_ID
  EXECUTE IMMEDIATE 'MERGE INTO D_CNT USING (
                      SELECT MAX(AUX_TITULARES.PER_ID) PER_ID, AUX_TITULARES.CNT_ID
                      FROM(
                         SELECT DISTINCT PER.PER_ID, CNT.CNT_ID, CPE.CPE_ORDEN, rank() over (partition by CPE.CNT_ID order by cpe.cpe_orden) as ranking
                         FROM '||V_DATASTAGE||'.CNT_CONTRATOS CNT,'||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS CPE, '||V_DATASTAGE||'.DD_TIN_TIPO_INTERVENCION TIN, '||V_DATASTAGE||'.PER_PERSONAS PER
                                WHERE CNT.CNT_ID = CPE.CNT_ID
                                AND CPE.DD_TIN_ID = TIN.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
                                AND CPE.PER_ID = PER.PER_ID AND PER.BORRADO = 0 AND CNT.BORRADO = 0
                                ) AUX_TITULARES
                      WHERE AUX_TITULARES.RANKING = 1
                      GROUP BY AUX_TITULARES.CNT_ID) CNT_TITULARES
                    ON (D_CNT.CONTRATO_ID = CNT_TITULARES.CNT_ID)
                    WHEN MATCHED THEN UPDATE SET CNT_TITULAR_ID = CNT_TITULARES.PER_ID';

  V_ROWCOUNT := sql%rowcount;
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT. Registros Mergeados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  UPDATE D_CNT
    SET CNT_TITULAR_ID = -1
   WHERE CNT_TITULAR_ID IS NULL;
   
   COMMIT;

  V_ROWCOUNT := sql%rowcount;
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_CNT. Contratos sin Titular: ' || TO_CHAR(V_ROWCOUNT), 3;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''ALTER'', ''D_CNT'', ''DISABLE CONSTRAINT D_CNT_PK'', :O_ERROR_STATUS); END;';
   execute immediate V_SQL USING OUT O_ERROR_STATUS;
   
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''ANALYZE'', ''D_CNT'', ''COMPUTE STATISTICS'', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;



 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_CNT_COD_CONTRATO_IX'', ''D_CNT (CONTRATO_COD_CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_CNT_CCC_LITIGIO_IX'', ''D_CNT (CCC_LITIGIO)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''D_CNT_NUC_IX'', ''D_CNT (NUC_LITIGIO)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;



  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


/*
  execute immediate
    'update D_CNT SET SEGMENTO_TITULAR_ID = NVL((select DD_SCE_ID from '||V_DATASTAGE||'.PER_PERSONAS where PER_ID =
    (select MIN(PER_ID) from '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID AND DD_TIN_ID = 1)), -1)';

  execute immediate
    'update D_CNT SET NACIONALIDAD_TITULAR_ID = NVL((select PER_NACIONALIDAD from '||V_DATASTAGE||'.PER_PERSONAS where PER_ID =
    (select MIN(PER_ID) from '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID AND DD_TIN_ID = 1)), -1)';

  execute immediate
    'update D_CNT SET SEXO_TITULAR_ID = NVL((select PER_SEXO from '||V_DATASTAGE||'.PER_PERSONAS where PER_ID =
    (select MIN(PER_ID) from '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID AND DD_TIN_ID = 1)), -1)';

  execute immediate
    'update D_CNT SET TIPO_PERSONA_TITULAR_ID = NVL((select DD_TPE_ID from '||V_DATASTAGE||'.PER_PERSONAS where PER_ID =
    (select MIN(PER_ID) from '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID AND DD_TIN_ID = 1)), -1)';

 /*
  -- update CCC_LITIGIO / NUC_LITIGIO / IBAN_RIESGO
  execute immediate
    'update D_CNT DC
    SET DC.CCC_LITIGIO = (select EXT.IAC_VALUE from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO EXT
                          where DC.CONTRATO_ID = EXT.CNT_ID AND EXT.DD_ifC_ID = 32)';

  update D_CNT SET CCC_LITIGIO = 'Desconocido' where CCC_LITIGIO is null;

  execute immediate
    'update D_CNT DC
    SET DC.NUC_LITIGIO = (select EXT.IAC_VALUE from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO EXT
                          where DC.CONTRATO_ID = EXT.CNT_ID AND EXT.DD_ifC_ID = 34)';

  update D_CNT SET NUC_LITIGIO = 'Desconocido' where NUC_LITIGIO is null;

  execute immediate
    'update D_CNT DC
    SET DC.IBAN_RIESGO = (select EXT.IAC_VALUE from '||V_DATASTAGE||'.EXT_IAC_INFO_ADD_CONTRATO EXT
                        where DC.CONTRATO_ID = EXT.CNT_ID AND EXT.DD_ifC_ID = 37)';

  update D_CNT SET IBAN_RIESGO = 'Desconocido' where IBAN_RIESGO is null;
  */
  /*
  POLITICA_TITULAR_ID
  NACIONALIDAD_TITULAR_ID
      SEGMENTO_TITULAR_ID,
      SEXO_TITULAR_ID,
      TIPO_PERSONA_TITULAR_ID,
  */


/*EXCEPTION
  WHEN OBJECTEXISTS then
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  WHEN INSERT_NULL then
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;
  WHEN PARAMETERS_NUMBER then
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;
  WHEN OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;*/
end;
end CARGAR_DIM_CONTRATO;

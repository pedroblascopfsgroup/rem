-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Fecha_Otras`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_FEC_OTR: BEGIN


-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 15/01/2015
-- Motivos del cambio: Motivo inadmisión, archivo y requerimiento previo
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensiones Fecha Posición 
-- Vencida, Fecha Movimiento Dudoso, Fecha Creación Asunto y Fecha Creación Procedimiento.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN FECHA_POS_VENCIDA
    -- DIM_FECHA_POS_VENCIDA_ANIO
    -- DIM_FECHA_POS_VENCIDA_TRIMESTRE
    -- DIM_FECHA_POS_VENCIDA_MES
    -- DIM_FECHA_POS_VENCIDA_DIA
    -- DIM_FECHA_POS_VENCIDA_DIA_SEMANA
    -- DIM_FECHA_POS_VENCIDA_MES_ANIO
    
-- DIMENSIÓN FECHA_SALDO_DUDOSO
    -- DIM_FECHA_SALDO_DUDOSO_ANIO
    -- DIM_FECHA_SALDO_DUDOSO_DIA_SEMANA
    -- DIM_FECHA_SALDO_DUDOSO_DIA
    -- DIM_FECHA_SALDO_DUDOSO_MES
    -- DIM_FECHA_SALDO_DUDOSO_MES_ANIO
    -- DIM_FECHA_SALDO_DUDOSO_TRIMESTRE
    
-- DIMENSIÓN FECHA_CREACION_ASUNTO
    -- DIM_FECHA_CREACION_ASUNTO_ANIO
    -- DIM_FECHA_CREACION_ASUNTO_DIA_SEMANA
    -- DIM_FECHA_CREACION_ASUNTO_DIA
    -- DIM_FECHA_CREACION_ASUNTO_MES
    -- DIM_FECHA_CREACION_ASUNTO_MES_ANIO
    -- DIM_FECHA_CREACION_ASUNTO_TRIMESTRE
    
-- DIMENSIÓN FECHA_CREACION_PROCEDIMIENTO
    -- DIM_FECHA_CREACION_PROCEDIMIENTO_ANIO
    -- DIM_FECHA_CREACION_PROCEDIMIENTO_DIA_SEMANA
    -- DIM_FECHA_CREACION_PROCEDIMIENTO_DIA
    -- DIM_FECHA_CREACION_PROCEDIMIENTO_MES
    -- DIM_FECHA_CREACION_PROCEDIMIENTO_MES_ANIO
    -- DIM_FECHA_CREACION_PROCEDIMIENTO_TRIMESTRE
    
-- DIMENSIÓN FECHA_ULTIMA_TAREA_CREADA
    -- DIM_FECHA_ULTIMA_TAREA_CREADA_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_CREADA_DIA_SEMANA
    -- DIM_FECHA_ULTIMA_TAREA_CREADA_DIA
    -- DIM_FECHA_ULTIMA_TAREA_CREADA_MES
    -- DIM_FECHA_ULTIMA_TAREA_CREADA_MES_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_CREADA_TRIMESTRE

-- DIMENSIÓN FECHA_ULTIMA_TAREA_FINALIZADA
    -- DIM_FECHA_ULTIMA_TAREA_FINALIZADA_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_FINALIZADA_DIA_SEMANA
    -- DIM_FECHA_ULTIMA_TAREA_FINALIZADA_DIA
    -- DIM_FECHA_ULTIMA_TAREA_FINALIZADA_MES
    -- DIM_FECHA_ULTIMA_TAREA_FINALIZADA_MES_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_FINALIZADA_TRIMESTRE

-- DIMENSIÓN FECHA_ULTIMA_TAREA_ACTUALIZADA
    -- DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_DIA_SEMANA
    -- DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_DIA
    -- DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_MES
    -- DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_MES_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_TRIMESTRE

-- DIMENSIÓN FECHA_ULTIMA_TAREA_PENDIENTE
    -- DIM_FECHA_ULTIMA_TAREA_PENDIENTE_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_PENDIENTE_DIA_SEMANA
    -- DIM_FECHA_ULTIMA_TAREA_PENDIENTE_DIA
    -- DIM_FECHA_ULTIMA_TAREA_PENDIENTE_MES
    -- DIM_FECHA_ULTIMA_TAREA_PENDIENTE_MES_ANIO
    -- DIM_FECHA_ULTIMA_TAREA_PENDIENTE_TRIMESTRE

-- DIMENSIÓN FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ANIO
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_DIA_SEMANA
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_DIA
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_MES
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_MES_ANIO
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_TRIMESTRE

-- DIMENSIÓN FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ANIO
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_DIA_SEMANA
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_DIA
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_MES
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_MES_ANIO
    -- DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_TRIMESTRE

-- DIMENSIÓN FECHA_COBRO
    -- DIM_FECHA_COBRO_ANIO
    -- DIM_FECHA_COBRO_DIA_SEMANA
    -- DIM_FECHA_COBRO_DIA
    -- DIM_FECHA_COBRO_MES
    -- DIM_FECHA_COBRO_MES_ANIO
    -- DIM_FECHA_COBRO_TRIMESTRE

-- DIMENSIÓN FECHA_ACEPTACION
    -- DIM_FECHA_ACEPTACION_ANIO
    -- DIM_FECHA_ACEPTACION_DIA_SEMANA
    -- DIM_FECHA_ACEPTACION_DIA
    -- DIM_FECHA_ACEPTACION_MES
    -- DIM_FECHA_ACEPTACION_MES_ANIO
    -- DIM_FECHA_ACEPTACION_TRIMESTRE

-- DIMENSIÓN FECHA_INTERPOSICION_DEMANDA
    -- DIM_FECHA_INTERPOSICION_DEMANDA_ANIO
    -- DIM_FECHA_INTERPOSICION_DEMANDA_DIA_SEMANA
    -- DIM_FECHA_INTERPOSICION_DEMANDA_DIA
    -- DIM_FECHA_INTERPOSICION_DEMANDA_MES
    -- DIM_FECHA_INTERPOSICION_DEMANDA_MES_ANIO
    -- DIM_FECHA_INTERPOSICION_DEMANDA_TRIMESTRE

-- DIMENSIÓN FECHA_DECRETO_FINALIZACION
    -- DIM_FECHA_DECRETO_FINALIZACION_ANIO
    -- DIM_FECHA_DECRETO_FINALIZACION_DIA_SEMANA
    -- DIM_FECHA_DECRETO_FINALIZACION_DIA
    -- DIM_FECHA_DECRETO_FINALIZACION_MES
    -- DIM_FECHA_DECRETO_FINALIZACION_MES_ANIO
    -- DIM_FECHA_DECRETO_FINALIZACION_TRIMESTRE
    
-- DIMENSIÓN FECHA_RESOLUCION_FIRME
    -- DIM_FECHA_RESOLUCION_FIRME_ANIO
    -- DIM_FECHA_RESOLUCION_FIRME_DIA_SEMANA
    -- DIM_FECHA_RESOLUCION_FIRME_DIA
    -- DIM_FECHA_RESOLUCION_FIRME_MES
    -- DIM_FECHA_RESOLUCION_FIRME_MES_ANIO
    -- DIM_FECHA_RESOLUCION_FIRME_TRIMESTRE
    
-- DIMENSIÓN FECHA_SUBASTA
    -- DIM_FECHA_SUBASTA_ANIO
    -- DIM_FECHA_SUBASTA_DIA_SEMANA
    -- DIM_FECHA_SUBASTA_DIA
    -- DIM_FECHA_SUBASTA_MES
    -- DIM_FECHA_SUBASTA_MES_ANIO
    -- DIM_FECHA_SUBASTA_TRIMESTRE
    
-- DIMENSIÓN FECHA_SUBASTA_EJECUCION_NOTARIAL
    -- DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_ANIO
    -- DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_DIA_SEMANA
    -- DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_DIA
    -- DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_MES
    -- DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_MES_ANIO
    -- DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_TRIMESTRE
    
-- DIMENSIÓN FECHA_INICIO_APREMIO
    -- DIM_FECHA_INICIO_APREMIO_ANIO
    -- DIM_FECHA_INICIO_APREMIO_DIA_SEMANA
    -- DIM_FECHA_INICIO_APREMIO_DIA
    -- DIM_FECHA_INICIO_APREMIO_MES
    -- DIM_FECHA_INICIO_APREMIO_MES_ANIO
    -- DIM_FECHA_INICIO_APREMIO_TRIMESTRE
    
-- DIMENSIÓN FECHA_ESTIMADA_COBRO
    -- DIM_FECHA_ESTIMADA_COBRO_ANIO
    -- DIM_FECHA_ESTIMADA_COBRO_DIA_SEMANA
    -- DIM_FECHA_ESTIMADA_COBRO_DIA
    -- DIM_FECHA_ESTIMADA_COBRO_MES
    -- DIM_FECHA_ESTIMADA_COBRO_MES_ANIO
    -- DIM_FECHA_ESTIMADA_COBRO_TRIMESTRE
    
-- DIMENSIÓN FECHA_ULTIMA_ESTIMACION
    -- DIM_FECHA_ULTIMA_ESTIMACION_ANIO
    -- DIM_FECHA_ULTIMA_ESTIMACION_DIA_SEMANA
    -- DIM_FECHA_ULTIMA_ESTIMACION_DIA
    -- DIM_FECHA_ULTIMA_ESTIMACION_MES
    -- DIM_FECHA_ULTIMA_ESTIMACION_MES_ANIO
    -- DIM_FECHA_ULTIMA_ESTIMACION_TRIMESTRE
    
-- DIMENSIÓN FECHA_LIQUIDACION
    -- DIM_FECHA_LIQUIDACION_ANIO
    -- DIM_FECHA_LIQUIDACION_TRIMESTRE
    -- DIM_FECHA_LIQUIDACION_MES
    -- DIM_FECHA_LIQUIDACION_DIA
    -- DIM_FECHA_LIQUIDACION_DIA_SEMANA
    -- DIM_FECHA_LIQUIDACION_MES_ANIO

-- DIMENSIÓN FECHA_INSINUACION_FINAL_CREDITO
    -- DIM_FECHA_INSINUACION_FINAL_CREDITO_ANIO
    -- DIM_FECHA_INSINUACION_FINAL_CREDITO_TRIMESTRE
    -- DIM_FECHA_INSINUACION_FINAL_CREDITO_MES
    -- DIM_FECHA_INSINUACION_FINAL_CREDITO_DIA
    -- DIM_FECHA_INSINUACION_FINAL_CREDITO_DIA_SEMANA
    -- DIM_FECHA_INSINUACION_FINAL_CREDITO_MES_ANIO
    
-- DIMENSIÓN FECHA_AUTO_APERTURA_CONVENIO
    -- DIM_FECHA_AUTO_APERTURA_CONVENIO_ANIO
    -- DIM_FECHA_AUTO_APERTURA_CONVENIO_TRIMESTRE
    -- DIM_FECHA_AUTO_APERTURA_CONVENIO_MES
    -- DIM_FECHA_AUTO_APERTURA_CONVENIO_DIA
    -- DIM_FECHA_AUTO_APERTURA_CONVENIO_DIA_SEMANA
    -- DIM_FECHA_AUTO_APERTURA_CONVENIO_MES_ANIO
   
-- DIMENSIÓN FECHA_JUNTA_ACREEDORES
    -- DIM_FECHA_JUNTA_ACREEDORES_ANIO
    -- DIM_FECHA_JUNTA_ACREEDORES_TRIMESTRE
    -- DIM_FECHA_JUNTA_ACREEDORES_MES
    -- DIM_FECHA_JUNTA_ACREEDORES_DIA
    -- DIM_FECHA_JUNTA_ACREEDORES_DIA_SEMANA
    -- DIM_FECHA_JUNTA_ACREEDORES_MES_ANIO

-- DIMENSIÓN FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION
    -- DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ANIO
    -- DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_TRIMESTRE
    -- DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_MES
    -- DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_DIA
    -- DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_DIA_SEMANA
    -- DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_MES_ANIO
    
-- DIMENSIÓN FECHA_CREACION_TAREA
    -- DIM_FECHA_CREACION_TAREA_ANIO
    -- DIM_FECHA_CREACION_TAREA_DIA_SEMANA
    -- DIM_FECHA_CREACION_TAREA_DIA
    -- DIM_FECHA_CREACION_TAREA_MES
    -- DIM_FECHA_CREACION_TAREA_MES_ANIO
    -- DIM_FECHA_CREACION_TAREA_TRIMESTRE

-- DIMENSIÓN FECHA_FINALIZACION_TAREA
    -- DIM_FECHA_FINALIZACION_TAREA_ANIO
    -- DIM_FECHA_FINALIZACION_TAREA_DIA_SEMANA
    -- DIM_FECHA_FINALIZACION_TAREA_DIA
    -- DIM_FECHA_FINALIZACION_TAREA_MES
    -- DIM_FECHA_FINALIZACION_TAREA_MES_ANIO
    -- DIM_FECHA_FINALIZACION_TAREA_TRIMESTRE

-- DIMENSIÓN FECHA_RECOGIDA_DOC_Y_ACEPTACION
    -- DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_ANIO
    -- DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_DIA_SEMANA
    -- DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_DIA
    -- DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_MES
    -- DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_MES_ANIO
    -- DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_TRIMESTRE
    
-- DIMENSIÓN FECHA_REGISTRAR_TOMA_DECISION
    -- DIM_FECHA_REGISTRAR_TOMA_DECISION_ANIO
    -- DIM_FECHA_REGISTRAR_TOMA_DECISION_DIA_SEMANA
    -- DIM_FECHA_REGISTRAR_TOMA_DECISION_DIA
    -- DIM_FECHA_REGISTRAR_TOMA_DECISION_MES
    -- DIM_FECHA_REGISTRAR_TOMA_DECISION_MES_ANIO
    -- DIM_FECHA_REGISTRAR_TOMA_DECISION_TRIMESTRE
    
-- DIMENSIÓN FECHA_RECEPCION_DOC_COMPLETA
    -- DIM_FECHA_RECEPCION_DOC_COMPLETA_ANIO
    -- DIM_FECHA_RECEPCION_DOC_COMPLETA_DIA_SEMANA
    -- DIM_FECHA_RECEPCION_DOC_COMPLETA_DIA
    -- DIM_FECHA_RECEPCION_DOC_COMPLETA_MES
    -- DIM_FECHA_RECEPCION_DOC_COMPLETA_MES_ANIO
    -- DIM_FECHA_RECEPCION_DOC_COMPLETA_TRIMESTRE
    
-- DIMENSIÓN FECHA_CONTABLE_LITIGIO
    -- DIM_FECHA_CONTABLE_LITIGIO_ANIO
    -- DIM_FECHA_CONTABLE_LITIGIO_DIA_SEMANA
    -- DIM_FECHA_CONTABLE_LITIGIO_DIA
    -- DIM_FECHA_CONTABLE_LITIGIO_MES
    -- DIM_FECHA_CONTABLE_LITIGIO_MES_ANIO
    -- DIM_FECHA_CONTABLE_LITIGIO_TRIMESTRE

-- DIMENSIÓN FECHA_DPS
    -- DIM_FECHA_DPS_ANIO
    -- DIM_FECHA_DPS_TRIMESTRE
    -- DIM_FECHA_DPS_MES
    -- DIM_FECHA_DPS_DIA
    -- DIM_FECHA_DPS_DIA_SEMANA
    -- DIM_FECHA_DPS_MES_ANIO

-- DIMENSIÓN FECHA_COMPROMETIDA_PAGO
    -- DIM_FECHA_COMPROMETIDA_PAGO_ANIO
    -- DIM_FECHA_COMPROMETIDA_PAGO_TRIMESTRE
    -- DIM_FECHA_COMPROMETIDA_PAGO_MES
    -- DIM_FECHA_COMPROMETIDA_PAGO_DIA
    -- DIM_FECHA_COMPROMETIDA_PAGO_DIA_SEMANA
    -- DIM_FECHA_COMPROMETIDA_PAGO_MES_ANIO
    
-- DIMENSIÓN FECHA_ALTA_GESTION_RECOBRO
    -- DIM_FECHA_ALTA_GESTION_RECOBRO_ANIO
    -- DIM_FECHA_ALTA_GESTION_RECOBRO_TRIMESTRE
    -- DIM_FECHA_ALTA_GESTION_RECOBRO_MES
    -- DIM_FECHA_ALTA_GESTION_RECOBRO_DIA
    -- DIM_FECHA_ALTA_GESTION_RECOBRO_DIA_SEMANA
    -- DIM_FECHA_ALTA_GESTION_RECOBRO_MES_ANIO

-- DIMENSIÓN FECHA_BAJA_GESTION_RECOBRO
    -- DIM_FECHA_BAJA_GESTION_RECOBRO_ANIO
    -- DIM_FECHA_BAJA_GESTION_RECOBRO_TRIMESTRE
    -- DIM_FECHA_BAJA_GESTION_RECOBRO_MES
    -- DIM_FECHA_BAJA_GESTION_RECOBRO_DIA
    -- DIM_FECHA_BAJA_GESTION_RECOBRO_DIA_SEMANA
    -- DIM_FECHA_BAJA_GESTION_RECOBRO_MES_ANIO

-- DIMENSIÓN FECHA_ACTUACION_RECOBRO
    -- DIM_FECHA_ACTUACION_RECOBRO_ANIO
    -- DIM_FECHA_ACTUACION_RECOBRO_TRIMESTRE
    -- DIM_FECHA_ACTUACION_RECOBRO_MES
    -- DIM_FECHA_ACTUACION_RECOBRO_DIA
    -- DIM_FECHA_ACTUACION_RECOBRO_DIA_SEMANA
    -- DIM_FECHA_ACTUACION_RECOBRO_MES_ANIO

-- DIMENSIÓN FECHA_PAGO_COMPROMETIDO
    -- DIM_FECHA_PAGO_COMPROMETIDO_ANIO
    -- DIM_FECHA_PAGO_COMPROMETIDO_TRIMESTRE
    -- DIM_FECHA_PAGO_COMPROMETIDO_MES
    -- DIM_FECHA_PAGO_COMPROMETIDO_DIA
    -- DIM_FECHA_PAGO_COMPROMETIDO_DIA_SEMANA
    -- DIM_FECHA_PAGO_COMPROMETIDO_MES_ANIO
 
 -- DIMENSIÓN FECHA_RESOLUCION
    -- DIM_FECHA_RESOLUCION_ANIO
    -- DIM_FECHA_RESOLUCION_DIA_SEMANA
    -- DIM_FECHA_RESOLUCION_DIA
    -- DIM_FECHA_RESOLUCION_MES
    -- DIM_FECHA_RESOLUCION_MES_ANIO
    -- DIM_FECHA_RESOLUCION_TRIMESTRE

-- DIMENSIÓN FECHA_CREACION_CONTRATO
    -- DIM_FECHA_CREACION_CONTRATO_ANIO
    -- DIM_FECHA_CREACION_CONTRATO_DIA_SEMANA
    -- DIM_FECHA_CREACION_CONTRATO_DIA
    -- DIM_FECHA_CREACION_CONTRATO_MES
    -- DIM_FECHA_CREACION_CONTRATO_MES_ANIO
    -- DIM_FECHA_CREACION_CONTRATO_TRIMESTRE

-- DIMENSIÓN FECHA_ULTIMO_COBRO
    -- DIM_FECHA_ULTIMO_COBRO_ANIO
    -- DIM_FECHA_ULTIMO_COBRO_TRIMESTRE
    -- DIM_FECHA_ULTIMO_COBRO_MES
    -- DIM_FECHA_ULTIMO_COBRO_DIA
    -- DIM_FECHA_ULTIMO_COBRO_DIA_SEMANA
    -- DIM_FECHA_ULTIMO_COBRO_MES_ANIO

-- DIMENSIÓN FECHA_ULTIMA_RESOLUCION
    -- DIM_FECHA_ULTIMA_RESOLUCION_ANIO
    -- DIM_FECHA_ULTIMA_RESOLUCION_TRIMESTRE
    -- DIM_FECHA_ULTIMA_RESOLUCION_MES
    -- DIM_FECHA_ULTIMA_RESOLUCION_DIA
    -- DIM_FECHA_ULTIMA_RESOLUCION_DIA_SEMANA
    -- DIM_FECHA_ULTIMA_RESOLUCION_MES_ANIO

-- DIMENSIÓN FECHA_ULTIMO_IMPULSO
    -- DIM_FECHA_ULTIMO_IMPULSO_ANIO
    -- DIM_FECHA_ULTIMO_IMPULSO_TRIMESTRE
    -- DIM_FECHA_ULTIMO_IMPULSO_MES
    -- DIM_FECHA_ULTIMO_IMPULSO_DIA
    -- DIM_FECHA_ULTIMO_IMPULSO_DIA_SEMANA
    -- DIM_FECHA_ULTIMO_IMPULSO_MES_ANIO

-- DIMENSIÓN FECHA_ULTIMA_INADMISION
    -- DIM_FECHA_ULTIMA_INADMISION_ANIO
    -- DIM_FECHA_ULTIMA_INADMISION_TRIMESTRE
    -- DIM_FECHA_ULTIMA_INADMISION_MES
    -- DIM_FECHA_ULTIMA_INADMISION_DIA
    -- DIM_FECHA_ULTIMA_INADMISION_DIA_SEMANA
    -- DIM_FECHA_ULTIMA_INADMISION_MES_ANIO
    
-- DIMENSIÓN FECHA_ULTIMO_ARCHIVO
    -- DIM_FECHA_ULTIMO_ARCHIVO_ANIO
    -- DIM_FECHA_ULTIMO_ARCHIVO_TRIMESTRE
    -- DIM_FECHA_ULTIMO_ARCHIVO_MES
    -- DIM_FECHA_ULTIMO_ARCHIVO_DIA
    -- DIM_FECHA_ULTIMO_ARCHIVO_DIA_SEMANA
    -- DIM_FECHA_ULTIMO_ARCHIVO_MES_ANIO
    
-- DIMENSIÓN FECHA_ULTIMO_REQUERIMIENTO_PREVIO
    -- DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_ANIO
    -- DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_TRIMESTRE
    -- DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_MES
    -- DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_DIA
    -- DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_DIA_SEMANA
    -- DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_MES_ANIO
    
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================

declare i int;
declare num_years int;
declare max_date date;
declare insert_date date;

-- Año
declare year_id int;
declare year_date date;
declare year_duration int;
declare prev_year_id int;

-- Trimestre
declare quarter_id int;
declare quarter_date date;
declare quarter_desc varchar(50);
declare quarter_duration int;
declare prev_quarter_id int;
declare ly_quarter_id int;
declare quarter_desc_de varchar(50);
declare quarter_desc_en varchar(50);
declare quarter_desc_fr varchar(50);
declare quarter_desc_it varchar(50);

-- Month
declare month_id int;
declare month_date date;
declare month_desc varchar(50);
declare month_duration int;
declare prev_month_id int;
declare lq_month_id int;
declare ly_month_id int;
declare month_desc_de varchar(50);
declare month_desc_en varchar(50);
declare month_desc_fr varchar(50);
declare month_desc_it varchar(50);

-- Day
declare day_date date;
declare prev_day_date date;
declare lm_day_date date;
declare lq_day_date date;
declare ly_day_date date;

-- Month of year
declare month_of_year_id int;
declare month_of_year_desc varchar(50);
declare month_of_year_desc_en varchar(50);
declare month_of_year_desc_de varchar(50);	 
declare month_of_year_desc_fr varchar(50); 
declare month_of_year_desc_it varchar(50);
	
-- Day of week
declare day_of_week_id int;
declare day_of_week_desc varchar(50);
declare day_of_week_desc_de varchar(50);
declare day_of_week_desc_en varchar(50);	 
declare day_of_week_desc_fr varchar(50);	 
declare day_of_week_desc_it varchar(50);		


-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: Número de parámetros incorrecto'; 

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DEL HANDLER GENÉRICO DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_POS_VENCIDA
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_POS_VENCIDA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_POS_VENCIDA_ANIO
      (ANIO_POS_VENCIDA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_POS_VENCIDA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_POS_VENCIDA_TRIMESTRE
       (TRIMESTRE_POS_VENCIDA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_POS_VENCIDA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_POS_VENCIDA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_POS_VENCIDA_MES
      (MES_POS_VENCIDA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_POS_VENCIDA_ID,
			 TRIMESTRE_POS_VENCIDA_ID,
			 ANIO_POS_VENCIDA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_POS_VENCIDA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_POS_VENCIDA_DIA
      (DIA_POS_VENCIDA_ID,
       DIA_SEMANA_POS_VENCIDA_ID,
       MES_POS_VENCIDA_ID,
       TRIMESTRE_POS_VENCIDA_ID,
       ANIO_POS_VENCIDA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_POS_VENCIDA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_POS_VENCIDA_DIA_SEMANA
      (DIA_SEMANA_POS_VENCIDA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_POS_VENCIDA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_POS_VENCIDA_MES_ANIO
      (MES_ANIO_POS_VENCIDA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    
-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_SALDO_DUDOSO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                              DIM_FECHA_SALDO_DUDOSO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_SALDO_DUDOSO_ANIO
      (ANIO_SALDO_DUDOSO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_SALDO_DUDOSO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_SALDO_DUDOSO_TRIMESTRE
       (TRIMESTRE_SALDO_DUDOSO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SALDO_DUDOSO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                               DIM_FECHA_SALDO_DUDOSO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_SALDO_DUDOSO_MES
      (MES_SALDO_DUDOSO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SALDO_DUDOSO_ID,
			 TRIMESTRE_SALDO_DUDOSO_ID,
			 ANIO_SALDO_DUDOSO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                 DIM_FECHA_SALDO_DUDOSO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_SALDO_DUDOSO_DIA
      (DIA_SALDO_DUDOSO_ID,
       DIA_SEMANA_SALDO_DUDOSO_ID,
       MES_SALDO_DUDOSO_ID,
       TRIMESTRE_SALDO_DUDOSO_ID,
       ANIO_SALDO_DUDOSO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                            DIM_FECHA_SALDO_DUDOSO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_SALDO_DUDOSO_DIA_SEMANA
      (DIA_SEMANA_SALDO_DUDOSO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_SALDO_DUDOSO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_SALDO_DUDOSO_MES_ANIO
      (MES_ANIO_SALDO_DUDOSO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_CREACION_ASUNTO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                             DIM_FECHA_CREACION_ASUNTO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_CREACION_ASUNTO_ANIO
      (ANIO_CREACION_ASUNTO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_CREACION_ASUNTO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_CREACION_ASUNTO_TRIMESTRE
       (TRIMESTRE_CREACION_ASUNTO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_ASUNTO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                             DIM_FECHA_CREACION_ASUNTO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_CREACION_ASUNTO_MES
      (MES_CREACION_ASUNTO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_ASUNTO_ID,
			 TRIMESTRE_CREACION_ASUNTO_ID,
			 ANIO_CREACION_ASUNTO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                           DIM_FECHA_CREACION_ASUNTO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_CREACION_ASUNTO_DIA
      (DIA_CREACION_ASUNTO_ID,
       DIA_SEMANA_CREACION_ASUNTO_ID,
       MES_CREACION_ASUNTO_ID,
       TRIMESTRE_CREACION_ASUNTO_ID,
       ANIO_CREACION_ASUNTO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_CREACION_ASUNTO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_CREACION_ASUNTO_DIA_SEMANA
      (DIA_SEMANA_CREACION_ASUNTO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_CREACION_ASUNTO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_CREACION_ASUNTO_MES_ANIO
      (MES_ANIO_CREACION_ASUNTO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_CREACION_PROCEDIMIENTO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_CREACION_PROCEDIMIENTO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_CREACION_PROCEDIMIENTO_ANIO
      (ANIO_CREACION_PROCEDIMIENTO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_CREACION_PROCEDIMIENTO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_CREACION_PROCEDIMIENTO_TRIMESTRE
       (TRIMESTRE_CREACION_PROCEDIMIENTO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_PROCEDIMIENTO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                           DIM_FECHA_CREACION_PROCEDIMIENTO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_CREACION_PROCEDIMIENTO_MES
      (MES_CREACION_PROCEDIMIENTO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_PROCEDIMIENTO_ID,
			 TRIMESTRE_CREACION_PROCEDIMIENTO_ID,
			 ANIO_CREACION_PROCEDIMIENTO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_CREACION_PROCEDIMIENTO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_CREACION_PROCEDIMIENTO_DIA
      (DIA_CREACION_PROCEDIMIENTO_ID,
       DIA_SEMANA_CREACION_PROCEDIMIENTO_ID,
       MES_CREACION_PROCEDIMIENTO_ID,
       TRIMESTRE_CREACION_PROCEDIMIENTO_ID,
       ANIO_CREACION_PROCEDIMIENTO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_CREACION_PROCEDIMIENTO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_CREACION_PROCEDIMIENTO_DIA_SEMANA
      (DIA_SEMANA_CREACION_PROCEDIMIENTO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                       DIM_FECHA_CREACION_PROCEDIMIENTO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_CREACION_PROCEDIMIENTO_MES_ANIO
      (MES_ANIO_CREACION_PROCEDIMIENTO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMA_TAREA_CREADA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_ULTIMA_TAREA_CREADA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMA_TAREA_CREADA_ANIO
      (ANIO_ULTIMA_TAREA_CREADA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                      DIM_FECHA_ULTIMA_TAREA_CREADA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMA_TAREA_CREADA_TRIMESTRE
       (TRIMESTRE_ULTIMA_TAREA_CREADA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMA_TAREA_CREADA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                      DIM_FECHA_ULTIMA_TAREA_CREADA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMA_TAREA_CREADA_MES
      (MES_ULTIMA_TAREA_CREADA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMA_TAREA_CREADA_ID,
			 TRIMESTRE_ULTIMA_TAREA_CREADA_ID,
			 ANIO_ULTIMA_TAREA_CREADA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_ULTIMA_TAREA_CREADA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMA_TAREA_CREADA_DIA
      (DIA_ULTIMA_TAREA_CREADA_ID,
       DIA_SEMANA_ULTIMA_TAREA_CREADA_ID,
       MES_ULTIMA_TAREA_CREADA_ID,
       TRIMESTRE_ULTIMA_TAREA_CREADA_ID,
       ANIO_ULTIMA_TAREA_CREADA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                         DIM_FECHA_ULTIMA_TAREA_CREADA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMA_TAREA_CREADA_DIA_SEMANA
      (DIA_SEMANA_ULTIMA_TAREA_CREADA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_ULTIMA_TAREA_CREADA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMA_TAREA_CREADA_MES_ANIO
      (MES_ANIO_ULTIMA_TAREA_CREADA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    
    
-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMA_TAREA_FINALIZADA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                            DIM_FECHA_ULTIMA_TAREA_FINALIZADA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMA_TAREA_FINALIZADA_ANIO
      (ANIO_ULTIMA_TAREA_FINALIZADA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_ULTIMA_TAREA_FINALIZADA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMA_TAREA_FINALIZADA_TRIMESTRE
       (TRIMESTRE_ULTIMA_TAREA_FINALIZADA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMA_TAREA_FINALIZADA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                       DIM_FECHA_ULTIMA_TAREA_FINALIZADA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMA_TAREA_FINALIZADA_MES
      (MES_ULTIMA_TAREA_FINALIZADA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMA_TAREA_FINALIZADA_ID,
			 TRIMESTRE_ULTIMA_TAREA_FINALIZADA_ID,
			 ANIO_ULTIMA_TAREA_FINALIZADA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_ULTIMA_TAREA_FINALIZADA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMA_TAREA_FINALIZADA_DIA
      (DIA_ULTIMA_TAREA_FINALIZADA_ID,
       DIA_SEMANA_ULTIMA_TAREA_FINALIZADA_ID,
       MES_ULTIMA_TAREA_FINALIZADA_ID,
       TRIMESTRE_ULTIMA_TAREA_FINALIZADA_ID,
       ANIO_ULTIMA_TAREA_FINALIZADA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                         DIM_FECHA_ULTIMA_TAREA_FINALIZADA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMA_TAREA_FINALIZADA_DIA_SEMANA
      (DIA_SEMANA_ULTIMA_TAREA_FINALIZADA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_ULTIMA_TAREA_FINALIZADA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMA_TAREA_FINALIZADA_MES_ANIO
      (MES_ANIO_ULTIMA_TAREA_FINALIZADA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                         DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_ANIO
      (ANIO_ULTIMA_TAREA_ACTUALIZADA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                      DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_TRIMESTRE
       (TRIMESTRE_ULTIMA_TAREA_ACTUALIZADA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMA_TAREA_ACTUALIZADA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                         DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_MES
      (MES_ULTIMA_TAREA_ACTUALIZADA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMA_TAREA_ACTUALIZADA_ID,
			 TRIMESTRE_ULTIMA_TAREA_ACTUALIZADA_ID,
			 ANIO_ULTIMA_TAREA_ACTUALIZADA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_DIA
      (DIA_ULTIMA_TAREA_ACTUALIZADA_ID,
       DIA_SEMANA_ULTIMA_TAREA_ACTUALIZADA_ID,
       MES_ULTIMA_TAREA_ACTUALIZADA_ID,
       TRIMESTRE_ULTIMA_TAREA_ACTUALIZADA_ID,
       ANIO_ULTIMA_TAREA_ACTUALIZADA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                      DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_DIA_SEMANA
      (DIA_SEMANA_ULTIMA_TAREA_ACTUALIZADA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMA_TAREA_ACTUALIZADA_MES_ANIO
      (MES_ANIO_ULTIMA_TAREA_ACTUALIZADA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    
    
-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMA_TAREA_PENDIENTE
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                           DIM_FECHA_ULTIMA_TAREA_PENDIENTE_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMA_TAREA_PENDIENTE_ANIO
      (ANIO_ULTIMA_TAREA_PENDIENTE_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                      DIM_FECHA_ULTIMA_TAREA_PENDIENTE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMA_TAREA_PENDIENTE_TRIMESTRE
       (TRIMESTRE_ULTIMA_TAREA_PENDIENTE_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMA_TAREA_PENDIENTE_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                         DIM_FECHA_ULTIMA_TAREA_PENDIENTE_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMA_TAREA_PENDIENTE_MES
      (MES_ULTIMA_TAREA_PENDIENTE_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMA_TAREA_PENDIENTE_ID,
			 TRIMESTRE_ULTIMA_TAREA_PENDIENTE_ID,
			 ANIO_ULTIMA_TAREA_PENDIENTE_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_ULTIMA_TAREA_PENDIENTE_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMA_TAREA_PENDIENTE_DIA
      (DIA_ULTIMA_TAREA_PENDIENTE_ID,
       DIA_SEMANA_ULTIMA_TAREA_PENDIENTE_ID,
       MES_ULTIMA_TAREA_PENDIENTE_ID,
       TRIMESTRE_ULTIMA_TAREA_PENDIENTE_ID,
       ANIO_ULTIMA_TAREA_PENDIENTE_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                       DIM_FECHA_ULTIMA_TAREA_PENDIENTE_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMA_TAREA_PENDIENTE_DIA_SEMANA
      (DIA_SEMANA_ULTIMA_TAREA_PENDIENTE_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                       DIM_FECHA_ULTIMA_TAREA_PENDIENTE_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMA_TAREA_PENDIENTE_MES_ANIO
      (MES_ANIO_ULTIMA_TAREA_PENDIENTE_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                    DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ANIO
      (ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_TRIMESTRE
       (TRIMESTRE_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                    DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_MES
      (MES_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
			 TRIMESTRE_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
			 ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                     DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_DIA
      (DIA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
       DIA_SEMANA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
       MES_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
       TRIMESTRE_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
       ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_DIA_SEMANA
      (DIA_SEMANA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_MES_ANIO
      (MES_ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ANIO
      (ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_TRIMESTRE
       (TRIMESTRE_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_MES
      (MES_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
			 TRIMESTRE_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
			 ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_DIA
      (DIA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
       DIA_SEMANA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
       MES_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
       TRIMESTRE_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
       ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_DIA_SEMANA
      (DIA_SEMANA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_MES_ANIO
      (MES_ANIO_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
 

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_COBRO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_COBRO_ANIO
      (ANIO_COBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_COBRO_TRIMESTRE
       (TRIMESTRE_COBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_COBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_COBRO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_COBRO_MES
      (MES_COBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_COBRO_ID,
			 TRIMESTRE_COBRO_ID,
			 ANIO_COBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_COBRO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_COBRO_DIA
      (DIA_COBRO_ID,
       DIA_SEMANA_COBRO_ID,
       MES_COBRO_ID,
       TRIMESTRE_COBRO_ID,
       ANIO_COBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_COBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_COBRO_DIA_SEMANA
      (DIA_SEMANA_COBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_COBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_COBRO_MES_ANIO
      (MES_ANIO_COBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ACEPTACION
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ACEPTACION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ACEPTACION_ANIO
      (ANIO_ACEPTACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ACEPTACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ACEPTACION_TRIMESTRE
       (TRIMESTRE_ACEPTACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ACEPTACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_ACEPTACION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ACEPTACION_MES
      (MES_ACEPTACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ACEPTACION_ID,
			 TRIMESTRE_ACEPTACION_ID,
			 ANIO_ACEPTACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ACEPTACION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ACEPTACION_DIA
      (DIA_ACEPTACION_ID,
       DIA_SEMANA_ACEPTACION_ID,
       MES_ACEPTACION_ID,
       TRIMESTRE_ACEPTACION_ID,
       ANIO_ACEPTACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_ACEPTACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ACEPTACION_DIA_SEMANA
      (DIA_SEMANA_ACEPTACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_ACEPTACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ACEPTACION_MES_ANIO
      (MES_ANIO_ACEPTACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_INTERPOSICION_DEMANDA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_INTERPOSICION_DEMANDA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_INTERPOSICION_DEMANDA_ANIO
      (ANIO_INTERPOSICION_DEMANDA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_INTERPOSICION_DEMANDA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_INTERPOSICION_DEMANDA_TRIMESTRE
       (TRIMESTRE_INTERPOSICION_DEMANDA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INTERPOSICION_DEMANDA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_INTERPOSICION_DEMANDA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_INTERPOSICION_DEMANDA_MES
      (MES_INTERPOSICION_DEMANDA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INTERPOSICION_DEMANDA_ID,
			 TRIMESTRE_INTERPOSICION_DEMANDA_ID,
			 ANIO_INTERPOSICION_DEMANDA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_INTERPOSICION_DEMANDA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_INTERPOSICION_DEMANDA_DIA
      (DIA_INTERPOSICION_DEMANDA_ID,
       DIA_SEMANA_INTERPOSICION_DEMANDA_ID,
       MES_INTERPOSICION_DEMANDA_ID,
       TRIMESTRE_INTERPOSICION_DEMANDA_ID,
       ANIO_INTERPOSICION_DEMANDA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_INTERPOSICION_DEMANDA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_INTERPOSICION_DEMANDA_DIA_SEMANA
      (DIA_SEMANA_INTERPOSICION_DEMANDA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_INTERPOSICION_DEMANDA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_INTERPOSICION_DEMANDA_MES_ANIO
      (MES_ANIO_INTERPOSICION_DEMANDA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_DECRETO_FINALIZACION
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_DECRETO_FINALIZACION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_DECRETO_FINALIZACION_ANIO
      (ANIO_DECRETO_FINALIZACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_DECRETO_FINALIZACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_DECRETO_FINALIZACION_TRIMESTRE
       (TRIMESTRE_DECRETO_FINALIZACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_DECRETO_FINALIZACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_DECRETO_FINALIZACION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_DECRETO_FINALIZACION_MES
      (MES_DECRETO_FINALIZACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_DECRETO_FINALIZACION_ID,
			 TRIMESTRE_DECRETO_FINALIZACION_ID,
			 ANIO_DECRETO_FINALIZACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_DECRETO_FINALIZACION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_DECRETO_FINALIZACION_DIA
      (DIA_DECRETO_FINALIZACION_ID,
       DIA_SEMANA_DECRETO_FINALIZACION_ID,
       MES_DECRETO_FINALIZACION_ID,
       TRIMESTRE_DECRETO_FINALIZACION_ID,
       ANIO_DECRETO_FINALIZACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_DECRETO_FINALIZACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_DECRETO_FINALIZACION_DIA_SEMANA
      (DIA_SEMANA_DECRETO_FINALIZACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_DECRETO_FINALIZACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_DECRETO_FINALIZACION_MES_ANIO
      (MES_ANIO_DECRETO_FINALIZACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_RESOLUCION_FIRME
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RESOLUCION_FIRME_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_RESOLUCION_FIRME_ANIO
      (ANIO_RESOLUCION_FIRME_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RESOLUCION_FIRME_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_RESOLUCION_FIRME_TRIMESTRE
       (TRIMESTRE_RESOLUCION_FIRME_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_RESOLUCION_FIRME_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_RESOLUCION_FIRME_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_RESOLUCION_FIRME_MES
      (MES_RESOLUCION_FIRME_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_RESOLUCION_FIRME_ID,
			 TRIMESTRE_RESOLUCION_FIRME_ID,
			 ANIO_RESOLUCION_FIRME_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RESOLUCION_FIRME_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_RESOLUCION_FIRME_DIA
      (DIA_RESOLUCION_FIRME_ID,
       DIA_SEMANA_RESOLUCION_FIRME_ID,
       MES_RESOLUCION_FIRME_ID,
       TRIMESTRE_RESOLUCION_FIRME_ID,
       ANIO_RESOLUCION_FIRME_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_RESOLUCION_FIRME_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_RESOLUCION_FIRME_DIA_SEMANA
      (DIA_SEMANA_RESOLUCION_FIRME_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_RESOLUCION_FIRME_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_RESOLUCION_FIRME_MES_ANIO
      (MES_ANIO_RESOLUCION_FIRME_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_SUBASTA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_SUBASTA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_SUBASTA_ANIO
      (ANIO_SUBASTA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_SUBASTA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_SUBASTA_TRIMESTRE
       (TRIMESTRE_SUBASTA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SUBASTA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_SUBASTA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_SUBASTA_MES
      (MES_SUBASTA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SUBASTA_ID,
			 TRIMESTRE_SUBASTA_ID,
			 ANIO_SUBASTA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_SUBASTA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_SUBASTA_DIA
      (DIA_SUBASTA_ID,
       DIA_SEMANA_SUBASTA_ID,
       MES_SUBASTA_ID,
       TRIMESTRE_SUBASTA_ID,
       ANIO_SUBASTA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_SUBASTA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_SUBASTA_DIA_SEMANA
      (DIA_SEMANA_SUBASTA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_SUBASTA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_SUBASTA_MES_ANIO
      (MES_ANIO_SUBASTA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_ANIO
      (ANIO_SUBASTA_EJECUCION_NOTARIAL_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_TRIMESTRE
       (TRIMESTRE_SUBASTA_EJECUCION_NOTARIAL_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SUBASTA_EJECUCION_NOTARIAL_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_MES
      (MES_SUBASTA_EJECUCION_NOTARIAL_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SUBASTA_EJECUCION_NOTARIAL_ID,
			 TRIMESTRE_SUBASTA_EJECUCION_NOTARIAL_ID,
			 ANIO_SUBASTA_EJECUCION_NOTARIAL_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_DIA
      (DIA_SUBASTA_EJECUCION_NOTARIAL_ID,
       DIA_SEMANA_SUBASTA_EJECUCION_NOTARIAL_ID,
       MES_SUBASTA_EJECUCION_NOTARIAL_ID,
       TRIMESTRE_SUBASTA_EJECUCION_NOTARIAL_ID,
       ANIO_SUBASTA_EJECUCION_NOTARIAL_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_DIA_SEMANA
      (DIA_SEMANA_SUBASTA_EJECUCION_NOTARIAL_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_SUBASTA_EJECUCION_NOTARIAL_MES_ANIO
      (MES_ANIO_SUBASTA_EJECUCION_NOTARIAL_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_INICIO_APREMIO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_INICIO_APREMIO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_INICIO_APREMIO_ANIO
      (ANIO_INICIO_APREMIO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_INICIO_APREMIO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_INICIO_APREMIO_TRIMESTRE
       (TRIMESTRE_INICIO_APREMIO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INICIO_APREMIO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_INICIO_APREMIO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_INICIO_APREMIO_MES
      (MES_INICIO_APREMIO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INICIO_APREMIO_ID,
			 TRIMESTRE_INICIO_APREMIO_ID,
			 ANIO_INICIO_APREMIO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_INICIO_APREMIO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_INICIO_APREMIO_DIA
      (DIA_INICIO_APREMIO_ID,
       DIA_SEMANA_INICIO_APREMIO_ID,
       MES_INICIO_APREMIO_ID,
       TRIMESTRE_INICIO_APREMIO_ID,
       ANIO_INICIO_APREMIO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_INICIO_APREMIO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_INICIO_APREMIO_DIA_SEMANA
      (DIA_SEMANA_INICIO_APREMIO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_INICIO_APREMIO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_INICIO_APREMIO_MES_ANIO
      (MES_ANIO_INICIO_APREMIO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ESTIMADA_COBRO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ESTIMADA_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ESTIMADA_COBRO_ANIO
      (ANIO_ESTIMADA_COBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ESTIMADA_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ESTIMADA_COBRO_TRIMESTRE
       (TRIMESTRE_ESTIMADA_COBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ESTIMADA_COBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_ESTIMADA_COBRO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ESTIMADA_COBRO_MES
      (MES_ESTIMADA_COBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ESTIMADA_COBRO_ID,
			 TRIMESTRE_ESTIMADA_COBRO_ID,
			 ANIO_ESTIMADA_COBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ESTIMADA_COBRO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ESTIMADA_COBRO_DIA
      (DIA_ESTIMADA_COBRO_ID,
       DIA_SEMANA_ESTIMADA_COBRO_ID,
       MES_ESTIMADA_COBRO_ID,
       TRIMESTRE_ESTIMADA_COBRO_ID,
       ANIO_ESTIMADA_COBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_ESTIMADA_COBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ESTIMADA_COBRO_DIA_SEMANA
      (DIA_SEMANA_ESTIMADA_COBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_ESTIMADA_COBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ESTIMADA_COBRO_MES_ANIO
      (MES_ANIO_ESTIMADA_COBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMA_ESTIMACION
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ULTIMA_ESTIMACION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMA_ESTIMACION_ANIO
      (ANIO_ULTIMA_ESTIMACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ULTIMA_ESTIMACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMA_ESTIMACION_TRIMESTRE
       (TRIMESTRE_ULTIMA_ESTIMACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMA_ESTIMACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_ULTIMA_ESTIMACION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMA_ESTIMACION_MES
      (MES_ULTIMA_ESTIMACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMA_ESTIMACION_ID,
			 TRIMESTRE_ULTIMA_ESTIMACION_ID,
			 ANIO_ULTIMA_ESTIMACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_ULTIMA_ESTIMACION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMA_ESTIMACION_DIA
      (DIA_ULTIMA_ESTIMACION_ID,
       DIA_SEMANA_ULTIMA_ESTIMACION_ID,
       MES_ULTIMA_ESTIMACION_ID,
       TRIMESTRE_ULTIMA_ESTIMACION_ID,
       ANIO_ULTIMA_ESTIMACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_ULTIMA_ESTIMACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMA_ESTIMACION_DIA_SEMANA
      (DIA_SEMANA_ULTIMA_ESTIMACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_ULTIMA_ESTIMACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMA_ESTIMACION_MES_ANIO
      (MES_ANIO_ULTIMA_ESTIMACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_LIQUIDACION
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_LIQUIDACION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_LIQUIDACION_ANIO
      (ANIO_LIQUIDACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_LIQUIDACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_LIQUIDACION_TRIMESTRE
       (TRIMESTRE_LIQUIDACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_LIQUIDACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_LIQUIDACION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_LIQUIDACION_MES
      (MES_LIQUIDACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_LIQUIDACION_ID,
			 TRIMESTRE_LIQUIDACION_ID,
			 ANIO_LIQUIDACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_LIQUIDACION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_LIQUIDACION_DIA
      (DIA_LIQUIDACION_ID,
       DIA_SEMANA_LIQUIDACION_ID,
       MES_LIQUIDACION_ID,
       TRIMESTRE_LIQUIDACION_ID,
       ANIO_LIQUIDACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_LIQUIDACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_LIQUIDACION_DIA_SEMANA
      (DIA_SEMANA_LIQUIDACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_LIQUIDACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_LIQUIDACION_MES_ANIO
      (MES_ANIO_LIQUIDACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_INSINUACION_FINAL_CREDITO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_INSINUACION_FINAL_CREDITO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_INSINUACION_FINAL_CREDITO_ANIO
      (ANIO_INSINUACION_FINAL_CREDITO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_INSINUACION_FINAL_CREDITO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_INSINUACION_FINAL_CREDITO_TRIMESTRE
       (TRIMESTRE_INSINUACION_FINAL_CREDITO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INSINUACION_FINAL_CREDITO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_INSINUACION_FINAL_CREDITO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_INSINUACION_FINAL_CREDITO_MES
      (MES_INSINUACION_FINAL_CREDITO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INSINUACION_FINAL_CREDITO_ID,
			 TRIMESTRE_INSINUACION_FINAL_CREDITO_ID,
			 ANIO_INSINUACION_FINAL_CREDITO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_INSINUACION_FINAL_CREDITO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_INSINUACION_FINAL_CREDITO_DIA
      (DIA_INSINUACION_FINAL_CREDITO_ID,
       DIA_SEMANA_INSINUACION_FINAL_CREDITO_ID,
       MES_INSINUACION_FINAL_CREDITO_ID,
       TRIMESTRE_INSINUACION_FINAL_CREDITO_ID,
       ANIO_INSINUACION_FINAL_CREDITO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_INSINUACION_FINAL_CREDITO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_INSINUACION_FINAL_CREDITO_DIA_SEMANA
      (DIA_SEMANA_INSINUACION_FINAL_CREDITO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_INSINUACION_FINAL_CREDITO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_INSINUACION_FINAL_CREDITO_MES_ANIO
      (MES_ANIO_INSINUACION_FINAL_CREDITO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_AUTO_APERTURA_CONVENIO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_AUTO_APERTURA_CONVENIO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_AUTO_APERTURA_CONVENIO_ANIO
      (ANIO_AUTO_APERTURA_CONVENIO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_AUTO_APERTURA_CONVENIO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_AUTO_APERTURA_CONVENIO_TRIMESTRE
       (TRIMESTRE_AUTO_APERTURA_CONVENIO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_AUTO_APERTURA_CONVENIO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_AUTO_APERTURA_CONVENIO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_AUTO_APERTURA_CONVENIO_MES
      (MES_AUTO_APERTURA_CONVENIO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_AUTO_APERTURA_CONVENIO_ID,
			 TRIMESTRE_AUTO_APERTURA_CONVENIO_ID,
			 ANIO_AUTO_APERTURA_CONVENIO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_AUTO_APERTURA_CONVENIO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_AUTO_APERTURA_CONVENIO_DIA
      (DIA_AUTO_APERTURA_CONVENIO_ID,
       DIA_SEMANA_AUTO_APERTURA_CONVENIO_ID,
       MES_AUTO_APERTURA_CONVENIO_ID,
       TRIMESTRE_AUTO_APERTURA_CONVENIO_ID,
       ANIO_AUTO_APERTURA_CONVENIO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_AUTO_APERTURA_CONVENIO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_AUTO_APERTURA_CONVENIO_DIA_SEMANA
      (DIA_SEMANA_AUTO_APERTURA_CONVENIO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_AUTO_APERTURA_CONVENIO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_AUTO_APERTURA_CONVENIO_MES_ANIO
      (MES_ANIO_AUTO_APERTURA_CONVENIO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
   

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_JUNTA_ACREEDORES
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_JUNTA_ACREEDORES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_JUNTA_ACREEDORES_ANIO
      (ANIO_JUNTA_ACREEDORES_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_JUNTA_ACREEDORES_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_JUNTA_ACREEDORES_TRIMESTRE
       (TRIMESTRE_JUNTA_ACREEDORES_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_JUNTA_ACREEDORES_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_JUNTA_ACREEDORES_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_JUNTA_ACREEDORES_MES
      (MES_JUNTA_ACREEDORES_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_JUNTA_ACREEDORES_ID,
			 TRIMESTRE_JUNTA_ACREEDORES_ID,
			 ANIO_JUNTA_ACREEDORES_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_JUNTA_ACREEDORES_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_JUNTA_ACREEDORES_DIA
      (DIA_JUNTA_ACREEDORES_ID,
       DIA_SEMANA_JUNTA_ACREEDORES_ID,
       MES_JUNTA_ACREEDORES_ID,
       TRIMESTRE_JUNTA_ACREEDORES_ID,
       ANIO_JUNTA_ACREEDORES_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_JUNTA_ACREEDORES_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_JUNTA_ACREEDORES_DIA_SEMANA
      (DIA_SEMANA_JUNTA_ACREEDORES_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_JUNTA_ACREEDORES_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_JUNTA_ACREEDORES_MES_ANIO
      (MES_ANIO_JUNTA_ACREEDORES_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
 

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ANIO
      (ANIO_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_TRIMESTRE
       (TRIMESTRE_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_MES
      (MES_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
			 TRIMESTRE_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
			 ANIO_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_DIA
      (DIA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
       DIA_SEMANA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
       MES_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
       TRIMESTRE_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
       ANIO_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_DIA_SEMANA
      (DIA_SEMANA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_MES_ANIO
      (MES_ANIO_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_CREACION_TAREA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_CREACION_TAREA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_CREACION_TAREA_ANIO
      (ANIO_CREACION_TAREA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_CREACION_TAREA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_CREACION_TAREA_TRIMESTRE
       (TRIMESTRE_CREACION_TAREA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_TAREA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_CREACION_TAREA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_CREACION_TAREA_MES
      (MES_CREACION_TAREA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_TAREA_ID,
			 TRIMESTRE_CREACION_TAREA_ID,
			 ANIO_CREACION_TAREA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_CREACION_TAREA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_CREACION_TAREA_DIA
      (DIA_CREACION_TAREA_ID,
       DIA_SEMANA_CREACION_TAREA_ID,
       MES_CREACION_TAREA_ID,
       TRIMESTRE_CREACION_TAREA_ID,
       ANIO_CREACION_TAREA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_CREACION_TAREA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_CREACION_TAREA_DIA_SEMANA
      (DIA_SEMANA_CREACION_TAREA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_CREACION_TAREA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_CREACION_TAREA_MES_ANIO
      (MES_ANIO_CREACION_TAREA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_FINALIZACION_TAREA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_FINALIZACION_TAREA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_FINALIZACION_TAREA_ANIO
      (ANIO_FINALIZACION_TAREA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_FINALIZACION_TAREA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_FINALIZACION_TAREA_TRIMESTRE
       (TRIMESTRE_FINALIZACION_TAREA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FINALIZACION_TAREA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_FINALIZACION_TAREA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_FINALIZACION_TAREA_MES
      (MES_FINALIZACION_TAREA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FINALIZACION_TAREA_ID,
			 TRIMESTRE_FINALIZACION_TAREA_ID,
			 ANIO_FINALIZACION_TAREA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_FINALIZACION_TAREA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_FINALIZACION_TAREA_DIA
      (DIA_FINALIZACION_TAREA_ID,
       DIA_SEMANA_FINALIZACION_TAREA_ID,
       MES_FINALIZACION_TAREA_ID,
       TRIMESTRE_FINALIZACION_TAREA_ID,
       ANIO_FINALIZACION_TAREA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_FINALIZACION_TAREA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_FINALIZACION_TAREA_DIA_SEMANA
      (DIA_SEMANA_FINALIZACION_TAREA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_FINALIZACION_TAREA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_FINALIZACION_TAREA_MES_ANIO
      (MES_ANIO_FINALIZACION_TAREA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 

	
-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_ANIO
      (ANIO_RECOGIDA_DOC_Y_ACEPTACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_TRIMESTRE
       (TRIMESTRE_RECOGIDA_DOC_Y_ACEPTACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_RECOGIDA_DOC_Y_ACEPTACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_MES
      (MES_RECOGIDA_DOC_Y_ACEPTACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_RECOGIDA_DOC_Y_ACEPTACION_ID,
			 TRIMESTRE_RECOGIDA_DOC_Y_ACEPTACION_ID,
			 ANIO_RECOGIDA_DOC_Y_ACEPTACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_DIA
      (DIA_RECOGIDA_DOC_Y_ACEPTACION_ID,
       DIA_SEMANA_RECOGIDA_DOC_Y_ACEPTACION_ID,
       MES_RECOGIDA_DOC_Y_ACEPTACION_ID,
       TRIMESTRE_RECOGIDA_DOC_Y_ACEPTACION_ID,
       ANIO_RECOGIDA_DOC_Y_ACEPTACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_DIA_SEMANA
      (DIA_SEMANA_RECOGIDA_DOC_Y_ACEPTACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_RECOGIDA_DOC_Y_ACEPTACION_MES_ANIO
      (MES_ANIO_RECOGIDA_DOC_Y_ACEPTACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_REGISTRAR_TOMA_DECISION
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_REGISTRAR_TOMA_DECISION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_REGISTRAR_TOMA_DECISION_ANIO
      (ANIO_FECHA_REGISTRAR_TOMA_DECISION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_REGISTRAR_TOMA_DECISION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_REGISTRAR_TOMA_DECISION_TRIMESTRE
       (TRIMESTRE_FECHA_REGISTRAR_TOMA_DECISION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FECHA_REGISTRAR_TOMA_DECISION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_REGISTRAR_TOMA_DECISION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_REGISTRAR_TOMA_DECISION_MES
      (MES_FECHA_REGISTRAR_TOMA_DECISION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FECHA_REGISTRAR_TOMA_DECISION_ID,
			 TRIMESTRE_FECHA_REGISTRAR_TOMA_DECISION_ID,
			 ANIO_FECHA_REGISTRAR_TOMA_DECISION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_REGISTRAR_TOMA_DECISION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_REGISTRAR_TOMA_DECISION_DIA
      (DIA_FECHA_REGISTRAR_TOMA_DECISION_ID,
       DIA_SEMANA_FECHA_REGISTRAR_TOMA_DECISION_ID,
       MES_FECHA_REGISTRAR_TOMA_DECISION_ID,
       TRIMESTRE_FECHA_REGISTRAR_TOMA_DECISION_ID,
       ANIO_FECHA_REGISTRAR_TOMA_DECISION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_REGISTRAR_TOMA_DECISION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_REGISTRAR_TOMA_DECISION_DIA_SEMANA
      (DIA_SEMANA_FECHA_REGISTRAR_TOMA_DECISION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_REGISTRAR_TOMA_DECISION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_REGISTRAR_TOMA_DECISION_MES_ANIO
      (MES_ANIO_FECHA_REGISTRAR_TOMA_DECISION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


	
-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_RECEPCION_DOC_COMPLETA
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RECEPCION_DOC_COMPLETA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_RECEPCION_DOC_COMPLETA_ANIO
      (ANIO_FECHA_RECEPCION_DOC_COMPLETA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RECEPCION_DOC_COMPLETA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_RECEPCION_DOC_COMPLETA_TRIMESTRE
       (TRIMESTRE_FECHA_RECEPCION_DOC_COMPLETA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FECHA_RECEPCION_DOC_COMPLETA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_RECEPCION_DOC_COMPLETA_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_RECEPCION_DOC_COMPLETA_MES
      (MES_FECHA_RECEPCION_DOC_COMPLETA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FECHA_RECEPCION_DOC_COMPLETA_ID,
			 TRIMESTRE_FECHA_RECEPCION_DOC_COMPLETA_ID,
			 ANIO_FECHA_RECEPCION_DOC_COMPLETA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RECEPCION_DOC_COMPLETA_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_RECEPCION_DOC_COMPLETA_DIA
      (DIA_FECHA_RECEPCION_DOC_COMPLETA_ID,
       DIA_SEMANA_FECHA_RECEPCION_DOC_COMPLETA_ID,
       MES_FECHA_RECEPCION_DOC_COMPLETA_ID,
       TRIMESTRE_FECHA_RECEPCION_DOC_COMPLETA_ID,
       ANIO_FECHA_RECEPCION_DOC_COMPLETA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_RECEPCION_DOC_COMPLETA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_RECEPCION_DOC_COMPLETA_DIA_SEMANA
      (DIA_SEMANA_FECHA_RECEPCION_DOC_COMPLETA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_RECEPCION_DOC_COMPLETA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_RECEPCION_DOC_COMPLETA_MES_ANIO
      (MES_ANIO_FECHA_RECEPCION_DOC_COMPLETA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_CONTABLE_LITIGIO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_CONTABLE_LITIGIO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_CONTABLE_LITIGIO_ANIO
      (ANIO_FECHA_CONTABLE_LITIGIO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_CONTABLE_LITIGIO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_CONTABLE_LITIGIO_TRIMESTRE
       (TRIMESTRE_FECHA_CONTABLE_LITIGIO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FECHA_CONTABLE_LITIGIO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_CONTABLE_LITIGIO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_CONTABLE_LITIGIO_MES
      (MES_FECHA_CONTABLE_LITIGIO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FECHA_CONTABLE_LITIGIO_ID,
			 TRIMESTRE_FECHA_CONTABLE_LITIGIO_ID,
			 ANIO_FECHA_CONTABLE_LITIGIO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_CONTABLE_LITIGIO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_CONTABLE_LITIGIO_DIA
      (DIA_FECHA_CONTABLE_LITIGIO_ID,
       DIA_SEMANA_FECHA_CONTABLE_LITIGIO_ID,
       MES_FECHA_CONTABLE_LITIGIO_ID,
       TRIMESTRE_FECHA_CONTABLE_LITIGIO_ID,
       ANIO_FECHA_CONTABLE_LITIGIO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_CONTABLE_LITIGIO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_CONTABLE_LITIGIO_DIA_SEMANA
      (DIA_SEMANA_FECHA_CONTABLE_LITIGIO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_CONTABLE_LITIGIO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_CONTABLE_LITIGIO_MES_ANIO
      (MES_ANIO_FECHA_CONTABLE_LITIGIO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_DPS
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_DPS_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_DPS_ANIO
      (ANIO_DPS_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_DPS_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_DPS_TRIMESTRE
       (TRIMESTRE_DPS_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_DPS_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_DPS_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_DPS_MES
      (MES_DPS_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_DPS_ID,
			 TRIMESTRE_DPS_ID,
			 ANIO_DPS_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_DPS_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_DPS_DIA
      (DIA_DPS_ID,
       DIA_SEMANA_DPS_ID,
       MES_DPS_ID,
       TRIMESTRE_DPS_ID,
       ANIO_DPS_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_DPS_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_DPS_DIA_SEMANA
      (DIA_SEMANA_DPS_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_DPS_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_DPS_MES_ANIO
      (MES_ANIO_DPS_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_COMPROMETIDA_PAGO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_COMPROMETIDA_PAGO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_COMPROMETIDA_PAGO_ANIO
      (ANIO_COMPROMETIDA_PAGO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_COMPROMETIDA_PAGO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_COMPROMETIDA_PAGO_TRIMESTRE
       (TRIMESTRE_COMPROMETIDA_PAGO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_COMPROMETIDA_PAGO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_COMPROMETIDA_PAGO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_COMPROMETIDA_PAGO_MES
      (MES_COMPROMETIDA_PAGO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_COMPROMETIDA_PAGO_ID,
			 TRIMESTRE_COMPROMETIDA_PAGO_ID,
			 ANIO_COMPROMETIDA_PAGO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_COMPROMETIDA_PAGO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_COMPROMETIDA_PAGO_DIA
      (DIA_COMPROMETIDA_PAGO_ID,
       DIA_SEMANA_COMPROMETIDA_PAGO_ID,
       MES_COMPROMETIDA_PAGO_ID,
       TRIMESTRE_COMPROMETIDA_PAGO_ID,
       ANIO_COMPROMETIDA_PAGO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_COMPROMETIDA_PAGO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_COMPROMETIDA_PAGO_DIA_SEMANA
      (DIA_SEMANA_COMPROMETIDA_PAGO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_COMPROMETIDA_PAGO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_COMPROMETIDA_PAGO_MES_ANIO
      (MES_ANIO_COMPROMETIDA_PAGO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ALTA_GESTION_RECOBRO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ALTA_GESTION_RECOBRO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ALTA_GESTION_RECOBRO_ANIO
      (ANIO_ALTA_GESTION_RECOBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ALTA_GESTION_RECOBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ALTA_GESTION_RECOBRO_TRIMESTRE
       (TRIMESTRE_ALTA_GESTION_RECOBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ALTA_GESTION_RECOBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ALTA_GESTION_RECOBRO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ALTA_GESTION_RECOBRO_MES
      (MES_ALTA_GESTION_RECOBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ALTA_GESTION_RECOBRO_ID,
			 TRIMESTRE_ALTA_GESTION_RECOBRO_ID,
			 ANIO_ALTA_GESTION_RECOBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ALTA_GESTION_RECOBRO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ALTA_GESTION_RECOBRO_DIA
      (DIA_ALTA_GESTION_RECOBRO_ID,
       DIA_SEMANA_ALTA_GESTION_RECOBRO_ID,
       MES_ALTA_GESTION_RECOBRO_ID,
       TRIMESTRE_ALTA_GESTION_RECOBRO_ID,
       ANIO_ALTA_GESTION_RECOBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ALTA_GESTION_RECOBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ALTA_GESTION_RECOBRO_DIA_SEMANA
      (DIA_SEMANA_ALTA_GESTION_RECOBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ALTA_GESTION_RECOBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ALTA_GESTION_RECOBRO_MES_ANIO
      (MES_ANIO_ALTA_GESTION_RECOBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 



-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_BAJA_GESTION_RECOBRO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_BAJA_GESTION_RECOBRO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_BAJA_GESTION_RECOBRO_ANIO
      (ANIO_BAJA_GESTION_RECOBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_BAJA_GESTION_RECOBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_BAJA_GESTION_RECOBRO_TRIMESTRE
       (TRIMESTRE_BAJA_GESTION_RECOBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_BAJA_GESTION_RECOBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_BAJA_GESTION_RECOBRO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_BAJA_GESTION_RECOBRO_MES
      (MES_BAJA_GESTION_RECOBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_BAJA_GESTION_RECOBRO_ID,
			 TRIMESTRE_BAJA_GESTION_RECOBRO_ID,
			 ANIO_BAJA_GESTION_RECOBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_BAJA_GESTION_RECOBRO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_BAJA_GESTION_RECOBRO_DIA
      (DIA_BAJA_GESTION_RECOBRO_ID,
       DIA_SEMANA_BAJA_GESTION_RECOBRO_ID,
       MES_BAJA_GESTION_RECOBRO_ID,
       TRIMESTRE_BAJA_GESTION_RECOBRO_ID,
       ANIO_BAJA_GESTION_RECOBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_BAJA_GESTION_RECOBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_BAJA_GESTION_RECOBRO_DIA_SEMANA
      (DIA_SEMANA_BAJA_GESTION_RECOBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_BAJA_GESTION_RECOBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_BAJA_GESTION_RECOBRO_MES_ANIO
      (MES_ANIO_BAJA_GESTION_RECOBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
   
   

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ACTUACION_RECOBRO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ACTUACION_RECOBRO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ACTUACION_RECOBRO_ANIO
      (ANIO_ACTUACION_RECOBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ACTUACION_RECOBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ACTUACION_RECOBRO_TRIMESTRE
       (TRIMESTRE_ACTUACION_RECOBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ACTUACION_RECOBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ACTUACION_RECOBRO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ACTUACION_RECOBRO_MES
      (MES_ACTUACION_RECOBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ACTUACION_RECOBRO_ID,
			 TRIMESTRE_ACTUACION_RECOBRO_ID,
			 ANIO_ACTUACION_RECOBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ACTUACION_RECOBRO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ACTUACION_RECOBRO_DIA
      (DIA_ACTUACION_RECOBRO_ID,
       DIA_SEMANA_ACTUACION_RECOBRO_ID,
       MES_ACTUACION_RECOBRO_ID,
       TRIMESTRE_ACTUACION_RECOBRO_ID,
       ANIO_ACTUACION_RECOBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ACTUACION_RECOBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ACTUACION_RECOBRO_DIA_SEMANA
      (DIA_SEMANA_ACTUACION_RECOBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ACTUACION_RECOBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ACTUACION_RECOBRO_MES_ANIO
      (MES_ANIO_ACTUACION_RECOBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_PAGO_COMPROMETIDO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_PAGO_COMPROMETIDO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_PAGO_COMPROMETIDO_ANIO
      (ANIO_PAGO_COMPROMETIDO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_PAGO_COMPROMETIDO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_PAGO_COMPROMETIDO_TRIMESTRE
       (TRIMESTRE_PAGO_COMPROMETIDO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_PAGO_COMPROMETIDO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_PAGO_COMPROMETIDO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_PAGO_COMPROMETIDO_MES
      (MES_PAGO_COMPROMETIDO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_PAGO_COMPROMETIDO_ID,
			 TRIMESTRE_PAGO_COMPROMETIDO_ID,
			 ANIO_PAGO_COMPROMETIDO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_PAGO_COMPROMETIDO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_PAGO_COMPROMETIDO_DIA
      (DIA_PAGO_COMPROMETIDO_ID,
       DIA_SEMANA_PAGO_COMPROMETIDO_ID,
       MES_PAGO_COMPROMETIDO_ID,
       TRIMESTRE_PAGO_COMPROMETIDO_ID,
       ANIO_PAGO_COMPROMETIDO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_PAGO_COMPROMETIDO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_PAGO_COMPROMETIDO_DIA_SEMANA
      (DIA_SEMANA_PAGO_COMPROMETIDO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_PAGO_COMPROMETIDO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_PAGO_COMPROMETIDO_MES_ANIO
      (MES_ANIO_PAGO_COMPROMETIDO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_RESOLUCION
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RESOLUCION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1970-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_RESOLUCION_ANIO
      (ANIO_RESOLUCION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RESOLUCION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_RESOLUCION_TRIMESTRE
       (TRIMESTRE_RESOLUCION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_RESOLUCION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                   DIM_FECHA_RESOLUCION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_RESOLUCION_MES
      (MES_RESOLUCION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_RESOLUCION_ID,
			 TRIMESTRE_RESOLUCION_ID,
			 ANIO_RESOLUCION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                  DIM_FECHA_RESOLUCION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_RESOLUCION_DIA
      (DIA_RESOLUCION_ID,
       DIA_SEMANA_RESOLUCION_ID,
       MES_RESOLUCION_ID,
       TRIMESTRE_RESOLUCION_ID,
       ANIO_RESOLUCION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                DIM_FECHA_RESOLUCION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_RESOLUCION_DIA_SEMANA
      (DIA_SEMANA_RESOLUCION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--              DIM_FECHA_RESOLUCION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1970-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_RESOLUCION_MES_ANIO
      (MES_ANIO_RESOLUCION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
 
 
-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_CREACION_CONTRATO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                             DIM_FECHA_CREACION_CONTRATO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_CREACION_CONTRATO_ANIO
      (ANIO_CREACION_CONTRATO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                        DIM_FECHA_CREACION_CONTRATO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_CREACION_CONTRATO_TRIMESTRE
       (TRIMESTRE_CREACION_CONTRATO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_CONTRATO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                             DIM_FECHA_CREACION_CONTRATO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_CREACION_CONTRATO_MES
      (MES_CREACION_CONTRATO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_CONTRATO_ID,
			 TRIMESTRE_CREACION_CONTRATO_ID,
			 ANIO_CREACION_CONTRATO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                           DIM_FECHA_CREACION_CONTRATO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_CREACION_CONTRATO_DIA
      (DIA_CREACION_CONTRATO_ID,
       DIA_SEMANA_CREACION_CONTRATO_ID,
       MES_CREACION_CONTRATO_ID,
       TRIMESTRE_CREACION_CONTRATO_ID,
       ANIO_CREACION_CONTRATO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_CREACION_CONTRATO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_CREACION_CONTRATO_DIA_SEMANA
      (DIA_SEMANA_CREACION_CONTRATO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                          DIM_FECHA_CREACION_CONTRATO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_CREACION_CONTRATO_MES_ANIO
      (MES_ANIO_CREACION_CONTRATO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMO_COBRO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMO_COBRO_ANIO
      (ANIO_ULTIMO_COBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ULTIMO_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMO_COBRO_TRIMESTRE
       (TRIMESTRE_ULTIMO_COBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMO_COBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_COBRO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMO_COBRO_MES
      (MES_ULTIMO_COBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMO_COBRO_ID,
			 TRIMESTRE_ULTIMO_COBRO_ID,
			 ANIO_ULTIMO_COBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_COBRO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMO_COBRO_DIA
      (DIA_ULTIMO_COBRO_ID,
       DIA_SEMANA_ULTIMO_COBRO_ID,
       MES_ULTIMO_COBRO_ID,
       TRIMESTRE_ULTIMO_COBRO_ID,
       ANIO_ULTIMO_COBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_COBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMO_COBRO_DIA_SEMANA
      (DIA_SEMANA_ULTIMO_COBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_COBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMO_COBRO_MES_ANIO
      (MES_ANIO_ULTIMO_COBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
     

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMA_RESOLUCION
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_RESOLUCION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMA_RESOLUCION_ANIO
      (ANIO_ULTIMA_RESOLUCION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ULTIMA_RESOLUCION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMA_RESOLUCION_TRIMESTRE
       (TRIMESTRE_ULTIMA_RESOLUCION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMA_RESOLUCION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_RESOLUCION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMA_RESOLUCION_MES
      (MES_ULTIMA_RESOLUCION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMA_RESOLUCION_ID,
			 TRIMESTRE_ULTIMA_RESOLUCION_ID,
			 ANIO_ULTIMA_RESOLUCION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_RESOLUCION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMA_RESOLUCION_DIA
      (DIA_ULTIMA_RESOLUCION_ID,
       DIA_SEMANA_ULTIMA_RESOLUCION_ID,
       MES_ULTIMA_RESOLUCION_ID,
       TRIMESTRE_ULTIMA_RESOLUCION_ID,
       ANIO_ULTIMA_RESOLUCION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_RESOLUCION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMA_RESOLUCION_DIA_SEMANA
      (DIA_SEMANA_ULTIMA_RESOLUCION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_RESOLUCION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMA_RESOLUCION_MES_ANIO
      (MES_ANIO_ULTIMA_RESOLUCION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMO_IMPULSO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_IMPULSO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMO_IMPULSO_ANIO
      (ANIO_ULTIMO_IMPULSO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ULTIMO_IMPULSO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMO_IMPULSO_TRIMESTRE
       (TRIMESTRE_ULTIMO_IMPULSO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMO_IMPULSO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_IMPULSO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMO_IMPULSO_MES
      (MES_ULTIMO_IMPULSO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMO_IMPULSO_ID,
			 TRIMESTRE_ULTIMO_IMPULSO_ID,
			 ANIO_ULTIMO_IMPULSO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_IMPULSO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMO_IMPULSO_DIA
      (DIA_ULTIMO_IMPULSO_ID,
       DIA_SEMANA_ULTIMO_IMPULSO_ID,
       MES_ULTIMO_IMPULSO_ID,
       TRIMESTRE_ULTIMO_IMPULSO_ID,
       ANIO_ULTIMO_IMPULSO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_IMPULSO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMO_IMPULSO_DIA_SEMANA
      (DIA_SEMANA_ULTIMO_IMPULSO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_IMPULSO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMO_IMPULSO_MES_ANIO
      (MES_ANIO_ULTIMO_IMPULSO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMA_INADMISION
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_INADMISION_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMA_INADMISION_ANIO
      (ANIO_ULTIMA_INADMISION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ULTIMA_INADMISION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMA_INADMISION_TRIMESTRE
       (TRIMESTRE_ULTIMA_INADMISION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMA_INADMISION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_INADMISION_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMA_INADMISION_MES
      (MES_ULTIMA_INADMISION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMA_INADMISION_ID,
			 TRIMESTRE_ULTIMA_INADMISION_ID,
			 ANIO_ULTIMA_INADMISION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_INADMISION_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMA_INADMISION_DIA
      (DIA_ULTIMA_INADMISION_ID,
       DIA_SEMANA_ULTIMA_INADMISION_ID,
       MES_ULTIMA_INADMISION_ID,
       TRIMESTRE_ULTIMA_INADMISION_ID,
       ANIO_ULTIMA_INADMISION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_INADMISION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMA_INADMISION_DIA_SEMANA
      (DIA_SEMANA_ULTIMA_INADMISION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMA_INADMISION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMA_INADMISION_MES_ANIO
      (MES_ANIO_ULTIMA_INADMISION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    

-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMO_ARCHIVO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_ARCHIVO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMO_ARCHIVO_ANIO
      (ANIO_ULTIMO_ARCHIVO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ULTIMO_ARCHIVO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMO_ARCHIVO_TRIMESTRE
       (TRIMESTRE_ULTIMO_ARCHIVO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMO_ARCHIVO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_ARCHIVO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMO_ARCHIVO_MES
      (MES_ULTIMO_ARCHIVO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMO_ARCHIVO_ID,
			 TRIMESTRE_ULTIMO_ARCHIVO_ID,
			 ANIO_ULTIMO_ARCHIVO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_ARCHIVO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMO_ARCHIVO_DIA
      (DIA_ULTIMO_ARCHIVO_ID,
       DIA_SEMANA_ULTIMO_ARCHIVO_ID,
       MES_ULTIMO_ARCHIVO_ID,
       TRIMESTRE_ULTIMO_ARCHIVO_ID,
       ANIO_ULTIMO_ARCHIVO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_ARCHIVO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMO_ARCHIVO_DIA_SEMANA
      (DIA_SEMANA_ULTIMO_ARCHIVO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_ARCHIVO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMO_ARCHIVO_MES_ANIO
      (MES_ANIO_ULTIMO_ARCHIVO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
-- 
--                              DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set num_years=60;
set max_date = '1969-01-01';

while (i<num_years)
	do
		set insert_date = date_add(max_date, INTERVAL i YEAR);
 		-- YEAR_ID
 		set year_id = year(insert_date);
 		-- YEAR_DATE
 		set year_date = insert_date;
 		-- YEAR_DURATION
 		set year_duration = datediff(date_add(year_date, INTERVAL 1 YEAR) , year_date);
    --  PREV_YEAR
 		set prev_year_id =year(date_add(year_date, INTERVAL -1 YEAR));
 
		insert into DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_ANIO
      (ANIO_ULTIMO_REQUERIMIENTO_PREVIO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id	
			);  
		set i=(i+1);
	end while; -- while				  


-- ----------------------------------------------------------------------------------------------
--                                  DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-10-01';

while (i<num_years*4)
	do
    set insert_date = date_add(max_date, INTERVAL i*3 MONTH);
		-- TRIMESTRE_ID
	 	set quarter_id = concat(year(insert_date), quarter(insert_date));
    -- TRIMESTRE_FECHA
		set quarter_date = insert_date;
		-- TRIMESTRE_DESC
    set quarter_desc = concat(year(quarter_date),' ', quarter(quarter_date), 'ºTr');
		-- ANIO_ID (Quarter)
    set year_id = year(quarter_date);
		-- TRIMESTRE_DURACION
		set quarter_duration = datediff(date_add(quarter_date, INTERVAL 3 MONTH) , quarter_date);
    -- TRIMESTRE_ANT_ID
		set prev_quarter_id = concat(year(date_add(quarter_date, INTERVAL -3 MONTH)), quarter(date_add(quarter_date, INTERVAL -3 MONTH)));
  	-- TRIMESTRE_ULT_ANIO_ID
		set ly_quarter_id = concat(year(date_add(quarter_date, INTERVAL -1 YEAR)), quarter(quarter_date));   
    -- TRIMESTRE_DESC_EN
		set quarter_desc_en = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
    -- TRIMESTRE_DESC_DE
    set quarter_desc_de = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_FR
		set quarter_desc_fr = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		-- TRIMESTRE_DESC_IT
		set quarter_desc_it = concat(year(quarter_date),' ', quarter(quarter_date), 'Q');
		
    insert into DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_TRIMESTRE
       (TRIMESTRE_ULTIMO_REQUERIMIENTO_PREVIO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMO_REQUERIMIENTO_PREVIO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
		set i=(i+1);
	end while; -- while


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_MES
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<num_years*12)
	do
    set insert_date = date_add(max_date, INTERVAL i MONTH);
		-- MES_ID
    case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
    -- MES_FECHA
		set month_date = insert_date; 
		-- MES_DESC
    set lc_time_names = 'es_ES';
		set month_desc = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
   -- MES_ANIO_ID 
		set month_of_year_id = month(month_date);
    -- TRIMESTRE_ID
		set quarter_id = concat(year(month_date), quarter(month_date));
    -- ANIO_ID
		set year_id = year(month_date);
    -- MES_DURACION
		set month_duration = datediff(date_add(month_date, INTERVAL 1 MONTH) , month_date);
    -- MES_ANT_ID
		case when(month(date_add(month_date, INTERVAL -1 month)) < 10) then set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), '0', month(date_add(month_date, INTERVAL -1 month)));
         else set prev_month_id = concat(year(date_add(month_date, INTERVAL -1 month)), month(date_add(month_date, INTERVAL -1 month)));
    end case ;
    -- MES_ULT_TRIMESTRE_ID
   	case when(month(date_add(month_date, INTERVAL -3 month)) < 10) then set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), '0', month(date_add(month_date, INTERVAL -3 month)));
         else set lq_month_id = concat(year(date_add(month_date, INTERVAL -3 month)), month(date_add(month_date, INTERVAL -3 month)));
    end case ;
  	-- MES_ULT_ANIO_ID
    case when(month(month_date) < 10) then set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), '0', month(insert_date));
         else set ly_month_id = concat(year(date_add(month_date, INTERVAL -1 year)), month(insert_date));
    end case;  
    -- MES_DESC_EN
    set lc_time_names = 'en_GB';
		set month_desc_en = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_DE
    set lc_time_names = 'de_DE';
		set month_desc_de = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_FR
    set lc_time_names = 'fr_FR';
		set month_desc_fr = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));
		-- MES_DESC_IT	
    set lc_time_names = 'it_IT';
		set month_desc_it = concat(upper(left(date_format(month_date,'%M'),1)), substr(date_format(month_date,'%M'),2), ' ', year(month_date));

    insert into DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_MES
      (MES_ULTIMO_REQUERIMIENTO_PREVIO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMO_REQUERIMIENTO_PREVIO_ID,
			 TRIMESTRE_ULTIMO_REQUERIMIENTO_PREVIO_ID,
			 ANIO_ULTIMO_REQUERIMIENTO_PREVIO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT			 
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_DIA
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-31';

while (i<num_years*365)
	do
		set insert_date = date_add(max_date, INTERVAL i day);
		-- DIA_ID
		set day_date = insert_date;
		-- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- MES_ID
		case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
         else set month_id = concat(year(insert_date), month(insert_date));
    end case ;
		-- TRIMESTRE_ID
		set quarter_id = concat(year(day_date), quarter(day_date));
    -- ANIO_ID
		set year_id = year(day_date);
		-- DIA_ANT_ID
		set prev_day_date = date_add(day_date, INTERVAL -1 DAY);
		-- DIA_ULT_MES_ID
		set lm_day_date = date_add(day_date, INTERVAL -1 MONTH);
		-- DIA_ULT_TRIMESTRE_ID
		set lq_day_date = date_add(day_date, INTERVAL -3 MONTH);
		-- DIA_ULT_ANIO_ID
		set ly_day_date = date_add(day_date, INTERVAL -1 YEAR);
	
		insert into DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_DIA
      (DIA_ULTIMO_REQUERIMIENTO_PREVIO_ID,
       DIA_SEMANA_ULTIMO_REQUERIMIENTO_PREVIO_ID,
       MES_ULTIMO_REQUERIMIENTO_PREVIO_ID,
       TRIMESTRE_ULTIMO_REQUERIMIENTO_PREVIO_ID,
       ANIO_ULTIMO_REQUERIMIENTO_PREVIO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date, 
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
		set i=(i+1);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
set i=1;
set day_date = subdate(curdate(), INTERVAL weekday(curdate()) DAY);

while (i <= 7 )
	do
    -- DIA_SEMANA_ID
		set day_of_week_id = date_format(day_date,'%w');
		-- DIA_SEMANA_DESC
		set lc_time_names = 'es_ES'; 
		set day_of_week_desc = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_EN
		set lc_time_names = 'en_GB'; 
		set day_of_week_desc_en =  concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_DE
		set lc_time_names = 'de_DE';
		set day_of_week_desc_de = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_FR
		set lc_time_names = 'fr_FR';
		set day_of_week_desc_fr = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));
		-- DIA_SEMANA_DESC_IT
	  set lc_time_names = 'it_IT';
		set day_of_week_desc_it = concat(upper(left(date_format(day_date,'%W'),1)), substr(date_format(day_date,'%W'),2));

		insert into DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_DIA_SEMANA
      (DIA_SEMANA_ULTIMO_REQUERIMIENTO_PREVIO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id, 
			 day_of_week_desc,
			 day_of_week_desc_en, 
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
        set i=(i+1);
        set day_date = date_add(day_date, INTERVAL 1 DAY);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1969-12-01';

while (i<=12)
	do
		set day_date = date_add(max_date, INTERVAL i MONTH);		
    -- MES_ANIO_ID
		set month_of_year_id = date_format(day_date,'%m');
		-- MES_ANIO_DESC
		set lc_time_names = 'es_ES'; 
		set month_of_year_desc =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_EN
		set lc_time_names = 'en_GB'; 
		set month_of_year_desc_en = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_DE
		set lc_time_names = 'de_DE';
		set month_of_year_desc_de = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_FR
		set lc_time_names = 'fr_FR';
		set month_of_year_desc_fr =  concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
		-- MES_ANIO_DESC_IT
	  set lc_time_names = 'it_IT';
		set month_of_year_desc_it = concat(upper(left(date_format(day_date,'%M'),1)), substr(date_format(day_date,'%M'),2));
    
		insert into DIM_FECHA_ULTIMO_REQUERIMIENTO_PREVIO_MES_ANIO
      (MES_ANIO_ULTIMO_REQUERIMIENTO_PREVIO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id, 
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
 set lc_time_names = 'es_ES'; 
    
END MY_BLOCK_DIM_FEC_OTR

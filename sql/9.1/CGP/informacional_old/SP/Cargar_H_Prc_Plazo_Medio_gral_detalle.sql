-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_H_Prc_Plazo_Medio_gral_detalle` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_H_Prc_Plazo_Medio_gral_detalle`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_PCR_PLA_MED: BEGIN


	-- ===============================================================================================
	-- Autor: Enrique Jiménez Diaz, PFS Group; Joaquin Arnal Diaz, PFS Group
	-- Fecha creación: Marzo 2015
	-- Responsable última modificación: Joaquin Arnal Diaz, PFS Group
	-- Fecha última modificación: 02/03/2015
	-- Motivos del cambio: 
	-- Cliente: Recovery BI Central de Demandas 
	--
	-- Descripción: Procedimiento almancenado que crea la tabla de hechos para Procedimiento especifico.
	-- ===============================================================================================

	-- ===============================================================================================
	-- Declaración de variables (Inicio) 
	-- ===============================================================================================
	-- DEFINICIÓN VARIABLES COMPROBACIÓN DE TABLAS
	DECLARE HAY INT;
	DECLARE HAY_TABLA INT;
	-- DECLARE FECHA_CALC VARCHAR(10);

		
	declare max_dia_con_contratos date;
	declare max_dia_semana date;
	declare max_dia_mes date;
	declare max_dia_trimestre date;
	declare max_dia_anio date;
	declare max_dia_carga date;
	declare semana int;
	declare mes int;
	declare trimestre int;
	declare anio int;
	declare fecha date;
	declare fecha_rellenar date;

	declare l_last_row int default 0;
	declare c_fecha_rellenar cursor for select distinct(DIA_ID) FROM D_F_DIA where DIA_ID between date_start and date_end;
	declare c_fecha cursor for select distinct(DIA_ID) FROM D_F_DIA where DIA_ID between date_start and date_end; 
	declare c_semanas cursor for select distinct SEMANA_H from TMP_FECHA order by 1;
	declare c_meses cursor for select distinct MES_H from TMP_FECHA order by 1;
	declare c_trimestre cursor for select distinct TRIMESTRE_H from TMP_FECHA order by 1;
	declare c_anio cursor for select distinct ANIO_H from TMP_FECHA order by 1;
	declare continue HANDLER FOR NOT FOUND SET l_last_row = 1;

	-- DEFINICIÓN DE LOS HANDLER DE ERROR
	DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
	DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
	DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: NÃºmero de parÃ¡metros incorrecto'; 

	-- DEFINICIÓN DEL HANDLER GENÉRICO DE ERROR
	DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

	-- ===============================================================================================
	-- Declaración de variables (Fin) 
	-- ===============================================================================================

	-- ===============================================================================================
	-- Detalle proceso
	-- 
	-- truncate 1
	-- 1) TMP_PRC_JERARQUIA_PM: Creamos temporal independiente a partir de PRC_PROCEDIMIENTOS_JERARQUIA
	-- 
	-- truncate 2
	-- truncate 3
	-- 
	-- BUCLE POR DIAS
	-- 
	-- 2) Tabla temporal con todas las tareas : TMP_PRC_TAREA_PM_ALL 
	-- 3) Tabla temporal con todas las tareas de Interposición demanda - TMP_PRC_TAREA_PM_INT
	-- 
	-- FIN BUCLE POR DIAS 
	-- 
	-- truncate 5
	-- truncate 6
	-- 
	-- 4) Categorizamos el plazo medio de las tareas. Segun diccionario -> D_PRC_HITO_PLAZO_MED
	-- 
	-- truncate 5
	-- truncate 6
	-- 
	-- 5) Tabla previa (BYPASS) para hacer la tabla temporal con los datos a incluir en PLAZOS MEDIOS: TMP_PLAZO_MEDIO_BYPASS
	-- 6) Tabla temporal con los datos a incluir en PLAZOS MEDIOS: TMP_PLAZO_MEDIO
	-- 7) Calculamos la interposicion de la demanda.
	-- 8) Calculamos los días desde la interposicion de la demanda hasta la fecha de la ult tarea si existe interposiscion de la demanda
	-- 9) Paso a tabla de producción
	-- 
	-- ===============================================================================================

		
	-- ===============================================================================================
	-- 1) TMP_PRC_JERARQUIA_PM: Creamos temporal independiente a partir de PRC_PROCEDIMIENTOS_JERARQUIA
	-- ===============================================================================================

	-- TRUNCATE TABLE TIMER_ANALIZE_SP; -- Reseteamos la tabla de control de tiempos.

	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
	VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'TRUNCATE TABLE TMP_PRC_JERARQUIA_PM', CURDATE(), CURTIME(), NULL, NULL);
	
	TRUNCATE TABLE TMP_PRC_JERARQUIA_PM;
	
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) WHERE  `STEP_SP` = 'TRUNCATE TABLE TMP_PRC_JERARQUIA_PM' AND  `TIME_END_EXECUTE` IS NULL;	
	
	
	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
	VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'INSERT INTO TMP_PRC_JERARQUIA_PM', CURDATE(), CURTIME(), NULL, NULL);
	
	-- Excluimos desde el origen traernos los procedimientos de tipo Contratos Adjuntos Bloqueados
	INSERT INTO TMP_PRC_JERARQUIA_PM (
		DIA_ID,                               
		ITER, -- PROCEDIMIENTO PADRE
		FASE_ACTUAL, -- PROCEDIMIENTO ACTUAL
		NIVEL,
		CONTEXTO,
		CODIGO_FASE_ACTUAL,
		PRIORIDAD_FASE,
		CANCELADO_FASE,
		ASU_ID,
		ENTIDAD_CEDENTE_ID
	) 
	SELECT HH.* 
	FROM (  
		SELECT 
			FECHA_PROCEDIMIENTO,
			PJ_PADRE,
			PRC_ID,
			NIVEL,
			PATH_DERIVACION,
			PRC_TPO,
			COALESCE(PRIORIDAD, 0),
			CANCEL_PRC,
			ASU_ID,
			1 -- 'UGAS'
		FROM bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD ON PRC_TPO = DD_TPO_CODIGO
		 WHERE PRC_TPO != 'P22'
		UNION
		SELECT 
			FECHA_PROCEDIMIENTO,
			PJ_PADRE,
			PRC_ID,
			NIVEL,
			PATH_DERIVACION,
			PRC_TPO,
			COALESCE(PRIORIDAD, 0),
			CANCEL_PRC,
			ASU_ID,
			2 -- 'BBVA'
		FROM bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD ON PRC_TPO = DD_TPO_CODIGO
		 WHERE PRC_TPO != 'P22'
		UNION
		SELECT 
			FECHA_PROCEDIMIENTO,
			PJ_PADRE,
			PRC_ID,
			NIVEL,
			PATH_DERIVACION,
			PRC_TPO,
			COALESCE(PRIORIDAD, 0),
			CANCEL_PRC,
			ASU_ID,
			3 -- 'BANKIA'
		FROM bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD ON PRC_TPO = DD_TPO_CODIGO
		 WHERE PRC_TPO != 'P22'
		UNION
		SELECT 
			FECHA_PROCEDIMIENTO,
			PJ_PADRE,
			PRC_ID,
			NIVEL,
			PATH_DERIVACION,
			PRC_TPO,
			COALESCE(PRIORIDAD, 0),
			CANCEL_PRC,
			ASU_ID,
			4 -- 'CAJAMAR'
		FROM bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD ON PRC_TPO = DD_TPO_CODIGO  
		 WHERE PRC_TPO != 'P22'      
		) HH
	-- WHERE HH.FECHA_PROCEDIMIENTO BETWEEN DATE_START AND DATE_END
	;

	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) WHERE  `STEP_SP` = 'INSERT INTO TMP_PRC_JERARQUIA_PM' AND  `TIME_END_EXECUTE` IS NULL;


	TRUNCATE TABLE TMP_PRC_TAREA_PM_ALL;
	TRUNCATE TABLE TMP_PRC_TAREA_PM_INT;

	-- Recorrer por las distintas fechas indicas en el rango.
	SET L_LAST_ROW = 0; 

	OPEN C_FECHA;
	READ_LOOP: LOOP
	FETCH C_FECHA INTO FECHA;        
		IF (L_LAST_ROW=1) THEN LEAVE READ_LOOP; 
		END IF;    

		-- ===============================================================================================
		-- 2) Tabla temporal con todas las tareas : TMP_PRC_TAREA_PM_ALL 
		-- ===============================================================================================
		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'INSERT INTO TMP_PRC_TAREA_PM_ALL', CURDATE(), CURTIME(), NULL, NULL);
		
		INSERT INTO TMP_PRC_TAREA_PM_ALL (FECHA, ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, ENTIDAD_CEDENTE_ID)
		SELECT 
			FECHA,
			TPJ.ITER, 
			TPJ.FASE_ACTUAL, 
			TAR.TAR_ID, 
			TAR.TAR_FECHA_INI, 
			COALESCE(TAR.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
			TAR.TAR_TAREA, 
			TPJ.ENTIDAD_CEDENTE_ID 
		FROM TMP_PRC_JERARQUIA_PM TPJ
			JOIN bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
				AND TPJ.ENTIDAD_CEDENTE_ID = 1		
		WHERE TPJ.DIA_ID = FECHA  AND DATE(TAR.TAR_FECHA_INI) <= FECHA
		UNION 
		SELECT 
			FECHA,
			TPJ2.ITER, 
			TPJ2.FASE_ACTUAL, 
			TAR2.TAR_ID, 
			TAR2.TAR_FECHA_INI, 
			COALESCE(TAR2.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
			TAR2.TAR_TAREA, 
			TPJ2.ENTIDAD_CEDENTE_ID 
		FROM TMP_PRC_JERARQUIA_PM TPJ2
			JOIN bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES TAR2 ON TPJ2.FASE_ACTUAL = TAR2.PRC_ID 
				AND TPJ2.ENTIDAD_CEDENTE_ID = 2
		WHERE TPJ2.DIA_ID = FECHA  AND DATE(TAR2.TAR_FECHA_INI) <= FECHA
		UNION 
		SELECT 
			FECHA,
			TPJ3.ITER, 
			TPJ3.FASE_ACTUAL, 
			TAR3.TAR_ID, 
			TAR3.TAR_FECHA_INI, 
			COALESCE(TAR3.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
			TAR3.TAR_TAREA, 
			TPJ3.ENTIDAD_CEDENTE_ID 
		FROM TMP_PRC_JERARQUIA_PM TPJ3
			JOIN bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES TAR3 ON TPJ3.FASE_ACTUAL = TAR3.PRC_ID 
				AND TPJ3.ENTIDAD_CEDENTE_ID = 3
		WHERE TPJ3.DIA_ID = FECHA  AND DATE(TAR3.TAR_FECHA_INI) <= FECHA
		UNION 
		SELECT 
			FECHA,
			TPJ4.ITER, 
			TPJ4.FASE_ACTUAL, 
			TAR4.TAR_ID, 
			TAR4.TAR_FECHA_INI, 
			COALESCE(TAR4.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
			TAR4.TAR_TAREA, 
			TPJ4.ENTIDAD_CEDENTE_ID 
		FROM TMP_PRC_JERARQUIA_PM TPJ4
			JOIN bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES TAR4 ON TPJ4.FASE_ACTUAL = TAR4.PRC_ID 
				AND TPJ4.ENTIDAD_CEDENTE_ID = 4
		WHERE TPJ4.DIA_ID = FECHA  AND DATE(TAR4.TAR_FECHA_INI) <= FECHA    
		;

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'INSERT INTO TMP_PRC_TAREA_PM_ALL' AND  `TIME_END_EXECUTE` IS NULL;
		
		-- ===============================================================================================
		-- 3) Tabla temporal con todas las tareas de Interposición demanda: TMP_PRC_TAREA_PM_INT
		-- ===============================================================================================
		
		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'INSERT INTO TMP_PRC_TAREA_PM_INT', CURDATE(), CURTIME(), NULL, NULL);
		
		insert into TMP_PRC_TAREA_PM_INT 
			(
			FECHA, 
			ITER, 
			FASE, 
			TAREA, 
			FECHA_INI, 
			FECHA_FIN, 
			DESCRIPCION_TAREA, 
			TAP_ID, 
			TEX_ID, 
			DESCRIPCION_FORMULARIO, 
			FECHA_FORMULARIO, 
			ENTIDAD_CEDENTE_ID
			) 
				select  FECHA, 
						tpj.ITER, 
						tpj.FASE_ACTUAL, 
						tar.TAR_ID, 
						tar.TAR_FECHA_INI, 
						coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
						tar.TAR_TAREA,
						TAP_ID, 
						tex.TEX_ID, 
						TEV_NOMBRE, 
						date(TEV_VALOR), 
						1 -- 'UGAS'
				from TMP_PRC_JERARQUIA_PM tpj
					join bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					join bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				where DIA_ID =  FECHA and date(tar.TAR_FECHA_INI) <= FECHA and
					tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
					and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)
				UNION 
				select  
						FECHA, 
						tpj.ITER, 
						tpj.FASE_ACTUAL, 
						tar.TAR_ID, 
						tar.TAR_FECHA_INI, 
						coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
						tar.TAR_TAREA,
						TAP_ID,
						tex.TEX_ID, 
						TEV_NOMBRE, 
						date(TEV_VALOR), 
						2 -- 'BBVA'
				from TMP_PRC_JERARQUIA_PM tpj
					join bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					join bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				where DIA_ID =  FECHA and date(tar.TAR_FECHA_INI) <= FECHA and
					tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
					and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)	   
				UNION 
				select  
						FECHA, 
						tpj.ITER, 
						tpj.FASE_ACTUAL, 
						tar.TAR_ID, 
						tar.TAR_FECHA_INI, 
						coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
						tar.TAR_TAREA,
						TAP_ID, 
						tex.TEX_ID, 
						TEV_NOMBRE, 
						date(TEV_VALOR), 
						3 -- 'BANKIA'
				from TMP_PRC_JERARQUIA_PM tpj
					join bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				where DIA_ID =  FECHA and date(tar.TAR_FECHA_INI) <= FECHA and
					tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
					and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)
				UNION
				select  
						FECHA, 
						tpj.ITER, 
						tpj.FASE_ACTUAL, 
						tar.TAR_ID, 
						tar.TAR_FECHA_INI, 
						coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
						tar.TAR_TAREA,
						TAP_ID, 
						tex.TEX_ID, 
						TEV_NOMBRE, 
						date(TEV_VALOR), 
						4 -- 'CAJAMAR'
				from TMP_PRC_JERARQUIA_PM tpj
					join bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					join bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				where DIA_ID =  FECHA and date(tar.TAR_FECHA_INI) <= FECHA and
					tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
					and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)	    	    
		;

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'INSERT INTO TMP_PRC_TAREA_PM_INT' AND  `TIME_END_EXECUTE` IS NULL;

	END LOOP;
	CLOSE C_FECHA;

	-- ===============================================================================================
	-- 3B) Se dan casos donde no se informa de la fecha de Interposición de la demanda, a consecuencia
	--	   de que son asuntos migrados, y cargados en tareas avanzadas. Usaremos la Fecha de Conforma-
	--	   ción del asunto como fecha base.
	-- ===============================================================================================
	/* => Comentamos la Conformación del Asunto.
	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'UPDATE TMP_PRC_TAREA_PM_ALL => FECHA_CONFOR_ASUNTO', CURDATE(), CURTIME(), NULL, NULL);

	-- ABANCA
	UPDATE TMP_PRC_TAREA_PM_ALL TPT
		SET TPT.FECHA_CONFOR_ASUNTO = 
		( SELECT MAX(ASU.ASU_FECHA_EST_ID)
			FROM TMP_PRC_JERARQUIA_PM PPJ 
				INNER JOIN bi_cdd_bng_datastage.ASU_ASUNTOS ASU ON PPJ.ASU_ID = ASU.ASU_ID
			WHERE TPT.ITER = PPJ.ITER and PPJ.ENTIDAD_CEDENTE_ID = TPT.ENTIDAD_CEDENTE_ID
		)
	WHERE TPT.ENTIDAD_CEDENTE_ID = 1
	;
	
	-- BBVA
	UPDATE TMP_PRC_TAREA_PM_ALL TPT
		SET TPT.FECHA_CONFOR_ASUNTO = 
		( SELECT MAX(ASU.ASU_FECHA_EST_ID)
			FROM TMP_PRC_JERARQUIA_PM PPJ 
				INNER JOIN bi_cdd_bbva_datastage.ASU_ASUNTOS ASU ON PPJ.ASU_ID = ASU.ASU_ID
			WHERE TPT.ITER = PPJ.ITER and PPJ.ENTIDAD_CEDENTE_ID = TPT.ENTIDAD_CEDENTE_ID
		)
	WHERE TPT.ENTIDAD_CEDENTE_ID = 2
	;
	
	-- BANKIA
	UPDATE TMP_PRC_TAREA_PM_ALL TPT
		SET TPT.FECHA_CONFOR_ASUNTO = 
		( SELECT MAX(ASU.ASU_FECHA_EST_ID)
			FROM TMP_PRC_JERARQUIA_PM PPJ 
				INNER JOIN bi_cdd_bankia_datastage.ASU_ASUNTOS ASU ON PPJ.ASU_ID = ASU.ASU_ID
			WHERE TPT.ITER = PPJ.ITER and PPJ.ENTIDAD_CEDENTE_ID = TPT.ENTIDAD_CEDENTE_ID
		)
	WHERE TPT.ENTIDAD_CEDENTE_ID = 3
	;	
	
	-- CAJAMAR
	UPDATE TMP_PRC_TAREA_PM_ALL TPT
		SET TPT.FECHA_CONFOR_ASUNTO = 
		( SELECT MAX(ASU.ASU_FECHA_EST_ID)
			FROM TMP_PRC_JERARQUIA_PM PPJ 
				INNER JOIN bi_cdd_cajamar_datastage.ASU_ASUNTOS ASU ON PPJ.ASU_ID = ASU.ASU_ID
			WHERE TPT.ITER = PPJ.ITER and PPJ.ENTIDAD_CEDENTE_ID = TPT.ENTIDAD_CEDENTE_ID
		)
	WHERE TPT.ENTIDAD_CEDENTE_ID = 4
	;    
	
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'UPDATE TMP_PRC_TAREA_PM_ALL => FECHA_CONFOR_ASUNTO' AND  `TIME_END_EXECUTE` IS NULL;
	*/
    
	-- ===============================================================================================
	-- 4) Categorizamos el plazo medio de las tareas. Segun diccionario -> D_PRC_HITO_PLAZO_MED
	-- ===============================================================================================
	
	-- ABANCA.
	-- SET SQL_SAFE_UPDATES=0;	
	
	/* EJD:> Descartamos del análisis la Interposición dado que no tenemos tarea estable válida de calculo inicial.
		-- *>  1, 'interposición de la demanda'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 1
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_DemandaCertificacionCargas')
			)
		;	
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = 'fecha'
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 2
		;			
		*/		
		
		
		-- *>  2, 'auto depachando ejecución'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'P01_AutoDespachandoEjecucion -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 2
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
			)
		;		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = 'fecha'
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 2
		;
					
		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'P01_AutoDespachandoEjecucion -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;
		

		-- *>  3, 'notificación'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'P01_ConfirmarNotificacionReqPago -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 3
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
			)
		;			

		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = 'fecha'
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 3
		;	

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 3
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 24 -- T. DE NOTIFICACIÓN
									)
					   AND TAP.TAP_CODIGO IN ('P06_ResultadoEdicto','P06_ResultadoDomicilio' )
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha', 'fechaEdicto')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 24 -- T. DE NOTIFICACIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P06_ResultadoEdicto','P06_ResultadoDomicilio' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 3
		;	

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'P01_ConfirmarNotificacionReqPago -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;


		-- *>  4, 'oposición del deudor'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'oposición del deudor -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);
			
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 4
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaResolucion')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 4
		;			
		
		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'oposición del deudor -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;
		
		
		/*
		-- *>  5, 'pendiente de solicitar subasta'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 5
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;		

		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 5
		;			
		*/		
		
		-- *>  6, 'solicitud subasta'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'solicitud subasta -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

			
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 6
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;		

		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 6
		;			

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'solicitud subasta -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;
				
		
		-- *>  7, 'anuncio subasta'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'anuncio subasta -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);
			
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 7
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new1')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaAnuncio')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new1' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 7
		;			
			
		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'anuncio subasta -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;		
		
		
		
		-- *>  8, 'celebración subasta'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'celebración subasta -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);
			
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 8
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					 AND TAP.TAP_CODIGO IN ('P11_CelebracionSubasta', 'P11_CelebracionSubasta_new1')
			)
		;		
		
		update TMP_PRC_TAREA_PM_ALL pd 
		 	SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID			
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSubasta')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new1', 'P11_AnuncioSubasta' )
		 			  -- and pd.TAREA = tar.tar_id Se comenta, al tratarse de tareas "pasadas" que recuperamos para informar en las avanzadas.
		 			  and pd.ITER = PJ.PJ_PADRE 
		 		)
		 WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
		 	AND pd.CATEGORIA_PLAZO_MEDIO = 8
		;
		
			
		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'celebración subasta -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;		
		
						
						
		-- *>  9, 'cesión de remate'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'cesión de remate -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);


		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 9
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 941 -- T. de cesiÃ³n de remate
									)
					  AND TAP.TAP_CODIGO IN ('P65_RealizacionCesionRemate')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 941 -- T. de cesiÃ³n de remate
									)
					  AND TAP.TAP_CODIGO IN ('P65_RealizacionCesionRemate' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 9
		;		
		

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'cesión de remate -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;	
		
		
		-- *>  10, 'solicitud adjudicación'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'solicitud adjudicación -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 10
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. de adjudicaciÃ³n
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
			)
		;		
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSolicitud')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. de adjudicación
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 10
		;	

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'solicitud adjudicación -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;					

				
		-- *>  11, 'adjudicación'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'adjudicación -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 11
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. de adjudicación
									)
					  AND TAP.TAP_CODIGO IN ('P05_RegistrarAutoAdjudicacion')
			)
		;		

		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaRegistro')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. de adjudicación
									)
					  AND TAP.TAP_CODIGO IN ('P05_RegistrarAutoAdjudicacion' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 11
		;			

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'adjudicación -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;					
						
				
		-- *>  12, 'solicitud de posesión'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'solicitud de posesión -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);


		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 12
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 --  T. de posesiÃ³n
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion')
			)
		;	
		

		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')					
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 --  T. de posesiÃ³n
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 12
		;			
		

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'solicitud de posesión -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;	
		
				
		-- *>  13, 'posesiÃ³n'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'posesión -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 13
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 --  T. de posesiÃ³n
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarPosesion', 'P54_registrarResolucion')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 --  T. de posesiÃ³n
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarPosesion', 'P54_registrarResolucion' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 13
		;	
			

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'posesión -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;	
		
				
		-- *>  14, 'lanzamiento'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'lanzamiento -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 14
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 --  T. de posesiÃ³n
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaLanzamiento')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 --  T. de posesiÃ³n
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 14
		;		
		
		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'lanzamiento -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;	
		

		-- *>  15, 'tasación de costas'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'tasación de costas -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 15
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 25 --  T. de costas
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 25 --  T. de costas
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 15
		;			
			

		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'tasación de costas -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;	
		
		
		-- *>  16, 'liquidaciÃ³n de intereses'

		INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
			VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'liquidación de intereses -- ABANCA', CURDATE(), CURTIME(), NULL, NULL);
		

		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 16
		where pm_all.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 28 -- T. de Intereses
									)
					  AND TAP.TAP_CODIGO IN ('P10_RegistrarResolucion')
			)
		;		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 28 -- T. de Intereses
									)
					  AND TAP.TAP_CODIGO IN ('P10_RegistrarResolucion' )
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 1 -- ABANCA
			AND pd.CATEGORIA_PLAZO_MEDIO = 16
		;					


		UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
		WHERE  `STEP_SP` = 'liquidación de intereses -- ABANCA' AND  `TIME_END_EXECUTE` IS NULL;	
		

		-- BANKIA.
/* EJD:> Descartamos del análisis la Interposición dado que no tenemos tarea estable válida de calculo inicial.
		-- *>  1, 'interposiciÃ³n de la demanda'		
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 33
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_DemandaCertificacionCargas')
			)
		;	
*/
		-- *>  2, 'auto depachando ejecuciÃ³n'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 34
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = 'fecha'
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 34
		;			

		-- *>  3, 'notificaciÃ³n'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 35
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
			)
		;	
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE = 'fecha'
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 35
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha', 'fechaEdicto')
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 24 -- T. DE NOTIFICACIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P06_ResultadoDomicilio', 'P06_ResultadoEdicto')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 35
		;		
				
		
		-- *>  4, 'oposiciÃ³n del deudor'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 36
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaResolucion')
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 36
		;			

/*
		-- *>  5, 'pendiente de solicitar subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 37
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;
		
*/		
		
		-- *>  	6, 'solicitud subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 38
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 38
		;		


		-- *>  	7, 'anuncio subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 39
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new2', 'P11_AnuncioSubasta_new1')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaAnuncio')
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new2', 'P11_AnuncioSubasta_new1')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 39
		;		
		
				
	
		-- *>  	8, 'celebraciÃ³n subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 40
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_CelebracionSubasta_new1', 'P11_CelebracionSubasta')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
		 	SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID			
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSubasta')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new1', 'P11_AnuncioSubasta' )
		 			  -- and pd.TAREA = tar.tar_id Se comenta, al tratarse de tareas "pasadas" que recuperamos para informar en las avanzadas.
		 			  and pd.ITER = PJ.PJ_PADRE 
		 		)
		 WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
		 	AND pd.CATEGORIA_PLAZO_MEDIO = 40
		;

		-- *>  	9, 'cesiÃ³n de remate' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 41
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_VerificarCesionRemate')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')					
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_VerificarCesionRemate')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 41
		;		
		
		
		-- *>  10, 'solicitud adjudicaciÃ³n' (T. DE ADJUDICACIÃ“N)			
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 42
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSolicitud')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 42
		;			
		
		-- *>  11, 'adjudicaciÃ³n' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 43
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. de adjudicación
									)
					  AND TAP.TAP_CODIGO IN ('P05_RegistrarAutoAdjudicacion')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaRegistro')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_RegistrarAutoAdjudicacion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 43
		;			
		

		-- *>  12, 'solicitud de posesiÃ³n' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 44
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion')
			)
		;

		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 44
		;	
		

		-- *>  13, 'posesiÃ³n' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 45
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarPosesion', 'P54_registrarResolucion')
			)
		;
		

		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarPosesion', 'P54_registrarResolucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 45
		;	
				

		-- *>  14, 'lanzamiento' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 46
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaLanzamiento')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 46
		;	
						
			
		-- *>  15, 'tasaciÃ³n de costas' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 47
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 25 -- T. DE COSTAS
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme')
			)
		;			

		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 25 -- T. DE COSTAS
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 47
		;	
			
		-- *>  	16, 'liquidaciÃ³n de intereses' (T. DE INTERESES)	
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 48
		where pm_all.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 28 -- T. DE INTERESES
									)
					  AND TAP.TAP_CODIGO IN ('P10_RegistrarResolucion')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 28 -- T. DE INTERESES
									)
					  AND TAP.TAP_CODIGO IN ('P10_RegistrarResolucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 3 -- BANKIA
			AND pd.CATEGORIA_PLAZO_MEDIO = 48
		;			

	-- BBVA.
/* EJD:> Descartamos del análisis la Interposición dado que no tenemos tarea estable válida de calculo inicial.
		-- *>  1, 'interposiciÃ³n de la demanda'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 17
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_DemandaCertificacionCargas')
			)
		;	

*/		
		
		-- *> 2, 'auto depachando ejecuciÃ³n'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 18
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
			)
		;	
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 18
		;		
		
		-- *> 3, 'notificaciÃ³n'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 19
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 19
		;	
		
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 19
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 24 -- T. DE NOTIFICACIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P06_ResultadoDomicilio', 'P06_ResultadoEdicto')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha', 'fechaEdicto')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 24 -- T. DE NOTIFICACIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P06_ResultadoDomicilio', 'P06_ResultadoEdicto')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 19
		;						
		
		-- *> 4, 'oposiciÃ³n del deudor'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 20
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaResolucion')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 20
		;			
		
		
		/*
		-- *> 5, 'pendiente de solicitar subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 21
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;
		*/
		
		-- *> 6, 'solicitud subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 22
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 22
		;		
		
		
		-- *> 7, 'anuncio subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 23
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new2', 'P11_AnuncioSubasta_new1')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaAnuncio')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new2', 'P11_AnuncioSubasta_new1')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 23
		;				
		
		-- *> 8, 'celebraciÃ³n subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 24
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_CelebracionSubasta_new1', 'P11_CelebracionSubasta')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
		 	SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID			
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSubasta')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new1', 'P11_AnuncioSubasta' )
		 			  -- and pd.TAREA = tar.tar_id Se comenta, al tratarse de tareas "pasadas" que recuperamos para informar en las avanzadas.
		 			  and pd.ITER = PJ.PJ_PADRE 
		 		)
		 WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
		 	AND pd.CATEGORIA_PLAZO_MEDIO = 24
		;		
		
		-- *> 9, 'cesiÃ³n de remate' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 25
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_VerificarCesionRemate')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_VerificarCesionRemate')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 25
		;			
		
		-- *> 10, 'solicitud adjudicaciÃ³n' (T. DE ADJUDICACIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 26
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSolicitud')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 26
		;			
		
		
		-- *> 11, 'adjudicaciÃ³n' (T. DE ADJUDICACIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 27
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. de adjudicación
									)
					  AND TAP.TAP_CODIGO IN ('P05_RegistrarAutoAdjudicacion')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaRegistro')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_RegistrarAutoAdjudicacion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 27
		;			
		
		-- *> 12, 'solicitud de posesión' (T. DE POSESIÓN)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 28
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion')
			)
		;		
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID					
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  23 -- T. DE ADJUDICACIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 28
		;		
		
		-- *> 13, 'posesión' (T. DE POSESIÓN)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 29
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarResolucion', 'P54_registrarPosesion')
			)
		;
		
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarResolucion', 'P54_registrarPosesion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 29
		;	
				
				
		-- *> 14, 'lanzamiento' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 30
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaLanzamiento')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 30
		;			
		
		
		-- *> 15, 'tasación de costas' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 31
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 25 -- T. DE COSTAS
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  25 -- T. DE COSTAS
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 31
		;			
		
		
		-- *> 16, 'liquidación de intereses' (T. DE INTERESES)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 32
		where pm_all.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 28 -- T. DE INTERESES
									)
					  AND TAP.TAP_CODIGO IN ('P10_RegistrarResolucion')
			)
		;	
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 28 -- T. DE INTERESES
									)
					  AND TAP.TAP_CODIGO IN ('P10_RegistrarResolucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 2 -- BBVA
			AND pd.CATEGORIA_PLAZO_MEDIO = 32
		;		
		
	-- CAJAMAR.		
/* EJD:> Descartamos del análisis la Interposición dado que no tenemos tarea estable válida de calculo inicial.
		-- *> 1, 'interposiciÃ³n de la demanda'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 49
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_DemandaCertificacionCargas')
			)
		;	
*/
		
		-- *>  2, 'auto depachando ejecuciÃ³n'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 50
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
			)
		;	
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_AutoDespachandoEjecucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 50
		;			
		
		-- *>  3, 'notificaciÃ³n'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 51
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ConfirmarNotificacionReqPago')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 51
		;	
		
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 51
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 24 -- T. DE NOTIFICACIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P06_ResultadoDomicilio', 'P06_ResultadoEdicto')
			)
		;	
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha', 'fechaEdicto')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 24 -- T. DE NOTIFICACIÓN
									)
					  AND TAP.TAP_CODIGO IN ('P06_ResultadoDomicilio', 'P06_ResultadoEdicto')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 51
		;					
		
		-- *>  4, 'oposiciÃ³n del deudor'
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 52
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaResolucion')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 1 -- P. HIPOTECARIO
									)
					  AND TAP.TAP_CODIGO IN ('P01_ResolucionFirme')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 52
		;			
		
		/*
		-- *>  5, 'pendiente de solicitar subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 53
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;
		*/
		
		-- *>  6, 'solicitud subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 54
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					join bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_SolicitudSubasta')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 54
		;				
		
		
		-- *>  7, 'anuncio subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 55
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new2', 'P11_AnuncioSubasta_new1')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaAnuncio')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new2', 'P11_AnuncioSubasta_new1')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 55
		;				
		
		-- *>  8, 'celebración subasta' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 56
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_CelebracionSubasta_new1', 'P11_CelebracionSubasta')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
		 	SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID			
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSubasta')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. de Subasta
									)
					  AND TAP.TAP_CODIGO IN ('P11_AnuncioSubasta_new1', 'P11_AnuncioSubasta' )
		 			  -- and pd.TAREA = tar.tar_id Se comenta, al tratarse de tareas "pasadas" que recuperamos para informar en las avanzadas.
		 			  and pd.ITER = PJ.PJ_PADRE 
		 		)
		 WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
		 	AND pd.CATEGORIA_PLAZO_MEDIO = 56
		;
				
		
		-- *>  9, 'cesión de remate' (T. DE SUBASTA)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 57
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_VerificarCesionRemate')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 29 -- T. DE SUBASTA
									)
					  AND TAP.TAP_CODIGO IN ('P11_VerificarCesionRemate')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 57
		;			
		
		-- *>  10, 'solicitud adjudicaciÃ³n' (T. DE ADJUDICACIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 58
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaSolicitud')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  23 -- T. DE ADJUDICACIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 58
		;			

		-- *>  11, 'adjudicaciÃ³n' (T. DE ADJUDICACIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 59
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 23 -- T. de adjudicación
									)
					  AND TAP.TAP_CODIGO IN ('P05_RegistrarAutoAdjudicacion')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaRegistro')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  23 -- T. de adjudicación
									)
					  AND TAP.TAP_CODIGO IN ('P05_SolicitudTramiteAdjudicacion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 59
		;			

		-- *>  12, 'solicitud de posesiÃ³n' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 60
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  173 -- T. de posesión
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 60
		;		

		-- *>  13, 'posesiÃ³n' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 61
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarPosesion', 'P54_registrarResolucion')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  173 -- T. de posesión
									)
					  AND TAP.TAP_CODIGO IN ('P54_regSolicitudPosesion', 'P54_registrarResolucion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 61
		;				

		-- *>  14, 'lanzamiento' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 62
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 173 -- T. DE POSESIÃ“N
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo')
			)
		;

		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fechaLanzamiento')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  173 -- T. de posesión
									)
					  AND TAP.TAP_CODIGO IN ('P54_registrarLanzamientoEfectivo')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 62
		;				


		-- *>  15, 'tasaciÃ³n de costas' (T. DE POSESIÃ“N)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 63
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 25 -- T. DE COSTAS
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme')
			)
		;
		
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  25 -- T. DE COSTAS
									)
					  AND TAP.TAP_CODIGO IN ('P07_AutoFirme', 'P07_ResolucionFirme')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 63
		;		

		-- *>  16, 'liquidaciÃ³n de intereses' (T. DE INTERESES)
		update TMP_PRC_TAREA_PM_ALL pm_all 
			SET pm_all.CATEGORIA_PLAZO_MEDIO = 64
		where pm_all.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			and pm_all.TAREA IN (
				SELECT DISTINCT tar.TAR_ID
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID = 28 -- T. DE INTERESES
									)
					  AND TAP.TAP_CODIGO IN ('P10_SolicitarLiquidacion')
			)
		;
		
		update TMP_PRC_TAREA_PM_ALL pd 
			SET pd.FECHA_VALOR_TAREA =  ( 
				SELECT max(tev.tev_valor)
				FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar 
					join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
					JOIN bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO TAP ON tex.TAP_ID = TAP.TAP_ID
					JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA PJ ON PJ.PRC_ID = tar.PRC_ID
					LEFT OUTER JOIN bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE IN ('fecha')
				WHERE TAP.TAP_ID IN (    
									SELECT TAP_ID
									FROM bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO
									WHERE DD_TPO_ID =  28 -- T. DE INTERESES
									)
					  AND TAP.TAP_CODIGO IN ('P10_SolicitarLiquidacion')
					  and pd.TAREA = tar.tar_id
					  and pd.ITER = PJ.PJ_PADRE 
				)
		WHERE pd.ENTIDAD_CEDENTE_ID = 4 -- CAJAMAR
			AND pd.CATEGORIA_PLAZO_MEDIO = 64
		;			
		
	-- ===============================================================================================
	-- 5) Tabla previa (BYPASS) para hacer la tabla temporal con los datos a incluir en PLAZOS MEDIOS: 
	--		"TMP_PLAZO_MEDIO_BYPASS"
	--	  Aprobechamos también para excluir las tareas VIGENTES para el analisis.
	-- ===============================================================================================
	
	truncate table TMP_PLAZO_MEDIO_BYPASS;


	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'insert into TMP_PLAZO_MEDIO_BYPASS', CURDATE(), CURTIME(), NULL, NULL);



       insert into TMP_PLAZO_MEDIO_BYPASS
		(FECHA, PROCEDIMIENTO_ID,CATEGORIA_PLAZO_MEDIO,ENTIDAD_CEDENTE_ID,TAREA_CALC) 
		SELECT 
			pm_all.FECHA,
			pm_all.ITER, -- Id_procedmiento
			pm_all.CATEGORIA_PLAZO_MEDIO, -- Categoria
			pm_all.ENTIDAD_CEDENTE_ID, -- Entidad
			pm_all.TAREA
		FROM TMP_PRC_TAREA_PM_ALL pm_all
		where pm_all.FECHA_FIN > '0000-00-00' -- Excluimos las tareas "vigentes"
		;


truncate TMP_PLAZO_MEDIO_BYPASS_AUXX;

 insert into TMP_PLAZO_MEDIO_BYPASS_AUXX
(FECHA, PROCEDIMIENTO_ID,CATEGORIA_PLAZO_MEDIO,ENTIDAD_CEDENTE_ID,TAREA_CALC) 

SELECT 
			pm_all.FECHA,
			pm_all.ITER, -- Id_procedmiento
			pm_all.CATEGORIA_PLAZO_MEDIO, -- Categoria
			pm_all.ENTIDAD_CEDENTE_ID, -- Entidad
			max(pm_all.TAREA) AS HITO
		FROM TMP_PRC_TAREA_PM_ALL pm_all
		where pm_all.CATEGORIA_PLAZO_MEDIO is not null
			AND pm_all.FECHA_FIN > '0000-00-00' -- Excluimos las tareas "vigentes"
		group by pm_all.FECHA, pm_all.ITER, pm_all.CATEGORIA_PLAZO_MEDIO, pm_all.ENTIDAD_CEDENTE_ID;




update TMP_PLAZO_MEDIO_BYPASS b, TMP_PLAZO_MEDIO_BYPASS_AUXX aux
set b.MARCA_HITO_ID=1
where b.TAREA_CALC=aux.TAREA_CALC
and b.ENTIDAD_CEDENTE_ID=aux.ENTIDAD_CEDENTE_ID
and b.CATEGORIA_PLAZO_MEDIO=aux.CATEGORIA_PLAZO_MEDIO
and b.PROCEDIMIENTO_ID=aux.PROCEDIMIENTO_ID;
		
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'insert into TMP_PLAZO_MEDIO_BYPASS' AND  `TIME_END_EXECUTE` IS NULL;	

		
	-- ===============================================================================================
	-- 6) Tabla temporal con los datos a incluir en PLAZOS MEDIOS: TMP_PLAZO_MEDIO
	-- ===============================================================================================
		
	truncate table TMP_PLAZO_MEDIO;
	
	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'insert into TMP_PLAZO_MEDIO', CURDATE(), CURTIME(), NULL, NULL);



	insert into TMP_PLAZO_MEDIO
	(
		FECHA_CARGA_DATOS, DIA_ID, PROCEDIMIENTO_ID,  
		CATEGORIA_PLAZO_MEDIO, NUM_DIAS_INTERPOS, ENTIDAD_CEDENTE_ID, 
		COLUM_DOMMY, FECHA_INTERPOS_DEMANDA, FECHA_FIN_TAREA,
		TAR_CAM_PM, ASUNTO_ID, ESTADO_FASE_ACTUAL_ID, 
		FASE_ACTUAL_DETALLE_ID, NUM_DIAS_INTERPOS2,MARCA_HITO_ID,TIPO_PROCEDIMIENTO_DET_ID
	) 
		SELECT 
			bypass.FECHA, -- Dia del bucle para FECHA_CARGA_DATOS 
			bypass.FECHA, -- Dia del bucle para DIA_ID
			bypass.PROCEDIMIENTO_ID, 
			bypass.CATEGORIA_PLAZO_MEDIO, 
			pm_all.NUM_DIAS_INTERPOS,
			bypass.ENTIDAD_CEDENTE_ID,
			1, -- COLUM_DOMMY
			pm_all.FECHA_INTERPOSICION_DEMANDA,
			pm_all.FECHA_FIN,
			bypass.TAREA_CALC,
			hprc.ASUNTO_ID, -- asunto_id
			hprc.ESTADO_FASE_ACTUAL_ID, -- ESTADO_FASE_ACTUAL_ID
			hprc.FASE_ACTUAL_DETALLE_ID, -- FASE_ACTUAL_DETALLE_ID
			pm_all.FECHA_INTERPOSICION_DEMANDA, -- segundo calculo de num de dias?	
			COALESCE(bypass.MARCA_HITO_ID, 0),
			hprc.TIPO_PROCEDIMIENTO_DET_ID
		FROM TMP_PLAZO_MEDIO_BYPASS bypass
			 join TMP_PRC_TAREA_PM_ALL pm_all 
			 	   on pm_all.ITER = bypass.PROCEDIMIENTO_ID
		           and pm_all.CATEGORIA_PLAZO_MEDIO = bypass.CATEGORIA_PLAZO_MEDIO
		           and pm_all.ENTIDAD_CEDENTE_ID = bypass.ENTIDAD_CEDENTE_ID
		           and pm_all.TAREA = bypass.TAREA_CALC
		     join H_PRC hprc -- ESTADO_FASE_ACTUAL_ID
		     	on hprc.ENTIDAD_CEDENTE_ID = bypass.ENTIDAD_CEDENTE_ID
		     	and hprc.PROCEDIMIENTO_ID = bypass.PROCEDIMIENTO_ID
		     	and hprc.DIA_ID = bypass.FECHA
		where pm_all.CATEGORIA_PLAZO_MEDIO is not null
		;

insert into TMP_PLAZO_MEDIO
	(
		FECHA_CARGA_DATOS, DIA_ID, PROCEDIMIENTO_ID,  
		CATEGORIA_PLAZO_MEDIO, NUM_DIAS_INTERPOS, ENTIDAD_CEDENTE_ID, 
		COLUM_DOMMY, FECHA_INTERPOS_DEMANDA, FECHA_FIN_TAREA,
		TAR_CAM_PM, ASUNTO_ID, ESTADO_FASE_ACTUAL_ID, 
		FASE_ACTUAL_DETALLE_ID, NUM_DIAS_INTERPOS2,MARCA_HITO_ID,TIPO_PROCEDIMIENTO_DET_ID
	) 
		SELECT 
			bypass.FECHA, -- Dia del bucle para FECHA_CARGA_DATOS 
			bypass.FECHA, -- Dia del bucle para DIA_ID
			bypass.PROCEDIMIENTO_ID, 
			bypass.CATEGORIA_PLAZO_MEDIO, 
			pm_all.NUM_DIAS_INTERPOS,
			bypass.ENTIDAD_CEDENTE_ID,
			1, -- COLUM_DOMMY
			pm_all.FECHA_INTERPOSICION_DEMANDA,
			pm_all.FECHA_FIN,
			bypass.TAREA_CALC,
			hprc.ASUNTO_ID, -- asunto_id
			hprc.ESTADO_FASE_ACTUAL_ID, -- ESTADO_FASE_ACTUAL_ID
			hprc.FASE_ACTUAL_DETALLE_ID, -- FASE_ACTUAL_DETALLE_ID
			pm_all.FECHA_INTERPOSICION_DEMANDA, -- segundo calculo de num de dias?	
			0,
			hprc.TIPO_PROCEDIMIENTO_DET_ID
		FROM TMP_PLAZO_MEDIO_BYPASS bypass
			 join TMP_PRC_TAREA_PM_ALL pm_all 
			 	   on pm_all.ITER = bypass.PROCEDIMIENTO_ID
		           
		           and pm_all.ENTIDAD_CEDENTE_ID = bypass.ENTIDAD_CEDENTE_ID
		           and pm_all.TAREA = bypass.TAREA_CALC
		     join H_PRC hprc -- ESTADO_FASE_ACTUAL_ID
		     	on hprc.ENTIDAD_CEDENTE_ID = bypass.ENTIDAD_CEDENTE_ID
		     	and hprc.PROCEDIMIENTO_ID = bypass.PROCEDIMIENTO_ID
		     	and hprc.DIA_ID = bypass.FECHA
		where pm_all.CATEGORIA_PLAZO_MEDIO is  null
		;

		
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'insert into TMP_PLAZO_MEDIO' AND  `TIME_END_EXECUTE` IS NULL;	

			
	-- ===============================================================================================
	-- 7) Calculamos la interposicion de la demanda.
	-- ===============================================================================================
 	
	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'update TMP_PLAZO_MEDIO tpm => tpm.FECHA_INTERPOS_DEMANDA', CURDATE(), CURTIME(), NULL, NULL);
 
	update TMP_PLAZO_MEDIO tpm 
    	set tpm.FECHA_INTERPOS_DEMANDA = (select max(pm_int.FECHA_FORMULARIO) 
    									   from TMP_PRC_TAREA_PM_INT pm_int 
    									   where tpm.PROCEDIMIENTO_ID = pm_int.ITER and date(pm_int.FECHA_INI) <= tpm.DIA_ID
    									   		and pm_int.FECHA_FIN <> '0000-00-00 00:00:00'
    									   		AND tpm.ENTIDAD_CEDENTE_ID = pm_int.ENTIDAD_CEDENTE_ID
    									   		AND tpm.DIA_ID = pm_int.FECHA
    									   );			
    									   
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'update TMP_PLAZO_MEDIO tpm => tpm.FECHA_INTERPOS_DEMANDA' AND  `TIME_END_EXECUTE` IS NULL;	

    									   
	-- ===============================================================================================
	-- 7 B) Sobre los asuntos que NO tienen Fecha de Interposición de la Demanda, cogemos la fecha
	--		de Conformación del asunto.
	-- ===============================================================================================
/*
	==> Desactivamos el tratamiento de los migrados, distorsionan los plazos medios analizados. 

	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'update TMP_PLAZO_MEDIO tpm (FECHA_INTERPOS_DEMANDA= FECHA_CONFOR_ASUNTO)', CURDATE(), CURTIME(), NULL, NULL);
 
 
	update TMP_PLAZO_MEDIO tpm 
		set tpm.FECHA_INTERPOS_DEMANDA = (select max(pm_all.FECHA_CONFOR_ASUNTO) 
										   from TMP_PRC_TAREA_PM_ALL pm_all 
										   where tpm.PROCEDIMIENTO_ID = pm_all.ITER 
												AND date(pm_all.FECHA_INI) <= tpm.DIA_ID
												AND pm_all.FECHA_FIN <> '0000-00-00 00:00:00'
												AND tpm.ENTIDAD_CEDENTE_ID = pm_all.ENTIDAD_CEDENTE_ID
												AND tpm.DIA_ID = pm_all.FECHA
										   )
	where tpm.FECHA_INTERPOS_DEMANDA is null
	;  
	
	  									   			 	
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'update TMP_PLAZO_MEDIO tpm (FECHA_INTERPOS_DEMANDA= FECHA_CONFOR_ASUNTO)' AND  `TIME_END_EXECUTE` IS NULL;	
*/   	
	
   	-- ===============================================================================================
	-- 8) Informamos de la Fecha Valor de las tareas a medir.
	-- ===============================================================================================
	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'update TMP_PLAZO_MEDIO => FECHA_VALOR_TAREA', CURDATE(), CURTIME(), NULL, NULL);
 
	
	update TMP_PLAZO_MEDIO tpm
		SET tpm.FECHA_VALOR_TAREA = (
			select tpa.FECHA_VALOR_TAREA 
			from TMP_PRC_TAREA_PM_ALL tpa 
			where tpm.ENTIDAD_CEDENTE_ID = tpa.ENTIDAD_CEDENTE_ID
					and tpm.PROCEDIMIENTO_ID = tpa.ITER
					and tpm.DIA_ID = tpa.FECHA	
					and tpm.TAR_CAM_PM = tpa.TAREA	 	
		)							
	;		   	

	  									   			 	
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'update TMP_PLAZO_MEDIO => FECHA_VALOR_TAREA' AND  `TIME_END_EXECUTE` IS NULL;	
   	
   	
   	-- ===============================================================================================
	-- 9) Calculamos los días desde la interposicion de la demanda hasta la fecha de la ult tarea si existe interposiscion de la demanda.
	--	  --> Existen Asuntos que dan dias negativos debido a que son migrados. Ya se ha intentado 
	--		  corregir usando la FECHA CONFORMACION, para el resto los anulamos.
	--	  --> Excluimos la Fecha de Intersposición de la demanda Nula.
	-- ===============================================================================================

	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'update TMP_PLAZO_MEDIO => NUM_DIAS_INTERPOS', CURDATE(), CURTIME(), NULL, NULL);
 
    
	update TMP_PLAZO_MEDIO tpm
		SET tpm.NUM_DIAS_INTERPOS = (
				CASE 
					WHEN tpm.FECHA_VALOR_TAREA IS NULL AND tpm.FECHA_INTERPOS_DEMANDA > tpm.FECHA_FIN_TAREA THEN 0
					WHEN tpm.FECHA_INTERPOS_DEMANDA > tpm.FECHA_VALOR_TAREA THEN 0 
					WHEN tpm.FECHA_VALOR_TAREA IS NULL AND tpm.FECHA_FIN_TAREA IS NOT NULL THEN datediff(tpm.FECHA_FIN_TAREA, tpm.FECHA_INTERPOS_DEMANDA)  
					WHEN tpm.FECHA_VALOR_TAREA IS NOT NULL THEN datediff(tpm.FECHA_VALOR_TAREA, tpm.FECHA_INTERPOS_DEMANDA)
				END 
		)	
	where tpm.FECHA_INTERPOS_DEMANDA is not null						
	;		
	
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'update TMP_PLAZO_MEDIO => NUM_DIAS_INTERPOS' AND  `TIME_END_EXECUTE` IS NULL;	
   	





	-- ===============================================================================================
	--  10) PASO A PRODUCCION 
	-- ===============================================================================================
	delete from H_PRC_PLAZO_MEDIO where dia_id=fecha;

	INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
		VALUE ( 'Cargar_H_Prc_Plazo_Medio_gral__detalle', 'PASO A PRODUCCION', CURDATE(), CURTIME(), NULL, NULL);
 

	INSERT INTO `bi_cdd_dwh`.`H_PRC_PLAZO_MEDIO`
	(`DIA_ID`,
	`FECHA_CARGA_DATOS`,
	`PROCEDIMIENTO_ID`,
	`CATEGORIA_PLAZO_MEDIO`,
	`NUM_DIAS_INTERPOS`,
	`ENTIDAD_CEDENTE_ID`,
	`colum_dommy`,
	`FECHA_INTERPOS_DEMANDA`,
	`FECHA_FIN_TAREA`,
	`TAR_CAT_PM`,
	`ASUNTO_ID`,
	`ESTADO_FASE_ACTUAL_ID`,
	`FASE_ACTUAL_DETALLE_ID`,
	`NUM_DIAS_INTERPOS_2`,
	`FECHA_VALOR_TAREA`,
	`PLAZA_ID`,
	`JUZGADO_ID`,
	`PROCURADOR_ID`,
	`PRC_CON_OPOSICION_ID`,
	`MARCA_HITO_ID`,
	`TIPO_PROCEDIMIENTO_DET_ID`

	)
	SELECT 
		`DIA_ID`,
		`FECHA_CARGA_DATOS`,
		`PROCEDIMIENTO_ID`,
		`CATEGORIA_PLAZO_MEDIO`,
		 coalesce(`NUM_DIAS_INTERPOS`, 0) as `NUM_DIAS_INTERPOS`,
		`ENTIDAD_CEDENTE_ID`,
		`COLUM_DOMMY`,
		`FECHA_INTERPOS_DEMANDA`,
		`FECHA_FIN_TAREA`,
		`TAR_CAM_PM`,
		`ASUNTO_ID`,
		`ESTADO_FASE_ACTUAL_ID`,
		`FASE_ACTUAL_DETALLE_ID`,
		coalesce(`NUM_DIAS_INTERPOS`, 0) as `NUM_DIAS_INTERPOS_2`,
		`FECHA_VALOR_TAREA`,
		-1 as `PLAZA_ID`,
		-1 as `JUZGADO_ID`,
		-1 as `PROCURADOR_ID`,
		0 as `PRC_CON_OPOSICION_ID`,
		`MARCA_HITO_ID`,
               `TIPO_PROCEDIMIENTO_DET_ID`
			
	FROM `bi_cdd_dwh`.`TMP_PLAZO_MEDIO`
	WHERE `DIA_ID` > (SELECT MAX(`DIA_ID`) FROM `bi_cdd_dwh`.`H_PRC_PLAZO_MEDIO`)
		and FECHA_INTERPOS_DEMANDA is not null 
		and NUM_DIAS_INTERPOS > 0;
	

-- ULT_TAR_FIN_DESC_ID _> Esta nos dará la descripcion de la tarea finalizada.

update H_PRC_PLAZO_MEDIO  h  set ULT_TAR_FIN_DESC_ID = (select td.ULT_TAR_FIN_DESC_ID 
										from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_FIN_DESC td on tn.TAR_TAREA = td.ULT_TAR_FIN_DESC_DESC 
                                        where TAR_ID = TAR_CAT_PM AND h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
					AND DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null

                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =1;




update H_PRC_PLAZO_MEDIO  h  set ULT_TAR_FIN_DESC_ID = (select td.ULT_TAR_FIN_DESC_ID 
										from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_FIN_DESC td on tn.TAR_TAREA = td.ULT_TAR_FIN_DESC_DESC 
                                        where TAR_ID = TAR_CAT_PM AND h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
					AND DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null

                                        ) 
where DIA_ID =fecha AND h.ENTIDAD_CEDENTE_ID =2;
update H_PRC_PLAZO_MEDIO  h  set ULT_TAR_FIN_DESC_ID = (select td.ULT_TAR_FIN_DESC_ID 
										from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_FIN_DESC td on tn.TAR_TAREA = td.ULT_TAR_FIN_DESC_DESC 
                                        where TAR_ID = TAR_CAT_PM AND h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
					AND DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =3;
update H_PRC_PLAZO_MEDIO  h  set ULT_TAR_FIN_DESC_ID = (select td.ULT_TAR_FIN_DESC_ID 
										from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_FIN_DESC td on tn.TAR_TAREA = td.ULT_TAR_FIN_DESC_DESC 
                                        where TAR_ID = TAR_CAT_PM AND h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
					AND DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =4;


	
	UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'PASO A PRODUCCION' AND  `TIME_END_EXECUTE` IS NULL;	
-- dias de interposicion de demanda=0

update bi_cdd_dwh.H_PRC_PLAZO_MEDIO t2  ,bi_cdd_dwh.D_PRC_ULT_TAR_FIN_DESC t1
set t2.NUM_DIAS_INTERPOS_2=0
where t1.ult_tar_fin_desc_id=t2.ult_tar_fin_desc_id  and t1.ULT_TAR_FIN_DESC_DESC like'%interposici%'
and t2.dia_id=fecha;
commit;


-- oposiciones -------------------------------------------------------------------
truncate table TMP_PRC_OPOSICIONES;

INSERT INTO TMP_PRC_OPOSICIONES
(select distinct  fecha, ITER from TMP_PRC_TAREA_PM_ALL tall 
join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tall.TAREA=tex.TAR_ID
join bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO tap on tex.TAP_ID=tap.TAP_ID
where
(tap.TAP_ID=244 or tap.TAP_ID=245) and tap.DD_TPO_ID=1 and tall.ENTIDAD_CEDENTE_ID=1)

UNION

(select distinct  fecha, ITER from TMP_PRC_TAREA_PM_ALL tall 
join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tall.TAREA=tex.TAR_ID
join bi_cdd_bbva_datastage.TAP_TAREA_PROCEDIMIENTO tap on tex.TAP_ID=tap.TAP_ID
where
(tap.TAP_ID=244 or tap.TAP_ID=245) and tap.DD_TPO_ID=1 and tall.ENTIDAD_CEDENTE_ID=2)

UNION

(select distinct  fecha, ITER from TMP_PRC_TAREA_PM_ALL tall 
join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tall.TAREA=tex.TAR_ID
join bi_cdd_bankia_datastage.TAP_TAREA_PROCEDIMIENTO tap on tex.TAP_ID=tap.TAP_ID
where
(tap.TAP_ID=244 or tap.TAP_ID=245) and tap.DD_TPO_ID=1 and tall.ENTIDAD_CEDENTE_ID=3)

UNION
(select distinct  fecha, ITER from TMP_PRC_TAREA_PM_ALL tall 
join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tall.TAREA=tex.TAR_ID
join bi_cdd_cajamar_datastage.TAP_TAREA_PROCEDIMIENTO tap on tex.TAP_ID=tap.TAP_ID
where
(tap.TAP_ID=244 or tap.TAP_ID=245) and tap.DD_TPO_ID=1 and tall.ENTIDAD_CEDENTE_ID=4)

UNION

(select distinct prc.DIA_ID,prc.PROCEDIMIENTO_ID from bi_cdd_bbva_datastage.DPR_DECISIONES_PROCEDIMIENTOS decp join  bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA pm
on pm.PRC_ID=decp.PRC_ID
JOIN H_PRC prc on pm.PJ_PADRE=prc.PROCEDIMIENTO_ID
where decp.DD_CDE_ID=7 and decp.DPR_PARALIZA=1 and prc.DIA_ID=fecha AND prc.entidad_cedente_id=2)

UNION

(select distinct prc.DIA_ID,prc.PROCEDIMIENTO_ID from bi_cdd_bng_datastage.DPR_DECISIONES_PROCEDIMIENTOS decp join  bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA pm
on pm.PRC_ID=decp.PRC_ID
JOIN H_PRC prc on pm.PJ_PADRE=prc.PROCEDIMIENTO_ID
where decp.DD_CDE_ID=7 and decp.DPR_PARALIZA=1 and prc.DIA_ID=fecha AND prc.entidad_cedente_id=1);



UPDATE H_PRC_PLAZO_MEDIO PM, TMP_PRC_OPOSICIONES OP
SET PRC_CON_OPOSICION_ID=1
WHERE PM.PROCEDIMIENTO_ID=OP.PROCEDIMIENTO_ID AND PM.DIA_ID=fecha AND PM.DIA_ID=OP.DIA_ID;

-- ---- Fase tarea detalle --------------------------------------------------------------------------------------------

update H_PRC_PLAZO_MEDIO  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_bng_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.TAR_CAT_PM and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =1;

update H_PRC_PLAZO_MEDIO  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_bbva_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.TAR_CAT_PM and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =2;

update H_PRC_PLAZO_MEDIO  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_bankia_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.TAR_CAT_PM and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =3;

update H_PRC_PLAZO_MEDIO  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_cajamar_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.TAR_CAT_PM and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =4;


-- ===============================================================================================
 -- FASE_TAREA_AGR_ID
-- ===============================================================================================
  
	
	 
	 update H_PRC_PLAZO_MEDIO set FASE_TAREA_AGR_ID = (case when TIPO_PROCEDIMIENTO_DET_ID IN (153) then 1
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (35) then 2
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (34) then 3
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (33) then 4
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (1) then 5
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2) then 6
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (164) then 7
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (162) then 8
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (171) then 9
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (168) then 10
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (21) then 11
						     when TIPO_PROCEDIMIENTO_DET_ID IN (157) then 12
                                                     when TIPO_PROCEDIMIENTO_DET_ID  IN (159) then 13
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (155) then 14
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (166) then 15
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (141,142,143,144) then 16
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (165) then 17
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (158) then 18
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (156) then 19
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (1041) then 20
						     when TIPO_PROCEDIMIENTO_DET_ID  IN (41) then 21
                                                     when TIPO_PROCEDIMIENTO_DET_ID IS NULL then -1
                                                     else -1 end) where DIA_ID = fecha;

	 
	 
 
    commit;                                                     
    
	
	 
	  update H_PRC_PLAZO_MEDIO set FASE_TAREA_AGR_ID = (case when FASE_TAREA_DETALLE_ID IN (153) then 1
                                                     when FASE_TAREA_DETALLE_ID IN (35) then 2
                                                     when FASE_TAREA_DETALLE_ID IN (34) then 3
                                                     when FASE_TAREA_DETALLE_ID IN (33) then 4
                                                     when FASE_TAREA_DETALLE_ID IN (1) then 5
                                                     when FASE_TAREA_DETALLE_ID IN (2) then 6
                                                     when FASE_TAREA_DETALLE_ID IN (164) then 7
                                                     when FASE_TAREA_DETALLE_ID IN (162) then 8
                                                     when FASE_TAREA_DETALLE_ID IN (171) then 9
                                                     when FASE_TAREA_DETALLE_ID IN (168) then 10
                                                     when FASE_TAREA_DETALLE_ID IN (21) then 11
						     when FASE_TAREA_DETALLE_ID IN (157) then 12
                                                     when FASE_TAREA_DETALLE_ID IN (159) then 13
						     when FASE_TAREA_DETALLE_ID IN (155) then 14
						     when FASE_TAREA_DETALLE_ID IN (166) then 15
						     when FASE_TAREA_DETALLE_ID IN (141,142,143,144) then 16
						     when FASE_TAREA_DETALLE_ID IN (165) then 17
						     when FASE_TAREA_DETALLE_ID IN (158) then 18
						     when FASE_TAREA_DETALLE_ID IN (156) then 19
						     when FASE_TAREA_DETALLE_ID IN (1041) then 20
						     when FASE_TAREA_DETALLE_ID IN (41) then 21
                                                     else FASE_TAREA_AGR_ID end) where DIA_ID = fecha;
	 
	 
	 
    commit;     


UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
	WHERE  `STEP_SP` = 'update H_PRC_PLAZO_MEDIO => FASE_TAREA_AGR_ID' AND  `TIME_END_EXECUTE` IS NULL;	

END MY_BLOCK_H_PCR_PLA_MED

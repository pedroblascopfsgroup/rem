-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_H_Prc_Recursos` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_H_Prc_Recursos`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_PCR_RECUR: BEGIN

-- ===============================================================================================
-- Autor: Joaquín Arnal, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almacenado que carga las tablas hechos H_PRC_RECURSOS.
-- ===============================================================================================

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




DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: NÃºmero de parÃ¡metros incorrecto'; 




DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';
	
	
	truncate table TMP_PRC_CODIGO_PRIORIDAD_REC;
	

	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P198', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P199', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P95', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P35', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P56', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P63', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P64', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P24', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P25', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P26', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P27', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P28', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P29', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P30', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P31', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P34', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P01', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P02', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P15', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P17', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P55', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P62', 3);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P03', 2);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P04', 2);
	insert into TMP_PRC_CODIGO_PRIORIDAD_REC (DD_TPO_CODIGO, PRIORIDAD) values ('P16', 1);

-- TRUNCATE TABLE TIMER_ANALIZE_SP;	
	
	
INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'INSERT INTO TMP_PRC_JERARQUIA_REC', CURDATE(), CURTIME(), NULL, NULL);
	
	
	TRUNCATE TABLE TMP_PRC_JERARQUIA_REC;
	
	INSERT INTO TMP_PRC_JERARQUIA_REC (
		DIA_ID,                               
		ITER, 
		FASE_ACTUAL, 
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
			1 
		FROM bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD_REC ON PRC_TPO = DD_TPO_CODIGO
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
			2 
		FROM bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD_REC ON PRC_TPO = DD_TPO_CODIGO
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
			3 
		FROM bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD_REC ON PRC_TPO = DD_TPO_CODIGO
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
			4 
		FROM bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
			LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD_REC ON PRC_TPO = DD_TPO_CODIGO  
		 WHERE PRC_TPO != 'P22'      
		) HH
	;
	
	
UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'INSERT INTO TMP_PRC_JERARQUIA_REC' AND  `TIME_END_EXECUTE` IS NULL;

	
	
	
	
	
	
INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'C_FECHA_RELLENAR', CURDATE(), CURTIME(), NULL, NULL);
	
	SET L_LAST_ROW = 0; 
	
	OPEN C_FECHA_RELLENAR;
	RELLENAR_LOOP: LOOP
	FETCH C_FECHA_RELLENAR INTO FECHA_RELLENAR;        
	    IF (L_LAST_ROW=1) THEN LEAVE RELLENAR_LOOP; 
	    END IF;
	    
	    
	    IF((SELECT COUNT(DIA_ID) FROM TMP_PRC_JERARQUIA_REC WHERE DIA_ID = FECHA_RELLENAR) = 0) THEN 
	    INSERT INTO TMP_PRC_JERARQUIA_REC(
	        DIA_ID,                               
	        ITER,   
	        FASE_ACTUAL, 
	        NIVEL,
	        CONTEXTO,
	        CODIGO_FASE_ACTUAL,   
	        PRIORIDAD_FASE,
	        CANCELADO_FASE,
	        ASU_ID 
	        )
	    SELECT DATE_ADD(DIA_ID, INTERVAL 1 DAY),                             
	        ITER,   
	        FASE_ACTUAL, 
	        NIVEL,
	        CONTEXTO,
	        CODIGO_FASE_ACTUAL,   
	        PRIORIDAD_FASE,
	        CANCELADO_FASE,
	        ASU_ID
	        FROM TMP_PRC_JERARQUIA_REC WHERE DIA_ID = DATE_ADD(FECHA_RELLENAR, INTERVAL -1 DAY);
	    END IF; 
	    
	END LOOP;
	CLOSE C_FECHA_RELLENAR;

	
UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'C_FECHA_RELLENAR' AND  `TIME_END_EXECUTE` IS NULL;
	






delete from H_PRC_RECURSOS where DIA_ID between date_start and date_end;







SET L_LAST_ROW = 0; 

OPEN C_FECHA;
READ_LOOP: LOOP
FETCH C_FECHA INTO FECHA;        
    IF (L_LAST_ROW=1) THEN LEAVE READ_LOOP; 
    END IF;
    
	
INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'TMP_PRC_TAREA_REC', CURDATE(), CURTIME(), NULL, NULL);

  	
    TRUNCATE TMP_PRC_DETALLE_REC;
    INSERT INTO TMP_PRC_DETALLE_REC (ITER, ENTIDAD_CEDENTE_ID) 
    	SELECT DISTINCT ITER, ENTIDAD_CEDENTE_ID FROM TMP_PRC_JERARQUIA_REC WHERE DIA_ID = FECHA;

    
    
    UPDATE TMP_PRC_DETALLE_REC PD SET 
        MAX_PRIORIDAD = (SELECT MAX(PRIORIDAD_FASE) FROM TMP_PRC_JERARQUIA_REC PJ WHERE PJ.DIA_ID = FECHA AND PJ.ITER = PD.ITER)
    ;
   
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ SET 
        PRIORIDAD_PROCEDIMIENTO = (SELECT MAX_PRIORIDAD 
								   FROM TMP_PRC_DETALLE_REC PD 
								   WHERE PD.ITER = PJ.ITER
										AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
									) 
    WHERE DIA_ID = FECHA
    ; 
   
     	
UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'TMP_PRC_TAREA_REC' AND  `TIME_END_EXECUTE` IS NULL;
   
	
INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'TMP_PRC_TAREA_REC_2', CURDATE(), CURTIME(), NULL, NULL);

	
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET FASE_MAX_PRIORIDAD = (SELECT MAX(FASE_ACTUAL) 
                                  FROM TMP_PRC_JERARQUIA_REC PJ 
                                  WHERE PJ.DIA_ID = FECHA 
										AND PJ.ITER = PD.ITER 										
										AND PJ.PRIORIDAD_PROCEDIMIENTO = PJ.PRIORIDAD_FASE
										AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
								 )
    ;
    
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET FASE_MAX_PRIORIDAD = (SELECT FASE_MAX_PRIORIDAD 
                                  FROM TMP_PRC_DETALLE_REC PD 
                                  WHERE PD.ITER = PJ.ITER
										AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
								  ) 
    WHERE DIA_ID = FECHA
    ; 

UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'TMP_PRC_TAREA_REC_2' AND  `TIME_END_EXECUTE` IS NULL;

    
INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'TMP_PRC_TAREA_REC_3', CURDATE(), CURTIME(), NULL, NULL);

    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET NUM_FASES = (SELECT COUNT(1) 
						 FROM TMP_PRC_JERARQUIA_REC PJ 
						 WHERE PJ.DIA_ID = FECHA 
							AND PJ.ITER = PD.ITER
							AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
						)
    ;
    
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET CANCELADO_FASE = (SELECT SUM(CANCELADO_FASE) 
							  FROM TMP_PRC_JERARQUIA_REC PJ 
							  WHERE PJ.DIA_ID = FECHA 
									AND PJ.ITER = PD.ITER
									AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							  )
    ;
    
    UPDATE TMP_PRC_DETALLE_REC 
        SET CANCELADO_PROCEDIMIENTO = (CASE WHEN NUM_FASES = CANCELADO_FASE THEN 1 ELSE 0 END)
    ;
    
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET CANCELADO_PROCEDIMIENTO = (SELECT CANCELADO_PROCEDIMIENTO 
									   FROM TMP_PRC_DETALLE_REC PD 
									   WHERE PD.ITER = PJ.ITER
											AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
									  ) 
	WHERE DIA_ID = FECHA
    ;

UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'TMP_PRC_TAREA_REC_3' AND  `TIME_END_EXECUTE` IS NULL;
   
INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'TMP_PRC_TAREA_REC_4', CURDATE(), CURTIME(), NULL, NULL);

    TRUNCATE TABLE TMP_PRC_TAREA_REC;
    
	INSERT INTO TMP_PRC_TAREA_REC (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, ENTIDAD_CEDENTE_ID)
    SELECT 
        TPJ.ITER, 
        TPJ.FASE_ACTUAL, 
        TAR.TAR_ID, 
        TAR.TAR_FECHA_INI, 
        COALESCE(TAR.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
        TAR.TAR_TAREA, 
        TPJ.ENTIDAD_CEDENTE_ID 
	FROM TMP_PRC_JERARQUIA_REC TPJ
        JOIN bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 1		
    WHERE TPJ.DIA_ID = FECHA  AND DATE(TAR.TAR_FECHA_INI) <= FECHA
	UNION 
    SELECT 
        TPJ2.ITER, 
        TPJ2.FASE_ACTUAL, 
        TAR2.TAR_ID, 
        TAR2.TAR_FECHA_INI, 
        COALESCE(TAR2.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
        TAR2.TAR_TAREA, 
        TPJ2.ENTIDAD_CEDENTE_ID 
	FROM TMP_PRC_JERARQUIA_REC TPJ2
        JOIN bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES TAR2 ON TPJ2.FASE_ACTUAL = TAR2.PRC_ID 
        	AND TPJ2.ENTIDAD_CEDENTE_ID = 2
    WHERE TPJ2.DIA_ID = FECHA  AND DATE(TAR2.TAR_FECHA_INI) <= FECHA
    UNION 
    SELECT 
        TPJ3.ITER, 
        TPJ3.FASE_ACTUAL, 
        TAR3.TAR_ID, 
        TAR3.TAR_FECHA_INI, 
        COALESCE(TAR3.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
        TAR3.TAR_TAREA, 
        TPJ3.ENTIDAD_CEDENTE_ID 
	FROM TMP_PRC_JERARQUIA_REC TPJ3
        JOIN bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES TAR3 ON TPJ3.FASE_ACTUAL = TAR3.PRC_ID 
        	AND TPJ3.ENTIDAD_CEDENTE_ID = 3
    WHERE TPJ3.DIA_ID = FECHA  AND DATE(TAR3.TAR_FECHA_INI) <= FECHA
    UNION 
    SELECT 
        TPJ4.ITER, 
        TPJ4.FASE_ACTUAL, 
        TAR4.TAR_ID, 
        TAR4.TAR_FECHA_INI, 
        COALESCE(TAR4.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
        TAR4.TAR_TAREA, 
        TPJ4.ENTIDAD_CEDENTE_ID 
	FROM TMP_PRC_JERARQUIA_REC TPJ4
        JOIN bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES TAR4 ON TPJ4.FASE_ACTUAL = TAR4.PRC_ID 
        	AND TPJ4.ENTIDAD_CEDENTE_ID = 4
    WHERE TPJ4.DIA_ID = FECHA  AND DATE(TAR4.TAR_FECHA_INI) <= FECHA    
	;


    	
UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'TMP_PRC_TAREA_REC_4' AND  `TIME_END_EXECUTE` IS NULL;

    
	/*
    TRUNCATE TMP_PRC_AUTO_PRORROGAS_REC;
    
    INSERT INTO TMP_PRC_AUTO_PRORROGAS_REC (TAREA, FECHA_AUTO_PRORROGA, ENTIDAD_CEDENTE_ID) 
 	SELECT 
         TEX.TAR_ID, 
         DATE(MEJ.FECHACREAR), 
         1 
 	FROM bi_cdd_bng_datastage.MEJ_REG_REGISTRO MEJ
 		  JOIN bi_cdd_bng_datastage.MEJ_IRG_INFO_REGISTRO INFO ON MEJ.REG_ID = INFO.REG_ID
 		  JOIN bi_cdd_bng_datastage.TEX_TAREA_EXTERNA TEX ON INFO.IRG_VALOR = TEX.TEX_ID
 	WHERE MEJ.DD_TRG_ID = 4 AND INFO.IRG_CLAVE = 'tarId' AND DATE(MEJ.FECHACREAR) <= FECHA
 	UNION
 	SELECT 
         TEX.TAR_ID, 
         DATE(MEJ.FECHACREAR), 
         2 
 	FROM bi_cdd_bbva_datastage.MEJ_REG_REGISTRO MEJ
 		  JOIN bi_cdd_bbva_datastage.MEJ_IRG_INFO_REGISTRO INFO ON MEJ.REG_ID = INFO.REG_ID
 		  JOIN bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA TEX ON INFO.IRG_VALOR = TEX.TEX_ID
 	WHERE MEJ.DD_TRG_ID = 4 AND INFO.IRG_CLAVE = 'tarId' AND DATE(MEJ.FECHACREAR) <= FECHA
 	UNION
 	SELECT 
         TEX.TAR_ID, 
         DATE(MEJ.FECHACREAR), 
         3 
 	FROM bi_cdd_bankia_datastage.MEJ_REG_REGISTRO MEJ
 		  JOIN bi_cdd_bankia_datastage.MEJ_IRG_INFO_REGISTRO INFO ON MEJ.REG_ID = INFO.REG_ID
 		  JOIN bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA TEX ON INFO.IRG_VALOR = TEX.TEX_ID
 	WHERE MEJ.DD_TRG_ID = 4 AND INFO.IRG_CLAVE = 'tarId' AND DATE(MEJ.FECHACREAR) <= FECHA 	
 	UNION
 	SELECT 
         TEX.TAR_ID, 
         DATE(MEJ.FECHACREAR), 
         4 
 	FROM bi_cdd_cajamar_datastage.MEJ_REG_REGISTRO MEJ
 		  JOIN bi_cdd_cajamar_datastage.MEJ_IRG_INFO_REGISTRO INFO ON MEJ.REG_ID = INFO.REG_ID
 		  JOIN bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA TEX ON INFO.IRG_VALOR = TEX.TEX_ID
 	WHERE MEJ.DD_TRG_ID = 4 AND INFO.IRG_CLAVE = 'tarId' AND DATE(MEJ.FECHACREAR) <= FECHA 	 	
 	;
	*/
    
    
    
    /*
 	UPDATE TMP_PRC_TAREA_REC PT SET FECHA_AUTO_PRORROGA = (
 		SELECT COALESCE(MAX(FECHA_AUTO_PRORROGA), '0000-00-00 00:00:00') 
 		FROM TMP_PRC_AUTO_PRORROGAS TPA 
 		WHERE TPA.TAREA = PT.TAREA 
 			AND TPA.ENTIDAD_CEDENTE_ID = PT.ENTIDAD_CEDENTE_ID)
	;  

	
	UPDATE TMP_PRC_TAREA_REC PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_bng_datastage.SPR_SOLICITUD_PRORROGA SPR 
 		WHERE SPR.TAR_ID = PT.TAREA AND DATE(SPR.FECHACREAR) <= FECHA
 			AND 1 = PT.ENTIDAD_CEDENTE_ID
 	)
 	;
 	
	
	UPDATE TMP_PRC_TAREA_REC PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_bbva_datastage.SPR_SOLICITUD_PRORROGA SPR2 
 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA
 			AND 2 = PT.ENTIDAD_CEDENTE_ID
 	);
 	
	
	UPDATE TMP_PRC_TAREA_REC PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_bankia_datastage.SPR_SOLICITUD_PRORROGA SPR2 
 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA
 			AND 3 = PT.ENTIDAD_CEDENTE_ID
 	); 	
 	
	
	UPDATE TMP_PRC_TAREA_REC PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_cajamar_datastage.SPR_SOLICITUD_PRORROGA SPR2 
 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA
 			AND 4 = PT.ENTIDAD_CEDENTE_ID
 	);  	

    
    UPDATE TMP_PRC_TAREA_REC PT 
        SET NUM_AUTO_PRORROGAS = (	
				SELECT COUNT(1) 
				FROM TMP_PRC_AUTO_PRORROGAS_REC TP 
				WHERE PT.TAREA = TP.TAREA 
					AND DATE(TP.FECHA_AUTO_PRORROGA) <= FECHA 
					AND FECHA_AUTO_PRORROGA <>'0000-00-00 00:00:00'
					AND PT.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
				)
    ;

    
    UPDATE TMP_PRC_TAREA_REC PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_bng_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 1
    ; 

    
    UPDATE TMP_PRC_TAREA_REC PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_bbva_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 2
    ;  

    
    UPDATE TMP_PRC_TAREA_REC PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_bankia_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 3
    ;    

    
    
    UPDATE TMP_PRC_TAREA_REC PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_cajamar_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 4
    ;    

	*/
    
    
    
	
INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'UPP_BLOQUE_1', CURDATE(), CURTIME(), NULL, NULL);
    
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET PD.FECHA_ULT_TAR_CREADA = (SELECT MAX(TP.FECHA_INI) 
        							FROM TMP_PRC_TAREA_REC TP 
        							WHERE PD.ITER = TP.ITER 
        								AND DATE(TP.FECHA_INI) <= FECHA 
        								AND TP.FECHA_INI<>'0000-00-00 00:00:00'
        								AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        							)
    ;
    
    
    
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET PD.ULT_TAR_CREADA = (SELECT MAX(TP.TAREA) 
        					  FROM TMP_PRC_TAREA_REC TP 
        					  WHERE PD.ITER = TP.ITER 
        					  	AND TP.FECHA_INI = PD.FECHA_ULT_TAR_CREADA
        					  	AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        					  )
    ;
    
   
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET PD.FECHA_ULT_TAR_FIN = (SELECT MAX(TP.FECHA_FIN) 
        						 FROM TMP_PRC_TAREA_REC TP 
        						 WHERE PD.ITER = TP.ITER 
        						 	AND DATE(TP.FECHA_FIN) <= FECHA 
        						 	AND TP.FECHA_FIN<>'0000-00-00 00:00:00'
        						 	AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        						 )
    ;
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET PD.ULT_TAR_FIN = (SELECT MAX(TP.TAREA) 
        				   FROM TMP_PRC_TAREA_REC TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.FECHA_FIN = PD.FECHA_ULT_TAR_FIN
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    
        
     	
UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'UPP_BLOQUE_1' AND  `TIME_END_EXECUTE` IS NULL;
   
    

INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'UPP_BLOQUE_2', CURDATE(), CURTIME(), NULL, NULL);
    
    UPDATE TMP_PRC_TAREA_REC 
        SET FECHA_ACTUALIZACION = FECHA_INI 
    WHERE DATE(FECHA_INI) <= FECHA
    ;
    
    UPDATE TMP_PRC_TAREA_REC 
        SET FECHA_ACTUALIZACION = FECHA_FIN 
    WHERE FECHA_FIN >= FECHA_ACTUALIZACION AND DATE(FECHA_FIN) <= FECHA
    ;
    
	
	
    UPDATE TMP_PRC_TAREA_REC 
        SET FECHA_ACTUALIZACION = FECHA_PRORROGA 
    WHERE FECHA_PRORROGA >= FECHA_ACTUALIZACION AND DATE(FECHA_PRORROGA) <= FECHA
    ;
    
    UPDATE TMP_PRC_TAREA_REC 
        SET FECHA_ACTUALIZACION = FECHA_AUTO_PRORROGA 
    WHERE FECHA_PRORROGA >= FECHA_ACTUALIZACION AND DATE(FECHA_AUTO_PRORROGA) <= FECHA
    ;

UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'UPP_BLOQUE_2' AND  `TIME_END_EXECUTE` IS NULL;

   
    
    
     

INSERT INTO TIMER_ANALIZE_SP ( `NAME_SP`, `STEP_SP`, `TIME_EXECUTE`, `TIME_START_EXECUTE`, `TIME_END_EXECUTE`, `TIME_DIFF_EXECUTE`) 
VALUE ( 'Cargar_H_Prc_Recursos', 'UPP_BLOQUE_3', CURDATE(), CURTIME(), NULL, NULL);
   
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET FECHA_ULTIMA_TAREA_ACTUALIZADA = (SELECT MAX(FECHA_ACTUALIZACION) 
        									  FROM TMP_PRC_TAREA_REC TP 
        									  WHERE PD.ITER = TP.ITER 
        									  		AND TP.FECHA_ACTUALIZACION<>'0000-00-00 00:00:00'
        									  		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        									  )
    ;
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET ULTIMA_TAREA_ACTUALIZADA = (SELECT MAX(TAREA) 
        								FROM TMP_PRC_TAREA_REC TP 
        								WHERE PD.ITER = TP.ITER 
        									AND TP.FECHA_ACTUALIZACION = PD.FECHA_ULTIMA_TAREA_ACTUALIZADA
        									AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        								)
    ;
    
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET FECHA_ULT_TAR_PEND = (SELECT MAX(FECHA_INI) 
                                  FROM TMP_PRC_TAREA_REC TP 
                                  WHERE PD.ITER = TP.ITER 
                                  		AND DATE(TP.FECHA_INI) <= FECHA 
                                  		AND FECHA_INI<>'0000-00-00 00:00:00' 
                                  		AND FECHA_FIN = '0000-00-00 00:00:00'
                                  		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
                                  )
    ;
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET ULT_TAR_PEND = (SELECT MAX(TAREA) 
        					FROM TMP_PRC_TAREA_REC TP 
        					WHERE PD.ITER = TP.ITER 
        						AND TP.FECHA_INI = PD.FECHA_ULT_TAR_PEND
        						AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        					)
    ;


UPDATE TIMER_ANALIZE_SP SET `TIME_END_EXECUTE` = CURTIME(), `TIME_DIFF_EXECUTE` = TIMEDIFF(`TIME_END_EXECUTE`, `TIME_START_EXECUTE`) 
WHERE  `STEP_SP` = 'UPP_BLOQUE_3' AND  `TIME_END_EXECUTE` IS NULL;
	
    
	/*  
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET FECHA_ULTIMA_AUTO_PRORROGA = (
        				   SELECT MAX(TP.FECHA_AUTO_PRORROGA) 
        				   FROM TMP_PRC_TAREA_REC TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    

    
	  
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET FECHA_ULTIMA_PRORROGA = (
        				   SELECT MAX(TP.FECHA_PRORROGA) 
        				   FROM TMP_PRC_TAREA_REC TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    
    
	  
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET NUM_AUTO_PRORROGA = (
        				   SELECT MAX(TP.NUM_AUTO_PRORROGAS) 
        				   FROM TMP_PRC_TAREA_REC TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    
 	
	  
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET NUM_PRORROGA = (
        				   SELECT MAX(TP.NUM_PRORROGAS)
        				   FROM TMP_PRC_TAREA_REC TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
	*/
   
    
    
    
    
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET ULT_TAR_CREADA = (SELECT ULT_TAR_CREADA 
        					  FROM TMP_PRC_DETALLE_REC PD 
        					  WHERE PD.ITER = PJ.ITER
        					  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					  ) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET FECHA_ULT_TAR_CREADA = (SELECT FECHA_ULT_TAR_CREADA 
        							FROM TMP_PRC_DETALLE_REC PD 
        							WHERE PD.ITER = PJ.ITER
        								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        							) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET ULT_TAR_FIN = (	SELECT ULT_TAR_FIN 
        					FROM TMP_PRC_DETALLE_REC PD 
        					WHERE PD.ITER = PJ.ITER
        						AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET FECHA_ULT_TAR_FIN = (SELECT FECHA_ULT_TAR_FIN 
        						 FROM TMP_PRC_DETALLE_REC PD 
        						 WHERE PD.ITER = PJ.ITER
        						 	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        						 ) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET ULTIMA_TAREA_ACTUALIZADA = (SELECT ULTIMA_TAREA_ACTUALIZADA 
        								FROM TMP_PRC_DETALLE_REC PD 
        								WHERE PD.ITER = PJ.ITER
        									AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        								) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET FECHA_ULTIMA_TAREA_ACTUALIZADA = (SELECT FECHA_ULTIMA_TAREA_ACTUALIZADA 
        									  FROM TMP_PRC_DETALLE_REC PD 
        									  WHERE PD.ITER = PJ.ITER
        									  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        									  ) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET ULT_TAR_PEND = (SELECT ULT_TAR_PEND 
        					FROM TMP_PRC_DETALLE_REC PD 
        					WHERE PD.ITER = PJ.ITER
        						AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET FECHA_ULT_TAR_PEND = (SELECT FECHA_ULT_TAR_PEND 
        						  FROM TMP_PRC_DETALLE_REC PD 
        						  WHERE PD.ITER = PJ.ITER
        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        						  ) 
    WHERE DIA_ID = FECHA
    ;   


	
	/*
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET FECHA_ULTIMA_AUTO_PRORROGA = (SELECT FECHA_ULTIMA_AUTO_PRORROGA 
		        						  FROM TMP_PRC_DETALLE_REC PD 
		        						  WHERE PD.ITER = PJ.ITER
		        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
		        						  ) 
    WHERE DIA_ID = FECHA
    ; 
    
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET FECHA_ULTIMA_PRORROGA = (SELECT FECHA_ULTIMA_PRORROGA 
		        						  FROM TMP_PRC_DETALLE_REC PD 
		        						  WHERE PD.ITER = PJ.ITER
		        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
		        						  ) 
    WHERE DIA_ID = FECHA
    ;
      
	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET NUM_AUTO_PRORROGA = (SELECT NUM_AUTO_PRORROGA 
        						 FROM TMP_PRC_DETALLE_REC PD 
        						 WHERE PD.ITER = PJ.ITER
        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        						) 
    WHERE DIA_ID = FECHA
    ; 
    
	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET NUM_PRORROGA = (SELECT NUM_PRORROGA 
    						 FROM TMP_PRC_DETALLE_REC PD 
    						 WHERE PD.ITER = PJ.ITER
    						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
    						) 
    WHERE DIA_ID = FECHA
    ;     
    */
    
	
/*	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET PARALIZADO = 1
    WHERE PJ.ASU_ID IN (
				SELECT DISTINCT PRC.ASU_ID  
				FROM bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_bng_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
		AND PJ.ENTIDAD_CEDENTE_ID = 1  
		AND DIA_ID = FECHA			
	;
	
	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET PARALIZADO = 1
    WHERE PJ.ASU_ID IN (
				SELECT DISTINCT PRC.ASU_ID  
				FROM bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_bbva_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
		AND PJ.ENTIDAD_CEDENTE_ID = 2  
		AND DIA_ID = FECHA			
	;

	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET PARALIZADO = 1
    WHERE PJ.ASU_ID IN (
				SELECT DISTINCT PRC.ASU_ID  
				FROM bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_bankia_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
		AND PJ.ENTIDAD_CEDENTE_ID = 3  
		AND DIA_ID = FECHA			
	;				
	
	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET PARALIZADO = 1
    WHERE PJ.ASU_ID IN (
				SELECT DISTINCT PRC.ASU_ID  
				FROM bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_cajamar_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
		AND PJ.ENTIDAD_CEDENTE_ID = 4  
		AND DIA_ID = FECHA			
	;
	
	
	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET NUM_PARALIZACIONES = (
				SELECT COUNT(1) 
				FROM bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_bng_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
	WHERE  DIA_ID = FECHA AND			
		PJ.ENTIDAD_CEDENTE_ID = 1
	;
	
	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET NUM_PARALIZACIONES = (
				SELECT COUNT(1) 
				FROM bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_bbva_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
	WHERE  DIA_ID = FECHA AND			
		PJ.ENTIDAD_CEDENTE_ID = 2		
	;

	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET NUM_PARALIZACIONES = (
				SELECT COUNT(1) 
				FROM bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_bankia_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
	WHERE  DIA_ID = FECHA AND			
		PJ.ENTIDAD_CEDENTE_ID = 3			
	;
	
	
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
        SET NUM_PARALIZACIONES = (
				SELECT COUNT(1) 
				FROM bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS PRC
					INNER JOIN bi_cdd_cajamar_datastage.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID 
							AND DPR.DPR_PARALIZA = 1 AND DPR.DD_EDE_ID = 2
				WHERE PRC.PRC_PARALIZADO = 1
					AND PRC.DD_EPR_ID NOT IN (5) 
					AND PRC.ASU_ID = PJ.ASU_ID					
				)
	WHERE  DIA_ID = FECHA AND			
		PJ.ENTIDAD_CEDENTE_ID = 4			
	;	

   */
    
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET FASE_ACTUAL = (SELECT MAX(FASE) 
        					FROM TMP_PRC_TAREA_REC PT 
        					WHERE PT.ITER = PD.ITER 
        						AND PT.TAREA = PD.ULT_TAR_CREADA
        						AND PD.ENTIDAD_CEDENTE_ID = PT.ENTIDAD_CEDENTE_ID
        					)
    ;
    
    UPDATE TMP_PRC_DETALLE_REC PD 
        SET FASE_ACTUAL = (	SELECT MAX(FASE_ACTUAL) 
        					FROM TMP_PRC_JERARQUIA_REC PJ 
        					WHERE PJ.DIA_ID = FECHA 
        						AND PJ.ITER = PD.ITER
        						AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					)
    WHERE FASE_ACTUAL IS NULL
    ;
                                                             
                                                             
     
    
    
    UPDATE TMP_PRC_JERARQUIA_REC PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE_REC PD 
								INNER JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA and PJ.ENTIDAD_CEDENTE_ID = 1 
	; 

    UPDATE TMP_PRC_JERARQUIA_REC PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE_REC PD 
								INNER JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA  and PJ.ENTIDAD_CEDENTE_ID = 2 
	; 

    UPDATE TMP_PRC_JERARQUIA_REC PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE_REC PD 
								INNER JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA and PJ.ENTIDAD_CEDENTE_ID = 3 
	; 

    UPDATE TMP_PRC_JERARQUIA_REC PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE_REC PD 
								INNER JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA and PJ.ENTIDAD_CEDENTE_ID = 4 
	; 


	
	TRUNCATE TMP_PRC_TAREA_STP1_REC;
	
	INSERT INTO TMP_PRC_TAREA_STP1_REC (
			ITER, FASE, TAREA, FECHA_INI, 
			FECHA_FIN, FECHA_PRORROGA, FECHA_AUTO_PRORROGA, FECHA_ACTUALIZACION, 
			DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, 
			FECHA_FORMULARIO, ENTIDAD_CEDENTE_ID, NUM_AUTO_PRORROGAS, NUM_PRORROGAS
			)	
	SELECT 	ITER, FASE, TAREA, FECHA_INI, 
			FECHA_FIN, FECHA_PRORROGA, FECHA_AUTO_PRORROGA, FECHA_ACTUALIZACION, 
			DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, 
			FECHA_FORMULARIO, ENTIDAD_CEDENTE_ID, NUM_AUTO_PRORROGAS, NUM_PRORROGAS
	FROM TMP_PRC_TAREA_REC
	;


  
    
	
	truncate table TMP_PRC_TAREA_REC;
	
	insert into TMP_PRC_TAREA_REC 
		(
		ITER, FASE, TAREA, 
		FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, 
		TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, 
		FECHA_FORMULARIO, ENTIDAD_CEDENTE_ID
		) 
			select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, 
					tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA ,
					TAP_ID, tex.TEX_ID, TEV_NOMBRE, 
					date(TEV_VALOR), 1 
			from TMP_PRC_JERARQUIA_REC tpj
			    join bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
			    join bi_cdd_bng_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
			    join bi_cdd_bng_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
			where DIA_ID =  fecha and date(tar.TAR_FECHA_INI) <= fecha and
			    tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
			    and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)
			UNION 
			select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, 
					tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA ,
					TAP_ID,tex.TEX_ID, TEV_NOMBRE, 
					date(TEV_VALOR), 2 
			from TMP_PRC_JERARQUIA_REC tpj
			    join bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
			    join bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
			    join bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
			where DIA_ID =  fecha and date(tar.TAR_FECHA_INI) <= fecha and
			    tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
			    and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)	   
			UNION 
			select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, 
					tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA ,
					TAP_ID, tex.TEX_ID, TEV_NOMBRE, 
					date(TEV_VALOR), 3 
			from TMP_PRC_JERARQUIA_REC tpj
			    join bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
			    join bi_cdd_bankia_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
			    join bi_cdd_bankia_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
			where DIA_ID =  fecha and date(tar.TAR_FECHA_INI) <= fecha and
			    tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
			    and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)
			UNION
			select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, 
					tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA ,
					TAP_ID, tex.TEX_ID, TEV_NOMBRE, 
					date(TEV_VALOR), 4 
			from TMP_PRC_JERARQUIA_REC tpj
			    join bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
			    join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
			    join bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
			where DIA_ID =  fecha and date(tar.TAR_FECHA_INI) <= fecha and
			    tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
			    and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)	    	    
    ;
                
        
    update TMP_PRC_DETALLE_REC pd 
    	set FECHA_INTERPOSICION_DEMANDA = (select max(FECHA_FORMULARIO) 
    									   from TMP_PRC_TAREA_REC tp 
    									   where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha and FECHA_FIN <> '0000-00-00 00:00:00'
    									   		AND pd.ENTIDAD_CEDENTE_ID = tp.ENTIDAD_CEDENTE_ID
    									   );
    									   
    update TMP_PRC_JERARQUIA_REC pj 
    	set FECHA_INTERPOSICION_DEMANDA = (select FECHA_INTERPOSICION_DEMANDA 
    									   from TMP_PRC_DETALLE_REC pd 
    									   where pd.ITER = pj.ITER
    									   		AND pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID
    									   ) 
   	where DIA_ID = fecha; 

    
    truncate table TMP_PRC_CONTRATO_REC;
    
    
	set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from bi_cdd_bng_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);
    
    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, h_mov.CNT_ID, cex.CEX_ID, h_mov.MOV_POS_VIVA_VENCIDA, h_mov.MOV_POS_VIVA_NO_VENCIDA, h_mov.MOV_EXTRA_1, h_mov.MOV_FECHA_POS_VENCIDA, 1 
	from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bng_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bng_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
		join bi_cdd_bng_datastage.MOV_MOVIMIENTOS h_mov on cex.CNT_ID = h_mov.CNT_ID
	
	where MOV_FECHA_EXTRACCION = max_dia_con_contratos
    ;
  

    set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);
    
    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, h_mov.CNT_ID, cex.CEX_ID, h_mov.MOV_POS_VIVA_VENCIDA, h_mov.MOV_POS_VIVA_NO_VENCIDA, h_mov.MOV_EXTRA_1, h_mov.MOV_FECHA_POS_VENCIDA, 2 
	from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bbva_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bbva_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
		join bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h_mov on cex.CNT_ID = h_mov.CNT_ID
	
	where MOV_FECHA_EXTRACCION = max_dia_con_contratos
    ;    


	set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);	

    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
	select prc.PRC_ID, pp.CNT_ID, cex.CEX_ID, pp.MOV_POS_VIVA_VENCIDA, pp.MOV_POS_VIVA_NO_VENCIDA, pp.MOV_EXTRA_1, pp.MOV_FECHA_POS_VENCIDA, 3 
	from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bankia_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bankia_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID	
		join (
		 SELECT distinct h_mov.*
		 FROM bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h_mov
		 WHERE h_mov.MOV_FECHA_EXTRACCION > (SELECT MAX(MOV3.MOV_FECHA_EXTRACCION) - 2 
											 FROM bi_cdd_bankia_datastage.MOV_MOVIMIENTOS MOV3 
											 WHERE MOV3.CNT_ID = h_mov.CNT_ID AND MOV3.BORRADO = 0)
		) pp on cex.CNT_ID = pp.CNT_ID
    
	where MOV_FECHA_EXTRACCION = max_dia_con_contratos
    ;        
   
    
    set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);
    
    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, h_mov.CNT_ID, cex.CEX_ID, h_mov.MOV_POS_VIVA_VENCIDA, h_mov.MOV_POS_VIVA_NO_VENCIDA, h_mov.MOV_EXTRA_1, h_mov.MOV_FECHA_POS_VENCIDA, 4 
	from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_cajamar_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_cajamar_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
		join bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h_mov on cex.CNT_ID = h_mov.CNT_ID
	
	where MOV_FECHA_EXTRACCION = max_dia_con_contratos
    ; 	  

    
    
    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 1 
	from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bng_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bng_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO_REC WHERE ENTIDAD_CEDENTE_ID = 1);

    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 2
	from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bbva_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bbva_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO_REC WHERE ENTIDAD_CEDENTE_ID = 2);


    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 3
	from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bankia_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bankia_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO_REC WHERE ENTIDAD_CEDENTE_ID = 3);


    insert into TMP_PRC_CONTRATO_REC (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 4 
	from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_cajamar_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_cajamar_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO_REC WHERE ENTIDAD_CEDENTE_ID = 4);


	
    update TMP_PRC_CONTRATO_REC tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =1;

    update TMP_PRC_CONTRATO_REC tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =2;

    update TMP_PRC_CONTRATO_REC tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =3;

    update TMP_PRC_CONTRATO_REC tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =4;


    
    delete from TMP_PRC_CONTRATO_REC where CEX_ID is null and MAX_MOV_ID is null;

    
    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 4;

	
    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO_REC tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 4;

	
    update TMP_PRC_CONTRATO_REC tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO_REC tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO_REC tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO_REC tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 4;

	
    update TMP_PRC_CONTRATO_REC tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO_REC tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO_REC tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO_REC tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 4;

   
   update TMP_PRC_DETALLE_REC pd 
		set pd.SALDO_VENCIDO = (select sum(pc.SALDO_VENCIDO) 
								from TMP_PRC_CONTRATO_REC pc 
								where pc.ITER = pd.FASE_ACTUAL 
									and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

    update TMP_PRC_DETALLE_REC pd 
		set pd.SALDO_NO_VENCIDO = (	select sum(pc.SALDO_NO_VENCIDO) 
									from TMP_PRC_CONTRATO_REC pc 
									where pc.ITER = pd.FASE_ACTUAL and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

    update TMP_PRC_DETALLE_REC pd 
		set pd.INGRESOS_PENDIENTES_APLICAR = (	select sum(pc.INGRESOS_PENDIENTES_APLICAR) 
											from TMP_PRC_CONTRATO_REC pc 
											where pc.ITER = pd.FASE_ACTUAL  and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

    update TMP_PRC_DETALLE_REC pd 
		set pd.NUM_CONTRATOS = (select count(*) from TMP_PRC_CONTRATO_REC pc where pc.ITER = pd.FASE_ACTUAL and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

		
    update TMP_PRC_JERARQUIA_REC pj 
		set pj.SALDO_VENCIDO = (select SALDO_VENCIDO from TMP_PRC_DETALLE_REC pd where pd.ITER = pj.ITER and pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where pj.DIA_ID = fecha; 

    update TMP_PRC_JERARQUIA_REC pj 
		set SALDO_NO_VENCIDO = (select SALDO_NO_VENCIDO from TMP_PRC_DETALLE_REC pd where pd.ITER = pj.ITER  and pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where DIA_ID = fecha	; 

    update TMP_PRC_JERARQUIA_REC pj 
		set pj.INGRESOS_PENDIENTES_APLICAR = (select INGRESOS_PENDIENTES_APLICAR from TMP_PRC_DETALLE_REC pd where pd.ITER = pj.ITER and pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where pj.DIA_ID = fecha; 

    update TMP_PRC_JERARQUIA_REC pj 
		set NUM_CONTRATOS = (select NUM_CONTRATOS from TMP_PRC_DETALLE_REC pd where pd.ITER = pj.ITER AND  pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where DIA_ID = fecha; 
    
    update TMP_PRC_JERARQUIA_REC pj 
		set pj.SUBTOTAL = (select pd.INGRESOS_PENDIENTES_APLICAR from TMP_PRC_DETALLE_REC pd where pd.ITER = pj.ITER AND  pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where DIA_ID = fecha; 
    
    
    
    
    insert into H_PRC_RECURSOS
    (
		DIA_ID,
		FECHA_CARGA_DATOS,
		RECURSO_ID,
		PROCEDIMIENTO_ID,
		PROCEDIMIENTO_PARALIZADO_ID,
		
		TIPO_PROCEDIMIENTO_ID, 
		TIPO_PROCEDIMIENTO_DET_ID, 
		FASE_ACTUAL_ID, 
		FASE_ACTUAL_DETALLE_ID, 
		
		ACTOR_ID,
		TIPO_RECURSO_ID,
		CAUSA_RECURSO_ID,
		ES_FAVORABLE_ID,
		RESULTADO_RESOL_ID,
		TAREA_ID,
		FECHA_RECURSO,
		FECHA_IMPUGNACION,
		FECHA_VISTA,
		FECHA_RESOLUCION,
		RCR_OBSERVACIONES,
		OBSERVACIONES_IMPUGNACION,
		OBSERVACIONES_RESOLUCION,
		CONFIRM_VISTA_ID,
		CONFIRM_IMPUGNACION_ID,
		OBSERVACIONES_VISTA,
		SUSPENSIVO_ID,
		COL_DUMMY,
		ENTIDAD_CEDENTE_ID,
		NUM_CONTRATOS,
  		SALDO_VENCIDO,         
  		SALDO_NO_VENCIDO,
  		INGRESOS_PENDIENTES_APLICAR,
  		SUBTOTAL
    )
	    SELECT HH.* 
		FROM (
			SELECT 
			  fecha DIA_ID,
		      fecha FECHA_CARGA_DATOS,
			  RCR.RCR_ID,
			  if(TPJR.ITER is null, -1, TPJR.ITER) ITER, 
			  RCR.PRC_ID,
			  TAC_p.DD_TAC_ID TIPO_PROCEDIMIENTO_ID, 
			  TPO_p.DD_TPO_ID TIPO_PROCEDIMIENTO_DET_ID, 
			  TAC.DD_TAC_ID FASE_ACTUAL_ID, 
			  TPO.DD_TPO_ID FASE_ANTERIOR_DETALLE_ID, 
			  RCR.DD_ACT_ID,
			  RCR.DD_DTR_ID,
			  RCR.DD_CRE_ID,
			  RCR.DD_DRR_ID,
			  RCR.DD_FAV_ID,
			  RCR.TAR_ID,
			  if(RCR.RCR_FECHA_RECURSO is null, '0001-01-01',RCR.RCR_FECHA_RECURSO) RCR_FECHA_RECURSO,
			  if(RCR.RCR_FECHA_IMPUGNACION is null, '0001-01-01', RCR.RCR_FECHA_IMPUGNACION) RCR_FECHA_IMPUGNACION,
			  if(RCR.RCR_FECHA_VISTA is null, '0001-01-01', RCR.RCR_FECHA_VISTA) RCR_FECHA_VISTA,
			  if(RCR.RCR_FECHA_RESOLUCION is null, '0001-01-01', RCR.RCR_FECHA_RESOLUCION) RCR_FECHA_RESOLUCION,
			  RCR.RCR_OBSERVACIONES,
			  RCR.RCR_OBSERVACIONES_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_RESOLUCION,
			  RCR.RCR_CONFIRM_VISTA,
			  RCR.RCR_CONFIRM_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_VISTA,
			  RCR.RCR_SUSPENSIVO,
			  1 DUMMY,
			  1 ENTIDAD_CEDENTE_ID,
			  TPJR.NUM_CONTRATOS,
  			  TPJR.SALDO_VENCIDO,         
  			  TPJR.SALDO_NO_VENCIDO,
  			  TPJR.INGRESOS_PENDIENTES_APLICAR,
  		 	  TPJR.SUBTOTAL
			FROM `bi_cdd_bng_datastage`.RCR_RECURSOS_PROCEDIMIENTOS RCR
				 LEFT JOIN TMP_PRC_JERARQUIA_REC TPJR ON TPJR.FASE_ACTUAL = RCR.PRC_ID AND TPJR.ENTIDAD_CEDENTE_ID = 1
				 
				 LEFT JOIN `bi_cdd_bng_datastage`.PRC_PROCEDIMIENTOS PRC_p ON PRC_p.PRC_ID=TPJR.FASE_ACTUAL
        		 LEFT JOIN `bi_cdd_bng_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO_p ON TPO_p.DD_TPO_ID=PRC_p.DD_TPO_ID
				 LEFT JOIN `bi_cdd_bng_datastage`.DD_TAC_TIPO_ACTUACION TAC_p ON TAC_p.DD_TAC_ID=TPO_p.DD_TAC_ID
				 
				 LEFT JOIN `bi_cdd_bng_datastage`.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=RCR.PRC_ID
        		 LEFT JOIN `bi_cdd_bng_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID=PRC.DD_TPO_ID
				 LEFT JOIN `bi_cdd_bng_datastage`.DD_TAC_TIPO_ACTUACION TAC ON TAC.DD_TAC_ID=TPO.DD_TAC_ID
			WHERE RCR.FECHACREAR <= fecha
			UNION
			SELECT 
			  fecha DIA_ID,
		      fecha FECHA_CARGA_DATOS,
			  RCR.RCR_ID,
			  if(TPJR.ITER is null, -1, TPJR.ITER) ITER, 
			  RCR.PRC_ID,
			  TAC_p.DD_TAC_ID TIPO_PROCEDIMIENTO_ID, 
			  TPO_p.DD_TPO_ID TIPO_PROCEDIMIENTO_DET_ID, 
			  TAC.DD_TAC_ID FASE_ACTUAL_ID, 
			  TPO.DD_TPO_ID FASE_ANTERIOR_DETALLE_ID, 
			  RCR.DD_ACT_ID,
			  RCR.DD_DTR_ID,
			  RCR.DD_CRE_ID,
			  RCR.DD_DRR_ID,
			  RCR.DD_FAV_ID,
			  RCR.TAR_ID,
			  if(RCR.RCR_FECHA_RECURSO is null, '0001-01-01',RCR.RCR_FECHA_RECURSO) RCR_FECHA_RECURSO,
			  if(RCR.RCR_FECHA_IMPUGNACION is null, '0001-01-01', RCR.RCR_FECHA_IMPUGNACION) RCR_FECHA_IMPUGNACION,
			  if(RCR.RCR_FECHA_VISTA is null, '0001-01-01', RCR.RCR_FECHA_VISTA) RCR_FECHA_VISTA,
			  if(RCR.RCR_FECHA_RESOLUCION is null, '0001-01-01', RCR.RCR_FECHA_RESOLUCION) RCR_FECHA_RESOLUCION,
			  RCR.RCR_OBSERVACIONES,
			  RCR.RCR_OBSERVACIONES_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_RESOLUCION,
			  RCR.RCR_CONFIRM_VISTA,
			  RCR.RCR_CONFIRM_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_VISTA,
			  RCR.RCR_SUSPENSIVO,
			  1 DUMMY,
			  2 ENTIDAD_CEDENTE_ID,
			  TPJR.NUM_CONTRATOS,
  			  TPJR.SALDO_VENCIDO,         
  			  TPJR.SALDO_NO_VENCIDO,
  			  TPJR.INGRESOS_PENDIENTES_APLICAR,
  		 	  TPJR.SUBTOTAL
			FROM `bi_cdd_bbva_datastage`.RCR_RECURSOS_PROCEDIMIENTOS RCR
				left join TMP_PRC_JERARQUIA_REC TPJR on TPJR.FASE_ACTUAL = RCR.PRC_ID AND TPJR.ENTIDAD_CEDENTE_ID = 2
				
				LEFT JOIN `bi_cdd_bbva_datastage`.PRC_PROCEDIMIENTOS PRC_p ON PRC_p.PRC_ID=TPJR.FASE_ACTUAL
				LEFT JOIN `bi_cdd_bbva_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO_p ON TPO_p.DD_TPO_ID=PRC_p.DD_TPO_ID
				LEFT JOIN `bi_cdd_bbva_datastage`.DD_TAC_TIPO_ACTUACION TAC_p ON TAC_p.DD_TAC_ID=TPO_p.DD_TAC_ID
				
				LEFT JOIN `bi_cdd_bbva_datastage`.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=RCR.PRC_ID
				LEFT JOIN `bi_cdd_bbva_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID=PRC.DD_TPO_ID
				LEFT JOIN `bi_cdd_bbva_datastage`.DD_TAC_TIPO_ACTUACION TAC ON TAC.DD_TAC_ID=TPO.DD_TAC_ID
			WHERE RCR.FECHACREAR <= fecha
			UNION
			SELECT 
			  fecha DIA_ID,
		      fecha FECHA_CARGA_DATOS,
			  RCR.RCR_ID,
			  if(TPJR.ITER is null, -1, TPJR.ITER) ITER, 
			  RCR.PRC_ID,
			  TAC_p.DD_TAC_ID TIPO_PROCEDIMIENTO_ID, 
			  TPO_p.DD_TPO_ID TIPO_PROCEDIMIENTO_DET_ID, 
			  TAC.DD_TAC_ID FASE_ACTUAL_ID, 
			  TPO.DD_TPO_ID FASE_ANTERIOR_DETALLE_ID, 
			  RCR.DD_ACT_ID,
			  RCR.DD_DTR_ID,
			  RCR.DD_CRE_ID,
			  RCR.DD_DRR_ID,
			  RCR.DD_FAV_ID,
			  RCR.TAR_ID,
			  if(RCR.RCR_FECHA_RECURSO is null, '0001-01-01',RCR.RCR_FECHA_RECURSO) RCR_FECHA_RECURSO,
			  if(RCR.RCR_FECHA_IMPUGNACION is null, '0001-01-01', RCR.RCR_FECHA_IMPUGNACION) RCR_FECHA_IMPUGNACION,
			  if(RCR.RCR_FECHA_VISTA is null, '0001-01-01', RCR.RCR_FECHA_VISTA) RCR_FECHA_VISTA,
			  if(RCR.RCR_FECHA_RESOLUCION is null, '0001-01-01', RCR.RCR_FECHA_RESOLUCION) RCR_FECHA_RESOLUCION,
			  RCR.RCR_OBSERVACIONES,
			  RCR.RCR_OBSERVACIONES_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_RESOLUCION,
			  RCR.RCR_CONFIRM_VISTA,
			  RCR.RCR_CONFIRM_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_VISTA,
			  RCR.RCR_SUSPENSIVO,
			  1 DUMMY,
			  3 ENTIDAD_CEDENTE_ID,
			  TPJR.NUM_CONTRATOS,
  			  TPJR.SALDO_VENCIDO,         
  			  TPJR.SALDO_NO_VENCIDO,
  			  TPJR.INGRESOS_PENDIENTES_APLICAR,
  		 	  TPJR.SUBTOTAL
			FROM `bi_cdd_bankia_datastage`.RCR_RECURSOS_PROCEDIMIENTOS RCR
				left join TMP_PRC_JERARQUIA_REC TPJR on TPJR.FASE_ACTUAL = RCR.PRC_ID AND TPJR.ENTIDAD_CEDENTE_ID = 3
				
				LEFT JOIN `bi_cdd_bankia_datastage`.PRC_PROCEDIMIENTOS PRC_p ON PRC_p.PRC_ID=TPJR.FASE_ACTUAL
				LEFT JOIN `bi_cdd_bankia_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO_p ON TPO_p.DD_TPO_ID=PRC_p.DD_TPO_ID
				LEFT JOIN `bi_cdd_bankia_datastage`.DD_TAC_TIPO_ACTUACION TAC_p ON TAC_p.DD_TAC_ID=TPO_p.DD_TAC_ID
				
				LEFT JOIN `bi_cdd_bankia_datastage`.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=RCR.PRC_ID
				LEFT JOIN `bi_cdd_bankia_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID=PRC.DD_TPO_ID
				LEFT JOIN `bi_cdd_bankia_datastage`.DD_TAC_TIPO_ACTUACION TAC ON TAC.DD_TAC_ID=TPO.DD_TAC_ID
			WHERE RCR.FECHACREAR <= fecha
			UNION
			SELECT 
			  fecha DIA_ID,
		      fecha FECHA_CARGA_DATOS,
			  RCR.RCR_ID,
			  if(TPJR.ITER is null, -1, TPJR.ITER) ITER, 
			  RCR.PRC_ID,
			  TAC_p.DD_TAC_ID TIPO_PROCEDIMIENTO_ID, 
			  TPO_p.DD_TPO_ID TIPO_PROCEDIMIENTO_DET_ID, 
			  TAC.DD_TAC_ID FASE_ACTUAL_ID, 
			  TPO.DD_TPO_ID FASE_ANTERIOR_DETALLE_ID, 
			  RCR.DD_ACT_ID,
			  RCR.DD_DTR_ID,
			  RCR.DD_CRE_ID,
			  RCR.DD_DRR_ID,
			  RCR.DD_FAV_ID,
			  RCR.TAR_ID,
			  if(RCR.RCR_FECHA_RECURSO is null, '0001-01-01',RCR.RCR_FECHA_RECURSO) RCR_FECHA_RECURSO,
			  if(RCR.RCR_FECHA_IMPUGNACION is null, '0001-01-01', RCR.RCR_FECHA_IMPUGNACION) RCR_FECHA_IMPUGNACION,
			  if(RCR.RCR_FECHA_VISTA is null, '0001-01-01', RCR.RCR_FECHA_VISTA) RCR_FECHA_VISTA,
			  if(RCR.RCR_FECHA_RESOLUCION is null, '0001-01-01', RCR.RCR_FECHA_RESOLUCION) RCR_FECHA_RESOLUCION,
			  RCR.RCR_OBSERVACIONES,
			  RCR.RCR_OBSERVACIONES_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_RESOLUCION,
			  RCR.RCR_CONFIRM_VISTA,
			  RCR.RCR_CONFIRM_IMPUGNACION,
			  RCR.RCR_OBSERVACIONES_VISTA,
			  RCR.RCR_SUSPENSIVO,
			  1 DUMMY,
			  4 ENTIDAD_CEDENTE_ID,
			  TPJR.NUM_CONTRATOS,
  			  TPJR.SALDO_VENCIDO,         
  			  TPJR.SALDO_NO_VENCIDO,
  			  TPJR.INGRESOS_PENDIENTES_APLICAR,
  		 	  TPJR.SUBTOTAL
			FROM `bi_cdd_cajamar_datastage`.RCR_RECURSOS_PROCEDIMIENTOS RCR
				left join TMP_PRC_JERARQUIA_REC TPJR on TPJR.FASE_ACTUAL = RCR.PRC_ID AND TPJR.ENTIDAD_CEDENTE_ID = 4
				
				LEFT JOIN `bi_cdd_cajamar_datastage`.PRC_PROCEDIMIENTOS PRC_p ON PRC_p.PRC_ID=TPJR.FASE_ACTUAL
				LEFT JOIN `bi_cdd_cajamar_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO_p ON TPO_p.DD_TPO_ID=PRC_p.DD_TPO_ID
				LEFT JOIN `bi_cdd_cajamar_datastage`.DD_TAC_TIPO_ACTUACION TAC_p ON TAC_p.DD_TAC_ID=TPO_p.DD_TAC_ID
				
				LEFT JOIN `bi_cdd_cajamar_datastage`.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=RCR.PRC_ID
				LEFT JOIN `bi_cdd_cajamar_datastage`.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID=PRC.DD_TPO_ID
				LEFT JOIN `bi_cdd_cajamar_datastage`.DD_TAC_TIPO_ACTUACION TAC ON TAC.DD_TAC_ID=TPO.DD_TAC_ID
			WHERE RCR.FECHACREAR <= fecha
		) HH
	;
     
end loop;
close c_fecha;





truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_EXP where DIA_ID between date_start and date_end;
update TMP_FECHA set SEMANA_H = (select SEMANA_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);



set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

	
    delete from H_PRC_RECURSOS_MES where MES_ID = mes;
    
    
    set max_dia_mes = (select max(DIA_H) from TMP_FECHA where MES_H = mes);
    
    
    set max_dia_mes = (select max(DIA_H) from TMP_FECHA where MES_H = mes);
    
    insert into H_PRC_RECURSOS_MES
        (DIA_ID,
        MES_ID,
		FECHA_CARGA_DATOS,
		RECURSO_ID,
		PROCEDIMIENTO_ID,
		
		PROCEDIMIENTO_PARALIZADO_ID,		
		TIPO_PROCEDIMIENTO_ID,
		TIPO_PROCEDIMIENTO_DET_ID,
		FASE_ACTUAL_ID,
		FASE_ACTUAL_DETALLE_ID,
		
		ACTOR_ID,
		TIPO_RECURSO_ID,
		CAUSA_RECURSO_ID,
		ES_FAVORABLE_ID,
		RESULTADO_RESOL_ID,
		TAREA_ID,
		FECHA_RECURSO,
		FECHA_IMPUGNACION,
		FECHA_VISTA,
		FECHA_RESOLUCION,
		RCR_OBSERVACIONES,
		OBSERVACIONES_IMPUGNACION,
		OBSERVACIONES_RESOLUCION,
		CONFIRM_VISTA_ID,
		CONFIRM_IMPUGNACION_ID,
		OBSERVACIONES_VISTA,
		SUSPENSIVO_ID,
		COL_DUMMY,
		ENTIDAD_CEDENTE_ID,
		NUM_CONTRATOS,
  		SALDO_VENCIDO,         
  		SALDO_NO_VENCIDO,
  		INGRESOS_PENDIENTES_APLICAR,
  		SUBTOTAL
        )
    select distinct  
    	rec.DIA_ID,
    	mes, 
        max_dia_mes,
		rec.RECURSO_ID,
		rec.PROCEDIMIENTO_ID,
		rec.PROCEDIMIENTO_PARALIZADO_ID,		
		rec.TIPO_PROCEDIMIENTO_ID,
		rec.TIPO_PROCEDIMIENTO_DET_ID,
		rec.FASE_ACTUAL_ID,
		rec.FASE_ACTUAL_DETALLE_ID,
		rec.ACTOR_ID,
		rec.TIPO_RECURSO_ID,
		rec.CAUSA_RECURSO_ID,
		rec.ES_FAVORABLE_ID,
		rec.RESULTADO_RESOL_ID,
		rec.TAREA_ID,
		rec.FECHA_RECURSO,
		rec.FECHA_IMPUGNACION,
		rec.FECHA_VISTA,
		rec.FECHA_RESOLUCION,
		rec.RCR_OBSERVACIONES,
		rec.OBSERVACIONES_IMPUGNACION,
		rec.OBSERVACIONES_RESOLUCION,
		rec.CONFIRM_VISTA_ID,
		rec.CONFIRM_IMPUGNACION_ID,
		rec.OBSERVACIONES_VISTA,
		rec.SUSPENSIVO_ID,
		rec.COL_DUMMY,
		rec.ENTIDAD_CEDENTE_ID,
		rec.NUM_CONTRATOS,
  		rec.SALDO_VENCIDO,         
  		rec.SALDO_NO_VENCIDO,
  		rec.INGRESOS_PENDIENTES_APLICAR,
  		rec.SUBTOTAL
    from H_PRC_RECURSOS rec
    where rec.DIA_ID = max_dia_mes
    ;
   
end loop c_meses_loop;
close c_meses;





truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_EXP where DIA_ID between date_start and date_end;
update TMP_FECHA set SEMANA_H = (select SEMANA_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);


set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    
    delete from H_PRC_RECURSOS_TRIMESTRE where TRIMESTRE_ID = trimestre;
    
    
    set max_dia_trimestre = (select max(DIA_H) from TMP_FECHA where TRIMESTRE_H = trimestre);
    
    insert into H_PRC_RECURSOS_TRIMESTRE
        (
        TRIMESTRE_ID,   
        FECHA_CARGA_DATOS,
        RECURSO_ID,
        PROCEDIMIENTO_ID,
		
		PROCEDIMIENTO_PARALIZADO_ID,		
		TIPO_PROCEDIMIENTO_ID,
		TIPO_PROCEDIMIENTO_DET_ID,
		FASE_ACTUAL_ID,
		FASE_ACTUAL_DETALLE_ID,
		
		ACTOR_ID,
		TIPO_RECURSO_ID,
		CAUSA_RECURSO_ID,
		ES_FAVORABLE_ID,
		RESULTADO_RESOL_ID,
		TAREA_ID,
		FECHA_RECURSO,
		FECHA_IMPUGNACION,
		FECHA_VISTA,
		FECHA_RESOLUCION,
		RCR_OBSERVACIONES,
		OBSERVACIONES_IMPUGNACION,
		OBSERVACIONES_RESOLUCION,
		CONFIRM_VISTA_ID,
		CONFIRM_IMPUGNACION_ID,
		OBSERVACIONES_VISTA,
		SUSPENSIVO_ID,
		COL_DUMMY,
		ENTIDAD_CEDENTE_ID,
		NUM_CONTRATOS,
  		SALDO_VENCIDO,         
  		SALDO_NO_VENCIDO,
  		INGRESOS_PENDIENTES_APLICAR,
  		SUBTOTAL
        )
    select distinct  
    	trimestre, 
        max_dia_trimestre,
        rec.RECURSO_ID,
        rec.PROCEDIMIENTO_ID,
		rec.PROCEDIMIENTO_PARALIZADO_ID,		
		rec.TIPO_PROCEDIMIENTO_ID,
		rec.TIPO_PROCEDIMIENTO_DET_ID,
		rec.FASE_ACTUAL_ID,
		rec.FASE_ACTUAL_DETALLE_ID,
		rec.ACTOR_ID,
		rec.TIPO_RECURSO_ID,
		rec.CAUSA_RECURSO_ID,
		rec.ES_FAVORABLE_ID,
		rec.RESULTADO_RESOL_ID,
		rec.TAREA_ID,
		rec.FECHA_RECURSO,
		rec.FECHA_IMPUGNACION,
		rec.FECHA_VISTA,
		rec.FECHA_RESOLUCION,
		rec.RCR_OBSERVACIONES,
		rec.OBSERVACIONES_IMPUGNACION,
		rec.OBSERVACIONES_RESOLUCION,
		rec.CONFIRM_VISTA_ID,
		rec.CONFIRM_IMPUGNACION_ID,
		rec.OBSERVACIONES_VISTA,
		rec.SUSPENSIVO_ID,
		rec.COL_DUMMY,
		rec.ENTIDAD_CEDENTE_ID,
		rec.NUM_CONTRATOS,
  		rec.SALDO_VENCIDO,         
  		rec.SALDO_NO_VENCIDO,
  		rec.INGRESOS_PENDIENTES_APLICAR,
  		rec.SUBTOTAL
    from H_PRC_RECURSOS rec
    where rec.DIA_ID = max_dia_trimestre
    ;

end loop c_trimestre_loop;
close c_trimestre;





truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_EXP where DIA_ID between date_start and date_end;
update TMP_FECHA set SEMANA_H = (select SEMANA_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);


set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    
    delete from H_PRC_RECURSOS_ANIO where ANIO_ID = anio;
    
    
    set max_dia_anio = (select max(DIA_H) from TMP_FECHA where ANIO_H = anio);
    
    insert into H_PRC_RECURSOS_ANIO
        (ANIO_ID,      
        FECHA_CARGA_DATOS,
        RECURSO_ID,
        PROCEDIMIENTO_ID,
		
		PROCEDIMIENTO_PARALIZADO_ID,		
		TIPO_PROCEDIMIENTO_ID,
		TIPO_PROCEDIMIENTO_DET_ID,
		FASE_ACTUAL_ID,
		FASE_ACTUAL_DETALLE_ID,
		
		ACTOR_ID,
		TIPO_RECURSO_ID,
		CAUSA_RECURSO_ID,
		ES_FAVORABLE_ID,
		RESULTADO_RESOL_ID,
		TAREA_ID,
		FECHA_RECURSO,
		FECHA_IMPUGNACION,
		FECHA_VISTA,
		FECHA_RESOLUCION,
		RCR_OBSERVACIONES,
		OBSERVACIONES_IMPUGNACION,
		OBSERVACIONES_RESOLUCION,
		CONFIRM_VISTA_ID,
		CONFIRM_IMPUGNACION_ID,
		OBSERVACIONES_VISTA,
		SUSPENSIVO_ID,
		COL_DUMMY,
		ENTIDAD_CEDENTE_ID,
		NUM_CONTRATOS,
  		SALDO_VENCIDO,         
  		SALDO_NO_VENCIDO,
  		INGRESOS_PENDIENTES_APLICAR,
  		SUBTOTAL
        )
    select distinct  
    	anio,   
        max_dia_anio,
        rec.RECURSO_ID,
        rec.PROCEDIMIENTO_ID,
		rec.PROCEDIMIENTO_PARALIZADO_ID,		
		rec.TIPO_PROCEDIMIENTO_ID,
		rec.TIPO_PROCEDIMIENTO_DET_ID,
		rec.FASE_ACTUAL_ID,
		rec.FASE_ACTUAL_DETALLE_ID,
		rec.ACTOR_ID,
		rec.TIPO_RECURSO_ID,
		rec.CAUSA_RECURSO_ID,
		rec.ES_FAVORABLE_ID,
		rec.RESULTADO_RESOL_ID,
		rec.TAREA_ID,
		rec.FECHA_RECURSO,
		rec.FECHA_IMPUGNACION,
		rec.FECHA_VISTA,
		rec.FECHA_RESOLUCION,
		rec.RCR_OBSERVACIONES,
		rec.OBSERVACIONES_IMPUGNACION,
		rec.OBSERVACIONES_RESOLUCION,
		rec.CONFIRM_VISTA_ID,
		rec.CONFIRM_IMPUGNACION_ID,
		rec.OBSERVACIONES_VISTA,
		rec.SUSPENSIVO_ID,
		rec.COL_DUMMY,
		rec.ENTIDAD_CEDENTE_ID,
		rec.NUM_CONTRATOS,
  		rec.SALDO_VENCIDO,         
  		rec.SALDO_NO_VENCIDO,
  		rec.INGRESOS_PENDIENTES_APLICAR,
  		rec.SUBTOTAL
    from H_PRC_RECURSOS rec
    where rec.DIA_ID = max_dia_anio
    ;

end loop c_anio_loop;
close c_anio;
    
END MY_BLOCK_H_PCR_RECUR

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS `Cargar_H_Procedimiento` $$
CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_H_Procedimiento`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_PRC: BEGIN












 



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
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: Número de parámetros incorrecto'; 




DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

 




delete from H_PRC where DIA_ID between date_start and date_end;

delete from H_PRC_DET_CONTRATO where DIA_ID between date_start and date_end;


truncate table TMP_PRC_CODIGO_PRIORIDAD;


insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P198', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P199', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P95', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P35', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P56', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P63', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P64', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P24', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P25', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P26', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P27', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P28', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P29', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P30', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P31', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P34', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P01', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P02', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P15', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P17', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P55', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P62', 3);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P03', 2);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P04', 2);
insert into TMP_PRC_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P16', 1);





TRUNCATE TABLE TMP_PRC_JERARQUIA;

INSERT INTO TMP_PRC_JERARQUIA (
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
    	2 
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
        3 
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
        4 
    FROM bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
    	LEFT JOIN TMP_PRC_CODIGO_PRIORIDAD ON PRC_TPO = DD_TPO_CODIGO  
	 WHERE PRC_TPO != 'P22'      
    ) HH
WHERE HH.FECHA_PROCEDIMIENTO BETWEEN DATE_START AND DATE_END
;















SET L_LAST_ROW = 0; 

OPEN C_FECHA_RELLENAR;
RELLENAR_LOOP: LOOP
FETCH C_FECHA_RELLENAR INTO FECHA_RELLENAR;        
    IF (L_LAST_ROW=1) THEN LEAVE RELLENAR_LOOP; 
    END IF;
    
    
    IF((SELECT COUNT(DIA_ID) FROM TMP_PRC_JERARQUIA WHERE DIA_ID = FECHA_RELLENAR) = 0) THEN 
    INSERT INTO TMP_PRC_JERARQUIA(
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
        FROM TMP_PRC_JERARQUIA WHERE DIA_ID = DATE_ADD(FECHA_RELLENAR, INTERVAL -1 DAY);
    END IF; 
    
    















END LOOP;
CLOSE C_FECHA_RELLENAR;







SET L_LAST_ROW = 0; 

OPEN C_FECHA;
READ_LOOP: LOOP
FETCH C_FECHA INTO FECHA;        
    IF (L_LAST_ROW=1) THEN LEAVE READ_LOOP; 
    END IF;
  
    TRUNCATE TMP_PRC_DETALLE;
    INSERT INTO TMP_PRC_DETALLE (ITER, ENTIDAD_CEDENTE_ID) 
    	SELECT DISTINCT ITER, ENTIDAD_CEDENTE_ID FROM TMP_PRC_JERARQUIA WHERE DIA_ID = FECHA;

    
    
    UPDATE TMP_PRC_DETALLE PD SET 
        MAX_PRIORIDAD = (SELECT MAX(PRIORIDAD_FASE) FROM TMP_PRC_JERARQUIA PJ WHERE PJ.DIA_ID = FECHA AND PJ.ITER = PD.ITER)
    ;
   
    
    UPDATE TMP_PRC_JERARQUIA PJ SET 
        PRIORIDAD_PROCEDIMIENTO = (SELECT MAX_PRIORIDAD 
								   FROM TMP_PRC_DETALLE PD 
								   WHERE PD.ITER = PJ.ITER
										AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
									) 
    WHERE DIA_ID = FECHA
    ; 
   
    
	
    UPDATE TMP_PRC_DETALLE PD 
        SET FASE_MAX_PRIORIDAD = (SELECT MAX(FASE_ACTUAL) 
                                  FROM TMP_PRC_JERARQUIA PJ 
                                  WHERE PJ.DIA_ID = FECHA 
										AND PJ.ITER = PD.ITER 										
										AND PJ.PRIORIDAD_PROCEDIMIENTO = PJ.PRIORIDAD_FASE
										AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
								 )
    ;
    
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET FASE_MAX_PRIORIDAD = (SELECT FASE_MAX_PRIORIDAD 
                                  FROM TMP_PRC_DETALLE PD 
                                  WHERE PD.ITER = PJ.ITER
										AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
								  ) 
    WHERE DIA_ID = FECHA
    ; 


    
    
    UPDATE TMP_PRC_DETALLE PD 
        SET NUM_FASES = (SELECT COUNT(1) 
						 FROM TMP_PRC_JERARQUIA PJ 
						 WHERE PJ.DIA_ID = FECHA 
							AND PJ.ITER = PD.ITER
							AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
						)
    ;
    
    
    UPDATE TMP_PRC_DETALLE PD 
        SET CANCELADO_FASE = (SELECT SUM(CANCELADO_FASE) 
							  FROM TMP_PRC_JERARQUIA PJ 
							  WHERE PJ.DIA_ID = FECHA 
									AND PJ.ITER = PD.ITER
									AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							  )
    ;
    
    UPDATE TMP_PRC_DETALLE 
        SET CANCELADO_PROCEDIMIENTO = (CASE WHEN NUM_FASES = CANCELADO_FASE THEN 1 ELSE 0 END)
    ;
    
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET CANCELADO_PROCEDIMIENTO = (SELECT CANCELADO_PROCEDIMIENTO 
									   FROM TMP_PRC_DETALLE PD 
									   WHERE PD.ITER = PJ.ITER
											AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
									  ) 
	WHERE DIA_ID = FECHA
    ;

    






    
    TRUNCATE TABLE TMP_PRC_TAREA;
    
	INSERT INTO TMP_PRC_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, ENTIDAD_CEDENTE_ID)
    SELECT 
        TPJ.ITER, 
        TPJ.FASE_ACTUAL, 
        TAR.TAR_ID, 
        TAR.TAR_FECHA_INI, 
        COALESCE(TAR.TAR_FECHA_FIN, '0000-00-00 00:00:00'), 
        TAR.TAR_TAREA, 
        TPJ.ENTIDAD_CEDENTE_ID 
	FROM TMP_PRC_JERARQUIA TPJ
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
	FROM TMP_PRC_JERARQUIA TPJ2
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
	FROM TMP_PRC_JERARQUIA TPJ3
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
	FROM TMP_PRC_JERARQUIA TPJ4
        JOIN bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES TAR4 ON TPJ4.FASE_ACTUAL = TAR4.PRC_ID 
        	AND TPJ4.ENTIDAD_CEDENTE_ID = 4
    WHERE TPJ4.DIA_ID = FECHA  AND DATE(TAR4.TAR_FECHA_INI) <= FECHA    
;


    
    
	
    TRUNCATE TMP_PRC_AUTO_PRORROGAS;
    
    INSERT INTO TMP_PRC_AUTO_PRORROGAS (TAREA, FECHA_AUTO_PRORROGA, ENTIDAD_CEDENTE_ID) 
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

    
    
    
    
 	UPDATE TMP_PRC_TAREA PT SET FECHA_AUTO_PRORROGA = (
 		SELECT COALESCE(MAX(FECHA_AUTO_PRORROGA), '0000-00-00 00:00:00') 
 		FROM TMP_PRC_AUTO_PRORROGAS TPA 
 		WHERE TPA.TAREA = PT.TAREA 
 			AND TPA.ENTIDAD_CEDENTE_ID = PT.ENTIDAD_CEDENTE_ID)
	;  

	
	UPDATE TMP_PRC_TAREA PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_bng_datastage.SPR_SOLICITUD_PRORROGA SPR 
 		WHERE SPR.TAR_ID = PT.TAREA AND DATE(SPR.FECHACREAR) <= FECHA
 			AND 1 = PT.ENTIDAD_CEDENTE_ID
 	)
 	;
 	
	
	UPDATE TMP_PRC_TAREA PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_bbva_datastage.SPR_SOLICITUD_PRORROGA SPR2 
 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA
 			AND 2 = PT.ENTIDAD_CEDENTE_ID
 	);
 	
	
	UPDATE TMP_PRC_TAREA PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_bankia_datastage.SPR_SOLICITUD_PRORROGA SPR2 
 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA
 			AND 3 = PT.ENTIDAD_CEDENTE_ID
 	); 	
 	
	
	UPDATE TMP_PRC_TAREA PT SET FECHA_PRORROGA = (
 		SELECT COALESCE(MAX(FECHACREAR), '0000-00-00 00:00:00') 
 		FROM bi_cdd_cajamar_datastage.SPR_SOLICITUD_PRORROGA SPR2 
 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA
 			AND 4 = PT.ENTIDAD_CEDENTE_ID
 	);  	

    
    UPDATE TMP_PRC_TAREA PT 
        SET NUM_AUTO_PRORROGAS = (	
				SELECT COUNT(1) 
				FROM TMP_PRC_AUTO_PRORROGAS TP 
				WHERE PT.TAREA = TP.TAREA 
					AND DATE(TP.FECHA_AUTO_PRORROGA) <= FECHA 
					AND FECHA_AUTO_PRORROGA <>'0000-00-00 00:00:00'
					AND PT.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
				)
    ;

    
    UPDATE TMP_PRC_TAREA PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_bng_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 1
    ; 

    
    UPDATE TMP_PRC_TAREA PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_bbva_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 2
    ;  

    
    UPDATE TMP_PRC_TAREA PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_bankia_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 3
    ;    

    
    
    UPDATE TMP_PRC_TAREA PT 
        SET NUM_PRORROGAS = (
		 		SELECT COUNT(1) 
		 		FROM bi_cdd_cajamar_datastage.SPR_SOLICITUD_PRORROGA SPR2 
		 		WHERE SPR2.TAR_ID = PT.TAREA AND DATE(SPR2.FECHACREAR) <= FECHA		 			
 			)
 	WHERE PT.ENTIDAD_CEDENTE_ID = 4
    ;    


    
    
    
    
    
    UPDATE TMP_PRC_DETALLE PD 
        SET FECHA_ULT_TAR_CREADA = (SELECT MAX(FECHA_INI) 
        							FROM TMP_PRC_TAREA TP 
        							WHERE PD.ITER = TP.ITER 
        								AND DATE(TP.FECHA_INI) <= FECHA 
        								AND FECHA_INI<>'0000-00-00 00:00:00'
        								AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        							)
    ;
    
    
    
    
    UPDATE TMP_PRC_DETALLE PD 
        SET ULT_TAR_CREADA = (SELECT MAX(TAREA) 
        					  FROM TMP_PRC_TAREA TP 
        					  WHERE PD.ITER = TP.ITER 
        					  	AND TP.FECHA_INI = PD.FECHA_ULT_TAR_CREADA
        					  	AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        					  )
    ;
    
   
    UPDATE TMP_PRC_DETALLE PD 
        SET FECHA_ULT_TAR_FIN = (SELECT MAX(FECHA_FIN) 
        						 FROM TMP_PRC_TAREA TP 
        						 WHERE PD.ITER = TP.ITER 
        						 	AND DATE(TP.FECHA_FIN) <= FECHA 
        						 	AND FECHA_FIN<>'0000-00-00 00:00:00'
        						 	AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        						 )
    ;
    
    UPDATE TMP_PRC_DETALLE PD 
        SET ULT_TAR_FIN = (SELECT MAX(TAREA) 
        				   FROM TMP_PRC_TAREA TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.FECHA_FIN = PD.FECHA_ULT_TAR_FIN
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    
        
    
    
    
    UPDATE TMP_PRC_TAREA 
        SET FECHA_ACTUALIZACION = FECHA_INI 
    WHERE DATE(FECHA_INI) <= FECHA
    ;
    
    UPDATE TMP_PRC_TAREA 
        SET FECHA_ACTUALIZACION = FECHA_FIN 
    WHERE FECHA_FIN >= FECHA_ACTUALIZACION AND DATE(FECHA_FIN) <= FECHA
    ;
    
	
	
    UPDATE TMP_PRC_TAREA 
        SET FECHA_ACTUALIZACION = FECHA_PRORROGA 
    WHERE FECHA_PRORROGA >= FECHA_ACTUALIZACION AND DATE(FECHA_PRORROGA) <= FECHA
    ;
    
    UPDATE TMP_PRC_TAREA 
        SET FECHA_ACTUALIZACION = FECHA_AUTO_PRORROGA 
    WHERE FECHA_PRORROGA >= FECHA_ACTUALIZACION AND DATE(FECHA_AUTO_PRORROGA) <= FECHA
    ;


   
    
    
    
    UPDATE TMP_PRC_DETALLE PD 
        SET FECHA_ULTIMA_TAREA_ACTUALIZADA = (SELECT MAX(FECHA_ACTUALIZACION) 
        									  FROM TMP_PRC_TAREA TP 
        									  WHERE PD.ITER = TP.ITER 
        									  		AND TP.FECHA_ACTUALIZACION<>'0000-00-00 00:00:00'
        									  		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        									  )
    ;
    
    UPDATE TMP_PRC_DETALLE PD 
        SET ULTIMA_TAREA_ACTUALIZADA = (SELECT MAX(TAREA) 
        								FROM TMP_PRC_TAREA TP 
        								WHERE PD.ITER = TP.ITER 
        									AND TP.FECHA_ACTUALIZACION = PD.FECHA_ULTIMA_TAREA_ACTUALIZADA
        									AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        								)
    ;
    
    
    UPDATE TMP_PRC_DETALLE PD 
        SET FECHA_ULT_TAR_PEND = (SELECT MAX(FECHA_INI) 
                                  FROM TMP_PRC_TAREA TP 
                                  WHERE PD.ITER = TP.ITER 
                                  		AND DATE(TP.FECHA_INI) <= FECHA 
                                  		AND FECHA_INI<>'0000-00-00 00:00:00' 
                                  		AND FECHA_FIN = '0000-00-00 00:00:00'
                                  		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
                                  )
    ;
    
    UPDATE TMP_PRC_DETALLE PD 
        SET ULT_TAR_PEND = (SELECT MAX(TAREA) 
        					FROM TMP_PRC_TAREA TP 
        					WHERE PD.ITER = TP.ITER 
        						AND TP.FECHA_INI = PD.FECHA_ULT_TAR_PEND
        						AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        					)
    ;

	
    
	  
    UPDATE TMP_PRC_DETALLE PD 
        SET FECHA_ULTIMA_AUTO_PRORROGA = (
        				   SELECT MAX(TP.FECHA_AUTO_PRORROGA) 
        				   FROM TMP_PRC_TAREA TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    

    
	  
    UPDATE TMP_PRC_DETALLE PD 
        SET FECHA_ULTIMA_PRORROGA = (
        				   SELECT MAX(TP.FECHA_PRORROGA) 
        				   FROM TMP_PRC_TAREA TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    
    
	  
    UPDATE TMP_PRC_DETALLE PD 
        SET NUM_AUTO_PRORROGA = (
        				   SELECT MAX(TP.NUM_AUTO_PRORROGAS) 
        				   FROM TMP_PRC_TAREA TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;
    
 	
	  
    UPDATE TMP_PRC_DETALLE PD 
        SET NUM_PRORROGA = (
        				   SELECT MAX(TP.NUM_PRORROGAS)
        				   FROM TMP_PRC_TAREA TP 
        				   WHERE PD.ITER = TP.ITER 
        				   		AND TP.TAREA = PD.ULT_TAR_PEND
        				   		AND PD.ENTIDAD_CEDENTE_ID = TP.ENTIDAD_CEDENTE_ID
        				   	)
    ;

   
    
    
    
    
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET ULT_TAR_CREADA = (SELECT ULT_TAR_CREADA 
        					  FROM TMP_PRC_DETALLE PD 
        					  WHERE PD.ITER = PJ.ITER
        					  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					  ) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET FECHA_ULT_TAR_CREADA = (SELECT FECHA_ULT_TAR_CREADA 
        							FROM TMP_PRC_DETALLE PD 
        							WHERE PD.ITER = PJ.ITER
        								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        							) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET ULT_TAR_FIN = (	SELECT ULT_TAR_FIN 
        					FROM TMP_PRC_DETALLE PD 
        					WHERE PD.ITER = PJ.ITER
        						AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET FECHA_ULT_TAR_FIN = (SELECT FECHA_ULT_TAR_FIN 
        						 FROM TMP_PRC_DETALLE PD 
        						 WHERE PD.ITER = PJ.ITER
        						 	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        						 ) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET ULTIMA_TAREA_ACTUALIZADA = (SELECT ULTIMA_TAREA_ACTUALIZADA 
        								FROM TMP_PRC_DETALLE PD 
        								WHERE PD.ITER = PJ.ITER
        									AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        								) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET FECHA_ULTIMA_TAREA_ACTUALIZADA = (SELECT FECHA_ULTIMA_TAREA_ACTUALIZADA 
        									  FROM TMP_PRC_DETALLE PD 
        									  WHERE PD.ITER = PJ.ITER
        									  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        									  ) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET ULT_TAR_PEND = (SELECT ULT_TAR_PEND 
        					FROM TMP_PRC_DETALLE PD 
        					WHERE PD.ITER = PJ.ITER
        						AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					) 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET FECHA_ULT_TAR_PEND = (SELECT FECHA_ULT_TAR_PEND 
        						  FROM TMP_PRC_DETALLE PD 
        						  WHERE PD.ITER = PJ.ITER
        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        						  ) 
    WHERE DIA_ID = FECHA
    ;   


	
	
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET FECHA_ULTIMA_AUTO_PRORROGA = (SELECT FECHA_ULTIMA_AUTO_PRORROGA 
		        						  FROM TMP_PRC_DETALLE PD 
		        						  WHERE PD.ITER = PJ.ITER
		        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
		        						  ) 
    WHERE DIA_ID = FECHA
    ; 
    
    
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET FECHA_ULTIMA_PRORROGA = (SELECT FECHA_ULTIMA_PRORROGA 
		        						  FROM TMP_PRC_DETALLE PD 
		        						  WHERE PD.ITER = PJ.ITER
		        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
		        						  ) 
    WHERE DIA_ID = FECHA
    ;
      
	
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET NUM_AUTO_PRORROGA = (SELECT NUM_AUTO_PRORROGA 
        						 FROM TMP_PRC_DETALLE PD 
        						 WHERE PD.ITER = PJ.ITER
        						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        						) 
    WHERE DIA_ID = FECHA
    ; 
    
	
    UPDATE TMP_PRC_JERARQUIA PJ 
        SET NUM_PRORROGA = (SELECT NUM_PRORROGA 
    						 FROM TMP_PRC_DETALLE PD 
    						 WHERE PD.ITER = PJ.ITER
    						  	AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
    						) 
    WHERE DIA_ID = FECHA
    ;     
    
    
	
	
    UPDATE TMP_PRC_JERARQUIA PJ 
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
	
	
    UPDATE TMP_PRC_JERARQUIA PJ 
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

	
    UPDATE TMP_PRC_JERARQUIA PJ 
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
	
	
    UPDATE TMP_PRC_JERARQUIA PJ 
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
	
	
	
    UPDATE TMP_PRC_JERARQUIA PJ 
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
	
	
    UPDATE TMP_PRC_JERARQUIA PJ 
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

	
    UPDATE TMP_PRC_JERARQUIA PJ 
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
	
	
    UPDATE TMP_PRC_JERARQUIA PJ 
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

   
    
    
    UPDATE TMP_PRC_DETALLE PD 
        SET FASE_ACTUAL = (SELECT MAX(FASE) 
        					FROM TMP_PRC_TAREA PT 
        					WHERE PT.ITER = PD.ITER 
        						AND PT.TAREA = PD.ULT_TAR_CREADA
        						AND PD.ENTIDAD_CEDENTE_ID = PT.ENTIDAD_CEDENTE_ID
        					)
    ;
    
    UPDATE TMP_PRC_DETALLE PD 
        SET FASE_ACTUAL = (	SELECT MAX(FASE_ACTUAL) 
        					FROM TMP_PRC_JERARQUIA PJ 
        					WHERE PJ.DIA_ID = FECHA 
        						AND PJ.ITER = PD.ITER
        						AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
        					)
    WHERE FASE_ACTUAL IS NULL
    ;
                                                             
                                                             
     
    
    
    UPDATE TMP_PRC_JERARQUIA PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE PD 
								INNER JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA and PJ.ENTIDAD_CEDENTE_ID = 1 
	; 

    UPDATE TMP_PRC_JERARQUIA PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE PD 
								INNER JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA  and PJ.ENTIDAD_CEDENTE_ID = 2 
	; 

    UPDATE TMP_PRC_JERARQUIA PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE PD 
								INNER JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA and PJ.ENTIDAD_CEDENTE_ID = 3 
	; 

    UPDATE TMP_PRC_JERARQUIA PJ 
		SET ULTIMA_FASE = (	SELECT MAX(FASE_ACTUAL) 
							FROM TMP_PRC_DETALLE PD 
								INNER JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PD.ITER 
							WHERE PRC.ASU_ID = PJ.ASU_ID
								AND PD.ENTIDAD_CEDENTE_ID = PJ.ENTIDAD_CEDENTE_ID
							) 
	WHERE DIA_ID = FECHA and PJ.ENTIDAD_CEDENTE_ID = 4 
	; 


	
	TRUNCATE TMP_PRC_TAREA_STP1;
	
	INSERT INTO TMP_PRC_TAREA_STP1 (
			ITER, FASE, TAREA, FECHA_INI, 
			FECHA_FIN, FECHA_PRORROGA, FECHA_AUTO_PRORROGA, FECHA_ACTUALIZACION, 
			DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, 
			FECHA_FORMULARIO, ENTIDAD_CEDENTE_ID, NUM_AUTO_PRORROGAS, NUM_PRORROGAS
			)	
	SELECT 	ITER, FASE, TAREA, FECHA_INI, 
			FECHA_FIN, FECHA_PRORROGA, FECHA_AUTO_PRORROGA, FECHA_ACTUALIZACION, 
			DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, 
			FECHA_FORMULARIO, ENTIDAD_CEDENTE_ID, NUM_AUTO_PRORROGAS, NUM_PRORROGAS
	FROM TMP_PRC_TAREA
	;


  
    
	
	truncate table TMP_PRC_TAREA;
	
	insert into TMP_PRC_TAREA 
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
			from TMP_PRC_JERARQUIA tpj
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
			from TMP_PRC_JERARQUIA tpj
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
			from TMP_PRC_JERARQUIA tpj
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
			from TMP_PRC_JERARQUIA tpj
			    join bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
			    join bi_cdd_cajamar_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
			    join bi_cdd_cajamar_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
			where DIA_ID =  fecha and date(tar.TAR_FECHA_INI) <= fecha and
			    tev.TEV_NOMBRE IN ('fecha', 'fechaSolicitud', 'fechainterposicion', 'fechaInterposicion', 'fechaDemanda') 
			    and tex.tap_id in (229, 240, 256, 270, 281, 301, 317, 427)	    	    
    ;
                
        
    update TMP_PRC_DETALLE pd 
    	set FECHA_INTERPOSICION_DEMANDA = (select max(FECHA_FORMULARIO) 
    									   from TMP_PRC_TAREA tp 
    									   where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha and FECHA_FIN <> '0000-00-00 00:00:00'
    									   		AND pd.ENTIDAD_CEDENTE_ID = tp.ENTIDAD_CEDENTE_ID
    									   );
    									   
    update TMP_PRC_JERARQUIA pj 
    	set FECHA_INTERPOSICION_DEMANDA = (select FECHA_INTERPOSICION_DEMANDA 
    									   from TMP_PRC_DETALLE pd 
    									   where pd.ITER = pj.ITER
    									   		AND pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID
    									   ) 
   	where DIA_ID = fecha; 

 
    













    
    truncate table TMP_PRC_CONTRATO;
    
    
	set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from bi_cdd_bng_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);
    
    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, h_mov.CNT_ID, cex.CEX_ID, h_mov.MOV_POS_VIVA_VENCIDA, h_mov.MOV_POS_VIVA_NO_VENCIDA, h_mov.MOV_EXTRA_1, h_mov.MOV_FECHA_POS_VENCIDA, 1 
	from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bng_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bng_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
		join bi_cdd_bng_datastage.MOV_MOVIMIENTOS h_mov on cex.CNT_ID = h_mov.CNT_ID
	
	where MOV_FECHA_EXTRACCION = max_dia_con_contratos
    ;
  

    set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);
    
    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, h_mov.CNT_ID, cex.CEX_ID, h_mov.MOV_POS_VIVA_VENCIDA, h_mov.MOV_POS_VIVA_NO_VENCIDA, h_mov.MOV_EXTRA_1, h_mov.MOV_FECHA_POS_VENCIDA, 2 
	from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bbva_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bbva_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
		join bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h_mov on cex.CNT_ID = h_mov.CNT_ID
	
	where MOV_FECHA_EXTRACCION = max_dia_con_contratos
    ;    

    

	set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);	

    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
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
    
    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, h_mov.CNT_ID, cex.CEX_ID, h_mov.MOV_POS_VIVA_VENCIDA, h_mov.MOV_POS_VIVA_NO_VENCIDA, h_mov.MOV_EXTRA_1, h_mov.MOV_FECHA_POS_VENCIDA, 4 
	from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_cajamar_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_cajamar_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
		join bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h_mov on cex.CNT_ID = h_mov.CNT_ID
	
	where MOV_FECHA_EXTRACCION = max_dia_con_contratos
    ; 	  

        
	
    
    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 1 
	from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bng_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bng_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO WHERE ENTIDAD_CEDENTE_ID = 1);

    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 2
	from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bbva_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bbva_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO WHERE ENTIDAD_CEDENTE_ID = 2);


    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 3
	from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_bankia_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_bankia_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO WHERE ENTIDAD_CEDENTE_ID = 3);


    insert into TMP_PRC_CONTRATO (ITER, CONTRATO, ENTIDAD_CEDENTE_ID)
    select prc.PRC_ID, cex.CNT_ID, 4 
	from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc
		join bi_cdd_cajamar_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
		join bi_cdd_cajamar_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
    where cex.CEX_ID not in (select CEX_ID from TMP_PRC_CONTRATO WHERE ENTIDAD_CEDENTE_ID = 4);


	
    update TMP_PRC_CONTRATO tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =1;

    update TMP_PRC_CONTRATO tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =2;

    update TMP_PRC_CONTRATO tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =3;

    update TMP_PRC_CONTRATO tpc 
		set MAX_MOV_ID = (select max(MOV_ID) from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.CNT_ID = tpc.CONTRATO) 
	where tpc.CEX_ID is null and tpc.ENTIDAD_CEDENTE_ID =4;


    
    delete from TMP_PRC_CONTRATO where CEX_ID is null and MAX_MOV_ID is null;

    
    update TMP_PRC_CONTRATO tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO tpc 
		set SALDO_VENCIDO = (select h.MOV_POS_VIVA_VENCIDA from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null
			and ENTIDAD_CEDENTE_ID = 4;

	
    update TMP_PRC_CONTRATO tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO tpc 
		set SALDO_NO_VENCIDO = (select h.MOV_POS_VIVA_NO_VENCIDA from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 4;

	
    update TMP_PRC_CONTRATO tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO tpc 
		set INGRESOS_PENDIENTES_APLICAR = (select h.MOV_EXTRA_1 from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 4;

	
    update TMP_PRC_CONTRATO tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_bng_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 1;

    update TMP_PRC_CONTRATO tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_bbva_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 2;

    update TMP_PRC_CONTRATO tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_bankia_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 3;

    update TMP_PRC_CONTRATO tpc 
		set FECHA_POS_VENCIDA = (select h.MOV_FECHA_POS_VENCIDA from bi_cdd_cajamar_datastage.MOV_MOVIMIENTOS h where h.MOV_ID = tpc.MAX_MOV_ID and h.CNT_ID = tpc.CONTRATO) 
	where CEX_ID is null and ENTIDAD_CEDENTE_ID = 4;

	


   
   update TMP_PRC_DETALLE pd 
		set pd.SALDO_VENCIDO = (select sum(pc.SALDO_VENCIDO) 
								from TMP_PRC_CONTRATO pc 
								where pc.ITER = pd.FASE_ACTUAL 
									and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

    update TMP_PRC_DETALLE pd 
		set pd.SALDO_NO_VENCIDO = (	select sum(pc.SALDO_NO_VENCIDO) 
									from TMP_PRC_CONTRATO pc 
									where pc.ITER = pd.FASE_ACTUAL and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

    update TMP_PRC_DETALLE pd 
		set pd.INGRESOS_PENDIENTES_APLICAR = (	select sum(pc.INGRESOS_PENDIENTES_APLICAR) 
											from TMP_PRC_CONTRATO pc 
											where pc.ITER = pd.FASE_ACTUAL  and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

    update TMP_PRC_DETALLE pd 
		set pd.NUM_CONTRATOS = (select count(*) from TMP_PRC_CONTRATO pc where pc.ITER = pd.FASE_ACTUAL and pd.ENTIDAD_CEDENTE_ID = pc.ENTIDAD_CEDENTE_ID);

    update TMP_PRC_JERARQUIA pj 
		set pj.SALDO_VENCIDO = (select SALDO_VENCIDO from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER and pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where pj.DIA_ID = fecha 
	; 


    update TMP_PRC_JERARQUIA pj 
		set SALDO_NO_VENCIDO = (select SALDO_NO_VENCIDO from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER  and pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where DIA_ID = fecha
	; 

    update TMP_PRC_JERARQUIA pj 
		set pj.INGRESOS_PENDIENTES_APLICAR = (select INGRESOS_PENDIENTES_APLICAR from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER and pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where pj.DIA_ID = fecha; 

    update TMP_PRC_JERARQUIA pj 
		set NUM_CONTRATOS = (select NUM_CONTRATOS from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER AND  pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where DIA_ID = fecha; 
    
    update TMP_PRC_JERARQUIA pj 
		set pj.SUBTOTAL = (select pd.INGRESOS_PENDIENTES_APLICAR from TMP_PRC_DETALLE pd where pd.ITER = pj.ITER AND  pd.ENTIDAD_CEDENTE_ID = pj.ENTIDAD_CEDENTE_ID) 
	where DIA_ID = fecha; 
  
    
	

    








  


    
    

    










    
    


    
    




    



    

  
    
    insert into H_PRC
    (
	    DIA_ID,                               
	    PROCEDIMIENTO_ID, 
	    FASE_ACTUAL,
	    ULT_TAR_CREADA,
	    ULT_TAR_FIN,
	    ULTIMA_TAREA_ACTUALIZADA,
	    ULT_TAR_PEND,
	    FECHA_CONTABLE_LITIGIO,
	    FECHA_ULT_TAR_CREADA,
	    FECHA_ULT_TAR_FIN, 
	    FECHA_ULTIMA_TAREA_ACTUALIZADA,  
	    FECHA_ULT_TAR_PEND,
	    FECHA_ACEPTACION,
	    FECHA_RECOGIDA_DOC_Y_ACEPT,
	    FECHA_REGISTRAR_TOMA_DECISION,
	    FECHA_RECEPCION_DOC_COMPLETA,
	    FECHA_INTERPOSICION_DEMANDA,
	    FECHA_ULTIMA_POSICION_VENCIDA,
	    FECHA_ULTIMA_ESTIMACION,
	    ASUNTO_ID,                                
	    FASE_MAX_PRIORIDAD, 
	    CONTEXTO_FASE,
	    NIVEL,
	    ESTADO_PROCEDIMIENTO_ID,               
	    CNT_GARANTIA_REAL_ASOC_ID,
	    CARTERA_PROCEDIMIENTO_ID,
	    TITULAR_PROCEDIMIENTO_ID,
	    NUM_PROCEDIMIENTOS,
	    NUM_FASES,
	    NUM_DIAS_ULT_ACTUALIZACION,
	    NUM_MAX_DIAS_CONTRATO_VENCIDO,
	    NUM_CONTRATOS,
	    SALDO_ACTUAL_VENCIDO,            
	    SALDO_ACTUAL_NO_VENCIDO,
	    SALDO_CONCURSOS_VENCIDO,
	    SALDO_CONCURSOS_NO_VENCIDO,
	    INGRESOS_PENDIENTES_APLICAR,
	    DURACION_ULT_TAREA_PENDIENTE,            
	    ENTIDAD_CEDENTE_ID, 
	    FECHA_CARGA_DATOS,
	    NUM_PRORROG_ULT_TAR_PEND, 		
	    FECHA_PRORROG_ULT_TAR_PEND,     
  	    NUM_AUTO_PRORROG_ULT_TAR_PEND,   
  	    FECHA_AUTO_PRORROG_ULT_TAR_PEND, 
	    NUM_PARALIZACIONES, 
	    PARALIZADO,
	    PLAZA_ID,
	    JUZGADO_ID,
	    PROCURADOR_ID
    )
    select 
        DIA_ID,                               
        ITER,   
        FASE_ACTUAL,
        ULT_TAR_CREADA,
        ULT_TAR_FIN,
        ULTIMA_TAREA_ACTUALIZADA,
        ULT_TAR_PEND,
        FECHA_CONTABLE_LITIGIO,
        FECHA_ULT_TAR_CREADA,
        FECHA_ULT_TAR_FIN, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA,
        FECHA_ULT_TAR_PEND,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPT,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        ASU_ID,
        FASE_MAX_PRIORIDAD,
        CONTEXTO,
        NIVEL, 
        CANCELADO_PROCEDIMIENTO,
        GARANTIA_CONTRATO,
        CARTERA,
        TITULAR_PROCEDIMIENTO,
        1,
        NUM_FASES,
        datediff(fecha, FECHA_ULTIMA_TAREA_ACTUALIZADA),
        NUM_DIAS_VENCIDO,
        NUM_CONTRATOS,
        SALDO_VENCIDO,         
        SALDO_NO_VENCIDO,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        INGRESOS_PENDIENTES_APLICAR,
        datediff(fecha, FECHA_ULT_TAR_PEND),
        ENTIDAD_CEDENTE_ID, 
        DIA_ID,
        NUM_PRORROGA,  
  	FECHA_ULTIMA_PRORROGA,
  	NUM_AUTO_PRORROGA,
  	FECHA_ULTIMA_AUTO_PRORROGA,
  	NUM_PARALIZACIONES,
  	PARALIZADO,
	-1,
	-1,
	-1
    from TMP_PRC_JERARQUIA 
    where DIA_ID = fecha and FASE_ACTUAL = ULTIMA_FASE
	;

    
    
    UPDATE H_PRC 
        SET FECHA_CREACION_ASUNTO = FECHA_CONTABLE_LITIGIO 
    WHERE DIA_ID = FECHA
    ;
    
    UPDATE H_PRC 
        SET TIPO_PROCEDIMIENTO_DET_ID = (SELECT DD_TPO_ID FROM bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS WHERE PRC_ID = FASE_MAX_PRIORIDAD) 
    WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 1 
    ;
    
	
	UPDATE H_PRC 
        SET TIPO_PROCEDIMIENTO_DET_ID = (SELECT DD_TPO_ID FROM bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS WHERE PRC_ID = FASE_MAX_PRIORIDAD) 
    WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 2 
    ;

	
	UPDATE H_PRC 
        SET TIPO_PROCEDIMIENTO_DET_ID = (SELECT DD_TPO_ID FROM bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS WHERE PRC_ID = FASE_MAX_PRIORIDAD) 
    WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 3 
    ;

	
	UPDATE H_PRC 
        SET TIPO_PROCEDIMIENTO_DET_ID = (SELECT DD_TPO_ID FROM bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS WHERE PRC_ID = FASE_MAX_PRIORIDAD) 
    WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 4 
    ;








update H_PRC PRC
	set FASE_ANTERIOR = (select PRC_PRC_ID from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 1 
;
	
update H_PRC PRC
	set FASE_ANTERIOR = (select PRC_PRC_ID from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 2 
;	
	
update H_PRC PRC
	set FASE_ANTERIOR = (select PRC_PRC_ID from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 3 
;	
	
update H_PRC PRC
	set FASE_ANTERIOR = (select PRC_PRC_ID from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 4 
;	
			

update H_PRC PRC
	set ESTADO_FASE_ACTUAL_ID = (select DD_EPR_ID from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 1 
;
	
update H_PRC PRC
	set ESTADO_FASE_ACTUAL_ID = (select DD_EPR_ID from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 2 
;
	
update H_PRC PRC
	set ESTADO_FASE_ACTUAL_ID = (select DD_EPR_ID from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 3 
;
	
update H_PRC PRC
	set ESTADO_FASE_ACTUAL_ID = (select DD_EPR_ID from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 4 
;
				

update H_PRC PRC
	set ESTADO_FASE_ANTERIOR_ID = (select DD_EPR_ID from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 1 
;
	
update H_PRC PRC
	set ESTADO_FASE_ANTERIOR_ID = (select DD_EPR_ID from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 2 
;
	
update H_PRC PRC
	set ESTADO_FASE_ANTERIOR_ID = (select DD_EPR_ID from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 3 
;
	
update H_PRC PRC
	set ESTADO_FASE_ANTERIOR_ID = (select DD_EPR_ID from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 4 
;			


update H_PRC PRC
	set FASE_ACTUAL_DETALLE_ID = (select DD_TPO_ID from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 1 
;
	
update H_PRC PRC
	set FASE_ACTUAL_DETALLE_ID = (select DD_TPO_ID from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 2 
;
	
update H_PRC PRC
	set FASE_ACTUAL_DETALLE_ID = (select DD_TPO_ID from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 3 
;
	
update H_PRC PRC
	set FASE_ACTUAL_DETALLE_ID = (select DD_TPO_ID from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 4 
;			


update H_PRC PRC
	set FASE_ANTERIOR_DETALLE_ID = (select DD_TPO_ID from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 1 
;

update H_PRC PRC
	set FASE_ANTERIOR_DETALLE_ID = (select DD_TPO_ID from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 2 
;
	
update H_PRC PRC
	set FASE_ANTERIOR_DETALLE_ID = (select DD_TPO_ID from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 3 
;
	
update H_PRC PRC
	set FASE_ANTERIOR_DETALLE_ID = (select DD_TPO_ID from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) 
where DIA_ID = fecha
	and PRC.ENTIDAD_CEDENTE_ID = 4 
;
		





UPDATE H_PRC 
    SET ULT_TAR_CREADA_TIPO_DET_ID = (SELECT (DD_STA_ID) FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = ULT_TAR_CREADA) 
WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 1 
;


UPDATE H_PRC 
    SET ULT_TAR_CREADA_TIPO_DET_ID = (SELECT (DD_STA_ID) FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = ULT_TAR_CREADA) 
WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 2 
;


UPDATE H_PRC 
    SET ULT_TAR_CREADA_TIPO_DET_ID = (SELECT (DD_STA_ID) FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = ULT_TAR_CREADA) 
WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 3 
;


UPDATE H_PRC 
    SET ULT_TAR_CREADA_TIPO_DET_ID = (SELECT (DD_STA_ID) FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = ULT_TAR_CREADA) 
WHERE DIA_ID = FECHA
		AND ENTIDAD_CEDENTE_ID = 4 
;


update H_PRC set ULT_TAR_FIN_TIPO_DET_ID = (select DD_STA_ID 
											from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_FIN) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 1 
;

update H_PRC set ULT_TAR_FIN_TIPO_DET_ID = (select DD_STA_ID 
											from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_FIN) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 2 
;

update H_PRC set ULT_TAR_FIN_TIPO_DET_ID = (select DD_STA_ID 
											from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_FIN) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 3 
;

update H_PRC set ULT_TAR_FIN_TIPO_DET_ID = (select DD_STA_ID 
											from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_FIN) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 4 
;



update H_PRC set ULT_TAR_ACT_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULTIMA_TAREA_ACTUALIZADA
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 1 
;

update H_PRC set ULT_TAR_ACT_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULTIMA_TAREA_ACTUALIZADA
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 2 
;

update H_PRC set ULT_TAR_ACT_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULTIMA_TAREA_ACTUALIZADA
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 3 
;

update H_PRC set ULT_TAR_ACT_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULTIMA_TAREA_ACTUALIZADA
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 4 
;



update H_PRC set ULT_TAR_PEND_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_PEND
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 1 
;

update H_PRC set ULT_TAR_PEND_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_PEND
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 2 
;

update H_PRC set ULT_TAR_PEND_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_PEND
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 3 
;

update H_PRC set ULT_TAR_PEND_TIPO_DET_ID = (select (DD_STA_ID) 
											from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES 
											where TAR_ID = ULT_TAR_PEND
											) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 4 
;




update H_PRC set ULT_TAR_CREADA_DESC_ID = (select td.ULT_TAR_CREADA_DESC_ID 
										   from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                join D_PRC_ULT_TAR_CREADA_DESC td on tn.TAR_TAREA = td.ULT_TAR_CREADA_DESC_DESC 
                                           where TAR_ID = ULT_TAR_CREADA and td.ENTIDAD_CEDENTE_ID = 1 
                                           ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 1 
;

update H_PRC set ULT_TAR_CREADA_DESC_ID = (
	select td.ULT_TAR_CREADA_DESC_ID 
	from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tn
        join D_PRC_ULT_TAR_CREADA_DESC td on tn.TAR_TAREA = td.ULT_TAR_CREADA_DESC_DESC 
	where tn.TAR_ID = ULT_TAR_CREADA and td.ENTIDAD_CEDENTE_ID = 2 
   ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 2 
;

update H_PRC set ULT_TAR_CREADA_DESC_ID = (select td.ULT_TAR_CREADA_DESC_ID 
										   from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                join D_PRC_ULT_TAR_CREADA_DESC td on tn.TAR_TAREA = td.ULT_TAR_CREADA_DESC_DESC 
                                           where TAR_ID = ULT_TAR_CREADA  and td.ENTIDAD_CEDENTE_ID = 3 
                                           ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 3 
;

update H_PRC set ULT_TAR_CREADA_DESC_ID = (select td.ULT_TAR_CREADA_DESC_ID 
										   from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                join D_PRC_ULT_TAR_CREADA_DESC td on tn.TAR_TAREA = td.ULT_TAR_CREADA_DESC_DESC 
                                           where TAR_ID = ULT_TAR_CREADA and td.ENTIDAD_CEDENTE_ID = 4 
                                           ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 4 
;





update H_PRC set ULT_TAR_PEND_DESC_ID = (
										select td.ULT_TAR_PEND_DESC_ID 
										from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_PEND_DESC td on tn.TAR_TAREA = td.ULT_TAR_PEND_DESC_DESC 
                                        where TAR_ID = ULT_TAR_PEND and td.ENTIDAD_CEDENTE_ID = 1 
                                        ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 1 
;   
 
update H_PRC set ULT_TAR_PEND_DESC_ID = (
										select td.ULT_TAR_PEND_DESC_ID 
										from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_PEND_DESC td on tn.TAR_TAREA = td.ULT_TAR_PEND_DESC_DESC 
                                        where TAR_ID = ULT_TAR_PEND and td.ENTIDAD_CEDENTE_ID = 2 
                                        ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 2 
;
   
update H_PRC set ULT_TAR_PEND_DESC_ID = (
										select td.ULT_TAR_PEND_DESC_ID 
										from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_PEND_DESC td on tn.TAR_TAREA = td.ULT_TAR_PEND_DESC_DESC 
                                        where TAR_ID = ULT_TAR_PEND and td.ENTIDAD_CEDENTE_ID = 3 
                                        ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 3 
;
   
update H_PRC set ULT_TAR_PEND_DESC_ID = (
										select td.ULT_TAR_PEND_DESC_ID 
										from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                        	join D_PRC_ULT_TAR_PEND_DESC td on tn.TAR_TAREA = td.ULT_TAR_PEND_DESC_DESC 
                                        where TAR_ID = ULT_TAR_PEND and td.ENTIDAD_CEDENTE_ID = 4 
                                        ) 
where DIA_ID = fecha AND ENTIDAD_CEDENTE_ID = 4 
;   



update H_PRC set ESTADO_FASE_ANTERIOR_ID = -2 where DIA_ID = fecha and ESTADO_FASE_ANTERIOR_ID is null;
update H_PRC set FASE_ANTERIOR_DETALLE_ID =  -2 where DIA_ID = fecha and FASE_ANTERIOR_DETALLE_ID is null;


update H_PRC set ULT_TAR_CREADA_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_CREADA_TIPO_DET_ID is null;
update H_PRC set ULT_TAR_FIN_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_FIN_TIPO_DET_ID is null;
update H_PRC set ULT_TAR_ACT_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_ACT_TIPO_DET_ID is null;
update H_PRC set ULT_TAR_PEND_TIPO_DET_ID = -2 where DIA_ID = fecha and ULT_TAR_PEND_TIPO_DET_ID is null;
update H_PRC set ULT_TAR_CREADA_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_CREADA_DESC_ID is null;
update H_PRC set ULT_TAR_FIN_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_FIN_DESC_ID is null;
update H_PRC set ULT_TAR_ACT_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_ACT_DESC_ID is null;
update H_PRC set ULT_TAR_PEND_DESC_ID = -2 where DIA_ID = fecha and ULT_TAR_PEND_DESC_ID is null;



-- ---- Fase tarea detalle --------------------------------------------------------------------------------------------

update H_PRC  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_bng_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.ULT_TAR_PEND and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =1;

update H_PRC  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_bbva_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.ULT_TAR_PEND and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =2;

update H_PRC  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_bankia_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.ULT_TAR_PEND and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =3;

update H_PRC  h  set FASE_TAREA_DETALLE_ID = (select td.FASE_TAREA_DETALLE_ID
from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES tn
JOIN bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc ON tn.PRC_ID=prc.PRC_ID
join bi_cdd_cajamar_datastage.DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.DD_TPO_ID=tpo.DD_TPO_ID
join D_PRC_FASE_TAREA_DETALLE td on td.FASE_TAREA_DETALLE_ID=tpo.DD_TPO_ID
where tn.TAR_ID = h.ULT_TAR_PEND and h.ENTIDAD_CEDENTE_ID=td.ENTIDAD_CEDENTE_ID
and DATE(tn.TAR_FECHA_FIN) <=fecha and tn.TAR_FECHA_FIN is not null
                                        ) 
where DIA_ID = fecha AND h.ENTIDAD_CEDENTE_ID =4;


-- ÚLTIMA TAREA PENDIENTE FILTRADO -----------------------------------------------------------------------------------------------------------------------------------

truncate table TMP_TAREAS_PEND_FILTR;
truncate table TMP_TAREAS_FIN_FILTR;


-- ------------------------------- INSERTAMOS PROCEDIMIENTOS CON TAREAS PENDIENTES ----------------------------------------
insert into TMP_TAREAS_PEND_FILTR  (PROCEDIMIENTO_ID,TAREA_PEND_ID ,ENTIDAD_CEDENTE_ID,DESCRIPCION_TAREA_PEND,ORDEN_TAREA)

(SELECT
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,
		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 1	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS NULL
and nt.visible=1
group by
       TPJ.ITER,
	   TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
	   TAR.TAR_TAREA 
)
union
(SELECT
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,
		
		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 2	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS NULL
 and nt.visible=1
group by
TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA 
)
union
(SELECT
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,
		
		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 3	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS NULL
 and nt.visible=1
group by
TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA 
)
union
(SELECT
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,

		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 4	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS NULL
 and nt.visible=1
group by
TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA 
);



update TMP_TAREAS_PEND_FILTR p, tareas_proc_aux a 
set p.TAREA_PEND_TAP=a.tarea_id
where a.tarea=p.DESCRIPCION_TAREA_PEND
and a.ENTIDAD_CEDENTE_ID=p.ENTIDAD_CEDENTE_ID;



-- ------------------------------- INSERTAMOS PROCEDIMIENTOS CON TAREAS FINALIZADAS EN LA TEMPORAL DE FINALIZADAS ----------------------------------------
insert into TMP_TAREAS_FIN_FILTR  (PROCEDIMIENTO_ID,TAREA_FIN_ID ,ENTIDAD_CEDENTE_ID,DESCRIPCION_TAREA_FIN, FECHA_FIN_FIN,ORDEN_TAREA)

(SELECT
DISTINCT 
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,
		
		max(TAR.TAR_FECHA_FIN),
		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 1	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS not NULL AND DATE(TAR.TAR_FECHA_FIN)<=fecha
and nt.visible=1
GROUP BY 
TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA
)
union
(SELECT
DISTINCT 
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,
		max(TAR.TAR_FECHA_FIN),
		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 2	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS not NULL AND DATE(TAR.TAR_FECHA_FIN)<=fecha
and nt.visible=1
GROUP BY 
TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA 
)
union
(SELECT
DISTINCT 
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,
		max(TAR.TAR_FECHA_FIN),
		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 3	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS not NULL AND DATE(TAR.TAR_FECHA_FIN)<=fecha
 and nt.visible=1
GROUP BY 
TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA
)
union
(SELECT
DISTINCT 
		TPJ.ITER,
        TAR.TAR_ID ,
       TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA ,
		max(TAR.TAR_FECHA_FIN),
		MAX(nt.orden_tarea)
	FROM TMP_PRC_JERARQUIA TPJ
        JOIN bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES TAR ON TPJ.FASE_ACTUAL = TAR.PRC_ID 
        	AND TPJ.ENTIDAD_CEDENTE_ID = 4	
join tareas_proc_aux	nt on TAR.TAR_TAREA=nt.tarea
    WHERE TPJ.DIA_ID = fecha AND DATE(TAR.TAR_FECHA_INI) <=fecha AND (TAR.TAR_FECHA_FIN) IS not NULL AND DATE(TAR.TAR_FECHA_FIN)<=fecha
 and nt.visible=1
GROUP BY 
		TPJ.ITER,
        TAR.TAR_ID ,
        TPJ.ENTIDAD_CEDENTE_ID,
		TAR.TAR_TAREA
);


update TMP_TAREAS_FIN_FILTR f, tareas_proc_aux a 
set f.TAREA_FIN_TAP=a.tarea_id
where a.tarea=f.DESCRIPCION_TAREA_FIN
and a.ENTIDAD_CEDENTE_ID=f.ENTIDAD_CEDENTE_ID;

-- -------------------------------------UPDATE H_PRC------------------------------------------------------------------

INSERT INTO TMP_TAREAS_FIN_FILT_AUX
select f1.procedimiento_id,f1.tarea_fin_id, f1.TAREA_FIN_TAP,f1.ENTIDAD_CEDENTE_ID, max(f1.ORDEN_TAREA) from TMP_TAREAS_FIN_FILTR f1, (select distinct procedimiento_id, max(fecha_fin_fin)as fecha_fin_fin, ENTIDAD_CEDENTE_ID from TMP_TAREAS_FIN_FILTR
group by procedimiento_id, ENTIDAD_CEDENTE_ID) f2
where f1.PROCEDIMIENTO_ID=f2.procedimiento_id and f1.FECHA_FIN_FIN=f2.fecha_fin_fin and f1.ENTIDAD_CEDENTE_ID=f2.ENTIDAD_CEDENTE_ID
group by f1.procedimiento_id,f1.tarea_fin_id, f1.TAREA_FIN_TAP,ENTIDAD_CEDENTE_ID;


update H_PRC prc,TMP_TAREAS_FIN_FILT_AUX f
set prc.ULT_TAR_PEND_FILTR_DESC_ID=f.TAREA_FIN_TAP,
prc.ULT_TAR_PEND_FILT=f.TAREA_FIN_ID,
prc.ORDEN_TAREA_FILT=f.orden_tarea
where prc.PROCEDIMIENTO_ID=f.PROCEDIMIENTO_ID 
and prc.DIA_ID=fecha;

update H_PRC prc,TMP_TAREAS_PEND_FILTR f
set prc.ULT_TAR_PEND_FILTR_DESC_ID=f.TAREA_PEND_TAP,
prc.ULT_TAR_PEND_FILT=f.TAREA_PEND_ID,
prc.ORDEN_TAREA_FILT=f.orden_tarea
where prc.PROCEDIMIENTO_ID=f.PROCEDIMIENTO_ID 
and prc.DIA_ID=fecha;


update H_PRC t1,(select TN.TAR_ID, ULT_TAR_PEND_FILTR_DESC_ID from bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES TN
                              join  D_PRC_ULT_TAR_PEND_FILTR_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_PEND_FILTR_DESC) t2
set  t1.ULT_TAR_PEND_FILTR_DESC_ID = t2.ULT_TAR_PEND_FILTR_DESC_ID
                       where t1.ULT_TAR_PEND_FILT = t2.TAR_ID and t1.entidad_cedente_id=1 and t1.DIA_ID = fecha;


update H_PRC t1,(select TN.TAR_ID, ULT_TAR_PEND_FILTR_DESC_ID from bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES TN
                              join  D_PRC_ULT_TAR_PEND_FILTR_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_PEND_FILTR_DESC) t2
set  t1.ULT_TAR_PEND_FILTR_DESC_ID = t2.ULT_TAR_PEND_FILTR_DESC_ID
                       where t1.ULT_TAR_PEND_FILT = t2.TAR_ID and t1.entidad_cedente_id=2 and t1.DIA_ID = fecha;



update H_PRC t1,(select TN.TAR_ID, ULT_TAR_PEND_FILTR_DESC_ID from bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES TN
                              join  D_PRC_ULT_TAR_PEND_FILTR_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_PEND_FILTR_DESC) t2
set  t1.ULT_TAR_PEND_FILTR_DESC_ID = t2.ULT_TAR_PEND_FILTR_DESC_ID
                       where t1.ULT_TAR_PEND_FILT = t2.TAR_ID and t1.entidad_cedente_id=3 and t1.DIA_ID = fecha;


update H_PRC t1,(select TN.TAR_ID, ULT_TAR_PEND_FILTR_DESC_ID from bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES TN
                              join  D_PRC_ULT_TAR_PEND_FILTR_DESC TD on TN.TAR_TAREA = TD.ULT_TAR_PEND_FILTR_DESC) t2
set  t1.ULT_TAR_PEND_FILTR_DESC_ID = t2.ULT_TAR_PEND_FILTR_DESC_ID
                       where t1.ULT_TAR_PEND_FILT = t2.TAR_ID and t1.entidad_cedente_id=4 and t1.DIA_ID = fecha;




-- ===============================================================================================
 -- FASE_TAREA_AGR_ID
-- ===============================================================================================
  
    
     
     update H_PRC set FASE_TAREA_AGR_ID = (case when TIPO_PROCEDIMIENTO_DET_ID IN (153) then 1
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
    
    
     
      update H_PRC set FASE_TAREA_AGR_ID = (case when FASE_ACTUAL_DETALLE_ID IN (153) then 1
                                                     when FASE_ACTUAL_DETALLE_ID IN (35) then 2
                                                     when FASE_ACTUAL_DETALLE_ID IN (34) then 3
                                                     when FASE_ACTUAL_DETALLE_ID IN (33) then 4
                                                     when FASE_ACTUAL_DETALLE_ID IN (1) then 5
                                                     when FASE_ACTUAL_DETALLE_ID IN (2) then 6
                                                     when FASE_ACTUAL_DETALLE_ID IN (164) then 7
                                                     when FASE_ACTUAL_DETALLE_ID IN (162) then 8
                                                     when FASE_ACTUAL_DETALLE_ID IN (171) then 9
                                                     when FASE_ACTUAL_DETALLE_ID IN (168) then 10
                                                     when FASE_ACTUAL_DETALLE_ID IN (21) then 11
                             when FASE_ACTUAL_DETALLE_ID IN (157) then 12
                                                     when FASE_ACTUAL_DETALLE_ID IN (159) then 13
                             when FASE_ACTUAL_DETALLE_ID IN (155) then 14
                             when FASE_ACTUAL_DETALLE_ID IN (166) then 15
                             when FASE_ACTUAL_DETALLE_ID IN (141,142,143,144) then 16
                             when FASE_ACTUAL_DETALLE_ID IN (165) then 17
                             when FASE_ACTUAL_DETALLE_ID IN (158) then 18
                             when FASE_ACTUAL_DETALLE_ID IN (156) then 19
                             when FASE_ACTUAL_DETALLE_ID IN (1041) then 20
                             when FASE_ACTUAL_DETALLE_ID IN (41) then 21
                                                     else FASE_TAREA_AGR_ID end) where DIA_ID = fecha;
     
     
     
    commit;   




END LOOP;
CLOSE C_FECHA;








set max_dia_carga = (select max(DIA_ID) from H_PRC);      






truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_PRC where DIA_ID between date_start and date_end;
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);



set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;
    
    
    delete from H_PRC_MES where MES_ID = mes;
    
    delete from H_PRC_DET_CONTRATO_MES where MES_ID = mes;
    
    
    set max_dia_mes = (select max(DIA_H) from TMP_FECHA where MES_H = mes);
    insert into H_PRC_MES
        (    
        		MES_ID,   
			    FECHA_CARGA_DATOS,
			    PROCEDIMIENTO_ID,
			    FASE_MAX_PRIORIDAD,
			    FASE_ANTERIOR,
			    FASE_ACTUAL,
			    ULT_TAR_CREADA,
			    ULT_TAR_FIN,
			    ULTIMA_TAREA_ACTUALIZADA,
			    ULT_TAR_PEND,
			    FECHA_CREACION_ASUNTO,
			    FECHA_CONTABLE_LITIGIO,
			    FECHA_CREACION_PROCEDIMIENTO,
			    FECHA_CREACION_FASE_MAX_PRIO,
			    FECHA_CREACION_FASE_ANTERIOR, 
			    FECHA_CREACION_FASE_ACTUAL, 
			    FECHA_ULT_TAR_CREADA, 
			    FECHA_ULT_TAR_FIN, 
			    FECHA_ULTIMA_TAREA_ACTUALIZADA,
			    FECHA_ULT_TAR_PEND,
			    FECHA_VENC_ORIG_ULT_TAR_FIN, 
			    FECHA_VENC_ACT_ULT_TAR_FIN,
			    FECHA_VENC_ORIG_ULT_TAR_PEND, 
			    FECHA_VENC_ACT_ULT_TAR_PEND,
			    FECHA_ACEPTACION,
			    FECHA_RECOGIDA_DOC_Y_ACEPT,
			    FECHA_REGISTRAR_TOMA_DECISION,
			    FECHA_RECEPCION_DOC_COMPLETA,
			    FECHA_INTERPOSICION_DEMANDA,
			    FECHA_ULTIMA_POSICION_VENCIDA,
			    FECHA_ULTIMA_ESTIMACION,
			    FECHA_ESTIMADA_COBRO,
			    CONTEXTO_FASE,
			    NIVEL,
			    ASUNTO_ID,
			    TIPO_PROCEDIMIENTO_DET_ID,
			    FASE_ACTUAL_DETALLE_ID,
			    FASE_ANTERIOR_DETALLE_ID,
			    ULT_TAR_CREADA_TIPO_DET_ID, 
			    ULT_TAR_CREADA_DESC_ID, 
			    ULT_TAR_FIN_TIPO_DET_ID,
			    ULT_TAR_FIN_DESC_ID,
			    ULT_TAR_ACT_TIPO_DET_ID,
			    ULT_TAR_ACT_DESC_ID,
			    ULT_TAR_PEND_TIPO_DET_ID,
			    ULT_TAR_PEND_DESC_ID,
			    CUMPLIMIENTO_ULT_TAR_FIN_ID,
			    CUMPLIMIENTO_ULT_TAR_PEND_ID,
			    ESTADO_PROCEDIMIENTO_ID,
			    ESTADO_FASE_ACTUAL_ID,
			    ESTADO_FASE_ANTERIOR_ID,
			    T_SALDO_TOTAL_PRC_ID,
			    T_SALDO_TOTAL_CONCURSO_ID,
			    TD_CONTRATO_VENCIDO_ID,
			    TD_CNT_VENC_CREACION_ASU_ID,
			    TD_CREA_ASU_A_INTERP_DEM_ID,  
			    TD_CREACION_ASU_ACEPT_ID,
			    TD_ACEPT_ASU_INTERP_DEM_ID,
			    TD_CREA_ASU_REC_DOC_ACEP_ID,
			    TD_REC_DOC_ACEPT_REG_TD_ID, 
			    TD_REC_DOC_ACEPT_REC_DC_ID,
			    CNT_GARANTIA_REAL_ASOC_ID,
			    ACT_ESTIMACIONES_ID,
			    CARTERA_PROCEDIMIENTO_ID,
			    TITULAR_PROCEDIMIENTO_ID,
			    NUM_PROCEDIMIENTOS,
			    NUM_CONTRATOS,
			    NUM_FASES,
			    NUM_DIAS_ULT_ACTUALIZACION,
			    NUM_MAX_DIAS_CONTRATO_VENCIDO,
			    PORCENTAJE_RECUPERACION,
			    P_RECUPERACION,
			    SALDO_RECUPERACION,
			    
			    SALDO_ORIGINAL_VENCIDO,
			    SALDO_ORIGINAL_NO_VENCIDO,
			    SALDO_ACTUAL_VENCIDO,
			    SALDO_ACTUAL_NO_VENCIDO,
			    SALDO_ACTUAL_TOTAL,
			    SALDO_CONCURSOS_VENCIDO,
			    SALDO_CONCURSOS_NO_VENCIDO,
			    SALDO_CONCURSOS_TOTAL,
			    INGRESOS_PENDIENTES_APLICAR,
			    SUBTOTAL,
			    DURACION_ULT_TAREA_FINALIZADA,
			    NUM_DIAS_EXCED_ULT_TAR_FIN,
			    NUM_DIAS_VENC_ULT_TAR_FIN,
			    NUM_DIAS_PRORROG_ULT_TAR_FIN, 
			    
			    DURACION_ULT_TAREA_PENDIENTE,
			    NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
			    NUM_DIAS_VENC_ULT_TAR_PEND,
			    NUM_DIAS_PRORROG_ULT_TAR_PEND,          
			    NUM_PRORROG_ULT_TAR_PEND, 		
			    FECHA_PRORROG_ULT_TAR_PEND,     
			    NUM_AUTO_PRORROG_ULT_TAR_PEND,   
			    FECHA_AUTO_PRORROG_ULT_TAR_PEND, 
			    
			    P_CREA_ASU_A_INTERP_DEM,  
			    P_CREACION_ASU_ACEP,   
			    P_ACEPT_ASU_INTERP_DEM,
			    P_CREA_ASU_REC_DOC_ACEP,
			    P_REC_DOC_ACEP_REG_TD,
			    P_REC_DOC_ACEP_RECEP_DC,
			    NUM_DIAS_DESDE_ULT_ESTIMACION,
			    NUM_PARALIZACIONES, 
			    PARALIZADO, 
			    SIT_CUADRE_CARTERA_ID, 
			    ENTIDAD_CEDENTE_ID,
			    PLAZA_ID,
	    		    JUZGADO_ID,
	                    PROCURADOR_ID,
			    FASE_TAREA_DETALLE_ID,
			    ULT_TAR_PEND_FILTR_DESC_ID,	
			    ULT_TAR_PEND_FILT,
			    ORDEN_TAREA_FILT,
                FASE_TAREA_AGR_ID
        )
    select mes, 
        max_dia_mes,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULT_TAR_CREADA,
        ULT_TAR_FIN,
        ULTIMA_TAREA_ACTUALIZADA,
        ULT_TAR_PEND,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIO,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULT_TAR_CREADA, 
        FECHA_ULT_TAR_FIN, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULT_TAR_PEND,
        FECHA_VENC_ORIG_ULT_TAR_FIN, 
        FECHA_VENC_ACT_ULT_TAR_FIN,
        FECHA_VENC_ORIG_ULT_TAR_PEND, 
        FECHA_VENC_ACT_ULT_TAR_PEND,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPT,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DET_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULT_TAR_CREADA_TIPO_DET_ID, 
        ULT_TAR_CREADA_DESC_ID, 
        ULT_TAR_FIN_TIPO_DET_ID,
        ULT_TAR_FIN_DESC_ID,
        ULT_TAR_ACT_TIPO_DET_ID,
        ULT_TAR_ACT_DESC_ID,
        ULT_TAR_PEND_TIPO_DET_ID,
        ULT_TAR_PEND_DESC_ID,
        CUMPLIMIENTO_ULT_TAR_FIN_ID,
        CUMPLIMIENTO_ULT_TAR_PEND_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        T_SALDO_TOTAL_PRC_ID,
        T_SALDO_TOTAL_CONCURSO_ID,
        TD_CONTRATO_VENCIDO_ID,
        TD_CNT_VENC_CREACION_ASU_ID,
        TD_CREA_ASU_A_INTERP_DEM_ID,  
        TD_CREACION_ASU_ACEPT_ID,
        TD_ACEPT_ASU_INTERP_DEM_ID,
        TD_CREA_ASU_REC_DOC_ACEP_ID,
        TD_REC_DOC_ACEPT_REG_TD_ID, 
        TD_REC_DOC_ACEPT_REC_DC_ID,
        CNT_GARANTIA_REAL_ASOC_ID,
        ACT_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        datediff(max_dia_mes, FECHA_ULTIMA_TAREA_ACTUALIZADA),
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        P_RECUPERACION,
        SALDO_RECUPERACION,
        
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCED_ULT_TAR_FIN,
        NUM_DIAS_VENC_ULT_TAR_FIN,
        NUM_DIAS_PRORROG_ULT_TAR_FIN,          
        
        datediff(max_dia_mes, FECHA_ULT_TAR_PEND),
        NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
        NUM_DIAS_VENC_ULT_TAR_PEND,
        NUM_DIAS_PRORROG_ULT_TAR_PEND,   
	NUM_PRORROG_ULT_TAR_PEND, 		
	FECHA_PRORROG_ULT_TAR_PEND,     
	NUM_AUTO_PRORROG_ULT_TAR_PEND,   
	FECHA_AUTO_PRORROG_ULT_TAR_PEND, 
        
        P_CREA_ASU_A_INTERP_DEM,  
        P_CREACION_ASU_ACEP,   
        P_ACEPT_ASU_INTERP_DEM,
        P_CREA_ASU_REC_DOC_ACEP,
        P_REC_DOC_ACEP_REG_TD,
        P_REC_DOC_ACEP_RECEP_DC,
        NUM_DIAS_DESDE_ULT_ESTIMACION,
  	NUM_PARALIZACIONES, 
  	PARALIZADO, 
	SIT_CUADRE_CARTERA_ID, 
  	ENTIDAD_CEDENTE_ID ,   
  	PLAZA_ID,
	JUZGADO_ID,
	PROCURADOR_ID ,
	FASE_TAREA_DETALLE_ID,
	ULT_TAR_PEND_FILTR_DESC_ID,	
	ULT_TAR_PEND_FILT,
	ORDEN_TAREA_FILT ,
    FASE_TAREA_AGR_ID  
    from H_PRC 
    where DIA_ID = max_dia_mes
    ;

    
    update H_PRC_MES 
    	set NUM_DIAS_ULT_ACTUALIZACION = (select datediff(max_dia_mes, FECHA_CREACION_FASE_ACTUAL)) 
    where NUM_DIAS_ULT_ACTUALIZACION is null;
                                                             
    
    update H_PRC_MES 
    	set TD_ULT_ACTUALIZACION_PRC_ID = (case 
    											when NUM_DIAS_ULT_ACTUALIZACION <=30 then 0
					                            when NUM_DIAS_ULT_ACTUALIZACION >30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
				                                when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
				                                when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
    								       else -1 
    								       end
    								       )
    ;
    
     
	
    insert into H_PRC_DET_CONTRATO_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO,
         ENTIDAD_CEDENTE_ID
         )
    select mes,   
         max_dia_mes,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO,
         ENTIDAD_CEDENTE_ID
    from H_PRC_DET_CONTRATO 
    where DIA_ID = max_dia_mes
    ;
         
end loop c_meses_loop;
close c_meses;







set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    
    delete from H_PRC_TRIMESTRE where TRIMESTRE_ID = trimestre;
    
    delete from H_PRC_DET_CONTRATO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    
    
    set max_dia_trimestre = (select max(DIA_H) from TMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_PRC_TRIMESTRE
        (TRIMESTRE_ID,   
        FECHA_CARGA_DATOS,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULT_TAR_CREADA,
        ULT_TAR_FIN,
        ULTIMA_TAREA_ACTUALIZADA,
        ULT_TAR_PEND,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIO,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULT_TAR_CREADA, 
        FECHA_ULT_TAR_FIN, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULT_TAR_PEND,
        FECHA_VENC_ORIG_ULT_TAR_FIN, 
        FECHA_VENC_ACT_ULT_TAR_FIN,
        FECHA_VENC_ORIG_ULT_TAR_PEND, 
        FECHA_VENC_ACT_ULT_TAR_PEND,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPT,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DET_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULT_TAR_CREADA_TIPO_DET_ID, 
        ULT_TAR_CREADA_DESC_ID, 
        ULT_TAR_FIN_TIPO_DET_ID,
        ULT_TAR_FIN_DESC_ID,
        ULT_TAR_ACT_TIPO_DET_ID,
        ULT_TAR_ACT_DESC_ID,
        ULT_TAR_PEND_TIPO_DET_ID,
        ULT_TAR_PEND_DESC_ID,
        CUMPLIMIENTO_ULT_TAR_FIN_ID,
        CUMPLIMIENTO_ULT_TAR_PEND_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        T_SALDO_TOTAL_PRC_ID,
        T_SALDO_TOTAL_CONCURSO_ID,
        TD_CONTRATO_VENCIDO_ID,
        TD_CNT_VENC_CREACION_ASU_ID,
        TD_CREA_ASU_A_INTERP_DEM_ID,  
        TD_CREACION_ASU_ACEPT_ID,
        TD_ACEPT_ASU_INTERP_DEM_ID,
        TD_CREA_ASU_REC_DOC_ACEP_ID,
        TD_REC_DOC_ACEPT_REG_TD_ID, 
        TD_REC_DOC_ACEPT_REC_DC_ID,
        CNT_GARANTIA_REAL_ASOC_ID,
        ACT_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        NUM_DIAS_ULT_ACTUALIZACION,
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        P_RECUPERACION,
        SALDO_RECUPERACION,
        
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCED_ULT_TAR_FIN,
        NUM_DIAS_VENC_ULT_TAR_FIN,
        NUM_DIAS_PRORROG_ULT_TAR_FIN,          
        
        DURACION_ULT_TAREA_PENDIENTE,
        NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
        NUM_DIAS_VENC_ULT_TAR_PEND,
        NUM_DIAS_PRORROG_ULT_TAR_PEND,  
	    NUM_PRORROG_ULT_TAR_PEND, 		
	    FECHA_PRORROG_ULT_TAR_PEND,     
	    NUM_AUTO_PRORROG_ULT_TAR_PEND,   
	    FECHA_AUTO_PRORROG_ULT_TAR_PEND, 
        
        P_CREA_ASU_A_INTERP_DEM,  
        P_CREACION_ASU_ACEP,   
        P_ACEPT_ASU_INTERP_DEM,
        P_CREA_ASU_REC_DOC_ACEP,
        P_REC_DOC_ACEP_REG_TD,
        P_REC_DOC_ACEP_RECEP_DC,
        NUM_DIAS_DESDE_ULT_ESTIMACION,
	    NUM_PARALIZACIONES, 
	    PARALIZADO, 
		SIT_CUADRE_CARTERA_ID, 
	    ENTIDAD_CEDENTE_ID,
	ULT_TAR_PEND_FILTR_DESC_ID,	
	ULT_TAR_PEND_FILT,
	ORDEN_TAREA_FILT   ,
     FASE_TAREA_AGR_ID        
        )
    select trimestre, 
        max_dia_trimestre,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULT_TAR_CREADA,
        ULT_TAR_FIN,
        ULTIMA_TAREA_ACTUALIZADA,
        ULT_TAR_PEND,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIO,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULT_TAR_CREADA, 
        FECHA_ULT_TAR_FIN, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULT_TAR_PEND,
        FECHA_VENC_ORIG_ULT_TAR_FIN, 
        FECHA_VENC_ACT_ULT_TAR_FIN,
        FECHA_VENC_ORIG_ULT_TAR_PEND, 
        FECHA_VENC_ACT_ULT_TAR_PEND,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPT,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DET_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULT_TAR_CREADA_TIPO_DET_ID, 
        ULT_TAR_CREADA_DESC_ID, 
        ULT_TAR_FIN_TIPO_DET_ID,
        ULT_TAR_FIN_DESC_ID,
        ULT_TAR_ACT_TIPO_DET_ID,
        ULT_TAR_ACT_DESC_ID,
        ULT_TAR_PEND_TIPO_DET_ID,
        ULT_TAR_PEND_DESC_ID,
        CUMPLIMIENTO_ULT_TAR_FIN_ID,
        CUMPLIMIENTO_ULT_TAR_PEND_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        T_SALDO_TOTAL_PRC_ID,
        T_SALDO_TOTAL_CONCURSO_ID,
        TD_CONTRATO_VENCIDO_ID,
        TD_CNT_VENC_CREACION_ASU_ID,
        TD_CREA_ASU_A_INTERP_DEM_ID,  
        TD_CREACION_ASU_ACEPT_ID,
        TD_ACEPT_ASU_INTERP_DEM_ID,
        TD_CREA_ASU_REC_DOC_ACEP_ID,
        TD_REC_DOC_ACEPT_REG_TD_ID, 
        TD_REC_DOC_ACEPT_REC_DC_ID,
        CNT_GARANTIA_REAL_ASOC_ID,
        ACT_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        datediff(max_dia_trimestre, FECHA_ULTIMA_TAREA_ACTUALIZADA),
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        P_RECUPERACION,
        SALDO_RECUPERACION,
        
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCED_ULT_TAR_FIN,
        NUM_DIAS_VENC_ULT_TAR_FIN,
        NUM_DIAS_PRORROG_ULT_TAR_FIN,          
        
        datediff(max_dia_trimestre, FECHA_ULT_TAR_PEND),
        NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
        NUM_DIAS_VENC_ULT_TAR_PEND,
        NUM_DIAS_PRORROG_ULT_TAR_PEND,  
	    NUM_PRORROG_ULT_TAR_PEND, 		
	    FECHA_PRORROG_ULT_TAR_PEND,     
	    NUM_AUTO_PRORROG_ULT_TAR_PEND,   
	    FECHA_AUTO_PRORROG_ULT_TAR_PEND, 
        P_CREA_ASU_A_INTERP_DEM,  
        P_CREACION_ASU_ACEP,   
        P_ACEPT_ASU_INTERP_DEM,
        P_CREA_ASU_REC_DOC_ACEP,
        P_REC_DOC_ACEP_REG_TD,
        P_REC_DOC_ACEP_RECEP_DC,
        NUM_DIAS_DESDE_ULT_ESTIMACION,
        NUM_PARALIZACIONES, 
  		PARALIZADO, 
		SIT_CUADRE_CARTERA_ID, 
  		ENTIDAD_CEDENTE_ID,
	ULT_TAR_PEND_FILTR_DESC_ID,	
	ULT_TAR_PEND_FILT,
	ORDEN_TAREA_FILT,
        FASE_TAREA_AGR_ID     
    from H_PRC where DIA_ID = max_dia_trimestre;


update H_PRC_TRIMESTRE set NUM_DIAS_ULT_ACTUALIZACION = (select datediff(max_dia_trimestre, FECHA_CREACION_FASE_ACTUAL)) where NUM_DIAS_ULT_ACTUALIZACION is null;                                                         

update H_PRC_TRIMESTRE set TD_ULT_ACTUALIZACION_PRC_ID = (case when NUM_DIAS_ULT_ACTUALIZACION <=30 then 0
                                                                                              when NUM_DIAS_ULT_ACTUALIZACION >30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
                                                                                              when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
                                                                                              when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
                                                                                              else -1 end);  
    
    

    insert into H_PRC_DET_CONTRATO_TRIMESTRE
        (TRIMESTRE_ID, 
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO,
         ENTIDAD_CEDENTE_ID 
        )
    select trimestre, 
         max_dia_trimestre,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO,
         ENTIDAD_CEDENTE_ID 
     from H_PRC_DET_CONTRATO where DIA_ID = max_dia_trimestre;
     
end loop c_trimestre_loop;
close c_trimestre;






set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    
    delete from H_PRC_ANIO where ANIO_ID = anio;
    
    delete from H_PRC_DET_CONTRATO_ANIO where ANIO_ID = anio;
    
    
    set max_dia_anio = (select max(DIA_H) from TMP_FECHA where ANIO_H = anio);
    insert into H_PRC_ANIO
        (ANIO_ID,      
        FECHA_CARGA_DATOS,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULT_TAR_CREADA,
        ULT_TAR_FIN,
        ULTIMA_TAREA_ACTUALIZADA,
        ULT_TAR_PEND,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIO,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULT_TAR_CREADA, 
        FECHA_ULT_TAR_FIN, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULT_TAR_PEND,
        FECHA_VENC_ORIG_ULT_TAR_FIN, 
        FECHA_VENC_ACT_ULT_TAR_FIN,
        FECHA_VENC_ORIG_ULT_TAR_PEND, 
        FECHA_VENC_ACT_ULT_TAR_PEND,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPT,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DET_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULT_TAR_CREADA_TIPO_DET_ID, 
        ULT_TAR_CREADA_DESC_ID, 
        ULT_TAR_FIN_TIPO_DET_ID,
        ULT_TAR_FIN_DESC_ID,
        ULT_TAR_ACT_TIPO_DET_ID,
        ULT_TAR_ACT_DESC_ID,
        ULT_TAR_PEND_TIPO_DET_ID,
        ULT_TAR_PEND_DESC_ID,
        CUMPLIMIENTO_ULT_TAR_FIN_ID,
        CUMPLIMIENTO_ULT_TAR_PEND_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        T_SALDO_TOTAL_PRC_ID,
        T_SALDO_TOTAL_CONCURSO_ID,
        TD_CONTRATO_VENCIDO_ID,
        TD_CNT_VENC_CREACION_ASU_ID,
        TD_CREA_ASU_A_INTERP_DEM_ID,  
        TD_CREACION_ASU_ACEPT_ID,
        TD_ACEPT_ASU_INTERP_DEM_ID,
        TD_CREA_ASU_REC_DOC_ACEP_ID,
        TD_REC_DOC_ACEPT_REG_TD_ID, 
        TD_REC_DOC_ACEPT_REC_DC_ID,
        CNT_GARANTIA_REAL_ASOC_ID,
        ACT_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        NUM_DIAS_ULT_ACTUALIZACION,
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        P_RECUPERACION,
        SALDO_RECUPERACION,
        
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCED_ULT_TAR_FIN,
        NUM_DIAS_VENC_ULT_TAR_FIN,
        NUM_DIAS_PRORROG_ULT_TAR_FIN,          
        
        DURACION_ULT_TAREA_PENDIENTE,
        NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
        NUM_DIAS_VENC_ULT_TAR_PEND,
        NUM_DIAS_PRORROG_ULT_TAR_PEND,          
        
	    NUM_PRORROG_ULT_TAR_PEND, 		
	    FECHA_PRORROG_ULT_TAR_PEND,     
	    NUM_AUTO_PRORROG_ULT_TAR_PEND,   
	    FECHA_AUTO_PRORROG_ULT_TAR_PEND, 
        P_CREA_ASU_A_INTERP_DEM,  
        P_CREACION_ASU_ACEP,   
        P_ACEPT_ASU_INTERP_DEM,
        P_CREA_ASU_REC_DOC_ACEP,
        P_REC_DOC_ACEP_REG_TD,
        P_REC_DOC_ACEP_RECEP_DC,
        NUM_DIAS_DESDE_ULT_ESTIMACION,
	    NUM_PARALIZACIONES, 
	    PARALIZADO, 
		SIT_CUADRE_CARTERA_ID, 
	    ENTIDAD_CEDENTE_ID,
	ULT_TAR_PEND_FILTR_DESC_ID,	
	ULT_TAR_PEND_FILT,
	ORDEN_TAREA_FILT   ,
    FASE_TAREA_AGR_ID          
        )
    select anio,   
        max_dia_anio,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULT_TAR_CREADA,
        ULT_TAR_FIN,
        ULTIMA_TAREA_ACTUALIZADA,
        ULT_TAR_PEND,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIO,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULT_TAR_CREADA, 
        FECHA_ULT_TAR_FIN, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULT_TAR_PEND,
        FECHA_VENC_ORIG_ULT_TAR_FIN, 
        FECHA_VENC_ACT_ULT_TAR_FIN,
        FECHA_VENC_ORIG_ULT_TAR_PEND, 
        FECHA_VENC_ACT_ULT_TAR_PEND,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPT,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DET_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULT_TAR_CREADA_TIPO_DET_ID, 
        ULT_TAR_CREADA_DESC_ID, 
        ULT_TAR_FIN_TIPO_DET_ID,
        ULT_TAR_FIN_DESC_ID,
        ULT_TAR_ACT_TIPO_DET_ID,
        ULT_TAR_ACT_DESC_ID,
        ULT_TAR_PEND_TIPO_DET_ID,
        ULT_TAR_PEND_DESC_ID,
        CUMPLIMIENTO_ULT_TAR_FIN_ID,
        CUMPLIMIENTO_ULT_TAR_PEND_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        T_SALDO_TOTAL_PRC_ID,
        T_SALDO_TOTAL_CONCURSO_ID,
        TD_CONTRATO_VENCIDO_ID,
        TD_CNT_VENC_CREACION_ASU_ID,
        TD_CREA_ASU_A_INTERP_DEM_ID,  
        TD_CREACION_ASU_ACEPT_ID,
        TD_ACEPT_ASU_INTERP_DEM_ID,
        TD_CREA_ASU_REC_DOC_ACEP_ID,
        TD_REC_DOC_ACEPT_REG_TD_ID, 
        TD_REC_DOC_ACEPT_REC_DC_ID,
        CNT_GARANTIA_REAL_ASOC_ID,
        ACT_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        datediff(max_dia_anio, FECHA_ULTIMA_TAREA_ACTUALIZADA),
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        P_RECUPERACION,
        SALDO_RECUPERACION,
        
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCED_ULT_TAR_FIN,
        NUM_DIAS_VENC_ULT_TAR_FIN,
        NUM_DIAS_PRORROG_ULT_TAR_FIN,          
        
        datediff(max_dia_anio, FECHA_ULT_TAR_PEND),
        NUM_DIAS_EXCEDIDO_ULT_TAR_PEND,
        NUM_DIAS_VENC_ULT_TAR_PEND,
        NUM_DIAS_PRORROG_ULT_TAR_PEND,         
        
	    NUM_PRORROG_ULT_TAR_PEND, 		
	    FECHA_PRORROG_ULT_TAR_PEND,     
	    NUM_AUTO_PRORROG_ULT_TAR_PEND,   
	    FECHA_AUTO_PRORROG_ULT_TAR_PEND, 
        P_CREA_ASU_A_INTERP_DEM,  
        P_CREACION_ASU_ACEP,   
        P_ACEPT_ASU_INTERP_DEM,
        P_CREA_ASU_REC_DOC_ACEP,
        P_REC_DOC_ACEP_REG_TD,
        P_REC_DOC_ACEP_RECEP_DC,
        NUM_DIAS_DESDE_ULT_ESTIMACION,
        NUM_PARALIZACIONES, 
  		PARALIZADO, 
		SIT_CUADRE_CARTERA_ID, 
  		ENTIDAD_CEDENTE_ID,
	ULT_TAR_PEND_FILTR_DESC_ID,	
	ULT_TAR_PEND_FILT,
	ORDEN_TAREA_FILT  ,
    FASE_TAREA_AGR_ID    
    from H_PRC where DIA_ID = max_dia_anio;


update H_PRC_ANIO set NUM_DIAS_ULT_ACTUALIZACION = (select datediff(max_dia_anio, FECHA_CREACION_FASE_ACTUAL)) where NUM_DIAS_ULT_ACTUALIZACION is null;                                                         

update H_PRC_ANIO set TD_ULT_ACTUALIZACION_PRC_ID = (case when NUM_DIAS_ULT_ACTUALIZACION <=30 then 0
                                                                                         when NUM_DIAS_ULT_ACTUALIZACION >30 and NUM_DIAS_ULT_ACTUALIZACION <= 60 then 1
                                                                                         when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION <= 90 then 2
                                                                                         when NUM_DIAS_ULT_ACTUALIZACION >60 and NUM_DIAS_ULT_ACTUALIZACION > 90 then 3
                                                                                        else -1 end);  
    
    
    
    insert into H_PRC_DET_CONTRATO_ANIO
        (ANIO_ID,   
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO,
         ENTIDAD_CEDENTE_ID
         )
    select anio, 
         max_dia_anio,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO,
         ENTIDAD_CEDENTE_ID
    from H_PRC_DET_CONTRATO where DIA_ID = max_dia_anio;
     
end loop c_anio_loop;  
close c_anio;


END MY_BLOCK_H_PRC

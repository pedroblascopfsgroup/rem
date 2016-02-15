-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Categoria_Estado_Cruce` $$



DELIMITER $$
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Categoria_Estado_Cruce`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_ESTADO: BEGIN

-- ===============================================================================================
-- Autor: Joaquin Arnal, PFS Group
-- Fecha creación: Diciembre 2014
-- Responsable última modificación: 
-- Fecha última modificación:
-- Motivos del cambio: 
-- Cliente: CDD 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Asunto.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN ASUNTO
    -- D_CATEGORIA_ESTADO_CRUCE
	
declare l_last_row int default 0;
declare continue HANDLER FOR NOT FOUND SET l_last_row = 1;	
	
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
--                 D_CATEGORIA_ESTADO_CRUCE
-- ----------------------------------------------------------------------------------------------


-- UGAS (1)
insert into D_CATEGORIA_ESTADO_CRUCE(CEC_ID, CEC_DESC, CEC_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	select 0, '[R.nAyD-JUD-DES]', 'Despreciables, estan en ambos sistemas, duplicados y no activos', 1  -- 0
	FROM DUAL
	UNION 	
	select 1, '[TAD-PRE-COR]', 'Pre-Judiciales correctamente vinculados', 1  -- 1
	FROM DUAL
	UNION 
	select 2, '[ACT-JUD-COR]', 'Judiciales correctamente vinculados', 1 -- 2
	FROM DUAL
	UNION 
	select 3, '[FIN-JUD-COR]', 'Judiciales correctamente vinculados, y FINALIZADOS', 1 -- 3
	FROM DUAL
	UNION 
	select 4, '[FIN-PRE-COR]', 'Pre-Judiciales correctamente vinculados, y FINALIZADOS', 1  -- 4
	FROM DUAL
	UNION
	select 5, '[C.N-R.A-JUD-DIS]', 'Discrepacias - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 1 -- 5
	FROM DUAL
	UNION
	select 18, '[C.N-R.A-JUD-DES]', 'Despreciable - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 1  -- 18
	FROM DUAL
	UNION
	select 6, '[C.DoA-R.N-PRE-DIS]', 'Discrepacias - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 1 -- 6
	FROM DUAL
	UNION
	select 22, '[C.DoA-R.N-PRE-COR]', 'Pre-Judiciales correctamente vinculados - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 1 -- 22
	FROM DUAL
	UNION
	select 23, '[C.ApF-R.N-JUD-COR]', 'No está en Recovery. JUDICIAL:> Estado Conexp [...].', 1 -- 23
	FROM DUAL
	UNION
	select 24, '[R.FinJud-JUD-COR]', 'Correctos, ya han finalizado y se ha quitado el despacho de CDD - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 1 -- 24
	FROM DUAL
	UNION
	select 7, '[C.Pd-R.N-JUD-DIS]', 'Discrepacias - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 1 -- 7
	FROM DUAL
	UNION
	select 8, '[C.Pd-R.TAD-PvJ-DIS]' ,'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 1 -- 8
	FROM DUAL
	UNION
	select 9, '[C.nPd-R.A-NID-DIS]', 'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 1  -- 9
	FROM DUAL
	UNION
	select 10, '[C.Pa-R.Pb-JUD-DIS]' , 'Discrepacias - Tipo Procedimiento. TPO Recovery [...], TPO Conexp. [...].', 1 -- 10
	FROM DUAL
	UNION
	select 11, '[C.DoA-R.N-NID-DES]', 'Despreciable - No está en Recovery, estado Conexp. [...]', 1  -- 11
	FROM DUAL
	UNION
	select 12, '[C.DoA-R.DoA-PRE-DES]', 'Despreciable PRE-Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 1 -- 12 
	FROM DUAL
	UNION
	select 13, '[C.DoA-R.DoA-JUD-DES]', 'Despreciable Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 1 -- 13
	FROM DUAL
	UNION
	select 14, '[C.Pd-R.nA-JUD-DIS]', 'Discrepacias - Situación Judicial. Estado Recovery [...], estado Conexp. [...].' , 1
	FROM DUAL
	UNION
	select 15, '[C.nA-R.TAD-PRE-DIS]', 'Discrepacias - Situación Prejudicial. Estado Recovery [...], estado Conexp. [...].', 1 
	FROM DUAL
	UNION
	select 16, '[C.A-R.nA-JUD-DIS]', 'Discrepacias - Estado Recovery [...], estado Conexp. [...].', 1
	FROM DUAL
	UNION
	select 17, '[C.AnAr-R.A-NID-DIS]', 'Discrepacias - Archivado o Anulado en Conexp, Activo en Recovery. Estado Recovery [...], estado Conexp. [...].', 1 -- 17
	FROM DUAL
; 

commit;

-- BBVA (2)
insert into D_CATEGORIA_ESTADO_CRUCE(CEC_ID, CEC_DESC, CEC_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	select 0, '[R.nAyD-JUD-DES]', 'Despreciables, estan en ambos sistemas, duplicados y no activos', 2  -- 0
	FROM DUAL
	UNION 	
	select 1, '[TAD-PRE-COR]', 'Pre-Judiciales correctamente vinculados', 2  -- 1
	FROM DUAL
	UNION 
	select 2, '[ACT-JUD-COR]', 'Judiciales correctamente vinculados', 2 -- 2
	FROM DUAL
	UNION 
	select 3, '[FIN-JUD-COR]', 'Judiciales correctamente vinculados, y FINALIZADOS', 2 -- 3
	FROM DUAL
	UNION 
	select 4, '[FIN-PRE-COR]', 'Pre-Judiciales correctamente vinculados, y FINALIZADOS', 2  -- 4
	FROM DUAL
	UNION
	select 5, '[C.N-R.A-JUD-DIS]', 'Discrepacias - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 2 -- 5
	FROM DUAL
	UNION
	select 18, '[C.N-R.A-JUD-DES]', 'Despreciable - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 2  -- 18
	FROM DUAL
	UNION
	select 6, '[C.DoA-R.N-PRE-DIS]', 'Discrepacias - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 2 -- 6
	FROM DUAL
	UNION
	select 22, '[C.DoA-R.N-PRE-COR]', 'Pre-Judiciales correctamente vinculados - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 2 -- 22
	FROM DUAL
	UNION
	select 23, '[C.ApF-R.N-JUD-COR]', 'No está en Recovery. JUDICIAL:> Estado Conexp [...].', 2 -- 23
	FROM DUAL
	UNION
	select 24, '[R.FinJud-JUD-COR]', 'Correctos, ya han finalizado y se ha quitado el despacho de CDD - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 2 -- 24
	FROM DUAL
	UNION
	select 7, '[C.Pd-R.N-JUD-DIS]', 'Discrepacias - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 2 -- 7
	FROM DUAL
	UNION
	select 8, '[C.Pd-R.TAD-PvJ-DIS]' ,'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 2 -- 8
	FROM DUAL
	UNION
	select 9, '[C.nPd-R.A-NID-DIS]', 'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 2  -- 9
	FROM DUAL
	UNION
	select 10, '[C.Pa-R.Pb-JUD-DIS]' , 'Discrepacias - Tipo Procedimiento. TPO Recovery [...], TPO Conexp. [...].', 2 -- 10
	FROM DUAL
	UNION
	select 11, '[C.DoA-R.N-NID-DES]', 'Despreciable - No está en Recovery, estado Conexp. [...]', 2  -- 11
	FROM DUAL
	UNION
	select 12, '[C.DoA-R.DoA-PRE-DES]', 'Despreciable PRE-Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 2 -- 12 
	FROM DUAL
	UNION
	select 13, '[C.DoA-R.DoA-JUD-DES]', 'Despreciable Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 2 -- 13
	FROM DUAL
	UNION
	select 14, '[C.Pd-R.nA-JUD-DIS]', 'Discrepacias - Situación Judicial. Estado Recovery [...], estado Conexp. [...].' , 2 -- 14
	FROM DUAL
	UNION
	select 15, '[C.nA-R.TAD-PRE-DIS]', 'Discrepacias - Situación Prejudicial. Estado Recovery [...], estado Conexp. [...].', 2  -- 15
	FROM DUAL
	UNION
	select 16, '[C.A-R.nA-JUD-DIS]', 'Discrepacias - Estado Recovery [...], estado Conexp. [...].', 2 -- 16
	FROM DUAL
	UNION
	select 17, '[C.AnAr-R.A-NID-DIS]', 'Discrepacias - Archivado o Anulado en Conexp, Activo en Recovery. Estado Recovery [...], estado Conexp. [...].', 2 -- 17
	FROM DUAL
; 

commit;

-- BANKIA (3)
insert into D_CATEGORIA_ESTADO_CRUCE(CEC_ID, CEC_DESC, CEC_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	select 0, '[R.nAyD-JUD-DES]', 'Despreciables, estan en ambos sistemas, duplicados y no activos', 3  -- 0
	FROM DUAL
	UNION 	
	select 1, '[TAD-PRE-COR]', 'Pre-Judiciales correctamente vinculados', 3  -- 1
	FROM DUAL
	UNION 
	select 2, '[ACT-JUD-COR]', 'Judiciales correctamente vinculados', 3 -- 2
	FROM DUAL
	UNION 
	select 3, '[FIN-JUD-COR]', 'Judiciales correctamente vinculados, y FINALIZADOS', 3 -- 3
	FROM DUAL
	UNION 
	select 4, '[FIN-PRE-COR]', 'Pre-Judiciales correctamente vinculados, y FINALIZADOS', 3  -- 4
	FROM DUAL
	UNION
	select 5, '[C.N-R.A-JUD-DIS]', 'Discrepacias - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 3 -- 5
	FROM DUAL
	UNION
	select 18, '[C.N-R.A-JUD-DES]', 'Despreciable - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 3  -- 18
	FROM DUAL
	UNION
	select 6, '[C.DoA-R.N-PRE-DIS]', 'Discrepacias - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 3 -- 6
	FROM DUAL
	UNION
	select 22, '[C.DoA-R.N-PRE-COR]', 'Pre-Judiciales correctamente vinculados - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 3 -- 22
	FROM DUAL
	UNION
	select 23, '[C.ApF-R.N-JUD-COR]', 'No está en Recovery. JUDICIAL:> Estado Conexp [...].', 3 -- 23
	FROM DUAL
	UNION
	select 24, '[R.FinJud-JUD-COR]', 'Correctos, ya han finalizado y se ha quitado el despacho de CDD - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 3 -- 24
	FROM DUAL
	UNION
	select 7, '[C.Pd-R.N-JUD-DIS]', 'Discrepacias - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 3 -- 7
	FROM DUAL
	UNION
	select 8, '[C.Pd-R.TAD-PvJ-DIS]' ,'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 3 -- 8
	FROM DUAL
	UNION
	select 9, '[C.nPd-R.A-NID-DIS]', 'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 3  -- 9
	FROM DUAL
	UNION
	select 10, '[C.Pa-R.Pb-JUD-DIS]' , 'Discrepacias - Tipo Procedimiento. TPO Recovery [...], TPO Conexp. [...].', 3 -- 10
	FROM DUAL
	UNION
	select 11, '[C.DoA-R.N-NID-DES]', 'Despreciable - No está en Recovery, estado Conexp. [...]', 3  -- 11
	FROM DUAL
	UNION
	select 12, '[C.DoA-R.DoA-PRE-DES]', 'Despreciable PRE-Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 3 -- 12 
	FROM DUAL
	UNION
	select 13, '[C.DoA-R.DoA-JUD-DES]', 'Despreciable Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 3 -- 13
	FROM DUAL
	UNION
	select 14, '[C.Pd-R.nA-JUD-DIS]', 'Discrepacias - Situación Judicial. Estado Recovery [...], estado Conexp. [...].' , 3 -- 14
	FROM DUAL
	UNION
	select 15, '[C.nA-R.TAD-PRE-DIS]', 'Discrepacias - Situación Prejudicial. Estado Recovery [...], estado Conexp. [...].', 3  -- 15
	FROM DUAL
	UNION
	select 16, '[C.A-R.nA-JUD-DIS]', 'Discrepacias - Estado Recovery [...], estado Conexp. [...].', 3 -- 16
	FROM DUAL
	UNION
	select 17, '[C.AnAr-R.A-NID-DIS]', 'Discrepacias - Archivado o Anulado en Conexp, Activo en Recovery. Estado Recovery [...], estado Conexp. [...].', 3 -- 17
	FROM DUAL
; 

commit;

-- CAJAMAR (4)
insert into D_CATEGORIA_ESTADO_CRUCE(CEC_ID, CEC_DESC, CEC_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	select 0, '[R.nAyD-JUD-DES]', 'Despreciables, estan en ambos sistemas, duplicados y no activos', 4  -- 0
	FROM DUAL
	UNION 	
	select 1, '[TAD-PRE-COR]', 'Pre-Judiciales correctamente vinculados', 4  -- 1
	FROM DUAL
	UNION 
	select 2, '[ACT-JUD-COR]', 'Judiciales correctamente vinculados', 4 -- 2
	FROM DUAL
	UNION 
	select 3, '[FIN-JUD-COR]', 'Judiciales correctamente vinculados, y FINALIZADOS', 4 -- 3
	FROM DUAL
	UNION 
	select 4, '[FIN-PRE-COR]', 'Pre-Judiciales correctamente vinculados, y FINALIZADOS', 4  -- 4
	FROM DUAL
	UNION
	select 5, '[C.N-R.A-JUD-DIS]', 'Discrepacias - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 4 -- 5
	FROM DUAL
	UNION
	select 18, '[C.N-R.A-JUD-DES]', 'Despreciable - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 4  -- 18
	FROM DUAL
	UNION
	select 6, '[C.DoA-R.N-PRE-DIS]', 'Discrepacias - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 4 -- 6
	FROM DUAL
	UNION
	select 22, '[C.DoA-R.N-PRE-COR]', 'Pre-Judiciales correctamente vinculados - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 4 -- 22
	FROM DUAL
	UNION
	select 23, '[C.ApF-R.N-JUD-COR]', 'No está en Recovery. JUDICIAL:> Estado Conexp [...].', 4 -- 23
	FROM DUAL
	UNION
	select 24, '[R.FinJud-JUD-COR]', 'Correctos, ya han finalizado y se ha quitado el despacho de CDD - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 4 -- 24
	FROM DUAL
	UNION
	select 7, '[C.Pd-R.N-JUD-DIS]', 'Discrepacias - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 4 -- 7
	FROM DUAL
	UNION
	select 8, '[C.Pd-R.TAD-PvJ-DIS]' ,'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 4 -- 8
	FROM DUAL
	UNION
	select 9, '[C.nPd-R.A-NID-DIS]', 'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 4  -- 9
	FROM DUAL
	UNION
	select 10, '[C.Pa-R.Pb-JUD-DIS]' , 'Discrepacias - Tipo Procedimiento. TPO Recovery [...], TPO Conexp. [...].', 4 -- 10
	FROM DUAL
	UNION
	select 11, '[C.DoA-R.N-NID-DES]', 'Despreciable - No está en Recovery, estado Conexp. [...]', 4  -- 11
	FROM DUAL
	UNION
	select 12, '[C.DoA-R.DoA-PRE-DES]', 'Despreciable PRE-Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 4 -- 12 
	FROM DUAL
	UNION
	select 13, '[C.DoA-R.DoA-JUD-DES]', 'Despreciable Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 4 -- 13
	FROM DUAL
	UNION
	select 14, '[C.Pd-R.nA-JUD-DIS]', 'Discrepacias - Situación Judicial. Estado Recovery [...], estado Conexp. [...].' , 4 -- 14
	FROM DUAL
	UNION
	select 15, '[C.nA-R.TAD-PRE-DIS]', 'Discrepacias - Situación Prejudicial. Estado Recovery [...], estado Conexp. [...].', 4  -- 15
	FROM DUAL
	UNION
	select 16, '[C.A-R.nA-JUD-DIS]', 'Discrepacias - Estado Recovery [...], estado Conexp. [...].', 4 -- 16
	FROM DUAL
	UNION
	select 17, '[C.AnAr-R.A-NID-DIS]', 'Discrepacias - Archivado o Anulado en Conexp, Activo en Recovery. Estado Recovery [...], estado Conexp. [...].', 4 -- 17
	FROM DUAL
; 


END MY_BLOCK_DIM_ESTADO
	select 9, '[C.nPd-R.A-NID-DIS]', 'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 2  -- 9
	FROM DUAL
	UNION
	select 10, '[C.Pa-R.Pb-JUD-DIS]' , 'Discrepacias - Tipo Procedimiento. TPO Recovery [...], TPO Conexp. [...].', 2 -- 10
	FROM DUAL
	UNION
	select 11, '[C.DoA-R.N-NID-DES]', 'Despreciable - No está en Recovery, estado Conexp. [...]', 2  -- 11
	FROM DUAL
	UNION
	select 12, '[C.DoA-R.DoA-PRE-DES]', 'Despreciable PRE-Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 2 -- 12 
	FROM DUAL
	UNION
	select 13, '[C.DoA-R.DoA-JUD-DES]', 'Despreciable Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 2 -- 13
	FROM DUAL
	UNION
	select 14, '[C.Pd-R.nA-JUD-DIS]', 'Discrepacias - Situación Judicial. Estado Recovery [...], estado Conexp. [...].' , 2 -- 14
	FROM DUAL
	UNION
	select 15, '[C.nA-R.TAD-PRE-DIS]', 'Discrepacias - Situación Prejudicial. Estado Recovery [...], estado Conexp. [...].', 2  -- 15
	FROM DUAL
	UNION
	select 16, '[C.A-R.nA-JUD-DIS]', 'Discrepacias - Estado Recovery [...], estado Conexp. [...].', 2 -- 16
	FROM DUAL
	UNION
	select 17, '[C.AnAr-R.A-NID-DIS]', 'Discrepacias - Archivado o Anulado en Conexp, Activo en Recovery. Estado Recovery [...], estado Conexp. [...].', 2 -- 17
	FROM DUAL
; 

-- BANKIA (3)
insert into D_CATEGORIA_ESTADO_CRUCE(CEC_ID, CEC_DESC, CEC_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	select 0, '[R.nAyD-JUD-DES]', 'Despreciables, estan en ambos sistemas, duplicados y no activos', 3  -- 0
	FROM DUAL
	UNION 	
	select 1, '[TAD-PRE-COR]', 'Pre-Judiciales correctamente vinculados', 3  -- 1
	FROM DUAL
	UNION 
	select 2, '[ACT-JUD-COR]', 'Judiciales correctamente vinculados', 3 -- 2
	FROM DUAL
	UNION 
	select 3, '[FIN-JUD-COR]', 'Judiciales correctamente vinculados, y FINALIZADOS', 3 -- 3
	FROM DUAL
	UNION 
	select 4, '[FIN-PRE-COR]', 'Pre-Judiciales correctamente vinculados, y FINALIZADOS', 3  -- 4
	FROM DUAL
	UNION
	select 5, '[C.N-R.A-JUD-DIS]', 'Discrepacias - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 3 -- 5
	FROM DUAL
	UNION
	select 18, '[C.N-R.A-JUD-DES]', 'Despreciable - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 3  -- 18
	FROM DUAL
	UNION
	select 6, '[C.DoA-R.N-PRE-DIS]', 'Discrepacias - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 3 -- 6
	FROM DUAL
	UNION
	select 22, '[C.DoA-R.N-PRE-COR]', 'Pre-Judiciales correctamente vinculados - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 3 -- 22
	FROM DUAL
	UNION
	select 23, '[C.ApF-R.N-JUD-COR]', 'No está en Recovery. JUDICIAL:> Estado Conexp [...].', 3 -- 23
	FROM DUAL
	UNION
	select 24, '[R.FinJud-JUD-COR]', 'Correctos, ya han finalizado y se ha quitado el despacho de CDD - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 3 -- 24
	FROM DUAL
	UNION
	select 7, '[C.Pd-R.N-JUD-DIS]', 'Discrepacias - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 3 -- 7
	FROM DUAL
	UNION
	select 8, '[C.Pd-R.TAD-PvJ-DIS]' ,'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 3 -- 8
	FROM DUAL
	UNION
	select 9, '[C.nPd-R.A-NID-DIS]', 'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 3  -- 9
	FROM DUAL
	UNION
	select 10, '[C.Pa-R.Pb-JUD-DIS]' , 'Discrepacias - Tipo Procedimiento. TPO Recovery [...], TPO Conexp. [...].', 3 -- 10
	FROM DUAL
	UNION
	select 11, '[C.DoA-R.N-NID-DES]', 'Despreciable - No está en Recovery, estado Conexp. [...]', 3  -- 11
	FROM DUAL
	UNION
	select 12, '[C.DoA-R.DoA-PRE-DES]', 'Despreciable PRE-Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 3 -- 12 
	FROM DUAL
	UNION
	select 13, '[C.DoA-R.DoA-JUD-DES]', 'Despreciable Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 3 -- 13
	FROM DUAL
	UNION
	select 14, '[C.Pd-R.nA-JUD-DIS]', 'Discrepacias - Situación Judicial. Estado Recovery [...], estado Conexp. [...].' , 3 -- 14
	FROM DUAL
	UNION
	select 15, '[C.nA-R.TAD-PRE-DIS]', 'Discrepacias - Situación Prejudicial. Estado Recovery [...], estado Conexp. [...].', 3  -- 15
	FROM DUAL
	UNION
	select 16, '[C.A-R.nA-JUD-DIS]', 'Discrepacias - Estado Recovery [...], estado Conexp. [...].', 3 -- 16
	FROM DUAL
	UNION
	select 17, '[C.AnAr-R.A-NID-DIS]', 'Discrepacias - Archivado o Anulado en Conexp, Activo en Recovery. Estado Recovery [...], estado Conexp. [...].', 3 -- 17
	FROM DUAL
; 


-- CAJAMAR (4)
insert into D_CATEGORIA_ESTADO_CRUCE(CEC_ID, CEC_DESC, CEC_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	select 0, '[R.nAyD-JUD-DES]', 'Despreciables, estan en ambos sistemas, duplicados y no activos', 4  -- 0
	FROM DUAL
	UNION 	
	select 1, '[TAD-PRE-COR]', 'Pre-Judiciales correctamente vinculados', 4  -- 1
	FROM DUAL
	UNION 
	select 2, '[ACT-JUD-COR]', 'Judiciales correctamente vinculados', 4 -- 2
	FROM DUAL
	UNION 
	select 3, '[FIN-JUD-COR]', 'Judiciales correctamente vinculados, y FINALIZADOS', 4 -- 3
	FROM DUAL
	UNION 
	select 4, '[FIN-PRE-COR]', 'Pre-Judiciales correctamente vinculados, y FINALIZADOS', 4  -- 4
	FROM DUAL
	UNION
	select 5, '[C.N-R.A-JUD-DIS]', 'Discrepacias - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 4 -- 5
	FROM DUAL
	UNION
	select 18, '[C.N-R.A-JUD-DES]', 'Despreciable - No está en Conexp. JUDICIAL:> Estado Recovery [...].', 4  -- 18
	FROM DUAL
	UNION
	select 6, '[C.DoA-R.N-PRE-DIS]', 'Discrepacias - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 4 -- 6
	FROM DUAL
	UNION
	select 22, '[C.DoA-R.N-PRE-COR]', 'Pre-Judiciales correctamente vinculados - No está en Recovery. PREJUDICIAL:> Estado Conexp [...].', 4 -- 22
	FROM DUAL
	UNION
	select 23, '[C.ApF-R.N-JUD-COR]', 'No está en Recovery. JUDICIAL:> Estado Conexp [...].', 4 -- 23
	FROM DUAL
	UNION
	select 24, '[R.FinJud-JUD-COR]', 'Correctos, ya han finalizado y se ha quitado el despacho de CDD - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 4 -- 24
	FROM DUAL
	UNION
	select 7, '[C.Pd-R.N-JUD-DIS]', 'Discrepacias - No está en Recovery. JUDICIAL:> Estado Conexp [...].', 4 -- 7
	FROM DUAL
	UNION
	select 8, '[C.Pd-R.TAD-PvJ-DIS]' ,'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 4 -- 8
	FROM DUAL
	UNION
	select 9, '[C.nPd-R.A-NID-DIS]', 'Discrepacias - Situación PrejudicialvsJudicial. Estado Recovery [...], estado Conexp. [...].', 4  -- 9
	FROM DUAL
	UNION
	select 10, '[C.Pa-R.Pb-JUD-DIS]' , 'Discrepacias - Tipo Procedimiento. TPO Recovery [...], TPO Conexp. [...].', 4 -- 10
	FROM DUAL
	UNION
	select 11, '[C.DoA-R.N-NID-DES]', 'Despreciable - No está en Recovery, estado Conexp. [...]', 4  -- 11
	FROM DUAL
	UNION
	select 12, '[C.DoA-R.DoA-PRE-DES]', 'Despreciable PRE-Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 4 -- 12 
	FROM DUAL
	UNION
	select 13, '[C.DoA-R.DoA-JUD-DES]', 'Despreciable Judicial- En ambos sistemas, pero ANULADOS EN AMBOS, estado Recovery. [...], estado Conexp. [...].', 4 -- 13
	FROM DUAL
	UNION
	select 14, '[C.Pd-R.nA-JUD-DIS]', 'Discrepacias - Situación Judicial. Estado Recovery [...], estado Conexp. [...].' , 4 -- 14
	FROM DUAL
	UNION
	select 15, '[C.nA-R.TAD-PRE-DIS]', 'Discrepacias - Situación Prejudicial. Estado Recovery [...], estado Conexp. [...].', 4  -- 15
	FROM DUAL
	UNION
	select 16, '[C.A-R.nA-JUD-DIS]', 'Discrepacias - Estado Recovery [...], estado Conexp. [...].', 4 -- 16
	FROM DUAL
	UNION
	select 17, '[C.AnAr-R.A-NID-DIS]', 'Discrepacias - Archivado o Anulado en Conexp, Activo en Recovery. Estado Recovery [...], estado Conexp. [...].', 4 -- 17
	FROM DUAL
; 


END MY_BLOCK_DIM_ESTADO

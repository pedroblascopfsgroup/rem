-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Fecha_Otras` $$
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Fecha_Otras`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_FEC_OTR: BEGIN
-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creación: Octubre 2015
-- Responsable última modificación: María Villanueva, PFS Group
-- Fecha última modificación: 12/11/2015
-- Motivos del cambio: Fecha CARGA DATOS
-- Cliente: Recovery BI CDD 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensiones Fecha Interposición de demanda y fecha carga datos
-- ===============================================================================================

-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN FECHA_INTERPOSICION_DEMANDA
    -- DIM_FECHA_INTERPOS_DEMANDA_ANIO
    -- DIM_FECHA_INTERPOS_DEMANDA_TRIMESTRE
    -- DIM_FECHA_INTERPOS_DEMANDA_MES
    -- DIM_FECHA_INTERPOS_DEMANDA_DIA
    -- DIM_FECHA_INTERPOS_DEMANDA_DIA_SEMANA
    -- DIM_FECHA_INTERPOS_DEMANDA_MES_ANIO
-- DIMENSIÓN FECHA_CARGA_DATOS
    -- D_F_CARGA_DATOS_ANIO
    -- D_F_CARGA_DATOS_TRIMESTRE
    -- D_F_CARGA_DATOS_MES
    -- D_F_CARGA_DATOS_DIA
    -- D_F_CARGA_DATOS_DIA_SEMANA
    -- D_F_CARGA_DATOS_MES_ANIO

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
--                              DIM_FECHA_INTERPOS_DEMANDA
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      DIM_FECHA_INTERPOS_DEMANDA_ANIO
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
 
		insert into DIM_FECHA_INTERPOS_DEMANDA_ANIO
      (ANIO_INTERPOS_DEMANDA_ID,
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
--                                  DIM_FECHA_INTERPOS_DEMANDA_TRIMESTRE
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
		
    insert into DIM_FECHA_INTERPOS_DEMANDA_TRIMESTRE
       (TRIMESTRE_INTERPOS_DEMANDA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INTERPOS_DEMANDA_ID,
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
--                                      DIM_FECHA_INTERPOS_DEMANDA_MES
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

    insert into DIM_FECHA_INTERPOS_DEMANDA_MES
      (MES_INTERPOS_DEMANDA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INTERPOS_DEMANDA_ID,
			 TRIMESTRE_INTERPOS_DEMANDA_ID,
			 ANIO_INTERPOS_DEMANDA_ID,
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
--                                      DIM_FECHA_INTERPOS_DEMANDA_DIA
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
	
		insert into DIM_FECHA_INTERPOS_DEMANDA_DIA
      (DIA_INTERPOS_DEMANDA_ID,
       DIA_SEMANA_INTERPOS_DEMANDA_ID,
       MES_INTERPOS_DEMANDA_ID,
       TRIMESTRE_INTERPOS_DEMANDA_ID,
       ANIO_INTERPOS_DEMANDA_ID ,
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
--                                      DIM_FECHA_INTERPOS_DEMANDA_DIA_SEMANA
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

		insert into DIM_FECHA_INTERPOS_DEMANDA_DIA_SEMANA
      (DIA_SEMANA_INTERPOS_DEMANDA_ID,
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
--                                      DIM_FECHA_INTERPOS_DEMANDA_MES_ANIO
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
    
		insert into DIM_FECHA_INTERPOS_DEMANDA_MES_ANIO
      (MES_ANIO_INTERPOS_DEMANDA_ID,
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
--                              D_F_CARGA_DATOS
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                      D_F_CARGA_DATOS_ANIO
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
 
		insert into D_F_CARGA_DATOS_ANIO
      (ANIO_CARGA_DATOS_ID,
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
--                                  D_F_CARGA_DATOS_TRIMESTRE
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
		
    insert into D_F_CARGA_DATOS_TRIMESTRE
       (TRIMESTRE_CARGA_DATOS_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CARGA_DATOS_ID,
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
--                                      D_F_CARGA_DATOS_MES
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

    insert into D_F_CARGA_DATOS_MES
      (MES_CARGA_DATOS_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CARGA_DATOS_ID,
			 TRIMESTRE_CARGA_DATOS_ID,
			 ANIO_CARGA_DATOS_ID,
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
--                                      D_F_CARGA_DATOS_DIA
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
	
		insert into D_F_CARGA_DATOS_DIA
      (DIA_CARGA_DATOS_ID,
       DIA_SEMANA_CARGA_DATOS_ID,
       MES_CARGA_DATOS_ID,
       TRIMESTRE_CARGA_DATOS_ID,
       ANIO_CARGA_DATOS_ID ,
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
--                                      D_F_CARGA_DATOS_DIA_SEMANA
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

		insert into D_F_CARGA_DATOS_DIA_SEMANA
      (DIA_SEMANA_CARGA_DATOS_ID,
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
--                                      D_F_CARGA_DATOS_MES_ANIO
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
    
		insert into D_F_CARGA_DATOS_MES_ANIO
      (MES_ANIO_CARGA_DATOS_ID,
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

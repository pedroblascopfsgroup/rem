-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Fecha` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Fecha`(IN ANIO_ENTRADA INT, IN NUM_ANIOS INT, OUT o_error_status varchar(500))
MY_BLOCK_DIM_FEC: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Fecha.
-- ===============================================================================================

-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN FECHA
    -- D_F_ANIO
    -- D_F_TRIMESTRE
    -- D_F_MES
    -- D_F_DIA
    -- D_F_SEMANA
    -- D_F_SEMANA_ANIO
    -- D_F_DIA_SEMANA
    -- D_F_MES_ANIO
    -- D_F_MTD
    -- D_F_QTD
    -- D_F_YTD
    -- D_F_ULT_6_MESES
    -- D_F_ULT_12_MESES



  
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================

declare i int;
declare y int;
declare num_years int;
declare max_date date;
declare insert_date date;
declare anio_curso date;

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
declare cierre_mes_id int;
declare month_desc_de varchar(50);
declare month_desc_en varchar(50);
declare month_desc_fr varchar(50);
declare month_desc_it varchar(50);

-- Day
declare dias int;
declare day_date date;
declare prev_day_date date;
declare lm_day_date date;
declare lq_day_date date;
declare ly_day_date date;

-- Semana
declare semana int;
declare semana_id int;
declare semana_anterior_id int;
declare semana_ant int;
declare dias_anio_ant int;
declare duracion int;
declare semana_fecha date;
declare semana_desc varchar(50);
declare semana_desc_alt varchar(50);
declare semana_desc_en varchar(50);
declare semana_desc_de varchar(50);
declare semana_desc_fr varchar(50);
declare semana_desc_it varchar(50);
declare week_of_year_id int;
declare week_of_year_desc varchar(50);
declare week_of_year_desc_en varchar(50);
declare week_of_year_desc_de varchar(50);	 
declare week_of_year_desc_fr varchar(50); 
declare week_of_year_desc_it varchar(50);

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

-- YTD, QTD, MTD
declare min_date date;
declare curr_date date; 
declare mtd_date date;
declare max_month_date date;
declare max_quarter_date date;
declare qtd_date date;
declare max_year_date date;
declare ytd_date date;

-- 6/12 Últimos meses   
declare min_mes int;
declare max_mes int; 
declare curr_mes int;
declare ult_6_meses int;
declare ult_12_meses int;
declare mes_actual int;

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
--                                      D_F_ANIO
-- ----------------------------------------------------------------------------------------------
set i=0;
set num_years = NUM_ANIOS;
set max_date = MAKEDATE(ANIO_ENTRADA,1);

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
 
		insert into D_F_ANIO
      (ANIO_ID,
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
--                                  D_F_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
set i=0;

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
		
    insert into D_F_TRIMESTRE
       (TRIMESTRE_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ID,
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
--                                      D_F_MES
-- ----------------------------------------------------------------------------------------------
set i=0;

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
    -- MES_CIERRE_ANIO_ID
    set cierre_mes_id = concat(year(date_add(month_date, INTERVAL -1 year)), '12');
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

    insert into D_F_MES
      (MES_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ID,
			 TRIMESTRE_ID,
			 ANIO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
       MES_CIERRE_ANIO_ID,       
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
       cierre_mes_id,       
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
		set i=(i+1);
	end while; -- while	
    
 set lc_time_names = 'es_ES';   


-- ----------------------------------------------------------------------------------------------
--                                      D_F_DIA
-- ----------------------------------------------------------------------------------------------
set y=0;

while (y<num_years)
    do
    -- miramos si el año es bisiesto
        set anio_curso = date_add(max_date, INTERVAL y year);
        set dias = datediff(date_add(anio_curso, INTERVAL 1 YEAR) , anio_curso);
    
        set i=0;
        while (i<dias)
            do
                set insert_date = date_add(anio_curso, INTERVAL i day);
                
                -- calculamos el resto del número de día del año para saber a que semana pertenece entre 7
                case dayofyear(insert_date) % 7
                     when 0 then
                        -- Si el número del año es múltiplo de siete y es domingo, la semana es el número/7
                        if dayofweek(date_add(anio_curso, INTERVAL i day)) = 1 then
                            set semana = TRUNCATE(dayofyear(insert_date)/7,0);
                        -- Si es múltiplo de siete y no es domingo la semana es el número/7 + 1
                        else
                            set semana = TRUNCATE(dayofyear(insert_date)/7,0) + 1;
                        end if;
                        -- Si tenemos resto 1
                     when 1 then
                        -- La semana es el número de día del año entre siete redondeado al entero más próximo más uno.
                        set semana = ROUND (dayofyear(insert_date)/7) + 1;
                        -- Si tenemos resto 2
                     when 2 then
                        -- Si es lunes
                        if dayofweek(insert_date) = 2 then
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano y le sumamos dos
                            set semana = ROUND (dayofyear(insert_date)/7) + 2;
                        -- Si es cualquier otro día
                        else
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano y le sumamos uno
                            set semana = ROUND (dayofyear(insert_date)/7) + 1;
                        end if;
                     when 3 then
                        -- Si es lunes o martes
                        if (dayofweek(date_add(date_add(max_date, INTERVAL y year), INTERVAL i day)) = 2 or dayofweek(date_add(date_add(max_date, INTERVAL y year), INTERVAL i day)) = 3) then
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano y le sumamos dos
                            set semana = ROUND (dayofyear(insert_date)/7) + 2;
                        else
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano y le sumamos uno
                            set semana = ROUND (dayofyear(insert_date)/7) + 1;
                        end if;
                     when 4 then
                        -- Si es lunes, martes o miércoles
                        if (dayofweek(insert_date) = 2 or dayofweek(insert_date) = 3 or dayofweek(insert_date) = 4) then
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano y le sumamos uno
                            set semana = ROUND (dayofyear(insert_date)/7) + 1;
                        -- Cualquier otro día de la semana
                        else
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano
                            set semana = ROUND (dayofyear(insert_date)/7);
                        end if;
                     when 5 then
                        -- Si es viernes, sábado o domingo
                        if (dayofweek(insert_date) = 6 or dayofweek(insert_date) = 7 or dayofweek(insert_date) = 1) then
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano
                            set semana = ROUND (dayofyear(insert_date)/7);
                        -- Cualquier otro día de la semana
                        else
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano y le sumamos uno
                            set semana = ROUND (dayofyear(insert_date)/7) + 1;                            
                        end if;
                     when 6 then
                        -- Si es sábado o domingo
                        if (dayofweek(insert_date) = 1 or dayofweek(insert_date) = 7) then
                            -- Dividimos el número del día del año entre siete y lo redondeamos al entero más cercano
                            set semana = ROUND (dayofyear(insert_date)/7);
                        -- El resto de días de la semana
                        else
                            -- Dividimos el número del día del año entre siete, lo redondeamos al entero más cercano y sumamos 1
                            set semana = ROUND (dayofyear(insert_date)/7) + 1;
                        end if;
                    end case;
                
                if semana < 10 then                        
                    set semana_id = concat(YEAR(insert_date), '0', semana);
                else
                    set semana_id = concat(YEAR(insert_date), semana);
                end if;                   
                                    
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

                insert into D_F_DIA
                (DIA_ID,
                DIA_SEMANA_ID,
                SEMANA_ID,
                MES_ID,
                TRIMESTRE_ID,
                ANIO_ID ,
                DIA_ANT_ID,
                DIA_ULT_MES_ID,
                DIA_ULT_TRIMESTRE_ID,
                DIA_ULT_ANIO_ID

                )
                values
                (day_date, 
                day_of_week_id,
                semana_id,
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
        
        set y= (y+1);
    end while;


-- ----------------------------------------------------------------------------------------------
--                                      D_F_SEMANA
-- ----------------------------------------------------------------------------------------------
-- Iniciamos el contador
set y = 0;    

-- Nos recorremos todos los años que tenemos que recorrernos
while (y < num_years) do                
    -- miramos si el año es bisiesto
    set anio_curso = date_add(max_date, INTERVAL y year);
    set dias = datediff(date_add(anio_curso, INTERVAL 1 YEAR) , anio_curso);
    
    set dias_anio_ant = abs(datediff(date_add(anio_curso, INTERVAL -1 YEAR) , anio_curso));
    
    -- Iniciamos el otro contador
    set i = 0;
    -- Inicializamos el número de semana
    set semana = 1;
    
    -- Nos recorremos todas las semanas del año
    while (i < dias) DO
        set insert_date = DATE_ADD(anio_curso, INTERVAL i DAY);
        set semana_ant = semana - 1;
        
        -- MES_ID
        case when (month(insert_date) < 10) then set month_id = concat(year(insert_date), '0', month(insert_date));
             else set month_id = concat(year(insert_date), month(insert_date));
        end case ;
        -- ANIO_ID
        set year_id = YEAR(insert_date);
        
        -- Si estamos mirando el 1 de Enero
        if i = 0 then
            -- Miramos en que cae el 1 de Enero del año de trabajo
            case dayofweek(insert_date)
                -- Domingo
                when 1 then
                    set duracion = 1;
                    set i = (i - 6);                                               
                -- Lunes
                when 2 then                        
                    set duracion = 7;                          
                -- Martes
                when 3 then
                    set duracion = 6;
                    set i = (i - 1);                        
                -- Miércoles
                when 4 then
                    set duracion = 5;
                    set i = (i - 2);                        
                -- Jueves
                when 5 then
                    set duracion = 4;
                    set i = (i - 3);                        
                -- Viernes
                when 6 then
                    set duracion = 3;
                    set i = (i - 4);                       
                -- Sabado
                when 7 then
                    set duracion = 2;
                    set i = (i - 5);
            end case;  
            -- SEMANA_ANTERIOR_ID - Primera semana del año
            -- Si el 1 de Enero del año anterior era domingo y el año era bisiesto
            -- if (dayofweek(MAKEDATE(year_id - 1,1)) = 1) and (((year_id - 1) % 4 = 0 and (year_id - 1) & 100 != 0) or ((year_id - 1) % 400 = 0)) then                
            if (dayofweek(date_add(anio_curso, INTERVAL -1 year)) = 1) and (dias_anio_ant = 366) then
                set semana_anterior_id = concat(year_id - 1, '54');                  
            else 
                set semana_anterior_id = concat(year_id - 1, '53');
            end if;
        
        elseif (dias = 366) and (i between 359 and 365) then
            case 
                when i = 365 then set duracion = 1;                    
                when i = 364 then set duracion = 2;                    
                when i = 363 then set duracion = 3;
                when i = 362 then set duracion = 4;
                when i = 361 then set duracion = 5;
                when i = 360 then set duracion = 6;
                when i = 359 then set duracion = 7;
            end case;
            -- SEMANA_ANTERIOR_ID - Última semana de un año bisiesto
            if semana_ant < 10 then
                set semana_anterior_id = concat(year_id, '0', semana_ant);
            else 
                set semana_anterior_id = concat(year_id, semana_ant);
            end if;
            
        -- La última semana de un año no bisiesto
        elseif (dias = 365) and (i between 358 and 364) then
            case
                when i = 364 then set duracion = 1;                    
                when i = 363 then set duracion = 2;                    
                when i = 362 then set duracion = 3;
                when i = 361 then set duracion = 4;
                when i = 360 then set duracion = 5;
                when i = 359 then set duracion = 6;
                when i = 358 then set duracion = 7;
            end case;
            -- SEMANA_ANTERIOR_ID - Última semana de un año no bisiesto
            if semana_ant < 10 then
                set semana_anterior_id = concat(year_id, '0', semana_ant);
            else 
                set semana_anterior_id = concat(year_id, semana_ant);
            end if;
        else
            set duracion = 7;
            -- SEMANA_ANTERIOR_ID - Resto semanas
            if semana_ant < 10 then
                set semana_anterior_id = concat(year_id, '0', semana_ant);
            else 
                set semana_anterior_id = concat(year_id, semana_ant);
            end if;
        end if;
        
        -- SEMANA_FECHA
        set semana_fecha = insert_date;
                                
        -- SEMANA_ID
        if semana < 10 then
            set semana_id = concat(year_id, '0', semana);
        else
            set semana_id = concat(year_id, semana);
        end if;
        
        -- SEMANA_DESC
        set semana_desc = concat(year_id, ' Sem ', semana);
        -- SEMANA_DESC_ALT
        set semana_desc_alt = concat('Semana ', semana);
        -- SEMANA_DESC_EN
        set semana_desc_en = concat(year_id, ' W', semana);
        -- SEMANA_DESC_DE
        set semana_desc_de = concat(year_id, ' W', semana);
        -- SEMANA_DESC_FR
        set semana_desc_fr = concat(year_id, ' W', semana);
        -- SEMANA_DESC_IT
        set semana_desc_it = concat(year_id, ' W', semana);
        
        set week_of_year_id = semana;   
        
        insert into D_F_SEMANA
        (
            SEMANA_ID,
            SEMANA_FECHA,
            SEMANA_DESC,
            SEMANA_DESC_ALT,
            SEMANA_DURACION,  
            SEMANA_ANIO_ID,
            MES_ID,
            ANIO_ID,
            SEM_ANT_ID,  
            SEMANA_DESC_EN,
            SEMANA_DESC_DE,
            SEMANA_DESC_FR,
            SEMANA_DESC_IT
        )
        values
        (
            semana_id,
            semana_fecha,
            semana_desc,
            semana_desc_alt,
            duracion,
            week_of_year_id,
            month_id,
            year_id,
            semana_anterior_id,  
            semana_desc_en,
            semana_desc_de,
            semana_desc_fr,
            semana_desc_it
        );
        
        set semana = (semana + 1);
        set i = (i + 7);
    end while;           
        
    set y = (y + 1);
end while;


-- ----------------------------------------------------------------------------------------------
--                                      D_F_SEMANA_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
while (i<=53)
	do	
    -- SEMANA_ANIO_ID
		set week_of_year_id = i;
		-- SEMANA_ANIO_DESC
		set week_of_year_desc =  concat('Semana ', i);
		-- SEMANA_ANIO_DESC_EN
		set week_of_year_desc_en = concat('Week ', i);
		-- SEMANA_ANIO_DESC_DE
		set week_of_year_desc_de = concat('Woche ', i);
		-- SEMANA_ANIO_DESC_FR
		set week_of_year_desc_fr = concat('Semaine ', i);
		-- SEMANA_ANIO_DESC_IT
		set week_of_year_desc_it = concat('Settimana ', i);
  	
		insert into D_F_SEMANA_ANIO
      (SEMANA_ANIO_ID,
       SEMANA_ANIO_DESC,
       SEMANA_ANIO_DESC_EN,
       SEMANA_ANIO_DESC_DE,
       SEMANA_ANIO_DESC_FR,
       SEMANA_ANIO_DESC_IT
			)
		 values
			(week_of_year_id, 
			 week_of_year_desc,
			 week_of_year_desc_en,
		 	 week_of_year_desc_de,
		 	 week_of_year_desc_fr,
		 	 week_of_year_desc_it
			);
        set i=(i+1);
    end while; -- while	 
    
    
-- ----------------------------------------------------------------------------------------------
--                                      D_F_DIA_SEMANA
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

		insert into D_F_DIA_SEMANA
      (DIA_SEMANA_ID,
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
--                                      D_F_MES_ANIO
-- ----------------------------------------------------------------------------------------------
set i=1;
set max_date = '1989-12-01';

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
    
		insert into D_F_MES_ANIO
      (MES_ANIO_ID,
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
--                                      D_F_MTD
-- ----------------------------------------------------------------------------------------------
-- Límites del bucle exterior
set min_date = (select min(DIA_ID) from D_F_DIA);
set max_date = (select max(DIA_ID) from D_F_DIA);

set curr_date = min_date;
while (curr_date <= max_date)
	do
	-- Fijo mtd_date a principio de mes y max_month_date al último día del mes
	set mtd_date = date_add(last_day(date_sub(curr_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY);
	set max_month_date = last_day(curr_date);
	while ((mtd_date <= max_month_date) and (mtd_date <= curr_date))
			do				
				insert into D_F_MTD
				   (DIA_ID,
				    MTD_DIA
					 )
				 values
           (curr_date, 
            mtd_date
           );
				set mtd_date = date_add(mtd_date, INTERVAL 1 DAY);
			end while;
	set curr_date = date_add(curr_date, INTERVAL 1 DAY);
	end while; -- while	


-- ----------------------------------------------------------------------------------------------
--                                      D_F_QTD
-- ----------------------------------------------------------------------------------------------
-- Límites del bucle exterior
set min_date = (select min(DIA_ID) from D_F_DIA);
set max_date = (select max(DIA_ID) from D_F_DIA);

set curr_date = min_date;
while (curr_date <= max_date)
	do
	-- Fijo qtd_date a principio de trimestre y max_quarter_date al último día del trimestre
  case quarter(curr_date) when 1 then set qtd_date = concat(year(curr_date), '-01-01');
        when 2 then set qtd_date = concat(year(curr_date), '-04-01');
        when 3 then set qtd_date = concat(year(curr_date), '-07-01');
        when 4 then set qtd_date = concat(year(curr_date), '-10-01');
  end case ;
	set max_quarter_date = date_sub(date_add(qtd_date, interval 1 QUARTER), interval 1 DAY);
	while ((qtd_date <= max_quarter_date) and (qtd_date <= curr_date))
			do				
				insert into D_F_QTD
				   (DIA_ID,
				    QTD_DIA
					 )
				 values
           (curr_date, 
            qtd_date
           );
				set qtd_date = date_add(qtd_date, INTERVAL 1 DAY);
			end while;
	set curr_date = date_add(curr_date, INTERVAL 1 DAY);
	end while; -- while	
   

-- ----------------------------------------------------------------------------------------------
--                                      D_F_YTD
-- ----------------------------------------------------------------------------------------------
-- Límites del bucle exterior
set min_date = (select min(DIA_ID) from D_F_DIA);
set max_date = (select max(DIA_ID) from D_F_DIA);

set curr_date = min_date;
while (curr_date <= max_date)
	do
	-- Fijo ytd_date a principio de año y max_year_date al último día del año
  set ytd_date = concat(year(curr_date), '-01-01');
	set max_year_date = date_sub(date_add(ytd_date, interval 1 YEAR), interval 1 DAY);
	while ((ytd_date <= max_year_date) and (ytd_date <= curr_date))
			do				
				insert into D_F_YTD
				   (DIA_ID,
				    YTD_DIA
					 )
				 values
           (curr_date, 
            ytd_date
           );
				set ytd_date = date_add(ytd_date, INTERVAL 1 DAY);
			end while;
	set curr_date = date_add(curr_date, INTERVAL 1 DAY);
	end while; -- while	
    

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULT_6_MESES
-- ----------------------------------------------------------------------------------------------
-- Límites del bucle exterior
set min_mes = (select min(MES_ID) from D_F_MES);
set max_mes = (select max(MES_ID) from D_F_MES);

set curr_mes = min_mes;
while (curr_mes <= max_mes)
	do
	-- Fijo ult_6_meses a 6 meses antes y mes_actual al mes actual    
  set ult_6_meses = (select concat(substring(date_add(MES_FECHA, INTERVAL -5 MONTH),1, 4), substring(date_add(MES_FECHA, INTERVAL -5 MONTH),6, 2)) from D_F_MES where MES_ID = curr_mes);    
	set mes_actual = curr_mes;
    
	while (ult_6_meses <= mes_actual)
			do				
				insert into D_F_ULT_6_MESES
				   (MES_ID,
				    ULT_6_MESES_ID
					 )
				 values
           (curr_mes, 
            ult_6_meses
           );
				set ult_6_meses = (select concat(substring(date_add(MES_FECHA, INTERVAL 1 MONTH),1, 4), substring(date_add(MES_FECHA, INTERVAL 1 MONTH),6, 2)) from D_F_MES where MES_ID = ult_6_meses);    
			end while;
	set curr_mes = (select MIN(MES_ID) from D_F_MES WHERE MES_ID > curr_mes);
	end while; -- while	
   

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULT_12_MESES
-- ----------------------------------------------------------------------------------------------
-- Límites del bucle exterior
set min_mes = (select min(MES_ID) from D_F_MES);
set max_mes = (select max(MES_ID) from D_F_MES);

set curr_mes = min_mes;
while (curr_mes <= max_mes)
	do
	-- Fijo ult_12_meses a 11 meses antes y mes_actual al mes actual    
  set ult_12_meses = (select concat(substring(date_add(MES_FECHA, INTERVAL -11 MONTH),1, 4), substring(date_add(MES_FECHA, INTERVAL -11 MONTH),6, 2)) from D_F_MES where MES_ID = curr_mes);    
	set mes_actual = curr_mes;
    
	while (ult_12_meses <= mes_actual)
			do				
				insert into D_F_ULT_12_MESES
				   (MES_ID,
				    ULT_12_MESES_ID
					 )
				 values
           (curr_mes, 
            ult_12_meses
           );
				set ult_12_meses = (select concat(substring(date_add(MES_FECHA, INTERVAL 1 MONTH),1, 4), substring(date_add(MES_FECHA, INTERVAL 1 MONTH),6, 2)) from D_F_MES where MES_ID = ult_12_meses);    
			end while;
	set curr_mes = (select MIN(MES_ID) from D_F_MES WHERE MES_ID > curr_mes);
	end while; -- while	
  
  
END MY_BLOCK_DIM_FEC

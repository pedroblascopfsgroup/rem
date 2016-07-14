create or replace PROCEDURE CARGAR_DIM_FECHA (p_ANIO_ENTRADA IN INTEGER, p_NUM_ANIOS IN INTEGER) IS

-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca, PFS Group
-- Fecha creación: Junio 2014
-- Responsable última modificación: Diego Pérez, PFS Group
-- Fecha última modificación: 29/01/2015
-- Motivos del cambio: Incluir LOG's
-- Cliente: Recovery BI PRODUCTO 
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

 i int;
 y int;
 v_Control NUMBER := 0;
 num_years NUMBER;
 max_date date;
 insert_date date;
 anio_curso NUMBER;

-- Año
 year_id NUMBER;
 year_date date;
 year_duration NUMBER;
 prev_year_id NUMBER;

-- Trimestre
 quarter_id NUMBER;
 quarter_date date;
 first_day_actual_year date;
 next_insert_date DATE;
 number_of_quarter NUMBER;
 quarter_desc varchar2(50);
 quarter_duration NUMBER;
 prev_quarter_id NUMBER;
 ly_quarter_id NUMBER;
 quarter_desc_de varchar2(50);
 quarter_desc_en varchar2(50);
 quarter_desc_fr varchar2(50);
 quarter_desc_it varchar2(50);

-- Month
 month_id NUMBER;
 month_date date;
 month_desc varchar2(50);
 month_duration NUMBER;
 prev_month_id NUMBER;
 lq_month_id NUMBER;
 ly_month_id NUMBER;
 cierre_mes_id NUMBER;
 month_desc_de varchar2(50);
 month_desc_en varchar2(50);
 month_desc_fr varchar2(50);
 month_desc_it varchar2(50);

-- Day
 dias NUMBER;
 day_date date;
 prev_day_date date;
 lm_day_date date;
 lq_day_date date;
 ly_day_date date;

-- Semana
 num_semanas_anio NUMBER;
 semana NUMBER;
 semana_id NUMBER;
 semana_anterior_id NUMBER;
 semana_ant NUMBER;
 dias_anio_ant NUMBER;
 duracion NUMBER;
 semana_fecha date;
 semana_desc varchar(50);
 semana_desc_alt varchar(50);
 semana_desc_en varchar(50);
 semana_desc_de varchar(50);
 semana_desc_fr varchar(50);
 semana_desc_it varchar(50);
 week_of_year_id NUMBER;
 week_of_year_desc varchar2(50);
 week_of_year_desc_en varchar2(50);
 week_of_year_desc_de varchar2(50);     
 week_of_year_desc_fr varchar2(50); 
 week_of_year_desc_it varchar2(50);

-- Month of year
 month_of_year_id NUMBER;
 month_of_year_desc varchar2(50);
 month_of_year_desc_en varchar2(50);
 month_of_year_desc_de varchar2(50);     
 month_of_year_desc_fr varchar2(50); 
 month_of_year_desc_it varchar2(50);
    
-- Day of week
 day_of_week_id NUMBER;
 day_of_week_desc varchar2(50);
 day_of_week_desc_de varchar2(50);
 day_of_week_desc_en varchar2(50);     
 day_of_week_desc_fr varchar2(50);     
 day_of_week_desc_it varchar2(50);        

-- YTD, QTD, MTD
 min_date date;
 curr_date date; 
 mtd_date date;
 max_month_date date;
 max_quarter_date date;
 qtd_date date;
 max_year_date date;
 ytd_date date;

-- 6/12 Últimos meses   
 min_mes NUMBER;
 max_mes NUMBER; 
 curr_mes NUMBER;
 ult_6_meses NUMBER;
 ult_12_meses NUMBER;
 mes_actual NUMBER;



V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_FECHA';
V_ROWCOUNT NUMBER;
  
   
BEGIN

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ANIO
-- ----------------------------------------------------------------------------------------------

    i:=0;
    num_years := p_NUM_ANIOS;
    min_date := TO_DATE('01-01-'||p_ANIO_ENTRADA, 'DD/MM/RRRR');

   DELETE FROM D_F_ANIO;

   COMMIT;
   
   WHILE (i<num_years) LOOP

		insert_date := ADD_MONTHS(min_date, (i*12));
 		-- YEAR_ID
 		year_id := TO_CHAR(insert_date, 'RRRR');
 		-- YEAR_DATE
 		year_date := insert_date;
 		-- YEAR_DURATION
 		year_duration := (TO_DATE('01/01-'||(year_id+1),'DD/MM/RRRR') - year_date);
    --  PREV_YEAR
 		prev_year_id := year_id - 1;
 
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
		
        i:=(i+1);

   END LOOP;
   
   COMMIT;
   
-- ----------------------------------------------------------------------------------------------
--                                  D_F_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
 i := 1;
 
 insert_date := NULL;
 
   DELETE FROM D_F_TRIMESTRE;

   COMMIT;

  WHILE (i <= num_years*4) LOOP

     year_id := TO_NUMBER(TO_CHAR(NVL(next_insert_date,min_date),'RRRR'));
     
     first_day_actual_year := TO_DATE('01-01-'||TO_CHAR(year_id), 'DD/MM/RRRR');
     

     insert_date := NVL(next_insert_date,min_date);

     next_insert_date := ADD_MONTHS(min_date, (i*3));
        

  -- ANIO_ID (Quarter)
--     anio_curso := TO_NUMBER(TO_CHAR(next_insert_date,'RRRR'));
     
	-- TRIMESTRE_ID
  
	 	 quarter_id := TO_CHAR(year_id) || TO_CHAR(insert_date,'Q');

  -- TRIMESTRE_DESC
     quarter_desc := TO_CHAR(year_id) || ' ' || TO_CHAR(insert_date,'Q') || ' ºTr';
	
  -- TRIMESTRE_DESC_EN
		 quarter_desc_en := TO_CHAR(year_id) || ' ' || TO_CHAR(insert_date,'Q') || 'Q';

  -- TRIMESTRE_DESC_DE
     quarter_desc_de := quarter_desc_en;

  -- TRIMESTRE_DESC_FR
		 quarter_desc_fr := quarter_desc_en;

	-- TRIMESTRE_DESC_IT
		 quarter_desc_it := quarter_desc_en;

	-- TRIMESTRE_DURACION
		 quarter_duration :=  (next_insert_date - insert_date);

  -- TRIMESTRE_ANT_ID
     SELECT DECODE(MONTHS_BETWEEN(next_insert_date,first_day_actual_year),0,1,MONTHS_BETWEEN(next_insert_date,first_day_actual_year)/3)
     INTO number_of_quarter
     FROM DUAL;

     SELECT DECODE(number_of_quarter,1, TO_CHAR(year_id - 1) || '4', TO_CHAR(year_id) || TO_CHAR((number_of_quarter-1)))
     INTO prev_quarter_id
     FROM DUAL;

  -- TRIMESTRE_ULT_ANIO_ID
     ly_quarter_id := TO_CHAR(year_id - 1) || TO_CHAR(insert_date,'Q');

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
			 insert_date,
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

		i := (i+1);

  END LOOP;
  
  COMMIT;
   
-- ----------------------------------------------------------------------------------------------
--                                      D_F_MES
-- ----------------------------------------------------------------------------------------------

 i := 1;
 
 insert_date := NULL;
 
 next_insert_date := NULL;
 
   DELETE FROM D_F_MES;

   COMMIT;

  WHILE (i <= num_years*12) LOOP


     year_id := TO_NUMBER(TO_CHAR(NVL(next_insert_date,min_date),'RRRR'));
     
     first_day_actual_year := TO_DATE('01-01-'||TO_CHAR(year_id), 'DD/MM/RRRR');
     
     insert_date := NVL(next_insert_date,min_date);

     next_insert_date := ADD_MONTHS(min_date, i);

     month_id := TO_CHAR(year_id) ||LPAD(TO_CHAR(insert_date,'MM'),2,'0');

     month_date := insert_date;
     
 		 month_desc := TO_CHAR(insert_date,'Month','NLS_DATE_LANGUAGE = Spanish') || ' ' || year_id;

		 month_of_year_id := TO_NUMBER(TO_CHAR(insert_date,'MM'));

	-- TRIMESTRE_ID
     
	 	 quarter_id := TO_CHAR(year_id) || TO_CHAR(insert_date,'Q');
     
   	 month_duration := (next_insert_date - insert_date);

		 prev_month_id := TO_CHAR(ADD_MONTHS(insert_date, -1),'RRRRMM');

		 lq_month_id := TO_CHAR(ADD_MONTHS(insert_date, -3),'RRRRMM');

  	 ly_month_id := TO_CHAR(ADD_MONTHS(insert_date, -12),'RRRRMM');

     cierre_mes_id := TO_CHAR(year_id - 1)|| '12';

	   month_desc_en := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = English') || ' ' || year_id;
		 month_desc_de := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = German') || ' ' || year_id;
		 month_desc_fr := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = French') || ' ' || year_id;
		 month_desc_it := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = Italian') || ' ' || year_id;

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

		i := (i+1);

  END LOOP;
  
  COMMIT;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_F_DIA
-- ----------------------------------------------------------------------------------------------


 insert_date := NULL;
 
 next_insert_date := NULL;
 
   DELETE FROM D_F_DIA;

   COMMIT;
   
  y := 1;

  WHILE (y <= num_years) LOOP
  
      year_id := TO_NUMBER(TO_CHAR(NVL(insert_date,min_date),'RRRR')); --YEAR_ID
        
      first_day_actual_year := TO_DATE('01-01-'||TO_CHAR(year_id), 'DD/MM/RRRR');
    
    --Averiguamos si el año es bisiesto:
      DIAS := (ADD_MONTHS(NVL(insert_date,min_date),12) - NVL(insert_date,min_date));
      
      i := 0;
      
      WHILE (i < DIAS) LOOP

        insert_date := first_day_actual_year + (i);
        
        day_date := insert_date;
                
        day_of_week_id := TO_CHAR(insert_date, 'D'); -- DIA DE LA SEMANA (DOMINGO=7)
        
        semana_id := TO_CHAR(year_id) || TO_CHAR(insert_date, 'WW'); --SEMANA DEL AÑO WW STANDARD
        
        month_id := TO_CHAR(insert_date, 'RRRRMM');
        
    --TRIMESTRE_ID:
        
/*     
        SELECT DECODE(round(MONTHS_BETWEEN(insert_date,first_day_actual_year)/3,0),0,1,round((MONTHS_BETWEEN(insert_date,first_day_actual_year)+2)/3,0))
        INTO number_of_quarter
        FROM DUAL;
     
        quarter_id := TO_CHAR(year_id) || number_of_quarter;
*/
        quarter_id := TO_CHAR(year_id) || TO_CHAR(insert_date,'Q');

        prev_day_date := insert_date - 1;

        lm_day_date := ADD_MONTHS(insert_date, -1);

        lq_day_date := ADD_MONTHS(insert_date, -3);

        ly_day_date := ADD_MONTHS(insert_date, -12);


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
                
                i:= (i+1);
                
       END LOOP;
       
       insert_date := insert_date + 1;
       
       y:= (y+1);

   END LOOP;
   
   COMMIT;

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SEMANA
-- ----------------------------------------------------------------------------------------------
-- Iniciamos el contador
 y := 0;

 insert_date := NULL;
 
 next_insert_date := NULL;
 
   DELETE FROM D_F_SEMANA;

   COMMIT;
   
  y := 0;

  WHILE (y < num_years) LOOP
  
      IF TO_CHAR(next_insert_date,'DDMM') = '3112' THEN
      
         next_insert_date := next_insert_date + 1;
         
      END IF;
      
      --Averiguamos si el año es bisiesto:
      year_id := TO_NUMBER(TO_CHAR(NVL(next_insert_date,min_date),'RRRR')); --YEAR_ID

      first_day_actual_year := TO_DATE('01-01-'||TO_CHAR(year_id), 'DD/MM/RRRR');
      
      DIAS := (ADD_MONTHS(NVL(first_day_actual_year,min_date),12) - first_day_actual_year);
      
      insert_date := first_day_actual_year;
      
      i := 1;
      
      num_semanas_anio := ROUND((DIAS+4)/7,0);
      
      duracion := 0;
      
      WHILE (i <= num_semanas_anio) LOOP
      
         insert_date := insert_date + NVL(duracion,0);
         
         IF TO_CHAR(insert_date, 'D') <> 1 THEN -- NO ES LUNES (1)
         
            SELECT NEXT_DAY(insert_date, 'LUNES')
            INTO next_insert_date
            FROM DUAL;
            
         ELSE
         
            next_insert_date := insert_date + 7;
            
         END IF;
  
         semana_id := TO_CHAR(year_id) || LPAD(TO_CHAR(i), 2, '0');
       
         semana_fecha := insert_date;

         semana_desc := TO_CHAR(year_id) || ' ' || 'Sem ' || TO_CHAR(i);

         semana_desc_alt := 'Semana ' || TO_CHAR(i);
         
         IF TO_NUMBER(TO_CHAR(next_insert_date,'RRRR')) > year_id THEN -- CAMBIO DE AÑO

            next_insert_date := (LAST_DAY(insert_date) + 1);
            
         END IF;

         duracion := (next_insert_date - insert_date);
         
         week_of_year_id := TO_CHAR(insert_date,'WW');
        
         month_id := TO_CHAR(insert_date,'RRRRMM');
         
         semana_anterior_id := TO_CHAR((insert_date - 7),'RRRR') || TO_CHAR((insert_date - 7),'WW');
         
         semana_desc_en := TO_CHAR(year_id) || ' W' || TO_CHAR(i);
         
         semana_desc_de := semana_desc_en;
         
         semana_desc_fr := semana_desc_en;
         
         semana_desc_it := semana_desc_en;

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
            SEMANA_ANT_ID,  
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
        
        i := (i + 1);
     
      END LOOP; 
      
      COMMIT;
        
    y := (y + 1);
    
    END LOOP;
    
    COMMIT;
    
-- ----------------------------------------------------------------------------------------------
--                                      D_F_SEMANA_ANIO
-- ----------------------------------------------------------------------------------------------
 
   DELETE FROM D_F_SEMANA_ANIO;
   
   COMMIT;
 
 i := 1;
 
 WHILE (i<=53) LOOP

    -- SEMANA_ANIO_ID
		   week_of_year_id := i;
		-- SEMANA_ANIO_DESC
       week_of_year_desc :=  'Semana ' || TO_CHAR(i);
		-- SEMANA_ANIO_DESC_EN
       week_of_year_desc_en := 'Week ' || TO_CHAR(i);
		-- SEMANA_ANIO_DESC_DE
       week_of_year_desc_de := 'Woche '|| TO_CHAR(i);
		-- SEMANA_ANIO_DESC_FR
		   week_of_year_desc_fr := 'Semaine ' || TO_CHAR(i);
		-- SEMANA_ANIO_DESC_IT
		   week_of_year_desc_it := 'Settimana '|| TO_CHAR(i);
  	
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

      i := (i + 1);

   END LOOP;
   
   COMMIT;
   
-- ----------------------------------------------------------------------------------------------
--                                      D_F_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
    
    DELETE FROM D_F_DIA_SEMANA;
    
   i := 0;
   
   insert_date := TO_DATE('02/06/2014','DD/MM/RRRR');
   
   WHILE (i < 7 ) LOOP
   
     day_of_week_id := i;
     day_of_week_desc := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = Spanish');
     day_of_week_desc_en := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = English');
     day_of_week_desc_de := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = German');
     day_of_week_desc_fr := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = French');
     day_of_week_desc_it := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = Italian');
   
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

        i := (i + 1);
   
   END LOOP;
   
   COMMIT;
   
-- ----------------------------------------------------------------------------------------------
--                                      D_F_MES_ANIO
-- ----------------------------------------------------------------------------------------------

    DELETE FROM D_F_MES_ANIO;
    
   i := 1;
   
   insert_date := TO_DATE('01/12/1900','DD/MM/RRRR');
   
   WHILE (i <= 12 ) LOOP
   
     month_of_year_id := i;
     month_of_year_desc := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = Spanish');
     month_of_year_desc_en := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = English');
     month_of_year_desc_de := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = German');
     month_of_year_desc_fr := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = French');
     month_of_year_desc_it := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = Italian');


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
        
        i := i + 1;
        
    END LOOP;
    
    COMMIT;
    
-- ----------------------------------------------------------------------------------------------
--                                      D_F_MTD
-- ----------------------------------------------------------------------------------------------

     DELETE FROM D_F_MTD;
     
     COMMIT;

-- Límites del bucle exterior
   SELECT MIN(DIA_ID)
   INTO min_date
   FROM D_F_DIA;
   
   SELECT MAX(DIA_ID)
   INTO max_date
   from D_F_DIA;

   insert_date := min_date;
   
   WHILE (insert_date <= max_date) LOOP
   
        mtd_date := TO_DATE('01/'|| TO_CHAR(insert_date,'MM/RRRR'),'DD/MM/RRRR');

        max_month_date := LAST_DAY(insert_date);
        
        WHILE (mtd_date <= insert_date) LOOP
    
              insert into D_F_MTD
                   (DIA_ID,
                    MTD_DIA
                    )
               values
                   (insert_date, -- DIA_ID fecha fija
                    mtd_date
                   );
                   
                mtd_date := mtd_date + 1;
                
          EXIT WHEN max_month_date = mtd_date;
                
        END LOOP;
        
        insert_date := insert_date + 1;

  END LOOP;
  
  COMMIT;

-- ----------------------------------------------------------------------------------------------
--                                      D_F_QTD
-- ----------------------------------------------------------------------------------------------

     DELETE FROM D_F_QTD;
     
     COMMIT;

-- Límites del bucle exterior
   SELECT MIN(DIA_ID)
   INTO min_date
   FROM D_F_DIA;
   
   SELECT MAX(DIA_ID)
   INTO max_date
   from D_F_DIA;

   insert_date := min_date;
   
   WHILE (insert_date <= max_date) LOOP
   
        max_quarter_date := ADD_MONTHS(NVL(max_quarter_date,(insert_date-1)),3);
        
        v_Control := 1;
   
        WHILE (max_quarter_date >= insert_date) LOOP
    
              IF v_Control = 1 THEN
      
                  SELECT TRIMESTRE_FECHA
                  INTO qtd_date
                  FROM D_F_TRIMESTRE
                  WHERE TO_CHAR(TRIMESTRE_ID) = TO_CHAR(insert_date,'RRRR') || TO_CHAR(insert_date,'Q');
                  
                  v_Control := 0;
                  
              END IF;
      
              insert into D_F_QTD
                   (DIA_ID,
                    QTD_DIA
                    )
               values
                   (qtd_date, --DIA_ID fecha fija
                    insert_date
                   );
                   
                insert_date := insert_date + 1;
                
        END LOOP;
        
  END LOOP;
  
  COMMIT;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_F_YTD
-- ----------------------------------------------------------------------------------------------

     DELETE FROM D_F_YTD;
     
     COMMIT;

-- Límites del bucle exterior
   SELECT MIN(DIA_ID)
   INTO min_date
   FROM D_F_DIA;
   
   SELECT MAX(DIA_ID)
   INTO max_date
   from D_F_DIA;

   insert_date := min_date;
   
   WHILE (insert_date <= max_date) LOOP
   
        max_year_date := ADD_MONTHS(NVL(max_year_date,(insert_date-1)),12);
        
        ytd_date := TO_DATE('01/01/' || TO_CHAR(max_year_date,'RRRR'));
        
        WHILE (max_year_date >= insert_date) LOOP
    
      
              insert into D_F_YTD
                   (DIA_ID,
                    YTD_DIA
                    )
               values
                   (ytd_date, --DIA_ID fecha fija
                    insert_date
                   );
                   
                insert_date := insert_date + 1;
                
        END LOOP;
        
  END LOOP;
  
  COMMIT;


-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULT_6_MESES
-- ----------------------------------------------------------------------------------------------

   DELETE FROM D_F_ULT_6_MESES;
   
   COMMIT;

-- Límites del bucle exterior
   SELECT MIN(MES_ID), MIN(MES_FECHA)
   INTO min_mes, month_date
   FROM D_F_MES;

   SELECT MAX(MES_ID)
   INTO max_mes
   FROM D_F_MES;
   
   curr_mes := min_mes;
   
   i := 0;
   
   WHILE (curr_mes <= max_mes) LOOP
   
      WHILE i < 6 LOOP
      
          insert into D_F_ULT_6_MESES
				   (MES_ID,
				    ULT_6_MESES_ID
					 )
				 values
           (curr_mes, 
            TO_CHAR(ADD_MONTHS(month_date, -i),'RRRRMM')
           );
           
           i := i + 1;
           
      END LOOP;   
      
      i := 0;

      SELECT MIN(MES_ID), MIN(MES_FECHA)
      INTO curr_mes, month_date
      FROM D_F_MES 
      WHERE MES_ID > curr_mes;

  END LOOP;

  COMMIT;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULT_12_MESES
-- ----------------------------------------------------------------------------------------------

   DELETE FROM D_F_ULT_12_MESES;
   
   COMMIT;

-- Límites del bucle exterior
   SELECT MIN(MES_ID), MIN(MES_FECHA)
   INTO min_mes, month_date
   FROM D_F_MES;

   SELECT MAX(MES_ID)
   INTO max_mes
   FROM D_F_MES;
   
   curr_mes := min_mes;
   
   i := 0;
   
   WHILE (curr_mes <= max_mes) LOOP
   
      WHILE i < 12 LOOP
      
          insert into D_F_ULT_12_MESES
				   (MES_ID,
				    ULT_12_MESES_ID
					 )
				 values
           (curr_mes, 
            TO_CHAR(ADD_MONTHS(month_date, -i),'RRRRMM')
           );
           
           i := i + 1;
           
      END LOOP;   
      
      i := 0;

      SELECT MIN(MES_ID), MIN(MES_FECHA)
      INTO curr_mes, month_date
      FROM D_F_MES 
      WHERE MES_ID > curr_mes;

  END LOOP;

  COMMIT;
  
END;
--/*
--##########################################
--## AUTOR=Jaime S-C.
--## FECHA_CREACION=20160317
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-1271
--## PRODUCTO=NO
--## 
--## Finalidad: Se obtiene la ZONA dela Oficina de la Persona
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace procedure CARGAR_H_PER(DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS
	-- ===============================================================================================
	-- Autor: Maria Villanueva, PFS Group
	-- Fecha creación:Septiembre 2015
  -- Responsable ultima modificacion: Jaime Sánchez-Cuenca, PFS Group
  -- Fecha ultima modificacion: 17/03/2016
  -- Motivos del cambio: Se obtiene la ZONA dela Oficina de la Persona
  -- Cliente: Recovery BI CAJAMAR
	--
	-- Descripci�n: Procedimiento almancenado que carga las tablas hechos H_PER.
	-- ===============================================================================================
begin
	declare
		-- ===============================================================================================
		--                           Declaracaci�n de variables
		-- ===============================================================================================
		v_num_row             number(10);




		v_datastage           VARCHAR2(100);
		v_CM01               VARCHAR2(100);
		v_number              number(16,0);
		max_dia_con_contratos date;
		min_dia_semana        date;
		max_dia_semana        date;
		min_dia_mes           date;
		max_dia_mes           date;
		min_dia_trimestre     date;
		max_dia_trimestre     date;
		min_dia_anio          date;
		max_dia_anio          date;
		max_dia_add_bi_h      date;
		max_dia_add_bi        date;
		max_dia_carga         date;
		dia_periodo_ant       date;
		semana_periodo_ant    int;
		mes_periodo_ant       int;
		trimestre_periodo_ant int;
		anio_periodo_ant      int;
		semana                int;
		mes                   int;
		trimestre             int;
		anio                  int;
		fecha                 date;
		fecha_rellenar        date;
		max_dia_h             date;
		max_dia_mov           date;
		penult_dia_mov        date;
		v_nombre              varchar2(50) := 'CARGAR_H_PER';
		v_rowcount            number;
		ncount                number;
		V_SQL 				  VARCHAR2(16000);
    
    
    
		cursor c_fecha_rellenar	is select distinct(dia_id) from d_f_dia where dia_id between date_start and date_end;
		cursor c_fecha is	select distinct(dia_id) from d_f_dia where dia_id between date_start and date_end;
		cursor c_semana	is select distinct semana_h from tmp_fecha order by 1;
		cursor c_mes is	select distinct mes_id	from d_f_dia where dia_id between date_start and date_end	order by 1;
		cursor c_trimestre is	select distinct trimestre_id from d_f_dia	where dia_id between date_start and date_end order by 1;
		cursor c_anio	is select distinct anio_id from d_f_dia	where dia_id between date_start and date_end order by 1;
    
		-- --------------------------------------------------------------------------------
		-- DEFINICI�N DE LOS HANDLER DE ERROR
		-- --------------------------------------------------------------------------------
		objectexists      exception;
		insert_null       exception;
		parameters_number exception;
		pragma exception_init(objectexists,      -955);
		pragma exception_init(insert_null,       -1400);
		pragma exception_init(parameters_number, -909);
	begin
		--Log_Proceso
		execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' using in v_nombre, 'Empieza ' || v_nombre,	2;
		select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
        select valor into V_CM01 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';
		-- ----------------------------------------------------------------------------------------------
		--                                      H_PER
		-- ----------------------------------------------------------------------------------------------
		--Log_Proceso
		execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' using in v_nombre, 'H_PRC. Empiezo Carga', 3;
    
		execute immediate 'select max_dia_h, max_dia_mov, penult_dia_mov from ' || v_datastage || '.FECHAS_MOV' into max_dia_h,	max_dia_mov, penult_dia_mov;
        
		-- ----------------------------- Loop fechas a cargar -----------------------------
		open c_fecha;
		loop --READ_LOOP
			fetch c_fecha into fecha;
			exit
		when c_fecha%notfound;
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER. Empieza Fecha: '||to_char(fecha, 'dd/mm/yyyy'), 3;
    
    -- Borrado indices TMP_H_PER








     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	
    commit;
    


  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PER'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;			
    commit;

    execute immediate 'insert into TMP_H_PER  
                        (    
                          DIA_ID,    
                          FECHA_CARGA_DATOS,  
                          PERSONA_ID,  
                          POLITICA_PERSONA_ID,    
                          POLITICA_PERSONA_ANT_ID,    
                          TIPO_POLITICA_PERSONA_ID,    
                          TIPO_POLITICA_PER_ANT_ID,
                          RATING_ID,    
                          RATING_ANT_ID,    
                          ZONA_PERSONA_ID,    
                          OFICINA_PERSONA_ID,    
                          TRAMO_PUNTUACION_ID,    
                          TRAMO_ALERTA_ID,    
                          NUM_CLIENTES  
                          )  
                          select
                          '''||fecha||''',
                          '''||fecha||''',
                          NVL(PER_ID,-1),
                          NVL(DD_POL_ID,-1),
                          -1,
                          NVL(TPL_ID,-1),
                          -1, 
                          NVL(DD_REX_ID,-1), 
                          -1,
                          NVL(ZON.ZON_ID,-1),
                          NVL(PER.OFI_ID,-1), 
                          -1, 
                          -1, 
                           1
                      from '||v_datastage||'.PER_PERSONAS PER, '||v_datastage||'.ZON_ZONIFICACION ZON
                      where PER.BORRADO = 0
                      AND PER.OFI_ID = ZON.OFI_ID (+)';
                          
    v_rowcount := sql%rowcount;

    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'TMP_H_PER. Registros insertados: ' || to_char(v_rowcount), 4;
    commit;

    -- Crear indices TMP_H_PER

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PER_IX'', ''TMP_H_PER (DIA_ID, PER_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';

    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    -- Fecha de analisis en H_MOV_MOVIMIENTOS (fecha menor que el ultimno d�a de H_MOV_MOVIMIENTOS o mayor que este, pero menor que el pen�ltimo dia de MOV_MOVIMIENTOS)
    if((fecha <= max_dia_h) or ((fecha > max_dia_h) and (fecha < penult_dia_mov))) then
    --   execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from '||v_CM01||'.H_MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) <= to_date('''|| fecha ||''')' into max_dia_con_contratos;
      execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from '||v_datastage||'.MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) <= to_date('''|| fecha ||''')' into max_dia_con_contratos;

      execute immediate 'merge into TMP_H_PER per            
        using (select cpe.PER_ID, sum(mov.MOV_RIESGO) as VOLUMEN_RIESGO, sum(mov.MOV_POS_VIVA_VENCIDA) as POS_VENCIDA, sum(mov.MOV_POS_VIVA_NO_VENCIDA) as POS_NO_VENCIDA 
              from '||v_datastage||'.CPE_CONTRATOS_PERSONAS cpe 
            --   join '||v_CM01||'.H_MOV_MOVIMIENTOS mov on mov.CNT_ID = cpe.CNT_ID
                 join '||v_datastage||'.MOV_MOVIMIENTOS mov on mov.CNT_ID = cpe.CNT_ID
              where cpe.BORRADO = 0 and mov.BORRADO = 0 and mov.MOV_FECHA_EXTRACCION = '''||max_dia_con_contratos||''' 
              group by cpe.PER_ID) crc            
        on (crc.PER_ID = per.PERSONA_ID)            
        when matched then update
        set per.VOLUMEN_RIESGO = crc.VOLUMEN_RIESGO,             
            per.POS_VENCIDA = crc.POS_VENCIDA,            
            per.POS_NO_VENCIDA = crc.POS_NO_VENCIDA            
        where per.DIA_ID = '''||fecha||'''';

      v_rowcount := sql%rowcount;
      
      --Log_Proceso
      execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'TMP_H_PER. Update (1): ' || to_char(v_rowcount), 4;
      commit;

    -- Fecha de an�lisis en MOV_MOVIMIENTOS - Pen�ltimo o �ltimo d�a
    elsif(fecha = penult_dia_mov or fecha = max_dia_mov) then

      execute immediate 'merge into TMP_H_PER per            
        using (select cpe.PER_ID, sum(mov.MOV_RIESGO) as VOLUMEN_RIESGO, sum(mov.MOV_POS_VIVA_VENCIDA) as POS_VENCIDA, sum(mov.MOV_POS_VIVA_NO_VENCIDA) as POS_NO_VENCIDA 
              from '||v_datastage||'.CPE_CONTRATOS_PERSONAS cpe 
              join '||v_datastage||'.MOV_MOVIMIENTOS mov on mov.CNT_ID = cpe.CNT_ID
              where cpe.BORRADO = 0 and mov.BORRADO = 0 and mov.MOV_FECHA_EXTRACCION = '''||fecha||''' 
              group by cpe.PER_ID) crc            
        on (crc.PER_ID = per.PERSONA_ID)            
        when matched then update
        set per.VOLUMEN_RIESGO = crc.VOLUMEN_RIESGO,             
            per.POS_VENCIDA = crc.POS_VENCIDA,            
            per.POS_NO_VENCIDA = crc.POS_NO_VENCIDA            
        where per.DIA_ID = '''||fecha||'''';

      v_rowcount := sql%rowcount;
      
      --Log_Proceso
      execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'TMP_H_PER. Update (1): ' || to_char(v_rowcount), 4;
      commit;

    end if;
    
    -- ----------------------------- updates -------------------------------
    --Dia anterior    
    select  max(DIA_ID) into dia_periodo_ant from H_PER	where DIA_ID < fecha;
    
    if dia_periodo_ant is not null then
    
      merge into TMP_H_PER t1
      using (select PERSONA_ID, POLITICA_PERSONA_ID, TIPO_POLITICA_PERSONA_ID, RATING_ID from H_PER where DIA_ID = dia_periodo_ant) t2
      on (t1.PERSONA_ID = t2.PERSONA_ID)
      when matched then update 
        set t1.POLITICA_PERSONA_ANT_ID = t2.POLITICA_PERSONA_ID,
            t1.TIPO_POLITICA_PER_ANT_ID = t2.TIPO_POLITICA_PERSONA_ID,
            t1.RATING_ANT_ID  = t2.RATING_ID
      where DIA_ID = fecha; 
      commit;

      v_rowcount := sql%rowcount;
      
      --Log_Proceso
      execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'TMP_H_PER. Update (2) - Politica Anterior: ' || to_char(v_rowcount), 4;
      commit;

    end if;
          

    execute immediate 'merge into TMP_H_PER per 
                       using (select cmp.per_id,tpo.tpl_id,tpo.dd_pol_id from '||v_datastage||'.CMP_CICLO_MARCADO_POLITICA cmp 
                              join '||v_datastage||'.pol_politica pol on cmp.cmp_id=pol.cmp_id
                              join '||v_datastage||'.tpl_tipo_politica tpo on pol.tpl_id= tpo.tpl_id
                              join '||v_datastage||'.dd_pol_politicas dpo on tpo.dd_pol_id= dpo.dd_pol_id and tpo.tpl_codigo= dpo.dd_pol_codigo
                              where pol.borrado=0) tpol
                      on (per.POLITICA_PERSONA_ID = tpol.DD_POL_ID and per.persona_id=tpol.per_id)
                      when matched then update set per.TIPO_POLITICA_PERSONA_ID = tpol.TPL_ID 
                      where per.DIA_ID = '''||fecha||'''';
      
      v_rowcount := sql%rowcount;

      --Log_Proceso
      execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'TMP_H_PER. Update (3) - Politica Actual: ' || to_char(v_rowcount), 4;
      commit;
      
      
      update TMP_H_PER set TRAMO_VOLUMEN_RIESGO_ID = (case when VOLUMEN_RIESGO <= 1000 then 0
                                                           when VOLUMEN_RIESGO > 1000 and VOLUMEN_RIESGO <= 3000 then 1
                                                           when VOLUMEN_RIESGO > 3000 and VOLUMEN_RIESGO <= 10000 then 2
                                                           when VOLUMEN_RIESGO > 10000 and VOLUMEN_RIESGO <= 50000 then 3
                                                           when VOLUMEN_RIESGO > 50000 and VOLUMEN_RIESGO <= 500000 then 4
                                                           when VOLUMEN_RIESGO > 500000 then 5
                                                           else -1 end) where DIA_ID = fecha;
      commit;
      
      execute immediate 'merge into TMP_H_PER per 
                         using (select PER_ID, count(*) NUM_ALERTAS
                                from '||v_datastage||'.ALE_ALERTAS 
                                where trunc(ALE_FECHA_EXTRACCION) <= '''||fecha||''' group by PER_ID) ale
                         on (per.PERSONA_ID = ale.PER_ID)
                         when matched then update
                         set per.TRAMO_ALERTA_ID = (case when NUM_ALERTAS is null or  NUM_ALERTAS = 0 then 0
                                                         when NUM_ALERTAS = 1 then 1
                                                         when NUM_ALERTAS = 2 then 2
                                                         when NUM_ALERTAS = 3 then 3
                                                         when NUM_ALERTAS = 4 then 4
                                                         when NUM_ALERTAS = 5 then 5
                                                         when NUM_ALERTAS >= 6 then 6
                                                         else -1 end)
                         where per.DIA_ID = '''||fecha||'''';

      v_rowcount := sql%rowcount;

      --Log_Proceso
      execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'TMP_H_PER. Update (4) - Alertas: ' || to_char(v_rowcount), 4;
      commit;
      
      
      
      -- TRAMO_PUNTUACION_ID
      execute immediate 'merge into TMP_H_PER per 
                         using (select PER_ID, MAX(PTO_PUNTUACION) PUNTUACION
                         from '||v_datastage||'.PTO_PUNTUACION_TOTAL 
                         where trunc(FECHACREAR) <= '''||fecha||'''
                         GROUP BY PER_ID) ale
                   on (per.PERSONA_ID = ale.PER_ID)
                   when matched then update
                   set per.TRAMO_PUNTUACION_ID = (case when PUNTUACION is null or  PUNTUACION = 0 then 1
                                                       when PUNTUACION > 0  and PUNTUACION < 1000 then 2
                                                       when PUNTUACION >= 1000 and PUNTUACION < 3000 then 3
                                                       when PUNTUACION >= 3000 then 4
                                                       else -1 end)
                   where per.DIA_ID = '''||fecha||'''';

      v_rowcount := sql%rowcount;

      --Log_Proceso
      execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'TMP_H_PER. Update (4) - Tramo Puntuacion: ' || to_char(v_rowcount), 4;
      commit;
      
    
		-- Borrado indices H_PER

	  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
		
    commit;
      
		-- Borrado del día a insertar
		delete from H_PER where DIA_ID = fecha;
		commit;
      
			insert into H_PER
					(
						DIA_ID,
						FECHA_CARGA_DATOS,
						PERSONA_ID,
						POLITICA_PERSONA_ID,
						POLITICA_PERSONA_ANT_ID,
						TIPO_POLITICA_PERSONA_ID,
            			TIPO_POLITICA_PER_ANT_ID,
						RATING_ID,
						RATING_ANT_ID,
						ZONA_PERSONA_ID,
						OFICINA_PERSONA_ID,
						TRAMO_PUNTUACION_ID,
						TRAMO_ALERTA_ID,
            TRAMO_VOLUMEN_RIESGO_ID,
						NUM_CLIENTES,
						VOLUMEN_RIESGO,
						POS_VENCIDA,
						POS_NO_VENCIDA
					)
			select  DIA_ID,
					FECHA_CARGA_DATOS,
					PERSONA_ID,
					POLITICA_PERSONA_ID,
					POLITICA_PERSONA_ANT_ID,
					TIPO_POLITICA_PERSONA_ID,
					TIPO_POLITICA_PER_ANT_ID,
					RATING_ID,
					RATING_ANT_ID,
					ZONA_PERSONA_ID,
					OFICINA_PERSONA_ID,
					TRAMO_PUNTUACION_ID,
					TRAMO_ALERTA_ID,
          TRAMO_VOLUMEN_RIESGO_ID,
					NUM_CLIENTES,
					VOLUMEN_RIESGO,
					POS_VENCIDA,
					POS_NO_VENCIDA
				from TMP_H_PER
				where dia_id = fecha;
			v_rowcount   := sql%rowcount;
			commit;
			--Log_Proceso
			execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER. Registros insertados: ' || to_char(v_rowcount), 4;
			--Log_Proceso
			execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER. Termina Fecha: '||to_char(fecha, 'dd/mm/yyyy'), 3;
		
    end loop;
		close c_fecha;
    
		-- Crear indices H_PER










		 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_IX'', ''H_PER (DIA_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';






            execute immediate V_SQL USING OUT O_ERROR_STATUS;
		commit;
    

-- ----------------------------------------------------------------------------------------------
--                                      H_PER_SEMANA
-- ----------------------------------------------------------------------------------------------
--Log_Proceso
execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_SEMANA. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)



  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PER_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PER_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  
		-- Bucle que recorre las semanas
		open c_semana;
		loop --C_SEMANAS_LOOP
			fetch c_semana into semana;
			exit when c_semana%notfound;

      select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;

			-- Borrado indices H_PER_SEMANA








			 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;
			commit;
      
			-- Borrado de las semanas a insertar
			delete from h_per_semana where semana_id = semana;
			commit;
      
			insert into H_PER_SEMANA
            (
              SEMANA_ID,
              FECHA_CARGA_DATOS,
              PERSONA_ID,
              POLITICA_PERSONA_ID,
              POLITICA_PERSONA_ANT_ID,
              TIPO_POLITICA_PERSONA_ID,
              TIPO_POLITICA_PER_ANT_ID,
              RATING_ID,
              RATING_ANT_ID,
              ZONA_PERSONA_ID,
              OFICINA_PERSONA_ID,
              TRAMO_PUNTUACION_ID,
              TRAMO_ALERTA_ID,
              TRAMO_VOLUMEN_RIESGO_ID,
              NUM_CLIENTES,
              VOLUMEN_RIESGO,
              POS_VENCIDA,
              POS_NO_VENCIDA
            )
        select SEMANA,
            MAX_DIA_SEMANA,
            PERSONA_ID,
            POLITICA_PERSONA_ID,
            POLITICA_PERSONA_ANT_ID,
            TIPO_POLITICA_PERSONA_ID,
            TIPO_POLITICA_PER_ANT_ID,
            RATING_ID,
            RATING_ANT_ID,
            ZONA_PERSONA_ID,
            OFICINA_PERSONA_ID,
            TRAMO_PUNTUACION_ID,
            TRAMO_ALERTA_ID,
            TRAMO_VOLUMEN_RIESGO_ID,
            NUM_CLIENTES,
            VOLUMEN_RIESGO,
            POS_VENCIDA,
            POS_NO_VENCIDA
        from H_PER
        where dia_id = max_dia_semana;
        
			v_rowcount   := sql%rowcount;
			commit;
      
			--Log_Proceso
			execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_SEMANA. Registros insertados: ' || to_char(v_rowcount), 4;
      
















			
      
    -- Semana anterior    
    select max(SEMANA_ID) into semana_periodo_ant from H_PER_SEMANA where SEMANA_ID < semana;

    if semana_periodo_ant is not null then
      merge into H_PER_SEMANA t1
      using (select PERSONA_ID, POLITICA_PERSONA_ID, RATING_ID from H_PER_SEMANA where SEMANA_ID = semana_periodo_ant) t2
      on (t1.PERSONA_ID = t2.PERSONA_ID)
      when matched then update 
        set t1.POLITICA_PERSONA_ANT_ID = t2.POLITICA_PERSONA_ID,

            t1.RATING_ANT_ID  = t2.RATING_ID
      where SEMANA_ID = semana;   
      commit;
    end if;
      
		end loop c_semanas_loop;
		close c_semana;
    
   -- Crear indices H_PER_SEMANA




			 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_SEMANA_IX'', ''H_PER_SEMANA (SEMANA_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';






            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			commit;
      
		--Log_Proceso
		execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_SEMANA. Termina bucle', 3;
    
    
-- ----------------------------------------------------------------------------------------------
--                                      H_PER_MES
-- ----------------------------------------------------------------------------------------------
--Log_Proceso
execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_MES. Empieza bucle',	3;
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PER_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  
		-- Bucle que recorre los meses
		open c_mes;
		loop --C_MESES_LOOP
			fetch c_mes into mes;
			exit	when c_mes%notfound;
      
			select max(dia_h) into max_dia_mes from tmp_fecha where mes_h = mes;
      
			-- Borrado indices H_PER_MES








			 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;
			commit;
      
			-- Borrado de los meses a insertar
			delete from h_per_mes where mes_id = mes;
			commit;
      
			insert into H_PER_MES
              (
                MES_ID,
                FECHA_CARGA_DATOS,
                PERSONA_ID,
                POLITICA_PERSONA_ID,
                POLITICA_PERSONA_ANT_ID,
                TIPO_POLITICA_PERSONA_ID,
                TIPO_POLITICA_PER_ANT_ID,
                RATING_ID,
                RATING_ANT_ID,
                ZONA_PERSONA_ID,
                OFICINA_PERSONA_ID,
                TRAMO_PUNTUACION_ID,
                TRAMO_ALERTA_ID,
                TRAMO_VOLUMEN_RIESGO_ID,
                NUM_CLIENTES,
                VOLUMEN_RIESGO,
                POS_VENCIDA,
                POS_NO_VENCIDA
              )
          select  MES,
              MAX_DIA_MES,
              PERSONA_ID,
              POLITICA_PERSONA_ID,
              POLITICA_PERSONA_ANT_ID,
              TIPO_POLITICA_PERSONA_ID,
              TIPO_POLITICA_PER_ANT_ID,
              RATING_ID,
              RATING_ANT_ID,
              ZONA_PERSONA_ID,
              OFICINA_PERSONA_ID,
              TRAMO_PUNTUACION_ID,
              TRAMO_ALERTA_ID,
              TRAMO_VOLUMEN_RIESGO_ID,
              NUM_CLIENTES,
              VOLUMEN_RIESGO,
              POS_VENCIDA,
              POS_NO_VENCIDA
          from H_PER
          where dia_id = max_dia_mes;
          
			v_rowcount   := sql%rowcount;
			commit;
      
			--Log_Proceso
			execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_MES. Registros insertados: ' || to_char(v_rowcount),	4;
		
















   
    
    -- Mes anterior    
    select max(MES_ID) into mes_periodo_ant from H_PER_MES where MES_ID < mes;

    if semana_periodo_ant is not null then
      merge into H_PER_MES t1
      using (select PERSONA_ID, POLITICA_PERSONA_ID, TIPO_POLITICA_PERSONA_ID, RATING_ID from H_PER_MES where MES_ID = mes_periodo_ant) t2
      on (t1.PERSONA_ID = t2.PERSONA_ID)
      when matched then update 
        set t1.POLITICA_PERSONA_ANT_ID = t2.POLITICA_PERSONA_ID,
            t1.TIPO_POLITICA_PER_ANT_ID = t2.TIPO_POLITICA_PERSONA_ID,
            t1.RATING_ANT_ID  = t2.RATING_ID
      where MES_ID = mes;   
      commit;
    end if;
    
      
		end loop c_meses_loop;
		close c_mes;
    
    -- Crear indices H_PER_MES




     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_MES_IX'', ''H_PER_MES (MES_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';






            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
      
		--Log_Proceso
		execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_MES. Termina bucle',	3;
    
  
  -- ----------------------------------------------------------------------------------------------
  --                                      H_PER_TRIMESTRE
  -- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_TRIMESTRE. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PER_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
		-- Bucle que recorre los trimestres
		open c_trimestre;
		loop --C_TRIMESTRE_LOOP
			fetch c_trimestre into trimestre;
			exit when c_trimestre%notfound;
      
			select  max(dia_h) into max_dia_trimestre	from tmp_fecha	where trimestre_h = trimestre;
        
			-- Borrar indices H_PER_TRIMESTRE








			 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;	
      
			-- Borrado de los trimestres a insertar
			delete from h_per_trimestre where trimestre_id = trimestre;
			commit;
      
			insert into H_PER_TRIMESTRE
					(
						TRIMESTRE_ID,
						FECHA_CARGA_DATOS,
						PERSONA_ID,
						POLITICA_PERSONA_ID,
						POLITICA_PERSONA_ANT_ID,
						TIPO_POLITICA_PERSONA_ID,
            			TIPO_POLITICA_PER_ANT_ID,
						RATING_ID,
						RATING_ANT_ID,
						ZONA_PERSONA_ID,
						OFICINA_PERSONA_ID,
						TRAMO_PUNTUACION_ID,
						TRAMO_ALERTA_ID,
            TRAMO_VOLUMEN_RIESGO_ID,
						NUM_CLIENTES,
						VOLUMEN_RIESGO,
						POS_VENCIDA,
						POS_NO_VENCIDA
					)
			select TRIMESTRE,
					MAX_DIA_TRIMESTRE,
					PERSONA_ID,
					POLITICA_PERSONA_ID,
					POLITICA_PERSONA_ANT_ID,
					TIPO_POLITICA_PERSONA_ID,
					TIPO_POLITICA_PER_ANT_ID,
					RATING_ID,
					RATING_ANT_ID,
					ZONA_PERSONA_ID,
					OFICINA_PERSONA_ID,
					TRAMO_PUNTUACION_ID,
					TRAMO_ALERTA_ID,
          TRAMO_VOLUMEN_RIESGO_ID,
					NUM_CLIENTES,
					VOLUMEN_RIESGO,
					POS_VENCIDA,
					POS_NO_VENCIDA
				from H_PER
				where dia_id = max_dia_trimestre;
			v_rowcount := sql%rowcount;
			commit;
      
			--Log_Proceso
			execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_TRIMESTRE. Registros insertados: ' || to_char(v_rowcount), 4;
			
      -- Crear indices H_PER_TRIMESTRE




			 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_TRIMESTRE_IX'', ''H_PER_TRIMESTRE (TRIMESTRE_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';






            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			commit;
      
    -- Trimestre anterior    
    select max(TRIMESTRE_ID) into trimestre_periodo_ant from H_PER_TRIMESTRE where TRIMESTRE_ID < trimestre;

    if semana_periodo_ant is not null then
      merge into H_PER_TRIMESTRE t1
	  using (select PERSONA_ID, POLITICA_PERSONA_ID, TIPO_POLITICA_PERSONA_ID, RATING_ID from H_PER_TRIMESTRE where TRIMESTRE_ID = trimestre_periodo_ant) t2
      on (t1.PERSONA_ID = t2.PERSONA_ID)
      when matched then update 
        set t1.POLITICA_PERSONA_ANT_ID = t2.POLITICA_PERSONA_ID,
            t1.TIPO_POLITICA_PER_ANT_ID = t2.TIPO_POLITICA_PERSONA_ID,
            t1.RATING_ANT_ID  = t2.RATING_ID
      where TRIMESTRE_ID = trimestre;    
      commit;
    end if;
      
		end loop c_trimestre_loop;
		close c_trimestre;
    
		--Log_Proceso
		execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_TRIMESTRE. Termina bucle',	3;
    
-- ----------------------------------------------------------------------------------------------
--                                      H_PER_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)


  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;	
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PER_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PER;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
		-- Bucle que recorre los a�os
		open c_anio;
		loop --C_ANIO_LOOP
			fetch c_anio into anio;
			exit when c_anio%notfound;
      
			select max(dia_h) into max_dia_anio from tmp_fecha where anio_h = anio;
      
			-- Crear indices H_PER_ANIO








			 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PER_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;		
			commit;
      
			-- Borrado de los a�os a insertar
			delete from h_per_anio where anio_id = anio;
			commit;
      
			insert into H_PER_ANIO
					(
						ANIO_ID,
						FECHA_CARGA_DATOS,
						PERSONA_ID,
						POLITICA_PERSONA_ID,
						POLITICA_PERSONA_ANT_ID,
						TIPO_POLITICA_PERSONA_ID,
						TIPO_POLITICA_PER_ANT_ID,
						RATING_ID,
						RATING_ANT_ID,
						ZONA_PERSONA_ID,
						OFICINA_PERSONA_ID,
						TRAMO_PUNTUACION_ID,
						TRAMO_ALERTA_ID,
            TRAMO_VOLUMEN_RIESGO_ID,
						NUM_CLIENTES,
						VOLUMEN_RIESGO,
						POS_VENCIDA,
						POS_NO_VENCIDA
					)
			select anio,
					max_dia_anio,
					PERSONA_ID,
					POLITICA_PERSONA_ID,
					POLITICA_PERSONA_ANT_ID,
					TIPO_POLITICA_PERSONA_ID,
					TIPO_POLITICA_PER_ANT_ID,
					RATING_ID,
					RATING_ANT_ID,
					ZONA_PERSONA_ID,
					OFICINA_PERSONA_ID,
					TRAMO_PUNTUACION_ID,
					TRAMO_ALERTA_ID,
          TRAMO_VOLUMEN_RIESGO_ID,
					NUM_CLIENTES,
					VOLUMEN_RIESGO,
					POS_VENCIDA,
					POS_NO_VENCIDA
				from H_PER
				where dia_id = max_dia_anio;
        
			v_rowcount := sql%rowcount;
			commit;
      
			--Log_Proceso
			execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_ANIO. Registros insertados: ' || to_char(v_rowcount),	4;
		
















    	
      
    -- Año anterior    
    select max(ANIO_ID) into anio_periodo_ant from H_PER_ANIO where ANIO_ID < anio;

    if semana_periodo_ant is not null then
      merge into H_PER_ANIO t1
      using (select PERSONA_ID, POLITICA_PERSONA_ID, RATING_ID from H_PER_ANIO where ANIO_ID = anio_periodo_ant) t2
      on (t1.PERSONA_ID = t2.PERSONA_ID)
      when matched then update 
        set t1.POLITICA_PERSONA_ANT_ID = t2.POLITICA_PERSONA_ID,

            t1.RATING_ANT_ID  = t2.RATING_ID
      where ANIO_ID = anio;    
      commit;
    end if;

		end loop c_anio_loop;
		close c_anio;
    
   -- Crear indices H_PER_ANIO




			V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PER_ANIO_IX'', ''H_PER_ANIO (ANIO_ID, PERSONA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';






            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			commit;
      
		--Log_Proceso
		execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre, 'H_PER_ANIO. Termina bucle',	3;
		--Log_Proceso
		execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' using in v_nombre,'Termina ' || v_nombre,	2;
  
	end;
    
end cargar_h_per;
/
EXIT

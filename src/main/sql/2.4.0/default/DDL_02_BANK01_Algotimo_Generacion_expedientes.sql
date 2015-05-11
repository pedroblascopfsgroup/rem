DECLARE
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Esquema hijo
    schema_name varchar(50);   
    -- Querys
    query_body varchar (30048);
BEGIN
    schema_name := 'BANK01';	
    
	select count(1) into table_count from all_mviews WHERE mview_name='BATCH_DATOS_CNT_PER';
    if table_count > 0 then  
			query_body :='DROP MATERIALIZED VIEW '||schema_name||'.BATCH_DATOS_CNT_PER'; EXECUTE IMMEDIATE query_body;
	end if;

	query_body :='CREATE MATERIALIZED VIEW '||schema_name||'.BATCH_DATOS_CNT_PER (cnt_id, per_id, cnt_per_tin, cnt_per_oin, cnt_per_arrastre)
	BUILD IMMEDIATE
	REFRESH FORCE ON DEMAND
	WITH PRIMARY KEY
	AS
	SELECT cpe.cnt_id, cpe.per_id, tin.dd_tin_codigo AS cnt_per_tin, cpe.cpe_orden AS cnt_per_oin, tin.dd_tin_exp_recobro_sn as cnt_per_arrastre
	FROM '||schema_name||'.cpe_contratos_personas cpe 
	JOIN '||schema_name||'.dd_tin_tipo_intervencion tin ON cpe.dd_tin_id = tin.dd_tin_id
	-- Se incluyen todos  los obligados de cada contrato
	WHERE cpe.borrado = 0 AND (dd_tin_titular = 1 or dd_tin_avalista = 1)'; EXECUTE IMMEDIATE query_body;
      
	-- CAMBIOS EN LA TEMPORAL TMP_CNT_PER_VALIDAS
    select count(1) into table_count from all_tables WHERE table_name='TMP_CNT_PER_VALIDAS';
	    if table_count > 0 then  
	    	query_body :='DROP TABLE '||schema_name||'.TMP_CNT_PER_VALIDAS PURGE'; EXECUTE IMMEDIATE query_body;
	end if;		    
	
	query_body :='CREATE TABLE '||schema_name||'.TMP_CNT_PER_VALIDAS (
	  CNT_ID NUMBER(16) 
	  , PER_ID NUMBER(16)
	  , CNT_PER_TIN VARCHAR2(8 CHAR)
	  , CNT_PER_OIN NUMBER(38)
	  , CNT_PER_ARRASTRE NUMBER(1)
	)'; EXECUTE IMMEDIATE query_body;

	-- CAMBIOS EN TEMPORAL TMP_REC_CNT_LIBRES_ARQ_REC_EXT
	select count(1) into table_count from user_tab_cols WHERE column_name='CNT_PER_ARRASTRE' and table_name='TMP_REC_CNT_LIBRES_ARQ_REC_EXT';
    if table_count = 0 then  
			query_body :='ALTER TABLE '||schema_name||'.TMP_REC_CNT_LIBRES_ARQ_REC_EXT ADD (CNT_PER_ARRASTRE NUMBER(1))'; EXECUTE IMMEDIATE query_body;
	end if;	
	
	-- CAMBIOS EN BATCH_DATOS_SALIDA
	select count(1) into table_count from user_tab_cols WHERE column_name='CNT_PER_ARRASTRE' and table_name='BATCH_DATOS_SALIDA';
    if table_count = 0 then  
			query_body :='ALTER TABLE '||schema_name||'.BATCH_DATOS_SALIDA ADD (CNT_PER_ARRASTRE NUMBER(1))'; EXECUTE IMMEDIATE query_body;
	end if;	

	select count(1) into table_count from all_indexes WHERE index_name='IDX_BATCH_DATOS_SALIDA_4';
    if table_count = 0 then      
		query_body :='CREATE INDEX '||schema_name||'.IDX_BATCH_DATOS_SALIDA_4 ON '||schema_name||'.BATCH_DATOS_SALIDA (CNT_PER_ARRASTRE)'; EXECUTE IMMEDIATE query_body;
	end if;		
	
	COMMIT;

END;
/
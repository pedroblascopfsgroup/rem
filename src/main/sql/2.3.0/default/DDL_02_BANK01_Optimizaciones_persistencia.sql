DECLARE
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Esquema hijo
    schema_name varchar(50);   
    -- Querys
    query_body varchar (30048);
BEGIN
    schema_name := 'BANK01';	
	
	select count(1) into table_count from all_indexes WHERE index_name='IDX_CRE_RCF_ESQ_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_CRE_RCF_ESQ_ID ON '||schema_name||'.CRE_CICLO_RECOBRO_EXP (RCF_ESQ_ID)'; EXECUTE IMMEDIATE query_body;
	end if;		

	select count(1) into table_count from all_indexes WHERE index_name='IDX_CRE_RCF_ESC_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_CRE_RCF_ESC_ID ON '||schema_name||'.CRE_CICLO_RECOBRO_EXP (RCF_ESC_ID)'; EXECUTE IMMEDIATE query_body;
	end if;		

	select count(1) into table_count from all_indexes WHERE index_name='IDX_CRE_RCF_SCA_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_CRE_RCF_SCA_ID ON '||schema_name||'.CRE_CICLO_RECOBRO_EXP (RCF_SCA_ID)'; EXECUTE IMMEDIATE query_body;
	end if;		
	
	select count(1) into table_count from all_indexes WHERE index_name='IDX_CRE_RCF_SUA_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_CRE_RCF_SUA_ID ON '||schema_name||'.CRE_CICLO_RECOBRO_EXP (RCF_SUA_ID)'; EXECUTE IMMEDIATE query_body;
	end if;			

	select count(1) into table_count from all_indexes WHERE index_name='IDX_CRE_RCF_AGE_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_CRE_RCF_AGE_ID ON '||schema_name||'.CRE_CICLO_RECOBRO_EXP (RCF_AGE_ID)'; EXECUTE IMMEDIATE query_body;
	end if;	
  
   select count(1) into table_count from all_indexes WHERE index_name='IDX_RCF_ESC_RCF_ESQ_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_RCF_ESC_RCF_ESQ_ID ON '||schema_name||'.RCF_ESC_ESQUEMA_CARTERAS (RCF_ESQ_ID)'; EXECUTE IMMEDIATE query_body;
   end if;	
  
   select count(1) into table_count from all_indexes WHERE index_name='IDX_RCF_ESC_RCF_CAR_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_RCF_ESC_RCF_CAR_ID ON '||schema_name||'.RCF_ESC_ESQUEMA_CARTERAS (RCF_CAR_ID)'; EXECUTE IMMEDIATE query_body;
   end if;	  
   
   select count(1) into table_count from all_indexes WHERE index_name='IDX_PER_PER_COD_CLIENTE_ENT';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_PER_PER_COD_CLIENTE_ENT ON '||schema_name||'.PER_PERSONAS (PER_COD_CLIENTE_ENTIDAD)'; EXECUTE IMMEDIATE query_body;
   end if;	     
  
   select count(1) into table_count from all_indexes WHERE index_name='IDX_PER_PER_NACIONALIDAD';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_PER_PER_NACIONALIDAD ON '||schema_name||'.PER_PERSONAS (PER_NACIONALIDAD)'; EXECUTE IMMEDIATE query_body;
   end if;	      
   
   select count(1) into table_count from all_indexes WHERE index_name='IDX_PER_DD_PRO_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_PER_DD_PRO_ID ON '||schema_name||'.PER_PERSONAS (DD_PRO_ID)'; EXECUTE IMMEDIATE query_body;
   end if;	   
   
   select count(1) into table_count from all_indexes WHERE index_name='IDX_TEL_PER_PER_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_TEL_PER_PER_ID ON '||schema_name||'.TEL_PER (PER_ID)'; EXECUTE IMMEDIATE query_body;
   end if;	
   
   select count(1) into table_count from all_indexes WHERE index_name='IDX_TEL_TELEFO_BORRADO';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_TEL_TELEFO_BORRADO ON '||schema_name||'.TEL_TELEFONOS (BORRADO)'; EXECUTE IMMEDIATE query_body;
   end if;	
   
   select count(1) into table_count from all_indexes WHERE index_name='IDX_TEL_TELEFO_DD_TTE_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_TEL_TELEFO_DD_TTE_ID ON '||schema_name||'.TEL_TELEFONOS (DD_TTE_ID)'; EXECUTE IMMEDIATE query_body;
   end if;	      
   
   select count(1) into table_count from all_indexes WHERE index_name='IDX_TEL_TELEFO_DD_OTE_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_TEL_TELEFO_DD_OTE_ID ON '||schema_name||'.TEL_TELEFONOS (DD_OTE_ID)'; EXECUTE IMMEDIATE query_body;
   end if;	        

   COMMIT;   
   
END;	
/

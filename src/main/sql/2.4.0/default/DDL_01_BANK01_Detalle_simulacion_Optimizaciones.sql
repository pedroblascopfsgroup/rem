DECLARE
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Esquema hijo
    schema_name varchar(50);   
    -- Querys
    query_body varchar (30048);
BEGIN
    schema_name := 'BANK01';	
	
    select count(1) into table_count from all_tables WHERE table_name='H_DETALLE_SIMULACION';
	    if table_count = 0 then      
			query_body :='CREATE TABLE '||schema_name||'.H_DETALLE_SIMULACION (
							  FECHA_HIST TIMESTAMP (6) NOT NULL ENABLE, 
							  RCF_AGE_ID NUMBER(16,0) NOT NULL ENABLE, 
							  RCF_AGE_NOMBRE VARCHAR2(100 CHAR),
							  RCF_SCA_ID NUMBER(16,0) NOT NULL ENABLE, 
							  RCF_SCA_NOMBRE VARCHAR2(250 CHAR),
							  EXP_ID NUMBER(16,0) NOT NULL ENABLE, 
							  PER_ID NUMBER(16,0) NOT NULL ENABLE, 
							  PER_COD_CLIENTE_ENTIDAD NUMBER(16,0) NOT NULL ENABLE,   
							  CNT_ID NUMBER(16,0) NOT NULL ENABLE,
							  CNT_CONTRATO VARCHAR2(50 CHAR) NOT NULL ENABLE,
							  RIESGO_IRREGULAR NUMBER(14,2) NOT NULL ENABLE, 
							  RIESGO_VIVO NUMBER(14,2) NOT NULL ENABLE, 
							  GESTION_COMPARTIDA NUMBER(16,0) NOT NULL ENABLE
							)'; EXECUTE IMMEDIATE query_body;
	end if;		
    
END;
/


DECLARE
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Esquema hijo
    schema_name varchar(50);   
    -- Querys
    query_body varchar (30048);
BEGIN
    schema_name := 'BANK01';	
	
    select count(1) into table_count from all_tables WHERE table_name='DATA_RULE_ENGINE_CNT_NIV';
	    if table_count = 0 then      
			query_body :='CREATE TABLE '||schema_name||'.DATA_RULE_ENGINE_CNT_NIV AS
                    select cnt_id, 
                    zonN0.zon_id as zon_idN0, zonN0.zon_cod as zon_codN0, zonN0.zon_num_centro as zon_num_centroN0, zonN0.zon_descripcion as zon_descripcionN0, zonN0.zon_pid as zon_pidN0, nivN0.niv_id as niv_idN0, nivN0.niv_codigo as niv_codigoN0, nivN0.niv_descripcion as niv_descripcionN0,
                    zonN1.zon_id as zon_idN1, zonN1.zon_cod as zon_codN1, zonN1.zon_num_centro as zon_num_centroN1, zonN1.zon_descripcion as zon_descripcionN1, zonN1.zon_pid as zon_pidN1, nivN1.niv_id as niv_idN1, nivN1.niv_codigo as niv_codigoN1, nivN1.niv_descripcion as niv_descripcionN1,    
                    zonN2.zon_id as zon_idN2, zonN2.zon_cod as zon_codN2, zonN2.zon_num_centro as zon_num_centroN2, zonN2.zon_descripcion as zon_descripcionN2, zonN2.zon_pid as zon_pidN2, nivN2.niv_id as niv_idN2, nivN2.niv_codigo as niv_codigoN2, nivN2.niv_descripcion as niv_descripcionN2,
                    zonN3.zon_id as zon_idN3, zonN3.zon_cod as zon_codN3, zonN3.zon_num_centro as zon_num_centroN3, zonN3.zon_descripcion as zon_descripcionN3, zonN3.zon_pid as zon_pidN3, nivN3.niv_id as niv_idN3, nivN3.niv_codigo as niv_codigoN3, nivN3.niv_descripcion as niv_descripcionN3,
                    zonN4.zon_id as zon_idN4, zonN4.zon_cod as zon_codN4, zonN4.zon_num_centro as zon_num_centroN4, zonN4.zon_descripcion as zon_descripcionN4, zonN4.zon_pid as zon_pidN4, nivN4.niv_id as niv_idN4, nivN4.niv_codigo as niv_codigoN4, nivN4.niv_descripcion as niv_descripcionN4,
                    zonN5.zon_id as zon_idN5, zonN5.zon_cod as zon_codN5, zonN5.zon_num_centro as zon_num_centroN5, zonN5.zon_descripcion as zon_descripcionN5, zonN5.zon_pid as zon_pidN5, nivN5.niv_id as niv_idN5, nivN5.niv_codigo as niv_codigoN5, nivN5.niv_descripcion as niv_descripcionN5,
                    zonN6.zon_id as zon_idN6, zonN6.zon_cod as zon_codN6, zonN6.zon_num_centro as zon_num_centroN6, zonN6.zon_descripcion as zon_descripcionN6, zonN6.zon_pid as zon_pidN6, nivN6.niv_id as niv_idN6, nivN6.niv_codigo as niv_codigoN6, nivN6.niv_descripcion as niv_descripcionN6,
                    zonN7.zon_id as zon_idN7, zonN7.zon_cod as zon_codN7, zonN7.zon_num_centro as zon_num_centroN7, zonN7.zon_descripcion as zon_descripcionN7, zonN7.zon_pid as zon_pidN7, nivN7.niv_id as niv_idN7, nivN7.niv_codigo as niv_codigoN7, nivN7.niv_descripcion as niv_descripcionN7,
                    zonN8.zon_id as zon_idN8, zonN8.zon_cod as zon_codN8, zonN8.zon_num_centro as zon_num_centroN8, zonN8.zon_descripcion as zon_descripcionN8, zonN8.zon_pid as zon_pidN8, nivN8.niv_id as niv_idN8, nivN8.niv_codigo as niv_codigoN8, nivN8.niv_descripcion as niv_descripcionN8,
                    zonN9.zon_id as zon_idN9, zonN9.zon_cod as zon_codN9, zonN9.zon_num_centro as zon_num_centroN9, zonN9.zon_descripcion as zon_descripcionN9, zonN9.zon_pid as zon_pidN9, nivN9.niv_id as niv_idN9, nivN9.niv_codigo as niv_codigoN9, nivN9.niv_descripcion as niv_descripcionN9
                    from '||schema_name||'.cnt_contratos cnt
                    join '||schema_name||'.zon_zonificacion zonN0 on cnt.zon_id=zonN0.zon_id
                    join '||schema_name||'. niv_nivel nivN0 on zonN0.niv_id=nivN0.niv_id
                    join '||schema_name||'.zon_zonificacion zonN1 on zonN0.zon_pid=zonN1.zon_id
                    join '||schema_name||'.niv_nivel nivN1 on zonN1.niv_id=nivN1.niv_id
                    join '||schema_name||'.zon_zonificacion zonN2 on zonN1.zon_pid=zonN2.zon_id
                    join '||schema_name||'.niv_nivel nivN2 on zonN2.niv_id=nivN2.niv_id
                    join '||schema_name||'.zon_zonificacion zonN3 on zonN2.zon_pid=zonN3.zon_id
                    join '||schema_name||'.niv_nivel nivN3 on zonN3.niv_id=nivN3.niv_id
                    join '||schema_name||'.zon_zonificacion zonN4 on zonN3.zon_pid=zonN4.zon_id
                    join '||schema_name||'.niv_nivel nivN4 on zonN4.niv_id=nivN4.niv_id
                    join '||schema_name||'.zon_zonificacion zonN5 on zonN4.zon_pid=zonN5.zon_id
                    join '||schema_name||'.niv_nivel nivN5 on zonN5.niv_id=nivN5.niv_id
                    join '||schema_name||'.zon_zonificacion zonN6 on zonN5.zon_pid=zonN6.zon_id
                    join '||schema_name||'.niv_nivel nivN6 on zonN6.niv_id=nivN6.niv_id
                    join '||schema_name||'.zon_zonificacion zonN7 on zonN6.zon_pid=zonN7.zon_id
                    join '||schema_name||'.niv_nivel nivN7 on zonN7.niv_id=nivN7.niv_id
                    join '||schema_name||'.zon_zonificacion zonN8 on zonN7.zon_pid=zonN8.zon_id
                    join '||schema_name||'.niv_nivel nivN8 on zonN8.niv_id=nivN8.niv_id
                    join '||schema_name||'.zon_zonificacion zonN9 on zonN8.zon_pid=zonN9.zon_id
                    join '||schema_name||'.niv_nivel nivN9 on zonN9.niv_id=nivN9.niv_id'; EXECUTE IMMEDIATE query_body;
	end if;		
	
  	select count(1) into table_count from all_indexes WHERE index_name='IDX_DATA_RULE_CNT_CNT_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_DATA_RULE_CNT_CNT_ID ON '||schema_name||'.DATA_RULE_ENGINE_CNT_NIV (CNT_ID)'; EXECUTE IMMEDIATE query_body;
	end if;			
    
END;
/
				           
                   
DECLARE
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Esquema hijo
    schema_name varchar(50);   
    -- Querys
    query_body varchar (30048);
BEGIN
    schema_name := 'BANK01';	
	
    select count(1) into table_count from all_tables WHERE table_name='DATA_RULE_ENGINE_PER_NIV';
	    if table_count = 0 then      
			query_body :='CREATE TABLE '||schema_name||'.DATA_RULE_ENGINE_PER_NIV AS                    
                    select per.per_id, 
                    zonPN0.zon_id as zon_idPN0, zonPN0.zon_cod as zon_codPN0, zonPN0.zon_num_centro as zon_num_centroPN0, zonPN0.zon_descripcion as zon_descripcionPN0, zonPN0.zon_pid as zon_pidPN0, nivN0.niv_id as niv_idPN0, nivN0.niv_codigo as niv_codigoPN0, nivN0.niv_descripcion as niv_descripcionPN0,
                    zonPN1.zon_id as zon_idPN1, zonPN1.zon_cod as zon_codPN1, zonPN1.zon_num_centro as zon_num_centroPN1, zonPN1.zon_descripcion as zon_descripcionPN1, zonPN1.zon_pid as zon_pidPN1, nivN1.niv_id as niv_idPN1, nivN1.niv_codigo as niv_codigoPN1, nivN1.niv_descripcion as niv_descripcionPN1,    
                    zonPN2.zon_id as zon_idPN2, zonPN2.zon_cod as zon_codPN2, zonPN2.zon_num_centro as zon_num_centroPN2, zonPN2.zon_descripcion as zon_descripcionPN2, zonPN2.zon_pid as zon_pidPN2, nivN2.niv_id as niv_idPN2, nivN2.niv_codigo as niv_codigoPN2, nivN2.niv_descripcion as niv_descripcionPN2,
                    zonPN3.zon_id as zon_idPN3, zonPN3.zon_cod as zon_codPN3, zonPN3.zon_num_centro as zon_num_centroPN3, zonPN3.zon_descripcion as zon_descripcionPN3, zonPN3.zon_pid as zon_pidPN3, nivN3.niv_id as niv_idPN3, nivN3.niv_codigo as niv_codigoPN3, nivN3.niv_descripcion as niv_descripcionPN3,
                    zonPN4.zon_id as zon_idPN4, zonPN4.zon_cod as zon_codPN4, zonPN4.zon_num_centro as zon_num_centroPN4, zonPN4.zon_descripcion as zon_descripcionPN4, zonPN4.zon_pid as zon_pidPN4, nivN4.niv_id as niv_idPN4, nivN4.niv_codigo as niv_codigoPN4, nivN4.niv_descripcion as niv_descripcionPN4,
                    zonPN5.zon_id as zon_idPN5, zonPN5.zon_cod as zon_codPN5, zonPN5.zon_num_centro as zon_num_centroPN5, zonPN5.zon_descripcion as zon_descripcionPN5, zonPN5.zon_pid as zon_pidPN5, nivN5.niv_id as niv_idPN5, nivN5.niv_codigo as niv_codigoPN5, nivN5.niv_descripcion as niv_descripcionPN5,
                    zonPN6.zon_id as zon_idPN6, zonPN6.zon_cod as zon_codPN6, zonPN6.zon_num_centro as zon_num_centroPN6, zonPN6.zon_descripcion as zon_descripcionPN6, zonPN6.zon_pid as zon_pidPN6, nivN6.niv_id as niv_idPN6, nivN6.niv_codigo as niv_codigoPN6, nivN6.niv_descripcion as niv_descripcionPN6,
                    zonPN7.zon_id as zon_idPN7, zonPN7.zon_cod as zon_codPN7, zonPN7.zon_num_centro as zon_num_centroPN7, zonPN7.zon_descripcion as zon_descripcionPN7, zonPN7.zon_pid as zon_pidPN7, nivN7.niv_id as niv_idPN7, nivN7.niv_codigo as niv_codigoPN7, nivN7.niv_descripcion as niv_descripcionPN7,
                    zonPN8.zon_id as zon_idPN8, zonPN8.zon_cod as zon_codPN8, zonPN8.zon_num_centro as zon_num_centroPN8, zonPN8.zon_descripcion as zon_descripcionPN8, zonPN8.zon_pid as zon_pidPN8, nivN8.niv_id as niv_idPN8, nivN8.niv_codigo as niv_codigoPN8, nivN8.niv_descripcion as niv_descripcionPN8,
                    zonPN9.zon_id as zon_idPN9, zonPN9.zon_cod as zon_codPN9, zonPN9.zon_num_centro as zon_num_centroPN9, zonPN9.zon_descripcion as zon_descripcionPN9, zonPN9.zon_pid as zon_pidPN9, nivN9.niv_id as niv_idPN9, nivN9.niv_codigo as niv_codigoPN9, nivN9.niv_descripcion as niv_descripcionPN9
                    from '||schema_name||'.per_personas per
                    join '||schema_name||'.zon_zonificacion zonPN0 on per.ofi_id=zonPN0.ofi_id
                    join '||schema_name||'.niv_nivel nivN0 on zonPN0.niv_id=nivN0.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN1 on zonPN0.zon_pid=zonPN1.zon_id
                    join '||schema_name||'.niv_nivel nivN1 on zonPN1.niv_id=nivN1.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN2 on zonPN1.zon_pid=zonPN2.zon_id
                    join '||schema_name||'.niv_nivel nivN2 on zonPN2.niv_id=nivN2.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN3 on zonPN2.zon_pid=zonPN3.zon_id
                    join '||schema_name||'.niv_nivel nivN3 on zonPN3.niv_id=nivN3.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN4 on zonPN3.zon_pid=zonPN4.zon_id
                    join '||schema_name||'.niv_nivel nivN4 on zonPN4.niv_id=nivN4.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN5 on zonPN4.zon_pid=zonPN5.zon_id
                    join '||schema_name||'.niv_nivel nivN5 on zonPN5.niv_id=nivN5.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN6 on zonPN5.zon_pid=zonPN6.zon_id
                    join '||schema_name||'.niv_nivel nivN6 on zonPN6.niv_id=nivN6.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN7 on zonPN6.zon_pid=zonPN7.zon_id
                    join '||schema_name||'.niv_nivel nivN7 on zonPN7.niv_id=nivN7.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN8 on zonPN7.zon_pid=zonPN8.zon_id
                    join '||schema_name||'.niv_nivel nivN8 on zonPN8.niv_id=nivN8.niv_id
                    join '||schema_name||'.zon_zonificacion zonPN9 on zonPN8.zon_pid=zonPN9.zon_id
                    join '||schema_name||'.niv_nivel nivN9 on zonPN9.niv_id=nivN9.niv_id'; EXECUTE IMMEDIATE query_body;
	end if;		
	
  	select count(1) into table_count from all_indexes WHERE index_name='IDX_DATA_RULE_PER_PER_ID';
	    if table_count = 0 then      
			query_body :='CREATE INDEX '||schema_name||'.IDX_DATA_RULE_PER_PER_ID ON '||schema_name||'.DATA_RULE_ENGINE_PER_NIV (PER_ID)'; EXECUTE IMMEDIATE query_body;
	end if;			
    
END;
/


DECLARE
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Esquema hijo
    schema_name varchar(50);   
    -- Querys
    query_body varchar (30048);
BEGIN
    schema_name := 'BANK01';	
	
    select count(1) into table_count from all_tables WHERE table_name='TMP_REC_EXP_SIN_CNT_ACTIVOS';
	    if table_count = 0 then      
			query_body :='CREATE TABLE '||schema_name||'.TMP_REC_EXP_SIN_CNT_ACTIVOS (EXP_ID NUMBER(16,0) NOT NULL ENABLE)'; EXECUTE IMMEDIATE query_body;
	end if;		
    
END;
/
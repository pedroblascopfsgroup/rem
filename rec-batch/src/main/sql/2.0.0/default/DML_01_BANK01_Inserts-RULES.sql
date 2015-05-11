-- ##########################################
-- ## Author: Pepe Company
-- ## Finalidad: Inserta 'RULES' en varios perfiles
-- ## 
-- ## INSTRUCCIONES:
-- ## VERSIONES:
-- ##        0.1 Version inicial
-- ##########################################

DECLARE
    -- Vble. para validar la existencia de las Secuencias.
    seq_count number(3);
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Vble. para validar la existencia de las Columnas.
    column_count number(3);   
    -- Esquema hijo
    schema_name varchar(50);
    -- Esquema padre
    schema_master_name varchar(50);
    -- Querys
    query_body varchar (30048);
    -- Nzmero de errores
    err_num NUMBER;
    -- Mensaje de error
    err_msg VARCHAR2(2048);
BEGIN
    -- ###########################    
    
    schema_name := 'BANK01';
--     schema_master_name := 'BANKMASTER';

-- ###########################  
-- Insertamos nuevas variables necesarias
-- ###########################      

 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=137;
	if table_count = 0 then
 		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (137, ''Dias irreguar - Compara1Valor (Calculado)'', ''dias_irregular'', ''compare1'', ''number'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=137-''dias_irregular'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=138;
	if table_count = 0 then
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (138, ''Domiciliacion Externa - Compara1Valor (Carga)'', ''CNT_DOMICI_EXT'', ''compare1'', ''number'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=138-''CNT_DOMICI_EXT'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=139;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (139, ''Servicio Nomina_Pension - Compara1Valor (Carga)'', ''SERV_NOMINA_PENSION'', ''compare1'', ''number'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=139-''SERV_NOMINA_PENSION'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;

 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=140;
	if table_count = 0 then	
	query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (140, ''Riesgo Dispuesto de la persona - Compara1Valor (Carga)'', ''per_riesgo_dispuesto'', ''compare1'', ''number'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=140-''per_riesgo_dispuesto'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=141;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (141, ''Aplicativo Origen Contrato (Carga)'', ''dd_apo_id'', ''dictionary'', ''number'', ''DDAplicativoOrigen'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=141-''dd_apo_id'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;

 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=142;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (142, ''Fecha de Nacimiento de la Persona - Compare1Valor (Carga)'', ''per_fecha_nacimiento'', ''compare1'', ''date'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=142-''per_fecha_nacimiento'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=143;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (143, ''Fecha de Nacimiento de la Persona - Compare2Valores (Carga)'', ''per_fecha_nacimiento'', ''compare2'', ''date'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=143-''per_fecha_nacimiento(2Valores)'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=144;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (144, ''Riesgo Dispuesto de la persona - Compare2Valores (Carga)'', ''per_riesgo_dispuesto'', ''compare2'', ''number'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=144-''per_riesgo_dispuesto(2Valores)'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=145;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (145, ''Marca de Empleado'', ''per_empleado'', ''compare1'', ''number'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=145-''per_empleado'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=146;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (146, ''Producto URSUS'', ''dd_tpe'', ''dictionary'', ''number'', ''DDTipoProductoEntidad'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=146-''Producto_URSUS'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=147;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (147, ''Estado Contrato Entidad'', ''dd_ece_id'', ''dictionary'', ''number'', ''DDEstadoContratoEntidad'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=147-''dd_ece_id'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=148;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (148, ''Colectivo Singular'', ''dd_cos_id'', ''dictionary'', ''number'', ''DDColectivoSingular'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=148-''dd_cos_id'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=149;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (149, ''Nivel Persona'', ''dd_pnv_id'', ''dictionary'', ''number'', ''DDTipoPersonaNivel'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=149-''dd_pnv_id'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=150;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (150, ''Titular (0/1)'', ''per_titular'', ''compare1'', ''number'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=150-''per_titular'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=151;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (151, ''Riesgo Autorizado de la Persona - Compara1Valor (Carga)'', ''per_riesgo_autorizado'', ''compare1'', ''number'', ''Riesgo'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=151-''per_riesgo_autorizado'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=152;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (152, ''Riesgo Autorizado de la Persona - Compare2Valores (Carga)'', ''per_riesgo_autorizado'', ''compare2'', ''number'', ''Riesgo'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=152-''per_riesgo_autorizado(2Valores)'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=153;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (153, ''Dispuesto Vencido de la Persona - Compara1Valor (Carga)'', ''per_riesgo_dir_vencido'', ''compare1'', ''number'', ''Riesgo'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=153-''per_riesgo_dir_vencido'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=154;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (154, ''Dispuesto Vencido de la Persona - Compare2Valores (Carga)'', ''per_riesgo_dir_vencido'', ''compare2'', ''number'', ''Riesgo'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=154-''per_riesgo_dir_vencido(2Valores)'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=155;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (155, ''Porcentaje de Provision del Contrato (1 valor)'', ''mov_provision_porcentaje'', ''compare1'', ''number'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=155-''mov_provision_porcentaje'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=156;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (156, ''Porcentaje de Provision del Contrato (2 valores)'', ''mov_provision_porcentaje'', ''compare2'', ''number'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=156-''mov_provision_porcentaje(2Valores)'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=157;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (157, ''Nivel 0 - OFICINA del contrato'', ''centronivel0'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=157-''centronivel0'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=158;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (158, ''Nivel 1 - DISTRITO del contrato'', ''centronivel1'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=158-''centronivel1'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=159;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (159, ''Nivel 2 - ZONA del contrato'', ''centronivel2'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=159-''centronivel2'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=160;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (160, ''Nivel 3 - DIRADJUN del contrato'', ''centronivel3'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=160-''centronivel3'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=161;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (161, ''Nivel 4 - DIRNEGOC del contrato'', ''centronivel4'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=161-''centronivel4'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=162;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (162, ''Nivel 5 - UNIDAD del contrato'', ''centronivel5'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=162-''centronivel5'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=163;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (163, ''Nivel 6 - UNIDAD0 del contrato'', ''centronivel6'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=163-''centronivel6'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=164;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (164, ''Nivel 7 - ORGDGE del contrato'', ''centronivel7'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=164-''centronivel7'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;

 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=165;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (165, ''Nivel 8 - OR900100 del contrato'', ''centronivel8'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=165-''centronivel8'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=166;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (166, ''Nivel 9 - EMPRESA del contrato'', ''centronivel9'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=166-''centronivel9'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=167;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (167, ''Nivel 0 - OFICINA de la persona'', ''centronivelper0'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=167-''centronivelper0'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=168;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (168, ''Nivel 1 - DISTRITO de la persona'', ''centronivelper1'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=168-''centronivelper1'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=169;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (169, ''Nivel 2 - ZONA de la persona'', ''centronivelper2'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=169-''centronivelper2'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=170;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (170, ''Nivel 3 - DIRADJUN de la persona'', ''centronivelper3'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=170-''centronivelper3'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=171;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (171, ''Nivel 4 - DIRNEGOC de la persona'', ''centronivelper4'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=171-''centronivelper4'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=172;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (172, ''Nivel 5 - UNIDAD de la persona'', ''centronivelper5'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=172-''centronivelper5'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=173;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (173, ''Nivel 6 - UNIDAD0 de la persona'', ''centronivelper6'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=173-''centronivelper6'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=174;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (174, ''Nivel 7 - ORGDGE de la persona'', ''centronivelper7'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=174-''centronivelper7'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=175;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (175, ''Nivel 8 - OR900100 de la persona'', ''centronivelper8'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=175-''centronivelper8'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=176;
	if table_count = 0 then	
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values (176, ''Nivel 9 - EMPRESA de la persona'', ''centronivelper9'', ''compare1'', ''text'', ''Jerarquia'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK INSERTADO EL RD_ID=176-''centronivelper9'' EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	

COMMIT;

-- ###########################  
-- Actualizamos información de variables ya existentes
-- ###########################   


 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_COLUMN='dd_sce_id';
	if table_count > 0 then	
		query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_BO_VALUES=''DDSegmentoEntidad'' where RD_COLUMN=''dd_sce_id'''; EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK ACTUALIZAMOS EL DICCIONARIO DEL SEGMENTO (''dd_sce_id'') EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;
	
 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID=106;
	if table_count > 0 then	
		query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_COLUMN=''cnt_fecha_venc'' where RD_ID=106'; EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK ACTUALIZAMOS EL RD_COLUMN DE LA RD_ID=106 EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;

 	select count(1) into table_count from BANK01.DD_RULE_DEFINITION WHERE RD_ID IN (140, 144, 66, 125, 55, 94, 57, 96, 70, 95, 56, 127);
	if table_count > 0 then	
		query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TAB=''Riesgo'' where RD_ID IN (140, 144, 66, 125, 55, 94, 57, 96, 70, 95, 56, 127)'; EXECUTE IMMEDIATE query_body;
		DBMS_OUTPUT.PUT_LINE('[INFO] OK ACTUALIZAMOS EL RD_TAB DE VARIAS REGLAS EN:> '||schema_name||'.DD_RULE_DEFINITION.');
	end if;

COMMIT;

-- ###########################  
-- Borramos lógicamente variables que no vamos a utlizar en Bankia
-- ###########################  

query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=83'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=84'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=39'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=40'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=41'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=42'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=43'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=50'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=48'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=13'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=51'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=52'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=16'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=17'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=15'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=34'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=105'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=31'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=71'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=86'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=72'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=88'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=81'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=90'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=82'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=92'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=75'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=101'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=53'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=54'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=24'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=115'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=11'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=130'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=131'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=132'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=133'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=134'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=135'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=25'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=85'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=26'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=87'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=28'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=89'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=29'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=91'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=23'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=116'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=18'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=19'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=21'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=120'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=22'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=121'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=30'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=37'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=110'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=36'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=118'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=122'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=33'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=123'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=32'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=124'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=12'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET BORRADO=1, USUARIOBORRAR=''PCOMPANY'', FECHABORRAR=SYSDATE WHERE RD_ID=10'; EXECUTE IMMEDIATE query_body;

DBMS_OUTPUT.PUT_LINE('[INFO] OK BORRADAS LOGICAMENTE VARIABLES EN:> '||schema_name||'.DD_RULE_DEFINITION.');

commit;

-- ###########################  
-- Actualizamos Nombres de variables
-- ###########################  

query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Marca de Domiciliacion Externa del Contrato (0/1)'' WHERE RD_ID=138'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Constitución del Contrato (1 valor)'' WHERE RD_ID=79'; EXECUTE IMMEDIATE query_body; 
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Constitución del Contrato (2 valores)'' WHERE RD_ID=98'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Creación del Contrato (1 valor)'' WHERE RD_ID=73'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Creación del Contrato (2 valores)'' WHERE RD_ID=99'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de la Situación Contable del Contrato (1 valor)'' WHERE RD_ID=76'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de la Situación Contable del Contrato (2 valores)'' WHERE RD_ID=104'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de la Situación Contable Anterior del Contrato (1 valor)'' WHERE RD_ID=77'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de la Situación Contable Anterior del Contrato (2 valores)'' WHERE RD_ID=103'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha Estado del Contrato (1 valor)'' WHERE RD_ID=78'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha Estado del Contrato (2 valores)'' WHERE RD_ID=102'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha Vencimiento del Contrato (2 valores)'' WHERE RD_ID=106'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha Vencimiento del Contrato (1 valor)'' WHERE RD_ID=80'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Limite Actual del Contrato (1 valor)'' WHERE RD_ID=65'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Limite Actual del Contrato (2 valores)'' WHERE RD_ID=111'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Limite Inicial del Contrato (2 valores)'' WHERE RD_ID=112'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Limite Inicial del Contrato (1 valor)'' WHERE RD_ID=64'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Aplicativo Origen Contrato'' WHERE RD_ID=141'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Producto Comercial'' WHERE RD_ID=38'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Situación Contable del Contrato'' WHERE RD_ID=45'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Situación Contable anterior del Contrato'' WHERE RD_ID=46'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Estado del Contrato'' WHERE RD_ID=136'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Finalidad Contrato'' WHERE RD_ID=49'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Garantia1 del Contrato'' WHERE RD_ID=47'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Tipo de Moneda del Contrato'' WHERE RD_ID=44'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Dias irreguar del Contrato'' WHERE RD_ID=137'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Comisiones Impagadas (1 valor)'' WHERE RD_ID=61'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Comisiones Impagadas (2 valores)'' WHERE RD_ID=93'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Deuda Irregular del Contrato (1 valor)'' WHERE RD_ID=55'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Deuda Irregular del Contrato (2 valores)'' WHERE RD_ID=94'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Dispuesto Total del Contrato (1 valor)'' WHERE RD_ID=57'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Dispuesto Total del Contrato (2 valores)'' WHERE RD_ID=96'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Inicio de la Posición Vencida del Contrato (1 valor)'' WHERE RD_ID=74'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Inicio de la Posición Vencida del Contrato (2 valores)'' WHERE RD_ID=100'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Gastos incurridos no cobrados (1 valor)'' WHERE RD_ID=62'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Gastos incurridos no cobrados (2 valores)'' WHERE RD_ID=107'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Int. Moratorios Devengados (1 valor)'' WHERE RD_ID=60'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Int. Moratorios Devengados (2 valores)'' WHERE RD_ID=108'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Int. Ordinarios Devengados (1 valor)'' WHERE RD_ID=59'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Int. Ordinarios Devengados (2 valores)'' WHERE RD_ID=109'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Disponible del Contrato (1 valor)'' WHERE RD_ID=70'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Disponible del Contrato (2 valores)'' WHERE RD_ID=95'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''LTV Final del Contrato  (1 valor)'' WHERE RD_ID=69'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''LTV Final del Contrato  (2 valores)'' WHERE RD_ID=113'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''LTV Inicial del Contrato  (1 valor)'' WHERE RD_ID=68'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''LTV Inicial del Contrato  (2 valores)'' WHERE RD_ID=114'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Provision del Contrato (1 valor)'' WHERE RD_ID=58'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Provision del Contrato (2 valores)'' WHERE RD_ID=117'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Riesgo Garantizado del Contrato (1 valor)'' WHERE RD_ID=66'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Riesgo Garantizado del Contrato (2 valores)'' WHERE RD_ID=125'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Saldo Dudoso del Contrato (1 valor)'' WHERE RD_ID=56'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Saldo Dudoso del Contrato (2 valores)'' WHERE RD_ID=127'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Saldo Excedido del Contrato (1 valor)'' WHERE RD_ID=67'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Saldo Excedido del Contrato (2 valores)'' WHERE RD_ID=128'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Saldo Pasivo del Contrato (1 valor)'' WHERE RD_ID=63'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Saldo Pasivo del Contrato (2 valores)'' WHERE RD_ID=129'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Reincidencia de los Antecedentes Internos de la Persona (1 valor)'' WHERE RD_ID=35'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Reincidencia de los Antecedentes Internos de la Persona (2 valores)'' WHERE RD_ID=119'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Política de la Entidad'' WHERE RD_ID=5'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Rating Interno de la Persona'' WHERE RD_ID=14'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Subsegmento'' WHERE RD_ID=2'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Tipo Persona'' WHERE RD_ID=3'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Oficina de la Persona'' WHERE RD_ID=9'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Estado Persona'' WHERE RD_ID=4'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Constitución Empresa (1 valor)'' WHERE RD_ID=27'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Constitución Empresa (2 valores)'' WHERE RD_ID=97'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Nacimiento de la Persona (1 valor)'' WHERE RD_ID=142'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Fecha de Nacimiento de la Persona (2 valores)'' WHERE RD_ID=143'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''ID Recovery Persona'' WHERE RD_ID=1'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nacionalidad de la Persona'' WHERE RD_ID=6'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Pais de Nacimiento de la Persona'' WHERE RD_ID=7'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Dispuesto Total de la persona (1 valor)'' WHERE RD_ID=140'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Dispuesto Total de la persona (2 valores)'' WHERE RD_ID=144'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Sexo de la Persona'' WHERE RD_ID=8'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Servicio Nomina_Pension'' WHERE RD_ID=139'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Marca de Empleado'' WHERE RD_ID=145'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Riesgo Indirecto de la Persona (1 valor)'' WHERE RD_ID=20'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Riesgo Indirecto de la Persona (2 valores)'' WHERE RD_ID=126'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Colectivo Singular'' WHERE RD_ID=148'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel de la persona'' WHERE RD_ID=149'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Titular (0/1)'' WHERE RD_ID=150'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Autorizado de la Persona (1 valor)'' WHERE RD_ID=151'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Autorizado de la Persona (2 valores)'' WHERE RD_ID=152'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Dispuesto Vencido de la Persona (1 valor)'' WHERE RD_ID=153'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Dispuesto Vencido de la Persona (2 valores)'' WHERE RD_ID=154'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Porcentaje de Provision del Contrato (1 valor)'' WHERE RD_ID=155'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Porcentaje de Provision del Contrato (2 valores)'' WHERE RD_ID=156'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 0 - Oificna del contrato'' WHERE RD_ID=157'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 1 - DISTRITO del contrato'' WHERE RD_ID=158'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 2 - ZONA del contrato'' WHERE RD_ID=159'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 3 - DIRADJUN del contrato'' WHERE RD_ID=160'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 4 - DIRNEGOC del contrato'' WHERE RD_ID=161'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 5 - UNIDAD del contrato'' WHERE RD_ID=162'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 6 - UNIDAD0 del contrato'' WHERE RD_ID=163'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 7 - ORGDGE del contrato'' WHERE RD_ID=164'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 8 - OR900100 del contrato'' WHERE RD_ID=165'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 9 - EMPRESA del contrato'' WHERE RD_ID=166'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 0 - Oificna de la persona'' WHERE RD_ID=167'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 1 - DISTRITO de la persona'' WHERE RD_ID=168'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 2 - ZONA de la persona'' WHERE RD_ID=169'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 3 - DIRADJUN de la persona'' WHERE RD_ID=170'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 4 - DIRNEGOC de la persona'' WHERE RD_ID=171'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 5 - UNIDAD de la persona'' WHERE RD_ID=172'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 6 - UNIDAD0 de la persona'' WHERE RD_ID=173'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 7 - ORGDGE de la persona'' WHERE RD_ID=174'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 8 - OR900100 de la persona'' WHERE RD_ID=175'; EXECUTE IMMEDIATE query_body;
query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Nivel 9 - EMPRESA de la persona'' WHERE RD_ID=176'; EXECUTE IMMEDIATE query_body;

DBMS_OUTPUT.PUT_LINE('[INFO] OK ACTUALIZADOS LOS NOMBRES DE LAS VARIABLES EN:> '||schema_name||'.DD_RULE_DEFINITION.');

commit;

EXCEPTION  
    WHEN OTHERS THEN
      
      err_num := SQLCODE;
      err_msg := SQLERRM;
    
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(err_num));
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(err_msg);
      
      ROLLBACK;
      RAISE;
END;
/

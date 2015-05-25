--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150519
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.0.1-rc07-bk
--## INCIDENCIA_LINK=BKFTRES-30
--## PRODUCTO=SI
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    v_count number(3); -- Vble. para validar la existencia de objetos

    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
    v_schema VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    v_schema_m VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    v_ts_index VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); 

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Creación del índice sobre el campo MOV_FECHA_EXTRACCION en H_MOV_MOVIMIENTOS');
	V_SQL := 'select count(1) from all_indexes i inner join all_ind_columns ic on ic.index_name= i.index_name ' || 
		' where i.owner=''' || V_SCHEMA || ''' and i.table_name=''H_MOV_MOVIMIENTOS'' ' || 
		' and ic.column_name=''MOV_FECHA_EXTRACCION'' and ic.column_position=1';
	EXECUTE IMMEDIATE V_SQL into v_count;
	if v_count > 0 then
		DBMS_OUTPUT.PUT_LINE('[INFO] Índice ' || v_schema || '.IDX_H_MOV_FECHA_EXTRACCION... Ya existe');
	else 
		V_SQL := 'CREATE INDEX ' || v_schema || '.IDX_H_MOV_FECHA_EXTRACCION ON ' || v_schema || '.H_MOV_MOVIMIENTOS (MOV_FECHA_EXTRACCION) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || v_ts_index;
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Índice ' || v_schema || '.IDX_H_MOV_FECHA_EXTRACCION... creado OK');
	end if;

	DBMS_OUTPUT.PUT_LINE('[INFO] Creación de la tabla DPR_FECHA_EXTRACCION');
	V_SQL := 'select count(1) from all_tables where table_name = ''DPR_FECHA_EXTRACCION'' and owner = ''' || v_schema || '''';
	EXECUTE IMMEDIATE V_SQL into v_count;
	if v_count > 0 then
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || v_schema || '.DPR_FECHA_EXTRACCION... Ya existe');
	else 
		V_SQL := 'CREATE TABLE ' || v_schema || '.DPR_FECHA_EXTRACCION (DPR_NUM_DIA NUMBER(10,0) NOT NULL ,' || 
			'DPR_FECHA_EXTRACCION DATE NOT NULL )';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || v_schema || '.DPR_FECHA_EXTRACCION... creada OK');
		V_SQL := 'CREATE UNIQUE INDEX ' || v_schema || '.PK_DPR_FECHA_EXTRACCION ON ' || v_schema || '.DPR_FECHA_EXTRACCION (DPR_NUM_DIA) ' ||
			' TABLESPACE ' || v_ts_index;
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Índice ' || v_schema || '.PK_DPR_FECHA_EXTRACCION... creado OK');
	end if;


	DBMS_OUTPUT.PUT_LINE('[INFO] Creación de la tabla TMP_CNT_IRREGULAR_FECHA');
	V_SQL := 'select count(1) from all_tables where table_name = ''TMP_CNT_IRREGULAR_FECHA'' and owner = ''' || v_schema || '''';
	EXECUTE IMMEDIATE V_SQL into v_count;
	if v_count > 0 then
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || v_schema || '.TMP_CNT_IRREGULAR_FECHA... Ya existe');
	else 
		V_SQL := 'CREATE TABLE ' || v_schema || '.TMP_CNT_IRREGULAR_FECHA (DPR_NUM_DIA NUMBER(10,0) NOT NULL ,' || 
			'CNT_ID NUMBER(16,0) NOT NULL )';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || v_schema || '.TMP_CNT_IRREGULAR_FECHA... creada OK');
		V_SQL := 'CREATE UNIQUE INDEX ' || v_schema || '.PK_CNT_IRREGULAR_FECHA ON ' || v_schema || '.TMP_CNT_IRREGULAR_FECHA (CNT_ID, DPR_NUM_DIA) ' ||
			' TABLESPACE ' || v_ts_index;
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Índice ' || v_schema || '.PK_CNT_IRREGULAR_FECHA... creado OK');
	end if;


	DBMS_OUTPUT.PUT_LINE('[INFO] Creación de la tabla ACN_ANTECED_CONTRATOS');
	V_SQL := 'select count(1) from all_tables where table_name = ''ACN_ANTECED_CONTRATOS'' and owner = ''' || v_schema || '''';
	EXECUTE IMMEDIATE V_SQL into v_count;
	if v_count > 0 then
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || v_schema || '.ACN_ANTECED_CONTRATOS... Ya existe');
	else 
		V_SQL := 'CREATE TABLE ' || v_schema || '.ACN_ANTECED_CONTRATOS (' || 
			'CNT_ID NUMBER(16,0) NOT NULL, ' || 
			'ACN_NUM_REINCIDEN NUMBER(10,0) DEFAULT 0 NOT NULL ENABLE,' || 
			'VERSION NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,' || 
			'USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL, ' || 
			'FECHACREAR TIMESTAMP (6) NOT NULL, ' || 
			'USUARIOMODIFICAR VARCHAR2(10 CHAR), ' || 
			'FECHAMODIFICAR TIMESTAMP (6), ' || 
			'USUARIOBORRAR VARCHAR2(10 CHAR), ' || 
			'FECHABORRAR TIMESTAMP (6), ' || 
			'BORRADO NUMBER(1,0)  DEFAULT 0 NOT NULL ENABLE)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || v_schema || '.ACN_ANTECED_CONTRATOS... creada OK');
		V_SQL := 'CREATE UNIQUE INDEX ' || v_schema || '.ACN_ANTECED_CONTRATOS ON ' || v_schema || '.ACN_ANTECED_CONTRATOS (CNT_ID) TABLESPACE ' || v_ts_index;
	end if;

EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          
          ROLLBACK;
          RAISE;

END;
/

EXIT;


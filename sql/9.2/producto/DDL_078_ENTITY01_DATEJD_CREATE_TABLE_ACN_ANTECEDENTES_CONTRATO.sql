--/*
--##########################################
--## AUTOR=Enrique Jiménez Díaz
--## FECHA_CREACION=20160317
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=PRODUCTO-792
--## PRODUCTO=SI
--## 
--## Finalidad: Creación de tabla TMP_ANTECEDENTES_PER.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 TABLA VARCHAR(30) :='ACN_ANTECED_CONTRATOS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);
 SECUENCIA VARCHAR(30) :='S_ACN_ANTECED_CONTRATOS';
 table_count number(3); -- Vble. para validar la existencia de las Tablas.
 column_count number(3); -- Vble. para validar la existencia de las Tablas.

BEGIN

  SELECT COUNT(*) INTO TABLE_COUNT
  FROM ALL_TABLES
  WHERE  UPPER(TABLE_NAME) = ''||TABLA;

  --   V_MSQL := 'SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE UPPER(table_name) = '||TABLA||' AND OWNER = '||V_ESQUEMA;

    if TABLE_COUNT > 0 then
          DBMS_OUTPUT.PUT_LINE ('[INFO] '||v_esquema||'.'||TABLA||' Existe');
--           V_MSQL := 'DROP TABLE '||v_esquema||'.'||TABLA||'';
--           Execute Immediate V_MSQL;
--           DBMS_OUTPUT.PUT_LINE ('[INFO] '||v_esquema||'.'||TABLA||' Dropped');

	select count(1) into column_count from ALL_TAB_COLUMNS where UPPER(table_name) = ''||TABLA and UPPER(COLUMN_NAME) = 'DPR_NUM_DIA';

	if column_count = 0 then
		V_MSQL := 'ALTER TABLE '||v_esquema||'.'||TABLA||' ADD (DPR_NUM_DIA NUMBER)';
	        Execute Immediate V_MSQL;
	        DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.'||TABLA||' No existe la columna DPR_NUM_DIA, se crea.');	
	else
	        DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.'||TABLA||' columna DPR_NUM_DIA Existe');
	end if;

    else
        DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.'||TABLA||' No existe');

	V_MSQL := 'CREATE TABLE '||v_esquema||'.'||TABLA||'
	(   
	CNT_ID NUMBER(16,0) NOT NULL ENABLE,
	ACN_NUM_REINCIDEN NUMBER(10,0) DEFAULT 0 NOT NULL ENABLE,
	VERSION NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
	USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL ENABLE,
	FECHACREAR TIMESTAMP (6) NOT NULL ENABLE,
	USUARIOMODIFICAR VARCHAR2(50 CHAR),
	FECHAMODIFICAR TIMESTAMP (6),
	USUARIOBORRAR VARCHAR2(50 CHAR),
	FECHABORRAR TIMESTAMP (6),
	BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
	DPR_NUM_DIA NUMBER
	)';

	Execute Immediate V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla creada '||v_esquema||'.'||TABLA||'.');

	V_MSQL := 'Create unique index IDX_'||TABLA||'_CNT on '||v_esquema||'.'||TABLA||' (CNT_ID)';
	Execute Immediate V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Indice creado '||v_esquema||'.'||TABLA||' (IDX_'||TABLA||'_CNT).');

	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.'||TABLA||' Creada');

	-- CREAMOS SECUENCIA SI NO EXISTE
        V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = '''||SECUENCIA||''' and sequence_owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;
        if TABLE_COUNT = 0 THEN
		execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.'||SECUENCIA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||SECUENCIA||'... Secuencia creada correctamente.');
        END IF;

    End if;

EXCEPTION

  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci�n:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;

END;
/

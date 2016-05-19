--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERÁ
--## FECHA_CREACION=20160511
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HR-2530
--## PRODUCTO=SI
--## 
--## Finalidad: 
--##			Creación de índice IDX_COD_REC_CNT_ID (REC_CODIGO_RECIBO, CNT_ID) en REC_RECIBOS
--##			Creación de PK (REC_ID) en REC_RECIBOS
--##                     
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30 CHAR) :='REC_RECIBOS';
 ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
 INDICE VARCHAR(30 CHAR) :='IDX_COD_REC_CNT_ID';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 
	--Validamos si la tabla ya tiene pk antes de crearla  
	SELECT COUNT(*) INTO V_EXISTE
	FROM ALL_CONSTRAINTS
	WHERE TABLE_NAME = ''||TABLA
	AND CONSTRAINT_TYPE = 'P'
	AND OWNER=''||V_ESQUEMA;
	
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' 
			ADD PRIMARY KEY (REC_ID)';
	
	IF V_EXISTE = 0 THEN   
	 EXECUTE IMMEDIATE V_MSQL;
	 DBMS_OUTPUT.PUT_LINE(TABLA||' PK CREADA');
	ELSE   
	 DBMS_OUTPUT.PUT_LINE(TABLA||' YA TENÍA PK DEFINIDA');
	END IF;
	
	--Validamos si el índice existe antes de crearlo  
	SELECT COUNT(1) INTO V_EXISTE
	FROM (
		SELECT index_name, listagg(column_name,',') within group (order by column_position) columnas
		FROM ALL_IND_COLUMNS
		WHERE table_name = ''||TABLA
		AND index_owner='' || V_ESQUEMA
       		GROUP BY index_name
	) sqli
	WHERE sqli.columnas = 'REC_CODIGO_RECIBO,CNT_ID';

	V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||INDICE||' ON '||V_ESQUEMA||'.'||TABLA||'
	(	
		REC_CODIGO_RECIBO,
		CNT_ID
	)
	TABLESPACE '||ITABLE_SPACE||'';

	IF V_EXISTE = 0 THEN   
	 EXECUTE IMMEDIATE V_MSQL;
	 DBMS_OUTPUT.PUT_LINE(TABLA||'.'||INDICE||' CREADO');
	ELSE   
	 DBMS_OUTPUT.PUT_LINE('YA EXISTE EL ÍNDICE POR (REC_CODIGO_RECIBO,CNT_ID)');    
	END IF;

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;   

--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210623
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14308
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación campos contratos para cajamar
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Toque abs4

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 V_TEXT_TABLA VARCHAR(30) :='IOC_INTERLOCUTOR_PBC_CAIXA';
 COLUMNA VARCHAR(50) :='IOC_DOC_IDENTIFICATIVO';
 TIPO VARCHAR(50) :='VARCHAR2(50 CHAR)';
 V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una V_TEXT_TABLA.   
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR); 


BEGIN

  	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||COLUMNA||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_MSQL||' ');
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  	IF V_NUM_TABLAS = 1 THEN
  		  		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN '||COLUMNA||'';
          		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||COLUMNA||'... Borrada');


  	            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD( '||COLUMNA||' '||TIPO||')';

  	END IF;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');

DBMS_OUTPUT.PUT_LINE(''||V_TEXT_TABLA||' Modificada');

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

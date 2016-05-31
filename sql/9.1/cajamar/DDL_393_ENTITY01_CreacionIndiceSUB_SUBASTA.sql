--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla SALIDAS_CONTRATOS
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
 TABLA VARCHAR(30 CHAR) :='SUB_SUBASTA';
 ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
 INDICE VARCHAR(30 CHAR) :='IDX_SUB_ASU_ID';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 
		
	--Validamos si el índice existe antes de crearlo  
	SELECT COUNT(*) INTO V_EXISTE
	FROM ALL_INDEXES
	WHERE TABLE_NAME = ''||TABLA
	AND INDEX_NAME = ''||INDICE;  

	V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||INDICE||' ON '||V_ESQUEMA||'.'||TABLA||'
	(	
		ASU_ID
	)
	TABLESPACE '||ITABLE_SPACE||'';

	IF V_EXISTE = 0 THEN   
	 EXECUTE IMMEDIATE V_MSQL;
	 DBMS_OUTPUT.PUT_LINE(TABLA||'.'||INDICE||' CREADO');   
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

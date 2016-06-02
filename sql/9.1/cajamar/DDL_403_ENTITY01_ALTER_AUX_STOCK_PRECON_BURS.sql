--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20160418
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-3103
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación de tabla AUX_STOCK_PRECON_BUR esquema
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 GMN Se pone el campo TMP_REF_TIPO_OBSERVACION a nullable
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
 TABLA VARCHAR(30 CHAR) :='AUX_STOCK_PRECON_BUR';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

-- Crear tabla 1 TMP_PER_EST_CICLO_VIDA

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TAB_COLUMNS
  WHERE TABLE_NAME = TABLA
  AND COLUMN_NAME = 'PEM_DOC_ID';
 
  IF V_EXISTE = 0 THEN
  
	  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' 
		add (PEM_DOC_ID VARCHAR2(20 CHAR),
		     PEM_NOMBRE VARCHAR2(100 CHAR),
		     PEM_APELLIDO1 VARCHAR2(100 CHAR),
		     PEM_APELLIDO2 VARCHAR2(100 CHAR),
		     PEM_NOM50 VARCHAR2(1200 CHAR),
		     DD_PRO_CODIGO NUMBER(5),
		     PER_COD_CLIENTE_ENTIDAD NUMBER(16)
		     )';
	 
	     EXECUTE IMMEDIATE V_MSQL;
	     DBMS_OUTPUT.PUT_LINE('Campos creados en '||TABLA);
   ELSE
	     DBMS_OUTPUT.PUT_LINE('Ya existen campos en '||TABLA);
   END IF;

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' 
	modify (PER_COD NUMBER(16,0) null
	     )';
 
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Campo PER_COD de '||TABLA||' modificado.');

--Fin crear tabla 1

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

--/*
--##########################################
--## AUTOR=Enrique Jimenez Diaz
--## FECHA_CREACION=20160215
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1510
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de tabla TMP_PROPUESTA_CNT2
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
	 V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- '#ESQUEMA#';             -- Configuracion Esquema
	 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master
	 TABLA VARCHAR(30 CHAR) :='TMP_PROPUESTA_CNT2';
	 err_num NUMBER;
	 err_msg VARCHAR2(2048 CHAR);
	 V_MSQL VARCHAR2(8500 CHAR);
	 V_EXISTE NUMBER (1);

BEGIN

	--Validamos si la tabla existe antes de crearla
  	SELECT COUNT(*) INTO V_EXISTE  FROM ALL_TABLES WHERE TABLE_NAME = ''||TABLA;

	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
	(   
	    ID_PROPUESTA	 NUMBER(16,0)       NOT NULL ENABLE, 
	    TIPO_ACUERDO         NUMBER(4,0)        NOT NULL ENABLE, 
	    ESTADO_ACUERDO       NUMBER(5,0)        NOT NULL ENABLE, 
	    CNT_CONTRATO         NUMBER(16,0)       NOT NULL ENABLE, 
	    FECHA_PROPUESTA      VARCHAR2(10 CHAR),
	    FECHA_PAGO 		 VARCHAR2(10 CHAR), 
	    IMPORTE		 NUMBER(16,2)
	) SEGMENT CREATION IMMEDIATE 
	NOCOMPRESS LOGGING';
	

  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  END IF;

--Fin crear tabla
--Excepciones

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
EXIT


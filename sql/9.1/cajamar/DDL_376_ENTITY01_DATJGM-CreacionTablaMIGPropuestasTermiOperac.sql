--/*
--##########################################
--## AUTOR=Enrique Jimenez Diaz
--## FECHA_CREACION=20160125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-961
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de tabla MIG_PROPUESTAS_TERMI_OPERAC
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
 TABLA VARCHAR(30 CHAR) :='MIG_PROPUESTAS_TERMI_OPERAC';
 ITABLE_SPACE VARCHAR(25 CHAR) := 'IRECOVERYONL8M'; -- '#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE  FROM ALL_TABLES WHERE TABLE_NAME = ''||TABLA;
  

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
            (	
                MIG_PROP_TERM_ACU_OPE_ID NUMBER(16,0)       NOT NULL ENABLE, 
	            ID_TERMINO               NUMBER(16,0)       NOT NULL ENABLE, 
	            CODIGO_ENTIDAD           NUMBER(4,0)        NOT NULL ENABLE, 
	            CODIGO_PROPIETARIO       NUMBER(5,0)        NOT NULL ENABLE, 
	            TIPO_PRODUCTO            VARCHAR2(5 CHAR)   NOT NULL ENABLE, 
	            NUMERO_CONTRATO          NUMBER(16,0)       NOT NULL ENABLE, 
	            NUMERO_ESPEC             NUMBER(15,0)       NOT NULL ENABLE
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
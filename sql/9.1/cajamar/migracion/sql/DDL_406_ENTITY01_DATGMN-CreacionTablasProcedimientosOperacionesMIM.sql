--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160426
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HR-2391
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_PROCEDIMIENTOS_OPERACIONES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   'CM01'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='MIG_PROCEDIMS_OPERACIONES_MIM';
 ITABLE_SPACE VARCHAR(25) :='IRECOVERYONL8M';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);
 SEQUENCE VARCHAR(30) :='S_MIG_PROCEDIMS_OPER_MIM';


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	  ID_PROC_OPERACIONES NUMBER(16)                NOT NULL,
	  CD_PROCEDIMIENTO    NUMBER(16)                NOT NULL,
	  CODIGO_ENTIDAD      NUMBER(4)                 NOT NULL,
	  CODIGO_PROPIETARIO  NUMBER(5)                 NOT NULL,
	  TIPO_PRODUCTO       VARCHAR2(5 CHAR)          NOT NULL,
	  NUMERO_CONTRATO     NUMBER(17)                NOT NULL,
	  NUMERO_ESPEC        NUMBER(15)                NOT NULL,
	  TIPO_RELACION       VARCHAR2(20 CHAR)         NOT NULL,
	  CONSTRAINT "PK_ID_PROC_OPERA_MIM" PRIMARY KEY ("ID_PROC_OPERACIONES")
	  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOCOMPRESS LOGGING
	  TABLESPACE '||ITABLE_SPACE||'  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE( TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');     
  END IF;
 
--Fin crear tabla

--Validamos si la tabla existe para hacer la secuencia.

  SELECT COUNT(*) INTO V_EXISTE
  FROM user_sequences
  WHERE sequence_name = ''||SEQUENCE||'';


 S_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||SEQUENCE||'
 INCREMENT BY 1
 START WITH 1
 MINVALUE 1
 MAXVALUE 999999999999999999999999999
 CACHE 100 NOORDER 
 NOCYCLE ';


IF V_EXISTE = 0 THEN  
     EXECUTE IMMEDIATE S_MSQL;
     DBMS_OUTPUT.PUT_LINE( SEQUENCE||' CREADA');
END IF;

--Fin crear secuencia

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
EXIT;   




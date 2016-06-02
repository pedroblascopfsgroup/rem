--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_PROPUESTAS_TERMINO_ACUERDO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   'CM01';                -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER';         -- Configuracion Esquema Master
 ITABLE_SPACE VARCHAR2(25 CHAR) :='IRECOVERYONL8M';
 TABLA VARCHAR2(30 CHAR) :='MIG_PROPUESTAS_TERMINO_ACUERDO';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);
 SECUENCIA VARCHAR(30) :='S_MIG_PROPUESTAS_TERMINO_ACU';


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (
        MIG_PROP_TERM_ACU_ID    NUMBER(16,0)      NOT NULL ENABLE, 
        ID_PROPUESTA       NUMBER(16,0)      NOT NULL ENABLE,
        ID_TERMINO         NUMBER(16,0)      NOT NULL ENABLE,
        TIPO_ACUERDO       NUMBER(16,0)      , 
        SUBTIPO_ACUERDO    VARCHAR2(20 CHAR), 
        FECHA_PAGO         DATE              , 
        PERIODICIDAD       NUMBER(16,0)      NOT NULL ENABLE,
        IMPORTE            NUMBER(13,2)      NOT NULL ENABLE,
        CONSTRAINT PK_MIG_PROP_TERM_ACU_ID PRIMARY KEY (MIG_PROP_TERM_ACU_ID)
            USING INDEX NOCOMPRESS LOGGING
            TABLESPACE '||ITABLE_SPACE||'  ENABLE
   ) NOCOMPRESS LOGGING';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');     
  END IF;   

--Fin crear tabla
          
--Validamos si la tabla existe para hacer la secuencia.

  SELECT COUNT(*) INTO V_EXISTE 
  FROM user_sequences 
  WHERE sequence_name = ''||SECUENCIA||'';


 S_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||SECUENCIA||' 
 INCREMENT BY 1 
 START WITH 1 
 MINVALUE 1 
 MAXVALUE 999999999999999999999999999 
 CACHE 100 NOORDER  
 NOCYCLE ';


IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE S_MSQL;
     DBMS_OUTPUT.PUT_LINE(SECUENCIA||' CREADA');
ELSE 
     DBMS_OUTPUT.PUT_LINE('YA EXISTE LA SECUENCIA '||SECUENCIA||'');
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


--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151006
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-475
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_MAESTRA_HITOS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M  VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA        VARCHAR(30) :='MIG_MAESTRA_HITOS';
 TABLA_FK     VARCHAR(30) :='MIG_MAESTRA_HITOS_VALORES'; 
 V_FK         VARCHAR(30) :='FK_MIG_MAESTRA_HITOS';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num      NUMBER;
 err_msg      VARCHAR2(2048 CHAR); 
 V_MSQL       VARCHAR2(8500 CHAR);
 I_MSQL       VARCHAR2(8500 CHAR);
 V_EXISTE     NUMBER (1);
 I_BORRADO    VARCHAR(30) := 'IDX_MAE_BORRADO_1';
 I_COMPUESTO  VARCHAR(30) := 'IDX_MAE_COMPUESTO';
 I_PRC        VARCHAR(30) := 'IDX_MAE_PRC';


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (
        CD_PROCEDIMIENTO      VARCHAR2(17 CHAR)  NOT NULL ENABLE, 
        PRC_ID                NUMBER(16,0)       NOT NULL ENABLE, 
        PRC_PRC_ID            NUMBER(16,0)       NOT NULL ENABLE, 
        ORDEN                 NUMBER             NOT NULL ENABLE, 
        DD_TPO_CODIGO         VARCHAR2(20 CHAR)  NOT NULL ENABLE, 
        DD_TPO_DESC           VARCHAR2(100 CHAR), 
        TAP_CODIGO            VARCHAR2(50 CHAR), 
        TAR_ID                NUMBER(16,0), 
        TAR_TAREA             VARCHAR2(100 CHAR), 
        TAR_FECHA             DATE, 
        TAR_TAREA_FINALIZADA  NUMBER(1,0), 
        CD_BIEN               VARCHAR2(20 CHAR), 
        CONSTRAINT "UK_MIG_MAESTRA_HITOS" UNIQUE ("TAR_ID") 
   ) SEGMENT CREATION IMMEDIATE';


  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS' );
     DBMS_OUTPUT.PUT_LINE( TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');     
     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA_FK||' ADD CONSTRAINT '||V_FK||' FOREIGN KEY (TAR_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLA||' (TAR_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT '||V_FK||' CREADA EN TABLA '||TABLA_FK);   
  END IF;   


--Fin crear tabla

--Validamos si la tabla existe para hacer el indice. (I_BORRADO)

  SELECT COUNT(*) INTO V_EXISTE
  FROM all_indexes
  WHERE TABLE_NAME = ''||TABLA||'';


 I_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||I_BORRADO||'
                      ON '||V_ESQUEMA||'.'||TABLA||' ("PRC_ID", "TAR_ID", "TAP_CODIGO")
                      TABLESPACE '||ITABLE_SPACE||'';


 IF V_EXISTE = 0 THEN  
     EXECUTE IMMEDIATE I_MSQL;
     DBMS_OUTPUT.PUT_LINE( I_BORRADO||' CREADO');
 ELSE 
     DBMS_OUTPUT.PUT_LINE( 'EL ÍNDICE '||I_BORRADO||' YA EXISTE');    
 END IF; 

--Validamos si la tabla existe para hacer el indice. (I_COMPUESTO)

  SELECT COUNT(*) INTO V_EXISTE
  FROM all_indexes
  WHERE TABLE_NAME = ''||TABLA||'';


 I_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||I_COMPUESTO||'
                      ON '||V_ESQUEMA||'.'||TABLA||' ("CD_PROCEDIMIENTO", "PRC_ID", "PRC_PRC_ID", "DD_TPO_CODIGO")
                      TABLESPACE '||ITABLE_SPACE||'';


 IF V_EXISTE = 0 THEN  
     EXECUTE IMMEDIATE I_MSQL;
     DBMS_OUTPUT.PUT_LINE( I_COMPUESTO||' CREADO');
 ELSE 
     DBMS_OUTPUT.PUT_LINE( 'EL ÍNDICE '||I_COMPUESTO||' YA EXISTE');         
 END IF;

--Validamos si la tabla existe para hacer el indice. (I_PRC)

  SELECT COUNT(*) INTO V_EXISTE
  FROM all_indexes
  WHERE TABLE_NAME = ''||TABLA||'';


 I_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||I_PRC||'
                      ON '||V_ESQUEMA||'.'||TABLA||' ("PRC_ID")
                      TABLESPACE '||ITABLE_SPACE||'';


 IF V_EXISTE = 0 THEN  
     EXECUTE IMMEDIATE I_MSQL;
     DBMS_OUTPUT.PUT_LINE( I_PRC||' CREADO');
 ELSE 
     DBMS_OUTPUT.PUT_LINE( 'EL ÍNDICE '||I_PRC||' YA EXISTE');              
 END IF;    

--Fin crear indices

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



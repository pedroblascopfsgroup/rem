--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151006
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-475
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_MAESTRA_HITOS_VALORES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='MIG_MAESTRA_HITOS_VALORES';		  
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 I_MSQL VARCHAR2 (8500 CHAR);	
 V_EXISTE NUMBER (1);
 I_INSERT VARCHAR(30) := 'IDX_MAEV_INSERT';
 I_HITOS VARCHAR(30) := 'MIG_MAESTRA_HITOS_VALORES_1';
 I_TAREA VARCHAR(30) := 'TAP_TAREA_PROCEDIMIENTO_IND_2';


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	TEV_ID            NUMBER   (16,0) 		NOT NULL ENABLE, 
	TAR_ID            NUMBER   (16,0) 		NOT NULL ENABLE, 
	TAR_TAREA         VARCHAR2 (100 CHAR), 
	TAP_CODIGO        VARCHAR2 (100 CHAR), 
	TEV_ORDEN         NUMBER 		NOT NULL ENABLE, 
	TEV_NOMBRE        VARCHAR2 (50 CHAR)    NOT NULL ENABLE, 
	TEV_VALOR         VARCHAR2 (1000 CHAR), 
     CONSTRAINT "MIG_MAESTRA_HITOS_VALORES_PK" PRIMARY KEY ("TEV_ID") 
              USING INDEX TABLESPACE '||ITABLE_SPACE||'  ENABLE, 
     CONSTRAINT "FK_MIG_MAESTRA_HITOS" FOREIGN KEY ("TAR_ID")
	      REFERENCES "'||V_ESQUEMA||'"."MIG_MAESTRA_HITOS" ("TAR_ID") 
   ) SEGMENT CREATION IMMEDIATE';


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


--Validamos si la tabla existe para hacer el indice. (I_INSERT)

  SELECT COUNT(*) INTO V_EXISTE
  FROM all_indexes
  WHERE TABLE_NAME = ''||TABLA||'';


 I_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||I_INSERT||'
            ON '||V_ESQUEMA||'.'||TABLA||' ("TAR_ID", "TAP_CODIGO", "TEV_NOMBRE")
            TABLESPACE '||ITABLE_SPACE||'';


 IF V_EXISTE = 0 THEN  
     EXECUTE IMMEDIATE I_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||I_INSERT||' CREADA');
 ELSE 
     DBMS_OUTPUT.PUT_LINE( 'EL ÍNDICE '||I_INSERT||' YA EXISTE');         
 END IF; 


--Validamos si la tabla existe para hacer el indice. (I_HITOS)

  SELECT COUNT(*) INTO V_EXISTE
  FROM all_indexes
  WHERE TABLE_NAME = ''||TABLA||'';


 I_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||I_HITOS||'
            ON '||V_ESQUEMA||'.'||TABLA||' ("TAP_CODIGO", "TEV_NOMBRE", "TEV_VALOR")
            TABLESPACE '||ITABLE_SPACE||'';


 IF V_EXISTE = 0 THEN  
     EXECUTE IMMEDIATE I_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||I_HITOS||' CREADA');
 ELSE 
     DBMS_OUTPUT.PUT_LINE( 'EL ÍNDICE '||I_HITOS||' YA EXISTE');         
 END IF;      

--Validamos si la tabla existe para hacer el indice. (I_TAREA)

  SELECT COUNT(*) INTO V_EXISTE
  FROM all_indexes
  WHERE TABLE_NAME = ''||TABLA||'';


 I_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||I_TAREA||'
            ON '||V_ESQUEMA||'.'||TABLA||' ("TAP_CODIGO")
            TABLESPACE '||ITABLE_SPACE||'';


 IF V_EXISTE = 0 THEN  
     EXECUTE IMMEDIATE I_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||I_TAREA||' CREADA');
 ELSE 
     DBMS_OUTPUT.PUT_LINE( 'EL ÍNDICE '||I_TAREA||' YA EXISTE');           
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




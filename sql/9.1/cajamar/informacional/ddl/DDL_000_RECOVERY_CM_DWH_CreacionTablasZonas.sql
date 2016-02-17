--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-1058
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de tabla D_CNT_ZONA y D_EXP_ZONA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='D_CNT_ZONA';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	ZONA_CONTRATO_ID NUMBER(16,0) NOT NULL ENABLE, 
	ZONA_CONTRATO_DESC VARCHAR2(50 CHAR), 
	ZONA_CONTRATO_DESC_2 VARCHAR2(250 CHAR), 
	NIVEL_CONTRATO_ID NUMBER(16,0), 
	OFICINA_CONTRATO_ID NUMBER(16,0)
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
TABLA := 'D_EXP_ZONA';
--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 

   (	ZONA_EXPEDIENTE_ID NUMBER(16,0) NOT NULL ENABLE, 
	ZONA_EXPEDIENTE_DESC VARCHAR2(50 CHAR), 
	ZONA_EXPEDIENTE_DESC_2 VARCHAR2(250 CHAR), 
	NIVEL_EXPEDIENTE_ID NUMBER(16,0), 
	OFICINA_EXPEDIENTE_ID NUMBER(16,0)
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

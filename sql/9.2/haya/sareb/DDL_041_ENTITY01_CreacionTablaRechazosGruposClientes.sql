--/*
--##########################################
--## AUTOR=RAFAEL ARACIL LOPEZ
--## FECHA_CREACION=20160426
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2197
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de rechazos para GRUPOS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='TMP_PER_GCL_REJECTS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	"ROWREJECTED" VARCHAR2(1024 BYTE), 
	"ERRORCODE" VARCHAR2(255 BYTE), 
	"ERRORMESSAGE" VARCHAR2(255 BYTE)
   ) ';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' CREADA');     
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




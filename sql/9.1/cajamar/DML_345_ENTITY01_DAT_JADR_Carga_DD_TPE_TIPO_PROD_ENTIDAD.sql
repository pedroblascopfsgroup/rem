--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Carga Diccionario DD_TPE_TIPO_PROD_ENTIDAD
--##                   
--##                               , esquema CM01. Con estructura correcta
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
 TABLA1 VARCHAR(30) :='DD_TPE_TIPO_PROD_ENTIDAD'; 

 
err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;



BEGIN 

	SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA1||'';

 
  IF V_EXISTE = 1 THEN
  
V_MSQL1 := 'UPDATE '||V_ESQUEMA||'.'||TABLA1||' SET BORRADO = 1 WHERE USUARIOCREAR = ''INICIAL''
  ';
	EXECUTE IMMEDIATE V_MSQL1;
COMMIT;

DBMS_OUTPUT.PUT_LINE(V_MSQL1);	

	END IF;

  
    DBMS_OUTPUT.PUT_LINE(''||TABLA1||' MODIFICADA');

  

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


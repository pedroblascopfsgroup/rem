--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Cambio de nombre de la tabla  DD_EIC_ESTADO_INTERNO_CAJAMAR a DD_EIC_ESTADO_INTERNO_ENTIDAD
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
 TABLA1 VARCHAR(30) :='DD_EIC_ESTADO_INTERNO_CAJAMAR'; 
 TABLA2 VARCHAR(30) :='DD_EIC_ESTADO_INTERNO_ENTIDAD';
 SECUENCIA VARCHAR(30) := 'DD_EIC_EDO_INTERNO_CAJAMAR' ;
 
err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
V_MSQL2 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;



BEGIN 


SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA2||'';

 
  IF V_EXISTE = 0 THEN
      V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA2||' AS 
   (	SELECT * FROM  '||V_ESQUEMA||'.'||TABLA1||' )
  ';
  	EXECUTE IMMEDIATE V_MSQL1;
  END IF;   

   V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||SECUENCIA and sequence_owner= V_ESQUEMA;

 if V_EXISTE is not null OR V_EXISTE > 0 then
     EXECUTE IMMEDIATE('DROP SEQUENCE '||V_ESQUEMA||'.S_'||SECUENCIA||);
 end if;


          

DBMS_OUTPUT.PUT_LINE(V_MSQL1);


     V_MSQL2 := 'DROP TABLE '||V_ESQUEMA||'.'||TABLA1||'';

DBMS_OUTPUT.PUT_LINE(V_MSQL2);


 EXECUTE IMMEDIATE V_MSQL2;
     DBMS_OUTPUT.PUT_LINE(''||TABLA1||' BORRADA');

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


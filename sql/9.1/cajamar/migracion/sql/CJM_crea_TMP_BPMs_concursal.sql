--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TMP_ALTA_BPM_INSTANCES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='TMP_ALTA_BPM_INSTANCES';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE GLOBAL TEMPORARY TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (    PRC_ID NUMBER(16,0) NOT NULL ENABLE, 
        DEF_ID NUMBER(16,0) NOT NULL ENABLE, 
        NODE_ID NUMBER(16,0) NOT NULL ENABLE, 
        TAP_CODIGO VARCHAR2(100 CHAR) NOT NULL ENABLE, 
        TEX_ID NUMBER(16,0) NOT NULL ENABLE, 
        FORK_NODE NUMBER(16,0), 
        INST_ID NUMBER(16,0) NOT NULL ENABLE, 
        TOKEN_PADRE_ID NUMBER(16,0), 
        MODULE_PADRE_ID NUMBER(16,0), 
        VMAP_PADRE_ID NUMBER(16,0), 
        TOKEN_ID NUMBER(16,0), 
        MODULE_ID NUMBER(16,0), 
        VMAP_ID NUMBER(16,0)
   ) ON COMMIT DELETE ROWS' ;
 
 
 
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

EXIT;


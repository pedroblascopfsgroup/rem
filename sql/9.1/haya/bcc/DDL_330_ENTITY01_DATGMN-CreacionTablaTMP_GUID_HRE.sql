--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TMP_GUID_BCC
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
 TABLA VARCHAR(30) :='TMP_GUID_HRE';
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
   (
        GUID_ID                  NUMBER(16,0) NOT NULL ENABLE
      , GUID_SYSGUID             VARCHAR2(32 BYTE) NOT NULL ENABLE
      , GUID_ASU_ID_EXTERNO      VARCHAR2(50 BYTE) NOT NULL ENABLE 
      , GUID_DES                 VARCHAR2(30 CHAR) NOT NULL ENABLE 
      , GUID_DD_TPO_CODIGO       VARCHAR2(20 CHAR)
      , GUID_BIE_CODIGO_INTERNO  NUMBER(16,0)
      , GUID_CNT_CONTRATO        VARCHAR2(50 CHAR)
      , GUID_TAP_CODIGO           VARCHAR2(100 CHAR)
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

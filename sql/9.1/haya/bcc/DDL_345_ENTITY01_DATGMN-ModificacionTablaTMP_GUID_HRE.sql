--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151216
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación de campo GUID_TAP_CODIGO de tabla TMP_GUID_HRE
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
 V_MSQL1 VARCHAR2(1500 CHAR);
 V_MSQL2 VARCHAR2(1500 CHAR);
 V_MSQL3 VARCHAR2(1500 CHAR);
 V_MSQL4 VARCHAR2(1500 CHAR); 
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TAB_COLUMNS
  WHERE TABLE_NAME  = ''||TABLA||''
    AND COLUMN_NAME = 'GUID_DD_PCO_PEP_CODIGO';

 
  V_MSQL1 := ' ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' ADD (GUID_DD_PCO_PEP_CODIGO VARCHAR2 (2 CHAR))';
  
  V_MSQL2 := ' ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' ADD (GUID_PCO_DOC_PDD_UG_DESC VARCHAR2 (50 CHAR))';
  
  V_MSQL3 := ' ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' ADD (GUID_DD_TFA_CODIGO VARCHAR2 (20 CHAR))';
 
   V_MSQL4 := ' ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' ADD (GUID_DD_PCO_DTD_CODIGO VARCHAR2 (2 CHAR))';
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL1;
     EXECUTE IMMEDIATE V_MSQL2;
     EXECUTE IMMEDIATE V_MSQL3;
     EXECUTE IMMEDIATE V_MSQL4;          
     DBMS_OUTPUT.PUT_LINE(TABLA||' MODIFICADA');  

  ELSE   
     DBMS_OUTPUT.PUT_LINE(TABLA||' LOS CAMPOS A AÑADIR YA EXISTEN');
    
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

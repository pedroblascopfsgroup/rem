--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151216
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación de campo GUID_TAP_CODIGO de tabla TMP_GUID_HRE_2
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
 TABLA VARCHAR(30) :='TMP_GUID_HRE_2';
 COLUMNA VARCHAR(30) :='GUID_TAP_CODIGO'; 
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TAB_COLUMNS
  WHERE TABLE_NAME  = ''||TABLA||''
    AND COLUMN_NAME = ''||COLUMNA;

  
  V_MSQL := ' ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' MODIFY ('||COLUMNA||' VARCHAR2 (250 CHAR))';
 
 
 
  IF V_EXISTE = 0 THEN   
     DBMS_OUTPUT.PUT_LINE(TABLA||' EL CAMPO GUID_TAP_CODIGO NO EXISTE');
  ELSE   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' MODIFICADA');  
    
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

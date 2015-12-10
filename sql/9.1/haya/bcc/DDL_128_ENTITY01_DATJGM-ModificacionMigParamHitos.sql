--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20150930
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-911
--## PRODUCTO=NO
--## 
--## Finalidad: Modificacion columna MIG_PARAM_HITOS
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
 TABLA VARCHAR(30) :='MIG_PARAM_HITOS';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_LENGTH NUMBER(5);


BEGIN 

  -- MIRA DE CUANTOS CARACTERES ES LA COLUMNA
  Select  CHAR_LENGTH INTO V_LENGTH 
  from ALL_TAB_COLUMNS
  WHERE TABLE_NAME = 'MIG_PARAM_HITOS'
  AND COLUMN_NAME ='COD_TIPO_PROCEDIMIENTO';
  
  DBMS_OUTPUT.PUT_LINE('LA COLUMNA ES UN VARCHAR DE '||V_LENGTH);
       
   -- CAMBIA A CARACTER CORRECT
   IF V_LENGTH >=3 then
   DBMS_OUTPUT.put_line('COD_TIPO_PROCEDIMIENTO YA ES VARCHAR IGUAL O MAYOR DE 3');
   ELSE
   V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' MODIFY COD_TIPO_PROCEDIMIENTO VARCHAR2(5 CHAR)';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.put_line('COD_TIPO_PROCEDIMIENTO MODIFICADO A VARCHAR DE 5');
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



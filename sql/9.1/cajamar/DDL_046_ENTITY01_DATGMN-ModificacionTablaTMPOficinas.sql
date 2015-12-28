--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20150921
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Eliminar ÍNDICE de tabla Temporal Oficinas --> APR_AUX_OFI_OFICINAS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 GMN:> Borramos la PK en lugar del índice
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := 'CM01';
 TABLA VARCHAR(30) :='APR_AUX_OFI_OFICINAS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(2500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

--Validamos si la CONSTRAINT existe antes de crearla y si existe borramos la PK.
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_CONSTRAINTS
  WHERE CONSTRAINT_NAME = 'PK_APR_AUX_OFI_OFICINAS';

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  DROP PRIMARY KEY';


 IF V_EXISTE > 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' Modificada');
  ELSE   
     DBMS_OUTPUT.PUT_LINE('CONSTRAINT NO EXISTENTE EN TABLA');     
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

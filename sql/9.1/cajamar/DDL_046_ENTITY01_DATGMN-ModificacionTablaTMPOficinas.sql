--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20150919
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Eliminar ÍNDICE de tabla Temporal Oficinas --> APR_AUX_OFI_OFICINAS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
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

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE
  FROM all_indexes
  WHERE INDEX_NAME = 'PK_APR_AUX_OFI_OFICINAS';

  V_MSQL := 'DROP INDEX PK_APR_AUX_OFI_OFICINAS';


 IF V_EXISTE > 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' Modificada');
  ELSE   
     DBMS_OUTPUT.PUT_LINE('ÍNDICE NO EXISTENTE EN LA TABLA '||TABLA||'');     
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

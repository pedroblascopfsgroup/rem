--*/
--##########################################
--## AUTOR=ENRIQUE JIMENEZ DIAZ
--## FECHA_CREACION=20151013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-739
--## PRODUCTO=NO
--## 
--## Finalidad: Se crea la tabla TMP_ALE_ALERTAS_REJECTS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se ajusta para dejar como NOT NULLABLE lo imprescindible
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) :=    'CM01';
 V_ESQUEMA_M VARCHAR(25) :=  'CMMASTER'; 
 TABLA1 VARCHAR(30) :=       'TMP_ALE_ALERTAS';
 TABLA2 VARCHAR(30) :=       'ALE_ALERTAS'; 
 TABLE_SPACE VARCHAR(25)  := 'DRECOVERYONL8M';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(1500 CHAR);
 V_MSQL2 VARCHAR2(1500 CHAR); 
 V_EXISTE NUMBER (1):=null;
 COLUMNA VARCHAR2 (50) :=  'TMP_ALE_COD_CLIENTE_ENTIDAD';
 COLUMNA2 VARCHAR2 (50) :=  'TMP_ALE_COD_ENTIDAD';
 COLUMNA3 VARCHAR2 (50) :=  'TMP_ALE_COD_PROPIETARIO'; 
 COLUMNA4 VARCHAR2 (50) :=  'TMP_ALE_TIPO_PRODUCTO';
 COLUMNA5 VARCHAR2 (50) :=  'TMP_ALE_NUMERO_CONTRATO';
 COLUMNA6 VARCHAR2 (50) :=  'TMP_ALE_NUMERO_ESPEC';

BEGIN 
  
--Validamos si la tabla existe antes de crearla

SELECT COUNT(*) INTO V_EXISTE
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = ''||TABLA1||''
AND OWNER      = ''||V_ESQUEMA||''
AND COLUMN_NAME = ''||COLUMNA||'';
  
  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  MODIFY
	     ( 
            COLUMNA||''   NOT NULL
	     )';
    
--Primera Columna   
IF V_EXISTE = 1 THEN

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    DROP COLUMN '||COLUMNA);
                    
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA|| ' BORRADA');

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA||' NUMBER (16) NOT NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA|| ' CREADA');

ELSE 
      EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA||' NUMBER (16) NOT NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA|| ' CREADA');
END IF;

--Segunda Columna  
  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  MODIFY
	     ( 
            TMP_ALE_COD_CLIENTE_ENTIDAD   NOT NULL
	     )';
       
IF V_EXISTE = 1 THEN

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    DROP COLUMN '||COLUMNA2);
                    
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA2|| ' BORRADA');

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA2||' NUMBER(4,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA2|| ' CREADA');

ELSE 
EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA2||' NUMBER(4,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA2|| ' CREADA');
END IF;     

--Tercera columan
IF V_EXISTE = 1 THEN

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    DROP COLUMN '||COLUMNA3);
                    
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA3|| ' BORRADA');

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA3||' NUMBER(5,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA3|| ' CREADA');

ELSE 
      EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA3||' NUMBER(5,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA3|| ' CREADA');
END IF;

--Cuarta columna
IF V_EXISTE = 1 THEN

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    DROP COLUMN '||COLUMNA4);
                    
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA4|| ' BORRADA');

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA4||' VARCHAR2(5 CHAR) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA4|| ' CREADA');

ELSE 
      EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA4||' VARCHAR2(5 CHAR) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA4|| ' CREADA');
END IF;

--Quinta columna
IF V_EXISTE = 1 THEN

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    DROP COLUMN '||COLUMNA5);
                    
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA5|| ' BORRADA');

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA5||' NUMBER(17,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA5|| ' CREADA');

ELSE 
      EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA5||' NUMBER(17,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA5|| ' CREADA');
END IF;

--Sexta columna
IF V_EXISTE = 1 THEN

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    DROP COLUMN '||COLUMNA6);
                    
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA6|| ' BORRADA');

EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA6||' NUMBER(15,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA6|| ' CREADA');

ELSE 
      EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||' 
                    ADD '||COLUMNA6||' NUMBER(15,0) NULL');
                                      
DBMS_OUTPUT.PUT_LINE('COLUMNA ' ||COLUMNA6|| ' CREADA');
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
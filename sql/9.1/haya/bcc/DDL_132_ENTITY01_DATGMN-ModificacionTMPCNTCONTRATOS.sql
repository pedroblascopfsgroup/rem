--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20151112
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-911
--## PRODUCTO=NO
--## 
--## Finalidad: Modificacion columna TMP_CNT_FECHA_POS_VENCIDA a NULLABLE de TMP_CNT_CONTRATOS
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
 V_TABLA VARCHAR(31) :='TMP_CNT_CONTRATOS';
 V_COL VARCHAR(31) :='TMP_CNT_FECHA_POS_VENCIDA'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR);
 V_NULLABLE VARCHAR2(1 CHAR);  
 
 

BEGIN 

        V_NULLABLE := '';
        V_MSQL1 := 'SELECT NULLABLE
                    FROM ALL_TAB_COLUMNS
                    WHERE TABLE_NAME = '''||V_TABLA||'''
                    AND COLUMN_NAME = '''||V_COL||'''';
                    
        
        EXECUTE IMMEDIATE V_MSQL1 INTO V_NULLABLE ;

        IF V_NULLABLE = 'N' THEN 
           -- Cambia el campo a NULLABLE
            V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY '||V_COL||' DATE NULL';
            EXECUTE IMMEDIATE V_MSQL2;

            DBMS_OUTPUT.put_line('Campo '||V_TABLA||'.'||V_COL||' modificado a NULLABLE.');
        ELSE
            DBMS_OUTPUT.put_line('Campo '||V_TABLA||'.'||V_COL||' ya es NULLABLE.');        
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

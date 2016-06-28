--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160627
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-1467
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir columna Finalizado a aux_alta_asuntos_concursos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 	-- Configuracion Esquema Master
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 
    V_MSQL := '  SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''RIESGO_OPE_REG_BAJA_CONVIV'' AND COLUMN_NAME = ''NUMERO_CONTRATO'' AND OWNER = '''||v_esquema|| '''';
 
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

    IF V_EXISTE > 0 THEN
		V_MSQL := 'ALTER TABLE '||v_esquema||'.RIESGO_OPE_REG_BAJA_CONVIV MODIFY NUMERO_CONTRATO NUMBER(17) ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.RIESGO_OPE_REG_BAJA_CONVIV modificada columna NUMERO_CONTRATO');	     
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
EXIT

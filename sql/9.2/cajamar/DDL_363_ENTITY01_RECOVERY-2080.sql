--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160621
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2080
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

    SELECT COUNT(*) INTO V_EXISTE FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = 'SALIDAS_ONLINE_CNT' AND COLUMN_NAME = 'FECHA_SOL_PREV' AND OWNER = 'CM01';
    IF V_EXISTE = 0 THEN
		V_MSQL := 'ALTER TABLE '||v_esquema||'.SALIDAS_ONLINE_CNT ADD FECHA_SOL_PREV DATE';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.SALIDAS_ONLINE_CNT creada columna FECHA_SOL_PREV DATE');	     
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

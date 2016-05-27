--/*
--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160517
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2962
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir columna Finalizado a aux_alta_asuntos_litigios
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
 TABLA VARCHAR(30) :='CTRO_INFOR_CALCULO_KPIS_CONVIV';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

    SELECT COUNT(*) INTO V_EXISTE FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = 'AUX_ALTA_ASUNTOS_LITIGIOS' AND COLUMN_NAME = 'FINALIZADO';
    IF V_EXISTE = 0 THEN
		V_MSQL := 'ALTER TABLE '||v_esquema||'.AUX_ALTA_ASUNTOS_LITIGIOS ADD FINALIZADO NUMBER(1,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.AUX_ALTA_ASUNTOS_LITIGIOS creada columna FINALIZADO NUMBER(1,0)');	     
    END IF; 

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

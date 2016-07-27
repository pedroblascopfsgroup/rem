--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2049
--## PRODUCTO=NO
--## 
--## Finalidad: Inicializar DWH BI
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='LOG_GENERAL_PARAMETROS';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 v_error VARCHAR2(100); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 


	V_MSQL :=  'BEGIN '||V_ESQUEMA||'.CARGAR_PARAMETROS_ENTORNO(:v_error); END;';
	execute immediate V_MSQL using out v_error; 

	V_MSQL :=  'BEGIN '||V_ESQUEMA||'.CARGAR_LOG(:v_error); END;';
	execute immediate V_MSQL using out v_error;      

	V_MSQL :=  'BEGIN '||V_ESQUEMA||'.CARGAR_DIM_FECHA(1980,90); END;';
	execute immediate V_MSQL; 

	DBMS_OUTPUT.PUT_LINE('INCIALIZACION OK');


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

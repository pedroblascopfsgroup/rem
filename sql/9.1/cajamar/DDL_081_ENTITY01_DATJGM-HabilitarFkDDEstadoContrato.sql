--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-922
--## PRODUCTO=NO
--## 
--## Finalidad: Activación constraints DD_ECE_ESTADO_CONTRATO_ENTIDAD
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

--Declaramos las variables

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='DD_ECE_ESTADO_CONTRATO_ENTIDAD';
 FK_ID VARCHAR (30) := 'FK_DD_ECE_FK_DD_ESC_ID';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);
 V_ACTIVA NUMBER (1);


BEGIN 

--Miramos si la constraint esta activa

  SELECT COUNT(*) INTO V_ACTIVA
  FROM USER_CONSTRAINTS
  WHERE TABLE_NAME = ''||TABLA
  AND CONSTRAINT_NAME =''||FK_ID
  AND STATUS = 'DISABLED';

--Habilita la constraint


V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||TABLA;
V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' ENABLE CONSTRAINT '||FK_ID;
          


IF V_ACTIVA > 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('TABLA '||TABLA||' TRUNCADA');
     EXECUTE IMMEDIATE V_MSQL2;
     DBMS_OUTPUT.PUT_LINE('CONSTRAINT '||FK_ID||' ACTIVADA');
  ELSE   
     DBMS_OUTPUT.PUT_LINE('LA CONSTRAINT ' ||FK_ID||' YA ESTA ACTIVA');     
  END IF;   

--Fin habilita constraint

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

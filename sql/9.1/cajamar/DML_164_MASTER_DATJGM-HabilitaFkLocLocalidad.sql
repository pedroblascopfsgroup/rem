--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151105
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-922
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar y habilita constraints de tabla LOC_LOCALIDAD
--##                   
--##                               , esquema MASTER. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:0.1
--##        
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_LOC_LOCALIDAD'; 
 FK_ID VARCHAR (30) := 'FK_DD_LOC_L_FK_PRV_LO_DD_PRV_P';
 V_ACTIVA NUMBER (1);
 err_num NUMBER;
 err_msg VARCHAR2(2048); 


BEGIN 

   --Modifica Valor de PRV_ID en TODOS LAS COLUMNAS
   EXECUTE IMMEDIATE ('UPDATE '||V_ESQUEMA_M||'.'||TABLA||' SET DD_PRV_ID = ''0''');
   DBMS_OUTPUT.put_line('PRV_ID ACTUALIZAD0');

 --Miramos si la constraint esta activa

  SELECT COUNT(*) INTO V_ACTIVA
  FROM USER_CONSTRAINTS
  WHERE TABLE_NAME = ''||TABLA
  AND CONSTRAINT_NAME =''||FK_ID
  AND STATUS = 'DISABLED';

--Habilita la constraint

IF V_ACTIVA  > 0 THEN   
     EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA_M||'.'||TABLA||' ENABLE CONSTRAINT '||FK_ID);
     DBMS_OUTPUT.PUT_LINE('CONSTRAINT '||FK_ID||' ACTIVADA');
  ELSE   
     DBMS_OUTPUT.PUT_LINE('LA CONSTRAINT ' ||FK_ID||' YA ESTA ACTIVA');     
  END IF;   

--Fin habilita constraint


 COMMIT;
 
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
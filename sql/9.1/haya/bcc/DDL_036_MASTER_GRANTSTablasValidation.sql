--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150828
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-533
--## PRODUCTO=NO
--## 
--## Finalidad: Grants tablas de job_validation DD_JVI_JOB_VAL_INTERFAZ, DD_JVS_JOB_VAL_SEVERITY y BATCH_JOB_VALIDATION para #ESQUEMA#
--##                               , esquema #ESQUEMA_MASTER#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_SCHEMA VARCHAR(25) := '#ESQUEMA#'; 
 V_SCHEMA_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
 TABLA1 VARCHAR(30) :='DD_JVS_JOB_VAL_SEVERITY'; 
 TABLA2 VARCHAR(30) :='DD_JVI_JOB_VAL_INTERFAZ';  
 TABLA3 VARCHAR(30) :='BATCH_JOB_VALIDATION'; 
 err_num NUMBER;	
 err_msg VARCHAR2(2048); 
 V_EXISTE NUMBER (1):=null;


BEGIN 

   EXECUTE IMMEDIATE ('grant insert, select, update on '||V_SCHEMA_MASTER||'.'||TABLA1||' to '||V_SCHEMA||''); 
   EXECUTE IMMEDIATE ('grant insert, select, update on '||V_SCHEMA_MASTER||'.'||TABLA2||' to '||V_SCHEMA||''); 
   EXECUTE IMMEDIATE ('grant insert, select, update on '||V_SCHEMA_MASTER||'.'||TABLA3||' to '||V_SCHEMA||''); 
   
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
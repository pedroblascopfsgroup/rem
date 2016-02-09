--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ
--## FECHA_CREACION=20160208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK= CMREC-1645
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de TABLA de MIG_RGE_REL_GESTOR_EXPEDIENTE
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master 
 TABLA1 VARCHAR(30) :='MIG_RGE_REL_GESTOR_EXPEDIENTE';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

BEGIN 

  -- CREAMOS LA TABLA DE MIG_RGE_REL_GESTOR_EXPEDIENTE 
  V_EXISTE:=0;
  
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA1||'';


  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA1||' 
   (
        CD_EXPEDIENTE               NUMBER(16) NOT NULL ENABLE, 
        COD_GESTOR	                VARCHAR(20 CHAR) NOT NULL ENABLE,
        FECHA_FICHERO	            DATE NOT NULL ENABLE,
        VERSION                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOCREAR                VARCHAR2(25 CHAR)   NOT NULL,
        FECHACREAR                  DATE                DEFAULT SYSDATE               NOT NULL,
        BORRADO                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOMODIFICAR            VARCHAR2(25 CHAR),
        FECHAMODIFICAR              DATE,
        USUARIOBORRAR               VARCHAR2(25 CHAR),
        FECHABORRAR                 DATE
   ) SEGMENT CREATION IMMEDIATE';


IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLA1||' CREADA');
ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA1||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE( TABLA1||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLA1||' CREADA');        
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

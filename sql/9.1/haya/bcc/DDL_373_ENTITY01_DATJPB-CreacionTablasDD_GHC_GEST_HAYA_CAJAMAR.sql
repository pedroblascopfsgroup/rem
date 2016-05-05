--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ
--## FECHA_CREACION=20160208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK= CMREC-1645
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de TABLA de DD_GHC_GEST_HAYA_CAJAMAR
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
 TABLA1 VARCHAR(30) :='DD_GHC_GEST_HAYA_CAJAMAR';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

BEGIN 

  -- CREAMOS LA TABLA DE DD_GHC_GEST_HAYA_CAJAMAR 
  V_EXISTE:=0;
  
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA1||'';


  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA1||' 
   (
        DD_GHC_HAYA_CODIGO              VARCHAR2(20 CHAR) NOT NULL ENABLE,
        DD_GHC_BCC_CODIGO	            VARCHAR2(20 CHAR),
        VERSION	            			NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE,
        USUARIOCREAR       				VARCHAR2(50 CHAR) NOT NULL ENABLE,
        FECHACREAR         				TIMESTAMP (6) NOT NULL ENABLE,
        USUARIOMODIFICAR   				VARCHAR2(50 CHAR),
        FECHAMODIFICAR     				TIMESTAMP (6),
        USUARIOBORRAR      				VARCHAR2(50 CHAR),
		FECHABORRAR       				TIMESTAMP (6),
        BORRADO					        NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
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

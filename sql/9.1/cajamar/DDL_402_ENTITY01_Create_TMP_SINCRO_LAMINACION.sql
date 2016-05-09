--/*
--##########################################
--## AUTOR=SERGIO HERNANDEZ GASO
--## FECHA_CREACION=20160416
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1714
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master
 TABLA VARCHAR(30 CHAR) :='TMP_SINCRO_LAMINACION';
 ITABLE_SPACE VARCHAR(25 CHAR) := '#TABLESPACE_INDEX#'; -- '#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE  FROM ALL_TABLES WHERE TABLE_NAME = ''||TABLA;
  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
            (	SYS_GUID VARCHAR2(32 BYTE)  Not Null,
              	FECHA_VENCIMIENTO DATE  Not Null,
		FECHA_VENCIM_REAL  DATE Not Null
            ) SEGMENT CREATION IMMEDIATE 
             NOCOMPRESS LOGGING';

 

  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');  
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;

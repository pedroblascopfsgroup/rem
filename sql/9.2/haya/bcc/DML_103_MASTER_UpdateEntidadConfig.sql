--/*
--##########################################
--## AUTOR=Rachel
--## FECHA_CREACION=20160407
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-cj
--## INCIDENCIA_LINK=HR-2211
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 
    V_NUM_EXISTE NUMBER(16);  
    ERR_NUM NUMBER(25); 
    ERR_MSG VARCHAR2(1024 CHAR); 
BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualización de configuración'); 
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.ENTIDADCONFIG set DATAVALUE=''0240'' where DATAKEY=''workingCode'' and ENTIDAD_ID=41';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    COMMIT;

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

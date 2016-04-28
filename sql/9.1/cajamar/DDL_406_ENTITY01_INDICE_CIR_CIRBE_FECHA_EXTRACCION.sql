--/*
--##########################################
--## AUTOR=LORENZO LERATE
--## FECHA_CREACION=20160427
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=NO
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL         VARCHAR2(3200 CHAR); -- Sentencia a ejecutar    
	V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';

BEGIN            

	V_MSQL := 'drop index '||V_ESQUEMA||'.CIR_CIRBE_INDEX_1';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.put_line('Índice borrado');

	V_MSQL := 'CREATE BITMAP INDEX CIR_CIRBE_INDEX_1 ON '||V_ESQUEMA||'.CIR_CIRBE (CIR_FECHA_EXTRACCION) TABLESPACE '||ITABLE_SPACE;
  EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.put_line('Índice creado');

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

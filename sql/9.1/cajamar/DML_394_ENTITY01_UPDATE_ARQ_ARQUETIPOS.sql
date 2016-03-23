--/*
--##########################################
--## AUTOR=Lorenzo Lerate
--## FECHA_CREACION=20160323
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CORREO
--## PRODUCTO=NO
--## Finalidad: Actualizar nombre arquetipos
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

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
        
	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = ''GR PARTICULARES HIP <= 200k y > 30k'' WHERE ARQ_NOMBRE = ''OLD-GR PARTICULARES HIP <= 200k''';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = ''GR PARTICULARES RESTO <= 60k y > 30k'' WHERE ARQ_NOMBRE = ''OLD-GR PARTICULARES RESTO''';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = ''GR EMP Y AUT <=200k y >30k'' WHERE ARQ_NOMBRE = ''OLD-GR EMP Y AUT HASTA 200k''';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = ''SINT PARTICULAR HIPOT MUY GRAVE > 30k'' WHERE ARQ_NOMBRE = ''OLD-SINT PARTICULAR HIPOT MUY GRAVE''';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = ''SINT PARTICULARES NO HIPOT MUY GRAVE > 30k'' WHERE ARQ_NOMBRE = ''OLD-SINT PARTICULARES NO HIPOT MUY GRAVE''';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = ''SINT EMP/AUT MUY GRAVE <=200k y >30k'' WHERE ARQ_NOMBRE = ''OLD-SINT EMP/AUT <200K MUY GRAVE''';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = ''SIST T100'' WHERE ARQ_NOMBRE = ''OLD-SIST T200''';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||v_esquema||'.ARQ_ARQUETIPOS SET ARQ_NOMBRE = REPLACE(ARQ_NOMBRE,''OLD-'')';
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

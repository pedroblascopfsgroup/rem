--/*
--##########################################
--## AUTOR=Lorenzo Lerate Perea
--## FECHA_CREACION=20160302
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=NO
--## PRODUCTO=NO
--## Finalidad: Modificaciones del tipo intervencion
--##
--## INSTRUCCIONES: NO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
DBMS_OUTPUT.put_line('--INICIO--');

V_MSQL := 'UPDATE '||V_ESQUEMA||'.dd_tin_tipo_intervencion set dd_tin_avalista = 0';
EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('UPDATE DD_TIN_TIPO_INTERVENCION.DD_TIN_AVALISTA = 0 -> OK');

V_MSQL := 'UPDATE '||V_ESQUEMA||'.dd_tin_tipo_intervencion set dd_tin_avalista = 1
where dd_tin_codigo in (4,5,92,99)';
EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('UPDATE DD_TIN_TIPO_INTERVENCION.DD_TIN_AVALISTA = 1 -> OK');

V_MSQL := 'UPDATE '||V_ESQUEMA||'.dd_tin_tipo_intervencion set dd_tin_titular = 1
where dd_tin_codigo in (93)';
EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('UPDATE DD_TIN_TIPO_INTERVENCION.DD_TIN_TITULAR = 1 WHERE DD_TIN_CODIGO IN (93) -> OK');

COMMIT;  

DBMS_OUTPUT.put_line('--FIN--');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;

    DBMS_OUTPUT.put_line('Error:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
  
    ROLLBACK;
	RAISE;
END;
/
EXIT;   

--/*
--##########################################
--## AUTOR=Lorenzo Lerate Perea
--## FECHA_CREACION=20160315
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.2
--## INCIDENCIA_LINK=NO
--## PRODUCTO=NO
--## Finalidad: Sustitución caracteres ¥ por Ñ
--##
--## INSTRUCCIONES: NO
--## VERSIONES:
--##        0.1 Versión inicial -- Lorenzo Lerate Perea
--##
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

V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA
SET DD_PRV_DESCRIPCION = replace(DD_PRV_DESCRIPCION, ''¥'', ''Ñ''),
  DD_PRV_DESCRIPCION_LARGA = replace(DD_PRV_DESCRIPCION_LARGA, ''¥'', ''Ñ'')
WHERE DD_PRV_DESCRIPCION LIKE ''%¥%'' 
  OR DD_PRV_DESCRIPCION_LARGA LIKE ''%¥%''';

EXECUTE IMMEDIATE(V_MSQL);

DBMS_OUTPUT.put_line('UPDATE '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA
SET DD_PRV_DESCRIPCION = replace(DD_PRV_DESCRIPCION, ''¥'', ''Ñ''),
  DD_PRV_DESCRIPCION_LARGA = replace(DD_PRV_DESCRIPCION_LARGA, ''¥'', ''Ñ'')
WHERE DD_PRV_DESCRIPCION LIKE ''%¥%'' 
  OR DD_PRV_DESCRIPCION_LARGA LIKE ''%¥%'';');
  
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

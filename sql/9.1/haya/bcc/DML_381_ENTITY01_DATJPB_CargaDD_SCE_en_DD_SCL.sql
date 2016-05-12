--/*
--##########################################
--## AUTOR=Jose Manuel Perez Barberá
--## FECHA_CREACION=20160219
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-2194
--## PRODUCTO=NO
--## Finalidad: Rellenar el SCL igual que el SCE
--##                               , esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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

V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_SCL_SEGTO_CLI SET BORRADO = 1';
EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('UPDATE BORRADO 1 OK');

V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SCL_SEGTO_CLI (DD_SCL_ID, DD_SCL_CODIGO, DD_SCL_DESCRIPCION, DD_SCL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
          SELECT '||V_ESQUEMA||'.S_DD_SCL_SEGTO_CLI.NEXTVAL, DD_SCE_CODIGO, DD_SCE_DESCRIPCION, DD_SCE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO 
          FROM '||V_ESQUEMA||'.DD_SCE_SEGTO_CLI_ENTIDAD SCE
			WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.DD_SCL_SEGTO_CLI SCL WHERE SCL.DD_SCL_CODIGO = SCE.DD_SCE_CODIGO)';
EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('INSERT OK');

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

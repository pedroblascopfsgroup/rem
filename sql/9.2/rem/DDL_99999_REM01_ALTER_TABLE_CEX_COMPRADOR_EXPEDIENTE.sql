--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190326
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3770
--## PRODUCTO=NO
--##
--## Finalidad: Alter table columna borrado not null
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-3770';

 BEGIN

  V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = ''BORRADO'' AND TABLE_NAME = ''CEX_COMPRADOR_EXPEDIENTE''';
      
  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
   
	IF V_COUNT > 0 THEN
	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE SET BORRADO = 0 WHERE BORRADO IS NULL';
		EXECUTE IMMEDIATE V_SQL;
	
	    V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE MODIFY BORRADO NOT NULL';
	    EXECUTE IMMEDIATE V_SQL;
	END IF;

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

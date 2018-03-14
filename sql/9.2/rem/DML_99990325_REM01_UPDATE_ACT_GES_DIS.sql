--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-215
--## PRODUCTO=NO
--##
--## Finalidad: Se modifica el gestor y supervisor de la tarea Posicionamiento y firma
--## INSTRUCCIONES:
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
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-215';

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO]');

   V_MSQL := 'UPDATE REM01.ACT_GES_DIST_GESTORES
   		SET USERNAME = ''acampos''
		WHERE USERNAME = ''zmartin''
		    AND TIPO_GESTOR = ''GFORM''';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas de la tabla de configuración de gestores');

   V_MSQL := 'UPDATE REM01.ACT_GES_DIST_GESTORES
   		SET USERNAME = ''nbertran''
		WHERE USERNAME = ''cmartinez''
		    AND TIPO_GESTOR = ''GFORM''';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas de la tabla de configuración de gestores');
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.PUT_LINE(ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
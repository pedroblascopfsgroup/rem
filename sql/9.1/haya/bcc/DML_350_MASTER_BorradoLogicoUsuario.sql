--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc35
--## INCIDENCIA_LINK=HR-1618
--## PRODUCTO=SI
--## Finalidad: Borrado lógico de un usuario.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(25);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''et.iirurzun''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el usuario en la tabla '||V_ESQUEMA_M||'.USU_USUARIOS, no se actualiza nada.');
	ELSE
		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET BORRADO = 1 WHERE USU_USERNAME=''et.iirurzun''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA_M||'.USU_USUARIOS');
	END IF;
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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
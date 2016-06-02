--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=Sin-ITEM
--## PRODUCTO=NO
--## Finalidad: Borrar procedure Turnado de todos los clietnes excepto BANKIA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INFO] PROCEDURE ' || V_ESQUEMA || '.asignacion_asuntos_turnado - Borrar procedure de CAJAMAR');

	---- Se comprueba que exista la columna
	V_SQL := 'SELECT COUNT(1) from USER_PROCEDURES  where UPPER(object_name) like UPPER(''asignacion_asuntos_turnado'')';
		  
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El proceudore asignacion_asuntos_turnado  *NO* existe. Por tanto no se hará nada.');
	ELSE 
		--Se borra el procedure asignacion_asuntos_turnado
		V_SQL := 'DROP PROCEDURE '||V_ESQUEMA||'.asignacion_asuntos_turnado';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] PROCEDURE ' || V_ESQUEMA || '.asignacion_asuntos_turnado... eliminado correctamente');
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
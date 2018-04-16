--/*
--##########################################
--## AUTOR=JUANJO ARBONA
--## FECHA_CREACION=20180406
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-408
--## PRODUCTO=NO
--## Finalidad: Borrar trabajo duplicado en GPV_TBJ.
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA_1 VARCHAR2(50 CHAR):= 'GPV_TBJ';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de borrado del duplicado en la tabla GPV_TBJ');
    
    V_SQL := ' SELECT COUNT(1) FROM (
			SELECT 1 FROM '||V_ESQUEMA||'.GPV_TBJ GT
			WHERE GT.GPV_TBJ_ID = 82441
			AND GT.BORRADO = 0)';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'... PROCEDEMOS A BORRAR '||V_NUM_TABLAS||' REGISTROS');
		
		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_1||' GT1 WHERE GT1.GPV_TBJ_ID IN(
					SELECT GT.GPV_TBJ_ID FROM '||V_ESQUEMA||'.GPV_TBJ GT
					WHERE GT.GPV_TBJ_ID = 82441
					AND GT.BORRADO = 0)';
        EXECUTE IMMEDIATE V_SQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'... SE HAN BORRADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA_1||'... NO HAY REGISTROS QUE BORRAR');
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

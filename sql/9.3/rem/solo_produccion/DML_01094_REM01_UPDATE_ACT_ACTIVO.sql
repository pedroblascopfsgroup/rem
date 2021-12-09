--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10805
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(10 CHAR) := '#ESQUEMA_MASTER#';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_NUM_TABLAS NUMBER(16);
V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN 
 

	DBMS_OUTPUT.PUT_LINE('[INFO] DESBORRAR ACTIVO UVEM 8905126.');

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE BORRADO = 1 AND ACT_NUM_ACTIVO_UVEM = 8905126';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN
 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET
					BORRADO = 0, USUARIOBORRAR = NULL, FECHABORRAR = NULL
						WHERE BORRADO = 1 AND ACT_NUM_ACTIVO_UVEM = 8905126';
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] - ACTIVO UVEM 8905126 DESBORRADO.');
	
	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] - ACTIVO UVEM 8905126 NO ESTA BORRADO.');

	END IF;
  
  
  COMMIT;
  

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT;

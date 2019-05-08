--/*
--#########################################
--## AUTOR=Alberto Checa
--## FECHA_CREACION=20190507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6194
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: Insertar del usuario bgarcia al grupo de golden.tree
--## VERSIONES:
--##        	0.1 Versión inicial
--##		
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR);						-- Primer sentencia a ejecutar
	V_MSQL2 VARCHAR2(32000 CHAR);						-- Segunda sentencia a ejecutar
	V_NUM_TABLAS NUMBER(16);							-- Vble. para validar la existencia de una tabla.   
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';			-- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';	-- Configuracion Esquema Master
	ERR_NUM NUMBER(25); 								-- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR);						-- Vble. auxiliar para registrar errores en el script.

BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] Se empieza a insertar el Valor [INICIO]');
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS WHERE USU_ID_GRUPO = 75397 AND USU_ID_USUARIO = 76262';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	-- Si el usuario EXISTE en el grupo
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[FIN] El usuario ya existe en el grupo [FIN]');
	ELSE
		V_MSQL2 := 'INSERT INTO '|| V_ESQUEMA_M ||'.GRU_GRUPOS_USUARIOS (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
					VALUES ('||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL, 75397, 76262, 0, ''HREOS-6194'', SYSDATE, NULL, NULL, NULL, NULL, 0)';
		EXECUTE IMMEDIATE V_MSQL2;
	    DBMS_OUTPUT.PUT_LINE('[FIN] El valor ha sido insertado [FIN]');
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

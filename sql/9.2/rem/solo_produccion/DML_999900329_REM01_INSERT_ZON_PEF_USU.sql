--/*
--#########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20180919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1942
--## PRODUCTO=NO
--## 
--## Finalidad: añadir permisos al usuario SBACKOFFICEINMLIBER 
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
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1942';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN

	DBMS_OUTPUT.PUT_LINE('  [INICIO] Añadimos el perfil HAYASBOFIN al usuario SBACKOFFICEINMLIBER');


	V_SQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU SET
			    PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASBOFIN''),
			    USUARIOMODIFICAR = ''REMVIP-1942'',
			    FECHAMODIFICAR = SYSDATE
			    WHERE ZPU_ID = (SELECT ZPU_ID
					FROM '||V_ESQUEMA||'.ZON_PEF_USU ZPU, '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.USU_USUARIOS USU
					WHERE USU.USU_ID = ZPU.USU_ID AND PEF.PEF_ID = ZPU.PEF_ID AND USU.USU_USERNAME = 						''SBACKOFFICEINMLIBER'' AND PEF.PEF_DESCRIPCION = ''Super'')';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha updateado correctamente '||SQL%ROWCOUNT||' en la tabla ZON_PEF_USU');


   COMMIT;

EXCEPTION
    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;

END;
/
EXIT;

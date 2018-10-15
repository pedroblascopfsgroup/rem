--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180904
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1659
--## PRODUCTO=NO
--## 
--## Finalidad: añadir permisos al usuario pnevot 
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1659';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (
		    ZON_ID,
		    PEF_ID,
		    USU_ID,
		    ZPU_ID,
		    USUARIOCREAR,
		    FECHACREAR
		   )
		    SELECT 
			19504,
			PEF.PEF_ID,
			(SELECT USU2.USU_ID FROM REMMASTER.USU_USUARIOS USU2 WHERE USU2.USU_USERNAME = ''pnevot''),
			'||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL ,
			'''||V_USUARIO||''' AS USUARIOCREAR,
			SYSDATE
		    FROM
		    '||V_ESQUEMA_M||'.USU_USUARIOS USU
		    JOIN '||V_ESQUEMA||'.ZON_PEF_USU ZPU ON ZPU.USU_ID = USU.USU_ID
		    JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_ID = ZPU.PEF_ID
		    WHERE PEF.PEF_ID IN (215, 219) 
 		    AND USU.USU_USERNAME = ''tpg'' 
	            ';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] Se han insertado '||SQL%ROWCOUNT||' en la tabla ZON_PEF_USU');


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

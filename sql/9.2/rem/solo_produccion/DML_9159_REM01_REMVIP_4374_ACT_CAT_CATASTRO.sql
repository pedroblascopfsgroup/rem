--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190613
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-4374
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar datos diversos
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

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema	
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    	V_SQL VARCHAR2(4000 CHAR); -- Vble. sentencia a ejecutar.

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]'); 

	-------------------------------------------------------------------------------------------
	-- => CAT_REF_CATASTRAL

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de ACT_CAT_CATASTRO. CAT_REF_CATASTRAL '); 

	V_SQL :=
	       'UPDATE '||V_ESQUEMA||'.ACT_CAT_CATASTRO
		SET CAT_REF_CATASTRAL = ''N9726610X''
		WHERE ACT_ID = 364313
		AND CAT_ID = 418367' ;

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 


	DBMS_OUTPUT.PUT_LINE('[INFO] Creando nuevo registro en ACT_CAT_CATASTRO '); 

	V_SQL :=
	       'INSERT INTO '||V_ESQUEMA||'.ACT_CAT_CATASTRO
		( CAT_ID, ACT_ID, CAT_REF_CATASTRAL, CAT_SUPERFICIE_CONSTRUIDA, CAT_SUPERFICIE_UTIL, USUARIOCREAR, FECHACREAR, BORRADO )
		VALUES
		( S_ACT_CAT_CATASTRO.NEXTVAL, 364313, ''N9726615Y'', 263.8, 213, ''REMVIP-3788'', SYSDATE, 0 ) ' ;

	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros creados.'); 


	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;

/

EXIT

--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190801
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5001
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5001';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_VIV_VIVIENDA - Borrado lógico ');
										
	 V_SQL := ' INSERT INTO '||V_ESQUEMA||'.ACT_VIV_VIVIENDA
			( ICO_ID )
			SELECT ICO_ID
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
			'||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			WHERE 1 = 1
			AND ACT.ACT_ID = ICO.ACT_ID
			AND ACT_NUM_ACTIVO = ''7069203''
			AND NOT EXISTS ( SELECT 1
			                 FROM '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV
			                 WHERE VIV.ICO_ID = ICO.ICO_ID
	               )  ' ;


	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Creado '||SQL%ROWCOUNT||' registros en ACT_VIV_VIVIENDA ');  

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

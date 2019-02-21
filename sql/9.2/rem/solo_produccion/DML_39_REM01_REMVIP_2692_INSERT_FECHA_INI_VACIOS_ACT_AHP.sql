--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2692
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAR FECHA_INI A LOS REGISTROS DE LA TABLA ACT_AHP_HIST_PUBLICACION VACIAS
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
V_SQL VARCHAR2(10000 CHAR);
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AHP_HIST_PUBLICACION';
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	--VENTA
	DBMS_OUTPUT.PUT_LINE('[INSERT FECHA_INI A LOS DE VENTA]');

        V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
		AHP_FECHA_INI_VENTA = CAST(FECHACREAR AS DATE),
		USUARIOMODIFICAR = ''REMVIP_2692_VACIOS_VENTAS'',
		FECHAMODIFICAR = SYSDATE
			WHERE AHP_ID IN (SELECT AHP.AHP_ID
		                FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
		                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AHP.ACT_ID
		                JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
		                WHERE AHP_FECHA_INI_VENTA IS NULL 
		                AND AHP_FECHA_FIN_VENTA IS NULL 
		                AND AHP_FECHA_INI_ALQUILER IS NULL 
		                AND AHP_FECHA_FIN_ALQUILER IS NULL  
		                AND APU.DD_TCO_ID IN (1)
		                AND ACT.BORRADO = 0 
		                AND AHP.BORRADO = 0)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han ACTUALIZADO '||SQL%ROWCOUNT||' registros VENTA CON FECHA_INI');


	

	--ALQUILER
	DBMS_OUTPUT.PUT_LINE('[INSERT FECHA_INI A LOS DE ALQUILER]');

        V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
		AHP_FECHA_INI_ALQUILER = CAST(FECHACREAR AS DATE),
		USUARIOMODIFICAR = ''REMVIP_2692_VACIOS_ALQUILERES'',
		FECHAMODIFICAR = SYSDATE
			WHERE AHP_ID IN (SELECT AHP.AHP_ID 
		                FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
		                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AHP.ACT_ID
		                JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
		                WHERE AHP_FECHA_INI_VENTA IS NULL 
		                AND AHP_FECHA_FIN_VENTA IS NULL 
		                AND AHP_FECHA_INI_ALQUILER IS NULL 
		                AND AHP_FECHA_FIN_ALQUILER IS NULL  
		                AND APU.DD_TCO_ID IN (3,4)
		                AND ACT.BORRADO = 0 
		                AND AHP.BORRADO = 0)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han ACTUALIZADO '||SQL%ROWCOUNT||' registros ALQUILER CON FECHA_INI');


	--VENTA Y ALQUILER
	DBMS_OUTPUT.PUT_LINE('[INSERT FECHA_INI A LOS DE VENTA Y ALQUILER]');

        V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
		AHP_FECHA_INI_ALQUILER = CAST(FECHACREAR AS DATE),
		AHP_FECHA_INI_VENTA = CAST(FECHACREAR AS DATE),
		USUARIOMODIFICAR = ''REMVIP_2692_VACIOS_V_A'',
		FECHAMODIFICAR = SYSDATE
			WHERE AHP_ID IN (SELECT AHP.AHP_ID
		                FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
		                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AHP.ACT_ID
		                JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
		                WHERE AHP_FECHA_INI_VENTA IS NULL 
		                AND AHP_FECHA_FIN_VENTA IS NULL 
		                AND AHP_FECHA_INI_ALQUILER IS NULL 
		                AND AHP_FECHA_FIN_ALQUILER IS NULL  
		                AND APU.DD_TCO_ID IN (2)
		                AND ACT.BORRADO = 0 
		                AND AHP.BORRADO = 0)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han ACTUALIZADO '||SQL%ROWCOUNT||' registros VENTA Y ALQUILER CON FECHA_INI');


	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;

/

EXIT

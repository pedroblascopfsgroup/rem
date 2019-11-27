--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5857
--## PRODUCTO=NO
--## Finalidad: DML
--##      
--## INSTRUCCIONES:
--## VERSIONES:
--##
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
 
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

    DBMS_OUTPUT.put_line('[INICIO]');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL SET ICO_MEDIADOR_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 10007348)
				WHERE ICO_MEDIADOR_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 110097914)';
	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR SET PVE_ID_EMISOR = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 10007348)
				WHERE PVE_ID_EMISOR = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 110097914)';
	EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE(' [INFO] Se han actualizado '||SQL%ROWCOUNT||' proveedores');
		
	COMMIT;
    
    DBMS_OUTPUT.put_line('[FIN]');
 
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

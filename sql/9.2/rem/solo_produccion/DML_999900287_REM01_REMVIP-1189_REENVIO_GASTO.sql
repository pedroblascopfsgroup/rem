--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-11189
--## PRODUCTO=NO
--##
--## Finalidad: Reenviar gasto
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1189';
 
 BEGIN

 --Ponemos el estado del o de los gastos en Autorizado Administración

    V_SQL := '
    MERGE INTO REM01.GGE_GASTOS_GESTION T1
	USING (SELECT GPV.GPV_ID
    FROM REM01.GPV_GASTOS_PROVEEDOR GPV
    JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
    JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
    JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON EAP.DD_EAP_ID = GGE.DD_EAP_ID
    JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN (9620719)) T2
	ON (T1.GPV_ID = T2.GPV_ID)
	WHEN MATCHED THEN UPDATE SET
    T1.USUARIOMODIFICAR = ''REENVIO_EJECUCION_290618'', T1.FECHAMODIFICAR = SYSDATE
    , T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03'')
    , T1.GGE_FECHA_EAH = SYSDATE, T1.DD_EAP_ID = NULL, T1.GGE_FECHA_EAP = NULL
    , T1.GGE_FECHA_ENVIO_PRPTRIO = NULL
WHERE T1.DD_EAH_ID <> (SELECT DD_EAH_ID FROM REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03'')
    AND T1.DD_EAP_ID IS NOT NULL OR T1.GGE_FECHA_EAP IS NOT NULL OR T1.GGE_FECHA_ENVIO_PRPTRIO IS NOT NULL
    ';
     
    EXECUTE IMMEDIATE V_SQL;
    
        
    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registros en la GGE_GASTOS_GESTION');
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

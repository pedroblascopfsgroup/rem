--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181311
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-2673
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2673';

BEGIN



		V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE 
				  SET USUARIOMODIFICAR = ''REMVIP-2673''
					,FECHAMODIFICAR = SYSDATE
					,GEX_IMPORTE_CALCULO = 0 
					,GEX_IMPORTE_FINAL = 0
					WHERE GEX_ID IN 
			 (SELECT GEX.GEX_ID FROM '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX
				JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = GEX.ECO_ID 
				WHERE ECO.ECO_FECHA_ANULACION IS NULL 
				AND DD_ACC_ID = 5 
				AND ACT_ID IN (SELECT ACT.ACT_ID 
					      FROM '||V_ESQUEMA||'.ACT_ACTIVO  ACT 
					      WHERE ACT_NUM_ACTIVO IN (SELECT NUM_ACTIVO_HAYA FROM '||V_ESQUEMA||'.AUX_REMVIP_2673)))';
	
		EXECUTE IMMEDIATE V_MSQL;
				
		DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla GEX_GASTOS_EXPEDIENTE');

			    
    
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


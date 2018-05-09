--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-541
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar titulos
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
    
 BEGIN

	MERGE INTO REM01.ACT_TIT_TITULO TIT
	USING (
	  SELECT ACT.ACT_ID, TIT_FECHA_INSC_REG, ETI.DD_ETI_ID
	  FROM PFSREM.REMVIP_541_FECHA_TITULO REMVIP
	  INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = REMVIP.ACT_NUM_ACTIVO
	  INNER JOIN REM01.DD_ETI_ESTADO_TITULO ETI ON ETI.DD_ETI_CODIGO = '02'
	) AUX
	ON (TIT.ACT_ID = AUX.ACT_ID)
	WHEN MATCHED THEN UPDATE SET
	TIT.TIT_FECHA_INSC_REG = AUX.TIT_FECHA_INSC_REG,
	TIT.USUARIOMODIFICAR = 'REMVIP-541',
	TIT.FECHAMODIFICAR = SYSDATE,
	TIT.DD_ETI_ID = AUX.DD_ETI_ID;

    DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros correctamente');
    
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

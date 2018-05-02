--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-542
--## PRODUCTO=NO
--##
--## Finalidad: Anular oferta
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

	REM01.ANULACION_OFERTA_CAMBIO_SCM('REMVIP-542','90005554',NULL,NULL); 

    DBMS_OUTPUT.PUT_LINE('Se ha anulado la oferta correctamente');
    
    MERGE INTO REM01.OFR_OFERTAS OFR1
	USING (
		SELECT OFR.OFR_ID, EOF1.DD_EOF_ID
		FROM REM01.ACT_ACTIVO ACT 
		INNER JOIN REM01.ACT_OFR ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
		INNER JOIN REM01.OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
		INNER JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
		INNER JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF1 ON EOF1.DD_EOF_CODIGO = '04'
		WHERE ACT.ACT_NUM_ACTIVO = '5934506'
		AND EOF.DD_EOF_CODIGO = '03'
		) AUX
	ON (OFR1.OFR_ID = AUX.OFR_ID)
	WHEN MATCHED THEN UPDATE SET 
	OFR1.USUARIOMODIFICAR = 'REMVIP-542',
	OFR1.FECHAMODIFICAR = SYSDATE,
	OFR1.DD_EOF_ID = AUX.DD_EOF_ID;
	
	DBMS_OUTPUT.PUT_LINE('Se ha actualizado el estado a '||sql%rowcount||' ofertas correctamente');
    
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

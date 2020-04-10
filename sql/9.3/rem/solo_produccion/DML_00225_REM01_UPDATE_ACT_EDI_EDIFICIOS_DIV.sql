--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200410
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6931
--## PRODUCTO=NO
--##
--## Finalidad:
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
	V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-6922'; -- Incidencia Link
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI USING(
		SELECT EDI.EDI_ID, ICO.ICO_DESCRIPCION FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.ACT_EDI_eDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID
		WHERE ACT.USUARIOCREAR = ''MIG_DIVARIAN'') AUX ON (AUX.EDI_ID = EDI.EDI_ID)
		WHEN MATCHED THEN UPDATE SET
		EDI.EDI_DESCRIPCION = AUX.ICO_DESCRIPCION,
		EDI.USUARIOMODIFICAR = ''REMVIP-6931'',
		EDI.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.put_line('[INFO] Se han modificado '||SQL%ROWCOUNT||' descripcion de edificios de Divarian.');

    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO USING(
		SELECT ICO.ICO_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
		WHERE ACT.USUARIOCREAR = ''MIG_DIVARIAN'') AUX ON (AUX.ICO_ID = ICO.ICO_ID)
		WHEN MATCHED THEN UPDATE SET
		ICO.ICO_DESCRIPCION = NULL,
		ICO.USUARIOMODIFICAR = ''REMVIP-6931'',
		ICO.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.put_line('[INFO] Se han modificado '||SQL%ROWCOUNT||' informes comerciales de Divarian.');

COMMIT;
    
    DBMS_OUTPUT.put_line('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

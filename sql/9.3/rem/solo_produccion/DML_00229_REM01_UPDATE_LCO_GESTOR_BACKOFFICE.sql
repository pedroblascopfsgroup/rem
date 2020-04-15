--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=202004012
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6939
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
	V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-6939'; -- Incidencia Link
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_LCO_LOTE_COMERCIAL LCO USING (
		    SELECT DISTINCT AGR_ID
		    FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
		    WHERE USUARIOCREAR = ''REMVIP-6939''
		) TMP
		ON (LCO.AGR_ID = TMP.AGR_ID)
		WHEN MATCHED THEN UPDATE SET
		LCO.LCO_GESTOR_COMER_BACK_OFFICE = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grusbackoffman''),
		LCO.LCO_GESTOR_COMERCIAL = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''lcarrillo'')';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' agrupaciones de Divarian.');

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

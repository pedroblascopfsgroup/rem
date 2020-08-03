--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7831
--## PRODUCTO=NO
--## Finalidad: Script de limpiar campo SPS_OTRO si SPS_COMBO_OTRO es No.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar  
    
BEGIN
	 DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion ...');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion de registros de ACT_SPS_SIT_POSESORIA...');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA... Procedemos a actualizar');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS USING(
		SELECT SPS_ID FROM '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA 
		WHERE BORRADO = 0 AND SPS_OTRO IS NOT NULL AND SPS_COMBO_OTRO = 0
	) AUX ON (SPS.SPS_ID = AUX.SPS_ID)
		WHEN MATCHED THEN UPDATE SET
		SPS.SPS_COMBO_OTRO = 1,
		SPS.USUARIOMODIFICAR = ''REMVIP-7831'',
		SPS.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA... Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS USING(
		SELECT SPS_ID FROM '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA 
		WHERE BORRADO = 0 AND SPS_OTRO IS NULL AND SPS_COMBO_OTRO = 1
	) AUX ON (SPS.SPS_ID = AUX.SPS_ID)
		WHEN MATCHED THEN UPDATE SET
		SPS.SPS_COMBO_OTRO = 0,
		SPS.USUARIOMODIFICAR = ''REMVIP-7831'',
		SPS.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA... Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
    
	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización ha finalizado correctamente');
	
	COMMIT;    
    
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

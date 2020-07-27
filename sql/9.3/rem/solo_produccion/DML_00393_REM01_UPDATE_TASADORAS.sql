--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200629
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=REMVIP-7794
--## PRODUCTO=NO
--## Finalidad: Script de actualización de nombre de tasasdoras Divarian.
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_M#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar  
    
BEGIN
	 DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion de los nombres de tasadoras...');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion de registros de ACT_TAS_TASACION...');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_TAS_TASACION... Procedemos a actualizar');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TAS_TASACION TAS USING(
		SELECT DISTINCT TAS.TAS_ID, PVE.PVE_NOMBRE_COMERCIAL 
		FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
		JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_DOCIDENTIF = TAS.TAS_CIF_TASADOR
		WHERE TAS.USUARIOMODIFICAR = ''REMVIP-7794'' AND PVE.PVE_FECHA_BAJA IS NULL AND PVE.DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''02'')
	) AUX ON (TAS.TAS_ID = AUX.TAS_ID)
		WHEN MATCHED THEN UPDATE SET
		TAS.TAS_NOMBRE_TASADOR = AUX.PVE_NOMBRE_COMERCIAL,
		TAS.USUARIOMODIFICAR = ''REMVIP-7794'',
		TAS.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_TAS_TASACION... Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
    
	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de importes a finalizado correctamente');
	
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

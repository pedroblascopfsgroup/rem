--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200427
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7063
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. ACT_SOL_SOLADO.SOL_SOLADO_OTROS carga masiva
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	PL_OUTPUT VARCHAR2(32000 CHAR);

	V_COUNT NUMBER(25);
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar ACT_SOL_SOLADO > Solado (Otro) desde AUX_TIPO_SOLADO_REMVIP_7063.');

	execute immediate 'MERGE INTO '||V_ESQUEMA||'.ACT_SOL_SOLADO T1 USING (
	    SELECT DISTINCT
	    SOL.SOL_ID, AUX.TIPO_SOLADO
	    FROM '||V_ESQUEMA||'.AUX_TIPO_SOLADO_REMVIP_7063 AUX
	    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO 
	    INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID 
	    INNER JOIN '||V_ESQUEMA||'.ACT_SOL_SOLADO SOL ON SOL.ICO_ID = ICO.ICO_ID
	) T2
	ON (T1.SOL_ID = T2.SOL_ID)
	WHEN MATCHED THEN UPDATE SET
	T1.SOL_SOLADO_OTROS = T2.TIPO_SOLADO,
	T1.USUARIOMODIFICAR = ''REMVIP-7063'',
	T1.FECHAMODIFICAR = SYSDATE';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_SOL_SOLADO. Deberian ser 50.124.');  

	COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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

--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200422
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7089
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación alquileres
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge ACT_TCT_TRABAJO_CFGTARIFA.TCT_PRECIO_UNITARIO. Carga masiva.');

    
    execute immediate '
	MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA USING(
	SELECT PTA.ACT_PTA_ID, 
	CASE WHEN AUX.SUBROGADO = ''S'' THEN 1 WHEN AUX.SUBROGADO = ''N'' THEN 0 END AS SUBROGADO,
	CASE WHEN AUX.ESTADO_ADECUACION = ''S'' THEN ''01'' WHEN AUX.ESTADO_ADECUACION = ''N'' THEN ''02'' WHEN AUX.ESTADO_ADECUACION = ''N/A'' THEN ''03'' END AS ESTADO_ADECUACION 
	FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = PTA.ACT_ID
	JOIN '||V_ESQUEMA||'.AUX_REMVIP_7089 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND PTA.USUARIOCREAR = ''MIG_DIVARIAN''
	) AUX ON (AUX.ACT_PTA_ID = PTA.ACT_PTA_ID)
	WHEN MATCHED THEN UPDATE SET
	PTA.CHECK_SUBROGADO = AUX.SUBROGADO,
	PTA.DD_ADA_ID = (SELECT DD_ADA_ID FROM DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = AUX.ESTADO_ADECUACION),
	PTA.USUARIOMODIFICAR = ''REMVIP-7089'',
	PTA.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. (Deberian de ser 12.180)');


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

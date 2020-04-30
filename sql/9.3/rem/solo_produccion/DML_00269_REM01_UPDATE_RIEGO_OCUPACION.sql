--/*
--######################################### 
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200423
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7107
--## PRODUCTO=NO
--## 
--## Finalidad: marcar rieSgo ocupacion
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

	DBMS_OUTPUT.PUT_LINE('[INFO] MARCAR RIEGO OCUPACION');

        execute immediate '
	MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA T1 USING(
		SELECT ACT.ACT_ID FROM ACT_ACTIVO ACT
		INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_7107 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO 
		) T2 
	ON (T1.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN UPDATE SET
	T1.SPS_RIESGO_OCUPACION = 1,
	T1.USUARIOMODIFICAR = ''REMVIP-7107'',
	T1.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros');

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

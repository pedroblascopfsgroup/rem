--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-9419
--## PRODUCTO=NO
--## 
--## Finalidad: Posicionamiento de trabajos.
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge DD_EAL_ID estado alquiler.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_activo PAT USING (
        SELECT 
        ACT_PTA_ID,
        pat.act_id,
        CASE WHEN SPS.DD_TPA_ID = 1 AND SPS.SPS_OCUPADO = 1 THEN (SELECT DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = ''02'') --ALQUILADO
        ELSE (SELECT DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = ''01'') END AS DD_EAL_ID--LIBRE
        FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO pat
        INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = PAT.ACT_ID
        WHERE PAT.USUARIOCREAR = ''MIG_DIVARIAN''
        AND DD_EAL_ID IS NULL
        AND CHECK_HPM = 1
    ) TMP
    ON (TMP.ACT_PTA_ID = pat.ACT_PTA_ID)
    WHEN MATCHED THEN UPDATE SET
    PAT.DD_EAL_ID = TMP.DD_EAL_ID,
    PAT.USUARIOMODIFICAR = ''REMVIP-6919'',
    PAT.FECHAMODIFICAR = SYSDATE';
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[INFO] Mergeado.');

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

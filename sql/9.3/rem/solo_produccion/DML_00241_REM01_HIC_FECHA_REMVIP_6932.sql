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

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge HIC_FECHA del informe comercial.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST TAB USING (
        SELECT DISTINCT
        HIC_FECHA,
        HIC_ID, 
        ACT.ACT_ID ,
        ACT.ACT_NUM_ACTIVO,
        aia.ico_fecha_aceptacion
        FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HIC.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.mig_aia_infcomercial_act AIA ON AIA.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
        WHERE HIC.USUARIOCREAR = ''MIG_DIVARIAN''
        AND AIA.VALIDACION = 0
    ) TMP 
    ON (TMP.HIC_ID = TAB.HIC_ID)
    WHEN MATCHED THEN UPDATE SET
    TAB.HIC_FECHA = TMP.ICO_FECHA_ACEPTACION,
    TAB.USUARIOMODIFICAR = ''REMVIP-6932'',
    TAB.FECHAMODIFICAR = SYSDATE';
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

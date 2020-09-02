--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200821
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7971
--## PRODUCTO=NO
--## 
--## Finalidad: PONER DESCRIPCION COMO ESTABA EN ACT_ACTIVO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-7971';
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    -- Devolvemos los valores que tenia act_descripcion de act_activo
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1 
                USING (SELECT ACT_ID ,ACT_DESCRIPCION FROM '||V_ESQUEMA||'.TMP_REMVIP_7971) T2 
            ON (T1.ACT_ID = T2.ACT_ID)
            WHEN MATCHED THEN UPDATE 
            SET T1.ACT_DESCRIPCION = T2.ACT_DESCRIPCION,
            T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
            T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
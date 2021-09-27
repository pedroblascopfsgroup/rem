--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10481
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado logico de ACT_HFP
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10481'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo


    V_TABLA VARCHAR2(50 CHAR):= 'ACT_HFP_HIST_FASES_PUB'; --Vble. Tabla a modificar proveedores

	V_COUNT NUMBER(16); -- Vble. para comprobar
	

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS '||V_TABLA||'');

        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                    USING (
SELECT AUX.HFP_ID FROM (
SELECT ROW_NUMBER() OVER (PARTITION BY ACT.ACT_ID ORDER BY ACT.ACT_ID desc) AS RN,HFP.* FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
JOIN '||V_ESQUEMA||'.act_hfp_hist_fases_pub HFP ON HFP.ACT_ID=ACT.ACT_ID AND HFP.BORRADO = 0
WHERE ACT.ACT_NUM_ACTIVO IN (
6032325,
6040176,
6032334,
6040144,
6040168,
6040171,
6032330,
6040179,
6040167,
6032333,
6032329,
6032331,
6040142,
6040143,
6040170,
6028895,
6040173,
6028889,
6028891,
6040149,
6032327,
6040151,
6040147,
6040172,
6040175,
6136653,
6040146,
6040152,
6040174,
6028897,
6040177,
6028890,
6028894,
6032332,
6028896,
6028893,
6040166,
6028888,
6040148,
6028892,
6040150,
6040178,
6032335,
6040145,
6040169,
6032326,
6040153,
6032328,
6040165

) AND hfp.hfp_fecha_fin IS NULL ORDER BY ACT.ACt_ID
)AUX WHERE AUX.RN=2
                            ) T2 
                    ON (T1.HFP_ID = T2.HFP_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.HFP_FECHA_FIN = SYSDATE,
                    T1.USUARIOBORRAR = '''||V_USUARIO||''', 
                    T1.FECHABORRAR = SYSDATE,
                    T1.BORRADO = 1';

        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TABLA||' ');
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
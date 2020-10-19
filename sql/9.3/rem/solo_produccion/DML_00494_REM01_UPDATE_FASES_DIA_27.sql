--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7885
--## PRODUCTO=NO
--## 
--## Finalidad: CUADRAR HISTORICO FASES PUBLICACION DIA 27/06
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
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-7885_2';
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
        DBMS_OUTPUT.PUT_LINE('[BORRADO LOGICO DE ULTIMOS REGISTORS AÑADIDOS SIN FECHA FIN IGUALES A LOS CORRECTOS ]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB T1 
    	       USING(SELECT AUX.HFP_ID FROM REM01.AUX_REMVIP_7885_2 AUX
			INNER JOIN REM01.ACT_HFP_HIST_FASES_PUB HFP ON AUX.HFP_ID = HFP.HFP_ID
			WHERE AUX.HFP_TIPO = 2 AND ACT_ID NOT IN (SELECT ACT_ID FROM REM01.AUX_REMVIP_7885_2 AUX
			INNER JOIN REM01.ACT_HFP_HIST_FASES_PUB HFP ON AUX.HFP_ID = HFP.HFP_ID
			WHERE AUX.HFP_TIPO = 2 AND HFP.HFP_FECHA_FIN IS NOT NULL)) T2
                ON (T1.HFP_ID = T2.HFP_ID)
            WHEN MATCHED THEN UPDATE SET
	    T1.BORRADO = 1,		 		   		     
            T1.FECHABORRAR = SYSDATE,
            T1.USUARIOBORRAR = ''REMVIP_7885_21'' ';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');



    DBMS_OUTPUT.PUT_LINE('[BORRADO LOGICO REGISTORS AÑADIDOS ERRONEAMENTE EL DIA 27/06]');

       V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB T1 
    	       USING(SELECT AUX.HFP_ID FROM REM01.AUX_REMVIP_7885_2 AUX
			INNER JOIN REM01.ACT_HFP_HIST_FASES_PUB HFP ON AUX.HFP_ID = HFP.HFP_ID
			WHERE AUX.HFP_TIPO = 3 AND ACT_ID NOT IN (SELECT ACT_ID FROM REM01.AUX_REMVIP_7885_2 AUX
			INNER JOIN REM01.ACT_HFP_HIST_FASES_PUB HFP ON AUX.HFP_ID = HFP.HFP_ID
			WHERE AUX.HFP_TIPO = 2 AND HFP.HFP_FECHA_FIN IS NOT NULL)) T2
                ON (T1.HFP_ID = T2.HFP_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.BORRADO = 1,		 		   		     
            T1.FECHABORRAR = SYSDATE,
            T1.USUARIOBORRAR = ''REMVIP_7885_22'' ';
            
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');


    DBMS_OUTPUT.PUT_LINE('[ACTUALIZAMOS FECHA FIN A NULO EN LOS REGISTROS CORRECTOS]');

          V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB T1 
    	       USING(SELECT AUX.HFP_ID FROM REM01.AUX_REMVIP_7885_2 AUX
			INNER JOIN REM01.ACT_HFP_HIST_FASES_PUB HFP ON AUX.HFP_ID = HFP.HFP_ID
			WHERE AUX.HFP_TIPO = 1 AND ACT_ID NOT IN (SELECT ACT_ID FROM REM01.AUX_REMVIP_7885_2 AUX
			INNER JOIN REM01.ACT_HFP_HIST_FASES_PUB HFP ON AUX.HFP_ID = HFP.HFP_ID
			WHERE AUX.HFP_TIPO = 2 AND HFP.HFP_FECHA_FIN IS NOT NULL)) T2
                ON (T1.HFP_ID = T2.HFP_ID)
            WHEN MATCHED THEN UPDATE SET		 		   		     
            T1.HFP_FECHA_FIN = NULL,		   		     
            T1.FECHAMODIFICAR = SYSDATE,
            T1.USUARIOMODIFICAR = ''REMVIP_7885_23''';

 EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');

COMMIT;

 DBMS_OUTPUT.PUT_LINE('[FIN]' );

			 
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

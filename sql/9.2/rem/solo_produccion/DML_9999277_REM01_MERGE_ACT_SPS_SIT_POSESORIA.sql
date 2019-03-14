--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3503
--## PRODUCTO=NO
--##
--## Finalidad:	Informar la nueva columna DD_TPA_ID de la tabla ACT_SPS_SIT_POSESORIA según la antigua SPS_CON_TITULO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA T1
				USING (
				    SELECT ACT.ACT_ID, ACT_NUM_ACTIVO, CRA.DD_CRA_DESCRIPCION, DD_SIJ_DESCRIPCION, DD_SIJ_INDICA_POSESION
					,SPS_FECHA_REVISION_ESTADO, SPS_FECHA_TOMA_POSESION, SPS.SPS_OCUPADO, SPS.SPS_CON_TITULO, SPS.DD_TPA_ID,
				    CASE 
				        WHEN CRA.DD_CRA_CODIGO = ''03'' THEN
				            CASE 
				                WHEN SIJ.DD_SIJ_INDICA_POSESION = 1 THEN 
				                    CASE
				                        WHEN SPS_CON_TITULO = 1 THEN 1
				                        WHEN SPS_CON_TITULO = 0 THEN 2
				                    END
				                WHEN SIJ.DD_SIJ_INDICA_POSESION = 0 THEN
				                    CASE
				                        WHEN SPS_CON_TITULO = 1 THEN 1
				                        WHEN SPS_CON_TITULO = 0 THEN 3
				                    END
				            END
				        ELSE
				            CASE
				                WHEN (SPS_FECHA_REVISION_ESTADO IS NOT NULL OR SPS_FECHA_TOMA_POSESION IS NOT NULL) THEN
				                    CASE
				                        WHEN SPS_CON_TITULO = 1 THEN 1
				                        WHEN SPS_CON_TITULO = 0 THEN 2
				                    END
				                ELSE
				                    CASE
				                        WHEN SPS_CON_TITULO = 1 THEN 1
				                        WHEN SPS_CON_TITULO = 0 THEN 3
				                    END
				            END
				    END NUEVO_TPA_ID
				    FROM '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS
				    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = SPS.ACT_ID
				    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
				    LEFT JOIN '||V_ESQUEMA||'.DD_SIJ_SITUACION_JURIDICA SIJ ON SIJ.DD_SIJ_ID = SPS.DD_SIJ_ID
				    WHERE SPS_OCUPADO = 1 AND SPS_CON_TITULO IS NOT NULL AND SPS.DD_TPA_ID IS NULL
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET 
				    T1.DD_TPA_ID = T2.NUEVO_TPA_ID,
				    T1.USUARIOMODIFICAR = ''REMVIP-3503'',
				    T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('	[INFO]	'||SQL%ROWCOUNT||' filas actualizadas');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
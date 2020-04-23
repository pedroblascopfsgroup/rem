--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200423
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7106
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a dar de baja ACT_AGR_AGRUPACION > Agrupaciones Comerciales (Comercial-Venta) relacionadas con Ofertas Anuladas');

	execute immediate 'MERGE INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T1 USING (
						    SELECT
						    DISTINCT AGR.AGR_ID
						    FROM '||V_ESQUEMA||'.ofr_ofertas OFR
						    INNER JOIN '||V_ESQUEMA||'.act_ofr ON  ACT_OFR.OFR_ID = OFR.OFR_ID
						    INNER JOIN '||V_ESQUEMA||'.act_activo ACT ON ACT.ACT_ID = ACT_OFR.ACT_ID 
						    INNER JOIN '||V_ESQUEMA||'.act_agr_agrupacion AGR ON AGR.AGR_ID = OFR.AGR_ID
						    WHERE ACT.DD_SCR_ID IN (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.dd_scr_subcartera WHERE DD_SCR_CODIGO IN (''151'',''152''))--Subcarteras Divarian
						    AND OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.dd_eof_estados_oferta WHERE DD_EOF_CODIGO = ''02'')--Anuladas
						    AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.dd_tag_tipo_agrupacion WHERE DD_TAG_CODIGO = ''14'')--Comercial-Venta
    						AND AGR.AGR_FECHA_BAJA IS NULL
    						AND AGR.USUARIOCREAR IN (''MIG_DIVARIAN'',''REMVIP-6939'')
						) T2
						ON (T1.AGR_ID = T2.AGR_ID)
						WHEN MATCHED THEN UPDATE SET
						T1.AGR_FECHA_BAJA = SYSDATE,
						T1.USUARIOMODIFICAR = ''REMVIP-7106'',
						T1.FECHAMODIFICAR = SYSDATE';

						DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_AGR_AGRUPACION. Deberian ser 542 ');  

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

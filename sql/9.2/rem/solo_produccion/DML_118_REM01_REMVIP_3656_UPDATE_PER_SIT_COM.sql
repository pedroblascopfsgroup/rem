--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190405
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3656
--## PRODUCTO=NO
--##
--## Finalidad:	Despublicar los activos pasados en el item que están fuera del perímetro HAYA
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]: MERGE EN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
			   USING (

				        SELECT ACT.ACT_ID, PAC.PAC_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
					 ON PAC.ACT_ID = ACT.ACT_ID
					WHERE ACT.ACT_NUM_ACTIVO IN ( 
					6825527	,
					6872124	,
					6848228	,
					6874571	,
					6885505	,
					6875709	,
					6879618	,
					6875608	,
					6877216	,
					6883365	,
					6885025	,
					6848713	,
					6877198	,
					7072551	,
					6884793	,
					6874306	,
					6884802	,
					7073023	,
					7072334	,
					7071766	,
					6876123	,
					6850469	,
					6852646	,
					6880147	,
					7015142	,
					6883545	,
					6879750	,
					6882535	,
					6935622	,
					6879152	,
					7031570	,
					7068472	,
					6850578	,
					6877115	,
					6938618	,
					7031418	,
					6879749	,
					6878950	,
					6878465	,
					7012801	,
					6878464	,
					7030001	,
					6879751	,
					6875873	,
					6876134	,
					6879790	,
					6878949	,
					6872275	,
					6875036	,
					6934717	,
					6881448	,
					6885347	,
					6870739	,
					6850632	,
					6870729	,
					6881175	
					)
					AND PAC.PAC_INCLUIDO = 0
			   ) T2
			   ON (T1.PAC_ID = T2.PAC_ID)
			   WHEN MATCHED THEN UPDATE SET T1.PAC_CHECK_COMERCIALIZAR = 0
			   ,T1.PAC_CHECK_FORMALIZAR = 0
			   ,T1.PAC_CHECK_GESTIONAR = 0
			   ,T1.PAC_CHECK_PUBLICAR = 0
			   ,T1.USUARIOMODIFICAR = ''REMVIP-3658''
			   ,T1.FECHAMODIFICAR = SYSDATE
			   ';
DBMS_OUTPUT.PUT_LINE(  V_MSQL );

	EXECUTE IMMEDIATE V_MSQL;


	DBMS_OUTPUT.PUT_LINE('[INICIO]: MERGE EN '||V_ESQUEMA||'.ACT_ACTIVO ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
			   USING (

				        SELECT ACT.ACT_ID, PAC.PAC_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
					 ON PAC.ACT_ID = ACT.ACT_ID
					WHERE ACT.ACT_NUM_ACTIVO IN ( 
					6825527	,
					6872124	,
					6848228	,
					6874571	,
					6885505	,
					6875709	,
					6879618	,
					6875608	,
					6877216	,
					6883365	,
					6885025	,
					6848713	,
					6877198	,
					7072551	,
					6884793	,
					6874306	,
					6884802	,
					7073023	,
					7072334	,
					7071766	,
					6876123	,
					6850469	,
					6852646	,
					6880147	,
					7015142	,
					6883545	,
					6879750	,
					6882535	,
					6935622	,
					6879152	,
					7031570	,
					7068472	,
					6850578	,
					6877115	,
					6938618	,
					7031418	,
					6879749	,
					6878950	,
					6878465	,
					7012801	,
					6878464	,
					7030001	,
					6879751	,
					6875873	,
					6876134	,
					6879790	,
					6878949	,
					6872275	,
					6875036	,
					6934717	,
					6881448	,
					6885347	,
					6870739	,
					6850632	,
					6870729	,
					6881175	
					)
					AND PAC.PAC_INCLUIDO = 0
			   ) T2
			   ON (T1.ACT_ID = T2.ACT_ID)
			   WHEN MATCHED THEN UPDATE 
				SET DD_SCM_ID = ( SELECT DD_SCM_ID FROM DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''01'' )
			   ,T1.USUARIOMODIFICAR = ''REMVIP-3658''
			   ,T1.FECHAMODIFICAR = SYSDATE
			   ';
	EXECUTE IMMEDIATE V_MSQL;


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACTIVOS MODIFICADOS CORRECTAMENTE ');   

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



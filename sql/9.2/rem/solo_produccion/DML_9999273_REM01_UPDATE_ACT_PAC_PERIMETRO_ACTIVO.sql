--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3139
--## PRODUCTO=NO
--##
--## Finalidad:	Sacar del perímetro todos los activos FINANCIEROS que no estén en una agrupación asistida
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
				    SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				    JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON ACT.DD_TTA_ID = TTA.DD_TTA_ID
				    JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
				    WHERE TTA.DD_TTA_CODIGO IN (''03'', ''04'')
				    AND PAC.PAC_INCLUIDO = 1
				    AND NOT EXISTS (
				        SELECT ACT2.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT2
				        JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON ACT2.DD_TTA_ID = TTA.DD_TTA_ID
				        JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT2.ACT_ID
				        JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
				        JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
				        WHERE TTA.DD_TTA_CODIGO IN (''03'', ''04'')
				        AND TAG.DD_TAG_CODIGO = ''13''
				        AND ACT.ACT_ID = ACT2.ACT_ID
				    )
			   ) T2
			   ON (T1.ACT_ID = T2.ACT_ID)
			   WHEN MATCHED THEN UPDATE SET T1.PAC_INCLUIDO = 0
			   ,T1.PAC_CHECK_COMERCIALIZAR = 0
			   ,T1.PAC_CHECK_FORMALIZAR = 0
			   ,T1.PAC_CHECK_GESTIONAR = 0
			   ,T1.PAC_CHECK_PUBLICAR = 0
			   ,T1.USUARIOMODIFICAR = ''REMVIP-3139''
			   ,T1.FECHAMODIFICAR = SYSDATE
			   ';
	EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO ACTUALIZADA CORRECTAMENTE');   

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



--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3433
--## PRODUCTO=NO
--##
--## Finalidad: Actualización campo ACT_VENTA_EXTERNA_OBSERVACION
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
           
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- Updatear los valores en ACT_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_ACTIVO] ');
         
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: Modificamos el campo ACT_VENTA_EXTERNA_OBSERVACION');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT_VENTA_EXTERNA_OBSERVACION = ''CHELO: en periodo de transparencia hasta el 05/03. OCUPADO !!!'',
						USUARIOMODIFICAR = ''REMVIP-3433'',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT.ACT_NUM_ACTIVO_UVEM = 5235451
						';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVO ACTUALIZADO');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT_VENTA_EXTERNA_OBSERVACION = ''20/2 CHELO: en perido de transparencia hasta el 28/02 (nuria viviz) VPO '',
						USUARIOMODIFICAR = ''REMVIP-3433'',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT.ACT_NUM_ACTIVO_UVEM = 11049975
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVO ACTUALIZADO');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT_VENTA_EXTERNA_OBSERVACION = ''20/02 CHELO: en periodo de transparencia hasta el 27/02, Re: SOLICITUD FSV ACTIVO Nº 6059032. Buenos días, el valor actual de venta de activo solicitado es de 130.000€. Para cualquier duda estamos a tu disposición. He solic a FV informe fiscal'',
						USUARIOMODIFICAR = ''REMVIP-3433'',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT.ACT_NUM_ACTIVO_UVEM = 20281772
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVO ACTUALIZADO');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT_VENTA_EXTERNA_OBSERVACION = ''20/02 CHELO: en periodo de transparencia hasta el 28/02, por visitas pdtes. Vivienda dividida en 4 plantas con escalera interior de caracol. Humedades en el techo y ventanas con humedades; tarifa para cambiar. En la tercera planta con filtraciones.'',
						USUARIOMODIFICAR = ''REMVIP-3433'',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT.ACT_NUM_ACTIVO_UVEM = 29244942
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVO ACTUALIZADO');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT_VENTA_EXTERNA_OBSERVACION = ''26/02 CHELO: lmadridano Lucia Madridano Gutierrezañadió un comentario - 27/feb/19 11:37. Buenos días, El valor de mercado del activo es 74.000 €.'',
						USUARIOMODIFICAR = ''REMVIP-3433'',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT.ACT_NUM_ACTIVO_UVEM = 31215685
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVO ACTUALIZADO');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT_VENTA_EXTERNA_OBSERVACION = ''CHELO: El valor actual de venta de activo solicitado es de 170.000€ periodo de transparencia hasta el 28/02'',
						USUARIOMODIFICAR = ''REMVIP-3433'',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT.ACT_NUM_ACTIVO_UVEM = 32017617
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVO ACTUALIZADO');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADA CORRECTAMENTE');   

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



--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5795
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-5795'; -- Vble. para el usuario modificar.
    V_MSQL VARCHAR2(32000 CHAR); -- Vble. auxiliar para almacenar la sentencia a ejecutar.
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAMOS CARTERA Y SUBCARTERA ACTIVO .'); 

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''13''),
		DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''133''),
     		FECHAMODIFICAR = SYSDATE,
		USUARIOMODIFICAR = '''||V_USUARIO||''' 
		WHERE ACT_NUM_ACTIVO = 6951745';

	EXECUTE IMMEDIATE V_MSQL;

    	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAMOS PROPIETARIO ACTIVO .'); 

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO SET PRO_ID = 3179,
		DD_TGP_ID = (SELECT DD_TGP_ID FROM '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_CODIGO = ''01''),
		PAC_PORC_PROPIEDAD = 100,
     		FECHAMODIFICAR = SYSDATE,
		USUARIOMODIFICAR = '''||V_USUARIO||''' 
		WHERE ACT_ID =  (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 6951745)';

	EXECUTE IMMEDIATE V_MSQL;

    	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

    DBMS_OUTPUT.PUT_LINE('[FIN]');
    COMMIT;
 
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

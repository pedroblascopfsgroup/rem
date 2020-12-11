C--/*
--#########################################
--## AUTOR=Carles Molins Pascual
--## FECHA_CREACION=20201009
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8221
--## PRODUCTO=NO
--## 
--## Finalidad:
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-8221'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar fechas tasaciones incorrectas');	

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TAS_TASACION TAS 
                SET TAS.TAS_FECHA_INI_TASACION = NULL, 
                    TAS.USUARIOMODIFICAR = '''|| V_USU ||''', 
                    TAS.FECHAMODIFICAR = SYSDATE
                WHERE TAS.ACT_ID IN (
                    SELECT ACT_ID 
                    FROM '||V_ESQUEMA||'.ACT_ACTIVO
                    WHERE ACT_NUM_ACTIVO IN (
                        7231677,
                        7239159,
                        7240028,
                        7240026,
                        7240027,
                        7247015,
                        7248737,
                        7251762,
                        7252098,
                        7251929,
                        7252128,
                        7251803,
                        7251791,
                        7252085,
                        7253428,
                        7252379,
                        7254130,
                        7256886,
                        7256499,
                        7254126,
                        7257482,
                        7259970,
                        7259971,
                        7259972,
                        7256185,
                        7255950,
                        7256904,
                        7258139,
                        7257913,
                        7259915,
                        7260312,
                        7268588,
                        7271868,
                        7281577,
                        7277250,
                        7277205,
                        7278047,
                        7281573,
                        7281571,
                        7281575,
                        7281576,
                        7281578,
                        7281572,
                        7281574,
                        7283025
                    )
                )';
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('  [INFO] Se borran '||SQL%ROWCOUNT||' TAS_FECHA_INI_TASACION de ACT_TAS_TASACION');

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
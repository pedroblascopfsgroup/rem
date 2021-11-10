--/*
--#########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20211014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10576
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10576'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar fechas tasaciones incorrectas');	

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                SET OFR.DD_RDC_ID = 1, 
                    OFR.USUARIOMODIFICAR = '''|| V_USU ||''', 
                    OFR.FECHAMODIFICAR = SYSDATE
                WHERE OFR.DD_CAP_ID = 1';
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('  [INFO] Se actualizan '||SQL%ROWCOUNT||' DD_RDC_ID de OFR_OFERTAS');

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
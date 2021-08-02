--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9975
--## PRODUCTO=NO
--##
--## Finalidad: Modificar proveedor
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ITEM VARCHAR2(20) := 'REMVIP-9975';
	V_NUM NUMBER;

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR SET
			    PVE_AUTORIZACION_WEB = 1,
			    USUARIOMODIFICAR = '''||V_ITEM||''',
			    FECHAMODIFICAR = SYSDATE
				WHERE PVE_COD_REM = 2039';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO] PROVEEDOR ACTUALIZADO');

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
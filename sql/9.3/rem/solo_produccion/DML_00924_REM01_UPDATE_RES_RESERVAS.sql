--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10034
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
    V_USU VARCHAR2(20) := 'REMVIP-10034';
	V_NUM NUMBER;
    V_COUNT NUMBER(16); -- Vble. para comprobar

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE RES_NUM_RESERVA = 178197';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

    IF V_COUNT = 1 THEN
        
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS SET
                    RES_FECHA_VENCIMIENTO = TO_DATE(''23/07/2021'', ''DD-MM-YYYY''),
                    USUARIOMODIFICAR = '''||V_USU||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE RES_NUM_RESERVA = 178197';
        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] FECHA DE VENCIMIENTO DE RESERVA ACTUALIZADA');

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA RESERVA');

    END IF;

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
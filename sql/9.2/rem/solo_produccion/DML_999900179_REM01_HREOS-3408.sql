--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.9
--## INCIDENCIA_LINK=HREOS-3408
--## PRODUCTO=NO
--##
--## Finalidad: Script cambio estado gasto
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
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio cañonazo.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
        SET DD_EGA_ID = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''01'')
            , USUARIOMODIFICAR = ''HREOS-3408'', FECHAMODIFICAR = SYSDATE
        WHERE DD_EGA_ID = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03'')
            AND GPV_NUM_GASTO_HAYA = ''9416204''';
    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] Gasto 9416204 ha sido actualizado a ''Pendiente de autorizar''.');
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
            SET DD_EAH_ID = (SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''01'')
                , DD_EAP_ID = NULL, GGE_FECHA_EAH = NULL, GGE_FECHA_EAP = NULL, GGE_FECHA_ENVIO_PRPTRIO = NULL, USU_ID_EAH = NULL
                , USUARIOMODIFICAR = ''HREOS-3408'', FECHAMODIFICAR = SYSDATE
            WHERE DD_EAH_ID = (SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03'')
                AND GPV_ID = (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = ''9416204'')';
        EXECUTE IMMEDIATE V_MSQL;
        IF SQL%ROWCOUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO] Gestión del Gasto 9416204 ha sido actualizado a ''Pendiente de autorizar''.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] Gestión del Gasto 9416204 no existe o en estado distinto a ''Autorizado''.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] Gasto 9416204 no existente o en estado distinto a ''Autorizado por administración''.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    COMMIT;    

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
EXIT;
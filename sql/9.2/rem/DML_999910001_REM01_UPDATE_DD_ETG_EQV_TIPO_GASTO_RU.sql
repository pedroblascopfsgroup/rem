--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.10
--## INCIDENCIA_LINK=REMVIP-3028
--## PRODUCTO=NO
--##
--## Finalidad: Añadir el tipo de proveedor a ciertos registros que lo necesitan
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU';
    V_EXISTS NUMBER(1);
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Añadiendo tipos de proveedor.');

        
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' T1
                    SET T1.COSBAC_POS = 5
                    , T1.USUARIOMODIFICAR = ''REMVIP-3028'', T1.FECHAMODIFICAR = SYSDATE
                    WHERE T1.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = ''07'')
		    AND T1.COSBAC_POS = 2';
                 EXECUTE IMMEDIATE V_MSQL;

        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
	
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;          
END;
/
EXIT

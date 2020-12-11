--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8390
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar fecha decreto firme / no firme
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
    V_TABLA VARCHAR( 100 CHAR ) := 'BIE_ADJ_ADJUDICACION';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8390'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_BIE_ADJ_ID_1 NUMBER(25):= 285245;
    V_BIE_ADJ_ID_2 NUMBER(25):= 300403;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                BIE_ADJ_F_DECRETO_N_FIRME = TO_DATE(''31/12/1899'', ''DD/MM/YYYY''),
                BIE_ADJ_F_DECRETO_FIRME = TO_DATE(''31/12/1899'', ''DD/MM/YYYY''),
                BORRADO = 0, FECHABORRAR = NULL, USUARIOBORRAR = NULL, 
                USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
                WHERE BIE_ADJ_ID = '||V_BIE_ADJ_ID_1||'';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO CORRECTAMENTE BIE_ADJ_ID '||V_BIE_ADJ_ID_1||'');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                BIE_ADJ_F_DECRETO_N_FIRME = TO_DATE(''31/12/1899'', ''DD/MM/YYYY''),
                BORRADO = 0, FECHABORRAR = NULL, USUARIOBORRAR = NULL, 
                USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
                WHERE BIE_ADJ_ID = '||V_BIE_ADJ_ID_2||'';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO CORRECTAMENTE BIE_ADJ_ID '||V_BIE_ADJ_ID_2||'');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT

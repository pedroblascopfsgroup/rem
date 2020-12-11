--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8496
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar relación gasto/activo borrado
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8496'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_TEV_ID NUMBER(25):= 9297073;
    V_OFERTA NUMBER(25):= 90275045;
    V_ACTIVO NUMBER(25):= 7053453;
    V_CONTRATO VARCHAR2(30 CHAR) := '0515/0089';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR NUMERO CONTRARO PRINEX');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR VALOR EN TAREA');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR
                    SET TEV_VALOR = '''||V_CONTRATO||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE TEV_ID = '||V_TEV_ID||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADAS '||SQL%ROWCOUNT||' FILAS');  

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR VALOR EN DATOS BASICOS OFERTA DE EXPEDIENTE');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
                    SET OFR_CONTRATO_PRINEX = '''||V_CONTRATO||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADAS '||SQL%ROWCOUNT||' FILAS');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR VALOR EN CONTRATO DE ACTIVO');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.ACT_DCA_DATOS_CONTRATO_ALQ
                    SET DCA_ID_CONTRATO = ''0515-0089'',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACTIVO||' AND BORRADO = 0)
                    AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADAS '||SQL%ROWCOUNT||' FILAS');

    DBMS_OUTPUT.PUT_LINE('[FIN]');

    COMMIT;

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

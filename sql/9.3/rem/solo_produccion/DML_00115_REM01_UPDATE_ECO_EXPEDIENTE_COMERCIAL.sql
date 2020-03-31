--/*
--##########################################
--## AUTOR=Adrián Molina Garrido
--## FECHA_CREACION=20200326
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6745
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6745'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INFO] Se van a pasar a estado vendido ciertos expedientes.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET DD_EEC_ID = 8,
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ECO_NUM_EXPEDIENTE IN (SELECT ECO.ECO_NUM_EXPEDIENTE FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                 join REM01.OFR_OFERTAS OFR on ECO.OFR_ID = OFR.OFR_ID
                                                 join REM01.ACT_OFR AFR on OFR.OFR_ID = AFR.OFR_ID
                                                 join REM01.ACT_ACTIVO ACT on AFR.ACT_ID = ACT.ACT_ID
                                                 where ECO.DD_EEC_ID = 3
                                                 and ECO.ECO_FECHA_CONT_VENTA is not null
                                                 and ACT.DD_SCR_ID in (23,
                                                 163,
                                                 164,
                                                 165,
                                                 166,
                                                 167,
                                                 263,
                                                 283,
                                                 323))';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] Cambio de estado efectuado correctamente.');

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

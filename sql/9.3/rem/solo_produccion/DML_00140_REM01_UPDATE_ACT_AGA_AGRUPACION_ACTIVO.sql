--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7878
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

    V_TABLA VARCHAR2(30 CHAR) := 'ACT_AGA_AGRUPACION_ACTIVO';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7917'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a borrar una relacion.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET BORRADO = 1,
                    USUARIOBORRAR = '''|| V_USR ||''',
                    FECHABORRAR = SYSDATE
                    WHERE AGA_ID IN (384419,
                                     384420,
                                     384421,
                                     384436,
                                     384439,
                                     384459,
                                     384461,
                                     384465,
                                     384483,
                                     384486,
                                     384745,
                                     384794,
                                     384899,
                                     384975)';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] Relacion borrada correctamente.');

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
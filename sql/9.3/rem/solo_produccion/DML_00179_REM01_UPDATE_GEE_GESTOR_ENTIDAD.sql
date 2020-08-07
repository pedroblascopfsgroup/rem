--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200804
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7916
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

    V_TABLA VARCHAR2(30 CHAR) := 'GEE_GESTOR_ENTIDAD';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7608'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a inserta el usuario en la tabla GEE.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET USU_ID = 47974,
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE GEE_ID IN (11446043,
                                     11446047,
                                     11446052,
                                     11446054,
                                     11446055,
                                     11446058,
                                     11446065,
                                     11445760,
                                     11445768,
                                     11445787,
                                     11445790,
                                     11445803,
                                     11445804,
                                     11445805,
                                     11445808,
                                     11445816,
                                     11445819,
                                     11445823,
                                     11445825,
                                     11445827,
                                     11445830,
                                     11445833,
                                     11445840,
                                     11445843,
                                     11445848,
                                     11445852,
                                     11445859,
                                     11445864,
                                     11445866,
                                     11445871,
                                     11445877,
                                     11445907,
                                     11445923,
                                     11445932,
                                     11445937,
                                     11445949,
                                     11445950,
                                     11445955,
                                     11445963,
                                     11445983,
                                     11445984,
                                     11445990,
                                     11445994,
                                     11445995,
                                     11445999,
                                     11446001,
                                     11446002,
                                     11446008,
                                     11446027)';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] Usuario insertado correctamente.');

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
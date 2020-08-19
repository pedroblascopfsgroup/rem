--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200805
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7793
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

    V_TABLA VARCHAR2(30 CHAR) := 'GPV_GASTOS_PROVEEDOR';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7793'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Se anulan gastos.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET USUARIOMODIFICAR = ''REMVIP-7793'', 
			FECHAMODIFICAR = SYSDATE, 
			DD_EGA_ID = 6 
			WHERE GPV_ID IN (
			    SELECT GPV.GPV_ID
			    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
			    INNER JOIN '||V_ESQUEMA||'.GPV_ACT GPVA ON GPV.GPV_ID = GPVA.GPV_ID
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GPVA.ACT_ID = ACT.ACT_ID 
			    INNER JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON GPV.PRO_ID = PRO.PRO_ID AND PRO.BORRADO = 1 
			    WHERE GPV.BORRADO = 0 
			    AND ACT.BORRADO = 0
			    )';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');

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

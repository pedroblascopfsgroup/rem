--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20210607
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-9878
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

    V_TABLA VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9880'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INFO] Se van a insertar datos en la tabla ACT_PRY_PROYECTO.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET PVC_ID = (SELECT PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO WHERE PVE_ID = 18904 AND PVC_PRINCIPAL = 1)
                    WHERE PVC_ID = 1895 AND DD_EST_ID IN (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO IN (''13'', ''CUR'', ''PCI''))';

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
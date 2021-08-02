--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14546
--## PRODUCTO=NO
--##
--## Finalidad: Script cambia estado de trabajos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'PROC_GEN_GASTOS_AALBARANES'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN		

    DBMS_OUTPUT.PUT_LINE('[INICIO] SCRIPT PARA MODIFICAR TRABAJOS.');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 USING (
           SELECT DISTINCT TBJ.TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
            JOIN '||V_ESQUEMA||'.GLD_TBJ GBJ ON TBJ.TBJ_ID = GBJ.TBJ_ID
            JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GBJ.GLD_ID = GLD.GLD_ID
            JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GLD.GPV_ID = GPV.GPV_ID
            WHERE GPV.USUARIOCREAR = ''PROC_GEN_GASTOS_ALBARANES'' AND TBJ.DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO = ''13'')) T2
        ON (T1.TBJ_ID = T2.TBJ_ID)
        WHEN MATCHED THEN UPDATE SET
        T1.DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO = ''PCI''),
        T1.USUARIOMODIFICAR = '''||V_USU||''',
        T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' ESTADOS DE TRABAJOS.');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


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

EXIT
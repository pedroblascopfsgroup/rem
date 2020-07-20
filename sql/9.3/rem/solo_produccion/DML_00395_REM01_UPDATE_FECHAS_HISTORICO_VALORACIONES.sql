--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200717
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7799
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

    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7799'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR FECHAS HISTORICO VALORACIONES');

	V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_HVA_HIST_VALORACIONES T1 USING 
			    (SELECT AUX.ACT_ID, AUX.HVA_ID, AUX.HVA_FECHA_CARGA, AUX.HVA_FECHA_INICIO 
			     FROM '||V_ESQUEMA||'.AUX_REMVIP_7799 AUX
			     INNER JOIN '||V_ESQUEMA||'.ACT_HVA_HIST_VALORACIONES HVA ON  AUX.HVA_ID = HVA.HVA_ID) 
			     T2
			ON (T1.HVA_ID = T2.HVA_ID AND T1.ACT_ID = T2.ACT_ID)
			WHEN MATCHED THEN UPDATE SET T1.USUARIOMODIFICAR = ''REMVIP-7799'',
			T1.FECHAMODIFICAR = SYSDATE, 
			T1.HVA_FECHA_CARGA = TO_DATE(T2.HVA_FECHA_CARGA,''DD/MM/YYYY''), 
			T1.HVA_FECHA_INICIO = TO_DATE(T2.HVA_FECHA_INICIO,''DD/MM/YYYY'')';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros '); 

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

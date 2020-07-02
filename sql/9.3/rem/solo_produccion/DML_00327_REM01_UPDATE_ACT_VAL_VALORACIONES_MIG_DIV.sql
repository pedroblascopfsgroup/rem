--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7265
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7265'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR FECHAS VALORACIONES MIGRADAS DIVARIAN');

	V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES T1 USING
			(
			SELECT VAL_ID, VAL_FECHA_APROBACION FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES WHERE USUARIOCREAR = ''MIG_DIVARIAN'' 
			AND VAL_FECHA_APROBACION < TO_DATE (''08/04/2020'',''DD/MM/YYYY'') 
			AND TRUNC(VAL_FECHA_CARGA) = TRUNC(TO_DATE (''08/04/2020'',''DD/MM/YYYY''))
			)T2 
			ON (T1.VAL_ID = T2.VAL_ID)
			WHEN MATCHED THEN UPDATE 
			SET T1.VAL_FECHA_CARGA = T2.VAL_FECHA_APROBACION,
			T1.USUARIOMODIFICAR = ''REMVIP-7265'',
			T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros '); 

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR VAL_FECHA_APROBACION MIGRADAS DIVARIAN A NULL');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.ACT_VAL_VALORACIONES SET 
			VAL_FECHA_APROBACION = NULL 
			WHERE USUARIOMODIFICAR = ''REMVIP-7265'' 
			AND USUARIOCREAR = ''MIG_DIVARIAN''';

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

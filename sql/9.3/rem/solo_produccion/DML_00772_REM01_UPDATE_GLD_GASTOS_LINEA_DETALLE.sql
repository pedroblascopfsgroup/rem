--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9267
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica CUENTA Y PARTIDA del gasto
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'GLD_GASTOS_LINEA_DETALLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9267'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
					SELECT GLD.GLD_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
					JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA||' GLD ON GLD.GPV_ID = GPV.GPV_ID AND GLD.BORRADO = 0
					WHERE GPV.BORRADO = 0 AND GPV.GPV_NUM_GASTO_HAYA = 13650820) T2
				ON (T1.GLD_ID = T2.GLD_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.GLD_PRINCIPAL_SUJETO = ''1179,70'',
				T1.USUARIOMODIFICAR = '''||V_USU||''',
				T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS IMPORTE EN GASTO 13650820');

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
--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210730
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10247
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10247'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_GPV_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('13650818')


		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1 USING (
					SELECT GLD.GLD_ID,BASE_SUJETA FROM(
                        SELECT GLD.GLD_ID,SUM(TBJ.TBJ_IMPORTE_PRESUPUESTO) AS BASE_SUJETA FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID
                        JOIN '||V_ESQUEMA||'.GLD_TBJ GLTJ ON GLTJ.GLD_ID=GLD.GLD_ID
                        JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID=GLTJ.TBJ_ID
                        WHERE GPV.GPV_NUM_GASTO_HAYA='||V_TMP_TIPO_DATA(1)||' 
                        GROUP BY (GLD.GLD_ID)
                    )AUX
                    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID=AUX.GLD_ID
                    WHERE GLD.GLD_PRINCIPAL_SUJETO!=AUX.BASE_SUJETA
                    ) T2
				ON (T1.GLD_ID = T2.GLD_ID)
				WHEN MATCHED THEN UPDATE SET
				GLD_PRINCIPAL_SUJETO = T2.BASE_SUJETA,
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE';
	            EXECUTE IMMEDIATE V_MSQL;

			    DBMS_OUTPUT.PUT_LINE('[INFO] GASTO '||V_TMP_TIPO_DATA(1)||' ACTUALIZADO');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO '||V_TMP_TIPO_DATA(1)||'');

		END IF;

	END LOOP;

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
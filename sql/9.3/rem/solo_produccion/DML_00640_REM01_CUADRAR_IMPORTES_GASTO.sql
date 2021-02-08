--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8784
--## PRODUCTO=NO
--## 
--## Finalidad: Cuadrar importes gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8784';

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_TABLA VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR';
    V_TABLA_GDE VARCHAR2(100 CHAR):='GDE_GASTOS_DETALLE_ECONOMICO';

	V_COUNT NUMBER(16); -- Vble. para comprobar

    V_IMPORTE_TOTAL NUMBER(16);
    

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: CUADRAR IMPORTES GASTOS EN '||V_TABLA_GDE||'');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_GDE||' T1
                USING(
                    SELECT GDE2.GDE_ID,T2.IMPORTE_TOTAL FROM (

                        SELECT GPV.GPV_ID,GDE.GDE_ID,GPV.GPV_NUM_GASTO_HAYA,GDE.GDE_RET_GAR_BASE-GDE.GDE_RET_GAR_CUOTA AS IMPORTE_TOTAL 
                        FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_GDE||' GDE ON GDE.GPV_ID=GPV.GPV_ID
                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID
                        WHERE GPV.BORRADO=0 AND GDE.BORRADO=0 AND GLD.BORRADO=0 
                        AND GLD.GLD_IMP_IND_EXENTO=1 AND GDE.GDE_RET_GAR_APLICA=1 
                        AND GDE.GDE_RET_GAR_BASE IS NOT NULL AND GDE.GDE_RET_GAR_CUOTA IS NOT NULL

                    ) T2
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_GDE||' GDE2 ON GDE2.GDE_ID=T2.GDE_ID
                    WHERE GDE2.GDE_IMPORTE_TOTAL!=T2.IMPORTE_TOTAL AND T2.IMPORTE_TOTAL !=0

                ) AUX
                ON (T1.GDE_ID = AUX.GDE_ID)
                WHEN MATCHED THEN UPDATE SET                
                T1.GDE_IMPORTE_TOTAL = AUX.IMPORTE_TOTAL,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                T1.FECHAMODIFICAR = SYSDATE
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' GASTOS ');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
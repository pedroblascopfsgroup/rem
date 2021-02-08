--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8708
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para consulta que valida la existencia de una tabla.
  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'GLD_ENT';  -- Tabla a modificar
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8708'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INFO] PARTICIPACIONES INCORRECTAS');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GLD_ENT T1
        USING (
            SELECT AUX.GLD_ENT_ID, SUM(AUX.PARTICIPACION_CLI) PARTICIPACION_CLI
            FROM '||V_ESQUEMA||'.V_REPARTO_IMP_TBJ AUX
            WHERE EXISTS (
                    SELECT GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA, GEN.GLD_ID, COUNT(1) 
                    FROM REM01.GLD_GASTOS_LINEA_DETALLE GLD 
                    INNER JOIN REM01.GLD_TBJ GTBJ ON GTBJ.GLD_ID = GLD.GLD_ID 
                        AND GTBJ.BORRADO = 0
                    INNER JOIN REM01.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GLD.GPV_ID 
                        AND GPV.BORRADO = 0
                    INNER JOIN REM01.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                        AND GEN.BORRADO = 0
                    WHERE GLD.USUARIOCREAR = ''HREOS-10574''
                        AND GLD.BORRADO = 0
                        AND GPV.DD_EGA_ID IN (1,2,8,10,12)
                        AND GPV.GPV_ID = AUX.GPV_ID
                    GROUP BY GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA, GEN.GLD_ID
                    HAVING SUM(GEN.GLD_PARTICIPACION_GASTO) <> 100
                )
            GROUP BY AUX.GLD_ENT_ID
        ) T2
        ON (T1.GLD_ENT_ID = T2.GLD_ENT_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GLD_PARTICIPACION_GASTO = T2.PARTICIPACION_CLI';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONADOS '||SQL%ROWCOUNT||' REGISTROS');
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] ');
  
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
--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8787
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8768';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA_GIL VARCHAR2(100 CHAR):='GIL_GASTOS_IMPORTES_LIBERBANK';
    V_TABLA_GDL VARCHAR2(100 CHAR):='GDL_GASTOS_DIARIOS_LIBERBANK';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_GDL||'');

        --#INSERTAMOS EN TABLA GDE_GASTOS_DIARIOS_LIBERBANK

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GDL||' (GDL_ID, GPV_ID, DIARIO1, DIARIO1_BASE, DIARIO1_TIPO, DIARIO1_CUOTA, USUARIOCREAR, FECHACREAR)
                    SELECT '||V_ESQUEMA||'.S_'||V_TABLA_GDL||'.NEXTVAL
                        , GPV.GPV_ID
                        , ''60''
                        , GLD.GLD_IMPORTE_TOTAL
                        , 0
                        , 0
                        , ''gestoria_gastos_gr''
                        , GLD.FECHACREAR
                    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                        AND GLD.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                        AND PRO.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                        AND CRA.BORRADO = 0
                    WHERE GPV.DD_GRF_ID IS NOT NULL
                        AND GPV.GPV_NUM_GASTO_GESTORIA IS NOT NULL
                        AND GPV.PVE_ID_GESTORIA IS NOT NULL
                        AND GPV.FECHACREAR > TO_DATE(''15012021'',''DDMMYYYY'')
                        AND CRA.DD_CRA_CODIGO = ''08''
                        AND NOT EXISTS (
                            SELECT 1
                            FROM '||V_ESQUEMA||'.'||V_TABLA_GDL||' GDL
                            WHERE GDL.GPV_ID = GPV.GPV_ID)';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_GIL||'');
 
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE EN '||V_TABLA_GDL||': '||sql%rowcount ||'');


        --INSERTAMOS EN TABLA GIL_GASTOS_IMPORTES_LIBERBANK
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GIL||' (GIL_ID, GPV_ID, ENT_ID, DD_ENT_ID, IMPORTE_ACTIVO, USUARIOCREAR, FECHACREAR)
                    SELECT '||V_ESQUEMA||'.S_'||V_TABLA_GIL||'.NEXTVAL
                        , GPV.GPV_ID
                        , GEN.ENT_ID
                        , GEN.DD_ENT_ID
                        , GEN.GLD_PARTICIPACION_GASTO / 100 * GLD.GLD_IMPORTE_TOTAL
                        , ''gestoria_gastos_gr''
                        , GEN.FECHACREAR
                    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                        AND GLD.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                        AND GEN.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                        AND PRO.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                        AND CRA.BORRADO = 0
                    WHERE GPV.BORRADO = 0
                        AND GPV.GPV_NUM_GASTO_GESTORIA IS NOT NULL
                        AND GPV.PVE_ID_GESTORIA IS NOT NULL
                        AND GPV.FECHACREAR > TO_DATE(''15012021'',''DDMMYYYY'')
                        AND CRA.DD_CRA_CODIGO = ''08''
                        AND NOT EXISTS (
                            SELECT 1
                            FROM '||V_ESQUEMA||'.'||V_TABLA_GIL||' GIL
                            WHERE GIL.GPV_ID = GPV.GPV_ID
                                AND GIL.ENT_ID = GEN.ENT_ID
                                AND GIL.DD_ENT_ID = GEN.DD_ENT_ID)';


        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE EN '||V_TABLA_GIL||': '||sql%rowcount ||'');

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
--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16383
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionar la tabla HIST_ENVIO_PEDIDOS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'HIST_ENVIO_PEDIDOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-16383';
    V_NUM_FILAS NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
      
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                     HIST_ID
                    ,GPV_ID
                    ,FECHA_ENVIO_PRPTRIO
                    ,USUARIOCREAR
                    ,FECHACREAR
                ) 
                SELECT
                    S_'||V_TEXT_TABLA||'.NEXTVAL
                    ,GPV.GPV_ID GPV_ID
                    ,GGE.GGE_FECHA_ENVIO_PRPTRIO FECHA_ENVIO_PRPTRIO
                    ,''HREOS-16383''
                    ,SYSDATE
                FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID=GPV.PVE_ID_EMISOR
                    AND PVE.BORRADO=0    
                JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID=GPV.DD_TGA_ID AND TGA.DD_TGA_CODIGO IN (''05'',''07'')
                    AND TGA.BORRADO=0 
                JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID
                    AND GLD.BORRADO=0
                JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID=GLD.DD_STG_ID
                    AND STG.BORRADO=0
                JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID=GPV.GPV_ID
                    AND GDE.BORRADO=0
                LEFT JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_ID=GLD.DD_TIT_ID
                    AND TIT.BORRADO=0
                JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID 
                        AND GGE.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                    AND EGA.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH ON DD_EAH.DD_EAH_ID = GGE.DD_EAH_ID
                    AND DD_EAH.BORRADO = 0  
                JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                        AND PRO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                    AND CRA.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GLD_ENT GLDENT ON GLDENT.GLD_ID=GLD.GLD_ID
                    AND GLDENT.BORRADO=0
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GLDENT.ENT_ID
                    AND ACT.BORRADO=0
                JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID=SCM.DD_SCM_ID
                    AND SCM.BORRADO=0
                WHERE GPV.BORRADO=0
                    AND DD_EAH.DD_EAH_CODIGO = ''03'' 
                    AND CRA.DD_CRA_CODIGO = ''03'' 
                    AND EGA.DD_EGA_CODIGO = ''03'' 
                    AND (GDE.GDE_IMPORTE_TOTAL IS NOT NULL AND GDE.GDE_IMPORTE_TOTAL<> 0)
                    AND GGE.GGE_FECHA_ENVIO_PRPTRIO IS NOT NULL
                    AND GPV.DD_GRF_ID IS NOT NULL
                    AND NOT EXISTS(SELECT 1
                                    FROM '||V_ESQUEMA||'.HIST_ENVIO_PEDIDOS HIST
                                    WHERE GPV.GPV_ID=HIST.GPV_ID 
                                    AND HIST.BORRADO=0
                                )
                    AND ( 
                        EXISTS (
                            SELECT 1
                            FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PROP 
                            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC2 ON GIC2.GPV_ID = GPV.GPV_ID 
                                AND GIC2.BORRADO = 0
                            WHERE PROP.BORRADO = 0
                            AND PROP.PRO_ID = GPV.PRO_ID 
                            AND PROP.PRO_DOCIDENTIF=''A58032244'' and PROP.PRO_SOCIEDAD_PAGADORA=''0015''
                                AND NVL(GIC2.GIC_FECHA_DEVENGO_ESPECIAL,TO_DATE(''01/01/2100'')) < TO_DATE(''12/11/21'')
                        )
                        OR 
                        EXISTS (
                                SELECT 1
                                FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PROP 
                                JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC2 ON GIC2.GPV_ID = GPV.GPV_ID 
                                    AND GIC2.BORRADO = 0
                                join '||V_ESQUEMA||'.dd_cra_cartera cra on cra.dd_cra_id=prop.dd_cra_id and
                                    cra.borrado=0
                                WHERE PROP.BORRADO = 0
                                AND PROP.PRO_ID = GPV.PRO_ID 
                                AND PROP.PRO_DOCIDENTIF=''A08663619'' and PROP.PRO_SOCIEDAD_PAGADORA=''0001''
                        )
                    )';

    EXECUTE IMMEDIATE V_MSQL;
    V_NUM_FILAS := sql%rowcount;

	DBMS_OUTPUT.put_line('[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN '||V_TEXT_TABLA||'  [INFO]');
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

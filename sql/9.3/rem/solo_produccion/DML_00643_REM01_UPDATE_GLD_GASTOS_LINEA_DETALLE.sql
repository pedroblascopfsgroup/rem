--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210128
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8803
--## PRODUCTO=NO
--##
--## Finalidad: INFORMAR CCC Y CPP EN GASTOS
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
  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'GLD_GASTOS_LINEA_DETALLE';  -- Tabla a modificar
    V_TABLA_AUX VARCHAR2(30 CHAR) := 'AUX_REMVIP_8803'; 
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8803'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en GIC_GASTOS_INFO_CONTABILIDAD - CPS_ID A NULL');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1 USING (
                SELECT GIC.GIC_ID FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID
                INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
            ) T2
            ON (T1.GIC_ID = T2.GIC_ID)
            WHEN MATCHED THEN UPDATE SET
            CPS_ID = NULL,
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] RECTIFICACION '||SQL%ROWCOUNT||' REGISTROS');

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en '||V_TABLA||'');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING (
                SELECT GLD.GLD_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' GLD
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GLD.GPV_ID
                INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
            ) T2
            ON (T1.GLD_ID = T2.GLD_ID)
            WHEN MATCHED THEN UPDATE SET
            GLD_CCC_BASE = ''6222000'',
            GLD_CPP_BASE = ''PP011'',
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' REGISTROS');
    
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
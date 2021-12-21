--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16632
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(25 CHAR):= 'HREOS-16632';

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS GEE_GESTOR_ENTIDAD ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1 USING (
            SELECT 
            PVE.PVE_ID
            , ''BK'' || PVE_COD_API_PROVEEDOR PVE_COD_API_PROVEEDOR
            FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
            JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
            WHERE PVE.BORRADO = 0
            AND TPR.DD_TPR_CODIGO = ''28''
            AND PVE_COD_API_PROVEEDOR IS NOT NULL) T2
            ON (T1.PVE_ID = T2.PVE_ID)
            WHEN MATCHED THEN UPDATE SET
              T1.PVE_COD_API_PROVEEDOR = T2.PVE_COD_API_PROVEEDOR,
              USUARIOMODIFICAR = '''||V_USU||''',
              FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_PVE_PROVEEDOR PARA CAMBIAR EL PVE_COD_API_PROVEEDOR');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1 USING (
              SELECT 
              PVE.PVE_ID
              FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
              JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
              WHERE TPR.DD_TPR_CODIGO = ''28''
              AND PVE_COD_API_PROVEEDOR IS NOT NULL
              AND (PVE.PVE_FECHA_BAJA IS NULL OR PVE.DD_EPR_ID <> (SELECT DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR WHERE DD_EPR_CODIGO = ''07''))
              AND NOT EXISTS (SELECT 1
              FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
              JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID AND EEC.BORRADO = 0
              JOIN '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX ON ECO.ECO_ID = GEX.ECO_ID AND GEX.BORRADO = 0
              WHERE ECO.BORRADO = 0 
              AND EEC.DD_EEC_CODIGO <> ''08''
              AND GEX.GEX_PROVEEDOR = PVE.PVE_ID)) T2
            ON (T1.PVE_ID = T2.PVE_ID)
            WHEN MATCHED THEN UPDATE SET
              T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR WHERE DD_EPR_CODIGO = ''07''),
              T1.PVE_FECHA_BAJA = SYSDATE,
              USUARIOMODIFICAR = '''||V_USU||''',
              FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_PVE_PROVEEDOR PARA DAR DE BAJA COMO PROVEEDOR');

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
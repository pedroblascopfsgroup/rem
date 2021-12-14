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

    V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR ETP
                (ETP_ID
                , DD_CRA_ID
                , PVE_ID
                , DD_TCL_ID
                , ETP_FECHA_INICIO
                , VERSION
                , USUARIOCREAR
                , FECHACREAR
                , BORRADO)
            SELECT
                '||V_ESQUEMA||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL ETP_ID
                , (SELECT CRA.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''03'') DD_CRA_ID
                , PVE.PVE_ID
                , (SELECT TCL.DD_TCL_ID FROM '||V_ESQUEMA||'.DD_TCL_TIPO_COLABORACION TCL WHERE TCL.DD_TCL_CODIGO = ''02'') DD_TCL_ID
                , SYSDATE ETP_FECHA_INICIO
                , 0 VERSION
                , '''||V_USU||''' USUARIOCREAR
                , SYSDATE FECHACREAR
                , 0 BORRADO
                FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
                WHERE PVE.USUARIOCREAR = '''||V_USU||'''';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_ETP_ENTIDAD_PROVEEDOR PARA NUEVAS OFICINAS CAIXA');

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
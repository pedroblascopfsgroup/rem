--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17696
--## PRODUCTO=NO
--##
--## Finalidad: MAPEO ACT_ACTIVO_CAIXA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'ACT_ACTIVO_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-17696'; -- Usuario modificar
    V_NUM_TABLAS NUMBER(25);

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                USING (
                    SELECT AAC.CBX_ID
                    , ETP.DD_ETP_ID
                    , TO_DATE(AUX.FEC_ESTADO_POSESORIO,''yyyymmdd'') FEC_EST_POSESORIO_BC
                    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                    JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AAC ON AAC.ACT_ID = ACT.ACT_ID AND AAC.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''ESTADO_POSESORIO'' AND EQV.DD_CODIGO_CAIXA = aux.ESTADO_POSESORIO
                    LEFT JOIN '||V_ESQUEMA||'.DD_ETP_ESTADO_POSESORIO ETP ON ETP.DD_ETP_CODIGO = EQV.DD_CODIGO_REM
                    WHERE ACT.BORRADO = 0
                ) T2 
                ON (T1.CBX_ID = T2.CBX_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.DD_ETP_ID = T2.DD_ETP_ID
                    , T1.FEC_EST_POSESORIO_BC = T2.FEC_EST_POSESORIO_BC
                    , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    , T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS '|| SQL%ROWCOUNT);
	
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

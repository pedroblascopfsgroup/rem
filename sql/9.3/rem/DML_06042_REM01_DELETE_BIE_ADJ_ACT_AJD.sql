--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211112
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16321
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'BIE_LOCALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


  DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN LA BIE_ADJ');
  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE_ADJ
              USING(SELECT AUX.BIE_ADJ_ID
              FROM  '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE_ADJ 
              JOIN (SELECT AUX_BIE_ADJ.BIE_ADJ_ID
              , ROW_NUMBER() OVER (PARTITION BY AUX_BIE_ADJ.BIE_ID ORDER BY AUX_BIE_ADJ.BIE_ADJ_ID DESC) RN
              FROM  '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION AUX_BIE_ADJ 
              JOIN  '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX_BIE_ADJ.BIE_ID = ACT.BIE_ID AND ACT.BORRADO = 0
              JOIN  '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''03''
              WHERE AUX_BIE_ADJ.BORRADO = 0) AUX ON AUX.BIE_ADJ_ID = BIE_ADJ.BIE_ADJ_ID
              WHERE RN > 1) AUX 
              ON (BIE_ADJ.BIE_ADJ_ID = AUX.BIE_ADJ_ID)
              WHEN MATCHED THEN
                  UPDATE SET BIE_ADJ.BORRADO = 1
                  , BIE_ADJ.USUARIOMODIFICAR = ''HREOS-16321''
                  , BIE_ADJ.FECHAMODIFICAR = SYSDATE';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADOS BIE_ADJ: ' || SQL%ROWCOUNT);

  DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN LA ACT_AJD');
  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD
              USING(SELECT AJD.AJD_ID 
              FROM '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD
              WHERE AJD.BIE_ADJ_ID IN (SELECT AUX_BIE_ADJ.BIE_ADJ_ID
              FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION AUX_BIE_ADJ 
              JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX_BIE_ADJ.BIE_ID = ACT.BIE_ID AND ACT.BORRADO = 0
              JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''03''
              WHERE AUX_BIE_ADJ.BORRADO = 1)
              AND AJD.BORRADO = 0) AUX 
              ON (AJD.AJD_ID = AUX.AJD_ID)
              WHEN MATCHED THEN
                  UPDATE SET AJD.BORRADO = 1
                  , AJD.USUARIOMODIFICAR = ''HREOS-16321''
                  , AJD.FECHAMODIFICAR = SYSDATE';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADOS ACT_AJD: ' || SQL%ROWCOUNT);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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

--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9948
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea CPP para Divarian de tipo arrendamiento
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9948';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
    --Comprobamos el dato a insertar
      V_SQL := 'SELECT 
                COUNT(CPP.CPP_ID)
                FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP
                LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                WHERE 
                  CPP.BORRADO = 0 
                  AND CPP.CPP_ARRENDAMIENTO = 0
                  AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                  AND NOT EXISTS (
                    SELECT 1
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP_AUX
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR_AUX ON CPP_AUX.DD_SCR_ID = SCR_AUX.DD_SCR_ID AND SCR_AUX.BORRADO = 0
                    WHERE CPP_AUX.BORRADO = 0 
                    AND SCR_AUX.DD_SCR_CODIGO IN (''151'',''152'')
                    AND CPP_AUX.CPP_ARRENDAMIENTO = 1
                    AND CPP_AUX.EJE_ID = CPP.EJE_ID
                    AND CPP_AUX.DD_STG_ID = CPP.DD_STG_ID
                  )
      ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    --1 existe lo modificamos
    IF V_NUM_TABLAS = 0 THEN	

      DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTEN LAS CPP DE ARRENDAMIENTO PARA DIVARIAN');  

    ELSE
    
      DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS');  

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
                    (
                      CPP_ID
                      , EJE_ID
                      , DD_STG_ID
                      , DD_CRA_ID
                      , DD_SCR_ID
                      , CPP_PARTIDA_PRESUPUESTARIA
                      , USUARIOCREAR
                      , FECHACREAR
                      , CPP_ARRENDAMIENTO
                    )
                    SELECT 
                    '||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL CPP_ID
                    , CPP.EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9948'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , 1 CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE 
                      CPP.BORRADO = 0 
                      AND CPP.CPP_ARRENDAMIENTO = 0
                      AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                      AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP_AUX
                        LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR_AUX ON CPP_AUX.DD_SCR_ID = SCR_AUX.DD_SCR_ID AND SCR_AUX.BORRADO = 0
                        WHERE CPP_AUX.BORRADO = 0 
                        AND SCR_AUX.DD_SCR_CODIGO IN (''151'',''152'')
                        AND CPP_AUX.CPP_ARRENDAMIENTO = 1
                        AND CPP_AUX.EJE_ID = CPP.EJE_ID
                        AND CPP_AUX.DD_STG_ID = CPP.DD_STG_ID
                      )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE LAS CPP DE ARRENDAMIENTO PARA DIVARIAN: ' ||sql%rowcount);
    
    END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  MODIFICADO CORRECTAMENTE ');
   

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

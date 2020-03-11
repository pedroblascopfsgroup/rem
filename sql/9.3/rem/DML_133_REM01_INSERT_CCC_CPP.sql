--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9747
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade CCC y CPP para Apple y Divarian y ejercicios no 2020
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9747';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
    --Comprobamos el dato a insertar
    V_SQL := 'SELECT COUNT(1) 
              FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
              WHERE CPP.BORRADO = 0 AND CPP.USUARIOCREAR = ''HREOS-9747'' AND CPP.CPP_ARRENDAMIENTO = 0
    ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    --1 existe lo modificamos
    IF V_NUM_TABLAS > 0 THEN	

      DBMS_OUTPUT.PUT_LINE('[INFO]: YA SE HAN INSERTADO LAS CCC Y CPP');  

    ELSE
    
      DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS');  

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2016'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )
                  ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA APPLE EN EL EJERCICIO 2016: ' ||sql%rowcount);

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2017'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )
                  ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA APPLE EN EL EJERCICIO 2017: ' ||sql%rowcount);

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2018'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )
                  ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA APPLE EN EL EJERCICIO 2018: ' ||sql%rowcount);

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2019'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )
                  ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA APPLE EN EL EJERCICIO 2019: ' ||sql%rowcount);

                  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2016'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA DIVARIAN EN EL EJERCICIO 2016: ' ||sql%rowcount);

                        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2017'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA DIVARIAN EN EL EJERCICIO 2017: ' ||sql%rowcount);

                        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2018'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA DIVARIAN EN EL EJERCICIO 2018: ' ||sql%rowcount);

                        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC 
                  (
                  CCC_ID
                  , DD_STG_ID
                  , DD_CRA_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  , CCC_CUENTA_CONTABLE
                  , EJE_ID
                  , CCC_ARRENDAMIENTO
                  , DD_SCR_ID
                  )
                  SELECT
                  '||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL CCC_ID
                  , CCC.DD_STG_ID
                  , CCC.DD_CRA_ID
                  , ''HREOS-9747'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , CCC.CCC_CUENTA_CONTABLE
                  ,(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2019'')) EJE_ID
                  , CCC.CCC_ARRENDAMIENTO
                  , CCC.DD_SCR_ID
                  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                  WHERE CCC.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                  AND NOT EXISTS
                  (
                  SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                  WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                  OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                  )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CCC PARA DIVARIAN EN EL EJERCICIO 2019: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2016'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                    AND NOT EXISTS
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                    )
                    ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA APPLE EN EL EJERCICIO 2016: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2017'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                    AND NOT EXISTS
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                    )
                    ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA APPLE EN EL EJERCICIO 2017: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2018'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                    AND NOT EXISTS
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                    )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA APPLE EN EL EJERCICIO 2018: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2019'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''138'')
                    AND NOT EXISTS
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CCC_TMP.BORRADO = 0 AND (CCC_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CCC_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CCC_TMP.CCC_ID = CCC.CCC_ID
                    )
                    ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA APPLE EN EL EJERCICIO 2019: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2016'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                    AND NOT EXISTS 
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CPP_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CPP_TMP.BORRADO = 0 AND (CPP_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CPP_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CPP_TMP.CPP_ID = CPP.CPP_ID
                    )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA DIVARIAN EN EL EJERCICIO 2016: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2017'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                    AND NOT EXISTS 
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CPP_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CPP_TMP.BORRADO = 0 AND (CPP_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CPP_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CPP_TMP.CPP_ID = CPP.CPP_ID
                    )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA DIVARIAN EN EL EJERCICIO 2017: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2018'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                    AND NOT EXISTS 
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CPP_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CPP_TMP.BORRADO = 0 AND (CPP_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CPP_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CPP_TMP.CPP_ID = CPP.CPP_ID
                    )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA DIVARIAN EN EL EJERCICIO 2018: ' ||sql%rowcount);

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
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND EJE.EJE_ANYO IN (''2019'')) EJE_ID
                    , CPP.DD_STG_ID
                    , CPP.DD_CRA_ID
                    , CPP.DD_SCR_ID
                    , CPP.CPP_PARTIDA_PRESUPUESTARIA
                    , ''HREOS-9747'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , CPP.CPP_ARRENDAMIENTO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP  CPP
                    JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CPP.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CPP.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CPP.BORRADO = 0 AND EJE.EJE_ANYO IN (''2020'') AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                    AND NOT EXISTS 
                    (
                    SELECT 1 FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP_TMP
                    LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CPP_TMP.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
                    WHERE CPP_TMP.BORRADO = 0 AND (CPP_TMP.USUARIOCREAR IN (''HREOS-9612'') OR CPP_TMP.USUARIOMODIFICAR IN (''HREOS-9612'')
                    OR STG.DD_STG_CODIGO IN (''01'',''02'')) AND CPP_TMP.CPP_ID = CPP.CPP_ID
                    )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN CPP PARA DIVARIAN EN EL EJERCICIO 2019: ' ||sql%rowcount);
    
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

--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10020
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica gastos de Apple
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-10020';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
    --Comprobamos el dato a insertar
    V_SQL := '
                  WITH CUEPAR AS 
                  (
                      SELECT CCC.CCC_CUENTA_CONTABLE, CPP.CPP_PARTIDA_PRESUPUESTARIA, CCC.CCC_ARRENDAMIENTO, CCC.DD_STG_ID, CCC.EJE_ID, CCC.DD_CRA_ID, CCC.DD_SCR_ID
                      FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                      JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID
                      LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC.DD_STG_ID = STG.DD_STG_ID
                      LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = CCC.DD_SCR_ID AND SCR.BORRADO = 0
                      LEFT JOIN '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP ON CCC.DD_STG_ID = CPP.DD_STG_ID AND CCC.EJE_ID = CPP.EJE_ID AND CCC.DD_CRA_ID = CPP.DD_CRA_ID AND CCC.DD_SCR_ID = CPP.DD_SCR_ID AND CCC.CCC_ARRENDAMIENTO = CPP.CPP_ARRENDAMIENTO AND CPP.BORRADO = 0
                      WHERE 
                          CCC.BORRADO = 0
                          AND STG.DD_STG_CODIGO IN (''84'',''70'',''82'',''81'',''83'',''79'',''77'',''71'',''78'')
                          AND SCR.DD_SCR_CODIGO = ''138''
                  )
                  SELECT COUNT(UNIQUE GPV.GPV_ID)
                  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                  JOIN '||V_ESQUEMA||'.GPV_ACT GPV_ACT ON GPV.GPV_ID = GPV_ACT.GPV_ID
                  JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID AND GIC.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GPV_ACT.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID AND STG.BORRADO = 0
                  JOIN CUEPAR ON CUEPAR.DD_STG_ID = GPV.DD_STG_ID AND CUEPAR.EJE_ID = GIC.EJE_ID AND CUEPAR.DD_CRA_ID = ACT.DD_CRA_ID AND CUEPAR.DD_SCR_ID = ACT.DD_SCR_ID AND CUEPAR.CCC_ARRENDAMIENTO = DECODE(SCM.DD_SCM_CODIGO, ''10'', 1, 0)
                  WHERE 
                    SCR.DD_SCR_CODIGO = ''138''
                    AND GPV.BORRADO = 0
                    AND EGA.DD_EGA_CODIGO NOT IN (''01'',''02'',''12'')
                    AND STG.DD_STG_CODIGO IN (''84'',''70'',''82'',''81'',''83'',''79'',''77'',''71'',''78'')
                    AND EXTRACT(YEAR FROM GPV.FECHACREAR) = 2020
                    AND (GIC.GIC_CUENTA_CONTABLE <> CUEPAR.CCC_CUENTA_CONTABLE OR GIC.GIC_PTDA_PRESUPUESTARIA <> CUEPAR.CPP_PARTIDA_PRESUPUESTARIA)
    ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    --1 existe lo modificamos
    IF V_NUM_TABLAS = 0 THEN	

      DBMS_OUTPUT.PUT_LINE('[INFO]: YA SE HAN ACTUALIZA LOS REGISTROS EN GIC');  

    ELSE
    
      DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS');

      V_MSQL := '
                MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                USING 
                (
                  WITH CUEPAR AS 
                  (
                      SELECT CCC.CCC_CUENTA_CONTABLE, CPP.CPP_PARTIDA_PRESUPUESTARIA, CCC.CCC_ARRENDAMIENTO, CCC.DD_STG_ID, CCC.EJE_ID, CCC.DD_CRA_ID, CCC.DD_SCR_ID
                      FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
                      JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID
                      LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC.DD_STG_ID = STG.DD_STG_ID
                      LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = CCC.DD_SCR_ID AND SCR.BORRADO = 0
                      LEFT JOIN '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP ON CCC.DD_STG_ID = CPP.DD_STG_ID AND CCC.EJE_ID = CPP.EJE_ID AND CCC.DD_CRA_ID = CPP.DD_CRA_ID AND CCC.DD_SCR_ID = CPP.DD_SCR_ID AND CCC.CCC_ARRENDAMIENTO = CPP.CPP_ARRENDAMIENTO AND CPP.BORRADO = 0
                      WHERE 
                          CCC.BORRADO = 0
                          AND STG.DD_STG_CODIGO IN (''84'',''70'',''82'',''81'',''83'',''79'',''77'',''71'',''78'')
                          AND SCR.DD_SCR_CODIGO = ''138''
                  )
                  SELECT UNIQUE GPV.GPV_ID, CUEPAR.CCC_CUENTA_CONTABLE, CUEPAR.CPP_PARTIDA_PRESUPUESTARIA
                  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                  JOIN '||V_ESQUEMA||'.GPV_ACT GPV_ACT ON GPV.GPV_ID = GPV_ACT.GPV_ID
                  JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID AND GIC.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GPV_ACT.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID AND STG.BORRADO = 0
                  LEFT JOIN CUEPAR ON CUEPAR.DD_STG_ID = GPV.DD_STG_ID AND CUEPAR.EJE_ID = GIC.EJE_ID AND CUEPAR.DD_CRA_ID = ACT.DD_CRA_ID AND CUEPAR.DD_SCR_ID = ACT.DD_SCR_ID AND CUEPAR.CCC_ARRENDAMIENTO = DECODE(SCM.DD_SCM_CODIGO, ''10'', 1, 0)
                  WHERE 
                    SCR.DD_SCR_CODIGO = ''138''
                    AND GPV.BORRADO = 0
                    AND EGA.DD_EGA_CODIGO NOT IN (''01'',''02'',''12'')
                    AND STG.DD_STG_CODIGO IN (''84'',''70'',''82'',''81'',''83'',''79'',''77'',''71'',''78'')
                    AND EXTRACT(YEAR FROM GPV.FECHACREAR) = 2020
                    AND (GIC.GIC_CUENTA_CONTABLE <> CUEPAR.CCC_CUENTA_CONTABLE OR GIC.GIC_PTDA_PRESUPUESTARIA <> CUEPAR.CPP_PARTIDA_PRESUPUESTARIA)
                ) AUX 
                ON (GIC.GPV_ID = AUX.GPV_ID)
                WHEN MATCHED THEN UPDATE SET
                GIC.GIC_CUENTA_CONTABLE = AUX.CCC_CUENTA_CONTABLE
                , GIC.GIC_PTDA_PRESUPUESTARIA = AUX.CPP_PARTIDA_PRESUPUESTARIA
                , GIC.USUARIOMODIFICAR = ''HREOS-10020''
                , GIC.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE EN GIC PARA ACTIVOS APPLE: ' ||sql%rowcount);
    
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

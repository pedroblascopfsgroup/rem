--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210819
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9782
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Cargar configuracion cuentas para bbva
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_ACTIVO NUMBER(16); -- Vble. sin prefijo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9782'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_CONFIG_CTAS_CONTABLES'; --Vble. auxiliar para almacenar la tabla a insertar

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('2007'),
        T_TIPO_DATA('2008'),
        T_TIPO_DATA('2009'),
        T_TIPO_DATA('2010'),
        T_TIPO_DATA('2011'),
        T_TIPO_DATA('2012'),
        T_TIPO_DATA('2013'),
        T_TIPO_DATA('2014'),
        T_TIPO_DATA('2015'),
        T_TIPO_DATA('2016')



    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: CARGAR CONFIGURACION AÑOS ANTERIORES A 2017 EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

          V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES

                        (CCC_CTAS_ID,CCC_CUENTA_CONTABLE,DD_TGA_ID,DD_STG_ID,DD_TIM_ID,DD_CRA_ID,DD_SCR_ID,PRO_ID,EJE_ID,
                        CCC_ARRENDAMIENTO,CCC_REFACTURABLE,VERSION,USUARIOCREAR,FECHACREAR,DD_TBE_ID,
                        CCC_SUBCUENTA_CONTABLE,CCC_ACTIVABLE,CCC_PLAN_VISITAS,DD_TCH_ID,CCC_PRINCIPAL,DD_TRT_ID,CCC_VENDIDO)

                        SELECT '||V_ESQUEMA||'.S_ACT_CONFIG_CTAS_CONTABLES.NEXTVAL, ccc_cuenta_contable, DD_TGA_ID,dd_stg_id, DD_TIM_ID, DD_CRA_ID,DD_SCR_ID,PRO_ID,EJE_ID,
                        CCC_ARRENDAMIENTO,CCC_REFACTURABLE,VERSION,USUARIOCREAR, FECHACREAR ,DD_TBE_ID,CCC_SUBCUENTA_CONTABLE,
                        CCC_ACTIVABLE,CCC_PLAN_VISITAS,DD_TCH_ID,CCC_PRINCIPAL,DD_TRT_ID,CCC_VENDIDO FROM (

                            SELECT DISTINCT ctas.ccc_cuenta_contable, TGA.DD_TGA_ID,stg.dd_stg_id, CTAS.DD_TIM_ID, CTAS.DD_CRA_ID,CTAS.DD_SCR_ID,CTAS.PRO_ID,
                            (SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO='''||V_TMP_TIPO_DATA(1)||''' AND BORRADO=0) AS EJE_ID,
                            CTAS.CCC_ARRENDAMIENTO,CTAS.CCC_REFACTURABLE,0 AS VERSION,'''||V_USUARIO||''' AS USUARIOCREAR, SYSDATE AS FECHACREAR ,CTAS.DD_TBE_ID,CTAS.CCC_SUBCUENTA_CONTABLE,
                            CTAS.CCC_ACTIVABLE,CTAS.CCC_PLAN_VISITAS,CTAS.DD_TCH_ID,CTAS.CCC_PRINCIPAL,CTAS.DD_TRT_ID,CTAS.CCC_VENDIDO
                            FROM '||V_ESQUEMA||'.AUX_REMVIP_9782_PARAM AUX
                            JOIN '||V_ESQUEMA||'.dd_tga_tipos_gasto TGA ON UPPER(TGA.DD_TGA_DESCRIPCION)=UPPER(aux.tga_descripcion)
                            JOIN '||V_ESQUEMA||'.dd_stg_subtipos_gasto STG ON STG.DD_TGA_ID=TGA.DD_TGA_ID AND UPPER(StG.DD_STG_DESCRIPCION)=UPPER(aux.stg_descripcion) AND STG.BORRADO = 0
                            join '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES CTAS ON CTAS.DD_CRA_ID=162 AND CTAS.DD_STG_ID=STG.DD_STG_ID AND CTAS.BORRADO = 0  
                            AND CTAS.EJE_ID=(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO=''2021'')
                            JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID=CTAS.EJE_ID
                            ORDER BY CTAS.DD_TIM_ID
                        )
                            ';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS: '|| SQL%ROWCOUNT ||' PARA EL AÑO '''||V_TMP_TIPO_DATA(1)||''' ');

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/
EXIT
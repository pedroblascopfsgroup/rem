--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211230
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10962
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade cuentas y partidas presupuestarias de 2021 copiando las de 2020
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
    V_USR VARCHAR2(400 CHAR):= 'REMVIP-10962';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ANYO VARCHAR2(200 CHAR):='2022';
    V_ANYO_ANT VARCHAR2(200 CHAR):='2021';
    

 
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- Inserta los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_CONFIG_PTDAS_PREP - '''||V_ANYO||''' ');

 
    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_CONFIG_PTDAS_PREP (CPP_PTDAS_ID,
CPP_PARTIDA_PRESUPUESTARIA,
DD_TGA_ID,
DD_STG_ID,
DD_TIM_ID,
DD_CRA_ID,
DD_SCR_ID,
PRO_ID,
EJE_ID,
CPP_ARRENDAMIENTO,
CPP_REFACTURABLE,
USUARIOCREAR,
FECHACREAR,
CPP_PRINCIPAL,
DD_TBE_ID,
CPP_APARTADO,
CPP_CAPITULO,
CPP_ACTIVABLE,
CPP_PLAN_VISITAS,
DD_TCH_ID,
DD_TRT_ID,
CPP_VENDIDO) 

SELECT '||V_ESQUEMA||'.S_ACT_CONFIG_PTDAS_PREP.NEXTVAL,
CPP_PARTIDA_PRESUPUESTARIA,
DD_TGA_ID,
DD_STG_ID,
DD_TIM_ID,
DD_CRA_ID,
DD_SCR_ID,
PRO_ID,
EJE_ID,
CPP_ARRENDAMIENTO,
CPP_REFACTURABLE,
USUARIOCREAR,
FECHACREAR,
CPP_PRINCIPAL,
DD_TBE_ID,
CPP_APARTADO,
CPP_CAPITULO,
CPP_ACTIVABLE,
CPP_PLAN_VISITAS,
DD_TCH_ID,
DD_TRT_ID,
CPP_VENDIDO FROM (

SELECT  
CPP.CPP_PARTIDA_PRESUPUESTARIA,
CPP.DD_TGA_ID,
CPP.DD_STG_ID,
CPP.DD_TIM_ID,
CPP.DD_CRA_ID,
CPP.DD_SCR_ID,
CPP.PRO_ID,
(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND eje.eje_anyo='''||V_ANYO||''' ) AS EJE_ID,
CPP.CPP_ARRENDAMIENTO,
CPP.CPP_REFACTURABLE,
'''||V_USR||''' AS USUARIOCREAR,
SYSDATE AS FECHACREAR,
CPP.CPP_PRINCIPAL,
CPP.DD_TBE_ID,
CPP.CPP_APARTADO,
CPP.CPP_CAPITULO,
CPP.CPP_ACTIVABLE,
CPP.CPP_PLAN_VISITAS,
CPP.DD_TCH_ID,
CPP.DD_TRT_ID,
CPP.CPP_VENDIDO
FROM '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP CPP
JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE2 ON EJE2.EJE_ID=CPP.EJE_ID AND EJE2.BORRADO = 0
WHERE CPP.BORRADO = 0 AND EJE2.EJE_ANYO='''||V_ANYO_ANT||'''
)
 	     ';
                                        
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CPP ['||SQL%ROWCOUNT||'] INSERTADOS CORRECTAMENTE - EJERCICIO '''||V_ANYO||''' ');
        
         DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_CONFIG_PTDAS_PREP ACTUALIZADA CORRECTAMENTE ');
         
         -- Inserta los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_CONFIG_CTAS_CONTABLES - '''||V_ANYO||''' ');

 
    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_CONFIG_CTAS_CONTABLES (CCC_CTAS_ID,
CCC_CUENTA_CONTABLE,
DD_TGA_ID,
DD_STG_ID,
DD_TIM_ID,
DD_CRA_ID,
DD_SCR_ID,
PRO_ID,
EJE_ID,
CCC_ARRENDAMIENTO,
CCC_REFACTURABLE,
USUARIOCREAR,
FECHACREAR,
DD_TBE_ID,
CCC_SUBCUENTA_CONTABLE,
CCC_ACTIVABLE,
CCC_PLAN_VISITAS,
DD_TCH_ID,
CCC_PRINCIPAL,
DD_TRT_ID,
CCC_VENDIDO) 

SELECT '||V_ESQUEMA||'.S_ACT_CONFIG_CTAS_CONTABLES.NEXTVAL,
CCC_CUENTA_CONTABLE,
DD_TGA_ID,
DD_STG_ID,
DD_TIM_ID,
DD_CRA_ID,
DD_SCR_ID,
PRO_ID,
EJE_ID,
CCC_ARRENDAMIENTO,
CCC_REFACTURABLE,
USUARIOCREAR,
FECHACREAR,
DD_TBE_ID,
CCC_SUBCUENTA_CONTABLE,
CCC_ACTIVABLE,
CCC_PLAN_VISITAS,
DD_TCH_ID,
CCC_PRINCIPAL,
DD_TRT_ID,
TO_NUMBER(CCC_VENDIDO )

FROM (

SELECT  
CCC.CCC_CUENTA_CONTABLE,
CCC.DD_TGA_ID,
CCC.DD_STG_ID,
CCC.DD_TIM_ID,
CCC.DD_CRA_ID,
CCC.DD_SCR_ID,
CCC.PRO_ID,
(SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.BORRADO = 0 AND eje.eje_anyo='''||V_ANYO||''' ) AS EJE_ID,
CCC.CCC_ARRENDAMIENTO,
CCC.CCC_REFACTURABLE,
'''||V_USR||''' AS USUARIOCREAR,
SYSDATE AS FECHACREAR,
CCC.DD_TBE_ID,
CCC.CCC_SUBCUENTA_CONTABLE,
CCC.CCC_ACTIVABLE,
CCC.CCC_PLAN_VISITAS,
CCC.DD_TCH_ID,
CCC.CCC_PRINCIPAL,
CCC.DD_TRT_ID,
CCC.CCC_VENDIDO AS CCC_VENDIDO
FROM '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES CCC
JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE2 ON EJE2.EJE_ID=CCC.EJE_ID AND EJE2.BORRADO = 0
WHERE CCC.BORRADO = 0 AND eje2.eje_anyo='''||V_ANYO_ANT||'''
)
 	     ';
                                        
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CCC ['||SQL%ROWCOUNT||'] INSERTADOS CORRECTAMENTE - EJERCICIO '''||V_ANYO||''' ');
        
        DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_CONFIG_CTAS_CONTABLES ACTUALIZADA CORRECTAMENTE ');      

    COMMIT;

   
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

EXIT;
--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20201230
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8625
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
        
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    

 
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- Inserta los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREPP - 2021');

 
    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP (CPP_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, EJE_ID, CPP_PARTIDA_PRESUPUESTARIA, CPP_ARRENDAMIENTO, CPP_CANTIDAD_MAX_PRO, CPP_REFACTURABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                SELECT   REM01.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
        	 DD_STG_ID,
        	 DD_CRA_ID,
		 DD_SCR_ID,
		 PRO_ID,
        	 (SELECT EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2021''),
		 CPP_PARTIDA_PRESUPUESTARIA,
		 CPP_ARRENDAMIENTO,	
        	 CPP_CANTIDAD_MAX_PRO,
		 CPP_REFACTURABLE,
       	  0, 
		 ''REMVIP-8625'',
		 SYSDATE,
		 0 
		 FROM '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP CTA
		 WHERE CTA.BORRADO = 0
        	 AND CTA.EJE_ID = (SELECT EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'')
		 AND NOT EXISTS ( 
				  SELECT 1
				  FROM '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP AUX
				  WHERE AUX.DD_STG_ID = CTA.DD_STG_ID	
				  AND AUX.EJE_ID = (SELECT EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2021'')
				  AND AUX.BORRADO = 0	
				) 
 	     ';
                                        
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['||SQL%ROWCOUNT||'] INSERTADO CORRECTAMENTE - EJERCICIO 2021');
        
         DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CPP_CONFIG_PTDAS_PREP ACTUALIZADA CORRECTAMENTE ');
         
         -- Inserta los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES - 2021');

 
    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES (CCC_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, EJE_ID, CCC_CUENTA_CONTABLE, CCC_ARRENDAMIENTO, CCC_CUENTA_ACTIVABLE, CCC_REFACTURABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                SELECT REM01.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL,
        	 DD_STG_ID,
        	 DD_CRA_ID,
		 DD_SCR_ID,
		 PRO_ID,
         	 (SELECT EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2021''),
		 CCC_CUENTA_CONTABLE,
		 CCC_ARRENDAMIENTO,	
         	 CCC_CUENTA_ACTIVABLE,
		 CCC_REFACTURABLE,
         	 0, 
		 ''REMVIP-8625'',
		 SYSDATE,
		 0 
		 FROM '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES CCC
		 WHERE 
		  CCC.EJE_ID = (SELECT EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'')
		 AND NOT EXISTS ( 
				  SELECT 1
				  FROM '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES AUX
				  WHERE AUX.DD_STG_ID = CCC.DD_STG_ID	
				  AND AUX.EJE_ID = (SELECT EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2021'')
				  AND AUX.BORRADO = 0	
				) 	
		 AND CCC.BORRADO = 0
 	     ';
                                        
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['||SQL%ROWCOUNT||'] INSERTADO CORRECTAMENTE - EJERCICIO 2021');
        
        DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CCC_CONFIG_CTAS_CONTABLES ACTUALIZADA CORRECTAMENTE ');      

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

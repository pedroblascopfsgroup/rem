--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200218
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6458
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CPP_CONFIG_PTDAS_PREP en la cartera APPLE-2020 con lo existente en APPLE-2019
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
    V_TABLA VARCHAR2(50 CHAR) := 'CPP_CONFIG_PTDAS_PREP';

 
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- Realiza el borrado lógico a la configuración actual de la cartera GIANTS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO DE LA CONFIGURACIÓN EN APPLE - 2020');

 
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP 
	       SET BORRADO = 1,	
		   USUARIOBORRAR = ''REMVIP-6458'',
		   FECHABORRAR  = SYSDATE
 	       WHERE 1 = 1
	       AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'')
	       AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'')
	       AND EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'')
 	     ';
                                 
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| SQL%ROWCOUNT ||'] BORRADO CORRECTAMENTE - EJERCICIO 2020');
        
         
    -- Inserta los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP; PARA APPLE - 2020');

 
    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP 
		(' ||  'CPP_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, EJE_ID, CPP_PARTIDA_PRESUPUESTARIA, CPP_ARRENDAMIENTO, CPP_CANTIDAD_MAX_PRO, CPP_REFACTURABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                SELECT ' 
		 || V_ESQUEMA ||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
                 DD_STG_ID,
                 (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''),
		 (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138''),	
		 PRO_ID,
                 (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020''),
		 CPP_PARTIDA_PRESUPUESTARIA,
		 CPP_ARRENDAMIENTO,	
                 CPP_CANTIDAD_MAX_PRO,
		 CPP_REFACTURABLE,
                 0, 
		 ''REMVIP-6458'',
		 SYSDATE,
		 0 
		 FROM '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP CTA
		 WHERE 1 = 1
		 AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'')
		 AND CTA.EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2019'')
		 AND DD_SCR_ID = ( SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'' )	
		 AND NOT EXISTS ( 
				  SELECT 1
				  FROM '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP AUX
				  WHERE AUX.DD_STG_ID = CTA.DD_STG_ID	
				  AND AUX.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'')
				  AND AUX.EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'')
				  AND AUX.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'')
				  AND AUX.BORRADO = 0	
				) 	
		 AND CTA.BORRADO = 0
 	     ';
                                        
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['||SQL%ROWCOUNT||'] INSERTADO CORRECTAMENTE - EJERCICIO 2020');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CPP_CONFIG_PTDAS_PREP ACTUALIZADA CORRECTAMENTE ');
   
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

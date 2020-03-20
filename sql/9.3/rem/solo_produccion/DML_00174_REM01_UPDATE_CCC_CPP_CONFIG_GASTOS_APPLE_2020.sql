--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200218
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6458
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en la cuenta contable y la partida presupuestaria a gastos de Apple 2020 que no tengan
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
    V_TABLA VARCHAR2(50 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES';

 
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- Informa la cuenta contable cuando no la tiene

 -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio de la actualización de cuentas ... ');


    	V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
	    USING (

			SELECT GPV.GPV_NUM_GASTO_HAYA, CCC.CCC_CUENTA_CONTABLE, GPV.GPV_ID
			FROM REM01.GIC_GASTOS_INFO_CONTABILIDAD GIC, REM01.GPV_GASTOS_PROVEEDOR GPV,
			(
			 SELECT CCC.CCC_CUENTA_CONTABLE, CCC.DD_STG_ID
			 FROM REM01.CCC_CONFIG_CTAS_CONTABLES CCC
			 WHERE CCC.DD_SCR_ID = 323
			 AND EJE_ID = ( SELECT EJE_ID FROM REM01.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'' )
			 AND CCC_ARRENDAMIENTO = 0
			) CCC
			WHERE 1 = 1
			AND GIC.GPV_ID = GPV.GPV_ID
			AND CCC.DD_STG_ID = GPV.DD_STG_ID
			AND GPV.GPV_ID IN ( 
						SELECT GPV_ID 
						FROM REM01.GPV_ACT 
						WHERE ACT_ID IN ( 
								    SELECT ACT_ID
								    FROM REM01.ACT_ACTIVO ACT
								    WHERE ACT.DD_SCR_ID = 323 ) )

			AND EJE_ID = ( SELECT EJE_ID FROM REM01.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'' )
			AND ( GIC_CUENTA_CONTABLE IS NULL )
	
		) AUX
	    ON (GIC.GPV_ID = AUX.GPV_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET GIC_CUENTA_CONTABLE = AUX.CCC_CUENTA_CONTABLE,
		   FECHAMODIFICAR = SYSDATE,
		   USUARIOMODIFICAR = ''REMVIP-6478''	 		
         ';
		
	EXECUTE IMMEDIATE V_MSQL;  

        DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' CUENTAS INFORMADAS  ');
        
         

    -- Informa la partida cuando no la tiene
 -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio de la actualización de partidas ... ');


    	V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
	    USING (

			SELECT GPV.GPV_NUM_GASTO_HAYA, CPP.CPP_PARTIDA_PRESUPUESTARIA, GPV.GPV_ID
			FROM REM01.GIC_GASTOS_INFO_CONTABILIDAD GIC, REM01.GPV_GASTOS_PROVEEDOR GPV,
			(
			 SELECT CPP.CPP_PARTIDA_PRESUPUESTARIA, CPP.DD_STG_ID
			 FROM REM01.CPP_CONFIG_PTDAS_PREP CPP
			 WHERE CPP.DD_SCR_ID = 323
			 AND EJE_ID = ( SELECT EJE_ID FROM REM01.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'' )
			 AND CPP_ARRENDAMIENTO = 0
			) CPP
			WHERE 1 = 1
			AND GIC.GPV_ID = GPV.GPV_ID
			AND CPP.DD_STG_ID = GPV.DD_STG_ID
			AND GPV.GPV_ID IN ( 
						SELECT GPV_ID 
						FROM REM01.GPV_ACT 
						WHERE ACT_ID IN ( 
								    SELECT ACT_ID
								    FROM REM01.ACT_ACTIVO ACT
								    WHERE ACT.DD_SCR_ID = 323 ) )

			AND EJE_ID = ( SELECT EJE_ID FROM REM01.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2020'' )
			AND ( GIC_PTDA_PRESUPUESTARIA IS NULL )
	
		) AUX
	    ON (GIC.GPV_ID = AUX.GPV_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET GIC_PTDA_PRESUPUESTARIA = AUX.CPP_PARTIDA_PRESUPUESTARIA,
		   FECHAMODIFICAR = SYSDATE,
		   USUARIOMODIFICAR = ''REMVIP-6478''	 		
         ';
		
	EXECUTE IMMEDIATE V_MSQL;  

        DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' PARTIDAS INFORMADAS  ');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA GIC_GASTOS_INFO_CONTABILIDAD ACTUALIZADA ');
   
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

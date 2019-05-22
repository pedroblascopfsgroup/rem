--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190522
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3618
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de GGE_GASTO_GESTION.DD_EAH_ID y GPV_GASTOS_PROVEEDOR.DD_EGA_ID
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
	
           
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN GGE_GASTOS_GESTION] ');
         

    V_MSQL := ' UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
		SET DD_EAH_ID = ( SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03'' ),
		    USUARIOMODIFICAR = ''REMVIP-3618'',
		    FECHAMODIFICAR = SYSDATE
		WHERE EXISTS ( SELECT 1
		               FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
		               WHERE 1 = 1
		               AND GPV.GPV_ID = '||V_ESQUEMA||'.GGE_GASTOS_GESTION.GPV_ID
		               AND GPV.GPV_NUM_GASTO_HAYA IN (

								9479715,
								9494064

								)
			      ) ';



	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('ACTUALIZADOS '||sql%rowcount||' GGE_GASTOS_GESTION ');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN GPV_GASTOS_PROVEEDOR ] ');
         

    V_MSQL := ' UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
		SET DD_EGA_ID = ( SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03'' ),
		    USUARIOMODIFICAR = ''REMVIP-3618'',
		    FECHAMODIFICAR = SYSDATE
		WHERE GPV_NUM_GASTO_HAYA IN (

								9479715,
								9494064

					    )
	 ';



	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('ACTUALIZADOS '||sql%rowcount||' GPV_GASTOS_PROVEEDOR ');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: REENVIADOS GASTOS ');   

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



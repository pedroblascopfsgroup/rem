--/*
--###########################################
--## AUTOR=PIER GOTTA BARRERA
--## FECHA_CREACION=20181227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2922
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar estados gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2922';
  V_COUNT_G  NUMBER(25) := 0;
  V_COUNT_N  NUMBER(25) := 0;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 
    -- LOOP para actualizar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE PROPIETARIOS GASTOS');
    
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL DEL GASTO'); 
			
			V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION T1
			    USING (SELECT GPV.GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
			    JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
			    JOIN '||V_ESQUEMA||'.AUX_REMVIP_2922 AUX ON AUX.NUM_GASTO = GPV.GPV_NUM_GASTO_HAYA) T2
			    ON (T1.GPV_ID = T2.GPV_ID)
			    WHEN MATCHED THEN UPDATE SET
			    DD_EAP_ID = NULL
			  , DD_EAH_ID = (SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''01'')
			  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
			  , FECHAMODIFICAR = SYSDATE' ;
										
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE ESTADO PROPIETARIO DEL GASTO');

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR SET 
				  DD_EGA_ID = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''01'')
				  , USUARIOMODIFICAR  = '''||V_USUARIO||'''
				  , FECHAMODIFICAR    = SYSDATE 
				  WHERE GPV_NUM_GASTO_HAYA IN (SELECT NUM_GASTO FROM '||V_ESQUEMA||'.AUX_REMVIP_2922)
				  AND BORRADO = 0' ;
										
			EXECUTE IMMEDIATE V_MSQL;
			

			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE ESTADO PROPIETARIO DEL GASTO');
		
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: '||V_COUNT_G||' PROPIETARIOS DE GASTOS ACTUALIZADOS CORRECTAMENTE ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||V_COUNT_N||' PROPIETARIOS DE GASTOS NO ACTUALIZADOS ');
    DBMS_OUTPUT.PUT_LINE('[FIN]: PROPIETARIOS DE GASTOS ACTUALIZADOS');

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
 	--DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución sql:'||V_MSQL);
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT

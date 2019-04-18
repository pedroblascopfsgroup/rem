--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190403
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3880
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de GGE_GASTO_GESTION.DDE_EAH_ID y GGE_GASTO_GESTION.DDE_EAP_ID
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

	
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_ACTIVO] ');
         

    V_MSQL := ' UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
		SET DD_EAH_ID = ( SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''01'' ),
		    DD_EAP_ID = NULL,
		    USUARIOMODIFICAR = ''REMVIP-3880'',
		    FECHAMODIFICAR = SYSDATE
		WHERE EXISTS ( SELECT 1
		               FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
		               WHERE 1 = 1
		               AND GPV.GPV_ID = '||V_ESQUEMA||'.GGE_GASTOS_GESTION.GPV_ID
		               AND GPV.GPV_NUM_GASTO_HAYA IN (
								10153900,
								10153901,
								10153902,
								10153903,
								10153906,
								10153907,
								10153908,
								10153910,
								10153912,
								10153913,
								10153914,
								10153915,
								10153916,
								10153917,
								10153919,
								10153920,
								10153921,
								10153922,
								10153925,
								10153926,
								10153927,
								10153928,
								10153929,
								10153930,
								10153931,
								10153932,
								10153933,
								10153934,
								10153936,
								10153937,
								10153938,
								10153939,
								10153940,
								10153941,
								10153942,
								10153943,
								10153944,
								10153946,
								10153947,
								10153948,
								10153949,
								10153951,
								10153953,
								10153954,
								10153955,
								10153956,
								10153957,
								10153959,
								10153960,
								10153961,
								10153962,
								10153963,
								10153964,
								10153965,
								10153966,
								10153967,
								10153968,
								10153969,
								10153970,
								10153971,
								10153972,
								10153974,
								10153975,
								10153976,
								10153977,
								10153978,
								10153979,
								10153980,
								10153981,
								10153982,
								10153983,
								10153984,
								10153985,
								10153986,
								10153987,
								10153988,
								10153989,
								10153990,
								10153991,
								10153992,
								10153993,
								10153995,
								10153996,
								10153997,
								10153998,
								10153999,
								10154000,
								10154002,
								10154003,
								10154004,
								10154005,
								10154006,
								10154007,
								10154008,
								10154009,
								10154010,
								10154011,
								10154012,
								10154013,
								10154014,
								10154015,
								10154016,
								10154017,
								10154018,
								10154019,
								10154021,
								10154022,
								10154023,
								10154024,
								10154025,
								10154026,
								10154027,
								10154028,
								10154029,
								10154030,
								10154031,
								10154033,
								10154034,
								10154035,
								10154037,
								10154038,
								10154039,
								10154040,
								10154041,
								10154043,
								10154044,
								10154045,
								10154046,
								10154047,
								10154048,
								10154049,
								10154051,
								10154052,
								10154053,
								10154054,
								10154055,
								10154056,
								10154058,
								10154059,
								10154060,
								10154061,
								10154062,
								10154064,
								10154065,
								10154066,
								10154067,
								10154068,
								10154069,
								10154070,
								10154071,
								10154072,
								10154073,
								10154074,
								10154075,
								10154076,
								10154077,
								10154079,
								10154081,
								10154082,
								10154083,
								10154086,
								10154087,
								10154088,
								10154089,
								10154090,
								10154091,
								10154092,
								10154093,
								10154094,
								10154095,
								10154096,
								10154097,
								10154098,
								10154099,
								10154100,
								10154101,
								10154102,
								10154103,
								10154104,
								10154105,
								10154106,
								10154107,
								10154109,
								10154110,
								10154111,
								10154112,
								10154113,
								10154115,
								10154116,
								10154117,
								10154118,
								10154119,
								10154121,
								10154122,
								10154123,
								10154124,
								10154125,
								10154126,
								10170936
								)
					) ';



	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('ACTUALIZADOS '||sql%rowcount||' GASTOS ');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.GGE_GASTOS_GESTION');   

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



--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4876
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar estado de trabajos.
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
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


     V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION 
		SET BIE_LOC_POBLACION = ''300300017'',
   		DD_LOC_ID = 4585,
    		USUARIOMODIFICAR = ''REMVIP-4876'',
    		FECHAMODIFICAR = SYSDATE
		WHERE BIE_LOC_ID IN 
		    (                                                                               
		    SELECT BILO.BIE_LOC_ID 
		    FROM REM01.ACT_ACTIVO ACT
		    INNER JOIN REM01.BIE_LOCALIZACION BILO ON BILO.BIE_ID = ACT.BIE_ID
		    WHERE ACT.ACT_NUM_ACTIVO IN 
			(7100681,
			7100829,
			7100719,
			7100863,
			7100867,
			7100895,
			7100728,
			7100755,
			7100682,
			7100727,
			7100764,
			7100694,
			7100790,
			7100771,
			7100723,
			7100779,
			7100820,
			7100857,
			7100888,
			7100741,
			7100783,
			7100900,
			7100761,
			7100689,
			7100870,
			7100772,
			7100781,
			7100691,
			7100811,
			7100692,
			7100773,
			7100836,
			7100854,
			7100768,
			7100769,
			7100752,
			7100686,
			7100830,
			7100833,
			7100759,
			7100834,
			7100827,
			7100864,
			7100765,
			7100892,
			7100801,
			7100731,
			7100807,
			7100849,
			7100786,
			7100818,
			7100753,
			7100878,
			7100696,
			7100853,
			7100881,
			7100821,
			7100702,
			7100778,
			7100770,
			7100877,
			7100742,
			7100898,
			7100697,
			7100715,
			7100734,
			7100869,
			7100720,
			7100879,
			7100754,
			7100848,
			7100823,
			7100813,
			7100844,
			7100777,
			7100815,
			7100775,
			7100748,
			7100800,
			7100876,
			7100718,
			7100743,
			7100732,
			7100837,
			7100899,
			7100733,
			7100780,
			7100703,
			7100890,
			7100747,
			7100805,
			7100871,
			7100880,
			7100698,
			7100884,
			7100791,
			7100842,
			7100737,
			7100866,
			7100868,
			7100721,
			7100750,
			7100701,
			7100704,
			7100889,
			7100840,
			7100757,
			7100843,
			7100852,
			7100699,
			7100722,
			7100838,
			7100756,
			7100709,
			7100695,
			7100683,
			7100700,
			7100730,
			7100861,
			7100706,
			7100760,
			7100744,
			7100684,
			7100717,
			7100819,
			7100835,
			7100901,
			7100714,
			7100740,
			7100716,
			7100782,
			7100688,
			7100690,
			7100897,
			7100831,
			7100776,
			7100785,
			7100891,
			7100724,
			7100858,
			7100862,
			7100687,
			7100859,
			7100872,
			7100745,
			7100712,
			7100902,
			7100874,
			7100799,
			7100725,
			7100865,
			7100711,
			7100685,
			7100758,
			7100825,
			7100803,
			7100739,
			7100883,
			7100893,
			7100826,
			7100824,
			7100808,
			7100822,
			7100882,
			7100851,
			7100693,
			7100810,
			7100705,
			7100875,
			7100767,
			7100798,
			7100855,
			7100850,
			7100708,
			7100845,
			7100751,
			7100738,
			7100839,
			7100860,
			7100729,
			7100894,
			7100886,
			7100804,
			7100710,
			7100817,
			7100816,
			7100828,
			7100887,
			7100846,
			7100847,
			7100802,
			7100749,
			7100746,
			7100763,
			7100873,
			7100903,
			7100856,
			7100735,
			7100707,
			7100774,
			7100713,
			7100762,
			7100736,
			7100766,
			7100812,
			7100806,
			7100726,
			7100809,
			7100814,
			7100832,
			7100896,
			7100841)
		)';
	
	EXECUTE IMMEDIATE V_MSQL;
    
	COMMIT;
   
	DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO FINALIZADO CORRECTAMENTE ');
 

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

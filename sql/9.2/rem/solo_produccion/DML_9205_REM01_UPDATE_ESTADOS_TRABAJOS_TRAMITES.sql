--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5063
--## PRODUCTO=NO
--##
--## Finalidad: actualizar estado trabajos y tramites
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_TBJ_TRABAJO'; 
    V_TABLA_2 VARCHAR2(25 CHAR):= 'ACT_TRA_TRAMITE';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-5063';    
    
BEGIN	
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
 				    FECHAMODIFICAR = SYSDATE 
				  , USUARIOMODIFICAR = '''||V_USUARIO||'''
	 			  , DD_EST_ID = 2  
				    WHERE TBJ_NUM_TRABAJO IN (  116518,
								149635,
								170700,
								9000021472,
								9000041003,
								9000049721,
								9000056186,
								9000061639,
								9000071562,
								9000075278,
								9000096318,
								9000101905,
								9000101956,
								9000101960,
								9000101970,
								9000101972,
								9000102154,
								9000102161,
								9000102163,
								9000102313,
								9000102314,
								9000102316,
								9000102318,
								9000102319,
								9000102320,
								9000102321,
								9000102329,
								9000102331,
								9000102337,
								9000102338,
								9000102368,
								9000115398,
								9000115632,
								9000116169,
								9000116223,
								9000116224,
								9000116225,
								9000116526,
								9000117805,
								9000120149,
								9000120626,
								9000120976,
								9000121006,
								9000123557,
								9000123561,
								9000124505,
								9000130910,
								9000131576,
								9000131974,
								9000134315,
								9000137726,
								9000138846,
								9000140368,
								9000140406,
								9000151346,
								9000152839,
								9000155286,
								9000158685,
								9000160825,
								9000165534,
								9000170664,
								9000171827,
								9000172999,
								9000176589,
								9000178013,
								9000180334,
								9000183505,
								9000184487,
								9000188569,
								9000190350,
								9000190685,
								9000190707,
								9000190708,
								9000195446,
								9000199086,
								9000199949,
								9000200962,
								9000206505,
								9000211059,
								9000211590,
								9000213887,
								9000214322,
								9000214591,
								9000214683,
								9000215962,
								9000216207,
								9000216665,
								9000217044,
								9000217415,
								9000217490,
								9000218377,
								9000219048,
								9000219061,
								9000219472,
								9000219719,
								9000220032,
								9000220387,
								9000220723,
								9000220740,
								9000221063,
								9000221109,
								9000221557,
								9000221841) 
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_2||' SET 
 				    FECHAMODIFICAR = SYSDATE 
				  , USUARIOMODIFICAR = '''||V_USUARIO||'''
	 			  , DD_EPR_ID = 5  
				    WHERE TRA_ID IN (   52579,
							42206,
							57975,
							46960,
							56148,
							46858,
							47573,
							20456,
							54759,
							51969,
							60152,
							59949,
							49785,
							45588,
							94440,
							100148,
							351571,
							352895,
							352896,
							352897,
							352898,
							352899,
							352900,
							352901,
							352902,
							352903,
							352904,
							352905,
							352906,
							352907,
							352911,
							352912,
							352913,
							352914,
							352915,
							352916,
							352917,
							352918,
							352919,
							352920,
							352921,
							352922,
							352923) 
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA_2);

   	COMMIT;
    	DBMS_OUTPUT.PUT_LINE('[FIN] ');


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



--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3987
--## PRODUCTO=NO
--##
--## Finalidad:  
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
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3987';
    PL_OUTPUT VARCHAR2(32000 CHAR);
    
    
 BEGIN

    		V_SQL := 'UPDATE REM01.ACT_PAC_PERIMETRO_ACTIVO PAC SET PAC_CHECK_FORMALIZAR = 1, 
                                                PAC.PAC_CHECK_COMERCIALIZAR = 1, 
                                                FECHAMODIFICAR = SYSDATE, 
                                                USUARIOMODIFICAR = ''REMVIP-3525'' 
                                                WHERE ACT_ID IN (SELECT ACT_ID FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO IN (5928069,
																5929462,
																5929656,
																5930016,
																5930444,
																5934710,
																5934896,
																5939103,
																5941214,
																5942344,
																5943072,
																5943763,
																5943827,
																5950363,
																5952704,
																5953630,
																5953722,
																5954170,
																5956123,
																5959651,
																5962500,
																5962657,
																5962928,
																5963054,
																5965348,
																5965708,
																5967506,
																5967690,
																5967797,
																5969208,
																5971614,
																6050976,
																6063616,
																6529988,
																6843076,
																6885714,
																6936000,
																6942778,
																6984773,
																6984936,
																6984971,
																6986174,
																6988279,
																6988536,
																6988557,
																6988713,
																6988728,
																6988757,
																6988758,
																6988828,
																6988852,
																6988853,
																6988966,
																6988967,
																6988998,
																6989246,
																6989414,
																6989430,
																6989903,
																6989960,
																6990038,
																6990056,
																6990389,
																6990649,
																6991490,
																6991515,
																6991651,
																6992670,
																6992700,
																6992702,
																6992729,
																6993023,
																6995508,
																6999004,
																6999323,
																6999509,
																6999544,
																7000957,
																7001318,
																7001421,
																7001900
																))';	  
	
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' registros ACTUALIZADOS');

 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;


--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=202000319
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6722
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6722';
   V_SQL VARCHAR2(4000 CHAR);	
   V_PAR VARCHAR( 32000 CHAR );
   V_RET VARCHAR( 1024 CHAR );  
  
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');

-----------------------------------------------------------------------------------------------------------------      

   V_PAR := '11282806,
11282807,
11282808,
11282809,
11282810,
11282811,
11282812,
11354782,
11354783,
11354784,
11360765,
11363510,
11363511,
11363512,
11363513,
11363514,
11363515,
11326733,
11326734,
11326842,
11379762,
11379763,
11379764,
11379765,
11379766,
11379767,
11379768,
11379769,
11379770,
11379771,
11379772,
11379773,
11379774,
11376838,
11376839,
11376840,
11376841,
11360766,
11375400,
11375401,
11355538,
11355092,
11355093,
11355094,
11355095,
11355096,
11355097,
11355098,
11355099,
11355100,
11355101,
11355102,
11355103,
11355104,
11355105,
11355106,
11355107,
11355108,
11355109,
11355110,
11355111,
11355112,
11355114,
11355116,
11355117,
11355504,
11264497,
11264498,
11264499,
11264502,
11264698,
11278347,
11278348,
11278349,
11278350,
11278352,
11278353,
11278354,
11278355,
11278357,
11278358,
11278361,
11278362,
11278363,
11278364,
11278365,
11278366,
11278367,
11278368,
11278369,
11278371,
11278373,
11278684,
11359822,
11359880,
11266505,
11266477,
11360169,
11360223,
11266685,
11266732,
11358852,
11359298,
11359299,
11359300,
11359301,
11359302,
11379874,
10503087,
10503088,
10503090,
11359431,
11359159,
11359167,
11266148,
11266156,
11266293,
11380026,
11380027,
11380028,
11380029,
11380030,
11380031,
11380032,
11380033,
11360609,
11360610,
11360046,
11360047,
11360048,
11360049,
11360050,
11360051,
11360052,
11360053,
11360054,
11360055,
11360412,
11266631,
11266632,
11266633,
11266634,
11266635,
11266636,
11266637,
11266638,
11266639,
11266640,
11266854,
11266955,
11266956';	
   REM01.SP_EXT_REENVIO_GASTO ( V_PAR , V_USUARIOMODIFICAR, V_RET );

-----------------------------------------------------------------------------------------------------------------

   DBMS_OUTPUT.PUT_LINE( V_RET );
   DBMS_OUTPUT.PUT_LINE(' [INFO] Reenviado gastos ');
   DBMS_OUTPUT.PUT_LINE('[FIN] ');
    
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(ERR_MSG);
        ROLLBACK;
        RAISE;   
END;
/
EXIT;

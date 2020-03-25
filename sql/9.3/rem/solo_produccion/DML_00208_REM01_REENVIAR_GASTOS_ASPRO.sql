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

   V_PAR := '11361737,
11361738,
11361739,
11362137,
11361740,
11361748,
11361749,
11361751,
11361752,
11361753,
11361754,
11361755,
11361756,
11361757,
11361758,
11361759,
11361760,
11361761,
11361762,
11361763,
11361764,
11361765,
11361766,
11361767,
11361768,
11361769,
11361770,
11364956,
11364957,
11364958,
11364959,
11364960,
11364961,
11364962,
11364968,
11364969,
11361865,
11361866,
11361867,
11361868,
11361869,
11361870,
11361871,
11361872,
11361873,
11361874,
11361875,
11361876,
11361877,
11361878,
11361879,
11361880,
11361881,
11361882,
11361883,
11361884,
11361885,
11361886,
11361887,
11361888,
11361889,
11361890,
11361891,
11361892,
11361893,
11361894,
11361945,
11361946,
11361947,
11361982,
11363266,
11363267,
11363268,
11363526,
11363527,
11363528,
11363529,
11363530,
11363531,
11363532,
11363533,
11363534,
11363535,
11363536,
11363537,
11363538,
11363539,
11363540,
11363541,
11363542,
11363543,
11363544,
11363545,
11363269,
11363270,
11363271,
11363272,
11363273,
11363274,
11363275,
11363276,
11363277,
11363278,
11363279,
11363280,
11363281,
11363282,
11363283,
11363284,
11363285,
11363290,
11363291,
11326860,
11326861,
11326862,
11326863,
11326864,
11326865,
11326866,
11326867,
11326868,
11326869,
11326870,
11326871,
11326872,
11326873,
11326874,
11326875,
11326876,
11326877,
11326878,
11326879,
11326880,
11360178,
11360215,
11360216,
11360233,
11266692,
11266722,
11266723,
11266740,
11363214,
11363215,
11363216,
11363217,
11358761,
11358762,
11358763,
11358764,
11358765,
11358766,
11262983,
11262984,
11262985,
11262986,
11262987,
11262988,
11359951,
11359952,
11359953,
11360733,
11254388,
11254389,
11254390,
11254391,
11254392,
11254393,
11254394,
11254395,
11254396,
11254397,
11254398,
11254399,
11254400,
11254419,
11254420,
11254421,
11254422,
11254423,
11254424,
11254425,
11363712,
11363713,
11363714,
11363715,
11363716,
11363717,
11363718,
11363719,
11363720,
11363791,
11363792,
11363793,
11360958,
11360959,
11360960,
11360961,
11360962,
11360963,
11360964,
11360965,
11360966,
11360967,
11360968,
11360969,
11360970,
11360971,
11360972,
11360973,
11360974,
11360975,
11360976,
11360977,
11267297,
11267299,
11267371,
11267377,
11267383,
11267384,
11267385,
11267386,
11267387,
11267388,
11267389,
11267390,
11267391,
11267392,
11267393,
11267394,
11267395,
11267396,
11267397,
11267713,
11358769,
11358770,
11277886,
11277887,
11354829,
11354830,
11354831,
11354832,
11354833,
11354834,
11354835,
11354836,
11354837,
11354838,
11354839,
11354840,
11354841,
11354842,
11202540,
11202541,
11202542,
11202543,
11202544,
11202545,
11202546,
11202547,
11202548,
11202549,
11202550,
11202551,
11202552,
11202553,
11264095,
11264096,
11264097,
11264098,
11264099,
11264100,
11264101,
11264102,
11264103,
11264104,
11264105,
11264106,
11264107,
11264108,
11326440,
11326441,
11326442,
11326443,
11326444,
11326445,
11326446,
11326447,
11326448,
11326449,
11326450,
11326451,
11326452,
11326453,
11326454,
11326455,
11326456,
11326457,
11326458,
11326459,
11326460,
11326461,
11326462,
11326463,
11326464,
11326465,
11326466,
11326467,
11326468,
11326469,
11326470,
11326471,
11326472,
11326473,
11326474,
11326475,
11326476,
11326477,
11326478,
11326479,
11326480,
11326481,
11326482,
11326483,
11326484,
11326485,
11326486,
11326487,
11326488,
11326489,
11259587,
11259588,
11259589,
11259590,
11259591,
11259592,
11259593,
11259594,
11259595,
11259596,
11259597,
11259598,
11259599,
11259600,
11282799,
11282800,
11282801,
11282802,
11282803,
11282804,
11282805';	
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

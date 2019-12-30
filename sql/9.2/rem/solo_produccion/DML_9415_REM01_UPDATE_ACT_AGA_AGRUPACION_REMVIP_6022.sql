--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6022
--## PRODUCTO=NO
--## 
--## Finalidad: Script que deshace el borrado de la relación entre activos y agrupaciones
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');


V_SQL := ' 

MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
USING (

SELECT DISTINCT AGA_ID
FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO
WHERE ACT_ID IN (
                SELECT ACT_ID
                FROM '||V_ESQUEMA||'.ACT_ACTIVO
                WHERE 1 = 1
                
                AND ACT_NUM_ACTIVO_PRINEX IN
			(
                10515,                     
                10516,  
                10517,
                10518,
                10519,
                10520,
                10521,
                10538,
                10540,
                10541,
                10542,
                10543,
                10544,
                10545,
                10546,
                10547,
                10548,
                10549,
                10550,
                10551,
                10552,
                10553,
                10554,
                10555,
                10556,
                10557,
                10558,
                10559,
                10561,
                10562,
                10563,
                10564,
                10565,
                10566,
                10567,
                10568,
                10569,
                10570,
                10572,
                10573,
                10575,
                10576,
                10577,
                10578,
                10579,
                10580,
                10581,
                10582,
                10583,
                10584,
                10585,
                10586,
                10587,
                10588,
                10589,
                10590,
                10591,
                10592,
                10593,
                10594,
                10595,
                10596,                
                10597,
                10598,
                10599,
                10600,
                10601,
                10602,
                10603,
                10604,
                10605,
                10606,
                10607,
                10608,
                10609,
                10610,
                10611,
                10614,
                10615,
                10616,
                10617,
                10618,
                10619,
                10620,
                10621,
                10622,
                10623,
                10624,
                10625,
                10626,
                10627,
                10628,
                10629

			)
   )
AND BORRADO = 1
AND USUARIOBORRAR = ''ITREM-10490''
            
) AUX
ON ( AGA.AGA_ID = AUX.AGA_ID )
WHEN MATCHED THEN UPDATE SET
BORRADO = 0,
USUARIOMODIFICAR = ''REMVIP-6022'',
FECHAMODIFICAR = SYSDATE

' ;
				                       
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros');

        DBMS_OUTPUT.PUT_LINE('[FIN]');

    COMMIT;


   

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

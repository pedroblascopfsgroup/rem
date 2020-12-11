--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201209
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8469
--## PRODUCTO=NO
--## 
--## Finalidad: Reenviar gastos
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
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-8469';
   V_SQL VARCHAR2(4000 CHAR);	
   V_PAR VARCHAR( 3000 CHAR );
   V_RET VARCHAR( 3000 CHAR );  
  
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');

-----------------------------------------------------------------------------------------------------------------      

   V_PAR := '12336492,
   12333977,
   12305818,
   11395413,
   11295645,
   10910134,
   10910133,
   10895885,
   10895890,
   10895891,
   10874211,
   10874212,
   10874213,
   10874214,
   10874215,
   10874210,
   10786012,
   10605098,
   10601217,
   10601044,
   10601203,
   10578484,
   12474383,
   12474265,
   12464720,
   12464705,
   12464692,
   12464605,
   12431574,
   12428623,
   12348282,
   12336353,
   12336352,
   12336351,
   12330025,
   12329984,
   12311786,
   12283805,
   12274653,
   12274651,
   12274648,
   12274645,
   12271979,
   12271973,
   12271970,
   12271968,
   12271967,
   12271965,
   12271963,
   12271962,
   12271959,
   12271958,
   12271954,
   12271953,
   12271952,
   12271933,
   12271931,
   12271928,
   12271922,
   12271900,
   12271898,
   12271888,
   12256832,
   12256831,
   12256829,
   12256823,
   12256821,
   12256820,
   12256817,
   12244681,
   12240656,
   12204444,
   12148246,
   12134445,
   12129225,
   12072298,
   12045248,
   12039614,
   12033733,
   12029870,
   11984611,
   11984610,
   11984609,
   11984605,
   11984602,
   11984599,
   11984597,
   11984592,
   11984591,
   11984589,
   11984586,
   11984581,
   11984575,
   11980576,
   11295483';	

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
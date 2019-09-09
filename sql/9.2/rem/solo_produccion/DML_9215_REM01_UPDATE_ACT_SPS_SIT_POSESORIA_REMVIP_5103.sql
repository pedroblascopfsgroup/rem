--/*
--##########################################								
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20190826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5103
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-5103';

    
 BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO] ');


	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA
		   SET SPS_OCUPADO = 1,
    		   SPS_CON_TITULO = 0,
    		   USUARIOMODIFICAR = ''REMVIP-5103'',
    		   FECHAMODIFICAR = SYSDATE
		   WHERE ACT_ID IN ( SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO 
                 	 	     WHERE 1 = 1
                  		     AND ACT_NUM_ACTIVO IN (
								6850777	,
								6850971	,
								6851431	,
								6851476	,
								6851513	,
								6851532	,
								6851563	,
								6851564	,
								6851696	,
								6852234	,
								6852235	,
								6852279	,
								6852489	,
								6852789	,
								6852790	,
								6853126	,
								6853450	,
								6854662	,
								6854663	,
								6854664	,
								6855104	,
								6855141	,
								6855142	,
								6855143	,
								6855144	,
								6855146	,
								6855861	,
								6855862	,
								6856253	,
								6856254	,
								6856258	,
								6856495	,
								6856606	,
								6856623	,
								6856827	,
								6857038	,
								6857297	,
								6857838	,
								6858142	,
								6858249	,
								6858670	,
								6859091	,
								6859670	,
								6859760	,
								6860386	,
								6860503	,
								6860611	,
								6860702	,
								6860738	,
								6860802	,
								6860967	,
								6860968	,
								6860989	,
								6861115	,
								6861587	,
								6861762	,
								6861772	,
								6861922	,
								6861968	,
								6862595	,
								6862596	,
								6862597	,
								6862900	,
								6862952	,
								6863831	,
								6864566	,
								6869635	,
								6870063	,
								6870065	,
								6870066	,
								6870067	,
								6870068	,
								6870069	,
								6870167	,
								6870168	,
								6870256	,
								6870257	,
								6870258	,
								6870262	,
								6870590	,
								6870594	,
								6870816	,
								6870817	,
								6871464	,
								6871477	,
								6871524	,
								6871598	,
								6871809	,
								6871897	,
								6871898	,
								6871899	,
								6872047	,
								6872073	,
								6872421	,
								6872620	,
								6872661	,
								6872824	,
								6872825	,
								6872919	,
								6873044	,
								6873045	,
								6873058	,
								6873128	,
								6873280	,
								6873281	,
								6873358	,
								6873930	,
								6874082	,
								6874083	,
								6874085	,
								6874822	,
								6876054	,
								6876213	,
								6877305	,
								6877535	,
								6878362	,
								6879726	,
								6879777	,
								6881201	,
								6882436	,
								6883102	,
								6883503	,
								6883504	,
								6884156	,
								6884157	,
								6884640	,
								6884952	,
								6935281	,
								6935283	,
								6935303	,
								6935308	,
								6935315	,
								6935316	,
								6935347	,
								6935366	,
								6947748	,
								6947914	,
								6948572	,
								6948689	,
								6948935	,
								6948939	,
								6949167	,
								6949435	,
								6949436	,
								6966743	,
								7007856	,
								7009711	,
								7009776	,
								7011868	,
								7011869	,
								7011870	,
								7030468	,
								7031662	,
								7068171	,
								7068771	,
								7072344	,
								7072576	,
								7073106	,
								7073148	,
								7075407	,
								7075981	
				             )
				)
				AND SPS_OCUPADO = 0
';

	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MERGEADOS '||SQL%ROWCOUNT||' registros en ACT_SPS_SIT_POSESORIA ');  

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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

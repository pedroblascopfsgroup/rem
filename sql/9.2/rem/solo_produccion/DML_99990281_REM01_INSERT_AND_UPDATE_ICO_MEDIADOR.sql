--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-97
--## PRODUCTO=NO
--##
--## Finalidad: Insertar todas las oficinas de BMN
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
    V_COUNT_INSERT NUMBER(16) := 0;
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    --V_TABLA VARCHAR2(27 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    --V_TABLA2 VARCHAR2(32 CHAR) := 'DD_TPR_TIPO_PROVEEDOR';
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-443';
	ACT_ID NUMBER(16);
	
	TYPE T_JBV IS TABLE OF VARCHAR2(32000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
		V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV(74966)
	, T_JBV(75085)
	, T_JBV(75017)
	, T_JBV(75022)
	, T_JBV(75013)
	, T_JBV(74860)
	, T_JBV(74758)
	, T_JBV(264314)
	, T_JBV(74986)
	, T_JBV(74770)
	, T_JBV(74960)
	, T_JBV(74989)
	, T_JBV(74846)
	, T_JBV(75018)
	, T_JBV(75082)
	, T_JBV(75071)
	, T_JBV(74996)
	, T_JBV(74741)
	, T_JBV(74781)
	, T_JBV(75027)
	, T_JBV(74983)
	, T_JBV(74847)
	, T_JBV(74980)
	, T_JBV(75062)
	, T_JBV(74790)
	, T_JBV(74867)
	, T_JBV(74784)
	, T_JBV(74866)
	, T_JBV(75063)
	, T_JBV(74962)
	, T_JBV(264248)
	, T_JBV(75038)
	, T_JBV(74743)
	, T_JBV(74756)
	, T_JBV(74934)
	, T_JBV(74993)
	, T_JBV(75076)
	, T_JBV(74992)
	, T_JBV(75070)
	, T_JBV(74998)
	, T_JBV(74768)
	, T_JBV(75066)
	, T_JBV(74745)
	, T_JBV(75031)
	, T_JBV(75086)
	, T_JBV(74987)
	, T_JBV(74787)
	, T_JBV(75083)
	, T_JBV(74958)
	, T_JBV(75080)
	, T_JBV(74883)
	, T_JBV(74740)
	, T_JBV(74976)
	, T_JBV(75007)
	, T_JBV(75067)
	, T_JBV(74785)
	, T_JBV(74995)
	, T_JBV(74792)
	, T_JBV(74972)
	, T_JBV(74780)
	, T_JBV(264330)
	, T_JBV(74978)
	, T_JBV(74877)
	, T_JBV(74988)
	, T_JBV(75009)
	, T_JBV(74771)
	, T_JBV(75015)
	, T_JBV(75029)
	, T_JBV(75078)
	, T_JBV(74982)
	, T_JBV(75024)
	, T_JBV(74742)
	, T_JBV(74985)
	, T_JBV(75026)
	, T_JBV(75021)
	, T_JBV(264265)
	, T_JBV(74967)
	, T_JBV(75030)
	, T_JBV(74964)
	, T_JBV(74744)
	, T_JBV(74763)
	, T_JBV(74968)
	, T_JBV(74970)
	, T_JBV(74775)
	, T_JBV(74971)
	, T_JBV(75002)
	, T_JBV(75016)
	, T_JBV(75061)
	, T_JBV(74859)
	, T_JBV(74931)
	, T_JBV(74991)
	, T_JBV(74961)
	, T_JBV(74760)
	, T_JBV(75012)
	, T_JBV(74997)
	, T_JBV(75059)
	, T_JBV(246520)
	, T_JBV(74783)
	, T_JBV(74789)
	, T_JBV(75074)
	, T_JBV(75064)
	, T_JBV(74766)
	, T_JBV(74786)
	, T_JBV(74746)
	, T_JBV(74769)
	, T_JBV(74759)
	, T_JBV(74776)
	, T_JBV(74975)
	, T_JBV(75058)
	, T_JBV(74750)
	, T_JBV(74819)
	, T_JBV(264271)
	, T_JBV(75014)
	, T_JBV(74981)
	, T_JBV(74990)
	, T_JBV(75011)
	, T_JBV(74767)
	, T_JBV(75005)
	, T_JBV(260434)
	, T_JBV(74999)
	, T_JBV(74974)
	, T_JBV(75028)
	, T_JBV(74754)
	, T_JBV(74850)
	, T_JBV(75039)
	, T_JBV(74969)
	, T_JBV(74963)
	, T_JBV(74845)
	, T_JBV(75008)
	, T_JBV(75003)
	, T_JBV(74965)
	, T_JBV(75068)
	, T_JBV(74904)
	, T_JBV(75020)
	, T_JBV(75001)
	, T_JBV(74772)
	, T_JBV(74979)
	, T_JBV(75023)
	, T_JBV(74761)
	, T_JBV(74863)
	, T_JBV(74762)
	, T_JBV(75060)
	, T_JBV(75077)
);
V_TMP_JBV T_JBV;
	
    
 BEGIN
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  ACT_ID	:= TRIM(V_TMP_JBV(1));
			  
			  EXECUTE IMMEDIATE 'INSERT INTO REM01.ACT_ICO_INFO_COMERCIAL (ICO_ID
								,ACT_ID
								,USUARIOCREAR
								,FECHACREAR
								) VALUES 
								(
								REM01.S_ACT_ICO_INFO_COMERCIAL.NEXTVAL,
								'''||ACT_ID||''',
								'''||V_USUARIO||''',
								SYSDATE
								)
								'; 			  

		  V_COUNT_INSERT := V_COUNT_INSERT + 1;
 END LOOP;

 DBMS_OUTPUT.PUT_LINE('Se han insertado '||V_COUNT_INSERT||' registros en la tabla ACT_ICO_INFO_COMERCIAL');


	EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_ICO_INFO_COMERCIAL T1 USING (

						SELECT ICO_ID, ICM.ICO_MEDIADOR_ID FROM REM01.ACT_ICO_INFO_COMERCIAL ICO
						JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
						JOIN REM01.ACT_ICM_INF_COMER_HIST_MEDI ICM ON ICM.ACT_ID = ACT.ACT_ID
						WHERE ICM.ICM_FECHA_HASTA IS NULL AND ICO.ICO_MEDIADOR_ID IS NULL

						) T2 ON (T1.ICO_ID = T2.ICO_ID)
						WHEN MATCHED THEN UPDATE SET
						T1.ICO_MEDIADOR_ID = T2.ICO_MEDIADOR_ID
					  ';
 
  DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_ICO_INFO_COMERCIAL');

 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;


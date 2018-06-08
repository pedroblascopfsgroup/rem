--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-995
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-995';

	ACT_NUM_ACTIVO VARCHAR2(55 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(934149)
		, T_JBV(945541)
		, T_JBV(940780)
		, T_JBV(941679)
		, T_JBV(940541)
		, T_JBV(939173)
		, T_JBV(935117)
		, T_JBV(941178)
		, T_JBV(936251)
		, T_JBV(942192)
		, T_JBV(944106)
		, T_JBV(935725)
		, T_JBV(940052)
		, T_JBV(940576)
		, T_JBV(935010)
		, T_JBV(941382)
		, T_JBV(938290)
		, T_JBV(943640)
		, T_JBV(942705)
		, T_JBV(943674)
		, T_JBV(939112)
		, T_JBV(935712)
		, T_JBV(936086)
		, T_JBV(945221)
		, T_JBV(937177)
		, T_JBV(938050)
		, T_JBV(940160)
		, T_JBV(944334)
		, T_JBV(943899)
		, T_JBV(940806)
		, T_JBV(934761)
		, T_JBV(934000)
		, T_JBV(944995)
		, T_JBV(939997)
		, T_JBV(934977)
		, T_JBV(944087)
		, T_JBV(933674)
		, T_JBV(940775)
		, T_JBV(940872)
		, T_JBV(939984)
		, T_JBV(944713)
		, T_JBV(939865)
		, T_JBV(933625)
		, T_JBV(934641)
		, T_JBV(940533)
		, T_JBV(937900)
		, T_JBV(938842)
		, T_JBV(941375)
		, T_JBV(941033)
		, T_JBV(945068)
		, T_JBV(943582)
		, T_JBV(937748)
		, T_JBV(940398)
		, T_JBV(936214)
		, T_JBV(939601)
		, T_JBV(939289)
		, T_JBV(940795)
		, T_JBV(943522)
		, T_JBV(936750)
		, T_JBV(941893)
		, T_JBV(942123)
		, T_JBV(944841)
		, T_JBV(944080)
		, T_JBV(945576)
		, T_JBV(943289)
		, T_JBV(944333)
		, T_JBV(938283)
		, T_JBV(935601)
		, T_JBV(939687)
		, T_JBV(937079)
		, T_JBV(945086)
		, T_JBV(945418)
		, T_JBV(935443)
		, T_JBV(935209)
		, T_JBV(944757)
		, T_JBV(938668)
		, T_JBV(936899)
		, T_JBV(938052)
		, T_JBV(941700)
		, T_JBV(941431)
		, T_JBV(948184)
		, T_JBV(948297)
		, T_JBV(948341)
		, T_JBV(948295)
		, T_JBV(948101)
		, T_JBV(948216)
		, T_JBV(948127)
		, T_JBV(948291)
		, T_JBV(948138)
		, T_JBV(948218)
		, T_JBV(948084)
		, T_JBV(948242)
		, T_JBV(948285)
		, T_JBV(948258)
		, T_JBV(948245)
		, T_JBV(948120)
		, T_JBV(948287)
		, T_JBV(948103)
		, T_JBV(948263)
		, T_JBV(948082)
		, T_JBV(948169)
		, T_JBV(948074)
		, T_JBV(948102)
		, T_JBV(948354)
		, T_JBV(948328)
		, T_JBV(948271)
		, T_JBV(948208)
		, T_JBV(948357)
		, T_JBV(948144)
		, T_JBV(948076)
		, T_JBV(948244)
		, T_JBV(948118)
		, T_JBV(948334)
		, T_JBV(948299)
		, T_JBV(948106)
		, T_JBV(948315)
		, T_JBV(948309)
		, T_JBV(948156)
		, T_JBV(948286)
		, T_JBV(948200)
		, T_JBV(948236)
		, T_JBV(948279)
		, T_JBV(948180)
		, T_JBV(948152)
		, T_JBV(948119)
		, T_JBV(948273)
		, T_JBV(948250)
		, T_JBV(948128)
		, T_JBV(948117)
		, T_JBV(948232)
		, T_JBV(948227)
		, T_JBV(948124)
		, T_JBV(948330)
		, T_JBV(948203)
		, T_JBV(948079)
		, T_JBV(948276)
		, T_JBV(948351)
		, T_JBV(948114)
		, T_JBV(948248)
		, T_JBV(948226)
		, T_JBV(948313)
		, T_JBV(948075)
		, T_JBV(948166)
		, T_JBV(948202)
		, T_JBV(948249)
		, T_JBV(948133)
		, T_JBV(948173)
		, T_JBV(948123)
		, T_JBV(948113)
		, T_JBV(948125)
		, T_JBV(948085)
		, T_JBV(948177)
		, T_JBV(948192)
		, T_JBV(948160)
		, T_JBV(948130)
		, T_JBV(948355)
		, T_JBV(948215)
		, T_JBV(948252)
		, T_JBV(948356)
		, T_JBV(948342)
		, T_JBV(948345)
		, T_JBV(948155)
		, T_JBV(948171)
		, T_JBV(948112)
		, T_JBV(948234)
		, T_JBV(948333)
		, T_JBV(948235)
		, T_JBV(948163)
		, T_JBV(948335)
		, T_JBV(948323)
		, T_JBV(948278)
		, T_JBV(948196)
		, T_JBV(948172)
		, T_JBV(948213)
		, T_JBV(948204)
		, T_JBV(948282)
		, T_JBV(948238)
		, T_JBV(948210)
		, T_JBV(948083)
		, T_JBV(948126)
		, T_JBV(948206)
		, T_JBV(948265)
		, T_JBV(948176)
		, T_JBV(948107)
		, T_JBV(948253)
		, T_JBV(948092)
		, T_JBV(948298)
		, T_JBV(948310)
		, T_JBV(948188)
		, T_JBV(948289)
		, T_JBV(948207)
		, T_JBV(948197)
		, T_JBV(948080)
		, T_JBV(948190)
		, T_JBV(948187)
		, T_JBV(948077)
		, T_JBV(948175)
		, T_JBV(948277)
		, T_JBV(948358)
		, T_JBV(948344)
		, T_JBV(948329)
		, T_JBV(948151)
		, T_JBV(948308)
		, T_JBV(948255)
		, T_JBV(948137)
		, T_JBV(948281)
		, T_JBV(948132)
		, T_JBV(948091)
		, T_JBV(948327)
		, T_JBV(948318)
		, T_JBV(948142)
		, T_JBV(948307)
		, T_JBV(948221)
		, T_JBV(948257)
		, T_JBV(948332)
		, T_JBV(948134)
		, T_JBV(948098)
		, T_JBV(948246)
		, T_JBV(948086)
		, T_JBV(948154)
		, T_JBV(948241)
		, T_JBV(948131)
		, T_JBV(948110)
		, T_JBV(948280)
		, T_JBV(948158)
		, T_JBV(948115)
		, T_JBV(948314)
		, T_JBV(948352)
		, T_JBV(948205)
		, T_JBV(948174)
		, T_JBV(948122)
		, T_JBV(948283)
		, T_JBV(948195)
		, T_JBV(948340)
		, T_JBV(948343)
		, T_JBV(948209)
		, T_JBV(948288)
		, T_JBV(134358)
		, T_JBV(134247)
		, T_JBV(139692)
		, T_JBV(134359)
		, T_JBV(147479)
		, T_JBV(134357)
		, T_JBV(147082)
		, T_JBV(134164)
		, T_JBV(147130)
		, T_JBV(134572)
		, T_JBV(134245)
		, T_JBV(157537)
		, T_JBV(139998)
		, T_JBV(134573)
		, T_JBV(134169)
		, T_JBV(157281)
		, T_JBV(147478)
		, T_JBV(157978)
		, T_JBV(134165)
		, T_JBV(134570)
		, T_JBV(146963)
		, T_JBV(134246)
		, T_JBV(147189)
		, T_JBV(134571)
		, T_JBV(134354)
		, T_JBV(147477)
		, T_JBV(147131)
		, T_JBV(157538)
		, T_JBV(157539)
		, T_JBV(134356)
		, T_JBV(134355)
		, T_JBV(139844)
		, T_JBV(157979)
		, T_JBV(147129)
		, T_JBV(157280)
		, T_JBV(139997)
		, T_JBV(139876)
		, T_JBV(157282)
		, T_JBV(134167)
		, T_JBV(139767)
		, T_JBV(139810)
		, T_JBV(133931)
		, T_JBV(157367)
		, T_JBV(139690)
		, T_JBV(139987)
		, T_JBV(134566)
		, T_JBV(147116)
		, T_JBV(147452)
		, T_JBV(157386)
		, T_JBV(139678)
		, T_JBV(134189)
		, T_JBV(133998)
		, T_JBV(146844)
		, T_JBV(147475)
		, T_JBV(147451)
		, T_JBV(134240)
		, T_JBV(147470)
		, T_JBV(157261)
		, T_JBV(139992)
		, T_JBV(157566)
		, T_JBV(134564)
		, T_JBV(147459)
		, T_JBV(157254)
		, T_JBV(134469)
		, T_JBV(133985)
		, T_JBV(157368)
		, T_JBV(134558)
		, T_JBV(147186)
		, T_JBV(157256)
		, T_JBV(133825)
		, T_JBV(146913)
		, T_JBV(139988)
		, T_JBV(133984)
		, T_JBV(157273)
		, T_JBV(134000)
		, T_JBV(157332)
		, T_JBV(157817)
		, T_JBV(147185)
		, T_JBV(146854)
		, T_JBV(147469)
		, T_JBV(146812)
		, T_JBV(147188)
		, T_JBV(146801)
		, T_JBV(139990)
		, T_JBV(134186)
		, T_JBV(157965)
		, T_JBV(134175)
		, T_JBV(139931)
		, T_JBV(157334)
		, T_JBV(157372)
		, T_JBV(133989)
		, T_JBV(157331)
		, T_JBV(146862)
		, T_JBV(157568)
		, T_JBV(139624)
		, T_JBV(133999)
		, T_JBV(157387)
		, T_JBV(157571)
		, T_JBV(146808)
		, T_JBV(134478)
		, T_JBV(146746)
		, T_JBV(147450)
		, T_JBV(134171)
		, T_JBV(157272)
		, T_JBV(139840)
		, T_JBV(139689)
		, T_JBV(139668)
		, T_JBV(157974)
		, T_JBV(146751)
		, T_JBV(134179)
		, T_JBV(146798)
		, T_JBV(157046)
		, T_JBV(157278)
		, T_JBV(134162)
		, T_JBV(146845)
		, T_JBV(147182)
		, T_JBV(157975)
		, T_JBV(157822)
		, T_JBV(140222)
		, T_JBV(157371)
		, T_JBV(133978)
		, T_JBV(942430)
		, T_JBV(943223)
		, T_JBV(948161)
		, T_JBV(948217)
		, T_JBV(948179)
		, T_JBV(948240)
		, T_JBV(948247)
		, T_JBV(139845)
		, T_JBV(157534)
		, T_JBV(134353)
		, T_JBV(157279)
		, T_JBV(157373)
		, T_JBV(146923)
		, T_JBV(146755)
		, T_JBV(146800)
		, T_JBV(134545)
	); 
V_TMP_JBV T_JBV;
BEGIN


 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
			
	

		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
					 DD_EPU_ID = (SELECT DD_EPU_ID FROM '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION WHERE DD_EPU_CODIGO = ''03'')
				   , USUARIOMODIFICAR = '''||V_USUARIO||'''
				   , FECHAMODIFICAR = SYSDATE
				   WHERE ACT_NUM_ACTIVO = '''||ACT_NUM_ACTIVO||'''
					';
		EXECUTE IMMEDIATE V_SQL;
		
		IF SQL%ROWCOUNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('Puesto el estado de publicación a Publicado oculto del activo con ID_HAYA = '||ACT_NUM_ACTIVO);
					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				END IF;
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION SET
				     USUARIOMODIFICAR = '''||V_USUARIO||'''
				   , FECHAMODIFICAR = SYSDATE
				   , HEP_FECHA_HASTA = SYSDATE
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
				   AND HEP_FECHA_HASTA IS NULL
					';
		EXECUTE IMMEDIATE V_SQL;
		
		IF SQL%ROWCOUNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('Puesta la fecha hasta a SYSDATE del activo con ID_HAYA = '||ACT_NUM_ACTIVO);
					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				END IF;
		
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION (
					  HEP_ID
					, ACT_ID
					, HEP_FECHA_DESDE
					, DD_POR_ID
					, DD_TPU_ID
					, DD_EPU_ID
					, HEP_MOTIVO
					, USUARIOCREAR
					, FECHACREAR
					) VALUES (
					  '||V_ESQUEMA||'.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL
					, (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')					
					, SYSDATE
					, (SELECT DD_POR_ID FROM '||V_ESQUEMA||'.DD_POR_PORTAL WHERE DD_POR_CODIGO = ''01'')
					, (SELECT DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION WHERE DD_TPU_CODIGO = ''02'')
					, (SELECT DD_EPU_ID FROM '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION WHERE DD_EPU_CODIGO = ''03'')
					, ''Petición Sareb''
					, '''||V_USUARIO||'''
					, SYSDATE
					)
					';
           
				EXECUTE IMMEDIATE V_SQL;
			
				
				IF SQL%ROWCOUNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('Insertado el nuevo estado de publicación del activo con ID_HAYA = '||ACT_NUM_ACTIVO);
					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				END IF;
 END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se hecho en total '||V_COUNT_UPDATE||' updates/inserts');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

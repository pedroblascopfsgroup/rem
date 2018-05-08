--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180508
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-675
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'USU_USUARIOS';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-675';

	USU_USERNAME VARCHAR2(55 CHAR);
	USU_PASSWORD VARCHAR2(55 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			  T_JBV('A027805','MBAGSDVHZZ')
			, T_JBV('A107592','LYLDSVTNEB')
			, T_JBV('A110337','GLTDNGQJBR')
			, T_JBV('A111180','IMOMKNQAXM')
			, T_JBV('A112826','GXYZWLISHY')
			, T_JBV('A126422','YNGCWAHRPT')
			, T_JBV('A127543','VEUNMVMBEP')
			, T_JBV('A133647','HZLCBDWBVV')
			, T_JBV('A135765','EPWIUFNWDZ')
			, T_JBV('A139372','HLFRATTKBB')
			, T_JBV('A143884','APSSAZQDDS')
			, T_JBV('A146460','WMHMCPKIKP')
			, T_JBV('A153731','VTNJHHSEMC')
			, T_JBV('A154057','EXROOFPNLY')
			, T_JBV('A154454','YJIKMJBPAK')
			, T_JBV('A184225','IPDOKHXLXM')
			, T_JBV('aarias','CVAVHKRWZN')
			, T_JBV('acotarelo','OISSAHDOYH')
			, T_JBV('aencarnacion','SBUQRPFPZL')
			, T_JBV('agarciaar','SRILTFUZHL')
			, T_JBV('ahernandezg','XPXSDIXHDJ')
			, T_JBV('asarmiento','PQNSDTKFKH')
			, T_JBV('bpacheco','WJOHZHOMSH')
			, T_JBV('cbarrosh','TBDWAVKSXU')
			, T_JBV('chidalgo','YUFNEVLSRD')
			, T_JBV('cmoran','MQJVTWXLFV')
			, T_JBV('cmurillo','QRIGFQLXKA')
			, T_JBV('dcruz','NIAPUAEZAQ')
			, T_JBV('egonzalezv','LADBCMXAIF')
			, T_JBV('eruiz','RAJFBELQKP')
			, T_JBV('fvallejos','VZARTGROVT')
			, T_JBV('jcalatayuda','NIMIXSDGHO')
			, T_JBV('jgarciato','VCYUGPMLGE')
			, T_JBV('jmeijon','QAYAIFHUQX')
			, T_JBV('jponte','FLJUNOTNMI')
			, T_JBV('ksanz','SGTIJBONCZ')
			, T_JBV('ladalberto','LHPUUVNUCO')
			, T_JBV('mandres','QJRRIJRRHS')
			, T_JBV('mcorona','XESZNZCNNK')
			, T_JBV('mcorrales','ETCFRZHXPQ')
			, T_JBV('mdejulio','CJWDAAQKZQ')
			, T_JBV('mfranco','UMRUZZHRHH')
			, T_JBV('mgarciame','GSNFTHJZOY')
			, T_JBV('mgomezch','ATADWYFIJN')
			, T_JBV('mmarrero','QWZFFDTJXZ')
			, T_JBV('mmerino','HNQDVWRFDP')
			, T_JBV('ngarcias','ZQEAUQKWDJ')
			, T_JBV('nllano','NXOHNMWHOR')
			, T_JBV('palonsom','GRMFBWQRJZ')
			, T_JBV('rdregorio','NEZONLNKCJ')
			, T_JBV('salzolav','NGHMGVANKK')
			, T_JBV('sval','NYWPUANURE')
			, T_JBV('vherrera','PYBDXBJCRP')
			, T_JBV('vmarin','VJNWDNMMSL')
			, T_JBV('acarabal','GDPGPIENIF')
			, T_JBV('amanzanob','PDIDMKIROX')
			, T_JBV('dvicentep','LVWXGQLJCN')
			, T_JBV('eluque','LUYGKFGGQG')
			, T_JBV('lclaret','GZFZTIUVNR')
			, T_JBV('mgarciaarr','KXIPJNUAPS')
			, T_JBV('omora','VQHHMAIOJD')
			, T_JBV('mroque','QPQTXEERTT')	
	); 
V_TMP_JBV T_JBV;
BEGIN


 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  USU_USERNAME := TRIM(V_TMP_JBV(1));
 			  USU_PASSWORD := TRIM(V_TMP_JBV(2));
			
	

		V_SQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TABLA||' SET
					 USU_PASSWORD = '''||USU_PASSWORD||'''
				   , USUARIOMODIFICAR = '''||V_USUARIO||'''
				   , FECHAMODIFICAR = SYSDATE
				   WHERE USU_USERNAME = '''||USU_USERNAME||'''
					';
           

				EXECUTE IMMEDIATE V_SQL;
				
				IF SQL%ROWCOUNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('Actualizada la contraseña del usuario '||USU_USERNAME||' a '||USU_PASSWORD);
					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				END IF;
 END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||V_COUNT_UPDATE||' contraseñas');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

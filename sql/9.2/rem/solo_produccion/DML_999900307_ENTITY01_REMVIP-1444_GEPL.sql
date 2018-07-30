--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180726
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1444
--## PRODUCTO=SI
--## Finalidad: Insertar gestor de publicaciones a los activos SAREB que no tienen
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA_GEE VARCHAR2(50 CHAR) := 'GEE_GESTOR_ENTIDAD';
    V_TABLA_GAC VARCHAR2(50 CHAR) := 'GAC_GESTOR_ADD_ACTIVO';
    V_TABLA_GEH VARCHAR2(50 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST';
    V_TABLA_GAH VARCHAR2(50 CHAR) := 'GAH_GESTOR_ACTIVO_HISTORICO';
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1444';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_ID NUMBER;
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    
    TYPE T_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				T_DATA(73866),
				T_DATA(73947),
				T_DATA(73992),
				T_DATA(74000),
				T_DATA(74037),
				T_DATA(74075),
				T_DATA(74088),
				T_DATA(74101),
				T_DATA(74128),
				T_DATA(74166),
				T_DATA(74182),
				T_DATA(74192),
				T_DATA(74204),
				T_DATA(74211),
				T_DATA(74259),
				T_DATA(74276),
				T_DATA(74369),
				T_DATA(74387),
				T_DATA(74397),
				T_DATA(74399),
				T_DATA(74434),
				T_DATA(74466),
				T_DATA(74738),
				T_DATA(74739),
				T_DATA(74740),
				T_DATA(74741),
				T_DATA(74742),
				T_DATA(74743),
				T_DATA(74744),
				T_DATA(74745),
				T_DATA(74746),
				T_DATA(74747),
				T_DATA(74748),
				T_DATA(74749),
				T_DATA(74750),
				T_DATA(74751),
				T_DATA(74752),
				T_DATA(74753),
				T_DATA(74754),
				T_DATA(74755),
				T_DATA(74756),
				T_DATA(74757),
				T_DATA(74758),
				T_DATA(74759),
				T_DATA(74760),
				T_DATA(74761),
				T_DATA(74762),
				T_DATA(74763),
				T_DATA(74764),
				T_DATA(74765),
				T_DATA(74766),
				T_DATA(74767),
				T_DATA(74768),
				T_DATA(74769),
				T_DATA(74770),
				T_DATA(74771),
				T_DATA(74772),
				T_DATA(74774),
				T_DATA(74775),
				T_DATA(74776),
				T_DATA(74777),
				T_DATA(74778),
				T_DATA(74779),
				T_DATA(74780),
				T_DATA(74781),
				T_DATA(74782),
				T_DATA(74783),
				T_DATA(74784),
				T_DATA(74785),
				T_DATA(74786),
				T_DATA(74787),
				T_DATA(74788),
				T_DATA(74789),
				T_DATA(74790),
				T_DATA(74791),
				T_DATA(74792),
				T_DATA(74793),
				T_DATA(74798),
				T_DATA(74819),
				T_DATA(74820),
				T_DATA(74821),
				T_DATA(74822),
				T_DATA(74823),
				T_DATA(74824),
				T_DATA(74825),
				T_DATA(74826),
				T_DATA(74827),
				T_DATA(74828),
				T_DATA(74829),
				T_DATA(74830),
				T_DATA(74831),
				T_DATA(74832),
				T_DATA(74833),
				T_DATA(74834),
				T_DATA(74835),
				T_DATA(74836),
				T_DATA(74837),
				T_DATA(74838),
				T_DATA(74839),
				T_DATA(74840),
				T_DATA(74841),
				T_DATA(74842),
				T_DATA(74843),
				T_DATA(74844),
				T_DATA(74845),
				T_DATA(74846),
				T_DATA(74847),
				T_DATA(74848),
				T_DATA(74849),
				T_DATA(74850),
				T_DATA(74851),
				T_DATA(74852),
				T_DATA(74853),
				T_DATA(74854),
				T_DATA(74855),
				T_DATA(74856),
				T_DATA(74857),
				T_DATA(74858),
				T_DATA(74859),
				T_DATA(74860),
				T_DATA(74861),
				T_DATA(74862),
				T_DATA(74863),
				T_DATA(74864),
				T_DATA(74865),
				T_DATA(74866),
				T_DATA(74867),
				T_DATA(74868),
				T_DATA(74869),
				T_DATA(74870),
				T_DATA(74871),
				T_DATA(74872),
				T_DATA(74873),
				T_DATA(74874),
				T_DATA(74875),
				T_DATA(74876),
				T_DATA(74877),
				T_DATA(74878),
				T_DATA(74879),
				T_DATA(74880),
				T_DATA(74881),
				T_DATA(74882),
				T_DATA(74883),
				T_DATA(74898),
				T_DATA(74899),
				T_DATA(74901),
				T_DATA(74902),
				T_DATA(74903),
				T_DATA(74904),
				T_DATA(74905),
				T_DATA(74906),
				T_DATA(74907),
				T_DATA(74908),
				T_DATA(74909),
				T_DATA(74910),
				T_DATA(74911),
				T_DATA(74912),
				T_DATA(74913),
				T_DATA(74914),
				T_DATA(74915),
				T_DATA(74916),
				T_DATA(74917),
				T_DATA(74918),
				T_DATA(74919),
				T_DATA(74920),
				T_DATA(74921),
				T_DATA(74922),
				T_DATA(74923),
				T_DATA(74924),
				T_DATA(74925),
				T_DATA(74926),
				T_DATA(74927),
				T_DATA(74928),
				T_DATA(74929),
				T_DATA(74930),
				T_DATA(74931),
				T_DATA(74932),
				T_DATA(74933),
				T_DATA(74934),
				T_DATA(74935),
				T_DATA(74936),
				T_DATA(74937),
				T_DATA(74938),
				T_DATA(74939),
				T_DATA(74940),
				T_DATA(74941),
				T_DATA(74942),
				T_DATA(74943),
				T_DATA(74944),
				T_DATA(74945),
				T_DATA(74946),
				T_DATA(74947),
				T_DATA(74948),
				T_DATA(74949),
				T_DATA(74950),
				T_DATA(74951),
				T_DATA(74958),
				T_DATA(74959),
				T_DATA(74960),
				T_DATA(74961),
				T_DATA(74962),
				T_DATA(74963),
				T_DATA(74964),
				T_DATA(74965),
				T_DATA(74966),
				T_DATA(74967),
				T_DATA(74968),
				T_DATA(74969),
				T_DATA(74970),
				T_DATA(74971),
				T_DATA(74972),
				T_DATA(74973),
				T_DATA(74974),
				T_DATA(74975),
				T_DATA(74976),
				T_DATA(74977),
				T_DATA(74978),
				T_DATA(74979),
				T_DATA(74980),
				T_DATA(74981),
				T_DATA(74982),
				T_DATA(74983),
				T_DATA(74984),
				T_DATA(74985),
				T_DATA(74986),
				T_DATA(74987),
				T_DATA(74988),
				T_DATA(74989),
				T_DATA(74990),
				T_DATA(74991),
				T_DATA(74992),
				T_DATA(74993),
				T_DATA(74994),
				T_DATA(74995),
				T_DATA(74996),
				T_DATA(74997),
				T_DATA(74998),
				T_DATA(74999),
				T_DATA(75000),
				T_DATA(75001),
				T_DATA(75002),
				T_DATA(75003),
				T_DATA(75004),
				T_DATA(75005),
				T_DATA(75006),
				T_DATA(75007),
				T_DATA(75008),
				T_DATA(75009),
				T_DATA(75010),
				T_DATA(75011),
				T_DATA(75012),
				T_DATA(75013),
				T_DATA(75014),
				T_DATA(75015),
				T_DATA(75016),
				T_DATA(75017),
				T_DATA(75018),
				T_DATA(75019),
				T_DATA(75020),
				T_DATA(75021),
				T_DATA(75022),
				T_DATA(75023),
				T_DATA(75024),
				T_DATA(75025),
				T_DATA(75026),
				T_DATA(75027),
				T_DATA(75028),
				T_DATA(75029),
				T_DATA(75030),
				T_DATA(75031),
				T_DATA(75038),
				T_DATA(75039),
				T_DATA(75058),
				T_DATA(75059),
				T_DATA(75060),
				T_DATA(75061),
				T_DATA(75062),
				T_DATA(75063),
				T_DATA(75064),
				T_DATA(75065),
				T_DATA(75066),
				T_DATA(75067),
				T_DATA(75068),
				T_DATA(75069),
				T_DATA(75070),
				T_DATA(75071),
				T_DATA(75072),
				T_DATA(75073),
				T_DATA(75074),
				T_DATA(75075),
				T_DATA(75076),
				T_DATA(75077),
				T_DATA(75078),
				T_DATA(75079),
				T_DATA(75080),
				T_DATA(75081),
				T_DATA(75082),
				T_DATA(75083),
				T_DATA(75084),
				T_DATA(75085),
				T_DATA(75086),
				T_DATA(75087),
				T_DATA(75088),
				T_DATA(75098),
				T_DATA(75118),
				T_DATA(75119)            
    );
    
    V_TMP_TIPO_DATA T_DATA;
    
    BEGIN
	    
	    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    --LOOP del ARRAY
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
	    
	    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	    
	    V_SQL := 'SELECT '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL FROM DUAL';
	    EXECUTE IMMEDIATE V_SQL INTO V_ID;
	    
	    
	    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GEE||' (
			GEE_ID,
			USU_ID,
			DD_TGE_ID,
			USUARIOCREAR,
			FECHACREAR	    
	    )
		VALUES(
			'||V_ID||',
			30174,
			392,
			'''||V_USUARIO||''',
			SYSDATE
			)';
	    
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.put_line('INSERTADOS REGISTROS '||SQL%ROWCOUNT||'EN GEE_GESTOR_ENTIDAD');
	    
	    
	    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GAC||' (
				GEE_ID,
				ACT_ID
		)
				VALUES(
				'||V_ID||',
				'||V_TMP_TIPO_DATA(1)||'
				)
		';   
	  
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.put_line('INSERTADOS REGISTROS '||SQL%ROWCOUNT||'EN GAC_GESTOR_ADD_ACTIVO');
		
		
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_ID;
		
		
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GEH||' (
			GEH_ID,
			USU_ID,
			DD_TGE_ID,
			GEH_FECHA_DESDE,
			USUARIOCREAR,
			FECHACREAR
		)
		VALUES(
			'||V_ID||',
			30174,
			392,
			SYSDATE,
			'''||V_USUARIO||''',
			SYSDATE
			)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.put_line('INSERTADOS REGISTROS '||SQL%ROWCOUNT||'EN GEH_GESTOR_ENTIDAD_HIST');
		
		
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GAH||' (
			GEH_ID,
			ACT_ID
		) VALUES(
			'||V_ID||',
			'||V_TMP_TIPO_DATA(1)||'
		)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.put_line('INSERTADOS REGISTROS '||SQL%ROWCOUNT||'EN GAH_GESTOR_ACTIVO_HISTORICO');
		
		
		END LOOP;
		
    ROLLBACK;
     DBMS_OUTPUT.PUT_LINE('[FIN] - COMMIT ');
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

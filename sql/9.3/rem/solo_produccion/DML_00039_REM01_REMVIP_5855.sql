--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5855
--## PRODUCTO=NO
--## Finalidad: DML
--##      
--## INSTRUCCIONES:
--## VERSIONES:
--##
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
 
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    COD_MEDIADOR_REM NUMBER(16);
	V_COUNT NUMBER(25);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
V_JBV T_ARRAY_JBV := T_ARRAY_JBV( 
-- ="T_JBV("&COLUMNA&"),"
T_JBV(1785),
T_JBV(110161850),
T_JBV(7121),
T_JBV(10004312),
T_JBV(110115323),
T_JBV(1326),
T_JBV(3355),
T_JBV(116),
T_JBV(13051),
T_JBV(11503),
T_JBV(99),
T_JBV(110116755),
T_JBV(13150),
T_JBV(6602),
T_JBV(3379),
T_JBV(110082627),
T_JBV(11807),
T_JBV(3277),
T_JBV(9990128),
T_JBV(6749),
T_JBV(2303),
T_JBV(3471),
T_JBV(9990151),
T_JBV(10404),
T_JBV(6320),
T_JBV(2682),
T_JBV(2980),
T_JBV(9990133),
T_JBV(4040),
T_JBV(1111),
T_JBV(4428),
T_JBV(2091),
T_JBV(1799),
T_JBV(3703),
T_JBV(1798),
T_JBV(3263),
T_JBV(2136),
T_JBV(10007550),
T_JBV(105),
T_JBV(154),
T_JBV(10007348),
T_JBV(110097914),
T_JBV(1116),
T_JBV(1115),
T_JBV(10586),
T_JBV(1075),
T_JBV(4448),
T_JBV(4449),
T_JBV(973),
T_JBV(3256),
T_JBV(4491),
T_JBV(12596),
T_JBV(2272),
T_JBV(1819),
T_JBV(11787),
T_JBV(3369),
T_JBV(24223),
T_JBV(266),
T_JBV(9970),
T_JBV(110161109),
T_JBV(11671),
T_JBV(2320),
T_JBV(10630),
T_JBV(3279),
T_JBV(403),
T_JBV(6952),
T_JBV(6421),
T_JBV(9990148),
T_JBV(110114356),
T_JBV(1227),
T_JBV(2119),
T_JBV(1081),
T_JBV(11252),
T_JBV(4384),
T_JBV(3331),
T_JBV(12608),
T_JBV(10006873),
T_JBV(5522),
T_JBV(110097633),
T_JBV(110115253),
T_JBV(3353),
T_JBV(4401),
T_JBV(3240),
T_JBV(11783),
T_JBV(6791),
T_JBV(1233),
T_JBV(4413),
T_JBV(110160863),
T_JBV(2260),
T_JBV(2263),
T_JBV(3247),
T_JBV(134),
T_JBV(10012200),
T_JBV(2984),
T_JBV(2982),
T_JBV(9990172),
T_JBV(2941),
T_JBV(2553),
T_JBV(13107),
T_JBV(11308),
T_JBV(2137),
T_JBV(672),
T_JBV(11523),
T_JBV(1105),
T_JBV(121),
T_JBV(2127),
T_JBV(2153),
T_JBV(1955),
T_JBV(983),
T_JBV(115),
T_JBV(9990065),
T_JBV(149),
T_JBV(1096),
T_JBV(86),
T_JBV(127),
T_JBV(1118),
T_JBV(2143),
T_JBV(110128180),
T_JBV(4443),
T_JBV(10005070),
T_JBV(3265),
T_JBV(110082230),
T_JBV(2264),
T_JBV(91),
T_JBV(3251),
T_JBV(11860),
T_JBV(2271),
T_JBV(662),
T_JBV(110155322),
T_JBV(3301),
T_JBV(3242),
T_JBV(11693),
T_JBV(6526),
T_JBV(12235),
T_JBV(151),
T_JBV(110117082),
T_JBV(398),
T_JBV(3235),
T_JBV(11360),
T_JBV(9990010),
T_JBV(2161),
T_JBV(2996),
T_JBV(2326),
T_JBV(110155537),
T_JBV(4767),
T_JBV(142),
T_JBV(4446),
T_JBV(4409),
T_JBV(126),
T_JBV(2140),
T_JBV(24),
T_JBV(110161853),
T_JBV(2705),
T_JBV(11623),
T_JBV(1092),
T_JBV(1219),
T_JBV(6610),
T_JBV(3232),
T_JBV(110155782),
T_JBV(110054050),
T_JBV(10012199),
T_JBV(1145),
T_JBV(6273),
T_JBV(5153),
T_JBV(9990165),
T_JBV(110083220),
T_JBV(10668),
T_JBV(110114704),
T_JBV(9990167),
T_JBV(110082689),
T_JBV(110073957),
T_JBV(2481),
T_JBV(1149),
T_JBV(9990158),
T_JBV(4450),
T_JBV(1079),
T_JBV(3365),
T_JBV(13059),
T_JBV(954),
T_JBV(110108090),
T_JBV(3347),
T_JBV(3258),
T_JBV(4434),
T_JBV(1146),
T_JBV(110117154),
T_JBV(448),
T_JBV(110065064),
T_JBV(110114233),
T_JBV(4455),
T_JBV(6908),
T_JBV(110128177),
T_JBV(110114700),
T_JBV(6979),
T_JBV(3219),
T_JBV(3392),
T_JBV(1067),
T_JBV(10585),
T_JBV(13048),
T_JBV(2105),
T_JBV(4395),
T_JBV(397),
T_JBV(110128600),
T_JBV(2149),
T_JBV(10765),
T_JBV(2981),
T_JBV(4447),
T_JBV(984),
T_JBV(3396),
T_JBV(2158),
T_JBV(3386),
T_JBV(96),
T_JBV(988),
T_JBV(3346),
T_JBV(3393),
T_JBV(1108),
T_JBV(2110),
T_JBV(110113895),
T_JBV(1636),
T_JBV(5612),
T_JBV(3351),
T_JBV(11646),
T_JBV(12567),
T_JBV(2125),
T_JBV(110082231),
T_JBV(3260),
T_JBV(1062),
T_JBV(3361),
T_JBV(4435),
T_JBV(110128453),
T_JBV(2129),
T_JBV(110117819),
T_JBV(4456),
T_JBV(5745),
T_JBV(10033473),
T_JBV(4430),
T_JBV(13090),
T_JBV(138),
T_JBV(3378),
T_JBV(2339),
T_JBV(4433),
T_JBV(110117726),
T_JBV(3413),
T_JBV(3403),
T_JBV(110128458),
T_JBV(11461),
T_JBV(13106),
T_JBV(10033552),
T_JBV(4415),
T_JBV(6927),
T_JBV(2269),
T_JBV(1106),
T_JBV(663),
T_JBV(427),
T_JBV(1112),
T_JBV(4564),
T_JBV(10008996),
T_JBV(1073),
T_JBV(2299),
T_JBV(963),
T_JBV(2112),
T_JBV(1107),
T_JBV(11673),
T_JBV(2145),
T_JBV(385),
T_JBV(4436),
T_JBV(2621),
T_JBV(1113),
T_JBV(110161264),
T_JBV(107),
T_JBV(396),
T_JBV(110112906),
T_JBV(120),
T_JBV(1117),
T_JBV(4438),
T_JBV(1095),
T_JBV(11875),
T_JBV(12695),
T_JBV(656),
T_JBV(110116364),
T_JBV(110081722),
T_JBV(2164),
T_JBV(150)
	); 
	V_TMP_JBV T_JBV;

BEGIN	

    DBMS_OUTPUT.put_line('[INICIO]');

	V_COUNT := 0;

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

  	COD_MEDIADOR_REM := TRIM(V_TMP_JBV(1));
	
    V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR 
                SET PVE_AUTORIZACION_WEB = 1, 
                    USUARIOMODIFICAR = ''REMVIP-5855'', 
                    FECHAMODIFICAR = SYSDATE
                WHERE PVE_COD_REM = '||COD_MEDIADOR_REM;
	EXECUTE IMMEDIATE V_SQL;

	V_COUNT := V_COUNT + 1;
	
	END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(' [INFO] Se han actualizado '||V_COUNT||' proveedores');
		
	COMMIT;
    
    DBMS_OUTPUT.put_line('[FIN]');
 
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

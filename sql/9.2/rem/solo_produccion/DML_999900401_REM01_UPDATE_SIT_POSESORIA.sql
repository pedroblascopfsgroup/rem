--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2443
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2393'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
						T_JBV(5928724),
						T_JBV(5949670),
						T_JBV(5962037),
						T_JBV(5958153),
						T_JBV(5957663),
						T_JBV(5950409),
						T_JBV(5943358),
						T_JBV(5945274),
						T_JBV(5950906),
						T_JBV(5940852),
						T_JBV(5961670),
						T_JBV(5926803),
						T_JBV(6756430),
						T_JBV(5949901),
						T_JBV(5962329),
						T_JBV(5939827),
						T_JBV(5939390),
						T_JBV(5944191),
						T_JBV(5938136),
						T_JBV(5950832),
						T_JBV(5936636),
						T_JBV(5967148),
						T_JBV(6355388),
						T_JBV(5935565),
						T_JBV(5958007),
						T_JBV(5942907),
						T_JBV(5946679),
						T_JBV(5948980),
						T_JBV(5941852),
						T_JBV(5961743),
						T_JBV(5927234),
						T_JBV(5952171),
						T_JBV(5941102),
						T_JBV(5953666),
						T_JBV(5955895),
						T_JBV(5958800),
						T_JBV(5944428),
						T_JBV(5925675),
						T_JBV(5927334),
						T_JBV(5928476),
						T_JBV(5944381),
						T_JBV(5937701),
						T_JBV(5926858),
						T_JBV(5969947),
						T_JBV(5958502),
						T_JBV(5970059),
						T_JBV(5928672),
						T_JBV(5967566),
						T_JBV(5954907),
						T_JBV(5927423),
						T_JBV(6128400),
						T_JBV(5956354),
						T_JBV(6062059),
						T_JBV(5962925),
						T_JBV(5931447),
						T_JBV(5948861),
						T_JBV(5928524),
						T_JBV(5927968),
						T_JBV(5941700),
						T_JBV(5969996),
						T_JBV(5932051),
						T_JBV(5929180),
						T_JBV(5941714),
						T_JBV(5938881),
						T_JBV(5960233),
						T_JBV(5969927),
						T_JBV(5951745),
						T_JBV(5957394),
						T_JBV(5962008),
						T_JBV(5970441),
						T_JBV(5952069),
						T_JBV(5935940),
						T_JBV(6059227),
						T_JBV(5938526),
						T_JBV(5967596),
						T_JBV(5936595),
						T_JBV(5958638),
						T_JBV(5931798),
						T_JBV(5965479),
						T_JBV(5942131),
						T_JBV(5955601),
						T_JBV(5966135),
						T_JBV(5958237),
						T_JBV(5945386),
						T_JBV(5957501),
						T_JBV(6344370),
						T_JBV(5939663),
						T_JBV(6703056),
						T_JBV(5959260),
						T_JBV(5965229),
						T_JBV(5965463),
						T_JBV(5961540),
						T_JBV(6704261),
						T_JBV(5931159),
						T_JBV(5970465),
						T_JBV(5955782),
						T_JBV(6710292),
						T_JBV(5940530),
						T_JBV(5941999),
						T_JBV(5966733),
						T_JBV(5960314),
						T_JBV(5968993),
						T_JBV(5965591),
						T_JBV(5934374),
						T_JBV(5942452),
						T_JBV(5963063),
						T_JBV(5937580),
						T_JBV(5949756),
						T_JBV(5969329),
						T_JBV(5954065),
						T_JBV(5928361),
						T_JBV(5941726),
						T_JBV(5927166),
						T_JBV(5956033),
						T_JBV(5942464),
						T_JBV(5936446),
						T_JBV(5940327),
						T_JBV(5939013),
						T_JBV(6063162),
						T_JBV(6128237),
						T_JBV(5942946),
						T_JBV(5941045),
						T_JBV(5965618),
						T_JBV(5953132),
						T_JBV(6356280),
						T_JBV(5956693),
						T_JBV(5961316),
						T_JBV(5964671),
						T_JBV(5948688),
						T_JBV(5969591),
						T_JBV(5942375),
						T_JBV(6063320),
						T_JBV(5928695),
						T_JBV(5959460),
						T_JBV(6344481),
						T_JBV(5956209),
						T_JBV(5931301),
						T_JBV(5938196),
						T_JBV(5940091),
						T_JBV(5931931),
						T_JBV(5966540),
						T_JBV(5928049),
						T_JBV(5952354),
						T_JBV(5937813),
						T_JBV(5954629),
						T_JBV(5964143),
						T_JBV(5958192),
						T_JBV(5936375),
						T_JBV(5939375),
						T_JBV(5956631),
						T_JBV(5946840),
						T_JBV(5934254),
						T_JBV(5945686),
						T_JBV(5967922),
						T_JBV(5927021),
						T_JBV(5935553),
						T_JBV(5938065),
						T_JBV(5927783),
						T_JBV(5947290),
						T_JBV(6063693),
						T_JBV(5958991),
						T_JBV(5952867),
						T_JBV(5966442),
						T_JBV(5956374),
						T_JBV(5963649),
						T_JBV(5925103),
						T_JBV(5937228),
						T_JBV(5967836),
						T_JBV(5947095),
						T_JBV(5967540),
						T_JBV(5929008),
						T_JBV(5969762),
						T_JBV(5936397),
						T_JBV(5927352),
						T_JBV(5944781),
						T_JBV(5943471),
						T_JBV(5931653),
						T_JBV(5953596),
						T_JBV(5961112),
						T_JBV(5960056),
						T_JBV(5959896),
						T_JBV(5933559),
						T_JBV(5937862),
						T_JBV(6710268),
						T_JBV(5948553),
						T_JBV(5964838),
						T_JBV(5928286),
						T_JBV(5935646),
						T_JBV(5954431),
						T_JBV(5956085),
						T_JBV(5937805),
						T_JBV(5935607),
						T_JBV(5958175),
						T_JBV(5959359),
						T_JBV(5927724),
						T_JBV(5965660),
						T_JBV(5936349),
						T_JBV(5950020),
						T_JBV(5959919),
						T_JBV(5962894),
						T_JBV(5937784),
						T_JBV(5927944),
						T_JBV(5949577),
						T_JBV(5927469),
						T_JBV(5946788),
						T_JBV(5941407),
						T_JBV(6051421),
						T_JBV(5944077),
						T_JBV(5930567),
						T_JBV(5941914),
						T_JBV(5944917),
						T_JBV(6057180),
						T_JBV(5966504),
						T_JBV(5960691),
						T_JBV(5951528),
						T_JBV(5948426),
						T_JBV(5960120),
						T_JBV(5935301),
						T_JBV(5946715),
						T_JBV(5930297),
						T_JBV(5963821),
						T_JBV(5932350),
						T_JBV(5958232),
						T_JBV(5950168),
						T_JBV(5950204),
						T_JBV(5967019),
						T_JBV(5937222),
						T_JBV(5944302),
						T_JBV(5940970),
						T_JBV(5946892),
						T_JBV(5942082),
						T_JBV(5954646),
						T_JBV(5967903),
						T_JBV(5938086),
						T_JBV(5925304),
						T_JBV(5946824),
						T_JBV(5932828),
						T_JBV(5966729),
						T_JBV(5935002),
						T_JBV(5926149),
						T_JBV(5963654),
						T_JBV(5934927),
						T_JBV(5934895),
						T_JBV(5962193),
						T_JBV(5928515),
						T_JBV(5938774),
						T_JBV(5934582),
						T_JBV(5948798),
						T_JBV(5961488),
						T_JBV(5927831),
						T_JBV(5950552),
						T_JBV(5941142),
						T_JBV(5944138),
						T_JBV(5942186),
						T_JBV(5942427),
						T_JBV(5929884),
						T_JBV(5945855),
						T_JBV(6063494),
						T_JBV(5949066),
						T_JBV(5948817),
						T_JBV(6058270),
						T_JBV(5957917),
						T_JBV(5942594),
						T_JBV(5935933),
						T_JBV(5931240),
						T_JBV(5942742),
						T_JBV(5947486),
						T_JBV(5961128),
						T_JBV(5968253),
						T_JBV(5957123),
						T_JBV(5941460),
						T_JBV(5965391),
						T_JBV(5939591),
						T_JBV(6344540),
						T_JBV(6788490),
						T_JBV(5934164),
						T_JBV(5963425),
						T_JBV(5958315),
						T_JBV(5962694),
						T_JBV(6052070),
						T_JBV(5937930),
						T_JBV(5943638),
						T_JBV(5949651),
						T_JBV(5945679),
						T_JBV(5962334),
						T_JBV(5967837),
						T_JBV(5938183),
						T_JBV(5940611),
						T_JBV(5933426),
						T_JBV(5947874),
						T_JBV(5955378),
						T_JBV(6520438),
						T_JBV(5930496),
						T_JBV(5944803),
						T_JBV(5928716),
						T_JBV(5939594),
						T_JBV(5947366),
						T_JBV(5959722),
						T_JBV(5934521),
						T_JBV(5955261),
						T_JBV(5952728),
						T_JBV(5928662),
						T_JBV(5948024),
						T_JBV(5969823),
						T_JBV(5948082),
						T_JBV(6061759),
						T_JBV(5939417),
						T_JBV(5962057),
						T_JBV(6049181),
						T_JBV(5970298),
						T_JBV(6128755),
						T_JBV(5948049),
						T_JBV(6764619),
						T_JBV(6984448),
						T_JBV(5938876),
						T_JBV(6060746),
						T_JBV(6060745),
						T_JBV(5961069),
						T_JBV(6989801),
						T_JBV(6983225),
						T_JBV(6984113),
						T_JBV(5948471),
						T_JBV(6993121),
						T_JBV(5962688),
						T_JBV(5969340),
						T_JBV(6060747),
						T_JBV(5934113),
						T_JBV(5944831),
						T_JBV(5959544),
						T_JBV(6984239),
						T_JBV(5967209),
						T_JBV(6998001),
						T_JBV(5968485),
						T_JBV(5961165),
						T_JBV(5947543),
						T_JBV(5968058),
						T_JBV(6988875),
						T_JBV(5947618),
						T_JBV(6987621),
						T_JBV(5943792),
						T_JBV(5964755),
						T_JBV(6991152),
						T_JBV(5950892),
						T_JBV(5944061),
						T_JBV(6998347),
						T_JBV(5958382),
						T_JBV(6998960),
						T_JBV(6058611),
						T_JBV(5962285),
						T_JBV(6981582),
						T_JBV(6984078),
						T_JBV(6991153),
						T_JBV(6706123),
						T_JBV(5938743),
						T_JBV(5958310),
						T_JBV(6993647),
						T_JBV(5930126),
						T_JBV(5964710),
						T_JBV(6059674),
						T_JBV(6982481),
						T_JBV(6992037),
						T_JBV(5928920),
						T_JBV(5943706),
						T_JBV(5936699),
						T_JBV(5929408),
						T_JBV(5958321),
						T_JBV(5929921),
						T_JBV(5957150),
						T_JBV(5964907),
						T_JBV(5965111),
						T_JBV(5966480),
						T_JBV(5952036),
						T_JBV(5939103),
						T_JBV(5953722),
						T_JBV(6885714),
						T_JBV(5943763),
						T_JBV(6529988),
						T_JBV(5953630),
						T_JBV(6843076),
						T_JBV(6942778),
						T_JBV(5948640),
						T_JBV(5928644),
						T_JBV(5970154),
						T_JBV(5959086),
						T_JBV(5934415),
						T_JBV(5928997),
						T_JBV(5928990)); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA SPS_CON_TITULO');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SIT
	ON SIT.ACT_ID = ACT.ACT_ID 
	WHERE ACT.ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
	AND SIT.SPS_FECHA_SOL_DESAHUCIO IS NOT NULL
	AND SIT.SPS_CON_TITULO = 1
	AND SIT.SPS_OCUPADO = 1';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA 
				   SET SPS_CON_TITULO = 0,
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' NO CUMPLE LAS CONDICIONES COMO PARA SER ACTUALIZADO');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');
 
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

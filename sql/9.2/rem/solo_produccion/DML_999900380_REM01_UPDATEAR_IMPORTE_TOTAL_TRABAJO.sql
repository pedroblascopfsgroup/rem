--/*
--###########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190314
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3598
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR IMPORTE TRABAJO 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-3598';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 		NUM TRABAJO, IMPORTE TOTAL
   	T_TIPO_DATA('164863','4131.12'),
	T_TIPO_DATA('163900','2427.54'),
	T_TIPO_DATA('9000050036','2117.48'),
	T_TIPO_DATA('9000061822','29.45'),
	T_TIPO_DATA('165773','1721.28'),
	T_TIPO_DATA('165848','1663.48'),
	T_TIPO_DATA('9000047479','1511.15'),
	T_TIPO_DATA('169020','1461.96'),
	T_TIPO_DATA('169881','1446.96'),
	T_TIPO_DATA('149421','1294.85'),
	T_TIPO_DATA('161951','1294.65'),
	T_TIPO_DATA('166895','1288.61'),
	T_TIPO_DATA('170324','1209.85'),
	T_TIPO_DATA('164844','1199.78'),
	T_TIPO_DATA('165806','1114.41'),
	T_TIPO_DATA('164694','1111.93'),
	T_TIPO_DATA('167621','1039.95'),
	T_TIPO_DATA('165918','990.79'),
	T_TIPO_DATA('162468','958.42'),
	T_TIPO_DATA('168582','948.86'),
	T_TIPO_DATA('168959','234.68'),
	T_TIPO_DATA('169570','931.05'),
	T_TIPO_DATA('167662','927.92'),
	T_TIPO_DATA('169910','895.33'),
	T_TIPO_DATA('151213','878.75'),
	T_TIPO_DATA('168235','859.23'),
	T_TIPO_DATA('169598','832.38'),
	T_TIPO_DATA('168418','827.48'),
	T_TIPO_DATA('168379','823.13'),
	T_TIPO_DATA('170821','823.13'),
	T_TIPO_DATA('167852','822.45'),
	T_TIPO_DATA('169352','822.45'),
	T_TIPO_DATA('168613','808.86'),
	T_TIPO_DATA('162161','798.95'),
	T_TIPO_DATA('169066','797.19'),
	T_TIPO_DATA('167685','786.48'),
	T_TIPO_DATA('170695','782.71'),
	T_TIPO_DATA('169909','748.76'),
	T_TIPO_DATA('169955','747.05'),
	T_TIPO_DATA('169583','741.43'),
	T_TIPO_DATA('166395','739.78'),
	T_TIPO_DATA('167669','734.08'),
	T_TIPO_DATA('153160','730.85'),
	T_TIPO_DATA('167682','730.85'),
	T_TIPO_DATA('167291','722.53'),
	T_TIPO_DATA('170170','701.94'),
	T_TIPO_DATA('169274','678.73'),
	T_TIPO_DATA('164115','678.05'),
	T_TIPO_DATA('167155','673.53'),
	T_TIPO_DATA('165849','671.48'),
	T_TIPO_DATA('169005','660.68'),
	T_TIPO_DATA('168572','658.23'),
	T_TIPO_DATA('168118','655.78'),
	T_TIPO_DATA('169924','653.51'),
	T_TIPO_DATA('168576','641.95'),
	T_TIPO_DATA('169550','641.28'),
	T_TIPO_DATA('168423','624.58'),
	T_TIPO_DATA('170321','624.58'),
	T_TIPO_DATA('169022','607.83'),
	T_TIPO_DATA('149799','586.45'),
	T_TIPO_DATA('167250','584.13'),
	T_TIPO_DATA('165828','579.36'),
	T_TIPO_DATA('166712','577.93'),
	T_TIPO_DATA('166031','95.38'),
	T_TIPO_DATA('168352','569.29'),
	T_TIPO_DATA('168028','569.08'),
	T_TIPO_DATA('168990','569.08'),
	T_TIPO_DATA('169404','569.08'),
	T_TIPO_DATA('170363','569.08'),
	T_TIPO_DATA('170693','569.08'),
	T_TIPO_DATA('164716','564.87'),
	T_TIPO_DATA('167051','534.33'),
	T_TIPO_DATA('167820','534.33'),
	T_TIPO_DATA('167907','534.33'),
	T_TIPO_DATA('168036','534.33'),
	T_TIPO_DATA('168090','534.33'),
	T_TIPO_DATA('168822','534.33'),
	T_TIPO_DATA('169741','534.33'),
	T_TIPO_DATA('170694','534.33'),
	T_TIPO_DATA('166817','532.93'),
	T_TIPO_DATA('168086','117.34'),
	T_TIPO_DATA('166631','527.03'),
	T_TIPO_DATA('169933','503.76'),
	T_TIPO_DATA('168117','502.03'),
	T_TIPO_DATA('168230','498.87'),
	T_TIPO_DATA('167537','497.15'),
	T_TIPO_DATA('169533','490.82'),
	T_TIPO_DATA('169332','489.11'),
	T_TIPO_DATA('167589','482.35'),
	T_TIPO_DATA('169326','459.83'),
	T_TIPO_DATA('167847','456.65'),
	T_TIPO_DATA('165305','454.13'),
	T_TIPO_DATA('166387','454.09'),
	T_TIPO_DATA('169150','429.92'),
	T_TIPO_DATA('158624','428.48'),
	T_TIPO_DATA('168464','428.48'),
	T_TIPO_DATA('169271','428.48'),
	T_TIPO_DATA('170473','428.48'),
	T_TIPO_DATA('167282','417.53'),
	T_TIPO_DATA('170605','83.92'),
	T_TIPO_DATA('166632','409.69'),
	T_TIPO_DATA('168599','399.95'),
	T_TIPO_DATA('168498','319.48'),
	T_TIPO_DATA('166721','395.74'),
	T_TIPO_DATA('164710','222.73'),
	T_TIPO_DATA('148363','393.73'),
	T_TIPO_DATA('166963','393.73'),
	T_TIPO_DATA('167079','393.73'),
	T_TIPO_DATA('168033','393.73'),
	T_TIPO_DATA('168034','393.73'),
	T_TIPO_DATA('168130','393.73'),
	T_TIPO_DATA('168465','393.73'),
	T_TIPO_DATA('168488','393.73'),
	T_TIPO_DATA('170081','393.73'),
	T_TIPO_DATA('168486','392.85'),
	T_TIPO_DATA('170980','389.41'),
	T_TIPO_DATA('170352','385.68'),
	T_TIPO_DATA('166501','383.69'),
	T_TIPO_DATA('168681','383.15'),
	T_TIPO_DATA('169327','381.19'),
	T_TIPO_DATA('151278','377.44'),
	T_TIPO_DATA('166630','373.88'),
	T_TIPO_DATA('169359','373.88'),
	T_TIPO_DATA('168803','360.04'),
	T_TIPO_DATA('168574','359.23'),
	T_TIPO_DATA('168201','348.59'),
	T_TIPO_DATA('170039','335.96'),
	T_TIPO_DATA('167671','331.37'),
	T_TIPO_DATA('168084','325.58'),
	T_TIPO_DATA('168369','318.68'),
	T_TIPO_DATA('169311','103.16'),
	T_TIPO_DATA('167574','303.86'),
	T_TIPO_DATA('168962','300.79'),
	T_TIPO_DATA('168482','297.15'),
	T_TIPO_DATA('168195','294.54'),
	T_TIPO_DATA('167048','294.04'),
	T_TIPO_DATA('169357','289.61'),
	T_TIPO_DATA('156252','281.23'),
	T_TIPO_DATA('160012','281.23'),
	T_TIPO_DATA('168093','281.23'),
	T_TIPO_DATA('169368','281.23'),
	T_TIPO_DATA('169809','281.23'),
	T_TIPO_DATA('160166','276.34'),
	T_TIPO_DATA('160039','275.12'),
	T_TIPO_DATA('168617','274.85'),
	T_TIPO_DATA('169782','274.85'),
	T_TIPO_DATA('167200','263.85'),
	T_TIPO_DATA('168276','263.85'),
	T_TIPO_DATA('168564','263.85'),
	T_TIPO_DATA('168600','263.85'),
	T_TIPO_DATA('169376','263.85'),
	T_TIPO_DATA('169434','263.85'),
	T_TIPO_DATA('170182','263.85'),
	T_TIPO_DATA('169428','258.16'),
	T_TIPO_DATA('164093','257.48'),
	T_TIPO_DATA('168313','257.48'),
	T_TIPO_DATA('168568','257.48'),
	T_TIPO_DATA('168800','257.48'),
	T_TIPO_DATA('169628','257.48'),
	T_TIPO_DATA('162795','256.34'),
	T_TIPO_DATA('168973','249.89'),
	T_TIPO_DATA('168434','247.93'),
	T_TIPO_DATA('167086','246.48'),
	T_TIPO_DATA('167404','246.48'),
	T_TIPO_DATA('167487','246.48'),
	T_TIPO_DATA('167496','246.48'),
	T_TIPO_DATA('168965','246.48'),
	T_TIPO_DATA('168984','246.48'),
	T_TIPO_DATA('170041','246.48'),
	T_TIPO_DATA('167379','246.35'),
	T_TIPO_DATA('170343','246.35'),
	T_TIPO_DATA('168606','236.64'),
	T_TIPO_DATA('168577','232.77'),
	T_TIPO_DATA('169323','232.77'),
	T_TIPO_DATA('170374','228.56'),
	T_TIPO_DATA('168098','228.41'),
	T_TIPO_DATA('168218','228.41'),
	T_TIPO_DATA('168308','228.41'),
	T_TIPO_DATA('9000048463','929.21'),
	T_TIPO_DATA('167407','123.5'),
	T_TIPO_DATA('167457','222.73'),
	T_TIPO_DATA('168220','222.73'),
	T_TIPO_DATA('168381','222.73'),
	T_TIPO_DATA('168561','222.73'),
	T_TIPO_DATA('168916','222.73'),
	T_TIPO_DATA('168963','222.73'),
	T_TIPO_DATA('169293','222.73'),
	T_TIPO_DATA('169526','222.73'),
	T_TIPO_DATA('170186','222.73'),
	T_TIPO_DATA('170492','222.73'),
	T_TIPO_DATA('160549','221.97'),
	T_TIPO_DATA('168985','218.23'),
	T_TIPO_DATA('165310','2366.4'),
	T_TIPO_DATA('165526','214.51'),
	T_TIPO_DATA('154931','214.39'),
	T_TIPO_DATA('169250','212.72'),
	T_TIPO_DATA('169743','209.66'),
	T_TIPO_DATA('167164','2268.6'),
	T_TIPO_DATA('167344','201.32'),
	T_TIPO_DATA('169620','198.74'),
	T_TIPO_DATA('168511','198.17'),
	T_TIPO_DATA('169238','198.17'),
	T_TIPO_DATA('166756','194.23'),
	T_TIPO_DATA('167456','194.23'),
	T_TIPO_DATA('169921','194.23'),
	T_TIPO_DATA('170162','194.23'),
	T_TIPO_DATA('168513','192.31'),
	T_TIPO_DATA('169407','184.79'),
	T_TIPO_DATA('168039','2027.3'),
	T_TIPO_DATA('169322','183.35'),
	T_TIPO_DATA('169312','174.95'),
	T_TIPO_DATA('169544','173.66'),
	T_TIPO_DATA('168306','170.31'),
	T_TIPO_DATA('165018','167.19'),
	T_TIPO_DATA('167359','167.19'),
	T_TIPO_DATA('169282','164.85'),
	T_TIPO_DATA('168320','162.83'),
	T_TIPO_DATA('160079','160.96'),
	T_TIPO_DATA('166780','160.96'),
	T_TIPO_DATA('166793','160.96'),
	T_TIPO_DATA('166837','160.96'),
	T_TIPO_DATA('167033','160.96'),
	T_TIPO_DATA('167037','160.96'),
	T_TIPO_DATA('167107','160.96'),
	T_TIPO_DATA('167865','160.96'),
	T_TIPO_DATA('170648','160.96'),
	T_TIPO_DATA('161868','156.75'),
	T_TIPO_DATA('168180','156.75'),
	T_TIPO_DATA('168463','156.75'),
	T_TIPO_DATA('168521','156.75'),
	T_TIPO_DATA('169076','156.75'),
	T_TIPO_DATA('169985','156.75'),
	T_TIPO_DATA('163538','155.23'),
	T_TIPO_DATA('166994','153.44'),
	T_TIPO_DATA('169460','151.38'),
	T_TIPO_DATA('169228','151.24'),
	T_TIPO_DATA('168332','149.47'),
	T_TIPO_DATA('168731','149.47'),
	T_TIPO_DATA('165163','1634.7'),
	T_TIPO_DATA('169059','148.58'),
	T_TIPO_DATA('169330','148.58'),
	T_TIPO_DATA('170660','147.81'),
	T_TIPO_DATA('166992','143.94'),
	T_TIPO_DATA('169045','143.94'),
	T_TIPO_DATA('169315','143.94'),
	T_TIPO_DATA('167174','143.62'),
	T_TIPO_DATA('167355','143.62'),
	T_TIPO_DATA('168371','143.62'),
	T_TIPO_DATA('168810','143.62'),
	T_TIPO_DATA('168775','131.82'),
	T_TIPO_DATA('167724','130.45'),
	T_TIPO_DATA('9000048209','97.2'),
	T_TIPO_DATA('167946','124.64'),
	T_TIPO_DATA('169375','121.98'),
	T_TIPO_DATA('169764','626.4'),
	T_TIPO_DATA('151176','117.34'),
	T_TIPO_DATA('162098','117.34'),
	T_TIPO_DATA('163752','117.34'),
	T_TIPO_DATA('163876','117.34'),
	T_TIPO_DATA('163878','117.34'),
	T_TIPO_DATA('163881','117.34'),
	T_TIPO_DATA('166229','117.34'),
	T_TIPO_DATA('166965','117.34'),
	T_TIPO_DATA('167077','117.34'),
	T_TIPO_DATA('167130','117.34'),
	T_TIPO_DATA('167145','117.34'),
	T_TIPO_DATA('167290','117.34'),
	T_TIPO_DATA('167394','117.34'),
	T_TIPO_DATA('167410','117.34'),
	T_TIPO_DATA('167844','117.34'),
	T_TIPO_DATA('167868','117.34'),
	T_TIPO_DATA('168030','117.34'),
	T_TIPO_DATA('168214','117.34'),
	T_TIPO_DATA('168438','117.34'),
	T_TIPO_DATA('168615','117.34'),
	T_TIPO_DATA('168972','117.34'),
	T_TIPO_DATA('169304','117.34'),
	T_TIPO_DATA('169314','117.34'),
	T_TIPO_DATA('169328','117.34'),
	T_TIPO_DATA('169335','117.34'),
	T_TIPO_DATA('169342','117.34'),
	T_TIPO_DATA('169344','117.34'),
	T_TIPO_DATA('169470','117.34'),
	T_TIPO_DATA('169615','117.34'),
	T_TIPO_DATA('169646','117.34'),
	T_TIPO_DATA('169650','117.34'),
	T_TIPO_DATA('169778','117.34'),
	T_TIPO_DATA('170750','117.34'),
	T_TIPO_DATA('9000059554','117.34'),
	T_TIPO_DATA('9000061399','117.34'),
	T_TIPO_DATA('168100','1248.3'),
	T_TIPO_DATA('9000044354','112.26'),
	T_TIPO_DATA('166097','1222.5'),
	T_TIPO_DATA('167154','108.73'),
	T_TIPO_DATA('169457','100.16'),
	T_TIPO_DATA('167608','1093.2'),
	T_TIPO_DATA('167260','98.41'),
	T_TIPO_DATA('9000032602','75.4'),
	T_TIPO_DATA('152720','95.38'),
	T_TIPO_DATA('163032','95.38'),
	T_TIPO_DATA('163875','95.38'),
	T_TIPO_DATA('167059','95.38'),
	T_TIPO_DATA('167294','95.38'),
	T_TIPO_DATA('167320','95.38'),
	T_TIPO_DATA('167550','95.38'),
	T_TIPO_DATA('167641','95.38'),
	T_TIPO_DATA('167683','95.38'),
	T_TIPO_DATA('168254','95.38'),
	T_TIPO_DATA('168351','95.38'),
	T_TIPO_DATA('168373','95.38'),
	T_TIPO_DATA('168432','95.38'),
	T_TIPO_DATA('168585','95.38'),
	T_TIPO_DATA('168604','95.38'),
	T_TIPO_DATA('168781','95.38'),
	T_TIPO_DATA('168979','95.38'),
	T_TIPO_DATA('169070','95.38'),
	T_TIPO_DATA('169269','95.38'),
	T_TIPO_DATA('169429','95.38'),
	T_TIPO_DATA('169475','95.38'),
	T_TIPO_DATA('169490','95.38'),
	T_TIPO_DATA('169591','95.38'),
	T_TIPO_DATA('169740','95.38'),
	T_TIPO_DATA('170184','95.38'),
	T_TIPO_DATA('170654','95.38'),
	T_TIPO_DATA('170781','95.38'),
	T_TIPO_DATA('170827','95.38'),
	T_TIPO_DATA('168361','1012.3'),
	T_TIPO_DATA('167007','89.65'),
	T_TIPO_DATA('168272','84.12'),
	T_TIPO_DATA('167822','904.8'),
	T_TIPO_DATA('160522','81.74'),
	T_TIPO_DATA('165943','81.74'),
	T_TIPO_DATA('169963','81.74'),
	T_TIPO_DATA('169966','81.74'),
	T_TIPO_DATA('169967','81.74'),
	T_TIPO_DATA('170824','81.74'),
	T_TIPO_DATA('9000048697','81.74'),
	T_TIPO_DATA('9000048698','81.74'),
	T_TIPO_DATA('9000086292','81.74'),
	T_TIPO_DATA('168424','79.57'),
	T_TIPO_DATA('167389','78.62'),
	T_TIPO_DATA('163879','76.72'),
	T_TIPO_DATA('167754','76.72'),
	T_TIPO_DATA('167916','76.72'),
	T_TIPO_DATA('169333','76.72'),
	T_TIPO_DATA('167983','73.11'),
	T_TIPO_DATA('166869','796.4'),
	T_TIPO_DATA('163246','71.81'),
	T_TIPO_DATA('166892','71.81'),
	T_TIPO_DATA('167026','71.81'),
	T_TIPO_DATA('167342','71.81'),
	T_TIPO_DATA('168630','71.81'),
	T_TIPO_DATA('169325','71.81'),
	T_TIPO_DATA('169401','71.81'),
	T_TIPO_DATA('169525','71.81'),
	T_TIPO_DATA('169569','71.81'),
	T_TIPO_DATA('169898','71.81'),
	T_TIPO_DATA('169923','71.81'),
	T_TIPO_DATA('170085','71.81'),
	T_TIPO_DATA('170464','71.81'),
	T_TIPO_DATA('9000050292','71.81'),
	T_TIPO_DATA('9000057723','71.81'),
	T_TIPO_DATA('168389','70.04'),
	T_TIPO_DATA('169257','746.7'),
	T_TIPO_DATA('169532','744.8'),
	T_TIPO_DATA('169746','744.8'),
	T_TIPO_DATA('169986','739.1'),
	T_TIPO_DATA('168399','732.2'),
	T_TIPO_DATA('170209','732.2'),
	T_TIPO_DATA('9000136563','328.42'),
	T_TIPO_DATA('9000042717','66.15'),
	T_TIPO_DATA('168490','706.6'),
	T_TIPO_DATA('169808','696.1'),
	T_TIPO_DATA('166808','676.7'),
	T_TIPO_DATA('170061','61.34'),
	T_TIPO_DATA('165966','656.3'),
	T_TIPO_DATA('166795','648.9'),
	T_TIPO_DATA('168578','57.67'),
	T_TIPO_DATA('166420','619.5'),
	T_TIPO_DATA('168266','55.68'),
	T_TIPO_DATA('167417','602.3'),
	T_TIPO_DATA('168207','594.9'),
	T_TIPO_DATA('165872','593.4'),
	T_TIPO_DATA('170409','587.8'),
	T_TIPO_DATA('165429','52.97'),
	T_TIPO_DATA('166778','52.97'),
	T_TIPO_DATA('167572','52.97'),
	T_TIPO_DATA('168763','578.6'),
	T_TIPO_DATA('170761','51.68'),
	T_TIPO_DATA('160007','551.7'),
	T_TIPO_DATA('165984','551.7'),
	T_TIPO_DATA('167826','551.7'),
	T_TIPO_DATA('167915','551.7'),
	T_TIPO_DATA('168317','551.7'),
	T_TIPO_DATA('168828','551.7'),
	T_TIPO_DATA('169334','551.7'),
	T_TIPO_DATA('169529','551.7'),
	T_TIPO_DATA('169626','551.7'),
	T_TIPO_DATA('169783','551.7'),
	T_TIPO_DATA('169900','551.7'),
	T_TIPO_DATA('170360','551.7'),
	T_TIPO_DATA('170361','551.7'),
	T_TIPO_DATA('169381','527.3'),
	T_TIPO_DATA('170947','487.2'),
	T_TIPO_DATA('170656','218.5'),
	T_TIPO_DATA('168926','128.63'),
	T_TIPO_DATA('166794','411.1'),
	T_TIPO_DATA('167913','411.1'),
	T_TIPO_DATA('168400','411.1'),
	T_TIPO_DATA('168611','411.1'),
	T_TIPO_DATA('169979','411.1'),
	T_TIPO_DATA('170188','411.1'),
	T_TIPO_DATA('168318','407.6'),
	T_TIPO_DATA('9000067484','34.65'),
	T_TIPO_DATA('170068','376.2'),
	T_TIPO_DATA('167883','375.4'),
	T_TIPO_DATA('165682','31.35'),
	T_TIPO_DATA('167596','31.35'),
	T_TIPO_DATA('167734','31.35'),
	T_TIPO_DATA('168607','31.35'),
	T_TIPO_DATA('168612','31.35'),
	T_TIPO_DATA('169452','31.35'),
	T_TIPO_DATA('9000040535','31.35'),
	T_TIPO_DATA('152956','29.45'),
	T_TIPO_DATA('163550','29.45'),
	T_TIPO_DATA('165338','29.45'),
	T_TIPO_DATA('165789','29.45'),
	T_TIPO_DATA('166152','29.45'),
	T_TIPO_DATA('166604','29.45'),
	T_TIPO_DATA('167032','29.45'),
	T_TIPO_DATA('167475','29.45'),
	T_TIPO_DATA('167525','29.45'),
	T_TIPO_DATA('167756','29.45'),
	T_TIPO_DATA('167987','29.45'),
	T_TIPO_DATA('167991','29.45'),
	T_TIPO_DATA('168215','29.45'),
	T_TIPO_DATA('168239','29.45'),
	T_TIPO_DATA('168248','29.45'),
	T_TIPO_DATA('168385','29.45'),
	T_TIPO_DATA('168454','29.45'),
	T_TIPO_DATA('168520','29.45'),
	T_TIPO_DATA('168920','29.45'),
	T_TIPO_DATA('168970','29.45'),
	T_TIPO_DATA('168971','29.45'),
	T_TIPO_DATA('168974','29.45'),
	T_TIPO_DATA('168975','29.45'),
	T_TIPO_DATA('168977','29.45'),
	T_TIPO_DATA('169038','29.45'),
	T_TIPO_DATA('169041','29.45'),
	T_TIPO_DATA('169049','29.45'),
	T_TIPO_DATA('169061','29.45'),
	T_TIPO_DATA('169083','29.45'),
	T_TIPO_DATA('169101','29.45'),
	T_TIPO_DATA('169191','29.45'),
	T_TIPO_DATA('169307','29.45'),
	T_TIPO_DATA('169331','29.45'),
	T_TIPO_DATA('169340','29.45'),
	T_TIPO_DATA('169349','29.45'),
	T_TIPO_DATA('169353','29.45'),
	T_TIPO_DATA('169360','29.45'),
	T_TIPO_DATA('169371','29.45'),
	T_TIPO_DATA('169405','29.45'),
	T_TIPO_DATA('169431','29.45'),
	T_TIPO_DATA('169451','29.45'),
	T_TIPO_DATA('169556','29.45'),
	T_TIPO_DATA('169651','29.45'),
	T_TIPO_DATA('170037','29.45'),
	T_TIPO_DATA('170047','29.45'),
	T_TIPO_DATA('170185','29.45'),
	T_TIPO_DATA('170298','29.45'),
	T_TIPO_DATA('170375','29.45'),
	T_TIPO_DATA('170380','29.45'),
	T_TIPO_DATA('170468','29.45'),
	T_TIPO_DATA('170575','29.45'),
	T_TIPO_DATA('170665','29.45'),
	T_TIPO_DATA('170706','29.45'),
	T_TIPO_DATA('170714','29.45'),
	T_TIPO_DATA('170730','29.45'),
	T_TIPO_DATA('170732','29.45'),
	T_TIPO_DATA('170868','29.45'),
	T_TIPO_DATA('170970','29.45'),
	T_TIPO_DATA('169469','313.5'),
	T_TIPO_DATA('169755','298.6'),
	T_TIPO_DATA('170388','298.6'),
	T_TIPO_DATA('168323','290.7'),
	T_TIPO_DATA('9000090313','116.4'),
	T_TIPO_DATA('167140','278.4'),
	T_TIPO_DATA('166547','278.3'),
	T_TIPO_DATA('168783','262.2'),
	T_TIPO_DATA('168382','240.1'),
	T_TIPO_DATA('168616','240.1'),
	T_TIPO_DATA('169013','240.1'),
	T_TIPO_DATA('169062','240.1'),
	T_TIPO_DATA('169264','240.1'),
	T_TIPO_DATA('169987','240.1'),
	T_TIPO_DATA('170357','240.1'),
	T_TIPO_DATA('166545','236.6'),
	T_TIPO_DATA('168644','218.5'),
	T_TIPO_DATA('169590','211.6'),
	T_TIPO_DATA('169594','211.6'),
	T_TIPO_DATA('9000059436','70.25'),
	T_TIPO_DATA('168081','194.4'),
	T_TIPO_DATA('9000058054','36.68'),
	T_TIPO_DATA('154197','139.2'),
	T_TIPO_DATA('167065','139.2'),
	T_TIPO_DATA('169245','139.2'),
	T_TIPO_DATA('163393','123.21'),
	T_TIPO_DATA('163874','123.8'),
	T_TIPO_DATA('167833','123.8'),
	T_TIPO_DATA('168772','123.5')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ECO_CONDICIONANTES_EXPEDIENTE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE IMPORTE RESERVA');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ WHERE TBJ.TBJ_NUM_TRABAJO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
		
       -- DBMS_OUTPUT.PUT_LINE(V_SQL);		
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       -- DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
			--Si existe realizamos otra comprobacion
			IF V_NUM_TABLAS > 0 THEN	
			
					V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ ATB 
								INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ on ATB.TBJ_ID = TBJ.TBJ_ID 
								WHERE TBJ.TBJ_NUM_TRABAJO = '||TRIM(V_TMP_TIPO_DATA(1));
					
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
					
					IF V_NUM_TABLAS > 1 THEN

				--DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL IMPORTE DEL TRABAJO '||TRIM(V_TMP_TIPO_DATA(1))||'');
				
					V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET TBJ_IMPORTE_TOTAL = ('||V_NUM_TABLAS||'*(TO_NUMBER('''||TRIM(V_TMP_TIPO_DATA(2))||''',''99999999.99''))),
								USUARIOMODIFICAR = '''||V_USUARIO||''',
								FECHAMODIFICAR = SYSDATE
								WHERE TBJ_NUM_TRABAJO = '||TRIM(V_TMP_TIPO_DATA(1));
                   --DBMS_OUTPUT.PUT_LINE(V_MSQL);
					EXECUTE IMMEDIATE V_MSQL;
					
					ELSE 
					
						V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET TBJ_IMPORTE_TOTAL = (TO_NUMBER('''||TRIM(V_TMP_TIPO_DATA(2))||''',''99999999.99'')),
									USUARIOMODIFICAR = '''||V_USUARIO||''',
									FECHAMODIFICAR = SYSDATE
									WHERE TBJ_NUM_TRABAJO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                       -- DBMS_OUTPUT.PUT_LINE(V_MSQL);
                        EXECUTE IMMEDIATE V_MSQL;

					END IF;
				
				
			--El activo no existe
			ELSE
				  DBMS_OUTPUT.PUT_LINE('[ERROR]:  EL IMPORTE DEL TRABAJO '''||TRIM(V_TMP_TIPO_DATA(1))||' NO HA SIDO ACTUALIZADO');
			END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  EL IMPORTE DEL TRABAJO HA SIDO ACTUALIZADO CORRECTAMENTE ');

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

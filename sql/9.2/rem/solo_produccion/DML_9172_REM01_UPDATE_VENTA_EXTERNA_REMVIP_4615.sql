--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4615
--## PRODUCTO=NO
--##
--## Finalidad: MODIFICAR ESTADO ACTIVO A VENDIDO, PONER FECHA VENTA EXTERNA, IMPORTE VENTA EXTERNA 
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-4615';   
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ACT_NUM_ACTIVO NUMBER(16);
    ECO_ID NUMBER(16);
    FECHA_VENTA VARCHAR2(30 CHAR);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--ACT_NUM_ACTIVO , FECHA_VENTA, IMPORTE_VENTA 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('6031230','13/12/2017','54470.39'),
		T_JBV('6077574','13/12/2017','41312.07'),
		T_JBV('6038462','13/12/2017','134731'),
		T_JBV('6035664','13/12/2017','25532.95'),
		T_JBV('6037388','13/12/2017','26453.27'),
		T_JBV('6037550','13/12/2017','89379.82'),
		T_JBV('6033231','13/12/2017','64857.89'),
		T_JBV('6043521','13/12/2017','29997.09'),
		T_JBV('6134517','13/12/2017','2500'),
		T_JBV('6043596','12/12/2017','70000'),
		T_JBV('6135068','13/12/2017','41740.58'),
		T_JBV('6035906','13/12/2017','13505.77'),
		T_JBV('6040552','13/12/2017','21920.82'),
		T_JBV('6040629','13/12/2017','40549.79'),
		T_JBV('6077488','13/12/2017','28083.93'),
		T_JBV('6037052','13/12/2017','32168.3'),
		T_JBV('6035454','13/12/2017','101477.02'),
		T_JBV('6077494','13/12/2017','18122.55'),
		T_JBV('6037603','13/12/2017','27498.86'),
		T_JBV('6030228','13/12/2017','19054.18'),
		T_JBV('6081922','13/12/2017','23077.09'),
		T_JBV('6034967','13/12/2017','41870.55'),
		T_JBV('6033629','13/12/2017','86611.89'),
		T_JBV('6081889','13/12/2017','15569.63'),
		T_JBV('6081890','13/12/2017','34984.77'),
		T_JBV('6038988','13/12/2017','30317.01'),
		T_JBV('6136406','13/12/2017','17518.74'),
		T_JBV('6030316','13/12/2017','62045.44'),
		T_JBV('6136956','13/12/2017','30000'),
		T_JBV('6030241','13/12/2017','105035.02'),
		T_JBV('6031901','13/12/2017','21357.24'),
		T_JBV('6039000','13/12/2017','44388.3'),
		T_JBV('6036058','13/12/2017','11549.32'),
		T_JBV('6077360','13/12/2017','47741.83'),
		T_JBV('6029147','13/12/2017','45093.12'),
		T_JBV('6034061','13/12/2017','119267.03'),
		T_JBV('6078023','13/12/2017','87729.02'),
		T_JBV('6036086','13/12/2017','4572'),
		T_JBV('6077251','13/12/2017','109304.62'),
		T_JBV('6031967','13/12/2017','35518.28'),
		T_JBV('6084189','13/12/2017','49878.74'),
		T_JBV('6079075','13/12/2017','36711.28'),
		T_JBV('6031976','13/12/2017','27464.55'),
		T_JBV('6040665','13/12/2017','25195.75'),
		T_JBV('6134804','13/12/2017','51434.88'),
		T_JBV('6084165','13/12/2017','33875.02'),
		T_JBV('6084166','13/12/2017','31740.22'),
		T_JBV('6084153','13/12/2017','52065.31'),
		T_JBV('6032353','13/12/2017','136512.51'),
		T_JBV('6029353','13/12/2017','281.82'),
		T_JBV('6033728','13/12/2017','96473.02'),
		T_JBV('6077277','13/12/2017','109133.15'),
		T_JBV('6077278','13/12/2017','95224.37'),
		T_JBV('6077280','13/12/2017','109133.15'),
		T_JBV('6077281','13/12/2017','95375.73'),
		T_JBV('6077282','13/12/2017','113076.36'),
		T_JBV('6077283','13/12/2017','117282.45'),
		T_JBV('6077284','13/12/2017','95375.73'),
		T_JBV('6077285','13/12/2017','148852.03'),
		T_JBV('6077286','13/12/2017','95375.73'),
		T_JBV('6077304','13/12/2017','52713.04'),
		T_JBV('6077305','13/12/2017','55795.32'),
		T_JBV('6077306','13/12/2017','55795.32'),
		T_JBV('6077307','13/12/2017','52713.04'),
		T_JBV('6077308','13/12/2017','59504.2'),
		T_JBV('6077309','13/12/2017','61430.72'),
		T_JBV('6077310','13/12/2017','57594.41'),
		T_JBV('6077311','13/12/2017','57594.41'),
		T_JBV('6077312','13/12/2017','141772.6'),
		T_JBV('6077313','13/12/2017','141772.6'),
		T_JBV('6136888','13/12/2017','144618.28'),
		T_JBV('6032802','13/12/2017','3709.7'),
		T_JBV('6029423','13/12/2017','3709.7'),
		T_JBV('6038157','13/12/2017','3709.7'),
		T_JBV('6041861','13/12/2017','3709.7'),
		T_JBV('6032803','13/12/2017','3709.7'),
		T_JBV('6032804','13/12/2017','3709.7'),
		T_JBV('6077314','13/12/2017','79133.34'),
		T_JBV('6040525','13/12/2017','44388.3'),
		T_JBV('6040969','13/12/2017','37433.02'),
		T_JBV('6030170','13/12/2017','33875.02'),
		T_JBV('6081461','13/12/2017','113481.45'),
		T_JBV('6043479','13/12/2017','29534.44'),
		T_JBV('6081763','13/12/2017','25072.22'),
		T_JBV('6043480','13/12/2017','25072.22'),
		T_JBV('6035782','13/12/2017','25072.22'),
		T_JBV('6037467','13/12/2017','25072.22'),
		T_JBV('6030363','13/12/2017','25335.81'),
		T_JBV('6037828','13/12/2017','211775.04'),
		T_JBV('6032845','13/12/2017','3295.32'),
		T_JBV('6029464','13/12/2017','3295.32'),
		T_JBV('6040683','13/12/2017','36851.1'),
		T_JBV('6041534','13/12/2017','34730.47'),
		T_JBV('6039035','13/12/2017','55903.82'),
		T_JBV('6043834','13/12/2017','62339.02'),
		T_JBV('6036127','13/12/2017','42852.89'),
		T_JBV('6038822','13/12/2017','106572.14'),
		T_JBV('6033738','13/12/2017','94288.91'),
		T_JBV('6032029','13/12/2017','42852.89'),
		T_JBV('6037844','13/12/2017','59742.33'),
		T_JBV('6081787','13/12/2017','22596.5'),
		T_JBV('6135253','13/12/2017','83257.38'),
		T_JBV('6032034','13/12/2017','34080.74'),
		T_JBV('6078092','13/12/2017','51445.39'),
		T_JBV('6081865','13/12/2017','26143.92'),
		T_JBV('6083964','13/12/2017','29777.53'),
		T_JBV('6083965','13/12/2017','2750'),
		T_JBV('6136298','13/12/2017','57065.75'),
		T_JBV('6080321','13/12/2017','130759.65'),
		T_JBV('6136960','13/12/2017','11341.17'),
		T_JBV('6136923','13/12/2017','51520.64'),
		T_JBV('6136663','13/12/2017','42957.93'),
		T_JBV('6030264','13/12/2017','103501.33'),
		T_JBV('6036176','13/12/2017','20547.28'),
		T_JBV('6029497','13/12/2017','40549.79'),
		T_JBV('6037889','13/12/2017','35175.88'),
		T_JBV('6077059','13/12/2017','25195.75'),
		T_JBV('6043899','13/12/2017','121401.83'),
		T_JBV('6037436','13/12/2017','56959.49'),
		T_JBV('6078874','13/12/2017','321049.01'),
		T_JBV('6040436','13/12/2017','13384.99'),
		T_JBV('6081732','13/12/2017','16221.96'),
		T_JBV('6081733','13/12/2017','50358.72'),
		T_JBV('6081734','13/12/2017','48611.27'),
		T_JBV('6076811','13/12/2017','30035.13'),
		T_JBV('6039108','13/12/2017','58974.63'),
		T_JBV('6136937','13/12/2017','24341.48'),
		T_JBV('6036549','13/12/2017','113481.45'),
		T_JBV('6040991','13/12/2017','99662.82'),
		T_JBV('6043941','13/12/2017','124248.23'),
		T_JBV('6084726','13/12/2017','75096.37'),
		T_JBV('6084727','13/12/2017','152251.29'),
		T_JBV('6084728','13/12/2017','134731'),
		T_JBV('6136075','13/12/2017','59742.33'),
		T_JBV('6076508','13/12/2017','129722.2'),
		T_JBV('6036268','13/12/2017','17351.52'),
		T_JBV('6043976','13/12/2017','52065.31'),
		T_JBV('6078728','13/12/2017','111897.48'),
		T_JBV('6036281','13/12/2017','45947.8'),
		T_JBV('6076622','13/12/2017','133072.05'),
		T_JBV('6037990','13/12/2017','41366.45'),
		T_JBV('6083498','13/12/2017','47175.83'),
		T_JBV('6136237','13/12/2017','60212.28'),
		T_JBV('6083520','13/12/2017','125380.83'),
		T_JBV('6134631','13/12/2017','75096.37'),
		T_JBV('6035342','13/12/2017','59742.33'),
		T_JBV('6043283','13/12/2017','147731.03'),
		T_JBV('6035343','13/12/2017','78167.17'),
		T_JBV('6135092','13/12/2017','37195.28'),
		T_JBV('6083418','13/12/2017','45984.66'),
		T_JBV('6083429','13/12/2017','55903.82'),
		T_JBV('6076285','13/12/2017','55577.67'),
		T_JBV('6043287','13/12/2017','81237.98'),
		T_JBV('6081305','13/12/2017','33819.58'),
		T_JBV('6081306','13/12/2017','44104.87'),
		T_JBV('6030735','13/12/2017','35703.27'),
		T_JBV('6034143','13/12/2017','35703.27'),
		T_JBV('6041049','13/12/2017','35703.27'),
		T_JBV('6041050','13/12/2017','35703.27'),
		T_JBV('6076163','13/12/2017','40549.79'),
		T_JBV('6135707','13/12/2017','52065.31'),
		T_JBV('6083328','13/12/2017','171059.08'),
		T_JBV('6133687','13/12/2017','25195.75'),
		T_JBV('6076007','13/12/2017','166460.87'),
		T_JBV('6075971','13/12/2017','73918.18'),
		T_JBV('6083198','13/12/2017','22259.37'),
		T_JBV('6083199','13/12/2017','2607.03'),
		T_JBV('6075980','13/12/2017','62399.52'),
		T_JBV('6082685','13/12/2017','19014.41'),
		T_JBV('6075897','13/12/2017','33875.02'),
		T_JBV('6075905','13/12/2017','207286.68'),
		T_JBV('6080215','13/12/2017','108070.34'),
		T_JBV('6080879','13/12/2017','39555.48'),
		T_JBV('6080083','13/12/2017','131600.14'),
		T_JBV('6133666','13/12/2017','36711.28'),
		T_JBV('6080043','13/12/2017','49042.35'),
		T_JBV('6083046','13/12/2017','31808.34'),
		T_JBV('6079904','13/12/2017','80451.94'),
		T_JBV('6079567','13/12/2017','119447.47'),
		T_JBV('6082990','13/12/2017','19918.29'),
		T_JBV('6079608','13/12/2017','90450.4'),
		T_JBV('6079512','13/12/2017','41585.19'),
		T_JBV('6079513','13/12/2017','3409.63'),
		T_JBV('6134818','13/12/2017','44388.3'),
		T_JBV('6079769','13/12/2017','171043.62'),
		T_JBV('6079843','13/12/2017','52065.31'),
		T_JBV('6080615','13/12/2017','64796.62'),
		T_JBV('6134900','13/12/2017','73188.92'),
		T_JBV('6134081','13/12/2017','77218.74'),
		T_JBV('6134899','13/12/2017','77218.74'),
		T_JBV('6135740','13/12/2017','77218.74'),
		T_JBV('6135489','13/12/2017','2186.19'),
		T_JBV('6134883','13/12/2017','2186.19'),
		T_JBV('6134848','13/12/2017','2186.19'),
		T_JBV('6135123','13/12/2017','2186.19'),
		T_JBV('6135598','13/12/2017','2186.19'),
		T_JBV('6134060','13/12/2017','2186.19'),
		T_JBV('6135203','13/12/2017','77218.74'),
		T_JBV('6134467','13/12/2017','77218.74'),
		T_JBV('6134850','13/12/2017','77218.74'),
		T_JBV('6134799','13/12/2017','77218.74'),
		T_JBV('6133752','13/12/2017','77218.74'),
		T_JBV('6135410','13/12/2017','77218.74'),
		T_JBV('6134915','13/12/2017','77218.74'),
		T_JBV('6135147','13/12/2017','2186.19'),
		T_JBV('6135465','13/12/2017','2186.19'),
		T_JBV('6134168','13/12/2017','2186.19'),
		T_JBV('6134224','13/12/2017','2186.19'),
		T_JBV('6133739','13/12/2017','2186.19'),
		T_JBV('6135806','13/12/2017','2186.19'),
		T_JBV('6137018','13/12/2017','2186.19'),
		T_JBV('6136648','13/12/2017','2186.19'),
		T_JBV('6136200','13/12/2017','2186.19'),
		T_JBV('6136081','13/12/2017','2186.19'),
		T_JBV('6133808','13/12/2017','2186.19'),
		T_JBV('6134780','13/12/2017','2186.19'),
		T_JBV('6135906','13/12/2017','2186.19'),
		T_JBV('6133819','13/12/2017','2186.19'),
		T_JBV('6134842','13/12/2017','63894.27'),
		T_JBV('6133859','13/12/2017','57508.41'),
		T_JBV('6346179','13/12/2017','58078.88'),
		T_JBV('6346231','13/12/2017','52761.4'),
		T_JBV('6346432','13/12/2017','52738.28'),
		T_JBV('6346482','13/12/2017','58078.88'),
		T_JBV('6354088','13/12/2017','52065.31'),
		T_JBV('6520368','22/03/2018','4.67'),
		T_JBV('6520360','11/12/2017','6000'),
		T_JBV('6520180','11/12/2017','65000'),
		T_JBV('6520301','13/12/2017','17351.52'),
		T_JBV('6520203','13/12/2017','278657.14'),
		T_JBV('6520168','13/12/2017','199479.9'),
		T_JBV('6520199','13/12/2017','33866.41'),
		T_JBV('6520393','13/12/2017','56388.9'),
		T_JBV('6711402','13/12/2017','26648.4'),
		T_JBV('6744969','13/12/2017','42803.42'),
		T_JBV('6745012','13/12/2017','2787.95'),
		T_JBV('6744966','13/12/2017','63580.84'),
		T_JBV('6745238','13/12/2017','382177.06'),
		T_JBV('6757961','13/12/2017','98127.42'),
		T_JBV('6760157','13/12/2017','111498.11'),
		T_JBV('6781040','13/12/2017','48107.02'),
		T_JBV('6780674','13/12/2017','54489.21'),
		T_JBV('6780974','13/12/2017','42469.04'),
		T_JBV('6781000','13/12/2017','2980.84'),
		T_JBV('6780918','13/12/2017','394.16'),
		T_JBV('6780953','13/12/2017','47869.73'),
		T_JBV('6785293','13/12/2017','67804.22'),
		T_JBV('6785333','13/12/2017','68515.82'),
		T_JBV('6788816','13/12/2017','43175.81'),
		T_JBV('6798396','13/12/2017','49528.47')
		); 
	V_TMP_JBV T_JBV; 
    
BEGIN	

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));

	FECHA_VENTA := TRIM(V_TMP_JBV(2));

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
	 				    FECHAMODIFICAR = SYSDATE  
					  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
		 			  , DD_SCM_ID = 5 
					  , ACT_VENTA_EXTERNA_FECHA = TO_DATE('''||FECHA_VENTA||''',''DD/MM/YYYY'') 
					  , ACT_VENTA_EXTERNA_IMPORTE = '||V_TMP_JBV(3)||' 
					    WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO
		 			  ;
	    	EXECUTE IMMEDIATE V_SQL;

	    	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registroS en la tabla '||V_TABLA);

	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
	
	END IF;

	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	   
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

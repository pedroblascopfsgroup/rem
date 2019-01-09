--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20190109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2937
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2937'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV('6865165','40844.53'),
			T_JBV('6864198','159902.90'),
			T_JBV('6866294','106853.81'),
			T_JBV('6866883','54898.85'),
			T_JBV('6864199','139000.48'),
			T_JBV('6866295','103244.79'),
			T_JBV('6866464','34524.31'),
			T_JBV('6866465','35400.48'),
			T_JBV('6866512','34524.31'),
			T_JBV('6866466','35400.48'),
			T_JBV('6866760','34524.31'),
			T_JBV('6867126','35400.48'),
			T_JBV('6867050','36585.90'),
			T_JBV('6866500','37108.66'),
			T_JBV('6866761','30343.37'),
			T_JBV('6866762','31216.61'),
			T_JBV('6867051','35687.64'),
			T_JBV('6867154','43713.12'),
			T_JBV('6867155','42295.77'),
			T_JBV('6866567','35687.64'),
			T_JBV('6865968','43713.12'),
			T_JBV('6865969','42295.77'),
			T_JBV('6867540','35687.64'),
			T_JBV('6867156','43713.12'),
			T_JBV('6867541','42295.77'),
			T_JBV('6866993','38743.21'),
			T_JBV('6866994','43794.11'),
			T_JBV('6866995','44368.70'),
			T_JBV('6866763','32267.63'),
			T_JBV('6865970','33998.72'),
			T_JBV('6865971','41884.31'),
			T_JBV('6867158','38350.14'),
			T_JBV('6867544','38085.22'),
			T_JBV('6866513','38328.92'),
			T_JBV('6867545','38048.68'),
			T_JBV('6867546','33586.94'),
			T_JBV('6868170','38842.84'),
			T_JBV('6865973','35484.01'),
			T_JBV('6867128','32971.68'),
			T_JBV('6865974','39321.37'),
			T_JBV('6865975','35511.11'),
			T_JBV('6867129','32970.50'),
			T_JBV('6866601','39321.37'),
			T_JBV('6868172','35621.89'),
			T_JBV('6866602','33124.88'),
			T_JBV('6866603','39634.86'),
			T_JBV('6868174','41052.72'),
			T_JBV('6864685','40229.07'),
			T_JBV('6864357','40637.89'),
			T_JBV('6864687','40351.63'),
			T_JBV('6864688','40695.64'),
			T_JBV('6865212','40379.92'),
			T_JBV('6864192','3033.31'),
			T_JBV('6866280','2541.18'),
			T_JBV('6866281','2844.03'),
			T_JBV('6866378','2844.03'),
			T_JBV('6866282','5263.88'),
			T_JBV('6866379','6309.28'),
			T_JBV('6866873','2822.68'),
			T_JBV('6865079','3070.19'),
			T_JBV('6865475','2805.21'),
			T_JBV('6866874','2761.53'),
			T_JBV('6864200','684.72'),
			T_JBV('6866296','733.03'),
			T_JBV('6866506','926.31'),
			T_JBV('6865166','789.60'),
			T_JBV('6866455','513.83'),
			T_JBV('6866456','401.88'),
			T_JBV('6866949','910.99'),
			T_JBV('6866457','899.21'),
			T_JBV('6866950','571.58'),
			T_JBV('6866951','824.96'),
			T_JBV('6865476','2567.39'),
			T_JBV('6867120','676.47'),
			T_JBV('6865167','471.40'),
			T_JBV('6866884','586.91'),
			T_JBV('6865561','2780.94'),
			T_JBV('6865080','2712.99'),
			T_JBV('6866283','3814.69'),
			T_JBV('6866875','2613.99'),
			T_JBV('6866284','2613.99'),
			T_JBV('6865477','3419.63'),
			T_JBV('6866942','391.18'),
			T_JBV('6866876','3230.36'),
			T_JBV('6866877','3557.46'),
			T_JBV('6864193','2960.51'),
			T_JBV('6864194','2649.90'),
			T_JBV('6866943','2649.90'),
			T_JBV('6865150','2649.90'),
			T_JBV('6865478','2926.53'),
			T_JBV('6865151','2856.65'),
			T_JBV('6865479','2611.07'),
			T_JBV('6865562','2603.31'),
			T_JBV('6865152','2722.70'),
			T_JBV('6865153','2373.26'),
			T_JBV('6864195','3533.20'),
			T_JBV('6866285','2400.44'),
			T_JBV('6865563','4989.19'),
			T_JBV('6865154','3147.85'),
			T_JBV('6865480','4416.50'),
			T_JBV('6865155','3780.72'),
			T_JBV('6865156','3070.19'),
			T_JBV('6865427','2751.82'),
			T_JBV('6866286','2623.69'),
			T_JBV('6866287','3921.46'),
			T_JBV('6865564','3308.00'),
			T_JBV('6865565','2842.09'),
			T_JBV('6865428','3965.14'),
			T_JBV('6866878','3033.31'),
			T_JBV('6865157','2541.18'),
			T_JBV('6866879','2844.03'),
			T_JBV('6865481','2844.03'),
			T_JBV('6866944','5154.20'),
			T_JBV('6865158','6566.51'),
			T_JBV('6866880','8423.37'),
			T_JBV('6864196','2822.68'),
			T_JBV('6866288','3070.19'),
			T_JBV('6866945','2805.21'),
			T_JBV('6865159','3144.94'),
			T_JBV('6865482','2567.39'),
			T_JBV('6865160','2780.94'),
			T_JBV('6865429','2712.99'),
			T_JBV('6865566','3814.69'),
			T_JBV('6865483','2613.99'),
			T_JBV('6865161','2613.99'),
			T_JBV('6866289','3439.05'),
			T_JBV('6866881','3885.55'),
			T_JBV('6864197','3644.82'),
			T_JBV('6865484','3557.46'),
			T_JBV('6865430','2960.51'),
			T_JBV('6865485','2649.90'),
			T_JBV('6866946','2649.90'),
			T_JBV('6866290','2649.90'),
			T_JBV('6865431','2856.65'),
			T_JBV('6865432','2611.07'),
			T_JBV('6866882','2606.22'),
			T_JBV('6865162','2722.70'),
			T_JBV('6866291','2373.26'),
			T_JBV('6865433','3400.22'),
			T_JBV('6866947','2533.42'),
			T_JBV('6865434','5275.53'),
			T_JBV('6866453','3147.85'),
			T_JBV('6865567','4239.84'),
			T_JBV('6865163','4210.72'),
			T_JBV('6865164','3914.67'),
			T_JBV('6866292','2751.82'),
			T_JBV('6866293','2623.69'),
			T_JBV('6865568','3921.46'),
			T_JBV('6866503','3308.00'),
			T_JBV('6866504','2842.09'),
			T_JBV('6866505','3965.14'),
			T_JBV('6866948','2926.53'),
			T_JBV('6866507','733.03'),
			T_JBV('6866508','926.31'),
			T_JBV('6866885','756.60'),
			T_JBV('6866297','723.61'),
			T_JBV('6866298','812.00'),
			T_JBV('6866493','458.44'),
			T_JBV('6866494','401.88'),
			T_JBV('6867121','870.92'),
			T_JBV('6866495','571.58'),
			T_JBV('6864201','824.96'),
			T_JBV('6864202','577.47'),
			T_JBV('6864203','672.93'),
			T_JBV('6866490','143594.66'),
			T_JBV('6866454','109210.46'),
			T_JBV('6866491','93567.02'),
			T_JBV('6866492','61580.22'),
			T_JBV('6866301','38054.06'),
			T_JBV('6866462','30388.38'),
			T_JBV('6864211','38054.06'),
			T_JBV('6867124','40394.69'),
			T_JBV('6865965','38054.06'),
			T_JBV('6867125','40394.69'),
			T_JBV('6866991','41315.59'),
			T_JBV('6866463','39252.98'),
			T_JBV('6866886','41315.59'),
			T_JBV('6865960','39283.74'),
			T_JBV('6867122','41365.92'),
			T_JBV('6866496','39322.88'),
			T_JBV('6864205','39022.49'),
			T_JBV('6864207','30926.09'),
			T_JBV('6866509','41674.95'),
			T_JBV('6866300','39022.49'),
			T_JBV('6866497','30926.09'),
			T_JBV('6865962','41674.95'),
			T_JBV('6865963','38830.98'),
			T_JBV('6864209','30734.58'),
			T_JBV('6866511','41631.61'),
			T_JBV('6866987','38115.83'),
			T_JBV('6866460','31009.79'),
			T_JBV('6866461','40268.86'),
			T_JBV('6865605','3792.54'),
			T_JBV('6864183','3484.15'),
			T_JBV('6864184','4213.60'),
			T_JBV('6865606','3635.38'),
			T_JBV('6864911','3246.94'),
			T_JBV('6866374','3267.69'),
			T_JBV('6864611','3229.15'),
			T_JBV('6865078','3970.45'),
			T_JBV('6864612','3401.13'),
			T_JBV('6864613','3540.50'),
			T_JBV('6865421','3558.29'),
			T_JBV('6866940','3611.66'),
			T_JBV('6865422','3558.29'),
			T_JBV('6865423','4139.47'),
			T_JBV('6866375','4865.96'),
			T_JBV('6865607','4097.96'),
			T_JBV('6865424','4086.10'),
			T_JBV('6866941','3899.29'),
			T_JBV('6865425','3792.54'),
			T_JBV('6864185','3484.15'),
			T_JBV('6864186','4213.60'),
			T_JBV('6864187','3635.38'),
			T_JBV('6864188','3246.94'),
			T_JBV('6864189','3238.04'),
			T_JBV('6865148','3229.15'),
			T_JBV('6866376','3970.45'),
			T_JBV('6864190','3401.13'),
			T_JBV('6865426','3540.50'),
			T_JBV('6864191','3558.29'),
			T_JBV('6866275','3611.66'),
			T_JBV('6866276','3558.29'),
			T_JBV('6866277','4139.47'),
			T_JBV('6866278','3982.32'),
			T_JBV('6866279','4865.96'),
			T_JBV('6865474','4097.96'),
			T_JBV('6865149','4086.10'),
			T_JBV('6866377','4195.81')); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA BORRADO');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_OFR 
				   SET ACT_OFR_IMPORTE = '||V_TMP_JBV(2)||'
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
				   AND OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = 90142568)';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
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

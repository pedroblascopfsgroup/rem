--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200608
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7642
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en GEX_GASTOS_EXPEDIENTE los datos añadidos en T_ARRAY_DATA.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-7642'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'GEX_GASTOS_EXPEDIENTE';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	 T_FUNCION('6008388','04','01','52769407R','199.80','0.9'),
	 T_FUNCION('6007301','04','01','B50645266','463.50','0.9'),
	 T_FUNCION('6008413','04','01','B53266581','494.10','0.9'),
	 T_FUNCION('6008314','04','01','30991790A','1756.57','1.9'),
	 T_FUNCION('6006756','04','01','B86053220','49.40','1.9'),
	 T_FUNCION('6009017','04','01','B95062717','741.00','1.9'),
	 T_FUNCION('6008426','04','01','B36972156','1999.50','0.93'),
	 T_FUNCION('6008421','04','01','B15962657','2204.00','1.9'),
	 T_FUNCION('6005101','04','01','30991790A','1111.50','1.9'),
	 T_FUNCION('6008944','04','01','26013192P','2040.60','1.9'),
	 T_FUNCION('6008945','04','01','26013192P','2188.80','1.9'),
	 T_FUNCION('6008388','05','01','52769407R','133.20','0.6'),
	 T_FUNCION('6007301','05','01','B50645266','309.00','0.6'),
	 T_FUNCION('6008413','05','01','B53266581','329.40','0.6'),
	 T_FUNCION('6008314','05','01','B07909609','554.71','0.6'),
	 T_FUNCION('6006756','05','01','B98693518','15.60','0.6'),
	 T_FUNCION('6009017','05','01','B48753586','234.00','0.6'),
	 T_FUNCION('6008426','05','01','A78868726','989.00','0.46'),
	 T_FUNCION('6008421','05','01','34874151X','696.00','0.6'),
	 T_FUNCION('6005101','05','01','B18954008','351.00','0.6'),
	 T_FUNCION('6008944','05','01','77323890Y','644.40','0.6'),
	 T_FUNCION('6008945','05','01','77323890Y','691.20','0.6'),
	 T_FUNCION('6012435','PRE_Y_COL','01','B64856446','24920.00','1.78'),
	 T_FUNCION('6012341','PRE_Y_COL','01','17700842L','2075.00','2.5'),
	 T_FUNCION('6008280','PRE_Y_COL','01','80145556D','1242.50','2.5'),
	 T_FUNCION('6007291','PRE_Y_COL','01','B43368976','1447.50','1.5'),
	 T_FUNCION('6008930','PRE_Y_COL','01','B04481032','697.50','1.5'),
	 T_FUNCION('6008492','PRE_Y_COL','01','B04481032','826.50','1.5'),
	 T_FUNCION('6008937','PRE_Y_COL','01','B76117498','465.00','2.5'),
	 T_FUNCION('6012336','PRE_Y_COL','01','77630041G','32555.00','1.7'),
	 T_FUNCION('6001286','PRE_Y_COL','01','B25696147','825.00','2.5'),
	 T_FUNCION('6008361','PRE_Y_COL','01','24739035M','675.00','2.5'),
	 T_FUNCION('6006197','PRE_Y_COL','01','B25616541','5258.00','1.91'),
	 T_FUNCION('6012270','PRE_Y_COL','01','A08469967','1000.00','2.5'),
	 T_FUNCION('6012425','PRE_Y_COL','01','B60973476','13546.20','2.11'),
	 T_FUNCION('6011912','PRE_Y_COL','01','B64171663','5400.00','2.4'),
	 T_FUNCION('6004514','PRE_Y_COL','01','B59620534','976.50','1.5'),
	 T_FUNCION('6010135','PRE_Y_COL','01','43043941Q','2482.00','1.46'),
	 T_FUNCION('6012306','PRE_Y_COL','01','33961519H','1765.00','2.5'),
	 T_FUNCION('6008161','PRE_Y_COL','01','B98693518','1000.00','2.5'),
	 T_FUNCION('6007887','PRE_Y_COL','01','B73665291','154.50','1.5'),
	 T_FUNCION('6008121','PRE_Y_COL','01','52601367E','633.25','2.5'),
	 T_FUNCION('6008706','PRE_Y_COL','01','17149283T','600.00','2.5'),
	 T_FUNCION('6007914','PRE_Y_COL','01','B04870903','1050.00','2.5'),
	 T_FUNCION('6000040','PRE_Y_COL','01','B85845337','2610.00','1.45'),
	 T_FUNCION('6012219','PRE_Y_COL','01','33961519H','2750.00','2.5'),
	 T_FUNCION('6008381','PRE_Y_COL','01','B32369183','1044.00','1.5'),
	 T_FUNCION('6007835','PRE_Y_COL','01','B07909609','1588.50','1.5'),
	 T_FUNCION('6008378','PRE_Y_COL','01','B65493611','875.00','2.5'),
	 T_FUNCION('6007456','PRE_Y_COL','01','21446796D','153.00','1.5'),
	 T_FUNCION('6008037','PRE_Y_COL','01','52119456F','1282.50','2.5'),
	 T_FUNCION('6001783','PRE_Y_COL','01','B98306145','3485.00','2.5'),
	 T_FUNCION('6012373','PRE_Y_COL','01','34848502Y','2250.00','2.5'),
	 T_FUNCION('6007824','PRE_Y_COL','01','B04870903','750.00','2.5'),
	 T_FUNCION('6006851','PRE_Y_COL','01','B62681697','1532.50','2.5'),
	 T_FUNCION('6007622','PRE_Y_COL','01','B64265523','750.00','2.5'),
	 T_FUNCION('6012354','PRE_Y_COL','01','75894290V','750.00','2.5'),
	 T_FUNCION('6008071','PRE_Y_COL','01','43148866S','2476.95','1.47'),
	 T_FUNCION('6008744','PRE_Y_COL','01','B98693518','167.50','2.5'),
	 T_FUNCION('6008979','PRE_Y_COL','01','B76117498','232.50','2.5'),
	 T_FUNCION('6008717','PRE_Y_COL','01','B54591102','3567.50','2.5'),
	 T_FUNCION('6007169','PRE_Y_COL','01','B12891735','3750.00','2.5'),
	 T_FUNCION('6010308','PRE_Y_COL','01','B25696147','1455.63','2.5'),
	 T_FUNCION('6006958','PRE_Y_COL','01','B97729412','495.00','1.5'),
	 T_FUNCION('6008857','PRE_Y_COL','01','B65493611','237.50','2.5'),
	 T_FUNCION('6008961','PRE_Y_COL','01','B04481032','76.50','1.5'),
	 T_FUNCION('6006251','PRE_Y_COL','01','B43524149','650.00','2.5'),
	 T_FUNCION('6012084','PRE_Y_COL','01','B64856446','1875.00','1.5'),
	 T_FUNCION('6008643','PRE_Y_COL','01','B04751137','487.50','1.5'),
	 T_FUNCION('6008396','PRE_Y_COL','01','B87084968','347.50','2.5'),
	 T_FUNCION('6008068','PRE_Y_COL','01','B97030837','500.00','2.5'),
	 T_FUNCION('6007220','PRE_Y_COL','01','B53497970','1200.00','2.5'),
	 T_FUNCION('6008338','PRE_Y_COL','01','B61789046','4440.80','2.44'),
	 T_FUNCION('6007948','PRE_Y_COL','01','B61789046','5075.46','2.41'),
	 T_FUNCION('6008519','PRE_Y_COL','01','B61789046','219.00','1.5'),
	 T_FUNCION('6008391','PRE_Y_COL','01','B61789046','219.00','1.5'),
	 T_FUNCION('6008184','PRE_Y_COL','01','18968244Y','592.50','1.5'),
	 T_FUNCION('6008877','PRE_Y_COL','01','B04772638','619.50','1.5'),
	 T_FUNCION('6008443','PRE_Y_COL','01','B98693518','975.00','2.5'),
	 T_FUNCION('6008217','PRE_Y_COL','01','52119456F','455.40','1.15'),
	 T_FUNCION('6008300','PRE_Y_COL','01','52119456F','445.50','1.5'),
	 T_FUNCION('6012297','PRE_Y_COL','01','B20486775','20.25','1.5'),
	 T_FUNCION('6012059','PRE_Y_COL','01','06255479P','20790.00','0.99'),
	 T_FUNCION('6008918','PRE_Y_COL','01','B48753586','825.00','2.5'),
	 T_FUNCION('6007698','PRE_Y_COL','01','75894290V','120.00','1.5'),
	 T_FUNCION('6012349','PRE_Y_COL','01','B04351276','3500.00','2.5'),
	 T_FUNCION('6008846','PRE_Y_COL','01','B62107677','812.50','2.5'),
	 T_FUNCION('6009091','PRE_Y_COL','01','B73665291','825.00','2.5'),
	 T_FUNCION('6012482','PRE_Y_COL','01','17700842L','875.00','2.5'),
	 T_FUNCION('6008795','PRE_Y_COL','01','B04772638','675.00','1.5'),
	 T_FUNCION('6008167','PRE_Y_COL','01','B97729412','2010.00','1.5'),
	 T_FUNCION('6009605','PRE_Y_COL','01','B04751137','1067.50','2.5'),
	 T_FUNCION('6002617','PRE_Y_COL','01','44133874W','105.00','1.5'),
	 T_FUNCION('6008416','PRE_Y_COL','01','21446796D','1125.00','1.5'),
	 T_FUNCION('6009018','PRE_Y_COL','01','B04772638','826.50','1.5'),
	 T_FUNCION('6012333','PRE_Y_COL','01','B45636891','2567.00','2.5'),
	 T_FUNCION('6007989','PRE_Y_COL','01','B04481032','991.50','1.5'),
	 T_FUNCION('6009686','PRE_Y_COL','01','B04870903','873.00','3'),
	 T_FUNCION('6008266','PRE_Y_COL','01','B30557532','758.75','2.5'),
	 T_FUNCION('6008301','PRE_Y_COL','01','B98182348','1007.50','2.5'),
	 T_FUNCION('6012374','PRE_Y_COL','01','B17747189','250.00','2.5'),
	 T_FUNCION('6008359','PRE_Y_COL','01','B48753586','1525.00','2.5'),
	 T_FUNCION('6008974','PRE_Y_COL','01','B48753586','930.00','1.5'),
	 T_FUNCION('6012364','PRE_Y_COL','01','33961519H','755.00','2.5'),
	 T_FUNCION('6008141','PRE_Y_COL','01','B04870903','717.50','2.5'),
	 T_FUNCION('6008743','PRE_Y_COL','01','B53266581','2097.50','2.5'),
	 T_FUNCION('6008538','PRE_Y_COL','01','B99430829','615.00','1.5'),
	 T_FUNCION('6012283','PRE_Y_COL','01','B64967961','2272.50','2.5')


      
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
		             SET BORRADO = 1,
			     FECHABORRAR = SYSDATE,
			     USUARIOBORRAR = ''HREOS-7642''
		             WHERE ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							   JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID WHERE OFR.OFR_NUM_OFERTA = '''||V_TMP_FUNCION(1)||''')';
				    	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' borrados correctamente.');
            
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'' || ' (GEX_ID,
											ECO_ID,
											DD_ACC_ID,
											GEX_CODIGO,
											GEX_NOMBRE,
											DD_TCC_ID,
											GEX_IMPORTE_CALCULO,
											GEX_IMPORTE_FINAL,
											VERSION,
											USUARIOCREAR,
											FECHACREAR,
											BORRADO,
											GEX_PROVEEDOR)' || 
			' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL' ||
			',(SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID WHERE OFR.OFR_NUM_OFERTA = '''||V_TMP_FUNCION(1)||''')' ||
			',(SELECT DD_ACC_ID FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS WHERE DD_ACC_CODIGO = '''||V_TMP_FUNCION(2)||''')' ||
			','''||V_TMP_FUNCION(2)||'''' ||
			',(SELECT DD_ACC_DESCRIPCION FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS WHERE DD_ACC_CODIGO = '''||V_TMP_FUNCION(2)||''')' ||
			',(SELECT DD_TCC_ID FROM '||V_ESQUEMA||'.DD_TCC_TIPO_CALCULO WHERE DD_TCC_CODIGO = '''||V_TMP_FUNCION(3)||''')' ||
			',TO_NUMBER('''||V_TMP_FUNCION(6)||''')' ||
			',TO_NUMBER('''||V_TMP_FUNCION(5)||''')' ||
			',0, '''||V_USUARIO||''', SYSDATE, 0' ||
			',(SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||V_TMP_FUNCION(4)||''' AND DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''04'') AND PVE_FECHA_BAJA IS NULL)' || 'FROM DUAL';
				    	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' insertados correctamente.');
						
			 
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;
/
EXIT;

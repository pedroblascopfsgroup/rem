--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3083
--## PRODUCTO=NO
--##
--## Finalidad: Script para sustituir el gestor actual de las configuraciones por las de una Excel adjunta en el item.
--## 			(Cambio en configuración de gestor de activo y supervisor de activo)
--##			Añade en la tabla ACT_GES_DIST_GESTORES los datos del array T_ARRAY_DATA
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-3083';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('igomezr','2','',''),
		T_TIPO_DATA('igomezr','33','',''),
		T_TIPO_DATA('igomezr','5','',''),
		T_TIPO_DATA('igomezr','48','',''),
		T_TIPO_DATA('igomezr','9','',''),
		T_TIPO_DATA('igomezr','13','',''),
		T_TIPO_DATA('igomezr','15','',''),
		T_TIPO_DATA('igomezr','16','',''),
		T_TIPO_DATA('igomezr','19','',''),
		T_TIPO_DATA('igomezr','22','',''),
		T_TIPO_DATA('igomezr','24','',''),
		T_TIPO_DATA('igomezr','28','',''),
		T_TIPO_DATA('igomezr','31','',''),
		T_TIPO_DATA('igomezr','34','',''),
		T_TIPO_DATA('igomezr','35','',''),
		T_TIPO_DATA('igomezr','36','',''),
		T_TIPO_DATA('igomezr','26','',''),
		T_TIPO_DATA('igomezr','38','',''),
		T_TIPO_DATA('igomezr','40','',''),
		T_TIPO_DATA('igomezr','42','',''),
		T_TIPO_DATA('igomezr','44','',''),
		T_TIPO_DATA('igomezr','45','',''),
		T_TIPO_DATA('igomezr','47','',''),
		T_TIPO_DATA('igomezr','50','',''),
		T_TIPO_DATA('maguilar','7','',''),
		T_TIPO_DATA('maguilar','8','',''),
		T_TIPO_DATA('maguilar','17','',''),
		T_TIPO_DATA('maguilar','25','',''),
		T_TIPO_DATA('maguilar','43','',''),
		T_TIPO_DATA('dvillaescusa','6','',''),
		T_TIPO_DATA('dvillaescusa','10','',''),
		T_TIPO_DATA('dvillaescusa','11','',''),
		T_TIPO_DATA('dvillaescusa','51','',''),
		T_TIPO_DATA('dvillaescusa','52','',''),
		T_TIPO_DATA('dvillaescusa','21','',''),
		T_TIPO_DATA('dvillaescusa','29','',''),
		T_TIPO_DATA('dvillaescusa','41','',''),
		T_TIPO_DATA('ateruel','12','',''),
		T_TIPO_DATA('asalag','30','',''),
		T_TIPO_DATA('agonzalezcr','3','',''),
		T_TIPO_DATA('gdelrosal','18','',''),
		T_TIPO_DATA('gdelrosal','23','',''),
		T_TIPO_DATA('mmaldonado','46','46011',''),
		T_TIPO_DATA('mmaldonado','46','46012',''),
		T_TIPO_DATA('mmaldonado','46','46016',''),
		T_TIPO_DATA('mmaldonado','46','46031',''),
		T_TIPO_DATA('mmaldonado','46','46017',''),
		T_TIPO_DATA('mmaldonado','46','46038',''),
		T_TIPO_DATA('mmaldonado','46','46044',''),
		T_TIPO_DATA('mmaldonado','46','46051',''),
		T_TIPO_DATA('mmaldonado','46','46064',''),
		T_TIPO_DATA('mmaldonado','46','46067',''),
		T_TIPO_DATA('mmaldonado','46','46070',''),
		T_TIPO_DATA('mmaldonado','46','46076',''),
		T_TIPO_DATA('mmaldonado','46','46077',''),
		T_TIPO_DATA('mmaldonado','46','46078',''),
		T_TIPO_DATA('mmaldonado','46','46080',''),
		T_TIPO_DATA('mmaldonado','46','46083',''),
		T_TIPO_DATA('mmaldonado','46','46084',''),
		T_TIPO_DATA('mmaldonado','46','46089',''),
		T_TIPO_DATA('mmaldonado','46','46095',''),
		T_TIPO_DATA('mmaldonado','46','46106',''),
		T_TIPO_DATA('mmaldonado','46','46111',''),
		T_TIPO_DATA('mmaldonado','46','46112',''),
		T_TIPO_DATA('mmaldonado','46','46099',''),
		T_TIPO_DATA('mmaldonado','46','46100',''),
		T_TIPO_DATA('mmaldonado','46','46114',''),
		T_TIPO_DATA('mmaldonado','46','46116',''),
		T_TIPO_DATA('mmaldonado','46','46117',''),
		T_TIPO_DATA('mmaldonado','46','46119',''),
		T_TIPO_DATA('mmaldonado','46','46130',''),
		T_TIPO_DATA('mmaldonado','46','46133',''),
		T_TIPO_DATA('mmaldonado','46','46135',''),
		T_TIPO_DATA('mmaldonado','46','46136',''),
		T_TIPO_DATA('mmaldonado','46','46142',''),
		T_TIPO_DATA('mmaldonado','46','46144',''),
		T_TIPO_DATA('mmaldonado','46','46147',''),
		T_TIPO_DATA('mmaldonado','46','46157',''),
		T_TIPO_DATA('mmaldonado','46','46149',''),
		T_TIPO_DATA('mmaldonado','46','46158',''),
		T_TIPO_DATA('mmaldonado','46','46160',''),
		T_TIPO_DATA('mmaldonado','46','46161',''),
		T_TIPO_DATA('mmaldonado','46','46162',''),
		T_TIPO_DATA('mmaldonado','46','46178',''),
		T_TIPO_DATA('mmaldonado','46','46182',''),
		T_TIPO_DATA('mmaldonado','46','46190',''),
		T_TIPO_DATA('mmaldonado','46','46191',''),
		T_TIPO_DATA('mmaldonado','46','46202',''),
		T_TIPO_DATA('mmaldonado','46','46203',''),
		T_TIPO_DATA('mmaldonado','46','46206',''),
		T_TIPO_DATA('mmaldonado','46','46209',''),
		T_TIPO_DATA('mmaldonado','46','46213',''),
		T_TIPO_DATA('mmaldonado','46','46214',''),
		T_TIPO_DATA('mmaldonado','46','46216',''),
		T_TIPO_DATA('mmaldonado','46','46222',''),
		T_TIPO_DATA('mmaldonado','46','46228',''),
		T_TIPO_DATA('mmaldonado','46','46234',''),
		T_TIPO_DATA('mmaldonado','46','46236',''),
		T_TIPO_DATA('mmaldonado','46','46239',''),
		T_TIPO_DATA('mmaldonado','46','46242',''),
		T_TIPO_DATA('mmaldonado','46','46246',''),
		T_TIPO_DATA('mmaldonado','46','46247',''),
		T_TIPO_DATA('mmaldonado','46','46249',''),
		T_TIPO_DATA('mmaldonado','46','46256',''),
		T_TIPO_DATA('mmaldonado','46','46257',''),
		T_TIPO_DATA('mmaldonado','46','46258',''),
		T_TIPO_DATA('mmaldonado','46','46261',''),
		T_TIPO_DATA('mmaldonado','46','46002',''),
		T_TIPO_DATA('mmaldonado','46','46008',''),
		T_TIPO_DATA('mmaldonado','46','46026',''),
		T_TIPO_DATA('mmaldonado','46','46029',''),
		T_TIPO_DATA('mmaldonado','46','46034',''),
		T_TIPO_DATA('mmaldonado','46','46035','46440'),
		T_TIPO_DATA('mmaldonado','46','46048',''),
		T_TIPO_DATA('mmaldonado','46','46904',''),
		T_TIPO_DATA('mmaldonado','46','46060',''),
		T_TIPO_DATA('mmaldonado','46','46059',''),
		T_TIPO_DATA('mmaldonado','46','46061',''),
		T_TIPO_DATA('mmaldonado','46','46063',''),
		T_TIPO_DATA('mmaldonado','46','46066',''),
		T_TIPO_DATA('mmaldonado','46','46085',''),
		T_TIPO_DATA('mmaldonado','46','46093',''),
		T_TIPO_DATA('mmaldonado','46','46098',''),
		T_TIPO_DATA('mmaldonado','46','46105',''),
		T_TIPO_DATA('mmaldonado','46','46113',''),
		T_TIPO_DATA('mmaldonado','46','46123',''),
		T_TIPO_DATA('mmaldonado','46','46127',''),
		T_TIPO_DATA('mmaldonado','46','46125',''),
		T_TIPO_DATA('mmaldonado','46','46131',''),
		T_TIPO_DATA('mmaldonado','46','46139',''),
		T_TIPO_DATA('mmaldonado','46','46140',''),
		T_TIPO_DATA('mmaldonado','46','46155',''),
		T_TIPO_DATA('mmaldonado','46','46156',''),
		T_TIPO_DATA('mmaldonado','46','46181',''),
		T_TIPO_DATA('mmaldonado','46','46187',''),
		T_TIPO_DATA('mmaldonado','46','46195',''),
		T_TIPO_DATA('mmaldonado','46','46197',''),
		T_TIPO_DATA('mmaldonado','46','46198',''),
		T_TIPO_DATA('mmaldonado','46','46208',''),
		T_TIPO_DATA('mmaldonado','46','46211',''),
		T_TIPO_DATA('mmaldonado','46','46215',''),
		T_TIPO_DATA('mmaldonado','46','46231',''),
		T_TIPO_DATA('mmaldonado','46','46233',''),
		T_TIPO_DATA('mmaldonado','46','46235','46410'),
		T_TIPO_DATA('mmaldonado','46','46235','46440'),
		T_TIPO_DATA('mmaldonado','46','46235','46420'),
		T_TIPO_DATA('mmaldonado','46','46235','46419'),
		T_TIPO_DATA('mmaldonado','46','46238',''),
		T_TIPO_DATA('mmaldonado','46','46255',''),
		T_TIPO_DATA('mmaldonado','46','46143',''),
		T_TIPO_DATA('mmaldonado','46','46146',''),
		T_TIPO_DATA('gcarbonell','46','46237',''),
		T_TIPO_DATA('gcarbonell','46','46250',''),
		T_TIPO_DATA('gcarbonell','46','46035','46035'),
		T_TIPO_DATA('gcarbonell','46','46260',''),
		T_TIPO_DATA('gcarbonell','46','46013',''),
		T_TIPO_DATA('gcarbonell','46','46032',''),
		T_TIPO_DATA('gcarbonell','46','46166',''),
		T_TIPO_DATA('gcarbonell','46','46126',''),
		T_TIPO_DATA('gcarbonell','46','46177',''),
		T_TIPO_DATA('gcarbonell','46','46207',''),
		T_TIPO_DATA('gcarbonell','46','46199',''),
		T_TIPO_DATA('gcarbonell','46','46134',''),
		T_TIPO_DATA('gcarbonell','46','46220',''),
		T_TIPO_DATA('gcarbonell','46','46192',''),
		T_TIPO_DATA('gcarbonell','46','46205',''),
		T_TIPO_DATA('gcarbonell','46','46204',''),
		T_TIPO_DATA('gcarbonell','46','46014',''),
		T_TIPO_DATA('gcarbonell','46','46163',''),
		T_TIPO_DATA('gcarbonell','46','46010',''),
		T_TIPO_DATA('gcarbonell','46','46024',''),
		T_TIPO_DATA('gcarbonell','46','46009',''),
		T_TIPO_DATA('gcarbonell','46','46169',''),
		T_TIPO_DATA('gcarbonell','46','46159',''),
		T_TIPO_DATA('gcarbonell','46','46102',''),
		T_TIPO_DATA('gcarbonell','46','46110',''),
		T_TIPO_DATA('gcarbonell','46','46005',''),
		T_TIPO_DATA('gcarbonell','46','46004',''),
		T_TIPO_DATA('gcarbonell','46','46042',''),
		T_TIPO_DATA('gcarbonell','46','46006',''),
		T_TIPO_DATA('gcarbonell','46','46007',''),
		T_TIPO_DATA('gcarbonell','46','46015',''),
		T_TIPO_DATA('gcarbonell','46','46020',''),
		T_TIPO_DATA('gcarbonell','46','46019',''),
		T_TIPO_DATA('gcarbonell','46','46021',''),
		T_TIPO_DATA('gcarbonell','46','46022',''),
		T_TIPO_DATA('gcarbonell','46','46039',''),
		T_TIPO_DATA('gcarbonell','46','46047',''),
		T_TIPO_DATA('gcarbonell','46','46054',''),
		T_TIPO_DATA('gcarbonell','46','46057',''),
		T_TIPO_DATA('gcarbonell','46','46062',''),
		T_TIPO_DATA('gcarbonell','46','46065',''),
		T_TIPO_DATA('gcarbonell','46','46069',''),
		T_TIPO_DATA('gcarbonell','46','46072',''),
		T_TIPO_DATA('gcarbonell','46','46073',''),
		T_TIPO_DATA('gcarbonell','46','46075',''),
		T_TIPO_DATA('gcarbonell','46','46081',''),
		T_TIPO_DATA('gcarbonell','46','46090',''),
		T_TIPO_DATA('gcarbonell','46','46094',''),
		T_TIPO_DATA('gcarbonell','46','46107',''),
		T_TIPO_DATA('gcarbonell','46','46118',''),
		T_TIPO_DATA('gcarbonell','46','46121',''),
		T_TIPO_DATA('gcarbonell','46','46132',''),
		T_TIPO_DATA('gcarbonell','46','46137',''),
		T_TIPO_DATA('gcarbonell','46','46138',''),
		T_TIPO_DATA('gcarbonell','46','46154',''),
		T_TIPO_DATA('gcarbonell','46','46151',''),
		T_TIPO_DATA('gcarbonell','46','46165',''),
		T_TIPO_DATA('gcarbonell','46','46170',''),
		T_TIPO_DATA('gcarbonell','46','46173',''),
		T_TIPO_DATA('gcarbonell','46','46174',''),
		T_TIPO_DATA('gcarbonell','46','46176',''),
		T_TIPO_DATA('gcarbonell','46','46172',''),
		T_TIPO_DATA('gcarbonell','46','46179',''),
		T_TIPO_DATA('gcarbonell','46','46180',''),
		T_TIPO_DATA('gcarbonell','46','46183',''),
		T_TIPO_DATA('gcarbonell','46','46184',''),
		T_TIPO_DATA('gcarbonell','46','46185',''),
		T_TIPO_DATA('gcarbonell','46','46186',''),
		T_TIPO_DATA('gcarbonell','46','46189',''),
		T_TIPO_DATA('gcarbonell','46','46193',''),
		T_TIPO_DATA('gcarbonell','46','46194',''),
		T_TIPO_DATA('gcarbonell','46','46200',''),
		T_TIPO_DATA('gcarbonell','46','46104',''),
		T_TIPO_DATA('gcarbonell','46','46212',''),
		T_TIPO_DATA('gcarbonell','46','46217',''),
		T_TIPO_DATA('gcarbonell','46','46225',''),
		T_TIPO_DATA('gcarbonell','46','46230',''),
		T_TIPO_DATA('gcarbonell','46','46235','46001'),
		T_TIPO_DATA('gcarbonell','46','46243',''),
		T_TIPO_DATA('gcarbonell','46','46244',''),
		T_TIPO_DATA('gcarbonell','46','46248',''),
		T_TIPO_DATA('gcarbonell','46','46251',''),
		T_TIPO_DATA('gcarbonell','46','46145',''),
		T_TIPO_DATA('gcarbonell','46','46040',''),
		T_TIPO_DATA('gcarbonell','46','46046',''),
		T_TIPO_DATA('gcarbonell','46','46045',''),
		T_TIPO_DATA('gcarbonell','46','46074',''),
		T_TIPO_DATA('gcarbonell','46','46153',''),
		T_TIPO_DATA('gcarbonell','46','46227',''),
		T_TIPO_DATA('gcarbonell','46','46229',''),
		T_TIPO_DATA('gcarbonell','46','46259',''),
		T_TIPO_DATA('fsamper','4','04001',''),
		T_TIPO_DATA('fsamper','4','04003',''),
		T_TIPO_DATA('fsamper','4','04011',''),
		T_TIPO_DATA('fsamper','4','04013',''),
		T_TIPO_DATA('fsamper','4','04015',''),
		T_TIPO_DATA('fsamper','4','04029',''),
		T_TIPO_DATA('fsamper','4','04030',''),
		T_TIPO_DATA('fsamper','4','04038',''),
		T_TIPO_DATA('fsamper','4','04902',''),
		T_TIPO_DATA('fsamper','4','04046',''),
		T_TIPO_DATA('fsamper','4','04047',''),
		T_TIPO_DATA('fsamper','4','04050',''),
		T_TIPO_DATA('fsamper','4','04051',''),
		T_TIPO_DATA('fsamper','4','04052',''),
		T_TIPO_DATA('fsamper','4','04057',''),
		T_TIPO_DATA('fsamper','4','04903',''),
		T_TIPO_DATA('fsamper','4','04079',''),
		T_TIPO_DATA('fsamper','4','18905',''),
		T_TIPO_DATA('fsamper','4','04091',''),
		T_TIPO_DATA('fsamper','4','04901',''),
		T_TIPO_DATA('fsamper','4','04101',''),
		T_TIPO_DATA('fsamper','4','04102',''),
		T_TIPO_DATA('gdelrosal','4','04103',''),
		T_TIPO_DATA('gdelrosal','4','04100',''),
		T_TIPO_DATA('gdelrosal','4','04099',''),
		T_TIPO_DATA('gdelrosal','4','04098',''),
		T_TIPO_DATA('gdelrosal','4','04097',''),
		T_TIPO_DATA('gdelrosal','4','04095',''),
		T_TIPO_DATA('gdelrosal','4','04093',''),
		T_TIPO_DATA('gdelrosal','4','04092',''),
		T_TIPO_DATA('gdelrosal','4','04089',''),
		T_TIPO_DATA('gdelrosal','4','04088',''),
		T_TIPO_DATA('gdelrosal','4','04086',''),
		T_TIPO_DATA('gdelrosal','4','04085',''),
		T_TIPO_DATA('gdelrosal','4','04083',''),
		T_TIPO_DATA('gdelrosal','4','04082',''),
		T_TIPO_DATA('gdelrosal','4','04081',''),
		T_TIPO_DATA('gdelrosal','4','04078',''),
		T_TIPO_DATA('gdelrosal','4','04077',''),
		T_TIPO_DATA('gdelrosal','4','04076',''),
		T_TIPO_DATA('gdelrosal','4','04075',''),
		T_TIPO_DATA('gdelrosal','4','04074',''),
		T_TIPO_DATA('gdelrosal','4','04073',''),
		T_TIPO_DATA('gdelrosal','4','04070',''),
		T_TIPO_DATA('gdelrosal','4','04069',''),
		T_TIPO_DATA('gdelrosal','4','04067',''),
		T_TIPO_DATA('gdelrosal','4','04066',''),
		T_TIPO_DATA('gdelrosal','4','04065',''),
		T_TIPO_DATA('gdelrosal','4','04064',''),
		T_TIPO_DATA('gdelrosal','4','04063',''),
		T_TIPO_DATA('gdelrosal','4','04062',''),
		T_TIPO_DATA('gdelrosal','4','04060',''),
		T_TIPO_DATA('gdelrosal','4','04059',''),
		T_TIPO_DATA('gdelrosal','4','04053',''),
		T_TIPO_DATA('gdelrosal','4','04049',''),
		T_TIPO_DATA('gdelrosal','4','04048',''),
		T_TIPO_DATA('gdelrosal','4','04045',''),
		T_TIPO_DATA('gdelrosal','4','04044',''),
		T_TIPO_DATA('gdelrosal','4','04043',''),
		T_TIPO_DATA('gdelrosal','4','04035',''),
		T_TIPO_DATA('gdelrosal','4','04034',''),
		T_TIPO_DATA('gdelrosal','4','04037',''),
		T_TIPO_DATA('gdelrosal','4','04036',''),
		T_TIPO_DATA('gdelrosal','4','04032',''),
		T_TIPO_DATA('gdelrosal','4','04031',''),
		T_TIPO_DATA('gdelrosal','4','04027',''),
		T_TIPO_DATA('gdelrosal','4','04024',''),
		T_TIPO_DATA('gdelrosal','4','04022',''),
		T_TIPO_DATA('gdelrosal','4','04017',''),
		T_TIPO_DATA('gdelrosal','4','04016',''),
		T_TIPO_DATA('gdelrosal','4','04010',''),
		T_TIPO_DATA('gdelrosal','4','04009',''),
		T_TIPO_DATA('gdelrosal','4','04007',''),
		T_TIPO_DATA('gdelrosal','4','04006',''),
		T_TIPO_DATA('gdelrosal','4','04004','')); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES WHERE COD_CARTERA IN (''1'') AND TIPO_GESTOR = ''HAYAGBOINM''';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO CORRECTO');

	
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
      
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
			V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                      	(ID, 
                      	TIPO_GESTOR, 
                      	COD_CARTERA, 
                      	USERNAME,
                      	COD_PROVINCIA, 
                      	COD_MUNICIPIO, 
                      	COD_POSTAL,  
                      	NOMBRE_USUARIO, 
                      	VERSION, 
                      	USUARIOCREAR, 
                      	FECHACREAR, 
                      	BORRADO) 
                      	SELECT '|| V_ID ||',
                      	''HAYAGBOINM'', 
						1,
						'''||TRIM(V_TMP_TIPO_DATA(1))||''',
						'''||TRIM(V_TMP_TIPO_DATA(2))||''',
						'''||TRIM(V_TMP_TIPO_DATA(3))||''', 
						'''||TRIM(V_TMP_TIPO_DATA(4))||''', 
						(SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 
							FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU 
							WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
						 0,
						 '''||V_USU||''',
						 SYSDATE,
						 0 FROM DUAL';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

		END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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

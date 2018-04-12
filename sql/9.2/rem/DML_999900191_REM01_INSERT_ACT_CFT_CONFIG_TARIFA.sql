--/*
--##########################################
--## AUTOR=Jose Navarro
--## FECHA_CREACION=20180412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3960
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TTF_TIPO_TARIFA los datos añadidos en T_ARRAY_DATA.
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
    V_NUM_TIPO   NUMBER(16); -- Vble. para validar la existencia de la tabla de tipos.    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    V_TABLA VARCHAR2(40 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_TTF VARCHAR2(40 CHAR) := 'DD_TTF_TIPO_TARIFA';
    V_TABLA_TTR VARCHAR2(40 CHAR) := 'DD_TTR_TIPO_TRABAJO';
    V_TABLA_STR VARCHAR2(40 CHAR) := 'DD_STR_SUBTIPO_TRABAJO';
    V_TABLA_CRA VARCHAR2(40 CHAR) := 'DD_CRA_CARTERA';
	
	V_TTF_ID NUMBER(16);		-- DD_TTF_TIPO_TARIFA
	V_TTR_ID NUMBER(16);		-- DD_TTR_TIPO_TRABAJO
	V_STR_ID NUMBER(16);		-- DD_STR_SUBTIPO_TRABAJO
	V_CRA_ID NUMBER(16);		-- DD_CRA_CARTERA
	
    


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--	(DD_TTF_CODIGO , DD_TTR_DESCRIPCION , DD_STR_DESCRIPCION , DD_CRA_DESCRIPCION , PRECIO_UNITARIO , UNIDAD_MEDIDA)
        	T_TIPO_DATA('TP1','Actuación técnica','Limpeza extraordinaria hasta 150m2','Bankia','275','unidad'),
		T_TIPO_DATA('TP2','Actuación técnica','Limpieza extraordinaria de 5 a 10 activos','Bankia','112','unidad'),
		T_TIPO_DATA('TP3','Actuación técnica','Limpieza extraordinaria de 10 a 20 activos','Bankia','108','unidad'),
		T_TIPO_DATA('TP4','Actuación técnica','Limpieza extraordinaria de 20 a 30 activos','Bankia','105','unidad'),
		T_TIPO_DATA('TP5','Actuación técnica','Limpieza extraordinaria más de 30 activos','Bankia','97','unidad'),
		T_TIPO_DATA('TP6','Actuación técnica','Limpieza extraordinaria más de 150 m2','Bankia','156','unidad'),
		T_TIPO_DATA('TP7','Actuación técnica','Mobiliario de cocina','Bankia','165','m2'),
		T_TIPO_DATA('TP8','Actuación técnica','Mobiliario de cocina','Bankia','267','m2'),
		T_TIPO_DATA('TP9','Actuación técnica','Mobiliario de cocina','Bankia','129','unidad'),
		T_TIPO_DATA('TP10','Actuación técnica','Mobiliario de cocina','Bankia','135','unidad'),
		T_TIPO_DATA('TP11','Actuación técnica','Mobiliario de cocina','Bankia','85','unidad'),
		T_TIPO_DATA('TP12','Actuación técnica','Mobiliario de cocina','Bankia','197','unidad'),
		T_TIPO_DATA('TP13','Actuación técnica','Mobiliario de cocina','Bankia','210','unidad'),
		T_TIPO_DATA('TP14','Actuación técnica','Mobiliario de cocina','Bankia','102','unidad'),
		T_TIPO_DATA('TP15','Actuación técnica','Mobiliario de cocina','Bankia','125','unidad'),
		T_TIPO_DATA('TP16','Actuación técnica','Mobiliario de cocina','Bankia','112','unidad'),
		T_TIPO_DATA('TP17','Actuación técnica','Mobiliario de cocina','Bankia','108','unidad'),
		T_TIPO_DATA('TP18','Actuación técnica','Mobiliario de cocina','Bankia','140','unidad'),
		T_TIPO_DATA('TP19','Actuación técnica','Mobiliario de cocina','Bankia','815','unidad'),
		T_TIPO_DATA('TP20','Actuación técnica','Mobiliario de cocina','Bankia','1065','unidad'),
		T_TIPO_DATA('TP21','Actuación técnica','Mobiliario de cocina','Bankia','1260','unidad'),
		T_TIPO_DATA('TP22','Actuación técnica','Electrodomésticos','Bankia','238','unidad'),
		T_TIPO_DATA('TP23','Actuación técnica','Electrodomésticos','Bankia','278','unidad'),
		T_TIPO_DATA('TP24','Actuación técnica','Electrodomésticos','Bankia','247','unidad'),
		T_TIPO_DATA('TP25','Actuación técnica','Electrodomésticos','Bankia','245','unidad'),
		T_TIPO_DATA('TP26','Actuación técnica','Electrodomésticos','Bankia','99','unidad'),
		T_TIPO_DATA('TP27','Actuación técnica','Electrodomésticos','Bankia','249','unidad'),
		T_TIPO_DATA('TP28','Actuación técnica','Electrodomésticos','Bankia','262','unidad'),
		T_TIPO_DATA('TP29','Actuación técnica','Electrodomésticos','Bankia','323','unidad'),
		T_TIPO_DATA('TP30','Actuación técnica','Electrodomésticos','Bankia','315','unidad'),
		T_TIPO_DATA('TP31','Actuación técnica','Electrodomésticos','Bankia','640','unidad'),
		T_TIPO_DATA('TP32','Actuación técnica','Electrodomésticos','Bankia','858','unidad'),
		T_TIPO_DATA('TP33','Actuación técnica','Electrodomésticos','Bankia','1172','unidad'),
		T_TIPO_DATA('TP34','Actuación técnica','Electrodomésticos','Bankia','177','unidad'),
		T_TIPO_DATA('TP35','Actuación técnica','Electrodomésticos','Bankia','277','unidad'),
		T_TIPO_DATA('TP36','Actuación técnica','Adecuación suelos','Bankia','350','unidad'),
		T_TIPO_DATA('TP37','Actuación técnica','Adecuación suelos','Bankia','480','unidad'),
		T_TIPO_DATA('TP38','Actuación técnica','Adecuación suelos','Bankia','1678','unidad'),
		T_TIPO_DATA('TP39','Actuación técnica','Adecuación suelos','Bankia','2520','unidad'),
		T_TIPO_DATA('TP40','Actuación técnica','Adecuación suelos','Bankia','0.12','metro'),
		T_TIPO_DATA('TP41','Actuación técnica','Vallado de hormigón','Bankia','72','m2'),
		T_TIPO_DATA('TP42','Actuación técnica','Vallado de hormigón','Bankia','45','m2'),
		T_TIPO_DATA('TP43','Actuación técnica','Vallado de chapa','Bankia','53','m2'),
		T_TIPO_DATA('TP44','Actuación técnica','Adecuación suelos','Bankia','0.34','m2'),
		T_TIPO_DATA('TP45','Actuación técnica','Cerramiento de ladrillo','Bankia','553','unidad'),
		T_TIPO_DATA('TP46','Actuación técnica','Cerramiento de ladrillo','Bankia','1472','unidad'),
		T_TIPO_DATA('TP47','Actuación técnica','Cerramiento de ladrillo','Bankia','3130','unidad'),
		T_TIPO_DATA('TP48','Actuación técnica','Cerramiento de ladrillo','Bankia','655','unidad'),
		T_TIPO_DATA('TP49','Actuación técnica','Cerramiento de ladrillo','Bankia','1745','unidad'),
		T_TIPO_DATA('TP50','Actuación técnica','Cerramiento de ladrillo','Bankia','3700','unidad'),
		T_TIPO_DATA('TP51','Actuación técnica','Puerta peatonal','Bankia','225','unidad'),
		T_TIPO_DATA('TP52','Actuación técnica','Puerta abatible','Bankia','350','unidad'),
		T_TIPO_DATA('TP53','Actuación técnica','Cercado','Bankia','16.5','m2'),
		T_TIPO_DATA('TP54','Actuación técnica','Cercado','Bankia','15','m2'),
		T_TIPO_DATA('TP55','Actuación técnica','Cercado','Bankia','13','m2'),
		T_TIPO_DATA('TP56','Actuación técnica','Desmontado cercado','Bankia','2.7','m2'),
		T_TIPO_DATA('TP57','Actuación técnica','Retirada residuos','Bankia','36','m3'),
		T_TIPO_DATA('TP58','Actuación técnica','Retirada fibrocemento','Bankia','68','m2'),
		T_TIPO_DATA('TP59','Actuación técnica','Aislamiento','Bankia','11.4','m2'),
		T_TIPO_DATA('TP60','Actuación técnica','Desinfección urbanización','Bankia','243','m2'),
		T_TIPO_DATA('TP61','Actuación técnica','Desinfección urbanización','Bankia','0.99','m2'),
		T_TIPO_DATA('TP62','Actuación técnica','Cepo garaje','Bankia','80','unidad'),
		T_TIPO_DATA('TP63','Obtención documentación','Boletín agua','Bankia','80','unidad'),
		T_TIPO_DATA('TP64','Obtención documentación','Boletín electricidad','Bankia','125','unidad'),
		T_TIPO_DATA('TP65','Obtención documentación','Boletín gas','Bankia','99','unidad'),
		T_TIPO_DATA('TP66','Obtención documentación','Certificado Eficiencia Energética (CEE)','Bankia','80','unidad'),
		T_TIPO_DATA('TP67','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP68','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP69','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP70','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP71','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP72','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP73','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP74','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP75','Actuación técnica','Reformas mayores','Bankia','28','hora'),
		T_TIPO_DATA('TP76','Actuación técnica','Pintura','Bankia','510','unidad'),
		T_TIPO_DATA('TP77','Actuación técnica','Pintura','Bankia','625','unidad'),
		T_TIPO_DATA('TP78','Actuación técnica','Pintura','Bankia','720','unidad'),
		T_TIPO_DATA('TP79','Actuación técnica','Pintura','Bankia','782','unidad'),
		T_TIPO_DATA('TP80','Actuación técnica','Pintura','Bankia','1165','unidad'),
		T_TIPO_DATA('TP81','Actuación técnica','Pintura','Bankia','9','m2'),
		T_TIPO_DATA('TP82','Actuación técnica','Pintura','Bankia','58',''),
		T_TIPO_DATA('TP83','Actuación técnica','Pintura','Bankia','36','hora'),
		T_TIPO_DATA('TP84','Actuación técnica','Carpintería','Bankia','280','unidad'),
		T_TIPO_DATA('TP85','Actuación técnica','Carpintería','Bankia','332','unidad'),
		T_TIPO_DATA('TP86','Actuación técnica','Carpintería','Bankia','158','unidad'),
		T_TIPO_DATA('TP87','Actuación técnica','Carpintería','Bankia','49','unidad'),
		T_TIPO_DATA('TP88','Actuación técnica','Carpintería','Bankia','36','unidad'),
		T_TIPO_DATA('TP89','Actuación técnica','Fontanería','Bankia','173','unidad'),
		T_TIPO_DATA('TP90','Actuación técnica','Fontanería','Bankia','98','unidad'),
		T_TIPO_DATA('TP91','Actuación técnica','Fontanería','Bankia','85','unidad'),
		T_TIPO_DATA('TP92','Actuación técnica','Fontanería','Bankia','136','unidad'),
		T_TIPO_DATA('TP93','Actuación técnica','Fontanería','Bankia','135','unidad'),
		T_TIPO_DATA('TP94','Actuación técnica','Fontanería','Bankia','132','unidad'),
		T_TIPO_DATA('TP95','Actuación técnica','Fontanería','Bankia','41','unidad'),
		T_TIPO_DATA('TP96','Actuación técnica','Albañilería','Bankia','5.8','m2'),
		T_TIPO_DATA('TP97','Actuación técnica','Albañilería','Bankia','9.6','m2'),
		T_TIPO_DATA('TP98','Actuación técnica','Albañilería','Bankia','10.1','m2'),
		T_TIPO_DATA('TP99','Actuación técnica','Albañilería','Bankia','14.4','m2'),
		T_TIPO_DATA('TP100','Actuación técnica','Albañilería','Bankia','7.2','m2'),
		T_TIPO_DATA('TP101','Actuación técnica','Albañilería','Bankia','8.4','m2'),
		T_TIPO_DATA('TP102','Actuación técnica','Albañilería','Bankia','9.6','m2'),
		T_TIPO_DATA('TP103','Actuación técnica','Albañilería','Bankia','8.4','m2'),
		T_TIPO_DATA('TP104','Actuación técnica','Albañilería','Bankia','5.6','ml'),
		T_TIPO_DATA('TP105','Actuación técnica','Albañilería','Bankia','8.4','m2'),
		T_TIPO_DATA('TP106','Actuación técnica','Albañilería','Bankia','5.6','m2'),
		T_TIPO_DATA('TP107','Actuación técnica','Albañilería','Bankia','10.7','m2'),
		T_TIPO_DATA('TP108','Actuación técnica','Albañilería','Bankia','12','m2'),
		T_TIPO_DATA('TP109','Actuación técnica','Albañilería','Bankia','10.7','m2'),
		T_TIPO_DATA('TP110','Actuación técnica','Albañilería','Bankia','6.1','m2'),
		T_TIPO_DATA('TP111','Actuación técnica','Albañilería','Bankia','8','m2'),
		T_TIPO_DATA('TP112','Actuación técnica','Albañilería','Bankia','17.95','m2'),
		T_TIPO_DATA('TP113','Actuación técnica','Albañilería','Bankia','21.6','m2'),
		T_TIPO_DATA('TP114','Actuación técnica','Electricidad','Bankia','30','unidad'),
		T_TIPO_DATA('TP115','Actuación técnica','Electricidad','Bankia','30','unidad'),
		T_TIPO_DATA('TP116','Actuación técnica','Electricidad','Bankia','30','unidad'),
		T_TIPO_DATA('TP117','Actuación técnica','Electricidad','Bankia','55','unidad'),
		T_TIPO_DATA('TP118','Actuación técnica','Cristalería','Bankia','26.31',''),
		T_TIPO_DATA('TP119','Actuación técnica','Cristalería','Bankia','42','m2'),
		T_TIPO_DATA('TP120','Actuación técnica','Cristalería','Bankia','42','m2'),
		T_TIPO_DATA('TP121','Actuación técnica','Informe técnico','Bankia','220','unidad')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para actualizar los valores en la tabla indicada
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando '||V_TABLA||'');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
				
		V_TTF_ID := NULL;
		V_TTR_ID := NULL;
		V_STR_ID := NULL;
		V_CRA_ID := NULL;

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TTF||' WHERE
						DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TIPO;
		
		IF V_NUM_TIPO = 1 THEN
			--Seleccionamos DD_TTF_ID
			V_MSQL := 'SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TTF||' WHERE
							DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND
							BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_TTF_ID;
		END IF;
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TTR||' WHERE
						DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TIPO;
		
		IF V_NUM_TIPO = 1 THEN
			--Seleccionamos DD_TTR_ID
			V_MSQL := 'SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TTR||' WHERE
							DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND
							BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_TTR_ID;
		END IF;
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_STR||' WHERE
						DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TIPO;
		
		IF V_NUM_TIPO = 1 THEN
			--Seleccionamos DD_STR_ID
			V_MSQL := 'SELECT DD_STR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_STR||' WHERE
							DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND
							BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_STR_ID;
		END IF;
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE
						DD_CRA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TIPO;
		
		IF V_NUM_TIPO = 1 THEN
			--Seleccionamos DD_CRA_ID
			V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE
							DD_CRA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND
							BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_CRA_ID;
		END IF;
		
		IF NOT V_TTF_ID IS NULL AND NOT V_TTR_ID IS NULL AND NOT V_STR_ID IS NULL AND NOT V_CRA_ID IS NULL THEN
		
			--Comprobamos si existe el registro entero
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE
							DD_TTF_ID = '''||V_TTF_ID||''' AND
							DD_TTR_ID = '''||V_TTR_ID||''' AND
							DD_STR_ID = '''||V_STR_ID||''' AND
							DD_CRA_ID = '''||V_CRA_ID||''' AND
							BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TIPO;
		
			IF V_NUM_TIPO > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[ERROR] Registro con código '||V_TMP_TIPO_DATA(1)||'. YA EXISTE');
			ELSE
		
				--Insertar registro en tabla.
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
							(	CFT_ID, 
								DD_TTF_ID,
								DD_TTR_ID,
								DD_STR_ID,
								DD_CRA_ID, 
								CFT_PRECIO_UNITARIO, 
								CFT_UNIDAD_MEDIDA,
								VERSION,
								USUARIOCREAR, 
								FECHACREAR, 
								BORRADO
							)
							VALUES
							(	'||V_ESQUEMA||'.S_ACT_CFT_CONFIG_TARIFA.nextval,
								'''||V_TTF_ID||''',
								'''||V_TTR_ID||''',
								'''||V_STR_ID||''',
								'''||V_CRA_ID||''',
								'||V_TMP_TIPO_DATA(5)||',
								'''||V_TMP_TIPO_DATA(6)||''',
								0,
								''HREOS-3962'',
								SYSDATE,
								0
							)';
				EXECUTE IMMEDIATE V_MSQL;
			   	DBMS_OUTPUT.PUT_LINE('[INFO] Registro con código '||V_TMP_TIPO_DATA(1)||' INSERTADO.');

			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado alguno de los diccionarios de la elemento: '|| V_TMP_TIPO_DATA(1));
		END IF;
	END LOOP;



	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE.');
   
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

EXIT;


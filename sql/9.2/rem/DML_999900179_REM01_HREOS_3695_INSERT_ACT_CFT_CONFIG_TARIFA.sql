--/*
--##########################################
--## AUTOR=Diego Crespo
--## FECHA_CREACION=20180125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3695
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en la tabla ACT_CFT_CONFIG_TARIFA
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
	
    


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    --(DD_TTF_CODIGO , DD_TTR_DESCRIPCION , DD_STR_DESCRIPCION , DD_CRA_DESCRIPCION , PRECIO_UNITARIO , UNIDAD_MEDIDA)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('BK-OM470' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '40.13' ,	'unidad'),
		T_TIPO_DATA('BK-OM471' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '59.79' , 	'unidad'),
		T_TIPO_DATA('BK-OM472' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '35.99' , 	'unidad'),
		T_TIPO_DATA('BK-OM473' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '55.06' ,	'unidad'),
		T_TIPO_DATA('BK-OM474' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '38.13' ,	'unidad'),
		T_TIPO_DATA('BK-OM475' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '46.27' ,	'unidad'),
		T_TIPO_DATA('BK-OM476' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '33.97' ,	'unidad'),
		T_TIPO_DATA('BK-OM477' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '41.55' ,	'unidad'),
		T_TIPO_DATA('BK-OM478' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '37.76' ,	'unidad'),
		T_TIPO_DATA('BK-OM479' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '43.88' ,	'unidad'),
		T_TIPO_DATA('BK-OM480' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '33.62' ,	'unidad'),
		T_TIPO_DATA('BK-OM481' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '39.17' ,	'unidad'),
		T_TIPO_DATA('BK-OM482' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '37.15' ,	'unidad'),
		T_TIPO_DATA('BK-OM483' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '42.53' ,	'unidad'),
		T_TIPO_DATA('BK-OM484' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '32.99' ,	'unidad'),
		T_TIPO_DATA('BK-OM485' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '37.82' ,	'unidad'),
		T_TIPO_DATA('BK-OM486' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '42.40' ,	'unidad'),
		T_TIPO_DATA('BK-OM487' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '150.48' , 	'unidad'),
		T_TIPO_DATA('BK-OM488' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '139.20' , 	'unidad'),
		T_TIPO_DATA('BK-OM489' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '0.61' , 	'm2'),
		T_TIPO_DATA('BK-OM490' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '74.29' ,	'ml'),
		T_TIPO_DATA('BK-OM491' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '47.32' ,	'ml'),
		T_TIPO_DATA('BK-OM492' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '54.72' ,	'ml'),
		T_TIPO_DATA('BK-OM493' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '15.00' ,	'ml'),
		T_TIPO_DATA('BK-OM494' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '13.16' ,	'ml'),
		T_TIPO_DATA('BK-OM495' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '225.36' , 	'unidad'),
		T_TIPO_DATA('BK-OM496' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '698.40' , 	'unidad'),
		T_TIPO_DATA('BK-OM497' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '2.70' , 	'ml'),
		T_TIPO_DATA('BK-OM498' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '36.06' ,	'm3'),
		T_TIPO_DATA('BK-OM499' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '68.32' ,	'm2'),
		T_TIPO_DATA('BK-OM500' , 'Actuación técnica' , 'Obra menor tarificada' , 'Bankia' , '11.40' ,	'm2')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para actualizar los valores en la tabla indicada
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando '||V_TABLA||'');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		--Seleccionamos DD_TTF_ID
		V_MSQL := 'SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TTF||' WHERE
						DD_TTF_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_TTF_ID;
		
		--Seleccionamos DD_TTR_ID
		V_MSQL := 'SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TTR||' WHERE
						DD_TTR_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_TTR_ID;
		
		--Seleccionamos DD_STR_ID
		V_MSQL := 'SELECT DD_STR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_STR||' WHERE
						DD_STR_DESCRIPCION = '''||V_TMP_TIPO_DATA(3)||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_STR_ID;
		
		--Seleccionamos DD_CRA_ID
		V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CRA||' WHERE
						DD_CRA_DESCRIPCION = '''||V_TMP_TIPO_DATA(4)||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_CRA_ID;
	
		
		--Comprobamos si existe el registro entero
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE
						DD_TTF_ID = '''||V_TTF_ID||''' AND
						DD_TTR_ID = '''||V_TTR_ID||''' AND
						DD_STR_ID = '''||V_STR_ID||''' AND
						DD_CRA_ID = '''||V_CRA_ID||''' AND
						CFT_PRECIO_UNITARIO = '''||V_TMP_TIPO_DATA(5)||''' AND
						CFT_UNIDAD_MEDIDA = '''||V_TMP_TIPO_DATA(6)||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TIPO;
		
		IF V_NUM_TIPO > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('[ERROR] Registro con código '||V_TMP_TIPO_DATA(1)||' YA EXISTE.');
	
		ELSE
		
			--Insertar registro en tabla.
			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
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
							''HREOS-3695'',
							SYSDATE,
							0
						)';
			EXECUTE IMMEDIATE V_SQL;
		   	DBMS_OUTPUT.PUT_LINE('[INFO] Registro con código '||V_TMP_TIPO_DATA(1)||' INSERTADO.');

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


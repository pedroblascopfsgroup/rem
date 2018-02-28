--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20180216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-SWAT
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en la tabla DD_TTF_TIPO_TARIFA
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

    V_TABLA VARCHAR2(40 CHAR) := 'DD_TTF_TIPO_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    --(DD_TTF_CODIGO , DD_TTF_DESCRIPCION , DD_TTF_DESCRIPCION_LARGA)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('BK-OM470' , 'Demolición de Edificación Aislada superficie < 200 m2' , 		'Demolición de Edificación Aislada superficie < 200 m2' ),
		T_TIPO_DATA('BK-OM471' , 'Demolición de Edificación entre medianeras superficie < 200 m2' , 		'Demolición de Edificación entre medianeras superficie < 200 m2' ),
		T_TIPO_DATA('BK-OM472' , 'Edificio Estructura Metálica Aislado superficie < 200 m2' , 		'Edificio Estructura Metálica Aislado superficie < 200 m2' ),
		T_TIPO_DATA('BK-OM473' , 'Edificio estructura metálica entre medianeras superficie < 200 m2' , 		'Edificio estructura metálica entre medianeras superficie < 200 m2'),
		T_TIPO_DATA('BK-OM474' , 'Demolición de Edificación Aislada, superficie de 200 a 1.000 m2' , 	'Demolición de Edificación Aislada, superficie de 200 a 1.000 m2' ),
		T_TIPO_DATA('BK-OM475' , 'Demolición de Edificación entre medianeras superficie de 200 a 1.000 m2' , 	'Demolición de Edificación entre medianeras superficie de 200 a 1.000 m2'),
		T_TIPO_DATA('BK-OM476' , 'Edificio Estructura Metálica Aislado superficie de 200 a 1.000 m2' , 	'Edificio Estructura Metálica Aislado superficie de 200 a 1.000 m2' ),
		T_TIPO_DATA('BK-OM477' , 'Edificio estructura metálica entre medianeras superficie de 200 a 1.000 m2' , 	'Edificio estructura metálica entre medianeras superficie de 200 a 1.000 m2' ),
		T_TIPO_DATA('BK-OM478' , 'Demolición de Edificación Aislada, superficie de 1.000 a 3.000 m2' , 'Demolición de Edificación Aislada, superficie de 1.000 a 3.000 m2' ),
		T_TIPO_DATA('BK-OM479' , 'Demolición de Edificación entre medianeras, superficie de 1.000 a 3.000 m2' , 'Demolición de Edificación entre medianeras, superficie de 1.000 a 3.000 m2'),
		T_TIPO_DATA('BK-OM480' , 'Edificio Estructura Metálica Aislado, superficie de 1.000 a 3.000 m2' , 'Edificio Estructura Metálica Aislado, superficie de 1.000 a 3.000 m2' ),
		T_TIPO_DATA('BK-OM481' , 'Edificio estructura metálica entre medianeras, superficie de 1.000 a 3.000 m2' , 'Edificio estructura metálica entre medianeras, superficie de 1.000 a 3.000 m2' ),
		T_TIPO_DATA('BK-OM482' , 'Demolición de Edificación Aislada, superficie > 3.000 m2' , 	'Demolición de Edificación Aislada, superficie > 3.000 m2' ),
		T_TIPO_DATA('BK-OM483' , 'Demolición de Edificación entre medianeras, superficie > 3.000 m2' , 	'Demolición de Edificación entre medianeras, superficie > 3.000 m2' ),
		T_TIPO_DATA('BK-OM484' , 'Edificio Estructura Metálica Aislado, superficie > 3.000 m2' , 	'Edificio Estructura Metálica Aislado, superficie > 3.000 m2' ),
		T_TIPO_DATA('BK-OM485' , 'Edificio estructura metálica entre medianeras, superficie > 3.000 m2' , 	'Edificio estructura metálica entre medianeras, superficie > 3.000 m2'),
		T_TIPO_DATA('BK-OM486' , 'Suministro y colocación de cadena de 50cm x 6mm, incluso candado de 60mm arco normal acerado' , 								'Suministro y colocación de 1 cadena de 50cm de longitud y de mínimo 6mm de grosor, incluso candado de 60mm arco normal acerado' ),
		T_TIPO_DATA('BK-OM487' , 'Derribo elementos puntuales en zonas afectadas con peligro de desprendimiento (Sup: 30m2)' , 								'Derribo elementos puntuales en zonas afectadas con peligro de desprendimiento como falsos techos… (Sup: 30m2) con retirada, carga de escombros y transporte a vertedero.' ),
		T_TIPO_DATA('BK-OM488' , 'Cualquier obra que ocupe 1/2 día de dos operarios.' , 								'Cualquier obra que ocupe 1/2 día de dos operarios.' ,													'Cualquier obra que ocupe 1/2 día de dos operarios.'),
		T_TIPO_DATA('BK-OM489' , 'Corte selectiva: Desbroce y poda puntual y selectiva. Manual, con todos los utiles necesarios.€/m2' , 								'Corte selectiva: Desbroce y poda puntual y selectiva. Manual, con todos los utiles necesarios.'),
		T_TIPO_DATA('BK-OM490' , 'Vallado con bloque de hormigón de 20cm, hasta una altura de 2 m' , 								'Vallado con bloque de hormigón de 20cm, hasta una altura de 2 m' ),
		T_TIPO_DATA('BK-OM491' , 'Vallado con bloque de hormigón de 20cm, hasta una altura de 1 m' , 								'Vallado con bloque de hormigón de 20cm, hasta una altura de 1 m' ),
		T_TIPO_DATA('BK-OM492' , 'Vallado con chapa metálica nervada hasta 2m de altura' , 								'Vallado con chapa metálica nervada hasta 2m de altura' ),
		T_TIPO_DATA('BK-OM493' , 'Cercado de 1,50 m. de altura con malla simple torsión' , 								'Cercado de 1,50 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14 y postes de tubo de acero y recibido de postes con hormigón HM-20/P/20/I'	),
		T_TIPO_DATA('BK-OM494' , 'Cercado de 1 m. de altura con malla simple torsión' , 								'Cercado de 1 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14 y postes de tubo de acero y recibido de postes con hormigón HM-20/P/20/I' ),
		T_TIPO_DATA('BK-OM495' , 'Puerta metálica de malla o chapa de acero galvanizado para acceso peatonal (0,8 - 1m)' , 								'Puerta metálica de malla o chapa de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado, incluso cimentación para anclajes. Incluyendo ejecución de rampas en el caso de ser necesarias' ),
		T_TIPO_DATA('BK-OM496' , 'Puerta abatible de 3x2 m. para cerramiento exterior totalmente instalada, incluso bastidor' , 								'Puerta abatible de 3x2 m. para cerramiento exterior totalmente instalada, incluso bastidor, montantes, travesaños y columnas de fijación de, parador de pie y tope, candado, elaborada en taller, ajuste y montaje en obra' ),
		T_TIPO_DATA('BK-OM497' , 'Desmontado manual de cercado de malla simple torsión, con recuperación del material desmontado' , 								'Desmontado por medios manuales de cercado de malla simple torsión, con recuperación del material desmontado, incluso ayudas de albañilería, medios de elevación carga, descarga, retirada de escombros y posterior transporte a vertedero' ),
		T_TIPO_DATA('BK-OM498' , 'Retirada de residuos inertes (restos de obra, basuras, etc.) y posterior transporte a vertedero' , 								'Retirada de residuos inertes (restos de obra, basuras, etc.), incluso medios de elevación carga, descarga y posterior transporte a vertedero' ),
		T_TIPO_DATA('BK-OM499' , 'Retirada y transporte a vertedero de residuos contaminados de fibrocemento, amianto, etc.' , 								'Retirada, desmontaje y acondicionamiento de residuos contaminados de fibrocemento, amianto,... Incluso plan de trabajo específico, autorizaciones necesarias, retirada a vertedero autorizado y certificado de gestión' ),
		T_TIPO_DATA('BK-OM500' , 'Aislamiento mediante espuma rígida de poliuretano hidrófugo, proyectada sobre paramento vertical' , 								'Aislamiento mediante espuma rígida de poliuretano hidrófugo, proyectada sobre los paramentos verticales, con una densidad mínima de 50 kg/m3. y 3 cm. de espesor medio, incluso maquinaria de proyección y medios auxiliares, medido a cinta corrida' )
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insert en '||V_TABLA);

	-- LOOP para actualizar los valores en la tabla indicada
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando diccionarios');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		--Comprobamos si existe el DD_TTF_CODIGO
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE
						DD_TTF_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND
						BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TIPO;

		IF V_NUM_TIPO > 0 THEN		
				
			-- Borrado lógico del registro de la tabla ACT_ACTIVO que coincide.
			DBMS_OUTPUT.PUT_LINE('[INFO] Código: '||V_TMP_TIPO_DATA(1)||' EXISTE.');
			V_SQL := '
				UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
				SET
					DD_TTF_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||''',
					DD_TTF_DESCRIPCION_LARGA= '''||V_TMP_TIPO_DATA(3)||''',
					USUARIOMODIFICAR = ''HREOS-SWAT'',
					FECHAMODIFICAR = SYSDATE
        		WHERE DD_TTF_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
			';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Código: '||V_TMP_TIPO_DATA(1)||' ACTUALIZADO.');
			
			
		ELSE
			--Insertar registro en tabla.
			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
						(	DD_TTF_ID, 
							DD_TTF_CODIGO, 
							DD_TTF_DESCRIPCION, 
							DD_TTF_DESCRIPCION_LARGA,
							VERSION,
							USUARIOCREAR, 
							FECHACREAR, 
							BORRADO
						)
						VALUES
						(	'||V_ESQUEMA||'.S_DD_TTF_TIPO_TARIFA.nextval,
							'''||V_TMP_TIPO_DATA(1)||''',
							'''||V_TMP_TIPO_DATA(2)||''',
							'''||V_TMP_TIPO_DATA(3)||''',
							0,
							''HREOS-SWAT'',
							SYSDATE,
							0
						)';
			EXECUTE IMMEDIATE V_SQL;
		   	DBMS_OUTPUT.PUT_LINE('[INFO] Código: '||V_TMP_TIPO_DATA(1)||' INSERTADO.');
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


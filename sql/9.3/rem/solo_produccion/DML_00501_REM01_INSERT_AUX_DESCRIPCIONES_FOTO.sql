--/*
--######################################### 
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20201020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8002
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar descripciones
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'AUX_REMVIP_8002_DESCRIPCIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TABLA_SAC VARCHAR2(30 CHAR) := 'DD_SAC_SUBTIPO_ACTIVO';
	V_TABLA_TPA VARCHAR2(30 CHAR) := 'DD_TPA_TIPO_ACTIVO';

	V_ID_TIPO NUMBER(16);
    V_ID_SUBTIPO NUMBER(16);

	TYPE T_TIPO_DATA_MAPEO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_MAPEO IS TABLE OF T_TIPO_DATA_MAPEO;
    V_TIPO_DATA_MAPEO T_ARRAY_DATA_MAPEO := T_ARRAY_DATA_MAPEO(
		T_TIPO_DATA_MAPEO('Suelo','No urbanizable (rústico)','Suelo'),
		T_TIPO_DATA_MAPEO('Suelo','Urbanizable programado','Suelo'),
		T_TIPO_DATA_MAPEO('Suelo','Urbanizable no programado','Suelo'),
		T_TIPO_DATA_MAPEO('Suelo','Urbano (solar)','Suelo'),
		T_TIPO_DATA_MAPEO('Suelo','No Urbanizable','Suelo'),
		T_TIPO_DATA_MAPEO('Vivienda','Piso dúplex','Vivienda'),
		T_TIPO_DATA_MAPEO('Vivienda','Estudio/Loft','Vivienda'),
		T_TIPO_DATA_MAPEO('Vivienda','Piso','Vivienda'),
		T_TIPO_DATA_MAPEO('Vivienda','Unifamiliar casa de pueblo','Vivienda'),
		T_TIPO_DATA_MAPEO('Vivienda','Unifamiliar pareada','Vivienda'),
		T_TIPO_DATA_MAPEO('Vivienda','Unifamiliar adosada','Vivienda'),
		T_TIPO_DATA_MAPEO('Vivienda','Unifamiliar aislada','Vivienda'),
		T_TIPO_DATA_MAPEO('Vivienda','Ático','Vivienda'),
		T_TIPO_DATA_MAPEO('Comercial y terciario','Parque Medianas','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Comercial y terciario','Almacén','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Comercial y terciario','Hotel','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Comercial y terciario','Oficina','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Comercial y terciario','Local comercial','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Comercial y terciario','Gasolinera','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Industrial','Nave en varias plantas','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Industrial','Nave aislada','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Industrial','Nave adosada','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Edificio completo','Comercial','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Edificio completo','Oficina','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Edificio completo','Aparcamiento','Garaje'),
		T_TIPO_DATA_MAPEO('Edificio completo','Hotel/Apartamentos turísticos','Vivienda'),
		T_TIPO_DATA_MAPEO('En construcción','En construcción (promoción)','Obra en construcción'),
		T_TIPO_DATA_MAPEO('Otros','Infraestructura Técnica','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Otros','Garaje','Garaje'),
		T_TIPO_DATA_MAPEO('Otros','Superficie en Zona Común','Vivienda'),
		T_TIPO_DATA_MAPEO('Otros','Trastero','Trastero'),
		T_TIPO_DATA_MAPEO('Otros','Residencia Estudiantes','Vivienda'),
		T_TIPO_DATA_MAPEO('Otros','Otros','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Dotacional','Dotacional Asistencial','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Dotacional','Dotacional Recreativo','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Dotacional','Dotacional Deportivo','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Dotacional','Dotacional Privado','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Dotacional','Dotacional Sanitario','Local/nave/oficina'),
		T_TIPO_DATA_MAPEO('Concesión Administrativa','Otros Derechos','Local/nave/oficina')
    ); 
    V_TMP_TIPO_DATA_MAPEO T_TIPO_DATA_MAPEO;

    TYPE T_TIPO_DATA_SUELO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_SUELO IS TABLE OF T_TIPO_DATA_SUELO;
    V_TIPO_DATA_SUELO T_ARRAY_DATA_SUELO := T_ARRAY_DATA_SUELO(
		T_TIPO_DATA_SUELO('Suelo'),
		T_TIPO_DATA_SUELO('Catastro'),
		T_TIPO_DATA_SUELO('Vista aérea'),
		T_TIPO_DATA_SUELO('Otros')
	); 
    V_TMP_TIPO_DATA_SUELO T_TIPO_DATA_SUELO;

	TYPE T_TIPO_DATA_LNO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_LNO IS TABLE OF T_TIPO_DATA_LNO;
    V_TIPO_DATA_LNO T_ARRAY_DATA_LNO := T_ARRAY_DATA_LNO(
		T_TIPO_DATA_LNO('Fachada'),
		T_TIPO_DATA_LNO('Sala diáfana'),
		T_TIPO_DATA_LNO('Despacho'),
		T_TIPO_DATA_LNO('Recepción'),
		T_TIPO_DATA_LNO('Cocina'),
		T_TIPO_DATA_LNO('Baño'),
		T_TIPO_DATA_LNO('Aseo'),
		T_TIPO_DATA_LNO('Almacén'),
		T_TIPO_DATA_LNO('Altillo'),
		T_TIPO_DATA_LNO('Terraza cubierta'),
		T_TIPO_DATA_LNO('Montacargas'),
		T_TIPO_DATA_LNO('Otros')
	); 
    V_TMP_TIPO_DATA_LNO T_TIPO_DATA_LNO;

	TYPE T_TIPO_DATA_GARAJE IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_GARAJE IS TABLE OF T_TIPO_DATA_GARAJE;
    V_TIPO_DATA_GARAJE T_ARRAY_DATA_GARAJE := T_ARRAY_DATA_GARAJE(
		T_TIPO_DATA_GARAJE('Fachada'),
		T_TIPO_DATA_GARAJE('Garaje'),
		T_TIPO_DATA_GARAJE('Trastero'),
		T_TIPO_DATA_GARAJE('Otros')
	); 
    V_TMP_TIPO_DATA_GARAJE T_TIPO_DATA_GARAJE;

	TYPE T_TIPO_DATA_TRASTERO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_TRASTERO IS TABLE OF T_TIPO_DATA_TRASTERO;
    V_TIPO_DATA_TRASTERO T_ARRAY_DATA_TRASTERO := T_ARRAY_DATA_TRASTERO(
		T_TIPO_DATA_TRASTERO('Fachada'),
		T_TIPO_DATA_TRASTERO('Trastero'),
		T_TIPO_DATA_TRASTERO('Otros')
	); 
    V_TMP_TIPO_DATA_TRASTERO T_TIPO_DATA_TRASTERO;

	TYPE T_TIPO_DATA_OBRA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_OBRA IS TABLE OF T_TIPO_DATA_OBRA;
    V_TIPO_DATA_OBRA T_ARRAY_DATA_OBRA := T_ARRAY_DATA_OBRA(
		T_TIPO_DATA_OBRA('Fachada'),
		T_TIPO_DATA_OBRA('Estructura'),
		T_TIPO_DATA_OBRA('Salón'),
		T_TIPO_DATA_OBRA('Dormitorio'),
		T_TIPO_DATA_OBRA('Buhardilla'),
		T_TIPO_DATA_OBRA('Cocina'),
		T_TIPO_DATA_OBRA('Baño'),
		T_TIPO_DATA_OBRA('Aseo'),
		T_TIPO_DATA_OBRA('Despensa'),
		T_TIPO_DATA_OBRA('Lavadero'),
		T_TIPO_DATA_OBRA('Tendedero'),
		T_TIPO_DATA_OBRA('Hall'),
		T_TIPO_DATA_OBRA('Balcón'),
		T_TIPO_DATA_OBRA('Terraza cubierta'),
		T_TIPO_DATA_OBRA('Terraza descubierta'),
		T_TIPO_DATA_OBRA('Patio'),
		T_TIPO_DATA_OBRA('Altillo'),
		T_TIPO_DATA_OBRA('Porche'),
		T_TIPO_DATA_OBRA('Garaje'),
		T_TIPO_DATA_OBRA('Trastero'),
		T_TIPO_DATA_OBRA('Sótano'),
		T_TIPO_DATA_OBRA('Zonas comunes'),
		T_TIPO_DATA_OBRA('Jardín'),
		T_TIPO_DATA_OBRA('Piscina'),
		T_TIPO_DATA_OBRA('Portal'),
		T_TIPO_DATA_OBRA('Vistas'),
		T_TIPO_DATA_OBRA('Otros')
	); 
    V_TMP_TIPO_DATA_OBRA T_TIPO_DATA_OBRA;

	TYPE T_TIPO_DATA_VIVIENDA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_VIVIENDA IS TABLE OF T_TIPO_DATA_VIVIENDA;
    V_TIPO_DATA_VIVIENDA T_ARRAY_DATA_VIVIENDA := T_ARRAY_DATA_VIVIENDA(
		T_TIPO_DATA_VIVIENDA('Fachada'),
		T_TIPO_DATA_VIVIENDA('Salón'),
		T_TIPO_DATA_VIVIENDA('Dormitorio'),
		T_TIPO_DATA_VIVIENDA('Buhardilla'),
		T_TIPO_DATA_VIVIENDA('Cocina'),
		T_TIPO_DATA_VIVIENDA('Baño'),
		T_TIPO_DATA_VIVIENDA('Aseo'),
		T_TIPO_DATA_VIVIENDA('Despensa'),
		T_TIPO_DATA_VIVIENDA('Lavadero'),
		T_TIPO_DATA_VIVIENDA('Tendedero'),
		T_TIPO_DATA_VIVIENDA('Hall'),
		T_TIPO_DATA_VIVIENDA('Balcón'),
		T_TIPO_DATA_VIVIENDA('Terraza cubierta'),
		T_TIPO_DATA_VIVIENDA('Terraza descubierta'),
		T_TIPO_DATA_VIVIENDA('Patio'),
		T_TIPO_DATA_VIVIENDA('Altillo'),
		T_TIPO_DATA_VIVIENDA('Porche'),
		T_TIPO_DATA_VIVIENDA('Garaje'),
		T_TIPO_DATA_VIVIENDA('Trastero'),
		T_TIPO_DATA_VIVIENDA('Sótano'),
		T_TIPO_DATA_VIVIENDA('Zonas comunes'),
		T_TIPO_DATA_VIVIENDA('Jardín'),
		T_TIPO_DATA_VIVIENDA('Piscina'),
		T_TIPO_DATA_VIVIENDA('Portal'),
		T_TIPO_DATA_VIVIENDA('Vistas'),
		T_TIPO_DATA_VIVIENDA('Planta calle'),
		T_TIPO_DATA_VIVIENDA('Otros')
    ); 
    V_TMP_TIPO_DATA_VIVIENDA T_TIPO_DATA_VIVIENDA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA_MAPEO.FIRST .. V_TIPO_DATA_MAPEO.LAST
    LOOP

        V_TMP_TIPO_DATA_MAPEO := V_TIPO_DATA_MAPEO(I);
        
		IF V_TMP_TIPO_DATA_MAPEO(3) = 'Suelo' THEN

			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' DE '||V_TMP_TIPO_DATA_MAPEO(3)||'');
            
            FOR I IN V_TIPO_DATA_SUELO.FIRST .. V_TIPO_DATA_SUELO.LAST
            LOOP

				V_MSQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TPA||' WHERE DD_TPA_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(1)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO;
					
				V_MSQL := 'SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SAC||' WHERE DD_SAC_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(2)||''' AND DD_TPA_ID = '||V_ID_TIPO||'';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBTIPO;

                V_TMP_TIPO_DATA_SUELO := V_TIPO_DATA_SUELO(I);
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_SUELO(1)||'');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (TPA_ID,SAC_ID,DESCRIPCION_FOTO) VALUES (
							'||V_ID_TIPO||','||V_ID_SUBTIPO||','''||V_TMP_TIPO_DATA_SUELO(1)||''')';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_SUELO(1)||'');
            
            END LOOP;

		ELSIF V_TMP_TIPO_DATA_MAPEO(3) = 'Local/nave/oficina' THEN
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' DE '||V_TMP_TIPO_DATA_MAPEO(3)||'');
            
            FOR I IN V_TIPO_DATA_LNO.FIRST .. V_TIPO_DATA_LNO.LAST
            LOOP

                V_MSQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TPA||' WHERE DD_TPA_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(1)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO;
					
				V_MSQL := 'SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SAC||' WHERE DD_SAC_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(2)||''' AND DD_TPA_ID = '||V_ID_TIPO||'';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBTIPO;

                V_TMP_TIPO_DATA_LNO := V_TIPO_DATA_LNO(I);
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_LNO(1)||'');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (TPA_ID,SAC_ID,DESCRIPCION_FOTO) VALUES (
							'||V_ID_TIPO||','||V_ID_SUBTIPO||','''||V_TMP_TIPO_DATA_LNO(1)||''')';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_LNO(1)||'');
            
            END LOOP;
        
        ELSIF V_TMP_TIPO_DATA_MAPEO(3) = 'Garaje' THEN
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' DE '||V_TMP_TIPO_DATA_MAPEO(3)||'');
            
            FOR I IN V_TIPO_DATA_GARAJE.FIRST .. V_TIPO_DATA_GARAJE.LAST
            LOOP

                V_MSQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TPA||' WHERE DD_TPA_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(1)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO;
					
				V_MSQL := 'SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SAC||' WHERE DD_SAC_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(2)||''' AND DD_TPA_ID = '||V_ID_TIPO||'';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBTIPO;

                V_TMP_TIPO_DATA_GARAJE := V_TIPO_DATA_GARAJE(I);
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_GARAJE(1)||'');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (TPA_ID,SAC_ID,DESCRIPCION_FOTO) VALUES (
							'||V_ID_TIPO||','||V_ID_SUBTIPO||','''||V_TMP_TIPO_DATA_GARAJE(1)||''')';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_GARAJE(1)||'');
            
            END LOOP;
        
        ELSIF V_TMP_TIPO_DATA_MAPEO(3) = 'Trastero' THEN
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' DE '||V_TMP_TIPO_DATA_MAPEO(3)||'');
            
            FOR I IN V_TIPO_DATA_TRASTERO.FIRST .. V_TIPO_DATA_TRASTERO.LAST
            LOOP

                V_MSQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TPA||' WHERE DD_TPA_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(1)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO;
					
				V_MSQL := 'SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SAC||' WHERE DD_SAC_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(2)||''' AND DD_TPA_ID = '||V_ID_TIPO||'';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBTIPO;

                V_TMP_TIPO_DATA_TRASTERO := V_TIPO_DATA_TRASTERO(I);
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_TRASTERO(1)||'');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (TPA_ID,SAC_ID,DESCRIPCION_FOTO) VALUES (
							'||V_ID_TIPO||','||V_ID_SUBTIPO||','''||V_TMP_TIPO_DATA_TRASTERO(1)||''')';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_TRASTERO(1)||'');
            
            END LOOP;
        
        ELSIF V_TMP_TIPO_DATA_MAPEO(3) = 'Obra en construcción' THEN
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' DE '||V_TMP_TIPO_DATA_MAPEO(3)||'');
            
            FOR I IN V_TIPO_DATA_OBRA.FIRST .. V_TIPO_DATA_OBRA.LAST
            LOOP

                V_MSQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TPA||' WHERE DD_TPA_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(1)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO;
					
				V_MSQL := 'SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SAC||' WHERE DD_SAC_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(2)||''' AND DD_TPA_ID = '||V_ID_TIPO||'';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBTIPO;

                V_TMP_TIPO_DATA_OBRA := V_TIPO_DATA_OBRA(I);
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_OBRA(1)||'');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (TPA_ID,SAC_ID,DESCRIPCION_FOTO) VALUES (
							'||V_ID_TIPO||','||V_ID_SUBTIPO||','''||V_TMP_TIPO_DATA_OBRA(1)||''')';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_OBRA(1)||'');
            
            END LOOP;
        
        ELSIF V_TMP_TIPO_DATA_MAPEO(3) = 'Vivienda' THEN

			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' DE '||V_TMP_TIPO_DATA_MAPEO(3)||'');
            
            FOR I IN V_TIPO_DATA_VIVIENDA.FIRST .. V_TIPO_DATA_VIVIENDA.LAST
            LOOP

                V_MSQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TPA||' WHERE DD_TPA_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(1)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO;
					
				V_MSQL := 'SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_SAC||' WHERE DD_SAC_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA_MAPEO(2)||''' AND DD_TPA_ID = '||V_ID_TIPO||'';
				EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBTIPO;

                V_TMP_TIPO_DATA_VIVIENDA := V_TIPO_DATA_VIVIENDA(I);
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_VIVIENDA(1)||'');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (TPA_ID,SAC_ID,DESCRIPCION_FOTO) VALUES (
							'||V_ID_TIPO||','||V_ID_SUBTIPO||','''||V_TMP_TIPO_DATA_VIVIENDA(1)||''')';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO '||V_TMP_TIPO_DATA_MAPEO(1)||', SUBTIPO '||V_TMP_TIPO_DATA_MAPEO(2)||' -> DATO '||V_TMP_TIPO_DATA_VIVIENDA(1)||'');
            
            END LOOP;

		END IF;

	END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;
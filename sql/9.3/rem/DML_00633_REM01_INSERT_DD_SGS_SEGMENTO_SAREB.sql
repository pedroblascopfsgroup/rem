--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13957
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SGS_SEGMENTO_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_TABLA_FK VARCHAR2(2400 CHAR) := 'ACT_SAREB_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_FK_NAME VARCHAR2(2400 CHAR) := 'FK_DD_SGS_ID_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('A00','A00','Residencial Promoción - Necesario análisis específico'),   
		T_TIPO_DATA('A01','A01','Residencial Promoción - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('A02','A02','Residencial Promoción - Run-off - Estrategia venta media'),
		T_TIPO_DATA('A03','A03','Residencial Promoción - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('A04','A04','Residencial Promoción - Alquiler - Estrategia alquiler agresiva'),
		T_TIPO_DATA('A05','A05','Residencial Promoción - Alquiler - Estrategia alquiler media'),
		T_TIPO_DATA('A06','A06','Residencial Promoción - Alquiler - Estrategia alquiler conservadora'),
		T_TIPO_DATA('A07','A07','Residencial Promoción - Portfolio social'),
		T_TIPO_DATA('B00','B00','Residencial Atomizado - Necesario análisis específico'),   
		T_TIPO_DATA('B01','B01','Residencial Atomizado - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('B02','B02','Residencial Atomizado - Run-off - Estrategia venta media'),
		T_TIPO_DATA('B03','B03','Residencial Atomizado - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('B04','B04','Residencial Atomizado - Alquiler - Estrategia alquiler agresiva'),
		T_TIPO_DATA('B05','B05','Residencial Atomizado - Alquiler - Estrategia alquiler media'),
		T_TIPO_DATA('B06','B06','Residencial Atomizado - Alquiler - Estrategia alquiler conservadora'),
		T_TIPO_DATA('B07','B07','Residencial Atomizado - Portfolio social'),
		T_TIPO_DATA('C00','C00','Cartera Retail Suelo Finalista - Necesario análisis específico'),
		T_TIPO_DATA('C01','C01','Cartera Retail Suelo Finalista - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('C02','C02','Cartera Retail Suelo Finalista - Run-off - Estrategia venta media'),
		T_TIPO_DATA('C03','C03','Cartera Retail Suelo Finalista - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('C07','C07','Cartera Retail Suelo Finalista - Portfolio social'),
		T_TIPO_DATA('C09','C09','Cartera Retail Suelo Finalista - Promoción suelo Finalista y finalizaciòn WIP'),
		T_TIPO_DATA('D00','D00','Cartera Retail Suelo Gestión - Necesario análisis específico'),
		T_TIPO_DATA('D01','D01','Cartera Retail Suelo Gestión - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('D02','D02','Cartera Retail Suelo Gestión - Run-off - Estrategia venta media'),
		T_TIPO_DATA('D03','D03','Cartera Retail Suelo Gestión - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('D08','D08','Cartera Retail Suelo Gestión - Desarrollo suelo urbanizable y gestión fincas rústicas'),
		T_TIPO_DATA('E00','E00','Cartera Retail Suelo Rústicas - Necesario análisis específico'),
		T_TIPO_DATA('E01','E01','Cartera Retail Suelo Rústicas - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('E02','E02','Cartera Retail Suelo Rústicas - Run-off - Estrategia venta media'),
		T_TIPO_DATA('E03','E03','Cartera Retail Suelo Rústicas - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('E08','E08','Cartera Retail Suelo Rústicas - Desarrollo suelo urbanizable y gestión fincas rústicas'),
		T_TIPO_DATA('F00','F00','Cartera Retail Terciario Comercial - Necesario análisis específico'),
		T_TIPO_DATA('F01','F01','Cartera Retail Terciario Comercial - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('F02','F02','Cartera Retail Terciario Comercial - Run-off - Estrategia venta media'),
		T_TIPO_DATA('F03','F03','Cartera Retail Terciario Comercial - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('F10','F10','Cartera Retail Terciario Comercial - Gestión en valor activos terciarios'),
		T_TIPO_DATA('F11','F11','Cartera Retail Terciario Comercial - Venta conjunta'),
		T_TIPO_DATA('G00','G00','Cartera Retail Terciario Industrial - Necesario análisis específico'),
		T_TIPO_DATA('G01','G01','Cartera Retail Terciario Industrial - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('G02','G02','Cartera Retail Terciario Industrial - Run-off - Estrategia venta media'),
		T_TIPO_DATA('G03','G03','Cartera Retail Terciario Industrial - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('G10','G10','Cartera Retail Terciario Industrial - Gestión en valor activos terciarios'),
		T_TIPO_DATA('G11','G11','Cartera Retail Terciario Industrial - Venta conjunta'),
		T_TIPO_DATA('H00','H00','Cartera Retail Terciario Otros - Necesario análisis específico'),
		T_TIPO_DATA('H01','H01','Cartera Retail Terciario Otros - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('H02','H02','Cartera Retail Terciario Otros - Run-off - Estrategia venta media'),
		T_TIPO_DATA('H03','H03','Cartera Retail Terciario Otros - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('H10','H10','Cartera Retail Terciario Otros - Gestión en valor activos terciarios'),
		T_TIPO_DATA('H11','H11','Cartera Retail Terciario Otros - Venta conjunta'),
		T_TIPO_DATA('I00','I00','Cartera Profesional Suelo Finalista - Necesario análisis específico'),
		T_TIPO_DATA('I01','I01','Cartera Profesional Suelo Finalista - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('I02','I02','Cartera Profesional Suelo Finalista - Run-off - Estrategia venta media'),
		T_TIPO_DATA('I03','I03','Cartera Profesional Suelo Finalista - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('I07','I07','Cartera Profesional Suelo Finalista - Portfolio social'),
		T_TIPO_DATA('I09','I09','Cartera Profesional Suelo Finalista - Promoción suelo Finalista y finalizaciòn WIP'),
		T_TIPO_DATA('J00','J00','Cartera Profesional Suelo Gestión - Necesario análisis específico'),
		T_TIPO_DATA('J01','J01','Cartera Profesional Suelo Gestión - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('J02','J02','Cartera Profesional Suelo Gestión - Run-off - Estrategia venta media'),
		T_TIPO_DATA('J03','J03','Cartera Profesional Suelo Gestión - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('J08','J08','Cartera Profesional Suelo Gestión - Desarrollo suelo urbanizable y gestión fincas rústicas'),
		T_TIPO_DATA('K00','K00','Cartera Profesional Suelo Rústicas - Necesario análisis específico'),
		T_TIPO_DATA('K01','K01','Cartera Profesional Suelo Rústicas - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('K02','K02','Cartera Profesional Suelo Rústicas - Run-off - Estrategia venta media'),
		T_TIPO_DATA('K03','K03','Cartera Profesional Suelo Rústicas - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('K08','K08','Cartera Profesional Suelo Rústicas - Desarrollo suelo urbanizable y gestión fincas rústicas'),
		T_TIPO_DATA('L00','L00','Cartera Profesional Terciario Comercial - Necesario análisis específico'),
		T_TIPO_DATA('L01','L01','Cartera Profesional Terciario Comercial - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('L02','L02','Cartera Profesional Terciario Comercial - Run-off - Estrategia venta media'),
		T_TIPO_DATA('L03','L03','Cartera Profesional Terciario Comercial - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('L10','L10','Cartera Profesional Terciario Comercial - Gestión en valor activos terciarios'),
		T_TIPO_DATA('L11','L11','Cartera Profesional Terciario Comercial - Venta conjunta'),
		T_TIPO_DATA('M00','M00','Cartera Profesional Terciario Industrial - Necesario análisis específico'),
		T_TIPO_DATA('M01','M01','Cartera Profesional Terciario Industrial - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('M02','M02','Cartera Profesional Terciario Industrial - Run-off - Estrategia venta media'),
		T_TIPO_DATA('M03','M03','Cartera Profesional Terciario Industrial - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('M10','M10','Cartera Profesional Terciario Industrial - Gestión en valor activos terciarios'),
		T_TIPO_DATA('M11','M11','Cartera Profesional Terciario Industrial - Venta conjunta'),
		T_TIPO_DATA('N00','N00','Cartera Profesional Terciario Otros - Necesario análisis específico'),
		T_TIPO_DATA('N01','N01','Cartera Profesional Terciario Otros - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('N02','N02','Cartera Profesional Terciario Otros - Run-off - Estrategia venta media'),
		T_TIPO_DATA('N03','N03','Cartera Profesional Terciario Otros - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('N10','N10','Cartera Profesional Terciario Otros - Gestión en valor activos terciarios'),
		T_TIPO_DATA('N11','N11','Cartera Profesional Terciario Otros - Venta conjunta'),
		T_TIPO_DATA('O00','O00','WIP - Necesario análisis específico'),
		T_TIPO_DATA('O01','O01','WIP - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('O02','O02','WIP - Run-off - Estrategia venta media'),
		T_TIPO_DATA('O03','O03','WIP - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('O07','O07','WIP - Portfolio social'),
		T_TIPO_DATA('O09','O09','WIP - Promoción suelo Finalista y finalizaciòn WIP'),
		T_TIPO_DATA('P00','P00','WIP - Necesario análisis específico'),
		T_TIPO_DATA('P01','P01','WIP - Run-off - Estrategia venta agresiva'),
		T_TIPO_DATA('P02','P02','WIP - Run-off - Estrategia venta media'),
		T_TIPO_DATA('P03','P03','WIP - Run-off - Estrategia venta conservadora'),
		T_TIPO_DATA('P07','P07','WIP - Portfolio social'),
		T_TIPO_DATA('P09','P09','WIP - Promoción suelo Finalista y finalizaciòn WIP')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- DISABLED foreign key para poder truncar la tabla--
	DBMS_OUTPUT.PUT_LINE('[INFO]: DESHABILITAMOS LA FK DE LA TABLA '||V_TEXT_TABLA_FK);
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_FK||' 
				DISABLE CONSTRAINT '||V_FK_NAME||'';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: DESHABILITADA LA FK DE LA TABLA '||V_TEXT_TABLA_FK);

    -- TRUNCATE de los registros anteriores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS SI EXISTEN CAMPOS EN LA TABLA '||V_TEXT_TABLA);
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE 
          DD_SGS_CODIGO = ''01'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: TRUNCAMOS TABLA '||V_TEXT_TABLA);
    		V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||''; 
    		EXECUTE IMMEDIATE V_SQL;
		END IF;
    COMMIT;

	-- ENABLED foreign key para poder insertar en la tabla--
	DBMS_OUTPUT.PUT_LINE('[INFO]: HABILITAMOS LA FK DE LA TABLA '||V_TEXT_TABLA_FK);
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_FK||' 
				ENABLE CONSTRAINT '||V_FK_NAME||'';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: HABILITADA LA FK DE LA TABLA '||V_TEXT_TABLA_FK);

	-- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        --Comprobar el dato a insertar.
		DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos que el campo '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_SGS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_SGS_ID,
              DD_SGS_CODIGO,
              DD_SGS_DESCRIPCION,
              DD_SGS_DESCRIPCION_LARGA,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              0,
              ''HREOS-13957'',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||'''');

        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE');

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

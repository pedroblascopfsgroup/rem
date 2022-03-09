--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20211215
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16615
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SED_SUBPARTIDA_EDIFICACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'SED'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('01','Ejecución de obra principal'),
      T_TIPO_DATA('02','Ejecución de obra adicional 1'),
      T_TIPO_DATA('03','Ejecución de obra adicional 2'),
      T_TIPO_DATA('04','Urbanización'),
      T_TIPO_DATA('05','Control de calidad'),
      T_TIPO_DATA('06','Compañia eléctrica'),
      T_TIPO_DATA('07','Compañia agua'),
      T_TIPO_DATA('08','Compañia gas'),
      T_TIPO_DATA('09','Compañia telefónica'),
      T_TIPO_DATA('10','Compañia OTRAS'),
      T_TIPO_DATA('11','Terceros afectados'),
      T_TIPO_DATA('12','Dirección técnica urbanización'),
      T_TIPO_DATA('13','Proyecto Básico'),
      T_TIPO_DATA('14','Proyecto de Urbanización'),
      T_TIPO_DATA('15','Proyectos específicos'),
      T_TIPO_DATA('16','Dirección de obra arquitecto'),
      T_TIPO_DATA('17','Dirección de obra aparejador'),
      T_TIPO_DATA('18','Coordinador Seguridad y Salud'),
      T_TIPO_DATA('19','Project Manager (Gestión integral)'),
      T_TIPO_DATA('20','Project Controller (Controlador de obra)'),
      T_TIPO_DATA('21','OCT'),
      T_TIPO_DATA('22','Proyecto topográfico'),
      T_TIPO_DATA('23','Proyecto Geotécnico'),
      T_TIPO_DATA('24','Reparcelación'),
      T_TIPO_DATA('25','Proyecto Ejecución'),
      T_TIPO_DATA('26','Otros honorarios técnicos'),
      T_TIPO_DATA('27','Gastos suplidos'),
      T_TIPO_DATA('28','Seguro Decenal'),
      T_TIPO_DATA('29','Gastos de notario y registro (D.H.)'),
      T_TIPO_DATA('30','Gastos de notario y registro (O.N.)'),
      T_TIPO_DATA('31','Gastos de notario y registro (AFO)'),
      T_TIPO_DATA('32','Gastos de notario y registro (Segreg./Agrup.)'),
      T_TIPO_DATA('33','Gastos de notario y registro (Otros)'),
      T_TIPO_DATA('34','Licencia obra (mayor/menor)'),
      T_TIPO_DATA('35','ICIO'),
      T_TIPO_DATA('36','Licencia 1ª Ocupación/Actividad'),
      T_TIPO_DATA('37','Tasas otros organismos'),
      T_TIPO_DATA('38','AJD: O.N., D.H., Segr/Agr. y otros'),
      T_TIPO_DATA('39','Publicidad'),
      T_TIPO_DATA('40','Otros gastos no activables'),
      T_TIPO_DATA('41','Avales'),
      T_TIPO_DATA('42','Contingencias generales')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN			
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
          (DD_'||V_TEXT_CHARS||'_ID
          , DD_'||V_TEXT_CHARS||'_CODIGO
          , DD_'||V_TEXT_CHARS||'_DESCRIPCION
          , DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA 
          , USUARIOCREAR
          , FECHACREAR) 
            SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
            , '''||V_TMP_TIPO_DATA(1)||'''
            , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            , ''HREOS-16615''
            , SYSDATE
            FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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

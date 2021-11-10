--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13993
--## PRODUCTO=NO
--##
--## Finalidad: Insertar registros en DD_DIC_DISTRITO_CAIXA           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto  en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-13993';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_DIC_DISTRITO_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('1','BCN-CIUTAT VELLA'),
        T_TIPO_DATA('2','BCN-EIXAMPLE'),
        T_TIPO_DATA('3','BCN-GRACIA'),
        T_TIPO_DATA('4','BCN-HORTA -GUINARDO'),
        T_TIPO_DATA('5','BCN-LES CORTS'),
        T_TIPO_DATA('6','BCN-NOU BARRIS'),
        T_TIPO_DATA('7','BCN-SANT ANDREU'),
        T_TIPO_DATA('8','BCN-SANT MARTI'),
        T_TIPO_DATA('9','BCN-SANTS'),
        T_TIPO_DATA('10','BCN-SARRIA -SANT GERVASI'),
        T_TIPO_DATA('11','MAD-ARGANZUELA'),
        T_TIPO_DATA('12','MAD-BARAJAS'),
        T_TIPO_DATA('13','MAD-CANILLEJAS'),
        T_TIPO_DATA('14','MAD-CARABANCHEL'),
        T_TIPO_DATA('15','MAD-CENTRO'),
        T_TIPO_DATA('16','MAD-CHAMARTIN'),
        T_TIPO_DATA('17','MAD-CHAMBERI'),
        T_TIPO_DATA('18','MAD-CIUDAD LINEAL'),
        T_TIPO_DATA('19','MAD-FUENCARRAL'),
        T_TIPO_DATA('20','MAD-HORTALEZA'),
        T_TIPO_DATA('21','MAD-LA LATINA'),
        T_TIPO_DATA('22','MAD-MONCLOA'),
        T_TIPO_DATA('23','MAD-MORATALAZ'),
        T_TIPO_DATA('24','MAD-PUENTE DE VALLECAS'),
        T_TIPO_DATA('25','MAD-RETIRO'),
        T_TIPO_DATA('26','MAD-SALAMANCA'),
        T_TIPO_DATA('27','MAD-TETUAN'),
        T_TIPO_DATA('28','MAD-USERA'),
        T_TIPO_DATA('29','MAD-VICALVARO'),
        T_TIPO_DATA('30','MAD-VILLA DE VALLECAS'),
        T_TIPO_DATA('31','MAD-VILLAVERDE')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_DIC_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_DIC_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_DIC_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(2)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_DIC_ID,
                    DD_DIC_CODIGO,
                    DD_DIC_DESCRIPCION,
                    DD_DIC_DESCRIPCION_LARGA,
                    VERSION,
                    USUARIOCREAR,
                    FECHACREAR,
                    BORRADO) VALUES(
					'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
					,'''||V_TMP_TIPO_DATA(1)||'''
                    ,'''||V_TMP_TIPO_DATA(2)||'''
					,'''||V_TMP_TIPO_DATA(2)||'''
                    ,0
                    ,'''||V_ITEM||'''
                    ,SYSDATE
                    ,0)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			END IF;
	END LOOP;
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');
	   
	
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

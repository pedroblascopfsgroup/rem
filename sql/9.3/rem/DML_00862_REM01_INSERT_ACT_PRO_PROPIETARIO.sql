--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14718
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_PRO_PROPIETARIO los datos añadidos en T_ARRAY_DATA
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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14718';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PRO_PROPIETARIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('0001','CAIXABANK','A08663619','Calle Diagonal 621','08028','08019','03'),
		T_TIPO_DATA('0015','LivingCenter, S.A.U','A58032244','Av. De Manoteras 20, Edificio París','08050','28079','03'),
		T_TIPO_DATA('3148','BANKIA HÁBITAT, S.L.U.','B46644290','Av. De Manoteras 20, Edificio París','08050','28079','03'),
		T_TIPO_DATA('3149','EUROPEA DE TITULIZACIÓN, S.A., S.G.F.T.','A80514466','Jorge Juan 68','28009','28079','03'),
		T_TIPO_DATA('3143','Titulización de Activos, Sociedad Gestora de Fondos de Titulización, S.A.','A80352750','Orense, 58','28020','28079','03')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
				DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''''); 
				V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET
					DD_LOC_ID = (SELECT DD_LOC_ID FROM '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||V_TMP_TIPO_DATA(6)||''')
					, DD_PRV_ID = (SELECT DD_PRV_ID FROM '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||V_TMP_TIPO_DATA(6)||''')
					, PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(1)||'''
					, DD_TPE_ID = (SELECT DD_TPE_ID FROM '|| V_ESQUEMA_M ||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = ''2'')
					, PRO_NOMBRE = '''||V_TMP_TIPO_DATA(2)||'''
					, DD_TDI_ID = (SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''15'')
					, PRO_DIR = '''||V_TMP_TIPO_DATA(4)||'''
					, PRO_CP = '''||V_TMP_TIPO_DATA(5)||'''
					, USUARIOMODIFICAR = '''||V_ITEM||'''
					, FECHAMODIFICAR = SYSDATE
					, DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(7)||''')
					, PRO_SOCIEDAD_PAGADORA = '''||V_TMP_TIPO_DATA(1)||'''
					WHERE PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(3)||'''';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');

			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					PRO_ID
					, DD_LOC_ID
					, DD_PRV_ID
					, PRO_CODIGO_UVEM
					, DD_TPE_ID
					, PRO_NOMBRE
					, DD_TDI_ID
					, PRO_DOCIDENTIF
					, PRO_DIR
					, PRO_CP
					, USUARIOCREAR
					, FECHACREAR
					, DD_CRA_ID
					, PRO_SOCIEDAD_PAGADORA
					) VALUES(
					'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
					, (SELECT DD_LOC_ID FROM '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||V_TMP_TIPO_DATA(6)||''')
					, (SELECT DD_PRV_ID FROM '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||V_TMP_TIPO_DATA(6)||''')
					, '''||V_TMP_TIPO_DATA(1)||'''
					, (SELECT DD_TPE_ID FROM '|| V_ESQUEMA_M ||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = ''2'')
					, '''||V_TMP_TIPO_DATA(2)||'''
					, (SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''15'')
					, '''||V_TMP_TIPO_DATA(3)||'''
					, '''||V_TMP_TIPO_DATA(4)||'''
					, '''||V_TMP_TIPO_DATA(5)||'''
					, '''||V_ITEM||'''
					, SYSDATE
					, (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(7)||''')
					, '''||V_TMP_TIPO_DATA(1)||'''
					)';
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

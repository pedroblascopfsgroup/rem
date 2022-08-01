--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220801
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18499
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_EEB_ESTADO_EXPEDIENTE_BC los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Añadir nuevos estados al expediente BC - HREOS-18499 [Javier Esbri]
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-18499';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EEB_ESTADO_EXPEDIENTE_BC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    			--  DD_EEB_CODIGO  	DD_EEB_DESCRIPCION  							DD_EEB_CODIGO_C4C
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
       T_TIPO_DATA('051', 			'Borrador enviado', 									'720'),
       T_TIPO_DATA('052', 			'Pte validación cambios clausurado en clausulado', 		'780'),
       T_TIPO_DATA('053', 			'Clausulado no negociable', 							'790'),
       T_TIPO_DATA('054', 			'Entrega de fianzas/garantías/Aval', 					'740'),
       T_TIPO_DATA('055', 			'Borrador aceptado', 									'730'),
	   -- ↓↓↓ HREOS_18499 ↓↓↓
	   T_TIPO_DATA('056', 			'Comunicar subrogación del contrato ', 										'770'),
	   T_TIPO_DATA('057', 			'Adenda necesaria', 														''),
	   T_TIPO_DATA('058', 			'Gestión de adecuaciones y certificaciones ofrecidas por el cliente', 		'750'),
	   T_TIPO_DATA('059', 			'Recisión Contrato', 														'600'),
	   T_TIPO_DATA('060', 			'Recisión agendada', 														'760')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_EEB_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_EEB_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_EEB_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_EEB_CODIGO_C4C = '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_EEB_ID,DD_EEB_CODIGO, DD_EEB_DESCRIPCION,DD_EEB_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_EEB_CODIGO_C4C) VALUES(
					'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
					,'''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||'''
					,'''||V_TMP_TIPO_DATA(2)||''',0,'''||V_ITEM||''',SYSDATE,0,'''||V_TMP_TIPO_DATA(3)||''')';
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

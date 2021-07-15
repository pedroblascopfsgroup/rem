--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14635
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_EEB_ESTADO_EXPEDIENTE_BC los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14635';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('44','Pte. PBC CN','Pte. PBC CN','1','0'),
		T_TIPO_DATA('45','Pte. PBC arras','Pte. PBC arras','1','0'),
		T_TIPO_DATA('46','Pte. PBC venta','Pte. PBC venta','1','0'),
		T_TIPO_DATA('47','Pte. agendar arras','Pte. agendar arras','1','0'),
		T_TIPO_DATA('48','Pte. agendar firma','Pte. agendar firma','1','0'),
		T_TIPO_DATA('49','Pte. firma arras','Pte. firma arras','1','0'),
		T_TIPO_DATA('50','Pendiente garantias adicionales','Pendiente garantias adicionales','0','1'),
		T_TIPO_DATA('51','Pte. agendar','Pte. agendar','0','1'),
		T_TIPO_DATA('52','Pte. envío','Pte. envío','0','1')		
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_EEC_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_EEC_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_EEC_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_EEC_ID,DD_EEC_CODIGO, DD_EEC_DESCRIPCION,DD_EEC_DESCRIPCION_LARGA,DD_EEC_VENTA,DD_EEC_ALQUILER, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
					'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
					,'''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||'''
					,'''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||'''
					,'''||V_TMP_TIPO_DATA(5)||''',0,'''||V_ITEM||''',SYSDATE,0)';
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

--/*
--##########################################
--## AUTOR= Lara Pablo Flores
--## FECHA_CREACION=20210728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14740
--## PRODUCTO=NO
--## Finalidad: Creación diccionario DD_MRA_MOTIVO_RESCISION_ARRAS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14637';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRA_MOTIVO_RESCISION_ARRAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CODIGO_TABLA VARCHAR2(2400 CHAR) := 'MRA';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('001','Título inscrito'),
        T_TIPO_DATA('002','Posesión'),
        T_TIPO_DATA('003','VPO'),
        T_TIPO_DATA('004','Problemas técnicos'),
        T_TIPO_DATA('005','Cargas'),
        T_TIPO_DATA('006','Motivos personales comprador'),
        T_TIPO_DATA('007','Discrepancias registrales'),
        T_TIPO_DATA('008','Alquiler'),
        T_TIPO_DATA('009','Otros')
             
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_'|| V_CODIGO_TABLA ||'_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_'|| V_CODIGO_TABLA ||'_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_'|| V_CODIGO_TABLA ||'_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(2)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_'|| V_CODIGO_TABLA ||'_ID,DD_'|| V_CODIGO_TABLA ||'_CODIGO, DD_'|| V_CODIGO_TABLA ||'_DESCRIPCION,DD_'|| V_CODIGO_TABLA ||'_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
					'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
					,'''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||'''
					,'''||V_TMP_TIPO_DATA(2)||''',0,'''||V_ITEM||''',SYSDATE,0)';
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
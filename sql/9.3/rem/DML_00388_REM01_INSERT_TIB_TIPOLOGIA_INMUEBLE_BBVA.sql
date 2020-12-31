--/*
--##########################################
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20201002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO= 9.3
--## INCIDENCIA_LINK=HREOS-11270
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla TIB_TIPOLOGIA_INMUEBLE_BBVA 
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
    V_TABLA VARCHAR2(30 CHAR) := 'TIB_TIPOLOGIA_INMUEBLE_BBVA';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-11270';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('1', '1', '07', 'Terreno rústico', '70', 'Suelo Rústico', 'A20'),
        T_TIPO_DATA('1', '3', '09', 'Terreno Residencial', '70', 'Suelo Rústico', 'A20'),
        T_TIPO_DATA('1', '2', '09', 'Terreno Residencial', '70', 'Suelo Rústico', 'A20'),
        T_TIPO_DATA('1', '4', '09', 'Terreno Residencial', '70', 'Suelo Rústico', 'A20'),
        T_TIPO_DATA('1', '1', '07', 'Terreno rústico', '70', 'Suelo Rústico', 'A20'),
        T_TIPO_DATA('2', '10', '01', 'Vivienda', '51', 'Vivienda Plurifamiliar', 'A02'),
        T_TIPO_DATA('2', '12', '01', 'Vivienda', '51', 'Vivienda Plurifamiliar', 'A02'),
        T_TIPO_DATA('2', '9', '01', 'Vivienda', '51', 'Vivienda Plurifamiliar', 'A02'),
        T_TIPO_DATA('2', '8', '01', 'Vivienda', '50', 'Vivienda Unifamiliar', 'A01'),
        T_TIPO_DATA('2', '7', '01', 'Vivienda', '50', 'Vivienda Unifamiliar', 'A01'),
        T_TIPO_DATA('2', '6', '01', 'Vivienda', '50', 'Vivienda Unifamiliar', 'A01'),
        T_TIPO_DATA('2', '5', '01', 'Vivienda', '50', 'Vivienda Unifamiliar', 'A01'),
        T_TIPO_DATA('2', '11', '01', 'Vivienda', '51', 'Vivienda Plurifamiliar', 'A02'),
        T_TIPO_DATA('3', '42', '23', 'Zona deportiva', '67', 'Lúdico', 'A17'),
        T_TIPO_DATA('3', '15', '04', 'Nave industrial', '61', 'Almacenaje', 'A12'),
        T_TIPO_DATA('3', '16', '12', 'Hotel', '56', 'Hotelero', 'A07'),
        T_TIPO_DATA('3', '14', '03', 'Oficina', '54', 'Oficina', 'A05'),
        T_TIPO_DATA('3', '13', '03', 'Local comercial', '55', 'Comercial', 'A06'),
        T_TIPO_DATA('3', '43', '03', 'Local comercial', '62', 'Servicios Empresariales', 'A13'),
        T_TIPO_DATA('4', '51', '04', 'Nave industrial', '60', 'Industrial', 'A11'),
        T_TIPO_DATA('4', '17', '04', 'Nave industrial', '60', 'Industrial', 'A11'),
        T_TIPO_DATA('4', '18', '04', 'Nave industrial', '60', 'Industrial', 'A11'),
        T_TIPO_DATA('5', '22', '03', 'Local comercial', '55', 'Comercial', 'A06'),
        T_TIPO_DATA('5', '21', '04', 'Nave industrial', '62', 'Servicios Empresariales', 'A13'),
        T_TIPO_DATA('5', '19', '05', 'Garaje/Aparcamiento', '52', 'Garaje', 'A03'),
        T_TIPO_DATA('5', '20', '12', 'Hotel', '56', 'Hotelero', 'A07'),
        T_TIPO_DATA('6', '23', '01', 'Vivienda', '51', 'Vivienda Plurifamiliar', 'A02'),
        T_TIPO_DATA('7', '49', '11', 'Terreno industrial', '69', 'Infraestructural', 'A19'),
        T_TIPO_DATA('7', '24', '05', 'Garaje/Aparcamiento', '52', 'Garaje', 'A03'),
        T_TIPO_DATA('7', '50', '35', 'Jardín-Huerto', '69', 'Infraestructural', 'A19'),
        T_TIPO_DATA('7', '25', '24', 'Trastero', '53', 'Trastero', 'A04'),
        T_TIPO_DATA('7', '61', '13', 'Edificio', '68', 'Residencia Colectiva', 'A18'),
        T_TIPO_DATA('7', '26', '35', 'Jardín-Huerto', '69', 'Infraestructural', 'A19'),
        T_TIPO_DATA('21', '48', '03', 'Local comercial', '63', 'Asistencial', 'A14'),
        T_TIPO_DATA('21', '46', '23', 'Zona deportiva', '63', 'Asistencial', 'A14'),
        T_TIPO_DATA('21', '44', '23', 'Zona deportiva', '66', 'Deportivo', 'A16'),
        T_TIPO_DATA('21', '62', '03', 'Local comercial', '63', 'Asistencial', 'A14'),
        T_TIPO_DATA('21', '45', '03', 'Local comercial', '63', 'Asistencial', 'A14'),
        T_TIPO_DATA('22', '47', '', '', '71', 'Derechos', 'A21')
); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
		       	   V_MSQL := '
		                     INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
		                        TIB_ID,
			                    DD_TPA_ID,
                                DD_SAC_ID,
                                TIB_CODIGO_SGITAS,
                                TIB_DESCRIPCION_SGITAS,
                                TIB_CODIGO_ACOGE,
                                TIB_DESCRIPCION_ACOGE,
                                TIB_TIPOLOGIA_BBVA,
                                USUARIOCREAR, 
                                FECHACREAR	                       
		                    ) VALUES (
		                        '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
		                        '''||V_TMP_TIPO_DATA(1)||''',
		                        '''||V_TMP_TIPO_DATA(2)||''',
		                        '''||V_TMP_TIPO_DATA(3)||''',
								'''||V_TMP_TIPO_DATA(4)||''',
                                '''||V_TMP_TIPO_DATA(5)||''',
								'''||V_TMP_TIPO_DATA(6)||''',
                                '''||V_TMP_TIPO_DATA(7)||''',
                                '''||V_USUARIO||''',
                                SYSDATE                   
		                      )';
		
		          EXECUTE IMMEDIATE V_MSQL;          
      
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');


EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

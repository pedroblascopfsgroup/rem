--/*
--##########################################
--## AUTOR=Maria Presencia
--## FECHA_CREACION=20181116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.4
--## INCIDENCIA_LINK=HREOS-4717
--## PRODUCTO=NO
--## 
--## Finalidad:           
--## INSTRUCCIONES: Insert tabla TMP_MAPEO_PUBLICACION_INICIAL
--## VERSIONES:
--##           0.1 Version inicial (Maria Presencia)
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
    V_TABLA VARCHAR2(2400 CHAR) := 'TMP_MAPEO_PUBLICACION_INICIAL'; -- Vble. para la tabla

        
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('03','03','1','0','0','0',null,null,'01',null,'01','1','0','0','01','0',null,null),
		T_TIPO_DATA('01','01','0','0','0','0',null,null,null,'01','01','1','0','0','03','0',null,null),
		T_TIPO_DATA('02','03','1','0','0','0',null,null,'01','01','01','1','0','0','03','0',null,null),
		T_TIPO_DATA('03','03','1','0','0','0',null,null,'02',null,'02','0','0','0','01','0',null,null),
		T_TIPO_DATA('01','01','0','0','0','0',null,null,null,'02','02','1','0','0','03','0',null,null),
		T_TIPO_DATA('02','03','1','0','0','0',null,null,'02','02','02','1','0','0','03','0',null,null),
		T_TIPO_DATA('03','03','1','0','1','0',null,null,'01',null,'04','0','0','1','01','0',null,null),
		T_TIPO_DATA('01','01','0','0','1','0',null,null,null,'01','04','1','0','1','03','0',null,null),
		T_TIPO_DATA('02','03','1','0','1','0',null,null,'01','01','04','1','0','1','03','0',null,null),
		T_TIPO_DATA('03','03','1','0','1','0',null,null,'02',null,'07','0','0','1','01','0',null,null),
		T_TIPO_DATA('01','01','0','0','1','0',null,null,null,'02','07','1','0','1','03','0',null,null),
		T_TIPO_DATA('02','03','1','0','1','0',null,null,'02','02','07','1','0','1','03','0',null,null),
		T_TIPO_DATA('03','04','1','1','0','0',null,null,null,null,'03','0','0','0','01','0',null,null),
		T_TIPO_DATA('01','01','0','0','0','0',null,null,null,null,'03','1','1','0','04','0',null,null),
		T_TIPO_DATA('02','04','1','1','0','0',null,null,null,null,'03','1','1','0','04','0',null,null),
		T_TIPO_DATA('03','04','1','1','0','0','12','Migración',null,null,'05','0','0','0','01','0',null,null),
		T_TIPO_DATA('01','01','0','0','0','0',null,null,null,null,'05','1','1','0','04','0','12','Migración'),
		T_TIPO_DATA('02','04','1','1','0','0','12','Migración',null,null,'05','1','1','0','04','0','12','Migración'),
		T_TIPO_DATA('03','01','0','0','0','0',null,null,null,null,'06','0','0','0','01','0',null,null),
		T_TIPO_DATA('01','01','0','0','0','0',null,null,null,null,'06','0','0','0','01','0',null,null),
		T_TIPO_DATA('02','01','0','0','0','0',null,null,null,null,'06','0','0','0','01','0',null,null)
    ); 

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

         
    -- LOOP para insertar los valores en TMP_MAPEO_PUBLICACION_INICIAL -------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);                            
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS');   
 
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (' ||
						'DD_TCO_CODIGO
						,DD_EPA_CODIGO
						,APU_CHECK_PUBLICAR_A
						,APU_CHECK_OCULTAR_A
						,APU_CHECK_OCULT_PRECIO_A
						,APU_CHECK_PUB_SIN_PRECIO_A
						,DD_MTO_A_CODIGO
						,MTO_OCULTACION_A
						,DD_TPU_A_CODIGO
						,DD_TPU_V_CODIGO
						,DD_EPU_CODIGO
						,APU_CHECK_PUBLICAR_V
						,APU_CHECK_OCULTAR_V
						,APU_CHECK_OCULT_PRECIO_V
						,DD_EPV_CODIGO
						,APU_CHECK_PUB_SIN_PRECIO_V
						,DD_MTO_V_CODIGO
						,MTO_OCULTACION_V
						) ' ||
                      'SELECT
					  '''||TRIM(V_TMP_TIPO_DATA(1))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                      '||TRIM(V_TMP_TIPO_DATA(5))||',
                      '||TRIM(V_TMP_TIPO_DATA(6))||',
                      '||TRIM(V_TMP_TIPO_DATA(7))||',
                      '||TRIM(V_TMP_TIPO_DATA(8))||',
                      '''||TRIM(V_TMP_TIPO_DATA(9))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(10))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(11))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(12))||''',
                      '||TRIM(V_TMP_TIPO_DATA(13))||',
                      '||TRIM(V_TMP_TIPO_DATA(14))||',
                      '||TRIM(V_TMP_TIPO_DATA(15))||',
                      '||TRIM(V_TMP_TIPO_DATA(16))||',
                      '''||TRIM(V_TMP_TIPO_DATA(17))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(18))||'''
                      FROM DUAL';
                      
          EXECUTE IMMEDIATE V_MSQL;
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE EN LA TABLA: '||V_TABLA||'. ');
          
      
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   

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



   

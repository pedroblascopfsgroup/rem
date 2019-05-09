--/*
--##########################################
--## AUTOR=IVAN SERRANO
--## FECHA_CREACION=20190423
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6238
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en DD_MTO_MOTIVOS_OCULTACION los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MTO_MOTIVOS_OCULTACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_CREAR VARCHAR2(1024 CHAR):= 'HREOS-6238'; --Vble. auxiliar para almacenar el nombre del usuario crear.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(		
		T_TIPO_DATA('16','16', 'Revisión comercial', 'Revisión comercial', '2', '1', V_USU_CREAR, '17'),
		T_TIPO_DATA('17','17', 'Revisión Cliente', 'Revisión Cliente', '2', '1', V_USU_CREAR, '18'),
		T_TIPO_DATA('18','18', 'Revisión Ocupación', 'Revisión Ocupación', '2', '1', V_USU_CREAR, '19'),
		T_TIPO_DATA('19','19', 'AT en curso', 'AT en curso', '2', '1', V_USU_CREAR, '20'),
		T_TIPO_DATA('20','20', 'Incidencia grave', 'Incidencia grave', '2', '1', V_USU_CREAR, '21'),
		T_TIPO_DATA('21','21', 'Ok desocultacion, no publicable', 'Ok desocultacion, no publicable', '2', '1', V_USU_CREAR, '22')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para actualizar los valores en DD_SDE_SUBTIPO_DOC_EXP -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
						'DD_MTO_ID, DD_MTO_CODIGO, DD_MTO_DESCRIPCION, DD_MTO_DESCRIPCION_LARGA, DD_TCO_ID, DD_MTO_MANUAL, 
					USUARIOCREAR, FECHACREAR, DD_MTO_ORDEN) VALUES('''
        			||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||'''
				,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
				,'''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||'''
				,'''||TRIM(V_TMP_TIPO_DATA(6))||''','''||TRIM(V_TMP_TIPO_DATA(7))||'''
				,SYSDATE,'''||TRIM(V_TMP_TIPO_DATA(8))||''')';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO: '''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(3))||'''');
          
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');
    

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line('[ERROR MESSAGE]: '||err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT

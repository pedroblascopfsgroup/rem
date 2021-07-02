--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10039
--## PRODUCTO=NO
--## Finalidad: Rellenar los datos del diccionario DD_MTC_MOTIVO_TECNICO
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	  T_TIPO_DATA('00','Camb.masivo incoher est.comerc','Camb.masivo incoher est.comerc'),
    T_TIPO_DATA('01','Detenida','Detenida'),
	  T_TIPO_DATA('02','Obras en ejecución','Obras en ejecución'),
    T_TIPO_DATA('03','Pdte. de autorizar inversión','Pdte. de autorizar inversión'),
    T_TIPO_DATA('04','Pdte de revisión técnica','Pdte de revisión técnica'),
    T_TIPO_DATA('05','Se advierte ocupación','Se advierte ocupación'),
    T_TIPO_DATA('06','Revisado','Revisado'),
    T_TIPO_DATA('07','Acceso no posible','Acceso no posible'),
    T_TIPO_DATA('08','Sin Actuación Proind o Usufruct','Sin Actuación Proind o Usufruct'),
    T_TIPO_DATA('09','No requiere actuación previa','No requiere actuación previa'),
    T_TIPO_DATA('11','Obras en ejecución','Obras en ejecución'),
    T_TIPO_DATA('12','En proceso de licitación','En proceso de licitación'),
    T_TIPO_DATA('13','En revisión para alquiler','En revisión para alquiler'),
    T_TIPO_DATA('14','Expediente detenido','Expediente detenido'),
    T_TIPO_DATA('15','Sin interés promotor','Sin interés promotor'),
    T_TIPO_DATA('16','Sin actuación posible','Sin actuación posible'),
    T_TIPO_DATA('17','Revisión Básico','Revisión Básico'),
    T_TIPO_DATA('19','Otros','Otros'),
    T_TIPO_DATA('20','En desarrollo para Alquiler','En desarrollo para Alquiler'),
    T_TIPO_DATA('21','Terminado para Alquiler','Terminado para Alquiler'),
    T_TIPO_DATA('22','En Estudio','En Estudio'),
    T_TIPO_DATA('23','En Catalogación','En Catalogación'),
    T_TIPO_DATA('99','-','-')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_MTC_MOTIVO_TECNICO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MTC_MOTIVO_TECNICO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MTC_MOTIVO_TECNICO WHERE DD_MTC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MTC_MOTIVO_TECNICO '||
                    'SET DD_MTC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_MTC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''REMVIP-10039'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MTC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MTC_MOTIVO_TECNICO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MTC_MOTIVO_TECNICO (' ||
                      'DD_MTC_ID, DD_MTC_CODIGO, DD_MTC_DESCRIPCION, DD_MTC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ', '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''REMVIP-10039'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MTC_MOTIVO_TECNICO ACTUALIZADO CORRECTAMENTE ');
   

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

EXIT;

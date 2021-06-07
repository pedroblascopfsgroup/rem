--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20201124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8388
--## PRODUCTO=NO
--## Finalidad: Inserción nuevos registros en la tabla DD_MRO_MOTIVO_RECHAZO_OFERTA.
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
      T_TIPO_DATA('904',   'INCUMPLIMIENTO DEL PLAZO FIRMA DE CONTRATO DE RESERVA',   'INCUMPLIMIENTO DEL PLAZO FIRMA DE CONTRATO DE RESERVA.'),
      T_TIPO_DATA('905',   'POR ORDEN DE LA PROPIEDAD',    'POR ORDEN DE LA PROPIEDAD'),
      T_TIPO_DATA('906',   'DESISTIMIENTO DEL COMPRADOR POR DESINTERÉS',   'DESISTIMIENTO DEL COMPRADOR POR DESINTERÉS'),
      T_TIPO_DATA('907',   'ANULACIÓN TRAS 3 MESES SIN FORMALIZAR O POSICIONAR',    'ANULACIÓN TRAS 3 MESES SIN FORMALIZAR O POSICIONAR'),
      T_TIPO_DATA('908',   'SIN NOTICIAS DE COMPRADOR/PRESCRIPTOR',   'SIN NOTICIAS DE COMPRADOR/PRESCRIPTOR'),
      T_TIPO_DATA('909',   'FINANCIACIÓN RECHAZADA',    'FINANCIACIÓN RECHAZADA'),
      T_TIPO_DATA('910',   'SIN DOCUMENTACIÓN DE PBC',    'SIN DOCUMENTACIÓN DE PBC'),
      T_TIPO_DATA('911',   'PBC RECHAZADO',    'PBC RECHAZADO'),
      T_TIPO_DATA('912',   'EJERCE TANTEO',    'EJERCE TANTEO'),
      T_TIPO_DATA('913',   'VPO DENEGADA',    'VPO DENEGADA'),
      T_TIPO_DATA('914',   'INCIDENCIA JURÍDICA/TÉCNICA',    'INCIDENCIA JURÍDICA/TÉCNICA'),
      T_TIPO_DATA('915',   'ALTA OFERTA ESPEJO',    'ALTA OFERTA ESPEJO')
      
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores en DD_MRO_MOTIVO_RECHAZO_OFERTA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MRO_MOTIVO_RECHAZO_OFERTA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MRO_MOTIVO_RECHAZO_OFERTA WHERE DD_MRO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MRO_MOTIVO_RECHAZO_OFERTA '||
                    'SET DD_MRO_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_MRO_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''REMVIP-8388'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MRO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MRO_MOTIVO_RECHAZO_OFERTA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MRO_MOTIVO_RECHAZO_OFERTA (' ||
                      'DD_MRO_ID, DD_TRO_ID, DD_MRO_CODIGO, DD_MRO_DESCRIPCION, DD_MRO_DESCRIPCION_LARGA, DD_MRO_VENTA, DD_MRO_ALQUILER, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ', 1, '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''',1,0,0, ''REMVIP-8388'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MAN_MOTIVO_ANULACION ACTUALIZADO CORRECTAMENTE ');
   

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
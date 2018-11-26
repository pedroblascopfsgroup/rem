--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180925
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4530
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TCO_OKU_TIPO_ACTUACION los datos añadidos en T_ARRAY_DATA
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
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(10000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--          DD_TCO_CODIGO	DD_TCO_DESCRIPCION	DD_TCO_DESCRIPCION_LARGA
    	T_TIPO_DATA('01',	'División Cosa Común',			'División Cosa Común'),
	T_TIPO_DATA('02',	'Impago de Rentas',		'Impago de Rentas'),
	T_TIPO_DATA('03',	'Nulidad de Contrato',		'Nulidad de Contrato'),
	T_TIPO_DATA('04',	'Ocupación de Precario',	'Ocupación de Precario'),
	T_TIPO_DATA('05',	'Querella',			'Querella'),
	T_TIPO_DATA('06',	'Reclamación Cantidad',		'Reclamación Cantidad'),
	T_TIPO_DATA('07',	'Retracto',			'Retracto'),
	T_TIPO_DATA('08',	'Usucapión',			'Usucapión'),
	T_TIPO_DATA('09',	'Vencimiento Contrato',		'Vencimiento Contrato')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TCO_OKU_TIPO_ACTUACION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TCO_OKU_TIPO_ACTUACION] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TCO_OKU_TIPO_ACTUACION WHERE DD_TCO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe no hacemos nada
        IF V_NUM_TABLAS > 0 THEN				
        	
	  DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO YA EXISTE');
          
       --Si no existe, lo insertamos   
        ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          
          -- Comprobar secuencias de la tabla.
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TCO_OKU_TIPO_ACTUACION.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
			V_SQL := 'SELECT NVL(MAX(DD_TCO_ID), 0) FROM '||V_ESQUEMA||'.DD_TCO_OKU_TIPO_ACTUACION';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TCO_OKU_TIPO_ACTUACION.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			END LOOP;
          
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TCO_OKU_TIPO_ACTUACION.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TCO_OKU_TIPO_ACTUACION (' ||
                      'DD_TCO_ID, DD_TCO_CODIGO, DD_TCO_DESCRIPCION, DD_TCO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '||V_ID||','''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||''','''||V_TMP_TIPO_DATA(3)||''',0,''HREOS-4530'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TCO_OKU_TIPO_ACTUACION ACTUALIZADO CORRECTAMENTE ');
   

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

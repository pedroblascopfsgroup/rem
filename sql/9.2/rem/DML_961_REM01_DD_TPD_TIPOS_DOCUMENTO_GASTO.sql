--/*
--##########################################
--## AUTOR=	JOSE VILLEL
--## FECHA_CREACION=20170110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade/modifica en DD_TPD_TIPOS_DOCUMENTO_GASTO los datos añadidos en T_ARRAY_DATA
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

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('01','Catastro: factura','Catastro: factura', 'AI-15-FACT-02'),
    	T_TIPO_DATA('02','Acta Junta Extraordinaria','Acta Junta Extraordinaria', 'AI-15-ACTR-07'),
    	T_TIPO_DATA('03','Notario: factura','Notario: factura', 'AI-15-FACT-09'),
    	T_TIPO_DATA('04','Otro gasto','Otro gasto', 'AI-15-FACT-10'),
    	T_TIPO_DATA('05','Impuesto sobre bienes inmuebles (IBI): justificante abono','Impuesto sobre bienes inmuebles (IBI): justificante abono', 'AI-15-CERA-12'),
    	T_TIPO_DATA('06','Registro Propiedad: factura','Registro Propiedad: factura', 'AI-15-FACT-13'),
    	T_TIPO_DATA('07','Impuesto sobre bienes inmuebles (IBI): recibo','Impuesto sobre bienes inmuebles (IBI): recibo', 'AI-15-CERA-16'),
    	T_TIPO_DATA('08','Impuesto sobre construcciones, instalaciones y obras (ICIO)','Impuesto sobre construcciones, instalaciones y obras (ICIO)', 'AI-15-CERA-17'),
    	T_TIPO_DATA('09','Otro impuesto / tasa / contribución','Otro impuesto / tasa / contribución', 'AI-15-CERA-22'),
    	T_TIPO_DATA('10','Suministro de agua','Suministro de agua', 'AI-15-CERT-23'),
    	T_TIPO_DATA('11','Suministro de luz','Suministro de luz', 'AI-15-CERT-24'),
    	T_TIPO_DATA('12','Impuesto sobre bienes inmuebles (IBI): certificado','Impuesto sobre bienes inmuebles (IBI): certificado', 'AI-15-CERJ-25'),
    	T_TIPO_DATA('13','Impuesto sobre bienes inmuebles (IBI): comunicaciones','Impuesto sobre bienes inmuebles (IBI): comunicaciones', 'AI-15-COMU-45'),
    	T_TIPO_DATA('14','Impuesto sobre bienes inmuebles (basura): recibo','Impuesto sobre bienes inmuebles (basura): recibo', 'AI-15-CERA-51'),
    	T_TIPO_DATA('15','Impuesto sobre bienes inmuebles (basura): justificante abono','Impuesto sobre bienes inmuebles (basura): justificante abono', 'AI-15-CERA-52'),
    	T_TIPO_DATA('16','Impuesto sobre bienes inmuebles (VADO): recibo','Impuesto sobre bienes inmuebles (VADO): recibo', 'AI-15-CERA-53'),
    	T_TIPO_DATA('17','Impuesto sobre bienes inmuebles (VADO): justificante abono','Impuesto sobre bienes inmuebles (VADO): justificante abono', 'AI-15-CERA-54'),
    	T_TIPO_DATA('18','Impuesto sobre bienes inmuebles (OTRAS TASAS): recibo','Impuesto sobre bienes inmuebles (OTRAS TASAS): recibo', 'AI-15-CERA-55'),
    	T_TIPO_DATA('19','Impuesto sobre bienes inmuebles (OTRAS TASAS): justificante abono','Impuesto sobre bienes inmuebles (OTRAS TASAS): justificante abono', 'AI-15-CERA-56'),
    	T_TIPO_DATA('20','Impuesto sobre bienes inmuebles (alcantarillado): recibo','Impuesto sobre bienes inmuebles (alcantarillado): recibo', 'AI-15-CERA-65'),
    	T_TIPO_DATA('21','Impuesto sobre bienes inmuebles (alcantarillado): justificante abono','Impuesto sobre bienes inmuebles (alcantarillado): justificante abono', 'AI-15-CERA-66'),
    	T_TIPO_DATA('22','Impuesto sobre Actividades Económicas (IAE): justificante abono','Impuesto sobre Actividades Económicas (IAE): justificante abono', 'AI-15-CERA-67'),
    	T_TIPO_DATA('23','Tasa de suministro agua potable : recibo','Tasa de suministro agua potable : recibo', 'AI-15-CERA-68'),
    	T_TIPO_DATA('24','Multa Coercitiva','Multa Coercitiva', 'AI-15-CERA-70'),
    	T_TIPO_DATA('25','Contribución especial','Contribución especial', 'AI-15-CERA-07')    	
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TPD_TIPOS_DOCUMENTO_GASTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPD_TIPOS_DOCUMENTO_GASTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPD_TIPOS_DOCUMENTO_GASTO WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO '||
                    'SET DD_TPD_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TPD_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TPD_TP_DTO_GASTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO (' ||
                      'DD_TPD_ID, DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA, DD_TPD_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''',0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TPD_TIPOS_DOCUMENTO_GASTO ACTUALIZADO CORRECTAMENTE ');
   

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



   
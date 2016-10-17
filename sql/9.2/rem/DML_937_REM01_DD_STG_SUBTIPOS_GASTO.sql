--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20161011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_STG_SUBTIPOS_GASTO los subtipos de trabajos de Precios
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
      -- TIPO TRABAJO(DD_TGA_CODIGO),   SUBTIPO(DD_STG_CODIGO),  DESCRIPCION,  DESCRIPCION LARGA
		T_TIPO_DATA('01','01','IBI urbana','IBI urbana'),
		T_TIPO_DATA('01','02','IBI rústica','IBI rústica'),
		T_TIPO_DATA('01','03','Plusvalía (IIVTNU) compra','Plusvalía (IIVTNU) compra'),
		T_TIPO_DATA('01','04','Plusvalía (IIVTNU) venta','Plusvalía (IIVTNU) venta'),
		T_TIPO_DATA('01','05','IAAEE','IAAEE'),
		T_TIPO_DATA('01','06','ICIO','ICIO'),
		T_TIPO_DATA('01','07','ITPAJD','ITPAJD'),										
		T_TIPO_DATA('02','08','Basura','Basura'),
		T_TIPO_DATA('02','09','Alcantarillado','Alcantarillado'),
		T_TIPO_DATA('02','10','Agua','Agua'),
		T_TIPO_DATA('02','11','Vado','Vado'),
		T_TIPO_DATA('02','12','Ecotasa','Ecotasa'),
		T_TIPO_DATA('02','13','Regularización catastral','Regularización catastral'),
		T_TIPO_DATA('02','14','Expedición documentos','Expedición documentos'),
		T_TIPO_DATA('02','15','Obras / Rehabilitación / Mantenimiento','Obras / Rehabilitación / Mantenimiento'),
		T_TIPO_DATA('02','16','Judicial','Judicial'),
		T_TIPO_DATA('02','17','Otras tasas ayuntamiento','Otras tasas ayuntamiento'),
		T_TIPO_DATA('02','18','Otras tasas','Otras tasas'),										
		T_TIPO_DATA('03','19','Contribución especial','Contribución especial'),
		T_TIPO_DATA('03','20','Otros','Otros'),										
		T_TIPO_DATA('04','21','Urbanística','Urbanística'),
		T_TIPO_DATA('04','22','Tributaria','Tributaria'),
		T_TIPO_DATA('04','23','Ruina','Ruina'),
		T_TIPO_DATA('04','24','Multa coercitiva','Multa coercitiva'),
		T_TIPO_DATA('04','25','Otros','Otros'),										
		T_TIPO_DATA('05','26','Cuota ordinaria','Cuota ordinaria'),
		T_TIPO_DATA('05','27','Cuota extraordinaria (derrama)','Cuota extraordinaria (derrama)'),										
		T_TIPO_DATA('06','28','Cuota ordinaria','Cuota ordinaria'),
		T_TIPO_DATA('06','29','Cuota extraordinaria (derrama)','Cuota extraordinaria (derrama)'),										
		T_TIPO_DATA('07','30','Gastos generales','Gastos generales'),
		T_TIPO_DATA('07','31','Cuotas y derramas','Cuotas y derramas'),										
		T_TIPO_DATA('08','32','Gastos generales','Gastos generales'),
		T_TIPO_DATA('08','33','Cuotas y derramas','Cuotas y derramas'),
		T_TIPO_DATA('08','34','Otros','Otros'),										
		T_TIPO_DATA('09','35','Electricidad','Electricidad'),
		T_TIPO_DATA('09','36','Agua','Agua'),
		T_TIPO_DATA('09','37','Gas','Gas'),
		T_TIPO_DATA('09','38','Otros','Otros'),										
		T_TIPO_DATA('10','39','Prima TRDM (todo riesgo daño material)','Prima TRDM (todo riesgo daño material)'),
		T_TIPO_DATA('10','40','Prima RC (responsabilidad civil)','Prima RC (responsabilidad civil)'),
		T_TIPO_DATA('10','41','Parte daños propios','Parte daños propios'),
		T_TIPO_DATA('10','42','Parte daños a terceros','Parte daños a terceros'),										
		T_TIPO_DATA('11','43','Registro','Registro'),
		T_TIPO_DATA('11','44','Notaría','Notaría'),
		T_TIPO_DATA('11','45','Abogado','Abogado'),
		T_TIPO_DATA('11','46','Procurador','Procurador'),
		T_TIPO_DATA('11','47','Otros servicios jurídicos','Otros servicios jurídicos'),
		T_TIPO_DATA('11','48','Administrador Comunidad Propietarios','Administrador Comunidad Propietarios'),
		T_TIPO_DATA('11','49','Asesoría','Asesoría'),
		T_TIPO_DATA('11','50','Técnico','Técnico'),
		T_TIPO_DATA('11','51','Tasación','Tasación'),
		T_TIPO_DATA('11','52','Otros','Otros'),										
		T_TIPO_DATA('12','53','Honorarios gestión activos','Honorarios gestión activos'),
		T_TIPO_DATA('12','54','Honorarios gestión ventas','Honorarios gestión ventas'),										
		T_TIPO_DATA('13','55','Mediador','Mediador'),
		T_TIPO_DATA('13','56','Fuerza de Venta Directa','Fuerza de Venta Directa'),										
		T_TIPO_DATA('14','57','Informes','Informes'),
		T_TIPO_DATA('14','58','Certif. eficiencia energética (CEE)','Certif. eficiencia energética (CEE)'),
		T_TIPO_DATA('14','59','Licencia Primera Ocupación (LPO)','Licencia Primera Ocupación (LPO)'),
		T_TIPO_DATA('14','60','Cédula Habitabilidad','Cédula Habitabilidad'),
		T_TIPO_DATA('14','61','Certificado Final de Obra (CFO)','Certificado Final de Obra (CFO)'),
		T_TIPO_DATA('14','62','Boletín instalaciones y suministros','Boletín instalaciones y suministros'),
		T_TIPO_DATA('14','63','Obtención certificados y documentación','Obtención certificados y documentación'),
		T_TIPO_DATA('14','64','Nota simple actualizada','Nota simple actualizada'),
		T_TIPO_DATA('14','65','VPO: Solicitud devolución ayudas','VPO: Solicitud devolución ayudas'),
		T_TIPO_DATA('14','66','VPO: Notificación adjudicación (tanteo)','VPO: Notificación adjudicación (tanteo)'),
		T_TIPO_DATA('14','67','VPO: Autorización de venta','VPO: Autorización de venta'),
		T_TIPO_DATA('14','68','Inspección técnica de edificios','Inspección técnica de edificios'),
		T_TIPO_DATA('14','69','Informe topográfico','Informe topográfico'),										
		T_TIPO_DATA('15','70','Cambio de cerradura','Cambio de cerradura'),
		T_TIPO_DATA('15','71','Tapiado','Tapiado'),
		T_TIPO_DATA('15','72','Retirada de enseres','Retirada de enseres'),
		T_TIPO_DATA('15','73','Limpieza','Limpieza'),
		T_TIPO_DATA('15','74','Limpieza y retirada de enseres','Limpieza y retirada de enseres'),
		T_TIPO_DATA('15','75','Limpieza, retirada de enseres y descerraje','Limpieza, retirada de enseres y descerraje'),
		T_TIPO_DATA('15','76','Limpieza, desinfección… (solares)','Limpieza, desinfección… (solares)'),
		T_TIPO_DATA('15','77','Seguridad y Salud (SS)','Seguridad y Salud (SS)'),
		T_TIPO_DATA('15','78','Verificación de averías','Verificación de averías'),
		T_TIPO_DATA('15','79','Obra menor','Obra menor'),
		T_TIPO_DATA('15','80','Obra mayor. Edificación (certif. de obra)','Obra mayor. Edificación (certif. de obra)'),
		T_TIPO_DATA('15','81','Control de actuaciones (dirección técnica)','Control de actuaciones (dirección técnica)'),
		T_TIPO_DATA('15','82','Colocación puerta antiocupa','Colocación puerta antiocupa'),
		T_TIPO_DATA('15','83','Mobiliario','Mobiliario'),
		T_TIPO_DATA('15','84','Actuación post-venta','Actuación post-venta'),										
		T_TIPO_DATA('16','85','Vigilancia y seguridad','Vigilancia y seguridad'),
		T_TIPO_DATA('16','86','Alarmas','Alarmas'),
		T_TIPO_DATA('16','87','Servicios auxiliares','Servicios auxiliares'),										
		T_TIPO_DATA('17','88','Publicidad','Publicidad'),										
		T_TIPO_DATA('18','89','Mensajería/correos/copias','Mensajería/correos/copias'),
		T_TIPO_DATA('18','90','Costas judiciales','Costas judiciales'),
		T_TIPO_DATA('18','91','Otros','Otros')       
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_STG_SUBTIPOS_GASTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_STG_SUBTIPOS_GASTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTGO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO '||
                    'SET DD_STG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
					', DD_STG_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''REM_F2'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTGO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTGO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_STG_SUBTIPOS_GASTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO (' ||
                      'DD_STG_ID, DD_TGA_ID, DD_STG_CODIGO, DD_STG_DESCRIPCION, DD_STG_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                      '('|| V_ID || ',
                      (SELECT DD_TGA_ID FROM '||V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                      '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                       0, ''REM_F2'',SYSDATE,0 )';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_STG_SUBTIPOS_GASTO ACTUALIZADO CORRECTAMENTE ');
   

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

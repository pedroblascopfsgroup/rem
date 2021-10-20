--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_EQV_TIT_CAIXA_REM los datos añadidos en T_ARRAY_DATA para todos los diccionarios
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-15423';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- DD_NOMBRE_CAIXA DD_CODIGO_CAIXA  DD_DESCRIPCION_CAIXA  DD_DESCRIPCION_LARGA_CAIXA  DD_NOMBRE_REM  DD_CODIGO_REM
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      --Sociedad (Propietario)
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84966126','Bancaja 10, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85164648','Bancaja 11, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85587434','Bancaja 13, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84322205','Bancaja 8, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84593961','Bancaja 9, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84669332','MBS Bancaja 3, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85082675','MBS Bancaja 4, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3149', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85623668','MBS Bancaja 6, FTA'),

        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84856319','Caixa Penedés 1, TdA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85500866','Caixa Penedes FTGENCAT 1 TDA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85143659','Caixa Penedes Pymes 1 TDA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85594927','MADRID RESIDENCIAL I, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85981231','MADRID RESIDENCIAL II, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84889229','MADRID RMBS I'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84916956','MADRID RMBS II'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85160935','MADRID RMBS III'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85295087','MADRID RMBS IV'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84175744','TdA 22 Mixto, FTA'),
        T_TIPO_DATA('SOCIEDAD_PATRIMONIAL','3143', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84925569','TdA 27, FTA'),
      --Sociedad (Propietario)
        T_TIPO_DATA('FONDO','V84966126', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84966126','Bancaja 10, FTA'),
        T_TIPO_DATA('FONDO','V85164648', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85164648','Bancaja 11, FTA'),
        T_TIPO_DATA('FONDO','V85587434', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85587434','Bancaja 13, FTA'),
        T_TIPO_DATA('FONDO','V84322205', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84322205','Bancaja 8, FTA'),
        T_TIPO_DATA('FONDO','V84593961', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84593961','Bancaja 9, FTA'),
        T_TIPO_DATA('FONDO','V84669332', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V84669332','MBS Bancaja 3, FTA'),
        T_TIPO_DATA('FONDO','V85082675', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85082675','MBS Bancaja 4, FTA'),
        T_TIPO_DATA('FONDO','V85623668', 'EDT - europea de titulización','ACT_PRO_PROPIETARIO','V85623668','MBS Bancaja 6, FTA'),

        T_TIPO_DATA('FONDO','V84856319', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84856319','Caixa Penedés 1, TdA'),
        T_TIPO_DATA('FONDO','V85500866', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85500866','Caixa Penedes FTGENCAT 1 TDA'),
        T_TIPO_DATA('FONDO','V85143659', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85143659','Caixa Penedes Pymes 1 TDA'),
        T_TIPO_DATA('FONDO','V85594927', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85594927','MADRID RESIDENCIAL I, FTA'),
        T_TIPO_DATA('FONDO','V85981231', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85981231','MADRID RESIDENCIAL II, FTA'),
        T_TIPO_DATA('FONDO','V84889229', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84889229','MADRID RMBS I'),
        T_TIPO_DATA('FONDO','V84916956', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84916956','MADRID RMBS II'),
        T_TIPO_DATA('FONDO','V85160935', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85160935','MADRID RMBS III'),
        T_TIPO_DATA('FONDO','V85295087', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V85295087','MADRID RMBS IV'),
        T_TIPO_DATA('FONDO','V84175744', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84175744','TdA 22 Mixto, FTA'),
        T_TIPO_DATA('FONDO','V84925569', 'TDA - titulización de activos','ACT_PRO_PROPIETARIO','V84925569','TdA 27, FTA'),
        --Función clase de uso Clase de uso
        T_TIPO_DATA('CLASE_USO','0001','Casa aislada','DD_SAC_SUBTIPO_ACTIVO','05','Unifamiliar aislada'),
        T_TIPO_DATA('CLASE_USO','0001','Casa adosada','DD_SAC_SUBTIPO_ACTIVO','06','Unifamiliar adosada'),
        T_TIPO_DATA('CLASE_USO','0001','Casa pareada','DD_SAC_SUBTIPO_ACTIVO','07','Unifamiliar pareada'),
        T_TIPO_DATA('CLASE_USO','0001','Piso Admisión','DD_SAC_SUBTIPO_ACTIVO','09','Piso'),
        T_TIPO_DATA('CLASE_USO','0001','Estudio	Admisión','DD_SAC_SUBTIPO_ACTIVO','12','Estudio/Loft'),
        T_TIPO_DATA('CLASE_USO','0001','Dúplex','DD_SAC_SUBTIPO_ACTIVO','10','Piso dúplex'),
        --T_TIPO_DATA('CLASE_USO','0001','Triplex	Admisión','DD_SAC_SUBTIPO_ACTIVO','10','Piso dúplex'),
        --T_TIPO_DATA('CLASE_USO','0001','Apartamento	Admisión','DD_SAC_SUBTIPO_ACTIVO','09','Piso'),
        --T_TIPO_DATA('CLASE_USO','0001','Loft Admisión','DD_SAC_SUBTIPO_ACTIVO','12','Estudio/Loft'),
        T_TIPO_DATA('CLASE_USO','0001','Ático	Admisión','DD_SAC_SUBTIPO_ACTIVO','11','Ático'),
        --T_TIPO_DATA('CLASE_USO','0001','Planta Baja	Admisión','DD_SAC_SUBTIPO_ACTIVO','09','Piso'),
        --T_TIPO_DATA('CLASE_USO','0001','Villa	Admisión','DD_SAC_SUBTIPO_ACTIVO','05','Unifamiliar aislada'),
        --T_TIPO_DATA('CLASE_USO','0001','Comercial	Admisión','DD_SAC_SUBTIPO_ACTIVO','13','Local comercial'),
        T_TIPO_DATA('CLASE_USO','0001','Almacén	Admisión','DD_SAC_SUBTIPO_ACTIVO','15','Almacén'),
        T_TIPO_DATA('CLASE_USO','0001','Entremedianeras	Admisión','DD_SAC_SUBTIPO_ACTIVO','28','Parque Medianas'),
        T_TIPO_DATA('CLASE_USO','0001','Unifamiliar casa de pueblo','DD_SAC_SUBTIPO_ACTIVO','08','Unifamiliar casa de pueblo'),
        T_TIPO_DATA('CLASE_USO','0001','Apartamento','DD_SAC_SUBTIPO_ACTIVO','40','Apartamento'),
        T_TIPO_DATA('CLASE_USO','0008','Resto de suelo urbanizable','DD_SAC_SUBTIPO_ACTIVO','02','Urbanizable no programado'),
        T_TIPO_DATA('CLASE_USO','0008','Suelo urbanizable organizado y Suelo urbanizable sectorizado','DD_SAC_SUBTIPO_ACTIVO','03','Urbanizable programado'),
        T_TIPO_DATA('CLASE_USO','0007','Suelo urbano no consolidado','DD_SAC_SUBTIPO_ACTIVO','42','Suelo Urbano No Consolidado'),
        T_TIPO_DATA('CLASE_USO','0007','Suelo urbano consolidado','DD_SAC_SUBTIPO_ACTIVO','04','Nave aislada'),
        T_TIPO_DATA('CLASE_USO','0006','Oficina','DD_SAC_SUBTIPO_ACTIVO','14','Oficina'),
        T_TIPO_DATA('CLASE_USO','0019','Hotel','DD_SAC_SUBTIPO_ACTIVO','20','Hotel/Apartamentos turísticos'),
        T_TIPO_DATA('CLASE_USO','0019','Hotel','DD_SAC_SUBTIPO_ACTIVO','41','Hostelero'),
        T_TIPO_DATA('CLASE_USO','0015','Edificio aparcamientos','DD_SAC_SUBTIPO_ACTIVO','19','Aparcamiento'),
        T_TIPO_DATA('CLASE_USO','0011','Edificio comercial','DD_SAC_SUBTIPO_ACTIVO','22','Comercial'),
        --T_TIPO_DATA('CLASE_USO','0014','Edificio residencial','DD_SAC_SUBTIPO_ACTIVO','43','Residencial (viviendas, locales, trasteros garajes)'),
        T_TIPO_DATA('CLASE_USO','0005','Parking','DD_SAC_SUBTIPO_ACTIVO','24','Garaje'),
        T_TIPO_DATA('CLASE_USO','0099','Varios','DD_SAC_SUBTIPO_ACTIVO','26','Otros'),
        T_TIPO_DATA('CLASE_USO','0004','Trastero','DD_SAC_SUBTIPO_ACTIVO','25','Trastero'),
        T_TIPO_DATA('CLASE_USO','0024','Instalaciones deportivas','DD_SAC_SUBTIPO_ACTIVO','30','Dotacional Deportivo'),
        T_TIPO_DATA('CLASE_USO','0023','Derechos','DD_SAC_SUBTIPO_ACTIVO','33','Otros Derechos'),
        T_TIPO_DATA('CLASE_USO','0002','Local','DD_SAC_SUBTIPO_ACTIVO','13','Local comercial'),
        T_TIPO_DATA('CLASE_USO','0003','Local comercial y vivienda','DD_SAC_SUBTIPO_ACTIVO','43','Residencial (viviendas, locales, trasteros garajes)'),
        T_TIPO_DATA('CLASE_USO','0009','Suelo no urbanizable','DD_SAC_SUBTIPO_ACTIVO','01','No urbanizable (rústico)'),
        --T_TIPO_DATA('CLASE_USO','0010','Edificio','DD_SAC_SUBTIPO_ACTIVO','43','Residencial (viviendas, locales, trasteros garajes)'),
        --T_TIPO_DATA('CLASE_USO','0012','Edificio mixto','DD_SAC_SUBTIPO_ACTIVO','43','Residencial (viviendas, locales, trasteros garajes)'),
        --T_TIPO_DATA('CLASE_USO','0013','Edificio terciario','DD_SAC_SUBTIPO_ACTIVO','22','Comercial'),
        T_TIPO_DATA('CLASE_USO','0016','Edificio educativo','DD_SAC_SUBTIPO_ACTIVO','38','Residencia Estudiantes'),
        T_TIPO_DATA('CLASE_USO','0017','Edificio industrial','DD_SAC_SUBTIPO_ACTIVO','37','Nave en varias plantas'),
        T_TIPO_DATA('CLASE_USO','0017','Edificio industrial','DD_SAC_SUBTIPO_ACTIVO','17','Nave aislada'),
        T_TIPO_DATA('CLASE_USO','0017','Edificio industrial','DD_SAC_SUBTIPO_ACTIVO','18','Nave adosada'),
        T_TIPO_DATA('CLASE_USO','0018','Finca rústica','DD_SAC_SUBTIPO_ACTIVO','01','No urbanizable (rústico)'),
        --T_TIPO_DATA('CLASE_USO','0020','Portería','DD_SAC_SUBTIPO_ACTIVO','26','Otros'),
        --T_TIPO_DATA('CLASE_USO','0021','Amarres','DD_SAC_SUBTIPO_ACTIVO','26','Otros'),
      --Tipo Suelo   
        T_TIPO_DATA('SUBTIPO_SUELO','U17','Resto de suelo urbanizable','DD_SAC_SUBTIPO_ACTIVO','02','Urbanizable no programado'),
        T_TIPO_DATA('SUBTIPO_SUELO','U15','Suelo urbanizable organizado','DD_SAC_SUBTIPO_ACTIVO','03','Urbanizable programado'),
        T_TIPO_DATA('SUBTIPO_SUELO','U14','Suelo urbano no consolidado','DD_SAC_SUBTIPO_ACTIVO','42','Suelo Urbano No Consolidado'),
        T_TIPO_DATA('SUBTIPO_SUELO','U13','Suelo urbano consolidado','DD_SAC_SUBTIPO_ACTIVO','04','Urbano (solar)'),
        --T_TIPO_DATA('SUBTIPO_SUELO','U16','Suelo urbanizable sectorizado','DD_SAC_SUBTIPO_ACTIVO','03','Urbanizable programado')
        --Tipo Vivienda   
        T_TIPO_DATA('SUBTIPO_VIVIENDA','1','Vivienda Unifamiliar Aislada','DD_SAC_SUBTIPO_ACTIVO','05','Unifamiliar aislada'),
        T_TIPO_DATA('SUBTIPO_VIVIENDA','2','Vivienda Unifamiliar Adosada','DD_SAC_SUBTIPO_ACTIVO','06','Unifamiliar adosada'),
        T_TIPO_DATA('SUBTIPO_VIVIENDA','3','Vivienda en bloque','DD_SAC_SUBTIPO_ACTIVO','07','Unifamiliar pareada')
        --T_TIPO_DATA('SUBTIPO_VIVIENDA','0','En el caso de no aplicar al tratarse de un bien inmueble no vivienda','DD_SAC_SUBTIPO_ACTIVO', NULL,'No puede ser no inmueble')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EQV_TIT_CAIXA_REM ');

  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_EQV_TIT_CAIXA_REM'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN				
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_EQV_TIT_CAIXA_REM... Se trunca la tabla y se vuelve a insertar.');
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.DD_EQV_TIT_CAIXA_REM';

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''||TRIM(V_TMP_TIPO_DATA(2))||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM 
                      (' ||'
                            DD_NOMBRE_CAIXA
                          , DD_CODIGO_CAIXA
                          , DD_DESCRIPCION_CAIXA
                          , DD_DESCRIPCION_LARGA_CAIXA
                          , DD_NOMBRE_REM
                          , DD_CODIGO_REM
                          ,	DD_DESCRIPCION_REM
		                      , DD_DESCRIPCION_LARGA_REM
                          , VERSION
                          , USUARIOCREAR
                          , FECHACREAR
                          , BORRADO) ' ||
                      'SELECT 
                          '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(4))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(5))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(6))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(6))||'''
                          , 0
                          , '''||TRIM(V_ITEM)||'''
                          , SYSDATE
                          , 0
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');      

      END LOOP;
    COMMIT;
  END IF;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EQV_TIT_CAIXA_REM MODIFICADO CORRECTAMENTE ');
   

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

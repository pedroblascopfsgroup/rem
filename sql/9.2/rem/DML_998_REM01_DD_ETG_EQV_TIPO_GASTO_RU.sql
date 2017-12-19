--/*
--##########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20171123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3310
--## PRODUCTO=NO
--##
--## Finalidad: Script que carga la tabla DD_ETG_EQV_TIPO_GASTO_RU
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial DAP
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
  V_TABLA VARCHAR2(50 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU';
  V_DD_TGA_ID NUMBER(16);
  V_DD_STG_ID NUMBER(16);
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(500);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('Impuesto','IBI urbana','01','IBIS',2,1,1,'DEVOLUCIÓN IBIS',2,1,51),
    T_TIPO_DATA('Impuesto','IBI rústica','02','IBI RÚSTICO',2,1,9,'DEVOLUCIÓN IBI RÚSTICO',2,1,59),
    T_TIPO_DATA('Impuesto','Plusvalía (IIVTNU) venta','03','PLUSVALÍA',1,1,0,'DEVOLUCIÓN PLUSVALÍA',1,1,50),
    T_TIPO_DATA('Impuesto','ICIO','04','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Tasa','Basura','05','TASAS BASURA',2,1,2,'DEVOLUCIÓN TASAS BASURA',2,1,52),
    T_TIPO_DATA('Tasa','Alcantarillado','06','TASAS ALCANTARILLADO',2,1,3,'DEVOLUCIÓN TASAS ALCANTARILLADO',2,1,53),
    T_TIPO_DATA('Tasa','Agua','07','TASAS AGUA',2,1,4,'DEVOLUCIÓN TASAS AGUA',2,1,54),
    T_TIPO_DATA('Tasa','Vado','08','VADOS',2,1,7,'DEVOLUCIÓN VADOS',2,1,57),
    T_TIPO_DATA('Tasa','Ecotasa','09','ECOTASA',2,1,8,'DEVOLUCIÓN ECOTASA',2,1,58),
    T_TIPO_DATA('Tasa','Regularización catastral','10','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Tasa','Expedición documentos','11','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Tasa','Obras / Rehabilitación / Mantenimiento','12','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Tasa','Judicial','13','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Tasa','Otras tasas ayuntamiento','14','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Tasa','Otras tasas','15','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Otros tributos','Contribución especial','16','CONTRIBUCIONES ESPECIALES',2,1,5,'DEVOLUCIÓN CONTRIBUCIONES ESPECIALES',2,1,55),
    T_TIPO_DATA('Otros tributos','Otros','17','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Sanción','Urbanística','18','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Sanción','Tributaria','19','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Sanción','Ruina','20','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Sanción','Multa coercitiva','21','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Sanción','Otros','22','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Comunidad de propietarios','Cuota ordinaria','23','COMUNIDAD ORDINARIA',2,2,1,'DEVOLUCIÓN COMUNIDAD ORDINARIA',2,2,51),
    T_TIPO_DATA('Comunidad de propietarios','Cuota extraordinaria (derrama)','24','EXTRAS COMUNIDAD',2,2,2,'DEVOLUCIÓN EXTRAS COMUNIDAD',2,2,52),
    T_TIPO_DATA('Comunidad de propietarios','Certificado deuda comunidad','25','COMUNIDAD ORDINARIA',2,2,1,'',null,null,null),
    T_TIPO_DATA('Complejo inmobiliario','Cuota ordinaria','26','MANCOMUNIDAD',2,2,3,'DEVOLUCIÓN MANCOMUNIDAD',2,2,53),
    T_TIPO_DATA('Complejo inmobiliario','Cuota extraordinaria (derrama)','27','EXTRAS MANCOMUNIDAD',2,2,4,'DEVOLUCIÓN EXTRAS MANCOMUNIDAD',2,2,54),
    T_TIPO_DATA('Junta de compensación / EUC','Gastos generales','28','EJEC. PROPIEDAD: OBRAS Y MANTENIM.',3,44,2,'',null,null,null),
    T_TIPO_DATA('Junta de compensación / EUC','Gastos generales','29','COMUNIDADES EUC',3,44,5,'',null,null,null),
    T_TIPO_DATA('Junta de compensación / EUC','Cuotas y derramas','30','EJEC. PROPIEDAD: OBRAS Y MANTENIM.',3,44,2,'',null,null,null),
    T_TIPO_DATA('Junta de compensación / EUC','Cuotas y derramas','31','COMUNIDADES EUC',3,44,5,'',null,null,null),
    T_TIPO_DATA('Otras entidades en que se integra el activo','Gastos generales','32','COMUNIDAD ORDINARIA',2,2,1,'DEVOLUCIÓN COMUNIDAD ORDINARIA',2,2,51),
    T_TIPO_DATA('Otras entidades en que se integra el activo','Cuotas y derramas','33','EXTRAS COMUNIDAD',2,2,2,'DEVOLUCIÓN EXTRAS COMUNIDAD',2,2,52),
    T_TIPO_DATA('Otras entidades en que se integra el activo','Otros','34','OTROS',2,2,20,'DEVOLUCIÓN COMUNIDADES',2,2,50),
    T_TIPO_DATA('Suministro','Electricidad','35','SUMINISTROS LUZ',2,3,1,'DEVOLUCIÓN SUMINISTROS LUZ',2,3,51),
    T_TIPO_DATA('Suministro','Agua','36','SUMINISTROS AGUA',2,3,2,'DEVOLUCIÓN SUMINISTROS AGUA',2,3,52),
    T_TIPO_DATA('Suministro','Gas','37','SUMINISTROS GAS',2,3,3,'DEVOLUCIÓN SUMINISTROS GAS',2,3,53),
    T_TIPO_DATA('Suministro','Otros','38','OTROS SUMINISTROS',2,3,0,'DEVOLUCIÓN OTROS SUMINISTROS',2,3,50),
    T_TIPO_DATA('Seguros','Prima TRDM (todo riesgo daño material)','39','SEGUROS INMUEBLES',3,42,6,'',null,null,null),
    T_TIPO_DATA('Seguros','Prima RC (responsabilidad civil)','40','SEGUROS INMUEBLES',3,42,6,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Registro','41','GASTOS REGISTRALES',3,49,3,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Notaría','42','GASTOS REGISTRALES',3,49,3,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Abogado (Ocupacional)','43','GASTOS ABOGADO',3,21,10,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Abogado (Asuntos generales)','44','GASTOS ABOGADO',3,21,10,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Abogado (Asistencia jurídica)','45','GASTOS ABOGADO',3,21,10,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Procurador','46','GASTOS PROCURADOR',3,21,12,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Otros servicios jurídicos','47','GASTOS ABOGADO',3,21,10,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Técnico','48','GASTOS ARQUITECTO Y APAREJADOR',3,45,3,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Tasación','49','ORDINARIA - ASESOR. COMERCIAL',3,22,1,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Gestión de suelo','50','GESTORAS DE SUELO',3,44,3,'',null,null,null),
    T_TIPO_DATA('Gestoría','Honorarios gestión activos','51','HONORARIOS GESTORÍA',3,49,4,'',null,null,null),
    T_TIPO_DATA('Gestoría','Honorarios gestión ventas','52','FIRMA CON ASISTENCIA',3,35,2,'',null,null,null),
    T_TIPO_DATA('Comisiones','Mediador','53','HONORARIOS',3,2,0,'',null,null,null),
    T_TIPO_DATA('Comisiones','Fuerza de Venta Directa','54','HONORARIOS',3,2,0,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Informes','55','INF. TÉCNICOS DE OBRAS',3,45,2,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','56','OBTENCIÓN DE C.E.E.',3,45,5,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Licencia Primera Ocupación (LPO)','57','INF. TÉCNICOS DE OBRAS',3,45,2,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Cédula Habitabilidad','58','CÉDULAS HABITABILIDAD',3,42,8,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Certificado Final de Obra (CFO)','59','INF. TÉCNICOS DE OBRAS',3,45,2,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Boletín instalaciones y suministros','60','INF. TÉCNICOS DE OBRAS',3,45,2,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Obtención certificados y documentación','61','INF. TÉCNICOS DE OBRAS',3,45,2,'',null,null,null),
    T_TIPO_DATA('Informes técnicos y obtención documentos','VPO: Solicitud devolución ayudas','62','OTRAS TASAS',2,1,6,'DEVOLUCIÓN OTRAS TASAS',2,1,56),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Inspección técnica de edificios','63','COMUNIDAD ORDINARIA',2,2,1,'DEVOLUCIÓN COMUNIDAD ORDINARIA',2,2,51),
    T_TIPO_DATA('Informes técnicos y obtención documentos','Informe topográfico','64','INF. TÉCNICOS DE OBRAS',3,45,2,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Cambio de cerradura','65','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Tapiado','66','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Retirada de enseres','67','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza','68','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza y retirada de enseres','69','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','70','GESTIÓN TOMA DE POSESIÓN',3,42,9,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','71','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Seguridad y Salud (SS)','72','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Verificación de averías','73','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Obra menor','74','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','75','ASIS. TECN, DF, SEG.  CONSTR.',3,43,1,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Control de actuaciones (dirección técnica)','76','ASIS. TECN, DF, SEG.  CONSTR.',3,43,1,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Colocación puerta antiocupa','77','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Actuación técnica y mantenimiento','Mobiliario','78','OBRAS MENORES',3,42,4,'',null,null,null),
    T_TIPO_DATA('Vigilancia y seguridad','Vigilancia y seguridad','79','VIGILANCIA Y SEGURIDAD',3,42,5,'',null,null,null),
    T_TIPO_DATA('Vigilancia y seguridad','Alarmas','80','VIGILANCIA Y SEGURIDAD',3,42,5,'',null,null,null),
    T_TIPO_DATA('Vigilancia y seguridad','Servicios auxiliares','81','VIGILANCIA Y SEGURIDAD',3,42,5,'',null,null,null),
    T_TIPO_DATA('Publicidad','Publicidad','82','COMERCIALIZACIÓN INMUEBLES',3,48,2,'',null,null,null),
    T_TIPO_DATA('Otros gastos','Mensajería/correos/copias','83','EXTRAS COMUNIDAD',2,2,2,'',null,null,null),
    T_TIPO_DATA('Otros gastos','Costas judiciales (demanda comunidad propietarios)','84','COSTAS DEMANDA COMUNIDAD',2,2,6,'DEVOLUCIÓN COSTAS DEMANDA COM.',2,2,56),
    T_TIPO_DATA('Otros gastos','Costas judiciales (otras demandas)','85','OBRAS MENORES',3,42,4,'',null,null,null),
    
    T_TIPO_DATA('Servicios profesionales independientes','Gestión de suelo','94','Gestión de suelo',3,44,3,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Abogado (Ocupacional)','95','Abogado (Ocupacional)',3,21,10,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Abogado (Asuntos generales)','96','Abogado (Asuntos generales)',3,21,10,'',null,null,null),
    T_TIPO_DATA('Servicios profesionales independientes','Abogado (Asistencia jurídica)','97','Abogado (Asistencia jurídica)',3,21,10,'',null,null,null),    
    
    T_TIPO_DATA('Otros gastos','Costas judiciales (demanda comunidad propietarios)','98','Costas judiciales (demanda comunidad propietarios)',2,2,6,'DEVOLUCIÓN Costas judiciales (demanda comunidad propietarios)',2,2,56),
    T_TIPO_DATA('Otros gastos','Costas judiciales (otras demandas)','99','Costas judiciales (otras demandas)',3,42,4,'',null,null,null)        
        
    );

  V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
  
  V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA;
  EXECUTE IMMEDIATE V_MSQL;
  
  -- LOOP para insertar los valores en  -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
  
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
      
      --Recuperamos DD_TGA_ID y DD_STG_ID
      BEGIN
        V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_DD_TGA_ID;
        
        V_MSQL := 'SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_TGA_ID = '||V_DD_TGA_ID||' AND DD_STG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_DD_STG_ID;
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''||TRIM(V_TMP_TIPO_DATA(3))||'''');
        V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
        
        --Insertamos registro
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(DD_ETG_ID, DD_TGA_ID, DD_STG_ID
          ,DD_ETG_CODIGO,DD_ETG_DESCRIPCION_POS,DD_ETG_DESCRIPCION_LARGA_POS
          ,COGRUG_POS,COTACA_POS,COSBAC_POS
          ,DD_ETG_DESCRIPCION_NEG,DD_ETG_DESCRIPCION_LARGA_NEG
          ,COGRUG_NEG,COTACA_NEG,COSBAC_NEG
          ,VERSION,USUARIOCREAR,FECHACREAR
          ,BORRADO) VALUES ('||V_ID||', '||V_DD_TGA_ID||', '||V_DD_STG_ID||'
          ,'''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||'''
          ,'''||TRIM(V_TMP_TIPO_DATA(5))||''', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||'''
          ,'''||TRIM(V_TMP_TIPO_DATA(8))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' 
          ,'''||TRIM(V_TMP_TIPO_DATA(9))||''', '''||TRIM(V_TMP_TIPO_DATA(10))||''', '''||TRIM(V_TMP_TIPO_DATA(11))||'''
          ,0, ''HREOS-3310'',SYSDATE,0)';
        EXECUTE IMMEDIATE V_MSQL;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Id no encontrado');
      END;

    END LOOP;

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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

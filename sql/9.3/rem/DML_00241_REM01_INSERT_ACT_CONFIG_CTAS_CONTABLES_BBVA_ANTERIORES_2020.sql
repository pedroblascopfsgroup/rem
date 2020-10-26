--/*
--##########################################
--## AUTOR=Daniel
--## FECHA_CREACION=20201023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11745
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CONFIG_CTAS_CONTABLES los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-11745';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	  V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- CUENTA_CONTABLE   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Actuación post-venta'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Cambio de cerradura'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Colocación puerta antiocupa'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Control de actuaciones (dirección técnica)'),
T_TIPO_DATA('Z02', 'Actuación técnica y mantenimiento', 'Limpieza'),
T_TIPO_DATA('Z02', 'Actuación técnica y mantenimiento', 'Limpieza, desinfección… (solares)'),
T_TIPO_DATA('Z02', 'Actuación técnica y mantenimiento', 'Limpieza, retirada de enseres y descerraje'),
T_TIPO_DATA('Z02', 'Actuación técnica y mantenimiento', 'Limpieza y retirada de enseres'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Mobiliario'),
T_TIPO_DATA('ZA06', 'Actuación técnica y mantenimiento', 'Obra mayor. Edificación (certif. de obra)'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Obra menor'),
T_TIPO_DATA('Z02', 'Actuación técnica y mantenimiento', 'Retirada de enseres'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Seguridad y Salud (SS)'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Tapiado'),
T_TIPO_DATA('Z01', 'Actuación técnica y mantenimiento', 'Verificación de averías'),


T_TIPO_DATA('Z04', 'Comisiones', 'Mediador'),
T_TIPO_DATA('Z33', 'Complejo inmobiliario', 'Cuota extraordinaria (derrama)'),
T_TIPO_DATA('Z33', 'Complejo inmobiliario', 'Cuota ordinaria'),
T_TIPO_DATA('Z33', 'Comunidad de propietarios', 'Certificado deuda comunidad'),
T_TIPO_DATA('Z33', 'Comunidad de propietarios', 'Cuota extraordinaria (derrama)'),
T_TIPO_DATA('Z33', 'Comunidad de propietarios', 'Cuota ordinaria'),
T_TIPO_DATA('Z17', 'Gestoría', 'Honorarios gestión activos'),
T_TIPO_DATA('Z17', 'Gestoría', 'Honorarios gestión ventas'),
T_TIPO_DATA('Z66', 'Impuesto', 'IAAEE'),
T_TIPO_DATA('Z39', 'Impuesto', 'IBI urbana'),
T_TIPO_DATA('Z39', 'Impuesto', 'IBI rústica'),
T_TIPO_DATA('ZA07', 'Impuesto', 'ICIO'),
T_TIPO_DATA('Z38', 'Impuesto', 'ITPAJD'),
T_TIPO_DATA('Z62', 'Impuesto', 'Plusvalía (IIVTNU) compra'),
T_TIPO_DATA('Z62', 'Impuesto', 'Plusvalía (IIVTNU) venta'),
T_TIPO_DATA('Z48', 'Impuesto', 'Recargos e intereses'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'Boletín instalaciones y suministros'),
T_TIPO_DATA('Z17', 'Informes técnicos y obtención documentos', 'Cédula Habitabilidad'),
T_TIPO_DATA('Z06', 'Informes técnicos y obtención documentos', 'Certif. eficiencia energética (CEE)'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'Certificado Final de Obra (CFO)'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'Informe topográfico'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'Informes'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'Inspección técnica de edificios'),
T_TIPO_DATA('Z40', 'Informes técnicos y obtención documentos', 'Licencia Primera Ocupación (LPO)'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'Nota simple actualizada'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'Obtención certificados y documentación'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'VPO: Autorización de venta'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'VPO: Notificación adjudicación (tanteo)'),
T_TIPO_DATA('Z08', 'Informes técnicos y obtención documentos', 'VPO: Solicitud devolución ayudas'),
T_TIPO_DATA('Z33', 'Junta de compensación / EUC', 'Cuotas y derramas'),
T_TIPO_DATA('Z33', 'Junta de compensación / EUC', 'Gastos generales'),
T_TIPO_DATA('Z33', 'Otras entidades en que se integra el activo', 'Cuotas y derramas'),
T_TIPO_DATA('Z33', 'Otras entidades en que se integra el activo', 'Gastos generales'),
T_TIPO_DATA('Z33', 'Otras entidades en que se integra el activo', 'Otros'),



T_TIPO_DATA('Z23', 'Otros gastos', 'Mensajería/correos/copias'),

T_TIPO_DATA('Z40', 'Otros tributos', 'Contribución especial'),
T_TIPO_DATA('Z40', 'Otros tributos', 'Otros'),
T_TIPO_DATA('Z50', 'Publicidad', 'Publicidad'),
T_TIPO_DATA('Z46', 'Sanción', 'Multa coercitiva'),
T_TIPO_DATA('Z46', 'Sanción', 'Otros'),
T_TIPO_DATA('Z46', 'Sanción', 'Ruina'),
T_TIPO_DATA('Z46', 'Sanción', 'Tributaria'),
T_TIPO_DATA('Z46', 'Sanción', 'Urbanística'),
T_TIPO_DATA('Z26', 'Seguros', 'Parte daños a terceros'),
T_TIPO_DATA('Z26', 'Seguros', 'Parte daños propios'),
T_TIPO_DATA('Z26', 'Seguros', 'Prima RC (responsabilidad civil)'),
T_TIPO_DATA('Z26', 'Seguros', 'Prima TRDM (todo riesgo daño material)'),
T_TIPO_DATA('Z13', 'Servicios profesionales independientes', 'Abogado (Asistencia jurídica)'),
T_TIPO_DATA('Z13', 'Servicios profesionales independientes', 'Abogado (Asuntos generales)'),
T_TIPO_DATA('Z13', 'Servicios profesionales independientes', 'Abogado (Ocupacional)'),
T_TIPO_DATA('Z13', 'Servicios profesionales independientes', 'Administrador Comunidad Propietarios'),
T_TIPO_DATA('Z21', 'Servicios profesionales independientes', 'Asesoría'),
T_TIPO_DATA('Z13', 'Servicios profesionales independientes', 'Gestión de suelo'),
T_TIPO_DATA('Z15', 'Servicios profesionales independientes', 'Notaría'),
T_TIPO_DATA('Z13', 'Servicios profesionales independientes', 'Otros'),
T_TIPO_DATA('Z13', 'Servicios profesionales independientes', 'Otros servicios jurídicos'),
T_TIPO_DATA('Z15', 'Servicios profesionales independientes', 'Procurador'),
T_TIPO_DATA('Z19', 'Servicios profesionales independientes', 'Registro'),
T_TIPO_DATA('Z05', 'Servicios profesionales independientes', 'Tasación'),
T_TIPO_DATA('Z08', 'Servicios profesionales independientes', 'Técnico'),
T_TIPO_DATA('Z29', 'Suministro', 'Agua'),
T_TIPO_DATA('Z30', 'Suministro', 'Electricidad'),
T_TIPO_DATA('Z31', 'Suministro', 'Gas'),

T_TIPO_DATA('Z40', 'Tasa', 'Agua'),
T_TIPO_DATA('Z40', 'Tasa', 'Alcantarillado'),
T_TIPO_DATA('Z40', 'Tasa', 'Basura'),
T_TIPO_DATA('Z40', 'Tasa', 'Ecotasa'),
T_TIPO_DATA('Z40', 'Tasa', 'Expedición documentos'),
T_TIPO_DATA('Z40', 'Tasa', 'Judicial'),
T_TIPO_DATA('Z40', 'Tasa', 'Obras / Rehabilitación / Mantenimiento'),
T_TIPO_DATA('Z40', 'Tasa', 'Otras tasas'),
T_TIPO_DATA('Z40', 'Tasa', 'Otras tasas ayuntamiento'),
T_TIPO_DATA('Z40', 'Tasa', 'Regularización catastral'),
T_TIPO_DATA('Z40', 'Tasa', 'Vado'),
T_TIPO_DATA('Z03', 'Vigilancia y seguridad', 'Alarmas'),
T_TIPO_DATA('Z24', 'Vigilancia y seguridad', 'Servicios auxiliares'),
T_TIPO_DATA('Z24', 'Vigilancia y seguridad', 'Vigilancia y seguridad')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] Vaciamos tabla temporal... ');
    V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA;
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''16''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_'||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
        V_SQL := 'SELECT COUNT(1) 
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TMP.DD_TGA_ID = TGA.DD_TGA_ID
            AND TGA.BORRADO = 0
          JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON TMP.DD_STG_ID = STG.DD_STG_ID
            AND STG.DD_TGA_ID = TGA.DD_TGA_ID
            AND STG.BORRADO = 0
          WHERE CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
            AND TGA.DD_TGA_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
            AND STG.DD_STG_DESCRIPCION = '''||V_TMP_TIPO_DATA(3)||'''
            AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''16'')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: La CCC '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_ID := I;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TMP_'||V_TEXT_TABLA||' (' ||
                      'CCC_CTAS_ID, CCC_CUENTA_CONTABLE, DD_TGA_ID, DD_STG_ID, DD_CRA_ID, FECHACREAR, BORRADO) VALUES (' ||
                      ''|| V_ID ||','''||V_TMP_TIPO_DATA(1)||''',(SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''),'||
                      '(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG '||
                      ' JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID AND TGA.DD_TGA_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||''''||
                      ' WHERE STG.DD_STG_DESCRIPCION = '''||V_TMP_TIPO_DATA(3)||'''),'||
                      ' '''||TRIM(V_DD_CRA_ID)||''', SYSDATE, 0)';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        END IF;

      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla TMP_'||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Preparamos cuentas para tabla de negocio.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CCC_CTAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CCC_ARRENDAMIENTO, CCC_REFACTURABLE, DD_TBE_ID
                      , CCC_ACTIVABLE, CCC_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CCC_VENDIDO
                  ORDER BY CCC_CTAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      ) T2
      ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
      WHEN MATCHED THEN 
          UPDATE SET T1.CCC_PRINCIPAL = CASE WHEN T2.RN = 1 THEN 1 ELSE 0 END';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      SET DD_TIM_ID = (SELECT DD_TIM_ID FROM DD_TIM_TIPO_IMPORTE WHERE DD_TIM_CODIGO = ''BAS'')
      WHERE DD_TIM_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CCC_CTAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CCC_ARRENDAMIENTO, CCC_REFACTURABLE, DD_TBE_ID
                      , CCC_ACTIVABLE, CCC_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CCC_VENDIDO
                  ORDER BY CCC_CTAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
          WHERE CCC_PRINCIPAL = 0
      ) T2
      ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID AND T2.RN > 1)
      WHEN MATCHED THEN
          UPDATE SET T1.BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      WHERE BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: Cuentas preparadas.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CCC_CTAS_ID
          , CCC_CUENTA_CONTABLE
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CCC_ARRENDAMIENTO
          , CCC_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CCC_SUBCUENTA_CONTABLE
          , CCC_ACTIVABLE
          , CCC_PLAN_VISITAS
          , DD_TCH_ID
          , CCC_PRINCIPAL
          , DD_TRT_ID
          , CCC_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CCC.CCC_CUENTA_CONTABLE
          , CCC.DD_TGA_ID
          , CCC.DD_STG_ID
          , CCC.DD_TIM_ID
          , CCC.DD_CRA_ID
          , CCC.DD_SCR_ID
          , CCC.PRO_ID
          , CCC.EJE_ID
          , CCC.CCC_ARRENDAMIENTO
          , CCC.CCC_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CCC.DD_TBE_ID
          , CCC.CCC_SUBCUENTA_CONTABLE
          , CCC.CCC_ACTIVABLE
          , CCC.CCC_PLAN_VISITAS
          , CCC.DD_TCH_ID
          , CCC.CCC_PRINCIPAL
          , CCC.DD_TRT_ID
          , CCC.CCC_VENDIDO
      FROM (
          SELECT TMP.CCC_CUENTA_CONTABLE
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , SCR.DD_SCR_ID
              , PRO.PRO_ID
              , TMP.PRO_ID TMP_PRO
              , EJE.EJE_ID
              , ARR.NUMERO CCC_ARRENDAMIENTO
              , 0 CCC_REFACTURABLE
              , NULL DD_TBE_ID
              , TMP.CCC_SUBCUENTA_CONTABLE
              , 0 CCC_ACTIVABLE
              , 0 CCC_PLAN_VISITAS
              , NULL DD_TCH_ID
              , TMP.CCC_PRINCIPAL
              , NULL DD_TRT_ID
              , VEN.NUMERO CCC_VENDIDO
              , RANK() OVER(
                  PARTITION BY TMP.DD_TGA_ID, TMP.DD_STG_ID, TMP.DD_TIM_ID, TMP.DD_CRA_ID, SCR.DD_SCR_ID, EJE.EJE_ID, PRO.PRO_ID, TMP.CCC_PRINCIPAL
                  ORDER BY 
                      CASE 
                          WHEN TMP.PRO_ID IS NOT NULL AND NVL(PRO.PRO_ID, 0) = NVL(TMP.PRO_ID, 0) THEN 0
                          WHEN TMP.PRO_ID IS NULL AND NVL(PRO.PRO_ID, 0) <> NVL(TMP.PRO_ID, 0) THEN 1
                          ELSE 2
                      END
                  ) RN 
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = TMP.DD_CRA_ID
              AND CRA.BORRADO = 0
          JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.DD_CRA_ID = TMP.DD_CRA_ID
              AND PRO.BORRADO = 0
          JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = TMP.DD_CRA_ID
              AND SCR.BORRADO = 0
          JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ANYO <> 2020
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO ARR ON 1 = 1
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO VEN ON 1 = 1
          WHERE TMP.BORRADO = 0
      ) CCC
      WHERE CCC.RN = 1
          AND (CCC.TMP_PRO = CCC.PRO_ID OR CCC.TMP_PRO IS NULL)
          AND NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CCC.DD_TGA_ID
                  AND AUX.DD_STG_ID = CCC.DD_STG_ID
                  AND AUX.DD_TIM_ID = CCC.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CCC.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CCC.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CCC.PRO_ID
                  AND AUX.EJE_ID = CCC.EJE_ID
                  AND NVL(AUX.CCC_ARRENDAMIENTO, 0) = NVL(CCC.CCC_ARRENDAMIENTO, NVL(AUX.CCC_ARRENDAMIENTO, 0))
                  AND AUX.CCC_REFACTURABLE = CCC.CCC_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CCC.DD_TBE_ID, 0)
                  AND AUX.CCC_ACTIVABLE = CCC.CCC_ACTIVABLE
                  AND AUX.CCC_PLAN_VISITAS = CCC.CCC_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CCC.DD_TCH_ID, 0)
                  AND AUX.CCC_PRINCIPAL = CCC.CCC_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CCC.DD_TRT_ID, 0)
                  AND NVL(AUX.CCC_VENDIDO, 0) = NVL(CCC.CCC_VENDIDO, NVL(AUX.CCC_VENDIDO, 0))
                  AND AUX.BORRADO = 0
          )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas insertadas');

    COMMIT;  
   

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

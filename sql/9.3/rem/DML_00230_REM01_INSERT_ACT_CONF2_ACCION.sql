--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=202001007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11215
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONF2_ACCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('001','ID Activo SAREB','001','NO_ACT'),
      T_TIPO_DATA('002','Tipo Activo','002','ACT_CND'),
      T_TIPO_DATA('002','Tipo Activo','003','WRN_CND'),
      T_TIPO_DATA('003','Tipo Activo OE','113','ACT'),
      T_TIPO_DATA('004','Subtipo Activo','004','ACT_CND'),
      T_TIPO_DATA('004','Subtipo Activo','005','WRN_CND'),
      T_TIPO_DATA('005','Subtipo Activo OE','114','ACT'),
      T_TIPO_DATA('006','Uso dominante','006','ACT'),
      T_TIPO_DATA('007','Alquilado (Ocupado)','007','NO_ACT'),
      T_TIPO_DATA('008','Origen Alquiler','139','NO_ACT'),
      T_TIPO_DATA('008','Origen Alquiler','140','WRN_CND'),
      T_TIPO_DATA('009','Situación: Ocupado ilegal',NULL,NULL),
      T_TIPO_DATA('010','Fecha cambio de estado Ocupado Ilegal',NULL,NULL),
      T_TIPO_DATA('011','Estado físico del activo','008','ACT'),
      T_TIPO_DATA('011','Estado físico del activo','009','WRN_CND'),
      T_TIPO_DATA('012','Riesgo de ocupacion',NULL,NULL),
      T_TIPO_DATA('013','Puerta antiokupa','010','ACT'),
      T_TIPO_DATA('014','Vigilancia','011','ACT'),
      T_TIPO_DATA('015','Alarma','012','ACT'),
      T_TIPO_DATA('016','Ascensor','128','ACT'),
      T_TIPO_DATA('017','Estado de inscripcion','013','ACT'),
      T_TIPO_DATA('017','Estado de inscripcion','014','WRN'),
      T_TIPO_DATA('018','Fecha de inscripción','015','ACT_CND'),
      T_TIPO_DATA('018','Fecha de inscripción','016','WRN_CND'),
      T_TIPO_DATA('019','Tipo de Titulo','017','NO_ACT'),
      T_TIPO_DATA('019','Tipo de Titulo','019','WRN_CND'),
      T_TIPO_DATA('020','Subtipo de titulo','018','NO_ACT'),
      T_TIPO_DATA('020','Subtipo de titulo','020','WRN_CND'),
      T_TIPO_DATA('021','Fecha Toma Posesion','021','ACT'),
      T_TIPO_DATA('021','Fecha Toma Posesion','022','WRN_CND'),
      T_TIPO_DATA('022','% Propiedad','023','ACT'),
      T_TIPO_DATA('023','Grado de propiedad','024','ACT'),
      T_TIPO_DATA('024','VPO','025','ACT'),
      T_TIPO_DATA('025','Fecha Decreto','129','ACT'),
      T_TIPO_DATA('026','Fecha Testimonio/Fecha escritura dación','130','ACT'),
      T_TIPO_DATA('027','Fecha de señalamiento del lanzamiento','026','ACT'),
      T_TIPO_DATA('028','CIF/NIF Propietario','027','ACT'),
      T_TIPO_DATA('029','Con cargas','028','ACT'),
      T_TIPO_DATA('029','Con cargas','029','WRN_CND'),
      T_TIPO_DATA('030','ID Carga','030','ACT'),
      T_TIPO_DATA('030','ID Carga','031','WRN_CND'),
      T_TIPO_DATA('031','Tipo de Carga','032','ACT'),
      T_TIPO_DATA('031','Tipo de Carga','033','WRN_CND'),
      T_TIPO_DATA('032','Subtipo de Carga','034','ACT'),
      T_TIPO_DATA('032','Subtipo de Carga','035','WRN_CND'),
      T_TIPO_DATA('033','Titular carga','036','ACT'),
      T_TIPO_DATA('033','Titular carga','037','WRN_CND'),
      T_TIPO_DATA('034','Importe registral','038','ACT'),
      T_TIPO_DATA('034','Importe registral','039','WRN_CND'),
      T_TIPO_DATA('035','Estado registral','040','ACT'),
      T_TIPO_DATA('035','Estado registral','041','WRN_CND'),
      T_TIPO_DATA('036','Estado económico','126','ACT'),
      T_TIPO_DATA('036','Estado económico','127','WRN_CND'),
      T_TIPO_DATA('037','Fecha cancelación económica carga','044','ACT'),
      T_TIPO_DATA('037','Fecha cancelación económica carga','045','WRN_CND'),
      T_TIPO_DATA('038','Fecha presentación cancelación','046','ACT'),
      T_TIPO_DATA('038','Fecha presentación cancelación','047','WRN_CND'),
      T_TIPO_DATA('039','Fecha cancelación registral','042','ACT'),
      T_TIPO_DATA('039','Fecha cancelación registral','043','WRN_CND'),
      T_TIPO_DATA('040','Tipo de vía','048','ACT_CND'),
      T_TIPO_DATA('040','Tipo de vía','049','WRN_CND'),
      T_TIPO_DATA('041','Tipo de vía OE','115','ACT'),
      T_TIPO_DATA('042','Nombre de vía','050','ACT_CND'),
      T_TIPO_DATA('042','Nombre de vía','051','WRN_CND'),
      T_TIPO_DATA('043','Nombre de vía OE','116','ACT'),
      T_TIPO_DATA('044','Nº','052','ACT_CND'),
      T_TIPO_DATA('044','Nº','053','WRN_CND'),
      T_TIPO_DATA('045','Nº OE','117','ACT'),
      T_TIPO_DATA('046','Escalera','054','ACT_CND'),
      T_TIPO_DATA('046','Escalera','055','WRN_CND'),
      T_TIPO_DATA('047','Escalera OE','118','ACT'),
      T_TIPO_DATA('048','Planta','056','ACT_CND'),
      T_TIPO_DATA('048','Planta','057','WRN_CND'),
      T_TIPO_DATA('049','Planta OE','119','ACT'),
      T_TIPO_DATA('050','Puerta','058','ACT_CND'),
      T_TIPO_DATA('050','Puerta','059','WRN_CND'),
      T_TIPO_DATA('051','Puerta OE','120','ACT'),
      T_TIPO_DATA('052','Provincia','060','ACT_CND'),
      T_TIPO_DATA('052','Provincia','061','WRN_CND'),
      T_TIPO_DATA('053','Provincia OE','121','ACT'),
      T_TIPO_DATA('054','Municipio','062','ACT_CND'),
      T_TIPO_DATA('054','Municipio','063','WRN_CND'),
      T_TIPO_DATA('055','Municipio OE','122','ACT'),
      T_TIPO_DATA('056','Comunidad Autónoma','064','ACT'),
      T_TIPO_DATA('057','País','131','ACT'),
      T_TIPO_DATA('058','Código Postal','065','ACT_CND'),
      T_TIPO_DATA('058','Código Postal','066','WRN_CND'),
      T_TIPO_DATA('059','Código Postal OE','123','ACT'),
      T_TIPO_DATA('060','Latitud','067','ACT_CND'),
      T_TIPO_DATA('060','Latitud','068','WRN_CND'),
      T_TIPO_DATA('061','Latitud OE','124','ACT'),
      T_TIPO_DATA('062','Longitud','069','ACT_CND'),
      T_TIPO_DATA('062','Longitud','070','WRN_CND'),
      T_TIPO_DATA('063','Longitud OE','125','ACT'),
      T_TIPO_DATA('064','Activo en división horizontal no inscrita',NULL,NULL),
      T_TIPO_DATA('065','Provincia Registro','071','ACT'),
      T_TIPO_DATA('066','Población Registro','072','ACT'),
      T_TIPO_DATA('067','Número registro','073','ACT'),
      T_TIPO_DATA('068','Tomo','074','ACT'),
      T_TIPO_DATA('069','Libro','075','ACT'),
      T_TIPO_DATA('070','Folio','076','ACT'),
      T_TIPO_DATA('071','Finca','077','ACT'),
      T_TIPO_DATA('072','Subfinca','132','ACT'),
      T_TIPO_DATA('073','IDUFIR','078','ACT'),
      T_TIPO_DATA('074','Referencia catastral activo','079','ACT'),
      T_TIPO_DATA('075','Superficie construida','080','ACT'),
      T_TIPO_DATA('076','Superficie útil','081','ACT'),
      T_TIPO_DATA('077','Superficie parcela','082','ACT'),
      T_TIPO_DATA('078','¿Tiene boletin de agua?','083','ACT'),
      T_TIPO_DATA('079','¿Tiene boletin de electricidad?','084','ACT'),
      T_TIPO_DATA('080','¿Tiene boletin de gas?','085','ACT'),
      T_TIPO_DATA('081','¿tiene cedula de habitabilidad?','086','ACT'),
      T_TIPO_DATA('082','Fecha obtención Cédula Habitabilidad','087','ACT'),
      T_TIPO_DATA('083','¿Tiene Certificado energetico?','088','ACT_CND'),
      T_TIPO_DATA('083','¿Tiene Certificado energetico?','089','WRN_CND'),
      T_TIPO_DATA('084','¿tienen informe 0?','090','ACT'),
      T_TIPO_DATA('085','Destino Comercial Objetivo (Mayorista/minorista)',NULL,NULL),
      T_TIPO_DATA('086','Estado comercial','091','NO_ACT'),
      T_TIPO_DATA('086','Estado comercial','092','WRN_CND'),
      T_TIPO_DATA('087','Orden de publicación Minorista (instrucción enviada por SAREB para publicar)',NULL,NULL),
      T_TIPO_DATA('088','Orden de publicación Mayorista (instrucción enviada por SAREB para publicar)',NULL,NULL),
      T_TIPO_DATA('089','Bloqueo',NULL,NULL),
      T_TIPO_DATA('090','Motivo Bloqueo',NULL,NULL),
      T_TIPO_DATA('091','Código Agrupación Obra nueva','133','ACT'),
      T_TIPO_DATA('092','¿Tiene CFO?','093','ACT'),
      T_TIPO_DATA('093','Fecha CFO','094','ACT'),
      T_TIPO_DATA('094','¿Tiene LPO?','095','ACT'),
      T_TIPO_DATA('095','Fecha LPO','096','ACT'),
      T_TIPO_DATA('096','Tapiado','097','ACT'),
      T_TIPO_DATA('096','Tapiado','098','WRN'),
      T_TIPO_DATA('097','Estado adecuación','099','ACT'),
      T_TIPO_DATA('098','Fecha prevista fin adecuación','134','ACT'),
      T_TIPO_DATA('099','Precio de Venta WEB',NULL,NULL),
      T_TIPO_DATA('100','Precio de Renta WEB',NULL,NULL),
      T_TIPO_DATA('101','Precio Minimo Autorizado Venta',NULL,NULL),
      T_TIPO_DATA('102','¿tiene Tasacion?','100','ACT'),
      T_TIPO_DATA('103','Fecha tasación','101','ACT'),
      T_TIPO_DATA('104','Fecha solicitud tasación','102','ACT'),
      T_TIPO_DATA('105','Fecha recepción tasación','103','ACT'),
      T_TIPO_DATA('106','Técnico tasadora asociado','104','ACT'),
      T_TIPO_DATA('107','Importe tasación finalizado','105','ACT'),
      T_TIPO_DATA('108','Tipo de tasación','106','ACT'),
      T_TIPO_DATA('109','Precio visible venta',NULL,NULL),
      T_TIPO_DATA('110','Fecha inicio vigencia precio venta',NULL,NULL),
      T_TIPO_DATA('111','Fecha fin vigencia precio venta',NULL,NULL),
      T_TIPO_DATA('112','Precio visible renta',NULL,NULL),
      T_TIPO_DATA('113','Fecha inicio vigencia precio renta',NULL,NULL),
      T_TIPO_DATA('114','Fecha fin vigencia precio renta',NULL,NULL),
      T_TIPO_DATA('115','Precio Minimo Autorizado Renta',NULL,NULL),
      T_TIPO_DATA('116','Valor unitario de la tasación relacionado con la superficie','135','ACT'),
      T_TIPO_DATA('117','¿Es una unidad alquilable?','107','NO_ACT'),
      T_TIPO_DATA('118','Id activo padre UA (ID SAREB)','108','NO_ACT'),
      T_TIPO_DATA('119','¿Es Anejos Registral?','136','ACT'),
      T_TIPO_DATA('120','id activo padre Anejo registral',NULL,NULL),
      T_TIPO_DATA('121','¿es Anejo Anejos Comercial?',NULL,NULL),
      T_TIPO_DATA('122','id activo padre Anejo Comercial',NULL,NULL),
      T_TIPO_DATA('123','Adecuación alquileres',NULL,NULL),
      T_TIPO_DATA('124','Fecha prevista fin adecuación alquileres',NULL,NULL),
      T_TIPO_DATA('125','Número de reserva','109','ACT'),
      T_TIPO_DATA('126','Fecha Contable de la reserva','110','ACT'),
      T_TIPO_DATA('127','Fecha contable de la devolución de la reserva','137','ACT'),
      T_TIPO_DATA('128','Cartera','111','NO_ACT'),
      T_TIPO_DATA('129','Subcartera','112','NO_ACT'),
      T_TIPO_DATA('130','Precomercialización (a futuro)',NULL,NULL),
      T_TIPO_DATA('131','Fecha compromiso cliente (a futuro)',NULL,NULL),
      T_TIPO_DATA('132','Importe Comunidad Mensual (a futuro)',NULL,NULL),
      T_TIPO_DATA('133','Importe IBI Anual (a futuro)',NULL,NULL),
      T_TIPO_DATA('134','Importe Tasas Anual (a futuro)',NULL,NULL),
      T_TIPO_DATA('135','Número VAI (a futuro)',NULL,NULL),
      T_TIPO_DATA('136','Seguros del activo (Siniestro - a futuro)',NULL,NULL),
      T_TIPO_DATA('137','Ruina (a futuro)',NULL,NULL),
      T_TIPO_DATA('138','Vandalizado (a futuro)',NULL,NULL),
      T_TIPO_DATA('139','CEE en trámite (a futuro)',NULL,NULL),
      T_TIPO_DATA('140','Motivo','138','ACT'),
       T_TIPO_DATA('140','Motivo','141','WRN_CND')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE AC2_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(3))||''' ya existe');
        ELSE
          IF TRIM(V_TMP_TIPO_DATA(3)) IS NOT NULL THEN
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              AC2_ID,
              AC2_CODIGO,
              DD_COS_ID,
              DD_ACS_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
              (SELECT DD_ACS_ID FROM '||V_ESQUEMA||'.DD_ACS_ACCION_CONV_SAREB WHERE DD_ACS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''),
              0,
              ''HREOS-11215'',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(3))||'''');     
          ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO]: No existe configuración para '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
          END IF;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10500
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
	  V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_COS_CAMPOS_ORIGEN_CONV_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('001','ID Activo SAREB'),
      T_TIPO_DATA('002','Tipo Activo'),
      T_TIPO_DATA('003','Tipo Activo OE'),
      T_TIPO_DATA('004','Subtipo Activo'),
      T_TIPO_DATA('005','Subtipo Activo OE'),
      T_TIPO_DATA('006','Uso dominante'),
      T_TIPO_DATA('007','Alquilado (Ocupado)'),
      T_TIPO_DATA('008','Origen Alquiler'),
      T_TIPO_DATA('009','Situación: Ocupado ilegal'),
      T_TIPO_DATA('010','Fecha cambio de estado Ocupado Ilegal'),
      T_TIPO_DATA('011','Estado físico del activo'),
      T_TIPO_DATA('012','Riesgo de ocupacion '),
      T_TIPO_DATA('013','Puerta antiokupa'),
      T_TIPO_DATA('014','Vigilancia'),
      T_TIPO_DATA('015','Alarma'),
      T_TIPO_DATA('016','Ascensor'),
      T_TIPO_DATA('017','Estado de inscripcion'),
      T_TIPO_DATA('018','Fecha de inscripción'),
      T_TIPO_DATA('019','Tipo de Titulo'),
      T_TIPO_DATA('020','Subtipo de titulo'),
      T_TIPO_DATA('021','Fecha Toma Posesion'),
      T_TIPO_DATA('022','% Propiedad'),
      T_TIPO_DATA('023','Grado de propiedad'),
      T_TIPO_DATA('024','VPO'),
      T_TIPO_DATA('025','Fecha Decreto'),
      T_TIPO_DATA('026','Fecha Testimonio/Fecha escritura dación'),
      T_TIPO_DATA('027','Fecha de señalamiento del lanzamiento'),
      T_TIPO_DATA('028','CIF/NIF Propietario'),
      T_TIPO_DATA('029','Con cargas'),
      T_TIPO_DATA('030','ID Carga'),
      T_TIPO_DATA('031','Tipo de Carga'),
      T_TIPO_DATA('032','Subtipo de Carga'),
      T_TIPO_DATA('033','Titular carga'),
      T_TIPO_DATA('034','Importe registral'),
      T_TIPO_DATA('035','Estado registral'),
      T_TIPO_DATA('036','Estado económico'),
      T_TIPO_DATA('037','Fecha cancelación económica carga'),
      T_TIPO_DATA('038','Fecha presentación cancelación'),
      T_TIPO_DATA('039','Fecha cancelación registral'),
      T_TIPO_DATA('040','Tipo de vía'),
      T_TIPO_DATA('041','Tipo de vía OE'),
      T_TIPO_DATA('042','Nombre de vía'),
      T_TIPO_DATA('043','Nombre de vía OE'),
      T_TIPO_DATA('044','Nº '),
      T_TIPO_DATA('045','Nº OE'),
      T_TIPO_DATA('046','Escalera'),
      T_TIPO_DATA('047','Escalera OE'),
      T_TIPO_DATA('048','Planta'),
      T_TIPO_DATA('049','Planta OE'),
      T_TIPO_DATA('050','Puerta'),
      T_TIPO_DATA('051','Puerta OE'),
      T_TIPO_DATA('052','Provincia'),
      T_TIPO_DATA('053','Provincia OE'),
      T_TIPO_DATA('054','Municipio'),
      T_TIPO_DATA('055','Municipio OE'),
      T_TIPO_DATA('056','Comunidad Autónoma'),
      T_TIPO_DATA('057','País'),
      T_TIPO_DATA('058','Código Postal'),
      T_TIPO_DATA('059','Código Postal OE'),
      T_TIPO_DATA('060','Latitud'),
      T_TIPO_DATA('061','Latitud OE'),
      T_TIPO_DATA('062','Longitud'),
      T_TIPO_DATA('063','Longitud OE'),
      T_TIPO_DATA('064','Activo en división horizontal no inscrita '),
      T_TIPO_DATA('065','Provincia Registro'),
      T_TIPO_DATA('066','Población Registro'),
      T_TIPO_DATA('067','Número registro'),
      T_TIPO_DATA('068','Tomo'),
      T_TIPO_DATA('069','Libro'),
      T_TIPO_DATA('070','Folio'),
      T_TIPO_DATA('071','Finca'),
      T_TIPO_DATA('072','Subfinca'),
      T_TIPO_DATA('073','IDUFIR'),
      T_TIPO_DATA('074','Referencia catastral activo'),
      T_TIPO_DATA('075','Superficie construida'),
      T_TIPO_DATA('076','Superficie útil'),
      T_TIPO_DATA('077','Superficie parcela'),
      T_TIPO_DATA('078','¿Tiene boletin de agua?'),
      T_TIPO_DATA('079','¿Tiene boletin de electricidad?'),
      T_TIPO_DATA('080','¿Tiene boletin de gas?'),
      T_TIPO_DATA('081','¿tiene cedula de habitabilidad?'),
      T_TIPO_DATA('082','Fecha obtención Cédula Habitabilidad'),
      T_TIPO_DATA('083','¿Tiene Certificado energetico?'),
      T_TIPO_DATA('084','¿tienen informe 0?'),
      T_TIPO_DATA('085','Destino Comercial Objetivo (Mayorista/minorista)'),
      T_TIPO_DATA('086','Estado comercial'),
      T_TIPO_DATA('087','Orden de publicación Minorista (instrucción enviada por SAREB para publicar)'),
      T_TIPO_DATA('088','Orden de publicación Mayorista (instrucción enviada por SAREB para publicar)'),
      T_TIPO_DATA('089','Bloqueo'),
      T_TIPO_DATA('090','Motivo Bloqueo'),
      T_TIPO_DATA('091','Código Agrupación Obra nueva'),
      T_TIPO_DATA('092','¿Tiene CFO?'),
      T_TIPO_DATA('093','Fecha CFO'),
      T_TIPO_DATA('094','¿Tiene LPO?'),
      T_TIPO_DATA('095','Fecha LPO'),
      T_TIPO_DATA('096','Tapiado'),
      T_TIPO_DATA('097','Estado adecuación'),
      T_TIPO_DATA('098','Fecha prevista fin adecuación'),
      T_TIPO_DATA('099','Precio de Venta WEB'),
      T_TIPO_DATA('100','Precio de Renta WEB'),
      T_TIPO_DATA('101','Precio Minimo Autorizado Venta'),
      T_TIPO_DATA('102','¿tiene Tasacion?'),
      T_TIPO_DATA('103','Fecha tasación'),
      T_TIPO_DATA('104','Fecha solicitud tasación'),
      T_TIPO_DATA('105','Fecha recepción tasación'),
      T_TIPO_DATA('106','Técnico tasadora asociado'),
      T_TIPO_DATA('107','Importe tasación finalizado'),
      T_TIPO_DATA('108','Tipo de tasación'),
      T_TIPO_DATA('109','Precio visible venta'),
      T_TIPO_DATA('110','Fecha inicio vigencia precio venta'),
      T_TIPO_DATA('111','Fecha fin vigencia precio venta'),
      T_TIPO_DATA('112','Precio visible renta'),
      T_TIPO_DATA('113','Fecha inicio vigencia precio renta'),
      T_TIPO_DATA('114','Fecha fin vigencia precio renta'),
      T_TIPO_DATA('115','Precio Minimo Autorizado Renta'),
      T_TIPO_DATA('116','Valor unitario de la tasación relacionado con la superficie'),
      T_TIPO_DATA('117','¿Es una unidad alquilable?'),
      T_TIPO_DATA('118','Id activo padre UA (ID SAREB)'),
      T_TIPO_DATA('119','¿Es Anejos Registral?'),
      T_TIPO_DATA('120','id activo padre Anejo registral'),
      T_TIPO_DATA('121','¿es Anejo Anejos Comercial?'),
      T_TIPO_DATA('122','id activo padre Anejo Comercial'),
      T_TIPO_DATA('123','Adecuación alquileres'),
      T_TIPO_DATA('124','Fecha prevista fin adecuación alquileres'),
      T_TIPO_DATA('125','Número de reserva'),
      T_TIPO_DATA('126','Fecha Contable de la reserva'),
      T_TIPO_DATA('127','Fecha contable de la devolución de la reserva'),
      T_TIPO_DATA('128','Cartera'),
      T_TIPO_DATA('129','Subcartera'),
      T_TIPO_DATA('130','Precomercialización (a futuro)'),
      T_TIPO_DATA('131','Fecha compromiso cliente (a futuro)'),
      T_TIPO_DATA('132','Importe Comunidad Mensual (a futuro)'),
      T_TIPO_DATA('133','Importe IBI Anual (a futuro)'),
      T_TIPO_DATA('134','Importe Tasas Anual (a futuro)'),
      T_TIPO_DATA('135','Número VAI (a futuro)'),
      T_TIPO_DATA('136','Seguros del activo (Siniestro - a futuro)'),
      T_TIPO_DATA('137','Ruina (a futuro)'),
      T_TIPO_DATA('138','Vandalizado (a futuro)'),
      T_TIPO_DATA('139','CEE en trámite (a futuro)'),
      T_TIPO_DATA('140','Motivo')
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
					WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_COS_ID,
              DD_COS_CODIGO,
              DD_COS_DESCRIPCION,
              DD_COS_DESCRIPCION_LARGA,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
               '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              0,
              ''HREOS-10500'',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

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

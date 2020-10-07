--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201007
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
	  V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_CCS_CAMPOS_CONV_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('001','ID Activo SAREB','ACT_ACTIVO','ACT_NUM_ACTIVO_SAREB','ACT_ID'),
      T_TIPO_DATA('002','Tipo Activo','ACT_ACTIVO','DD_TPA_ID','ACT_ID'),
      T_TIPO_DATA('003','Tipo Activo OE','ACT_SAREB_ACTIVOS','DD_TPA_ID','ACT_ID'),
      T_TIPO_DATA('004','Subtipo Activo','ACT_ACTIVO','DD_SAC_ID','ACT_ID'),
      T_TIPO_DATA('005','Subtipo Activo OE','ACT_SAREB_ACTIVOS','DD_SAC_ID','ACT_ID'),
      T_TIPO_DATA('006','Uso dominante','ACT_ACTIVO','DD_TUD_ID','ACT_ID'),
      T_TIPO_DATA('007','Alquilado (Ocupado)','ACT_SPS_SIT_POSESORIA','SPS_OCUPADO','ACT_ID'),
      T_TIPO_DATA('007','Alquilado (Ocupado)','ACT_SPS_SIT_POSESORIA','DD_TPA_ID','ACT_ID'),
      T_TIPO_DATA('008','Origen Alquiler','ACT_PTA_PATRIMONIO_ACTIVO','CHECK_SUBROGADO','ACT_ID'),
      T_TIPO_DATA('009','Situación: Ocupado ilegal','ACT_SPS_SIT_POSESORIA','SPS_OCUPADO','ACT_ID'),
      T_TIPO_DATA('009','Situación: Ocupado ilegal','ACT_SPS_SIT_POSESORIA','DD_TPA_ID','ACT_ID'),
      T_TIPO_DATA('010','Fecha cambio de estado Ocupado Ilegal',NULL,NULL,NULL),
      T_TIPO_DATA('011','Estado físico del activo','ACT_ACTIVO','DD_EAC_ID','ACT_ID'),
      T_TIPO_DATA('012','Riesgo de ocupacion','ACT_SPS_SIT_POSESORIA','SPS_RIESGO_OCUPACION','ACT_ID'),
      T_TIPO_DATA('013','Puerta antiokupa','ACT_SPS_SIT_POSESORIA','SPS_ACC_ANTIOCUPA','ACT_ID'),
      T_TIPO_DATA('014','Vigilancia','ACT_ZCO_ZONA_COMUN','ZCO_CONSERJE_VIGILANCIA','ICO_ID'),
      T_TIPO_DATA('015','Alarma',NULL,NULL,NULL),
      T_TIPO_DATA('016','Ascensor','ACT_EDI_EDIFICIO','EDI_ASCENSOR','ACT_ID'),
      T_TIPO_DATA('017','Estado de inscripcion','ACT_TIT_TITULO','DD_ETI_ID','ACT_ID'),
      T_TIPO_DATA('018','Fecha de inscripción','ACT_TIT_TITULO','TIT_FECHA_INSC_REG','ACT_ID'),
      T_TIPO_DATA('019','Tipo de Titulo','ACT_ACTIVO','DD_TTA_ID','ACT_ID'),
      T_TIPO_DATA('020','Subtipo de titulo','ACT_ACTIVO','DD_STA_ID','ACT_ID'),
      T_TIPO_DATA('021','Fecha Toma Posesion','ACT_SPS_SIT_POSESORIA','SPS_FECHA_TOMA_POSESION','ACT_ID'),
      T_TIPO_DATA('022','% Propiedad','ACT_PAC_PROPIETARIO_ACTIVO','PAC_PORC_PROPIEDAD','ACT_ID'),
      T_TIPO_DATA('023','Grado de propiedad','ACT_PAC_PROPIETARIO_ACTIVO','DD_TGP_ID','ACT_ID'),
      T_TIPO_DATA('024','VPO','ACT_ACTIVO','ACT_VPO','ACT_ID'),
      T_TIPO_DATA('025','Fecha Decreto','ACT_AJD_ADJJUDICIAL','AJD_FECHA_ADJUDICACION','ACT_ID'),
      T_TIPO_DATA('026','Fecha Testimonio/Fecha escritura dación','BIE_ADJ_ADJUDICACION','BIE_ADJ_F_DECRETO_FIRME','BIE_ID'),
      T_TIPO_DATA('027','Fecha de señalamiento del lanzamiento','BIE_ADJ_ADJUDICACION','BIE_ADJ_F_SEN_LANZAMIENTO','BIE_ID'),
      T_TIPO_DATA('028','CIF/NIF Propietario','ACT_PAC_PROPIETARIO_ACTIVO','PRO_ID','ACT_ID'),
      T_TIPO_DATA('029','Con cargas','ACT_CRG_CARGAS','CRG_ID','ACT_ID'),
      T_TIPO_DATA('030','ID Carga','BIE_CAR_CARGAS','BIE_CAR_ID_RECOVERY','BIE_ID'),
      T_TIPO_DATA('031','Tipo de Carga','ACT_CRG_CARGAS','DD_TCA_ID','ACT_ID'),
      T_TIPO_DATA('032','Subtipo de Carga','ACT_CRG_CARGAS','DD_STC_ID','ACT_ID'),
      T_TIPO_DATA('033','Titular carga','BIE_CAR_CARGAS','BIE_CAR_TITULAR','BIE_ID'),
      T_TIPO_DATA('034','Importe registral','BIE_CAR_CARGAS','BIE_CAR_IMPORTE_REGISTRAL','BIE_ID'),
      T_TIPO_DATA('035','Estado registral','ACT_CRG_CARGAS','DD_ECG_ID','ACT_ID'),
      T_TIPO_DATA('036','Estado económico','ACT_CRG_CARGAS','DD_ECG_ID','ACT_ID'),
      T_TIPO_DATA('037','Fecha cancelación económica carga','BIE_CAR_CARGAS','BIE_CAR_FECHA_CANCELACION','BIE_ID'),
      T_TIPO_DATA('038','Fecha presentación cancelación','BIE_CAR_CARGAS','BIE_CAR_FECHA_PRESENTACION','BIE_ID'),
      T_TIPO_DATA('039','Fecha cancelación registral','ACT_CRG_CARGAS','CRG_FECHA_CANCEL_REGISTRAL','ACT_ID'),
      T_TIPO_DATA('040','Tipo de vía','BIE_LOCALIZACION','DD_TVI_ID','BIE_ID'),
      T_TIPO_DATA('041','Tipo de vía OE','ACT_SAREB_ACTIVOS','DD_TVI_ID','ACT_ID'),
      T_TIPO_DATA('042','Nombre de vía','BIE_LOCALIZACION','BIE_LOC_NOMBRE_VIA','BIE_ID'),
      T_TIPO_DATA('043','Nombre de vía OE','ACT_SAREB_ACTIVOS','ASA_NOMBRE_VIA','ACT_ID'),
      T_TIPO_DATA('044','Nº','BIE_LOCALIZACION','BIE_LOC_NUMERO_DOMICILIO','BIE_ID'),
      T_TIPO_DATA('045','Nº OE','ACT_SAREB_ACTIVOS','ASA_NUMERO_DOMICILIO','ACT_ID'),
      T_TIPO_DATA('046','Escalera','BIE_LOCALIZACION','BIE_LOC_ESCALERA','BIE_ID'),
      T_TIPO_DATA('047','Escalera OE','ACT_SAREB_ACTIVOS','ASA_ESCALERA','ACT_ID'),
      T_TIPO_DATA('048','Planta','BIE_LOCALIZACION','BIE_LOC_PISO','BIE_ID'),
      T_TIPO_DATA('049','Planta OE','ACT_SAREB_ACTIVOS','ASA_PISO','ACT_ID'),
      T_TIPO_DATA('050','Puerta','BIE_LOCALIZACION','BIE_LOC_PUERTA','BIE_ID'),
      T_TIPO_DATA('051','Puerta OE','ACT_SAREB_ACTIVOS','ASA_PUERTA','ACT_ID'),
      T_TIPO_DATA('052','Provincia','BIE_LOCALIZACION','DD_PRV_ID','BIE_ID'),
      T_TIPO_DATA('053','Provincia OE','ACT_SAREB_ACTIVOS','DD_PRV_ID','ACT_ID'),
      T_TIPO_DATA('054','Municipio','BIE_LOCALIZACION','DD_LOC_ID','BIE_ID'),
      T_TIPO_DATA('055','Municipio OE','ACT_SAREB_ACTIVOS','DD_LOC_ID','ACT_ID'),
      T_TIPO_DATA('056','Comunidad Autónoma','BIE_LOCALIZACION','DD_PRV_ID','BIE_ID'),
      T_TIPO_DATA('057','País','BIE_LOCALIZACION','DD_CIC_ID','BIE_ID'),
      T_TIPO_DATA('058','Código Postal','BIE_LOCALIZACION','BIE_LOC_COD_POST','BIE_ID'),
      T_TIPO_DATA('059','Código Postal OE','ACT_SAREB_ACTIVOS','ASA_COD_POST','ACT_ID'),
      T_TIPO_DATA('060','Latitud','ACT_LOC_LOCALIZACION','LOC_LATITUD','ACT_ID'),
      T_TIPO_DATA('061','Latitud OE','ACT_SAREB_ACTIVOS','ASA_LATITUD','ACT_ID'),
      T_TIPO_DATA('062','Longitud','ACT_LOC_LOCALIZACION','LOC_LONGITUD','ACT_ID'),
      T_TIPO_DATA('063','Longitud OE','ACT_SAREB_ACTIVOS','ASA_LATITUD','ACT_ID'),
      T_TIPO_DATA('064','Activo en división horizontal no inscrita','ACT_REG_INFO_REGISTRAL','REG_DIV_HOR_INSCRITO','ACT_ID'),
      T_TIPO_DATA('065','Provincia Registro','BIE_DATOS_REGISTRALES','DD_PRV_ID','BIE_ID'),
      T_TIPO_DATA('066','Población Registro','BIE_DATOS_REGISTRALES','DD_LOC_ID','BIE_ID'),
      T_TIPO_DATA('067','Número registro','BIE_DATOS_REGISTRALES','BIE_DREG_NUM_REGISTRO','BIE_ID'),
      T_TIPO_DATA('068','Tomo','BIE_DATOS_REGISTRALES','BIE_DREG_TOMO','BIE_ID'),
      T_TIPO_DATA('069','Libro','BIE_DATOS_REGISTRALES','BIE_DREG_LIBRO','BIE_ID'),
      T_TIPO_DATA('070','Folio','BIE_DATOS_REGISTRALES','BIE_DREG_FOLIO','BIE_ID'),
      T_TIPO_DATA('071','Finca','BIE_DATOS_REGISTRALES','BIE_DREG_NUM_FINCA','BIE_ID'),
      T_TIPO_DATA('072','Subfinca',NULL,NULL,NULL),
      T_TIPO_DATA('073','IDUFIR','ACT_REG_INFO_REGISTRAL','REG_IDUFIR','ACT_ID'),
      T_TIPO_DATA('074','Referencia catastral activo','BIE_DATOS_REGISTRALES','BIE_DREG_REFERENCIA_CATASTRAL','BIE_ID'),
      T_TIPO_DATA('075','Superficie construida','BIE_DATOS_REGISTRALES','BIE_DREG_SUPERFICIE_CONSTRUIDA','BIE_ID'),
      T_TIPO_DATA('076','Superficie útil','ACT_REG_INFO_REGISTRAL','REG_SUPERFICIE_UTIL','ACT_ID'),
      T_TIPO_DATA('077','Superficie parcela','ACT_REG_INFO_REGISTRAL','REG_SUPERFICIE_PARCELA','ACT_ID'),
      T_TIPO_DATA('078','¿Tiene boletin de agua?',NULL,NULL,NULL),
      T_TIPO_DATA('079','¿Tiene boletin de electricidad?',NULL,NULL,NULL),
      T_TIPO_DATA('080','¿Tiene boletin de gas?',NULL,NULL,NULL),
      T_TIPO_DATA('081','¿tiene cedula de habitabilidad?',NULL,NULL,NULL),
      T_TIPO_DATA('082','Fecha obtención Cédula Habitabilidad','ACT_ADO_ADMISION_DOCUMENTO','ADO_FECHA_OBTENCION','ACT_ID'),
      T_TIPO_DATA('083','¿Tiene Certificado energetico?',NULL,NULL,NULL),
      T_TIPO_DATA('084','¿tienen informe 0?',NULL,NULL,NULL),
      T_TIPO_DATA('085','Destino Comercial Objetivo (Mayorista/minorista)','ACT_APU_ACTIVO_PUBLICACION','DD_POR_ID','ACT_ID'),
      T_TIPO_DATA('086','Estado comercial','ACT_ACTIVO','DD_SCM_ID','ACT_ID'),
      T_TIPO_DATA('087','Orden de publicación Minorista (instrucción enviada por SAREB para publicar)',NULL,NULL,NULL),
      T_TIPO_DATA('088','Orden de publicación Mayorista (instrucción enviada por SAREB para publicar)',NULL,NULL,NULL),
      T_TIPO_DATA('089','Bloqueo',NULL,NULL,NULL),
      T_TIPO_DATA('090','Motivo Bloqueo',NULL,NULL,NULL),
      T_TIPO_DATA('091','Código Agrupación Obra nueva','ACT_AGR_AGRUPACION','AGR_COD_ON_SAREB','AGR_ID'),
      T_TIPO_DATA('092','¿Tiene CFO?',NULL,NULL,NULL),
      T_TIPO_DATA('093','Fecha CFO','ACT_REG_INFO_REGISTRAL','REG_FECHA_CFO','ACT_ID'),
      T_TIPO_DATA('094','¿Tiene LPO?',NULL,NULL,NULL),
      T_TIPO_DATA('095','Fecha LPO','ACT_ADO_ADMISION_DOCUMENTO','ADO_FECHA_OBTENCION','ACT_ID'),
      T_TIPO_DATA('096','Tapiado','ACT_SPS_SIT_POSESORIA','SPS_ACC_TAPIADO','ACT_ID'),
      T_TIPO_DATA('097','Estado adecuación','ACT_PTA_PATRIMONIO_ACTIVO','DD_ADA_ID','ACT_ID'),
      T_TIPO_DATA('098','Fecha prevista fin adecuación',NULL,NULL,NULL),
      T_TIPO_DATA('099','Precio de Venta WEB','ACT_VAL_VALORACIONES','DD_TPC_ID','ACT_ID'),
      T_TIPO_DATA('100','Precio de Renta WEB','ACT_VAL_VALORACIONES','DD_TPC_ID','ACT_ID'),
      T_TIPO_DATA('101','Precio Minimo Autorizado Venta','ACT_VAL_VALORACIONES','DD_TPC_ID','ACT_ID'),
      T_TIPO_DATA('102','¿tiene Tasacion?',NULL,NULL,NULL),
      T_TIPO_DATA('103','Fecha tasación','BIE_VALORACIONES','BIE_FECHA_VALOR_TASACION','BIE_ID'),
      T_TIPO_DATA('104','Fecha solicitud tasación','BIE_VALORACIONES','BIE_F_SOL_TASACION','BIE_ID'),
      T_TIPO_DATA('105','Fecha recepción tasación','ACT_TAS_TASACION','TAS_FECHA_RECEPCION_TASACION','TAS_ID'),
      T_TIPO_DATA('106','Técnico tasadora asociado','BIE_VALORACIONES','DD_TRA_ID','BIE_ID'),
      T_TIPO_DATA('107','Importe tasación finalizado','ACT_TAS_TASACION','TAS_IMPORTE_TAS_FIN','TAS_ID'),
      T_TIPO_DATA('108','Tipo de tasación','ACT_TAS_TASACION','DD_TTS_ID','TAS_ID'),
      T_TIPO_DATA('109','Precio visible venta','ACT_VAL_VALORACIONES','DD_TPC_ID','ACT_ID'),
      T_TIPO_DATA('110','Fecha inicio vigencia precio venta','ACT_VAL_VALORACIONES','VAL_FECHA_INICIO','ACT_ID'),
      T_TIPO_DATA('111','Fecha fin vigencia precio venta','ACT_VAL_VALORACIONES','VAL_FECHA_FIN','ACT_ID'),
      T_TIPO_DATA('112','Precio visible renta','ACT_VAL_VALORACIONES','DD_TPC_ID','ACT_ID'),
      T_TIPO_DATA('113','Fecha inicio vigencia precio renta','ACT_VAL_VALORACIONES','VAL_FECHA_INICIO','ACT_ID'),
      T_TIPO_DATA('114','Fecha fin vigencia precio renta','ACT_VAL_VALORACIONES','VAL_FECHA_FIN','ACT_ID'),
      T_TIPO_DATA('115','Precio Minimo Autorizado Renta',NULL,NULL,NULL),
      T_TIPO_DATA('116','Valor unitario de la tasación relacionado con la superficie',NULL,NULL,NULL),
      T_TIPO_DATA('117','¿Es una unidad alquilable?',NULL,NULL,NULL),
      T_TIPO_DATA('118','Id activo padre UA (ID SAREB)','ACT_ACTIVO','ACT_ID','ACT_ID'),
      T_TIPO_DATA('119','¿Es Anejos Registral?','ACT_REG_INFO_REGISTRAL','TIENE_ANEJOS_REGISTRALES','ACT_ID'),
      T_TIPO_DATA('120','id activo padre Anejo registral',NULL,NULL,NULL),
      T_TIPO_DATA('121','¿es Anejo Anejos Comercial?',NULL,NULL,NULL),
      T_TIPO_DATA('122','id activo padre Anejo Comercial',NULL,NULL,NULL),
      T_TIPO_DATA('123','Adecuación alquileres','ACT_PTA_PATRIMONIO_ACTIVO','DD_ADA_ID','ACT_ID'),
      T_TIPO_DATA('124','Fecha prevista fin adecuación alquileres',NULL,NULL,NULL),
      T_TIPO_DATA('125','Número de reserva','RES_RESERVAS','RES_NUM_RESERVA','RES_ID'),
      T_TIPO_DATA('126','Fecha Contable de la reserva','RES_RESERVAS','RES_FECHA_FIRMA','RES_ID'),
      T_TIPO_DATA('126','Fecha Contable de la reserva','RES_RESERVAS','RES_FECHA_CONTABILIZACION','RES_ID'),
      T_TIPO_DATA('127','Fecha contable de la devolución de la reserva','ECO_EXPEDIENTE_COMERCIAL','ECO_FECHA_DEV_ENTREGAS','ECO_ID'),
      T_TIPO_DATA('128','Cartera','ACT_ACTIVO','DD_CRA_ID','ACT_ID'),
      T_TIPO_DATA('129','Subcartera','ACT_ACTIVO','DD_SCR_ID','ACT_ID'),
      T_TIPO_DATA('130','Precomercialización (a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('131','Fecha compromiso cliente (a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('132','Importe Comunidad Mensual (a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('133','Importe IBI Anual (a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('134','Importe Tasas Anual (a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('135','Número VAI (a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('136','Seguros del activo (Siniestro - a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('137','Ruina (a futuro)','ACT_ACTIVO','DD_EAC_ID','ACT_ID'),
      T_TIPO_DATA('138','Vandalizado (a futuro)','ACT_ACTIVO','DD_EAC_ID','ACT_ID'),
      T_TIPO_DATA('139','CEE en trámite (a futuro)',NULL,NULL,NULL),
      T_TIPO_DATA('140','Motivo','ACT_CAN_CALIFICACION_NEG','DD_MCN_ID','ACT_ID')
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
					WHERE DD_CCS_TABLA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' 
          AND DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0) AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
          IF TRIM(V_TMP_TIPO_DATA(3)) IS NOT NULL THEN
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_CCS_ID,
              DD_CCS_TABLA,
              DD_CCS_CAMPO,
              DD_CCS_CRUCE,
              DD_CCS_DESCRIPCION,
              DD_COS_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              '''||TRIM(V_TMP_TIPO_DATA(5))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0),
              0,
              ''HREOS-11215'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||'''');
          ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO]: No existe tabla de destino para '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||'''');
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

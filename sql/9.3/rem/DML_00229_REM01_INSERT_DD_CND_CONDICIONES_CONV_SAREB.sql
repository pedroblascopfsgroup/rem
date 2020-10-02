--/*
--##########################################
--## AUTOR=Joaquin Arnal 
--## FECHA_CREACION=20200721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11246
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Daniel Algaba - HREOS-10920 - Versión inicial
--## 	    0.2 Joaquin Arnal - HREOS-10499 - Añadimos Campos QUERY_ACT
--## 	    0.3 Joaquin Arnal - HREOS-11246 - Cambios en los alcances de los condicionados
--##        0.4 Joaquin Arnal - HREOS-11233 - Añadimos seis condiciones
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_CND_CONDICIONES_CONV_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ITEM VARCHAR2(2400 CHAR) := 'HREOS-10499';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('OFR_VUE', 'Si hay ofertas en vuelo', 'Si hay ofertas en vuelo'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)'
            ,'0')
            
      ,T_TIPO_DATA('OFR_NVU', 'Sino hay ofertas en vuelo', 'Sino hay ofertas en vuelo'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.tmp_conv_sareb   tmp ON tmp.act_num_activo = act.act_num_activo minus SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)'
            ,'0')
            
      , T_TIPO_DATA('MOD_REM', 'PENDIENTE - Primera modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,''
            ,''
            ,'0')
      , T_TIPO_DATA('CHK_SUB', 'Check de subrogado diferente de lo que se recibe', 'Si el check de subrogado es diferente en REM que lo que se recibe de SAREB'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''008'''' LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID WHERE ( LOWER(TMP.VALOR_NUEVO) like ''''%subrogado%'''' AND PTA.check_subrogado = 0 ) OR ( LOWER(TMP.VALOR_NUEVO) not like ''''%subrogado%'''' AND PTA.check_subrogado = 1)'
            ,'0')
      , T_TIPO_DATA('ACT_SIEMPRE_PRISMA', 'ELIMINADO - Se actualizará siempre REM con la información procedente de PRISMA salvo algún caso', 'Se actualizará siempre REM con la información procedente de PRISMA salvo en el caso de que el valor de PRISMA venga vacío y  El dato existente en REM hubiese sido modificado previamente a que las gestorías de Fase 1 trabajasen con PRISMA (fecha corte 01/06/2020)'
            ,''
            ,''
            ,'1')
            
      , T_TIPO_DATA('ELI_VAL', 'Si se elimina el valor (vacía el campo)', 'Si se elimina el valor (vacía el campo)'
            ,'AND TMP.VALOR_NUEVO is null'
            ,''
            ,'0')
      , T_TIPO_DATA('ADJ_NO', 'Si el valor es Adjudicación judicial y el valor recibido no', 'Si el valor de REM es Adjudicación judicial y el valor recibido no'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''019'''' AND TMP.VALOR_NUEVO != ''''Adjudicación judicial'''' JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND DD_TTA_CODIGO = ''''01'''''
            ,'0')
      , T_TIPO_DATA('ADN_LC_ADJ', 'Si el valor es ADN y el valor recibido es LQ colateral o ADJ', 'Si el valor de REM es Adjudicación no judicial y el valor recibido de Sareb es Liquidación de colateral o adjudicación judicial'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''019'''' AND TMP.VALOR_NUEVO in (''''Adjudicación judicial'''',''''Colateral (PDV)'''',''''Colateral – Liquidación de colaterales'''') JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND DD_TTA_CODIGO = ''''02'''''
            ,'0')
      , T_TIPO_DATA('NUE_CAR', 'Si aparecen cargas en un activo que no tenía cargas', 'Bloque datos cargas: Si aparecen cargas en un activo que no tenía cargas'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''029'''' AND TMP.VALOR_NUEVO = ''''1'''' WHERE ACT.BORRADO = 0 AND NOT EXISTS (SELECT 1 FROM ACT_CRG_CARGAS CRG WHERE CRG.BORRADO = 0 AND CRG.CRG_FECHA_CANCEL_REGISTRAL is null AND CRG.ACT_ID = ACT.ACT_ID)'
            ,'0')
      , T_TIPO_DATA('OFR_VUE_CAR', 'Si teniendo ofertas en vuelo, aparecen o desaparecen cargas', 'Bloque datos cargas: Si teniendo ofertas en vuelo, aparecen o desaparecen cargas'
            ,''
            ,'SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' WHERE OFR.BORRADO = 0 AND ACTO.ACT_ID = ACT.ACT_ID AND EXISTS (SELECT 1 from ACT_CRG_CARGAS CRG WHERE CRG.ACT_ID = ACT.ACT_ID AND CRG.FECHACREAR > OFR.OFR_FECHA_ALTA AND CRG.CRG_FECHA_CANCEL_REGISTRAL > OFR.OFR_FECHA_ALTA AND CRG.BORRADO = 0))'
            ,'0')
      , T_TIPO_DATA('CEE_OBT', 'Si el activo no tiene estado de la etiqueta de efi. energética y se recibe una S', 'Si el activo no tiene estado de la etiqueta de eficiencia energética y se recibe una S desde Sareb'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''083'''' AND TMP.VALOR_NUEVO = ''''1'''' WHERE  ACT.BORRADO = 0 AND NOT EXISTS (SELECT ACT2.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT2 JOIN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT2.ACT_ID AND ADO.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO EDC ON EDC.DD_EDC_ID = ADO.DD_EDC_ID AND EDC.DD_EDC_CODIGO != ''''01'''' JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID AND CFD.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0 AND DD_TPD_CODIGO = ''''25'''' WHERE ACT2.ACT_ID = ACT.ACT_ID)'
            ,'0')
      , T_TIPO_DATA('CEE_NOB', 'Si el activo tiene estado de la etiqueta de efi. energética y se recibe una N', 'Si el activo tiene estado de la etiqueta de eficiencia energética y se recibe una N desde Sareb'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''083'''' AND TMP.VALOR_NUEVO = ''''0'''' WHERE ACT.BORRADO = 0 AND EXISTS (SELECT ACT2.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT2 JOIN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT2.ACT_ID AND ADO.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO EDC ON EDC.DD_EDC_ID = ADO.DD_EDC_ID AND EDC.DD_EDC_CODIGO = ''''01'''' JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID AND CFD.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0 AND DD_TPD_CODIGO = ''''25'''' WHERE ACT2.ACT_ID = ACT.ACT_ID)'
            ,'0')
      , T_TIPO_DATA('ALQ_DIV', 'Si se recibe alquilado y no está alquilado o viceversa', 'Si se recibe alquilado y en REM no está alquilado o viceversa'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''007'''' AND TMP.VALOR_NUEVO = ''''1'''' JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO != ''''10'''' JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO UNION SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''007'''' AND TMP.VALOR_NUEVO != ''''S'''' JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''''10'''' JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO'
            ,'0')
      , T_TIPO_DATA('RES_DIV', 'Si se recibe reservado y el estado anterior a dicho estado, o viceversa', 'Si se recibe reservado y el estado en REM es anterior a dicho estado, o viceversa'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID and OFR.BORRADO = 0 JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID and ECO.BORRADO = 0 WHERE ACT.BORRADO = 0'
            ,'0')
      , T_TIPO_DATA('INT_MOD', 'Si se modifica el valor existente en REM', 'Si se modifica el valor existente en REM'
            ,''
            ,''
            ,'0')            
            
        , T_TIPO_DATA('MOD_EFA', 'Si se modifica el valor existente en REM para estado físico del activo', 'Si se modifica el valor existente en REM para estado físico del activo'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''011'''' JOIN '||V_ESQUEMA||'.dd_eac_estado_activo eac ON eac.DD_eac_ID = ACT.DD_eac_ID WHERE TMP.VALOR_NUEVO != eac.DD_eac_ID'
            ,'0')   
        , T_TIPO_DATA('MOD_FIN', 'Si se modifica el valor existente en REM para la fecha de inscripción', 'Si se modifica el valor existente en REM para la fecha de inscripción'
            ,''
            ,'SELECT distinct ACT.ACT_ID 
                FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''018'''' minus SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''018'''' JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID = ACT.ACT_ID AND TIT.BORRADO = 0 WHERE TMP.VALOR_NUEVO = to_char(TIT.TIT_FECHA_INSC_REG,''''YYYYMMDD'''')'
            ,'0')
        , T_TIPO_DATA('VAC_FIN', 'Si se elimina el valor -vacía el campo- para la fecha de inscripción', 'Si se elimina el valor -vacía el campo- para la fecha de inscripción'
            ,''
            ,'SELECT distinct ACT.ACT_ID 
                FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''018''''  WHERE TMP.VALOR_NUEVO is null'
            ,'0')
        , T_TIPO_DATA('MOD_FTP', 'Si se modifica el valor existente en REM para la fecha de toma de posesión', 'Si se modifica el valor existente en REM para la fecha de toma de posesión'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''021'''' minus SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''021'''' JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = SPS.ACT_ID and SPS.BORRADO = 0 WHERE TMP.VALOR_NUEVO = to_char(SPS.SPS_FECHA_TOMA_POSESION,''''YYYYMMDD'''')'
            ,'0')
        , T_TIPO_DATA('VAC_FTP', 'Si se elimina el valor (vacía el campo) para la fecha de toma posesión', 'Si se elimina el valor (vacía el campo) para la fecha de toma posesión'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''021'''' WHERE TMP.VALOR_NUEVO is null'
            ,'0')
        , T_TIPO_DATA('MOD_TAP', 'Si se modifica el valor existente en REM para Tapiado', 'Si se modifica el valor existente en REM para Tapiado'
            ,''
            ,'SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''021'''' minus SELECT distinct ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO AND TMP.ORIGEN = ''''021'''' JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = SPS.ACT_ID and SPS.BORRADO = 0 WHERE TMP.VALOR_NUEVO = SPS.SPS_ACC_TAPIADO'
            ,'0')
            
            
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
					WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
          DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
          
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
              SET
                DD_CND_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                DD_CND_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                QUERY = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                USUARIOMODIFICAR = '''||V_ITEM||''',
                FECHAMODIFICAR = SYSDATE,
                QUERY_ACT = '''||TRIM(V_TMP_TIPO_DATA(5))||''',
                BORRADO = '''||TRIM(V_TMP_TIPO_DATA(6))||'''
              WHERE 
                DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
              ';
          
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha actualizado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||''''); 
        ELSE
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

          DBMS_OUTPUT.PUT_LINE('[INFO]: '''||TRIM(V_TMP_TIPO_DATA(4))||'''');
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                            DD_CND_ID,
                            DD_CND_CODIGO,
                            DD_CND_DESCRIPCION,
                            DD_CND_DESCRIPCION_LARGA,
                            QUERY,
                            VERSION,
                            USUARIOCREAR,
                            FECHACREAR,
                            BORRADO,
                            QUERY_ACT	
              ) VALUES (
              '||V_ID||',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              0,
              ''HREOS-10920'',
              SYSDATE,
              '''||TRIM(V_TMP_TIPO_DATA(6))||''',
              '''||TRIM(V_TMP_TIPO_DATA(5))||''')';
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
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

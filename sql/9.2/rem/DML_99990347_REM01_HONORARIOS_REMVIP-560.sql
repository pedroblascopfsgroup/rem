--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180627
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-560
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TTF_TIPO_TARIFA los datos añadidos en T_ARRAY_DATA
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
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-560';
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('04','02','02','1','0','0'),
    T_TIPO_DATA('04','02','01','1','0','0'),
    T_TIPO_DATA('30','02','02','1','0',null),
    T_TIPO_DATA('30','02','01','1','0',null),
    T_TIPO_DATA('31','02','02','1','0',null),
    T_TIPO_DATA('31','02','01','1','0',null),
    T_TIPO_DATA('28','02','02','1','0','6'),
    T_TIPO_DATA('28','02','01','1','0','6'),
    T_TIPO_DATA('29','02','02','1','0','6'),
    T_TIPO_DATA('29','02','01','1','0','6')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN 

  DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- LOOP para insertar los valores en DD_TTF_TIPO_TARIFA -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TRF_TRF_PRC_HONORARIOS] ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP

    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    --Insertamos o actualizamos en ACT_CFT_CONFIG_TARIFA
    V_MSQL := 'MERGE INTO REM01.TRF_TRF_PRC_HONORARIOS T1
      USING (
          SELECT TRF.TRF_ID, '''||V_TMP_TIPO_DATA(1)||''' DD_TPR_CODIGO, '''||V_TMP_TIPO_DATA(2)||''' DD_CLA_CODIGO
              , '''||V_TMP_TIPO_DATA(3)||''' DD_SCA_CODIGO, '||V_TMP_TIPO_DATA(4)||' TRF_LLAVES_HRE
              , '||V_TMP_TIPO_DATA(5)||' TRF_PRC_COLAB, '||V_TMP_TIPO_DATA(6)||' TRF_PRC_PRESC
          FROM DUAL
          LEFT JOIN REM01.TRF_TRF_PRC_HONORARIOS TRF ON TRF.DD_TPR_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
              AND TRF.DD_CLA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' 
              AND TRF.DD_SCA_CODIGO = '''||V_TMP_TIPO_DATA(3)||''' 
              AND TRF.TRF_LLAVES_HRE = '||V_TMP_TIPO_DATA(4)||'
          ) T2
      ON (T1.TRF_ID = T2.TRF_ID)
      WHEN MATCHED THEN UPDATE SET
          T1.TRF_PRC_COLAB = T2.TRF_PRC_COLAB, T1.TRF_PRC_PRESC = T2.TRF_PRC_PRESC
      WHEN NOT MATCHED THEN INSERT (T1.TRF_ID, T1.DD_CLA_CODIGO, T1.DD_SCA_CODIGO, T1.TRF_LLAVES_HRE
          , T1.DD_TPR_CODIGO, T1.TRF_PRC_COLAB, T1.TRF_PRC_PRESC)
      VALUES (REM01.S_TRF_TRF_PRC_HONORARIOS.NEXTVAL, T2.DD_CLA_CODIGO, T2.DD_SCA_CODIGO, T2.TRF_LLAVES_HRE
          , T2.DD_TPR_CODIGO, T2.TRF_PRC_COLAB, T2.TRF_PRC_PRESC)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTRO INSERTADO/ACTUALIZADO CORRECTAMENTE');

  END LOOP;

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: TRF_TRF_PRC_HONORARIOS ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(V_MSQL);
    DBMS_OUTPUT.put_line(err_msg);
    ROLLBACK;
    RAISE;          
END;
/
EXIT

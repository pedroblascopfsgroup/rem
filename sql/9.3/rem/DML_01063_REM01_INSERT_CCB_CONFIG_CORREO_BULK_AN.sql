--/*
--##########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20221020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17983
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade CCB_CONFIG_CORREO_BULK_AN
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_MAIL VARCHAR2(50 CHAR):= 'pruebashrem@gmail.com';
    V_ENTORNO NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-17983';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('DID','divarian_gov@haya.es'),
      T_TIPO_DATA('DID','scampillo@haya.es'),
      T_TIPO_DATA('DID','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('DIC','divarian_gov@haya.es'),
      T_TIPO_DATA('DIC','scampillo@haya.es'),
      T_TIPO_DATA('DIC','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('APDB','appleofertas@haya.es'),
      T_TIPO_DATA('APDB','lcarrillo@haya.es'),
      T_TIPO_DATA('APDB','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('APDO','appleofertas@haya.es'),
      T_TIPO_DATA('APDO','lcarrillo@haya.es'),
      T_TIPO_DATA('APDO','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('DRDB','divarian_gov@haya.es'),
      T_TIPO_DATA('DRDB','scampillo@haya.es'),
      T_TIPO_DATA('DRDB','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('DRDO','divarian_gov@haya.es'),
      T_TIPO_DATA('DRDO','scampillo@haya.es'),
      T_TIPO_DATA('DRDO','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('JRCC','jaguar_offer_sales@haya.es'),
      T_TIPO_DATA('JRCC','lcarrillo@haya.es'),
      T_TIPO_DATA('JRCC','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('JRDC','jaguar_offer_sales@haya.es'),
      T_TIPO_DATA('JRDC','lcarrillo@haya.es'),
      T_TIPO_DATA('JRDC','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('JRDB','jaguar_offer_sales@haya.es'),
      T_TIPO_DATA('JRDB','lcarrillo@haya.es'),
      T_TIPO_DATA('JRDB','backup.rem@pfsgroup.es'),

      T_TIPO_DATA('JRDO','jaguar_offer_sales@haya.es'),
      T_TIPO_DATA('JRDO','lcarrillo@haya.es'),
      T_TIPO_DATA('JRDO','backup.rem@pfsgroup.es')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL := 'SELECT CASE
                  WHEN SYS_CONTEXT ( ''USERENV'', ''DB_NAME'' ) = ''orarem'' THEN 1
                  ELSE 0
                  END AS ES_PRO
              FROM DUAL';

        EXECUTE IMMEDIATE V_MSQL INTO V_ENTORNO;

        IF V_ENTORNO = 1 THEN 
       
          V_MAIL:= TRIM(V_TMP_TIPO_DATA(2));

        END IF;



    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    

        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) 
        FROM '||V_ESQUEMA||'.CCB_CONFIG_CORREO_BULK_AN CCB
        LEFT JOIN '||V_ESQUEMA||'.DD_TBK_TIPO_BULK_AN TBK ON CCB.DD_TBK_ID = TBK.DD_TBK_ID AND TBK.BORRADO = 0
        WHERE TBK.DD_TBK_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
        AND CCB.CORREO = '''||V_MAIL||'''
        AND CCB.BORRADO = 0
        ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --1 existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN	

          DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE : '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''||V_MAIL||'''');  

        ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''||V_MAIL||'''');  

          V_MSQL := '

            INSERT INTO '|| V_ESQUEMA ||'.CCB_CONFIG_CORREO_BULK_AN CCB
            (
              CCB_ID
              , DD_TBK_ID
              , CORREO
              , USUARIOCREAR
              , FECHACREAR
            )
            SELECT
            '|| V_ESQUEMA ||'.S_CCB_CONFIG_CORREO_BULK_AN.NEXTVAL
            , (SELECT TBK.DD_TBK_ID FROM '||V_ESQUEMA||'.DD_TBK_TIPO_BULK_AN TBK WHERE TBK.DD_TBK_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
            , '''||V_MAIL||'''
            , '''||TRIM(V_ITEM)||'''
            , SYSDATE
            FROM DUAL
          ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  MODIFICADO CORRECTAMENTE ');
   

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

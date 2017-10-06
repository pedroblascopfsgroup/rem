--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20170929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2927
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CCC_CONFIG_CTAS_CONTABLES los datos añadidos en T_ARRAY_DATA
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
    V_TABLA VARCHAR2(50 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- El último valor 'isAllYears' indica si poner la cuenta entre los años 2012-2017. Si el valor es 1 -> 2012-2017; si es 0 -> solo 2017
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(    
        --                      DD_STG_CODIGO,  DD_CRA_CODIGO   PRO_CODIGO_UVEM         CUENTA_CONTABLE,        CCC_ARRENDAMIENTO, isAllYears   
                -- Tipo gasto: TASA
                T_TIPO_DATA('13'                        ,'02'                   ,''                                     ,'6310000000'           ,'0'                            ,'1'),
                T_TIPO_DATA('14'                        ,'02'                   ,''                                     ,'6310000000'           ,'0'                            ,'1'),
                T_TIPO_DATA('17'                        ,'02'                   ,''                                     ,'6310000000'           ,'0'                            ,'1')
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');
        
         
    -- LOOP para insertar los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES; PARA SAREB');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        FOR anyo IN 2012 .. 2017
         LOOP
                V_TMP_TIPO_DATA := V_TIPO_DATA(I);
                
                V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES 
                                                WHERE 
                                                        DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') AND  
                                                        DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND  
                                                        EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||''') AND 
                                                        CCC_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_DATA(5))||''' ';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
                
                IF V_NUM_TABLAS > 0 THEN
                        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES 
                                                SET
                                                        CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(4))||''', USUARIOMODIFICAR = ''HREOS-2927'', FECHAMODIFICAR = SYSDATE  
                                                WHERE 
                                                        DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') AND 
                                                        DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND 
                                                        EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||''') AND
                                                        CCC_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_DATA(5))||''' ';
                                EXECUTE IMMEDIATE V_MSQL;
                                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| I ||'] ACTUALIZADO CORRECTAMENTE - EJECICIO '||anyo);
                ELSE
                        -- SI isAllYears está activado, o si el año a introducir es el actual, sino, no inserta.
                        IF (V_TMP_TIPO_DATA(6) = 1 OR  (V_TMP_TIPO_DATA(6) = 0 AND anyo = 2017)) THEN
         
                                        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL FROM DUAL';
                                        EXECUTE IMMEDIATE V_MSQL INTO V_ID;     
                                        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES (' ||
                                                    'CCC_ID, DD_STG_ID, DD_CRA_ID, PRO_ID, EJE_ID, CCC_CUENTA_CONTABLE, CCC_ARRENDAMIENTO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                                                      '('|| V_ID || ',
                                                                          (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                                                                          (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                                                                          (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO INNER JOIN '||V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON PRO.DD_CRA_ID = CRA.DD_CRA_ID 
                                                                                        WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(3)||''' AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                                                                          (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||'''),
                                                      '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                                                      '''||TRIM(V_TMP_TIPO_DATA(5))||''',
                                                       0, ''HREOS-2927'',SYSDATE,0 )';
                                        EXECUTE IMMEDIATE V_MSQL;
                                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| I ||'] INSERTADO CORRECTAMENTE - EJECICIO '||anyo);
        
                            END IF;
                        END IF;
                        
                END LOOP;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CCC_CONFIG_CTAS_CONTABLES ACTUALIZADA CORRECTAMENTE ');
   
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

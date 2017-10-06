--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20170929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2927
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CPP_CONFIG_PTDAS_PREP los datos añadidos en T_ARRAY_DATA.
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
    V_TABLA VARCHAR2(50 CHAR) := 'CPP_CONFIG_PTDAS_PREP';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARATIDAS PARA ANYO EN CURSO (2017)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(   
        --                      EJE_ANYO        DD_STG_COD      DD_CRA_COD      DD_SCR_COD      PRO_COD PVE_COD CPP_PARTIDA_PRESUPUESTARIA      CPP_ARRENDAMIENTO
                -- Tipo gasto: TASA
                T_TIPO_DATA('2017'              ,'13'           ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
                T_TIPO_DATA('2017'              ,'14'           ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
                T_TIPO_DATA('2017'              ,'17'           ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
                T_TIPO_DATA('2017'              ,'18'           ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
                -- Tipo gasto: OTROS TRIBUTOS
                T_TIPO_DATA('2017'              ,'19'           ,'02'           ,''                     ,''             ,''             ,'G011383','0')                                                   
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    -- PARTIDAS PARA ANYOS ANTERIORES (2012-2016)
    TYPE T_ARRAY_ANTERIOR IS TABLE OF T_TIPO_DATA;
    V_TIPO_ANTERIOR T_ARRAY_ANTERIOR := T_ARRAY_ANTERIOR(
        --                      DD_STG_COD      DD_CRA_COD      DD_SCR_COD      PRO_COD PVE_COD CPP_PARTIDA_PRESUPUESTARIA      CPP_ARRENDAMIENTO
        -- Tipo gasto: IMPUESTO
        T_TIPO_DATA('13'                ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
        T_TIPO_DATA('14'                ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
        T_TIPO_DATA('17'                ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
        T_TIPO_DATA('18'                ,'02'           ,''                     ,''             ,''             ,'G011383','0'),
                -- Tipo gasto: OTROS TRIBUTOS
        T_TIPO_DATA('19'                ,'02'           ,''                     ,''             ,''             ,'G011383','0')
    ); 
    V_TMP_TIPO_ANTERIOR T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');
        

         
    -- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP -----  EJECICIO 2017   -------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP - EJECICIO 2017 ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP 
                                        WHERE 
                                                DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND  
                                                DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(3)||''') AND                                                  
                                                EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = 2017) AND 
                                                CPP_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_DATA(8))||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP 
                                        SET
                                                CPP_PARTIDA_PRESUPUESTARIA = '''||TRIM(V_TMP_TIPO_DATA(7))||''', USUARIOMODIFICAR = ''HREOS-2927'', FECHAMODIFICAR = SYSDATE  
                                        WHERE 
                                                DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND 
                                                DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(3)||''') AND 
                                                EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = 2017) AND
                                                CPP_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_DATA(8))||''' ';

                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| I ||'] ACTUALIZADO CORRECTAMENTE - EJECICIO 2017');
        ELSE        
       
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '||I);   
            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID; 
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP (' ||
                        'CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, PVE_ID, CPP_PARTIDA_PRESUPUESTARIA, CPP_ARRENDAMIENTO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                          '('|| V_ID || ',
                          (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_TMP_TIPO_DATA(1)||'''),
                                           (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                                           (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
                                           (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''),
                                           (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(5)||'''),
                                           (SELECT PVE_ID FROM '||V_ESQUEMA ||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(6)||'''),
                          '''||TRIM(V_TMP_TIPO_DATA(7))||''', '||V_TMP_TIPO_DATA(8) ||'
                          , 0, ''HREOS-2927'',SYSDATE,0 )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');


          END IF;
          
   END LOOP;   
    -- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP -----  EJECICIO 2012-2016   -------------------------------------------  
    FOR anyo IN 2012 .. 2016
     LOOP
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP - EJECICIO '||anyo);
        FOR I IN V_TIPO_ANTERIOR.FIRST .. V_TIPO_ANTERIOR.LAST  
         LOOP

  
            V_TMP_TIPO_ANTERIOR := V_TIPO_ANTERIOR(I);
      
            V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP 
                                        WHERE 
                                                DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_ANTERIOR(1)||''') AND  
                                                DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_ANTERIOR(2)||''') AND                                                  
                                                EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||''') AND 
                                                CPP_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_ANTERIOR(7))||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        
        IF V_NUM_TABLAS > 0 THEN
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP 
                                        SET
                                                CPP_PARTIDA_PRESUPUESTARIA = '''||TRIM(V_TMP_TIPO_ANTERIOR(6))||''', USUARIOMODIFICAR = ''HREOS-2927'', FECHAMODIFICAR = SYSDATE  
                                        WHERE 
                                                DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_ANTERIOR(1)||''') AND 
                                                DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_ANTERIOR(2)||''') AND 
                                                EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||''') AND
                                                CPP_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_ANTERIOR(7))||''' ';

                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| I ||'] ACTUALIZADO CORRECTAMENTE - EJECICIO '''||anyo||''' ');
        ELSE     
      
                    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '||I);   
                    V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL FROM DUAL';

                    EXECUTE IMMEDIATE V_MSQL INTO V_ID;
                    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP (' ||
                    'CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, PVE_ID, CPP_PARTIDA_PRESUPUESTARIA, CPP_ARRENDAMIENTO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                      '('|| V_ID || ',
                      (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||'''),
                      (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_ANTERIOR(1)||'''),
                      (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_ANTERIOR(2)||'''),
                      (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_ANTERIOR(3)||'''),
                      (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_ANTERIOR(4)||'''),
                      (SELECT PVE_ID FROM '||V_ESQUEMA ||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_ANTERIOR(5)||'''),
                      '''||TRIM(V_TMP_TIPO_ANTERIOR(6))||''',
                       0,0, ''HREOS-2927'',SYSDATE,0 )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
        END IF;            
                    
        END LOOP;
    END LOOP;
 
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CPP_CONFIG_PTDAS_PREP ACTUALIZADA CORRECTAMENTE ');
   

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


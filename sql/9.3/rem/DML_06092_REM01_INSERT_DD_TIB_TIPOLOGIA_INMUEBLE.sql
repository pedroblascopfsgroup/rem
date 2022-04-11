--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9459
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla DD_TIB_TIPOLOGIA_INMUEBLE CON TRUNCATE
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_TIB_TIPOLOGIA_INMUEBLE';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9459';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_TPA_ID NUMBER(16);
    V_SAC_ID NUMBER(16);
    V_EAC_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --DD_EAC_CODIGO   DD_TPA_CODIGO   DD_SAC_CODIGO   COD_BBVA   DESC_BBVA
    T_TIPO_DATA('02','02','05','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','02','06','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','02','07','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','02','08','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','02','09','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','02','10','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','02','11','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','02','12','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','03','13','80','RESTO - OBRA EN CURSO'),
    T_TIPO_DATA('02','03','14','80','RESTO - OBRA EN CURSO'),
    T_TIPO_DATA('02','03','15','80','RESTO - OBRA EN CURSO'),
    T_TIPO_DATA('02','03','16','80','RESTO - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','24','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','25','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','26','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('02','03','28','80','RESTO - OBRA EN CURSO'),
    T_TIPO_DATA('02','03','29','80','RESTO - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','35','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','36','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','38','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','40','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','41','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('06','02','05','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','02','06','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','02','07','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','02','08','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','02','09','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','02','10','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','02','11','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','02','12','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','03','13','89','LOCALES - OBRA PARADA'),
    T_TIPO_DATA('06','03','14','91','OFICINAS - OBRA PARADA'),
    T_TIPO_DATA('06','03','16','94','HOTELES - OBRA PARADA'),
    T_TIPO_DATA('06','04','17','90','NAVES - OBRA PARADA'),
    T_TIPO_DATA('06','04','18','90','NAVES - OBRA PARADA'),
    T_TIPO_DATA('06','05','20','94','HOTELES - OBRA PARADA'),
    T_TIPO_DATA('06','07','24','87','GARAJE - OBRA PARADA'),
    T_TIPO_DATA('06','07','25','88','TRASTERO - OBRA PARADA'),
    T_TIPO_DATA('06','09','33','92','GARAJE-TRASTERO TERCIARIO - OBRA PARADA'),
    T_TIPO_DATA('06','04','37','90','NAVES - OBRA PARADA'),
    T_TIPO_DATA('06','07','40','86','VIVIENDA - OBRA PARADA'),
    T_TIPO_DATA('06','05','21','91','OFICINAS - OBRA PARADA'),
    T_TIPO_DATA('NULL','01','01','82','SUELO - RUSTICO '),
    T_TIPO_DATA('NULL','01','02','81','SUELO'),
    T_TIPO_DATA('NULL','01','03','81','SUELO'),
    T_TIPO_DATA('NULL','01','04','81','SUELO'),
    T_TIPO_DATA('NULL','02','05','84','VIVIENDA'),
    T_TIPO_DATA('NULL','02','06','84','VIVIENDA'),
    T_TIPO_DATA('NULL','02','07','84','VIVIENDA'),
    T_TIPO_DATA('NULL','02','08','84','VIVIENDA'),
    T_TIPO_DATA('NULL','02','09','84','VIVIENDA'),
    T_TIPO_DATA('NULL','02','10','84','VIVIENDA'),
    T_TIPO_DATA('NULL','02','11','84','VIVIENDA'),
    T_TIPO_DATA('NULL','02','12','84','VIVIENDA'),
    T_TIPO_DATA('NULL','03','13','76','LOCALES'),
    T_TIPO_DATA('NULL','03','14','79','OFICINAS'),
    T_TIPO_DATA('NULL','03','15','77','NAVES'),
    T_TIPO_DATA('NULL','03','16','75','HOTEL'),
    T_TIPO_DATA('NULL','04','17','77','NAVES'),
    T_TIPO_DATA('NULL','04','18','77','NAVES'),
    T_TIPO_DATA('NULL','05','22','76','LOCALES'),
    T_TIPO_DATA('NULL','07','25','83','TRASTERO'),
    T_TIPO_DATA('NULL','07','26','72','GARAJE'),
    T_TIPO_DATA('NULL','09','33','73','GARAJE-TRASTERO TERCIARIO'),
    T_TIPO_DATA('NULL','01','27','82','SUELO - RUSTICO '),
    T_TIPO_DATA('NULL','08','30','77','NAVES'),
    T_TIPO_DATA('NULL','08','32','76','LOCALES'),
    T_TIPO_DATA('NULL','07','40','84','VIVIENDA'),
    T_TIPO_DATA('NULL','07','41','75','HOTEL'),
    T_TIPO_DATA('NULL','01','42','81','SUELO'),
    T_TIPO_DATA('NULL','05','43','84','VIVIENDA')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  --############@@@@@@@@@#########  CUIDADO HAY UN TRUNCATE AQUI | ############
  --                                                             V
	V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
  EXECUTE IMMEDIATE V_SQL;
  COMMIT;
  --############TRUNCATE#############

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        IF V_TMP_TIPO_DATA(1) != 'NULL' THEN
        
          --sacamos dd_sac ,dd_tpa y dd_eac
          V_SQL := 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
          
          EXECUTE IMMEDIATE V_SQL INTO V_TPA_ID; 
          
          
          V_SQL := 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_SAC_ID;

          V_SQL := 'SELECT DD_EAC_ID FROM '|| V_ESQUEMA ||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_EAC_ID;
          
          
          --Comprobamos el dato a insertar
          V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'||V_TABLA||' WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND  DD_SAC_ID = '''||V_SAC_ID||'''
                    AND  DD_EAC_ID = '''||V_EAC_ID||''' AND DD_TIB_CODIGO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0';
                          
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          --Si existe lo modificamos
          IF V_NUM_TABLAS > 0 THEN				
            
          DBMS_OUTPUT.PUT_LINE('[WARN]: YA EXISTE EL REGISTRO '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||' - '||V_TMP_TIPO_DATA(4)||' - '||V_TMP_TIPO_DATA(5)||' ');
            
        --Si no existe, lo insertamos   
          ELSE
        
            V_MSQL := ' INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
                  DD_TIB_ID,
                  DD_TPA_ID,
                  DD_SAC_ID,
                  DD_EAC_ID,
                  DD_TIB_CODIGO,
                  DD_TIB_DESCRIPCION,
                  DD_TIB_DESCRIPCION_LARGA,
                  USUARIOCREAR, 
                  FECHACREAR
                    ) VALUES (
                    '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
                    '||V_TPA_ID||','||V_SAC_ID||','||V_EAC_ID||',
                    '''||V_TMP_TIPO_DATA(4)||''',
                    '''||V_TMP_TIPO_DATA(5)||''',
                    '''||V_TMP_TIPO_DATA(5)||''',
                    '''||V_USUARIO||''',
                    SYSDATE                   
                        )';   
            EXECUTE IMMEDIATE V_MSQL;          
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE: '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||' - '||V_TMP_TIPO_DATA(4)||' - '||V_TMP_TIPO_DATA(5)||'');
          
        END IF;

       ELSE
       --############################### CASO DD_EAC NULO ############################
                  --sacamos dd_sac ,dd_tpa 
          V_SQL := 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
          
          EXECUTE IMMEDIATE V_SQL INTO V_TPA_ID; 
          
          
          V_SQL := 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_SAC_ID;
          
          
          --Comprobamos el dato a insertar
          V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'||V_TABLA||' WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND  DD_SAC_ID = '''||V_SAC_ID||'''
                    AND DD_EAC_ID IS NULL AND DD_TIB_CODIGO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0';
                          
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          --Si existe lo modificamos
          IF V_NUM_TABLAS > 0 THEN				
            
            DBMS_OUTPUT.PUT_LINE('[WARN]: YA EXISTE EL REGISTRO '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||' - '||V_TMP_TIPO_DATA(4)||' - '||V_TMP_TIPO_DATA(5)||' ');

            
        --Si no existe, lo insertamos   
        ELSE
        
          V_MSQL := ' INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
                  DD_TIB_ID,
                  DD_TPA_ID,
                  DD_SAC_ID,
                  DD_TIB_CODIGO,
                  DD_TIB_DESCRIPCION,
                  DD_TIB_DESCRIPCION_LARGA,
                  USUARIOCREAR, 
                  FECHACREAR
                  ) VALUES (
                  '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
                  '||V_TPA_ID||',
                  '||V_SAC_ID||',
                  '''||V_TMP_TIPO_DATA(4)||''',
                  '''||V_TMP_TIPO_DATA(5)||''',
                  '''||V_TMP_TIPO_DATA(5)||''',
                  '''||V_USUARIO||''',
                  SYSDATE                   
                        )';   
            EXECUTE IMMEDIATE V_MSQL;          
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE: '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||' - '||V_TMP_TIPO_DATA(4)||' - '||V_TMP_TIPO_DATA(5)||'');
          END IF;
        END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');


EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

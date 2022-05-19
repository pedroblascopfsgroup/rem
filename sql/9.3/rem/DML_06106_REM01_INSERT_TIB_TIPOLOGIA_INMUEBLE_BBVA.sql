--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11493
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
    V_TABLA VARCHAR2(30 CHAR) := 'TIB_TIPOLOGIA_INMUEBLE_BBVA';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-11641';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_TPA_ID NUMBER(16);
    V_SAC_ID NUMBER(16);
    V_EAC_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --DD_TPA_CODIGO   DD_SAC_CODIGO   COD_BBVA   DESC_BBVA  TIB_DESCRIPCION_ACOGE   TIB_TIPOLOGIA_BBVA
T_TIPO_DATA('05','43','01','Vivienda','NULL','NULL')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        IF V_TMP_TIPO_DATA(6) != 'NULL' THEN
        
          --sacamos dd_sac ,dd_tpa y dd_eac
          V_SQL := 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
          
          EXECUTE IMMEDIATE V_SQL INTO V_TPA_ID; 
          
          
          V_SQL := 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_SAC_ID;
          
          --Comprobamos el dato a insertar
          V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'||V_TABLA||' WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND  DD_SAC_ID = '''||V_SAC_ID||'''
                    AND TIB_CODIGO_SGITAS = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0';
                          
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          --Si existe lo modificamos
          IF V_NUM_TABLAS > 0 THEN				
            
          DBMS_OUTPUT.PUT_LINE('[WARN]: YA EXISTE EL REGISTRO '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||' ');
            
        --Si no existe, lo insertamos   
          ELSE
        
            V_MSQL := ' INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
                  TIB_ID,
                  DD_TPA_ID,
                  DD_SAC_ID,
                  TIB_CODIGO_SGITAS,
                  TIB_DESCRIPCION_SGITAS,
                  TIB_DESCRIPCION_ACOGE,
                  TIB_TIPOLOGIA_BBVA,
                  USUARIOCREAR, 
                  FECHACREAR
                    ) VALUES (
                    '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
                    '||V_TPA_ID||','||V_SAC_ID||',
                    '''||V_TMP_TIPO_DATA(3)||''',
                    '''||V_TMP_TIPO_DATA(4)||''',
                    '''||V_TMP_TIPO_DATA(5)||''',
                    '''||V_TMP_TIPO_DATA(6)||''',
                    '''||V_USUARIO||''',
                    SYSDATE                   
                        )';   
            EXECUTE IMMEDIATE V_MSQL;          
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE: '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||'');
          
        END IF;

       ELSE
       --############################### CASO TIB_TIPOLOGIA_BBVA A NULO ############################
                  --sacamos dd_sac ,dd_tpa 
          V_SQL := 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
          
          EXECUTE IMMEDIATE V_SQL INTO V_TPA_ID; 
          
          
          V_SQL := 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_SAC_ID;
          
          
          --Comprobamos el dato a insertar
          V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'||V_TABLA||' WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND  DD_SAC_ID = '''||V_SAC_ID||'''
                    AND TIB_CODIGO_SGITAS = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0';
                          
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          --Si existe lo modificamos
          IF V_NUM_TABLAS > 0 THEN				
            
            DBMS_OUTPUT.PUT_LINE('[WARN]: YA EXISTE EL REGISTRO '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||' ');

            
        --Si no existe, lo insertamos   
        ELSE
        
          V_MSQL := ' INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
                TIB_ID,
                DD_TPA_ID,
                DD_SAC_ID,
                TIB_CODIGO_SGITAS,
                TIB_DESCRIPCION_SGITAS,
                USUARIOCREAR, 
                FECHACREAR
                  ) VALUES (
                  '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
                  '||V_TPA_ID||','||V_SAC_ID||',
                  '''||V_TMP_TIPO_DATA(3)||''',
                  '''||V_TMP_TIPO_DATA(4)||''',
                  '''||V_USUARIO||''',
                  SYSDATE                   
                      )';     
            EXECUTE IMMEDIATE V_MSQL;          
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE: '||V_TMP_TIPO_DATA(1)||' - '||V_TMP_TIPO_DATA(2)||' - '||V_TMP_TIPO_DATA(3)||'');
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
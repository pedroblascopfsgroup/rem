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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-11493';
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
T_TIPO_DATA('01','01','07','Terreno rústico','Suelo Rústico','A20'),
T_TIPO_DATA('01','02','09','Terreno Residencial','Suelo Rústico','A20'),
T_TIPO_DATA('01','03','09','Terreno Residencial','Suelo Rústico','A20'),
T_TIPO_DATA('01','04','09','Terreno Residencial','Suelo Rústico','A20'),
T_TIPO_DATA('02','05','01','Vivienda','Vivienda Unifamiliar','A01'),
T_TIPO_DATA('02','06','01','Vivienda','Vivienda Unifamiliar','A01'),
T_TIPO_DATA('02','07','01','Vivienda','Vivienda Unifamiliar','A01'),
T_TIPO_DATA('02','08','01','Vivienda','Vivienda Unifamiliar','A01'),
T_TIPO_DATA('02','09','01','Vivienda','Vivienda Plurifamiliar','A02'),
T_TIPO_DATA('02','10','01','Vivienda','Vivienda Plurifamiliar','A02'),
T_TIPO_DATA('02','11','01','Vivienda','Vivienda Plurifamiliar','A02'),
T_TIPO_DATA('02','12','01','Vivienda','Vivienda Plurifamiliar','A02'),
T_TIPO_DATA('03','13','03','Local comercial','Comercial','A06'),
T_TIPO_DATA('03','14','02','Oficina','Oficina','A05'),
T_TIPO_DATA('03','15','04','Nave industrial','Almacenaje','A12'),
T_TIPO_DATA('03','16','12','Hotel','Hotelero','A07'),
T_TIPO_DATA('04','17','04','Nave industrial','Industrial','A11'),
T_TIPO_DATA('04','18','04','Nave industrial','Industrial','A11'),
T_TIPO_DATA('05','19','05','Garaje/Aparcamiento','Garaje','A03'),
T_TIPO_DATA('05','20','12','Hotel','Hotelero','A07'),
T_TIPO_DATA('05','21','04','Nave industrial','Servicios Empresariales','A13'),
T_TIPO_DATA('05','22','03','Local comercial','Comercial','A06'),
T_TIPO_DATA('06','23','01','Vivienda','Vivienda Plurifamiliar','A02'),
T_TIPO_DATA('07','24','05','Garaje/Aparcamiento','Garaje','A03'),
T_TIPO_DATA('07','25','24','Trastero','Trastero','A04'),
T_TIPO_DATA('01','27','07','Terreno rústico','NULL','NULL'),
T_TIPO_DATA('03','29','03','Local comercial','Servicios Empresariales','A13'),
T_TIPO_DATA('09','31','03','Local comercial','Asistencial','A14'),
T_TIPO_DATA('08','33','05','Garaje/Aparcamiento','Derechos','A21'),
T_TIPO_DATA('09','34','03','Local comercial','Asistencial','A14'),
T_TIPO_DATA('07','35','11','Terreno industrial','Infraestructural','A19'),
T_TIPO_DATA('04','37','04','Nave industrial','Industrial','A11'),
T_TIPO_DATA('09','39','03','Local comercial','Asistencial','A14'),
T_TIPO_DATA('07','40','01','Vivienda','NULL','NULL'),
T_TIPO_DATA('07','42','12','Hotel','NULL','NULL'),
T_TIPO_DATA('01','42','09','Terreno Residencial','NULL','NULL')

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
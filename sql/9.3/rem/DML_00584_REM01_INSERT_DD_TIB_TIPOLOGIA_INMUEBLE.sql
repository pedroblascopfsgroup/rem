--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210422
--## ARTEFACTO=online
--## VERSION_ARTEFACTO= 9.3
--## INCIDENCIA_LINK=REMVIP-9459
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla DD_TIB_TIPOLOGIA_INMUEBLE 
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
    T_TIPO_DATA('07','24','03','72','GARAJE'),
    T_TIPO_DATA('07','24','04','72','GARAJE'),
    T_TIPO_DATA('07','26','04','72','GARAJE'),
    T_TIPO_DATA('09','33','04','72','GARAJE'),
    T_TIPO_DATA('07','24','02','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('07','25','02','74','GARAJES Y TRASTEROS - OBRA EN CURSO'),
    T_TIPO_DATA('03','16','04','75','HOTEL'),
    T_TIPO_DATA('07','41','04','75','HOTEL'),
    T_TIPO_DATA('03','13','03','76','LOCALES'),
    T_TIPO_DATA('05','22','03','76','LOCALES'),
    T_TIPO_DATA('03','13','04','76','LOCALES'),
    T_TIPO_DATA('08','32','04','76','LOCALES'),
    T_TIPO_DATA('04','18','03','77','NAVES'),
    T_TIPO_DATA('03','15','04','77','NAVES'),
    T_TIPO_DATA('04','17','04','77','NAVES'),
    T_TIPO_DATA('04','18','04','77','NAVES'),
    T_TIPO_DATA('08','30','04','77','NAVES'),
    T_TIPO_DATA('02','05','06','78','OBRA PARADA'),
    T_TIPO_DATA('02','06','06','78','OBRA PARADA'),
    T_TIPO_DATA('02','07','06','78','OBRA PARADA'),
    T_TIPO_DATA('02','09','06','78','OBRA PARADA'),
    T_TIPO_DATA('03','13','06','78','OBRA PARADA'),
    T_TIPO_DATA('07','24','06','78','OBRA PARADA'),
    T_TIPO_DATA('07','25','06','78','OBRA PARADA'),
    T_TIPO_DATA('07','26','06','78','OBRA PARADA'),
    T_TIPO_DATA('03','14','04','79','OFICINAS'),
    T_TIPO_DATA('03','13','02','80','RESTO - OBRA EN CURSO'),
    T_TIPO_DATA('01','02','01','81','SUELO'),
    T_TIPO_DATA('01','03','01','81','SUELO'),
    T_TIPO_DATA('01','04','01','81','SUELO'),
    T_TIPO_DATA('01','42','01','81','SUELO'),
    T_TIPO_DATA('01','27','01','82','SUELO RUSTICO'),
    T_TIPO_DATA('07','25','03','83','TRASTERO'),
    T_TIPO_DATA('07','25','04','83','TRASTERO'),
    T_TIPO_DATA('02','05','03','84','VIVIENDA'),
    T_TIPO_DATA('02','06','03','84','VIVIENDA'),
    T_TIPO_DATA('02','07','03','84','VIVIENDA'),
    T_TIPO_DATA('02','09','03','84','VIVIENDA'),
    T_TIPO_DATA('05','43','03','84','VIVIENDA'),
    T_TIPO_DATA('02','05','04','84','VIVIENDA'),
    T_TIPO_DATA('02','06','04','84','VIVIENDA'),
    T_TIPO_DATA('02','07','04','84','VIVIENDA'),
    T_TIPO_DATA('02','09','04','84','VIVIENDA'),
    T_TIPO_DATA('02','06','02','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','07','02','85','VIVIENDA - OBRA EN CURSO'),
    T_TIPO_DATA('02','09','02','85','VIVIENDA - OBRA EN CURSO')); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
         --sacamos dd_sac ,dd_tpa y dd_eac
         V_SQL := 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
        
        EXECUTE IMMEDIATE V_SQL INTO V_TPA_ID; 
        
        
         V_SQL := 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_SAC_ID;

        V_SQL := 'SELECT DD_EAC_ID FROM '|| V_ESQUEMA ||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_EAC_ID;
        
        
         --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'||V_TABLA||' WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND  DD_SAC_ID = '''||V_SAC_ID||'''
                  AND  DD_EAC_ID = '''||V_EAC_ID||''' AND DD_TIB_CODIGO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0';
                        
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
                    SET DD_TIB_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(5))||'''
					, DD_TIB_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(5))||'''
					, USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE 
					WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND  DD_SAC_ID = '''||V_SAC_ID||'''
                  AND  DD_EAC_ID = '''||V_EAC_ID||''' AND BORRADO = 0';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
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
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
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

--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO= 9.3
--## INCIDENCIA_LINK=HREOS-13038
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla TIB_TIPOLOGIA_INMUEBLE_BBVA 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 REMVIP-8858 - Añadidas dos tipologias nuevas (tipo Suelo, subtipo No Urbanizable y  tipo Concesión Administrativa, subtipo Otros Derechos)
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
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-13038';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_TPA_ID NUMBER(16);
    V_SAC_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('07', '40', '01', '57'),
        T_TIPO_DATA('07', '41', '12', '59'),
        T_TIPO_DATA('01', '42', '09', '70'),
        T_TIPO_DATA('09', '22', '09', '71'),
        T_TIPO_DATA('01', '27', '09', '70')
); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --sacamos dd_sac y dd_tpa
         V_SQL := 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_TPA_ID;
        
         V_SQL := 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_SAC_ID;
        
        
         --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'||V_TABLA||' WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND  DD_SAC_ID = '''||V_SAC_ID||''' AND BORRADO = 0';
                        
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' '||
                    'SET TIB_CODIGO_SGITAS = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', TIB_CODIGO_ACOGE = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TPA_ID = '''||V_TPA_ID||''' AND DD_SAC_ID = '''||V_SAC_ID||''' AND BORRADO = 0';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          V_MSQL := '
                        INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
                        TIB_ID,
                        DD_TPA_ID,
                        DD_SAC_ID,
                        TIB_CODIGO_SGITAS,
                        TIB_CODIGO_ACOGE,
                        USUARIOCREAR, 
                        FECHACREAR	                       
                    ) VALUES (
                        '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
                        (SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                        (SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                        '''||V_TMP_TIPO_DATA(3)||''',
                        '''||V_TMP_TIPO_DATA(4)||''',
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

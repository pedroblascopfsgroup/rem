--/*
--######################################### 
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180306
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
        T_TIPO_DATA('52','Santander','Santander')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_EEJ_ENTIDAD_EJECUTANTE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EEJ_ENTIDAD_EJECUTANTE] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EEJ_ENTIDAD_EJECUTANTE WHERE DD_EEJ_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe no hacemos nada
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS010] El código 52 (Santander) ya existe en el DD_EEJ_ENTIDAD_EJECUTANTE. No lo insertamos.');
          EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS010'',''DML_010_REM01_INSERT_DD_EEJ_ENTIDAD_EJECUTANTE.sql'',''Para arreglar "[DICCIONARIO] El campo MIG_ADJ_JUDICIAL.ENTIDAD_EJECUTANTE no se corresponde a ningún valor del DD DD_EEJ_ENTIDAD_EJECUTANTE.DD_EEJ_CODIGO" y "[DICCIONARIO] El campo MIG_ADJ_NO_JUDICIAL.ENTIDAD_EJECUTANTE no se corresponde a ningún valor del DD DD_EEJ_ENTIDAD_EJECUTANTE.DD_EEJ_CODIGO.", creamos el valor 52 en el DD correspondiente al Santander si no existe.''
                             ,0,SYSDATE)' ;

       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_EEJ_ENTIDAD_EJECUTANTE.NEXTVAL FROM DUAL';         
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EEJ_ENTIDAD_EJECUTANTE (' ||
                      'DD_EEJ_ID, DD_EEJ_CODIGO, DD_EEJ_DESCRIPCION, DD_EEJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
                      '0, ''HREOS-5588'',SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          
          EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS010'',''DML_010_REM01_INSERT_DD_EEJ_ENTIDAD_EJECUTANTE.sql'',''Para arreglar "[DICCIONARIO] El campo MIG_ADJ_JUDICIAL.ENTIDAD_EJECUTANTE no se corresponde a ningún valor del DD DD_EEJ_ENTIDAD_EJECUTANTE.DD_EEJ_CODIGO" y "[DICCIONARIO] El campo MIG_ADJ_NO_JUDICIAL.ENTIDAD_EJECUTANTE no se corresponde a ningún valor del DD DD_EEJ_ENTIDAD_EJECUTANTE.DD_EEJ_CODIGO.", creamos el valor 52 en el DD correspondiente al Santander si no existe.''
                             ,1,SYSDATE)' ;
          DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS010] Se inserta el código 52 (Santander) en el diccionario DD_EEJ_ENTIDAD_EJECUTANTE.');
        
       END IF;
    END LOOP;
   
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EEJ_ENTIDAD_EJECUTANTE ACTUALIZADO CORRECTAMENTE ');
   
   
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

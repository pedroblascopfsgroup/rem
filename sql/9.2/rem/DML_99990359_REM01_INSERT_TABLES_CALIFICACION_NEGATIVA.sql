--/*
--##########################################
--## AUTOR=Maria Presencia
--## FECHA_CREACION=20190225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4702
--## PRODUCTO=NO
--## Finalidad: insert Tabla para gestionar el defecto inscripción.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_ID1 NUMBER(16);
    
    V_TABLA VARCHAR2 (50 CHAR) := 'DD_MCN_MOTIVO_CALIFIC_NEG';
    V_TABLA2 VARCHAR2 (50 CHAR) := 'DD_CAN_CALIFICACION_NEG';
   
    
    TYPE T_TIPO_MOT IS TABLE OF VARCHAR2(2500);
    TYPE T_ARRAY_MOT IS TABLE OF T_TIPO_MOT;
    V_TIPO_MOT T_ARRAY_MOT := T_ARRAY_MOT(
        T_TIPO_MOT('01'	,'FALTA NOTIFICACIÓN ARRENDATARIOS'	,'FALTA NOTIFICACIÓN ARRENDATARIOS'),
        T_TIPO_MOT('02'	,'PENDIENTE RATIFICAR ENTIDAD'	,'PENDIENTE RATIFICAR ENTIDAD'),
        T_TIPO_MOT('03'	,'PENDIENTE RATIFICAR HAYA'	,'PENDIENTE RATIFICAR HAYA'),
        T_TIPO_MOT('04'	,'ANOTACIÓN DE CONCURSO'	,'ANOTACIÓN DE CONCURSO'),
        T_TIPO_MOT('05'	,'AUSENCIA INDICACIÓN FIRMEZA'	,'AUSENCIA INDICACIÓN FIRMEZA'),
        T_TIPO_MOT('06'	,'ERROR IMPORTES ECONÓMICOS'	,'ERROR IMPORTES ECONÓMICOS'),
        T_TIPO_MOT('07'	,'FALTA DE DOCUMENTACIÓN CONCURSAL'	,'FALTA DE DOCUMENTACIÓN CONCURSAL'),
        T_TIPO_MOT('08'	,'ERRORES IDENTIFICATIVOS FINCAS'	,'ERRORES IDENTIFICATIVOS FINCAS'),
        T_TIPO_MOT('09'	,'TERCER POSEEDOR'	,'TERCER POSEEDOR'),
        T_TIPO_MOT('10'	,'FALTA TRACTO SUCESIVO'	,'FALTA TRACTO SUCESIVO'),
        T_TIPO_MOT('11'	,'AUSENCIA ACTA LIBERTAD ARRENDATARIOS'	,'AUSENCIA ACTA LIBERTAD ARRENDATARIOS'),
        T_TIPO_MOT('12'	,'CONTRARIO A DERECHO'	,'CONTRARIO A DERECHO'),
        T_TIPO_MOT('13'	,'PENDIENTE DE INSCRIBIR TÍTULO PREVIO'	,'PENDIENTE DE INSCRIBIR TÍTULO PREVIO'),
        T_TIPO_MOT('14'	,'PENDIENTE DE DOCUMENTACIÓN NO JUDICIAL'	,'PENDIENTE DE DOCUMENTACIÓN NO JUDICIAL'),
        T_TIPO_MOT('15'	,'FALTA AUTORIZACIÓN JUDICIAL O ADMINISTRATIVA DE VENTA'	,'FALTA AUTORIZACIÓN JUDICIAL O ADMINISTRATIVA DE VENTA'),
        T_TIPO_MOT('16'	,'PAGO PLUSVALIA'	,'PAGO PLUSVALIA'),
        T_TIPO_MOT('17'	,'SIN REQUERIR A TODOS LOS INTERVINIENTES'	,'SIN REQUERIR A TODOS LOS INTERVINIENTES'),
        T_TIPO_MOT('18'	,'EXISTENCIA DE CARGAS INTERMEDIAS'	,'EXISTENCIA DE CARGAS INTERMEDIAS'),
        T_TIPO_MOT('19'	,'LEY 1/2013: CLÁUSULAS ABUSIVAS'	,'LEY 1/2013: CLÁUSULAS ABUSIVAS'),
        T_TIPO_MOT('20'	,'LEY 9/2015: EXISTENCIA DE RECURSO DE APELACIÓN'	,'LEY 9/2015: EXISTENCIA DE RECURSO DE APELACIÓN'),
        T_TIPO_MOT('21'	,'OTROS'	,'OTROS')
	); 
    V_TMP_TIPO_MOT T_TIPO_MOT;

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01'	,'Si'	,'Si'),
        T_TIPO_DATA('02'	,'No'	,'No'),
        T_TIPO_DATA('03'	,'Subsanado'	,'Subsanado')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	-- LOOP para insertar los valores en DD_CAN_CALIFICACION_NEG -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
    FOR I IN V_TIPO_MOT.FIRST .. V_TIPO_MOT.LAST
      LOOP
      
        V_TMP_TIPO_MOT := V_TIPO_MOT(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MCN_CODIGO = '''||TRIM(V_TMP_TIPO_MOT(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_MOT(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' '||
                    'SET DD_MCN_DESCRIPCION = '''||TRIM(V_TMP_TIPO_MOT(2))||''''|| 
					', DD_MCN_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_MOT(3))||''''||
					', USUARIOMODIFICAR = ''HREOS-4702'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MCN_CODIGO = '''||TRIM(V_TMP_TIPO_MOT(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_MOT(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MCN_MOTIVO_CALIFIC_NEG.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (' ||
                      'DD_MCN_ID, DD_MCN_CODIGO, DD_MCN_DESCRIPCION, DD_MCN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_MOT(1)||''','''||TRIM(V_TMP_TIPO_MOT(2))||''','''||TRIM(V_TMP_TIPO_MOT(3))||''', 0, ''HREOS-4702'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
	 
    -- LOOP para insertar los valores en DD_CAN_CALIFICACION_NEG -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA2||'] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA2||' WHERE DD_CAN_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA2||' '||
                    'SET DD_CAN_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_CAN_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''HREOS-4702'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_CAN_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_CAN_CALIFICACION_NEG.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID1;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA2||' (' ||
                      'DD_CAN_ID, DD_CAN_CODIGO, DD_CAN_DESCRIPCION, DD_CAN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID1 || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-4702'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_CAN_CALIFICACION_NEG Y DD_MCN_MOTIVO_CALIFIC_NEG ACTUALIZADO/INSERTADO CORRECTAMENTE ');
   

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



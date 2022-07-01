--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20211126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16412
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TPR_TIPO_PROVEEDOR los datos añadidos en T_ARRAY_DATA.
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
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro. 
    V_CODIGO_REGISTRO VARCHAR2(25 CHAR); -- Vble. para obtener el codigo de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('43'	,'Procuradores'								,'Procuradores'								,'03')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TPR_TIPO_PROVEEDOR -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPR_TIPO_PROVEEDOR] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        -- Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR '||
                    'SET DD_TPR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TPR_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', DD_TEP_ID = (SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')'||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       -- Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TPR_TIPO_PROVEEDOR.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR (' ||
                      'DD_TPR_ID, DD_TPR_CODIGO, DD_TPR_DESCRIPCION, DD_TPR_DESCRIPCION_LARGA, DD_TEP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''',(SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
      
      -- Actualizar registros existentes
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Gestoría de admisión)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Gestoría de admisión''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
      	  V_SQL := 'SELECT DD_TPR_CODIGO FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Gestoría de admisión''';
      	  EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_REGISTRO;
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR '||
	                    'SET DD_TPR_DESCRIPCION = ''Gestoría'''|| 
						', DD_TPR_DESCRIPCION_LARGA = ''Gestoría'''||
						', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						', DD_TEP_ID = (SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = ''03'')'||
						'WHERE DD_TPR_CODIGO = '''||V_CODIGO_REGISTRO||'''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Gestoría de admisión), quizás ya se encuentra actualizado');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Mantenimiento)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Mantenimiento''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
      	  V_SQL := 'SELECT DD_TPR_CODIGO FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Mantenimiento''';
      	  EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_REGISTRO;
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR '||
	                    'SET DD_TPR_DESCRIPCION = ''Mantenimiento (técnico)'''|| 
						', DD_TPR_DESCRIPCION_LARGA = ''Mantenimiento (técnico)'''||
						', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						', DD_TEP_ID = (SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = ''03'')'||
						'WHERE DD_TPR_CODIGO = '''||V_CODIGO_REGISTRO||'''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Mantenimiento), quizás ya se encuentra actualizado');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Aseguradora)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Aseguradora'' AND DD_TEP_ID IS NULL';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
      	  V_SQL := 'SELECT DD_TPR_CODIGO FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Aseguradora''';
      	  EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_REGISTRO;
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR '||
	                    'SET USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						', DD_TEP_ID = (SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = ''03'')'||
						'WHERE DD_TPR_CODIGO = '''||V_CODIGO_REGISTRO||'''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Aseguradora) sin subtipo asignado, quizás ya se encuentra actualizado');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Certificadora)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Certificadora'' AND DD_TEP_ID IS NULL';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
      	  V_SQL := 'SELECT DD_TPR_CODIGO FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Certificadora''';
      	  EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_REGISTRO;
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR '||
	                    'SET USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						', DD_TEP_ID = (SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = ''03'')'||
						'WHERE DD_TPR_CODIGO = '''||V_CODIGO_REGISTRO||'''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Certificadora) sin subtipo asignado, quizás ya se encuentra actualizado');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Sociedad Tasadora)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Sociedad Tasadora'' AND DD_TEP_ID IS NULL';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
      	  V_SQL := 'SELECT DD_TPR_CODIGO FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Sociedad Tasadora''';
      	  EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_REGISTRO;
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR '||
	                    'SET USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						', DD_TEP_ID = (SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = ''03'')'||
						'WHERE DD_TPR_CODIGO = '''||V_CODIGO_REGISTRO||'''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Sociedad Tasadora) sin subtipo asignado, quizás ya se encuentra actualizado');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Colaborador)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Colaborador'' AND DD_TEP_ID IS NULL';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
      	  V_SQL := 'SELECT DD_TPR_CODIGO FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_DESCRIPCION = ''Colaborador''';
      	  EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_REGISTRO;
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR '||
	                    'SET USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						', DD_TEP_ID = (SELECT DD_TEP_ID FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR WHERE DD_TEP_CODIGO = ''03'')'||
						'WHERE DD_TPR_CODIGO = '''||V_CODIGO_REGISTRO||'''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Colaborador) sin subtipo asignado, quizás ya se encuentra actualizado');
      END IF;
      
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TPR_TIPO_PROVEEDOR ACTUALIZADO CORRECTAMENTE ');
   

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



   
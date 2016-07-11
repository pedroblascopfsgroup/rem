--/*
--##########################################
--## AUTOR=CARLOS FELIU
--## FECHA_CREACION=20160504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('Puede ver pestaña de título e información registral en la ficha del activo', 'TAB_ACTIVO_TITULO_INFO_REGISTRAL'),
      T_FUNCION('Puede ver pestaña de información administrativa en la ficha del activo', 'TAB_ACTIVO_INFO_ADMINISTRATIVA'),
      T_FUNCION('Puede ver pestaña de cargas en la ficha del activo', 'TAB_ACTIVO_CARGAS'),
      T_FUNCION('Puede ver pestaña de situación posesoria en la ficha del activo', 'TAB_ACTIVO_SITU_POSESORIA'),
	  T_FUNCION('Puede ver pestaña de valoraciones en la ficha del activo', 'TAB_ACTIVO_VALORACIONES'),
	  T_FUNCION('Puede ver pestaña de información comercial en la ficha del activo', 'TAB_ACTIVO_INFO_COMERCIAL'),   
	  T_FUNCION('Puede ver pestaña de comunidad de propietarios en la ficha del activo', 'TAB_ACTIVO_DATOS_COMUNIDAD'),
	  T_FUNCION('Función de edición de la pestaña de datos básicos del activo', 'EDITAR_DATOS_BASICOS_ACTIVO'),
      T_FUNCION('Función de edición de la pestaña de título e información registral del activo', 'EDITAR_TITULO_INFO_REGISTRAL_ACTIVO'),
      T_FUNCION('Función de edición de la pestaña de información administrativa del activo', 'EDITAR_INFO_ADMINISTRATIVA_ACTIVO'),
      T_FUNCION('Función de edición de la pestaña de situación posesoria del activo', 'EDITAR_SITU_POSESORIA_ACTIVO'),
      T_FUNCION('Función de edición de la pestaña de datos de comunidad del activo', 'EDITAR_DATOS_COMUNIDAD_ACTIVO'),
      T_FUNCION('Se le mostrará el combo de gestores', 'MOSTRAR_COMBO_GESTORES'),
      T_FUNCION('Función de edición de fotos web del activo', 'EDITAR_FOTOS_WEB_ACTIVO'),
      T_FUNCION('Función de edición de fotos técnicas del activo', 'EDITAR_FOTOS_TECNICAS_ACTIVO'),
      T_FUNCION('Función de edición del checking de información de admisión', 'EDITAR_CHECKING_INFO_ADMISION'),
      T_FUNCION('Función de edición del checking de documentación de admisión', 'EDITAR_CHECKING_DOC_ADMISION'),
      T_FUNCION('Función de edición de la pestaña de ficha del trabajo', 'EDITAR_FICHA_TRABAJO'),
      T_FUNCION('Función de edición de la pestaña de gestión económica del trabajo', 'EDITAR_GESTION_ECONOMICA_TRABAJO'),
      T_FUNCION('Función de edición de fotos de la subdivisión', 'EDITAR_FOTOS_SUBDIVISION')
      ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	

	     
    --Comprobamos el dato a actualizar
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''TAB_ACTIVO_DATOS_BASICOS''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    --Si existe lo modificamos
    IF V_NUM_TABLAS > 0 THEN				
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO TAB_ACTIVO_DATOS_BASICOS');
   	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.FUN_FUNCIONES '||
                'SET FUN_DESCRIPCION = ''TAB_ACTIVO_DATOS_GENERALES'''|| 
				', FUN_DESCRIPCION_LARGA = ''Puede ver la pestaña Datos generales en activo'''||
				', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
				'WHERE FUN_DESCRIPCION = ''TAB_ACTIVO_DATOS_BASICOS''';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
      
    END IF;
    

    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Empezando a insertar datos en el diccionario');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_FUNCION := V_FUNCION(I);
       
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
						'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''','||
						'0, ''DML'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Datos del diccionario insertado');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
  	
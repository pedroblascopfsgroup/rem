--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20190925
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7593
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza o inserta en FUN_FUNCIONES (Carga Masiva)
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR); -- Vble principal para consulta
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TABLA VARCHAR2(40 CHAR); -- Vble. Nombre de la tabla
    V_USUARIO VARCHAR(40 CHAR); -- Usuario (HREOS)
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('Precios: Carga de distribución de precios' , 'CARGA_DISTRIBUCION_PRECIOS')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    
    V_TABLA := 'FUN_FUNCIONES';
    V_USUARIO := 'HREOS-7593';

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.'||V_TABLA||'... Empezando a escribir datos');
    -- LOOP Insertando valores en FUN_FUNCIONES
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
      V_TMP_FUNCION := V_FUNCION(I);
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION updatea, si no inserta
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.'||V_TABLA||'... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
        V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.'||V_TABLA||
						' SET FUN_DESCRIPCION_LARGA = '''||V_TMP_FUNCION(1)||''', VERSION = VERSION + 1, USUARIOMODIFICAR = '''||V_USUARIO||''''||
            ', FECHAMODIFICAR = SYSDATE, BORRADO = 0 WHERE FUN_DESCRIPCION = ''' || TRIM(V_TMP_FUNCION(2))||'''';
				DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			ELSE		
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.'||V_TABLA||'... No existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
        
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.'||V_TABLA||' (' ||
						'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''','||
						'0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.'||V_TABLA||'... Datos escritos');

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
  	
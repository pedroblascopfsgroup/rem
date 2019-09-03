--/*
--##########################################
--## AUTOR=Jose Antonio gigante
--## FECHA_CREACION=20190827
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7400
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
    V_USUARIO_CREAR VARCHAR2(25 CHAR); -- Vble. para indicar el usuario que realiza la inserción.
    V_BORRADO number(3); -- Vble. para inicializar el registro con borrado a 0, es decir false.
    V_TABLA VARCHAR2(25 CHAR);
    V_TABLE_COUNT number(3); -- Vble. para validar la existencia de las Tablas.

    V_SEQ_COUNT number(3); -- Vble. para validar la existencia de las Secuencias.
    V_COLUMN_COUNT number(3); -- Vble. para validar la existencia de las Columnas.
    V_CONSTRAINT_COUNT number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    -- Inicializando variables
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('Carga Masiva LPO', 'CARGA_MASIVA_LPO')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    V_TABLA := 'FUN_FUNCIONES';
    V_USUARIO_CREAR := 'HREOS-7400';
    V_BORRADO := 0;
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.'||V_TABLA||'... Empezando a insertar datos en la tabla');
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
  			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''';
  			EXECUTE IMMEDIATE V_SQL INTO V_TABLE_COUNT;
  			-- Si existe la FUNCION
  			IF V_TABLE_COUNT > 0 THEN				
  				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M ||'.'||V_TABLA|| '... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
  			ELSE		
  				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.'||V_TABLA||
  						' (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
  						' SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''',0,'''||
  						V_USUARIO_CREAR||''',SYSDATE,0 FROM DUAL';
  				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
  			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.'||V_TABLA||'... inserción en tabla');

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
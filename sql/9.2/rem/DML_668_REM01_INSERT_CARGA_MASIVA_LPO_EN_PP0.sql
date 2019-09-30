--/*
--##########################################
--## AUTOR=Jose Antonio gigante
--## FECHA_CREACION=20190827
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7400
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en POP_PLANTILLAS_OPERACION  DD_OPM_ID
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
    V_TABLA VARCHAR2(25 CHAR); -- Vble. para referenciar a la tabla destino del script.
    V_TABLA_2 VARCHAR2(25 CHAR); -- Vble. para referenciar tablas auxiliares de búsqueda.
    V_CAMPO_1 VARCHAR(25 CHAR); -- Vble. para hacer referencia a los campos de V_TABLA_2.
    V_CAMPO_2 VARCHAR(25 CHAR); -- Vble. para hacer referencia a los campos de V_TABLA.
    V_TABLE_COUNT number(3); -- Vble. para validar la existencia de las Tablas.
    V_DD_OPM_ID number(16); -- Vble. para obtener DD_OPM_ID desde DD_OPM_OPERACION_MASIVA
    V_VERSION number(3);

    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    -- Inicializando variables
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('CML','Carga Masiva LPO', 'plantillas/plugin/masivo/CARGA_MASIVA_LPO.xls')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    V_TABLA := 'POP_PLANTILLAS_OPERACION';
    V_TABLA_2 := 'DD_OPM_OPERACION_MASIVA';
    V_CAMPO_1 := 'DD_OPM_CODIGO';
    V_CAMPO_2 := 'DD_OPM_ID';
    V_USUARIO_CREAR := 'HREOS-7400';
    V_BORRADO := 0;
    V_DD_OPM_ID := 0;
    V_VERSION := 0;
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||V_TABLA||'... Empezando a insertar datos en la tabla');
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);
        V_SQL := 'SELECT '||V_CAMPO_2||' FROM '|| V_ESQUEMA||'.'||V_TABLA_2||' WHERE '||V_CAMPO_1||' = '''|| V_TMP_FUNCION(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_DD_OPM_ID;
        IF V_DD_OPM_ID <= 0 THEN
  	       DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA ||'.'||V_TABLA_2||'... EL VALOR '''|| TRIM(V_TMP_FUNCION(1))||''' NO EXISTE EN LA TABLA');
        ELSE
          V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE '||V_CAMPO_2||' = '||V_DD_OPM_ID||'';
    			EXECUTE IMMEDIATE V_SQL INTO V_TABLE_COUNT;
    			-- Si existe la FUNCION
    			IF V_TABLE_COUNT > 0 THEN				
    				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA ||'.'||V_TABLA|| '... Ya existe el código '''|| V_DD_OPM_ID||'''');
    			ELSE		
    				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||
    						' (POP_ID,POP_NOMBRE,POP_DIRECTORIO,DD_OPM_ID,VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
    						' SELECT S_POP_PLANTILLAS_OPERACION.NEXTVAL,'''||TRIM(V_TMP_FUNCION(2))||''','''||
                            TRIM(V_TMP_FUNCION(3))||''','||V_DD_OPM_ID||','||V_VERSION||','''||V_USUARIO_CREAR||''',SYSDATE,'||V_BORRADO||' FROM DUAL';
    				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_DD_OPM_ID||''','''||V_TMP_FUNCION(2)||''','''||TRIM(V_TMP_FUNCION(3))||'''');
                    EXECUTE IMMEDIATE V_MSQL;
    			END IF;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||V_TABLA||'... inserción en tabla');

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
--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20191223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8909
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a uno varios perfiles, las funciones añadidas en T_ARRAY_FUNCION 
--##            Agregando a su vez las funciones en la tabla FUN_FUNCIONES
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    V_TABLA_FUNCIONES VARCHAR(50)   := 'FUN_FUNCIONES';

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'HREOS-8909';

    -- EDITAR: FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    --  Valores de T_FUNCION: FUN_DESCRIPCION (Corta, Larga)
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('CARGA_MASIVA_TRABAJOS', 'API Automatizado: Carga masiva de trabajos')
    ); 
    V_TMP_FUNCION T_FUNCION;


    V_CONSULTA_FUNCION VARCHAR2(2048) := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.'||V_TABLA_FUNCIONES||' WHERE FUN_DESCRIPCION=:1';
    V_CONSULTA_FUNCION_ID VARCHAR2(2048) := 'SELECT FUN_ID FROM ' || V_ESQUEMA_M || '.'||V_TABLA_FUNCIONES||' WHERE FUN_DESCRIPCION=:1';
    V_INSERT_FUNCION VARCHAR(2048) := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA_FUNCIONES||' (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, '||
    'VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('|| V_ESQUEMA_M||'.S_'||V_TABLA_FUNCIONES||'.NEXTVAL, :1, :2,  0, :3, SYSDATE, 0)  ';
    
    V_NUM_FUNCIONES NUMBER;
    V_FUNCION_ID NUMBER; 
    V_NOM_FUNCION VARCHAR2(200);
    V_NOM_FUNCION_LARGO VARCHAR(200);

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.'||V_TABLA_FUNCIONES||'... Empezando a insertar datos en la tabla');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
        V_NOM_FUNCION := V_TMP_FUNCION(1);
        V_NOM_FUNCION_LARGO := V_TMP_FUNCION(2);
        EXECUTE IMMEDIATE V_CONSULTA_FUNCION INTO V_NUM_FUNCIONES USING V_NOM_FUNCION;

        -- Insertando en FUN_FUNCIONES si no existe el registro
        IF V_NUM_FUNCIONES=0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Función ' || V_NOM_FUNCION || ' no existe, INSERTANDO en '||V_ESQUEMA_M||'.'||V_TABLA_FUNCIONES||'.');
            EXECUTE IMMEDIATE V_INSERT_FUNCION USING V_NOM_FUNCION, V_NOM_FUNCION_LARGO, V_ITEM;

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.'||V_TABLA_FUNCIONES||' registro insertado (' || V_NOM_FUNCION || '): ' || sql%rowcount);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.'||V_TABLA_FUNCIONES||' la función' || V_NOM_FUNCION || ' ya existe, no hay cambios ');
        END IF;

	END LOOP;
    
    COMMIT;

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

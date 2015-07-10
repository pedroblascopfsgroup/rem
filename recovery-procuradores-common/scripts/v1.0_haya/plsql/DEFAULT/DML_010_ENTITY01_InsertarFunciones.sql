--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta las nuevas funciones.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    
    
 
    --Valores en FUN_FUNCIONES
    TYPE T_FUN_FUNCIONES IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUN IS TABLE OF T_FUN_FUNCIONES;
    V_FUN_FUNCIONES T_ARRAY_FUN := T_ARRAY_FUN(
      T_FUN_FUNCIONES('Muestra el menú de procuradores', 'MENU_PROCURADORES_GENERAL', 0, 'MOD_PROC',SYSDATE,NULL,NULL,NULL,NULL,0),
      T_FUN_FUNCIONES('Muestra el menú de procesado de resoluciones del procurador', 'MENU_PROCESADO_PROCURADORES', 0, 'MOD_PROC',SYSDATE,NULL,NULL,NULL,NULL,0),
      T_FUN_FUNCIONES('Muestra el menú de mantenimiento de categorías', 'MANTENIMIENTO_CATEGORIAS', 0, 'MOD_PROC',SYSDATE,NULL,NULL,NULL,NULL,0),
      T_FUN_FUNCIONES('Abre la ventana de resoluciones por defecto', 'INITIAL_TAB_RESOL_PROC', 0, 'MOD_PROC',SYSDATE,NULL,NULL,NULL,NULL,0),
      T_FUN_FUNCIONES('Muestra la rama de tareas pendientes de validar', 'RAMA_TAREAS_PENDIENTES_VALIDAR', 0, 'MOD_PROC',SYSDATE,NULL,NULL,NULL,NULL,0)
      );   
    V_TMP_FUN_FUNCIONES T_FUN_FUNCIONES;

BEGIN	

      -- LOOP Insertando valores en FUN_FUNCIONES ------------------------------------------------------------------------
      
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Empezando a insertar datos en FUN_FUNCIONES');
    FOR I IN V_FUN_FUNCIONES.FIRST .. V_FUN_FUNCIONES.LAST
      LOOP
            V_TMP_FUN_FUNCIONES := V_FUN_FUNCIONES(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUN_FUNCIONES(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe el FUN_FUNCIONES '''|| TRIM(V_TMP_FUN_FUNCIONES(2)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
                      'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ', '''||V_TMP_FUN_FUNCIONES(1)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(2)||''', '''||V_TMP_FUN_FUNCIONES(3)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(4)||''', '''||V_TMP_FUN_FUNCIONES(5)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(6)||''', '''||V_TMP_FUN_FUNCIONES(7)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(8)||''', '''||V_TMP_FUN_FUNCIONES(9)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(10)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUN_FUNCIONES(2)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.FUN_FUNCIONES... Datos de la función insertados');
    
    
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
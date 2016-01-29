--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20151106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO
--## PRODUCTO=SI
--## Finalidad: DML
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

    V_NUM_PEF_ID NUMBER(16);
    V_NUM_FUN_ID NUMBER(16);

    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('Puede ver los botones del grid de documentos', 'TAB_PRECONTENCIOSO_DOC_BTN'),
      T_FUNCION('Puede ver los botones del grid de liquidaciones', 'TAB_PRECONTENCIOSO_LIQ_BTN'),
      T_FUNCION('Puede ver los botones del grid de burofaxes', 'TAB_PRECONTENCIOSO_BUR_BTN')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'SELECT PEF_ID FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO = ''FULLPRECON''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_PEF_ID;


    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        -- INSERTANDO EN FUN_FUNCIONES

        IF V_NUM_TABLAS > 0 THEN        
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
        ELSE    
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
              'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
              'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL,'''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''','||
              '0, ''DML'',SYSDATE,0 FROM DUAL';
          DBMS_OUTPUT.PUT_LINE('INSERTANDO: en FUN_FUNCIONES datos: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;

        V_MSQL := 'SELECT FUN_ID FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''' || TRIM(V_TMP_FUNCION(2)) || '''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FUN_ID;


        -- INSERTANDO EN FUN_PEF

        V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.FUN_PEF WHERE FUN_ID = ''' || V_NUM_FUN_ID || ''' AND PEF_ID = ''' || V_NUM_PEF_ID || '''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FUN_PEF... Ya existe la relacion');
        ELSE
          V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.FUN_PEF (FP_ID, USUARIOCREAR, FECHACREAR, PEF_ID, FUN_ID) VALUES '
                  || '(' || V_ESQUEMA || '.S_FUN_PEF.NextVal, ''DML'', SYSDATE, ''' || V_NUM_PEF_ID || ''',''' || V_NUM_FUN_ID || ''')';

          DBMS_OUTPUT.PUT_LINE('INSERTANDO: en FUN_PEF datos: ' || TRIM(V_TMP_FUNCION(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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

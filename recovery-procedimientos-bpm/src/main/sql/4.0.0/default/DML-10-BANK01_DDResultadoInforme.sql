/*
--##########################################
--## Author: Oscar Dorado
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Rellenar la tabla Resultados de informe
--## INSTRUCCIONES:  Rellenar la tabla Resultados de informe
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    --Insertando valores en DD_ESU_ESTADO_SUBASTA
    V_REI_ID NUMBER(16);
    TYPE T_TIPO_REI IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_REI IS TABLE OF T_TIPO_REI;
    V_TIPO_REI T_ARRAY_REI := T_ARRAY_REI(
      T_TIPO_REI('NHANHV', 'No hay alegaciones y no hay vista', 'No hay alegaciones y no hay vista'),
      T_TIPO_REI('NHASHV', 'No hay alegaciones y sí hay vista', 'No hay alegaciones y sí hay vista'),
      T_TIPO_REI('HA', 'Hay alegaciones', 'Hay alegaciones'),
      T_TIPO_REI('MOD', 'Requiere modificación', 'Requiere modificación')
    ); 
    V_TMP_TIPO_REI T_TIPO_REI;
    
BEGIN	

    -- LOOP Insertando valores en DD_REI_RESULTADO_INFORME
    VAR_TABLENAME := 'DD_REI_RESULTADO_INFORME';
    VAR_SEQUENCENAME := 'S_DD_REI_RESULTADO_INFORME';

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_REI.FIRST .. V_TIPO_REI.LAST
      LOOP
        V_TMP_TIPO_REI := V_TIPO_REI(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE DD_REI_CODIGO = '''||TRIM(V_TMP_TIPO_REI(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Ya existe el DD_REI_CODIGO '''|| TRIM(V_TMP_TIPO_REI(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.' || VAR_SEQUENCENAME || '.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_REI_ID; 
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_REI_ID, DD_REI_CODIGO, DD_REI_DESCRIPCION, DD_REI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '|| V_REI_ID || ','''||TRIM(V_TMP_TIPO_REI(1))||''','''||TRIM(V_TMP_TIPO_REI(2))||''','''||TRIM(V_TMP_TIPO_REI(3))||''','||
                    '0, ''DD'', SYSDATE, 0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_REI(1)||''','''||TRIM(V_TMP_TIPO_REI(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Datos del diccionario insertado');

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
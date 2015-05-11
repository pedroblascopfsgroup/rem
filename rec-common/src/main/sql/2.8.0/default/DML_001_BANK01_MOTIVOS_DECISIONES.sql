--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DML para rellenar los datos de los diccionarios relacionados con SUB_SUBASTA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en DD_DFI_DECISION_FINALIZAR
    TYPE T_TIPO_DFI IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DFI IS TABLE OF T_TIPO_DFI;
    V_TIPO_DFI T_ARRAY_DFI := T_ARRAY_DFI(
      T_TIPO_DFI('INSTRUC', 'Instrucciones de la entidad', 'Instrucciones de la entidad'),
      T_TIPO_DFI('ERROR', 'Error al crear la actuación', 'Error al crear la actuación'),
      T_TIPO_DFI('ENERV', 'Enervación', 'Enervación'),
      T_TIPO_DFI('DACI', 'Dación', 'Dación'),
      T_TIPO_DFI('REFIN', 'Refinanciación', 'Refinanciación'),
      T_TIPO_DFI('ACUM', 'Acumulación', 'Acumulación'),
      T_TIPO_DFI('CONDO', 'Condonación de la deuda', 'Condonación de la deuda')
    ); 
    V_TMP_TIPO_DFI T_TIPO_DFI;
    
    --Insertando valores en DD_DPA_DECISION_PARALIZAR
    TYPE T_TIPO_DPA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DPA IS TABLE OF T_TIPO_DPA;
    V_TIPO_DPA T_ARRAY_DPA := T_ARRAY_DPA(
      T_TIPO_DPA('CONCUR', 'Concurso de acreedores', 'Concurso de acreedores'),
      T_TIPO_DPA('ACUER', 'Acuerdo extrajudicial', 'Acuerdo extrajudicial'),
      T_TIPO_DPA('OPOSI', 'Oposición Ley hipotecaria 1/2013', 'Oposición Ley hipotecaria 1/2013'),
      T_TIPO_DPA('INSTR', 'Instrucciones de la entidad', 'Instrucciones de la entidad'),
      T_TIPO_DPA('OTRA', 'Otras causa', 'Otras causa')
    ); 
    V_TMP_TIPO_DPA T_TIPO_DPA;

BEGIN	
    -- LOOP Insertando valores en DD_DFI_DECISION_FINALIZAR
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_DFI.FIRST .. V_TIPO_DFI.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_DFI := V_TIPO_DFI(I);
        -- Comprobamos si existe el codigo
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_CODIGO = '''||TRIM(V_TMP_TIPO_DFI(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... Ya existe el DD_DFI_CODIGO '''|| TRIM(V_TMP_TIPO_DFI(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_DFI_DECISION_FINALIZAR (' ||
                      'DD_DFI_ID, DD_DFI_CODIGO, DD_DFI_DESCRIPCION, DD_DFI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_DFI(1)||''','''||TRIM(V_TMP_TIPO_DFI(2))||''','''||TRIM(V_TMP_TIPO_DFI(3))||''','||
                      '1, ''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_DFI(1)||''','''||TRIM(V_TMP_TIPO_DFI(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR... Datos del diccionario insertado');
    
    -- LOOP Insertando valores en DD_DPA_DECISION_PARALIZAR
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_DPA.FIRST .. V_TIPO_DPA.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_DPA := V_TIPO_DPA(I);
        -- Comprobamos si existe el codigo
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = '''||TRIM(V_TMP_TIPO_DPA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Ya existe el DD_DPA_CODIGO '''|| TRIM(V_TMP_TIPO_DPA(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_DPA_DECISION_PARALIZAR (' ||
                      'DD_DPA_ID, DD_DPA_CODIGO, DD_DPA_DESCRIPCION, DD_DPA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_DPA(1)||''','''||TRIM(V_TMP_TIPO_DPA(2))||''','''||TRIM(V_TMP_TIPO_DPA(3))||''','||
                      '1,''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_DPA(1)||''','''||TRIM(V_TMP_TIPO_DPA(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Datos del diccionario insertado');

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
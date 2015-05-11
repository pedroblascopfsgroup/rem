--/*
--##########################################
--## Author: David Gilsanz
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DML para rellenar los datos del diccionario DD_TAS_TIPOS_ASUNTO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en DD_TAS_TIPOS_ASUNTO
    TYPE T_TIPO_TAS IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TAS IS TABLE OF T_TIPO_TAS;
    V_TIPO_TAS T_ARRAY_TAS := T_ARRAY_TAS(
      T_TIPO_TAS('01', 'Litigio', 'Litigio'),
      T_TIPO_TAS('02', 'Concursal', 'Concursal'),
      T_TIPO_TAS('03', 'Especializada', 'Especializada'),
      T_TIPO_TAS('04', 'Especializada SAREB', 'Especializada SAREB')
    ); 
    V_TMP_TIPO_TAS T_TIPO_TAS;

BEGIN	
    -- LOOP Insertando valores en DD_DFI_DECISION_FINALIZAR
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TAS.FIRST .. V_TIPO_TAS.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_TAS_TIPOS_ASUNTO.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_TAS := V_TIPO_TAS(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = '''||TRIM(V_TMP_TIPO_TAS(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO... Ya existe el DD_TAS_CODIGO '''|| TRIM(V_TMP_TIPO_TAS(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_TAS_TIPOS_ASUNTO (' ||
                      'DD_TAS_ID, DD_TAS_CODIGO, DD_TAS_DESCRIPCION, DD_TAS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_TAS(1)||''','''||TRIM(V_TMP_TIPO_TAS(2))||''','''||TRIM(V_TMP_TIPO_TAS(3))||''','||
                      '1, ''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAS(1)||''','''||TRIM(V_TMP_TIPO_TAS(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO... Datos del diccionario insertado');

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
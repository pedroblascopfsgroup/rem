--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20150514
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.10.13
--## INCIDENCIA_LINK=BCFI-614
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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
    
    --Valores en DD_MRF_MARCA_REFINANCIACION
    TYPE T_TIPO_MRF IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_MRF IS TABLE OF T_TIPO_MRF;
    V_TIPO_MRF T_ARRAY_MRF := T_ARRAY_MRF
    (
      T_TIPO_MRF('N/A', 'NO APLICA', 'VALOR NO INFORMADO O NULO'),
      T_TIPO_MRF('NV', 'NUEVA', 'NUEVA'),
      T_TIPO_MRF('RD', 'REFINANCIADA', 'REFINANCIADA'),
      T_TIPO_MRF('RF', 'REFINANCIACION', 'REFINANCIACION'),
      T_TIPO_MRF('RG', 'RENEGOCIADA', 'RENEGOCIADA'),
      T_TIPO_MRF('RT', 'REESTRUCTURACION', 'REESTRUCTURACION'),
      T_TIPO_MRF('RV', 'RENOVADA', 'RENOVADA')     
    );   
    V_TMP_TIPO_MRF T_TIPO_MRF;

BEGIN    

    -- LOOP Insertando valores en DD_MRF_MARCA_REFINANCIACION ------------------------------------------------------------------------
      
    execute immediate 'delete from '||V_ESQUEMA_M||'.DD_MRF_MARCA_REFINANCIACION';
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_MRF_MARCA_REFINANCIACION... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_MRF.FIRST .. V_TIPO_MRF.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_MRF_MARCA_REFINANCIACION.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_MRF := V_TIPO_MRF(I);
            
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_MRF_MARCA_REFINANCIACION WHERE DD_MRF_CODIGO = '''||TRIM(V_TMP_TIPO_MRF(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN                
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_MRF_MARCA_REFINANCIACION... Ya existe el DD_MRF_CODIGO '''|| TRIM(V_TMP_TIPO_MRF(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_MRF_MARCA_REFINANCIACION (' ||
                      'DD_MRF_ID, DD_MRF_CODIGO, DD_MRF_DESCRIPCION, DD_MRF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_MRF(1)||''','''||TRIM(V_TMP_TIPO_MRF(2))||''','''||TRIM(V_TMP_TIPO_MRF(3))||''','||
                      '1, ''DD'', SYSDATE, 0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_MRF(1)||''','''||TRIM(V_TMP_TIPO_MRF(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_MRF_MARCA_REFINANCIACION... Datos del diccionario insertado');
    
    
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
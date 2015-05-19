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
    
    --Valores en DD_MOM_MOTIVO_MARCA_R
    TYPE T_TIPO_MOM IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_MOM IS TABLE OF T_TIPO_MOM;
    V_TIPO_MOM T_ARRAY_MOM := T_ARRAY_MOM
    (
      T_TIPO_MOM('N/A', 'NO APLICA', 'VALOR NO INFORMADO O NULO'),
      T_TIPO_MOM('AP', 'AMPLIACION PLAZO', 'AMPLIACION PLAZO'),
      T_TIPO_MOM('CA', 'CUAD AMORT', 'CUADRO AMORTIZACION'),
      T_TIPO_MOM('CR', 'CARENCIA', 'CARENCIA'),
      T_TIPO_MOM('CT', 'CARENCIA TOTAL', 'CARENCIA TOTAL'),
      T_TIPO_MOM('DC', 'DACION', 'DACION'),
      T_TIPO_MOM('NV', 'NUEVA', 'NUEVA'),
      T_TIPO_MOM('OT', 'OTROS', 'OTROS'),
      T_TIPO_MOM('PR', 'PRECIO', 'PRECIO'),
      T_TIPO_MOM('QT', 'QUITA', 'QUITA'),
      T_TIPO_MOM('RD', 'REFINANCIADA', 'REFINANCIADA'),
      T_TIPO_MOM('RF', 'REFINANCIACION', 'REFINANCIACION'),
      T_TIPO_MOM('RG', 'RENEGOCIADA', 'RENEGOCIADA'),
      T_TIPO_MOM('RT', 'REESTRUCTURACION', 'REESTRUCTURACION'),
      T_TIPO_MOM('RV', 'RENOVADA', 'RENOVADA')  
    );   
    V_TMP_TIPO_MOM T_TIPO_MOM;

BEGIN    

    -- LOOP Insertando valores en DD_MOM_MARCA_REFINANCIACION ------------------------------------------------------------------------
      
    execute immediate 'delete from '||V_ESQUEMA_M||'.DD_MOM_MOTIVO_MARCA_R';
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_MOM_MOTIVO_MARCA_R... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_MOM.FIRST .. V_TIPO_MOM.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_MOM_MOTIVO_MARCA_R.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_MOM := V_TIPO_MOM(I);
            
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_MOM_MOTIVO_MARCA_R WHERE DD_MOM_CODIGO = '''||TRIM(V_TMP_TIPO_MOM(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN                
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_MOM_MOTIVO_MARCA_R... Ya existe el DD_MOM_CODIGO '''|| TRIM(V_TMP_TIPO_MOM(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_MOM_MOTIVO_MARCA_R (' ||
                      'DD_MOM_ID, DD_MOM_CODIGO, DD_MOM_DESCRIPCION, DD_MOM_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_MOM(1)||''','''||TRIM(V_TMP_TIPO_MOM(2))||''','''||TRIM(V_TMP_TIPO_MOM(3))||''','||
                      '1, ''DD'', SYSDATE, 0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_MOM(1)||''','''||TRIM(V_TMP_TIPO_MOM(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_MOM_MOTIVO_MARCA_R... Datos del diccionario insertado');
    
    
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
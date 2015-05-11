--/*
--##########################################
--## Author: Carlos Perez
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
    --Insertando valores en DD_ESU_ESTADO_SUBASTA
    TYPE T_TIPO_ESU IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_ESU IS TABLE OF T_TIPO_ESU;
    V_TIPO_ESU T_ARRAY_ESU := T_ARRAY_ESU(
      T_TIPO_ESU('SUS','SUSPENDIDA','SUSPENDIDA'),
      T_TIPO_ESU('CAN','CANCELADA','CANCELADA'),
      T_TIPO_ESU('CEL','CELEBRADA','CELEBRADA'),
      T_TIPO_ESU('PIN','PENDIENTE INFORME','PENDIENTE INFORME'),
      T_TIPO_ESU('PPR','PENDIENTE PROPUESTA','PENDIENTE PROPUESTA'),
      T_TIPO_ESU('PCO','PENDIENTE APROBACIÓN','PENDIENTE APROBACIÓN'),
      T_TIPO_ESU('PAC','PENDIENTE ACEPTACIÓN','PENDIENTE ACEPTACIÓN'),
      T_TIPO_ESU('PCE','PENDIENTE CELEBRACION','PENDIENTE CELEBRACION')
    ); 
    V_TMP_TIPO_ESU T_TIPO_ESU;
    
    --Insertando valores en DD_MCS_MOT_CANCEL_SUBASTA
    TYPE T_TIPO_MCS IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_MCS IS TABLE OF T_TIPO_MCS;
    V_TIPO_MCS T_ARRAY_MCS := T_ARRAY_MCS(
      T_TIPO_MCS('CAC','CONCURSO ACREEDORES','CONCURSO ACREEDORES'),
      T_TIPO_MCS('INE','INSTRUCCIONES ENTIDAD','INSTRUCCIONES ENTIDAD'),
      T_TIPO_MCS('EAC','ERROR AL CREAR ACTUACION','ERROR AL CREAR ACTUACION'),
      T_TIPO_MCS('ACU','ACUERDO','ACUERDO'),
      T_TIPO_MCS('OTR','OTROS','OTROS')
    ); 
    V_TMP_TIPO_MCS T_TIPO_MCS;
    
    --Insertando valores en DD_MSS_MOT_SUSP_SUBASTA
    TYPE T_TIPO_MSS IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_MSS IS TABLE OF T_TIPO_MSS;
    V_TIPO_MSS T_ARRAY_MSS := T_ARRAY_MSS(
      T_TIPO_MSS('SENE','SUSPENDIDA ENTIDAD: NEGOCIACION EXTRAJUDICIAL','SUSPENDIDA ENTIDAD: NEGOCIACION EXTRAJUDICIAL'),
      T_TIPO_MSS('SEDJ','SUSPENDIDA ENTIDAD: DEUDA JUDICIAL','SUSPENDIDA ENTIDAD: DEUDA JUDICIAL'),
      T_TIPO_MSS('SEEC','SUSPENDIDA ENTIDAD: EXISTENCIA CARGAS','SUSPENDIDA ENTIDAD: EXISTENCIA CARGAS'),
      T_TIPO_MSS('SEOT','SUSPENDIDA ENTIDAD: OTROS','SUSPENDIDA ENTIDAD: OTROS'),
      T_TIPO_MSS('SOOT','SUSPENDIDA OTROS: OTROS','SUSPENDIDA OTROS: OTROS'),
      T_TIPO_MSS('SODP','SUSPENDIDA OTROS: DEFECTO PROCESAL','SUSPENDIDA OTROS: DEFECTO PROCESAL'),
      T_TIPO_MSS('SOFN','SUSPENDIDA OTROS: FALTA NOTIFICACION','SUSPENDIDA OTROS: FALTA NOTIFICACION')
    ); 
    V_TMP_TIPO_MSS T_TIPO_MSS;
    
    --Insertando valores en DD_REC_RESULTADO_COMITE
    TYPE T_TIPO_REC IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_REC IS TABLE OF T_TIPO_REC;
    V_TIPO_REC T_ARRAY_REC := T_ARRAY_REC(
      T_TIPO_REC('SUS','SUSPENDER','SUSPENDER'),
      T_TIPO_REC('REC','RECTIFICAR','RECTIFICAR'),
      T_TIPO_REC('ACE','ACEPTADA','ACEPTADA')
    ); 
    V_TMP_TIPO_REC T_TIPO_REC;

    --Insertando valores en DD_TSU_TIPO_SUBASTA
    TYPE T_TIPO_TSU IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TSU IS TABLE OF T_TIPO_TSU;
    V_TIPO_TSU T_ARRAY_TSU := T_ARRAY_TSU(
      T_TIPO_TSU('DEL','DELGADA','SUBASTA DELEGADA'),
      T_TIPO_TSU('NDE','NO DELEGADA','SUBASTA NO DELEGADA')
    ); 
    V_TMP_TIPO_TSU T_TIPO_TSU;
    
BEGIN	
    -- LOOP Insertando valores en DD_MCS_MOT_CANCEL_SUBASTA
    DBMS_OUTPUT.PUT_LINE(''||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_ESU.FIRST .. V_TIPO_ESU.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_ESU_ESTADO_SUBASTA.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_ESU := V_TIPO_ESU(I);
        -- Comprobamos si existe el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA WHERE DD_ESU_CODIGO = '''||TRIM(V_TMP_TIPO_ESU(1))||'''';
      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA... Ya existe el DD_ESU_CODIGO '''|| TRIM(V_TMP_TIPO_ESU(1)) ||'''');
        ELSE    
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_ESU_ESTADO_SUBASTA (' ||
                      'DD_ESU_ID,DD_ESU_CODIGO,DD_ESU_DESCRIPCION,DD_ESU_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_ESU(1)||''','''||TRIM(V_TMP_TIPO_ESU(2))||''','''||TRIM(V_TMP_TIPO_ESU(3))||''','||
                      '''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_ESU(1)||''','''||TRIM(V_TMP_TIPO_ESU(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA... Datos del diccionario insertado');
    
    -- LOOP Insertando valores en DD_MCS_MOT_CANCEL_SUBASTA
    DBMS_OUTPUT.PUT_LINE(''||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_MCS.FIRST .. V_TIPO_MCS.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MCS_MOT_CANCEL_SUBASTA.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_MCS := V_TIPO_MCS(I);
        -- Comprobamos si existe el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA WHERE DD_MCS_CODIGO = '''||TRIM(V_TMP_TIPO_MCS(1))||'''';
      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA... Ya existe el DD_MCS_CODIGO '''|| TRIM(V_TMP_TIPO_MCS(1)) ||'''');
        ELSE    
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MCS_MOT_CANCEL_SUBASTA (' ||
                      'DD_MCS_ID,DD_MCS_CODIGO,DD_MCS_DESCRIPCION,DD_MCS_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_MCS(1)||''','''||TRIM(V_TMP_TIPO_MCS(2))||''','''||TRIM(V_TMP_TIPO_MCS(3))||''','||
                      '''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_MCS(1)||''','''||TRIM(V_TMP_TIPO_MCS(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA... Datos del diccionario insertado');
    
    -- LOOP Insertando valores en DD_MSS_MOT_SUSP_SUBASTA
    DBMS_OUTPUT.PUT_LINE(''||V_ESQUEMA||'.DD_MSS_MOT_SUSP_SUBASTA... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_MSS.FIRST .. V_TIPO_MSS.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MSS_MOT_SUSP_SUBASTA.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_MSS := V_TIPO_MSS(I);
        -- Comprobamos si existe el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MSS_MOT_SUSP_SUBASTA WHERE DD_MSS_CODIGO = '''||TRIM(V_TMP_TIPO_MSS(1))||'''';
      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Ya existe el DD_MSS_CODIGO '''|| TRIM(V_TMP_TIPO_MSS(1)) ||'''');
        ELSE 
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MSS_MOT_SUSP_SUBASTA (' ||
                      'DD_MSS_ID,DD_MSS_CODIGO,DD_MSS_DESCRIPCION,DD_MSS_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_MSS(1)||''','''||TRIM(V_TMP_TIPO_MSS(2))||''','''||TRIM(V_TMP_TIPO_MSS(3))||''','||
                      '''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_MSS(1)||''','''||TRIM(V_TMP_TIPO_MSS(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_MSS_MOT_SUSP_SUBASTA... Datos del diccionario insertado');
    
    -- LOOP Insertando valores en DD_REC_RESULTADO_COMITE
    DBMS_OUTPUT.PUT_LINE(''||V_ESQUEMA||'.DD_REC_RESULTADO_COMITE... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_REC.FIRST .. V_TIPO_REC.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_REC_RESULTADO_COMITE.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_REC := V_TIPO_REC(I);
        -- Comprobamos si existe el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_REC_RESULTADO_COMITE WHERE DD_REC_CODIGO = '''||TRIM(V_TMP_TIPO_REC(1))||'''';
      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Ya existe el DD_REC_CODIGO '''|| TRIM(V_TMP_TIPO_REC(1)) ||'''');
        ELSE 
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_REC_RESULTADO_COMITE (' ||
                      'DD_REC_ID,DD_REC_CODIGO,DD_REC_DESCRIPCION,DD_REC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_REC(1)||''','''||TRIM(V_TMP_TIPO_REC(2))||''','''||TRIM(V_TMP_TIPO_REC(3))||''','||
                      '''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_REC(1)||''','''||TRIM(V_TMP_TIPO_REC(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_REC_RESULTADO_COMITE... Datos del diccionario insertado');
    
    -- LOOP Insertando valores en DD_TSU_TIPO_SUBASTA
    DBMS_OUTPUT.PUT_LINE(''||V_ESQUEMA||'.DD_TSU_TIPO_SUBASTA... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TSU.FIRST .. V_TIPO_TSU.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TSU_TIPO_SUBASTA.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_TSU := V_TIPO_TSU(I);
        -- Comprobamos si existe el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TSU_TIPO_SUBASTA WHERE DD_TSU_CODIGO = '''||TRIM(V_TMP_TIPO_TSU(1))||'''';
      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Ya existe el DD_TSU_CODIGO '''|| TRIM(V_TMP_TIPO_TSU(1)) ||'''');
        ELSE 
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TSU_TIPO_SUBASTA (' ||
                      'DD_TSU_ID,DD_TSU_CODIGO,DD_TSU_DESCRIPCION,DD_TSU_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_TSU(1)||''','''||TRIM(V_TMP_TIPO_TSU(2))||''','''||TRIM(V_TMP_TIPO_TSU(3))||''','||
                      '''DML'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TSU(1)||''','''||TRIM(V_TMP_TIPO_TSU(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TSU_TIPO_SUBASTA... Datos del diccionario insertado');

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
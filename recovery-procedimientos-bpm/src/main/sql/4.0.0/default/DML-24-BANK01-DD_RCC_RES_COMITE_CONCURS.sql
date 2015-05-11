--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Guillermo Marín
--## Finalidad: DML Inserción en DD_RCC_RES_COMITE_CONCURS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01';-- Configuracion Esquemas
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  V_ENTIDAD_ID NUMBER(16);
  --Insertando valores en DD_RCC_RES_COMITE_CONCURS
  TYPE T_TIPO_RCC1 IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_RCC1 IS TABLE OF T_TIPO_RCC1;
  V_TIPO_RCC1 T_ARRAY_RCC1 := T_ARRAY_RCC1(
    T_TIPO_RCC1('CONCEDIDO','CONCEDIDO','CONCEDIDO',0,'DGG',sysdate,0),
    T_TIPO_RCC1('CONCONMOD','CONCEDIDO CON MODIFICACIONES','CONCEDIDO CON MODIFICACIONES',0,'DGG',sysdate,0),
    T_TIPO_RCC1('MODIFICAR','MODIFICAR','MODIFICAR',0,'DGG',sysdate,0),
    T_TIPO_RCC1('DENEGADA','DENEGADA','DENEGADA',0,'DGG',sysdate,0)
  ); 
  V_TMP_TIPO_RCC1 T_TIPO_RCC1; 
  
  
BEGIN 

DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_RCC1.FIRST .. V_TIPO_RCC1.LAST
      LOOP
        V_TMP_TIPO_RCC1 := V_TIPO_RCC1(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS WHERE DD_RCC_CODIGO = ''' ||TRIM(V_TMP_TIPO_RCC1(1)) || '''';
        -- DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
          IF V_NUM_TABLAS > 0 THEN				
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_RCC_RES_COMITE_CONCURS... Ya existe el comite '''|| TRIM(V_TMP_TIPO_RCC1(1)) ||'''');
          ELSE
              V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dd_rcc_res_comite_concurs.NEXTVAL FROM DUAL';
              EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
              
              V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_RCC_RES_COMITE_CONCURS (
                          DD_RCC_ID,DD_RCC_CODIGO,DD_RCC_DESCRIPCION,DD_RCC_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                          'SELECT '''|| V_ENTIDAD_ID || ''', '''||TRIM(V_TMP_TIPO_RCC1(1))||''' ,'''||TRIM(V_TMP_TIPO_RCC1(2))||''','''||TRIM(V_TMP_TIPO_RCC1(3))||''','''||V_TMP_TIPO_RCC1(4)||''','||
                            ''''||TRIM(V_TMP_TIPO_RCC1(5)) || ''','''||TRIM(V_TMP_TIPO_RCC1(6))||''','''||V_TMP_TIPO_RCC1(7)||
                            ''' FROM DUAL';
                  DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||TRIM(V_TMP_TIPO_RCC1(1))||''','''||TRIM(V_TMP_TIPO_RCC1(2)));
              EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS... Datos del diccionario insertado');
    
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
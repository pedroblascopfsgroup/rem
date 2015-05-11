--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150427
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.12
--## INCIDENCIA_LINK=FASE-1238
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    --Valores en DD_TRI_TRIBUTACION
    TYPE T_TIPO_TRI IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TRI IS TABLE OF T_TIPO_TRI;
    V_TIPO_TRI T_ARRAY_TRI := T_ARRAY_TRI(
      T_TIPO_TRI('0101', 'IVA EXENTO', 'IVA EXENTO'),
      T_TIPO_TRI('0102', 'IVA GENERAL', 'IVA GENERAL'),
      T_TIPO_TRI('0103', 'IVA SUPERREDUCIDO', 'IVA SUPERREDUCIDO'),
      T_TIPO_TRI('0104', 'IVA REDUCIDO', 'IVA REDUCIDO'),
      T_TIPO_TRI('0105', 'IVA-AG.VIAJE REG.ESPECIAL', 'IVA-AG.VIAJE REG.ESPECIAL'),
      T_TIPO_TRI('0201', 'IGIC GENERAL', 'IGIC GENERAL'),
      T_TIPO_TRI('0203', 'IGIC-APIC', 'IGIC-APIC'),
      T_TIPO_TRI('0204', 'IGIC-EXENTO', 'IGIC-EXENTO'),
      T_TIPO_TRI('0205', 'IGIC-INCREMENTADO', 'IGIC-INCREMENTADO'),
      T_TIPO_TRI('0206', 'IGIC - REDUCIDO', 'IGIC - REDUCIDO'),
      T_TIPO_TRI('0301', 'IPSI GENERAL', 'IPSI GENERAL'),
      T_TIPO_TRI('0302', 'IPSI-EXENTO', 'IPSI-EXENTO'),
      T_TIPO_TRI('0401', 'ITP', 'ITP'),
      T_TIPO_TRI('0402', 'ITP BONIFICADO', 'ITP BONIFICADO')
      
      
    );   
    V_TMP_TIPO_TRI T_TIPO_TRI;

BEGIN	

      -- LOOP Insertando valores en DD_TRI_TRIBUTACION ------------------------------------------------------------------------
      
	execute immediate 'delete from '||V_ESQUEMA||'.dd_tri_tributacion';
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TRI_TRIBUTACION... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TRI.FIRST .. V_TIPO_TRI.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TRI_TRIBUTACION.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_TRI := V_TIPO_TRI(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TRI_TRIBUTACION WHERE DD_TRI_CODIGO = '''||TRIM(V_TMP_TIPO_TRI(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TRI_TRIBUTACION... Ya existe el DD_TRI_CODIGO '''|| TRIM(V_TMP_TIPO_TRI(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TRI_TRIBUTACION (' ||
                      'DD_TRI_ID, DD_TRI_CODIGO, DD_TRI_DESCRIPCION, DD_TRI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_TRI(1)||''','''||TRIM(V_TMP_TIPO_TRI(2))||''','''||TRIM(V_TMP_TIPO_TRI(3))||''','||
                      '1, ''FASE_1238'',SYSDATE,0 FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TRI(1)||''','''||TRIM(V_TMP_TIPO_TRI(2))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TRI_TRIBUTACION... Datos del diccionario insertado');
    
    
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
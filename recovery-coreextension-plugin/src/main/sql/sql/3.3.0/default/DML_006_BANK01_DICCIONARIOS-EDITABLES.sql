/*
--##########################################
--## Author: Carlos Pérez
--## Finalidad:  Rellenar la tabla diccionarios editables
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
    V_ID NUMBER(16);
    TYPE T_TIPO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('DD_OC_ORIGEN_COBRO', 'OC', 'Diccionario para el origen de cobro'),
      T_TIPO('DD_TIN_TIPO_INTERVENCION', 'TIN', 'Diccionario para el tipo de intervención'),
      T_TIPO('DD_SEC_SEGMENTO_CARTERA', 'SEC', 'Diccionario para el segmento cartera'),
      T_TIPO('DD_SSC_SUBSEGMENTO_CLI_ENTIDAD', 'SSC', 'Diccionario para el subsegmento del cliente entidad'),
      T_TIPO('DD_APO_APLICATIVO_ORIGEN', 'APO', 'Diccinario para el aplicativo origen'),
      T_TIPO('DD_TBI_TIPO_BIEN', 'TBI', 'Diccionario para el tipo de bien'),
      T_TIPO('DD_TPB_TIPO_PROD_BANCARIO', 'TPB', 'Diccionario para el tipo de producto bancario'),
      T_TIPO('DD_TRE_TIPO_RECIBO', 'TRE', 'Diccionario para el tipo de recibo'),
      T_TIPO('DD_SIR_SITUACIÓN_RECIBO', 'SIR', 'Diccionario para la situación del recibo')
    ); 
   V_TMP_TIPO T_TIPO;
    
BEGIN	

    VAR_TABLENAME := 'DIC_DICCIONARIOS_EDITABLES';
    VAR_SEQUENCENAME := 'S_DIC_DICCIONARIOS_EDITABLES';
    

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
      LOOP
       V_TMP_TIPO := V_TIPO(I);        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE DIC_NBTABLA = '''||TRIM(V_TMP_TIPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Ya existe el dato '''|| TRIM(V_TMP_TIPO(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.' || VAR_SEQUENCENAME || '.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID; 
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DIC_ID, DIC_NBTABLA, DIC_CODIGO, DIC_DESCRIPCION, DIC_EDICION, DIC_ADD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '|| V_ID || ','''||TRIM(V_TMP_TIPO(1))||''','''||TRIM(V_TMP_TIPO(2))||''','''||TRIM(V_TMP_TIPO(3))||''','||
                    '1,1,0,''DML'', SYSDATE, 0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO(1)||''','''||TRIM(V_TMP_TIPO(2))||'''');
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
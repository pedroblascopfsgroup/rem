/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150912
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-236
--## PRODUCTO=SI
--##
--## Finalidad: Inserción de nuevos tipos de gestor y nuevos tipos de subtarea
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_LINEA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA IS TABLE OF T_LINEA;
    V_TIPO_LINEA T_ARRAY_LINEA := T_ARRAY_LINEA(
      T_LINEA('PREDOC','Gestor expediente judicial'),
      T_LINEA('SUP_PCO','Supervisor expediente judicial'),
      T_LINEA('GESTORIA_PREDOC','Gestoría preparación documental')
    ); 
    V_TMP_TIPO_LINEA T_LINEA;
    
    TYPE T_LINEA2 IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA2 IS TABLE OF T_LINEA2;
    V_TIPO_LINEA2 T_ARRAY_LINEA2 := T_ARRAY_LINEA2(
      T_LINEA2('PCO_LET','Tarea Letrado Precontencioso', 'LETR'),
      T_LINEA2('PCO_PREDOC','Tarea Gestor Expediente judicial', 'PREDOC'),
      T_LINEA2('PCO_GEST','Tarea Gestoría Preparación Expediente Judicial', 'GESTORIA_PREDOC'),
      T_LINEA2('PCO_SUP','Supervisor expediente judicial', 'SUP_PCO')
    ); 
    V_TMP_TIPO_LINEA2 T_LINEA2;
    
BEGIN	

    VAR_TABLENAME := 'DD_TGE_TIPO_GESTOR';
	
    -- Inserción de valores en DD_TGE_TIPO_GESTOR
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar valores');
    FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
      LOOP
        V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || ' WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          V_MSQL := 'UPDATE  '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || ' SET DD_TGE_DESCRIPCION='''||TRIM(V_TMP_TIPO_LINEA(2))||''', ' ||
            'DD_TGE_DESCRIPCION_LARGA='''||TRIM(V_TMP_TIPO_LINEA(2))||''' ' ||
            '  WHERE DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MASTER || '.' || VAR_TABLENAME || ' Actualizado DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''');
          EXECUTE IMMEDIATE V_MSQL;
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_MASTER ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TGE_EDITABLE_WEB) ' ||
                    'SELECT '||V_ESQUEMA_MASTER||'.' || 'S_' || VAR_TABLENAME || '.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(2)),'''','''''') || ''', ''PCO'',sysdate,1 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''  || V_TMP_TIPO_LINEA(1) ||''','''||TRIM(V_TMP_TIPO_LINEA(2))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '.');
    

    VAR_TABLENAME := 'DD_STA_SUBTIPO_TAREA_BASE';
  
    -- Inserción de valores en DD_STA_SUBTIPO_TAREA_BASE
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar valores');
    FOR I IN V_TIPO_LINEA2.FIRST .. V_TIPO_LINEA2.LAST
      LOOP
        V_TMP_TIPO_LINEA2 := V_TIPO_LINEA2(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || ' WHERE DD_STA_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA2(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
        IF V_NUM_TABLAS > 0 THEN        
          V_MSQL := 'UPDATE  '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || ' SET DD_STA_DESCRIPCION='''||TRIM(V_TMP_TIPO_LINEA2(2))||''', ' ||
            'DD_STA_DESCRIPCION_LARGA='''||TRIM(V_TMP_TIPO_LINEA2(2))||''' , DD_STA_GESTOR=null, DD_TAR_ID=1, ' ||
            'DTYPE=''EXTSubtipoTarea'', ' || 
            'DD_TGE_ID=(SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || V_TMP_TIPO_LINEA2(3) || ''') ' ||
            '  WHERE DD_STA_CODIGO='''||TRIM(V_TMP_TIPO_LINEA2(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MASTER || '.' || VAR_TABLENAME || ' Actualizado DD_STA_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA2(1))||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_MASTER ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_STA_ID,DD_TAR_ID,DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_STA_GESTOR,DD_TGE_ID,DTYPE) ' ||
                    'SELECT '||V_ESQUEMA_MASTER||'.' || 'S_' || VAR_TABLENAME || '.NEXTVAL, 1, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA2(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_LINEA2(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA2(2)),'''','''''') || ''', ''PCO'',sysdate, null, ' || 
                    '(SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || REPLACE(TRIM(V_TMP_TIPO_LINEA2(3)),'''','''''') || ''') ,''EXTSubtipoTarea''' || 
                    ' FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''  || V_TMP_TIPO_LINEA2(1) ||''','''||TRIM(V_TMP_TIPO_LINEA2(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '.');    
	COMMIT;
	 
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

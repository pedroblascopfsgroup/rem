/*
--##########################################
--## AUTOR=Jorge Martin
--## FECHA_CREACION=20151013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-1256
--## PRODUCTO=NO
--##
--## Finalidad: Inserción de nuevos tipos de gestor en la tabla DD_TGE_TIPO_GESTOR + DD_TDE_TIPO_DESPACHO + TGP_TIPO_GESTOR_PROPIEDAD
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
      T_LINEA('REGPROP_PCO', 'Registro de la propiedad'),
      T_LINEA('ARCHIVO_PCO', 'Archivo'),
      T_LINEA('NOTARI', 'Notaria')
    );
    V_TMP_TIPO_LINEA T_LINEA;

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

        EXECUTE IMMEDIATE V_MSQL;
    END IF;
END LOOP;


-- Inserción de valores en DD_TDE_TIPO_DESPACHO

VAR_TABLENAME := 'DD_TDE_TIPO_DESPACHO';

DBMS_OUTPUT.PUT_LINE('[INICIO 2] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar valores');

FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
  LOOP
    V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || ' WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS > 0 THEN
      V_MSQL := 'UPDATE  '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || ' SET DD_TDE_DESCRIPCION='''||TRIM(V_TMP_TIPO_LINEA(2))||''', ' ||
        'DD_TDE_DESCRIPCION_LARGA='''||TRIM(V_TMP_TIPO_LINEA(2))||''' ' ||
        '  WHERE DD_TDE_CODIGO='''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MASTER || '.' || VAR_TABLENAME || ' Actualizado DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''');

      EXECUTE IMMEDIATE V_MSQL;
    ELSE

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA_MASTER ||'.' || VAR_TABLENAME || ' (' ||
                'DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) ' ||
                'SELECT '||V_ESQUEMA_MASTER||'.' || 'S_' || VAR_TABLENAME || '.NEXTVAL, ' ||
                '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(2)),'''','''''') || ''',' ||
                '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(2)),'''','''''') || ''', ''PCO'',sysdate FROM DUAL';

        DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''  || V_TMP_TIPO_LINEA(1) ||''','''||TRIM(V_TMP_TIPO_LINEA(2))||'''');

        EXECUTE IMMEDIATE V_MSQL;
    END IF;
END LOOP;


-- TGP_TIPO_GESTOR_PROPIEDAD

DBMS_OUTPUT.PUT_LINE('[INICIO 3] TGP_TIPO_GESTOR_PROPIEDAD ... Empezando a insertar valores');

FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
  LOOP
    V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);

    V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.TGP_TIPO_GESTOR_PROPIEDAD WHERE DD_TGE_ID = ' 
    || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''' || TRIM(V_TMP_TIPO_LINEA(1)) || ''')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN

      V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear) ' || 'values (' 
        || V_ESQUEMA || q'[.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (SELECT dd_tge_id from ]' || V_ESQUEMA_MASTER ||
        '.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''' || TRIM(V_TMP_TIPO_LINEA(1)) || '''), ''DES_VALIDOS'', ''' || TRIM(V_TMP_TIPO_LINEA(1)) || ''', ''PCO'', sysdate)';

      EXECUTE IMMEDIATE V_MSQL;
    END IF;
END LOOP;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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

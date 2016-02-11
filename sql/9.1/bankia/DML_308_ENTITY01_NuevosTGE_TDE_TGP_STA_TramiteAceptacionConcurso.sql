--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20151230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-541
--## PRODUCTO=NO
--##
--## Finalidad: Inserción de nuevos tipos de gestor para trámite de Aceptacion-Concurso Bankia
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_CODIGO_STA1 VARCHAR2(50 CHAR) := 'SUP_ASIG_CONC';
    TYPE T_LINEA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA IS TABLE OF T_LINEA;
    V_TIPO_LINEA T_ARRAY_LINEA := T_ARRAY_LINEA(
      T_LINEA(V_CODIGO_STA1, 'Supervisor de asignación de letrado')
    ); 
    V_TMP_TIPO_LINEA T_LINEA;

    V_CODIGO_STA2 VARCHAR2(50 CHAR) := '37';
    V_CODIGO_TGE2 VARCHAR2(50 CHAR) := 'SUPNVL2';
    V_CODIGO_TAP1 VARCHAR2(50 CHAR) := 'P421_AsignarLetradoConcurso';
    V_CODIGO_TAP2 VARCHAR2(50 CHAR) := 'P421_RevisarTurnadoLetradoConcurso';

BEGIN

-- Inserción de valores en DD_TGE_TIPO_GESTOR

VAR_TABLENAME := 'DD_TGE_TIPO_GESTOR';

DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.' || VAR_TABLENAME || '... Empezando a insertar valores');
FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
  LOOP
    V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.' || VAR_TABLENAME || ' WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS > 0 THEN
      V_MSQL := 'UPDATE  '||V_ESQUEMA_M||'.' || VAR_TABLENAME || ' SET DD_TGE_DESCRIPCION='''||TRIM(V_TMP_TIPO_LINEA(2))||''', ' ||
        'DD_TGE_DESCRIPCION_LARGA='''||TRIM(V_TMP_TIPO_LINEA(2))||''' ' ||
        '  WHERE DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.' || VAR_TABLENAME || ' Actualizado DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''');

      EXECUTE IMMEDIATE V_MSQL;
    ELSE

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.' || VAR_TABLENAME || ' (' ||
                'DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TGE_EDITABLE_WEB) ' ||
                'SELECT '||V_ESQUEMA_M||'.' || 'S_' || VAR_TABLENAME || '.NEXTVAL, ' ||
                '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(2)),'''','''''') || ''',' ||
                '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(2)),'''','''''') || ''', ''PCO'',sysdate,1 FROM DUAL'; 
        DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''  || V_TMP_TIPO_LINEA(1) ||''','''||TRIM(V_TMP_TIPO_LINEA(2))||'''');

        EXECUTE IMMEDIATE V_MSQL;
    END IF;
END LOOP;


-- Inserción de valores en DD_TDE_TIPO_DESPACHO

VAR_TABLENAME := 'DD_TDE_TIPO_DESPACHO';

DBMS_OUTPUT.PUT_LINE('[INICIO 2] '||V_ESQUEMA_M||'.' || VAR_TABLENAME || '... Empezando a insertar valores');

FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
  LOOP
    V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.' || VAR_TABLENAME || ' WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS > 0 THEN
      V_MSQL := 'UPDATE  '||V_ESQUEMA_M||'.' || VAR_TABLENAME || ' SET DD_TDE_DESCRIPCION='''||TRIM(V_TMP_TIPO_LINEA(2))||''', ' ||
        'DD_TDE_DESCRIPCION_LARGA='''||TRIM(V_TMP_TIPO_LINEA(2))||''' ' ||
        '  WHERE DD_TDE_CODIGO='''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.' || VAR_TABLENAME || ' Actualizado DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''');

      EXECUTE IMMEDIATE V_MSQL;
    ELSE

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.' || VAR_TABLENAME || ' (' ||
                'DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) ' ||
                'SELECT '||V_ESQUEMA_M||'.' || 'S_' || VAR_TABLENAME || '.NEXTVAL, ' ||
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
    || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''' || TRIM(V_TMP_TIPO_LINEA(1)) || ''')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN

      V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear) ' || 'values (' 
        || V_ESQUEMA || q'[.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (SELECT dd_tge_id from ]' || V_ESQUEMA_M ||
        '.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''' || TRIM(V_TMP_TIPO_LINEA(1)) || '''), ''DES_VALIDOS'', ''' || TRIM(V_TMP_TIPO_LINEA(1)) || ''', ''PCO'', sysdate)';

      DBMS_OUTPUT.PUT_LINE('INSERTANDO EN TGP_TIPO_GESTOR_PROPIEDAD: ' || TRIM(V_TMP_TIPO_LINEA(1)));

      EXECUTE IMMEDIATE V_MSQL;
    END IF;
END LOOP;

-- CREACIÓN DE LA DD_STA_SUBTIPO_TAREA

DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Empezando a insertar datos en DD_STA_SUBTIPO_TAREA_BASE');
--Comprobamos el dato a insertar
V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''' || V_CODIGO_STA1 || ''' ';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN				
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Ya existe el DD_STA_SUBTIPO_TAREA_BASE PCO_TAR_APP_EXT');
ELSE
    V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE(DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR, VERSION, USUARIOCREAR, FECHACREAR,  USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TGE_ID, DTYPE)  VALUES (' ||
	V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL, ''1'', ''' || V_CODIGO_STA1 || ''', ''Tarea ' || V_CODIGO_STA1 || ''', ''Tarea ' || V_CODIGO_STA1 || ''', null, ''0'', ''DD'', sysdate, null, null, null, null, ''0'', ''0'', ''EXTSubtipoTarea'') ';   	   EXECUTE IMMEDIATE V_MSQL;
END IF;
DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.STA_SUBTIPO... Datos del subtipo de tarea insertado.');
	
-- CAMBIOS EN TAP_TAREA_PROCEDIMIENTO
V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || V_CODIGO_TAP1 || ''' ';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN				
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_STA_SUBTIPO_TAREA_BASE... Actualizar TAP_TAREA_PROCEDIMIENTO');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '||
		' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || V_CODIGO_STA1 || '''), DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||
		'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || V_CODIGO_STA1 || ''')
		WHERE tap_codigo = ''' || V_CODIGO_TAP1 || ''' ';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('TAP_TAREA_PROCEDIMIENTO ' || V_CODIGO_TAP1 || ' actualizado');
ELSE 
	DBMS_OUTPUT.PUT_LINE('TAP_TAREA_PROCEDIMIENTO ' || V_CODIGO_TAP1 || ' no existe');
END IF;
	
V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || V_CODIGO_TAP2 || ''' ';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN				
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_STA_SUBTIPO_TAREA_BASE... Actualizar TAP_TAREA_PROCEDIMIENTO');
	-- DD_STA_CODIGO=''102'' tipo de tarea correspondiente al Supervisor nivel 2 (no coincide con DD_TGE_CODIGO, tal como pasa para el caso de arriba)
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '||
		' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || V_CODIGO_STA2 || '''), DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||
		'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || V_CODIGO_TGE2 || ''')
		WHERE tap_codigo = ''' || V_CODIGO_TAP2 || ''' ';    
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('TAP_TAREA_PROCEDIMIENTO ' || V_CODIGO_TAP2 || ' actualizado');
ELSE 
	DBMS_OUTPUT.PUT_LINE('TAP_TAREA_PROCEDIMIENTO ' || V_CODIGO_TAP2 || ' no existe');
END IF;
	
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] DML_307_ENTITY01_NuevosTGE_TDE_TGP_STA_TramiteAceptacionConcurso.sql .');

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

/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20151103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-980
--## PRODUCTO=NO
--##
--## Finalidad: Inserción de nuevos tipos de gestor en la tabla DD_TDE_TIPO_DESPACHO 
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

	V_DD_TDE_ID_OFI NUMBER(16); -- Vble. para almacenar el DD_TDE_ID del tipo despacho oficina.
	V_DES_ID_OFI NUMBER(16); -- Vble. para almacenar el DES_ID del despacho oficina.

    TYPE T_LINEA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA IS TABLE OF T_LINEA;
    V_TIPO_LINEA T_ARRAY_LINEA := T_ARRAY_LINEA(
      T_LINEA('D-GESRIE', 'Despacho Gestor de riesgos')
      ,T_LINEA('D-DIRTERRIE', 'Despacho Director territorial riesgos')
      ,T_LINEA('D-DIRRIETERGCC', 'Despacho Director riesgos territoriales GCC')
    );
    V_TMP_TIPO_LINEA T_LINEA;

BEGIN

-- Inserción de valores en DD_TDE_TIPO_DESPACHO

VAR_TABLENAME := 'DD_TDE_TIPO_DESPACHO';

DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar valores');

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


-- Insertar despacho tipo Gestor de riesgos

V_SQL := 'SELECT DD_TDE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''D-GESRIE''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TDE_ID_OFI;

DBMS_OUTPUT.PUT_LINE('[INFO] Se consulta si existe un DES_DESPACHO_EXTERNO con tipo Gestor de riesgos');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = ' || V_DD_TDE_ID_OFI;
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO DES_DESPACHO_EXTERNO con tipo Gestor de riesgos');

	V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, DD_TDE_ID) VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, ''Despacho Gestor de riesgos'', 0, ''DD'', sysdate, ' || V_DD_TDE_ID_OFI || ')'; 
	EXECUTE IMMEDIATE V_MSQL;
END IF;

-- Insertar despacho tipo Director territorial riesgos

V_SQL := 'SELECT DD_TDE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''D-DIRTERRIE''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TDE_ID_OFI;

DBMS_OUTPUT.PUT_LINE('[INFO] Se consulta si existe un DES_DESPACHO_EXTERNO con tipo Director territorial riesgos');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = ' || V_DD_TDE_ID_OFI;
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO DES_DESPACHO_EXTERNO con tipo Director territorial riesgos');

	V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, DD_TDE_ID) VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, ''Despacho Director territorial riesgos'', 0, ''DD'', sysdate, ' || V_DD_TDE_ID_OFI || ')'; 
	EXECUTE IMMEDIATE V_MSQL;
END IF;

-- Insertar despacho tipo Director riesgos territoriales GCC

V_SQL := 'SELECT DD_TDE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''D-DIRRIETERGCC''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TDE_ID_OFI;

DBMS_OUTPUT.PUT_LINE('[INFO] Se consulta si existe un DES_DESPACHO_EXTERNO con tipo Director riesgos territoriales GCC');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = ' || V_DD_TDE_ID_OFI;
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO DES_DESPACHO_EXTERNO con tipo Director riesgos territoriales GCC');

	V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, DD_TDE_ID) VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, ''Despacho Director riesgos territoriales GCC'', 0, ''DD'', sysdate, ' || V_DD_TDE_ID_OFI || ')'; 
	EXECUTE IMMEDIATE V_MSQL;
END IF;

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

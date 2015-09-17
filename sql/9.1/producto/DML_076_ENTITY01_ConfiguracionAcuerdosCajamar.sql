--/*
--##########################################
--## AUTOR=PEDROBLASCOS
--## FECHA_CREACION=20150916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-174
--## PRODUCTO=NO
--##
--## Finalidad: CONFIGURACIÓN DE ACUERDOS CAJAMAR
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SUBCONSULTA1 VARCHAR2(200 CHAR); -- Nombre de la tabla a crear
    VAR_SUBCONSULTA2 VARCHAR2(200 CHAR); -- Nombre de la tabla a crear

    TYPE T_LINEA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA IS TABLE OF T_LINEA;
    V_TIPO_LINEA T_ARRAY_LINEA := T_ARRAY_LINEA(
      T_LINEA('OFICINA', 'DIRTER', 'DEPRECUDE'),
      T_LINEA('GESRIESGO', 'DEPRECUDE', 'DEPRECUDE'),
      T_LINEA('DIRRIESGO', 'DEPRECUDE', 'DEPRECUDE'),
      T_LINEA('HRE', 'DEPRECUDE', 'DEPRECUDE'),
      T_LINEA('ASECON', 'DEPRECUDE', 'DEPRECUDE'),
      T_LINEA('DEPRECUDE', 'DEPRECUDE', 'DEPRECUDE')
    ); 
    V_TMP_TIPO_LINEA T_LINEA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('CONFIGURACIÓN DE ACUERDOS CAJAMAR');
	DBMS_OUTPUT.PUT_LINE('***** Inserción -- Nuevos tipos de gestor ******');


    VAR_TABLENAME := 'ACU_CONFIG_ACUERDO_ASUNTO';
	VAR_SUBCONSULTA1 := '(SELECT DD_TDE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO=''';
	VAR_SUBCONSULTA2 := ''')';

    DBMS_OUTPUT.PUT_LINE(VAR_SUBCONSULTA1 ||  VAR_TABLENAME || VAR_SUBCONSULTA2);

    -- Inserción de valores en DD_TGE_TIPO_GESTOR
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar valores');
    FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
      LOOP
        V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE DD_TDE_ID_PROPONENTE = ' || 
        		VAR_SUBCONSULTA1 || V_TMP_TIPO_LINEA(1) || VAR_SUBCONSULTA2;
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          V_MSQL := 'UPDATE  '||V_ESQUEMA||'.' || VAR_TABLENAME || 
          	' SET DD_TDE_ID_VALIDADOR=' || VAR_SUBCONSULTA1 || V_TMP_TIPO_LINEA(2) || VAR_SUBCONSULTA2 ||
            ', DD_TDE_ID_DECISOR=' || VAR_SUBCONSULTA1 || V_TMP_TIPO_LINEA(3) || VAR_SUBCONSULTA2 ||
            ' WHERE DD_TDE_ID_PROPONENTE=' || VAR_SUBCONSULTA1 || V_TMP_TIPO_LINEA(1) || VAR_SUBCONSULTA2;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' Actualizado DD_TDE_ID_PROPONENTE = ' || V_TMP_TIPO_LINEA(1));
          EXECUTE IMMEDIATE V_MSQL;
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'ACU_DGE_ID,DD_TDE_ID_PROPONENTE,DD_TDE_ID_VALIDADOR,DD_TDE_ID_DECISOR,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                    'SELECT '||V_ESQUEMA||'.' || 'S_' || VAR_TABLENAME || '.NEXTVAL, ' ||
                    	VAR_SUBCONSULTA1 || V_TMP_TIPO_LINEA(1) || VAR_SUBCONSULTA2 || ',' ||
                    	VAR_SUBCONSULTA1 || V_TMP_TIPO_LINEA(2) || VAR_SUBCONSULTA2 || ',' ||
                    	VAR_SUBCONSULTA1 || V_TMP_TIPO_LINEA(3) || VAR_SUBCONSULTA2 || ',' ||
                    	' 0, ''PCO'', sysdate, 0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''  || V_TMP_TIPO_LINEA(1) ||''','''||TRIM(V_TMP_TIPO_LINEA(2))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
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

--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta los valores de prueba de categorizaciones.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    
    --Valores en CTG_CATEGORIZACIONES
    TYPE T_CTG_CATEGORIZACIONES IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_CTG IS TABLE OF T_CTG_CATEGORIZACIONES;
    V_CTG_CATEGORIZACIONES T_ARRAY_CTG := T_ARRAY_CTG(
      T_CTG_CATEGORIZACIONES('Prioridad',0,'MOD_PROC',SYSDATE,0,'PRIORIDAD'),
      T_CTG_CATEGORIZACIONES('Tipo de procedimiento',0,'MOD_PROC',SYSDATE,0,'TIPO_PROC'),
      T_CTG_CATEGORIZACIONES('Buzones CDD',0,'MOD_PROC',SYSDATE,0,'CDD')
    );   
    V_TMP_CTG_CATEGORIZACIONES T_CTG_CATEGORIZACIONES;

BEGIN	

      -- LOOP Insertando valores en CTG_CATEGORIZACIONES ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.CTG_CATEGORIZACIONES... Empezando a insertar datos en CTG_CATEGORIZACIONES');
    FOR I IN V_CTG_CATEGORIZACIONES.FIRST .. V_CTG_CATEGORIZACIONES.LAST
      LOOP
            V_TMP_CTG_CATEGORIZACIONES := V_CTG_CATEGORIZACIONES(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CTG_CATEGORIZACIONES WHERE CTG_CODIGO = '''||TRIM(V_TMP_CTG_CATEGORIZACIONES(6))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CTG_CATEGORIZACIONES... Ya existe el CTG_CATEGORIZACIONES '''|| TRIM(V_TMP_CTG_CATEGORIZACIONES(6)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CTG_CATEGORIZACIONES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CTG_CATEGORIZACIONES (' ||
                      'CTG_ID, CTG_NOMBRE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CTG_CODIGO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_CTG_CATEGORIZACIONES(1)||''', '''||V_TMP_CTG_CATEGORIZACIONES(2)||''''||
					  ','''||V_TMP_CTG_CATEGORIZACIONES(3)||''', '''||V_TMP_CTG_CATEGORIZACIONES(4)||''''||
					  ','''||V_TMP_CTG_CATEGORIZACIONES(5)||''', '''||V_TMP_CTG_CATEGORIZACIONES(6)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_CTG_CATEGORIZACIONES(6)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.CTG_CATEGORIZACIONES... Datos de la categorizacion insertados');
    
    
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
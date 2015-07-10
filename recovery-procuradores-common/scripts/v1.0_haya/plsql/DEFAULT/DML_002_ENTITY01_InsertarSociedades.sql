--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta los valores de prueba la relación entre procurador y sociedad.
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
    
    --Valores en PSP_PROC_SOCI_PROCS
    TYPE T_SCP_SOCIEDAD_PROCU IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_SCP IS TABLE OF T_SCP_SOCIEDAD_PROCU;
    V_SCP_SOCIEDAD_PROCU T_ARRAY_SCP := T_ARRAY_SCP(
      T_SCP_SOCIEDAD_PROCU('Sociedad 1'),
      T_SCP_SOCIEDAD_PROCU('Sociedad 2'),
      T_SCP_SOCIEDAD_PROCU('Sociedad 3'),
      T_SCP_SOCIEDAD_PROCU('Sociedad 4'),
      T_SCP_SOCIEDAD_PROCU('Sociedad 5'),
      T_SCP_SOCIEDAD_PROCU('Sociedad 6')
    );   
    V_TMP_SCP_SOCIEDAD_PROCU T_SCP_SOCIEDAD_PROCU;

BEGIN	

      -- LOOP Insertando valores en SCP_SOCIEDAD_PROCURADORES ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.SCP_SOCIEDAD_PROCURADORES... Empezando a insertar datos en SCP_SOCIEDAD_PROCURADORES');
    FOR I IN V_SCP_SOCIEDAD_PROCU.FIRST .. V_SCP_SOCIEDAD_PROCU.LAST
      LOOP
            V_TMP_SCP_SOCIEDAD_PROCU := V_SCP_SOCIEDAD_PROCU(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SCP_SOCIEDAD_PROCURADORES WHERE NOMBRE = '''||TRIM(V_TMP_SCP_SOCIEDAD_PROCU(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SCP_SOCIEDAD_PROCURADORES... Ya existe el SCP_SOCIEDAD_PROCURADORES '''|| TRIM(V_TMP_SCP_SOCIEDAD_PROCU(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_SCP_SOCIEDAD_PROCURADORES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.SCP_SOCIEDAD_PROCURADORES (' ||
                      'SOC_PRO_ID, NOMBRE)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_SCP_SOCIEDAD_PROCU(1)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_SCP_SOCIEDAD_PROCU(1)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.SCP_SOCIEDAD_PROCURADORES... Datos de la sociedad insertados');
    
    
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
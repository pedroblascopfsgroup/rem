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
    TYPE T_PSP_PROC_SOCI_PROCS IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PSP IS TABLE OF T_PSP_PROC_SOCI_PROCS;
    V_PSP_PROC_SOCI_PROCS T_ARRAY_PSP := T_ARRAY_PSP(
      T_PSP_PROC_SOCI_PROCS(1,1),
      T_PSP_PROC_SOCI_PROCS(2,1),
      T_PSP_PROC_SOCI_PROCS(4,1),
      T_PSP_PROC_SOCI_PROCS(1,2),
      T_PSP_PROC_SOCI_PROCS(3,3),
      T_PSP_PROC_SOCI_PROCS(5,3),
      T_PSP_PROC_SOCI_PROCS(5,4),
      T_PSP_PROC_SOCI_PROCS(2,5),
      T_PSP_PROC_SOCI_PROCS(5,5)
    );   
    V_TMP_PSP_PROC_SOCI_PROCS T_PSP_PROC_SOCI_PROCS;

BEGIN	

      -- LOOP Insertando valores en PSP_PROC_SOCI_PROCS ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.PSP_PROC_SOCI_PROCS... Empezando a insertar datos en PSP_PROC_SOCI_PROCS');
    FOR I IN V_PSP_PROC_SOCI_PROCS.FIRST .. V_PSP_PROC_SOCI_PROCS.LAST
      LOOP
            V_TMP_PSP_PROC_SOCI_PROCS := V_PSP_PROC_SOCI_PROCS(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PSP_PROC_SOCI_PROCS WHERE PRO_ID = '''||TRIM(V_TMP_PSP_PROC_SOCI_PROCS(1))||''' AND SOC_PRO_ID = '''||TRIM(V_TMP_PSP_PROC_SOCI_PROCS(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PSP_PROC_SOCI_PROCS... Ya existe el PSP_PROC_SOCI_PROCS ('''||V_TMP_PSP_PROC_SOCI_PROCS(1)||''', '''||V_TMP_PSP_PROC_SOCI_PROCS(2)||''')');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_PSP_PROC_SOCI_PROCS.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.PSP_PROC_SOCI_PROCS (' ||
                      'PR_SOC_ID, PRO_ID, SOC_PRO_ID)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_PSP_PROC_SOCI_PROCS(1)||''','''||V_TMP_PSP_PROC_SOCI_PROCS(2)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: ('''||V_TMP_PSP_PROC_SOCI_PROCS(1)||''', '''||V_TMP_PSP_PROC_SOCI_PROCS(2)||''') ');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.PSP_PROC_SOCI_PROCS... Datos de la sociedad insertados');
    
    
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
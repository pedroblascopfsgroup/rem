--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta el perfil de procurador
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
    
    
    
    --Valores en PEF_PERFILES
    TYPE T_PEF_PERFILES IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PEF IS TABLE OF T_PEF_PERFILES;
    V_PEF_PERFILES T_ARRAY_PEF := T_ARRAY_PEF(
      T_PEF_PERFILES(10000000000700,'Gestor Procurador', 'Gestor Procurador', 0, 'MOD_PROC', SYSDATE, 0, 'FPFSRPROC', 0, 'EXTPerfil')
    );   
    V_TMP_PEF_PERFILES T_PEF_PERFILES;

BEGIN	

      -- LOOP Insertando valores en PEF_PERFILES ------------------------------------------------------------------------
      
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.PEF_PERFILES... Empezando a insertar datos en PEF_PERFILES');
    FOR I IN V_PEF_PERFILES.FIRST .. V_PEF_PERFILES.LAST
      LOOP
            V_TMP_PEF_PERFILES := V_PEF_PERFILES(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_DESCRIPCION = '''||TRIM(V_TMP_PEF_PERFILES(3))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PEF_PERFILES... Ya existe el PEF_PERFILES '''|| TRIM(V_TMP_PEF_PERFILES(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.PEF_PERFILES (' ||
                      'PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO, DTYPE)' ||
                      'SELECT '''||V_TMP_PEF_PERFILES(1)||''', '''||V_TMP_PEF_PERFILES(2)||''''||
					  ','''||V_TMP_PEF_PERFILES(3)||''', '''||V_TMP_PEF_PERFILES(4)||''''||
					  ','''||V_TMP_PEF_PERFILES(5)||''', '''||V_TMP_PEF_PERFILES(6)||''''||
					  ','''||V_TMP_PEF_PERFILES(7)||''', '''||V_TMP_PEF_PERFILES(8)||''''||
					  ','''||V_TMP_PEF_PERFILES(9)||''', '''||V_TMP_PEF_PERFILES(10)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_PEF_PERFILES(3)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.PEF_PERFILES... Datos del perfil insertados');
    
    
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
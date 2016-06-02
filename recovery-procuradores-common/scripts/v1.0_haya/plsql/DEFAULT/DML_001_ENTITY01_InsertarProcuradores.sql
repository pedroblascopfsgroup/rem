--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta los valores de prueba de procuradores.
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
    
    --Valores en PRO_PROCURADORES
    TYPE T_PRO_PROCURADORES IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PRO IS TABLE OF T_PRO_PROCURADORES;
    V_PRO_PROCURADORES T_ARRAY_PRO := T_ARRAY_PRO(
      T_PRO_PROCURADORES('Procurador 1'),
      T_PRO_PROCURADORES('Procurador 2'),
      T_PRO_PROCURADORES('Procurador 3'),
      T_PRO_PROCURADORES('Procurador 4'),
      T_PRO_PROCURADORES('Procurador 5')
    );   
    V_TMP_PRO_PROCURADORES T_PRO_PROCURADORES;

BEGIN	

      -- LOOP Insertando valores en PRO_PROCURADORES ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.PRO_PROCURADORES... Empezando a insertar datos en PRO_PROCURADORES');
    FOR I IN V_PRO_PROCURADORES.FIRST .. V_PRO_PROCURADORES.LAST
      LOOP
            V_TMP_PRO_PROCURADORES := V_PRO_PROCURADORES(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PRO_PROCURADORES WHERE NOMBRE = '''||TRIM(V_TMP_PRO_PROCURADORES(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRO_PROCURADORES... Ya existe el PRO_PROCURADOR '''|| TRIM(V_TMP_PRO_PROCURADORES(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_PRO_PROCURADORES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.PRO_PROCURADORES (' ||
                      'PRO_ID, NOMBRE)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_PRO_PROCURADORES(1)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_PRO_PROCURADORES(1)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.PRO_PROCURADORES... Datos del procurador insertados');
    
    
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
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
    
    --Valores en DD_EPF_ESTADO_PROCES_FICH
    TYPE T_EPF_ESTADO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_EPF IS TABLE OF T_EPF_ESTADO;
    V_EPF_ESTADO T_ARRAY_EPF := T_ARRAY_EPF(
      T_EPF_ESTADO('PAU', 'Pausado', 'Pausado', 0, 'DD', SYSDATE, 0)
    );   
    V_TMP_EPF_ESTADO T_EPF_ESTADO;

BEGIN	

      -- LOOP Insertando valores en DD_EPF_ESTADO_PROCES_FICH ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_EPF_ESTADO_PROCES_FICH... Empezando a insertar datos en DD_EPF_ESTADO_PROCES_FICH');
    FOR I IN V_EPF_ESTADO.FIRST .. V_EPF_ESTADO.LAST
      LOOP
            V_TMP_EPF_ESTADO := V_EPF_ESTADO(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EPF_ESTADO_PROCES_FICH WHERE DD_EPF_CODIGO = '''||TRIM(V_TMP_EPF_ESTADO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_EPF_ESTADO_PROCES_FICH... Ya existe el DD_EPF_ESTADO_PROCES_FICH '''|| TRIM(V_TMP_EPF_ESTADO(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_EPF_ESTADO_PROCES_FICH.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EPF_ESTADO_PROCES_FICH (' ||
                      'DD_EPF_ID, DD_EPF_CODIGO, DD_EPF_DESCRIPCION, DD_EPF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_EPF_ESTADO(1)||''','''||V_TMP_EPF_ESTADO(2)||''','''||V_TMP_EPF_ESTADO(3)||''','''||V_TMP_EPF_ESTADO(4)||''','''||V_TMP_EPF_ESTADO(5)||''',SYSDATE,'''||V_TMP_EPF_ESTADO(7)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_EPF_ESTADO(1)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_EPF_ESTADO_PROCES_FICH... Datos del estado insertados');
    
    
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
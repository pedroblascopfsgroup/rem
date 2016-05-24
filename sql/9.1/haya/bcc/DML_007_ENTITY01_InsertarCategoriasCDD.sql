--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta los valores de prueba de categorias de la CDD.
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
    V_CTG_ID VARCHAR2(20 CHAR); -- Vble. auxiliar par almacenar la categorización que queramos.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
    --Valores en CAT_CATEGORIAS
    TYPE T_CAT_CATEGORIAS IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_CAT IS TABLE OF T_CAT_CATEGORIAS;
    V_CAT_CATEGORIAS T_ARRAY_CAT := T_ARRAY_CAT(
      T_CAT_CATEGORIAS('Documentación', 'Documentación', 0, 'MOD_PROC',SYSDATE,0,1),
      T_CAT_CATEGORIAS('Sin Respuesta', 'Sin Respuesta', 0, 'MOD_PROC',SYSDATE,0,2),
      T_CAT_CATEGORIAS('Con Plazo', 'Con Plazo', 0, 'MOD_PROC',SYSDATE,0,3),
      T_CAT_CATEGORIAS('Subastas', 'Subastas', 0, 'MOD_PROC',SYSDATE,0,4),
      T_CAT_CATEGORIAS('Sin Plazo', 'Sin Plazo', 0, 'MOD_PROC',SYSDATE,0,5),
      T_CAT_CATEGORIAS('Minutas', 'Minutas', 0, 'MOD_PROC',SYSDATE,0,6),
      T_CAT_CATEGORIAS('Acta Subastas', 'Acta Subastas', 0, 'MOD_PROC',SYSDATE,0,7),
      T_CAT_CATEGORIAS('Toma y Lanzamiento', 'Toma y Lanzamiento', 0, 'MOD_PROC',SYSDATE,0,8),
      T_CAT_CATEGORIAS('Otros', 'Otros', 0, 'MOD_PROC',SYSDATE,0,9),
      T_CAT_CATEGORIAS('Otros resto procedimientos', 'Otros resto procedimientos', 0, 'MOD_PROC',SYSDATE,0,10),
      T_CAT_CATEGORIAS('Ordinario con tarea', 'Ordinario con tarea', 0, 'MOD_PROC',SYSDATE,0,11),
      T_CAT_CATEGORIAS('Prioritario con plazo', 'Prioritario con plazo', 0, 'MOD_PROC',SYSDATE,0,12),
      T_CAT_CATEGORIAS('Prioritario sin plazo', 'Prioritario sin plazo', 0, 'MOD_PROC',SYSDATE,0,13)
    );   
    V_TMP_CAT_CATEGORIAS T_CAT_CATEGORIAS;

BEGIN	

      -- LOOP Insertando valores en CAT_CATEGORIAS ------------------------------------------------------------------------
      
    --Obtenemos categorización de la CDD
    V_SQL := 'SELECT CTG_ID FROM '||V_ESQUEMA||'.CTG_CATEGORIZACIONES WHERE CTG_CODIGO = ''CDD''';
    EXECUTE IMMEDIATE V_SQL INTO V_CTG_ID;
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.CAT_CATEGORIAS... Empezando a insertar datos en CAT_CATEGORIAS');
    FOR I IN V_CAT_CATEGORIAS.FIRST .. V_CAT_CATEGORIAS.LAST
      LOOP
            V_TMP_CAT_CATEGORIAS := V_CAT_CATEGORIAS(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CAT_CATEGORIAS WHERE CAT_NOMBRE = '''||TRIM(V_TMP_CAT_CATEGORIAS(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CAT_CATEGORIAS... Ya existe el CAT_CATEGORIAS '''|| TRIM(V_TMP_CAT_CATEGORIAS(1)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CAT_CATEGORIAS.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CAT_CATEGORIAS (' ||
                      'CAT_ID, CTG_ID, CAT_NOMBRE, CAT_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CAT_ORDEN)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','|| V_CTG_ID ||', '''||V_TMP_CAT_CATEGORIAS(1)||''''||
					  ','''||V_TMP_CAT_CATEGORIAS(2)||''', '''||V_TMP_CAT_CATEGORIAS(3)||''''||
					  ','''||V_TMP_CAT_CATEGORIAS(4)||''', '''||V_TMP_CAT_CATEGORIAS(5)||''''||
					  ','''||V_TMP_CAT_CATEGORIAS(6)||''', '''||V_TMP_CAT_CATEGORIAS(7)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_CAT_CATEGORIAS(1)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.CAT_CATEGORIAS... Datos de la categoria insertados');
    
    
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
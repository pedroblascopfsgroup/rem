--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta tipos de acción.
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
    V_TPROCE VARCHAR2(100 CHAR); -- Vble. auxiliar para obtener tipo procedimiento.
    
    
    
    --Valores en FUN_PEF
    TYPE T_TIPO_ACCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TA IS TABLE OF T_TIPO_ACCION;
    V_TIPO_ACCION T_ARRAY_TA := T_ARRAY_TA(
      T_TIPO_ACCION('UPLOAD', 'Subir Ficheros', 'Subir Ficheros', 0, 'MOD_PROC', SYSDATE, 0),
      T_TIPO_ACCION('TAREAS', 'Tareas', 'Tareas', 0, 'MOD_PROC', SYSDATE, 0),
      T_TIPO_ACCION('AUTOTAREA', 'Autotarea', 'Autotarea', 0, 'MOD_PROC', SYSDATE, 0),
      T_TIPO_ACCION('NOTIFICACION', 'Notificacion', 'Notificacion', 0, 'MOD_PROC', SYSDATE, 0)
    );   
    V_TMP_TIPO_ACCION T_TIPO_ACCION;

BEGIN	

      -- LOOP Insertando valores en BPM_DD_TAC_TIPO_ACCION ------------------------------------------------------------------------
     
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.BPM_DD_TAC_TIPO_ACCION... Empezando a insertar datos en BPM_DD_TAC_TIPO_ACCION');
    FOR I IN V_TIPO_ACCION.FIRST .. V_TIPO_ACCION.LAST
      LOOP
        V_TMP_TIPO_ACCION := V_TIPO_ACCION(I);
        
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO = '''||V_TMP_TIPO_ACCION(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.BPM_DD_TAC_TIPO_ACCION... Ya existe el BPM_DD_TAC_CODIGO '''||V_TMP_TIPO_ACCION(1)||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_BPM_DD_TAC_TIPO_ACCION.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.BPM_DD_TAC_TIPO_ACCION (' ||
                      'BPM_DD_TAC_ID, BPM_DD_TAC_CODIGO, BPM_DD_TAC_DESCRIPCION, BPM_DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ', '''||V_TMP_TIPO_ACCION(1)||''''||
					  ','''||V_TMP_TIPO_ACCION(2)||''', '''||V_TMP_TIPO_ACCION(3)||''''||
					  ','''||V_TMP_TIPO_ACCION(4)||''', '''||V_TMP_TIPO_ACCION(5)||''''||
					  ','''||V_TMP_TIPO_ACCION(6)||''', '''||V_TMP_TIPO_ACCION(7)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_ACCION(1)||''' - '''||V_TMP_TIPO_ACCION(2)||''' ');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.V_TMP_TIPO_ACCION... Datos del tipo de accion insertados.');
    
    
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
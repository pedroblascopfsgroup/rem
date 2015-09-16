--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20150907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=PRODUCTO-180
--## PRODUCTO=SI
--##
--## Finalidad: Inserta el Subtipo de tarea Aceptar Acuerdo en DD_TGE_TIPO_GESTOR
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
    
    --Valores en DD_TGE_TIPO_GESTOR
    TYPE T_STA_SUBTIPO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_STA IS TABLE OF T_STA_SUBTIPO;
    V_STA_SUBTIPO T_ARRAY_STA := T_ARRAY_STA(
      T_STA_SUBTIPO('VALID_ACEPT_ACU', 'Validador aceptacion acuerdo', 'Validador aceptacion acuerdo', 0, 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0),
      T_STA_SUBTIPO('ACEPT_ACU', 'Aceptacion acuerdo', 'Aceptacion acuerdo', 0, 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0),
      T_STA_SUBTIPO('GEST_ACU', 'Gestiones cierre acuerdo', 'Gestiones cierre acuerdo', 0, 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0)
    );   
    V_TMP_STA_SUBTIPO T_STA_SUBTIPO;

BEGIN	

      -- LOOP Insertando valores en DD_TGE_TIPO_GESTOR ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR... Empezando a insertar datos en DD_TGE_TIPO_GESTOR');
    FOR I IN V_STA_SUBTIPO.FIRST .. V_STA_SUBTIPO.LAST
      LOOP
            V_TMP_STA_SUBTIPO := V_STA_SUBTIPO(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_STA_SUBTIPO(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR... Ya existe el DD_TGE_TIPO_GESTOR '''|| TRIM(V_TMP_STA_SUBTIPO(2)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_TGE_TIPO_GESTOR.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR (' ||
                      'DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, DD_TGE_EDITABLE_WEB, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_STA_SUBTIPO(1)||''','''||V_TMP_STA_SUBTIPO(2)||''','''||V_TMP_STA_SUBTIPO(3)||''''||
						','''||V_TMP_STA_SUBTIPO(4)||''','''||V_TMP_STA_SUBTIPO(5)||''','''||V_TMP_STA_SUBTIPO(6)||''''||
						','''||V_TMP_STA_SUBTIPO(7)||''','''||V_TMP_STA_SUBTIPO(8)||''','''||V_TMP_STA_SUBTIPO(9)||''''||
						','''||V_TMP_STA_SUBTIPO(10)||''','''||V_TMP_STA_SUBTIPO(11)||''','''||V_TMP_STA_SUBTIPO(12)||''' FROM DUAL';
             
			DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_STA_SUBTIPO(2)||'''');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.STA_SUBTIPO... Datos del tipo de gestor.');
    
    
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
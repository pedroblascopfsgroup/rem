--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20150916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=PRODUCTO-180
--## PRODUCTO=SI
--##
--## Finalidad: Update el Subtipo de tarea Aceptar Acuerdo en DD_STA_SUBTIPO_TAREA_BASE
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
    V_SQL_TGE VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TGE.  
    V_ID_TGE VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TGE
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    --Valores en DD_STA_SUBTIPO_TAREA_BASE
    TYPE T_STA_SUBTIPO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_STA IS TABLE OF T_STA_SUBTIPO;
    V_STA_SUBTIPO T_ARRAY_STA := T_ARRAY_STA(
      T_STA_SUBTIPO(1, 'ACP_ACU', 'Aceptacion acuerdo', 'Aceptacion acuerdo', NULL, 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0, 'VALIACU', 'EXTSubtipoTarea'),
      T_STA_SUBTIPO(1, 'REV_ACU', 'Revisión acuerdo aceptado', 'Revisión acuerdo aceptado', NULL, 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0, 'DECIACU', 'EXTSubtipoTarea'),
      T_STA_SUBTIPO(1, 'GST_CIE_ACU', 'Gestiones para cierre acuerdo', 'Gestiones para cierre acuerdo', NULL, 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0, 'PROPACU', 'EXTSubtipoTarea')
    );   
    V_TMP_STA_SUBTIPO T_STA_SUBTIPO;

BEGIN	

      -- LOOP Insertando valores en DD_STA_SUBTIPO_TAREA_BASE ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Empezando a insertar datos en DD_STA_SUBTIPO_TAREA_BASE');
    FOR I IN V_STA_SUBTIPO.FIRST .. V_STA_SUBTIPO.LAST
      LOOP
            V_TMP_STA_SUBTIPO := V_STA_SUBTIPO(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '''||TRIM(V_TMP_STA_SUBTIPO(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE... Actualizando.... '''|| TRIM(V_TMP_STA_SUBTIPO(2)) ||'''');
        
          V_SQL_TGE := 'SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_TMP_STA_SUBTIPO(14)||'''';
          EXECUTE IMMEDIATE V_SQL_TGE INTO V_ID_TGE;
          DBMS_OUTPUT.put_line(' Se ha obtenido el DD_TGE_ID: '||V_ID_TGE);
        
          V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.DD_STA_SUBTIPO_TAREA_BASE '||
                    'SET DD_TGE_ID = '''||V_ID_TGE||''''|| 
					'WHERE DD_STA_CODIGO = '''||V_TMP_STA_SUBTIPO(2)||'''';
          
		EXECUTE IMMEDIATE V_MSQL;
          
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.STA_SUBTIPO... Datos del subtipo de tarea updateado.');
    
    
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
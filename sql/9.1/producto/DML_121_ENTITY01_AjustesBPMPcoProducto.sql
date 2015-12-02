--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20151013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy
--## INCIDENCIA_LINK=PRODUCTO-306
--## PRODUCTO=SI
--##
--## Finalidad: Modificaciones BPM Precontencioso Producto
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

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
	
    V_TABLENAME VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    -- Actualización de script de decision de las tareas
    TYPE T_LINEA3 IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA3 IS TABLE OF T_LINEA3;
    V_AUX VARCHAR2(1000) := 'valores[''''PCO_RegistrarTomaDec''''][''''observaciones'''']';
    V_TIPO_LINEA3 T_ARRAY_LINEA3 := T_ARRAY_LINEA3(
        T_LINEA3('PCO_RevisarSubsanacion', V_AUX),
        T_LINEA3('PCO_SubsanarCambioProc', V_AUX),
        T_LINEA3('PCO_SubsanarIncidenciaExp', V_AUX)
    ); 
    V_TMP_TIPO_LINEA3 T_LINEA3;
    
BEGIN	

    V_TABLENAME := 'tfi_tareas_form_items';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a actualizar campo decisión de tareas');
    FOR I IN V_TIPO_LINEA3.FIRST .. V_TIPO_LINEA3.LAST
      LOOP
        V_TMP_TIPO_LINEA3 := V_TIPO_LINEA3(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || V_TABLENAME || 
                '  WHERE TAP_ID= (SELECT TAP_ID FROM ' || V_ESQUEMA || 
                '.tap_tarea_procedimiento WHERE TAP_CODIGO='''|| TRIM(V_TMP_TIPO_LINEA3(1)) ||''')';
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
        IF V_NUM_TABLAS > 0 THEN        
            V_MSQL := 'UPDATE  '||V_ESQUEMA||'.' || V_TABLENAME || 
                ' SET tfi_valor_inicial=''' || TRIM(V_TMP_TIPO_LINEA3(2)) || 
                '''  WHERE TAP_ID= (SELECT TAP_ID FROM ' || V_ESQUEMA || 
                '.tap_tarea_procedimiento WHERE TAP_CODIGO='''|| TRIM(V_TMP_TIPO_LINEA3(1)) ||''')';
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        ELSE
            DBMS_OUTPUT.PUT_LINE('HAY QUE INSERTAR ESTA FILA: '  || V_TMP_TIPO_LINEA3(1));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '.');

    COMMIT;
   
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
EXIT

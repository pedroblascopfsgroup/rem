/*
--##########################################
--## AUTOR=Carlos Martos
--## FECHA_CREACION=20160623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2128
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Actualiza los plazos de tareas por obsolescencia y problemas con migracion
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(

     T_TIPO_PLAZAS('H002_AdjuntarTasaciones','(valores[''H002_SenyalamientoSubasta''] != null && valores[''H002_SenyalamientoSubasta][fechaSenyalamiento''] != null) ? damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])-15*24*60*60*1000L : 1*24*60*60*1000L','RECOVERY-2128')
    ,T_TIPO_PLAZAS('H002_SolicitarInformeFiscal','(valores[''H002_SenyalamientoSubasta''] != null && valores[''H002_SenyalamientoSubasta][fechaSenyalamiento''] != null) ? damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])-20*24*60*60*1000L : 1*24*60*60*1000L','RECOVERY-2128')
    ,T_TIPO_PLAZAS('H002_AdjuntarNotasSimples','(valores[''H002_SenyalamientoSubasta''] != null && valores[''H002_SenyalamientoSubasta][fechaSenyalamiento''] != null) ? damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])-30*24*60*60*1000L : 1*24*60*60*1000L','RECOVERY-2128')
    ,T_TIPO_PLAZAS('H002_PrepararInformeSubasta','(valores[''H002_SenyalamientoSubasta''] != null && valores[''H002_SenyalamientoSubasta][fechaSenyalamiento''] != null) ? damePlazo(valores[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])-25*24*60*60*1000L : 1*24*60*60*1000L','RECOVERY-2128')
  
  ); 
  V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
BEGIN   
    
  
    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a actualizar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(1))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
        IF V_NUM_TABLAS > 0 THEN        
    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(2)),'''','''''') || ''',' ||
             ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(3)),'''','''''') || ''',' ||
             ' FECHAMODIFICAR=sysdate ' ||
             ' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(1))||''')';
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Se actualiza el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(1)) ||'''');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Los plazos que intenta actualizar no existen');
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');
    

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

/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20151105
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-979
--## PRODUCTO=SI
--##
--## Finalidad: Inserción de nuevos tipos de gestor y nuevos tipos de subtarea
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_LINEA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA IS TABLE OF T_LINEA;
    V_TIPO_LINEA T_ARRAY_LINEA := T_ARRAY_LINEA(
--T_LINEA('PCO_PreTurnadoManual','PCO_PREDOC','2','SUP_PCO'),
--T_LINEA('PCO_PreTurnado','PCO_PREDOC','2','SUP_PCO'),
--T_LINEA('PCO_RegistrarAceptacion','PCO_LET','2','SUP_PCO'),
--T_LINEA('PCO_RevisarNoAceptacion','PCO_SUP','2','SUP_PCO'),
T_LINEA('PCO_PrepararExpediente','PCO_CM_GE','45','SUP_PCO'),
T_LINEA('PCO_SolicitarDoc','PCO_CM_GD','2','SUP_PCO'),
--T_LINEA('PCO_PostTurnado','PCO_PREDOC','2','SUP_PCO'),
--T_LINEA('PCO_RegistrarAceptacionPost','PCO_LET','2','SUP_PCO'),
--T_LINEA('PCO_RevisarNoAceptacionPost','PCO_SUP','2','SUP_PCO'),
--T_LINEA('PCO_EnviarExpedienteLetrado','PCO_PREDOC','2','SUP_PCO'), -- DUDA 
--T_LINEA('PCO_RegistrarTomaDec','PCO_LET','7','SUP_PCO'),
--T_LINEA('PCO_RevisarSubsanacion','PCO_SUP','2','SUP_PCO'),
--T_LINEA('PCO_IniciarProcJudicial','PCO_SUP','2','SUP_PCO'),
T_LINEA('PCO_SubsanarIncidenciaExp','PCO_CM_GE','10','SUP_PCO'),
--T_LINEA('PCO_ValidarCambioProc','PCO_SUP','2','SUP_PCO'),
T_LINEA('PCO_SubsanarCambioProc','PCO_CM_GE','10','SUP_PCO'),
--T_LINEA('PCO_RevisarExpediente','PCO_LET','5','SUP_PCO'),
T_LINEA('PCO_RegResultadoExped','PCO_CM_GD','2','SUP_PCO'),
T_LINEA('PCO_RecepcionExped','PCO_CM_GD','15','SUP_PCO'),
T_LINEA('PCO_RegResultadoDoc','PCO_CM_GD','2','SUP_PCO'),
T_LINEA('PCO_RegEnvioDoc','PCO_CM_GD','2','SUP_PCO'),
T_LINEA('PCO_RecepcionDoc','PCO_CM_GD','2','SUP_PCO'),
T_LINEA('PCO_AdjuntarDoc','PCO_CM_GD','10','SUP_PCO'),
T_LINEA('PCO_GenerarLiq','PCO_CM_GL','45','SUP_PCO'),
T_LINEA('PCO_ConfirmarLiq','PCO_CM_GL','2','SUP_PCO'),
T_LINEA('PCO_EnviarBurofax','PCO_CM_GL','2','SUP_PCO'),
T_LINEA('PCO_AcuseReciboBurofax','PCO_CM_GL','7','SUP_PCO')
    ); 
    V_TMP_TIPO_LINEA T_LINEA;
    
BEGIN	

    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
	
    -- Actualización de valores en TAP_TAREA_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a actualizar valores');
    FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
      LOOP
        V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
        IF V_NUM_TABLAS > 0 THEN        
          V_MSQL := 'UPDATE  '||V_ESQUEMA||'.' || VAR_TABLENAME || 
            ' SET DD_STA_ID=(SELECT DD_STA_ID FROM '||V_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='''||TRIM(V_TMP_TIPO_LINEA(2))||'''), ' ||
            ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_LINEA(4))||''') ' ||
            '  WHERE TAP_CODIGO='''||TRIM(V_TMP_TIPO_LINEA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' ACTUALIZADO TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''');
        ELSE
            DBMS_OUTPUT.PUT_LINE('HAY QUE INSERTAR ESTA FILA: '  || V_TMP_TIPO_LINEA(1));
         END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '.');
    
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
  
    -- Actualización de valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
/* Jorge - Se comenta ya que en principio solo hay que modificar las tareas y los STA

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a actualizar valores');
    FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
      LOOP
        V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || 
          ' WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
        IF V_NUM_TABLAS > 0 THEN        
          V_MSQL := 'UPDATE  '||V_ESQUEMA||'.' || VAR_TABLENAME || 
            ' SET dd_ptp_plazo_script='''||TRIM(V_TMP_TIPO_LINEA(3))||'*24*60*60*1000L'' ' ||
            ' WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||''')';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' ACTUALIZADO TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''');
        ELSE
            DBMS_OUTPUT.PUT_LINE('HAY QUE INSERTAR ESTA FILA: ' || V_TMP_TIPO_LINEA(1));
         END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '.');
*/

  
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

EXIT;

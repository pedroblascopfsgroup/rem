/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20151104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-983
--## PRODUCTO=NO
--##
--## Finalidad: Modificación de los plazos de las tareas de Precontencioso para Cajamar
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
    
    V_DM_PLZ VARCHAR2(1024 CHAR):=  q'[damePlazo(valores[''PCO_EnviarExpedienteLetrado''][''fecha_envio''])+10*24*60*60*1000L]';-- Dame plazo   

    TYPE T_LINEA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA IS TABLE OF T_LINEA;
    V_TIPO_LINEA T_ARRAY_LINEA := T_ARRAY_LINEA(
      T_LINEA('PCO_SolicitarDoc', '2*24*60*60*1000L'),
      T_LINEA('PCO_RegResultadoExped', 'dameFechaSolicitudExpediente() + 2*24*60*60*1000L'),
      T_LINEA('PCO_RegEnvioDoc', 'dameFechaSolicitudDocumentos() + 2*24*60*60*1000L'),
      T_LINEA('PCO_RecepcionExped', 'dameFechaResultadoArchivo() + 15*24*60*60*1000L'),
      T_LINEA('PCO_RegResultadoDoc', 'dameFechaSolicitudDocumentos() + 2*24*60*60*1000L'),
      T_LINEA('PCO_RegResultadoDocG', 'dameFechaSolicitudDocumentos() + 2*24*60*60*1000L'),
      T_LINEA('PCO_RecepcionDoc', 'dameFechaEnvio() + 2*24*60*60*1000L'),
      T_LINEA('PCO_AdjuntarDoc', '10*24*60*60*1000L'),
      T_LINEA('PCO_GenerarLiq', '2*24*60*60*1000L'),
      T_LINEA('PCO_ConfirmarLiq', '2*24*60*60*1000L'),
      T_LINEA('PCO_EnviarBurofax', '2*24*60*60*1000L'),
      T_LINEA('PCO_AcuseReciboBurofax', '10*24*60*60*1000L'),
      T_LINEA('PCO_RegistrarAceptacion', '5*24*60*60*1000L'),
      T_LINEA('PCO_RegistrarAceptacionPost', '5*24*60*60*1000L'),
      T_LINEA('PCO_RevisarNoAceptacion', '2*24*60*60*1000L'),
      T_LINEA('PCO_RevisarNoAceptacionPost', '2*24*60*60*1000L'),
      T_LINEA('PCO_EnviarExpedienteLetrado', 'dameFechaFinalizacionTareasPrecedentes() + 2*24*60*60*1000L'),
      T_LINEA('PCO_RegistrarTomaDec', 'dameFechaUltimoEnvioExp() + 7*24*60*60*1000L'),
      T_LINEA('PCO_SubsanarIncidenciaExp', V_DM_PLZ),
      T_LINEA('PCO_ValidarCambioProc', '2*24*60*60*1000L'),
      T_LINEA('PCO_RevisarSubsanacion', '2*24*60*60*1000L'),
      T_LINEA('PCO_SubsanarCambioProc', V_DM_PLZ)
    );
    V_TMP_TIPO_LINEA T_LINEA;

BEGIN   

-- Inserción de valores en DD_PTP_PLAZOS_TAREAS_PLAZAS

VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';

DBMS_OUTPUT.PUT_LINE('[INICIO ] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a actualizar valores');

FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
  LOOP
    V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||''')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS > 0 THEN
      V_MSQL := 'UPDATE  '||V_ESQUEMA||'.' || VAR_TABLENAME || ' SET DD_PTP_PLAZO_SCRIPT=''' ||TRIM(V_TMP_TIPO_LINEA(2)) || ''' ' || 
        'WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA(1))||''')';

      EXECUTE IMMEDIATE V_MSQL;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' Actualizado DD_PTP_PLAZO_SCRIPT del TAP = '''||TRIM(V_TMP_TIPO_LINEA(1))||'''');

    END IF;
END LOOP;


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

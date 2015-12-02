--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=CMREC-413
--## PRODUCTO=NO
--##
--## Finalidad: Adaptar BPM's Haya-Cajamar
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas

    /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    PAR_TABLENAME_TPLAZ VARCHAR2(50 CHAR) := 'DD_PTP_PLAZOS_TAREAS_PLAZAS'; -- [PARAMETRO] TABLA para plazos de tareas. Por defecto DD_PTP_PLAZOS_TAREAS_PLAZAS
    PAR_TABLENAME_TFITE VARCHAR2(50 CHAR) := 'TFI_TAREAS_FORM_ITEMS';       -- [PARAMETRO] TABLA para items del form de tareas. Por defecto TFI_TAREAS_FORM_ITEMS

    /*
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
    PAR_TIT_TRAMITE VARCHAR2(75 CHAR)   := 'Trámite de demanda incidental';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Alberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'alberto.campos@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2034';                              -- [PARAMETRO] Teléfono del autor

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.
    V_TAREA VARCHAR(50 CHAR);

    VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones

    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_CODIGO_PLAZAS VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Plazos
    V_CODIGO1_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo1 FK con codigo de TFI Items
    V_CODIGO2_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo2 FK con codigo de TFI Items
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'H023'; -- Código de procedimiento para reemplazar
    
    /**
     * TAREAS QUE HAY QUE BORRAR
     */    
    CURSOR CRS_TAREA_BORRAR(P_COD_PROCEDIMIENTO V_COD_PROCEDIMIENTO%TYPE) IS 
		SELECT TAP_CODIGO 
			FROM TAP_TAREA_PROCEDIMIENTO TAP, DD_TPO_TIPO_PROCEDIMIENTO TPO 
			WHERE TPO.DD_TPO_CODIGO = P_COD_PROCEDIMIENTO
				AND TPO.DD_TPO_ID = TAP.DD_TPO_ID
				AND TAP.TAP_CODIGO NOT LIKE 'DEL_%'
				AND TAP_CODIGO = 'H023_informarSareb';

BEGIN
	
	/*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    DBMS_OUTPUT.PUT_LINE('    Generacion de datos BPM: '||PAR_TIT_TRAMITE);

    /*
	 * ---------------------------------------------------------------------------------------------------------
	 * 								ACTUALIZACIONES
	 * ---------------------------------------------------------------------------------------------------------
	 */
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET DD_TPO_DESCRIPCION = ''T. Demanda Incidental - CJ'', DD_TPO_XML_JBPM = ''cj_demandaIncidental'' WHERE DD_TPO_CODIGO = '''||V_COD_PROCEDIMIENTO||'''';

	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : comprobarExisteDocumentoINTDEM() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Para poder continuar debe adjuntar el documento "Interposici&oacute;n de la demanda".</div>'''''' WHERE TAP_CODIGO = ''H023_interposicionDemanda''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = null WHERE TAP_CODIGO = ''H023_confirmarOposicion''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/cajamar/tramiteDemandaIncidental/confirmarOposicion'' WHERE TAP_CODIGO = ''H023_confirmarOposicion''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/cajamar/tramiteDemandaIncidental/admisionOposicionSenyalamientoVista'' WHERE TAP_CODIGO = ''H023_admisionOposicionYSenalamientoVista''';
	
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''valoresBPMPadre[''''H009_RegistrarInformeAdmonConcursal''''] != null ? damePlazo(valoresBPMPadre[''''H009_RegistrarInformeAdmonConcursal''''][''''fecha'''']) + 2*24*60*60*1000L : (valoresBPMPadre[''''H035_registrarOposicion''''] != null ? damePlazo(valoresBPMPadre[''''H035_registrarOposicion''''][''''fecha'''']) + 2*24*60*60*1000L : (valoresBPMPadre[''''H027_RegistrarResHomologacionJudicial''''] != null ? damePlazo(valoresBPMPadre[''''H027_RegistrarResHomologacionJudicial''''][''''fecha'''']) + 2*24*60*60*1000L : 2*24*60*60*1000L))'' WHERE TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_interposicionDemanda'')';
	
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Deber&aacute; informar la fecha de admisi&oacute;n de la oposici&oacute;n, y en su caso si ha se&ntilde;alado vista por el juzgado.</p><p style="margin-bottom: 10px">En caso de que se haya señalado vista, el gestor se generar&aacute; una autotarea con d&iacute;as suficientes de antelaci&oacute;n a la vista recordando que la ha de preparar convenientemente.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:<ul style="list-style-type:square;margin-left:35px;"><li>Si no hay vista o no hay admisi&oacute;n de la oposici&oacute;n "Registrar resoluci&oacute;n" (en caso de no admisi&oacute;n pondr&aacute; la misma fecha que en la presente pantalla).</li><li>En caso de que haya se&ntilde;alamiento de vista "Registrar vista".</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_admisionOposicionYSenalamientoVista'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = null, TFI_VALIDACION = null WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_admisionOposicionYSenalamientoVista'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deberá informar la fecha en la que la Resolución adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_resolucionFirme'')';
	
	-- BORRADO DE TAREA (lógico)
	FOR REG_TAREA IN CRS_TAREA_BORRAR(V_COD_PROCEDIMIENTO) LOOP
		V_TAREA:= REG_TAREA.TAP_CODIGO;
		EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID IN (SELECT TAP_ID FROM '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
		EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID IN (SELECT TAP_ID FROM '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
		EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''', BORRADO=1, FECHABORRAR=SYSDATE, USUARIOBORRAR=''ALBERTO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	END LOOP;

	/*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
	
EXCEPTION

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT('[KO]');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.put_line('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.put_line('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('SQL que ha fallado:');
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.put_line('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.put_line('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;
END;          
/ 
EXIT;

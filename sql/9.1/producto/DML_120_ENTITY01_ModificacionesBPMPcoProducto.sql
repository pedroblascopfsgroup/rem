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
    
    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('PCO','PCO_RegResultadoDocG','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Registrar resultado para documento (Gestoría)',
            '0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'PCO_GEST',null,'PREDOC',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'PCO_RegResultadoDocG','2*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('PCO_RegResultadoDocG','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('PCO_RegResultadoDocG','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;

    -- Actualización de script de decision de las tareas
    TYPE T_LINEA3 IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA3 IS TABLE OF T_LINEA3;
    V_TIPO_LINEA3 T_ARRAY_LINEA3 := T_ARRAY_LINEA3(
        T_LINEA3('PCO_RegistrarTomaDec', 'Confirmar documentación y procedimiento')
    ); 
    V_TMP_TIPO_LINEA3 T_LINEA3;

    V_CONFIG VARCHAR2(4000 CHAR);      

    V_AUX1 VARCHAR2(1000);
    V_AUX2 VARCHAR2(1000);
    
BEGIN	

    -- Nuevas TAP_TAREA_PROCEDIMIENTO PCO_RegResultadoDocG
	V_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a insertar TAREAS');
	FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
	  LOOP
	    V_TMP_TIPO_TAP := V_TIPO_TAP(I);
	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || 
	    	V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
	    IF V_NUM_TABLAS > 0 THEN				
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLENAME||'... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||'''');
	    ELSE
	        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLENAME || ' (' ||
	                'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
	                'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
	                'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
	                'SELECT ' || V_ESQUEMA || '.' ||
	                '' || V_ESQUEMA || '.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
	                '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
	                '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
	                'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''',' || 
	                '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
	                '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' || 
                    '(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_TAP(22))||'''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
	        DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
	        DBMS_OUTPUT.PUT_LINE(V_MSQL);
	        EXECUTE IMMEDIATE V_MSQL;
	      END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '... Tareas');

    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    V_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    '' || V_ESQUEMA || '.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    V_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    '' || V_ESQUEMA || '.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME || '... Campos');

    -- Borrar los TFI_ITEMS sobrantes de PCO_SubsanarIncidenciaExp
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.tfi_tareas_form_items ... Eliminando campos sobrantes de PCO_SubsanarIncidenciaExp');
    V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.tfi_tareas_form_items WHERE TFI_NOMBRE = ''fecha_exp_sub'' and tap_id in ' ||
    	'(select tap_id from ' || V_ESQUEMA || '.tap_tarea_procedimiento where tap_codigo=''PCO_SubsanarIncidenciaExp'')';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 1 THEN
   		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.tfi_tareas_form_items ... Eliminando campos sobrante fecha_exp_sub de PCO_SubsanarIncidenciaExp');
	    V_AUX1 := q'[DELETE from ]' || V_ESQUEMA || q'[.tfi_tareas_form_items where tap_id=(SELECT TAP_ID FROM ]' || V_ESQUEMA || 
	        q'[.tap_tarea_procedimiento WHERE TAP_CODIGO = 'PCO_SubsanarIncidenciaExp') and TFI_NOMBRE = 'fecha_exp_sub' and tfi_id NOT IN (select max(tfi_id) from ]' 
	        || V_ESQUEMA || q'[.tfi_tareas_form_items where tap_id=(SELECT TAP_ID FROM ]' || V_ESQUEMA || 
	        q'[.tap_tarea_procedimiento WHERE TAP_CODIGO = 'PCO_SubsanarIncidenciaExp') and TFI_NOMBRE = 'fecha_exp_sub')]';
	    DBMS_OUTPUT.PUT_LINE(V_AUX1);
	    EXECUTE IMMEDIATE V_AUX1;		
    END IF;
    V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.tfi_tareas_form_items WHERE TFI_NOMBRE = ''tipo_problema'' and tap_id in ' ||
    	'(select tap_id from ' || V_ESQUEMA || '.tap_tarea_procedimiento where tap_codigo=''PCO_SubsanarIncidenciaExp'')';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 1 THEN
	    V_AUX2 := q'[DELETE from ]' || V_ESQUEMA || q'[.tfi_tareas_form_items where tap_id=(SELECT TAP_ID FROM ]' || V_ESQUEMA || 
	        q'[.tap_tarea_procedimiento WHERE TAP_CODIGO = 'PCO_SubsanarIncidenciaExp') and TFI_NOMBRE = 'tipo_problema' and tfi_id NOT IN (select max(tfi_id) from ]' 
	        || V_ESQUEMA || q'[.tfi_tareas_form_items where tap_id=(SELECT TAP_ID FROM ]' || V_ESQUEMA || 
	        q'[.tap_tarea_procedimiento WHERE TAP_CODIGO = 'PCO_SubsanarIncidenciaExp') and TFI_NOMBRE = 'tipo_problema')]';
	    DBMS_OUTPUT.PUT_LINE(V_AUX2);
	    EXECUTE IMMEDIATE V_AUX2;
	END IF;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.tfi_tareas_form_items ... Eliminados campos sobrantes de PCO_SubsanarIncidenciaExp');

    -- INSERTAR LINEAS DE CONFIGURACIÓN PARA LA NUEVA TAREA ESPECIAL PCO_RegResultadoDocG 
    V_TABLENAME := 'PCO_LCT_LINEA_CONFIG_TAREA';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || V_TABLENAME || ' WHERE PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION=''CREAR''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          
    V_CONFIG := 'select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDocG'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_trat_exp=0 and tactor2.dd_pco_dsa_acceso_recovery=1)) and pco.prc_id=? ';
    IF V_NUM_TABLAS > 0 THEN        
        V_SQL := 'UPDATE ' ||V_ESQUEMA||'.' || V_TABLENAME || ' SET PCO_LCT_HQL=''' || V_CONFIG || 
            ''' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION=''CREAR''';
    ELSE
        V_SQL := 'INSERT INTO ' ||V_ESQUEMA||'.' || V_TABLENAME || ' (PCO_LCT_ID,PCO_LCT_CODIGO_TAREA,PCO_LCT_CODIGO_ACCION,PCO_LCT_HQL,VERSION,USUARIOCREAR,FECHACREAR) ' ||
            ' VALUES (' ||V_ESQUEMA||'.S_' || V_TABLENAME || '.NEXTVAL,''PCO_RegResultadoDocG'',''CREAR'',''' || V_CONFIG || ''',0,''INICIAL'',sysdate)';
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;
    V_CONFIG := 'select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDocG'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id AND tactor2.dd_pco_dsa_trat_exp =0 and tactor2.dd_pco_dsa_acceso_recovery=1)) and pco.prc_id=? ';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || V_TABLENAME || ' WHERE PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION=''CANCELAR''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          
    IF V_NUM_TABLAS > 0 THEN        
        V_SQL := 'UPDATE ' ||V_ESQUEMA||'.' || V_TABLENAME || ' SET PCO_LCT_HQL=''' || V_CONFIG || 
            ''' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION=''CANCELAR''';
    ELSE
        V_SQL := 'INSERT INTO ' ||V_ESQUEMA||'.' || V_TABLENAME || ' (PCO_LCT_ID,PCO_LCT_CODIGO_TAREA,PCO_LCT_CODIGO_ACCION,PCO_LCT_HQL,VERSION,USUARIOCREAR,FECHACREAR) ' ||
            ' VALUES (' ||V_ESQUEMA||'.S_' || V_TABLENAME || '.NEXTVAL,''PCO_RegResultadoDocG'',''CANCELAR'',''' || V_CONFIG || ''',0,''INICIAL'',sysdate)';
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;

	-- Modificación de campo de decisión de PCO_PrepararExpediente
    V_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLENAME || '... Empezando a actualizar campo decisión de tareas');
    FOR I IN V_TIPO_LINEA3.FIRST .. V_TIPO_LINEA3.LAST
      LOOP
        V_TMP_TIPO_LINEA3 := V_TIPO_LINEA3(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || V_TABLENAME || ' WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA3(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
        IF V_NUM_TABLAS > 0 THEN        
            V_MSQL := 'UPDATE  '||V_ESQUEMA||'.' || V_TABLENAME || 
                ' SET TAP_DESCRIPCION=''' || TRIM(V_TMP_TIPO_LINEA3(2)) || 
                '''  WHERE TAP_CODIGO='''|| TRIM(V_TMP_TIPO_LINEA3(1)) ||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLENAME || ' ACTUALIZACION DE TAP_SCRIPT_DECISION DE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_LINEA3(1))||'''');
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

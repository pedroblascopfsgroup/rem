/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20160712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Insertar los procedimientos para la migracion de haya a cajamar
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
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    --Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	--Litigios
    	T_TIPO_TPO('CJ016','P. Cambiario - CJ','Procedimiento Cambiario',null,'cj_procedimientoCambiario','0','RECOVERY-2026','1','EJ',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ018','P. Ej. de Título Judicial - CJ','Procedimiento Ejecución de Título Judicial',null,'cj_ejecucionTituloJudicial','0','RECOVERY-2026','1','EJ',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ020','P. Ej. de título no judicial - CJ','Procedimiento ejecución de título no judicial',null,'cj_ejecucionTituloNoJudicial','0','RECOVERY-2026','1','EJ',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ022','P. Monitorio - CJ','Procedimiento Monitorio',null,'cj_procedimientoMonitorio','0','RECOVERY-2026','1','DE',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ024','P. ordinario - CJ','Procedimiento ordinario',null,'cj_procedimientoOrdinario','0','RECOVERY-2026','1','DE',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ026','P. verbal - CJ','Procedimiento verbal',null,'cj_procedimientoVerbal','0','RECOVERY-2026','1','DE',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ028','P. Verbal desde Monitorio - CJ','Procedimiento Verbal desde Monitorio',null,'cj_procedimientoVerbalDesdeMonitorio','0','RECOVERY-2026','1','DE',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ030','T. certificación de cargas y revisión - CJ','Trámite de certificación de cargas y revisión',null,'cj_tramiteCertificacionCargasRevision','0','RECOVERY-2026','1','AP',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ032','T. Costas contra Entidad - CJ','Trámite de Costas contra Entidad',null,'cj_tramiteCostasVsEntidad','0','RECOVERY-2026','1','TR',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ106','T. de cesión de remate - CJ','T. de cesión de remate',null,'cj_tramiteCesionRemate','0','RECOVERY-2026','1','AP',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ064','T. de consignación - CJ','Trámite de consignación',null,'cj_tramiteConsignacion','0','RECOVERY-2026','1','AP',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ007','T. de costas - CJ','Trámite de costas',null,'cj_tramiteCostas','0','RECOVERY-2026','1','TR',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ070','T. de subasta TERCEROS - CJ','Trámite de subasta terceros',null,'cj_tramiteSubastaTerceros','0','RECOVERY-2026','1','AP',null,null,'8','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ034','T. de depósito - CJ','Trámite de depósito',null,'cj_tramiteDeposito','0','RECOVERY-2026','1','TR',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ038','T. de Embargo de Salarios - CJ','Trámite de Embargo de Salarios',null,'cj_tramiteEmbargoSalarios','0','RECOVERY-2026','1','TR',null,null,'1','MEJTipoProcedimiento','1','0'), 
    	T_TIPO_TPO('CJ040','T. de gestión de llaves - CJ','T. de gestión de llaves',null,'cj_tramiteDeGestionDeLlaves','0','RECOVERY-2026','1','AP',null,null,'1','MEJTipoProcedimiento','1','1')
    	); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

BEGIN	
	
    -- LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TIPO DE PROCEDIMIENTO');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN
	V_SQL := 'UPDATE ' ||V_ESQUEMA||'.'||VAR_TABLENAME|| ' SET DD_TPO_DESCRIPCION=''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
    	' DD_TPO_DESCRIPCION_LARGA=''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',' ||
        ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',' ||
        ' FECHAMODIFICAR=sysdate ' || 
        ' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||''')';	
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;			
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
            'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
            'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
            'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
            'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
            'SELECT '||V_ESQUEMA ||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
            '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
            '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
            '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
            '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
            '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
            '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
            '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
            '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) || ''' FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');
    
  
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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
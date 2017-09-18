--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170918
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2813
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de TAP del BPM - Trámite Comercial Cajamar
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_USUARIOCREAR VARCHAR2(50 CHAR) := 'HREOS-2813';
    VAR_CODIGOS_DD_TPO VARCHAR2(100 CHAR) := 'T013';
    
    -- TABLA: TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(3000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    	-- (1) DD_TPO_CODIGO
    	-- (2) TAP_CODIGO
    	-- (3) TAP_VIEW
    	-- (4) TAP_SCRIPT_VALIDACION
    	-- (5) TAP_SCRIPT_VALIDACION_JBPM
    	-- (6) TAP_SCRIPT_DECISION
    	-- (7) DD_TPO_ID_BPM
    	-- (8) TAP_SUPERVISOR
    	-- (9) TAP_DESCRIPCION
	    -- (10) TAP_ALERT_NO_RETORNO
	    -- (11) TAP_ALERT_VUELTA_ATRAS
	    -- (12) DD_FAP_ID
	    -- (13) TAP_AUTOPRORROGA
	    -- (14) DTYPE
	    -- (15) TAP_MAX_AUTOP
	    -- (16) DD_TGE_codigo
	    -- (17) DD_STA_codigo
	    -- (18) TAP_EVITAR_REORG
	    -- (19) DD_TSUP_codigo
	    -- (20) TAP_BUCLE_BPM
		T_TIPO_TAP(
			'T013'
			,'T013_DefinicionOferta'
			,null
			,'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''El activo está vendido'' : (checkComercializable() ? (checkBankia() ? (checkImpuestos() ? null : ''Debe indicar el tipo de impuesto y tipo aplicable.'' ) : null) : ''El activo debe ser comercializable'') ) : ''Los compradores deben sumar el 100%'') : ''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''
	        ,'valores[''T013_DefinicionOferta''][''comboConflicto''] != DDSiNo.SI && valores[''T013_DefinicionOferta''][''comboRiesgo''] != DDSiNo.SI ? (checkFormalizacion() ? (checkDeDerechoTanteo() == false ? (checkBankia() ? altaComiteProcess() : null) : null) : null) : ''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'' '
	        ,'checkFormalizacion() ? (checkDeDerechoTanteo() == false ? (checkAtribuciones() ? (checkReserva() == false ? (checkDerechoTanteo() ? (checkCajamar() ? ''ConFormalizacionSinTanteoConAtribucionSinReservaConTanteoCajamar'' : ''ConFormalizacionSinTanteoConAtribucionSinReservaConTanteo'') : (checkCajamar() ? ''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteoCajamar'' : ''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'')) : (checkCajamar() ? ''ConFormalizacionSinTanteoConAtribucionConReservaCajamar'' : ''ConFormalizacionSinTanteoConAtribucionConReserva'')) : ''ConFormalizacionSinTanteoSinAtribucion'') : ''ConFormalizacionConTanteo'') : ''SinFormalizacion'' '
	        ,'NULL'
	        ,'0'
	        ,'Definición oferta'
	        ,null
	        ,null
	        ,'NULL'
	        ,'0'
	        ,'EXTTareaProcedimiento'
	        ,'3'
	        ,'GCOM'
	        ,'811'
	        ,'NULL'
	        ,'NULL'
	        ,null
	        )
		,T_TIPO_TAP(
			'T013'
			,'T013_ResolucionComite'
			,null
			,'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''El activo está vendido'' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''El estado de la política corporativa no es el correcto para poder avanzar.'') : ''El activo debe ser comercializable'') ) : ''Los compradores deben sumar el 100%'') : ''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''
	        ,'valores[''T013_ResolucionComite''][''comboResolucion''] == DDResolucionComite.CODIGO_APRUEBA ? existeAdjuntoUGValidacion("23","E") : (valores[''T013_ResolucionComite''][''comboResolucion''] == DDResolucionComite.CODIGO_CONTRAOFERTA ? existeAdjuntoUGValidacion("22","E") : null) '
	        ,'valores[''T013_ResolucionComite''][''comboResolucion''] == DDResolucionComite.CODIGO_APRUEBA ? (checkReserva() ? (checkCajamar() ? ''ApruebaConReservaCajamar'' :''ApruebaConReserva'') : ( checkDerechoTanteo() ? (checkCajamar() ? ''ApruebaSinReservaConTanteoCajamar'' : ''ApruebaSinReservaConTanteo'') : (checkCajamar() ? ''ApruebaSinReservaSinTanteoCajamar'' : ''ApruebaSinReservaSinTanteo''))) : (valores[''T013_ResolucionComite''][''comboResolucion''] == DDResolucionComite.CODIGO_RECHAZA ? ''Rechaza'' : ''Contraoferta'') '
	        ,'NULL'
	        ,'0'
	        ,'Resolución comité'
	        ,null
	        ,null
	        ,'NULL'
	        ,'0'
	        ,'EXTTareaProcedimiento'
	        ,'3'
	        ,'GCOM'
	        ,'811'
	        ,'NULL'
	        ,'NULL'
	        ,null
	        )
		,T_TIPO_TAP(
			'T013'
			,'T013_RespuestaOfertante'
			,null
			,'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''El activo está vendido'' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''El estado de la política corporativa no es el correcto para poder avanzar.'') : ''El activo debe ser comercializable'') ) : ''Los compradores deben sumar el 100%'') : ''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''
	        ,'valores[''T013_RespuestaOfertante''][''comboRespuesta''] == DDSiNo.SI ? (checkBankia() ? ratificacionComiteProcess() : null) : null'
	        ,'valores[''T013_RespuestaOfertante''][''comboRespuesta''] == DDSiNo.SI ? (checkBankia() ? ''AceptaBankia'' : (checkReserva() ? (checkCajamar() ? ''AceptaConReservaCajamar'' : ''AceptaConReserva'' ) : ( checkDerechoTanteo() ? (checkCajamar() ? ''AceptaSinReservaConTanteoCajamar'' : ''AceptaSinReservaConTanteo'') : (checkCajamar() ? ''AceptaSinReservaSinTanteoCajamar'' : ''AceptaSinReservaSinTanteo'')))) : ''Rechaza'''
	        ,'NULL'
	        ,'0'
	        ,'Respuesta ofertante'
	        ,null
	        ,null
	        ,'NULL'
	        ,'0'
	        ,'EXTTareaProcedimiento'
	        ,'3'
	        ,'GCOM'
	        ,'811'
	        ,'NULL'
	        ,'NULL'
	        ,null
	        )
	); 
    V_TMP_TIPO_TAP T_TIPO_TAP;
    
    
    
    
 -- ## FIN DATOS	
 -- ########################################################################################
  


BEGIN

	
	-- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO 
	VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insertando\Actualizando datos de TAP_TAREA_PROCEDIMIENTO');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
        IF V_NUM_TABLAS > 0 THEN				
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET ' ||
						' TAP_VIEW='''|| TRIM(V_TMP_TIPO_TAP(3)) ||''',' ||
			        	' TAP_SCRIPT_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
			        	' TAP_SCRIPT_VALIDACION_JBPM=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',' ||
			        	' TAP_SCRIPT_DECISION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' ||
			        	' TAP_DESCRIPCION='''|| TRIM(V_TMP_TIPO_TAP(9)) ||''', ' ||
			        	' DD_TGE_ID =  (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(16)) || '''),'||
			        	' DD_STA_ID =  (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(17)) || '''), ' ||
			        	' DD_TSUP_ID = (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' ||
			        	' USUARIOMODIFICAR='''|| TRIM(VAR_USUARIOCREAR) ||''', FECHAMODIFICAR=SYSDATE, USUARIOBORRAR=NULL, FECHABORRAR=NULL, BORRADO=0 '||
			        	' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||''' ';
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Actualizada la tarea '''|| TRIM(V_TMP_TIPO_TAP(2)) ||''', ' || TRIM(V_TMP_TIPO_TAP(3)));
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
	                    'TAP_ID,' ||
						'DD_TPO_ID,' ||
						'TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,'||
						'TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
	                    'TAP_SUPERVISOR,TAP_DESCRIPCION,TAP_ALERT_NO_RETORNO,' ||
	                    'TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,' ||
	                    'DTYPE,TAP_MAX_AUTOP,' ||
	                    'DD_TGE_ID,'||
	                    'DD_STA_ID,'||
	                    'DD_TSUP_ID,'||
	                    'TAP_EVITAR_REORG,TAP_BUCLE_BPM,'||
	                    'VERSION,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
                    'SELECT ' || V_ESQUEMA || '.' ||
	                    ' S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
	                    ' (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(1)) || '''),' ||
	                    ' ''' || TRIM(V_TMP_TIPO_TAP(2)) || ''',''' || TRIM(V_TMP_TIPO_TAP(3)) || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
	                    ' ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || V_TMP_TIPO_TAP(7) || ',' ||
	                    ' '|| V_TMP_TIPO_TAP(8) || ',''' || TRIM(V_TMP_TIPO_TAP(9)) || ''',''' || TRIM(V_TMP_TIPO_TAP(10)) || ''',' ||
	                    ' ''' || TRIM(V_TMP_TIPO_TAP(11)) || ''',' || V_TMP_TIPO_TAP(12) || ',' || V_TMP_TIPO_TAP(13) || ',' ||
	                    ' ''' || TRIM(V_TMP_TIPO_TAP(14)) || ''',' || V_TMP_TIPO_TAP(15) || ',' ||
	                    ' (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(16)) || '''),' ||
	                    ' (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(17)) || '''),' || 
	                    ' (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' ||
	                    ' '|| V_TMP_TIPO_TAP(18) || ',''' || V_TMP_TIPO_TAP(20) || ''',' ||
	                    ' 0, ''' || VAR_USUARIOCREAR || ''',sysdate,0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||V_TMP_TIPO_TAP(9)||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');
    
    
    
    DBMS_OUTPUT.PUT_LINE('[COMMIT] Commit realizado');
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
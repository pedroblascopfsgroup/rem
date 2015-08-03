--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar los gestores en las tareas para HRE-BCC
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    
    --Insertando valores en dd_tfa_fichero_adjunto
    TYPE T_TIPO_VALOR IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_VALOR;
    V_TIPO_VALOR T_ARRAY_TFA := T_ARRAY_TFA(

T_TIPO_VALOR('HCJ001','HCJ001_DeclararIVAIGIC','TGCTRGE','SCTRGE')
,T_TIPO_VALOR('HCJ002','HCJ002_ObtenerValidacionComite','TGCTRGE','DRECU')
,T_TIPO_VALOR('H036','H036_ElevarPropuestaAComite','CJ-TGESEXT','CJ-SUEXT')
,T_TIPO_VALOR('H033','H033_aperturaFase','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_InformeLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_decidirPresentarObs','TSUCON','DIRCON')
,T_TIPO_VALOR('H033','H033_presentarObs','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_regInformeTrimestral1','TGESCON','SUCON')
,T_TIPO_VALOR('H039','H039_registrarCausaConclusion','TGESCON','SUCON')
,T_TIPO_VALOR('H039','H039_registrarInformeAdmConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('H039','H039_registrarConclusionConcurso','TGESCON','SUCON')
,T_TIPO_VALOR('H039','H039_ConclusionDecision','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_AutoDeclarandoConcurso','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_BPMTramiteFaseComunOrdinario','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_ConfirmarAdmision','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_ConfirmarNotificacionDemandado','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_RegistrarResolucion','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_RegistrarVista','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_ResolucionDecision','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_ResolucionFirme','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_RevisionEjecucionesParalizadas','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_SolicitudConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_registrarOposicion','TGESCON','SUCON')
,T_TIPO_VALOR('H035','H035_aperturaLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H035','H035_resolucionFirme','TGESCON','SUCON')
,T_TIPO_VALOR('H035','H035_ResolucionDecision','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_ContabilizarConvenio','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H031','H031_ConvenioDecision','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_ElevarAComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('H031','H031_EscritoEvaluacion','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_PrepararInforme','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_RegistrarRespuestaComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('H031','H031_ResolucionJudicial','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_admisionTramiteConvenio','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_registrarPropAnticipadaConvenio','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_ActualizarEstadoCreditos','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_AnyadirTextosDefinitivos','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_BPMTramiteDemandaIncidental','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_BPMTramiteFaseConvenioV4','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_BPMTramiteFaseLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_PresentacionAdenda','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_PresentacionJuzgado','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_PresentarEscritoInsinuacion','TGESHRE','GESCON')
,T_TIPO_VALOR('H009','H009_RectificarInsinuacionCreditos','TGESHRE','GESCON')
,T_TIPO_VALOR('H009','H009_RegistrarInformeAdmonConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RegistrarInsinuacionCreditos','TGESHRE','GESCON')
,T_TIPO_VALOR('H009','H009_RegistrarProyectoInventario','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RegistrarPublicacionBOE','TGESHRE','SUHRE')
,T_TIPO_VALOR('H009','H009_ResolucionJuzgado','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RevisarEjecuciones','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RevisarInsinuacionCreditos','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RevisarResultadoInfAdmon','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_DemandaDecision','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_admisionOposicionYSenalamientoVista','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_confirmarAdmisionDemanda','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_confirmarOposicion','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_interposicionDemanda','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_registrarResolucion','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_registrarVista','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_resolucionFirme','TGESCON','SUCON')

); 
    V_TMP_TIPO T_TIPO_VALOR;
    
BEGIN	
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con DD_TFA_FICHERO_ADJUNTO');  
  -- LOOP Insertando valores en dd_tfa_fichero_adjunto
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.dd_tfa_fichero_adjunto... Empezando a insertar datos en el diccionario');
    
	FOR I IN V_TIPO_VALOR.FIRST .. V_TIPO_VALOR.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dd_tfa_fichero_adjunto.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO := V_TIPO_VALOR(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,'||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ' ||
				' WHERE TAP.DD_TPO_ID=TPO.DD_TPO_ID AND TPO.DD_TPO_CODIGO='''||TRIM(V_TMP_TIPO(1))||''' AND TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO(2))||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe
			IF V_NUM_TABLAS > 0 THEN				
				--DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.dd_tfa_fichero_adjunto... Ya existe la relacion dd_tfa_codigo='''|| TRIM(V_TMP_TIPO_TFA(1))||''' con el código de actuación='''|| TRIM(V_TMP_TIPO_TFA(4))||'''');
				 V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' || 
                         ' DD_STA_ID = (select dd_sta_id from '||V_ESQUEMA_MASTER||'.Dd_Sta_Subtipo_Tarea_Base where Dd_Sta_Codigo='''||TRIM(V_TMP_TIPO(3))||''')' ||
                         ' ,DD_TSUP_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.Dd_Tge_Tipo_Gestor where dd_tge_codigo='''||TRIM(V_TMP_TIPO(4))||''')' ||
                         ' WHERE TAP_CODIGO = ''' || V_TMP_TIPO(2)|| ''' AND DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO WHERE DD_TPO_CODIGO='''||TRIM(V_TMP_TIPO(1))||''')';
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
			ELSE
        DBMS_OUTPUT.PUT_LINE('NO ENCONTRADO...' || TRIM(V_TMP_TIPO(2)));
			END IF;
      END LOOP;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA ||'.dd_tfa_fichero_adjunto... Insertados datos en el diccionario');

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
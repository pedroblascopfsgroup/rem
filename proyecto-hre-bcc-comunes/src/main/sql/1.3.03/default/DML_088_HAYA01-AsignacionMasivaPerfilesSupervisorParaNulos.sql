/*
--##########################################
--## Author: JoseVi Jimenez, Ignacio Arcos
--## Adaptado a BP : JoseVI Jimenez
--## Finalidad: Corrección tareas con perfil supervisor NULL
--## INSTRUCCIONES:  Verificar esquemas correctos en el Declare
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_NUM_TAREAS NUMBER(4);  -- Vble. auxiliar para registrar errores en el script.


    --Lista de perfiles SUPERVISOR por TAREA (en casos supervisor = null)
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H002_ElevarPropuestaASareb'                               , 'DUCL'),
      T_TIPO_TAP('H002_RegistrarRespuestaSareb'                             , 'DUCL'),
      T_TIPO_TAP('H004_SenyalamientoSubasta'                                , 'GUCL'),
      T_TIPO_TAP('H009_ActualizarEstadoCreditos'                            , 'GUCL'),
      T_TIPO_TAP('H009_PresentarEscritoInsinuacion'                         , 'GUCL'),
      T_TIPO_TAP('H009_PresentarRectificacion'                              , 'GUCL'),
      T_TIPO_TAP('H009_RegistrarInformeAdmonConcursal'                      , 'GUCL'),
      T_TIPO_TAP('H009_RegistrarInsinuacionCreditos'                        , 'GUCL'),
      T_TIPO_TAP('H009_RegistrarProyectoInventario'                         , 'GUCL'),
      T_TIPO_TAP('H009_RegistrarPublicacionBOE'                             , 'GUCL'),
      T_TIPO_TAP('H009_RegistrarResolucionFaseComun'                        , 'GUCL'),
      T_TIPO_TAP('H009_RevisarResultadoInfAdmon'                            , 'GUCL'),
      T_TIPO_TAP('H017_aceptarFinSeguimiento'                               , 'DUCL'),
      T_TIPO_TAP('H017_PreparaPropInstSareb'                                , 'DUCL'),
      T_TIPO_TAP('H021_AutoDeclarandoConcurso'                              , 'GUCL'),
      T_TIPO_TAP('H021_ConfirmarAdmision'                                   , 'GUCL'),
      T_TIPO_TAP('H021_ConfirmarNotificacionDemandado'                      , 'GUCL'),
      T_TIPO_TAP('H021_registrarOposicion'                                  , 'GUCL'),
      T_TIPO_TAP('H021_RegistrarResolucion'                                 , 'GUCL'),
      T_TIPO_TAP('H021_RegistrarVista'                                      , 'GUCL'),
      T_TIPO_TAP('H021_ResolucionFirme'                                     , 'GUCL'),
      T_TIPO_TAP('H021_SolicitudConcursal'                                  , 'GUCL'),
      T_TIPO_TAP('H027_AceptarPropuestaAcuerdo'                             , 'DUCL'),
      T_TIPO_TAP('H027_ConfirmarContabilidad'                               , 'SSDE'),
      T_TIPO_TAP('H027_LecturaAceptacionInstrucciones'                      , 'GUCL'),
      T_TIPO_TAP('H027_RegistrarAperturaNegociaciones'                      , 'GUCL'),
      T_TIPO_TAP('H027_RegistrarEntradaEnVigor'                             , 'GUCL'),
      T_TIPO_TAP('H027_RegistrarPropuestaAcuerdo'                           , 'GUCL'),
      T_TIPO_TAP('H027_RegistrarPublicacionSolArticulo'                     , 'GUCL'),
      T_TIPO_TAP('H027_RegistrarResHomologacionJudicial'                    , 'GUCL'),
      T_TIPO_TAP('H027_RegistrarResultadoAcuerdo'                           , 'GUCL'),
      T_TIPO_TAP('H032_ConfirmarPresImpugnacion'                            , 'GUCL'),
      T_TIPO_TAP('H032_RegistrarCelebracionVista'                           , 'GUCL'),
      T_TIPO_TAP('H032_RegistrarDecTasacionCostas'                          , 'GUCL'),
      T_TIPO_TAP('H032_RegistrarPago'                                       , 'GUCL'),
      T_TIPO_TAP('H032_RegistrarResolucion'                                 , 'GUCL'),
      T_TIPO_TAP('H032_RegistrarSolCostasContrario'                         , 'GUCL'),
      T_TIPO_TAP('H032_ResolucionFirme'                                     , 'GUCL'),
      T_TIPO_TAP('H033_aperturaFase'                                        , 'GUCL'),
      T_TIPO_TAP('H033_decidirPresentarObs'                                 , 'DUCL'),
      T_TIPO_TAP('H033_InformeLiquidacion'                                  , 'GUCL'),
      T_TIPO_TAP('H033_presentarObs'                                        , 'GUCL'),
      T_TIPO_TAP('H033_presentarSeparacion'                                 , 'GUCL'),
      T_TIPO_TAP('H033_regInformeTrimestral1'                               , 'GUCL'),
      T_TIPO_TAP('H033_regInformeTrimestral2'                               , 'GUCL'),
      T_TIPO_TAP('H033_registrarResolucion'                                 , 'GUCL'),
      T_TIPO_TAP('H033_regResolucionAprovacion'                             , 'GUCL'),
      T_TIPO_TAP('H033_separacionAdministradores'                           , 'GUCL'),
      T_TIPO_TAP('H040_Decision1'                                           , 'GUCL'),
      T_TIPO_TAP('H042_ElaborarLiquidacion'                                 , 'DUCL'),
      T_TIPO_TAP('H042_ValidarLiquidacionIntereses'                         , 'DUCL'),
      T_TIPO_TAP('H054_ConfirmarComEmpresario'                              , 'SFIS'),
      T_TIPO_TAP('H054_EmisionInformeFiscal'                                , 'SFIS'),
      T_TIPO_TAP('H054_PresentarEscritoJuzgado'                             , 'GUCL'),
      T_TIPO_TAP('H054_ValidaBienesTributacion'                             , 'GSUB'),
      T_TIPO_TAP('P400_GestionarNotificaciones'                             , 'GUCL')
      --T_TIPO_TAP('P404_Decision1'                                           , 'NULL'),
      --T_TIPO_TAP('P404_NodoEsperaController'                                , 'NULL'),
      --T_TIPO_TAP('P404_RegistrarAceptacionAsunto'                           , 'NULL'),
      --T_TIPO_TAP('P420_registrarAceptacion'                                 , 'NULL'),
      --T_TIPO_TAP('P420_registrarProcedimiento'                              , 'NULL'),
      --T_TIPO_TAP('P420_SubsanarErrDocumentacion'                            , 'NULL')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

   
BEGIN	
    ------------------------------------------------------------------------------------------------
    -- LOOP Actualizando valores en TAP_TAREA_PROCEDIMIENTO - ARRAY SUPERVISORES DD_TSUP_ID 
    ------------------------------------------------------------------------------------------------
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    V_NUM_TAREAS := 0;
    DBMS_OUTPUT.PUT_LINE('[INICIO-LOOP] Actualizacion DD_TSUP_ID en '||V_ESQUEMA||'.' || VAR_TABLENAME);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' SET ' ||
                    ' DD_TSUP_ID = ' || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(2)) || ''') ' ||
                    ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(1)) || ''' '
                    ;
                
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
        V_NUM_TAREAS := V_NUM_TAREAS + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD(V_TMP_TIPO_TAP(1),length(V_TMP_TIPO_TAP(1))+(70-length(V_TMP_TIPO_TAP(1))),'.')||'OK');
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN-LOOP] '||V_ESQUEMA||'.' || VAR_TABLENAME || ' actualizado.');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TAREAS || ' tareas actualizadas.');
    DBMS_OUTPUT.PUT_LINE('');


    ------------------------------------------------------------------------------------------------
    -- Individuales Actualizando valores en TAP_TAREA_PROCEDIMIENTO - UPDATES SUPERVISORES DD_TSUP_ID 
    ------------------------------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INICIO-UPDATES 1] Actualizacion DD_STA_ID en '||V_ESQUEMA||'.' || VAR_TABLENAME);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

    --Se pone valor NULL en todos los registros DD_TGE_ID porque es un campo que no se utiliza en HAYA
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_TGE_ID = NULL ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''814'') '
          || ' WHERE TAP_CODIGO IN (''H032_ConfirmarPresImpugnacion'', ''H032_RegistrarCelebracionVista'', ''H032_RegistrarDecTasacionCostas'', ''H032_RegistrarPago'', ''H032_RegistrarResolucion'', ''H032_RegistrarSolCostasContrario'', ''H032_ResolucionFirme'') ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;


    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''809'') '
          || ' WHERE TAP_CODIGO IN (''H054_ConfirmarComEmpresario'', ''H054_EmisionInformeFiscal'') ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''814'') '
          || ' WHERE TAP_CODIGO IN (''H054_PresentarEscritoJuzgado'', ''P400_GestionarNotificaciones'') ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''803'') '
          || ' WHERE TAP_CODIGO IN (''H054_ValidaBienesTributacion'') ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('[FIN-UPDATES 1] ');
    DBMS_OUTPUT.PUT_LINE('');

    ----------------------------------------------------------------------------------------------------------
    -- Individuales Actualizando valores en TAP_TAREA_PROCEDIMIENTO - UPDATES SUPERVISORES DD_TSUP_ID - NACHO
    ----------------------------------------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INICIO-UPDATES 2] Actualizacion DD_STA_ID en '||V_ESQUEMA||'.' || VAR_TABLENAME);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''103'') '
          || ' WHERE TAP_CODIGO LIKE ''H066%'' AND DD_STA_ID IS NULL ';
   
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
      
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''103''), '
          || ' DD_TSUP_ID = (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''GAREO'') '
          || ' WHERE (TAP_CODIGO = ''H005_RegistrarEntregaTitulo'' OR TAP_CODIGO = ''H005_RegistrarPresentacionEnHacienda'' OR TAP_CODIGO = ''H005_RegistrarPresentacionEnRegistro'' OR TAP_CODIGO = ''H005_RegistrarInscripcionDelTitulo'') AND DD_STA_ID IS NULL ';
   
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''814''), '
          || ' DD_TSUP_ID = (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''GUCL'') '
          || ' WHERE (TAP_CODIGO = ''H005_SolicitudDecretoAdjudicacion'' OR TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAEntidad'' OR TAP_CODIGO = ''H005_notificacionDecretoAdjudicacionAlContrario'' OR TAP_CODIGO = ''H005_SolicitudTestimonioDecretoAdjudicacion'' OR TAP_CODIGO = ''H005_ConfirmarTestimonio'') AND DD_STA_ID IS NULL ';
   
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''805''), '
          || ' DD_TSUP_ID = (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''SSDE'') '
          || ' WHERE TAP_CODIGO = ''H005_ConfirmarContabilidad'' AND DD_STA_ID IS NULL ';
   
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('[FIN-UPDATES 2] ');

COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('KO');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
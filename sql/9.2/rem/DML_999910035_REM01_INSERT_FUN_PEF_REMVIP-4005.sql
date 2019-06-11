--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.0
--## INCIDENCIA_LINK=REMVIP-3966
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a uno varios perfiles, las funciones añadidas en T_ARRAY_FUNCION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    V_EXISTE_PERFIL NUMBER(16); -- Vble. para almacenar la busqueda del perfil.
    V_EXISTE_FUNCION NUMBER(16); -- Vble. para almacenar la busqueda de la función.
    V_EXISTE_RELACION NUMBER(16); -- Vble. para almacenar la busqueda de la relación perfil/función.

    V_FP_ID NUMBER(16); -- Vble. para almacenar el id de la tabla FUN_PEF con la relación perfil/función.

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-3966';

    -- EDITAR: FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(

        --         NOMBRE_FUNCION                                     NOMBRE_PERFIL
        T_FUNCION('OPTIMIZACION_BUZON_TAREAS'                            , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_DATOS_GENERALES'                           , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_ADMISION'                                  , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_GESTION'                                   , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_ACTUACIONES'                               , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_GESTORES'                                  , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_AGENDA'                                          , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_ACTIVOS'                                         , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_AGRUPACIONES'                                    , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_TRABAJOS'                                        , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_MASIVO'                                          , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_BUSQUEDA_ACTIVOS'                                 , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_OBSERVACIONES'                             , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_FOTOS'                                     , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_DOCUMENTOS'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_AGRUPACIONES'                              , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_AGRUPACION'                                    , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_LIST_AGRUPACIONES'                             , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_TITULO_INFO_REGISTRAL'                     , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_INFO_ADMINISTRATIVA'                       , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_CARGAS'                                    , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_SITU_POSESORIA'                            , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_DATOS_COMUNIDAD'                           , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_FICHA_TRABAJO'                                 , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_FOTOS_SUBDIVISION'                             , 'HAYAGESTPUBL'),
        T_FUNCION('BOTON_CREAR_NOTIFICACION'                             , 'HAYAGESTPUBL'),
        T_FUNCION('BOTON_CREAR_TRABAJO'                                  , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_TOP_TAREAS'                                      , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_TOP_ALERTAS'                                     , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_TOP_AVISOS'                                      , 'HAYAGESTPUBL'),
        T_FUNCION('ACTIVO_OBSERVACIONES_ADD'                             , 'HAYAGESTPUBL'),
        T_FUNCION('ACTIVO_DOCUMENTOS_ADD'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TRABAJO_DIARIO_ADD'                                   , 'HAYAGESTPUBL'),
        T_FUNCION('TRABAJO_DOCUMENTOS_ADD'                               , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_PRECIOS'                                         , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_PUBLICACION'                                     , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_ACTIVO_DOCUMENTOS'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_PRECIOS'                                   , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_PUBLICACION'                               , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_COMERCIAL'                                 , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVO_ADMINISTRACION'                            , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DATOS_BASICOS_ACTIVO'                             , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_FOTOS_ACTIVO_WEB'                          , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FOTOS_ACTIVO_WEB'                                 , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FOTOS_ACTIVO_TECNICAS'                            , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_CHECKING_INFO_ADMISION'                           , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_CHECKING_DOC_ADMISION'                            , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_HIST_PETICIONES'                                  , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_PRESUPUESTO_ASIGNADO_ACTIVO'                      , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_VALORACIONES_PRECIOS'                      , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_VALORACIONES_PRECIOS'                             , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_TASACIONES'                                       , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_PROPUESTAS_PRECIO'                                , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_INFO_COMERCIAL_PUBLICACION'                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_INFO_COMERCIAL_PUBLICACION'                       , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_DATOS_PUBLICACION'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DATOS_PUBLICACION'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_COMERCIAL_VISITAS'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_COMERCIAL_OFERTAS'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DATOS_GENERALES_TRAMITE'                          , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_TAREAS_TRAMITE'                                   , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_HISTORICO_TAREAS_TRAMITE'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVOS_TRAMITE'                                  , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_AGRUPACION'                                       , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_LISTA_ACTIVOS_AGRUPACION'                  , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_LISTA_ACTIVOS_AGRUPACION'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FOTOS_AGRUPACION'                                 , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_OBSERVACIONES_AGRUPACION'                  , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_OBSERVACIONES_AGRUPACION'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_SUBDIVISIONES_AGRUPACION'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_COMERCIAL_AGRUPACION'                             , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FICHA_TRABAJO'                                    , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVOS_TRABAJO'                                  , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_TRAMITES_TRABAJO'                                 , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_DIARIO_GESTIONES_TRABAJO'                  , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DIARIO_GESTIONES_TRABAJO'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FOTOS_TRABAJO'                                    , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FOTOS_SOLICITANTE_TRABAJO'                        , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_FOTOS_SOLICITANTE_TRABAJO'                 , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FOTOS_PROVEEDOR_TRABAJO'                          , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_DOCUMENTOS_TRABAJO'                        , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DOCUMENTOS_TRABAJO'                               , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GESTION_ECONOMICA_TRABAJO'                        , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_COMERCIAL'                                       , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GENERACION_PROPUESTAS_PRECIO'                     , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_INCLUSION_AUTOMATICA_PRECIOS'                     , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_SELECCION_MANUAL_PRECIOS'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_HISTORICO_PROPUESTA_PRECIOS'                      , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_PUBLICACION_ACTIVOS'                              , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_CONFIGURACION_PUBLICACION'                        , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_CONFIGURACION_PUBLICACION'                 , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_VISITAS_COMERCIAL'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_OFERTAS_COMERCIAL'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DATOS_BASICOS_EXPEDIENTES'                        , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_OFERTA_EXPEDIENTES'                               , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES'                 , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_CONDICIONES_EXPEDIENTES'                          , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVOS_COMERCIALIZABLES_EXPEDIENTES'             , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_RESERVA_EXPEDIENTES'                              , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_COMPRADORES_EXPEDIENTES'                          , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DIARIO_GESTIONES_EXPEDIENTES'                     , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_DIARIO_GESTIONES_EXPEDIENTES'              , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_TRÁMITES_EXPEDIENTES'                             , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DOCUMENTOS_EXPEDIENTES'                           , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_FORMALIZACION_EXPEDIENTES'                        , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GESTION_ECONOMICA_EXPEDIENTES'                    , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES'               , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GASTOS_ADMINISTRACION'                            , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GESTION_GASTOS_ADMINISTRACION'                    , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GESTION_PROVISIONES_ADMINISTRACION'               , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DATOS_GENERALES_GASTOS'                           , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DETALLE_ECONOMICO_GASTOS'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ACTIVOS_AFECTADOS_GASTOS'                         , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_CONTABILIDAD_GASTOS'                              , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GESTION_GASTOS'                                   , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_IMPUGNACION_GASTOS'                               , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DOCUMENTOS'                                       , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_ADMINISTRACION_CONFIGURACION'                     , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_PROVEEDORES'                                      , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DATOS_PROVEEDORES'                                , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DOCUMENTOS_PROVEEDORES'                           , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_ADMINISTRACION'                                  , 'HAYAGESTPUBL'),
        T_FUNCION('MENU_CONFIGURACION'                                   , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_CONFIGURACION_PROPUESTA_PRECIO'                   , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_GESTORES_EXPEDIENTES'                             , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_PUBLICACION_LISTA_ACTIVOS_AGRUPACION'      , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_TAB_FOTOS_AGRUPACION'                          , 'HAYAGESTPUBL'),
        T_FUNCION('BOTON_RESOLUCION_EXPEDIENTE'                          , 'HAYAGESTPUBL'),
        T_FUNCION('BOTON_ANULAR_TRAMITE'                                 , 'HAYAGESTPUBL'),
        T_FUNCION('ROLE_PUEDE_VER_BOTON_APROBAR_INFORME'                 , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_DOCUMENTOS_AGRUPACION'                            , 'HAYAGESTPUBL'),
        T_FUNCION('TAB_SEGUIMIENTO_AGRUPACION'                           , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_PRECIOS_VIGENTES'                         , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_PUBLICACION_HISTORICO_MEDIADORES'         , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_PUBLICACION_CONDICIONES_ESPECIFICAS'      , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_LISTADO_ACTIVOS_EXPEDIENTE'               , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_GESTION_ECONOMICA_EXPEDIENTE'             , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_TEXTOS_OFERTA_EXPEDIENTE'                 , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_POS_FIRMA_FORMALIZACION_EXPEDIENTE'       , 'HAYAGESTPUBL'),
        T_FUNCION('EDITAR_GRID_LISTADO_FICHA_COMUNIDAD_ENTIDADES'        , 'HAYAGESTPUBL'),
        T_FUNCION('CARGA_MASIVA_IMPUESTOS'                               , 'HAYAGESTPUBL')
    ); 
    V_TMP_FUNCION T_FUNCION;


BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.FUN_PEF... Empezando a insertar datos en la tabla.');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Comprobamos que existe el perfil ' ||TRIM(V_TMP_FUNCION(2))||'.');
		
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES
                   WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_PERFIL;

        IF V_EXISTE_PERFIL > 0 THEN 

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_FUNCIONES... Comprobamos que existe la función ' ||TRIM(V_TMP_FUNCION(1))||'.');
		
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES
                       WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||'''';

            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_FUNCION;

            IF V_EXISTE_FUNCION > 0 THEN

                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES PEF
                           INNER JOIN '||V_ESQUEMA||'.FUN_PEF FPEF ON FPEF.PEF_ID = PEF.PEF_ID
                           INNER JOIN '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN ON FUN.FUN_ID = FPEF.FUN_ID 
                           WHERE FUN.FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''' 
                           AND PEF.PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''';

                EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_RELACION;

                IF V_EXISTE_RELACION = 0 THEN

                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (
                                 FUN_ID
                               , PEF_ID
                               , FP_ID
                               , VERSION
                               , USUARIOCREAR
                               , FECHACREAR
                               , BORRADO
                               ) VALUES (
                                      (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES
                                       WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''')
                                    , (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES
                                       WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||''')
                                    , S_FUN_PEF.NEXTVAL
                                    , 0
                                    , '''||V_ITEM||'''
                                    , SYSDATE
                                    , 0
                               )';

                    EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Insertada la relación perfil/función satisfactoriamente.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Se ha encontrado la relación entre el perfil '||TRIM(V_TMP_FUNCION(2))||' y la función '||TRIM(V_TMP_FUNCION(1))||'.');
                END IF;

            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_FUNCIONES... No se ha encontrado la función '||TRIM(V_TMP_FUNCION(1))||'.');
            END IF;

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_FUNCIONES... No se ha encontrado al perfil '||TRIM(V_TMP_FUNCION(2))||'.');
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
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

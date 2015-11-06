package es.capgemini.pfs.configuracion;

/**
 *
 * @author minigo
 *
 */
public final class ConfiguracionBusinessOperation {

    private ConfiguracionBusinessOperation() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     *****************************************************************************
     ** Constantes de los nombres de clase de los diccionarios.
     *****************************************************************************
     ****************************************************************************/

    public static final String CLASS_DD_SITUACION = "DDSituacion";
    public static final String CLASS_DD_TIPO_PERSONA = "DDTipoPersona";
    public static final String CLASS_DD_ESTADO_ITINERARIO = "DDEstadoItinerario";
    public static final String CLASS_DD_TIPO_ENTIDAD = "TipoEntidad";
    public static final String CLASS_DD_ESTADO_EXPEDIENTE = "DDEstadoExpediente";
    public static final String CLASS_DD_ESTADO_ITINERARIO3 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO4 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO5 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO6 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO7 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO8 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO9 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO10 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO11 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO12 = "DDEstadoItinerario";
    public static final String CLASS_DD_ESTADO_ITINERARIO13 = "DDEstadoItinerario";
    public static final String CLASS_DD_GRUPO_GESTOR = "DDGrupoGestor";
    public static final String CLASS_DD_PERSONA_EXTRA_3 = "DD_PX3_PERSONA_EXTRA_3";
    public static final String CLASS_DD_PERSONA_EXTRA_4 = "DD_PX3_PERSONA_EXTRA_4";
    public static final String CLASS_DD_POLITICA = "DDPolitica";
    public static final String CLASS_DD_RATING_AUXILIAR = "DDRatingAuxiliar";
    public static final String CLASS_DD_RATING_EXTERNO = "DD_REX_RATING_EXTERNO";
    public static final String CLASS_DD_SEXO = "DDSexo";
    public static final String CLASS_DD_TIPO_DOCUMENTO = "DDTipoDocumento";
    public static final String CLASS_DD_TIPO_TELEFONO = "DDTipoTelefono";
    public static final String CLASS_DD_CATALOGO_1 = "DDCatalogo1";
    public static final String CLASS_DD_CATALOGO_2 = "DDCatalogo2";
    public static final String CLASS_DD_CATALOGO_3 = "DDCatalogo3";
    public static final String CLASS_DD_CATALOGO_4 = "DDCatalogo4";
    public static final String CLASS_DD_CATALOGO_5 = "DDCatalogo5";
    public static final String CLASS_DD_CATALOGO_6 = "DDCatalogo6";
    public static final String CLASS_DD_ESTADO_CONTRATO = "DDEstadoContrato";
    public static final String CLASS_DD_ESTADO_FINANCIERO = "DDEstadoFinanciero";
    public static final String CLASS_DD_FINALIDAD_CONTRATO = "DDFinalidadContrato";
    public static final String CLASS_DD_FINALIDAD_OFICIAL = "DDFinalidadOficial";
    public static final String CLASS_DD_GARANTIA_CONTRATO = "DDGarantiaContrato";
    public static final String CLASS_DD_MONEDA = "DDMoneda";
    public static final String CLASS_DD_TIPO_INTERVENCION = "DDTipoIntervencion";
    public static final String CLASS_DD_TIPO_PRODUCTO = "DDTipoProducto";
    public static final String CLASS_DD_TIPO_PRODUCTO_ENTIDAD = "DDTipoProductoEntidad";
    /*****************************************************************************
     *****************************************************************************
     ** Constantes de los nombres de las Business Operations.
     *****************************************************************************
     ****************************************************************************/

    /*****************************************************************************
     ** DictionaryManager.
     ****************************************************************************/
    public static final String BO_DICTIONARY_GET = "dictionaryManager.get";
    public static final String BO_DICTIONARY_GET_BY_CODE = "dictionaryManager.getByCode";

    /*****************************************************************************
     ** UsuarioMangaer.
     ****************************************************************************/
    public static final String BO_USUARIO_MGR_GET_USUARIO_LOGADO = "usuarioManager.getUsuarioLogado";
    public static final String BO_USUARIO_MGR_GET = "usuarioManager.get";
    public static final String BO_USUARIO_MGR_GET_USUARIOS_ZONA_PERFIL = "usuarioManager.getUsuariosZonaPerfil";
    public static final String BO_USUARIO_MGR_FIND_USERS_PAGE = "usuarioManager.findUsersPage";
    public static final String BO_USUARIO_MGR_SET_DEFAULT_USER_ID = "usuarioManager.setDefaultUserId";
    public static final String BO_USUARIO_MGR_UPDATE = "usuarioManager.update";
    public static final String BO_USUARIO_MGR_UPDATE_ARRAY = "usuarioManager.updateArray";
    public static final String BO_USUARIO_MGR_GET_ZONAS_USUARIO_LOGADO = "usuarioManager.getZonasUsuarioLogado";
    public static final String BO_USUARIO_MGR_GET_BY_USERNAME = "usuarioManager.getByUsername";
    public static final String BO_USUARIO_MGR_FIND_USERNAME_ARRAY = "usuarioManager.findByUsernameArray";
    public static final String BO_USUARIO_MGR_FIND_BY_USERNAME = "usuarioManager.findByUsername";
    public static final String BO_USUARIO_MGR_GET_DEFAULT_USER_ID = "usuarioManager.getDefaultUserId";
    public static final String SET_DEFAULT_USER_ID = "usuarioManager.setDefaultUserId";
    public static final String BO_USUARIO_MGR_UPDATE_ARRAY_USUARIO = "usuarioManager.updateArrayUsuario";
    public static final String BO_USUARIO_MGR_UPDATE_LIST = "usuarioManager.updateList";
    public static final String BO_USUARIO_MGR_SAVE = "usuarioManager.save";
    public static final String BO_USUARIO_MGR_SAVE_OR_UPDATE = "usuarioManager.saveOrUpdate";
    public static final String BO_USUARIO_MGR_DELETE = "usuarioManager.delete";
    public static final String BO_USUARIO_MGR_DELETE_LIST = "usuarioManager.deleteList";
    public static final String BO_USUARIO_MGR_DELETE_USUARIO = "usuarioManager.deleteUsuario";
    public static final String BO_USUARIO_MGR_GET_OFICINAS = "usuarioManager.getOficinas";
    public static final String BO_USUARIO_MGR_RECUPERAR_PASSWORD = "usuarioManager.recuperarPassword";
    public static final String BO_USUARIO_MGR_GUARDAR_USUARIO = "usuarioManager.guardarUsuario";
    public static final String BO_USUARIO_MGR_GUARDAR_USUARIO_INTERNO = "usuarioManager.guardarUsuarioInterno";
    public static final String BO_USUARIO_MGR_BUSCAR_PERFIL_POR_CODIGO = "usuarioManager.buscarPerfilPorCodigo";
    public static final String BO_USUARIO_MGR_GET_PERFIL_LIST = "usuarioManager.getPerfiList";

    /*****************************************************************************
     ** ParametrizacionManager.
     ****************************************************************************/
    public static final String BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE = "parametrizacionManager.buscarParametroPorNombre";
    public static final String BO_PARAMETRIZACION_MGR_UDPATE = "parametrizacionManager.update";

    /*****************************************************************************
     ** ArquetipoManager.
     ****************************************************************************/
    public static final String BO_ARQ_MGR_GET = "arquetipoManager.get";
    public static final String BO_ARQ_MGR_GET_ARQUETIPO_CALCULADO_WITH_ESTADO = "arquetipoManager.getArquetipoCalculadoWithEstado";
    public static final String BO_ARQ_MGR_GET_WITH_ESTADO = "arquetipoManager.getWithEstado";
    public static final String BO_ARQ_MGR_CALCULAR_ARQUETIPO = "arquetipoManager.calcularArquetipo";
    public static final String BO_ARQ_MGR_IS_ARQUETIPO_RECUPERACION = "arquetipoManager.isArquetipoRecuperacion";
    public static final String BO_PARAMETRIZACION_MGR_GET_LIST = "arquetipoManager.getList";
    public static final String BO_ARQ_MGR_GET_BY_NOMBRE = "arquetipoManager.getByNombre";
    public static final String BO_ARQ_MGR_GET_RECUPERACION_BY_PERSONA = "arquetipoManager.getArquetipoRecuperacionByPersonaId";
    public static final String BO_ARQ_MGR_GET_LIST_RECUPERACION = "arquetipoManager.getListRecuperacion";
    public static final String BO_ARQ_MGR_GET_LIST_SEGUIMIENTO = "arquetipoManager.getListSeguimiento";
    
    /*****************************************************************************
     ** DDEstadoItinerarioManager.
     ****************************************************************************/
    public static final String BO_EST_ITI_MGR_FIND_BY_CODE = "estadoItinearioManager.findByCodigo";
    public static final String BO_EST_ITI_MGR_GET_ESTADOS = "estadoItinearioManager.getEstados";
    public static final String BO_EST_ITI_MGR_GET_ESTADOS_EXPEDIENTES = "estadoItinearioManager.getEstadosExpedientes";
    public static final String BO_EST_ITI_MGR_GET_ESTADOS_CLIENTES = "estadoItinearioManager.getEstadosClientes";
    public static final String BO_EST_ITI_MGR_GET_ESTADOS_ASUNTOS = "estadoItinearioManager.getEstadosAsuntos";

    /*****************************************************************************
     ** EstadoManager.
     ****************************************************************************/
    public static final String BO_EST_MGR_GET = "estadoManager.get";
    public static final String BO_EST_MGR_EXISTE_GESTOR_BY_PERFIL = "estadoManager.existeGestorByPerfilEstadoItinerario";

    /*****************************************************************************
     ** ReglasElevacionManager.
     ****************************************************************************/
    public static final String BO_REGLAS_MGR_GET = "reglasElevacionManager.get";
    public static final String BO_REGLAS_MGR_FIND_BY_TIPO_AND_ESTADO = "reglasElevacionManager.findByTipoAndEstado";

    /*****************************************************************************
     ** ZonaManager.
     ****************************************************************************/
    public static final String BO_ZONA_MGR_EXISTE_PERFIL_ZONA = "zonaManager.existePerfilZona";
    public static final String BO_ZONA_MGR_BUSCAR_ZONA_POR_PERFIL = "zonaManager.buscarZonasPorPerfil";
    public static final String BO_ZONA_MGR_GET = "zonaManager.get";
    public static final String BO_ZONA_MGR_GET_NIVELES = "zonaManager.getNiveles";
    public static final String BO_ZONA_MGR_GET_ALL_NIVELES = "zonaManager.getAllNiveles";
    public static final String BO_ZONA_MGR_GET_NIVEL = "zonaManager.getNivel";
    public static final String BO_ZONA_MGR_GET_ZONAS_POR_NIVEL = "zonaManager.getZonasPorNivel";
    public static final String BO_ZONA_MGR_GET_ALL_ZONAS_POR_NIVEL = "zonaManager.getAllZonasPorNivel";
    public static final String BO_ZONA_MGR_GET_ZONA_POR_PERFIL = "zonaManager.getZonasPorPerfil";
    public static final String BO_ZONA_MGR_GET_ZONA_POR_CODIGO_PERFIL = "zonaManager.getZonasPorCodigoPerfil";
    public static final String BO_ZONA_MGR_GET_ZONA_POR_CENTRO = "zonaManager.getZonaPorCentro";
    public static final String BO_ZONA_MGR_GET_ZONA_POR_CODIGO = "zonaManager.getZonaPorCodigo";
    public static final String BO_ZONA_MGR_GET_ZONA_POR_DESCRIPCION = "zonaManager.getZonaPorDescripcion";
    public static final String BO_ZONA_MGR_FIND_ZONA_BY_CODIGO = "zonaManager.findZonasBycodigo";
    public static final String BO_ZONA_MGR_GET_NIVELES_BY_ID = "zonaManager.getNivelById";
    public static final String BO_ZONA_MGR_GET_NIVELES_BY_ID_OR_EMPTY_OBJ = "zonaManager.getNivelByIdOrEmptyObj";
    public static final String BO_ZONA_MGR_GET_ZONA_TERRITORIAL = "zonaManager.getZonaTerritorial";
    
    /*****************************************************************************
     ** EntidadManager.
     ****************************************************************************/
    public static final String BO_ENTIDAD_MGR_GET_LISTA_ENTIDADES = "entidadManager.getListaEntidades";

    /*****************************************************************************
     ** ConfigManager.
     ****************************************************************************/
    public static final String BO_CONFIG_MGR_GET_CONFIG_BY_KEY = "configManager.getConfigByKey";
    public static final String BO_CONFIG_MGR_GET_CONFIG_BY_DTO = "configManager.getConfigByDTO";
    public static final String BO_CONFIG_MGR_CREATE_CONFIG_LIST_DTO = "configManager.createConfigListDTO";
    public static final String BO_CONFIG_MGR_SET_CONFIG_DAO = "configManager.setConfigDao";

    /*****************************************************************************
     ** UsuarioSecurityManager.
     ****************************************************************************/
    public static final String BO_USR_SEC_MGR_GET_BY_USERNAME = "usuarioSecurityManager.getByUsername";
    public static final String BO_USR_SEC_MGR_GET_BY_USERNAME_AND_ENTITY = "usuarioSecurityManager.getByUsernameAndEntity";
    public static final String BO_USR_SEC_MGR_GET = "usuarioSecurityManager.get";
    public static final String BO_USR_SEC_MGR_GET_USUARIO_LOGADO = "usuarioSecurityManager.getUsuarioLogado";
    public static final String BO_USR_SEC_MGR_GET_AUTHORITIES = "usuarioSecurityManager.getAuthorities";
	
	
}

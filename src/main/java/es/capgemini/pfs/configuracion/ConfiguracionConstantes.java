package es.capgemini.pfs.configuracion;

/**
 *
 * @author minigo
 *
 */
public final class ConfiguracionConstantes {

    private ConfiguracionConstantes() {
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

    /**
     * Business Operation DictionaryManager.getByCode.
     */
    public static final String BO_USUARIO_MGR_GET_USUARIO_LOGADO = "usuarioManager.getUsuarioLogado";

    /*****************************************************************************
     ** ParametrizacionManager.
     ****************************************************************************/
    public static final String BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE = "parametrizacionManager.buscarParametroPorNombre";
    public static final String BO_PARAMETRIZACION_MGR_UDPATE = "parametrizacionManager.update";

    /*****************************************************************************
     ** ArquetipoManager.
     ****************************************************************************/
    public static final String BO_ARQ_MGR_GET = "arquetipoManager.get";
    public static final String BO_ARQ_MGR_GET_WITH_ESTADO = "arquetipoManager.getWithEstado";
    public static final String BO_ARQ_MGR_CALCULAR_ARQUETIPO = "arquetipoManager.calcularArquetipo";

    /*****************************************************************************
     ** DDEstadoItinerarioManager.
     ****************************************************************************/

    public static final String BO_EST_ITI_MGR_FIND_BY_CODE = "estadoManager.findByCodigo";
}

package es.pfsgroup.plugin.precontencioso.burofax.api;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersonaManual;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.persona.dto.DtoPersonaManual;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonaManual;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.precontencioso.burofax.dto.ContratosPCODto;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxEnvioIntegracionPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDEstadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;

public interface BurofaxApi {

	public static final String TIPO_BUROFAX_DEFAULT = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getTipoBurofaxPorDefecto";
	public static final String OBTENER_CONTRATO = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getContrato";
	public static final String OBTENER_LISTA_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getListaBurofaxPCO";
	public static final String GUARDA_DIRECCION = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.guardaDireccion";
	//public static final String GUARDA_DIRECCION_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.guardaDireccionBurofax";
	public static final String DICCIONARIO_TIPO_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getTiposBurofaxex";
	public static final String CONFIGURA_TIPO_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.configurarTipoBurofax";
	public static final String OBTENER_CONTENIDO_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.obtenerContenidoBurofax";
	public static final String CONFIGURAR_CONTENIDO_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.configurarContenidoBurofax";
	public static final String OBTENER_PERSONA = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getPersonaById";
	public static final String GUARDA_PERSONA = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.guardaPersonaCreandoBurofax";
	public static final String OBTENER_PERSONAS_CON_DIRECCION = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getPersonasConDireccion";
	public static final String OBTENER_PERSONAS_CON_CONTRATO = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getPersonasConContrato";
	public static final String OBTENER_PERSONAS = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getPersonas";
	public static final String GUARDAR_ENVIO_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.guardarEnvioBurofax";
	public static final String OBTENER_TIPO_BUROFAX_BY_ENVIO = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getTipoBurofaxByIdEnvio";
	public static final String GUARDAR_INFORMACION_ENVIO = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.guardaInformacionEnvio";
	public static final String OBTENER_ENVIO_BY_ID = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getEnvioBurofaxById";
	public static final String OBTENER_ESTADO_BUROFAX_BY_ID = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getEstadoBurofaxById";
	public static final String OBTENER_ESTADOS_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getEstadosBurofax";
	public static final String OBTENER_TIPO_BUROFAX_BY_CODIGO = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getTipoBurofaxByCodigo";
	public static final String OBTENER_BUROFAX_ENVIO_INTE = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.getBurofaxEnvioIntegracionByIdEnvio";
	public static final String CANCELAR_EST_PREPARADO = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.cancelarEstadoPreparado";
	public static final String DESCARTAR_PERSONA_ENVIO = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.descartarPersonaEnvio";
	public static final String BORRAR_DIRECCION_MANUAL_BUROFAX = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.borrarDirManualBurofax";
	public static final String EXCLUIR_BUROFAX_POR_IDS = "es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi.excluirBurofaxPorIds";

	/**
	 * Obtiene una lista de tipos de burofax a partir del Procedimiento 
	 * @param idProcedimiento
	 * @param idContrato
	 * @return
	 */
	@BusinessOperationDefinition(TIPO_BUROFAX_DEFAULT)
	DDTipoBurofaxPCO getTipoBurofaxPorDefecto(Long idProcedimiento, Long idContrato);
	
	/**
	 * Obtiene un Contrato a partir de su id
	 * @param idContrato
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_CONTRATO)
	Contrato getContrato(Long idContrato);
	
	/**
	 * Devuelve una lista de burofax a partir del idProcedimiento
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_LISTA_BUROFAX)
	List<BurofaxPCO> getListaBurofaxPCO(Long idProcedimiento);
	
	/**
	 * Guarda una nueva direccion en la tabla DIR_DIRECCIONES y devuelve el id de la nueva direccion
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(GUARDA_DIRECCION)
	Long guardaDireccion(DireccionAltaDto dto);
	
	/**
	 * Guarda la direccion de EnvioBurofaxPCO
	 * @param idEnvio
	 * @param idDireccion
	 */
	/*
	@BusinessOperationDefinition(GUARDA_DIRECCION_BUROFAX)
	boolean guardaDireccionBurofax(Long idPersona,Long idDireccion,Long idProcedimiento,Long idContrato);
	*/
	
	/**
	 * Devuelve los tipos de Burofax
	 * @return
	 */
	@BusinessOperationDefinition(DICCIONARIO_TIPO_BUROFAX)
	List<DDTipoBurofaxPCO> getTiposBurofaxex();
	
	/**
	 * Configura el estado y el tipo de burofax de un envio
	 * @param idEnvio
	 * @param idTipoBurofax
	 * @param idDocumento
	 */
	@BusinessOperationDefinition(CONFIGURA_TIPO_BUROFAX)
	List<EnvioBurofaxPCO> configurarTipoBurofax(Long idTipoBurofax,String[] arrayIdDirecciones,String[] arrayIdBurofax,String[] arrayIdEnvios, Long idDocumento);
	
	/**
	 * Devuelve el contenido del burofax dado su envio
	 * @param idEnvio
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_CONTENIDO_BUROFAX)
	String obtenerContenidoBurofax(Long idEnvio);
	
	
	@BusinessOperationDefinition(CONFIGURAR_CONTENIDO_BUROFAX)
	void configurarContenidoBurofax(Long idEnvio,String contenido);
	
	@BusinessOperationDefinition(OBTENER_PERSONA)
	Persona getPersonaById(Long idPersona);
	
	/**
	 * Se crea un nuevo burofax configurando una nueva persona
	 * @param idPersona
	 * @param idProcedimientoPCO
	 */
	@BusinessOperationDefinition(GUARDA_PERSONA)
	void guardaPersonaCreandoBurofax(Long idPersona,Long idProcedimientoPCO);
	
	/**
	 * Devuelve una coleccioón de personas con direccion
	 * @param query
	 * @param idAsunto
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_PERSONAS_CON_DIRECCION)
	Collection<? extends Persona> getPersonasConDireccion(String query);
	
	/**
	 * Devuelve una coleccioón de personas
	 * @param query
	 * @param idAsunto
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_PERSONAS)
	Collection<? extends Persona> getPersonas(String query);
	
	/**
	 * Devuelve una coleccion de personas con contrato
	 * @param query
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_PERSONAS_CON_CONTRATO)
	Collection<DtoPersonaManual> getPersonasConContrato(String query);
	Collection<DtoPersonaManual> getPersonasConContrato(String query, boolean addManuales);
	
	
	/**
	 * Devuelve el tipo de burofax para un envio dado
	 * @param idEnvio
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_TIPO_BUROFAX_BY_ENVIO)
	DDTipoBurofaxPCO getTipoBurofaxByIdEnvio(Long idEnvio);
	
	/**
	 * Obtiene tipo burofax a partir de su codigo
	 * @param codigo
	 * @return
	 */
	@BusinessOperation(OBTENER_TIPO_BUROFAX_BY_CODIGO)
	DDTipoBurofaxPCO getTipoBurofaxByCodigo(String codigo);
	
	/**
	 * Guarda informacion del envio: Estado: Notificado/No notificado , fechaAcuse , fechaEnvio
	 * @param arrayIdEnvio
	 * @param idEstadoEnvio
	 * @param fechaEnvio
	 * @param fechaAcuse
	 */
	@BusinessOperationDefinition(GUARDAR_INFORMACION_ENVIO)
	void guardaInformacionEnvio(String[] arrayIdEnvio,Long idEstadoEnvio,Date fechaEnvio,Date fechaAcuse);
	
	/**
	 * Obtiene un envio burofax a partir de su id
	 * @param idEnvio
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_ENVIO_BY_ID)
	EnvioBurofaxPCO getEnvioBurofaxById(Long idEnvio);
	
	/**
	 * Obtiene un estado burofax a partir de su id
	 * @param idEstado
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_ESTADO_BUROFAX_BY_ID)
	DDEstadoBurofaxPCO getEstadoBurofaxById(Long idEstado);
	
	/**
	 * Obtiene una lista con los estado de burofax existentes
	 * @return
	 */
	@BusinessOperationDefinition(OBTENER_ESTADOS_BUROFAX)
	List<DDEstadoBurofaxPCO> getEstadosBurofax();
	
	/**
	 * Guarda toda la información cuando se realiza el envio de un burofax
	 * @param certificado
	 * @param listaEnvioBurofaxPCO
	 */
	@BusinessOperationDefinition(GUARDAR_ENVIO_BUROFAX)
	void guardarEnvioBurofax(Boolean certificado,List<EnvioBurofaxPCO> listaEnvioBurofaxPCO);
	
	@BusinessOperationDefinition(OBTENER_BUROFAX_ENVIO_INTE)
	BurofaxEnvioIntegracionPCO getBurofaxEnvioIntegracionByIdEnvio(Long idEnvio);

	List<ContratosPCODto> getContratosProcPersona(Long idProcedimientoPCO, Long idPersona, Boolean manual);
	
	PersonaManual guardaPersonaManual(String dni, String nombre, String app1, String app2, String propietarioCodigo, Long codClienteEntidad);
	
	ContratoPersonaManual guardaContratoPersonaManual(Long idPersonaManual, Long idContrato, String codigoTipoIntervencion);
	
	void crearBurofaxPersonaManual(Long idPersonaManual,Long idProcedimiento, Long idContratoPersonaManual);
	
	void crearBurofaxPersona(Long idPersona,Long idProcedimiento, Long idContratoPersona);

	void actualizaDireccion(DireccionAltaDto dto, Long idDireccion);
	
	PersonaManual updatePersonaManual(String dni, String nombre, String app1, String app2, Long idPersonaManual);
	
	@BusinessOperationDefinition(EXCLUIR_BUROFAX_POR_IDS)
	void excluirBurofaxPorIds(String idsBurofax);

}

package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.api;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDResultadoGestionTelefonica;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDTipoGestion;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonAccionesExtrajudicialesConstants;

/**
 * Interfaz de métodos para las operaciones de negocio de las acciones
 * judiciales de recobro
 * 
 * @author Guillem
 * 
 */
public interface RecobroAccionesExtrajudicialesManagerApi {

	public final String BO_EXP_GET_LISTADO_TIPO_GESTION = "expedienteRecobroApi.getListadoTipoGestion";
	public final String BO_EXP_GET_LISTADO_TIPO_RESULTADO = "expedienteRecobroApi.getListadoTipoResultado";
	public final String BO_EXP_GET_LISTADO_CICLO_RECOBRO_EXPEDIENTE = "expedienteRecobroApi.getListadoCicloRecobroExpediente";
	public final String BO_EXP_GET_ACCION_EXTRAJUDICIAL_BY_ID = "expedienteRecobroApi.getAccionExtrajudicialById";
	public final String BO_EXP_ES_AGENCIA = "RecobroAccionesExtrajudicialesManagerApi.esAgencia";

	/**
	 * Obtiene las acciones extrajudiciales por agencia, según el resultado
	 * obtenido y a partir de una determinada fecha de gestión
	 * 
	 * @param agencia
	 * @param fechaGestion
	 * @param resultadoGestionTelefonica
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_BO)
	public List<RecobroAccionesExtrajudiciales> obtenerAccionesExtrajudicialesPorAgenciaResultadoFechaGestion(RecobroAgencia agencia, Date fechaGestion,
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica);

	/**
	 * Obtiene las acciones extrajudiciales por agencia, contrato, según el
	 * resultado obtenido y a partir de una determinada fecha de gestión
	 * 
	 * @param agencia
	 * @param contrato
	 * @param fechaGestion
	 * @param resultadoGestionTelefonica
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_OBTENER_ACCIONES_POR_AGENCIA_CONTRATO_RESULTADO_FECHA_BO)
	public List<RecobroAccionesExtrajudiciales> obtenerAccionesExtrajudicialesPorAgenciaContratoResultadoFechaGestion(RecobroAgencia agencia, Contrato contrato, Date fechaGestion,
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica);

	/**
	 * Obtiene las acciones extrajudiciales del contrato
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_CICLORECOBROCONTRATO_BO)
	public Page getPageAccionesCicloRecobroContrato(RecobroAccionesExtrajudicialesDto dto);

	/**
	 * Obtiene las acciones extrajudiciales del persona
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_CICLORECOBROPERSONA_BO)
	public Page getPageAccionesCicloRecobroPersona(RecobroAccionesExtrajudicialesDto dto);

	/**
	 * Obtiene las acciones extrajudiciales de un expediente.
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_EXPEDIENTE_BO)
	public Page getPageAccionesRecobroExpediente(RecobroAccionesExtrajudicialesExpedienteDto dto);
	
	/**
	 * Obtiene las acciones extrajudiciales de un expediente según el usuario logado
	 * Si es interno o tiene permiso de ver todas devuelve todas las acciones asociadas
	 * Si es externo devuelve sólamente las acciones que corresponden a la agencia a la que pertenece el usuario
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_EXP_BYUSU_BO)
	public Page getPageAccionesRecobroExpedientePorTipoUsuario(RecobroAccionesExtrajudicialesExpedienteDto dto);

	/**
	 * Obtiene una acción extrajudicial.
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_BO)
	public RecobroAccionesExtrajudiciales getAccionExtrajudicial(Long idAccionExtrajudicial);

	/**
	 * Obtiene listado tipo gestión recobro
	 * 
	 * @param
	 * @return list
	 */
	@BusinessOperationDefinition(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_GET_LISTADO_TIPO_GESTION)
	public List<RecobroDDTipoGestion> getListadoTipoGestion();

	/**
	 * Obtiene listado tipo resultado
	 * 
	 * @param
	 * @return list
	 */
	@BusinessOperationDefinition(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_GET_LISTADO_TIPO_RESULTADO)
	public List<RecobroDDResultadoGestionTelefonica> getListadoTipoResultado();
	
	/**
	 * Obtiene listado ciclos recobro expediente
	 * 
	 * @param expId
	 * @return list
	 */
	@BusinessOperationDefinition(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_GET_LISTADO_CICLO_RECOBRO_EXPEDIENTE)
	public List<CicloRecobroExpediente> getListadoCiclosRecobroExpediente(Long expId);

	@BusinessOperationDefinition(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_GET_ACCION_EXTRAJUDICIAL_BY_ID)
	public RecobroAccionesExtrajudiciales getAccionExtrajudicialById(Long id);

	/**
	 * Indica si el usuario es una agencia
	 * @param usuario
	 * @return
	 */
	@BusinessOperationDefinition(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_ES_AGENCIA)
	public Boolean esAgencia(Long usuId);

}

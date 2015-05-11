package es.pfsgroup.recovery.recobroCommon.expediente.manager;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.RecobroDDTipoPalanca;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.gestorEntidad.model.GestorExpediente;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.AcuerdoExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.DtoCreacionManualExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.ExpedienteRecobroDto;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.ExpedienteRecobroContants;

public interface ExpedienteRecobroApi {

	
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_REC_OBTENER_NUM_CONTRATOS_GENERACION_EXP_MANUAL)
	public int obtenerNumContratosGeneracionExpManual(Long idPersona);

	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_REC_CREARF_EXP_MANUAL_RECOBRO)
	public Expediente crearExpedienteManual(Long idPersona, Long idContrato);

	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_REC_CANCELA_EXP_MANUAL_RECOBRO)
	public void cancelacionExpManualRecobro(Long idExpediente, Long idPersona);

	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_REC_GET_MODELO_FACTURACION)
	public List<RecobroModeloFacturacion> getModeloFacturacion();

	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_MGR_PROPONER_ACTIVAR_EXPEDIENTE_RECOBRO)
	public void proponerActivarExpedienteRecobro(DtoCreacionManualExpedienteRecobro dto);

	@BusinessOperationDefinition(ExpedienteRecobroContants.MEJ_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE)
	public void excluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto);

	@BusinessOperationDefinition(ExpedienteRecobroContants.MEJ_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE)
	public void incluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto);

	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_REC_GETEXPEDIENTE)
	public ExpedienteRecobro getExpedienteRecobro(Long id);

	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_MGR_BUSQUEDA_CONTRATOS_RECOBRO)
	public Page busquedaContratosRecobro(BusquedaContratosDto dto);

	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GET_AGENCIAS_RECOBRO)
	public List<RecobroAgencia> getAgenciasRecobro();
	
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GET_CABECERA_EXPEDIENTE_RECOBRO)
	public ExpedienteRecobroDto getCabeceraExpedienteRecobro(Long id);
	
	/**
	 * Devuelve el gestor que en estos momentos es el gestor de recobro del expediente
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GET_GESTORRECOBRO_ACTIVO_BO)
	public GestorExpediente getGestorRecobroActualExpediente(Long idExpediente);
	
	/**
	 * Devuelve true si el usuario que se le pasa como parámetro es el gestor de recobro del expediente
	 * 
	 * @param idExpediente
	 * @param idUsuario
	 * @return
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_IS_GESTORRECOBROEXP)
	public Boolean esGestorRecobroExpediente(Long idExpediente, Long idUsuario);
	
	/**
	 *  Devuelve true si el usuario que se le pasa como parámetro es el supervisor de recobro del expediente
	 * @param idExpediente
	 * @param idUsuario
	 * @return
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_IS_SUPERVISORRECOBROEXP)
	public Boolean esSupervisorRecobroExpediente(Long idExpediente, Long idUsuario);
	
	/**
	 * Devuelve true si el usuario logado pertenece a la agencia que actualmente está gestionando el expediente
	 * @param idExpediente
	 * @param idUsuario
	 * @return
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_IS_AGENCIARECOBRO_EXP)
	public Boolean esAgenciaRecobroExpediente(Long idExpediente, Long idUsuario);

	/**
	 * Devuelve la lista de acuerdos dados de alta para un expediente
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GETLIST_ACUERDOS)
	public List<Acuerdo> getAcuerdosExpediente(Long idExpediente);
	
	/**
	 * Crea un nuevo expediente de recobro para el expediente o modifica uno ya existente
	 * @param dto
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GUARDA_ACUERDO_EXPEDIENTE)
	public void guardarAcuerdoExpediente (AcuerdoExpedienteDto dto);
	
	/**
	 * Cambia el estado del acuerdo a propuesto
	 * @param idAcuerdo
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_PROPONER_ACUERDO)
	public void proponerAcuerdo(Long idAcuerdo);
	
	/**
	 * Cambia el estado del acuerdo a cancelado
	 * @param idAcuerdo
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_CANCELAR_ACUERDO )
	public void cancelarAcuerdo(Long idAcuerdo);
	
	/**
	 * Devuelve la lista de palancas asociadas al modelo de politicas asociado al expediente
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_LISTA_PALANCAS_PERMITIDAS)
	public List<RecobroDDTipoPalanca> buscaPalancasPermitidasExpediente(Long idExpediente);
	
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GET_BY_ID)
	public Expediente getExpediente(Long idExpediente);
	
	/**
	 * Devuelve una lista de agencias de recobro, 
	 * Si el usuario es interno devuelve todas y si es externo devuelve sólo 
	 * las agencias a las que pertenece este usuario
	 * @return
	 */
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GET_AGENCIAS_RECOBRO_USU)
	public List<RecobroAgencia> getAgenciasRecobroUsuario();
	
	
	@BusinessOperationDefinition(ExpedienteRecobroContants.BO_EXP_GET_ID_SAGER)
	public Long getIdSager();

}

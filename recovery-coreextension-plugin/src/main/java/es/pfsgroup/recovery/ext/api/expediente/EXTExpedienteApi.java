package es.pfsgroup.recovery.ext.api.expediente;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.api.ExpedienteApi;

public interface EXTExpedienteApi extends ExpedienteApi{
	
	public static final String AMBITO_EXPEDIENTE_CONTRATOS_MARCADOS="CM";
	public static final String EXT_EXP_MGR_BUSCAR_EXP_CON_CONTRATO = "es.pfsgroup.recovery.ext.api.expediente.buscaExpedientesConContrato";
	public static final String EXT_EXP_MGR_ES_GESTOR_CARACTERIZADO = "es.pfsgroup.recovery.ext.api.expediente.esGestorCaracterizado";
	public static final String EXT_EXP_MGR_ES_SUPERVISOR_CARACTERIZADO = "es.pfsgroup.recovery.ext.api.expediente.esSupervisorCaracterizado";
	
	/**
	 * Busca expedients que contengan un determinado contrato
	 * @param idContrato Contrato que buscamos
	 * @param estados Lista de estados posibles para los expedientes. Si se indica NULL se devuelven todos independientemente del estado
	 * @return
	 */
	@BusinessOperationDefinition(EXT_EXP_MGR_BUSCAR_EXP_CON_CONTRATO)
    @Transactional(readOnly = false)
	public List<? extends Expediente> buscaExpedientesConContrato(Long idContrato, String[] estados);
	
	/***
	 * Comprueba que el usuario logado tiene es gestor del tipo gestor empresas caraterizadas
	 * @param idExpediente Expediente que queremos comprobar
	 * @return 
	 * 
	 * */
	@BusinessOperationDefinition(EXT_EXP_MGR_ES_GESTOR_CARACTERIZADO)
	public boolean esGestorCaracterizado(Long idExpediente);
	
	/***
	 * Comprueba que el usuario logado tiene es gestor del tipo gestor empresas caraterizadas
	 * @param idExpediente Expediente que queremos comprobar
	 * @return 
	 * 
	 * */
	@BusinessOperationDefinition(EXT_EXP_MGR_ES_SUPERVISOR_CARACTERIZADO)
	public boolean esSupervisorCaracterizado(Long idExpediente);

	/**
	 * Eleva un expediente a revision, previa revisiÃ³n del estado de sus propuestas
	 * @param idExpediente id del expediente
	 * @param isSupervisor isSupervisor
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_REVISION)	
	void elevarExpedienteARevision(Long idExpediente, Boolean isSupervisor);

	/**
	 * Eleva un expediente a DECISION comite, previa revisiÃ³n del estado de sus propuestas
	 * @param idExpediente id del expediente
	 * @param isSupervisor boolean
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_DECISION_COMITE)
	void elevarExpedienteADecisionComite(Long idExpediente, Boolean isSupervisor);

	/**
	 * Devuelve un expediente a revision.
	 * @param idExpediente id del expediente
	 * @param respuesta String
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_REVISION)
	void devolverExpedienteARevision(Long idExpediente, String respuesta);

	/**
	 * Eleva un expediente a formalizar propuesta.
	 * @param idExpediente id del expediente
	 * @param isSupervisor isSupervisor
	 */	
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_FORMALIZAR_PROPUESTA)
	void elevarExpedienteAFormalizarPropuesta(Long idExpediente, Boolean isSupervisor);
	
	/**
	 * Devuelve un expediente a decisiÃ³n comitÃ©.
	 * @param idExpediente id del expediente
	 * @param respuesta String
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_DECISION_COMITE)
	public void devolverExpedienteADecisionComite(Long idExpediente, String respuesta);
	
	/**
	 * Elevar un expediente de Revisión a Ensanción
	 * @param idExpediente
	 * @param isSupervisor
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_REVISION_A_ENSANCION)
	public void elevarExpedienteDeREaENSAN(Long idExpediente, Boolean isSupervisor);
	
	/**
	 * Devolver un expediente de Ensanción a Revisión
	 * @param idExpediente
	 * @param respuesta
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_ENSANCION_A_REVISION)
	public void devolverExpedienteDeEnSancionARevision(Long idExpediente, String respuesta,Boolean isSupervisor);
	
	/**
	 * Elevar un expediente de Ensanción a Sancionado
	 * @param idExpediente
	 * @param isSupervisor
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_ENSANCION_A_SANCIONADO)
	public void elevarExpedienteDeENSANaSANC(Long idExpediente, Boolean isSupervisor);
	
	/**
	 * Devolver un expediente de Sancionado a Completar expediente
	 * @param idExpediente
	 * @param respuesta
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_SANCIONADO_A_COMPLETAR_EXPEDIENTE)
	public void devolverExpedienteDeSancionadoACompletarExpediente(Long idExpediente,String respuesta, Boolean isSupervisor);
	
	 
	
}

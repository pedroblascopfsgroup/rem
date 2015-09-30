package es.pfsgroup.plugin.recovery.mejoras.acuerdos.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

public interface PropuestaApi {

	public static final String BO_PROPUESTA_GET_LISTADO_PROPUESTAS = "mejacuerdo.listadoPropuestasByExpedienteId";
	public static final String BO_PROPUESTA_ES_GESTOR_SUPERVISOR_ACTUAL = "propuestaApi.usuarioLogadoEsGestorSupervisorActual";
	public static final String BO_PROPUESTA_GET_LISTADO_CONTRATOS_DEL_EXPEDIENTE = "mejacuerdo.listadoContratosByExpedienteId";

	@BusinessOperationDefinition(BO_PROPUESTA_GET_LISTADO_PROPUESTAS)
    @Transactional(readOnly = false)
    public List<EXTAcuerdo> listadoPropuestasByExpedienteId(Long idExpediente);

	@BusinessOperationDefinition(BO_PROPUESTA_GET_LISTADO_CONTRATOS_DEL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public List<Contrato> listadoContratosByExpedienteId(Long idExpediente);

	/**
	 * El usuario logado es Gestor o Supervisor de la fase en que se encuentra el Expediente
	 * 
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(BO_PROPUESTA_ES_GESTOR_SUPERVISOR_ACTUAL)
	public Boolean usuarioLogadoEsGestorSupervisorActual(Long idExpediente);

	/**
	 * El usuario logado es el que ha generado la propuesta
	 * @param idPropuesta
	 * @return
	 */
	public Boolean usuarioLogadoEsProponente(Long idPropuesta);

	/**
	 * 
	 * @param idPropuesta
	 */
	public void proponer(Long idPropuesta);
}

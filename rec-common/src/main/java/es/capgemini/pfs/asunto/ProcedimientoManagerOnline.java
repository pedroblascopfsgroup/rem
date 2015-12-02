package es.capgemini.pfs.asunto;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dto.DtoFormularioDemanda;
import es.capgemini.pfs.asunto.dto.DtoRecopilacionDocProcedimiento;
import es.capgemini.pfs.asunto.dto.PersonasProcedimientoDto;
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.persona.dto.DtoProcedimientoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Funciones relacionadas a los procedimientos.
 * Sólo funciones de interface (para compatibilidad con webflows)
 */
@Component
public class ProcedimientoManagerOnline {

	@Autowired
	private ProcedimientoManager procedimientoMgr; 

	/**
	 * Devuelve los procedimientos asociados a un expediente.
	 * 
	 * @param idExpediente
	 *            el id del expediente.
	 * @return la lista de procedimientos asociados.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTOS_DE_EXPEDIENTE)
	public List<Procedimiento> getProcedimientosDeExpediente(Long idExpediente) {
		return procedimientoMgr.getProcedimientosDeExpediente(idExpediente);
	}

	/**
	 * Devuelve las personas asociadas al contrato, indicando si también están
	 * afectadas al procedimiento.
	 * 
	 * @param idContrato
	 *            el id del contrato
	 * @param idProcedimiento
	 *            el id del procedimiento
	 * @return la lista de personas asociadas y un booleano que indica si está o
	 *         no asociada al procedimiento.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_PERSONAS_ASOCIADAS_A_CONTRATO_PROCEDIMIENTO)
	public List<PersonasProcedimientoDto> getPersonasAsociadasAContratoProcedimiento(Long idContrato, Long idProcedimiento) {
		return procedimientoMgr.getPersonasAsociadasAContratoProcedimiento(idContrato, idProcedimiento);
	}

	/**
	 * Devuelve un procedimiento a partir de su id.
	 * 
	 * @param idProcedimiento
	 *            el id del proceimiento
	 * @return el procedimiento
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO)
	public Procedimiento getProcedimiento(Long idProcedimiento) {
		return procedimientoMgr.getProcedimiento(idProcedimiento);
	}

	/**
	 * Devuelve los tipos de actuacion.
	 * 
	 * @return la lista de Tipos de actuación
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_TIPOS_ACTUACION)
	public List<DDTipoActuacion> getTiposActuacion() {
		return procedimientoMgr.getTiposActuacion();
	}

	/**
	 * Devuelve los tipos de procedimientos.
	 * 
	 * @return la lista de Tipos de procedimientos
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_TIPOS_PROCEDIMIENTO)
	public List<TipoProcedimiento> getTiposProcedimiento() {
		return procedimientoMgr.getTiposProcedimiento();
	}

	/**
	 * Devuelve una lista de tipos de procedimiento, filtrado por tipo de
	 * actuación
	 * 
	 * @param codigoTipoActuacion
	 * @return
	 */
	@BusinessOperation
	public List<TipoProcedimiento> getTipoProcedimientosPorTipoActuacion(String codigoTipoActuacion) {
		return procedimientoMgr.getTipoProcedimientosPorTipoActuacion(codigoTipoActuacion);
	}

	/**
	 * Devuelve los tipos de reclamación.
	 * 
	 * @return la lista de Tipos de reclamación
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_TIPOS_RECLAMACION)
	public List<DDTipoReclamacion> getTiposReclamacion() {
		return procedimientoMgr.getTiposReclamacion();
	}

	/**
	 * Salva un procedimiento, si ya existía lo modifica, si no lo crea y lo
	 * guarda.
	 * 
	 * @param dto
	 *            los datos del procedimiento.
	 * @return el id del procedimiento.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_SALVAR_PROCEDIMIMENTO)
	@Transactional(readOnly = false)
	public Long salvarProcedimiento(ProcedimientoDto dto) {
		return procedimientoMgr.salvarProcedimiento(dto);
	}

	/**
	 * Devuelve las personas que están relacionadas a alguno de los contratos
	 * que vine por parámetro, con un check 'asiste' que indica si había sido
	 * marcado en el procedimiento.
	 * 
	 * @param contratos
	 *            String: listado de los ids de contratos, separados por "-"
	 * @param idProcedimiento
	 *            Long: id del procedimiento
	 * @return ListDtoProcedimientoPersona
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_PERSONAS_DE_LOS_CONTRATOS_PROCEDIMIMENTO)
	public List<DtoProcedimientoPersona> getPersonasDeLosContratosProcedimiento(String contratos, Long idProcedimiento) {
		return procedimientoMgr.getPersonasDeLosContratosProcedimiento(contratos, idProcedimiento);
	}

	/**
	 * Borra un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            el id del procedimiento a borrar.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_BORRAR_PROCEDIMIENTO)
	@Transactional
	public void borrarProcedimiento(Long idProcedimiento) {
		procedimientoMgr.borrarProcedimiento(idProcedimiento);
	}

	/**
	 * save procedimiento.
	 * 
	 * @param p
	 *            procedimiento
	 * @return id
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_SAVE_PROCEDIMIENTO)
	@Transactional
	public Long saveProcedimiento(Procedimiento p) {
		return procedimientoMgr.saveProcedimiento(p);
	}

	/**
	 * Guarda la informaciï¿½n de recopilaciï¿½n del procedimiento.
	 * 
	 * @param dto
	 *            DtoRecopilacionDocProcedimiento
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_SAVE_RECOPILACION_PROCEDIMIENTO)
	@Transactional
	public void saveRecopilacionProcedimiento(DtoRecopilacionDocProcedimiento dto) {
		procedimientoMgr.saveRecopilacionProcedimiento(dto);
	}

	/**
	 * save procedimiento.
	 * 
	 * @param p
	 *            procedimiento
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO)
	@Transactional
	public void saveOrUpdateProcedimiento(Procedimiento p) {
		procedimientoMgr.saveOrUpdateProcedimiento(p);
	}

	/**
	 * Salva un procedimiento, si ya existia lo modifica, si no lo crea y lo
	 * guarda.
	 * 
	 * @param dto
	 *            los datos del procedimiento.
	 * @return el id del procedimiento.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GUARDAR_PROCEDIMIMENTO)
	@Transactional
	public Long guardarProcedimiento(ProcedimientoDto dto) {
		return procedimientoMgr.guardarProcedimiento(dto);
	}

	/**
	 * Devuelve la lista de Estados del Procedimiento.
	 * 
	 * @return la lista de Estados del Procedimiento
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_ESTADOS_PROCEDIMIENTOS)
	public List<DDEstadoProcedimiento> getEstadosProcedimientos() {
		return procedimientoMgr.getEstadosProcedimientos();
	}

	/**
	 * El gestor del procedimiento lo acepta iniciando el proceso JBPM
	 * correspondiente. Para ello le pasa el proceso JBPM el id del
	 * procedimiento como parámetro.
	 * 
	 * @param idProcedimiento
	 *            Long
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_ACEPTAR_PROCEDIMIENTO)
	public void aceptarProcedimiento(Long idProcedimiento) {
		procedimientoMgr.aceptarProcedimiento(idProcedimiento);
	}

	/**
	 * Crea la tarea de recopilar documentación para el procedimiento.
	 * 
	 * @param procedimiento
	 *            procedimiento.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_CREAR_TAREA_RECOPILAR_DOCUMENTACION)
	public void crearTareaRecopilarDocumentacion(Procedimiento procedimiento) {
		procedimientoMgr.crearTareaRecopilarDocumentacion(procedimiento);
	}

	/**
	 * Indica si el Usuario Logado es el gestor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el gestor.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_ES_GESTOR)
	public Boolean esGestor(Long idProcedimiento) {
		return procedimientoMgr.esGestor(idProcedimiento);
	}

	/**
	 * Indica si el Usuario Logado es el supervisor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el Supervisor.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_ES_SUPERVISOR)
	public Boolean esSupervisor(Long idProcedimiento) {
		return procedimientoMgr.esSupervisor(idProcedimiento);
	}

	/**
	 * Recupera los bienes para un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            Long
	 * @return lista de bienes.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO)
	public List<Bien> getBienesDeUnProcedimiento(Long idProcedimiento) {
		return procedimientoMgr.getBienesDeUnProcedimiento(idProcedimiento);
	}

	/**
	 * Recupera las personas afectadas a un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            long
	 * @return lista de personas
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_GET_PERSONAS_AFECTADAS)
	public List<Persona> getPersonasAfectadas(Long idProcedimiento) {
		return procedimientoMgr.getPersonasAfectadas(idProcedimiento);
	}

	/**
	 * Indica si el Usuario Logado tiene que responder alguna comunicación. Se
	 * usa para mostrar o no el botón responder.
	 * 
	 * @param idProcedimiento
	 *            el id del procedimiento.
	 * @return true o false.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_BUSCAR_TAREA_PENDIENTE)
	public TareaNotificacion buscarTareaPendiente(Long idProcedimiento) {
		return procedimientoMgr.buscarTareaPendiente(idProcedimiento);
	}

	/**
	 * Datos para generar el formulario de demanda judicial.
	 * 
	 * @param idProcedimiento
	 *            Long: id del procedimiento
	 * @return DtoFormularioDemanda
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_FORMULARIO_DEMANDA)
	public DtoFormularioDemanda formularioDemanda(Long idProcedimiento) {
		return procedimientoMgr.formularioDemanda(idProcedimiento);
	}

	/**
	 * Borra el procedimiento.
	 * 
	 * @param p
	 *            Procedimiento.
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_PRC_MGR_DELETE)
	@Transactional(readOnly = false)
	public void delete(Procedimiento p) {
		procedimientoMgr.delete(p);
	}
	
	/***
	 * 
	 * Funcion utilizada para el tramite de decision y aceptacion para obtener
	 * el tipo de procedimiento original del procedimiento padre
	 * 
	 * @param idProcedimiento
	 *            Id del procedimiento
	 * @return Descripcion del tipo de procedimiento original
	 * 
	 * */
	public String getTipoProcedimientoOriginal(Long idProcedimiento) {
		return procedimientoMgr.getTipoProcedimientoOriginal(idProcedimiento);
	}

}

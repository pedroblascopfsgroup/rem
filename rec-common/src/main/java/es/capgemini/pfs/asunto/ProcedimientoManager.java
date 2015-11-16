package es.capgemini.pfs.asunto;

import java.util.List;
import es.capgemini.pfs.asunto.dto.DtoFormularioDemanda;
import es.capgemini.pfs.asunto.dto.DtoRecopilacionDocProcedimiento;
import es.capgemini.pfs.asunto.dto.PersonasProcedimientoDto;
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.persona.dto.DtoProcedimientoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

public interface ProcedimientoManager {

	List<Procedimiento> getProcedimientosDeExpediente(Long idExpediente);

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
	List<PersonasProcedimientoDto> getPersonasAsociadasAContratoProcedimiento(Long idContrato, Long idProcedimiento);

	/**
	 * Devuelve un procedimiento a partir de su id.
	 * 
	 * @param idProcedimiento
	 *            el id del proceimiento
	 * @return el procedimiento
	 */
	Procedimiento getProcedimiento(Long idProcedimiento);

	/**
	 * Devuelve los tipos de actuacion.
	 * 
	 * @return la lista de Tipos de actuación
	 */
	List<DDTipoActuacion> getTiposActuacion();

	/**
	 * Devuelve los tipos de actuacion para un procedimiento
	 * 
	 * @param prc Procedimiento para el que obtener los tipos de actuación específicos donde podemos derivar.
	 * 
	 * @return la lista de Tipos de actuación
	 */
	List<DDTipoActuacion> getTiposActuacion(Procedimiento prc); 
	 
	/**
	 * Devuelve los tipos de procedimientos.
	 * 
	 * @return la lista de Tipos de procedimientos
	 */
	List<TipoProcedimiento> getTiposProcedimiento();

	/**
	 * Devuelve una lista de tipos de procedimiento, filtrado por tipo de
	 * actuación
	 * 
	 * @param codigoTipoActuacion
	 * @return
	 */
	List<TipoProcedimiento> getTipoProcedimientosPorTipoActuacion(String codigoTipoActuacion);
	
	/**
	 * Devuelve los tipos de reclamación.
	 * 
	 * @return la lista de Tipos de reclamación
	 */
	List<DDTipoReclamacion> getTiposReclamacion();

	/**
	 * Salva un procedimiento, si ya existía lo modifica, si no lo crea y lo
	 * guarda.
	 * 
	 * @param dto
	 *            los datos del procedimiento.
	 * @return el id del procedimiento.
	 */
	Long salvarProcedimiento(ProcedimientoDto dto);

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
	List<DtoProcedimientoPersona> getPersonasDeLosContratosProcedimiento(String contratos, Long idProcedimiento);

	/**
	 * Borra un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            el id del procedimiento a borrar.
	 */
	void borrarProcedimiento(Long idProcedimiento);

	/**
	 * save procedimiento.
	 * 
	 * @param p
	 *            procedimiento
	 * @return id
	 */
	Long saveProcedimiento(Procedimiento p);

	/**
	 * Guarda la informaciï¿½n de recopilaciï¿½n del procedimiento.
	 * 
	 * @param dto
	 *            DtoRecopilacionDocProcedimiento
	 */
	void saveRecopilacionProcedimiento(DtoRecopilacionDocProcedimiento dto);

	/**
	 * save procedimiento.
	 * 
	 * @param p
	 *            procedimiento
	 */
	void saveOrUpdateProcedimiento(Procedimiento p);

	/**
	 * Salva un procedimiento, si ya existia lo modifica, si no lo crea y lo
	 * guarda.
	 * 
	 * @param dto
	 *            los datos del procedimiento.
	 * @return el id del procedimiento.
	 */
	Long guardarProcedimiento(ProcedimientoDto dto);

	/**
	 * Devuelve la lista de Estados del Procedimiento.
	 * 
	 * @return la lista de Estados del Procedimiento
	 */
	List<DDEstadoProcedimiento> getEstadosProcedimientos();

	/**
	 * El gestor del procedimiento lo acepta iniciando el proceso JBPM
	 * correspondiente. Para ello le pasa el proceso JBPM el id del
	 * procedimiento como parámetro.
	 * 
	 * @param idProcedimiento
	 *            Long
	 */
	void aceptarProcedimiento(Long idProcedimiento);

	/**
	 * Crea la tarea de recopilar documentación para el procedimiento.
	 * 
	 * @param procedimiento
	 *            procedimiento.
	 */
	void crearTareaRecopilarDocumentacion(Procedimiento procedimiento);

	/**
	 * Indica si el Usuario Logado es el gestor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el gestor.
	 */
	Boolean esGestor(Long idProcedimiento);

	/**
	 * Indica si el Usuario Logado es el supervisor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el Supervisor.
	 */
	Boolean esSupervisor(Long idProcedimiento);

	/**
	 * Recupera los bienes para un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            Long
	 * @return lista de bienes.
	 */
	List<Bien> getBienesDeUnProcedimiento(Long idProcedimiento);

	/**
	 * Recupera las personas afectadas a un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            long
	 * @return lista de personas
	 */
	List<Persona> getPersonasAfectadas(Long idProcedimiento);

	/**
	 * Indica si el Usuario Logado tiene que responder alguna comunicación. Se
	 * usa para mostrar o no el botón responder.
	 * 
	 * @param idProcedimiento
	 *            el id del procedimiento.
	 * @return true o false.
	 */
	TareaNotificacion buscarTareaPendiente(Long idProcedimiento);

	/**
	 * Datos para generar el formulario de demanda judicial.
	 * 
	 * @param idProcedimiento
	 *            Long: id del procedimiento
	 * @return DtoFormularioDemanda
	 */
	DtoFormularioDemanda formularioDemanda(Long idProcedimiento);
	
	/**
	 * Borra el procedimiento.
	 * 
	 * @param p
	 *            Procedimiento.
	 */
	void delete(Procedimiento p);
	
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
	String getTipoProcedimientoOriginal(Long idProcedimiento);

}

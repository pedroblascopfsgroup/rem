package es.capgemini.pfs.expediente.api;

import java.util.Date;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.actitudAptitudActuacion.dto.DtoActitudAptitudActuacion;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;
import es.capgemini.pfs.cliente.dto.DtoListadoExpedientes;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.exclusionexpedientecliente.dto.DtoExclusionExpedienteCliente;
import es.capgemini.pfs.exclusionexpedientecliente.model.ExclusionExpedienteCliente;
import es.capgemini.pfs.expediente.ObjetoEntidadRegla;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.dto.DtoCreacionManualExpediente;
import es.capgemini.pfs.expediente.dto.DtoExpedienteContrato;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.PropuestaExpedienteManual;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.dto.DtoPersonaPoliticaExpediente;
import es.capgemini.pfs.politica.dto.DtoPersonaPoliticaUlt;
import es.capgemini.pfs.titulo.model.Titulo;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ExpedienteManagerApi {

	/**
	 * Busca expedientes para un filtro.
	 *
	 * @param expedientes
	 *            DtoBuscarExpedientes el filtro
	 * @return List la lista
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PAGINATED)
	public Page findExpedientesPaginated(DtoBuscarExpedientes expedientes);

	/**
	 * Busca expedientes para un filtro.
	 *
	 * @param expedientes
	 *            DtoBuscarExpedientes el filtro
	 * @return List la lista
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PAGINATED_DINAMICO)
	public Page findExpedientesPaginatedDinamico(
			DtoBuscarExpedientes expedientes, String params);

	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PARA_EXCEL_DINAMICO)
	public List<Expediente> findExpedientesParaExcelDinamico(
			DtoBuscarExpedientes dto, String params);

	/**
	 * Busca expedientes para un contrato determinado.
	 *
	 * @param idExpediente El id del expediente
	 * @return List
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_CONTRATO_POR_ID)
	public List<ExpedienteContrato> findExpedientesContratoPorId(
			Long idExpediente);

	/**
	 * Devuelve los contratos de un expediente sin paginar, si en el dto se especifica
	 * un procedimiento, se marca en el check 'seleccionado' si ya estaba inclu�do en �l.
	 * @param dto DtoBuscarContrato
	 * @return List DtoExpedienteContrato: lista de contratos de un expediente.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.CONTRATOS_DE_UN_EXPEDIENET_SIN_PAGINAR)
	public List<DtoExpedienteContrato> contratosDeUnExpedienteSinPaginar(
			DtoBuscarContrato dto);

	/**
	 * Busca los clientes relacionados con los contratos del expediente.
	 * @param idExpediente Long
	 * @return List
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_PERSONAS_BY_EXPEDIENET_ID)
	public List<Persona> findPersonasByExpedienteId(Long idExpediente);

	/**
	 *
	 * @param expediente DtoBuscarExpedientes
	 * @return List
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_OBTEER_SUPERVISOR_GENERACION_EXPEDIENTE)
	public List<String> obtenerSupervisorGeneracionExpediente(
			DtoBuscarExpedientes expediente);

	/**
	 * Devuelve un expediente a partir de su id.
	 *
	 * @param idExpediente el id del expediente
	 * @return El expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE)
	public Expediente getExpediente(Long idExpediente);

	/**
	 * Salva un expediente.
	 *
	 * @param exp el expediente a salvar
	 *
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE)
	public void saveOrUpdate(Expediente exp);

	/**
	 * Crea un expediente.
	 *
	 * @param idContrato id del contrato principal
	 * @param idArquetipo id del arquetipo del cliente
	 * @param idBPMExpediente proceso BPM asociado
	 * @param idPersona id
	 * @param idBPMCliente proceso bpm del cliente?
	 * @return Expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_AUTO)	
	public Expediente crearExpedienteAutomatico(Long idContrato,
			Long idPersona, Long idArquetipo, Long idBPMExpediente,
			Long idBPMCliente);

	/**
	 * Crea un Expediente Manual de Seguimiento (con pol�ticas).
	 * @param idPersona Long
	 * @return Expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_SEGUIMIENTO)
	public Expediente crearExpedienteManualSeg(Long idPersona);

	/**
	 * Crear un Expediente Manual de Seguimiento (con políticas) con un arquetipo indicado
	 * @param idPersona
	 * @param idArquetipo
	 * @return
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_SEGUIMIENTO_ARQ)
	public Expediente crearExpedienteManualSeg(Long idPersona, Long idArquetipo);

	/**
	 * Crea un Expediente Manual de Recuperaciones.
	 * @param idPersona id de la persona
	 * @param idContrato id del contrato
	 * @return expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL)
	public Expediente crearExpedienteManual(Long idPersona, Long idContrato);

	/**
	 * Crea un Expediente Manual de Recuperaciones con un arquetipo determinado
	 * @param idPersona
	 * @param idContrato
	 * @param idArquetipo
	 * @return
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_ARQ)
	public Expediente crearExpedienteManual(Long idPersona, Long idContrato,
			Long idArquetipo);

	/**
	 * confirma la creaci�n de un expediente automatico.
	 * @param idExpediente id expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CONFIRMAR_EXPEDIENTE_AUTOMATICO)
	public void confirmarExpedienteAutomatico(Long idExpediente);

	/**
	 * cambia el estado del itinerario del expediente.
	 * @param idExpediente id del expediente
	 * @param estadoItinerario estado
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CAMBIAR_ESTADO_ITINERARIO_EXPEDIENTE)
	public void cambiarEstadoItinerarioExpediente(Long idExpediente,
			String estadoItinerario);

	/**
	 * Retorna los expedientes de una persona no borrados (pero si los cancelados).
	 * @param idPersona id de un cliente
	 * @return expedientes
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_OBTENER_EXPEDIENTE_DE_UNA_PERSONA)
	public List<Expediente> obtenerExpedientesDeUnaPersona(Long idPersona);

	/**
	 * Devuelve si la persona que se pasa como parámetro tiene expedientes de seguimiento activos.
	 * @param idPersona id de una persona
	 * @return boolean
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_TIENE_EXPEDIENTE_SEGUIMIENTO)
	public Boolean tieneExpedienteDeSeguimiento(Long idPersona);

	/**
	 * Devuelve si la persona que se pasa como parámetro tiene expedientes de recuperación activos.
	 * @param idPersona id de una persona
	 * @return boolean
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_TIENE_EXPEDIENTE_RECUPERACION)
	public Boolean tieneExpedienteDeRecuperacion(Long idPersona);

	/**
	 * Retorna los expedientes de una persona no borrados (pero si los cancelados).
	 * @param idPersona id de un cliente
	 * @return expedientes
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_OBTENER_EXPEDIENTE_DE_UNA_PERSONA_PAGINADOS)
	public Page obtenerExpedientesDeUnaPersonaPaginados(
			DtoListadoExpedientes dto);

	/**
	 * Retorna los expedientes de una persona no borrados ni cancelados.
	 * @param idPersona id de un cliente
	 * @return expedientes
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_OBTENER_EXPEDIENTES_DE_UNA_PERSONA_NO_CANCELADOS)
	public List<Long> obtenerExpedientesDeUnaPersonaNoCancelados(Long idPersona);

	/**
	 * Setea el instante en que cambi� el estado de un expediente.
	 * @param idExpediente el id del expediente.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SET_INSTANCE_CAMBIO_ESTADO_EXPEDIENTE)
	public void setInstanteCambioEstadoExpediente(Long idExpediente);

	/**
	 * Devuelve los titulos de un expediente.
	 * @param idExpediente el id del expediente
	 * @return los titulos.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_TITULOS_EXPEDIENTE)
	public List<Titulo> findTitulosExpediente(Long idExpediente);

	/**
	 * Eleva un expediente a revision.
	 * @param idExpediente id del expediente
	 * @param isSupervisor isSupervisor
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_REVISION)
	public void elevarExpedienteARevision(Long idExpediente,
			Boolean isSupervisor);

	/**
	 * Devuelve un expediente a completar.
	 * @param idExpediente id del expediente
	 * @param respuesta String
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_COMPLETAR)
	public void devolverExpedienteACompletar(Long idExpediente, String respuesta);

	/**
	 * Eleva un expediente a DECISION comite.
	 * @param idExpediente id del expediente
	 * @param isSupervisor boolean
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_DECISION_COMITE)
	public void elevarExpedienteADecisionComite(Long idExpediente,
			Boolean isSupervisor);

	/**
	 * Devuelve un expediente a revision.
	 * @param idExpediente id del expediente
	 * @param respuesta String
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_REVISION)
	public void devolverExpedienteARevision(Long idExpediente, String respuesta);

	/**
	 * Eleva un expediente a formalizar propuesta.
	 * @param idExpediente id del expediente
	 * @param isSupervisor isSupervisor
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_FORMALIZAR_PROPUESTA)
	public void elevarExpedienteAFormalizarPropuesta(Long idExpediente,
			Boolean isSupervisor);

	/**
	 * Devuelve un expediente a decisión comité.
	 * @param idExpediente id del expediente
	 * @param respuesta String
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_DECISION_COMITE)
	public void devolverExpedienteADecisionComite(Long idExpediente, String respuesta);

	/**
	 * calcular el comite del expediente.
	 * @param idExpediente id del expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CALCULAR_COMITE_EXPEDIENTE)
	public void calcularComiteExpediente(Long idExpediente);

	/**
	 * Indica si se puede mostrar la pesta�a de decisi�n de comit� de la consulta de expediente.
	 * Cumple con los campos de precondiciones y activaci�n del CU WEB-30,
	 * los permisos a nivel de funciones de perfil los maneja la vista con los tags.
	 * @param idExpediente el id del expediente que se quiere ver.
	 * @return un Boolean indicando si se puede o no ver el tab de DC.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_PUEDE_MOSTRAR_SOLAPA_DECISION_COMITE)
	public Boolean puedeMostrarSolapaDecisionComite(Long idExpediente);

	/**
	 * Indica si se puede mostrar la pesta�a de marcado de pol�ticas de la consulta de expediente.
	 * Los permisos a nivel de funciones de perfil los maneja la vista con los tags.
	 * @param idExpediente el id del expediente que se quiere ver.
	 * @return un Boolean indicando si se puede o no ver el tab.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_PUEDE_MOSTRAR_SOLAPA_MARCADO_POLITICA)
	public Boolean puedeMostrarSolapaMarcadoPoliticas(Long idExpediente);

	/**
	 * solicita una cancelacion de un expediente.
	 * @param idExpediente id expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SOLICITAR_CANCELACION_EXPEDIENTE)
	public void solicitarCancelacionExpediente(Long idExpediente);

	/**
	 * solicita una cancelacion de un expediente.
	 * @param idExpediente id tarea original
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_RECHAZAR_CANCELACION_EXPEDIENTE)
	public void rechazarCancelacionExpediente(Long idExpediente);

	/**
	 * Se cancela el expediente.
	 * @param idExpediente id
	 * @param conNotificacion conNotificacion
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CANCELACION_EXPEDIENTE)
	public void cancelacionExp(Long idExpediente, boolean conNotificacion);

	/**
	 * Se cancela el expediente generado manualmente a partir de un cliente.
	 * @param idExpediente Long: id del expediente propuesto
	 * @param idPersona Long: id de la persona con la que se gener� el expediente (y el cliente manual)
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CANCELACION_EXPEDIENTE_MANUAL)
	public void cancelacionExpManual(Long idExpediente, Long idPersona);

	/**
	 * Congela un expediente.
	 * @param idExpediente id
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CONGELAR_EXPEDIENTE)
	public void congelarExpediente(Long idExpediente);

	/**
	 * Congela un expediente.
	 * @param idExpediente id
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DESCONGELAR_EXPEDIENTE)
	public void desCongelarExpediente(Long idExpediente);

	/**
	 * Busca aaa.
	 * @param idAAA Long
	 * @return ActitudAptitudActuacion
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_BUSCAR_AAA)
	public ActitudAptitudActuacion buscarAAA(Long idAAA);

	/**
	 * Actualiza ActitudAptitudActuacion.
	 * @param dtoAAA DtoActitudAptitudActuacion
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_UPDATE_AAA)
	public void updateActitudAptitudActuacion(DtoActitudAptitudActuacion dtoAAA);

	/**
	 * Actualiza ActitudAptitudActuacion.
	 * @param dtoAAA DtoActitudAptitudActuacion
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_UPDATE_AAA_REVISION)
	public void updateActitudAptitudActuacionRevision(
			DtoActitudAptitudActuacion dtoAAA);

	/**
	 * @param id Long: id del expediente
	 * @return Todas las personas titulares de los contratos relacionados del expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_PERSONAS_TIT_CONTRATOS_EXPEDIENTES)
	public List<Persona> findPersonasTitContratosExpediente(Long id);

	/**
	 * @param idExpediente Long
	 * @return Todas las personas de los contratos relacionados del expediente,
	 * con archivos adjuntos
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_PERSONAS_CONTRATOS_CON_ADJUNTOS)
	public List<Persona> findPersonasContratosConAdjuntos(Long idExpediente);

	/**
	 * @param idExpediente Long
	 * @return Todos los contratos relacionados del expediente,
	 * con archivos adjuntos
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_CONTRATOS_CON_ADJUNTOS)
	public List<Persona> findContratosConAdjuntos(Long idExpediente);

	/**
	 * Devuelve los contratos y títulos de un expediente.
	 * @param idExpediente el id del expediente
	 * @return los titulos.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_CONTRATOS_RIESGO_EXPEDIENTES)
	public List<Contrato> findContratosRiesgoExpediente(Long idExpediente);

	/**
	 * cierre de la toma de decision de un expediente.
	 * @param idExpediente expediente
	 * @param observaciones observaciones de la decision
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_TOMAR_DECISION_COMITE)
	public void tomarDecisionComite(Long idExpediente, String observaciones);

	/**
	 * cierre de la toma de decision de un expediente.
	 * @param idExpediente expediente
	 * @param observaciones observaciones de la decision
	 * @param automatico automatico
	 * @param generaNotificacion generaNotificacion
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_TOMAR_DECISION_COMITE_COMPLETO)
	public void tomarDecisionComite(Long idExpediente, String observaciones,
			boolean automatico, boolean generaNotificacion);

	/**
	 * upload.
	 * @param uploadForm upload
	 * @return String
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_UPLOAD)
	public String upload(WebFileItem uploadForm);

	/**
	 * delete un adjunto.
	 * @param expedienteId exp
	 * @param adjuntoId adjunto
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DELETE_ADJUNTO)
	public void deleteAdjunto(Long expedienteId, Long adjuntoId);

	/**
	 * bajar un adjunto.
	 * @param adjuntoId adjunto
	 * @return file
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_BAJAR_ADJUNTO)
	public FileItem bajarAdjunto(Long adjuntoId);

	/**
	 * obtiene la propuesta de expediente manual activa.
	 * @param idExpediente id expediente
	 * @return propuesta
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_PROPUESTA_EXPEDIENTE_MANUAL)
	public PropuestaExpedienteManual getPropuestaExpedienteManual(
			Long idExpediente);

	/**
	 * propone un expediente o lo activa en caso de que sea supervisor.
	 * @param dto DtoCreacionManualExpediente:
	 * <ul>
	 * <li>idExpediente id del expediente</li>
	 * <li>idPersona id de la persona titular del contrato que se seleccion� para generar el pase</li>
	 * <li>codigoMotivo motivo</li>
	 * <li>observaciones observaciones</li>
	 * <li>idPropuesta id propuesta manual</li>
	 * <li>isSupervisor isSupervisor</li>
	 * </ul>
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_PROPONER_ACTIVAR_EXPEDIENTE)
	public void proponerActivarExpediente(DtoCreacionManualExpediente dto);

	/**
	 * Obtiene la solicitud de exclusi�n de clientes en un expediente.
	 * @param idExpediente Long: expediente asociado a la exclusi�n
	 * @return ExclusionExpedienteCliente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_EXCLUSION_EXPEDIENTE_CLIENTE_BY_EXPEDIENTE)
	public ExclusionExpedienteCliente findExclusionExpedienteClienteByExpedienteId(
			Long idExpediente);

	/**
	 * @param see ExclusionExpedienteCliente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE_EXCLUSION_EXPEDIENTE_CLIENTE)
	public void saveOrUpdateExclusionExpedienteCliente(
			ExclusionExpedienteCliente see);

	/**
	 * @param dto DtoExclusionExpedienteCliente
	 * @param idExpediente Long
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SAVE_EXCLUSION_EXPEDIENTE_CLIENTE)
	public void saveExclusionExpedienteCliente(
			DtoExclusionExpedienteCliente dto, Long idExpediente);

	/**
	 * Devuelve la solicitud de creaci�n.
	 * @param id el id de la solicitud.
	 * @return la solicitud.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_BUSCAR_SOLICITUD_CANCELACION)
	public SolicitudCancelacion buscarSolicitudCancelacion(Long id);

	/**
	 * Busca una solicitud de cancelaci�n de expediente por el id de la tarea asociada.
	 * @param idTarea el id de la tarea.
	 * @return la solicitud.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_BUSCAR_SOLICITUD_CANCELACION_POR_TAREA)
	public SolicitudCancelacion buscarSolCancPorTarea(Long idTarea);

	/**
	 * Toma la decision sobre una solicitud de cancelaci�n del expediente.
	 * @param idExpediente el id del expediente sobre el que se toma la decision.
	 * @param idSolicitud el id de la solicitud de cancelaci�n.
	 * @param aceptar la decision.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_TOMAR_DECISION_CANCELACION)
	public void tomarDecisionCancelacion(Long idExpediente, Long idSolicitud,
			boolean aceptar);

	/**
	 * Genera todos los datos necesarios para tomar un decision de comite automatica.
	 * @param idExpediente Long
	 * @param dca DecisionComiteAutomatico
	 * @return idAsunto
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_DATOS_PARA_DECISION_COMITE_AUTO)
	public Long crearDatosParaDecisionComiteAutomatica(Long idExpediente,
			DecisionComiteAutomatico dca);

	/**
	 * Incluye los contratos al expediente.
	 * @param dto DtoExclusionContratoExpediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE)
	public void incluirContratosAlExpediente(
			DtoInclusionExclusionContratoExpediente dto);

	/**
	 * Excluye el contrato del expediente.
	 * @param dto DtoExclusionContratoExpediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE)
	public void excluirContratosAlExpediente(
			DtoInclusionExclusionContratoExpediente dto);

	/**
	 * Lanza una excepci�n si el expediente fue decidido o se est� decidiendo en comit�.
	 * @param idExpediente Long
	 * @throws BusinessOperationException
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_EXISTE_DECISION_INICIADA)
	public void existeDecisionIniciada(Long idExpediente);

	/**
	 * Actualiza el timer y el vencimiento tras la aceptaci�n de la prorroga.
	 * @param idProcessInstance ID del BPM
	 * @param idTareaAsociada ID TareaNotificacion asociada
	 * @param fechaPropuesta Fecha de la prorroga
	 * @param nombreTimer Nombre del timer a actualizar
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_PRORROGA_EXTRA)
	public void prorrogaExtra(Long idProcessInstance, Long idTareaAsociada,
			Date fechaPropuesta, String nombreTimer);

	/**
	 * Hace la b�squeda de expedientes para mostrar en excel.
	 * @param dto los par�metros de b�squeda
	 * @return la lista de expedientes
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PARA_EXCEL)
	public List<Expediente> findExpedientesParaExcel(DtoBuscarExpedientes dto);

	/**
	 * Devuelve las reglas de elevaci�n del expediente y dice adem�s si est� o no cumplida.
	 * @param idExpediente long
	 * @return List
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_REGLAS_ELEVACION_EXPEDIENTE)
	public List<ReglasElevacion> getReglasElevacionExpediente(Long idExpediente);

	/**
	 * Devuelve las reglas de elevaci�n del expediente y dice adem�s si est� o no cumplida.
	 * @param idExpediente long
	 * @param idReglaElevacion long
	 * @return idReglaElevacion long
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_ENTIDADES_REGLA_ELEVACON_EXPEDIENTE)
	public List<ObjetoEntidadRegla> getEntidadReglaElevacionExpediente(
			Long idExpediente, Long idReglaElevacion);

	/**
	 * Devuelve verdadero si el expediente pasado es de tipo recobro
	 * @param expediente
	 * @return
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_IS_RECOBRO)
	public boolean isRecobro(Long idExpediente);

	/**
	 * Devuelve una lista con las personas pertenecientes al contrato que, seg�n
	 * las reglas definidas, deben tener una pol�tica marcada obligatoriamente.
	 * @param idExpediente
	 *            Long
	 * @return Lista de las personas
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_PERSONAS_MARCADO_OBLIGATORIO)
	public List<DtoPersonaPoliticaUlt> getPersonasMarcadoObligatorio(
			Long idExpediente);

	/**
	 * Devuelve una lista con las personas pertenecientes al contrato que, seg�n
	 * las reglas definidas, deben tener una pol�tica marcada obligatoriamente.
	 * @param idExpediente
	 *            Long
	 * @return Lista de las personas
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_PERSONAS_MARCADO_OPCIONAL)
	public List<DtoPersonaPoliticaUlt> getPersonasMarcadoOpcional(
			Long idExpediente);

	/**
	 * Cierra una decisi�n de pol�tica desde un expediente de seguimiento.
	 * @param idExpediente long
	 * @return Boolean devuelve si se cerr� correctamente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CERRAR_DECISION_POLITICA)
	public Boolean cerrarDecisionPolitica(Long idExpediente);

	/**
	 * Cierra una decisi�n de pol�tica de un superusuario.
	 * @param idPolitica long
	 * @return Boolean devuelve si se cerr� correctamente
	 */
	@BusinessOperationDefinition
	public Boolean cerrarDecisionPoliticaSuperusuario(Long idPolitica);

	/**
	 * Obtiene todas las personas del expediente con su poltica vigente asociada o la ltima
	 * del estado actual de expediente (CE/RE/DC). Si el expediente no es de seguimiento se
	 * retorna una lista vaca.
	 * @param idExpediente Long
	 * @return List DtoPersonaPoliticaExpediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_PERSONAS_POLITICAS_DEL_EXPEDIENTE)
	public List<DtoPersonaPoliticaExpediente> getPersonasPoliticasDelExpediente(
			Long idExpediente);

	/**
	 * Actualiza un expediente contrato.
	 * @param ec el expcnt.
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO)
	public void updateExpedienteContrato(ExpedienteContrato ec);

	/**
	 * Recupera el expedienteContrato indicado.
	 * @param ecId Long.
	 * @return ExpedienteContrato
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDINTE_CONTRATO)	
	public ExpedienteContrato getExpedienteContrato(Long ecId);

	/**
	 * Guarda una solicitud de cancelaci�n
	 * @param solicitudCancelacion Solicitud a guardar
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GUARDAR_SOLICITUD_CANCELACION)
	public void guardarSolicitudCancelacion(
			SolicitudCancelacion solicitudCancelacion);

	/**
	 * Devuelve si una persona No tiene ning�n expediente activo para la creaci�n de cliente
	 * @param idPersona
	 * @return True en caso de que no tenga ningun expediente
	 */
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SIN_EXPEDIENTES_ACTIVOS_DE_UNA_PERSONA)
	public Boolean sinExpedientesActivosDeUnaPersona(Long idPersona);
	
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
	public void devolverExpedienteDeEnSancionARevision(Long idExpediente, String respuesta, Boolean isSupervisor);
	
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
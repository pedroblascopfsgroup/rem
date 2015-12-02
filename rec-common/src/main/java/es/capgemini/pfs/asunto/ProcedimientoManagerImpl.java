package es.capgemini.pfs.asunto;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.dao.ProcedimientoContratoExpedienteDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.asunto.dto.DtoFormularioDemanda;
import es.capgemini.pfs.asunto.dto.DtoRecopilacionDocProcedimiento;
import es.capgemini.pfs.asunto.dto.PersonasProcedimientoDto;
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.persona.dto.DtoProcedimientoPersona;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;

/**
 * Funciones relacionadas a los procedimientos.
 */
@Service(value="procedimientoManager")
public class ProcedimientoManagerImpl implements ProcedimientoManager {

	private final Log logger = LogFactory.getLog(getClass());
	@Autowired
	private Executor executor;

	@Autowired
	private ProcedimientoContratoExpedienteDao procedimientoContratoExpedienteDao;

	@Autowired
	private ProcedimientoDao procedimientoDao;

	@Autowired
	private TipoProcedimientoDao tipoProcedimientoDao;

	/**
	 * Devuelve los procedimientos asociados a un expediente.
	 * 
	 * @param idExpediente
	 *            el id del expediente.
	 * @return la lista de procedimientos asociados.
	 */
	@Override
	public List<Procedimiento> getProcedimientosDeExpediente(Long idExpediente) {
		return procedimientoDao.getProcedimientosExpediente(idExpediente);
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
	@Override
	public List<PersonasProcedimientoDto> getPersonasAsociadasAContratoProcedimiento(Long idContrato, Long idProcedimiento) {
		EventFactory.onMethodStart(this.getClass());
		List<PersonasProcedimientoDto> l = new ArrayList<PersonasProcedimientoDto>();
		Contrato c = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);
		for (ContratoPersona cp : c.getContratoPersona()) {
			PersonasProcedimientoDto pdto = new PersonasProcedimientoDto();
			pdto.setContratoPersona(cp);
			l.add(pdto);
		}
		if (idProcedimiento != null && idProcedimiento != 0L) {
			Procedimiento proc = procedimientoDao.get(idProcedimiento);
			for (Persona p : proc.getPersonasAfectadas()) {
				for (PersonasProcedimientoDto pdto : l) {
					if (p.getId() == pdto.getContratoPersona().getPersona().getId()) {
						pdto.setAsociada(Boolean.TRUE);
					}
				}
			}
		}
		EventFactory.onMethodStop(this.getClass());
		return l;
	}

	/**
	 * Devuelve un procedimiento a partir de su id.
	 * 
	 * @param idProcedimiento
	 *            el id del proceimiento
	 * @return el procedimiento
	 */
	@Override
	public Procedimiento getProcedimiento(Long idProcedimiento) {
		EventFactory.onMethodStart(this.getClass());
		if (idProcedimiento == 0L) {
			return null;
		}
		return procedimientoDao.get(idProcedimiento);
	}

	/**
	 * Devuelve los tipos de actuacion.
	 * 
	 * @return la lista de Tipos de actuación
	 */
	@Override
	public List<DDTipoActuacion> getTiposActuacion() {
		return this.getTiposActuacion(null);
	}

	@Override
	public List<DDTipoActuacion> getTiposActuacion(Procedimiento prc) {
		return (List<DDTipoActuacion>) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_LIST, DDTipoActuacion.class.getName());
	}
	
	/**
	 * Devuelve los tipos de procedimientos.
	 * 
	 * @return la lista de Tipos de procedimientos
	 */
	@Override
	public List<TipoProcedimiento> getTiposProcedimiento() {
		return tipoProcedimientoDao.getList();
	}

	/**
	 * Devuelve una lista de tipos de procedimiento, filtrado por tipo de
	 * actuación
	 * 
	 * @param codigoTipoActuacion
	 * @return
	 */
	@Override
	public List<TipoProcedimiento> getTipoProcedimientosPorTipoActuacion(String codigoTipoActuacion) {
		return tipoProcedimientoDao.getTipoProcedimientosPorTipoActuacion(codigoTipoActuacion);
	}

	/**
	 * Devuelve los tipos de reclamación.
	 * 
	 * @return la lista de Tipos de reclamación
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<DDTipoReclamacion> getTiposReclamacion() {
		return (List<DDTipoReclamacion>) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_LIST, DDTipoReclamacion.class.getName());
	}

	/**
	 * Salva un procedimiento, si ya existía lo modifica, si no lo crea y lo
	 * guarda.
	 * 
	 * @param dto
	 *            los datos del procedimiento.
	 * @return el id del procedimiento.
	 */
	@Transactional(readOnly = false)
	@Override
	public Long salvarProcedimiento(ProcedimientoDto dto) {
		Procedimiento p = saveOrUpdateProcedimiento(dto);

		// Al crear una nueva lista borramos la anterior (de contratos
		// relacionados con el proc.)
		if (dto.getContratosAfectados() == null) {
			String[] idsExpedienteContratos = dto.getSeleccionContratos().split(",");
			List<ExpedienteContrato> listado = new ArrayList<ExpedienteContrato>(idsExpedienteContratos.length);
			for (int i = 0; i < idsExpedienteContratos.length; i++) {
				listado.add((ExpedienteContrato) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDINTE_CONTRATO, Long.decode(idsExpedienteContratos[i])));
			}
			p.setExpedienteContratos(listado);
		} else {
			p.setExpedienteContratos(dto.getContratosAfectados());
		}

		Long id = procedimientoDao.save(p);
		procedimientoContratoExpedienteDao.actualizaCEXProcedimiento(p.getProcedimientosContratosExpedientes(), id);

		// Ahora iteramos los contratos y agregamos el procedimiento,
		// y quitamos la marca de 'Sin Actuación' si la tubiera
		for (ExpedienteContrato ec : p.getExpedienteContratos()) {
			if (ec.getProcedimientos() == null) {
				ec.setProcedimientos(new ArrayList<Procedimiento>());
			}
			if (ec.getContrato().getProcedimientos() == null) {
				ec.getContrato().setProcedimientos(new ArrayList<Procedimiento>());
			}
			ec.getProcedimientos().add(p);
			ec.getContrato().getProcedimientos().add(p);
			ec.setSinActuacion(false);
			executor.execute(InternaBusinessOperation.BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO, ec);
			executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_SAVE_OR_UPDATE, ec.getContrato());
		}

		return id;
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
	@Override
	@SuppressWarnings("unchecked")
	public List<DtoProcedimientoPersona> getPersonasDeLosContratosProcedimiento(String contratos, Long idProcedimiento) {
		// Lista de las personas de los contratos marcados
		List<Persona> personasMarcadas = null;
		// DTO con la lista anterior más el check que indica si ya estaba
		// marcado en el procedimiento
		List<DtoProcedimientoPersona> procedimientoPersonas = new ArrayList<DtoProcedimientoPersona>();
		// DTO para interar
		DtoProcedimientoPersona procedimientoPersona = null;
		String[] idsContratos = contratos.split("-");
		List<String> idsContratosList = Arrays.asList(idsContratos);
		if (idsContratos.length != 0 && !idsContratos[0].equals("")) {
			personasMarcadas = (List<Persona>) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CLIENTES_DE_CONTRATOS, idsContratosList);
		} else {
			personasMarcadas = new ArrayList<Persona>(); // Lista vacía
		}
		List<Persona> personasAfectadas = null;
		if (idProcedimiento != null && idProcedimiento.longValue() != 0L && personasMarcadas.size() > 0) {
			// Personas marcadas en el procedimiento
			personasAfectadas = procedimientoDao.get(idProcedimiento).getPersonasAfectadas();
		} else {
			personasAfectadas = new ArrayList<Persona>();
		}
		for (int i = 0; i < personasMarcadas.size(); i++) {
			procedimientoPersona = new DtoProcedimientoPersona();
			procedimientoPersona.setPersona(personasMarcadas.get(i));
			if (personasAfectadas.size() > 0) {
				if (personasAfectadas.contains(personasMarcadas.get(i))) {
					procedimientoPersona.setAsiste(true);
				} else {
					procedimientoPersona.setAsiste(false);
				}
			} else {
				procedimientoPersona.setAsiste(false);
			}
			procedimientoPersonas.add(procedimientoPersona);
		}
		return procedimientoPersonas;
	}

	/**
	 * Borra un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            el id del procedimiento a borrar.
	 */
	@Override
	@Transactional
	public void borrarProcedimiento(Long idProcedimiento) {
		logger.debug("BORRANDO PROCEDIMIENTO " + idProcedimiento);
		Procedimiento proc = procedimientoDao.get(idProcedimiento);
		proc.setExpedienteContratos(null);
		proc.setPersonasAfectadas(null);

		DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
				DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO);

		proc.setEstadoProcedimiento(estadoProcedimiento);

		// procedimientoContratoExpedienteDao.actualizaCEXProcedimiento(proc.getProcedimientosContratosExpedientes(),
		// idProcedimiento);

		procedimientoDao.delete(proc);
	}

	/**
	 * save procedimiento.
	 * 
	 * @param p
	 *            procedimiento
	 * @return id
	 */
	@Override
	@Transactional
	public Long saveProcedimiento(Procedimiento p) {
		Long idProcedimiento = procedimientoDao.save(p);
		procedimientoContratoExpedienteDao.actualizaCEXProcedimiento(p.getProcedimientosContratosExpedientes(), idProcedimiento);
		return idProcedimiento;
	}

	/**
	 * Guarda la informaciï¿½n de recopilaciï¿½n del procedimiento.
	 * 
	 * @param dto
	 *            DtoRecopilacionDocProcedimiento
	 */
	@Override
	@Transactional
	public void saveRecopilacionProcedimiento(DtoRecopilacionDocProcedimiento dto) {
		Procedimiento p = procedimientoDao.get(dto.getProcedimiento().getId());
		p.setFechaRecopilacion(dto.getProcedimiento().getFechaRecopilacion());
		p.setObservacionesRecopilacion(dto.getProcedimiento().getObservacionesRecopilacion());
		procedimientoDao.save(p);

		// Marcamos la tarea como aceptada
		if (dto.getProcedimiento().getFechaRecopilacion() != null) {
			Long idBPM = p.getProcessBPM();
			if (idBPM != null)
				executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
		}
	}

	/**
	 * save procedimiento.
	 * 
	 * @param p
	 *            procedimiento
	 */
	@Override
	@Transactional
	public void saveOrUpdateProcedimiento(Procedimiento p) {
		procedimientoDao.saveOrUpdate(p);
		procedimientoContratoExpedienteDao.actualizaCEXProcedimiento(p.getProcedimientosContratosExpedientes(), p.getId());
	}

	/**
	 * Salva un procedimiento, si ya existia lo modifica, si no lo crea y lo
	 * guarda.
	 * 
	 * @param dto
	 *            los datos del procedimiento.
	 * @return el id del procedimiento.
	 */
	@Override
	@Transactional
	public Long guardarProcedimiento(ProcedimientoDto dto) {
		return saveOrUpdateProcedimiento(dto).getId();
	}

	private Procedimiento saveOrUpdateProcedimiento(ProcedimientoDto dto) {
		Procedimiento p;

		if (dto.getIdProcedimiento() != null) {
			logger.debug("SALVANDO PROCEDIMIENTO " + dto.getIdProcedimiento());
			p = procedimientoDao.get(dto.getIdProcedimiento());
		} else {
			logger.debug("SALVANDO PROCEDIMIENTO NUEVO");
			p = new Procedimiento();
			DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
					DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION);
			p.setEstadoProcedimiento(estadoProcedimiento);
			dto.setEnConformacion(true);
		}

		// Si el procedimiento se ha elevado desde un asunto y no es un
		// procedimiento original, solo se permite modificar el asunto
		if (!dto.getEnConformacion()) {
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getAsunto());
			p.setAsunto(asunto);
		} else {
			// En caso contrario se actualiza el resto
			if (dto.getPersonasAfectadas() == null) {
				String[] idsPersonas = dto.getSeleccionPersonas().split("-");
				Persona[] personas = new Persona[idsPersonas.length];
				for (int i = 0; i < idsPersonas.length; i++) {
					if (!"".equals(personas[i])) {
						personas[i] = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, Long.decode(idsPersonas[i]));
					}
				}
				p.setPersonasAfectadas(new ArrayList<Persona>(Arrays.asList(personas)));
			} else {
				p.setPersonasAfectadas(dto.getPersonasAfectadas());
			}

			if (p.getEstadoProcedimiento() == null) {
				DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
						DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION);
				p.setEstadoProcedimiento(estadoProcedimiento);
			}

			DDTipoActuacion tipoActuacion = (DDTipoActuacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoActuacion.class, dto.getActuacion());
			p.setTipoActuacion(tipoActuacion);
			DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoReclamacion.class, dto.getTipoReclamacion());
			p.setTipoReclamacion(tipoReclamacion);
			p.setTipoProcedimiento(tipoProcedimientoDao.getByCodigo(dto.getTipoProcedimiento()));
			p.setPlazoRecuperacion(dto.getPlazo());
			p.setPorcentajeRecuperacion(dto.getRecuperacion());
			p.setSaldoRecuperacion(dto.getSaldorecuperar());
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getAsunto());
			p.setAsunto(asunto);
			p.setSaldoOriginalVencido(dto.getSaldoOriginalVencido());
			p.setSaldoOriginalNoVencido(dto.getSaldoOriginalNoVencido());
		}

		procedimientoDao.saveOrUpdate(p);
		return p;
	}

	/**
	 * Devuelve la lista de Estados del Procedimiento.
	 * 
	 * @return la lista de Estados del Procedimiento
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<DDEstadoProcedimiento> getEstadosProcedimientos() {
		return (List<DDEstadoProcedimiento>) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_LIST, DDEstadoProcedimiento.class.getName());
	}

	/**
	 * El gestor del procedimiento lo acepta iniciando el proceso JBPM
	 * correspondiente. Para ello le pasa el proceso JBPM el id del
	 * procedimiento como parámetro.
	 * 
	 * @param idProcedimiento
	 *            Long
	 */
	@Override
	public void aceptarProcedimiento(Long idProcedimiento) {
		try {
			Procedimiento procedimiento = procedimientoDao.get(idProcedimiento);

			DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
					DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO);
			procedimiento.setEstadoProcedimiento(estadoProcedimiento);

			String nombreJBPM = procedimiento.getTipoProcedimiento().getXmlJbpm();
			Map<String, Object> param = new HashMap<String, Object>();
			param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, idProcedimiento);
			Long idBPM = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, nombreJBPM, param);
			procedimiento.setProcessBPM(idBPM);

			this.saveOrUpdateProcedimiento(procedimiento);

		} catch (Exception e) {
			// TODO quitar esto luego cuando el FO implemente su parte.
			logger.error("Error al lanzar el proceso judicial", e);
		}
	}

	/**
	 * Crea la tarea de recopilar documentación para el procedimiento.
	 * 
	 * @param procedimiento
	 *            procedimiento.
	 */
	@Override
	public void crearTareaRecopilarDocumentacion(Procedimiento procedimiento) {
		Long idBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA, procedimiento.getId(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO,
				SubtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO, PlazoTareasDefault.CODIGO_RECOPILAR_DOCUMENTACION, true);

		procedimiento.setProcessBPM(idBPM);
		saveOrUpdateProcedimiento(procedimiento);
	}

	/**
	 * Indica si el Usuario Logado es el gestor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el gestor.
	 */
	@Override
	public Boolean esGestor(Long idProcedimiento) {
		Asunto asunto = procedimientoDao.get(idProcedimiento).getAsunto();
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		return asunto.getGestor().getUsuario().getId().equals(usuario.getId());
	}

	/**
	 * Indica si el Usuario Logado es el supervisor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el Supervisor.
	 */
	@Override
	public Boolean esSupervisor(Long idProcedimiento) {
		Asunto asunto = procedimientoDao.get(idProcedimiento).getAsunto();
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		return asunto.getSupervisor().getUsuario().getId().equals(usuario.getId());
	}

	/**
	 * Recupera los bienes para un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            Long
	 * @return lista de bienes.
	 */
	@Override
	public List<Bien> getBienesDeUnProcedimiento(Long idProcedimiento) {
		Procedimiento prc = procedimientoDao.get(idProcedimiento);
		List<Bien> bienes = new ArrayList<Bien>();
		if (!Checks.esNulo(prc) && !Checks.esNulo(prc.getBienes())) {
			for (ProcedimientoBien prcBien : prc.getBienes()) {
				bienes.add(prcBien.getBien());
			}
		}
		return bienes;

	}

	/**
	 * Recupera las personas afectadas a un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            long
	 * @return lista de personas
	 */
	@Override
	public List<Persona> getPersonasAfectadas(Long idProcedimiento) {
		return procedimientoDao.get(idProcedimiento).getPersonasAfectadas();
	}

	/**
	 * Indica si el Usuario Logado tiene que responder alguna comunicación. Se
	 * usa para mostrar o no el botón responder.
	 * 
	 * @param idProcedimiento
	 *            el id del procedimiento.
	 * @return true o false.
	 */
	@Override
	public TareaNotificacion buscarTareaPendiente(Long idProcedimiento) {
		EventFactory.onMethodStart(this.getClass());
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		EventFactory.onMethodStop(this.getClass());
		return procedimientoDao.buscarTareaPendiente(idProcedimiento, usuario.getId());
	}

	/**
	 * Datos para generar el formulario de demanda judicial.
	 * 
	 * @param idProcedimiento
	 *            Long: id del procedimiento
	 * @return DtoFormularioDemanda
	 */
	@Override
	public DtoFormularioDemanda formularioDemanda(Long idProcedimiento) {
		// Formateadores
		SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY);
		DecimalFormat monedaDecimalFormat = new DecimalFormat(FormatUtils.FORMATO_MONEDA + " " + FormatUtils.EURO);

		// Cargamos el DTO con los datos para el formulario
		Procedimiento procedimiento = procedimientoDao.get(idProcedimiento);
		DtoFormularioDemanda dto = new DtoFormularioDemanda();
		dto.setIdProcedimiento(procedimiento.getId().toString());
		dto.setFecha(fechaFormat.format(new Date()));
		dto.setMontoPrincipal(monedaDecimalFormat.format(procedimiento.getSaldoRecuperacion()));
		dto.setNombreAbogado(procedimiento.getAsunto().getGestor().getUsuario().getApellidoNombre() + " (" + procedimiento.getAsunto().getGestor().getDespachoExterno().getDespacho() + ")");
		String nombresDemandados = "";
		String nombresDomiciliosDemandados = "";
		String don;
		for (Persona persona : procedimiento.getPersonasAfectadas()) {
			nombresDemandados += persona.getApellidoNombre() + "\n";
			if (persona.getTipoPersona().getCodigo().equals(DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA)) {
				don = "Don/Doña ";
			} else {
				don = "";
			}
			nombresDomiciliosDemandados += don + persona.getApellidoNombre();
			if (persona.getDirecciones().size() > 0) {
				nombresDomiciliosDemandados += ", cuyo domicilio a efectos de comunicaciones en este procedimiento, radica en " + persona.getDirecciones().get(0);
			}
			nombresDomiciliosDemandados += ", con " + persona.getTipoDocumento() + " N° " + persona.getDocId() + ".\n";
		}
		dto.setNombresDemandados(nombresDemandados);
		dto.setNombresDomiciliosDemandados(nombresDomiciliosDemandados);
		String listaFincas = "";
		List<Bien> bienesDelProcedimiento = getBienesDeUnProcedimiento(procedimiento.getId());
		int i = 1;
		for (Bien bien : bienesDelProcedimiento) {
			String finca = "Finca N° " + i + "\n";
			if (bien.getTipoBien() != null) {
				finca += "Tipo bien: " + bien.getTipoBien().getDescripcion();
			}
			if (bien.getValorActual() != null) {
				finca += ", Valor actual: " + monedaDecimalFormat.format(bien.getValorActual());
			}
			if (bien.getImporteCargas() != null) {
				finca += ", Valor total cargas: " + monedaDecimalFormat.format(bien.getImporteCargas());
			}
			if (bien.getDescripcionBien() != null) {
				finca += ", Descripción bien y cargas: " + bien.getDescripcionBien();
			}
			if (bien.getReferenciaCatastral() != null && !bien.getReferenciaCatastral().equals("")) {
				finca += ", Ref. catastral: " + bien.getReferenciaCatastral();
			}
			if (bien.getSuperficie() != null) {
				finca += ", Superficie en m2: " + bien.getSuperficie();
			}
			if (bien.getPoblacion() != null && !bien.getPoblacion().equals("")) {
				finca += ", Población: " + bien.getPoblacion();
			}
			if (bien.getDatosRegistrales() != null && !bien.getDatosRegistrales().equals("")) {
				finca += ", Datos registrales: " + bien.getDatosRegistrales();
			}
			if (bien.getFechaVerificacion() != null) {
				finca += ", Fecha verificación: " + fechaFormat.format(bien.getFechaVerificacion());
			}
			listaFincas += finca + "\n";
		}
		dto.setListaFincas(listaFincas);
		return dto;
	}

	/**
	 * Borra el procedimiento.
	 * 
	 * @param p
	 *            Procedimiento.
	 */
	@Override
	@Transactional(readOnly = false)
	public void delete(Procedimiento p) {
		procedimientoDao.delete(p);
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
	@Override
	public String getTipoProcedimientoOriginal(Long idProcedimiento) {
		try {
			
			Procedimiento proc = procedimientoDao.get(idProcedimiento);

			if (proc.getProcedimientoPadre() != null) {
				return this.getTipoProcedimientoOriginal(proc.getProcedimientoPadre().getId());
			} else {
				String ddTpoCodigo = proc.getTipoProcedimiento().getCodigo();
				if ("P01".equals(ddTpoCodigo) || "P02".equals(ddTpoCodigo) || "P03".equals(ddTpoCodigo) || "P04".equals(ddTpoCodigo) || "P15".equals(ddTpoCodigo) || "P16".equals(ddTpoCodigo)
						|| "P17".equals(ddTpoCodigo) || "P24".equals(ddTpoCodigo) || "P56".equals(ddTpoCodigo) || "P55".equals(ddTpoCodigo) || "P412".equals(ddTpoCodigo)) {
					return proc.getTipoProcedimiento().getCodigo();
				} else
					return "";
			}
		} catch (Exception e) {
			return "";
		}

	}

}

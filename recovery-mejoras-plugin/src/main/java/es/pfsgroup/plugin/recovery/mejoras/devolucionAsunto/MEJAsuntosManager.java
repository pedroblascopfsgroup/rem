package es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.ObservacionAceptacion;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJAsuntoDao;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJFichaAceptacionDao;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJObservacionAceptacionDao;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dto.MEJEditaAdjuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dto.MEJFichaAceptacionDto;

@Component
public class MEJAsuntosManager {

	@Autowired
	private DynamicElementManager tabManager;

	@Autowired
	private Executor executor;

	@Autowired
	private MEJObservacionAceptacionDao observacionAceptacionDao;

	@Autowired
	private MEJAsuntoDao asuntoDao;

	@Autowired
	private MEJFichaAceptacionDao fichaAceptacionDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	private MessageService messageService;
	
	@Autowired
	private FuncionManager funcionManager;

	/**
	 * 
	 * @param id
	 *            del objeto AdjuntoExpediente
	 * @return el objeto AdjuntoExpediente cuyo id coincide con el parámetro que
	 *         se le pasa
	 * 
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GET_ADJUNTO_EXPEDIENTE)
	public AdjuntoExpediente getAdjuntoExpedienteById(Long id) {
		EventFactory.onMethodStart(this.getClass());
		return genericDao.get(AdjuntoExpediente.class, genericDao.createFilter(
				FilterType.EQUALS, "id", id));
	}

	/**
	 * 
	 * @param id
	 *            del objeto AdjuntoContrato
	 * @return el objeto AdjuntoContrato cuyo id coincide con el parámetro que
	 *         se le pasa como parámetro
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GET_ADJUNTO_CONTRATO)
	public AdjuntoContrato getAdjuntoContratoById(Long id) {
		EventFactory.onMethodStart(this.getClass());
		return genericDao.get(AdjuntoContrato.class, genericDao.createFilter(
				FilterType.EQUALS, "id", id));
	}

	/**
	 * 
	 * @param id
	 *            del objeto AdjuntoPersona
	 * @return
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GET_ADJUNTO_PERSONA)
	public AdjuntoPersona getAdjuntoPersonaById(Long id) {
		EventFactory.onMethodStart(this.getClass());
		return genericDao.get(AdjuntoPersona.class, genericDao.createFilter(
				FilterType.EQUALS, "id", id));
	}

	/**
	 * 
	 * @param id
	 *            del adjunto del asunto
	 * @return objeto del tipo AdjuntoAsunto
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GET_ADJUNTOASUNTO)
	public AdjuntoAsunto getAdjuntoAsuntoById(Long id) {
		EventFactory.onMethodStart(this.getClass());
		return genericDao.get(AdjuntoAsunto.class, genericDao.createFilter(
				FilterType.EQUALS, "id", id));
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GUARDA_ADJUNTOASUNTO)
	@Transactional(readOnly = false)
	public void guardaAdjuntoAsunto(MEJEditaAdjuntoDto dto) {
		AdjuntoAsunto adjunto = genericDao.get(AdjuntoAsunto.class, genericDao
				.createFilter(FilterType.EQUALS, "id", dto.getId()));
		if (dto.getDescripcion().length() > 1000) {
			throw new BusinessOperationException(
					"plugin.mejoras.adjunto.descripcion.demasiadoLarga.mensaje");
		} else {
			adjunto.setDescripcion(dto.getDescripcion());
		}
		genericDao.save(AdjuntoAsunto.class, adjunto);
	}

	/**
	 * 
	 * @param dto
	 *            de edición de adjuntos guarda lo la descripción en el adjunto
	 *            del expediente
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GUARDA_ADJUNTO_CONTRATO)
	@Transactional(readOnly = false)
	public void guardaAdjuntoContrato(MEJEditaAdjuntoDto dto) {
		AdjuntoContrato adjunto = genericDao.get(AdjuntoContrato.class,
				genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
		if (dto.getDescripcion().length() > 1000) {
			throw new BusinessOperationException(
					"plugin.mejoras.adjunto.descripcion.demasiadoLarga.mensaje");
		} else {
			adjunto.setDescripcion(dto.getDescripcion());
		}
		genericDao.save(AdjuntoContrato.class, adjunto);
	}

	/**
	 * 
	 * @param dto
	 *            de edición de adjuntos guarda lo la descripción en el adjunto
	 *            de la persona
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GUARDA_ADJUNTO_PERSONA)
	@Transactional(readOnly = false)
	public void guardaAdjuntoPersona(MEJEditaAdjuntoDto dto) {
		AdjuntoPersona adjunto = genericDao.get(AdjuntoPersona.class,
				genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
		if (dto.getDescripcion().length() > 1000) {
			throw new BusinessOperationException(
					"plugin.mejoras.adjunto.descripcion.demasiadoLarga.mensaje");
		} else {
			adjunto.setDescripcion(dto.getDescripcion());
		}
		genericDao.save(AdjuntoPersona.class, adjunto);
	}

	/**
	 * 
	 * @param dto
	 *            de edición de adjuntos de expedientes guarda lo la descripción
	 *            en el adjunto del expediente
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GUARDA_ADJUNTO_EXPEDIENTE)
	@Transactional(readOnly = false)
	public void guardaAdjuntoExpediente(MEJEditaAdjuntoDto dto) {
		AdjuntoExpediente adjunto = genericDao.get(AdjuntoExpediente.class,
				genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
		if (dto.getDescripcion().length() > 1000) {
			throw new BusinessOperationException(
					"plugin.mejoras.adjunto.descripcion.demasiadoLarga.mensaje");
		} else {
			adjunto.setDescripcion(dto.getDescripcion());
		}
		genericDao.save(AdjuntoExpediente.class, adjunto);
	}

	/**
	 * Graba una ficha de aceptación.
	 * 
	 * @param dto
	 *            trae los datos para la ficha
	 * @return el id del asunto.
	 */
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GUARDAR_FICHA_ACEPTACION)
	@Transactional(readOnly = false)
	public Long guardarFichaAceptacion(MEJFichaAceptacionDto dto) {
		Asunto asunto = asuntoDao.get(dto.getIdAsunto());
		asunto.getFichaAceptacion().setAceptacion(dto.getAceptacion());
		asunto.getFichaAceptacion().setConflicto(dto.getConflicto());
		asunto.getFichaAceptacion().setDocumentacionRecibida(
				dto.getDocumentacionRecibida());
		if (dto.getFechaRecepDoc() != null
				&& !dto.getFechaRecepDoc().equals("")) {
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				asunto.setFechaRecepDoc(sdf1.parse(dto.getFechaRecepDoc()));
			} catch (ParseException e) {
				throw new BusinessOperationException("error.parse.fecha");
			}
		} else {
			asunto.setFechaRecepDoc(null);
		}
		ObservacionAceptacion oba = new ObservacionAceptacion();
		oba.setDetalle(dto.getObservaciones());
		oba.setFecha(new Date());
		oba.setFichaAceptacion(asunto.getFichaAceptacion());
		oba
				.setUsuario((Usuario) executor
						.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO));

		fichaAceptacionDao.save(asunto.getFichaAceptacion());
		// Ejecutar la accion SIEMPRE SERA DEVOLVER PORQUE ESTAMOS EN EL PLUGIN
		// MEJORAS
		if (MEJFichaAceptacionDto.ACEPTAR.equals(dto.getAccion())) {
		} else if (MEJFichaAceptacionDto.DEVOLVER.equals(dto.getAccion())) {
			oba.setAccion(messageService
					.getMessage("asunto.fichaAceptacion.devolucion"));
			devolverAsunto(dto.getIdAsunto());
		} else if (MEJFichaAceptacionDto.ELEVAR_COMITE.equals(dto.getAccion())) {

		} else if (MEJFichaAceptacionDto.EDITAR.equals(dto.getAccion())) {

		}
		observacionAceptacionDao.save(oba);

		return asunto.getId();
	}

	/**
	 * Salva un Asunto.
	 * 
	 * @param asunto
	 *            el Asunto para salvar.
	 */
	public void saveOrUpdateAsunto(Asunto asunto) {
		asuntoDao.saveOrUpdate(asunto);
	}

	/**
	 * devolver un asunto.
	 * 
	 * @param idAsunto
	 *            id del asunto
	 */
	@Transactional(readOnly = false)
	public void devolverAsunto(Long idAsunto) {
		Asunto asunto = this.get(idAsunto);
		// Validar que soy el gestor o supervisor, sino lanzar exception
		Usuario usuarioLogado = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		Usuario usuarioGestor = asunto.getGestor().getUsuario();
		Usuario usuarioSupervisor = asunto.getSupervisor().getUsuario();
		if (!(usuarioLogado.equals(usuarioGestor) || usuarioLogado
				.equals(usuarioSupervisor))) {
			throw new BusinessOperationException(
					"asunto.devolucion.usuarioErroneo");
		}
		if (!puedoDevolverAsunto(idAsunto)) {
			throw new BusinessOperationException("asunto.devolucion.yaDevuelto");
		}
		// Validar que estoy en el estado Confirmado
		if (!DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO.equals(asunto
				.getEstadoAsunto().getCodigo())) {
			throw new BusinessOperationException(
					"asunto.aceptacion.estadoErroneo");
		}
		// cambiar el tipo de tarea para que cambie de usuario
		for (TareaNotificacion tarea : asunto.getTareas()) {
			if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR.equals(tarea
					.getSubtipoTarea().getCodigoSubtarea())) {
				SubtipoTarea subtipoTarea = (SubtipoTarea) executor
						.execute(
								ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
								SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR);
				tarea.setSubtipoTarea(subtipoTarea);
				tarea.setDescripcionTarea(tarea.getDescripcionTarea().replace(
						"Aceptación", "Devolución"));
				executor.execute(
						ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
						tarea);
			} else if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR
					.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
				SubtipoTarea subtipoTarea = (SubtipoTarea) executor
						.execute(
								ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
								SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR);
				tarea.setSubtipoTarea(subtipoTarea);
				tarea.setDescripcionTarea(tarea.getDescripcionTarea().replace(
						"Devolución", "Aceptación"));
				executor.execute(
						ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
						tarea);
			}
			// tarea.setDescripcionTarea("assdas");
		}
	}

	/**
	 * indica si puedo devolver el asunto.
	 * 
	 * @param idAsunto
	 *            id del asunto
	 * @return puedo o no
	 */
	public boolean puedoDevolverAsunto(Long idAsunto) {
		Asunto asunto = this.get(idAsunto);
		Usuario usuarioLogado = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		for (TareaNotificacion tarea : asunto.getTareas()) {
			SubtipoTarea subtipo = tarea.getSubtipoTarea();
			if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR.equals(subtipo
					.getCodigoSubtarea())) {
				if (usuarioLogado.equals(asunto.getGestor().getUsuario())) {
					return true;
				}
			}
			if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR.equals(subtipo
					.getCodigoSubtarea())) {
				if (usuarioLogado.equals(asunto.getSupervisor().getUsuario())) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * devuelve un asunto.
	 * 
	 * @param id
	 *            id
	 * @return asunto
	 */

	public Asunto get(Long id) {
		return asuntoDao.get(id);
	}


	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ASUNTO_CONSULTA_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsConsultaAsuntoLeft() {
		List<DynamicElement> lista = new ArrayList<DynamicElement>();
		List<DynamicElement> l = proxyFactory
				.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.asuntos.consultaAsunto.buttons.left",
						null);
		List<DynamicElement> l2 = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("asunto.buttons", null);
		if (!Checks.esNulo(l) && !Checks.estaVacio(l)) {
			lista.addAll(l);
		}
		if (!Checks.esNulo(l2) && !Checks.estaVacio(l2)) {
			lista.addAll(l2);
		}
		return lista;
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ASUNTO_CONSULTA_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsConsultaAsuntoRight() {
		List<DynamicElement> l = proxyFactory
				.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.asuntos.consultaAsunto.buttons.right",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ASUNTO_BUTTONS_LEFT_FAST)
	public List<DynamicElement> getButtonsAsuntoLeftFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("entidad.asunto.buttons.left.fast", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ASUNTO_BUTTONS_RIGHT_FAST)
	public List<DynamicElement> getButtonsAsuntoRightFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("entidad.asunto.buttons.right.fast", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_ASUNTO_TABS_FAST)
	public List<DynamicElement> getTabsFast() {
		return tabManager.getDynamicElements("tabs.asunto.fast", null);
	}
	
	//TODO - Falta terminar de implementar
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PUEDE_FINALIZAR_ASUNTO)
	public boolean puedoFinalizarAsunto(Long idAsunto) {
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		boolean tieneFuncionFinalizar = funcionManager.tieneFuncion(usuario, MEJDecisionProcedimientoManager.FUNCION_FINALIZAR_ASUNTOS);
		return tieneFuncionFinalizar;
	}

}

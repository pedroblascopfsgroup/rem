package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionCustomTemplate;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao.RecoveryAgendaMultifuncionContratosDao;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao.RecoveryAnotacionDaoApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.AnotacionAgendaDto;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionRespuestaTareaInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionUsuarioInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.AgendaMultifuncionCorreoUtils;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.ClasspathResourceUtil;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.EmailContentUtil;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;
import es.pfsgroup.recovery.ext.impl.tareas.EXTDtoGenerarTareaIdividualizadaImpl;

@Service
@Transactional(readOnly = true)
public class RecoveryAnotacionManager implements RecoveryAnotacionApi,
		AgendaMultifuncionCustomTemplate {

	private static final String SUBTIPO_ANOTACION_AUTOTAREA = "700";
	private static final String SUBTIPO_ANOTACION_TAREA = "700";
	private static final String SUBTIPO_ANOTACION_NOTIFICACION = "701";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RecoveryAnotacionDaoApi recoveryAnotacionDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	private Properties appProperties;

	@Resource(name = "mailManager")
	private MailManager mailManager;

	// FIXME Mover esta dependencia al emailContentUtil
	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private RecoveryAgendaMultifuncionContratosDao recoveryAgendaContratosDao;
	
	@Autowired
	private ClasspathResourceUtil classpathUtil;
	
	@Autowired
	private EmailContentUtil emailContentUtil;
	
	@Autowired
	private Executor executor;	
	
	@Autowired
	private AgendaMultifuncionCorreoUtils agendaMultifuncionCorreoUtils;

	@Override
	@BusinessOperation(AMF_GET_USUARIOS)
	public Collection<? extends Usuario> getUsuarios(String query) {
		return recoveryAnotacionDao.getGestores(query);
	}

	@Override
	@BusinessOperation(AMF_CREATE_ANOTACION)
	@Transactional(readOnly = false)
	//public void createAnotacion(DtoCrearAnotacionInfo dto) {
	public List<Long> createAnotacion(DtoCrearAnotacionInfo dto) {
		List<Long> listaTareas = new ArrayList<Long>();
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class)
				.getUsuarioLogado();

		// FIXME Refactorizar toda esta parte para obtener el nombre y ug. Utilizar una factorï¿½a o algo.
		String nombre = "";
		String ug = "";
		String codUg = dto.getCodUg();
		Long idUg = dto.getIdUg();
		
		if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equalsIgnoreCase(codUg)) {
			Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(
					dto.getIdUg());
			nombre = asunto.getNombre();
			ug = "Asunto";
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equalsIgnoreCase(codUg)) {
			Cliente cliente = genericDao.get(Cliente.class, genericDao
					.createFilter(FilterType.EQUALS, "persona.id",
							dto.getIdUg()), genericDao.createFilter(
					FilterType.EQUALS, "auditoria.borrado", false));
			if (cliente != null) {
				System.out.println("Existe cliente");
				nombre = cliente.getPersona().getApellidoNombre();
				ug = "Cliente";
				idUg = cliente.getId();
			} else {
				Persona persona = proxyFactory.proxy(PersonaApi.class).get(
						dto.getIdUg());
				nombre = persona.getApellidoNombre();
				ug = "Persona";
				codUg = "9";
			}

		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equalsIgnoreCase(codUg)) {
			Expediente expediente = null;
			expediente = proxyFactory.proxy(ExpedienteApi.class).getExpediente(
					dto.getIdUg());
			nombre = expediente.getDescripcion();
			ug = "Expediente";
		}

		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();

		boolean isComentario = true;

		for (DtoCrearAnotacionUsuarioInfo user : dto.getUsuarios()) {
			try {
				if (user.isIncorporar()) {
					isComentario = false;
					if (user.getFecha() != null) {
						if (user.getId().equals(usuarioLogado.getId())) {
							// autotarea: crear tarea y dejar traza
							Long idTarea = crearTarea(idUg, codUg,
									dto.getAsuntoMail(), usuarioLogado.getId(),
									false, SUBTIPO_ANOTACION_AUTOTAREA,
									user.getFecha());
							listaTareas.add(idTarea); // Metemos la tarea creada en la lista de tareas.
							dejarTraza(
									usuarioLogado.getId(),
									AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA,
									idUg,
									codUg,
									createInfoEventoTarea(idTarea,
											usuarioLogado.getId(), new Date(),
											user.getFecha(), user.getId(),
											dto.getAsuntoMail(),
											HtmlUtils.htmlUnescape(dto.getCuerpoEmail()),
											user.isEmail(),
											dto.getTipoAnotacion()));
						} else {
							// tarea: crear tarea para el destinatario y tarea
							// en espera para el creador y dejar traza
							Long idTarea = crearTarea(idUg, codUg,
									dto.getAsuntoMail(), user.getId(), true,
									SUBTIPO_ANOTACION_TAREA, user.getFecha());
							listaTareas.add(idTarea); // Metemos la tarea creada en la lista de tareas.
							// crearTarea(asunto.getId(), dto.getAsuntoMail(),
							// usuarioLogado.getId(), true,
							// SUBTIPO_ANOTACION_TAREA_EN_ESPERA,
							// user.getFecha());
							dejarTraza(
									usuarioLogado.getId(),
									AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA,
									idUg,
									codUg,
									createInfoEventoTarea(idTarea,
											usuarioLogado.getId(), new Date(),
											user.getFecha(), user.getId(),
											dto.getAsuntoMail(),
											HtmlUtils.htmlUnescape(dto.getCuerpoEmail()),
											user.isEmail(),
											dto.getTipoAnotacion()));
						}
					} else {
						// notificacion, se la modificaciï¿½n y se deja una
						// traza
						Long idTarea = crearTarea(idUg, codUg,
								dto.getAsuntoMail(), user.getId(), false,
								SUBTIPO_ANOTACION_NOTIFICACION, user.getFecha());
						listaTareas.add(idTarea); // Metemos la tarea creada en la lista de tareas.
						dejarTraza(
								usuarioLogado.getId(),
								AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_NOTIFICACION,
								idUg,
								codUg,
								createInfoEventoNotificacion(idTarea,
										usuarioLogado.getId(), new Date(),
										user.getId(), dto.getAsuntoMail(),
										HtmlUtils.htmlUnescape(dto.getCuerpoEmail()), user.isEmail(),
										dto.getTipoAnotacion()));
					}
				}
			} catch (EXTCrearTareaException e) {
				logger.error("Error creando tarea",e);
				throw new FrameworkException("Error creando la tarea");
			}

			if (user.isEmail()) {
				mailsPara.add(getMailUsuario(user.getId()));
			}

		}
		if (isComentario) {
			// comentario, se creta una traza de tipo comentario
			dejarTraza(
					usuarioLogado.getId(),
					AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_COMENTARIO,
					idUg,
					codUg,
					createInfoEventoComentario(usuarioLogado.getId(),
							new Date(), dto.getAsuntoMail(),
							HtmlUtils.htmlUnescape(dto.getCuerpoEmail()), dto.getTipoAnotacion()));
		}

		mailsPara.addAll(dto.getDireccionesMailPara());
		mailsCC.addAll(dto.getDireccionesMailCc());

		if (mailsPara.size() > 0) {
			try {
				Usuario usuarioLogueado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
				String textoFrom =  usuarioLogueado.getApellidoNombre();
				
				//AÃ±adimos SOLO en el asunto del email, el nombre del asunto
				Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dto.getIdUg());
				String asuntoMail = dto.getAsuntoMail();
				if(!Checks.esNulo(asu)) {
					asuntoMail = asu.getNombre() + " - " + asuntoMail;
				}
					
				String cuerpoEmail = processCuerpoEmail( textoFrom, StringUtils.collectionToCommaDelimitedString(mailsPara),
						 StringUtils.collectionToCommaDelimitedString(mailsCC), dto.getAsuntoMail(), ug, nombre, HtmlUtils.htmlUnescape(dto.getCuerpoEmail()),
						dto);
				
				agendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos( null, mailsPara, mailsCC,
						asuntoMail, cuerpoEmail, dto.getAdjuntosList());
				
				/*DIANA: Nuevo mï¿½todo para aï¿½adir adjuntos al email
				enviarMailConAdjuntos(mailsPara, mailManager.getUsername(), dto.getDireccionesMailCc(),
						asuntoMail, cuerpoEmail, dto.getAdjuntosList());*/
				
				dejarTraza(
						usuarioLogado.getId(),
						MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS,
						idUg,
						codUg,
						createInfoEventoMailConAdjunto(
								dto.getAsuntoMail(),
								mailManager.getUsername(),
								StringUtils
										.collectionToCommaDelimitedString(mailsPara),
								StringUtils
										.collectionToCommaDelimitedString(mailsCC),
										HtmlUtils.htmlUnescape(cuerpoEmail),
								dto.getAdjuntosList()));
			} catch (Exception e) {
				logger.error("Error enviando los mails de una nueva anotacion",e);
				throw new FrameworkException(
						"Error enviando los mails de una nueva anotaciï¿½n");
			}
		}

		return listaTareas;
	}


	@Override
	@BusinessOperation(AMF_CREATE_RESPUESTA)
	@Transactional(readOnly = false)
	public void createRespuesta(DtoCrearAnotacionRespuestaTareaInfo dto) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class)
				.getUsuarioLogado();

		try {
			Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class)
					.getUsuarioLogado();

			if (!dto.getIdUsuarioEmisor().equals(usuLogado.getId())) {
				Long idTareaRespuesta = crearTareaRespuesta(dto.getIdUg(),
						dto.getCodUg(), dto.getRespuesta(),
						dto.getIdUsuarioEmisor(),
						SUBTIPO_ANOTACION_NOTIFICACION, new Date());
				dejarTraza(
						usuarioLogado.getId(),
						AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA,
						dto.getIdUg(),
						dto.getCodUg(),
						createInfoEventoRespuesta(dto.getIdTarea(), new Date(),
								dto.getRespuesta(), idTareaRespuesta));
			} else {
				dejarTraza(
						usuarioLogado.getId(),
						AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA,
						dto.getIdUg(),
						dto.getCodUg(),
						createInfoEventoRespuesta(dto.getIdTarea(), new Date(),
								dto.getRespuesta(), null));
			}
		} catch (Exception e) {
			logger.error("error creando respuesta",e);
		}

	}

	private Map<String, Object> createInfoEventoRespuesta(Long idTarea,
			Date fechaRespuesta, String respuesta, Long idTareaRespuesta) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA,
				idTareaRespuesta);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA_ORIGINAL,
				idTarea);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.FECHA_RESPUESTA,
				fechaRespuesta);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.RESPUESTA_TAREA,
				respuesta);

		return info;
	}

	/*
	 * Este mï¿½todo es protected para poder hacer un spy durante el testeo
	 */
	protected void enviarMailConAdjuntos(List<String> mailsPara,
			String emailFrom, List<String> direccionesMailCc,
			String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) throws javax.mail.MessagingException  {
		MimeMessageHelper helper = mailManager.createMimeMessageHelper(!Checks.esNulo(list) && !Checks.estaVacio(list));
		helper.setFrom(emailFrom);
		helper.setTo(mailsPara.toArray(new String[mailsPara.size()]));
		if (direccionesMailCc != null && direccionesMailCc.size() > 0) {
			helper.setCc(direccionesMailCc.toArray(new String[direccionesMailCc.size()]));
		}
		helper.setSubject(asuntoMail);
		helper.setText(cuerpoEmail, true);
		// diana : aï¿½adimos aquï¿½ los adjuntos
		if(!Checks.esNulo(list) && !Checks.estaVacio(list)){
			for(DtoAdjuntoMail adj : list){
				helper.addAttachment(adj.getNombre(), adj.getAdjunto().getFileItem().getFile());
			}
		}
		mailManager.send(helper);
		
	}

	private String getMailUsuario(Long idUsuario) {
		Usuario u = proxyFactory.proxy(UsuarioApi.class).get(idUsuario);
		return u.getEmail();
	}

	private void dejarTraza(final long idUsuario, final String tipoEvento,
			final long idUg, final String codUg,
			final Map<String, Object> infoEvento) {
		MEJTrazaDto evento = new MEJTrazaDto() {

			@Override
			public long getUsuario() {
				return idUsuario;
			}

			@Override
			public String getTipoUnidadGestion() {
				return codUg;
			}

			@Override
			public String getTipoEvento() {
				return tipoEvento;
			}

			@Override
			public Map<String, Object> getInformacionAdicional() {
				return infoEvento;
			}

			@Override
			public long getIdUnidadGestion() {
				return idUg;
			}
		};
		proxyFactory.proxy(MEJRegistroApi.class).guardatTrazaEvento(evento);
	}
	

	private Map<String, Object> createInfoEventoTarea(Long idTarea,
			Long emisor, Date fecha_creacion, Date fecha_vencimiento,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.ID_TAREA,
				idTarea);
		info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.EMISOR_TAREA,
				emisor);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_CREACION_TAREA,
				fecha_creacion);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_VENCIMIENTO_TAREA,
				fecha_vencimiento);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA,
				destinatario);
		info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.ASUNTO_TAREA,
				asunto);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA,
				descripcion);
		if (mail) {
			info.put(
					AgendaMultifuncionTipoEventoRegistro.EventoTarea.FLAG_MAIL,
					1);
		}
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION,
				tipoAnotacion);
		return info;
	}

	private Map<String, Object> createInfoEventoNotificacion(
			Long idnotificacion, Long emisor, Date fecha_creacion,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.ID_NOTIFICACION,
				idnotificacion);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.EMISOR_NOTIFICACION,
				emisor);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FECHA_CREACION_NOTIFICACION,
				fecha_creacion);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESTINATARIO_NOTIFICACION,
				destinatario);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.ASUNTO_NOTIFICACION,
				asunto);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESCRIPCION_NOTIFICACION,
				descripcion);
		if (mail) {
			info.put(
					AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FLAG_MAIL,
					1);
		}
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.TIPO_ANOTACION,
				tipoAnotacion);
		return info;
	}

	private Map<String, Object> createInfoEventoComentario(Long emisor,
			Date fecha_creacion, String asunto, String descripcion,
			String tipoAnotacion) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoComentario.EMISOR_COMENTARIO,
				emisor);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoComentario.FECHA_CREACION_COMENTARIO,
				fecha_creacion);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoComentario.ASUNTO_COMENTARIO,
				asunto);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoComentario.DESCRIPCION_COMENTARIO,
				descripcion);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoComentario.TIPO_ANOTACION,
				tipoAnotacion);
		return info;
	}

	
	private Map<String, Object> createInfoEventoMailConAdjunto(
			String asunto, String from,
			String destino,
			String cc, String cuerpo,
			List<DtoAdjuntoMail> adjuntosList) {
		HashMap<String, Object> info = new HashMap<String, Object>();

		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_ORIGEN, from);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_ASUNTO, asunto);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_DESTINO, destino);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_CC, cc);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_CUERPO, cuerpo);
		if(!Checks.esNulo(adjuntosList) && !Checks.estaVacio(adjuntosList)){
			String adjuntos="";
			for (DtoAdjuntoMail adjunto : adjuntosList){
				if ("".equals(adjuntos)){ adjuntos = adjuntos + adjunto.getAdjunto().getId();}
				else { adjuntos=adjuntos+","+adjunto.getAdjunto().getId();}
			}
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_ADJUNTOS,adjuntos );
		}

		return info;
	}

	private String processCuerpoEmail(String origen, String destino, String destinoCC,
			String asunto, String tipoUnidadGestion,
			String nombreUnidadGestion, String cuerpoOld,
			DtoCrearAnotacionInfo dto) {

		Map<String, String> model = new HashMap<String, String>();

		model.put("origen", origen);
		model.put("destino", destino);
		model.put("destinoCC", destinoCC);
		model.put("asunto", asunto);
		model.put("tipoUnidadGestion", tipoUnidadGestion);
		model.put("nombreUnidadGestion", nombreUnidadGestion);
		model.put("cuerpo", cuerpoOld);

		Map<String, String> customize = proxyFactory.proxy(AgendaMultifuncionCustomTemplate.class).getCustomize(dto);
		String customizeTempate = "template/mailTemplate.html";

		if (customize != null) {
			model.putAll(customize);
			//FIXME ï¿½Cï¿½mo sabemos que el mapa debe tener esa propiedad?, buscar un modo mejor de hacer esto.
			customizeTempate = customize.get(AgendaMultifuncionCustomTemplate.LOCATION_TEMPLATE_KEY);
		}

		InputStream in = classpathUtil.getResourceAsStream(customizeTempate);
		// indicadora de quien es el cliente?
		if (Checks.esNulo(in)) {
			throw new BusinessOperationException(customizeTempate + ": no se encuentra el recurso");
		}
		
		try {
			if(in != null)in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return this.emailContentUtil.createContenntWithVelocity(this.velocityEngine,
				customizeTempate, model);
	}

	/*
	 * Este mï¿½todo se pone como protected para poder hacer un spy sobre el durante el testeo
	 */
	protected Long crearTarea(Long idUg, String codUg, String asuntoMail,
			Long idUsuarioDestinatarioTarea, boolean enEspera,
			String codigoSubtarea, Date fechaVencimiento)
			throws EXTCrearTareaException {

		EXTDtoGenerarTareaIdividualizadaImpl tareaIndDto = new EXTDtoGenerarTareaIdividualizadaImpl();
		DtoGenerarTarea tareaDto = new DtoGenerarTarea();

		tareaDto.setSubtipoTarea(codigoSubtarea);
		tareaDto.setEnEspera(enEspera);
		tareaDto.setFecha(fechaVencimiento);
		tareaDto.setDescripcion(asuntoMail);
		tareaDto.setIdEntidad(idUg);
		tareaDto.setCodigoTipoEntidad(codUg);
		tareaIndDto.setTarea(tareaDto);
		tareaIndDto.setDestinatario(idUsuarioDestinatarioTarea);
		return proxyFactory.proxy(EXTTareasApi.class)
				.crearTareaNotificacionIndividualizada(tareaIndDto);

	}

	
	private Long crearTareaRespuesta(Long idUg, String codUg, String respuesta,
			Long idUsuarioDestinatarioTarea, String codigoSubtarea,
			Date fechaVencimiento) throws EXTCrearTareaException {

		EXTDtoGenerarTareaIdividualizadaImpl tareaIndDto = new EXTDtoGenerarTareaIdividualizadaImpl();
		DtoGenerarTarea tareaDto = new DtoGenerarTarea();
		tareaDto.setSubtipoTarea(codigoSubtarea);
		tareaDto.setEnEspera(false);
		tareaDto.setFecha(fechaVencimiento);
		tareaDto.setDescripcion(respuesta);
		tareaDto.setCodigoTipoEntidad(codUg);
		tareaDto.setIdEntidad(idUg);
		tareaIndDto.setTarea(tareaDto);
		tareaIndDto.setTarea(tareaDto);
		tareaIndDto.setDestinatario(idUsuarioDestinatarioTarea);
		return proxyFactory.proxy(EXTTareasApi.class)
				.crearTareaNotificacionIndividualizada(tareaIndDto);

	}

	@Override
	@BusinessOperation(AMF_GET_TIPOS_ANOTACIONES)
	public List<DDTipoAnotacion> getListaTiposAnotacion() {
		
		return genericDao.getList(DDTipoAnotacion.class, genericDao
				.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
	}

	@Override
	@BusinessOperation(AMF_GET_ANOTACIONES_AGENDA)
	public List<AnotacionAgendaDto> getAnotacionesAgenda(
			String tipoUnidadGestion, Long idUnidadGestion,
			String[] tipoAnotacion) {

		List<? extends MEJRegistroInfo> trazas = getTrazasRegistroUnidadGestion(
				tipoUnidadGestion, idUnidadGestion, tipoAnotacion);

		if (!Checks.estaVacio(trazas)) {
			ArrayList<AnotacionAgendaDto> anotaciones = new ArrayList<AnotacionAgendaDto>();

			for (MEJRegistroInfo traza : trazas) {
				EXTTareaNotificacion tarea = getTareaAsociadaTraza(traza);
				anotaciones.add(new AnotacionAgendaDto(tarea, traza));
			}

			return anotaciones;

		}
		return null;
	}

	private EXTTareaNotificacion getTareaAsociadaTraza(MEJRegistroInfo traza) {
		if ((traza == null) || (traza.getTipo() == null)) {
			return null;
		}
		if (AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_NOTIFICACION
				.equals(traza.getTipo().getCodigo())) {
			return obtenTarea(
					traza.getInfoRegistro(),
					AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.ID_NOTIFICACION);
		} else if (AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA
				.equals(traza.getTipo().getCodigo())) {
			return obtenTarea(traza.getInfoRegistro(),
					AgendaMultifuncionTipoEventoRegistro.EventoTarea.ID_TAREA);
		} else {
			return null;
		}
	}

	private EXTTareaNotificacion obtenTarea(
			List<? extends ClaveValor> infoRegistro, String tipo) {
		if (Checks.estaVacio(infoRegistro) || Checks.esNulo(tipo)) {
			return null;
		}
		for (ClaveValor cv : infoRegistro) {
			Long idTarea = null;
			if (tipo.equals(cv.getClave())) {
				try {
					idTarea = Long.parseLong(cv.getValor().toString());
					return (EXTTareaNotificacion) proxyFactory.proxy(
							TareaNotificacionApi.class).get(idTarea);
				} catch (NumberFormatException e) {
					logger.error("Id de tarea invï¿½lido en traza de anotaciï¿½n "
							+ cv.getClave());
					return null;
				} catch (ClassCastException cce) {
					logger.error("La tarea " + idTarea
							+ " no es de tipo EXTTareaNotificacion");
					return null;
				}
			}
		}
		return null;
	}

	private List<? extends MEJRegistroInfo> getTrazasRegistroUnidadGestion(
			String tipoUnidadGestion, Long idUnidadGestion,
			String[] tipoAnotacion) {
		List<? extends MEJRegistroInfo> trazas;

		if (tipoAnotacion == null) {
			MEJTrazaDto dto = creaPeticionBusquedaTraza(tipoUnidadGestion,
					idUnidadGestion, null);
			trazas = proxyFactory.proxy(MEJRegistroApi.class)
					.buscaTrazasEvento(dto);
		} else {
			trazas = new ArrayList<MEJRegistroInfo>();
			for (String tipo : tipoAnotacion) {
				MEJTrazaDto dto = creaPeticionBusquedaTraza(tipoUnidadGestion,
						idUnidadGestion, tipo);
				List aux = proxyFactory.proxy(MEJRegistroApi.class)
						.buscaTrazasEvento(dto);
				if (!Checks.estaVacio(aux)) {
					trazas.addAll(aux);
				}
			}
		}
		return trazas;
	}

	@Override
	@BusinessOperation(AMF_GET_TIPO_ANOTACION_BY_CODIGO)
	public DDTipoAnotacion getTipoAnotacionByCodigo(String codigo) {
		if (Checks.esNulo(codigo)) {
			return null;
		}
		return genericDao.get(DDTipoAnotacion.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", codigo));
	}

	public void setGenericDao(GenericABMDao genericDao) {
		this.genericDao = genericDao;
	}

	public GenericABMDao getGenericDao() {
		return genericDao;
	}

	
	@Override
	@BusinessOperation(AGENDA_MULTIFUNCION_GET_CUSTOMIZE)
	public Map<String, String> getCustomize(DtoCrearAnotacionInfo dto) {

		return null;
	}

	private MEJTrazaDto creaPeticionBusquedaTraza(
			final String tipoUnidadGestion, final Long idUnidadGestion,
			final String tipoEvento) {
		MEJTrazaDto dto = new MEJTrazaDto() {

			@Override
			public long getUsuario() {
				return 0;
			}

			@Override
			public String getTipoUnidadGestion() {
				return tipoUnidadGestion;
			}

			@Override
			public String getTipoEvento() {
				return tipoEvento;
			}

			@Override
			public Map<String, Object> getInformacionAdicional() {
				return null;
			}

			@Override
			public long getIdUnidadGestion() {
				return idUnidadGestion;
			}
		};
		return dto;
	}

	
	@BusinessOperation(AMF_GET_CODIGO_LITIGIO)
	public String getCodigoLitigioAsu(Long id) {
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
		List<Contrato> contratos = new ArrayList<Contrato>();
		contratos.addAll(asunto.getContratos());

		for (final Contrato c : contratos) {
			String cccLitigio = recoveryAgendaContratosDao.getCccLitigio(c.getId());
			if (cccLitigio != null) {
				return cccLitigio;
			}
		}
		return null;
	}
	
	@BusinessOperation(CONF_VENTANA_ANOTACIONES)
	public Boolean getConfiVentanaAnotaciones(){
		
		String parametroCreacionTareaUnicaAnotacion= Parametrizacion.CREACION_TAREA_UNICA_ANOTACION;
        
        try {
		    Parametrizacion param = (Parametrizacion) executor.execute(
		            ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, parametroCreacionTareaUnicaAnotacion);
		    return Boolean.valueOf(param.getValor());
		} catch (Exception e) {
		    logger.warn("No esta parametrizado el la configuración de la ventana Crear Anotación, se toma un valor por defecto 'false'");
		    return false;
		}
		
	}

}

package es.pfsgroup.plugin.rem.notificacion;

import java.io.IOException;
import java.io.InputStream;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.dao.EXTTareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionCustomTemplate;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionUsuarioInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacionUsuario;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.ClasspathResourceUtil;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.EmailContentUtil;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJRegistro;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.notificacion.api.RegistroApi;
import es.pfsgroup.plugin.rem.notificacion.dto.CrearAnotacionDto;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionDto;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;
import es.pfsgroup.recovery.ext.impl.tareas.EXTDtoGenerarTareaIdividualizadaImpl;

@Service("Anotacion")
@Transactional(readOnly = false)
public class AnotacionManager implements AnotacionApi{
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private EXTTareaNotificacionDao tareaDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private RegistroApi registroApi;
	
	@Autowired
	private RestApi restApi;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private ClasspathResourceUtil classpathUtil;
	
	@Resource(name = "mailManager")
	private MailManager mailManager;
	
	@Autowired
	private EmailContentUtil emailContentUtil;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	// FIXME Mover esta dependencia al emailContentUtil
	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;
	
	private final Log logger = LogFactory.getLog(getClass());

	
	
	@Override
	@BusinessOperation(PLUGIN_REM_ANOTACION_SAVE_ANNOTATION)
	@Transactional(readOnly = false)
	public Notificacion saveNotificacion(Notificacion notificacion) throws ParseException
	{
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;
		
		if(!Checks.esNulo(notificacion.getStrFecha()))
			fecha = formato.parse(notificacion.getStrFecha());
		else{
			if(!Checks.esNulo(notificacion.getFecha()))
				fecha = notificacion.getFecha();
		}
		
		CrearAnotacionDto serviceDto = new CrearAnotacionDto();
		List<DtoCrearAnotacionUsuario> listaUsuarios = new ArrayList<DtoCrearAnotacionUsuario>();
		DtoCrearAnotacionUsuario du = new DtoCrearAnotacionUsuario();
		du.setId(notificacion.getDestinatario());
		du.setFecha(fecha);
		du.setIncorporar(true);
		listaUsuarios.add(du);
		serviceDto.setUsuarios(listaUsuarios);
		
		serviceDto.setTipoAnotacion("A");
		serviceDto.setCuerpoEmail(notificacion.getDescripcion());
		serviceDto.setAsuntoMail(notificacion.getTitulo());
		
		List<String> listaDireccionesCc = new ArrayList<String>();
        if (StringUtils.hasText(notificacion.getCc())) {
            String direcciones[] = notificacion.getCc().replace(" ", "").split(",");
            if (direcciones.length > 1) {
                listaDireccionesCc.addAll(Arrays.asList(direcciones));
            } else {
                listaDireccionesCc.add(notificacion.getCc());
            }
        }
        serviceDto.setDireccionesMailCc(listaDireccionesCc);

        List<String> listaDireccionesPara = new ArrayList<String>();
        if (StringUtils.hasText(notificacion.getPara())) {
            String direcciones[] = notificacion.getPara().replace(" ", "").split(",");
            if (direcciones.length > 1) {
                listaDireccionesPara.addAll(Arrays.asList(direcciones));
            } else {
                listaDireccionesPara.add(notificacion.getPara());
            }
        }
        serviceDto.setDireccionesMailPara(listaDireccionesPara);

		serviceDto.setIdUg(notificacion.getIdActivo());
		serviceDto.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_ACTIVO);
		serviceDto.setIdTareaAppExterna(notificacion.getIdTareaAppExterna());
		
		List<Long> idsTareaNotificacion = createAnotacion(serviceDto);
		
		notificacion.setIdsNotificacionCreada(idsTareaNotificacion);
		
		return notificacion;
	}
	
	
	@Override
	@BusinessOperation(PLUGIN_REM_ANOTACION_CREATE_ANOTATION)
	@Transactional(readOnly = false)
	public List<Long> createAnotacion(CrearAnotacionDto dto) {
		List<Long> listaTareas = new ArrayList<Long>();
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		// FIXME Refactorizar toda esta parte para obtener el nombre y ug. Utilizar una factoría o algo.
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
		
		Long idTarea = null;
		
		for (DtoCrearAnotacionUsuarioInfo user : dto.getUsuarios()) {
			try {
				if (user.isIncorporar()) {
					isComentario = false;
					if (user.getFecha() != null) {
						if (user.getId().equals(usuarioLogado.getId())) {
							// autotarea: crear tarea y dejar traza
							idTarea = crearTarea(idUg, codUg,
									dto.getAsuntoMail(), usuarioLogado.getId(),
									false, SUBTIPO_ANOTACION_AUTOTAREA,
									user.getFecha());
							listaTareas.add(idTarea); // Metemos la tarea creada en la lista de tareas.
							registroApi.dejarTraza(usuarioLogado.getId(), 
									AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA,
									idUg, 
									codUg,
									registroApi.createInfoEventoTarea(idTarea, 
											usuarioLogado.getId(),
											new Date(), 
											user.getFecha(), 
											user.getId(),
											dto.getAsuntoMail(),
											HtmlUtils.htmlUnescape(dto.getCuerpoEmail()),
											user.isEmail(),
											dto.getTipoAnotacion(),
											dto.getDireccionesMailPara(), 
											dto.getDireccionesMailCc(),
											dto.getAdjuntoCrear(),
											dto.getAdjuntoResp(),
											dto.getIdTareaAppExterna()
									),
									null);

						} else {
							// tarea: crear tarea para el destinatario y tarea
							// en espera para el creador y dejar traza
							idTarea = crearTarea(idUg, codUg,
									dto.getAsuntoMail(), user.getId(), true,
									SUBTIPO_ANOTACION_TAREA, user.getFecha());
							listaTareas.add(idTarea); // Metemos la tarea creada en la lista de tareas.
							registroApi.dejarTraza(
									usuarioLogado.getId(),
									AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA,
									idUg,
									codUg,
									registroApi.createInfoEventoTarea(idTarea,
											usuarioLogado.getId(), new Date(),
											user.getFecha(), user.getId(),
											dto.getAsuntoMail(),
											HtmlUtils.htmlUnescape(dto.getCuerpoEmail()),
											user.isEmail(),
											dto.getTipoAnotacion(),
											dto.getDireccionesMailPara(), 
											dto.getDireccionesMailCc(),
											dto.getAdjuntoCrear(),
											dto.getAdjuntoResp(),
											dto.getIdTareaAppExterna()
									),
									null
							);
						}
					} else {
						// notificacion, se la modificación y se deja una traza					
						idTarea = crearTarea(idUg, codUg,
								dto.getAsuntoMail(), user.getId(), false,
								SUBTIPO_ANOTACION_NOTIFICACION, user.getFecha());
						listaTareas.add(idTarea); // Metemos la tarea creada en la lista de tareas.
						registroApi.dejarTraza(
								usuarioLogado.getId(),
								AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_NOTIFICACION,
								idUg,
								codUg,
								registroApi.createInfoEventoNotificacion(idTarea,
										usuarioLogado.getId(), new Date(),
										user.getId(), dto.getAsuntoMail(),
										HtmlUtils.htmlUnescape(dto.getCuerpoEmail()), user.isEmail(),
										dto.getTipoAnotacion(),
										dto.getDireccionesMailPara(), 
										dto.getDireccionesMailCc(),
										dto.getAdjuntoCrear(),
										dto.getAdjuntoResp(),
										dto.getIdTareaAppExterna()
								),
								null
						);
					}					
					
				}
			} catch (EXTCrearTareaException e) {
				logger.error("Error creando tarea");
				e.printStackTrace();
				throw new FrameworkException("Error creando la tarea");
			}

			//Envío de mails cuando se marca el check del email del listado de usuarios
			if (user.isEmail()) {
				List<String> mailpara = new ArrayList<String>();
				Usuario u = proxyFactory.proxy(UsuarioApi.class).get(user.getId());
				mailpara.add(u.getEmail());
				enviarMail(dto, ug, nombre, mailpara, null, codUg, idUg, user.getFecha());				
			}

		}
		
		
		
		if (isComentario) {
			// comentario, se creta una traza de tipo comentario
			registroApi.dejarTraza(
					usuarioLogado.getId(),
					AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_COMENTARIO,
					idUg,
					codUg,
					registroApi.createInfoEventoComentario(usuarioLogado.getId(),
							new Date(), dto.getAsuntoMail(),
							HtmlUtils.htmlUnescape(dto.getCuerpoEmail()), dto.getTipoAnotacion(),
							dto.getIdTareaAppExterna()
					),
					null
			);
		}

		//Envío de mails cuando se pone una dirección para y en cc
		mailsPara.addAll(dto.getDireccionesMailPara());
		mailsCC.addAll(dto.getDireccionesMailCc());
		if (mailsPara.size() > 0) {		
			enviarMail(dto, ug, nombre, mailsPara, mailsCC, codUg, idUg, dto.getFechaTodas());
		}
		
		return listaTareas;

	}
	
	
	
	
	private void enviarMail(CrearAnotacionDto dto, String ug, String nombre, 
			List<String> mailsPara, List<String> mailsCC, String codUg, Long idUg, Date fechaVenc) {
		try {
			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			String emailFrom = obtenerDireccionEmailUsuarioLogado();
			String userName = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getApellidoNombre();
			dto.setUserNameSender(userName);
			
			String cuerpoEmail = processCuerpoEmail(
					emailFrom, 
					StringUtils.collectionToCommaDelimitedString(mailsPara),
					dto.getAsuntoMail(), ug, nombre, HtmlUtils.htmlUnescape(dto.getCuerpoEmail()),
					dto,fechaVenc);
			// DIANA: Nuevo método para añadir adjuntos al email
			enviarMailConAdjuntos(mailsPara, emailFrom, dto.getDireccionesMailCc(),dto.getAsuntoMail(), cuerpoEmail, dto.getAdjuntosList());
			registroApi.dejarTraza(
					usuarioLogado.getId(),
					MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS,
					idUg,
					codUg,
					registroApi.createInfoEventoMailConAdjunto(
							dto.getAsuntoMail(),
							emailFrom,
							StringUtils.collectionToCommaDelimitedString(mailsPara),
							StringUtils.collectionToCommaDelimitedString(mailsCC),
							HtmlUtils.htmlUnescape(cuerpoEmail),
							dto.getAdjuntosList()
					),
					null
			);
		} catch (Exception e) {
			logger.error("Error enviando los mails de una nueva anotación");
			e.printStackTrace();
			throw new FrameworkException(
					"Error enviando los mails de una nueva anotación");
		}
	}
	
	
	
	private String processCuerpoEmail(String mailOrigen, String mailDestino,
			String asunto, String tipoUnidadGestion,
			String nombreUnidadGestion, String cuerpo,
			CrearAnotacionDto dto, Date fechaVenc) throws ParseException {

		Map<String, String> model = new HashMap<String, String>();
		
		if(!Checks.esNulo(dto.getTipoAnotacion())){
			DDTipoAnotacion tipoAnot =proxyFactory.proxy(RecoveryAnotacionApi.class).getTipoAnotacionByCodigo(dto.getTipoAnotacion());
			if(!Checks.esNulo(tipoAnot)){
				model.put("subtipo", tipoAnot.getDescripcion());
			}else{
				model.put("subtipo", "");
			}
		}
		if(!Checks.esNulo(dto.getUserNameSender())){
			model.put("userNameSender", dto.getUserNameSender());
		}
		if(!Checks.esNulo(mailOrigen)){
			model.put("mailOrigen", mailOrigen);
		}
		if(!Checks.esNulo(mailDestino)){
			model.put("mailDestino", mailDestino);
		}
		if(!Checks.esNulo(asunto)){
			model.put("asunto", asunto);
		}
		if(!Checks.esNulo(nombreUnidadGestion)){
			model.put("nombreUnidadGestion", nombreUnidadGestion);
		}		
		if(!Checks.esNulo(cuerpo)){
			model.put("cuerpo", cuerpo);
		}
		if(!Checks.esNulo(tipoUnidadGestion)){
			model.put("tipoUnidadGestion", tipoUnidadGestion);
		}
		if(!Checks.esNulo(fechaVenc)){
			Format formatter = new SimpleDateFormat("dd/MM/yyyy");
    		String fecha = formatter.format(fechaVenc);
			model.put("textoFechaVenc", "Con fecha de vencimiento " + fecha + "<br/><br/>");
		}else{
			model.put("textoFechaVenc", "");
		}
		if(!Checks.esNulo(dto.getAdjuntosList()) && dto.getAdjuntosList().size()>0){
			model.put("textoAdjuntos", "Se acompañan los archivos adjuntos necesarios para su revisión.<br/><br/>");
		}else{
			model.put("textoAdjuntos", "");
		}
		
		Map<String, String> customize = proxyFactory.proxy(AgendaMultifuncionCustomTemplate.class).getCustomize(dto);
		String customizeTempate = "template/mailTemplate.html";

		if (customize != null) {
			model.putAll(customize);
			//FIXME ¿Cómo sabemos que el mapa debe tener esa propiedad?, buscar un modo mejor de hacer esto.
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


	private String obtenerDireccionEmailUsuarioLogado() {
		String email = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado()
				.getEmail();
		if (email == null || email.length() == 0) {
			email = appProperties.getProperty("agendaMultifuncion.mail.from");
		}
		return email;
	}
	
	
	/*
	 * Este método es protected para poder hacer un spy durante el testeo
	 */
	protected void enviarMailConAdjuntos(List<String> mailsPara,
			String emailFrom, List<String> direccionesMailCc,
			String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) throws javax.mail.MessagingException  {
		MimeMessageHelper helper = mailManager.createMimeMessageHelper(!Checks.esNulo(list) && !Checks.estaVacio(list));
		helper.setFrom(emailFrom);
		helper.setTo(mailsPara.toArray(new String[mailsPara.size()]));
		if (direccionesMailCc != null && direccionesMailCc.size() > 0) {
			helper.setCc(mailsPara.toArray(new String[direccionesMailCc.size()]));
		}
		helper.setSubject(asuntoMail);
		helper.setText(cuerpoEmail, true);
		// diana : añadimos aquí los adjuntos
		if(!Checks.esNulo(list) && !Checks.estaVacio(list)){
			for(DtoAdjuntoMail adj : list){
				helper.addAttachment(adj.getNombre(), adj.getAdjunto().getFileItem().getFile());
			}
		}
		mailManager.send(helper);
		
	}
	
	
	
	
	
	@Override
	@BusinessOperation(PLUGIN_REM_ANOTACION_CAMBIAR_DESTINATARIO_TAREA)
	public void cambiarDestinatarioTarea(Long idTarea, Long idUsuario, Long idTraza)  throws BusinessOperationException {
		
		if( Checks.esNulo(idUsuario) || Checks.esNulo(idTarea)){
			throw new BusinessOperationException("La información enviada no incluye identificador tarea y/o nuevo responsable.");
    	}else{
    		//Actualizar nuevo usuario destino
    		Filter filtroIdTarea=genericDao.createFilter(FilterType.EQUALS, "id", idTarea);
    		EXTTareaNotificacion tarea = genericDao.get(EXTTareaNotificacion.class, filtroIdTarea);	
    		
    		Filter filtroIdUsuario=genericDao.createFilter(FilterType.EQUALS, "id", idUsuario);
    		Usuario usuario = genericDao.get(Usuario.class, filtroIdUsuario);	
    		
    		tarea.setDestinatarioTarea(usuario);
    		tareaDao.saveOrUpdate(tarea);
    		
    		//Cambiarlo también en el REGISTRO
    		MEJRegistro registro = (MEJRegistro) proxyFactory.proxy(MEJRegistroApi.class).get(idTraza);
    		for (ClaveValor cv : registro.getInfoRegistro()){
    			if (cv.getClave().equals(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA)) {
    				MEJInfoRegistro cvInfo = (MEJInfoRegistro)cv;
    				Filter filtroIdRegistro=genericDao.createFilter(FilterType.EQUALS, "id", cvInfo.getId());
    				MEJInfoRegistro registroInfo = genericDao.get(MEJInfoRegistro.class, filtroIdRegistro);
    				registroInfo.setValor(usuario.getId().toString());
    				genericDao.save(MEJInfoRegistro.class, registroInfo);
    			}
    		}
    		
    	}
	}

	@Override
	@BusinessOperation(PLUGIN_REM_ANOTACION_CAMBIAR_FECHA_TAREA)
	public void cambiarFechaTarea(Long idTarea, String nuevaFecha, Long idTraza)  throws BusinessOperationException {
		
		if( Checks.esNulo(nuevaFecha) || Checks.esNulo(idTarea)){
			throw new BusinessOperationException("La información enviada no incluye identificador tarea y/o nueva fecha.");
    	}else{
    		//Actualizar nueva fecha de vencimiento real
    		Filter filtroIdTarea=genericDao.createFilter(FilterType.EQUALS, "id", idTarea);
    		EXTTareaNotificacion tarea = genericDao.get(EXTTareaNotificacion.class, filtroIdTarea);	
    		
    		Date fecha = null;
    		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    		try {
    			fecha = formatter.parse(nuevaFecha);
			} catch (ParseException e) {
			}   
    		tarea.setFechaVencReal(fecha);
    		tareaDao.saveOrUpdate(tarea);
    		
    		//Cambiarlo también en el REGISTRO
    		MEJRegistro registro = (MEJRegistro) proxyFactory.proxy(MEJRegistroApi.class).get(idTraza);
    		for (ClaveValor cv : registro.getInfoRegistro()){
    			if (cv.getClave().equals(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_VENCIMIENTO_TAREA)) {
    				MEJInfoRegistro cvInfo = (MEJInfoRegistro)cv;
    				Filter filtroIdRegistro=genericDao.createFilter(FilterType.EQUALS, "id", cvInfo.getId());
    				MEJInfoRegistro registroInfo = genericDao.get(MEJInfoRegistro.class, filtroIdRegistro);
    				registroInfo.setValor("" + fecha.getTime());
    				genericDao.save(MEJInfoRegistro.class, registroInfo);
    			}
    		}    		
    	}
	}
	
	
	
	
	@Override
	public HashMap<String, String> validateNotifPostRequestData(NotificacionDto notificacionDto, Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = null;

		hashErrores = restApi.validateRequestObject(notificacionDto ,TIPO_VALIDACION.INSERT);

		if (!Checks.esNulo(notificacionDto.getIdActivoHaya())) {
			Activo activo = (Activo) genericDao.get(Activo.class,
					genericDao.createFilter(FilterType.EQUALS, "numActivo", notificacionDto.getIdActivoHaya()));
			if (Checks.esNulo(activo)) {
				hashErrores.put("idActivoHaya", RestApi.REST_MSG_UNKNOWN_KEY);
			}else{
				Usuario gestor = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
				if (Checks.esNulo(gestor)) {
					hashErrores.put("idActivoHaya", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}

		return hashErrores;
	}


	
}

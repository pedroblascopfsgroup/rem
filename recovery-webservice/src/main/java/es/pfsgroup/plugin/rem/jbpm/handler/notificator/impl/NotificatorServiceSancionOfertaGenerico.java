package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

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
import org.springframework.aop.interceptor.PerformanceMonitorInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.utils.FileItemUtils;

public abstract class NotificatorServiceSancionOfertaGenerico extends AbstractNotificatorService implements NotificatorService {
	
	private final Log logger = LogFactory.getLog(getClass());

	private static final String GESTOR_PRESCRIPTOR = "prescriptor";
	private static final String GESTOR_MEDIADOR = "mediador";
	private static final String GESTOR_COMERCIAL_ACTIVO = "gestor-comercial-activo";
	private static final String GESTOR_COMERCIAL_LOTE_RESTRINGIDO = "gestor-comercial-lote-restringido";
	private static final String GESTOR_COMERCIAL_LOTE_COMERCIAL = "gestor-comercial-lote-comercial";
	private static final String GESTOR_FORMALIZACION = "gestor-formalizacion";
	private static final String GESTOR_GESTORIA_FASE_3 = "gestoria-fase-3";
	
	@Resource
	private Properties appProperties;

	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Override
	public final void notificator(ActivoTramite tramite) {

	}

	protected void generaNotificacion(ActivoTramite tramite, boolean permieRechazar) {
		
		Activo activo = tramite.getActivo();
		Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());

		ActivoTramite tramiteSimulado = new ActivoTramite();
		tramiteSimulado.setActivo(activo);

		sendNotification(tramiteSimulado, permieRechazar, activo, oferta);
	}

	private void sendNotification(ActivoTramite tramite, boolean permiteRechazar, Activo activo, Oferta oferta) {

		if(!Checks.esNulo(oferta)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if(!Checks.esNulo(expediente) && DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())) { // APROVACIÓN
	
				ArrayList<String> destinatarios = getDestinatariosNotificacion(activo, oferta, expediente);

				if (destinatarios.isEmpty()) {
					logger.warn("No se han encontrado destinatarios para la notificación. No se va a enviar la notificación [oferta.id=" + oferta.getId() + "]");
					return;
				}

				this.enviaNotificacionAceptar(tramite, oferta, expediente.getReserva() != null ? expediente.getId() : null, destinatarios.toArray(new String[]{}));

			} else if (permiteRechazar && DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) { // RECHAZO
				String prescriptor = getPrescriptor(activo, oferta);

				if (Checks.esNulo(prescriptor)) {
					logger.warn("No se ha encontrado el prescriptor. No se va a mandar la notificación [oferta.id=" + oferta.getId() + "]");
					return;
				}

				this.enviaNotificacionRechazar(tramite, activo, oferta, prescriptor);
			}
		}
	}

	protected void generaNotificacionSinTramite(Long idOferta) {

		Oferta oferta = ofertaApi.getOfertaById(idOferta);
		Activo activo = oferta.getActivoPrincipal(); 

		// ya que se trata de una notificacion sin tramite simulamos uno para cumplir con la definicion de los metodos comunes 
		// ya que la idea es que se genere exactamente la misma notificacion como si viniera de un tramite
		ActivoTramite tramiteSimulado = new ActivoTramite();
		tramiteSimulado.setActivo(activo);

		sendNotification(tramiteSimulado, true, activo, oferta);
	}

	private String getPrescriptor(Activo activo, Oferta ofertaAceptada) {
		Map<String, String> gestores = getGestores(activo, ofertaAceptada, null, null, GESTOR_PRESCRIPTOR);
		return gestores.get(GESTOR_PRESCRIPTOR);
	}


	private String[] getGestoresANotificar(Activo activo, Oferta ofertaAceptada) {
		boolean formalizacion = checkFormalizar(activo.getId());
		String[] clavesGestores = null;
		String claveGestorComercial = this.getTipoGestorComercial(ofertaAceptada);
		
		if (formalizacion) {
			
			clavesGestores = new String[]{
					GESTOR_FORMALIZACION, GESTOR_GESTORIA_FASE_3, GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial
			};
		} else {
			clavesGestores = new String[] {
					GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial
			};
		}
		return clavesGestores;
	}


	private ArrayList<String> getDestinatariosNotificacion(Activo activo, Oferta ofertaAceptada,
			ExpedienteComercial expediente) {
		String[] clavesGestores = getGestoresANotificar(activo, ofertaAceptada);
		Map<String, String> gestores = getGestores(activo, ofertaAceptada, this.getLoteComercial(ofertaAceptada), expediente, clavesGestores);
		ArrayList<String> destinatarios = new ArrayList<String>();
		for (String clave : clavesGestores){
			String value = gestores.get(clave);
			if ((value != null) && (!destinatarios.contains(value))) {
				destinatarios.add(value);
			}
		}
		return destinatarios;
	}

	private ActivoLoteComercial getLoteComercial(Oferta oferta) {
		if ((oferta != null) && (oferta.getAgrupacion() != null)){
			return genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
		} else {
			return null;
		}
	}

	private String getTipoGestorComercial(Oferta oferta) {
		if (oferta != null) {
			if (Checks.esNulo(oferta.getAgrupacion())) {
				return GESTOR_COMERCIAL_ACTIVO;
			} else {
				DDTipoAgrupacion tipo =oferta.getAgrupacion().getTipoAgrupacion();
				if (tipo == null) {
					throw new IllegalStateException("La agrupación no tiene tipo [" + oferta.getAgrupacion().getClass().getSimpleName() + ", id=" + oferta.getAgrupacion().getId() + "]");
				}
				if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(tipo.getCodigo())) {
					return GESTOR_COMERCIAL_LOTE_RESTRINGIDO;
				} else if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(tipo.getCodigo())) {
					return GESTOR_COMERCIAL_LOTE_COMERCIAL;
				} else {
					return null;
				}
			}
		} else {
			return null;
		}
	}

	private boolean checkFormalizar(Long id) {
		if (id == null) {
			throw new IllegalArgumentException("'id' no puede ser NULL");
		}
		
		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(id);
		if (perimetro != null) {
			Integer check = perimetro.getAplicaFormalizar();
			return (check != null) && (check == 1);
		} else {
			return false;
		}
	}

	private Map<String, String> getGestores(Activo activo, Oferta oferta, ActivoLoteComercial loteComercial, ExpedienteComercial expediente, String ...filtroGestores) {
		String [] claves = filtroGestores != null ? filtroGestores : new String[] {
				GESTOR_PRESCRIPTOR, 
				GESTOR_MEDIADOR, 
				GESTOR_COMERCIAL_ACTIVO,
				GESTOR_COMERCIAL_LOTE_RESTRINGIDO,
				GESTOR_COMERCIAL_LOTE_COMERCIAL,
				GESTOR_FORMALIZACION,
				GESTOR_GESTORIA_FASE_3
				};
		this.compruebaRequisitos(activo, oferta, loteComercial, expediente, Arrays.asList(claves));
		
		HashMap<String, String> gestores = new HashMap<String, String>();
		
		for (String s : claves) {
			if (GESTOR_PRESCRIPTOR.equals(s)) {
				gestores.put(s, extractEmail(ofertaApi.getUsuarioPreescriptor(oferta)));
			} else if (GESTOR_MEDIADOR.equals(s)) {
				gestores.put(s, extractEmail(activoApi.getUsuarioMediador(activo)));
			} else if (GESTOR_COMERCIAL_ACTIVO.equals(s) || GESTOR_COMERCIAL_LOTE_RESTRINGIDO.equals(s)) {
				gestores.put(s, extractEmail(gestorActivoApi.getGestorByActivoYTipo(activo, "GCOM")));
			} else if (GESTOR_COMERCIAL_LOTE_COMERCIAL.equals(s)) {
				gestores.put(s, extractEmail(loteComercial.getUsuarioGestorComercial()));
			} else if (GESTOR_FORMALIZACION.equals(s) || GESTOR_GESTORIA_FASE_3.equals(s)) {
				gestores.put(s, extractEmail(gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GFORM")));
			}
		}
		
		return gestores;
	}
	
	private String extractEmail(Usuario u) {
		if (u != null) {
			return u.getEmail();
		} else {
			return null;
		}
	}
	
	private void compruebaRequisitos(Activo activo, Oferta oferta, ActivoLoteComercial loteComercial, ExpedienteComercial expediente, List<String> claves) {
		if (claves != null) {
			if ((activo == null) && (claves.contains(GESTOR_COMERCIAL_ACTIVO) || claves.contains(GESTOR_COMERCIAL_LOTE_RESTRINGIDO) || claves.contains(GESTOR_MEDIADOR))) {
				throw new IllegalStateException("Se necesita un Activo para obtener alguno de los gestores: " + claves.toString());
			}
			
			if (oferta == null && claves.contains(GESTOR_PRESCRIPTOR)) {
				throw new IllegalStateException("Se necesita una Oferta para obtener alguno de los gestores: " + claves.toString());
			}
			
			if (loteComercial == null && claves.contains(GESTOR_COMERCIAL_LOTE_COMERCIAL)) {
				throw new IllegalStateException("Se necesita un ActivoLoteComercial para obtener alguno de los gestores: " + claves.toString());
			}
			
			if ((expediente == null) && (claves.contains(GESTOR_FORMALIZACION) || claves.contains(GESTOR_GESTORIA_FASE_3))) {
				throw new IllegalStateException("Se necesita un ExpedienteComercial para obtener alguno de los gestores: " + claves.toString());
			}
		}
	}

	private void enviaNotificacionAceptar(ActivoTramite tramite, Oferta oferta, Long idExpediente, String ...destinatarios) {
		String asunto = "Notificación de aprobación provisional de la oferta " + oferta.getNumOferta();
		String cuerpo = "<p>Nos complace comunicarle que la oferta " + oferta.getNumOferta() + " ha sido PROVISIONALMENTE ACEPTADA. Adjunto a este correo encontrará el documento con las instrucciones a seguir para la formalización de la reserva.</p>";

		if (idExpediente != null) {
			String reservationKey = String.valueOf(idExpediente).concat(appProperties.getProperty("haya.reservation.pwd"));
			String reservationUrl = appProperties.getProperty("haya.reservation.url");
			cuerpo = cuerpo + "<p>Pinche <a href=\""+reservationUrl + idExpediente +"/"+reservationKey+"/1\">aquí</a> para la descarga del contrato de reserva.</p>";
		}

		
		cuerpo = cuerpo + "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

		Usuario gestorComercial = null;
		
		if (!Checks.esNulo(oferta.getAgrupacion()) 
		        && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion())
		        && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {

			ActivoLoteComercial activoLoteComercial = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			gestorComercial = activoLoteComercial.getUsuarioGestorComercial();

		} else {
		    gestorComercial = gestorActivoManager.getGestorByActivoYTipo(tramite.getActivo(), "GCOM");
		}

		cuerpo = cuerpo + String.format("<p>Gestor comercial: %s </p>", gestorComercial.getApellidoNombre());
		cuerpo = cuerpo + String.format("<p>%s</p>", gestorComercial.getEmail());

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		enviaNotificacionGenerico(asunto, cuerpoCorreo, true, destinatarios);
	}
	
	private void enviaNotificacionRechazar(ActivoTramite tramite, Activo activo, Oferta oferta, String ...destinatarios) {
		String numAgrupacion  = "";
		if (oferta.getAgrupacion() != null) {
			numAgrupacion = " / #" + oferta.getAgrupacion().getNumAgrupRem();
		}
		String asunto = "Notificación de rechazo de oferta " + oferta.getNumOferta();
		String cuerpo = "La oferta #" + oferta.getNumOferta() + " presentada por el activo #" + activo.getNumActivo() + numAgrupacion + " ha sido rechazada.";

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		enviaNotificacionGenerico(asunto, cuerpoCorreo, false, destinatarios);
	}
	

	private void enviaNotificacionGenerico(String asunto, String cuerpoCorreo, boolean adjuntaInstrucciones,
			String... destinatarios) {
		if (Checks.esNulo(destinatarios)) {
			throw new IllegalArgumentException("Es necesario especificar el destinatario de la notificación.");
		}
		List<String> mailsCC = new ArrayList<String>();

		DtoAdjuntoMail adjMail = new DtoAdjuntoMail();
		FileItem fileitem = FileItemUtils.fromResource("docs/correo_sancion_oferta.docx");
		try {
			List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
			
			if (adjuntaInstrucciones) {
				Adjunto adjunto = new Adjunto(fileitem);
				adjMail.setAdjunto(adjunto);
				adjMail.setNombre("Instrucciones de la reserva.docx");
				adjuntos.add(adjMail);
			}
			genericAdapter.sendMail(Arrays.asList(destinatarios), mailsCC,
					asunto,
					cuerpoCorreo,
					adjuntos);
		} finally {
			if ((fileitem != null) && (fileitem.getFile() != null)) {
				boolean deleted = fileitem.getFile().delete();
				if (! deleted) {
					logger.warn("No se ha borrado el fichero: " + fileitem.getFile().getAbsolutePath() + ". Se ha quedado basurilla.");
				}
			}
		}
	}

}

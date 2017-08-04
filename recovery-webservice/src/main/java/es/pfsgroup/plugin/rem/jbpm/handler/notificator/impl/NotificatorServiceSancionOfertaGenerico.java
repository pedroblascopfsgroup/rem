package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.aop.interceptor.PerformanceMonitorInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
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
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
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


	@Override
	public final void notificator(ActivoTramite tramite) {

	}
	
	
	public final void pruebaEnvioNotificacion (String destinatario){
		ActivoTramite tramite = new ActivoTramite();
		
		Activo activo = new Activo();
		activo.setNumActivo(1234L);
		NMBBien bien = new NMBBien();
		bien.setLocalizaciones(Arrays.asList(new NMBLocalizacionesBien()));
		activo.setBien(bien);
		tramite.setActivo(activo);
		
		
		Trabajo trabajo = new Trabajo();
		DDSubtipoTrabajo subtipoTrabajo = new DDSubtipoTrabajo();
		subtipoTrabajo.setDescripcion("Trabajo Fake");
		trabajo.setSubtipoTrabajo(subtipoTrabajo);
		trabajo.setNumTrabajo(1234567L);
		trabajo.setFechaTope(new Date());
		tramite.setTrabajo(trabajo);
		
		enviaNotificacionAceptar(tramite, 1L, destinatario);
		
		enviaNotificacionRechazar(tramite, destinatario);
	}
	

	protected void generaNotificacion(ActivoTramite tramite, boolean permieRechazar) {
		
		Activo activo = tramite.getActivo();
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());

		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if(DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())){ // APROVACIÓN
				
				boolean formalizacion = checkFormalizar(activo.getId());
				String[] clavesGestores = null;
				String claveGestorComercial = this.getTipoGestorComercial(ofertaAceptada);
				
				if (formalizacion) {
					clavesGestores = new String[] {
						GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial
					};
				} else {
					clavesGestores = new String[]{
						GESTOR_FORMALIZACION, GESTOR_GESTORIA_FASE_3, GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial
					};
				}
				
				Map<String, String> gestores = getGestores(activo, ofertaAceptada, this.getLoteComercial(ofertaAceptada), expediente, clavesGestores);
				ArrayList<String> destinatarios = new ArrayList<String>();
				for (String clave : clavesGestores){
					destinatarios.add(gestores.get(clave));
				}
				
				this.enviaNotificacionAceptar(tramite, expediente.getReserva() != null ? expediente.getId() : null, destinatarios.toArray(new String[]{}));
				
				
			} else if (permieRechazar && DDEstadoOferta.CODIGO_RECHAZADA.equals(ofertaAceptada.getEstadoOferta().getCodigo())) { // RECHAZO
				Map<String, String> gestores = getGestores(activo, ofertaAceptada, null, null, GESTOR_PRESCRIPTOR);
				this.enviaNotificacionRechazar(tramite, gestores.get(GESTOR_PRESCRIPTOR));
			}
		}
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
		List<PerimetroActivo> perimetros = genericDao.getList(PerimetroActivo.class,  genericDao.createFilter(FilterType.EQUALS, "activo.id", id));
		
		if (Checks.estaVacio(perimetros)) {
			throw new IllegalStateException("Activo sin perímetro [activo.id=" + id + "]");
		}
		
		Integer check = perimetros.get(0).getAplicaFormalizar();
		return (check != null) && (check == 1);
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
				ofertaApi.getUsuarioPreescriptor(oferta);
			} else if (GESTOR_MEDIADOR.equals(s)) {
				activoApi.getUsuarioMediador(activo);
			} else if (GESTOR_COMERCIAL_ACTIVO.equals(s) || GESTOR_COMERCIAL_LOTE_RESTRINGIDO.equals(s)) {
				gestores.put(s, gestorActivoApi.getGestorByActivoYTipo(activo, "GCOM").getEmail());
			} else if (GESTOR_COMERCIAL_LOTE_COMERCIAL.equals(s)) {
				gestores.put(s, loteComercial.getUsuarioGestorComercial().getEmail());
			} else if (GESTOR_FORMALIZACION.equals(s) || GESTOR_GESTORIA_FASE_3.equals(s)) {
				gestores.put(s, gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GFORM").getEmail());
			}
		}
		
		return gestores;
	}
	
	private void compruebaRequisitos(Activo activo, Oferta oferta, ActivoLoteComercial loteComercial, ExpedienteComercial expediente, List<String> claves) {
		if (claves != null) {
			if (activo == null) {
				if (claves.contains(GESTOR_COMERCIAL_ACTIVO) || claves.contains(GESTOR_COMERCIAL_LOTE_RESTRINGIDO) || claves.contains(GESTOR_MEDIADOR)) {
					throw new IllegalStateException("Se necesita un Activo para obtener alguno de los gestores: " + claves.toString());
				}
			}
			
			if (oferta == null && claves.contains(GESTOR_PRESCRIPTOR)) {
				throw new IllegalStateException("Se necesita una Oferta para obtener alguno de los gestores: " + claves.toString());
			}
			
			if (loteComercial == null && claves.contains(GESTOR_COMERCIAL_LOTE_COMERCIAL)) {
				throw new IllegalStateException("Se necesita un ActivoLoteComercial para obtener alguno de los gestores: " + claves.toString());
			}
			
			if (expediente == null) {
				if (claves.contains(GESTOR_FORMALIZACION) || claves.contains(GESTOR_GESTORIA_FASE_3)) {
					throw new IllegalStateException("Se necesita un ExpedienteComercial para obtener alguno de los gestores: " + claves.toString());
				}
			}
		}
	}

	private void enviaNotificacionAceptar(ActivoTramite tramite, Long idExpediente, String ...destinatarios) {
		String asunto = "Aceptación Provisional de la Oferta y Formalización de la Reserva de la Oferta";
		String cuerpo = "<p>Nos complace informarles que la oferta #nºoferta, que se detalla en los documentos adjuntos, ha sido PROVISIONALMENTE ACEPTADA. Siga las instrucciones indicadas.</p>";
		if (idExpediente != null) {
			cuerpo = cuerpo + "<p>Puede descargar la reserva desde <a href=\"https://ws.haya.es/test-word/reservation/" + idExpediente + "/1\">aquí</a></p>";
		}
		String cuerpoCorreo = this.generateCuerpo(this.rellenaDtoSendNotificator(tramite), cuerpo);
		enviaNotificacionGenerico(asunto, cuerpoCorreo, true, destinatarios);
	}
	
	private void enviaNotificacionRechazar(ActivoTramite tramite, String ...destinatarios) {
		String asunto = "Rechazo de la oferta";
		String cuerpo = "La oferta #Número_oferta presentada por el activo #Número_activo / #Número_agrupación ha sido rechazada.";
		String cuerpoCorreo = this.generateCuerpo(this.rellenaDtoSendNotificator(tramite), cuerpo);
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
				fileitem.getFile().delete();
			}
		}
	}
	
	
	private String getUrlImagenes(){
		String url = appProperties.getProperty("url");
		
		return url+"/pfs/js/plugin/rem/resources/images/notificator/";
	}
	
//	protected String generateCuerpo(String titulo, String contenido, Long idReserva) {
//		StringBuilder cuerpo = new StringBuilder("<html>"
//				+ "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
//				+ "<html>"
//				+ "<head>"
//				+ "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>"
//				+ "</head>"
//				+ "<body>"
//				+ "	<div>"
//				+ "		<div style='font-family: Arial,&amp; amp;'>"
//				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 100%; min-height: 60px; display: table'>"
//				+ "				<img src='"+this.getUrlImagenes()+"ico_notificacion.png' "
//				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
//				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'>" + titulo + "</div>"
//				+ "			</div>"			
//				+ "			<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
//				+ "              <p>"
//				+ 					contenido
//				+ "              </p>");
//		if (idReserva != null) {
//			cuerpo.append("      <p>"
//				+ "                Puede descargar la reserva desde <a href=\"https://ws.haya.es/test-word/reservation/" + idReserva + "/1\">aquí</a>"
//				+ "              </p>");
//		}
//		cuerpo.append("     </div>"
//				+ "			<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
//				+ "					<div style='display: table-cell'>"
//				+ "						<img src='"+this.getUrlImagenes()+"ico_advertencia.png' />"
//				+ "					</div>"			
//				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
//				+ "						Este mensaje es una notificación automática. No responda a este correo.</div>"
//				+ "				</div>"
//				+ "			</div>"
//				+ "		</div>"
//				+ "</body>"
//				+ "</html>");
//		
//		return cuerpo.toString();
//	}
	
	
	
	
//	public static void main(String[] args) throws NoSuchAlgorithmException, KeyManagementException {
//		
//		
//		
//		HttpClientFacade facade = new HttpClientFacade();
//		try {
//			Object o = facade.processRequestToString("https://ws.haya.es/test-word/reservation/1/word/", "GET", null, "{}", 10, "UTF-8");
//			//Object o = facade.processRequestToJSON("http://www.mocky.io/v2/59805c2d110000c9091cf99d", "GET", null, "{}", 10, "UTF-8");
//			
//			if (o != null) {
//				System.out.println(o.getClass() + " -> " + o.toString());
//			}
//		} catch (HttpClientException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}

}
